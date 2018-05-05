# Lab6 实验报告

## 0. 个人信息

- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习6.0 填写已有实验

#### 对已完成的实验1/2/3/4/5的代码改进

1. trap.c
    - 在`trap_dispatch()`中，需要设置时钟中断时每个TICK_NUM cycle时将调用进程调度类的`proc_tick()`函数以进行调度相关的时间感知，同时注释掉之前lab中的代码。实现如下：
        ```c
        if (ticks % TICK_NUM == 0) {
            // print_ticks();
            assert(current != NULL);
            // current->need_resched = 1;
            sched_class_proc_tick(current);
        }
        ```
        【注意】此处实现其实是有问题的，修改方法请参考下文“练习6.1”部分
2. proc.c
    - 在`alloc_proc()`中，需要对新增的若干变量进行初始化如下：
        ```c
        // NEW IN LAB 6
        proc->rq = NULL;
        list_init(&(proc->run_link));
        proc->time_slice = 0;
        // for stride
        skew_heap_init(&(proc->lab6_run_pool));
        proc->lab6_stride = 0;
        proc->lab6_priority = 0;
        ```

#### 迁移结果

在完成上述的迁移和代码更新后，运行`make qemu`有如下结果，可见可以正常运行：

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
kernel panic at kern/process/proc.c:498:
    initproc exit.
