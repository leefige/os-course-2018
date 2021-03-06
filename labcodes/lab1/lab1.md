# Lab1 实验报告

## 0. 个人信息
- 姓名：李逸飞
- 班级：计52
- 学号：2015010062

## 1. 练习

### 1.1 理解通过make生成执行文件的过程
#### 问题1: 操作系统镜像文件ucore.img是如何一步一步生成的？
1. 使用`make "V=" 1>makelog.txt 2>&1`将make过程log到"lab1/makelog.txt"文件中
2. 通过分析"makelog.txt"文件，可知make经历了如下过程：
    1. 使用`-m32`模式，利用`gcc`依次编译kern/init/init.c, kern/libs/目录下的库函数, kern/debug/目录下的各调试函数, kern/driver/目录下的驱动程序如时钟等, kern/trap/目录下的中断、异常处理程序，生成的可重定向文件放置在obj/目录下。参数含义如下：
        - -m32: 32位模式，即x86模式
        - -fno-builtin: 不使用C内建函数，因为ucore可能定义了名字和Ｃ语言运行库里面已经存在的函数名冲突的函数，如果直接编译，就会报错，为了让源文件顺利编译，需要在编译时候添加-fno-builtin选项
        - -nostdinc: 使编译器不再系统缺省的头文件目录里面找头文件,一般和-I联合使用,明确限定头文件的位置，目的与`-fno-builtin`类似，因为ucore作为OS定义了自己的一套库函数和头文件
        - -I _dir_ : 限定头文件包含的寻找目录,先在你所制定的目录查找,然后再按常规的顺序去找，与上述`-nostdinc`配合
        - -Wall: 使能所有警告
        - -ggdb: 产生 GDB 所需的调试信息，方便后续调试
        - -gstabs: 以stabs格式声称调试信息
        - -fno-stack-protector: 禁用堆栈保护，这样编译出的堆栈布局与我们一般认识一致，方便调试
        - -c: 只编译出可重定向文件(.o文件)
        - -o: 输出目标，均位于obj/目录下
    2. 在`elf_i386`模式下使用`ld`对之前生成的可重定向文件链接生成bin/kernel，即ucore OS的kernel，其中链接脚本使用了tools/kernel.ld.参数含义如下：
        - -m elf_i386: 使用i380模式链接，即x86模式
        - -nostdlib: 在1中已经提及
        - -T tools/kernel.ld: 指定用链接脚本tools/kernel.ld替换掉主连接脚本
        - -o: 指定输出文件名
    3. 使用`-m32`模式，利用`gcc`汇编boot/目录下的bootasm.S, 编译bootmain.c，在obj/目录下生成对应的可重定向文件。部分参数含义与1中类似，不同如下：
        - -Os: 编译器优化，这个等级用来优化代码尺寸
    4. 使用`-m32`模式，利用`gcc`编译链接boot/sign.c生成可执行文件bin/sign，这一程序用于对MBR签名，即将源文件写入512 bytes并在其最后两个字节写入0x55AA。部分参数与1中类似，不同如下：
        - -g: 增加gdb需要的调试信息
        - -O2: 编译器优化，2级性能优化
    5. 在`elf_i386`模式下使用`ld`链接生成obj/bootblock.o，接着使用上一步生成的`sign`程序进行签名，提示`build 512 bytes boot sector: 'bin/bootblock' success`，即生成的bin/bootblock文件为第0个扇区中的主引导记录MBR。部分参数含义与2中类似，不一样的有：
        - -N: 把text和data段设置为可读写；同时，取消数据段的页对齐；同时，取消对共享库的连接
        - -e start: 使用符号`start`作为程序的开始执行点,而不是使用缺省的进入点
        - -Ttext 0x7C00: 指定text段在输出文件中的绝对地址为0x7C00，因为BIOS执行完毕后会默认bootloader的入口地址为0x7C00并跳到此处继续执行，因此需要将bootloader的起始地址设置为0x7C00
    6. 使用`dd`命令，设置`if=/dev/zero of=bin/ucore`，对bin/ucore.img写入"0"。参数：
        - count=10000: 写入的块的数量，每块大小默认为512 bytes，那么ucore.img的大小为5,120,000 bytes，实际查看其大小的确为4.9MB，一致
    7. 使用`dd`命令，设置`if=bin/bootblock of=bin/ucore.img`，将作为MBR的bin/bootblock写入bin/ucore.img，大小为512 bytes。参数：
        - conv=notrunc: 不截短输出文件，即保留了ucore.img的4.9MB大小
    8. 继续使用`dd`命令，设置`if=bin/kernel of=bin/ucore.img`，将ucore kernel写入bin/ucore.img的MBR之后的扇区, 大小为74828 bytes。参数：
        - conv=notrunc: 同上
        - seek=1: 从输出文件开头跳过1个块后再开始复制，即从第0扇区的MBR之后开始写入

