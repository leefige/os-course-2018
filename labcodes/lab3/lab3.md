# Lab3 实验报告

## 0. 个人信息
- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习3.0 填写已有实验

#### 合并与变更说明
- 在迁移Lab 1和Lab 2实验内容到Lab 3后，若直接运行`make qemu`，则会出现提示信息如下，可以看出对Lab1~2的内容检查已经完成，并触发了page fault，证明移植成功：
```gdb
    ...
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
    check_vma_struct() succeeded!
    page fault at 0x00000100: K/W [no page found].
    page fault at 0x00000100: K/W [no page found].
    ...
```
- 在正式开始本练习前，同以往类似，我希望从boot开始理清OS启动和初始化的步骤。在lab 3中，通过检查init/entry.S文件，可以看到本lab中对启动分页机制的设置和lab 2有所不同，体现在：
    1. lab 2中，在汇编编写的entry.S中并没有启动分页机制，而是在段机制下运行，在调用C编写的kern_ini()后才进一步启动分页机制，页表和页目录表也是在C函数编写的程序中定义并填充的
    2. lab 3中，在entry.S中直接定义好了的页目录表和页表，并在kern_entry中直接将页目录表物理地址写入%cr3寄存器，即
        ```x86asm
            movl $REALLOC(__boot_pgdir), %eax
            movl %eax, %cr3
        ```
        需要注意的是，该页表中已经定义了`va 0 ~ 4M to pa 0 ~ 4M`和`va KERNBASE + (0 ~ 4M) to pa 0 ~ 4M`两种映射，其中前者为临时映射，作用与lab 2中相同
    3. 随后直接开启页机制，并且通过`jmp`指令强制更新%eip为KERNBASE开始的虚拟地址（之前虚拟地址等于线性地址，而且由于GDT中段基址为0，因此也等于物理地址），这一更新操作如下，其中next为下条指令地址：
        ```x86asm
            leal next, %eax
            jmp *%eax
        ```
    4. 在这之后，因为已经更新了%eip，因此取消临时映射，并建立调用栈调用kern_init()
- 随后的步骤与lab 2相似，但在物理内存、中断、idt初始化后，需要进行虚拟存储、IDE磁盘和swap的初始化，这是本次实验需要完成的部分

### 练习3.1 给未被映射的地址映射上物理页

1. **原理简述**
    1. 现在我们已经拥有的基础是对物理内存的管理和对页表/页目录表的管理，以及对异常/中断的处理机制；虚拟内存管理就是在这二者基础上建立的，一方面，利用虚拟地址得到物理地址的对应关系由页表实现，另一方面，通过触发Page Fault异常，可以实现将不在物理内存中的页换入物理内存
    2. 对虚拟内存的管理类似对物理内存的管理，都是建立在连续地址空间基础之上的，用来管理一片连续虚拟地址的结构为`struct vma_struct`，定义如下：
        ```c
            struct vma_struct {
                struct mm_struct *vm_mm; // 虚拟内存管理器
                uintptr_t vm_start;      // virtual memory area的首地址
                uintptr_t vm_end;        // virtual memory area的未地址，vma区间为[start, end)
                uint32_t vm_flags;       // flags of vma
                list_entry_t list_link;  // 链表节点
            };
        ```
    3. 在每个`vma_struct`中都有一个指向`mm_struct`的指针vm_mm，而且属于同一PDT（页目录表）的vma，也即对应于同一进程（尽管在lab 3中还没有实现进程管理）的vma，都指向同一个vm_mm，这个vm_mm就是用来管理这一进程的所有虚拟地址的虚拟内存管理器，其定义如下：
        ```c
            struct mm_struct {
                list_entry_t mmap_list;        // 连接各vma的链表的头节点
                struct vma_struct *mmap_cache; // vma的查找缓存，根据实验指导书，可以将查找效率提高30%
                pde_t *pgdir;                  // 该虚拟内存管理器对应的页目录表（也就是该进程的页目录表）
                int map_count;                 // vma计数
                void *sm_priv;                 // 由交换管理器swap manager使用的数据
            };
        ```
    4. 可以看到，在`mm_struct`中还定义了用于交换的swap manager私有数据`sm_priv`，这部分相关内容将在下一个练习中涉及
    
