# Lab2 实验报告

## 0. 个人信息
- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习2.1 实现 first-fit 连续物理内存分配算法
1. 流程说明
    - 在迁移Lab 1实验内容到Lab 2后，若直接运行`make qemu`，则会触发assertion failure，提示信息如下，可以看出是在检查alloc_page()即连续内存分配算法时出现异常，说明这里是尚待完成的部分：
    ```gdb
        kernel panic at kern/mm/default_pmm.c:277:
        assertion failed: (p0 = alloc_page()) == p2 - 1
    ```
    - 在正式开始本练习前，我希望先理清程序是如何一步步执行到此处，共进行了哪些步骤，才到达了对算法的检查。通过跟踪，可以看出μcore在可以进行连续内存分配之前需要以下过程：
        1. 和Lab 1相同的BIOS启动，并调用bootloader
        2. bootloader直到开启A20 Gate时都与Lab 1相同，但在这之后，bootloader通过实模式下执行参数为e820h的BIOS `INT 15h`中断，实现了物理内存探测，具体过程如下：
            1. 将物理内存地址0x8000开始的空间作为物理内存信息存放处，在0x8000放置探测到的内存块数量，在随后的空间依次放置各内存块信息，对应于一个`e820map`结构体
            2. 先将0x8000清零，随后开始循环扫描物理内存，每次得到一条内存信息，BIOS会将信息写入%di指定的内存空间（每条记录20 bytes），接着%di值加20，0x8000值加1，再判断%ebx中的返回值，若为0则说明检查结束，否则继续循环
            3. 检查结束后，更新全局描述符表，并在%cr0置位PE，开启保护模式
        3. 开启保护模式后，建立第一个栈，栈基址%ebp为0，栈顶%esp为0x7c00，调用`bootmain`开始读取OS kernel映像到内存中
        4. 从kernel elf设置的entry开始执行OS kernel代码，不同于Lab 1，这里的入口变为`kern_entry`，在此重新更新gdt，将段的base设置为`- KERNBASE`，使用`ljmp`强制更新%cs，建立新的栈，栈基址%ebp为0，栈顶%esp为`$bootstacktop`，即专门用为栈开辟的一块大小为`KSTACKSIZE`的空间结束地址，调用`kern_init`开始由kernel执行初始化
        5. 在`kern_init`中初始化console后，就开始执行`pmm_init`，进行物理内存管理初始化
        6. 在`pmm_init`中，先设置物理内存管理器pmm_manager，这里借用了__面向对象__方法，抽象出一个pmm_manager，提供了需要的内存初始化、分配、释放等算法，而实现可以有多种方式，默认使用default_pmm_manager，之后执行的对物理内存的操作大多调用了pmm_manager的接口
        7. 设置pmm_manager后，进行页初始化`page_init`，其流程如下：
            1. 建立`struct e820map *memmap`，这一结构体指向对应于物理内存地址0x8000的空间，即boot过程中保存的物理内存扫描信息，并输出这些信息
            2. 根据上述信息得到物理内存最大地址`maxpa`，并算得物理页数量`npage = maxpa / PGSIZE`
            3. 可用页的起始地址为kernel代码的结束地址，即在链接时得到的`extern char end[]`，于是将物理页数组的起始地址`pages`定义为这一地址，该数组中元素为`Page`类型，用于对实际物理页的组织、管理，元素数量等于可用物理页数量
            4. 开始初始化物理页数组，先将物理页数组中对应于其**自身**存储位置的页置为“reserved”，即
                ```c
                for (i = 0; i < npage; i ++) {
                    SetPageReserved(pages + i);     // page + 1: next physical page table entry
                }
                ```
            5. 遍历memmap中之前扫描到的所有物理内存，将其中freemem（空闲内存的起始地址，即物理页数组结束的地址）之后、小于物理内存大小上限的部分依次建立内存映射，即调用`init_memmap`，这一方法指向pmm_manager中的同名方法
        8. 随后进行对物理内存alloc/free的检查，这就是前述assertion failed的位置
    - 本练习的关键，在于对default_pmm_manager中对于物理内存init/alloc/free方法的修改与完善，以实现first-fit物理内存分配算法