#### 问题2: 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

- 扇区的最后两个字节为0x55AA，这从sign签名程序的功能即可看出。

### 1.2 使用qemu执行并调试lab1中的软件

#### 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行
1. 根据附录中所述，先在gdbinit中添加配置信息，以强制显示反汇编指令
2. 使用`make debug`命令，启动gdb调试qemu，此时显示为`=> 0xfff0: add %al,(%bx,%si)`，这与实验指导中所述“这时gdb停在BIOS的第一条指令处：`0xffff0: ljmp $0xf000,$0xe05b`”不符。
3. 在piazza上查阅相关问题后看到类似问题
[为什么Lab1 练习2 “启动后第一条执行的指令“ $PC停留在0xFFF0而不是0xFFFF0](https://piazza.com/class/i5j09fnsl7k5x0?cid=991)指出，这是正常现象。同时自己观测寄存器和内存值，可见

    ```gdb
        (gdb) p /x $cs
            $3 = 0xf000
        (gdb) p /x $eip
            $4 = 0xfff0
        (gdb) x/i 0xffff0
            0xffff0:     ljmp   $0xf000,$0xe05b 
    ```
    
   说明此时$cs和$eip都有着恰当的值，而且此时再执行si，可以看到确实跳转到了0xe05b，也即执行了0xffff0处的ljmp，证明第一条指令无误：
    ```gdb
        (gdb) si
            => 0xe05b:      add    %al,(%bx,%si)
    ```
4. 之后持续使用si即可查看BIOS中的各条指令

#### 在初始化位置0x7c00设置实地址断点,测试断点正常

1. 将gdbinit恢复为初始状态，并增加`break *0x7c00`以设置0x7C00断点
2. 使用`make debug`命令，可以看到如下结果，断点正常：
    ```gdb
        => 0x7c00:      cli
        Breakpoint 2, 0x00007c00 in ?? ()
    ```
3. 需要指出的是，我在这里调试时遇到一个问题，表现为无法从gdbinit中设置断点，`make debug`后无法在断点处停止，且使用`info breakpoints`查看断点信息发现不存在断点。后来通过对lab1_answer执行`make debug`时发现报错“找不到cgdb”，于是安装cgdb，再次尝试发现可行，问题解决，结论为我自己的Ubuntu中的gdb和标准实验环境有差异，安装cgdb即可。

#### 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较

1. 继续上一步的后续操作，使用`si`查看后续指令
2. 得到的汇编指令如下（从0x7C00开始）：

    ```asm
        cli
        cld
        xor    %ax,%ax
        mov    %ax,%ds
        mov    %ax,%es
        mov    %ax,%ss
        in     $0x64,%al
        test   $0x2,%al
        ...
    ```
    这与反汇编得到的obj/bootblock.asm中`start`段代码吻合。其中`in     $0x64,%al`之后为`seta20.1`段中的指令，即设置A20 GATE。

#### 自己找一个bootloader或内核中的代码位置，设置断点并进行测试

- 在gdbinit文件中加入`break clock_init`，再进行调试，可以观测到这个断点：
    ```gdb
        => 0x100c6f <clock_init>:       push   %bp
        Breakpoint 3, clock_init () at kern/driver/clock.c:33
    ```

### 1.3 分析bootloader进入保护模式的过程

#### 为何开启A20？如何开启A20？
- 开启A20的原因：Intel早期的8086 CPU提供了20根地址线,可寻址空间范围即0~2^20(00000H~FFFFFH)的 1MB内存空间，且这时运行在实模式下。后续的32位CPU为了后向兼容，保留了实模式。在80386以上的CPU中，为了兼容，采用了在实模式下“回卷”的寻址方法，而用A20 Gate就用来控制这一特性。但在保护模式下，寻址空间达到4G，如果A20仍被屏蔽，则只能访问奇数兆的内存，即只能访问0--1M, 2-3M, 4-5M...，这样无法有效访问所有可用内存，因此需要打开A20 Gate。
- 开启A20的方法：
    - 总体而言，开启A20需要将键盘控制器8042发送一个命令，随后键盘控制器会将其一个引脚（P2端口的1bit）置为高电平，它是A20地址线控制的输入，这就开启了A20
    - 具体操作如下：
        1. 轮循等待8042的input buffer为空
        2. 在0x64端口写入0xd1，即写Output Port(P2端口)命令
        3. 再次轮循等待8042的input buffer为空
        4. 在端口0x60写入0xdf(11011111)，该值会被设置到P2端口，实现了设置其1bit为1的目的，即置A20为高电平

#### 如何初始化GDT表？
- 通过一条指令`lgdt gdtdesc`即可加载定义好的gdtdesc（全局描述符表），其中gdtdesc为GDT的描述符，包含了GDT的基址和大小，被写入GDTR寄存器中，GDT基址指向实际的GDT表，其定义如下：
    ```asm
    gdt:
        SEG_NULLASM  # null seg
        SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff) # code seg
        SEG_ASM(STA_W, 0x0, 0xffffffff)       # data seg
    ```
- GDT的第一项为空项，随后两项分别是代码段和数据段的段描述符

#### 如何使能和进入保护模式？

- 使用了如下的汇编代码：
    ```asm
        movl %cr0, %eax
        orl $CR0_PE_ON, %eax
        movl %eax, %cr0

        ljmp $PROT_MODE_CSEG, $protcseg
    ```
- 解释如下：
    1. 首先将%cr0寄存器转移到%eax寄存器中，需要注意，%cr0寄存器的0位为PE(Protected Enable)，置1时启动保护模式，否则为实模式
    2. `$CR0_PE_ON`的值为0x1，将它和%eax中的%cr0的置做或运算，将%eax的0bit置为1
    3. 将%eax的值写回%cr0寄存器，就实现了将%cr0的0bit(PE)置1的目的，使能了保护模式
    4. 最后通过一次长跳转，进入了32位地址空间下的OS kernel代码，这就进入了保护模式

### 1.4 分析bootloader加载ELF格式的OS的过程
#### bootloader如何读取硬盘扇区的？
- 读取扇区的接口函数为`readseg(uintptr_t va, uint32_t count, uint32_t offset)`，即将`offset`开始的`count`个字节读入`va`内存地址
- `readseg`函数通过计算得出起始扇区，并调整目的内存地址（因为读取扇区需要以扇区大小为单位，当然这样可能导致`va`前内存空间被覆盖，因此需要谨慎设计），再调用`readsect`函数依次读出所有扇区
- 在`readsect`函数中具体读取扇区时，分以下步骤：
    1. 等待磁盘就绪`waitdisk();`
    2. 发出读取扇区的命令，即使用`outb`函数对目标端口写入命令
    3. 再次等待磁盘就绪
    4. 通过`insl`函数把磁盘扇区数据读到指定内存地址

#### bootloader是如何加载ELF格式的OS？
1. 在1.3进入保护模式后，首先将初始化%ds, %es, %fs, %gs, %ss各段寄存器，建立第一个调用栈（基址%ebp = 0)，将`$start`(应当为0:0x7C00)赋给%esp，随后`call bootmain`转入bootmain的代码
2. bootmain首先读取磁盘上从0地址（对应于从1号扇区开始，因为0号扇区为MBR）开始的8个扇区写入地址0x10000，并判断是否是合法的ELF文件，若不合法则进入死循环
3. 若为合法ELF文件，则取出program header的起始地址和数量，遍历所有program header，将它们描述的磁盘存储装载入它们指定的映射内存地址，即`readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);`
4. 最后通过`((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();`调用ELF Header指定的程序入口，将控制权移交给OS

