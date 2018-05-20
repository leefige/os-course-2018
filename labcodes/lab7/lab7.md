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

### 练习7.2 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题

1. **原理简述**
    1. 条件变量`condvar_t`
        - 条件变量对应于一项条件及其等待队列，需要该条件变量的进程，当条件变量满足时进程继续执行；但不满足时，将进入该条件变量的等待队列并阻塞，直到条件再次满足将被唤醒
        - 本实验中，条件变量基于信号量实现，每个条件变量包含一个信号量`sem`（拥有自己的value和等待队列，这个等待队列也就是条件变量cv的等待队列），和一个等待该条件变量的进程计数`count`，初始化时，信号量值为0；此外信号量还有一个指向宿主管程moniter的指针`owner`
    2. 管程`moniter_t`
        - 管程是对一组共享变量、条件变量和互斥访问函数的封装，一般为语言级特性，用于简化并行编程，相比直接使用信号量，更加模板化
        - moniter包含以下组分：
            - 互斥锁mutex：用于在执行任一管程内函数时控制互斥访问，其值初始化为1
            - 条件变量数组cv：用于管程中的条件控制，可以包含若干个信号量
            - 信号量next：用于在唤醒其他进程时锁定自身，后面会讨论其意义
            - 计数next_count：由于发出singal而睡眠的进程个数
        - 管程提供两个方法：
            - `cond_wait()`：用于针对管程中某个条件变量cv，让一个进程在该条件变量不满足时阻塞在cv的等待队列中，阻塞是通过调用条件变量cv中包含的信号量sem的`down()`方法实现的；在调用`down()`之前，需要判断宿主管程的`next_count`，若其大于零，说明有其他因为唤醒当前进程而进入阻塞的进程，那么对`next`调用`up()`，直接唤醒那个进程；否则，直接对`mutex`调用`up()`，释放互斥锁，允许其他等待进入管程的进程进入
            - `cond_signal()`：用于针对管程中某个条件变量cv，让其通知阻塞在cv的等待队列中的进程，若cv的`count`为0，说明等待队列为空，那么什么都不做；否则，通过调用条件变量cv中包含的信号量sem的`up()`方法释放该信号量（相当于通知等待该信号量的进程，将其唤醒并加入就绪队列），随后将自身阻塞在moniter的`next`
            - 当然，上述两个方法都有可能涉及阻塞自身，那么在再次被唤醒后（即`down()`的下一条代码），需要对相应的等待计数做减一操作
    3. 管程同步互斥控制原理：
        - 管程的执行过程是，在定义好一个管程（包括其包含的所有条件变量）后，对任一需要用管程保护的互斥访问函数，都在其入口获取管程mt的mutex以阻止其他进程进入管程，并在结束访问的出口处释放互斥锁（注意，本实验中由于`next`的存在，不一定直接释放mutex，也有可能会释放next，这将随后说明），这就形成了管程的互斥保护模板，方便编程；进程和管程的关系有如下三种：
            - 唯一在管程中执行被管程保护的函数的进程，它占有了互斥锁mutex
            - 试图进入管程，但管程的mutex正被其他进程占用的进程，它们在管程外排队，处于mutex的等待队列中
            - 已经进入管程，但在被管程保护的函数内部由于不满足条件变量而阻塞在条件变量的等待队列中的进程，它们已经“通过”了mutex，可以看作位于管程内，但并没能执行管程的函数，而是在等待被其他进入管程的进程（可能在执行，可能在其他条件变量等待队列中）唤醒
        - 因为存在上面说到的第三种进程，即阻塞在管程内条件变量上的进程，于是出现了管程语义上的分歧：
            - Mesa语义的管程，在用signal唤醒阻塞在条件变量的进程后，当前进程并没有立刻放弃mutex，那么可能导致在这期间由于进程调度，刚被唤醒的进程进入running态试图获取mutex继续执行，但失败，于是直接退出管程并阻塞在mutex处排队，这就让它从第一个要执行的进程变成了最后一个要执行的进程
            - Hoare语义的管程，在用signal唤醒阻塞的进程后，当前进程并不释放互斥锁，而是通过某种方法直接将互斥访问权限“传递”给被唤醒进程，这就保证了在进程切换时若切换到刚被唤醒的进程，那么它可以直接开始执行而不会出现Mesa语义中被mutex阻塞的情况
        - 进而可以理解本实验中`next`的作用：
            - 当前进程发送signal时，若发现信号量有其他进程在排队，需要唤醒其他进程、并阻塞自己时，会将自己阻塞在管程的next信号量上
            - 进程执行wait时，若发现有进程阻塞在next上，说明该进程在被唤醒时有其他进程阻塞了自身，它就在next等待队列中，那么不释放mutex，即阻止了在管程外排队获取mutex的进程进入管程，而是对next执行up，唤醒之前的进程；否则，说明已经没有进程在排队等待这个条件变量，那么直接释放mutex
            - 类似的，在函数出管程的例行模板里，也要执行上面的判断，从而选择释放mutex还是释放next
    4. 基于管程的哲学家就餐问题
        - 类似地，定义了表示哲学家状态的数组`int state_condvar[N]`，此外还定义了一个管程mt，对mt初始化时设置了N个条件变量，分别表示每个哲学家是否同时拿到了两只叉子
        - 
