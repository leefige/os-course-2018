# Lab7 实验报告

## 0. 个人信息

- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习7.0 填写已有实验

#### 对已完成的实验1/2/3/4/5/6的代码改进

- trap.c
    - 在`trap_dispatch()`中，需要设置时钟中断时调用进程调度类的`schede.c::run_timer_list()`函数以进行调度时钟感知，并更新各定时器timer，同时注释掉之前lab中的代码。实现如下：
        ```c
        ticks++;
        assert(current != NULL);
        // sched_class_proc_tick(current);
        run_timer_list();
        break;
        ```

### 练习7.1 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题

1. **与lab 6的diff**
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
2. **内核级信号量的设计描述**
    - 等待队列`wait_t`
        - 首先实现了等待队列`wait_t`，用于在信号量实现中，对于不能满足互斥条件而必须等待的进程，将其加入等待队列并休眠从而让出CPU，而不是让其处于“忙等”状态消耗CPU资源
        - 等待队列为一个双向队列，实现在wait.[ch]中，并且提供了初始化、入队、出队等方法
        - 在上述方法基础上，还封装了两个与进程相关联的方法`wait_current_set()`和`wait_current_del()`（以宏的形式），这两个方法作为接口被上层调用，用于将当前进程加入等待队列，或者从等待队列中删除
    - 信号量`semaphore_t`
        - 结构：包含两个量：`value`即信号量的值，表示资源数量，为0时表示条件变量；`wait_queue`即等待队列
        - `down()`：即P()操作，用于“占用”一个信号量，其实现上，若value大于0，则直接对value减一并返回，相当于赋予访问权限；否则，将当前进程阻塞，加入等待队列，并调用`schedule()`让出CPU，当其再次被唤醒时，将自己从等待队列中移除
        - `up()`：即V()操作，用于“释放”一个信号量，具体实现为，取出等待队列队首元素，若为NULL，说明等待队列为空，则直接对value加一并返回；否则，说明有其他进程被该信号量阻塞，那么唤醒该进程（不改变value值）
        - 需要说明的是，上述对value和等待队列的操作均要求为原子操作，因为信号量为内核级实现，因此可以在内部实现上灵活使用关中断/恢复中断的方法，保证不被打断
3. **基于内核级信号量的哲学家就餐问题执行流程**
    - 哲学家就餐问题定义在`check_sync.c`中，入口为`check_sync()`，在该函数中，会分别用信号量和管程测试哲学家就餐问题，这里先讨论信号量实现，管程实现在下一个练习中涉及
    - 问题中定义了三个变量：
        1. `int state_sema[N]`：哲学家状态，可以为{THINK, HUNGRY, EAT}之一
        2. `semaphore_t mutex`，互斥锁，用于对共享变量`state_sema[N]`的互斥保护
        3. `semaphore_t s[N]`：独属于每个哲学家的条件变量，用于标志该哲学家是否能进餐（即是否同时拿到了两只叉子）
    - 对于信号量实现，首先初始化mutex信号量值为1，表示同时只允许1个进程访问state_sema；再将所有s初始化为0，作为条件变量；接着利用`kernel_thread()`产生N个`philosopher_using_semaphore()`内核线程表示N个哲学家
    - 在各哲学家线程函数`philosopher_using_semaphore()`中，循环尝试执行：思考（sleep），取叉子（`phi_take_forks_sema()`），进餐（sleep），放回叉子（`phi_put_forks_sema()`），其中，在取叉子时可能由于没能同时取到两个叉子而被阻塞
    - 在`phi_take_forks_sema()`中，首先获取mutex，接着在state_sema中记录自己为HUNGRY，然后调用`phi_test_sema()`尝试获取叉子：
        - `phi_test_sema()`中，需要做一个判断：自己是否HUNGRY？左右两边是否都没有在EATING？
        - 若满足条件，则将自己的state_sema置为EATING，同时对自己的s调用`up()`使条件变量值变为1
        - 否则返回
    - 随后结束对state_sema的操作，释放mutex；接着尝试能否进餐，即对自己的s调用`down()`：
        - 若在上一步中成功调用了`up()`则此处`down()`可以成功执行，那么返回继续执行，哲学家将sleep以模拟进餐
        - 否则，此处`down()`将因为条件变量s的值为0而被阻塞，哲学家被加入等待队列开始等待，直到条件变量s被满足，进程将被唤醒
    - 进餐结束后，在`phi_put_forks_sema()`中，首先获取mutex，接着在state_sema中记录自己为THINKING，然后分别对左右两位哲学家调用`phi_test_sema()`，即尝试唤醒他们进餐，如果他们中有人为HUNGRY状态，则会类似上面的流程，尝试获取叉子，并随之更新各自的条件变量s，而这会进一步唤醒可能处于各自条件变量s的等待队列的哲学家，从而让他们成功进餐
