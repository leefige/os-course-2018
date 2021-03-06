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
可见在执行`kernel_execve: pid = 2, name = "exit".`对应语句时触发了General Protection异常，经检查是在执行`user_main()`欲加载`exit`用户程序时触发，通过输出，确认在syscall过程中没有异常，于是确定是因为`load_icode()`尚未填写完全导致执行用户进程出错，这正是练习1中的内容

### 练习5.1 加载应用程序并执行

1. **原理简述**
    1. lab 4中，第二个内核线程仅仅实现了输出"Hello world"的功能，而在本实验中，这一进程被用来创建用户进程，方法是调用`kernel_thread(user_main, NULL, 0)`以`user_main()`作为用户进程的主函数
    2. 在本实验中，由于还未实现文件系统，因此加载应用程序只能将全部应用程序都编译并写入内存，加载时根据其elf信息再将目标程序拷贝至用户程序的目标内存位置，这里使用了一个tricky的方法，即在`user_main()`中调用定义好的宏`KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE)`来加载目标应用程序`TEST`，在一系列调用后会执行`kernel_execve(const char *name, unsigned char *binary, size_t size)`函数，其中调用了`SYS_exec`的系统调用，实现了对应用程序的加载
    3. `SYS_exec`系统调用对应的处理例程为`do_execve()`，其流程如下：
        1. 检测当前进程已有的`mm`
        2. 对旧`mm`的清理，包括清理映射关系、释放页表、`mm`销毁
        3. 调用`load_icode()`读取应用程序的二进制文件到内存中的适当位置
        4. 给进程重命名为指定的进程名，并返回；由于这里是系统调用，故返回会进一步触发中断返回，这会让进程从trapframe中重新加载%eip等寄存器，并从新加载的应用程序的入口开始执行
    4. 本练习中主要需要补充的部分在`load_icode()`中，`load_icode()`包括以下流程：
        1. 新建`mm`，新建页目录表，注意，在新建页目录表时，已经将内核页目录表即`boot_pgdir`拷贝到新页目录表中（当然也重建了页表自映射），并将`mm`的`pgdir`成员设置为该新建的页目录表
        2. 读取指定的elf文件，并对各代码段依次建立vma，分配物理页，并拷贝至目标物理内存
        3. 对应用程序的bss段进行初始化
        4. 建立用户栈空间，即建立USERSTACK在`mm`中的映射
        5. 将上面建立的`mm`赋值给当前进程，同时重新加载%cr3为当前进程的页目录表
        6. 建立用户进程的trapframe，这是本练习需要完成的部分，其目的是设置用户进程转入执行时需要拥有的状态，如各段寄存器值、栈顶位置、中断状态，尤其是%eip需要设置为应用程序elf文件中指定的入口`elf->e_entry`
        7. 加载完毕，返回

2. **实现方法**
    - 主要需要实现对用户进程trapframe的初始化，将段寄存器设置为用户值，将%esp设置为用户栈顶，将%eip设置为应用程序入口，并开启用户进程的中断，实现方法如下：
        ```c
        tf->tf_cs = USER_CS;
        tf->tf_ds = USER_DS;
        tf->tf_es = USER_DS;
        tf->tf_ss = USER_DS;
        tf->tf_esp = USTACKTOP;
        tf->tf_eip = elf->e_entry;
        tf->tf_eflags |= FL_IF;     // enable intr
        ```
    - 完成后，运行`make qemu`可以看到如下结果，可见已经成功在用户进程中加载了目标代码（`exit`），并且父进程代码执行顺利，直到父进程进入等待状态转而执行子进程时，触发了无法处理的Page Fault，这是由于父进程利用系统调用fork产生子进程的代码尚未补完，这涉及到练习2相关内容：
        ```gdb
            ...
            ++ setup timer interrupts
            kernel_execve: pid = 2, name = "exit".
            I am the parent. Forking the child...
            I am parent, fork a child pid 3
            I am the parent, waiting now..
            not valid addr 0, and  can not find it in vma
            trapframe at 0xc039cfb4
            edi  0x00000000
            esi  0xafffffa8
            ebp  0xafffff6c
            oesp 0xc039cfd4
            ebx  0x00801320
            edx  0xafffff88
            ecx  0x008001c3
            eax  0x00000000
            ds   0x----0023
            es   0x----0023
            fs   0x----0000
            gs   0x----0000
            trap 0x0000000e Page Fault
            err  0x00000004
            eip  0x008000fd
            cs   0x----001b
            flag 0x00000202 IF,IOPL=0
            esp  0xafffff40
            ss   0x----0023
            killed by kernel.
            kernel panic at kern/trap/trap.c:218:
                handle user mode pgfault failed. ret=-3
        ```