2. **实现方法**
    5. 完成这一步后，可以看到如下结果，可见`check_vma_struct()`, `check_pgfault()`和`check_vmm()`已经成功，虚拟存储框架已经建立，但在具体处理swap时出现异常，这是下一个练习中涉及的内容：
        ```gdb
            ...
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
            check_vma_struct() succeeded!
            page fault at 0x00000100: K/W [no page found].
            check_pgfault() succeeded!
            check_vmm() succeeded.
            ide 0:      10000(sectors), 'QEMU HARDDISK'.
            ide 1:     262144(sectors), 'QEMU HARDDISK'.
            SWAP: manager = fifo swap manager
            BEGIN check_swap: count 1, total 31965
            setup Page Table for vaddr 0X1000, so alloc a page
            setup Page Table vaddr 0~4MB OVER!
            set up init env for check_swap begin!
            page fault at 0x00001000: K/W [no page found].
            page fault at 0x00002000: K/W [no page found].
            page fault at 0x00003000: K/W [no page found].
            page fault at 0x00004000: K/W [no page found].
            set up init env for check_swap over!
            write Virt Page c in fifo_check_swap
            write Virt Page a in fifo_check_swap
            write Virt Page d in fifo_check_swap
            write Virt Page b in fifo_check_swap
            write Virt Page e in fifo_check_swap
            page fault at 0x00005000: K/W [no page found].
            page fault at 0x0000001b: K/R [no page found].
            not valid addr 1b, and  can not find it in vma
            trapframe at 0xc011ed34
            ...
            kernel panic at kern/trap/trap.c:189:
                handle pgfault failed. invalid parameter
        ```

2. **回答问题** ：
    1. 请描述页目录项（Pag Director Entry）和页表（Page Table Entry）中组成部分对ucore实现页替换算法的潜在用处
        > 的确存在进一步改进空间，主要在于以下方面：
        > 1. 在`default_alloc_pages`方法中，对于分割块的操作，先删除了块的链表节点，之后若块大于需求，则分割，并将新块作为节点插入原块的位置。这里，事实上大多数情况下会发生分割操作，更节省开销的方法是直接将原块的前后节点指向新节点，同时添加新节点的指向，而不是像现在先删除再插入；但考虑到已经封装好的链表方法，直接调用已有方法封装性更好，减少出错可能，不过开销稍大
        > 2. 在`default_free_pages`方法中，先拓展块，再遍历链表寻找插入位置。事实上在拓展块的同时，就已经可以得到拓展后块的前/后一个节点，如果能利用这一信息，可以省去寻找位置时的遍历
        > 3. 同样在`default_free_pages`方法中，在拓展块时，考虑到如果一直使用这种拓展方法，链表中的已有块之间一定已经不能互相合并，那么在对空闲块的前、后至多各一次拓展后就已经不可能再发生其他合并，那么可以提前结束遍历。同时，在遍历时当前块地址大于空闲块地址时不可能继续向前拓展，当前块地址小于空闲块地址时不可能向后拓展（因为正常情况下块之间不可能发生重叠），这样也可以提前结束循环。
        > 4. 对于上述第3点，较简单的方法是，在遍历中直接找到第一个地址大于当前空闲块的已有块，这一定是唯一可能的向后拓展块，再取这个块的前一个块，这也一定是唯一可能的向前拓展块，同时这也确定了合并后块的插入位置。尝试将这两个块合并入待插入的空闲块，最后将合并后的空闲块插入已经确定的位置即可。
    2. 如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？
        > 的确存在进一步改进空间，主要在于以下方面：

    

### 练习3.2 补充完成基于FIFO的页面替换算法

1. **原理简述**
    1. 关于地址
        
