# Lab7 实验报告

## 0. 个人信息

- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习7.0 填写已有实验

1. **对已完成的实验1/2/3/4/5/6的代码改进**
    - trap.c
        - 在`trap_dispatch()`中，需要设置时钟中断时调用进程调度类的`schede.c::run_timer_list()`函数以进行调度时钟感知，并更新各定时器timer，同时注释掉之前lab中的代码。实现如下：
            ```c
            ticks++;
            assert(current != NULL);
            // sched_class_proc_tick(current);
            run_timer_list();
            break;
            ```
2. **与lab 5的diff**
    1. mm/vmm.[ch]
        - 将原有的`lock`修改为基于`semaphore`实现的同步互斥控制
        - `mm_struct`种新增`locked_by`标识被哪个进程锁定
    2. process/proc.[ch]
        - 增加了`do_sleep()`支持进程休眠
    3. schedule/sched.[ch]
        - 新增了`timer_t`定时器类型，以及初始化定时器函数`timer_init()`，和相关的`add_timer()`, `del_timer()`, `run_timer_list()`
        - 将`sched_class_proc_tick()`改为了static函数，在`run_timer_list()`中屏蔽中断后调用
    4. syscall/syscall.[ch]
        - 新增`sys_sleep()`
    5. sync/
        - 将原有基于x86 原子指令实现的`lock`锁机制改为基于信号量和管程实现的同步互斥机制

### 练习7.1 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题

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

### 练习7.2 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题

1. **原理简述**
    1. Stride Scheduling调度算法的基本想法是类比人走路的样子：
        - 有的人步伐(pass)小，有的人步伐大，那么一起行走时，步伐大的人就应该走走停停，多等一等步伐小的人，相应的，步伐小的人就应该多走而少等待
        - 在该算法里，优先级与步伐pass相对应，优先级高的pass小，那么它就有更多执行的机会，而pass大的就应该多等待pass小的进程
        - 另外还有一个标志“路程”的量，就是stride，进程每次执行都会给其stride累加pass
        - 那么每次挑选就绪进程让其占用CPU运行时，就应该挑选stride最小的进程执行
    2. 每个进程都有自己的优先级priority，而pass根据priority产生。首先需要定义一个常量`BIG_STRIDE`，pass的计算公式就是`BIG_STRIDE / priority`
    3. 在实现层面上，还有两个问题需要考虑：
        1. 效率问题：若每次pick_next时需要遍历列表寻找stride最小的进程，则开销很大，为O(n)量级。因此可以使用优先级队列`skew_heap`实现，那么每次enqueue/dequeue时会有O(log n)的开销，而每次pick_next时直接取出队首元素即可
        2. 溢出问题：stride在不断累加过程中一定存在溢出问题。但是好消息时，我们在比较时取两者差值，stride本身为无符号数，而比较函数中对二者差值的计算结果取为有符号数（事实上unsigned和signed计算方法一样，字节中位表示也相同），那么就可以做到即使较大的stride溢出（无符号数）变为“较小”值，其减去本来较小的stride时的差值（有符号数）有可能仍为正数——当然，这要求二者的差值在一定范围内而不能溢出。那么只需要控制差值大小为int32可以表示的范围即可，也即0x7fffffff. 同时可以证明，`STRIDE_MAX – STRIDE_MIN <= BIG_STRIDE`，那么我们需要做的就是控制`BIG_STRIDE`的范围不超过0x7fffffff