3. **回答问题**
    - 描述创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。
        > 1. 假设该进程是被刚刚创建出来的新进程，那么在该用户态进程被ucore选择占用CPU执行（进入RUNNING态）后，首先通过切换context从其context中恢复出%eip的值，这个值是在`copy_thread()`中设置好的`proc->context.eip = (uintptr_t)forkret`
        > 2. `forkret()`中调用`forkrets()`，进而通过`__trapret()`利用trapframe中断返回
        > 3. 若该进程由用户进程fork得来，那么trapframe中%eip值为父进程执行到fork语句的下一条指令，子进程fork后拥有和父进程相同的代码和数据，因此继续从该条指令向下执行父进程代码，直到遇到exec系统调用则加载新应用程序
        > 4. 但是，若该进程由内核线程创建，例如ucore创建第一个用户进程时，则略有不同，这种情况下使用`kernel_thread`创建进程，这一过程中对trapframe进行了一些人为设置，最重要的是将其`tf_eip`设置为`tf.tf_eip = (uint32_t)kernel_thread_entry`，这样，在`__trapret()`利用trapframe中断返回后会先执行`kernel_thread_entry()`，这个函数会进一步调用在trapframe中设置好的参数（用户进程主函数及其参数），如ucore创建的第一个用户进程主函数为`user_main()`，在这一函数中又通过exec系统调用加载真正要执行的用户程序
        > 5. exec系统调用由服务例程`do_execve()`处理，它的执行过程在上面的 **原理简述** 中已有详细说明，而它是通过在内部调用`load_icode()`时更改当前进程的trapframe中的tf_eip：`tf->tf_eip = elf->e_entry`，将elf文件给出的入口entry指定为应用程序的入口，进而在系统调用处理完毕、利用trapframe中断返回时，会将这一入口恢复到%eip中，这样%eip就指向了应用程序的第一条指令，并且从这里开始执行

### 练习5.2 父进程复制自己的内存空间给子进程

1. **原理简述**
    1. lab 4中，实现`do_fork()`时在创建PCB、建立子进程的内核栈后，还要调用`copy_mm()`复制父进程的虚拟地址空间，但由于在lab 4中只涉及内核线程，它们共享同一内核虚拟地址空间，因此不需要设置自己的`mm`，故这一步实际什么都没有做；但在lab 5中每个用户进程都有自己独立的虚拟地址空间，因此有着各自的`mm`进行管理，故必须实现`copy_mm()`
    2. `copy_mm()`中首先判断是需要复制还是共享`mm`，当其参数`uint32_t clone_flags`中`CLONE_VM`位置1时，仅仅共享即可，即将目标进程的`mm`指针指向当前进程的`mm`；否则需要复制一份`mm`，如用户程序进行fork系统调用时就是这种情况
    3. 复制时，首先新建一个`mm`，然后调用`setup_pgdir(mm)`对其建立其页表，注意在这里新分配了一个页作为子进程的页目录表，并且将内核页表`boot_pgdir`复制进了新建的页目录表，随后重建页表自映射
    4. 随后为了避免同步问题，首先锁定当前进程的`mm`，然后调用`dup_mmap()`将当前进程的`mm`复制进子进程的`mm`，然后解锁当前进程`mm`，最后对子进程`mm`引用计数加一并返回
    5. 在`dup_mmap()`中主要是对`mm`中管理的`vma`列表进行复制，同时还要对其对应用户虚拟地址所在的页表进行复制（因为上面`setup_pgdir()`只是复制了`boot_pgdir`页目录表，但其用户地址空间的页表并没有复制），这一步通过`copy_range()`实现，这正是本练习所要完成的，其具体步骤为针对每一段连续的用户虚拟地址空间，执行如下步骤：
        1. 调用`get_pte(to, start, 1)`新建一个页表
        2. 调用`alloc_page()`为新页表分配一个物理页
        3. 分别获取当前进程已有页表的虚地址`src_kvaddr = page2kva(page)`和待填充页表的虚地址`dst_kvaddr = page2kva(npage)`
        4. 用`memcpy()`将当前进程的指定页表内容复制到新建的带填充页表中
        5. 将新建页表插入子进程的页目录表中，

