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
        可以看到，在`mm_struct`中还定义了用于交换的swap manager私有数据`sm_priv`，这部分相关内容将在下一个练习中涉及
    4. 虚拟存储管理的工作原理如下：
        - 利用虚拟地址映射得到物理地址的实现已经在lab 2的页表配置相关内容中完成，MMU通过查询页表就可以获得虚拟地址对应的物理地址（如果存在）和相关标志，如页是否存在于内存中等
        - 对于每一个合法的虚拟地址，都会有相应的vma维护，而同一页目录表下的所有vma（即所有合法虚拟地址）则由更上层的vm_mm维护：
            - vma维护了每一段连续虚拟地址空间的地址范围以及访问权限、标志位
            - vm_mm维护了所有vma组成的链表，vma数量，所属的页目录表以及换入换出相关数据
        - 在实际访存时，如果正常得到标志为存在且权限合法的物理地址，则直接访存；否则会触发PAGE FAULT，这就进入<span id="steps">**PAGE FAULT处理相关步骤**</span>：
            1. 选择出错虚拟地址所属PDT对应的vm_mm，将PAGE FAULT错误码和%cr2寄存器中的出错虚拟地址
            2. 检查要访存的虚拟地址是否合法、具有何种权限要求、是否可访问
            3. 如果合法、可访问，但地址所在的物理页不在内存中，则将其从磁盘换入
            4. 在需要的时候，将某些物理页从内存换出到磁盘中
        - 本练习涉及上述前两步，其具体过程如下：
            1. 触发PAGE FAULT异常，转入中断异常处理例程，导致出错的线性地址保存在%cr2寄存器，指示错误类型的错误码被压栈
            2. 判断为PAGE FAULT异常后，交由`pgfault_handler()`处理，在该函数中，会检查vm_mm是否存在，如果存在，以vm_mm，错误码和%cr2寄存器中的地址为参数，调用`do_pgfault()`转入下一步处理
            3. 在`do_pgfault()`中，首先根据%cr2中的线性地址在vm_mm中寻找维护该地址的vma，若没找到，说明该地址非法，直接fail
            4. 接着根据错误码判断出错类型，如读/写不在物理内存中的页、写只读页等
            5. 若判断为合法、可访问，但是目标页不在物理内存中，则准备将该页换入物理内存或分配新的物理页，根据vma中的标志位设置页权限
            6. 通过`get_pte()`获得地址对应的页表项PTE，检查PTE中的地址，若为0，说明该物理页尚未被分配，则直接调用`pgdir_alloc_page()`为该虚地址分配一个物理页，结束处理
            7. 若PTE中地址非0，说明该页被换出，需要换入，进入上述的第3步

2. **实现方法**
    - 这一练习需要完成的部分在`do_pgfault()`中，需要实现在判断虚地址合法、可访问后，获取对应的PTE，并在检查发现该页事实还未被分配时直接分配一个物理页
    - 注释中已经给出了实现步骤，流程如上所述，我的实现如下：
        ```c
            ptep = get_pte(mm->pgdir, addr, 1);
            assert(ptep != NULL);
            if (*ptep == 0) {
                assert(pgdir_alloc_page(mm->pgdir, addr, perm) != NULL);
            }
        ```
    - 完成这一步后，可以看到如下结果，可见`check_vma_struct()`, `check_pgfault()`和`check_vmm()`已经成功，虚拟存储框架已经建立，但在具体处理swap时出现异常，这是下一个练习中涉及的内容：
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
        > 1. 组成：
        >       - PDE高20位存储对应二级页表物理地址的高20位，低12位中有一些为标志位：bit 0为PTE_P表示二级页表是否存在，bit 1为PTE_W表示是否可写，bit 2为PTE_U表示用户是否可访问；其余为保留位
        >       - PTE结构类似，高20位存储对应物理页的物理地址高20位，但是当该页被换出时，高24位表示该页在硬盘上的起始扇区地址；PDE的标志位PTE也具有，而且PTE还有其他标志位：bit 5为PTE_A，表示该页被访问过，bit 6为PTE_D，表示该页被修改过；其他位也是保留位
        > 2. 潜在用途：
        >       - 首先对于保存地址的部分，在虚拟地址映射中用于寻找一个虚地址对应的物理地址，而在页替换中，可以用来找到一个被换出的物理页在硬盘上的实际位置
        >       - 对于标志位，PDE的标志位主要用于对PTE的控制，与页替换算法无太大关系；但PTE的标志位十分重要，PTE_P用来表示一个页是否存在于内存中，若该位为0则可能要从硬盘中换入页；PTE_W和PTE_U用于页的权限控制；PTE_A可以表示一个页是否被访问过，在页替换算法中，可以用于判断被换出页的优先级，未被访问过的页会被优先淘汰；PTE_D表示一个页是否被修改过，在页替换算法中，可以用来判断一个页被淘汰时是否需要写入硬盘
    2. 如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？
        > - 一般来讲，缺页服务例程作为核心代码应该常驻内存中，不会在执行缺页服务例程过程中出现页访问异常
        > - 但如果真的出现这种情况，那么硬件会像其他中断/异常一样，依次将eflags, cs, eip寄存器压入核心栈，还会将错误码压入栈中，随后查找IDT并嵌套转入PAGE FAULT处理服务例程
        > - 在执行过程中会再次出现相同的异常，导致死循环