### 1.5 实现函数调用堆栈跟踪函数
- 实现过程：
    1. 在初始获取%ebp和%eip时直接调用相应函数即可
    2. 在获取参数时，使用`*(((uint32_t*) stack_val_ebp) + 2 + j)`，j为循环变量，从0到4分别取得4个参数的值，方法是将ebp作为指针，第0个参数为8(ebp)，其地址为&ebp+2，以此类推
    3. 向上查找上一级调用栈时，使用`*(((uint32_t*) stack_val_ebp) + 1);`获取eip值，即4(ebp)，也即&ebp+1处的值；使用`*(((uint32_t*) stack_val_ebp));`获取ebp值，即(ebp)，也即地址&ebp处的值
    4. 为避免错误，当%ebp <= 0时即停止上溯。

- 使用`make qemu`后输出如下：
    ```
    + cc kern/debug/kdebug.c
    + ld bin/kernel
    10000+0 records in
    10000+0 records out
    5120000 bytes (5.1 MB, 4.9 MiB) copied, 0.0944737 s, 54.2 MB/s
    1+0 records in
    1+0 records out
    512 bytes copied, 0.99168 s, 0.5 kB/s
    146+1 records in
    146+1 records out
    74828 bytes (75 kB, 73 KiB) copied, 0.000727063 s, 103 MB/s
    WARNING: Image format was not specified for 'bin/ucore.img' and probing guessed raw.
            Automatically detecting the format is dangerous for raw images, write operations on block 0 will be restricted.
            Specify the 'raw' format explicitly to remove the restrictions.
    (THU.CST) os is loading ...

    Special kernel symbols:
    entry  0x00100000 (phys)
    etext  0x00103279 (phys)
    edata  0x0010ea16 (phys)
    end    0x0010fd20 (phys)
    Kernel executable memory footprint: 64KB
    ebp:0x00007b38 eip:0x00100a28 args:0x00010094 0x00010094 0x00007b68 0x0010007f
        kern/debug/kdebug.c:309: print_stackframe+22
    ebp:0x00007b48 eip:0x00100d39 args:0x00000000 0x00000000 0x00000000 0x00007bb8
        kern/debug/kmonitor.c:125: mon_backtrace+10
    ebp:0x00007b68 eip:0x0010007f args:0x00000000 0x00007b90 0xffff0000 0x00007b94
        kern/init/init.c:48: grade_backtrace2+19
    ebp:0x00007b88 eip:0x001000a1 args:0x00000000 0xffff0000 0x00007bb4 0x00000029
        kern/init/init.c:53: grade_backtrace1+27
    ebp:0x00007ba8 eip:0x001000be args:0x00000000 0x00100000 0xffff0000 0x00100043
        kern/init/init.c:58: grade_backtrace0+19
    ebp:0x00007bc8 eip:0x001000df args:0x00000000 0x00000000 0x00000000 0x00103280
        kern/init/init.c:63: grade_backtrace+26
    ebp:0x00007be8 eip:0x00100050 args:0x00000000 0x00000000 0x00000000 0x00007c4f
        kern/init/init.c:28: kern_init+79
    ebp:0x00007bf8 eip:0x00007d6e args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
        <unknow>: -- 0x00007d6d --
    ++ setup timer interrupts
    ```