2. **实现方法**
    - 练习中需要编码实现的部分其实不多，主要是获取当前进程页表地址和子进程新建页表的地址，随后调用`memcpy()`复制页表内容，最后将新建的页表插入子进程的页目录表即可，实现代码如下：
        ```c
        // (1) find src_kvaddr: the kernel virtual address of page
        uintptr_t src_kvaddr = page2kva(page);
        // (2) find dst_kvaddr: the kernel virtual address of npage
        uintptr_t dst_kvaddr = page2kva(npage);
        // (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
        // (4) build the map of phy addr of  nage with the linear addr start
        ret = page_insert(to, npage, start, perm);
        assert(ret == 0);
        ```
    - 在进行上述全部修改后，执行`make qemu`却遇到`nr_process`的assertion failure，经过检查是因为我在迁移并更新过去代码时，在`do_fork()`中虽然改用了`set_links()`并注释掉了`list_add()`，但没有取消原有的`nr_process++`导致重复了对`nr_process`的操作；修正后，运行`make qemu`可以看到如下结果，可见已经顺利地执行完毕`exit`用户进程，并且通过所有检测，最终init_proc退出，运行结束：
        ```gdb
            ...
            ++ setup timer interrupts
            kernel_execve: pid = 2, name = "exit".
            I am the parent. Forking the child...
            I am parent, fork a child pid 3
            I am the parent, waiting now..
            I am the child.
            waitpid 3 ok.
            exit pass.
            all user-mode processes have quit.
            init check memory pass.
            kernel panic at kern/process/proc.c:480:
                initproc exit.
        ```

3. **回答问题**
    - 简要说明如何设计实现“Copy on Write 机制”，给出概要设计
        > - 基本思路是，fork出子进程时仅复制一份页目录表，但对用户空间里所有虚拟地址空间对应的页表并不实际拷贝内存，而是仅仅通过指针，让子进程的页目录表项指向父进程的页表（即共享方式）
        > - 但是，为了防止父进程和子进程由于后续执行的分歧而对页表进行冲突修改，需要设置父进程的用户空间页表权限均为只读，而其原有的读写权限则冗余保存在`mm`中对应的`vma`里
        > - 当两个进程都以只读方式访问页表时，不会触发任何问题，都可以正常访问；但当任何一个进程试图写某一页表项对应的页时，由于页表均被设为只读，故会触发PAGE FAULT，并进入PAGE FAULT处理例程
        > - 在PAGE FAULT处理中需要根据错误码判断出错类型，若错误类型为“写只读页”，这时检查`vma`中备份的实际R/W类型，若该页实际为可写的，那么说明该页是由于COW而被设为共享的页，那么，为子进程拷贝该页表项所在的页表并将子进程页目录表中对应页目录表项指向该新建的页表，同时为子进程拷贝父进程的被访问页，将子进程的对应页表项指向该页，并将父进程和子进程的这条页表项读写权限恢复正常，结束处理，中断返回

