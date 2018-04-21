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

1. **原理和实现**
    1. 操作系统中对一个进程是否存在的唯一标识是其进程控制块PCB，ucore中PCB由内核管理，以结构体`struct proc_struct`的形式存在，其中包含与进程相关的各类信息，包括进程标识信息（PID, name等）、存储管理信息（mm, cr3等）、处理机现场信息（context等）、进程调度信息（need_resched等），以及PCB之间的连接信息（即链表节点）
    2. 每次创建新进程都需要创建一个对应的PCB，执行这一操作的函数是`alloc_proc`，它调用`kmalloc()`为PCB分配空间，并且执行其中成员值的初始化
    3. 初始化中，大部分值被置为0，指针被置为空指针NULL，数组也初始化为0，包括：
        ```c
            proc->runs = 0;
            proc->kstack = 0;
            proc->need_resched = 0;
            proc->parent = NULL;
            proc->mm = NULL;
            memset(&(proc->context), 0, sizeof(struct context));
            proc->tf = NULL;
            proc->flags = 0;
            memset(proc->name, 0, sizeof(char) * (PROC_NAME_LEN + 1));
        ```
        其中要注意到，对于数组和结构体要使用`memset`进行连续内存空间的初始化
    4. 除了这些值外，还有3个成员需要单独考虑，它们会被分配特定的值，包括：
        ```c
            proc->state = PROC_UNINIT;  // show that this PCB has just be alloced but not inited
            proc->pid = -1;             // an invalid pid
            proc->cr3 = boot_cr3;       // kernel threads share boot_cr3
        ```
        其中，state被初始化为`PROC_UNINIT`表明该PCB对应的进程还未被初始化，仅仅是分配了PCB而已；pid被置为-1也即一个非法值，那么这一PCB不在合法的PCB队列中；cr3被置为boot_cr3，因为这里创建的PCB是内核线程的PCB，而在ucore中内核线程共享同一地址空间，因此共享在kernel中以及创建的页表

2. **回答问题** ：
    - 请说明proc_struct中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？
        > 1. `context`；
        >       - 含义是进程运行时的上下文（即处理机中部分寄存器的值），其包含信息如下：
        >           ```c
        >               struct context {
        >                   uint32_t eip;
        >                   uint32_t esp;
        >                   uint32_t ebx;
        >                   uint32_t ecx;
        >                   uint32_t edx;
        >                   uint32_t esi;
        >                   uint32_t edi;
        >                   uint32_t ebp;
        >               };
        >           ```
        >       - 作用：进程（线程）执行时有着自己的控制流，而控制流包括寄存器值和堆栈，这里，`context`就是用来保存这些运行时控制流信息的结构，其中包括当前执行的指令地址%eip, 当前堆栈信息%esp, %ebp, 以及通用寄存器值（除了%eax, 因为%eax用于保存返回值）。利用`context`，在进程切换时只需执行`switch_to()`变更当前处理机中`context`所包含的内容即可实现控制流的上下文切换
        > 2. `tf`；
        >       - 含义同中断/异常处理时含义相同，即复用了trapfram结构用来保存各段寄存器值和%eflags的值
        >       - 作用：主要用于解决新进程刚被创建后如何开始执行的问题。创建新的内核进程使用函数`kernel_thread()`，在其中会对被创建进程的tf进行初始化设置如下：
        >           ```c
        >               tf.tf_cs = KERNEL_CS;
        >               tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
        >               tf.tf_regs.reg_ebx = (uint32_t)fn;              // this is the function this thread will truly exec
        >               tf.tf_regs.reg_edx = (uint32_t)arg;             // this is the arg of fn
        >               tf.tf_eip = (uint32_t)kernel_thread_entry;      // as soon as the kthread start to run, it will exec k_t_entry
        >               return do_fork(clone_flags | CLONE_VM, 0, &tf);
        >           ```
        >           可以看到这里对各段寄存器进行了预设，格外需要注意的是，将`tf`中的%ebx，%edx设为了线程主函数和其参数，而%eip设为了函数`kernel_thread_entry()`；随后在调用`do_fork()`实际创建出这个线程时，在调用`copy_thread()`时将`context`中的%eip设为了`forkret()`. 那么，在该线程被创建、就绪，并且第一次被执行时，其执行流程如下：
        >           1. 通过`switch_to()`将其`context`恢复到处理机中，那么它执行的第一条指令是`forkret()`
        >           2. 进而以进程的`tf`（这是一个指针）为参数调用`trapentry.S::forkrets()`函数
        >           3. 在`forkrets()`中，将参数`tf`的值赋给%esp，即让栈顶指向该进程内核栈的trapframe首地址，这就是内核栈的栈顶位置
        >           4. 随后跳转到`__trapret()`，按照普通中断/异常的返回流程，将trapframe中的通用寄存器和段寄存器的值恢复到处理机中
        >           5. 最后利用`iret`中断返回后，将从`tf.tf_eip`中指定的`entry.S::kernel_thread_entry()`开始执行，它通过`pushl %edx; call *%ebx`以之前指定在`tf`中的%edx值为参数、%ebx值为入口函数地址开始执行新进程真正的main函数
        >           6. 新进程的main函数执行完毕返回`kernel_thread_entry()`后，通过`pushl %eax; call do_exit`将该进程的返回值%eax压栈作为参数，最后调用`do_exit`进程退出