...
```

### 练习6.1 使用 Round Robin 调度算法

1. **与lab 5的diff**
    1. init/init.c
        - 新增`sched_init()`用于进程调度的初始化
    2. process/proc.c
        - `alloc_proc()`中对新增进程调度相关变量的初始化
        - 新增`lab6_set_priority()`函数
    3. schedule/
        - 新增default_sched.\[ch\], default_sched_stride_c
        - sched.\[ch\]中新增调度框架相关函数，修改原有`schedule()`函数
    4. syscall/syscall.c
        - 新增`sys_gettime()`
        - 新增`sys_lab6_set_priority()`
    5. trap/trap.c
        - `trap_dispatch()`中，处理时钟中断时调用进程调度类的时间感知

2. **运行结果**
    - 直接执行`make grade`，会发现除了`priority`和`waitkill`外全部通过，但根据实验指导书中说法，`waitkill`不应该未通过。经过检查，可以发现`waitkill`由于多次调用`yield()`导致执行时间很长，超过了测试脚本的`timeout`限制
    - 考虑其原因，应该是由于每个时间片过长，而这是因为在`trap.c::trap_dispatch()`中，对时钟中断的处理方法有问题。我沿用了之前输出“100 ticks”时，判断`ticks`为100整数倍才执行操作。但事实上应该每次时钟中断都执行相应处理，那么修改为如下：
        ```c
        ticks++;
        // if (ticks % TICK_NUM == 0) {
            // print_ticks();
            // current->need_resched = 1;
        assert(current != NULL);
        sched_class_proc_tick(current);
        // }
        ```
    - 再次执行，可以得到如下结果，可见除了`priority`通过了其他所有测试：
        ```gdb
        badsegment:              (3.6s)
        -check result:                             OK
        -check output:                             OK
        divzero:                 (2.6s)
        -check result:                             OK
        -check output:                             OK
        softint:                 (3.1s)
        -check result:                             OK
        -check output:                             OK
        faultread:               (3.2s)
        -check result:                             OK
        -check output:                             OK
        faultreadkernel:         (2.5s)
        -check result:                             OK
        -check output:                             OK
        hello:                   (2.5s)
        -check result:                             OK
        -check output:                             OK
        testbss:                 (2.7s)
        -check result:                             OK
        -check output:                             OK
        pgdir:                   (2.8s)
        -check result:                             OK
        -check output:                             OK
        yield:                   (2.6s)
        -check result:                             OK
        -check output:                             OK
        badarg:                  (2.2s)
        -check result:                             OK
        -check output:                             OK
        exit:                    (2.0s)
        -check result:                             OK
        -check output:                             OK
        spin:                    (2.7s)
        -check result:                             OK
        -check output:                             OK
        waitkill:                (3.5s)
        -check result:                             OK
        -check output:                             OK
        forktest:                (2.9s)
        -check result:                             OK
        -check output:                             OK
        forktree:                (2.7s)
        -check result:                             OK
        -check output:                             OK
        matrix:                  (28.7s)
        -check result:                             OK
        -check output:                             OK
        priority:                (12.8s)
        -check result:                             WRONG
        -e !! error: missing 'sched class: stride_scheduler'
        !! error: missing 'stride sched correct result: 1 2 3 4 5'

        -check output:                             OK
        Total Score: 163/170
        Makefile:314: recipe for target 'grade' failed
        make: *** [grade] Error 1
        ```

3. **回答问题**
    - 请理解并分析sched_calss中各个函数指针的用法，并结合Round Robin 调度算法描述ucore的调度执行过程
        > 1. 各函数指针的用法：
        >    - `void (*init)(struct run_queue *rq)`：用于该调度类的初始化，包括对timer_list的初始化、rq中`max_time_slice`的初始化以及选择需要的调度类实例，并进一步调用调度类实例的`init()`进行其自己的初始化
        >    - `void (*enqueue)(struct run_queue *rq, struct proc_struct *proc)`：用于将一个PCB加入就绪队列rq中
        >    - `void (*dequeue)(struct run_queue *rq, struct proc_struct *proc)`：用于从就绪队列rq中将某个PCB取出
        >    - `struct proc_struct *(*pick_next)(struct run_queue *rq)`：用于从就绪队列中挑选一个就绪的进程用作下一个被切换到的进程
        >    - `void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc)`：用于调度算法的时间感知，时钟中断时会调用该函数，进而对相应的进程的时间片进行操作
        > 2. RR算法调度过程：
        >    - 时钟中断，转入中断处理例程`trap()`，调用`trap_dispatch()`
        >    - `trap_dispatch()`中判断出中断类型为时钟中断，`ticks`递增，若`ticks`达到TICK_NUM整数倍，则对当前进程current执行调度类框架的`sched_class_proc_tick()`，其中会判断当前进程是否为idle，若为idle则直接置其`need_resched`为1并返回，否则，对当前进程调用调度类的时间感知函数`proc_tick()`
        >    - 在RR算法的`proc_tick()`中，会对当前进程的时间片`time_slice`递减，若时间片为0，则置其为需要被调度`proc->need_resched = 1`
        >    - 逐层返回，直到回到`trap()`中，继续执行调度代码，若判断当前进程非内核线程，那么可以调度，先判断当前进程是否已经退出，即`current->flags & PF_EXITING`，若是则直接调用`do_exit()`退出；否则，检查当前进程是否需要被调度，即`current->need_resched`，若是，则调用调度函数`schedule()`进行进程调度
        >    - 在`schedule()`中进程调度，需要保证不被打断，因此要屏蔽中断
        >       - 首先将当前进程的`need_resched`重置，接着判断当前进程是否是就绪/运行态`PROC_RUNNABLE`，若是则将其加入就绪队列，这里调用了`sched_class_enqueue()`，其中RR的`enqueue()`将当前进程插入rq的`run_list`尾，并将其时间片置为合理值（若为0，说明上一次时间片完，则将时间片置为最大时间片）
        >       - 然后调用`sched_class_pick_next()`挑选出下一个要运行的进程，RR的`pick_next()`直接返回`run_list`队首的进程；随后将这个挑选出来的进程从就绪队列拿出，调用`sched_class_dequeue()`，RR的`dequeue()`直接将该进程从链表中删除即可
        >       - 最后调用`proc_run()`进行实际的进程切换，并恢复中断状态，返回
    - 请简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计
        > - 首先需要若干个run_queue队列，每个有自己的优先级，各优先级有着自己的最大时间片，且高优先级时间片小，新进程第一次enqueue时在最高优先级
        > - 每次进程切换时，检查其是否是因为时间片用完而被抢占，若是，则其再次enqueue时进入低一级优先级的队列
        > - pick_next时，在队列内可以使用先来先服务方式顺序进行；在队列间，可以使用固定优先级方式，即先处理高优先级的队列，再处理低优先级的队列（由于高优先级队列中多为交互密集型进程，它们大多时候在sleep等待交互事件，因此大多数情况下也不会导致饥饿发生）

### 练习6.2 实现 Stride Scheduling 调度算法

1. **原理简述**
    1. Stride Scheduling调度算法的基本想法是，类比人走路的样子，有的人步伐(pass)小，有的人步伐大，那么一起行走时，步伐大的人就应该走走停停，多等一等步伐小的人，相应的，步伐小的人就应该多走而少等待。在该算法里，优先级与步伐pass相对应，优先级高的pass小，那么它就有更多执行的机会，而pass大的就应该多等待pass小的进程
    2. 

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

## 2. 标准答案对比

- **练习0** ：
    - 在`trap.c::trap_dispatch()`中，时钟中断时需设置当前进程为需要调度，这里答案用`assert(current != NULL)`确保当前进程存在，我没有加，已经根据答案修正
- **练习2** ：
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