### 练习5.3 阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现

0. **系统调用实现**
    1. 用户进程使用系统调用的方法是通过软中断`int 0x80`指令，进而触发软中断（trap），进入中断处理例程，在中断处理例程中，通过`trap_dispatch()`转到`T_SYSCALL`(0x80)，进而调用`syscall()`
    2. `syscall()`从trapframe提取出用户通过寄存器传入的系统调用参数，并根据系统调用号（如`SYS_exit`等）调用对应的具体系统调用函数（如`sys_exit()`等)，在这个函数中，取出具体系统调用参数并指定合适的类型，最后调用相应的实现系统调用的内核函数（如`do_exit()`等）
1. **fork**：fork由`do_fork()`实现，在lab 4和lab 5中都有对其实现的叙述：
    1. 分配一个新的PCB块
    2. 为PCB建立对应的内核栈kstack
    3. 复制父进程的用户地址空间给子进程
    4. 通过`copy_thread()`为子进程设置好trapframe和context，以便其第一次被调度时能正常执行
    5. 在屏蔽中断的情况下为PCB分配pid，并将PCB插入PCB列表
    6. 设置子进程状态为就绪态，并设置返回值为子进程pid（当然，对于子进程而言，由于其context中%eax被置为0，因此其fork返回值也为0）
2. **exec**：由`do_execve()`实现，流程如下：
    1. 检查指定的进程名指向的内存是否合法
    2. 清理当前进程原有的内存空间，包括将%cr3置为boot_cr3，mm引用计数减一，取消虚实地址映射，清理页目录表，最后销毁mm
    3. 调用`load_icode()`加载用户程序
    4. 重置进程名并返回
3. **wait**：由`do_wait()`实现，流程如下：
    1. 首先判断wait类型，若需要保留被等待进程的退出码，则检查待写入的变量地址是否合法
    2. 根据pid重复检查需要等待的进程（若未指定pid，则为等待所有子进程），若该进程已经退出（成为ZOMBIE态），则将目标进程的退出码写入待写入的变量，并且清理目标进程占用的还未被释放的资源（如PCB）
    3. 若发现目标进程仍在执行，则将当前进程状态设为SLEEP，将其等待状态设为WAIT_CHILD，并调用`schedule()`切换到下一进程，
    4. 下次该进程再次获得CPU并执行时，将继续执行上述循环，随后可能再次被调度，但会循环执行直到目标进程退出
4. **exit**：由`do_exit()`实现，流程如下：
    1. 检查当前进程是否是idle/init，若是，则直接panic
    2. 清理当前进程的用户内存空间，包括将%cr3置为boot_cr3，mm引用计数减一，取消虚实地址映射，清理页目录表，最后销毁mm
    3. 将当前进程状态设为ZOMBIE态，将当前进程exit_code设为系统调用时指定的error_code
    4. 在屏蔽中断状态下，检查当前进程的父进程是否为等待子进程状态，若是，将其唤醒；随后将自己的所有子进程转移为initproc的子进程（当然，在此过程中，若发现当前进程的子进程有ZOMBIE态，且initproc正在等待子进程，那么将initproc唤醒）
    5. 最后调用`schedule()`切换到下一进程
5. **回答问题**
    1. 请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？
        > - fork通过调用`wakeup_proc()`将子进程设置为就绪态
        > - exec只是修改进程对应的用户地址空间内容，不会直接改变进程执行状态
        > - wait在判断被等待的进程还未退出时，会将当前进程状态设置为SLEEP，并调用`schedule()`主动放弃CPU，切换到下一进程
        > - exit会在清理完资源后直接将当前进程状态设置为ZOMBIE，并调用`schedule()`主动切换到下一进程
    2. 请给出ucore中一个用户态进程的执行状态生命周期图（包括执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）
        >```
        >   NULL -- (创建PCB) --> PROC_UNINIT -- (通过fork进行初始化和资源分配) 
        >                                                   |
        >                  |-------------  PROC_RUNNABLE <--|
        >                  |                      ^    ^
        >              (schedule)   |--(schedule)-|    |---- (事件出现) ----|
        >                  |        |                                      |
        >                  |--> PROC_RUNNING -- (wait) --> PROC_SLEEPING --|
        >                           |
        >                           |-- (exit) --> PROC_ZOMBIE
        >```
