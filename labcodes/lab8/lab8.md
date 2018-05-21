# Lab8 实验报告

## 0. 个人信息

- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 练习8.0 填写已有实验

#### 对已完成的实验1/2/3/4/5/6/7的代码改进

- proc.c
    - 在`alloc_proc()`中，需要对PCB中新增的成员`struct files_struct *filesp`进行初始化。实现如下：
        ```c
        // NEW IN LAB8
        proc->filesp = NULL;
        ```

### 练习8.1 完成读文件操作的实现

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
2. **实现方法**
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
3. **回答问题**
    - 设计实现”UNIX的PIPE机制“的概要设方案
        > - 类似前面的信号量，可以直接使用已经实现的内核条件变量机制，将其封装为syscall，提供给用户系统调用接口
        > - 同样，也应该在内核维护所有实际的管程，类似进程管理，只给用户提供当前使用的管程的id，用户通过这个id，配合其他提供给用户作为系统调用的接口（如管程初始化、对管程内某个条件变量执行wait/signal等），实现基于条件变量的用户态同步互斥
        > - 与内核级条件变量机制的异同：
        >     - 相同点：用户级条件变量复用了内核级条件变量的基本实现，只是将其包装成了系统调用
        >     - 不同点：内核级条件变量完全在内核代码实现，内核中各种数据结构可以暴露和直接传递，但用户级条件变量不能直接将内核数据结构暴露给用户，因此需要通过一些封装，类似用户通过pid管理进程一样，可以通过id管理管程；此外，内核线程调用管程&条件变量可以直接使用函数调用，但用户使用基于内核实现的条件变量需要通过系统调用。

### 练习8.2 完成基于文件系统的执行程序机制的实现

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

2. **实现方法**
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
    5. 执行`make qemu`，待执行完哲学家就餐问题测试后，进入shell，分别执行`ls`和`hello`可以看到如下结果：
        ```gdb
        $ ls
        @ is  [directory] 2(hlinks) 23(blocks) 5888(bytes) : @'.'
        [d]   2(h)       23(b)     5888(s)   .
        [d]   2(h)       23(b)     5888(s)   ..
        [-]   1(h)       11(b)    44508(s)   sh
        [-]   1(h)       10(b)    40292(s)   priority
        [-]   1(h)       10(b)    40220(s)   divzero
        [-]   1(h)       10(b)    40208(s)   faultreadkernel
        [-]   1(h)       10(b)    40200(s)   hello
        [-]   1(h)       10(b)    40200(s)   softint
        [-]   1(h)       10(b)    40224(s)   testbss
        [-]   1(h)       10(b)    40332(s)   waitkill
        [-]   1(h)       10(b)    40192(s)   pgdir
        [-]   1(h)       10(b)    40360(s)   ls
        [-]   1(h)       10(b)    40204(s)   badsegment
        [-]   1(h)       10(b)    40228(s)   forktest
        [-]   1(h)       10(b)    40196(s)   spin
        [-]   1(h)       10(b)    40204(s)   faultread
        main-loop: WARNING: I/O thread spun for 1000 iterations
        [-]   1(h)       10(b)    40200(s)   yield
        [-]   1(h)       10(b)    40304(s)   matrix
        [-]   1(h)       10(b)    40252(s)   forktree
        [-]   1(h)       10(b)    40204(s)   sleepkill
        [-]   1(h)       10(b)    40220(s)   sleep
        [-]   1(h)       10(b)    40224(s)   exit
        [-]   1(h)       10(b)    40200(s)   badarg
        lsdir: step 4
        $ hello
        Hello world!!.
        I am process 15.
        hello pass.
        ```
    6. 执行`make grade`可以看到通过了全部测试：
        ```gdb
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        Makefile:277: warning: overriding recipe for target 'disk0'
        Makefile:274: warning: ignoring old recipe for target 'disk0'
        badsegment:              (19.5s)
        -check result:                             OK
        -check output:                             OK
        divzero:                 (4.1s)
        -check result:                             OK
        -check output:                             OK
        softint:                 (3.9s)
        -check result:                             OK
        -check output:                             OK
        faultread:               (2.3s)
        -check result:                             OK
        -check output:                             OK
        faultreadkernel:         (2.1s)
        -check result:                             OK
        -check output:                             OK
        hello:                   (3.5s)
        -check result:                             OK
        -check output:                             OK
        testbss:                 (2.5s)
        -check result:                             OK
        -check output:                             OK
        pgdir:                   (3.1s)
        -check result:                             OK
        -check output:                             OK
        yield:                   (4.2s)
        -check result:                             OK
        -check output:                             OK
        badarg:                  (2.8s)
        -check result:                             OK
        -check output:                             OK
        exit:                    (2.9s)
        -check result:                             OK
        -check output:                             OK
        spin:                    (3.1s)
        -check result:                             OK
        -check output:                             OK
        waitkill:                (4.5s)
        -check result:                             OK
        -check output:                             OK
        forktest:                (3.9s)
        -check result:                             OK
        -check output:                             OK
        forktree:                (5.7s)
        -check result:                             OK
        -check output:                             OK
        priority:                (15.4s)
        -check result:                             OK
        -check output:                             OK
        sleep:                   (12.3s)
        -check result:                             OK
        -check output:                             OK
        sleepkill:               (3.7s)
        -check result:                             OK
        -check output:                             OK
        matrix:                  (11.6s)
        -check result:                             OK
        -check output:                             OK
        Total Score: 190/190
        ```