2. **实现方法**
    - 根据框架注释中已经给出的模式，实现如下：
        
    - 完成后，运行`make qemu`可以看到如下结果，可见通过了`check_swap()`的检查
        ```gdb
            ...
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
            check_vma_struct() succeeded!
            page fault at 0x00000100: K/W [no page found].
            check_pgfault() succeeded!
            check_vmm() succeeded.
            ide 0:      10000(sectors), 'QEMU HARDDISK'.
            ide 1:     262144(sectors), 'QEMU HARDDISK'.
            SWAP: manager = fifo swap manager
            BEGIN check_swap: count 1, total 31964
            setup Page Table for vaddr 0X1000, so alloc a page
            setup Page Table vaddr 0~4MB OVER!
            set up init env for check_swap begin!
            page fault at 0x00001000: K/W [no page found].
            page fault at 0x00002000: K/W [no page found].
            page fault at 0x00003000: K/W [no page found].
            page fault at 0x00004000: K/W [no page found].
            set up init env for check_swap over!
            write Virt Page c in fifo_check_swap
            write Virt Page a in fifo_check_swap
            write Virt Page d in fifo_check_swap
            write Virt Page b in fifo_check_swap
            write Virt Page e in fifo_check_swap
            page fault at 0x00005000: K/W [no page found].
            swap_out: i 0, store page in vaddr 0x1000 to disk swap entry 2
            write Virt Page b in fifo_check_swap
            write Virt Page a in fifo_check_swap
            page fault at 0x00001000: K/W [no page found].
            swap_out: i 0, store page in vaddr 0x2000 to disk swap entry 3
            swap_in: load disk swap entry 2 with swap_page in vadr 0x1000
            write Virt Page b in fifo_check_swap
            page fault at 0x00002000: K/W [no page found].
            swap_out: i 0, store page in vaddr 0x3000 to disk swap entry 4
            swap_in: load disk swap entry 3 with swap_page in vadr 0x2000
            write Virt Page c in fifo_check_swap
            page fault at 0x00003000: K/W [no page found].
            swap_out: i 0, store page in vaddr 0x4000 to disk swap entry 5
            swap_in: load disk swap entry 4 with swap_page in vadr 0x3000
            write Virt Page d in fifo_check_swap
            page fault at 0x00004000: K/W [no page found].
            swap_out: i 0, store page in vaddr 0x5000 to disk swap entry 6
            swap_in: load disk swap entry 5 with swap_page in vadr 0x4000
            write Virt Page e in fifo_check_swap
            page fault at 0x00005000: K/W [no page found].
            swap_out: i 0, store page in vaddr 0x1000 to disk swap entry 2
            swap_in: load disk swap entry 6 with swap_page in vadr 0x5000
            write Virt Page a in fifo_check_swap
            page fault at 0x00001000: K/R [no page found].
            swap_out: i 0, store page in vaddr 0x2000 to disk swap entry 3
            swap_in: load disk swap entry 2 with swap_page in vadr 0x1000
            count is 0, total is 7
            check_swap() succeeded!
            ++ setup timer interrupts
            100 ticks
            100 ticks

        ```
3. **回答问题**
    - 如果要在ucore上实现"extended clock页替换算法"请给你的设计方案，现有的swap_manager框架是否足以支持在ucore中实现此算法？如果是，请给你的设计方案。如果不是，请给出你的新的扩展和基此扩展的设计方案。并需要回答如下问题:
        - 需要被换出的页的特征是什么？
        - 在ucore中如何判断具有这样特征的页？
        - 何时进行换入和换出操作？
        > - PDE：高20位表示二级页表基址的高20位；第3位为PTE_U，置1表示用户可以访问；第2位为PTE_W，置1表示该二级页表中各页可写；第1位为PTE_P，置1表示二级页表存在
        > - PTE：高20位表示物理页基址的高20位；第3位为PTE_U，置1表示用户可以访问；第2位为PTE_W，置1表示该页可写；第1位为PTE_P，置1表示该物理页存在于内存中
        > - 潜在用处：各控制位均有潜在用处，PTE_U用于对不同内存的权限控制，保护核心代码和数据；PTE_W可以用于实现只读内存空间；对于页目录表，PTE_P可以使未用到的二级页表不必存在于内存中，减少空间开销，对于二级页表，PTE_P可以支持虚拟存储技术，允许部分页被替换到外存中，解决物理内存不足的问题。


### 练习2.x 实现识别dirty bit的 extended clock页替换算法

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