# Lab2 实验报告

## 0. 个人信息
- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习2.1 实现 first-fit 连续物理内存分配算法

1. **流程说明**
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
2. **原理与实现**
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

        修改后，寻找位置并插入空闲块的代码如下：
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
    5. 完成这一步后，可以看到如下结果，可见`check_alloc_page()`已经成功：
        ```gdb
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
3. **回答问题** ：你的first fit算法是否有进一步的改进空间？
    > 的确存在进一步改进空间，主要在于以下方面：
    > 1. 在`default_alloc_pages`方法中，对于分割块的操作，先删除了块的链表节点，之后若块大于需求，则分割，并将新块作为节点插入原块的位置。这里，事实上大多数情况下会发生分割操作，更节省开销的方法是直接将原块的前后节点指向新节点，同时添加新节点的指向，而不是像现在先删除再插入；但考虑到已经封装好的链表方法，直接调用已有方法封装性更好，减少出错可能，不过开销稍大
    > 2. 在`default_free_pages`方法中，先拓展块，再遍历链表寻找插入位置。事实上在拓展块的同时，就已经可以得到拓展后块的前/后一个节点，如果能利用这一信息，可以省去寻找位置时的遍历
    > 3. 同样在`default_free_pages`方法中，在拓展块时，考虑到如果一直使用这种拓展方法，链表中的已有块之间一定已经不能互相合并，那么在对空闲块的前、后至多各一次拓展后就已经不可能再发生其他合并，那么可以提前结束遍历。同时，在遍历时当前块地址大于空闲块地址时不可能继续向前拓展，当前块地址小于空闲块地址时不可能向后拓展（因为正常情况下块之间不可能发生重叠），这样也可以提前结束循环。
    > 4. 对于上述第3点，较简单的方法是，在遍历中直接找到第一个地址大于当前空闲块的已有块，这一定是唯一可能的向后拓展块，再取这个块的前一个块，这也一定是唯一可能的向前拓展块，同时这也确定了合并后块的插入位置。尝试将这两个块合并入待插入的空闲块，最后将合并后的空闲块插入已经确定的位置即可。

### 练习2.2 实现寻找虚拟地址对应的页表项

1. **原理简述**
    1. 关于地址
        - 在完成first-fit物理内存分配算法后，若尝试`make qemu`，会显示在`check_pgdir`检查页目录表时出现关于`get_pte`的assertion failure，对应于本练习中对页表/页目录表的完善
        - 在这一阶段中，段机制生效，各段base置为`-KERNBASE`即-0xC0000000，存在虚拟地址/线性地址/物理地址的差异，其关系为`virtual addr - 0xC0000000 = linear addr = physical addr`. 值得注意的是，此时代码中也做了相应区分，`pte_t`和`pdt_t`均为虚拟地址，一切可以做`*`运算的指针和函数形参中的指针类型均为虚拟地址；`uintptr_t`表示线性地址，也即此时的物理地址。虚拟地址和线性地址之间的相互转换可以简单地用Macro进行运算得到
        - 另外需要考虑对Page类型到地址的转换。这一转换的核心是ppn，即physical page number，这一值由`page - pages`算得，其中pages为内存中已经分配的管理所有物理页信息的Page的数组（长度等于物理页数量），page为待求物理页对应的pages数组中的元素的指针（可能由alloc_page分配得到），其差值即为待求物理页的编号即ppn，再将物理页编号 ppn << PAGE_SIZE(12) 即得到物理地址，由此可以进一步将Page和线性地址和虚拟地址相联系
        - 在实际代码执行过程中，虚拟地址到线性地址的转换由GDT隐式完成，传递给页表的地址均为线性地址，页表给出的地址为物理地址
    2. 关于页目录表/页表
        - 首先需要注意到地址的区别。在页目录的表项中包含的地址均为物理地址，而页表项中包含的地址也为物理地址
        - 启动过程中，页目录表为一个page大小，其虚拟地址保存在`boot_pgdir`中。其中每一个表项长为1 byte，含有二级页表的基址（物理地址），每个二级页表也为一个page大小，含有其指向的物理页地址。页表和页目录表都是4k对齐的
        - 获取线性地址对应页表项的方法是将线性地址分为三部分：PDX, PTX, OFFSET，使用PDX在页目录表中找到对应PDE，再从PDE中取出其高20位，即为二级页表的基址（物理地址），进一步通过PTX在二级页表中找到对应的页表项，将其地址转换为虚地址即可
2. **实现方法**
    - 根据框架注释中已经给出的模式，实现如下：
        1. 获取页目录项pde，方法为通过`PDX`宏得到页目录项号，再将页目录指针（指向页目录的首项）加上这个编号即得到指向目的页目录项的指针，代码如下：
            ```c
            // (1) find page directory entry
            size_t pdx = PDX(la);       // index of this la in page dir table
            pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
            ```
        2. 检查页目录项，若显示对应的二级页表不存在（`*pdep & PTE_P`不为真），且在传入参数中指定了如不存在则新建，那么新建二级页表（若不需要新建，则直接返回NULL），方法为申请一个物理页，将其清零，并将该物理页的物理地址作为二级页表地址写入pde中，同时写入的还有权限控制，写入方法为直接取它们的按位或即可。代码如下：
            ```c
            // (2) check if entry is not present
            if (!(*pdep & PTE_P)) {
                // (3) check if creating is needed
                if (!create) {
                    return NULL;
                }
                // alloc page for page table
                struct Page * pt_page =  alloc_page();
                if (pt_page == NULL) {
                    return NULL;
                }

                // (4) set page reference
                set_page_ref(pt_page, 1);

                // (5) get linear address of page
                uintptr_t pt_addr = page2pa(pt_page);

                // (6) clear page content using memset
                memset(KADDR(pt_addr), 0, PGSIZE);

                // (7) set page directory entry's permission
                *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
            }
            ```
        3. 返回所求的pte，方法为先由`PTX`宏得到二级页表中页表项的编号，再获取二级页表的地址（虚拟地址），将指向该二级页表的指针加上页表项编号即为指向该页表项的指针，实现如下：
            ```c
            // (8) return page table entry
            size_t ptx = PTX(la);   // index of this la in page dir table
            uintptr_t pt_pa = PDE_ADDR(*pdep);
            pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
            return ptep;
            ```
    - 完成后，运行`make qemu`可以看到如下结果，可见通过了`get_pte`的检查，问题转移到了对page_ref即物理页引用计数的检查上，这涉及到下一个练习
        ```gdb
            check_alloc_page() succeeded!
            kernel panic at kern/mm/pmm.c:545:
                assertion failed: page_ref(p2) == 0
            Welcome to the kernel debug monitor!!
            Type 'help' for a list of commands.
        ```
3. **回答问题**
    - 请描述页目录项（Pag Director Entry）和页表（Page Table Entry）中每个组成部分的含义和以及对ucore而言的潜在用处
        > - PDE：高20位表示二级页表基址的高20位；第3位为PTE_U，置1表示用户可以访问；第2位为PTE_W，置1表示该二级页表中各页可写；第1位为PTE_P，置1表示二级页表存在
        > - PTE：高20位表示物理页基址的高20位；第3位为PTE_U，置1表示用户可以访问；第2位为PTE_W，置1表示该页可写；第1位为PTE_P，置1表示该物理页存在于内存中
        > - 潜在用处：各控制位均有潜在用处，PTE_U用于对不同内存的权限控制，保护核心代码和数据；PTE_W可以用于实现只读内存空间；对于页目录表，PTE_P可以使未用到的二级页表不必存在于内存中，减少空间开销，对于二级页表，PTE_P可以支持虚拟存储技术，允许部分页被替换到外存中，解决物理内存不足的问题。
    - 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？
        > 出现页访问异常时，如果在实现了虚拟存储情况下，若页不存在则触发`PAGE FAULT`异常，硬件要负责先检查异常编号，通过tss找到内核栈位置，保存现场（将eflags，eip，cs寄存器和错误码压栈，如果涉及特权级切换还需要将ss和esp寄存器压栈），然后转入对缺页异常的处理例程（软件部分）；软件处理结束后（可能分配物理页/将物理页从外存换入/什么也没做），再次交给硬件，硬件会再次尝试执行之前触发`PAGE FAULT`的指令

### 练习2.3 释放某虚地址所在的页并取消对应二级页表项的映射

1. **原理简述**
    - 在维护页表时，需要注意与pages数组的结合。对于每个进程都有一套页表，而且不同页表项可能指向同一物理页，这意味着一个物理页可能被若干个页表项引用，因此对于pages管理的每一个物理页，都有一个“**引用计数**”
        - 在插入新页表项时，相当于将这个页表项对应的虚地址指向一个物理页，要增加物理页引用计数
        - 释放一个虚地址时，对应物理页的引用计数需要减一，此时如果引用计数归零，则此物理页也被释放
    - 此外，任何时候如果更新了页表，需要在TLB中将相应虚地址对应条目置为“invalid”，以保证TLB和页表的一致性
2. **实现方法**
    1. 首先检查该虚地址对应的页表项是否存在，若不存在则直接返回，若存在则得到该页表项对应的物理页Page，即
        ```c
        //(1) check if this page table entry is present
        if (!(*ptep & PTE_P)) {
            return;
        }
        //(2) find corresponding page to pte
        struct Page *page = pte2page(*ptep);
        ```
    2. 将该物理页引用计数减一，当引用计数减为零时，释放该物理页，即
        ```c
        //(3) decrease page reference
        page_ref_dec(page);

        //(4) and free this page when page reference reachs 0
        if (page->ref == 0) {
            free_page(page);
        }
        ```
    3. 清理该页表项，同时在TLB中将该虚地址对应的项置为“invalid”
        ```c
        //(5) clear second page table entry
        *ptep = 0;

        //(6) flush tlb
        tlb_invalidate(pgdir, la);
        ```
    4. 实现后执行`make qemu`效果如下，可见已经顺利地建立了页表，并开启了段页式内存管理机制，打印出了当前页表/页目录表内容，并且可以正常接收时钟中断：
    ```gdb
        (THU.CST) os is loading ...

        Special kernel symbols:
        entry  0xc010002a (phys)
        etext  0xc0105c11 (phys)
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
        ebp:0xc0116fd8 eip:0xc0100109 args:0x00000000 0x00000000 0x00000000 0xc0105c20
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
        check_pgdir() succeeded!
        check_boot_pgdir() succeeded!
        -------------------- BEGIN --------------------
        PDE(0e0) c0000000-f8000000 38000000 urw
        |-- PTE(38000) c0000000-f8000000 38000000 -rw
        PDE(001) fac00000-fb000000 00400000 -rw
        |-- PTE(000e0) faf00000-fafe0000 000e0000 urw
        |-- PTE(00001) fafeb000-fafec000 00001000 -rw
        --------------------- END ---------------------
        ++ setup timer interrupts
        100 ticks
        100 ticks
    ```
3. **回答问题**
    - 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？
        > - 正如前文多次提到的，Page结构的pages数组用于管理实际物理页，每个元素对应于一个物理页，由于物理页与页表/页目录表的对应关系，pages项与页表项/页目录表项也存在对应关系
        > - 这种关系同物理页和页表项的关系一样，也是一对多的关系，每个pages中的项对应于一个物理页（编号也是一一对应，即第i个pages项对应于第i个物理页），也就对应于所有引用该物理页的页表项，由此也对应到了包含该页表项的二级页表对应的页目录表项
        > - 从数值关系来讲，假设某一虚拟地址已经分配了物理页，则其高10位对应一页目录项，该项高20位左移12位得到二级页表基址，虚拟地址的下一个10位为二级页表中页表项编号，这一页表项高20位左移12位为物理页地址，这一地址右移12位（相当于直接取出页表项高20位）即得到该物理页编号ppn，这也是该物理页对应的pages项的下标，可以直接用pages[ppn]得到该项
        > - 事实上，前述流程可以直接用`struct Page * pte2page(pte_t pte)`函数实现
    - 如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？
        > - 在实现分页机制后，虚拟地址/线性地址/物理地址关系为`virtual addr = linear addr = physical addr + 0xC0000000`，这里0xC0000000即`KERNBASE`，这种对应关系是在`pmm_init`中通过调用`boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W)`对页表进行内存映射实现的，这将虚地址KERNBASE映射到了物理地址的0x0位置
        > - 因此，实现步骤如下：
        >   1. 改为`boot_map_segment(boot_pgdir, 0, KMEMSIZE, 0, PTE_W)`即可实现页表中虚拟地址等于物理地址的映射
        >   2. 但需要注意的是，事实上OS kernel仍然处于物理内存的0x0开始的空间，而gcc编译后的OS kernel中虚拟地址为0xC0000000开始的空间，在建立虚拟地址等于物理地址的映射后，必须解决OS kernel地址映射正确的问题，即将OS kernel所在的页表中的地址全部映射到物理地址0x0的页，这一实现需要将原有 ~~`boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)]`~~ 改为`boot_pgdir[PDX(KERNBASE)] = boot_pgdir[0]`. 当然，这样带来的问题是，boot_pgdir[0]中的虚拟地址将无法使用，否则会与kernel冲突，这算是这种实现方式下“虚拟地址=物理地址”的一个例外
        >   3. 此外需要去掉 ~~`boot_pgdir[0] = 0`~~ 的恢复操作，而且需要在`check_boot_pgdir(void)`中注释掉相应的 ~~`assert(boot_pgdir[0] == 0)`~~ 检查
        > - 完成上述步骤后即可执行`make qemu`运行，实现效果如下，可以看到页表项的变化：
        >    ```gdb
        >    memory management: default_pmm_manager
        >    e820map:
        >    memory: 0009fc00, [00000000, 0009fbff], type = 1.
        >    memory: 00000400, [0009fc00, 0009ffff], type = 2.
        >    memory: 00010000, [000f0000, 000fffff], type = 2.
        >    memory: 07ee0000, [00100000, 07fdffff], type = 1.
        >    memory: 00020000, [07fe0000, 07ffffff], type = 2.
        >    memory: 00040000, [fffc0000, ffffffff], type = 2.
        >    check_alloc_page() succeeded!
        >    check_pgdir() succeeded!
        >    check_boot_pgdir() succeeded!
        >    -------------------- BEGIN --------------------
        >    PDE(0df) 00400000-38000000 37c00000 urw
        >    |-- PTE(37c00) 00400000-38000000 37c00000 -rw
        >    PDE(001) c0000000-c0400000 00400000 urw
        >    |-- PTE(00400) c0000000-c0400000 00400000 -rw
        >    PDE(001) fac00000-fb000000 00400000 -rw
        >    |-- PTE(000df) fac01000-face0000 000df000 urw
        >    |-- PTE(00001) faf00000-faf01000 00001000 urw
        >    |-- PTE(00001) fafeb000-fafec000 00001000 -rw
        >    --------------------- END ---------------------
        >    ++ setup timer interrupts
        >    100 ticks
        >    ```

## 2. 标准答案对比

1. **练习1** ：
    - 在`default_alloc_pages`中，答案在分割块时的操作为先分割，再将剩余块插入被分配出去的块后，再删除被分配的块；而我的做法是先删除被分配的块（尚未分割），再分割，然后将剩余块插回原处。两种方法都是一次插入一次删除，开销应该不相上下
    - 在`default_free_pages`中，主要有两点区别：
        1. 答案在向前/向后拓展空闲块时，对于被合并的块未将其大小`p->property`清零，感觉应该不会有影响，但慎重起见我做了清零操作即`p->property = 0`或`base->property = 0`
        2. 在判断待插入位置时，我默认了块之间不会有重叠，但答案则更为谨慎地使用`assert(base + base->property != p)`确认这一点，这方面答案考虑更为周全，避免了可能的隐患
2. **练习2** ：
    - 在`get_pte`中，主要有以下区别：
        1. 答案在获取页目录项指针时，直接使用了下标访问数组元素的方法，`pde_t *pdep = &pgdir[PDX(la)]`这在C中是一种常用的方法，但对于没有学习过C直接学习C++的我来说一般不会想到这一方法。我使用的是指针类型变量 + 偏移量的方法，即`pde_t * pdep = pgdir + pdx`
        2. 在分配页给二级页表时，答案简洁地使用`if (!create || (page = alloc_page()) == NULL)`在判断的同时完成了分配，我则分成两步，稍显麻烦
        3. 在写入页目录项内容时，答案直接用`*pdep = pa | PTE_U | PTE_W | PTE_P`，没有对二级页表地址做处理，我则用`*pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P`只取了页表地址的高20位，虽然事实上答案的实现也没有问题，因为中间的位其实没有使用，但我的实现更多考虑了实际意义，并且避免了可能的拓展时的不一致性，但会增加一点开销
        4. 在返回页表项虚地址时，答案同样使用一行代码`return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]`完成，我用了三步操作：先计算PTX，再取页表物理地址，再将页表物理地址转换为虚拟地址（指针类型）并用指针加法取得页表项虚拟地址，即
            ```c
            size_t ptx = PTX(la);   // index of this la in page dir table
            uintptr_t pt_pa = PDE_ADDR(*pdep);
            pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
            return ptep;
            ```
3. **练习3** ：
    - 在`page_remove_pte`中，由于函数本身比较简单，我与答案实现相差不多，主要在于对物理页page的引用计数是否归零的判断上，答案一如既往使用了简洁的在引用计数减一的同时判断结果是否为零的方法即`if (page_ref_dec(page) == 0)`，我则还是拆成了两步实现。

## 3. 实验知识点分析

1. 连续内存管理：
    - 物理内存检测：这里在实验框架中直接实现，不需要我们修改，这一点在OS原理中没有深入涉及
    - 物理内存按页管理：实验中使用了Page结构体的数组pages作为对实际物理内存页帧的映射，从而实现了对物理内存的管理，这一方法在OS原理中没有涉及到，但在实现上却是一个非常巧妙的方案
    - 双向链表管理空闲块：实验中使用一个双向链表管理所有空闲内存块，方便连续内存的各种操作，这在OS原理中没有对应的内容
    - First Fit分配算法的实现：对应于OS原理中连续内存的分配算法，实验中仅以FFMA算法为例，涉及到了连续物理内存的管理、分配和释放
    - 借用面向对象思想，将物理内存管理抽象出physical memory manager（ppm），提供了一系列接口，这也方便了实现各种不同的连续内存管理方法（如FFMA，buddy system等），这在OS原理中没有对应内容
2. 页目录表/页表的建立
    - 页目录的分配和填充：在已有的连续内存管理基础上直接分配一页给页目录，清零后通过填充各页目录项进行初始化，对应于OS原理中页目录建立相关内容
    - 页表的建立和页表项获取：页表不会主动建立，而是在需要进行虚实地址转换时，当发现需要的页目录不存在时才建立，并填充需要的页表项，对应于OS原理中段页式内存管理机制的原理、根据虚地址如何找到对应的页目录项、页表项，进而获取物理地址
    - 页表项的维护：包括页表项的添加和删除，不仅要直接操作页表本身，还要涉及到pages数组中对物理页引用情况的维护，这两点的具体实现在OS原理中都没有过多展开，不过在“内存共享”相关内容中稍有提及
    - 页表自映射：为了方便程序员了解页表本身的情况，首先巧妙地规定一个不可能用到的虚拟地址`VTX`作为页表虚地址（其PDX == PTX），接着利用页表自映射的想法，将页目录表本身也当作一个页表，在其中建立指向自身物理地址的页目录项，就可以使用`VTX`直接访问页目录表的物理地址，这在OS原理中没有涉及，但可以说设计得非常巧妙
3. 段页式内存管理机制
    - 使能页机制：将页目录表物理地址写入%cr3，再将%cr0页机制相关位置位即可，在OS原理中有对应内容
    - μcore OS的段页式机制建立过程：经历了四个阶段，实模式，开启段机制、无页表，开启段机制、建立了页表，更新段机制、开启页机制，四个阶段有着各自不同的地址转换方式，这属于μcore实验本身的内容，在OS原理中没有过多涉及

## 4. 未对应知识点分析

1. 地址生成：这一点在实验内容中没有直接涉及到，相关内容在链接脚本中实现，实验指导书中也在附录有所讲解。当然，如果要实现练习3的问题2，即实现虚拟地址等于物理地址，则需要考虑地址生成问题，因为OS kernel的虚拟地址是在链接时指定的，但OS kernel装载到内存的物理地址是在elf中指定的，因而若要虚拟地址等于物理地址，在不改动链接方法的情况下需要为OS kernel开特例，即将其虚拟地址映射到物理地址上
2. 其他连续内存分配算法：如最佳匹配、最差匹配
3. 内存碎片整理：在实验中未涉及
4. 对TLB的软件管理：在实验中，只是调用给出的接口即可，关于其具体实现没有过多涉及
5. 反置页表等其他类型的页表实现方案