2. 原理与实现
    1. 关于pmm_manager，其定义如下所示，提供了若干接口以实现对连续物理内存的管理：
        ```c
        struct pmm_manager {
            const char *name;                                 // pmm_manager名称
            void (*init)(void);                               // pmm_manager自身初始化
            void (*init_memmap)(struct Page *base, size_t n); // 初始化page list
            struct Page *(*alloc_pages)(size_t n);            // 分配n个物理页
            void (*free_pages)(struct Page *base, size_t n);  // 释放从base开始的n个物理页
            size_t (*nr_free_pages)(void);                    // 获取当前空闲页数量
            void (*check)(void);                              // 检查分配/释放算法
        };
        ```
    2. 对于default_pmm_manager，其`init`和`init_memmap`方法其实不需要额外改动即可满足first-fit的要求；
        - 在`init`中初始化了管理free page的双向链表`free_list`，这一链表中各项对应一块连续物理内存，同时置free page数量为0
        - 在`init_memmap`中建立`free_list`链表项到物理页数组（也即到实际扫描到的物理内存）的映射关系：对于每一块连续的空闲物理空间，将其第一页对应的物理页数组`pages`中的元素设为“head page”，并在其中记录该块的页数量，最后将这个Page元素的`list_entry`插入`free_list`，也即将这个块作为链表节点插入链表中
        - 默认BIOS给出的物理内存扫描信息是顺序的（地址从小到大），因此通过遍历这些信息并依次建立memmap也是顺序的，所以认为`list_entry`中各节点对应物理内存块起始地址为从小到大的，满足first-fit要求
    3. 对于default_pmm_manager的`alloc_pages`方法，框架已经给出了其大体实现：
        1. 遍历`free_list`，找到第一个大小不小于需要的页数量的块
        2. 若这个块大于需要的数量，则对其分割，将前一部分分配出去，将剩下的部分插入回`free_list`

        但对块进行分割的操作还不能满足first-fit的要求，因为打乱了链表中块按地址升序排列的要求。因此我作出的修改为：
        1. 原框架分割块后未将新块的第一页设为“head page”，我补充了这一操作
        2. 原框架直接将新块插入到了链表头，我将这里修改为将新块插入之前取出的空闲块的下一块`following_le`的前面，即`list_add_before(following_le, &(p->page_link))`

        修改后，分割块并插回链表的代码如下，其中page为已找到的不小于需要数量的第一个块：
        ```c
        if (page != NULL) {
            list_entry_t *following_le = list_next(le);
            list_del(&(page->page_link));
            if (page->property > n) {
                struct Page *p = page + n;                      // split the allocated page
                p->property = page->property - n;               // set page num
                SetPageProperty(p);                             // mark as the head page
                list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
            }
            nr_free -= n;
            ClearPageProperty(page);    // mark as "not head page"
        }
        return page;
        ```
    4. 对于default_pmm_manager的`free_pages`方法，框架给出基本流程：设置被释放块的各种标记，向前、向后尝试合并相邻空闲块，将合并后的空闲块插回`free_list`. 对于原框架，要满足first-fit，需要以下修改：
        1. 框架中在尝试拓展空闲块时，对被合并的块只做了`ClearPageProperty`即清理“head page”标记的操作，但没有将其大小置为0，虽然直观上不会有影响，但为了一致性和消除可能的隐患，在此加入了将其property（即大小）清零的操作`p->property = 0;`
        2. 框架直接将空闲块插入到链表头，类似前述这破坏了链表节点的地址顺序性，因此改为遍历`free_pages`（链表本身的顺序性是保证的），在找到第一个地址大于空闲块基址`base`的块后/回到链表头中止，再将空闲块插入这个块（或链表头）的前面：`list_add_before(le, &(base->page_link))`，这样可以保证插入位置之前的所有节点地址均小于该空闲块

        修改后，寻找位置并插入空闲块的代码如下，可见`check_alloc_page()`已经成功：
        ```c
        // search for a place to add page into list
        le = list_next(&free_list);
        while (le != &free_list) {
            p = le2page(le, page_link);
            if (p > base) {
                break;
            }
            le = list_next(le);
        }
        nr_free += n;
        list_add_before(le, &(base->page_link));
        ```
    5. 完成这一步后，可以看到如下结果：
        ```gdb
        Special kernel symbols:
        entry  0xc010002a (phys)
        etext  0xc0105a37 (phys)
        edata  0xc0117a36 (phys)
        end    0xc01189c8 (phys)
        Kernel executable memory footprint: 99KB
        ebp:0xc0116f48 eip:0xc0100a5a args:0x00010094 0x00010094 0xc0116f78 0xc01000a9
            kern/debug/kdebug.c:312: print_stackframe+22
        ebp:0xc0116f58 eip:0xc0100d60 args:0x00000000 0x00000000 0x00000000 0xc0116fc8
            kern/debug/kmonitor.c:129: mon_backtrace+10
        ebp:0xc0116f78 eip:0xc01000a9 args:0x00000000 0xc0116fa0 0xffff0000 0xc0116fa4
            kern/init/init.c:49: grade_backtrace2+19
        ebp:0xc0116f98 eip:0xc01000cb args:0x00000000 0xffff0000 0xc0116fc4 0x00000029
            kern/init/init.c:54: grade_backtrace1+27
        ebp:0xc0116fb8 eip:0xc01000e8 args:0x00000000 0xc010002a 0xffff0000 0xc010006d
            kern/init/init.c:59: grade_backtrace0+19
        ebp:0xc0116fd8 eip:0xc0100109 args:0x00000000 0x00000000 0x00000000 0xc0105a40
            kern/init/init.c:64: grade_backtrace+26
        ebp:0xc0116ff8 eip:0xc010007a args:0x00000000 0x00000000 0x0000ffff 0x40cf9a00
            kern/init/init.c:29: kern_init+79
        memory management: default_pmm_manager
        e820map:
        memory: 0009fc00, [00000000, 0009fbff], type = 1.
        memory: 00000400, [0009fc00, 0009ffff], type = 2.
        memory: 00010000, [000f0000, 000fffff], type = 2.
        memory: 07ee0000, [00100000, 07fdffff], type = 1.
        memory: 00020000, [07fe0000, 07ffffff], type = 2.
        memory: 00040000, [fffc0000, ffffffff], type = 2.
        check_alloc_page() succeeded!
        ```
