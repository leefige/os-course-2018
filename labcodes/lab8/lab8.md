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
    - 在`do_fork()`中，需要复制父进程的`filesp`，根据已经给出的代码，`bad_fork_cleanup_fs`在`bad_fork_cleanup_kstack`之前，故`copy_files`应该在`setup_kstack`之后操作，只需要加入如下内容：
        ```c
        //    2.5 copy files
        if (copy_files(clone_flags, proc) != 0) {
            goto bad_fork_cleanup_kstack;
        }
        ```

### 练习8.1 完成读文件操作的实现

1. **原理简述**
    1. 读写文件的实现基于对低层设备等的抽象接口，实验框架使用四个层次：最顶层为面向用户程序的接口，通过系统调用，以文件描述符为基础为用户提供文件操作；第二层为虚拟文件系统VFS，用于封装实际文件系统的实现细节，为kernel和系统调用提供文件操作接口；第三层为实际文件系统，实验中使用SFS实现；第四层为设备层，对各种不同设备（如stdin, stdout, 磁盘）等进行统一的抽象。具体到磁盘设备，本实验对磁盘做了简化处理，用block取代sector作为存储的基本单位。
    2. lab 8中，读写文件的具体操作实现在`sfs_inode.c`中，函数为`sfs_read()`和`sfs_write()`，而它们又进一步调用了统一接口`sfs_io()`，这个函数通过一个`write`参数确定时读还是写，在内部，该函数在控制互斥的基础上，调用`sfs_io_nolock()`函数。本练习主要在该函数中实现读文件的操作
    3. `sfs_io_nolock()`的参数包括目标buffer（读/写均使用buffer），起始字节位置offset，目标读写长度指针alenp。包含以下流程：
        1. 计算结束位置endpos
        2. 根据读/写类型，将两个直接操作block/buffer的函数指针分别定义为读操作/写操作
        3. 将读取内容划分为以块为单位，这样会得到最前端不成块的部分和最尾端不成块的部分，而中间部分均为成块数据，这样对于中间部分可以直接以block为单位操作，而两端则以buffer形式操作
        4. 按照前端buffer，中段blocks和后端buffer顺序，分别将字节流读入目标buffer中（或从目标buffer写入文件），计算实际读/写字节数，最后返回这个数量
2. **实现方法**
    - 主要是实现上述按照三个部分分别操作的流程：
        1. 最前端的buffer
            ```c
            // (1) If offset isn't aligned with the first block, Rd/Wr some content from offset to the end of the first block
            blkoff = offset % SFS_BLKSIZE;
            if (blkoff != 0) {
                // Rd/Wr size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset)
                size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
                if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
                    goto out;
                }
                if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
                    goto out;
                }
                alen += size;
                // if nothing left
                if (nblks == 0) {
                    goto out;
                }
                // else, update buf pos
                buf += size;
                blkno++;
                nblks--;
            }
            ```
        2. 中部的blocks
            ```c
            // (2) Rd/Wr aligned blocks 
            size = SFS_BLKSIZE;
            while (nblks > 0) {
                if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
                    goto out;
                }
                if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
                    goto out;
                }
                alen += size;
                // update buf pos
                buf += size;
                blkno++;
                nblks--;
            }
            ```
        3. 后端的buffer
            ```c
            // (3) If end position isn't aligned with the last block, Rd/Wr some content from begin to the (endpos % SFS_BLKSIZE) of the last block
            size = endpos % SFS_BLKSIZE;
            if (size != 0) {
                if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
                    goto out;
                }
                if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
                    goto out;
                }
                alen += size;
            }
            ```
3. **回答问题**
    - 设计实现”UNIX的PIPE机制“的概要设方案
        > - 首先，pipe是一种文件，因此也要又有自己的inode；其次，pipe本质上是一个buffer，且类似生产者-消费者问题，存在等待与唤醒的机制
        > - 向上，pipe向用户提供入端和出端，那么pipe需要维护两个文件描述符fd，入端只写，出端只读，用户调用时，通过系统调用获取这两个文件描述符
        > - 此外，需要考虑同步互斥问题，入端和出端不能同时执行read和write操作，同一时间点只能有一方在操作pipe，另一方要么在休眠等待，要么已经结束操作关闭了pipe；一方操作结束后，或者关闭pipe时，需要唤醒另一方
        > - 具体实现上，类似生产者-消费者问题，出端读取时，若要读的字节数不大于buffer字节数，则直接读取指定数量；若大于，则读取buffer大小的字节数，此时若入端还未关闭，那么出端休眠等待，唤醒入端继续写入buffer，否则直接返回这么多大小的字节数，结束读取；类似的，入端写入时，若写满了/写完了，则休眠等待（或关闭pipe），唤醒出端读取，当然，如果出端已经关闭，则直接返回

### 练习8.2 完成基于文件系统的执行程序机制的实现

