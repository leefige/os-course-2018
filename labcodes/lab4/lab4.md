# Lab4 实验报告

## 0. 个人信息
- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习4.0 填写已有实验

- 在迁移Lab 1-3实验内容到Lab 4后，若直接运行`make qemu`，则会出现提示信息如下，可以看出对Lab 1-3的内容检查已经完成，并运行到了`proc.c`中创建线程的位置，触发kernel panic，证明移植成功：
    ```gdb
        ...
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
        use SLOB allocator
        kmalloc_init() succeeded!
        check_vma_struct() succeeded!
        page fault at 0x00000100: K/W [no page found].
        check_pgfault() succeeded!
        check_vmm() succeeded.
        kernel panic at kern/process/proc.c:353:
            create init_main failed.
    ```
- 本次实验中添加了创建第一个内核线程的步骤，并且之后以该线程为基础产生其他线程。在`init.c`中，可以看到`kern_init()`函数如下：
    ```c
        pmm_init();         // init physical memory management
        pic_init();         // init interrupt controller
        idt_init();         // init interrupt descriptor table
        vmm_init();         // init virtual memory management
        proc_init();        // init process table
        ide_init();         // init ide devices
        swap_init();        // init swap
        clock_init();       // init clock interrupt
        intr_enable();      // enable irq interrupt

        cpu_idle();         // run idle process
    ```
    可以看到在pmm和vmm都初始化后，会进行进程初始化，随后才初始化置换机制和时钟中断等。在全部就绪后，会调用`cpu_idle()`转入idle_process，开始进程调度。idle_process唯一的工作就是检查当前进程是否需要调度，如果需要，就进行进程调度，并且死循环执行这一过程。

### 练习4.1 分配并初始化一个进程控制块

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

### 练习4.2 为新创建的内核线程分配资源

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

### 练习4.3 阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的

1. **原理简述**
    1. Clock算法将各虚拟地址节点按双向链表组织，依靠一个“时钟”式的指针，依次检查各节点，并执行相应操作，周而复始直到找到满足条件的可被置换出的节点
    2. Extended clock算法在clock算法的基础上，其挑选被置换页的方法是依靠PTE中的PTE_A和PTE_D检测一个页表项是否被访问/修改过，被置换的优先级按如下排序：
        1. PTE_A == 0 && PTE_D == 0，即既没有访问过又没有访问过的
        2. PTE_A == 0 && PTE_D == 1，即虽然修改过，但没有访问过的
        3. PTE_A != 0，即访问过的
        该排序的依据是程序运行的局部性原理，即访问过的页更有可能后续还会被访问
    3. 在该排序方法下，算法在遍历双向链表、寻找到合适节点前，对于扫描到的每一个节点做如下操作：
        - 若PTE_A != 0，即页被访问过时，将PTE_A置0，指针直接指向下一个节点继续判断
        - 若PTE_A == 0，即页没有访问过，但PTE_D != 0，即页被修改过，则将它复写到硬盘缓冲区，并将PTE_D置0，指针指向下一个节点继续判断
        - 若PTE_A == 0且PTE_D == 0，则该节点被选中为被换出页，结束遍历，将该节点删除，同时指针指向该节点原来的后继节点