3. 回答问题：你的first fit算法是否有进一步的改进空间？
    > 的确存在进一步改进空间，主要在于以下方面：
    > 1. 在`default_alloc_pages`方法中，对于分割块的操作，先删除了块的链表节点，之后若块大于需求，则分割，并将新块作为节点插入原块的位置。这里，事实上大多数情况下会发生分割操作，更节省开销的方法是直接将原块的前后节点指向新节点，同时添加新节点的指向，而不是像现在先删除再插入；但考虑到已经封装好的链表方法，直接调用已有方法封装性更好，减少出错可能，不过开销稍大
    > 2. 在`default_free_pages`方法中，先拓展块，再遍历链表寻找插入位置。事实上在拓展块的同时，就已经可以得到拓展后块的前/后一个节点，如果能利用这一信息，可以省去寻找位置时的遍历
    > 3. 同样在`default_free_pages`方法中，在拓展块时，考虑到如果一直使用这种拓展方法，链表中的已有块之间一定已经不能互相合并，那么在对空闲块的前、后至多各一次拓展后就已经不可能再发生其他合并，那么可以提前结束遍历。同时，在遍历时当前块地址大于空闲块地址时不可能继续向前拓展，当前块地址小于空闲块地址时不可能向后拓展（因为正常情况下块之间不可能发生重叠），这样也可以提前结束循环。
    > 4. 对于上述第3点，较简单的方法是，在遍历中直接找到第一个地址大于当前空闲块的已有块，这一定是唯一可能的向后拓展块，再取这个块的前一个块，这也一定是唯一可能的向前拓展块，同时这也确定了合并后块的插入位置。尝试将这两个块合并入待插入的空闲块，最后将合并后的空闲块插入已经确定的位置即可。

### 练习2.2 实现寻找虚拟地址对应的页表项
- 一切地址转换的核心是ppn，即physical page number，这一值由`page - pages`算得，其中pages为内存中已经分配的管理所有物理页信息的Page的数组（长度等于物理页数量），page为待求物理页对应的pages数组中的元素的指针，其差值即为待求物理页的编号即ppn
- 得到实际物理地址的方法：将物理页编号 ppn << PAGE_SIZE(12) 即可
- 虚拟地址：类型为指向uintptr_t的指针，值为对应物理地址 PADDR + KERNEL_BASE(0xC0000000)


### 练习2.3 释放某虚地址所在的页并取消对应二级页表项的映射

### 练习2.x1 buddy system（伙伴系统）分配算法


## 2. 标准答案对比


## 3. 知识点分析