1. **原理简述**
    1. 基于文件系统的exec
        - 之前实现的exec是将所有用户进程生成为elf格式二进制文件并放入内存，在实际执行exec时，使用tricky的手段通过文件名将其二进制文件按elf不同字段加载到用户进程的地址空间，并通过trapframe返回
        - 本实验中，总体思路不变，但是不同之处在于并不会将二进制文件直接加载到内存中，而是存放于磁盘上，通过文件系统提供的读操作读取，并按照之前的方法加载到用户地址空间
        - 此外，本实验支持了一个简单的shell，因此需要支持通过命令行给用户进程传递参数，这要求在执行用户进程时构造必要的调用栈，并正确地push参数
    2. 读取文件写入用户地址空间`load_icode()`
        - 实验中只给出了注释，看起来实现非常复杂，但事实上大部分与之前实验内容相同，只有注释中描述的第三步即读取elf二进制文件并复制到用户空间部分需要修改
        - 读取操作使用已经提供的`load_icode_read()`方法，传入参数为指定的文件描述符fd，目标地址，和读取大小；先读取elf头，再根据elf头中的信息依次读取各代码段并用`mm_map()`在用户地址空间建立vma映射关系，接着分配实际物理页，将代码段/数据段内容读入内存；最后为bss段分配空间并初始化，这里和之前实验操作相同
        - 需要注意的是，在读取结束后，应该用`sysfile_close(fd)`关闭文件
    3. 建立栈并调用用户进程：
        - 栈本身的建立和之前实验相同，需要做的是如何在栈上正确压入命令行参数，即注释中的第6步
        - 在这里，获得的参数为argc和kargv，存放在内核空间，我们需要将他们合理布局（拷贝）到用户空间，kargv为指针数组
        - 根据`user/libs/initcode.S`即用户进程入口，在调用该入口前，%esp指向的内容应该是`int argc`，%esp+4内存单元内容应该是`char** argv`，即argv字符串数组的首地址（字符串可以理解为char\*类型）。但argv中各字符串本身长度是不等的，它们应该集中、连续存放在某处，前面说到的作为argv参数传入的数组，应该是char\*指针类型的数组，每个元素大小为指针类型大小，其指向的是实际字符串的首地址
        - 于是，在构造栈上参数时，执行以下步骤：
            1. 依argc循环统计kargv指向的全部参数的大小argv_size
            2. 在用户栈顶高地址区，将kargv指向的全部字符串参数`strcpy`到这一空间
            3. 将`strcpy`返回的目标字符串地址（首地址）依次写入上面这块空间下方的内存单元，依惯例uargv[0]在低地址
            4. 最后将argc写入uargv下方的一个内存单元，并将这里作为用户栈栈顶，写入trapframe的`%esp`