4. **用户态进程/线程提供信号量机制的设计方案**
    - 可以直接使用已经实现的内核信号量，类似fork，sleep等，将其封装为syscall，提供给用户系统调用接口。但问题是，由于当前内核实现的up，down都需要传入semaphore参数，但这是定义在内核中的类型，用户无法直接使用，这可能会带来一些麻烦
    - 更好的做法是，提供一个更高层次封装的接口，在内核维护所有实际的semaphore，类似进程管理，只给用户提供当前使用的semaphore的id，用户通过这个id，配合其他提供给用户作为系统调用的接口（如获取semaphore的id，对某个id的semaphore进行up/down操作等），实现基于信号量的用户态同步互斥
5. **附：基于信号量的哲学家就餐问题执行结果**
    ```gdb
    I am No.4 philosopher_sema
    Iter 1, No.4 philosopher_sema is thinking
    I am No.3 philosopher_sema
    Iter 1, No.3 philosopher_sema is thinking
    I am No.2 philosopher_sema
    Iter 1, No.2 philosopher_sema is thinking
    I am No.1 philosopher_sema
    Iter 1, No.1 philosopher_sema is thinking
    I am No.0 philosopher_sema
    Iter 1, No.0 philosopher_sema is thinking

    Iter 1, No.2 philosopher_sema is eating
    Iter 1, No.4 philosopher_sema is eating
    Iter 2, No.4 philosopher_sema is thinking
    Iter 1, No.0 philosopher_sema is eating
    Iter 2, No.2 philosopher_sema is thinking
    Iter 1, No.3 philosopher_sema is eating
    Iter 2, No.3 philosopher_sema is thinking
    Iter 2, No.2 philosopher_sema is eating
    Iter 2, No.0 philosopher_sema is thinking
    Iter 2, No.4 philosopher_sema is eating
    Iter 3, No.4 philosopher_sema is thinking
    Iter 2, No.0 philosopher_sema is eating
    Iter 3, No.2 philosopher_sema is thinking
    Iter 2, No.3 philosopher_sema is eating
    Iter 3, No.3 philosopher_sema is thinking
    Iter 3, No.2 philosopher_sema is eating
    Iter 3, No.0 philosopher_sema is thinking
    Iter 3, No.4 philosopher_sema is eating
    Iter 4, No.4 philosopher_sema is thinking
    Iter 3, No.0 philosopher_sema is eating
    Iter 4, No.2 philosopher_sema is thinking
    Iter 3, No.3 philosopher_sema is eating
    Iter 4, No.3 philosopher_sema is thinking
    Iter 4, No.2 philosopher_sema is eating
    Iter 4, No.0 philosopher_sema is thinking
    Iter 4, No.4 philosopher_sema is eating
    No.4 philosopher_sema quit
    Iter 4, No.0 philosopher_sema is eating
    No.2 philosopher_sema quit
    Iter 4, No.3 philosopher_sema is eating
    No.3 philosopher_sema quit
    No.0 philosopher_sema quit
    Iter 1, No.1 philosopher_sema is eating
    Iter 2, No.1 philosopher_sema is thinking
    Iter 2, No.1 philosopher_sema is eating
    Iter 3, No.1 philosopher_sema is thinking
    Iter 3, No.1 philosopher_sema is eating
    Iter 4, No.1 philosopher_sema is thinking
    Iter 4, No.1 philosopher_sema is eating
    No.1 philosopher_sema quit
    all user-mode processes have quit.
    init check memory pass.
    kernel panic at kern/process/proc.c:498:
        initproc exit.
    ```

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
        badsegment:              (5.3s)
        -check result:                             OK
        -check output:                             OK
        divzero:                 (3.7s)
        -check result:                             OK
        -check output:                             OK
        softint:                 (3.6s)
        -check result:                             OK
        -check output:                             OK
        faultread:               (2.3s)
        -check result:                             OK
        -check output:                             OK
        faultreadkernel:         (2.1s)
        -check result:                             OK
        -check output:                             OK
        hello:                   (3.6s)
        -check result:                             OK
        -check output:                             OK
        testbss:                 (2.1s)
        -check result:                             OK
        -check output:                             OK
        pgdir:                   (3.9s)
        -check result:                             OK
        -check output:                             OK
        yield:                   (3.6s)
        -check result:                             OK
        -check output:                             OK
        badarg:                  (3.6s)
        -check result:                             OK
        -check output:                             OK
        exit:                    (3.2s)
        -check result:                             OK
        -check output:                             OK
        spin:                    (3.7s)
        -check result:                             OK
        -check output:                             OK
        waitkill:                (3.9s)
        -check result:                             OK
        -check output:                             OK
        forktest:                (3.6s)
        -check result:                             OK
        -check output:                             OK
        forktree:                (3.5s)
        -check result:                             OK
        -check output:                             OK
        priority:                (15.8s)
        -check result:                             OK
        -check output:                             OK
        sleep:                   (11.7s)
        -check result:                             OK
        -check output:                             OK
        sleepkill:               (3.3s)
        -check result:                             OK
        -check output:                             OK
        matrix:                  (13.3s)
        -check result:                             OK
        -check output:                             OK
        Total Score: 190/190
        ```
3. **附：基于管程&条件变量的哲学家就餐问题执行结果**
    ```gdb
    I am No.4 philosopher_condvar
    Iter 1, No.4 philosopher_condvar is thinking
    I am No.3 philosopher_condvar
    Iter 1, No.3 philosopher_condvar is thinking
    I am No.2 philosopher_condvar
    Iter 1, No.2 philosopher_condvar is thinking
    I am No.1 philosopher_condvar
    Iter 1, No.1 philosopher_condvar is thinking
    I am No.0 philosopher_condvar
    Iter 1, No.0 philosopher_condvar is thinking

    phi_test_condvar: state_condvar[1] will eating
    phi_test_condvar: signal self_cv[1] 
    cond_signal begin: cvp c03a728c, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a728c, cvp->count 0, cvp->owner->next_count 0
    Iter 1, No.1 philosopher_condvar is eating
    Iter 1, No.0 philosopher_condvar is eating
    Iter 1, No.2 philosopher_condvar is eating
    phi_test_condvar: state_condvar[3] will eating
    phi_test_condvar: signal self_cv[3] 
    cond_signal begin: cvp c03a72b4, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a72b4, cvp->count 0, cvp->owner->next_count 0
    Iter 1, No.3 philosopher_condvar is eating
    Iter 1, No.4 philosopher_condvar is eating
    Iter 2, No.2 philosopher_condvar is thinking
    Iter 2, No.0 philosopher_condvar is thinking
    Iter 2, No.1 philosopher_condvar is thinking
    Iter 2, No.4 philosopher_condvar is thinking
    Iter 2, No.3 philosopher_condvar is thinking
    phi_test_condvar: state_condvar[0] will eating
    phi_test_condvar: signal self_cv[0] 
    cond_signal begin: cvp c03a7278, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a7278, cvp->count 0, cvp->owner->next_count 0
    Iter 2, No.0 philosopher_condvar is eating
    phi_test_condvar: state_condvar[2] will eating
    phi_test_condvar: signal self_cv[2] 
    cond_signal begin: cvp c03a72a0, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a72a0, cvp->count 0, cvp->owner->next_count 0
    Iter 2, No.2 philosopher_condvar is eating
    Iter 2, No.3 philosopher_condvar is eating
    Iter 2, No.4 philosopher_condvar is eating
    Iter 2, No.1 philosopher_condvar is eating
    phi_test_condvar: state_condvar[4] will eating
    phi_test_condvar: signal self_cv[4] 
    cond_signal begin: cvp c03a72c8, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a72c8, cvp->count 0, cvp->owner->next_count 0
    Iter 3, No.0 philosopher_condvar is thinking
    Iter 3, No.1 philosopher_condvar is thinking
    Iter 3, No.4 philosopher_condvar is thinking
    Iter 3, No.3 philosopher_condvar is thinking
    Iter 3, No.2 philosopher_condvar is thinking
    phi_test_condvar: state_condvar[3] will eating
    phi_test_condvar: signal self_cv[3] 
    cond_signal begin: cvp c03a72b4, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a72b4, cvp->count 0, cvp->owner->next_count 0
    Iter 3, No.3 philosopher_condvar is eating
    Iter 3, No.2 philosopher_condvar is eating
    Iter 3, No.4 philosopher_condvar is eating
    phi_test_condvar: state_condvar[1] will eating
    phi_test_condvar: signal self_cv[1] 
    cond_signal begin: cvp c03a728c, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a728c, cvp->count 0, cvp->owner->next_count 0
    Iter 3, No.1 philosopher_condvar is eating
    Iter 3, No.0 philosopher_condvar is eating
    Iter 4, No.4 philosopher_condvar is thinking
    Iter 4, No.2 philosopher_condvar is thinking
    Iter 4, No.3 philosopher_condvar is thinking
    Iter 4, No.0 philosopher_condvar is thinking
    Iter 4, No.1 philosopher_condvar is thinking
    phi_test_condvar: state_condvar[3] will eating
    phi_test_condvar: signal self_cv[3] 
    cond_signal begin: cvp c03a72b4, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a72b4, cvp->count 0, cvp->owner->next_count 0
    Iter 4, No.3 philosopher_condvar is eating
    Iter 4, No.2 philosopher_condvar is eating
    Iter 4, No.4 philosopher_condvar is eating
    phi_test_condvar: state_condvar[1] will eating
    phi_test_condvar: signal self_cv[1] 
    cond_signal begin: cvp c03a728c, cvp->count 0, cvp->owner->next_count 0
    cond_signal end: cvp c03a728c, cvp->count 0, cvp->owner->next_count 0
    Iter 4, No.1 philosopher_condvar is eating
    Iter 4, No.0 philosopher_condvar is eating
    No.4 philosopher_condvar quit
    No.2 philosopher_condvar quit
    No.3 philosopher_condvar quit
    No.0 philosopher_condvar quit
    No.1 philosopher_condvar quit
    all user-mode processes have quit.
    init check memory pass.
    kernel panic at kern/process/proc.c:498:
        initproc exit.

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