### 练习3.2 补充完成基于FIFO的页面替换算法

1. **原理简述**
    1. 承接练习1中所述的[PAGE FAULT处理相关步骤](#steps)，在`do_pgfault()`判断需要目标页被换出到磁盘后，需要将页换入
    2. 页换入时，调用`swap_in()`将磁盘中存储的页内容写入物理内存，并得到对应的物理页Page指针，接着调用`page_insert()`建立物理页到对应虚页的映射关系，然后将这一被换入页利用`swap_map_swappable()`标注为可换出
    3. 这里需要注意的是，在物理页换入后，要将物理页Page的`pra_vaddr`属性写为对应虚地址，这是为了在后续换出时使用
    4. 在具体的换入换出算法中，练习中实现了FIFO算法，该算法通过维护一个链表，每次一个页被设置为可换出时，将它加入这个链表尾部，而每次需要将一个页换出时，从这个链表的头部取出一个页换出，这样就实现了先进先出的置换算法
    5. 具体地，在设置一个页可换出时使用`_fifo_map_swappable()`，该函数将一个页Page的`pra_page_link`插入上述链表尾部；在获取可换出页时，使用`_fifo_swap_out_victim()`，该函数取出链表头的页，将其从该链表中删除，并将对应的物理页Page返回到目标中，即找到了被淘汰的页
        
2. **实现方法**
    - 首先在`do_pgfault()`中，地址合法、可访问且判断PTE不为0，说明该页被换出到磁盘，那么调用`swap_in()`将其换入、建立虚拟地址映射、标记为可换出，实现如下：
        ```c
            if(swap_init_ok) {
                struct Page *page=NULL;
                assert(swap_in(mm, addr, &page) == 0);
                page->pra_vaddr = addr;
                page_insert(mm->pgdir, page, addr, perm);
                swap_map_swappable(mm, addr, page, 1);
            }
        ```
    - 在具体的置换算法`swap_fifo.c`中，需要完善`_fifo_map_swappable()`和`_fifo_swap_out_victim()`。其中`_fifo_map_swappable()`根据传入参数`swap_in`判断是否是被换入页（存在不是的情况，如试图换出一个页失败时），如果是，则直接将其插入链表尾，也即双向列表的head之前；若不是，则还需先找到原来的节点，将其删除，再重新插入链表尾。实现如下：
        ```c
            if (swap_in == 0) {
                list_entry_t *le_prev = head, *le;
                while ((le = list_next(le_prev)) != head) {
                    if (le == entry) {
                        list_del(le);
                        break;
                    }
                    le_prev = le;
                }
            }
            list_add_before(head, entry);
        ```
    - 在`_fifo_swap_out_victim()`中，要取出链表第一个节点，将其删除，并将它返回到传入的指针，实现如下：
        ```c
            list_entry_t *front = list_next(head);
            assert(front != head);
            list_del(front);
            //(2)  assign the value of *ptr_page to the addr of this page
            struct Page *page = le2page(front, pra_page_link);
            *ptr_page = page;
        ```
        需要说明的是，我在这里遇到的一个问题是在`le2page()`中因为混淆，误把第二个参数写成了page_link（实际为pra_page_link），导致无法将链表项返回为正确的page，这一bug调试花费我很长时间，不过也说明这两者命名可能不够有区分度，导致有混淆的可能
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
        > - 在现有框架下可以支持实现extended clock算法，可以在FIFO算法基础上增加一个指针用于指向当前的链表节点，同时让`mm_struct`的`sm_priv`指针指向一个结构体，这个结构体包含了链表头指针和指向当前链表节点的指针。在此基础上再修改相关算法实现即可。具体实现过程参见下文challenge部分
        > - 需要被置换出页，其修改位和访问位都应该为0
        > - 在ucore中，可以通过PTE的标志位PTE_A（访问位）和PTE_D（修改位）进行判断
        > - 换入：在访存错误触发PAGE FAULT，经过检查发现目标页被换出到磁盘时进行；换出：消极策略，在试图分配新页时发现物理内存不足时进行

### 练习3.x 实现识别dirty bit的 extended clock页替换算法

1. **原理简述**
    1. 现在
2. **实现方法**
    - 实现结果如下，check中顺序与PPT一致，并且打印了每次时钟指针转向下一个时的4个PTE情况，和PPT中对比可见PAGE FAULT情况一致（第一次victim为0x3000即c，第二次victim为0x4000即d，第三次victim为0x2000即b），说明实现基本正确：
        ```c
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
            SWAP: manager = enclock swap manager
            BEGIN check_swap: count 1, total 31963
            setup Page Table for vaddr 0X1000, so alloc a page
            setup Page Table vaddr 0~4MB OVER!
            set up init env for check_swap begin!
            page fault at 0x00001000: K/W [no page found].
            page fault at 0x00002000: K/W [no page found].
            page fault at 0x00003000: K/W [no page found].
            page fault at 0x00004000: K/W [no page found].
            set up init env for check_swap over!
            PTEs resetting...
            PTEs reseted!
            read Virt Page c in enclock_check_swap
            write Virt Page a in enclock_check_swap
            read Virt Page d in enclock_check_swap
            write Virt Page b in enclock_check_swap
            write Virt Page e in enclock_check_swap
            page fault at 0x00005000: K/W [no page found].
            -------------------------
            va: 0x1000, pte: 0x308067 A: 0x20, D: 0x40
            va: 0x2000, pte: 0x309067 A: 0x20, D: 0x40
            va: 0x3000, pte: 0x30a027 A: 0x20, D: 0x0
            va: 0x4000, pte: 0x30b027 A: 0x20, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309067 A: 0x20, D: 0x40
            va: 0x3000, pte: 0x30a027 A: 0x20, D: 0x0
            va: 0x4000, pte: 0x30b027 A: 0x20, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309047 A: 0x0, D: 0x40
            va: 0x3000, pte: 0x30a027 A: 0x20, D: 0x0
            va: 0x4000, pte: 0x30b027 A: 0x20, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309047 A: 0x0, D: 0x40
            va: 0x3000, pte: 0x30a007 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b027 A: 0x20, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309047 A: 0x0, D: 0x40
            va: 0x3000, pte: 0x30a007 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            -------------------------
            write 0x1000 to disk
            -------------------------
            va: 0x1000, pte: 0x308007 A: 0x0, D: 0x0
            va: 0x2000, pte: 0x309047 A: 0x0, D: 0x40
            va: 0x3000, pte: 0x30a007 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            -------------------------
            write 0x2000 to disk
            -------------------------
            va: 0x1000, pte: 0x308007 A: 0x0, D: 0x0
            va: 0x2000, pte: 0x309007 A: 0x0, D: 0x0
            va: 0x3000, pte: 0x30a007 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            -------------------------
            victim is 0x3000
            swap_out: i 0, store page in vaddr 0x3000 to disk swap entry 4
            read Virt Page b in enclock_check_swap
            write Virt Page a in enclock_check_swap
            read Virt Page b in enclock_check_swap
            read Virt Page c in enclock_check_swap
            page fault at 0x00003000: K/R [no page found].
            -------------------------
            va: 0x1000, pte: 0x308067 A: 0x20, D: 0x40
            va: 0x2000, pte: 0x309027 A: 0x20, D: 0x0
            va: 0x3000, pte: 0x400 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308067 A: 0x20, D: 0x40
            va: 0x2000, pte: 0x309027 A: 0x20, D: 0x0
            va: 0x3000, pte: 0x400 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309027 A: 0x20, D: 0x0
            va: 0x3000, pte: 0x400 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309007 A: 0x0, D: 0x0
            va: 0x3000, pte: 0x400 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            -------------------------
            victim is 0x4000
            swap_out: i 0, store page in vaddr 0x4000 to disk swap entry 5
            swap_in: load disk swap entry 4 with swap_page in vadr 0x3000
            read Virt Page d in enclock_check_swap
            page fault at 0x00004000: K/R [no page found].
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309007 A: 0x0, D: 0x0
            va: 0x3000, pte: 0x30b027 A: 0x20, D: 0x0
            va: 0x4000, pte: 0x500 A: 0x0, D: 0x0
            -------------------------
            -------------------------
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            va: 0x2000, pte: 0x309007 A: 0x0, D: 0x0
            va: 0x3000, pte: 0x30b007 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x500 A: 0x0, D: 0x0
            -------------------------
            write 0x1000 to disk
            -------------------------
            va: 0x1000, pte: 0x308007 A: 0x0, D: 0x0
            va: 0x2000, pte: 0x309007 A: 0x0, D: 0x0
            va: 0x3000, pte: 0x30b007 A: 0x0, D: 0x0
            va: 0x4000, pte: 0x500 A: 0x0, D: 0x0
            -------------------------
            victim is 0x2000
            swap_out: i 0, store page in vaddr 0x2000 to disk swap entry 3
            swap_in: load disk swap entry 5 with swap_page in vadr 0x4000
            count is 0, total is 7
            check_swap() succeeded!
            ++ setup timer interrupts
            100 ticks
            100 ticks
            ```

## 2. 标准答案对比

1. **练习1** ：
    - 在`do_pgfault()`中，答案在获取PTE、发现pte等于0欲分配新物理页时，都进行了是否成功的判断，并在失败时输出了相关错误信息，如`cprintf("get_pte in do_pgfault failed\n");`
    - 但我在实现时，虽然也考虑了可能的失败情况，不过我用了assert进行确保，在失败时会直接退出并提示在何处assertion failed，如`assert(pgdir_alloc_page(mm->pgdir, addr, perm) != NULL);`
2. **练习2** ：
    - 同样在`do_pgfault()`中，答案判断swap in失败时会输出错误信息并`goto failed`，但我用了`assert(swap_in(mm, addr, &page) == 0);`，通过assert进行结果确保
    - 在`_fifo_map_swappable()`中，答案没有考虑参数`swap_in`，即被置为可换出的页是否是刚换入的页，也许是因为答案认为在FIFO算法中这一参数并没有体现作用。但我考虑到一种情况，即在`kern/mm/swap.c`的`swap_out()`函数种有一处为`sm->map_swappable(mm, v, page, 0)`，这里是因为该页本来应该被换出，但因为某种原因换出失败时，被重新标记为可换出，按照FIFO的思路，该页此时应该被插入链表尾，但换出失败时可能出现该页的节点仍然在链表中的情况，因此我认为应该在swap_in == 0时遍历链表，确保该节点被删除后再插入链表尾，以避免可能的错误，因此我增加了对swap_in的判断以及其等于0时的操作
    - 另外，答案中对链表首尾的理解与我不同，答案中插入时直接用了`list_add(head, entry)`，也就是插入头节点之后，那么答案对链表首的定义为头节点的前一个节点，链表尾为头节点的后一个节点；但我理解链表首为头节点下一个节点，链表尾为头节点前一个节点，因此在插入时使用了`list_add_before(head, entry)`
    - 对应上条，在`_fifo_swap_out_victim()`中删除节点时，答案删除头节点的前一个节点，而我删除头节点的下一个节点

## 3. 实验知识点分析

1. 虚拟内存管理：
    - 连续虚拟地址空间管理：实验中使用vma实现对一块连续虚地址空间的维护，这一点相对偏实现细节，在OS原理课中没有展开
    - 虚拟内存管理：建立在vma之上，使用vm_mm对属于同一PDT下的虚拟内存空间进行管理，包括判断某一虚地址是否合法等，这一点同样在OS原理中没有展开
    - 按需分页：在实际用到某虚页时才动态地分配物理页，这一点在实验中体现在处理PAGE FAULT时发现PTE为0的情况，在OS原理中有对应知识点
2. PAGE FAULT异常处理：
    - 在触发PAGE FAULT异常时，转入对应的异常处理服务例程，并判断错误码得到对应的处理方法，如直接退出、分配新物理页或从磁盘换入物理页。在OS原理中有对应知识点
3. 页面置换机制：
    - 为支持页面置换，在磁盘设置缓存区：偏于实现细节，在OS原理中没有涉及
    - 页面置换机制：用于支持将不常用的物理页面换入磁盘，从而得到更多物理内存空间，在OS原理中有对应知识点
    - FIFO页面置换算法：利用FIFO建立页面链表，优先将驻留内存时间最长的页换出，这一点在OS原理中有对应知识点

## 4. 未对应知识点分析

1. 其他局部页面置换算法：如LFU等，在实验中未要求实现
2. 全局页面置换算法：如工作集置换算法、缺页率置换算法
3. 抖动问题和负载控制：因为Lab 3尚未涉及进程，因此没有涉及
4. 覆盖技术和交换技术
5. 反置页表等其他类型的页表实现方案