- 最后一行各参数如下：
    ```
    ebp:0x00007bf8 eip:0x00007d6e args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
        <unknow>: -- 0x00007d6d --
    ```
    由于总堆栈数未达到20，因此最后一行对应于最顶层的调用栈，也即bootloader在调用bootmain时的调用栈。`ebp:0x00007bf8`为该栈的基址，由于bootloader的第一个栈设置为`movl $start, %esp`，其中`$start`为0x7c00，因此在执行`call bootmain`时将返回地址压栈，再将原来的ebp压栈，这时栈顶值被赋给ebp，因此该调用栈的%ebp值为0x7bf8。ss:%eip为此时的栈顶地址，后边四个arg无实际含义，因为bootmain函数没有参数。

### 1.6 完善中断初始化和处理

#### 中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

- IDT的一个表项长为8 bytes，其中的第16~31位为段选择子，第0~16位为offset的低16位，第48~63位为offset的高16位，拼起来可以用来获取中断处理例程的入口地址。

#### 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init
- 实现方法遵从注释中的步骤，首先声明在vectors.S中定义好的\__vectors数组，截着对idt数组中的全部256项调用`SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL)`设置idt表项，其中，0表示为interrupt而非trap，GD_KTEXT在memlayout.h中声明，表示段类型为kernel的代码段，入口offset为\__vectors数组对应的项，DPL为内核级。最后用lidt将idt表装载到idtr寄存器中。
- 实现了这步后具有了接受键盘中断的能力，效果如下：
    ```
    kbd [104] h
    kbd [000] 
    kbd [101] e
    kbd [000] 
    kbd [121] y
    kbd [000] 
    kbd [032]  
    kbd [000] 
    kbd [103] g
    kbd [000] 
    kbd [117] u
    kbd [000] 
    kbd [121] y
    kbd [000] 
    kbd [115] s
    ```

