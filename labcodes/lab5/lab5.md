# Lab5 实验报告

## 0. 个人信息

- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习5.0 填写已有实验

#### 对已完成的实验1/2/3/4的代码改进

1. trap.c
    - 在`idt_init()`中，需要增加对syscall的支持，即设置syscall的TRAP_GATE，一方面需要设置RPL为用户级，另一方面需要设置其`istrap`标志为1，实现如下：
        ```c
        SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
        ```
    - 在`trap_dispatch()`中，需要设置时钟中断时每个TICK_NUM cycle时将当前正在执行的进程的`need_resched`置为1，即需要调度，实现如下：
        ```c
        if (ticks % TICK_NUM == 0) {
            print_ticks();
            current->need_resched = 1;  // updated in lab 5
        }
        ```
2. proc.c
    - 在`alloc_proc()`中，需要对新增的两个变量进行初始化如下：
        ```c
        proc->wait_state = 0;
        proc->cptr = NULL;
        proc->yptr = NULL;
        proc->optr = NULL;
        ```
    - 在`do_fork()`中，需要检查当前进程的`wait_state`是否为0，还需设置子进程的`parent`为当前进程，实现如下：
        ```c
        // update
        assert(current->wait_state == 0);
        proc->parent = current;
        ```
        此外还需要在插入PCB到相应列表中时设置相关连接关系，这里调用`set_links()`即可，不过需要注意，在`set_links()`中已经包含了插入链表的操作，需要将lab 4中的相同操作去掉，实现如下：
        ```c
        // update
        // list_add(&proc_list, &(proc->list_link));    // deleted
        set_links(proc);
        ```

#### 迁移结果

在完成上述的迁移和代码更新后执行`make qemu`，可以看到如下的结果：
    ```gdb
    ...
    check_swap() succeeded!
    ++ setup timer interrupts
    kernel_execve: pid = 2, name = "exit".
    trapframe at 0xc038bf54
    edi  0x00000000
    esi  0x00000000
    ebp  0x00000000
    oesp 0xc038bf74
    ebx  0x00000000
    edx  0x00000000
    ecx  0x00000000
    eax  0x00000000
    ds   0x----0000
    es   0x----0000
    fs   0x----0000
    gs   0x----0000
    trap 0x0000000d General Protection
    err  0x00000000
    eip  0xc01035b4
    cs   0x----0008
    flag 0x00000282 SF,IF,IOPL=0
    unhandled trap.
    all user-mode processes have quit.
    kernel panic at kern/process/proc.c:855:
        assertion failed: nr_process == 2
    ...
    ```
可见在执行`kernel_execve: pid = 2, name = "exit".`对应语句时触发了异常，经检查是在执行`user_main()`欲加载`exit`用户程序时触发，通过输出，确认在syscall过程中没有异常，于是确定是因为`load_icode()`尚未填写完全导致执行用户进程出错，这正是练习1中的内容

### 练习5.1 加载应用程序并执行

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

### 练习5.2 父进程复制自己的内存空间给子进程

1. **原理简述**
    1. 练习1中`alloc_proc()`只是为进程分配了PCB资源，但还未为其分配运行所需的内存空间、栈等资源。考虑进程创建的方式，第一个内核线程事实上就是从初始运行至创建第二个内核线程之前的OS kernel本身，在`proc_init()`中，它为自己创建一个PCB并为自己命名为`idleproc`，将这个PCB的kstack指向自己运行至今的栈`bootstack`；在有了这一初始进程后，随后的内核线程都利用`fork`的方法创建，内核线程创建接口为`int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags)`，它在内部使用`do_fork()`通过fork当前进程创建新进程，并返回子进程的pid
    2. 那么，为新建进程的资源分配过程在`do_fork()`中完成，它包含以下过程：
        1. 创建子进程的PCB：`alloc_proc()`
        2. 创建子进程的内核栈：`setup_kstack()`
        3. 为子进程复制内存空间：`copy_mm()`，注意，在创建内核线程时事实上不需要执行复制，因为内核线程共享OS kernel启动时设置好的内存空间，这在本实验中体现在`copy_mm()`中实际未执行任何操作
        4. 复制控制流上下文信息：`copy_thread()`，用来初始化`context`和`tf`，而二者的具体作用已经在 _练习4.2_ 的问题回答部分予以解释
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
    - 请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由
        > - fork时分配PID的工作由静态函数`static int get_pid()`实现，在该静态函数中定义了两个静态变量，初始化为`static int next_safe = MAX_PID, last_pid = MAX_PID`，这个赋值语句只会在初始化时被执行一次，其中`last_pid`表示可能的候选pid，`next_safe`表示当前 **连续** 可用pid的上界
        > - 在实际被调用时，首先直接对`last_pid`加一，若它大于等于`MAX_PID`，说明一轮查找到头了，让其返回1重新开始查找；否则，若`last_pid`小于`next_safe`，说明该pid可用，返回`last_pid`值；否则，即若`last_pid`大于等于`next_safe`，则进入一个循环开始查找可用pid
        > - 在循环中，一方面需要查找可用的pid，另一方面还要刷新`next_safe`，这样在下次查找时可以继续采用比较`last_pid`是否小于`next_safe`从而快速找到一个可用的pid。具体做法是：
        >   - 首先将`next_safe`置为`MAX_PID`，然后开始遍历PCB链表，若当前PCB的pid小于`last_pid`，则查找下一个PCB，相当于增加当前可用pid的下界
        >   - 若发现当前PCB的pid等于`last_pid`，说明找到了可能的一段连续pid的下界，将`last_pid`加一并与`next_safe`比较，若`last_pid`大于等于`next_safe`说明`next_safe`需要刷新，将其置为`MAX_PID`（当然，在任何时候做`last_pid`加一操作后，都需要检查是否越界，越界则让其返回1），然后重新从头开始遍历
        >   - 若发现当前PCB的pid大于`last_pid`（注意，上一步做了`last_pid`加一操作，故上次导致中断的与旧的`last_pid`相等的PCB->pid现在已经小于`last_pid`，被直接跳过），说明可能找到了这一段连续可用pid的上界，这时判断`next_safe`是否大于这一值，若是，则更新`next_safe`为这个值（即上界），否则继续遍历、继续尝试更新`next_safe`，直到循环结束
        >   - 最后若对PCB列表的循环完整进行一次并结束循环后，说明`next_safe`的值已经更新为当前一段连续可用pid的紧的上界，而`last_pid`也已经指向该连续区域的下界，返回`last_pid`作为分配的pid即可
        > - 根据以上分析，可以看到ucore给每个新fork的线程分配的pid一定是唯一的，当然，这里需要注意因为涉及对全局静态变量的更新，因此应该屏蔽中断，以避免出现同步方面的问题