2. **实现方法**
    1. `load_icode()`中读取elf文件并加载到用户空间：如前所述，基本框架以之前的lab为主，只是改为了使用文件系统提供的读函数读取文件，改动部分如下：
        ```c
        // (3) copy TEXT/DATA/BSS parts in binary to memory space of process
        struct Page *page;
        struct elfhdr __elf, *elf = &__elf;

        //  *    (3.1) read raw data content in file and resolve elfhdr
        if ((ret = load_icode_read(fd, elf, sizeof(struct elfhdr), 0)) != 0) {
            goto bad_elf_cleanup_pgdir;
        }

        if (elf->e_magic != ELF_MAGIC) {
            ret = -E_INVAL_ELF;
            goto bad_elf_cleanup_pgdir;
        }

        //  *    (3.2) read raw data content in file and resolve proghdr based on info in elfhdr
        struct proghdr __ph, *ph = &__ph;
        uint32_t vm_flags, perm, phnum;
        for (phnum = 0; phnum < elf->e_phnum; phnum ++) {
            off_t phoff = elf->e_phoff + sizeof(struct proghdr) * phnum;
            // read
            if ((ret = load_icode_read(fd, ph, sizeof(struct proghdr), phoff)) != 0) {
                goto bad_cleanup_mmap;
            }
            if (ph->p_type != ELF_PT_LOAD) {
                continue ;
            }
            if (ph->p_filesz > ph->p_memsz) {
                ret = -E_INVAL_ELF;
                goto bad_cleanup_mmap;
            }
            if (ph->p_filesz == 0) {
                continue ;
            }

            //  *    (3.3) call mm_map to build vma related to TEXT/DATA
            vm_flags = 0, perm = PTE_U;
            if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
            if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
            if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
            if (vm_flags & VM_WRITE) perm |= PTE_W;
            if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
                goto bad_cleanup_mmap;
            }

            //  *    (3.4) callpgdir_alloc_page to allocate page for TEXT/DATA, read contents in file
            //  *          and copy them into the new allocated pages
            off_t offset = ph->p_offset;
            size_t off, size;
            uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

            ret = -E_NO_MEM;

            end = ph->p_va + ph->p_filesz;
            while (start < end) {
                if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                    ret = -E_NO_MEM;
                    goto bad_cleanup_mmap;
                }
                off = start - la, size = PGSIZE - off, la += PGSIZE;
                if (end < la) {
                    size -= la - end;
                }
                // read
                if ((ret = load_icode_read(fd, page2kva(page) + off, size, offset)) != 0) {
                    goto bad_cleanup_mmap;
                }
                start += size, offset += size;
            }

            //  *    (3.5) callpgdir_alloc_page to allocate pages for BSS, memset zero in these pages
            end = ph->p_va + ph->p_memsz;
            if (start < la) {
                /* ph->p_memsz == ph->p_filesz */
                if (start == end) {
                    continue ;
                }
                off = start + PGSIZE - la, size = PGSIZE - off;
                if (end < la) {
                    size -= la - end;
                }
                memset(page2kva(page) + off, 0, size);
                start += size;
                assert((end < la && start == end) || (end >= la && start == la));
            }
            while (start < end) {
                if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                    // change ret
                    ret = -E_NO_MEM;
                    goto bad_cleanup_mmap;
                }
                off = start - la, size = PGSIZE - off, la += PGSIZE;
                if (end < la) {
                    size -= la - end;
                }
                memset(page2kva(page) + off, 0, size);
                start += size;
            }
        }
        // close file
        sysfile_close(fd);
        ```
    2. `load_icode()`中构造用户主函数调用栈：如前所述，基本框架以之前的lab为主，在构造trapframe之前需要构造调用栈上的参数情况，实现如下：
        ```c
        //  * (6) setup uargc and uargv in user stacks
        // count size of all arg
        uint32_t argv_size = 0;
        uint32_t i;
        for (i = 0; i < argc; i ++) {
            argv_size += strnlen(kargv[i], EXEC_MAX_ARG_LEN + 1)+1;
        }

        // make place for real args in high addr
        uintptr_t stacktop = USTACKTOP - (argv_size/sizeof(long) + 1) * sizeof(long);
        char** uargv=(char **)(stacktop - argc * sizeof(char *));

        // copy argv, low addr to high addr
        argv_size = 0;
        for (i = 0; i < argc; i ++) {
            uargv[i] = strcpy((char *)(stacktop + argv_size), kargv[i]);
            argv_size +=  strnlen(kargv[i], EXEC_MAX_ARG_LEN + 1) + 1;  // '1' for '\0'
        }

        // save argc to esp(stack top)
        stacktop = (uintptr_t)uargv - sizeof(int);
        *(int *)stacktop = argc;

        ```
    3. 注意，与之前实验框架不同的是，现在trapframe中用户栈顶esp不再是`USTACKTOP`，而是参数压栈后的栈顶，指向argc
    4. 执行`make qemu`，待执行完哲学家就餐问题测试后，进入shell，分别执行`ls`和`hello`可以看到如下结果：
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
    5. 执行`make grade`可以看到通过了全部测试：
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
    - 设计实现基于“UNIX的硬链接和软链接机制”的概要设方案
        > - 硬链接：创建时，文件的inode与源文件的inode相同，inode的引用计数增加。因此对任一硬链接的操作都是对同一原始文件的操作（inode相同），删除时，inode引用计数减少，归零时销毁该inode
        > - 软链接：是一种特殊的文件，inode类型为符号链接，其数据为指向的目标文件的路径。操作时经过两步，先读出软链接文件数据中的路径，再根据这个路径对其真正指向的文件进行操作。

## 2. 标准答案对比

- **练习1** ：
    - 标准答案中对各种sfs提供的操作都使用了诸如`ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0`这样的判断操作是否成功并将返回值写入`ret`的操作，以排除可能的错误，我没有加入，已经依据答案修正
- **练习2** ：
    - 在`load_icode()`入口，原来的实验框架不涉及argc和argv，但现在涉及这两个参数，因此答案对argc的大小进行了约束：`assert(argc >= 0 && argc <= EXEC_MAX_ARG_NUM)`，我没有加这句，已经根据答案修正
    - 设置trapframe时，答案与之前的实验框架一样，在开中断时直接给eflags赋值为FL_IF，但我认为应该做“或”操作，否则会破坏原有的eflags，因此我的实现是`tf->tf_eflags |= FL_IF`

## 3. 实验知识点分析

1. 文件系统
    - 文件系统的分层，具体的sfs实现，在OS原理中对分层有所介绍，对sfs具体实现涉及不多
    - 低层设备的抽象接口：如stdin等，可以通过阅读源码了解，但实验中自己填写的部分没有涉及，OS原理中没有太多涉及
    - 具体的读/写操作实现过程，实验中基于已经提供的函数进行填写，OS原理中没有涉及这些细节
2. 基于文件系统的exec
    - OS原理中没有涉及，实验中需要对之前的实验框架进行修改
3. shell执行用户程序时的命令行参数
    - 通过构造用户主函数调用栈传递参数，在OS原理中没有涉及
4. UNIX中pipe、硬/软链接的实现
    - 在回答问题中涉及，编码不涉及，OS原理中有提及

## 4. 未对应知识点分析

1. IO设备
2. 磁盘调度
3. 磁盘缓存