3. **回答问题**
    - 设计实现基于”UNIX的硬链接和软链接机制“的概要设方案，鼓励给出详细设计方案
        > - 类似前面的信号量，可以直接使用已经实现的内核条件变量机制，将其封装为syscall，提供给用户系统调用接口
        > - 同样，也应该在内核维护所有实际的管程，类似进程管理，只给用户提供当前使用的管程的id，用户通过这个id，配合其他提供给用户作为系统调用的接口（如管程初始化、对管程内某个条件变量执行wait/signal等），实现基于条件变量的用户态同步互斥
        > - 与内核级条件变量机制的异同：
        >     - 相同点：用户级条件变量复用了内核级条件变量的基本实现，只是将其包装成了系统调用
        >     - 不同点：内核级条件变量完全在内核代码实现，内核中各种数据结构可以暴露和直接传递，但用户级条件变量不能直接将内核数据结构暴露给用户，因此需要通过一些封装，类似用户通过pid管理进程一样，可以通过id管理管程；此外，内核线程调用管程&条件变量可以直接使用函数调用，但用户使用基于内核实现的条件变量需要通过系统调用。

## 2. 标准答案对比

- **练习2** ：
    - 在条件变量实现上，答案中从条件变量获取管程时，每次都使用`cvp->owner`，而我在函数一开始就声明了`monitor_t * mt = cvp->owner`，之后使用比较方便
    - 在哲学家就餐问题上，`phi_take_forks_condvar()`中，判断是否已经被置为`state_condvar[i] == EATING`时，我一开始使用了`while`，但答案使用了`if`，事实上ucore实现了Hoare语义的管程，因此可以确保使用if可以完成判断，但若为Mesa语义则需要使用while，这里我已经改为使用if
    - `phi_take_forks_condvar()`中，标准答案在获得叉子后会有一句输出，这里我没有输出信息

## 3. 实验知识点分析

1. 信号量
    - 实现了定时器，并在此基础上实现了sleep进程休眠，这在OS原理中没有过多涉及
    - 等待队列，在OS原理中有原理性讲解，但没有牵扯实现细节
    - 信号量，与OS原理中讲解思路大致相同，但实验中，保证sem的value恒为非负，将执行P()时所有可能导致value为负值的操作都直接转化为加入等待队列；相应的，当执行V()时，若等待队列非空则不增加value值
2. 管程&条件变量
    - 原理在OS原理课中有所讲述，但实现上与原理稍有不同，这里在已经实现的信号量基础上实现了管程
    - 通过一些trick实现了Hoare语义的管程，在OS原理中有所讲解
3. 同步互斥问题
    - 以哲学家就餐问题为例，实现了对同步互斥问题的解决
    - 实验中利用信号量和管程实现了两种版本对上面问题的解决方法，在OS原理中有讲解该问题，但实现思路有所不同，原理中通过安排奇偶号哲学家拿叉子顺序解决了问题

## 4. 未对应知识点分析

1. 进程间通信
2. 死锁&死锁检测/预防/解决
3. 其他同步互斥解决办法，如Peterson算法等
4. 其他类型的锁，如自旋锁（之前lab中通过x86原子操作实现，但在lab7中移除）