2. **基于内核级条件变量的哲学家就餐问题执行流程**
    - 哲学家就餐问题定义在`check_sync.c`中，入口为`check_sync()`，在该函数中，会分别用信号量和管程测试哲学家就餐问题，这里讨论管程&条件变量实现
    - 问题中定义了两个变量：
        1. `int state_condvar[N]`：哲学家状态，可以为{THINK, HUNGRY, EAT}之一
        2. 管程`monitor_t * mtp`，对mt初始化时设置了N个条件变量，分别表示每个哲学家是否同时拿到了两只叉子
    - 初始化时，利用`kernel_thread()`产生N个`philosopher_using_condvar()`内核线程表示N个哲学家，在各哲学家线程函数`philosopher_using_semaphore()`中，循环尝试执行：思考（sleep），取叉子（`phi_take_forks_condvar()`），进餐（sleep），放回叉子（`phi_put_forks_condvar()`），其中，在取叉子时可能由于没能同时取到两个叉子而被阻塞
    - 在`phi_take_forks_condvar()`中，依据惯例先获取mutex，在退出时释放mutex/next。函数体中，在state_condvar中记录自己为HUNGRY，然后调用`phi_test_condvar()`尝试获取叉子：
        - `phi_test_condvar()`中，需要做一个判断：自己是否HUNGRY？左右两边是否都没有在EATING？
        - 若满足条件，则将自己的state_sema置为EATING，同时对属于自己的条件变量调用`cond_signal()`，否则返回
        - 【注意】根据管程的实现，若本身并没有被阻塞（当进程自己执行到signal时，一定满足这个条件），则无事发生，直接继续执行，哲学家进餐

        随后返回`phi_take_forks_condvar()`，判断state_condvar是否为EATING，若是，说明上一步成功取得了两个叉子，那么继续执行，即进餐；否则说明没有取得叉子，于是在自己的条件变量`mtp->cv[i]`上阻塞，等待被唤醒
    - 进餐结束后，在`phi_put_forks_condvar()`中，依据惯例先获取mutex，在退出时释放mutex/next。函数体中，在state_condvar中记录自己为THINKING，然后分别对左右两位哲学家调用`phi_test_condvar()`，即尝试把叉子交给他们，如果他们中有人为HUNGRY状态，则会类似上面的流程，尝试获取叉子，并调用`cond_signal()`，但这里不同的是，目标哲学家并不是当前进程，他们有可能正被阻塞，因此可以被唤醒进而进餐

3. **实现方法**
    1. 实现`cond_signal()`：根据上述原理及相关注释，实现如下：
        ```c
        if(cvp->count > 0) {
            monitor_t * mt = cvp->owner;
            mt->next_count ++;
            up(&(cvp->sem));
            down(&(mt->next));
            // after woken up
            mt->next_count--;
        }
        ```
    2. 实现`cond_wait()`：根据上述原理及相关注释，实现如下：
        ```c
        cvp->count ++;
        monitor_t * mt = cvp->owner;
        if(mt->next_count > 0) {
            up(&(mt->next));
        }
        else {
            up(&(mt->mutex));
        }
        down(&(cvp->sem));
        // after woken up
        cvp->count --;
        ```
    3. 实现`phi_take_forks_condvar()`：根据上述原理及相关注释，实现如下(不含进出管程的例程)：
        ```c
        // I am hungry
        // try to get fork
        state_condvar[i] = HUNGRY; /* 记录下哲学家i饥饿的事实 */
        phi_test_condvar(i); /* 试图得到两只叉子 */
        if (state_condvar[i] != EATING) {
            cond_wait(&(mtp->cv[i]));
        }
        ```
    4. 实现`phi_put_forks_condvar()`：根据上述原理及相关注释，实现如下(不含进出管程的例程)：
        ```c
        // I ate over
        // test left and right neighbors
        state_condvar[i] = THINKING; /* 哲学家进餐结束 */
        phi_test_condvar(LEFT); /* 看一下左邻居现在是否能进餐 */
        phi_test_condvar(RIGHT); /* 看一下右邻居现在是否能进餐 */
        ```
    5. 在进行上述全部修改后，执行`make grade`可以看到通过了全部测试：
        ```gdb
        badsegment:              (3.8s)
        -check result:                             OK
        -check output:                             OK
        divzero:                 (3.1s)
        -check result:                             OK
        -check output:                             OK
        softint:                 (3.0s)
        -check result:                             OK
        -check output:                             OK
        faultread:               (1.7s)
        -check result:                             OK
        -check output:                             OK
        faultreadkernel:         (1.4s)
        -check result:                             OK
        -check output:                             OK
        hello:                   (2.8s)
        -check result:                             OK
        -check output:                             OK
        testbss:                 (1.7s)
        -check result:                             OK
        -check output:                             OK
        pgdir:                   (3.1s)
        -check result:                             OK
        -check output:                             OK
        yield:                   (3.1s)
        -check result:                             OK
        -check output:                             OK
        badarg:                  (3.1s)
        -check result:                             OK
        -check output:                             OK
        exit:                    (2.9s)
        -check result:                             OK
        -check output:                             OK
        spin:                    (3.1s)
        -check result:                             OK
        -check output:                             OK
        waitkill:                (4.1s)
        -check result:                             OK
        -check output:                             OK
        forktest:                (2.9s)
        -check result:                             OK
        -check output:                             OK
        forktree:                (3.3s)
        -check result:                             OK
        -check output:                             OK
        priority:                (16.2s)
        -check result:                             OK
        -check output:                             OK
        sleep:                   (12.5s)
        -check result:                             OK
        -check output:                             OK
        sleepkill:               (3.1s)
        -check result:                             OK
        -check output:                             OK
        matrix:                  (12.1s)
        -check result:                             OK
        -check output:                             OK
        Total Score: 190/190

        ```

## 2. 标准答案对比

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