2. **实现方法**
    - 实现的extended clock置换算法定义在`swap_enclock.[ch]`中（因为我在编码时误将extended clock记为enhanced clock，故命名为enclock，下同）
    - 算法的实现在已有的FIFO基础上进行改进，涉及到需要修改的函数为`swap_manager`中的`init_mm()`，`map_swappable()`和`swap_out_victim()`函数，另外新增了一个结构体`enclock_struct`，内含算法需要维护的双向链表头节点head和时钟指针clock，用作vm_mm对象的`sm_priv`变量，其定义如下：
        ```c
            // swap_enclock.h
            struct enclock_struct {
                list_entry_t* head;
                list_entry_t** clock;
            };

            // swap_enclock.c
            list_entry_t pra_list_head; // 链表头
            list_entry_t *clock_ptr;    // 时钟指针
            struct enclock_struct sm_priv_enclock =
            {
                .head            = &pra_list_head,
                .clock           = &clock_ptr,
            };
        ```
    - `init_mm()`中，需要初始化链表头节点，并让指针指向该节点，同时为vm_mm的`sm_priv`变量赋值为上述的`&sm_priv_enclock`，该函数定义如下：
        ```c
            static int
            _enclock_init_mm(struct mm_struct *mm)
            {
                list_init(&pra_list_head);
                clock_ptr = &pra_list_head;
                assert(clock_ptr != NULL);
                mm->sm_priv = &sm_priv_enclock;
                return 0;
            }
        ```
    - `map_swappable()`中，事实上与FIFO算法操作相同，都是对新换入的节点加入到链表尾，没有其他特殊操作，唯一的不同是从`sm_priv`中取出链表头节点的方法不同，即`list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head`，其他类似，在此不再赘述
    - `swap_out_victim()`为本算法核心，需要实现前面原理中叙述的第3点，即遍历双向链表并对PTE_A/PTE_D做出相应修改，最终筛选出被换出节点，注意在此处可能会遍历最多3次：第一次将PTE_A全部清零，第二次将PTE_D全部清零，第三次找到目标，因此对循环进行了计数，并加`assert(cnt < 3)`确保无误。此外，在每次修改PTE时，需要手动置TLB无效。遍历过程实现如下：
        ```c
            list_entry_t *le_prev = clock_ptr, *le;
            int cnt = 0;
            while (le = list_next(le_prev)) {
                assert(cnt < 3);    // 确保循环次数正确
                if (le == head) {
                    cnt ++;
                    le_prev = le;   // 每次遇到头节点时，跳过
                    continue;
                }
                struct Page *page = le2page(le, pra_page_link);
                // 获取PTE
                pte_t* ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
                _enclock_print_pte(ptep, page->pra_vaddr); // 打印PTE信息
                // PTE_A != 0
                if (*ptep & PTE_A) {
                    // set access to 0
                    *ptep &= ~PTE_A;
                    tlb_invalidate(mm->pgdir, page->pra_vaddr);
                } else {
                    // PTE_A == 0 && PTE_D != 0
                    if (*ptep & PTE_D) {
                        // 先将dirty page写入缓冲区
                        if (swapfs_write((page->pra_vaddr / PGSIZE + 1) << 8, page) == 0) {
                            cprintf("write 0x%x to disk\n", page->pra_vaddr);
                        }
                        // set dirty to 0
                        *ptep = *ptep & ~PTE_D;
                        tlb_invalidate(mm->pgdir, page->pra_vaddr);
                    } else {
                        // PTE_A == 0 && PTE_D == 0
                        cprintf("victim is 0x%x\n", page->pra_vaddr);
                        break;
                    }
                }
                le_prev = le;
            }
        ```
        在筛选出victim并结束算法之前，还需要注意要更新`mm->sm_priv`中的`clock`指针，以保存当前指针位置，指向被删除节点的原后继，也即被删除节点的前驱的现后继，实现如下：
        ```c
            *(((struct enclock_struct*) mm->sm_priv)->clock) = list_next(le_prev);
        ```
    - 为了检查实现效果，采用了PPT中的例子，即a, b, c, d四页均已在内存中且都未被访问、未被修改，那么一方面需要修改`check_swap()`令其与PPT中样例一致，包括读/写和PAGE FAULT数的assertion。另一方面，新增了函数`_enclock_reset_pte()`用来初始修改4个页的PTE标志位，以将其A/D均清空，该函数在`check_swap()`中的第一步执行。定义如下：
        ```c
            void
            _enclock_reset_pte(pde_t* pgdir) {
                cprintf("PTEs resetting...\n");
                for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
                    pte_t* ptep = get_pte(pgdir, va, 0);
                    *ptep = *ptep & ~PTE_A;
                    *ptep = *ptep & ~PTE_D;
                    tlb_invalidate(pgdir, va);
                }
                cprintf("PTEs reseted!\n");
            }
        ```
        此外，为了方面查看指针每次移动后，PTE的变化情况，定义了`_enclock_print_pte()`函数打印4个页的PTE情况。定义如下：
        ```c
            void
            _enclock_print_pte(struct mm_struct *mm) {
                cprintf("va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", va, *ptep, *ptep & PTE_A, *ptep & PTE_D);
            }
        ```
    - 要使用该方法，需要在`swap.c`中将sm赋值为swap_manager_enclock，即`sm = &swap_manager_enclock`. 实现结果如下，check中顺序与PPT一致，并且打印了每次时钟指针转向下一个时的4个PTE情况，和PPT中对比可见PAGE FAULT情况一致（新增3次PAGE FAULT，第一次victim为0x3000即c，第二次victim为0x4000即d，第三次victim为0x2000即b），说明实现基本正确：
        ```gdb
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
            SWAP: manager = extended clock swap manager
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
            va: 0x1000, pte: 0x308067 A: 0x20, D: 0x40
            va: 0x2000, pte: 0x309067 A: 0x20, D: 0x40
            va: 0x3000, pte: 0x30a027 A: 0x20, D: 0x0
            va: 0x4000, pte: 0x30b027 A: 0x20, D: 0x0
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            write 0x1000 to disk
            va: 0x2000, pte: 0x309047 A: 0x0, D: 0x40
            write 0x2000 to disk
            va: 0x3000, pte: 0x30a007 A: 0x0, D: 0x0
            victim is 0x3000
            swap_out: i 0, store page in vaddr 0x3000 to disk swap entry 4
            read Virt Page b in enclock_check_swap
            write Virt Page a in enclock_check_swap
            read Virt Page b in enclock_check_swap
            read Virt Page c in enclock_check_swap
            page fault at 0x00003000: K/R [no page found].
            va: 0x5000, pte: 0x30a067 A: 0x20, D: 0x40
            va: 0x1000, pte: 0x308067 A: 0x20, D: 0x40
            va: 0x2000, pte: 0x309027 A: 0x20, D: 0x0
            va: 0x4000, pte: 0x30b007 A: 0x0, D: 0x0
            victim is 0x4000
            swap_out: i 0, store page in vaddr 0x4000 to disk swap entry 5
            swap_in: load disk swap entry 4 with swap_page in vadr 0x3000
            read Virt Page d in enclock_check_swap
            page fault at 0x00004000: K/R [no page found].
            va: 0x3000, pte: 0x30b027 A: 0x20, D: 0x0
            va: 0x1000, pte: 0x308047 A: 0x0, D: 0x40
            write 0x1000 to disk
            va: 0x2000, pte: 0x309007 A: 0x0, D: 0x0
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

1. 其他局部页面置换算法：如LFU等，在实验中未要求实现（extended clock算法在challenge中实现）
2. 全局页面置换算法：如工作集置换算法、缺页率置换算法
3. 抖动问题和负载控制：因为Lab 3尚未涉及进程，因此没有涉及
4. 覆盖技术和交换技术