6. **测试结果**
    - 执行`make grade`，但发现在spin和waitkill用户进程出现WRONG，经过比对标准输出，发现我在时钟中断时仍然输出了`100 ticks`，但标准输出中已经没有该输出，去掉这一输出后再次测试，可见通过了全部测试：
        ```c
        badsegment:              (4.6s)
        -check result:                             OK
        -check output:                             OK
        divzero:                 (2.7s)
        -check result:                             OK
        -check output:                             OK
        softint:                 (2.5s)
        -check result:                             OK
        -check output:                             OK
        faultread:               (2.7s)
        -check result:                             OK
        -check output:                             OK
        faultreadkernel:         (3.2s)
        -check result:                             OK
        -check output:                             OK
        hello:                   (2.8s)
        -check result:                             OK
        -check output:                             OK
        testbss:                 (2.7s)
        -check result:                             OK
        -check output:                             OK
        pgdir:                   (2.5s)
        -check result:                             OK
        -check output:                             OK
        yield:                   (2.6s)
        -check result:                             OK
        -check output:                             OK
        badarg:                  (2.6s)
        -check result:                             OK
        -check output:                             OK
        exit:                    (2.5s)
        -check result:                             OK
        -check output:                             OK
        spin:                    (5.4s)
        -check result:                             OK
        -check output:                             OK
        waitkill:                (14.9s)
        -check result:                             OK
        -check output:                             OK
        forktest:                (2.8s)
        -check result:                             OK
        -check output:                             OK
        forktree:                (2.4s)
        -check result:                             OK
        -check output:                             OK
        Total Score: 150/150
        ```

## 2. 标准答案对比

0. **练习0** ：
    - 在`trap.c::trap_dispatch()`中，时钟中断时需设置当前进程为需要调度，这里答案用`assert(current != NULL)`确保当前进程存在，我没有加，已经根据答案修正
1. **练习1** ：
    - 在`load_icode()`中，在即将完成时需要重新设置trapframe，其中对%eflags的设置，答案直接用了`tf->tf_eflags = FL_IF;`，但我用了`tf->tf_eflags |= FL_IF;`，我认为答案这里实现有问题，会导致其他标志位被覆盖
2. **练习2** ：
    - 在`copy_range()`中，我将源/目的页的地址类型设为`uintptr_t src_kvaddr`，而答案设置为`void * kva_src`，这里两种方法没有实质区别

## 3. 实验知识点分析

1. 系统调用
    - 系统调用的实现过程，包括从执行指令`int 0x80`到中断处理例程中一系列调用最终用合适的参数调用恰当的内核函数执行相应操作的过程，在OS原理中只描述了大致过程，但lab中涉及很详细的实现流程和一些编程技巧
    - 对fork, exec, wait, exit等系统调用的具体实现，OS原理中只讲述了原理和大致过程，实验中涉及具体的实现方法
2. 用户进程：
    - 基于内核线程，通过创建mm实现对用户地址空间的管理：在原理中简单涉及了大致过程，但实验中涉及到详细的实现过程，包括在各个具体时间节点%cr3中的值、每个用户进程的页表中到底包含哪些内容等
    - 加载用户程序：由于没有文件系统，因此直接使用elf加载用户程序，在OS原理中没有涉及
3. 进程状态转换：
    - 通过不同的系统调用，主动切换进程状态：在原理中有所涉及
    - 通过时钟中断，进行进程切换：在原理中有涉及

## 4. 未对应知识点分析

1. 进程优先级控制：原理中有提及，但实验中没有涉及到