### 练习4.2 为新创建的内核线程分配资源

1. **原理简述**
    1. 练习1中`alloc_proc()`只是为进程分配了PCB资源，但还未为其分配运行所需的内存空间、栈等资源。考虑进程创建的方式，第一个内核线程事实上就是从初始运行至创建第二个内核线程之前的OS kernel本身，在`proc_init()`中，它为自己创建一个PCB并为自己命名为`idleproc`，将这个PCB的kstack指向自己运行至今的栈`bootstack`；在有了这一初始进程后，随后的内核线程都利用`fork`的方法创建，内核线程创建接口为`int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags)`，它在内部使用`do_fork()`通过fork当前进程创建新进程，并返回子进程的pid
    2. 那么，为新建进程的资源分配过程在`do_fork()`中完成，它包含以下过程：
        1. 创建子进程的PCB：`alloc_proc()`
        2. 创建子进程的内核栈：`setup_kstack()`
        3. 为子进程复制内存空间：`copy_mm()`，注意，在创建内核线程时不需要执行复制，因为内核线程共享OS kernel启动时设置好的内存空间
        4. 复制控制流上下文信息：`copy_thread()`，用来初始化`context`和`tf`
        5. 将子进程的PCB插入PCB list，这一步因为涉及修改全局信息，因此需要暂时屏蔽中断，以保证操作的原子性
        6. 通过`wakeup_proc()`设置子线程为`RUNNABLE`，即就绪状态
        7. 返回子进程的pid

2. **实现方法**
    - 步骤基本按照上述原理中叙述进行，需要注意的是，要处理可能出现的异常状况：
        - 若在分配PCB时就失败，则直接失败退出
        - 若在分配内核栈时失败，则需要先清理已经分配的PCB再退出，那么返回`bad_fork_cleanup_proc`
        - 若在复制内核空间时失败，则需要清理栈和PCB再退出，那么返回`bad_fork_cleanup_kstack`
    - 另外需要注意，分配PCB后，要手动在`do_fork`中为PCB指定其父进程为当前进程，即`proc->parent = current`
    - 此外，在将PCB插入list并增加PCB数量时，由于涉及全局信息修改，需要保证操作原子性，所以需要暂时屏蔽中断
    - 完成后，运行`make qemu`可以看到如下结果，可见已经成功创建了第0个和第1个线程，并成功执行了`init_proc`线程输出了"Hello world!!"信息，最后正常通过`do_exit()`退出：
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
            use SLOB allocator
            kmalloc_init() succeeded!
            check_vma_struct() succeeded!
            page fault at 0x00000100: K/W [no page found].
            check_pgfault() succeeded!
            check_vmm() succeeded.
            ide 0:      10000(sectors), 'QEMU HARDDISK'.
            ide 1:     262144(sectors), 'QEMU HARDDISK'.
            SWAP: manager = fifo swap manager
            BEGIN check_swap: count 1, total 31953
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
            count is 0, total is 5
            check_swap() succeeded!
            ++ setup timer interrupts
            this initproc, pid = 1, name = "init"
            To U: "Hello world!!".
            To U: "en.., Bye, Bye. :)"
            kernel panic at kern/process/proc.c:353:
                process exit!!.
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