#### 请编程完善trap.c中的中断处理函数trap
- 实现方法：只需在`trap_dispatch`中，当时钟中断发生时，将ticks计数器加一，若ticks达到100， 则打印ticks，并将ticks清零，即可大约1s输出一次时钟中断信息。
    ```c
        // 1. record
        ticks++;

        // 2. print
        if (ticks >= 100) {
            print_ticks();
            ticks = 0;
        }
    ```
### 1.x1 扩展练习 Challenge 1

- 实现方法：
    1. 首先在init.c中将`lab1_switch_test();`一行uncomment，以允许评测代码允许
    2. 在`lab1_switch_to_kernel`和`lab1_switch_to_user`中执行系统调用，即使用`int`指令，参数分别为`T_SWITCH_TOK`和`T_SWITCH_TOU`。此处使用`movl %%ebp, %%esp`是为了确保系统调用后、函数返回前，%esp确实回到调用栈基。此处我遇到过的bug是，在`lab1_switch_to_kernel`中，起初我没有加`movl %%ebp, %%esp`，但是在刚进入函数后为了调试调用`cprintf`输出了调试信息，这时`make grade`允行无误，但删除这条语句后该函数不能正常执行，分析原因，是因为额外的函数调用保证了%esp回到正确的位置，但不做额外函数调用时，可能需要手工恢复其位置。代码如下
        ```c
        static void
        lab1_switch_to_user(void) {
            //LAB1 CHALLENGE 1 : TODO
            // "movl %%ebp, %%esp" esure that before ret, esp = ebp -> old ebp
            asm volatile (
                "int %0;"
                "movl %%ebp, %%esp"
                : 
                : "i"(T_SWITCH_TOU)
            );
        }

        static void
        lab1_switch_to_kernel(void) {
            //LAB1 CHALLENGE 1 :  TODO
            // cprintf("in lab1_switch_to_kernel\n");
            asm volatile (
                "int %0;"
                "movl %%ebp, %%esp"
                : 
                : "i"(T_SWITCH_TOK)
            );
        }
        ```
    3. 在trap.c中实现相应的系统调用功能。
        - 这部分我遇到不少bug，通过gdb单步跟踪，基本明白了处理中断的原理和过程。在trapentry.S的中断处理入口处，硬件已经保存了trap frame中靠后的信息，包括trap number，此时它位于栈顶，进入trapentry后，首先将各段寄存器压栈，对应于trap frame中的最前面几项，接着通过`pushal`保存通用寄存器值，将%ds, %es置为核心数据段。这时%esp指向的正是tp，通过`pushl %esp`将参数tp压栈，然后`call trap`，转到trap.c中对具体trap的处理。在处理完毕后，再通过`popl %esp`将%esp指向tp，恢复通用寄存器，从tp中重置各段寄存器，最后跳过trap number和error code并用`iret`返回。
        - 由上述可见，**切换状态的关键在于对tp的重写，以改变各段寄存器的值**。在切到核心态时非常简单，直接对tf做修改即可，因为核心态对用户态栈拥有权限。但切到用户态时，不能直接在原tf上修改，因为原tf在核心态栈上，切换后若还停留在该处会导致"General Protection"异常。所以需要利用已经给出的全局变量switchk2u，用它构建新栈，最后将tf指向这块内存空间。这里的技巧是，作为参数的tf恰好为`pushl %esp`后的esp+1位置，因此需要将switchk2u的地址赋给`((uint32_t *)tf - 1)`，也即随后将要被`popl %esp`的栈顶位置，这样在返回trapentry继续执行时将会把这个地址赋给%esp，也即将栈顶转移到此处，就实现了从这个栈中恢复各段寄存器值的目的。
        - 此外还需要修改eflags的值，以满足在用户态下可用调用I/O以显示调试信息。切回核心态时，需要将其还原。
        - 相关代码如下：
            ```c
            case T_SWITCH_TOU:
                switchk2u = *tf;
                switchk2u.tf_cs = USER_CS;
                switchk2u.tf_ds = USER_DS;
                switchk2u.tf_es = USER_DS;
                switchk2u.tf_ss = USER_DS;

                // set eflags, make sure ucore can use io under user mode.
                // if CPL > IOPL, then cpu will generate a general protection.
                switchk2u.tf_eflags |= FL_IOPL_MASK;
            
                // set trap frame pointer
                // tf is the pointer to the pointer of trap frame (a structure)
                // tf = esp, while esp -> esp - 1 (*trap_frame) due to `pushl %esp`
                // so *(tf - 1) is the pointer to trap frame
                // change *trap_frame to point to the new frame
                *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
                break;
            case T_SWITCH_TOK:
                // panic("T_SWITCH_** ??\n");
                tf->tf_cs = KERNEL_CS;
                tf->tf_ds = KERNEL_DS;
                tf->tf_es = KERNEL_DS;

                // restore eflags
                tf->tf_eflags &= ~FL_IOPL_MASK;
                break;
            ```
    4. 还有很关键的一点，也是导致我花费很多时间调试的问题，就是要将`T_SWITCH_TOK`这一中断服务例程的RPL设置为用户态，因为这部分代码不同于其他中断处理程序在核心态下执行，而是必须在用户态下执行。相关设置是在初始化IDT时，加入`SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);`，将这一GATE单独设置为用户级RPL。否则会出现我在调试中遇到的"General Protection"异常。
    