2. **实现方法**
    1. 定义`BIG_STRIDE`：根据上述原理，可以将其定义为0x7fffffff：
        ```c
        #define BIG_STRIDE 0x7fffffff    /* you should give a value, and is 2^31 - 1 */
        ```
    2. init：对run_queue做初始化，包括对`run_list`的初始化、置`proc_num`为0，以及将优先级队列队首置为`NULL`（表示空队列）：
        ```c
        // (1) init the ready process list: rq->run_list
        list_init(&(rq->run_list));
        // (2) init the run pool: rq->lab6_run_pool
        rq->lab6_run_pool = NULL;
        //(3) set number of process: rq->proc_num to 0 
        rq->proc_num = 0;
        ```
    3. enqueue：主要是调用`skew_heap_insert`将PCB加入优先级队列，其余操作与RR相同，包括对时间片的操作等：
        ```c
        // (1) insert the proc into rq correctly
        rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), (compare_f)proc_stride_comp_f);
        // (2) recalculate proc->time_slice
        if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
            proc->time_slice = rq->max_time_slice;
        }
        // (3) set proc->rq pointer to rq
        proc->rq = rq;
        // (4) increase rq->proc_num
        rq->proc_num ++;
        ```
    4. dequeue：调用`skew_heap_remove`将PCB移出优先级队列，同时将`proc_num`减一：
        ```c
        // (1) remove the proc from rq correctly
        rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), (compare_f)proc_stride_comp_f);
        rq->proc_num --;
        ```
    5. pick_next：若当前队列为空，即队首为`NULL`，则直接返回`NULL`（进而执行idle）；否则返回优先级队列队首的PCB，同时增加其stride值，增量为`pass = BIG_STRIDE / proc->lab6_priority`：
        ```c
        // (1) get a  proc_struct pointer p  with the minimum value of stride
        if (rq->lab6_run_pool == NULL) {
            return NULL;
        }
        struct proc_struct * proc = le2proc(rq->lab6_run_pool, lab6_run_pool);
        // (2) update p's stride value: p->lab6_stride
        proc->lab6_stride += BIG_STRIDE / proc->lab6_priority;
        // (3) return p
        return proc;
        ```
    6. proc_tick：与RR相同，针对时间片进行递减和判零：
        ```c
        if (proc->time_slice > 0) {
        proc->time_slice --;
        }
        if (proc->time_slice == 0) {
            proc->need_resched = 1;
        }
        ```
    7. 在进行上述全部修改后，执行`make grade`可以看到通过了全部测试（注意，有时`make grade`时可能会出现priority无法通过的情况，此时可以通过`make run-priority`查看结果；或者尝试重复运行`make grade`）：
        ```gdb
        badsegment:              (2.9s)
        -check result:                             OK
        -check output:                             OK
        divzero:                 (2.3s)
        -check result:                             OK
        -check output:                             OK
        softint:                 (2.6s)
        -check result:                             OK
        -check output:                             OK
        faultread:               (2.7s)
        -check result:                             OK
        -check output:                             OK
        faultreadkernel:         (2.2s)
        -check result:                             OK
        -check output:                             OK
        hello:                   (2.4s)
        -check result:                             OK
        -check output:                             OK
        testbss:                 (2.7s)
        -check result:                             OK
        -check output:                             OK
        pgdir:                   (2.9s)
        -check result:                             OK
        -check output:                             OK
        yield:                   (2.7s)
        -check result:                             OK
        -check output:                             OK
        badarg:                  (3.0s)
        -check result:                             OK
        -check output:                             OK
        exit:                    (2.6s)
        -check result:                             OK
        -check output:                             OK
        spin:                    (2.7s)
        -check result:                             OK
        -check output:                             OK
        waitkill:                (3.2s)
        -check result:                             OK
        -check output:                             OK
        forktest:                (2.1s)
        -check result:                             OK
        -check output:                             OK
        forktree:                (2.6s)
        -check result:                             OK
        -check output:                             OK
        matrix:                  (26.5s)
        -check result:                             OK
        -check output:                             OK
        priority:                (13.3s)
        -check result:                             OK
        -check output:                             OK
        Total Score: 170/170
        ```

## 2. 标准答案对比

- **练习0** ：
    - 在`proc.c::alloc_proc()`中，答案对`lab6_priority`初始化为0，这导致其在实现stride算法时还需要对priority为0的情况进行特判。但事实上，根据stride算法的原理，priority的初值直接置为1更合理，我是按照这种方法实现的
    - 此外，对于`lab6_run_pool`的初始化，答案直接操作了其成员变量，我则调用了`skew_heap_init()`进行初始化
- **练习2** ：
    - 首先一个不同之处是，答案还实现了使用list的方式，但我只实现了优先级队列
    - 如前所述，答案由于对priority初始化为0，因此需要在pick_next时计算pass过程中对priority是否为0进行特判；但我因为初始化为1，因此不需要这一步

## 3. 实验知识点分析

1. 调度框架
    - 使用类似面向对象的编程方法实现了与实现无关的调度框架，其基本操作类型与OS原理中所讲述的类似，但具体实现技巧在OS原理中没有涉及
2. RR调度算法
    - 原理在OS原理课中有所讲述
3. Stride调度算法
    - 基本思想在OS原理课中有所讲授
    - 具体实现上，通过论文和实验指导书进行指导，在原理课上没有过多展开

## 4. 未对应知识点分析

1. 实时调度
2. 多处理器调度
3. 优先级反置问题