### 练习5.3 阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现

1. **原理简述**
    1. `proc_run()`函数用来将处理机移交给指定的进程，从而实现将指定进程从就绪态转移至运行态的功能，也即帮助完成处理机调度。其流程如下：
    2. 首先判断目标进程是否就是当前进程`current`，若是则不必执行直接返回
    3. 否则，需要进行进程切换，这要求关闭中断，因此先用`local_intr_save(intr_flag)`保存当前%eflags中与中断状态相关的值并关中断，然后将`current`改为目标进程，并将目标进程的内核栈顶位置赋值给tss中的`esp0`，然后用`lcr3()`更新页表，最后调用`switch_to(&(prev->context), &(next->context))`切换控制流上下文为目标进程，并恢复中断返回，这样随后开始执行的将是目标进程
2. **回答问题**
    1. 在本实验的执行过程中，创建且运行了几个内核线程？
        > - 创建并了两个：首先是被bootloader加载并运行至`proc_init()`被调用的初始内核线程，它在`proc_init()`中被指定了PCB`idle_proc`，随后通过fork自己创建出了第二个内核线程`init_proc`
        > - 之后`idle_proc`转入`cpu_idle()`函数中，专职线程调度，即负责在自己被唤醒时，唤醒另一个就绪的线程；当然，在第一次执行时，它会唤醒`init_proc`，随后`init_proc`开始运行并输出"Hello world!!"
    2. 语句`local_intr_save(intr_flag);....local_intr_restore(intr_flag);`在这里有何作用?请说明理由
        > - 由于在线程切换过程中需要对各寄存器值和堆栈信息进行切换，这一过程是不允许被打断的，否则将无法正确继续执行，因此需要在线程切换前关闭中断，切换完毕后再恢复中断状态
        > - 这里，`local_intr_save(intr_flag);`的目的就是将%eflags中中断相关的值存入`intr_flag`变量中并关闭中断，而`local_intr_restore(intr_flag);`则相反，将已保存的中断状态恢复到%eflags中

## 2. 标准答案对比

1. **练习1** ：
    - 在`alloc_proc()`中，答案在初始化`proc->name`时直接将memset目标大小写为`PROC_NAME_LEN`，这是预设了char类型大小为1 Byte，而且还有一个问题是事实上`proc->name`定义时大小为PROC_NAME_LEN + 1，多出的一位应该作为字符串结尾`\0`；我在实现时用`memset(proc->name, 0, sizeof(char) * (PROC_NAME_LEN + 1))`，不对char大小做预设，同时确保初始化大小与定义大小相同，字符串结尾被初始化为`\0`
2. **练习2** ：
    - 在`do_fork()`中，我在实现时完全没有考虑到同步问题，因此在获取pid并将PCB插入链表过程中并没有关闭中断；但事实上如前所述，`get_pid()`会操作全局变量，若过程中不屏蔽中断可能出现同步方面的问题，所以必须在开始执行前关闭中断；这里根据答案进行了修改
    - 另外，我在实现时没有考虑到`proc->parent`需要在fork时进行指定，这里根据答案进行了修改，加入`proc->parent = current`操作

## 3. 实验知识点分析

1. 进程和PCB：
    - PCB的创建和初始化：在OS原理中对PCB的概念和功能有讲解，但实现中包含了更多细节
    - PCB保存的信息：在OS原理中只是笼统提出了需要保存的信息类型，在实验中涉及实现细节，如context，tf等，均有其存在的必要性和在实现中的功能
2. 进程创建：
    - 第一个内核线程的创建：第一个内核线程事实上就是kernel初始化时的线程本身，只是在实现线程初始化时给自己分配了PCB，这在OS原理中没有讲到
    - 基于fork的内核线程创建：基于fork实现，在OS原理中有讲解
    - 唯一pid的获取：在OS原理中只说到pid唯一，但未提及其具体实现方法，在实验中有涉及
3. 进程启动和切换：
    - 新进程如何启动：类似在练习1问题回答中的分析，一个新线程依次通过context中指定的第一条语句，`forkrets`中跳转到异常返回`trapret`，最后借助`kernel_thread_entry()`通过trapframe中指定的进程入口函数及其参数正常开始执行，这在OS原理中没有涉及
    - 进程切换：基于context的上下文切换实现进程切换，在OS原理中有对应内容

## 4. 未对应知识点分析

1. 五状态模型：实验中没有用到挂起状态
2. 用户线程和轻权进程：ucore中线程通过核心线程实现，因此没有涉及到其他实现方法
3. 进程加载：由于只实现了两个内核线程，因此没有涉及到这一部分内容
4. 进程退出：当前直接调用了`kernel panic`，并没有实现进一步的清理工作
5. 进程等待：由于只实现了两个内核线程，因此没有涉及到这一部分内容