### 1.x2 扩展练习 Challenge 2

- 实现方法：在challenge 1的基础上，这部分只需要在键盘中断时加入过滤条件，在输入'0'和'3'时分别执行切换到内核/用户态的代码即可。为了方便显示结果，在输入'p'时会调用`print_trapframe(tf);`打印当前各段寄存器的值，由此判断当前的特权态：若CS最低两位为11b，则为用户态，若为00b，则为特权态。
- 结果如下，可见按下'3'后再打印调试信息，CS为0x001b，最低两位为11，处于用户态；再按下'0'，打印调试信息可见CS为0x0008，最低两位为00，处于核心态，功能无误：
    ```gdb
    100 ticks
    kbd [051] 3
    switch to user
    kbd [000]
    100 ticks
    kbd [112] p
    trapframe at 0x10fd34
        edi  0x00000000
        esi  0x00010094
        ebp  0x00007be8
        oesp 0x0010fd54
        ebx  0x00010094
        edx  0x000000a1
        ecx  0x00000000
        eax  0x000000ff
        ds   0x----0023
        es   0x----0023
        fs   0x----0023
        gs   0x----0023
        trap 0x00000021 Hardware Interrupt
        err  0x00000000
        eip  0x00100069
        cs   0x----001b
        flag 0x00003202 IF,IOPL=3
        esp  0x00007bd0
        ss   0x----0023
    kbd [000]
    100 ticks
    100 ticks
    kbd [048] 0
    switch to kern
    kbd [000]
    100 ticks
    kbd [112] p
    trapframe at 0x10fd34
        edi  0x00000000
        esi  0x00010094
        ebp  0x00007be8
        oesp 0x0010fd54
        ebx  0x00010094
        edx  0x000000a1
        ecx  0x00000000
        eax  0x000000ff
        ds   0x----0010
        es   0x----0010
        fs   0x----0023
        gs   0x----0023
        trap 0x00000021 Hardware Interrupt
        err  0x00000000
        eip  0x00100069
        cs   0x----0008
        flag 0x00000202 IF,IOPL=0
    kbd [000]
    100 ticks
    ```

