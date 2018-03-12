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

- 扇区的最后两个字节为0x55AA.
### 1.2 

### 1.3 

### 1.4 

### 1.5 

## 2. 标准答案分析

## 3. 知识点分析