## 2. 标准答案对比
1. 练习5：
    - 在获取四个参数值时，答案用了`uint32_t *args = (uint32_t *)ebp + 2;`获取参数的首地址，随后将其看成数组，直接依次访问`args[j]`；在我的实现中，先开辟了数组`stack_val_args[4]`，随后使用`stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);`依次填充数组的值。答案的方法跟巧妙，也算是对c的灵活运用
    - 在判断循环终止条件时，答案在`for`的循环条件中判断`ebp != 0`，我在循环的最后取得新的ebp值后，判断`stack_val_ebp <= 0`，若为真则返回
2. 练习6：
    - 在循环填充trap gate时，答案的循环条件用`sizeof(idt) / sizeof(struct gatedesc)`作为循环上界，这样可变性更强，但我的使用了hard code，直接用了idt数组大小256
    - 在时钟中断中，遵循注释，代码与答案差异不大，不同之处在于答案中，计数达到100时并没有将ticks清零，但我清零了，细想发现这一操作没有必要，因为如果加法溢出将会回卷，所以求模运算保证了不需对ticks清零。随后我参考答案删除了这一操作。
3. challenge：
    - 答案在切换模式时先判断了当前模式是否是目标模式，但我没有做这一判断，实际测试发现并无影响，严格来讲答案做法更节省开销，不会做不必要的切换
    - 对于切换到kernel模式，答案新建了trap frame，但我的实现中通过直接修改tf实现，实际测试可行，这样开销更小
    - 在`lab1_switch_to_user()`函数中，答案里做了`sub $0x8, %%esp`操作，其目的是，当在核心态处理中断时硬件不会将esp和ss压栈，这里是要模拟两个压栈动作以和用户态遇到中断的栈状态保持一致。但实际上，在切换到用户态的过程中并不会用到原来的esp和ss，只需要修改cs, ds, es, gs的值即可，因此我没有执行这一步。相应的，答案中`switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;`这一对trap frame中tf_esp的操作也就没有必要了，因为对应的栈中根本没有压入这一变量。当然，如果为了防止取成员变量时取到tf_esp导致访问非法内存的情况，模拟压栈两次还是有其积极意义的，不过考虑到这里是OS kernel编程，省略这一操作也未尝不可。
    - 事实上，由于我的实现方法中没有对esp的特殊操作，在执行`int`后的`movl %%ebp, %%esp`操作可能也不那么必要了，但是保险起见，还是保留了这一步操作。

## 3. 知识点分析
1. 对make过程的认识：涉及到实验所需的tool chain，以及bootloader和OS kernel的生成过程，在OS原理中没有涉及相应知识点
2. x86的启动顺序、从BIOS到bootloader再到OS kernel的加载流程：只体现在代码阅读方面，没有对应的编程
3. 保护模式、段机制、段描述符等：同样体现在代码阅读，没有对应的编程；不过在中断处理中，对`idt`的设置、初始化和对`gdt`的操作是相似的，都是有一张描述符表，再将对这个表的描述符加载到寄存器（gdtr和idtr）中
4. 保护模式下的中断处理：包括idt的设置、中断处理流程的理解和中断处理例程的编写，相比原理课，自己动手编写代码涉及更多细节，尤其是challenge，让我更深入思考了从中断被触发、硬件自动压栈、trap entry进一步生成trap frame并调用中断处理例程、最后从trap frame中恢复段寄存器值并执行iret返回的过程
5. x86的C函数调用过程：这部分在汇编语言程序设计中就有过详细的讲解，在实验中，主要是在challenge中对这方面需要较深的理解，才能明白对trap frame的各种操作
