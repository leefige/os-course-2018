
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 20 12 00       	mov    $0x122000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax     #c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 20 12 c0       	mov    %eax,0xc0122000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 10 12 c0       	mov    $0xc0121000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 5c 51 12 c0       	mov    $0xc012515c,%edx
c0100041:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	83 ec 04             	sub    $0x4,%esp
c010004d:	50                   	push   %eax
c010004e:	6a 00                	push   $0x0
c0100050:	68 00 40 12 c0       	push   $0xc0124000
c0100055:	e8 9d 83 00 00       	call   c01083f7 <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 ab 1d 00 00       	call   c0101e0d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 80 8c 10 c0 	movl   $0xc0108c80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 9c 8c 10 c0       	push   $0xc0108c9c
c0100074:	e8 11 02 00 00       	call   c010028a <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 93 08 00 00       	call   c0100914 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 83 00 00 00       	call   c0100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 3a 6e 00 00       	call   c0106ec5 <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 ef 1e 00 00       	call   c0101f7f <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 50 20 00 00       	call   c01020e5 <idt_init>

    vmm_init();                 // init virtual memory management
c0100095:	e8 77 3d 00 00       	call   c0103e11 <vmm_init>

    ide_init();                 // init ide devices
c010009a:	e8 3d 0d 00 00       	call   c0100ddc <ide_init>
    swap_init();                // init swap
c010009f:	e8 46 4b 00 00       	call   c0104bea <swap_init>

    clock_init();               // init clock interrupt
c01000a4:	e8 0b 15 00 00       	call   c01015b4 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a9:	e8 0e 20 00 00       	call   c01020bc <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000ae:	eb fe                	jmp    c01000ae <kern_init+0x78>

c01000b0 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b0:	55                   	push   %ebp
c01000b1:	89 e5                	mov    %esp,%ebp
c01000b3:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000b6:	83 ec 04             	sub    $0x4,%esp
c01000b9:	6a 00                	push   $0x0
c01000bb:	6a 00                	push   $0x0
c01000bd:	6a 00                	push   $0x0
c01000bf:	e8 ac 0c 00 00       	call   c0100d70 <mon_backtrace>
c01000c4:	83 c4 10             	add    $0x10,%esp
}
c01000c7:	90                   	nop
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d7:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	51                   	push   %ecx
c01000de:	52                   	push   %edx
c01000df:	53                   	push   %ebx
c01000e0:	50                   	push   %eax
c01000e1:	e8 ca ff ff ff       	call   c01000b0 <grade_backtrace2>
c01000e6:	83 c4 10             	add    $0x10,%esp
}
c01000e9:	90                   	nop
c01000ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000ed:	c9                   	leave  
c01000ee:	c3                   	ret    

c01000ef <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000ef:	55                   	push   %ebp
c01000f0:	89 e5                	mov    %esp,%ebp
c01000f2:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000f5:	83 ec 08             	sub    $0x8,%esp
c01000f8:	ff 75 10             	pushl  0x10(%ebp)
c01000fb:	ff 75 08             	pushl  0x8(%ebp)
c01000fe:	e8 c7 ff ff ff       	call   c01000ca <grade_backtrace1>
c0100103:	83 c4 10             	add    $0x10,%esp
}
c0100106:	90                   	nop
c0100107:	c9                   	leave  
c0100108:	c3                   	ret    

c0100109 <grade_backtrace>:

void
grade_backtrace(void) {
c0100109:	55                   	push   %ebp
c010010a:	89 e5                	mov    %esp,%ebp
c010010c:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010f:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100114:	83 ec 04             	sub    $0x4,%esp
c0100117:	68 00 00 ff ff       	push   $0xffff0000
c010011c:	50                   	push   %eax
c010011d:	6a 00                	push   $0x0
c010011f:	e8 cb ff ff ff       	call   c01000ef <grade_backtrace0>
c0100124:	83 c4 10             	add    $0x10,%esp
}
c0100127:	90                   	nop
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c010014d:	83 ec 04             	sub    $0x4,%esp
c0100150:	52                   	push   %edx
c0100151:	50                   	push   %eax
c0100152:	68 a1 8c 10 c0       	push   $0xc0108ca1
c0100157:	e8 2e 01 00 00       	call   c010028a <cprintf>
c010015c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010015f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100163:	0f b7 d0             	movzwl %ax,%edx
c0100166:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c010016b:	83 ec 04             	sub    $0x4,%esp
c010016e:	52                   	push   %edx
c010016f:	50                   	push   %eax
c0100170:	68 af 8c 10 c0       	push   $0xc0108caf
c0100175:	e8 10 01 00 00       	call   c010028a <cprintf>
c010017a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010017d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100181:	0f b7 d0             	movzwl %ax,%edx
c0100184:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100189:	83 ec 04             	sub    $0x4,%esp
c010018c:	52                   	push   %edx
c010018d:	50                   	push   %eax
c010018e:	68 bd 8c 10 c0       	push   $0xc0108cbd
c0100193:	e8 f2 00 00 00       	call   c010028a <cprintf>
c0100198:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c010019b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010019f:	0f b7 d0             	movzwl %ax,%edx
c01001a2:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001a7:	83 ec 04             	sub    $0x4,%esp
c01001aa:	52                   	push   %edx
c01001ab:	50                   	push   %eax
c01001ac:	68 cb 8c 10 c0       	push   $0xc0108ccb
c01001b1:	e8 d4 00 00 00       	call   c010028a <cprintf>
c01001b6:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001b9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001bd:	0f b7 d0             	movzwl %ax,%edx
c01001c0:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001c5:	83 ec 04             	sub    $0x4,%esp
c01001c8:	52                   	push   %edx
c01001c9:	50                   	push   %eax
c01001ca:	68 d9 8c 10 c0       	push   $0xc0108cd9
c01001cf:	e8 b6 00 00 00       	call   c010028a <cprintf>
c01001d4:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001d7:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001dc:	83 c0 01             	add    $0x1,%eax
c01001df:	a3 00 40 12 c0       	mov    %eax,0xc0124000
}
c01001e4:	90                   	nop
c01001e5:	c9                   	leave  
c01001e6:	c3                   	ret    

c01001e7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001e7:	55                   	push   %ebp
c01001e8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    // "movl %%ebp, %%esp" esure that before ret, esp = ebp -> old ebp
    asm volatile (
c01001ea:	cd 78                	int    $0x78
c01001ec:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c01001ee:	90                   	nop
c01001ef:	5d                   	pop    %ebp
c01001f0:	c3                   	ret    

c01001f1 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f1:	55                   	push   %ebp
c01001f2:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    // cprintf("in lab1_switch_to_kernel\n");
    asm volatile (
c01001f4:	cd 79                	int    $0x79
c01001f6:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
        : 
	    : "i"(T_SWITCH_TOK)
	);
}
c01001f8:	90                   	nop
c01001f9:	5d                   	pop    %ebp
c01001fa:	c3                   	ret    

c01001fb <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fb:	55                   	push   %ebp
c01001fc:	89 e5                	mov    %esp,%ebp
c01001fe:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c0100201:	e8 24 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100206:	83 ec 0c             	sub    $0xc,%esp
c0100209:	68 e8 8c 10 c0       	push   $0xc0108ce8
c010020e:	e8 77 00 00 00       	call   c010028a <cprintf>
c0100213:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100216:	e8 cc ff ff ff       	call   c01001e7 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021b:	e8 0a ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	68 08 8d 10 c0       	push   $0xc0108d08
c0100228:	e8 5d 00 00 00       	call   c010028a <cprintf>
c010022d:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100230:	e8 bc ff ff ff       	call   c01001f1 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100235:	e8 f0 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c010023a:	90                   	nop
c010023b:	c9                   	leave  
c010023c:	c3                   	ret    

c010023d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010023d:	55                   	push   %ebp
c010023e:	89 e5                	mov    %esp,%ebp
c0100240:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100243:	83 ec 0c             	sub    $0xc,%esp
c0100246:	ff 75 08             	pushl  0x8(%ebp)
c0100249:	e8 f0 1b 00 00       	call   c0101e3e <cons_putc>
c010024e:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c0100251:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100254:	8b 00                	mov    (%eax),%eax
c0100256:	8d 50 01             	lea    0x1(%eax),%edx
c0100259:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025c:	89 10                	mov    %edx,(%eax)
}
c010025e:	90                   	nop
c010025f:	c9                   	leave  
c0100260:	c3                   	ret    

c0100261 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100261:	55                   	push   %ebp
c0100262:	89 e5                	mov    %esp,%ebp
c0100264:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010026e:	ff 75 0c             	pushl  0xc(%ebp)
c0100271:	ff 75 08             	pushl  0x8(%ebp)
c0100274:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100277:	50                   	push   %eax
c0100278:	68 3d 02 10 c0       	push   $0xc010023d
c010027d:	e8 ab 84 00 00       	call   c010872d <vprintfmt>
c0100282:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100285:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100288:	c9                   	leave  
c0100289:	c3                   	ret    

c010028a <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010028a:	55                   	push   %ebp
c010028b:	89 e5                	mov    %esp,%ebp
c010028d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100290:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100293:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100296:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100299:	83 ec 08             	sub    $0x8,%esp
c010029c:	50                   	push   %eax
c010029d:	ff 75 08             	pushl  0x8(%ebp)
c01002a0:	e8 bc ff ff ff       	call   c0100261 <vcprintf>
c01002a5:	83 c4 10             	add    $0x10,%esp
c01002a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002ae:	c9                   	leave  
c01002af:	c3                   	ret    

c01002b0 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b0:	55                   	push   %ebp
c01002b1:	89 e5                	mov    %esp,%ebp
c01002b3:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002b6:	83 ec 0c             	sub    $0xc,%esp
c01002b9:	ff 75 08             	pushl  0x8(%ebp)
c01002bc:	e8 7d 1b 00 00       	call   c0101e3e <cons_putc>
c01002c1:	83 c4 10             	add    $0x10,%esp
}
c01002c4:	90                   	nop
c01002c5:	c9                   	leave  
c01002c6:	c3                   	ret    

c01002c7 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002c7:	55                   	push   %ebp
c01002c8:	89 e5                	mov    %esp,%ebp
c01002ca:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d4:	eb 14                	jmp    c01002ea <cputs+0x23>
        cputch(c, &cnt);
c01002d6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002da:	83 ec 08             	sub    $0x8,%esp
c01002dd:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002e0:	52                   	push   %edx
c01002e1:	50                   	push   %eax
c01002e2:	e8 56 ff ff ff       	call   c010023d <cputch>
c01002e7:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ed:	8d 50 01             	lea    0x1(%eax),%edx
c01002f0:	89 55 08             	mov    %edx,0x8(%ebp)
c01002f3:	0f b6 00             	movzbl (%eax),%eax
c01002f6:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002f9:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002fd:	75 d7                	jne    c01002d6 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002ff:	83 ec 08             	sub    $0x8,%esp
c0100302:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100305:	50                   	push   %eax
c0100306:	6a 0a                	push   $0xa
c0100308:	e8 30 ff ff ff       	call   c010023d <cputch>
c010030d:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100310:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100313:	c9                   	leave  
c0100314:	c3                   	ret    

c0100315 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100315:	55                   	push   %ebp
c0100316:	89 e5                	mov    %esp,%ebp
c0100318:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010031b:	e8 67 1b 00 00       	call   c0101e87 <cons_getc>
c0100320:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100323:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100327:	74 f2                	je     c010031b <getchar+0x6>
        /* do nothing */;
    return c;
c0100329:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010032c:	c9                   	leave  
c010032d:	c3                   	ret    

c010032e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010032e:	55                   	push   %ebp
c010032f:	89 e5                	mov    %esp,%ebp
c0100331:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100334:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100338:	74 13                	je     c010034d <readline+0x1f>
        cprintf("%s", prompt);
c010033a:	83 ec 08             	sub    $0x8,%esp
c010033d:	ff 75 08             	pushl  0x8(%ebp)
c0100340:	68 27 8d 10 c0       	push   $0xc0108d27
c0100345:	e8 40 ff ff ff       	call   c010028a <cprintf>
c010034a:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010034d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100354:	e8 bc ff ff ff       	call   c0100315 <getchar>
c0100359:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010035c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100360:	79 0a                	jns    c010036c <readline+0x3e>
            return NULL;
c0100362:	b8 00 00 00 00       	mov    $0x0,%eax
c0100367:	e9 82 00 00 00       	jmp    c01003ee <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010036c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100370:	7e 2b                	jle    c010039d <readline+0x6f>
c0100372:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100379:	7f 22                	jg     c010039d <readline+0x6f>
            cputchar(c);
c010037b:	83 ec 0c             	sub    $0xc,%esp
c010037e:	ff 75 f0             	pushl  -0x10(%ebp)
c0100381:	e8 2a ff ff ff       	call   c01002b0 <cputchar>
c0100386:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100389:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010038c:	8d 50 01             	lea    0x1(%eax),%edx
c010038f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100392:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100395:	88 90 20 40 12 c0    	mov    %dl,-0x3fedbfe0(%eax)
c010039b:	eb 4c                	jmp    c01003e9 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010039d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003a1:	75 1a                	jne    c01003bd <readline+0x8f>
c01003a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003a7:	7e 14                	jle    c01003bd <readline+0x8f>
            cputchar(c);
c01003a9:	83 ec 0c             	sub    $0xc,%esp
c01003ac:	ff 75 f0             	pushl  -0x10(%ebp)
c01003af:	e8 fc fe ff ff       	call   c01002b0 <cputchar>
c01003b4:	83 c4 10             	add    $0x10,%esp
            i --;
c01003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003bb:	eb 2c                	jmp    c01003e9 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01003bd:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003c1:	74 06                	je     c01003c9 <readline+0x9b>
c01003c3:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003c7:	75 8b                	jne    c0100354 <readline+0x26>
            cputchar(c);
c01003c9:	83 ec 0c             	sub    $0xc,%esp
c01003cc:	ff 75 f0             	pushl  -0x10(%ebp)
c01003cf:	e8 dc fe ff ff       	call   c01002b0 <cputchar>
c01003d4:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003da:	05 20 40 12 c0       	add    $0xc0124020,%eax
c01003df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003e2:	b8 20 40 12 c0       	mov    $0xc0124020,%eax
c01003e7:	eb 05                	jmp    c01003ee <readline+0xc0>
        }
    }
c01003e9:	e9 66 ff ff ff       	jmp    c0100354 <readline+0x26>
}
c01003ee:	c9                   	leave  
c01003ef:	c3                   	ret    

c01003f0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f0:	55                   	push   %ebp
c01003f1:	89 e5                	mov    %esp,%ebp
c01003f3:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003f6:	a1 20 44 12 c0       	mov    0xc0124420,%eax
c01003fb:	85 c0                	test   %eax,%eax
c01003fd:	75 4a                	jne    c0100449 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003ff:	c7 05 20 44 12 c0 01 	movl   $0x1,0xc0124420
c0100406:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100409:	8d 45 14             	lea    0x14(%ebp),%eax
c010040c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c010040f:	83 ec 04             	sub    $0x4,%esp
c0100412:	ff 75 0c             	pushl  0xc(%ebp)
c0100415:	ff 75 08             	pushl  0x8(%ebp)
c0100418:	68 2a 8d 10 c0       	push   $0xc0108d2a
c010041d:	e8 68 fe ff ff       	call   c010028a <cprintf>
c0100422:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100428:	83 ec 08             	sub    $0x8,%esp
c010042b:	50                   	push   %eax
c010042c:	ff 75 10             	pushl  0x10(%ebp)
c010042f:	e8 2d fe ff ff       	call   c0100261 <vcprintf>
c0100434:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100437:	83 ec 0c             	sub    $0xc,%esp
c010043a:	68 46 8d 10 c0       	push   $0xc0108d46
c010043f:	e8 46 fe ff ff       	call   c010028a <cprintf>
c0100444:	83 c4 10             	add    $0x10,%esp
c0100447:	eb 01                	jmp    c010044a <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100449:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c010044a:	e8 74 1c 00 00       	call   c01020c3 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010044f:	83 ec 0c             	sub    $0xc,%esp
c0100452:	6a 00                	push   $0x0
c0100454:	e8 3d 08 00 00       	call   c0100c96 <kmonitor>
c0100459:	83 c4 10             	add    $0x10,%esp
    }
c010045c:	eb f1                	jmp    c010044f <__panic+0x5f>

c010045e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010045e:	55                   	push   %ebp
c010045f:	89 e5                	mov    %esp,%ebp
c0100461:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100464:	8d 45 14             	lea    0x14(%ebp),%eax
c0100467:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010046a:	83 ec 04             	sub    $0x4,%esp
c010046d:	ff 75 0c             	pushl  0xc(%ebp)
c0100470:	ff 75 08             	pushl  0x8(%ebp)
c0100473:	68 48 8d 10 c0       	push   $0xc0108d48
c0100478:	e8 0d fe ff ff       	call   c010028a <cprintf>
c010047d:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100480:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100483:	83 ec 08             	sub    $0x8,%esp
c0100486:	50                   	push   %eax
c0100487:	ff 75 10             	pushl  0x10(%ebp)
c010048a:	e8 d2 fd ff ff       	call   c0100261 <vcprintf>
c010048f:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100492:	83 ec 0c             	sub    $0xc,%esp
c0100495:	68 46 8d 10 c0       	push   $0xc0108d46
c010049a:	e8 eb fd ff ff       	call   c010028a <cprintf>
c010049f:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01004a2:	90                   	nop
c01004a3:	c9                   	leave  
c01004a4:	c3                   	ret    

c01004a5 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004a5:	55                   	push   %ebp
c01004a6:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004a8:	a1 20 44 12 c0       	mov    0xc0124420,%eax
}
c01004ad:	5d                   	pop    %ebp
c01004ae:	c3                   	ret    

c01004af <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004af:	55                   	push   %ebp
c01004b0:	89 e5                	mov    %esp,%ebp
c01004b2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004b8:	8b 00                	mov    (%eax),%eax
c01004ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c0:	8b 00                	mov    (%eax),%eax
c01004c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004cc:	e9 d2 00 00 00       	jmp    c01005a3 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004d7:	01 d0                	add    %edx,%eax
c01004d9:	89 c2                	mov    %eax,%edx
c01004db:	c1 ea 1f             	shr    $0x1f,%edx
c01004de:	01 d0                	add    %edx,%eax
c01004e0:	d1 f8                	sar    %eax
c01004e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004e8:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004eb:	eb 04                	jmp    c01004f1 <stab_binsearch+0x42>
            m --;
c01004ed:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004f7:	7c 1f                	jl     c0100518 <stab_binsearch+0x69>
c01004f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004fc:	89 d0                	mov    %edx,%eax
c01004fe:	01 c0                	add    %eax,%eax
c0100500:	01 d0                	add    %edx,%eax
c0100502:	c1 e0 02             	shl    $0x2,%eax
c0100505:	89 c2                	mov    %eax,%edx
c0100507:	8b 45 08             	mov    0x8(%ebp),%eax
c010050a:	01 d0                	add    %edx,%eax
c010050c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100510:	0f b6 c0             	movzbl %al,%eax
c0100513:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100516:	75 d5                	jne    c01004ed <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100518:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010051b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051e:	7d 0b                	jge    c010052b <stab_binsearch+0x7c>
            l = true_m + 1;
c0100520:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100523:	83 c0 01             	add    $0x1,%eax
c0100526:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100529:	eb 78                	jmp    c01005a3 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c010052b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100532:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100535:	89 d0                	mov    %edx,%eax
c0100537:	01 c0                	add    %eax,%eax
c0100539:	01 d0                	add    %edx,%eax
c010053b:	c1 e0 02             	shl    $0x2,%eax
c010053e:	89 c2                	mov    %eax,%edx
c0100540:	8b 45 08             	mov    0x8(%ebp),%eax
c0100543:	01 d0                	add    %edx,%eax
c0100545:	8b 40 08             	mov    0x8(%eax),%eax
c0100548:	3b 45 18             	cmp    0x18(%ebp),%eax
c010054b:	73 13                	jae    c0100560 <stab_binsearch+0xb1>
            *region_left = m;
c010054d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100550:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100553:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100555:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100558:	83 c0 01             	add    $0x1,%eax
c010055b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010055e:	eb 43                	jmp    c01005a3 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100560:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100563:	89 d0                	mov    %edx,%eax
c0100565:	01 c0                	add    %eax,%eax
c0100567:	01 d0                	add    %edx,%eax
c0100569:	c1 e0 02             	shl    $0x2,%eax
c010056c:	89 c2                	mov    %eax,%edx
c010056e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100571:	01 d0                	add    %edx,%eax
c0100573:	8b 40 08             	mov    0x8(%eax),%eax
c0100576:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100579:	76 16                	jbe    c0100591 <stab_binsearch+0xe2>
            *region_right = m - 1;
c010057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100581:	8b 45 10             	mov    0x10(%ebp),%eax
c0100584:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100586:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100589:	83 e8 01             	sub    $0x1,%eax
c010058c:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010058f:	eb 12                	jmp    c01005a3 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100591:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100594:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100597:	89 10                	mov    %edx,(%eax)
            l = m;
c0100599:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010059f:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01005a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005a9:	0f 8e 22 ff ff ff    	jle    c01004d1 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01005af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005b3:	75 0f                	jne    c01005c4 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b8:	8b 00                	mov    (%eax),%eax
c01005ba:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c0:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005c2:	eb 3f                	jmp    c0100603 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c7:	8b 00                	mov    (%eax),%eax
c01005c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005cc:	eb 04                	jmp    c01005d2 <stab_binsearch+0x123>
c01005ce:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d5:	8b 00                	mov    (%eax),%eax
c01005d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005da:	7d 1f                	jge    c01005fb <stab_binsearch+0x14c>
c01005dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005df:	89 d0                	mov    %edx,%eax
c01005e1:	01 c0                	add    %eax,%eax
c01005e3:	01 d0                	add    %edx,%eax
c01005e5:	c1 e0 02             	shl    $0x2,%eax
c01005e8:	89 c2                	mov    %eax,%edx
c01005ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ed:	01 d0                	add    %edx,%eax
c01005ef:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005f3:	0f b6 c0             	movzbl %al,%eax
c01005f6:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005f9:	75 d3                	jne    c01005ce <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100601:	89 10                	mov    %edx,(%eax)
    }
}
c0100603:	90                   	nop
c0100604:	c9                   	leave  
c0100605:	c3                   	ret    

c0100606 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100606:	55                   	push   %ebp
c0100607:	89 e5                	mov    %esp,%ebp
c0100609:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010060c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060f:	c7 00 68 8d 10 c0    	movl   $0xc0108d68,(%eax)
    info->eip_line = 0;
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100622:	c7 40 08 68 8d 10 c0 	movl   $0xc0108d68,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100629:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100633:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100636:	8b 55 08             	mov    0x8(%ebp),%edx
c0100639:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010063c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100646:	c7 45 f4 d4 ae 10 c0 	movl   $0xc010aed4,-0xc(%ebp)
    stab_end = __STAB_END__;
c010064d:	c7 45 f0 e4 af 11 c0 	movl   $0xc011afe4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100654:	c7 45 ec e5 af 11 c0 	movl   $0xc011afe5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010065b:	c7 45 e8 b8 eb 11 c0 	movl   $0xc011ebb8,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100662:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100665:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100668:	76 0d                	jbe    c0100677 <debuginfo_eip+0x71>
c010066a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010066d:	83 e8 01             	sub    $0x1,%eax
c0100670:	0f b6 00             	movzbl (%eax),%eax
c0100673:	84 c0                	test   %al,%al
c0100675:	74 0a                	je     c0100681 <debuginfo_eip+0x7b>
        return -1;
c0100677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010067c:	e9 91 02 00 00       	jmp    c0100912 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100688:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010068b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068e:	29 c2                	sub    %eax,%edx
c0100690:	89 d0                	mov    %edx,%eax
c0100692:	c1 f8 02             	sar    $0x2,%eax
c0100695:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c010069b:	83 e8 01             	sub    $0x1,%eax
c010069e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006a1:	ff 75 08             	pushl  0x8(%ebp)
c01006a4:	6a 64                	push   $0x64
c01006a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006a9:	50                   	push   %eax
c01006aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006ad:	50                   	push   %eax
c01006ae:	ff 75 f4             	pushl  -0xc(%ebp)
c01006b1:	e8 f9 fd ff ff       	call   c01004af <stab_binsearch>
c01006b6:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01006b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006bc:	85 c0                	test   %eax,%eax
c01006be:	75 0a                	jne    c01006ca <debuginfo_eip+0xc4>
        return -1;
c01006c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006c5:	e9 48 02 00 00       	jmp    c0100912 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006d6:	ff 75 08             	pushl  0x8(%ebp)
c01006d9:	6a 24                	push   $0x24
c01006db:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006de:	50                   	push   %eax
c01006df:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006e2:	50                   	push   %eax
c01006e3:	ff 75 f4             	pushl  -0xc(%ebp)
c01006e6:	e8 c4 fd ff ff       	call   c01004af <stab_binsearch>
c01006eb:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006f4:	39 c2                	cmp    %eax,%edx
c01006f6:	7f 7c                	jg     c0100774 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	89 d0                	mov    %edx,%eax
c01006ff:	01 c0                	add    %eax,%eax
c0100701:	01 d0                	add    %edx,%eax
c0100703:	c1 e0 02             	shl    $0x2,%eax
c0100706:	89 c2                	mov    %eax,%edx
c0100708:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070b:	01 d0                	add    %edx,%eax
c010070d:	8b 00                	mov    (%eax),%eax
c010070f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100712:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100715:	29 d1                	sub    %edx,%ecx
c0100717:	89 ca                	mov    %ecx,%edx
c0100719:	39 d0                	cmp    %edx,%eax
c010071b:	73 22                	jae    c010073f <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010071d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100720:	89 c2                	mov    %eax,%edx
c0100722:	89 d0                	mov    %edx,%eax
c0100724:	01 c0                	add    %eax,%eax
c0100726:	01 d0                	add    %edx,%eax
c0100728:	c1 e0 02             	shl    $0x2,%eax
c010072b:	89 c2                	mov    %eax,%edx
c010072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100730:	01 d0                	add    %edx,%eax
c0100732:	8b 10                	mov    (%eax),%edx
c0100734:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100737:	01 c2                	add    %eax,%edx
c0100739:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073c:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010073f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100742:	89 c2                	mov    %eax,%edx
c0100744:	89 d0                	mov    %edx,%eax
c0100746:	01 c0                	add    %eax,%eax
c0100748:	01 d0                	add    %edx,%eax
c010074a:	c1 e0 02             	shl    $0x2,%eax
c010074d:	89 c2                	mov    %eax,%edx
c010074f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100752:	01 d0                	add    %edx,%eax
c0100754:	8b 50 08             	mov    0x8(%eax),%edx
c0100757:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075a:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010075d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100760:	8b 40 10             	mov    0x10(%eax),%eax
c0100763:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100766:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100769:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010076c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010076f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100772:	eb 15                	jmp    c0100789 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100774:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100777:	8b 55 08             	mov    0x8(%ebp),%edx
c010077a:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010077d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100783:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100786:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078c:	8b 40 08             	mov    0x8(%eax),%eax
c010078f:	83 ec 08             	sub    $0x8,%esp
c0100792:	6a 3a                	push   $0x3a
c0100794:	50                   	push   %eax
c0100795:	e8 d1 7a 00 00       	call   c010826b <strfind>
c010079a:	83 c4 10             	add    $0x10,%esp
c010079d:	89 c2                	mov    %eax,%edx
c010079f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a2:	8b 40 08             	mov    0x8(%eax),%eax
c01007a5:	29 c2                	sub    %eax,%edx
c01007a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007aa:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007ad:	83 ec 0c             	sub    $0xc,%esp
c01007b0:	ff 75 08             	pushl  0x8(%ebp)
c01007b3:	6a 44                	push   $0x44
c01007b5:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007b8:	50                   	push   %eax
c01007b9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007bc:	50                   	push   %eax
c01007bd:	ff 75 f4             	pushl  -0xc(%ebp)
c01007c0:	e8 ea fc ff ff       	call   c01004af <stab_binsearch>
c01007c5:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ce:	39 c2                	cmp    %eax,%edx
c01007d0:	7f 24                	jg     c01007f6 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007d5:	89 c2                	mov    %eax,%edx
c01007d7:	89 d0                	mov    %edx,%eax
c01007d9:	01 c0                	add    %eax,%eax
c01007db:	01 d0                	add    %edx,%eax
c01007dd:	c1 e0 02             	shl    $0x2,%eax
c01007e0:	89 c2                	mov    %eax,%edx
c01007e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e5:	01 d0                	add    %edx,%eax
c01007e7:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007eb:	0f b7 d0             	movzwl %ax,%edx
c01007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f1:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007f4:	eb 13                	jmp    c0100809 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007fb:	e9 12 01 00 00       	jmp    c0100912 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	83 e8 01             	sub    $0x1,%eax
c0100806:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100809:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010080f:	39 c2                	cmp    %eax,%edx
c0100811:	7c 56                	jl     c0100869 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c0100813:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100816:	89 c2                	mov    %eax,%edx
c0100818:	89 d0                	mov    %edx,%eax
c010081a:	01 c0                	add    %eax,%eax
c010081c:	01 d0                	add    %edx,%eax
c010081e:	c1 e0 02             	shl    $0x2,%eax
c0100821:	89 c2                	mov    %eax,%edx
c0100823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100826:	01 d0                	add    %edx,%eax
c0100828:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010082c:	3c 84                	cmp    $0x84,%al
c010082e:	74 39                	je     c0100869 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100833:	89 c2                	mov    %eax,%edx
c0100835:	89 d0                	mov    %edx,%eax
c0100837:	01 c0                	add    %eax,%eax
c0100839:	01 d0                	add    %edx,%eax
c010083b:	c1 e0 02             	shl    $0x2,%eax
c010083e:	89 c2                	mov    %eax,%edx
c0100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100843:	01 d0                	add    %edx,%eax
c0100845:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100849:	3c 64                	cmp    $0x64,%al
c010084b:	75 b3                	jne    c0100800 <debuginfo_eip+0x1fa>
c010084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100850:	89 c2                	mov    %eax,%edx
c0100852:	89 d0                	mov    %edx,%eax
c0100854:	01 c0                	add    %eax,%eax
c0100856:	01 d0                	add    %edx,%eax
c0100858:	c1 e0 02             	shl    $0x2,%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	8b 40 08             	mov    0x8(%eax),%eax
c0100865:	85 c0                	test   %eax,%eax
c0100867:	74 97                	je     c0100800 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100869:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010086c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010086f:	39 c2                	cmp    %eax,%edx
c0100871:	7c 46                	jl     c01008b9 <debuginfo_eip+0x2b3>
c0100873:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100876:	89 c2                	mov    %eax,%edx
c0100878:	89 d0                	mov    %edx,%eax
c010087a:	01 c0                	add    %eax,%eax
c010087c:	01 d0                	add    %edx,%eax
c010087e:	c1 e0 02             	shl    $0x2,%eax
c0100881:	89 c2                	mov    %eax,%edx
c0100883:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100886:	01 d0                	add    %edx,%eax
c0100888:	8b 00                	mov    (%eax),%eax
c010088a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010088d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100890:	29 d1                	sub    %edx,%ecx
c0100892:	89 ca                	mov    %ecx,%edx
c0100894:	39 d0                	cmp    %edx,%eax
c0100896:	73 21                	jae    c01008b9 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010089b:	89 c2                	mov    %eax,%edx
c010089d:	89 d0                	mov    %edx,%eax
c010089f:	01 c0                	add    %eax,%eax
c01008a1:	01 d0                	add    %edx,%eax
c01008a3:	c1 e0 02             	shl    $0x2,%eax
c01008a6:	89 c2                	mov    %eax,%edx
c01008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ab:	01 d0                	add    %edx,%eax
c01008ad:	8b 10                	mov    (%eax),%edx
c01008af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008b2:	01 c2                	add    %eax,%edx
c01008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b7:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008bf:	39 c2                	cmp    %eax,%edx
c01008c1:	7d 4a                	jge    c010090d <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008c6:	83 c0 01             	add    $0x1,%eax
c01008c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008cc:	eb 18                	jmp    c01008e6 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008d1:	8b 40 14             	mov    0x14(%eax),%eax
c01008d4:	8d 50 01             	lea    0x1(%eax),%edx
c01008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008da:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008e0:	83 c0 01             	add    $0x1,%eax
c01008e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008ec:	39 c2                	cmp    %eax,%edx
c01008ee:	7d 1d                	jge    c010090d <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f3:	89 c2                	mov    %eax,%edx
c01008f5:	89 d0                	mov    %edx,%eax
c01008f7:	01 c0                	add    %eax,%eax
c01008f9:	01 d0                	add    %edx,%eax
c01008fb:	c1 e0 02             	shl    $0x2,%eax
c01008fe:	89 c2                	mov    %eax,%edx
c0100900:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100903:	01 d0                	add    %edx,%eax
c0100905:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100909:	3c a0                	cmp    $0xa0,%al
c010090b:	74 c1                	je     c01008ce <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010090d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100912:	c9                   	leave  
c0100913:	c3                   	ret    

c0100914 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100914:	55                   	push   %ebp
c0100915:	89 e5                	mov    %esp,%ebp
c0100917:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010091a:	83 ec 0c             	sub    $0xc,%esp
c010091d:	68 72 8d 10 c0       	push   $0xc0108d72
c0100922:	e8 63 f9 ff ff       	call   c010028a <cprintf>
c0100927:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010092a:	83 ec 08             	sub    $0x8,%esp
c010092d:	68 36 00 10 c0       	push   $0xc0100036
c0100932:	68 8b 8d 10 c0       	push   $0xc0108d8b
c0100937:	e8 4e f9 ff ff       	call   c010028a <cprintf>
c010093c:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010093f:	83 ec 08             	sub    $0x8,%esp
c0100942:	68 66 8c 10 c0       	push   $0xc0108c66
c0100947:	68 a3 8d 10 c0       	push   $0xc0108da3
c010094c:	e8 39 f9 ff ff       	call   c010028a <cprintf>
c0100951:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100954:	83 ec 08             	sub    $0x8,%esp
c0100957:	68 00 40 12 c0       	push   $0xc0124000
c010095c:	68 bb 8d 10 c0       	push   $0xc0108dbb
c0100961:	e8 24 f9 ff ff       	call   c010028a <cprintf>
c0100966:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100969:	83 ec 08             	sub    $0x8,%esp
c010096c:	68 5c 51 12 c0       	push   $0xc012515c
c0100971:	68 d3 8d 10 c0       	push   $0xc0108dd3
c0100976:	e8 0f f9 ff ff       	call   c010028a <cprintf>
c010097b:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010097e:	b8 5c 51 12 c0       	mov    $0xc012515c,%eax
c0100983:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100988:	ba 36 00 10 c0       	mov    $0xc0100036,%edx
c010098d:	29 d0                	sub    %edx,%eax
c010098f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100995:	85 c0                	test   %eax,%eax
c0100997:	0f 48 c2             	cmovs  %edx,%eax
c010099a:	c1 f8 0a             	sar    $0xa,%eax
c010099d:	83 ec 08             	sub    $0x8,%esp
c01009a0:	50                   	push   %eax
c01009a1:	68 ec 8d 10 c0       	push   $0xc0108dec
c01009a6:	e8 df f8 ff ff       	call   c010028a <cprintf>
c01009ab:	83 c4 10             	add    $0x10,%esp
}
c01009ae:	90                   	nop
c01009af:	c9                   	leave  
c01009b0:	c3                   	ret    

c01009b1 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009b1:	55                   	push   %ebp
c01009b2:	89 e5                	mov    %esp,%ebp
c01009b4:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009ba:	83 ec 08             	sub    $0x8,%esp
c01009bd:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009c0:	50                   	push   %eax
c01009c1:	ff 75 08             	pushl  0x8(%ebp)
c01009c4:	e8 3d fc ff ff       	call   c0100606 <debuginfo_eip>
c01009c9:	83 c4 10             	add    $0x10,%esp
c01009cc:	85 c0                	test   %eax,%eax
c01009ce:	74 15                	je     c01009e5 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009d0:	83 ec 08             	sub    $0x8,%esp
c01009d3:	ff 75 08             	pushl  0x8(%ebp)
c01009d6:	68 16 8e 10 c0       	push   $0xc0108e16
c01009db:	e8 aa f8 ff ff       	call   c010028a <cprintf>
c01009e0:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009e3:	eb 65                	jmp    c0100a4a <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009ec:	eb 1c                	jmp    c0100a0a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	01 d0                	add    %edx,%eax
c01009f6:	0f b6 00             	movzbl (%eax),%eax
c01009f9:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a02:	01 ca                	add    %ecx,%edx
c0100a04:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a10:	7f dc                	jg     c01009ee <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a12:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a1b:	01 d0                	add    %edx,%eax
c0100a1d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a23:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a26:	89 d1                	mov    %edx,%ecx
c0100a28:	29 c1                	sub    %eax,%ecx
c0100a2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a30:	83 ec 0c             	sub    $0xc,%esp
c0100a33:	51                   	push   %ecx
c0100a34:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a3a:	51                   	push   %ecx
c0100a3b:	52                   	push   %edx
c0100a3c:	50                   	push   %eax
c0100a3d:	68 32 8e 10 c0       	push   $0xc0108e32
c0100a42:	e8 43 f8 ff ff       	call   c010028a <cprintf>
c0100a47:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a4a:	90                   	nop
c0100a4b:	c9                   	leave  
c0100a4c:	c3                   	ret    

c0100a4d <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a4d:	55                   	push   %ebp
c0100a4e:	89 e5                	mov    %esp,%ebp
c0100a50:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a53:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a5c:	c9                   	leave  
c0100a5d:	c3                   	ret    

c0100a5e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a5e:	55                   	push   %ebp
c0100a5f:	89 e5                	mov    %esp,%ebp
c0100a61:	53                   	push   %ebx
c0100a62:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a65:	89 e8                	mov    %ebp,%eax
c0100a67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
c0100a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
c0100a70:	e8 d8 ff ff ff       	call   c0100a4d <read_eip>
c0100a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c0100a78:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a7f:	e9 93 00 00 00       	jmp    c0100b17 <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
c0100a84:	83 ec 04             	sub    $0x4,%esp
c0100a87:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a8a:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a8d:	68 44 8e 10 c0       	push   $0xc0108e44
c0100a92:	e8 f3 f7 ff ff       	call   c010028a <cprintf>
c0100a97:	83 c4 10             	add    $0x10,%esp
        // get args
        for (int j = 0; j < 4; j++) {
c0100a9a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100aa1:	eb 1f                	jmp    c0100ac2 <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
c0100aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aa6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab0:	01 d0                	add    %edx,%eax
c0100ab2:	83 c0 08             	add    $0x8,%eax
c0100ab5:	8b 10                	mov    (%eax),%edx
c0100ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aba:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
        // get args
        for (int j = 0; j < 4; j++) {
c0100abe:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100ac2:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ac6:	7e db                	jle    c0100aa3 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
c0100ac8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c0100acb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0100ace:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0100ad1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100ad4:	83 ec 0c             	sub    $0xc,%esp
c0100ad7:	53                   	push   %ebx
c0100ad8:	51                   	push   %ecx
c0100ad9:	52                   	push   %edx
c0100ada:	50                   	push   %eax
c0100adb:	68 5c 8e 10 c0       	push   $0xc0108e5c
c0100ae0:	e8 a5 f7 ff ff       	call   c010028a <cprintf>
c0100ae5:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);
        // print function info
        print_debuginfo(stack_val_eip - 1);
c0100ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aeb:	83 e8 01             	sub    $0x1,%eax
c0100aee:	83 ec 0c             	sub    $0xc,%esp
c0100af1:	50                   	push   %eax
c0100af2:	e8 ba fe ff ff       	call   c01009b1 <print_debuginfo>
c0100af7:	83 c4 10             	add    $0x10,%esp
        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
c0100afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afd:	83 c0 04             	add    $0x4,%eax
c0100b00:	8b 00                	mov    (%eax),%eax
c0100b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
c0100b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b08:	8b 00                	mov    (%eax),%eax
c0100b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // ebp should be valid
        if (stack_val_ebp <= 0) {
c0100b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b11:	74 10                	je     c0100b23 <print_stackframe+0xc5>
    uint32_t stack_val_ebp = read_ebp();
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c0100b13:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b17:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b1b:	0f 8e 63 ff ff ff    	jle    c0100a84 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
c0100b21:	eb 01                	jmp    c0100b24 <print_stackframe+0xc6>
        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
c0100b23:	90                   	nop
        }
    }
}
c0100b24:	90                   	nop
c0100b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100b28:	c9                   	leave  
c0100b29:	c3                   	ret    

c0100b2a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b2a:	55                   	push   %ebp
c0100b2b:	89 e5                	mov    %esp,%ebp
c0100b2d:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b37:	eb 0c                	jmp    c0100b45 <parse+0x1b>
            *buf ++ = '\0';
c0100b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3c:	8d 50 01             	lea    0x1(%eax),%edx
c0100b3f:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b42:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b48:	0f b6 00             	movzbl (%eax),%eax
c0100b4b:	84 c0                	test   %al,%al
c0100b4d:	74 1e                	je     c0100b6d <parse+0x43>
c0100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b52:	0f b6 00             	movzbl (%eax),%eax
c0100b55:	0f be c0             	movsbl %al,%eax
c0100b58:	83 ec 08             	sub    $0x8,%esp
c0100b5b:	50                   	push   %eax
c0100b5c:	68 00 8f 10 c0       	push   $0xc0108f00
c0100b61:	e8 d2 76 00 00       	call   c0108238 <strchr>
c0100b66:	83 c4 10             	add    $0x10,%esp
c0100b69:	85 c0                	test   %eax,%eax
c0100b6b:	75 cc                	jne    c0100b39 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b70:	0f b6 00             	movzbl (%eax),%eax
c0100b73:	84 c0                	test   %al,%al
c0100b75:	74 69                	je     c0100be0 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b77:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b7b:	75 12                	jne    c0100b8f <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b7d:	83 ec 08             	sub    $0x8,%esp
c0100b80:	6a 10                	push   $0x10
c0100b82:	68 05 8f 10 c0       	push   $0xc0108f05
c0100b87:	e8 fe f6 ff ff       	call   c010028a <cprintf>
c0100b8c:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b92:	8d 50 01             	lea    0x1(%eax),%edx
c0100b95:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ba2:	01 c2                	add    %eax,%edx
c0100ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ba9:	eb 04                	jmp    c0100baf <parse+0x85>
            buf ++;
c0100bab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb2:	0f b6 00             	movzbl (%eax),%eax
c0100bb5:	84 c0                	test   %al,%al
c0100bb7:	0f 84 7a ff ff ff    	je     c0100b37 <parse+0xd>
c0100bbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc0:	0f b6 00             	movzbl (%eax),%eax
c0100bc3:	0f be c0             	movsbl %al,%eax
c0100bc6:	83 ec 08             	sub    $0x8,%esp
c0100bc9:	50                   	push   %eax
c0100bca:	68 00 8f 10 c0       	push   $0xc0108f00
c0100bcf:	e8 64 76 00 00       	call   c0108238 <strchr>
c0100bd4:	83 c4 10             	add    $0x10,%esp
c0100bd7:	85 c0                	test   %eax,%eax
c0100bd9:	74 d0                	je     c0100bab <parse+0x81>
            buf ++;
        }
    }
c0100bdb:	e9 57 ff ff ff       	jmp    c0100b37 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100be0:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100be4:	c9                   	leave  
c0100be5:	c3                   	ret    

c0100be6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100be6:	55                   	push   %ebp
c0100be7:	89 e5                	mov    %esp,%ebp
c0100be9:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bec:	83 ec 08             	sub    $0x8,%esp
c0100bef:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bf2:	50                   	push   %eax
c0100bf3:	ff 75 08             	pushl  0x8(%ebp)
c0100bf6:	e8 2f ff ff ff       	call   c0100b2a <parse>
c0100bfb:	83 c4 10             	add    $0x10,%esp
c0100bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c05:	75 0a                	jne    c0100c11 <runcmd+0x2b>
        return 0;
c0100c07:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c0c:	e9 83 00 00 00       	jmp    c0100c94 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c18:	eb 59                	jmp    c0100c73 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c1a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c20:	89 d0                	mov    %edx,%eax
c0100c22:	01 c0                	add    %eax,%eax
c0100c24:	01 d0                	add    %edx,%eax
c0100c26:	c1 e0 02             	shl    $0x2,%eax
c0100c29:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100c2e:	8b 00                	mov    (%eax),%eax
c0100c30:	83 ec 08             	sub    $0x8,%esp
c0100c33:	51                   	push   %ecx
c0100c34:	50                   	push   %eax
c0100c35:	e8 5e 75 00 00       	call   c0108198 <strcmp>
c0100c3a:	83 c4 10             	add    $0x10,%esp
c0100c3d:	85 c0                	test   %eax,%eax
c0100c3f:	75 2e                	jne    c0100c6f <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c44:	89 d0                	mov    %edx,%eax
c0100c46:	01 c0                	add    %eax,%eax
c0100c48:	01 d0                	add    %edx,%eax
c0100c4a:	c1 e0 02             	shl    $0x2,%eax
c0100c4d:	05 08 10 12 c0       	add    $0xc0121008,%eax
c0100c52:	8b 10                	mov    (%eax),%edx
c0100c54:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c57:	83 c0 04             	add    $0x4,%eax
c0100c5a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c5d:	83 e9 01             	sub    $0x1,%ecx
c0100c60:	83 ec 04             	sub    $0x4,%esp
c0100c63:	ff 75 0c             	pushl  0xc(%ebp)
c0100c66:	50                   	push   %eax
c0100c67:	51                   	push   %ecx
c0100c68:	ff d2                	call   *%edx
c0100c6a:	83 c4 10             	add    $0x10,%esp
c0100c6d:	eb 25                	jmp    c0100c94 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c76:	83 f8 02             	cmp    $0x2,%eax
c0100c79:	76 9f                	jbe    c0100c1a <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c7e:	83 ec 08             	sub    $0x8,%esp
c0100c81:	50                   	push   %eax
c0100c82:	68 23 8f 10 c0       	push   $0xc0108f23
c0100c87:	e8 fe f5 ff ff       	call   c010028a <cprintf>
c0100c8c:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c94:	c9                   	leave  
c0100c95:	c3                   	ret    

c0100c96 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c96:	55                   	push   %ebp
c0100c97:	89 e5                	mov    %esp,%ebp
c0100c99:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c9c:	83 ec 0c             	sub    $0xc,%esp
c0100c9f:	68 3c 8f 10 c0       	push   $0xc0108f3c
c0100ca4:	e8 e1 f5 ff ff       	call   c010028a <cprintf>
c0100ca9:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100cac:	83 ec 0c             	sub    $0xc,%esp
c0100caf:	68 64 8f 10 c0       	push   $0xc0108f64
c0100cb4:	e8 d1 f5 ff ff       	call   c010028a <cprintf>
c0100cb9:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100cbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cc0:	74 0e                	je     c0100cd0 <kmonitor+0x3a>
        print_trapframe(tf);
c0100cc2:	83 ec 0c             	sub    $0xc,%esp
c0100cc5:	ff 75 08             	pushl  0x8(%ebp)
c0100cc8:	e8 d0 15 00 00       	call   c010229d <print_trapframe>
c0100ccd:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cd0:	83 ec 0c             	sub    $0xc,%esp
c0100cd3:	68 89 8f 10 c0       	push   $0xc0108f89
c0100cd8:	e8 51 f6 ff ff       	call   c010032e <readline>
c0100cdd:	83 c4 10             	add    $0x10,%esp
c0100ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ce7:	74 e7                	je     c0100cd0 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100ce9:	83 ec 08             	sub    $0x8,%esp
c0100cec:	ff 75 08             	pushl  0x8(%ebp)
c0100cef:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cf2:	e8 ef fe ff ff       	call   c0100be6 <runcmd>
c0100cf7:	83 c4 10             	add    $0x10,%esp
c0100cfa:	85 c0                	test   %eax,%eax
c0100cfc:	78 02                	js     c0100d00 <kmonitor+0x6a>
                break;
            }
        }
    }
c0100cfe:	eb d0                	jmp    c0100cd0 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100d00:	90                   	nop
            }
        }
    }
}
c0100d01:	90                   	nop
c0100d02:	c9                   	leave  
c0100d03:	c3                   	ret    

c0100d04 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d04:	55                   	push   %ebp
c0100d05:	89 e5                	mov    %esp,%ebp
c0100d07:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d11:	eb 3c                	jmp    c0100d4f <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d16:	89 d0                	mov    %edx,%eax
c0100d18:	01 c0                	add    %eax,%eax
c0100d1a:	01 d0                	add    %edx,%eax
c0100d1c:	c1 e0 02             	shl    $0x2,%eax
c0100d1f:	05 04 10 12 c0       	add    $0xc0121004,%eax
c0100d24:	8b 08                	mov    (%eax),%ecx
c0100d26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d29:	89 d0                	mov    %edx,%eax
c0100d2b:	01 c0                	add    %eax,%eax
c0100d2d:	01 d0                	add    %edx,%eax
c0100d2f:	c1 e0 02             	shl    $0x2,%eax
c0100d32:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100d37:	8b 00                	mov    (%eax),%eax
c0100d39:	83 ec 04             	sub    $0x4,%esp
c0100d3c:	51                   	push   %ecx
c0100d3d:	50                   	push   %eax
c0100d3e:	68 8d 8f 10 c0       	push   $0xc0108f8d
c0100d43:	e8 42 f5 ff ff       	call   c010028a <cprintf>
c0100d48:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d52:	83 f8 02             	cmp    $0x2,%eax
c0100d55:	76 bc                	jbe    c0100d13 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d5c:	c9                   	leave  
c0100d5d:	c3                   	ret    

c0100d5e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d5e:	55                   	push   %ebp
c0100d5f:	89 e5                	mov    %esp,%ebp
c0100d61:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d64:	e8 ab fb ff ff       	call   c0100914 <print_kerninfo>
    return 0;
c0100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d6e:	c9                   	leave  
c0100d6f:	c3                   	ret    

c0100d70 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d70:	55                   	push   %ebp
c0100d71:	89 e5                	mov    %esp,%ebp
c0100d73:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d76:	e8 e3 fc ff ff       	call   c0100a5e <print_stackframe>
    return 0;
c0100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d80:	c9                   	leave  
c0100d81:	c3                   	ret    

c0100d82 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 14             	sub    $0x14,%esp
c0100d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d8b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100d8f:	90                   	nop
c0100d90:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0100d94:	83 c0 07             	add    $0x7,%eax
c0100d97:	0f b7 c0             	movzwl %ax,%eax
c0100d9a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d9e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100da2:	89 c2                	mov    %eax,%edx
c0100da4:	ec                   	in     (%dx),%al
c0100da5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100da8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100dac:	0f b6 c0             	movzbl %al,%eax
c0100daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100db5:	25 80 00 00 00       	and    $0x80,%eax
c0100dba:	85 c0                	test   %eax,%eax
c0100dbc:	75 d2                	jne    c0100d90 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100dbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100dc2:	74 11                	je     c0100dd5 <ide_wait_ready+0x53>
c0100dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dc7:	83 e0 21             	and    $0x21,%eax
c0100dca:	85 c0                	test   %eax,%eax
c0100dcc:	74 07                	je     c0100dd5 <ide_wait_ready+0x53>
        return -1;
c0100dce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100dd3:	eb 05                	jmp    c0100dda <ide_wait_ready+0x58>
    }
    return 0;
c0100dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dda:	c9                   	leave  
c0100ddb:	c3                   	ret    

c0100ddc <ide_init>:

void
ide_init(void) {
c0100ddc:	55                   	push   %ebp
c0100ddd:	89 e5                	mov    %esp,%ebp
c0100ddf:	57                   	push   %edi
c0100de0:	53                   	push   %ebx
c0100de1:	81 ec 40 02 00 00    	sub    $0x240,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100de7:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100ded:	e9 c1 02 00 00       	jmp    c01010b3 <ide_init+0x2d7>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100df2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100df6:	c1 e0 03             	shl    $0x3,%eax
c0100df9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100e00:	29 c2                	sub    %eax,%edx
c0100e02:	89 d0                	mov    %edx,%eax
c0100e04:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0100e09:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e0c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e10:	66 d1 e8             	shr    %ax
c0100e13:	0f b7 c0             	movzwl %ax,%eax
c0100e16:	0f b7 04 85 98 8f 10 	movzwl -0x3fef7068(,%eax,4),%eax
c0100e1d:	c0 
c0100e1e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e22:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e26:	6a 00                	push   $0x0
c0100e28:	50                   	push   %eax
c0100e29:	e8 54 ff ff ff       	call   c0100d82 <ide_wait_ready>
c0100e2e:	83 c4 08             	add    $0x8,%esp

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e31:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e35:	83 e0 01             	and    $0x1,%eax
c0100e38:	c1 e0 04             	shl    $0x4,%eax
c0100e3b:	83 c8 e0             	or     $0xffffffe0,%eax
c0100e3e:	0f b6 c0             	movzbl %al,%eax
c0100e41:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e45:	83 c2 06             	add    $0x6,%edx
c0100e48:	0f b7 d2             	movzwl %dx,%edx
c0100e4b:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0100e4f:	88 45 c7             	mov    %al,-0x39(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e52:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
c0100e56:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100e5a:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e5b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e5f:	6a 00                	push   $0x0
c0100e61:	50                   	push   %eax
c0100e62:	e8 1b ff ff ff       	call   c0100d82 <ide_wait_ready>
c0100e67:	83 c4 08             	add    $0x8,%esp

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100e6a:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e6e:	83 c0 07             	add    $0x7,%eax
c0100e71:	0f b7 c0             	movzwl %ax,%eax
c0100e74:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
c0100e78:	c6 45 c8 ec          	movb   $0xec,-0x38(%ebp)
c0100e7c:	0f b6 45 c8          	movzbl -0x38(%ebp),%eax
c0100e80:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c0100e84:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e85:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e89:	6a 00                	push   $0x0
c0100e8b:	50                   	push   %eax
c0100e8c:	e8 f1 fe ff ff       	call   c0100d82 <ide_wait_ready>
c0100e91:	83 c4 08             	add    $0x8,%esp

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100e94:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e98:	83 c0 07             	add    $0x7,%eax
c0100e9b:	0f b7 c0             	movzwl %ax,%eax
c0100e9e:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ea2:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0100ea6:	89 c2                	mov    %eax,%edx
c0100ea8:	ec                   	in     (%dx),%al
c0100ea9:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0100eac:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100eb0:	84 c0                	test   %al,%al
c0100eb2:	0f 84 ef 01 00 00    	je     c01010a7 <ide_init+0x2cb>
c0100eb8:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ebc:	6a 01                	push   $0x1
c0100ebe:	50                   	push   %eax
c0100ebf:	e8 be fe ff ff       	call   c0100d82 <ide_wait_ready>
c0100ec4:	83 c4 08             	add    $0x8,%esp
c0100ec7:	85 c0                	test   %eax,%eax
c0100ec9:	0f 85 d8 01 00 00    	jne    c01010a7 <ide_init+0x2cb>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100ecf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ed3:	c1 e0 03             	shl    $0x3,%eax
c0100ed6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100edd:	29 c2                	sub    %eax,%edx
c0100edf:	89 d0                	mov    %edx,%eax
c0100ee1:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0100ee6:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100ee9:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100eed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100ef0:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100ef6:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100ef9:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0100f00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100f03:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100f06:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100f09:	89 cb                	mov    %ecx,%ebx
c0100f0b:	89 df                	mov    %ebx,%edi
c0100f0d:	89 c1                	mov    %eax,%ecx
c0100f0f:	fc                   	cld    
c0100f10:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100f12:	89 c8                	mov    %ecx,%eax
c0100f14:	89 fb                	mov    %edi,%ebx
c0100f16:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f19:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f1c:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f22:	89 45 dc             	mov    %eax,-0x24(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f25:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f28:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f31:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f34:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f39:	85 c0                	test   %eax,%eax
c0100f3b:	74 0e                	je     c0100f4b <ide_init+0x16f>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f40:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100f46:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100f49:	eb 09                	jmp    c0100f54 <ide_init+0x178>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100f4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f4e:	8b 40 78             	mov    0x78(%eax),%eax
c0100f51:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100f54:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f58:	c1 e0 03             	shl    $0x3,%eax
c0100f5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f62:	29 c2                	sub    %eax,%edx
c0100f64:	89 d0                	mov    %edx,%eax
c0100f66:	8d 90 44 44 12 c0    	lea    -0x3fedbbbc(%eax),%edx
c0100f6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f6f:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100f71:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f75:	c1 e0 03             	shl    $0x3,%eax
c0100f78:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f7f:	29 c2                	sub    %eax,%edx
c0100f81:	89 d0                	mov    %edx,%eax
c0100f83:	8d 90 48 44 12 c0    	lea    -0x3fedbbb8(%eax),%edx
c0100f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f8c:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100f8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f91:	83 c0 62             	add    $0x62,%eax
c0100f94:	0f b7 00             	movzwl (%eax),%eax
c0100f97:	0f b7 c0             	movzwl %ax,%eax
c0100f9a:	25 00 02 00 00       	and    $0x200,%eax
c0100f9f:	85 c0                	test   %eax,%eax
c0100fa1:	75 16                	jne    c0100fb9 <ide_init+0x1dd>
c0100fa3:	68 a0 8f 10 c0       	push   $0xc0108fa0
c0100fa8:	68 e3 8f 10 c0       	push   $0xc0108fe3
c0100fad:	6a 7d                	push   $0x7d
c0100faf:	68 f8 8f 10 c0       	push   $0xc0108ff8
c0100fb4:	e8 37 f4 ff ff       	call   c01003f0 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0100fb9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fbd:	89 c2                	mov    %eax,%edx
c0100fbf:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fc6:	89 c2                	mov    %eax,%edx
c0100fc8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fcf:	29 d0                	sub    %edx,%eax
c0100fd1:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0100fd6:	83 c0 0c             	add    $0xc,%eax
c0100fd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100fdf:	83 c0 36             	add    $0x36,%eax
c0100fe2:	89 45 d0             	mov    %eax,-0x30(%ebp)
        unsigned int i, length = 40;
c0100fe5:	c7 45 cc 28 00 00 00 	movl   $0x28,-0x34(%ebp)
        for (i = 0; i < length; i += 2) {
c0100fec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ff3:	eb 34                	jmp    c0101029 <ide_init+0x24d>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0100ff5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100ffb:	01 c2                	add    %eax,%edx
c0100ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101000:	8d 48 01             	lea    0x1(%eax),%ecx
c0101003:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101006:	01 c8                	add    %ecx,%eax
c0101008:	0f b6 00             	movzbl (%eax),%eax
c010100b:	88 02                	mov    %al,(%edx)
c010100d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101010:	8d 50 01             	lea    0x1(%eax),%edx
c0101013:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101016:	01 c2                	add    %eax,%edx
c0101018:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010101b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010101e:	01 c8                	add    %ecx,%eax
c0101020:	0f b6 00             	movzbl (%eax),%eax
c0101023:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101025:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101029:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010102c:	3b 45 cc             	cmp    -0x34(%ebp),%eax
c010102f:	72 c4                	jb     c0100ff5 <ide_init+0x219>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101031:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101034:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101037:	01 d0                	add    %edx,%eax
c0101039:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010103c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010103f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101042:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101045:	85 c0                	test   %eax,%eax
c0101047:	74 0f                	je     c0101058 <ide_init+0x27c>
c0101049:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010104c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010104f:	01 d0                	add    %edx,%eax
c0101051:	0f b6 00             	movzbl (%eax),%eax
c0101054:	3c 20                	cmp    $0x20,%al
c0101056:	74 d9                	je     c0101031 <ide_init+0x255>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101058:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010105c:	89 c2                	mov    %eax,%edx
c010105e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0101065:	89 c2                	mov    %eax,%edx
c0101067:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c010106e:	29 d0                	sub    %edx,%eax
c0101070:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0101075:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101078:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010107c:	c1 e0 03             	shl    $0x3,%eax
c010107f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101086:	29 c2                	sub    %eax,%edx
c0101088:	89 d0                	mov    %edx,%eax
c010108a:	05 48 44 12 c0       	add    $0xc0124448,%eax
c010108f:	8b 10                	mov    (%eax),%edx
c0101091:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101095:	51                   	push   %ecx
c0101096:	52                   	push   %edx
c0101097:	50                   	push   %eax
c0101098:	68 0a 90 10 c0       	push   $0xc010900a
c010109d:	e8 e8 f1 ff ff       	call   c010028a <cprintf>
c01010a2:	83 c4 10             	add    $0x10,%esp
c01010a5:	eb 01                	jmp    c01010a8 <ide_init+0x2cc>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c01010a7:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01010a8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010ac:	83 c0 01             	add    $0x1,%eax
c01010af:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01010b3:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01010b8:	0f 86 34 fd ff ff    	jbe    c0100df2 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01010be:	83 ec 0c             	sub    $0xc,%esp
c01010c1:	6a 0e                	push   $0xe
c01010c3:	e8 8a 0e 00 00       	call   c0101f52 <pic_enable>
c01010c8:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_IDE2);
c01010cb:	83 ec 0c             	sub    $0xc,%esp
c01010ce:	6a 0f                	push   $0xf
c01010d0:	e8 7d 0e 00 00       	call   c0101f52 <pic_enable>
c01010d5:	83 c4 10             	add    $0x10,%esp
}
c01010d8:	90                   	nop
c01010d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01010dc:	5b                   	pop    %ebx
c01010dd:	5f                   	pop    %edi
c01010de:	5d                   	pop    %ebp
c01010df:	c3                   	ret    

c01010e0 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c01010e0:	55                   	push   %ebp
c01010e1:	89 e5                	mov    %esp,%ebp
c01010e3:	83 ec 04             	sub    $0x4,%esp
c01010e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c01010ed:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c01010f2:	77 25                	ja     c0101119 <ide_device_valid+0x39>
c01010f4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01010f8:	c1 e0 03             	shl    $0x3,%eax
c01010fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101102:	29 c2                	sub    %eax,%edx
c0101104:	89 d0                	mov    %edx,%eax
c0101106:	05 40 44 12 c0       	add    $0xc0124440,%eax
c010110b:	0f b6 00             	movzbl (%eax),%eax
c010110e:	84 c0                	test   %al,%al
c0101110:	74 07                	je     c0101119 <ide_device_valid+0x39>
c0101112:	b8 01 00 00 00       	mov    $0x1,%eax
c0101117:	eb 05                	jmp    c010111e <ide_device_valid+0x3e>
c0101119:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010111e:	c9                   	leave  
c010111f:	c3                   	ret    

c0101120 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101120:	55                   	push   %ebp
c0101121:	89 e5                	mov    %esp,%ebp
c0101123:	83 ec 04             	sub    $0x4,%esp
c0101126:	8b 45 08             	mov    0x8(%ebp),%eax
c0101129:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c010112d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101131:	50                   	push   %eax
c0101132:	e8 a9 ff ff ff       	call   c01010e0 <ide_device_valid>
c0101137:	83 c4 04             	add    $0x4,%esp
c010113a:	85 c0                	test   %eax,%eax
c010113c:	74 1b                	je     c0101159 <ide_device_size+0x39>
        return ide_devices[ideno].size;
c010113e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101142:	c1 e0 03             	shl    $0x3,%eax
c0101145:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010114c:	29 c2                	sub    %eax,%edx
c010114e:	89 d0                	mov    %edx,%eax
c0101150:	05 48 44 12 c0       	add    $0xc0124448,%eax
c0101155:	8b 00                	mov    (%eax),%eax
c0101157:	eb 05                	jmp    c010115e <ide_device_size+0x3e>
    }
    return 0;
c0101159:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010115e:	c9                   	leave  
c010115f:	c3                   	ret    

c0101160 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101160:	55                   	push   %ebp
c0101161:	89 e5                	mov    %esp,%ebp
c0101163:	57                   	push   %edi
c0101164:	53                   	push   %ebx
c0101165:	83 ec 40             	sub    $0x40,%esp
c0101168:	8b 45 08             	mov    0x8(%ebp),%eax
c010116b:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c010116f:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101176:	77 25                	ja     c010119d <ide_read_secs+0x3d>
c0101178:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c010117d:	77 1e                	ja     c010119d <ide_read_secs+0x3d>
c010117f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101183:	c1 e0 03             	shl    $0x3,%eax
c0101186:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010118d:	29 c2                	sub    %eax,%edx
c010118f:	89 d0                	mov    %edx,%eax
c0101191:	05 40 44 12 c0       	add    $0xc0124440,%eax
c0101196:	0f b6 00             	movzbl (%eax),%eax
c0101199:	84 c0                	test   %al,%al
c010119b:	75 19                	jne    c01011b6 <ide_read_secs+0x56>
c010119d:	68 28 90 10 c0       	push   $0xc0109028
c01011a2:	68 e3 8f 10 c0       	push   $0xc0108fe3
c01011a7:	68 9f 00 00 00       	push   $0x9f
c01011ac:	68 f8 8f 10 c0       	push   $0xc0108ff8
c01011b1:	e8 3a f2 ff ff       	call   c01003f0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011b6:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01011bd:	77 0f                	ja     c01011ce <ide_read_secs+0x6e>
c01011bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01011c2:	8b 45 14             	mov    0x14(%ebp),%eax
c01011c5:	01 d0                	add    %edx,%eax
c01011c7:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01011cc:	76 19                	jbe    c01011e7 <ide_read_secs+0x87>
c01011ce:	68 50 90 10 c0       	push   $0xc0109050
c01011d3:	68 e3 8f 10 c0       	push   $0xc0108fe3
c01011d8:	68 a0 00 00 00       	push   $0xa0
c01011dd:	68 f8 8f 10 c0       	push   $0xc0108ff8
c01011e2:	e8 09 f2 ff ff       	call   c01003f0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c01011e7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011eb:	66 d1 e8             	shr    %ax
c01011ee:	0f b7 c0             	movzwl %ax,%eax
c01011f1:	0f b7 04 85 98 8f 10 	movzwl -0x3fef7068(,%eax,4),%eax
c01011f8:	c0 
c01011f9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01011fd:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101201:	66 d1 e8             	shr    %ax
c0101204:	0f b7 c0             	movzwl %ax,%eax
c0101207:	0f b7 04 85 9a 8f 10 	movzwl -0x3fef7066(,%eax,4),%eax
c010120e:	c0 
c010120f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101213:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101217:	83 ec 08             	sub    $0x8,%esp
c010121a:	6a 00                	push   $0x0
c010121c:	50                   	push   %eax
c010121d:	e8 60 fb ff ff       	call   c0100d82 <ide_wait_ready>
c0101222:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101225:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101229:	83 c0 02             	add    $0x2,%eax
c010122c:	0f b7 c0             	movzwl %ax,%eax
c010122f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101233:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101237:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010123b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010123f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101240:	8b 45 14             	mov    0x14(%ebp),%eax
c0101243:	0f b6 c0             	movzbl %al,%eax
c0101246:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124a:	83 c2 02             	add    $0x2,%edx
c010124d:	0f b7 d2             	movzwl %dx,%edx
c0101250:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c0101254:	88 45 d8             	mov    %al,-0x28(%ebp)
c0101257:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010125b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010125f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101260:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101263:	0f b6 c0             	movzbl %al,%eax
c0101266:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010126a:	83 c2 03             	add    $0x3,%edx
c010126d:	0f b7 d2             	movzwl %dx,%edx
c0101270:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101274:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101277:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010127b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010127f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101280:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101283:	c1 e8 08             	shr    $0x8,%eax
c0101286:	0f b6 c0             	movzbl %al,%eax
c0101289:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010128d:	83 c2 04             	add    $0x4,%edx
c0101290:	0f b7 d2             	movzwl %dx,%edx
c0101293:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c0101297:	88 45 da             	mov    %al,-0x26(%ebp)
c010129a:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c010129e:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c01012a2:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012a6:	c1 e8 10             	shr    $0x10,%eax
c01012a9:	0f b6 c0             	movzbl %al,%eax
c01012ac:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012b0:	83 c2 05             	add    $0x5,%edx
c01012b3:	0f b7 d2             	movzwl %dx,%edx
c01012b6:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01012ba:	88 45 db             	mov    %al,-0x25(%ebp)
c01012bd:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01012c1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01012c5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c01012c6:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01012ca:	83 e0 01             	and    $0x1,%eax
c01012cd:	c1 e0 04             	shl    $0x4,%eax
c01012d0:	89 c2                	mov    %eax,%edx
c01012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012d5:	c1 e8 18             	shr    $0x18,%eax
c01012d8:	83 e0 0f             	and    $0xf,%eax
c01012db:	09 d0                	or     %edx,%eax
c01012dd:	83 c8 e0             	or     $0xffffffe0,%eax
c01012e0:	0f b6 c0             	movzbl %al,%eax
c01012e3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012e7:	83 c2 06             	add    $0x6,%edx
c01012ea:	0f b7 d2             	movzwl %dx,%edx
c01012ed:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c01012f1:	88 45 dc             	mov    %al,-0x24(%ebp)
c01012f4:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01012f8:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c01012fc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c01012fd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101301:	83 c0 07             	add    $0x7,%eax
c0101304:	0f b7 c0             	movzwl %ax,%eax
c0101307:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c010130b:	c6 45 dd 20          	movb   $0x20,-0x23(%ebp)
c010130f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101313:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101317:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101318:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c010131f:	eb 56                	jmp    c0101377 <ide_read_secs+0x217>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101321:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101325:	83 ec 08             	sub    $0x8,%esp
c0101328:	6a 01                	push   $0x1
c010132a:	50                   	push   %eax
c010132b:	e8 52 fa ff ff       	call   c0100d82 <ide_wait_ready>
c0101330:	83 c4 10             	add    $0x10,%esp
c0101333:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010133a:	75 43                	jne    c010137f <ide_read_secs+0x21f>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c010133c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101340:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0101343:	8b 45 10             	mov    0x10(%ebp),%eax
c0101346:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101349:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101350:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101353:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101356:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0101359:	89 cb                	mov    %ecx,%ebx
c010135b:	89 df                	mov    %ebx,%edi
c010135d:	89 c1                	mov    %eax,%ecx
c010135f:	fc                   	cld    
c0101360:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101362:	89 c8                	mov    %ecx,%eax
c0101364:	89 fb                	mov    %edi,%ebx
c0101366:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c0101369:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c010136c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101370:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101377:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010137b:	75 a4                	jne    c0101321 <ide_read_secs+0x1c1>
c010137d:	eb 01                	jmp    c0101380 <ide_read_secs+0x220>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c010137f:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101380:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101383:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101386:	5b                   	pop    %ebx
c0101387:	5f                   	pop    %edi
c0101388:	5d                   	pop    %ebp
c0101389:	c3                   	ret    

c010138a <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c010138a:	55                   	push   %ebp
c010138b:	89 e5                	mov    %esp,%ebp
c010138d:	56                   	push   %esi
c010138e:	53                   	push   %ebx
c010138f:	83 ec 40             	sub    $0x40,%esp
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101399:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01013a0:	77 25                	ja     c01013c7 <ide_write_secs+0x3d>
c01013a2:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c01013a7:	77 1e                	ja     c01013c7 <ide_write_secs+0x3d>
c01013a9:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01013ad:	c1 e0 03             	shl    $0x3,%eax
c01013b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01013b7:	29 c2                	sub    %eax,%edx
c01013b9:	89 d0                	mov    %edx,%eax
c01013bb:	05 40 44 12 c0       	add    $0xc0124440,%eax
c01013c0:	0f b6 00             	movzbl (%eax),%eax
c01013c3:	84 c0                	test   %al,%al
c01013c5:	75 19                	jne    c01013e0 <ide_write_secs+0x56>
c01013c7:	68 28 90 10 c0       	push   $0xc0109028
c01013cc:	68 e3 8f 10 c0       	push   $0xc0108fe3
c01013d1:	68 bc 00 00 00       	push   $0xbc
c01013d6:	68 f8 8f 10 c0       	push   $0xc0108ff8
c01013db:	e8 10 f0 ff ff       	call   c01003f0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01013e0:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01013e7:	77 0f                	ja     c01013f8 <ide_write_secs+0x6e>
c01013e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01013ec:	8b 45 14             	mov    0x14(%ebp),%eax
c01013ef:	01 d0                	add    %edx,%eax
c01013f1:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01013f6:	76 19                	jbe    c0101411 <ide_write_secs+0x87>
c01013f8:	68 50 90 10 c0       	push   $0xc0109050
c01013fd:	68 e3 8f 10 c0       	push   $0xc0108fe3
c0101402:	68 bd 00 00 00       	push   $0xbd
c0101407:	68 f8 8f 10 c0       	push   $0xc0108ff8
c010140c:	e8 df ef ff ff       	call   c01003f0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101411:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101415:	66 d1 e8             	shr    %ax
c0101418:	0f b7 c0             	movzwl %ax,%eax
c010141b:	0f b7 04 85 98 8f 10 	movzwl -0x3fef7068(,%eax,4),%eax
c0101422:	c0 
c0101423:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101427:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010142b:	66 d1 e8             	shr    %ax
c010142e:	0f b7 c0             	movzwl %ax,%eax
c0101431:	0f b7 04 85 9a 8f 10 	movzwl -0x3fef7066(,%eax,4),%eax
c0101438:	c0 
c0101439:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c010143d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101441:	83 ec 08             	sub    $0x8,%esp
c0101444:	6a 00                	push   $0x0
c0101446:	50                   	push   %eax
c0101447:	e8 36 f9 ff ff       	call   c0100d82 <ide_wait_ready>
c010144c:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c010144f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101453:	83 c0 02             	add    $0x2,%eax
c0101456:	0f b7 c0             	movzwl %ax,%eax
c0101459:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010145d:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101461:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101465:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101469:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c010146a:	8b 45 14             	mov    0x14(%ebp),%eax
c010146d:	0f b6 c0             	movzbl %al,%eax
c0101470:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101474:	83 c2 02             	add    $0x2,%edx
c0101477:	0f b7 d2             	movzwl %dx,%edx
c010147a:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c010147e:	88 45 d8             	mov    %al,-0x28(%ebp)
c0101481:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101485:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101489:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c010148a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010148d:	0f b6 c0             	movzbl %al,%eax
c0101490:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101494:	83 c2 03             	add    $0x3,%edx
c0101497:	0f b7 d2             	movzwl %dx,%edx
c010149a:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c010149e:	88 45 d9             	mov    %al,-0x27(%ebp)
c01014a1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01014a5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01014a9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014ad:	c1 e8 08             	shr    $0x8,%eax
c01014b0:	0f b6 c0             	movzbl %al,%eax
c01014b3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014b7:	83 c2 04             	add    $0x4,%edx
c01014ba:	0f b7 d2             	movzwl %dx,%edx
c01014bd:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c01014c1:	88 45 da             	mov    %al,-0x26(%ebp)
c01014c4:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c01014c8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c01014cc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01014cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014d0:	c1 e8 10             	shr    $0x10,%eax
c01014d3:	0f b6 c0             	movzbl %al,%eax
c01014d6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014da:	83 c2 05             	add    $0x5,%edx
c01014dd:	0f b7 d2             	movzwl %dx,%edx
c01014e0:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01014e4:	88 45 db             	mov    %al,-0x25(%ebp)
c01014e7:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01014eb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01014ef:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c01014f0:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01014f4:	83 e0 01             	and    $0x1,%eax
c01014f7:	c1 e0 04             	shl    $0x4,%eax
c01014fa:	89 c2                	mov    %eax,%edx
c01014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014ff:	c1 e8 18             	shr    $0x18,%eax
c0101502:	83 e0 0f             	and    $0xf,%eax
c0101505:	09 d0                	or     %edx,%eax
c0101507:	83 c8 e0             	or     $0xffffffe0,%eax
c010150a:	0f b6 c0             	movzbl %al,%eax
c010150d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101511:	83 c2 06             	add    $0x6,%edx
c0101514:	0f b7 d2             	movzwl %dx,%edx
c0101517:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c010151b:	88 45 dc             	mov    %al,-0x24(%ebp)
c010151e:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0101522:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c0101526:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101527:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010152b:	83 c0 07             	add    $0x7,%eax
c010152e:	0f b7 c0             	movzwl %ax,%eax
c0101531:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c0101535:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
c0101539:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010153d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101541:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101549:	eb 56                	jmp    c01015a1 <ide_write_secs+0x217>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c010154b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010154f:	83 ec 08             	sub    $0x8,%esp
c0101552:	6a 01                	push   $0x1
c0101554:	50                   	push   %eax
c0101555:	e8 28 f8 ff ff       	call   c0100d82 <ide_wait_ready>
c010155a:	83 c4 10             	add    $0x10,%esp
c010155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101564:	75 43                	jne    c01015a9 <ide_write_secs+0x21f>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101566:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010156a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010156d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101570:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101573:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c010157a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010157d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101580:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0101583:	89 cb                	mov    %ecx,%ebx
c0101585:	89 de                	mov    %ebx,%esi
c0101587:	89 c1                	mov    %eax,%ecx
c0101589:	fc                   	cld    
c010158a:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c010158c:	89 c8                	mov    %ecx,%eax
c010158e:	89 f3                	mov    %esi,%ebx
c0101590:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c0101593:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101596:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c010159a:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01015a1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01015a5:	75 a4                	jne    c010154b <ide_write_secs+0x1c1>
c01015a7:	eb 01                	jmp    c01015aa <ide_write_secs+0x220>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c01015a9:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c01015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01015b0:	5b                   	pop    %ebx
c01015b1:	5e                   	pop    %esi
c01015b2:	5d                   	pop    %ebp
c01015b3:	c3                   	ret    

c01015b4 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c01015b4:	55                   	push   %ebp
c01015b5:	89 e5                	mov    %esp,%ebp
c01015b7:	83 ec 18             	sub    $0x18,%esp
c01015ba:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c01015c0:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01015c8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01015cc:	ee                   	out    %al,(%dx)
c01015cd:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c01015d3:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c01015d7:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c01015db:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01015df:	ee                   	out    %al,(%dx)
c01015e0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c01015e6:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c01015ea:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01015ee:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01015f2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c01015f3:	c7 05 0c 50 12 c0 00 	movl   $0x0,0xc012500c
c01015fa:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c01015fd:	83 ec 0c             	sub    $0xc,%esp
c0101600:	68 8a 90 10 c0       	push   $0xc010908a
c0101605:	e8 80 ec ff ff       	call   c010028a <cprintf>
c010160a:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c010160d:	83 ec 0c             	sub    $0xc,%esp
c0101610:	6a 00                	push   $0x0
c0101612:	e8 3b 09 00 00       	call   c0101f52 <pic_enable>
c0101617:	83 c4 10             	add    $0x10,%esp
}
c010161a:	90                   	nop
c010161b:	c9                   	leave  
c010161c:	c3                   	ret    

c010161d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010161d:	55                   	push   %ebp
c010161e:	89 e5                	mov    %esp,%ebp
c0101620:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0101623:	9c                   	pushf  
c0101624:	58                   	pop    %eax
c0101625:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0101628:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010162b:	25 00 02 00 00       	and    $0x200,%eax
c0101630:	85 c0                	test   %eax,%eax
c0101632:	74 0c                	je     c0101640 <__intr_save+0x23>
        intr_disable();
c0101634:	e8 8a 0a 00 00       	call   c01020c3 <intr_disable>
        return 1;
c0101639:	b8 01 00 00 00       	mov    $0x1,%eax
c010163e:	eb 05                	jmp    c0101645 <__intr_save+0x28>
    }
    return 0;
c0101640:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101645:	c9                   	leave  
c0101646:	c3                   	ret    

c0101647 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0101647:	55                   	push   %ebp
c0101648:	89 e5                	mov    %esp,%ebp
c010164a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010164d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0101651:	74 05                	je     c0101658 <__intr_restore+0x11>
        intr_enable();
c0101653:	e8 64 0a 00 00       	call   c01020bc <intr_enable>
    }
}
c0101658:	90                   	nop
c0101659:	c9                   	leave  
c010165a:	c3                   	ret    

c010165b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c010165b:	55                   	push   %ebp
c010165c:	89 e5                	mov    %esp,%ebp
c010165e:	83 ec 10             	sub    $0x10,%esp
c0101661:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101667:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c010166b:	89 c2                	mov    %eax,%edx
c010166d:	ec                   	in     (%dx),%al
c010166e:	88 45 f4             	mov    %al,-0xc(%ebp)
c0101671:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0101677:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c010167b:	89 c2                	mov    %eax,%edx
c010167d:	ec                   	in     (%dx),%al
c010167e:	88 45 f5             	mov    %al,-0xb(%ebp)
c0101681:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0101687:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010168b:	89 c2                	mov    %eax,%edx
c010168d:	ec                   	in     (%dx),%al
c010168e:	88 45 f6             	mov    %al,-0xa(%ebp)
c0101691:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0101697:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c010169b:	89 c2                	mov    %eax,%edx
c010169d:	ec                   	in     (%dx),%al
c010169e:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c01016a1:	90                   	nop
c01016a2:	c9                   	leave  
c01016a3:	c3                   	ret    

c01016a4 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c01016a4:	55                   	push   %ebp
c01016a5:	89 e5                	mov    %esp,%ebp
c01016a7:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c01016aa:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c01016b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016b4:	0f b7 00             	movzwl (%eax),%eax
c01016b7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c01016bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016be:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c01016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016c6:	0f b7 00             	movzwl (%eax),%eax
c01016c9:	66 3d 5a a5          	cmp    $0xa55a,%ax
c01016cd:	74 12                	je     c01016e1 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c01016cf:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c01016d6:	66 c7 05 26 45 12 c0 	movw   $0x3b4,0xc0124526
c01016dd:	b4 03 
c01016df:	eb 13                	jmp    c01016f4 <cga_init+0x50>
    } else {
        *cp = was;
c01016e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016e8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c01016eb:	66 c7 05 26 45 12 c0 	movw   $0x3d4,0xc0124526
c01016f2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c01016f4:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c01016fb:	0f b7 c0             	movzwl %ax,%eax
c01016fe:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0101702:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101706:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c010170a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010170e:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c010170f:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101716:	83 c0 01             	add    $0x1,%eax
c0101719:	0f b7 c0             	movzwl %ax,%eax
c010171c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101720:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101724:	89 c2                	mov    %eax,%edx
c0101726:	ec                   	in     (%dx),%al
c0101727:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010172a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010172e:	0f b6 c0             	movzbl %al,%eax
c0101731:	c1 e0 08             	shl    $0x8,%eax
c0101734:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0101737:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c010173e:	0f b7 c0             	movzwl %ax,%eax
c0101741:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0101745:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101749:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010174d:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101751:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101752:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101759:	83 c0 01             	add    $0x1,%eax
c010175c:	0f b7 c0             	movzwl %ax,%eax
c010175f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101763:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101767:	89 c2                	mov    %eax,%edx
c0101769:	ec                   	in     (%dx),%al
c010176a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010176d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101771:	0f b6 c0             	movzbl %al,%eax
c0101774:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0101777:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010177a:	a3 20 45 12 c0       	mov    %eax,0xc0124520
    crt_pos = pos;
c010177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101782:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
}
c0101788:	90                   	nop
c0101789:	c9                   	leave  
c010178a:	c3                   	ret    

c010178b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c010178b:	55                   	push   %ebp
c010178c:	89 e5                	mov    %esp,%ebp
c010178e:	83 ec 28             	sub    $0x28,%esp
c0101791:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0101797:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010179b:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c010179f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017a3:	ee                   	out    %al,(%dx)
c01017a4:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c01017aa:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c01017ae:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01017b2:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01017b6:	ee                   	out    %al,(%dx)
c01017b7:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c01017bd:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c01017c1:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017c5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
c01017ca:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c01017d0:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c01017d4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017d8:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017dc:	ee                   	out    %al,(%dx)
c01017dd:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c01017e3:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c01017e7:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017eb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c01017f6:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c01017fa:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017fe:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101809:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c010180d:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0101811:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010181c:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0101820:	89 c2                	mov    %eax,%edx
c0101822:	ec                   	in     (%dx),%al
c0101823:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0101826:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010182a:	3c ff                	cmp    $0xff,%al
c010182c:	0f 95 c0             	setne  %al
c010182f:	0f b6 c0             	movzbl %al,%eax
c0101832:	a3 28 45 12 c0       	mov    %eax,0xc0124528
c0101837:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010183d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101841:	89 c2                	mov    %eax,%edx
c0101843:	ec                   	in     (%dx),%al
c0101844:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0101847:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c010184d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0101851:	89 c2                	mov    %eax,%edx
c0101853:	ec                   	in     (%dx),%al
c0101854:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101857:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c010185c:	85 c0                	test   %eax,%eax
c010185e:	74 0d                	je     c010186d <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101860:	83 ec 0c             	sub    $0xc,%esp
c0101863:	6a 04                	push   $0x4
c0101865:	e8 e8 06 00 00       	call   c0101f52 <pic_enable>
c010186a:	83 c4 10             	add    $0x10,%esp
    }
}
c010186d:	90                   	nop
c010186e:	c9                   	leave  
c010186f:	c3                   	ret    

c0101870 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101870:	55                   	push   %ebp
c0101871:	89 e5                	mov    %esp,%ebp
c0101873:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101876:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010187d:	eb 09                	jmp    c0101888 <lpt_putc_sub+0x18>
        delay();
c010187f:	e8 d7 fd ff ff       	call   c010165b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101884:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101888:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c010188e:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0101892:	89 c2                	mov    %eax,%edx
c0101894:	ec                   	in     (%dx),%al
c0101895:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101898:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010189c:	84 c0                	test   %al,%al
c010189e:	78 09                	js     c01018a9 <lpt_putc_sub+0x39>
c01018a0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01018a7:	7e d6                	jle    c010187f <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c01018a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01018ac:	0f b6 c0             	movzbl %al,%eax
c01018af:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c01018b5:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b8:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c01018bc:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c01018c0:	ee                   	out    %al,(%dx)
c01018c1:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01018c7:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01018cb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018cf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018d3:	ee                   	out    %al,(%dx)
c01018d4:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c01018da:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c01018de:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c01018e2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018e6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01018e7:	90                   	nop
c01018e8:	c9                   	leave  
c01018e9:	c3                   	ret    

c01018ea <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01018ea:	55                   	push   %ebp
c01018eb:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01018ed:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01018f1:	74 0d                	je     c0101900 <lpt_putc+0x16>
        lpt_putc_sub(c);
c01018f3:	ff 75 08             	pushl  0x8(%ebp)
c01018f6:	e8 75 ff ff ff       	call   c0101870 <lpt_putc_sub>
c01018fb:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01018fe:	eb 1e                	jmp    c010191e <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c0101900:	6a 08                	push   $0x8
c0101902:	e8 69 ff ff ff       	call   c0101870 <lpt_putc_sub>
c0101907:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c010190a:	6a 20                	push   $0x20
c010190c:	e8 5f ff ff ff       	call   c0101870 <lpt_putc_sub>
c0101911:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c0101914:	6a 08                	push   $0x8
c0101916:	e8 55 ff ff ff       	call   c0101870 <lpt_putc_sub>
c010191b:	83 c4 04             	add    $0x4,%esp
    }
}
c010191e:	90                   	nop
c010191f:	c9                   	leave  
c0101920:	c3                   	ret    

c0101921 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101921:	55                   	push   %ebp
c0101922:	89 e5                	mov    %esp,%ebp
c0101924:	53                   	push   %ebx
c0101925:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101928:	8b 45 08             	mov    0x8(%ebp),%eax
c010192b:	b0 00                	mov    $0x0,%al
c010192d:	85 c0                	test   %eax,%eax
c010192f:	75 07                	jne    c0101938 <cga_putc+0x17>
        c |= 0x0700;
c0101931:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101938:	8b 45 08             	mov    0x8(%ebp),%eax
c010193b:	0f b6 c0             	movzbl %al,%eax
c010193e:	83 f8 0a             	cmp    $0xa,%eax
c0101941:	74 4e                	je     c0101991 <cga_putc+0x70>
c0101943:	83 f8 0d             	cmp    $0xd,%eax
c0101946:	74 59                	je     c01019a1 <cga_putc+0x80>
c0101948:	83 f8 08             	cmp    $0x8,%eax
c010194b:	0f 85 8a 00 00 00    	jne    c01019db <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c0101951:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101958:	66 85 c0             	test   %ax,%ax
c010195b:	0f 84 a0 00 00 00    	je     c0101a01 <cga_putc+0xe0>
            crt_pos --;
c0101961:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101968:	83 e8 01             	sub    $0x1,%eax
c010196b:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101971:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101976:	0f b7 15 24 45 12 c0 	movzwl 0xc0124524,%edx
c010197d:	0f b7 d2             	movzwl %dx,%edx
c0101980:	01 d2                	add    %edx,%edx
c0101982:	01 d0                	add    %edx,%eax
c0101984:	8b 55 08             	mov    0x8(%ebp),%edx
c0101987:	b2 00                	mov    $0x0,%dl
c0101989:	83 ca 20             	or     $0x20,%edx
c010198c:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c010198f:	eb 70                	jmp    c0101a01 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c0101991:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101998:	83 c0 50             	add    $0x50,%eax
c010199b:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01019a1:	0f b7 1d 24 45 12 c0 	movzwl 0xc0124524,%ebx
c01019a8:	0f b7 0d 24 45 12 c0 	movzwl 0xc0124524,%ecx
c01019af:	0f b7 c1             	movzwl %cx,%eax
c01019b2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01019b8:	c1 e8 10             	shr    $0x10,%eax
c01019bb:	89 c2                	mov    %eax,%edx
c01019bd:	66 c1 ea 06          	shr    $0x6,%dx
c01019c1:	89 d0                	mov    %edx,%eax
c01019c3:	c1 e0 02             	shl    $0x2,%eax
c01019c6:	01 d0                	add    %edx,%eax
c01019c8:	c1 e0 04             	shl    $0x4,%eax
c01019cb:	29 c1                	sub    %eax,%ecx
c01019cd:	89 ca                	mov    %ecx,%edx
c01019cf:	89 d8                	mov    %ebx,%eax
c01019d1:	29 d0                	sub    %edx,%eax
c01019d3:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
        break;
c01019d9:	eb 27                	jmp    c0101a02 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01019db:	8b 0d 20 45 12 c0    	mov    0xc0124520,%ecx
c01019e1:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c01019e8:	8d 50 01             	lea    0x1(%eax),%edx
c01019eb:	66 89 15 24 45 12 c0 	mov    %dx,0xc0124524
c01019f2:	0f b7 c0             	movzwl %ax,%eax
c01019f5:	01 c0                	add    %eax,%eax
c01019f7:	01 c8                	add    %ecx,%eax
c01019f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01019fc:	66 89 10             	mov    %dx,(%eax)
        break;
c01019ff:	eb 01                	jmp    c0101a02 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101a01:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101a02:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a09:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101a0d:	76 59                	jbe    c0101a68 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a0f:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a14:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101a1a:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a1f:	83 ec 04             	sub    $0x4,%esp
c0101a22:	68 00 0f 00 00       	push   $0xf00
c0101a27:	52                   	push   %edx
c0101a28:	50                   	push   %eax
c0101a29:	e8 09 6a 00 00       	call   c0108437 <memmove>
c0101a2e:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a31:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101a38:	eb 15                	jmp    c0101a4f <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c0101a3a:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101a42:	01 d2                	add    %edx,%edx
c0101a44:	01 d0                	add    %edx,%eax
c0101a46:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101a4f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101a56:	7e e2                	jle    c0101a3a <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101a58:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a5f:	83 e8 50             	sub    $0x50,%eax
c0101a62:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101a68:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101a6f:	0f b7 c0             	movzwl %ax,%eax
c0101a72:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101a76:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101a7a:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101a7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101a82:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101a83:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a8a:	66 c1 e8 08          	shr    $0x8,%ax
c0101a8e:	0f b6 c0             	movzbl %al,%eax
c0101a91:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101a98:	83 c2 01             	add    $0x1,%edx
c0101a9b:	0f b7 d2             	movzwl %dx,%edx
c0101a9e:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101aa2:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101aa5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101aa9:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101aad:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101aae:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101ab5:	0f b7 c0             	movzwl %ax,%eax
c0101ab8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101abc:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101ac0:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101ac4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ac8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101ac9:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101ad0:	0f b6 c0             	movzbl %al,%eax
c0101ad3:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101ada:	83 c2 01             	add    $0x1,%edx
c0101add:	0f b7 d2             	movzwl %dx,%edx
c0101ae0:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101ae4:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101ae7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101aeb:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101aef:	ee                   	out    %al,(%dx)
}
c0101af0:	90                   	nop
c0101af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101af4:	c9                   	leave  
c0101af5:	c3                   	ret    

c0101af6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101af6:	55                   	push   %ebp
c0101af7:	89 e5                	mov    %esp,%ebp
c0101af9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101afc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b03:	eb 09                	jmp    c0101b0e <serial_putc_sub+0x18>
        delay();
c0101b05:	e8 51 fb ff ff       	call   c010165b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b0a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b0e:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b14:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101b18:	89 c2                	mov    %eax,%edx
c0101b1a:	ec                   	in     (%dx),%al
c0101b1b:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101b1e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101b22:	0f b6 c0             	movzbl %al,%eax
c0101b25:	83 e0 20             	and    $0x20,%eax
c0101b28:	85 c0                	test   %eax,%eax
c0101b2a:	75 09                	jne    c0101b35 <serial_putc_sub+0x3f>
c0101b2c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101b33:	7e d0                	jle    c0101b05 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b38:	0f b6 c0             	movzbl %al,%eax
c0101b3b:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c0101b41:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b44:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c0101b48:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101b4c:	ee                   	out    %al,(%dx)
}
c0101b4d:	90                   	nop
c0101b4e:	c9                   	leave  
c0101b4f:	c3                   	ret    

c0101b50 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101b50:	55                   	push   %ebp
c0101b51:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101b53:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101b57:	74 0d                	je     c0101b66 <serial_putc+0x16>
        serial_putc_sub(c);
c0101b59:	ff 75 08             	pushl  0x8(%ebp)
c0101b5c:	e8 95 ff ff ff       	call   c0101af6 <serial_putc_sub>
c0101b61:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101b64:	eb 1e                	jmp    c0101b84 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101b66:	6a 08                	push   $0x8
c0101b68:	e8 89 ff ff ff       	call   c0101af6 <serial_putc_sub>
c0101b6d:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101b70:	6a 20                	push   $0x20
c0101b72:	e8 7f ff ff ff       	call   c0101af6 <serial_putc_sub>
c0101b77:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101b7a:	6a 08                	push   $0x8
c0101b7c:	e8 75 ff ff ff       	call   c0101af6 <serial_putc_sub>
c0101b81:	83 c4 04             	add    $0x4,%esp
    }
}
c0101b84:	90                   	nop
c0101b85:	c9                   	leave  
c0101b86:	c3                   	ret    

c0101b87 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101b87:	55                   	push   %ebp
c0101b88:	89 e5                	mov    %esp,%ebp
c0101b8a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101b8d:	eb 33                	jmp    c0101bc2 <cons_intr+0x3b>
        if (c != 0) {
c0101b8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101b93:	74 2d                	je     c0101bc2 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101b95:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101b9a:	8d 50 01             	lea    0x1(%eax),%edx
c0101b9d:	89 15 44 47 12 c0    	mov    %edx,0xc0124744
c0101ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101ba6:	88 90 40 45 12 c0    	mov    %dl,-0x3fedbac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101bac:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101bb1:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101bb6:	75 0a                	jne    c0101bc2 <cons_intr+0x3b>
                cons.wpos = 0;
c0101bb8:	c7 05 44 47 12 c0 00 	movl   $0x0,0xc0124744
c0101bbf:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc5:	ff d0                	call   *%eax
c0101bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101bca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101bce:	75 bf                	jne    c0101b8f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101bd0:	90                   	nop
c0101bd1:	c9                   	leave  
c0101bd2:	c3                   	ret    

c0101bd3 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101bd3:	55                   	push   %ebp
c0101bd4:	89 e5                	mov    %esp,%ebp
c0101bd6:	83 ec 10             	sub    $0x10,%esp
c0101bd9:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101bdf:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101be3:	89 c2                	mov    %eax,%edx
c0101be5:	ec                   	in     (%dx),%al
c0101be6:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101be9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101bed:	0f b6 c0             	movzbl %al,%eax
c0101bf0:	83 e0 01             	and    $0x1,%eax
c0101bf3:	85 c0                	test   %eax,%eax
c0101bf5:	75 07                	jne    c0101bfe <serial_proc_data+0x2b>
        return -1;
c0101bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101bfc:	eb 2a                	jmp    c0101c28 <serial_proc_data+0x55>
c0101bfe:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c04:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101c08:	89 c2                	mov    %eax,%edx
c0101c0a:	ec                   	in     (%dx),%al
c0101c0b:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c0101c0e:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101c12:	0f b6 c0             	movzbl %al,%eax
c0101c15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101c18:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101c1c:	75 07                	jne    c0101c25 <serial_proc_data+0x52>
        c = '\b';
c0101c1e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101c28:	c9                   	leave  
c0101c29:	c3                   	ret    

c0101c2a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101c2a:	55                   	push   %ebp
c0101c2b:	89 e5                	mov    %esp,%ebp
c0101c2d:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c0101c30:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101c35:	85 c0                	test   %eax,%eax
c0101c37:	74 10                	je     c0101c49 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c0101c39:	83 ec 0c             	sub    $0xc,%esp
c0101c3c:	68 d3 1b 10 c0       	push   $0xc0101bd3
c0101c41:	e8 41 ff ff ff       	call   c0101b87 <cons_intr>
c0101c46:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c49:	90                   	nop
c0101c4a:	c9                   	leave  
c0101c4b:	c3                   	ret    

c0101c4c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101c4c:	55                   	push   %ebp
c0101c4d:	89 e5                	mov    %esp,%ebp
c0101c4f:	83 ec 18             	sub    $0x18,%esp
c0101c52:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c58:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101c5c:	89 c2                	mov    %eax,%edx
c0101c5e:	ec                   	in     (%dx),%al
c0101c5f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101c62:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101c66:	0f b6 c0             	movzbl %al,%eax
c0101c69:	83 e0 01             	and    $0x1,%eax
c0101c6c:	85 c0                	test   %eax,%eax
c0101c6e:	75 0a                	jne    c0101c7a <kbd_proc_data+0x2e>
        return -1;
c0101c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c75:	e9 5d 01 00 00       	jmp    c0101dd7 <kbd_proc_data+0x18b>
c0101c7a:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c80:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c84:	89 c2                	mov    %eax,%edx
c0101c86:	ec                   	in     (%dx),%al
c0101c87:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101c8a:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101c8e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101c91:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101c95:	75 17                	jne    c0101cae <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101c97:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101c9c:	83 c8 40             	or     $0x40,%eax
c0101c9f:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101ca4:	b8 00 00 00 00       	mov    $0x0,%eax
c0101ca9:	e9 29 01 00 00       	jmp    c0101dd7 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101cae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cb2:	84 c0                	test   %al,%al
c0101cb4:	79 47                	jns    c0101cfd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101cb6:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101cbb:	83 e0 40             	and    $0x40,%eax
c0101cbe:	85 c0                	test   %eax,%eax
c0101cc0:	75 09                	jne    c0101ccb <kbd_proc_data+0x7f>
c0101cc2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cc6:	83 e0 7f             	and    $0x7f,%eax
c0101cc9:	eb 04                	jmp    c0101ccf <kbd_proc_data+0x83>
c0101ccb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101ccf:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101cd2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cd6:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101cdd:	83 c8 40             	or     $0x40,%eax
c0101ce0:	0f b6 c0             	movzbl %al,%eax
c0101ce3:	f7 d0                	not    %eax
c0101ce5:	89 c2                	mov    %eax,%edx
c0101ce7:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101cec:	21 d0                	and    %edx,%eax
c0101cee:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101cf3:	b8 00 00 00 00       	mov    $0x0,%eax
c0101cf8:	e9 da 00 00 00       	jmp    c0101dd7 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c0101cfd:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d02:	83 e0 40             	and    $0x40,%eax
c0101d05:	85 c0                	test   %eax,%eax
c0101d07:	74 11                	je     c0101d1a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d09:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d0d:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d12:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d15:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    }

    shift |= shiftcode[data];
c0101d1a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d1e:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101d25:	0f b6 d0             	movzbl %al,%edx
c0101d28:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d2d:	09 d0                	or     %edx,%eax
c0101d2f:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    shift ^= togglecode[data];
c0101d34:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d38:	0f b6 80 40 11 12 c0 	movzbl -0x3fedeec0(%eax),%eax
c0101d3f:	0f b6 d0             	movzbl %al,%edx
c0101d42:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d47:	31 d0                	xor    %edx,%eax
c0101d49:	a3 48 47 12 c0       	mov    %eax,0xc0124748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101d4e:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d53:	83 e0 03             	and    $0x3,%eax
c0101d56:	8b 14 85 40 15 12 c0 	mov    -0x3fedeac0(,%eax,4),%edx
c0101d5d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d61:	01 d0                	add    %edx,%eax
c0101d63:	0f b6 00             	movzbl (%eax),%eax
c0101d66:	0f b6 c0             	movzbl %al,%eax
c0101d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101d6c:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d71:	83 e0 08             	and    $0x8,%eax
c0101d74:	85 c0                	test   %eax,%eax
c0101d76:	74 22                	je     c0101d9a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101d78:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101d7c:	7e 0c                	jle    c0101d8a <kbd_proc_data+0x13e>
c0101d7e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101d82:	7f 06                	jg     c0101d8a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101d84:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101d88:	eb 10                	jmp    c0101d9a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101d8a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101d8e:	7e 0a                	jle    c0101d9a <kbd_proc_data+0x14e>
c0101d90:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101d94:	7f 04                	jg     c0101d9a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101d96:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101d9a:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d9f:	f7 d0                	not    %eax
c0101da1:	83 e0 06             	and    $0x6,%eax
c0101da4:	85 c0                	test   %eax,%eax
c0101da6:	75 2c                	jne    c0101dd4 <kbd_proc_data+0x188>
c0101da8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101daf:	75 23                	jne    c0101dd4 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101db1:	83 ec 0c             	sub    $0xc,%esp
c0101db4:	68 a5 90 10 c0       	push   $0xc01090a5
c0101db9:	e8 cc e4 ff ff       	call   c010028a <cprintf>
c0101dbe:	83 c4 10             	add    $0x10,%esp
c0101dc1:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101dc7:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dcb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dcf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101dd3:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101dd7:	c9                   	leave  
c0101dd8:	c3                   	ret    

c0101dd9 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101dd9:	55                   	push   %ebp
c0101dda:	89 e5                	mov    %esp,%ebp
c0101ddc:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101ddf:	83 ec 0c             	sub    $0xc,%esp
c0101de2:	68 4c 1c 10 c0       	push   $0xc0101c4c
c0101de7:	e8 9b fd ff ff       	call   c0101b87 <cons_intr>
c0101dec:	83 c4 10             	add    $0x10,%esp
}
c0101def:	90                   	nop
c0101df0:	c9                   	leave  
c0101df1:	c3                   	ret    

c0101df2 <kbd_init>:

static void
kbd_init(void) {
c0101df2:	55                   	push   %ebp
c0101df3:	89 e5                	mov    %esp,%ebp
c0101df5:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101df8:	e8 dc ff ff ff       	call   c0101dd9 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101dfd:	83 ec 0c             	sub    $0xc,%esp
c0101e00:	6a 01                	push   $0x1
c0101e02:	e8 4b 01 00 00       	call   c0101f52 <pic_enable>
c0101e07:	83 c4 10             	add    $0x10,%esp
}
c0101e0a:	90                   	nop
c0101e0b:	c9                   	leave  
c0101e0c:	c3                   	ret    

c0101e0d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101e0d:	55                   	push   %ebp
c0101e0e:	89 e5                	mov    %esp,%ebp
c0101e10:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c0101e13:	e8 8c f8 ff ff       	call   c01016a4 <cga_init>
    serial_init();
c0101e18:	e8 6e f9 ff ff       	call   c010178b <serial_init>
    kbd_init();
c0101e1d:	e8 d0 ff ff ff       	call   c0101df2 <kbd_init>
    if (!serial_exists) {
c0101e22:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101e27:	85 c0                	test   %eax,%eax
c0101e29:	75 10                	jne    c0101e3b <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c0101e2b:	83 ec 0c             	sub    $0xc,%esp
c0101e2e:	68 b1 90 10 c0       	push   $0xc01090b1
c0101e33:	e8 52 e4 ff ff       	call   c010028a <cprintf>
c0101e38:	83 c4 10             	add    $0x10,%esp
    }
}
c0101e3b:	90                   	nop
c0101e3c:	c9                   	leave  
c0101e3d:	c3                   	ret    

c0101e3e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101e3e:	55                   	push   %ebp
c0101e3f:	89 e5                	mov    %esp,%ebp
c0101e41:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e44:	e8 d4 f7 ff ff       	call   c010161d <__intr_save>
c0101e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101e4c:	83 ec 0c             	sub    $0xc,%esp
c0101e4f:	ff 75 08             	pushl  0x8(%ebp)
c0101e52:	e8 93 fa ff ff       	call   c01018ea <lpt_putc>
c0101e57:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c0101e5a:	83 ec 0c             	sub    $0xc,%esp
c0101e5d:	ff 75 08             	pushl  0x8(%ebp)
c0101e60:	e8 bc fa ff ff       	call   c0101921 <cga_putc>
c0101e65:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101e68:	83 ec 0c             	sub    $0xc,%esp
c0101e6b:	ff 75 08             	pushl  0x8(%ebp)
c0101e6e:	e8 dd fc ff ff       	call   c0101b50 <serial_putc>
c0101e73:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101e76:	83 ec 0c             	sub    $0xc,%esp
c0101e79:	ff 75 f4             	pushl  -0xc(%ebp)
c0101e7c:	e8 c6 f7 ff ff       	call   c0101647 <__intr_restore>
c0101e81:	83 c4 10             	add    $0x10,%esp
}
c0101e84:	90                   	nop
c0101e85:	c9                   	leave  
c0101e86:	c3                   	ret    

c0101e87 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101e87:	55                   	push   %ebp
c0101e88:	89 e5                	mov    %esp,%ebp
c0101e8a:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101e8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e94:	e8 84 f7 ff ff       	call   c010161d <__intr_save>
c0101e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101e9c:	e8 89 fd ff ff       	call   c0101c2a <serial_intr>
        kbd_intr();
c0101ea1:	e8 33 ff ff ff       	call   c0101dd9 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101ea6:	8b 15 40 47 12 c0    	mov    0xc0124740,%edx
c0101eac:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101eb1:	39 c2                	cmp    %eax,%edx
c0101eb3:	74 31                	je     c0101ee6 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101eb5:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101eba:	8d 50 01             	lea    0x1(%eax),%edx
c0101ebd:	89 15 40 47 12 c0    	mov    %edx,0xc0124740
c0101ec3:	0f b6 80 40 45 12 c0 	movzbl -0x3fedbac0(%eax),%eax
c0101eca:	0f b6 c0             	movzbl %al,%eax
c0101ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101ed0:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101ed5:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101eda:	75 0a                	jne    c0101ee6 <cons_getc+0x5f>
                cons.rpos = 0;
c0101edc:	c7 05 40 47 12 c0 00 	movl   $0x0,0xc0124740
c0101ee3:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101ee6:	83 ec 0c             	sub    $0xc,%esp
c0101ee9:	ff 75 f0             	pushl  -0x10(%ebp)
c0101eec:	e8 56 f7 ff ff       	call   c0101647 <__intr_restore>
c0101ef1:	83 c4 10             	add    $0x10,%esp
    return c;
c0101ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ef7:	c9                   	leave  
c0101ef8:	c3                   	ret    

c0101ef9 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101ef9:	55                   	push   %ebp
c0101efa:	89 e5                	mov    %esp,%ebp
c0101efc:	83 ec 14             	sub    $0x14,%esp
c0101eff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f06:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f0a:	66 a3 50 15 12 c0    	mov    %ax,0xc0121550
    if (did_init) {
c0101f10:	a1 4c 47 12 c0       	mov    0xc012474c,%eax
c0101f15:	85 c0                	test   %eax,%eax
c0101f17:	74 36                	je     c0101f4f <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f19:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f1d:	0f b6 c0             	movzbl %al,%eax
c0101f20:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f26:	88 45 fa             	mov    %al,-0x6(%ebp)
c0101f29:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c0101f2d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f31:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f32:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f36:	66 c1 e8 08          	shr    $0x8,%ax
c0101f3a:	0f b6 c0             	movzbl %al,%eax
c0101f3d:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101f43:	88 45 fb             	mov    %al,-0x5(%ebp)
c0101f46:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101f4a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101f4e:	ee                   	out    %al,(%dx)
    }
}
c0101f4f:	90                   	nop
c0101f50:	c9                   	leave  
c0101f51:	c3                   	ret    

c0101f52 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f52:	55                   	push   %ebp
c0101f53:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f58:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f5d:	89 c1                	mov    %eax,%ecx
c0101f5f:	d3 e2                	shl    %cl,%edx
c0101f61:	89 d0                	mov    %edx,%eax
c0101f63:	f7 d0                	not    %eax
c0101f65:	89 c2                	mov    %eax,%edx
c0101f67:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c0101f6e:	21 d0                	and    %edx,%eax
c0101f70:	0f b7 c0             	movzwl %ax,%eax
c0101f73:	50                   	push   %eax
c0101f74:	e8 80 ff ff ff       	call   c0101ef9 <pic_setmask>
c0101f79:	83 c4 04             	add    $0x4,%esp
}
c0101f7c:	90                   	nop
c0101f7d:	c9                   	leave  
c0101f7e:	c3                   	ret    

c0101f7f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101f7f:	55                   	push   %ebp
c0101f80:	89 e5                	mov    %esp,%ebp
c0101f82:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101f85:	c7 05 4c 47 12 c0 01 	movl   $0x1,0xc012474c
c0101f8c:	00 00 00 
c0101f8f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f95:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0101f99:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101f9d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fa1:	ee                   	out    %al,(%dx)
c0101fa2:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101fa8:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0101fac:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101fb0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101fb4:	ee                   	out    %al,(%dx)
c0101fb5:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0101fbb:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101fbf:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101fc3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fc7:	ee                   	out    %al,(%dx)
c0101fc8:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0101fce:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101fd2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101fd6:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101fda:	ee                   	out    %al,(%dx)
c0101fdb:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0101fe1:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101fe5:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101fe9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101fed:	ee                   	out    %al,(%dx)
c0101fee:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0101ff4:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0101ff8:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101ffc:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0102000:	ee                   	out    %al,(%dx)
c0102001:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c0102007:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c010200b:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c010200f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102013:	ee                   	out    %al,(%dx)
c0102014:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c010201a:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c010201e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102022:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0102026:	ee                   	out    %al,(%dx)
c0102027:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010202d:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c0102031:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0102035:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102039:	ee                   	out    %al,(%dx)
c010203a:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c0102040:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c0102044:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0102048:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c010204c:	ee                   	out    %al,(%dx)
c010204d:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c0102053:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c0102057:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c010205b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010205f:	ee                   	out    %al,(%dx)
c0102060:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0102066:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c010206a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010206e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0102072:	ee                   	out    %al,(%dx)
c0102073:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102079:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c010207d:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c0102081:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102085:	ee                   	out    %al,(%dx)
c0102086:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c010208c:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c0102090:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0102094:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c0102098:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0102099:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c01020a0:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020a4:	74 13                	je     c01020b9 <pic_init+0x13a>
        pic_setmask(irq_mask);
c01020a6:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c01020ad:	0f b7 c0             	movzwl %ax,%eax
c01020b0:	50                   	push   %eax
c01020b1:	e8 43 fe ff ff       	call   c0101ef9 <pic_setmask>
c01020b6:	83 c4 04             	add    $0x4,%esp
    }
}
c01020b9:	90                   	nop
c01020ba:	c9                   	leave  
c01020bb:	c3                   	ret    

c01020bc <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01020bc:	55                   	push   %ebp
c01020bd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01020bf:	fb                   	sti    
    sti();
}
c01020c0:	90                   	nop
c01020c1:	5d                   	pop    %ebp
c01020c2:	c3                   	ret    

c01020c3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01020c3:	55                   	push   %ebp
c01020c4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01020c6:	fa                   	cli    
    cli();
}
c01020c7:	90                   	nop
c01020c8:	5d                   	pop    %ebp
c01020c9:	c3                   	ret    

c01020ca <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020ca:	55                   	push   %ebp
c01020cb:	89 e5                	mov    %esp,%ebp
c01020cd:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020d0:	83 ec 08             	sub    $0x8,%esp
c01020d3:	6a 64                	push   $0x64
c01020d5:	68 e0 90 10 c0       	push   $0xc01090e0
c01020da:	e8 ab e1 ff ff       	call   c010028a <cprintf>
c01020df:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01020e2:	90                   	nop
c01020e3:	c9                   	leave  
c01020e4:	c3                   	ret    

c01020e5 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01020e5:	55                   	push   %ebp
c01020e6:	89 e5                	mov    %esp,%ebp
c01020e8:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c01020eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01020f2:	e9 c3 00 00 00       	jmp    c01021ba <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01020f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020fa:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c0102101:	89 c2                	mov    %eax,%edx
c0102103:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102106:	66 89 14 c5 60 47 12 	mov    %dx,-0x3fedb8a0(,%eax,8)
c010210d:	c0 
c010210e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102111:	66 c7 04 c5 62 47 12 	movw   $0x8,-0x3fedb89e(,%eax,8)
c0102118:	c0 08 00 
c010211b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010211e:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c0102125:	c0 
c0102126:	83 e2 e0             	and    $0xffffffe0,%edx
c0102129:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c0102130:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102133:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c010213a:	c0 
c010213b:	83 e2 1f             	and    $0x1f,%edx
c010213e:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c0102145:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102148:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c010214f:	c0 
c0102150:	83 e2 f0             	and    $0xfffffff0,%edx
c0102153:	83 ca 0e             	or     $0xe,%edx
c0102156:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c010215d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102160:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c0102167:	c0 
c0102168:	83 e2 ef             	and    $0xffffffef,%edx
c010216b:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c0102172:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102175:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c010217c:	c0 
c010217d:	83 e2 9f             	and    $0xffffff9f,%edx
c0102180:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c0102187:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218a:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c0102191:	c0 
c0102192:	83 ca 80             	or     $0xffffff80,%edx
c0102195:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c010219c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010219f:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c01021a6:	c1 e8 10             	shr    $0x10,%eax
c01021a9:	89 c2                	mov    %eax,%edx
c01021ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ae:	66 89 14 c5 66 47 12 	mov    %dx,-0x3fedb89a(,%eax,8)
c01021b5:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c01021b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021ba:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01021c1:	0f 8e 30 ff ff ff    	jle    c01020f7 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01021c7:	a1 c4 17 12 c0       	mov    0xc01217c4,%eax
c01021cc:	66 a3 28 4b 12 c0    	mov    %ax,0xc0124b28
c01021d2:	66 c7 05 2a 4b 12 c0 	movw   $0x8,0xc0124b2a
c01021d9:	08 00 
c01021db:	0f b6 05 2c 4b 12 c0 	movzbl 0xc0124b2c,%eax
c01021e2:	83 e0 e0             	and    $0xffffffe0,%eax
c01021e5:	a2 2c 4b 12 c0       	mov    %al,0xc0124b2c
c01021ea:	0f b6 05 2c 4b 12 c0 	movzbl 0xc0124b2c,%eax
c01021f1:	83 e0 1f             	and    $0x1f,%eax
c01021f4:	a2 2c 4b 12 c0       	mov    %al,0xc0124b2c
c01021f9:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102200:	83 e0 f0             	and    $0xfffffff0,%eax
c0102203:	83 c8 0e             	or     $0xe,%eax
c0102206:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c010220b:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102212:	83 e0 ef             	and    $0xffffffef,%eax
c0102215:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c010221a:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102221:	83 c8 60             	or     $0x60,%eax
c0102224:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c0102229:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102230:	83 c8 80             	or     $0xffffff80,%eax
c0102233:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c0102238:	a1 c4 17 12 c0       	mov    0xc01217c4,%eax
c010223d:	c1 e8 10             	shr    $0x10,%eax
c0102240:	66 a3 2e 4b 12 c0    	mov    %ax,0xc0124b2e
c0102246:	c7 45 f8 60 15 12 c0 	movl   $0xc0121560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010224d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102250:	0f 01 18             	lidtl  (%eax)
    // 3. LIDT
    lidt(&idt_pd);
}
c0102253:	90                   	nop
c0102254:	c9                   	leave  
c0102255:	c3                   	ret    

c0102256 <trapname>:

static const char *
trapname(int trapno) {
c0102256:	55                   	push   %ebp
c0102257:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102259:	8b 45 08             	mov    0x8(%ebp),%eax
c010225c:	83 f8 13             	cmp    $0x13,%eax
c010225f:	77 0c                	ja     c010226d <trapname+0x17>
        return excnames[trapno];
c0102261:	8b 45 08             	mov    0x8(%ebp),%eax
c0102264:	8b 04 85 a0 94 10 c0 	mov    -0x3fef6b60(,%eax,4),%eax
c010226b:	eb 18                	jmp    c0102285 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010226d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102271:	7e 0d                	jle    c0102280 <trapname+0x2a>
c0102273:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102277:	7f 07                	jg     c0102280 <trapname+0x2a>
        return "Hardware Interrupt";
c0102279:	b8 ea 90 10 c0       	mov    $0xc01090ea,%eax
c010227e:	eb 05                	jmp    c0102285 <trapname+0x2f>
    }
    return "(unknown trap)";
c0102280:	b8 fd 90 10 c0       	mov    $0xc01090fd,%eax
}
c0102285:	5d                   	pop    %ebp
c0102286:	c3                   	ret    

c0102287 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102287:	55                   	push   %ebp
c0102288:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010228a:	8b 45 08             	mov    0x8(%ebp),%eax
c010228d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102291:	66 83 f8 08          	cmp    $0x8,%ax
c0102295:	0f 94 c0             	sete   %al
c0102298:	0f b6 c0             	movzbl %al,%eax
}
c010229b:	5d                   	pop    %ebp
c010229c:	c3                   	ret    

c010229d <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c010229d:	55                   	push   %ebp
c010229e:	89 e5                	mov    %esp,%ebp
c01022a0:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c01022a3:	83 ec 08             	sub    $0x8,%esp
c01022a6:	ff 75 08             	pushl  0x8(%ebp)
c01022a9:	68 3e 91 10 c0       	push   $0xc010913e
c01022ae:	e8 d7 df ff ff       	call   c010028a <cprintf>
c01022b3:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c01022b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b9:	83 ec 0c             	sub    $0xc,%esp
c01022bc:	50                   	push   %eax
c01022bd:	e8 b8 01 00 00       	call   c010247a <print_regs>
c01022c2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022cc:	0f b7 c0             	movzwl %ax,%eax
c01022cf:	83 ec 08             	sub    $0x8,%esp
c01022d2:	50                   	push   %eax
c01022d3:	68 4f 91 10 c0       	push   $0xc010914f
c01022d8:	e8 ad df ff ff       	call   c010028a <cprintf>
c01022dd:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01022e7:	0f b7 c0             	movzwl %ax,%eax
c01022ea:	83 ec 08             	sub    $0x8,%esp
c01022ed:	50                   	push   %eax
c01022ee:	68 62 91 10 c0       	push   $0xc0109162
c01022f3:	e8 92 df ff ff       	call   c010028a <cprintf>
c01022f8:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01022fe:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102302:	0f b7 c0             	movzwl %ax,%eax
c0102305:	83 ec 08             	sub    $0x8,%esp
c0102308:	50                   	push   %eax
c0102309:	68 75 91 10 c0       	push   $0xc0109175
c010230e:	e8 77 df ff ff       	call   c010028a <cprintf>
c0102313:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102316:	8b 45 08             	mov    0x8(%ebp),%eax
c0102319:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010231d:	0f b7 c0             	movzwl %ax,%eax
c0102320:	83 ec 08             	sub    $0x8,%esp
c0102323:	50                   	push   %eax
c0102324:	68 88 91 10 c0       	push   $0xc0109188
c0102329:	e8 5c df ff ff       	call   c010028a <cprintf>
c010232e:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102331:	8b 45 08             	mov    0x8(%ebp),%eax
c0102334:	8b 40 30             	mov    0x30(%eax),%eax
c0102337:	83 ec 0c             	sub    $0xc,%esp
c010233a:	50                   	push   %eax
c010233b:	e8 16 ff ff ff       	call   c0102256 <trapname>
c0102340:	83 c4 10             	add    $0x10,%esp
c0102343:	89 c2                	mov    %eax,%edx
c0102345:	8b 45 08             	mov    0x8(%ebp),%eax
c0102348:	8b 40 30             	mov    0x30(%eax),%eax
c010234b:	83 ec 04             	sub    $0x4,%esp
c010234e:	52                   	push   %edx
c010234f:	50                   	push   %eax
c0102350:	68 9b 91 10 c0       	push   $0xc010919b
c0102355:	e8 30 df ff ff       	call   c010028a <cprintf>
c010235a:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c010235d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102360:	8b 40 34             	mov    0x34(%eax),%eax
c0102363:	83 ec 08             	sub    $0x8,%esp
c0102366:	50                   	push   %eax
c0102367:	68 ad 91 10 c0       	push   $0xc01091ad
c010236c:	e8 19 df ff ff       	call   c010028a <cprintf>
c0102371:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102374:	8b 45 08             	mov    0x8(%ebp),%eax
c0102377:	8b 40 38             	mov    0x38(%eax),%eax
c010237a:	83 ec 08             	sub    $0x8,%esp
c010237d:	50                   	push   %eax
c010237e:	68 bc 91 10 c0       	push   $0xc01091bc
c0102383:	e8 02 df ff ff       	call   c010028a <cprintf>
c0102388:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c010238b:	8b 45 08             	mov    0x8(%ebp),%eax
c010238e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102392:	0f b7 c0             	movzwl %ax,%eax
c0102395:	83 ec 08             	sub    $0x8,%esp
c0102398:	50                   	push   %eax
c0102399:	68 cb 91 10 c0       	push   $0xc01091cb
c010239e:	e8 e7 de ff ff       	call   c010028a <cprintf>
c01023a3:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a9:	8b 40 40             	mov    0x40(%eax),%eax
c01023ac:	83 ec 08             	sub    $0x8,%esp
c01023af:	50                   	push   %eax
c01023b0:	68 de 91 10 c0       	push   $0xc01091de
c01023b5:	e8 d0 de ff ff       	call   c010028a <cprintf>
c01023ba:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023cb:	eb 3f                	jmp    c010240c <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d0:	8b 50 40             	mov    0x40(%eax),%edx
c01023d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023d6:	21 d0                	and    %edx,%eax
c01023d8:	85 c0                	test   %eax,%eax
c01023da:	74 29                	je     c0102405 <print_trapframe+0x168>
c01023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023df:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c01023e6:	85 c0                	test   %eax,%eax
c01023e8:	74 1b                	je     c0102405 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c01023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023ed:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c01023f4:	83 ec 08             	sub    $0x8,%esp
c01023f7:	50                   	push   %eax
c01023f8:	68 ed 91 10 c0       	push   $0xc01091ed
c01023fd:	e8 88 de ff ff       	call   c010028a <cprintf>
c0102402:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102405:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102409:	d1 65 f0             	shll   -0x10(%ebp)
c010240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010240f:	83 f8 17             	cmp    $0x17,%eax
c0102412:	76 b9                	jbe    c01023cd <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102414:	8b 45 08             	mov    0x8(%ebp),%eax
c0102417:	8b 40 40             	mov    0x40(%eax),%eax
c010241a:	25 00 30 00 00       	and    $0x3000,%eax
c010241f:	c1 e8 0c             	shr    $0xc,%eax
c0102422:	83 ec 08             	sub    $0x8,%esp
c0102425:	50                   	push   %eax
c0102426:	68 f1 91 10 c0       	push   $0xc01091f1
c010242b:	e8 5a de ff ff       	call   c010028a <cprintf>
c0102430:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0102433:	83 ec 0c             	sub    $0xc,%esp
c0102436:	ff 75 08             	pushl  0x8(%ebp)
c0102439:	e8 49 fe ff ff       	call   c0102287 <trap_in_kernel>
c010243e:	83 c4 10             	add    $0x10,%esp
c0102441:	85 c0                	test   %eax,%eax
c0102443:	75 32                	jne    c0102477 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102445:	8b 45 08             	mov    0x8(%ebp),%eax
c0102448:	8b 40 44             	mov    0x44(%eax),%eax
c010244b:	83 ec 08             	sub    $0x8,%esp
c010244e:	50                   	push   %eax
c010244f:	68 fa 91 10 c0       	push   $0xc01091fa
c0102454:	e8 31 de ff ff       	call   c010028a <cprintf>
c0102459:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010245c:	8b 45 08             	mov    0x8(%ebp),%eax
c010245f:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102463:	0f b7 c0             	movzwl %ax,%eax
c0102466:	83 ec 08             	sub    $0x8,%esp
c0102469:	50                   	push   %eax
c010246a:	68 09 92 10 c0       	push   $0xc0109209
c010246f:	e8 16 de ff ff       	call   c010028a <cprintf>
c0102474:	83 c4 10             	add    $0x10,%esp
    }
}
c0102477:	90                   	nop
c0102478:	c9                   	leave  
c0102479:	c3                   	ret    

c010247a <print_regs>:

void
print_regs(struct pushregs *regs) {
c010247a:	55                   	push   %ebp
c010247b:	89 e5                	mov    %esp,%ebp
c010247d:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102480:	8b 45 08             	mov    0x8(%ebp),%eax
c0102483:	8b 00                	mov    (%eax),%eax
c0102485:	83 ec 08             	sub    $0x8,%esp
c0102488:	50                   	push   %eax
c0102489:	68 1c 92 10 c0       	push   $0xc010921c
c010248e:	e8 f7 dd ff ff       	call   c010028a <cprintf>
c0102493:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102496:	8b 45 08             	mov    0x8(%ebp),%eax
c0102499:	8b 40 04             	mov    0x4(%eax),%eax
c010249c:	83 ec 08             	sub    $0x8,%esp
c010249f:	50                   	push   %eax
c01024a0:	68 2b 92 10 c0       	push   $0xc010922b
c01024a5:	e8 e0 dd ff ff       	call   c010028a <cprintf>
c01024aa:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b0:	8b 40 08             	mov    0x8(%eax),%eax
c01024b3:	83 ec 08             	sub    $0x8,%esp
c01024b6:	50                   	push   %eax
c01024b7:	68 3a 92 10 c0       	push   $0xc010923a
c01024bc:	e8 c9 dd ff ff       	call   c010028a <cprintf>
c01024c1:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c7:	8b 40 0c             	mov    0xc(%eax),%eax
c01024ca:	83 ec 08             	sub    $0x8,%esp
c01024cd:	50                   	push   %eax
c01024ce:	68 49 92 10 c0       	push   $0xc0109249
c01024d3:	e8 b2 dd ff ff       	call   c010028a <cprintf>
c01024d8:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024db:	8b 45 08             	mov    0x8(%ebp),%eax
c01024de:	8b 40 10             	mov    0x10(%eax),%eax
c01024e1:	83 ec 08             	sub    $0x8,%esp
c01024e4:	50                   	push   %eax
c01024e5:	68 58 92 10 c0       	push   $0xc0109258
c01024ea:	e8 9b dd ff ff       	call   c010028a <cprintf>
c01024ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01024f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f5:	8b 40 14             	mov    0x14(%eax),%eax
c01024f8:	83 ec 08             	sub    $0x8,%esp
c01024fb:	50                   	push   %eax
c01024fc:	68 67 92 10 c0       	push   $0xc0109267
c0102501:	e8 84 dd ff ff       	call   c010028a <cprintf>
c0102506:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102509:	8b 45 08             	mov    0x8(%ebp),%eax
c010250c:	8b 40 18             	mov    0x18(%eax),%eax
c010250f:	83 ec 08             	sub    $0x8,%esp
c0102512:	50                   	push   %eax
c0102513:	68 76 92 10 c0       	push   $0xc0109276
c0102518:	e8 6d dd ff ff       	call   c010028a <cprintf>
c010251d:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102520:	8b 45 08             	mov    0x8(%ebp),%eax
c0102523:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102526:	83 ec 08             	sub    $0x8,%esp
c0102529:	50                   	push   %eax
c010252a:	68 85 92 10 c0       	push   $0xc0109285
c010252f:	e8 56 dd ff ff       	call   c010028a <cprintf>
c0102534:	83 c4 10             	add    $0x10,%esp
}
c0102537:	90                   	nop
c0102538:	c9                   	leave  
c0102539:	c3                   	ret    

c010253a <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010253a:	55                   	push   %ebp
c010253b:	89 e5                	mov    %esp,%ebp
c010253d:	53                   	push   %ebx
c010253e:	83 ec 14             	sub    $0x14,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102541:	8b 45 08             	mov    0x8(%ebp),%eax
c0102544:	8b 40 34             	mov    0x34(%eax),%eax
c0102547:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010254a:	85 c0                	test   %eax,%eax
c010254c:	74 07                	je     c0102555 <print_pgfault+0x1b>
c010254e:	bb 94 92 10 c0       	mov    $0xc0109294,%ebx
c0102553:	eb 05                	jmp    c010255a <print_pgfault+0x20>
c0102555:	bb a5 92 10 c0       	mov    $0xc01092a5,%ebx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010255a:	8b 45 08             	mov    0x8(%ebp),%eax
c010255d:	8b 40 34             	mov    0x34(%eax),%eax
c0102560:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102563:	85 c0                	test   %eax,%eax
c0102565:	74 07                	je     c010256e <print_pgfault+0x34>
c0102567:	b9 57 00 00 00       	mov    $0x57,%ecx
c010256c:	eb 05                	jmp    c0102573 <print_pgfault+0x39>
c010256e:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102573:	8b 45 08             	mov    0x8(%ebp),%eax
c0102576:	8b 40 34             	mov    0x34(%eax),%eax
c0102579:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010257c:	85 c0                	test   %eax,%eax
c010257e:	74 07                	je     c0102587 <print_pgfault+0x4d>
c0102580:	ba 55 00 00 00       	mov    $0x55,%edx
c0102585:	eb 05                	jmp    c010258c <print_pgfault+0x52>
c0102587:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010258c:	0f 20 d0             	mov    %cr2,%eax
c010258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102592:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102595:	83 ec 0c             	sub    $0xc,%esp
c0102598:	53                   	push   %ebx
c0102599:	51                   	push   %ecx
c010259a:	52                   	push   %edx
c010259b:	50                   	push   %eax
c010259c:	68 b4 92 10 c0       	push   $0xc01092b4
c01025a1:	e8 e4 dc ff ff       	call   c010028a <cprintf>
c01025a6:	83 c4 20             	add    $0x20,%esp
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025a9:	90                   	nop
c01025aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01025ad:	c9                   	leave  
c01025ae:	c3                   	ret    

c01025af <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025af:	55                   	push   %ebp
c01025b0:	89 e5                	mov    %esp,%ebp
c01025b2:	83 ec 18             	sub    $0x18,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025b5:	83 ec 0c             	sub    $0xc,%esp
c01025b8:	ff 75 08             	pushl  0x8(%ebp)
c01025bb:	e8 7a ff ff ff       	call   c010253a <print_pgfault>
c01025c0:	83 c4 10             	add    $0x10,%esp
    if (check_mm_struct != NULL) {
c01025c3:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c01025c8:	85 c0                	test   %eax,%eax
c01025ca:	74 24                	je     c01025f0 <pgfault_handler+0x41>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025cc:	0f 20 d0             	mov    %cr2,%eax
c01025cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025d2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d8:	8b 50 34             	mov    0x34(%eax),%edx
c01025db:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c01025e0:	83 ec 04             	sub    $0x4,%esp
c01025e3:	51                   	push   %ecx
c01025e4:	52                   	push   %edx
c01025e5:	50                   	push   %eax
c01025e6:	e8 a7 1e 00 00       	call   c0104492 <do_pgfault>
c01025eb:	83 c4 10             	add    $0x10,%esp
c01025ee:	eb 17                	jmp    c0102607 <pgfault_handler+0x58>
    }
    panic("unhandled page fault.\n");
c01025f0:	83 ec 04             	sub    $0x4,%esp
c01025f3:	68 d7 92 10 c0       	push   $0xc01092d7
c01025f8:	68 a9 00 00 00       	push   $0xa9
c01025fd:	68 ee 92 10 c0       	push   $0xc01092ee
c0102602:	e8 e9 dd ff ff       	call   c01003f0 <__panic>
}
c0102607:	c9                   	leave  
c0102608:	c3                   	ret    

c0102609 <trap_dispatch>:
// LAB1 YOU SHOULD ALSO COPY THIS
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

static void
trap_dispatch(struct trapframe *tf) {
c0102609:	55                   	push   %ebp
c010260a:	89 e5                	mov    %esp,%ebp
c010260c:	57                   	push   %edi
c010260d:	56                   	push   %esi
c010260e:	53                   	push   %ebx
c010260f:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102612:	8b 45 08             	mov    0x8(%ebp),%eax
c0102615:	8b 40 30             	mov    0x30(%eax),%eax
c0102618:	83 f8 24             	cmp    $0x24,%eax
c010261b:	0f 84 c8 00 00 00    	je     c01026e9 <trap_dispatch+0xe0>
c0102621:	83 f8 24             	cmp    $0x24,%eax
c0102624:	77 1c                	ja     c0102642 <trap_dispatch+0x39>
c0102626:	83 f8 20             	cmp    $0x20,%eax
c0102629:	0f 84 80 00 00 00    	je     c01026af <trap_dispatch+0xa6>
c010262f:	83 f8 21             	cmp    $0x21,%eax
c0102632:	0f 84 d8 00 00 00    	je     c0102710 <trap_dispatch+0x107>
c0102638:	83 f8 0e             	cmp    $0xe,%eax
c010263b:	74 32                	je     c010266f <trap_dispatch+0x66>
c010263d:	e9 98 01 00 00       	jmp    c01027da <trap_dispatch+0x1d1>
c0102642:	83 f8 78             	cmp    $0x78,%eax
c0102645:	0f 84 ec 00 00 00    	je     c0102737 <trap_dispatch+0x12e>
c010264b:	83 f8 78             	cmp    $0x78,%eax
c010264e:	77 11                	ja     c0102661 <trap_dispatch+0x58>
c0102650:	83 e8 2e             	sub    $0x2e,%eax
c0102653:	83 f8 01             	cmp    $0x1,%eax
c0102656:	0f 87 7e 01 00 00    	ja     c01027da <trap_dispatch+0x1d1>
    // end of copy

    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010265c:	e9 b3 01 00 00       	jmp    c0102814 <trap_dispatch+0x20b>
trap_dispatch(struct trapframe *tf) {
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102661:	83 f8 79             	cmp    $0x79,%eax
c0102664:	0f 84 42 01 00 00    	je     c01027ac <trap_dispatch+0x1a3>
c010266a:	e9 6b 01 00 00       	jmp    c01027da <trap_dispatch+0x1d1>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c010266f:	83 ec 0c             	sub    $0xc,%esp
c0102672:	ff 75 08             	pushl  0x8(%ebp)
c0102675:	e8 35 ff ff ff       	call   c01025af <pgfault_handler>
c010267a:	83 c4 10             	add    $0x10,%esp
c010267d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102684:	0f 84 86 01 00 00    	je     c0102810 <trap_dispatch+0x207>
            print_trapframe(tf);
c010268a:	83 ec 0c             	sub    $0xc,%esp
c010268d:	ff 75 08             	pushl  0x8(%ebp)
c0102690:	e8 08 fc ff ff       	call   c010229d <print_trapframe>
c0102695:	83 c4 10             	add    $0x10,%esp
            panic("handle pgfault failed. %e\n", ret);
c0102698:	ff 75 e4             	pushl  -0x1c(%ebp)
c010269b:	68 ff 92 10 c0       	push   $0xc01092ff
c01026a0:	68 bd 00 00 00       	push   $0xbd
c01026a5:	68 ee 92 10 c0       	push   $0xc01092ee
c01026aa:	e8 41 dd ff ff       	call   c01003f0 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c01026af:	a1 0c 50 12 c0       	mov    0xc012500c,%eax
c01026b4:	83 c0 01             	add    $0x1,%eax
c01026b7:	a3 0c 50 12 c0       	mov    %eax,0xc012500c
        if (ticks % TICK_NUM == 0) {
c01026bc:	8b 0d 0c 50 12 c0    	mov    0xc012500c,%ecx
c01026c2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01026c7:	89 c8                	mov    %ecx,%eax
c01026c9:	f7 e2                	mul    %edx
c01026cb:	89 d0                	mov    %edx,%eax
c01026cd:	c1 e8 05             	shr    $0x5,%eax
c01026d0:	6b c0 64             	imul   $0x64,%eax,%eax
c01026d3:	29 c1                	sub    %eax,%ecx
c01026d5:	89 c8                	mov    %ecx,%eax
c01026d7:	85 c0                	test   %eax,%eax
c01026d9:	0f 85 34 01 00 00    	jne    c0102813 <trap_dispatch+0x20a>
            print_ticks();
c01026df:	e8 e6 f9 ff ff       	call   c01020ca <print_ticks>
        }
        break;
c01026e4:	e9 2a 01 00 00       	jmp    c0102813 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026e9:	e8 99 f7 ff ff       	call   c0101e87 <cons_getc>
c01026ee:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01026f1:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c01026f5:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c01026f9:	83 ec 04             	sub    $0x4,%esp
c01026fc:	52                   	push   %edx
c01026fd:	50                   	push   %eax
c01026fe:	68 1a 93 10 c0       	push   $0xc010931a
c0102703:	e8 82 db ff ff       	call   c010028a <cprintf>
c0102708:	83 c4 10             	add    $0x10,%esp
        break;
c010270b:	e9 04 01 00 00       	jmp    c0102814 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102710:	e8 72 f7 ff ff       	call   c0101e87 <cons_getc>
c0102715:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102718:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c010271c:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c0102720:	83 ec 04             	sub    $0x4,%esp
c0102723:	52                   	push   %edx
c0102724:	50                   	push   %eax
c0102725:	68 2c 93 10 c0       	push   $0xc010932c
c010272a:	e8 5b db ff ff       	call   c010028a <cprintf>
c010272f:	83 c4 10             	add    $0x10,%esp
        break;
c0102732:	e9 dd 00 00 00       	jmp    c0102814 <trap_dispatch+0x20b>
        
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
c0102737:	8b 55 08             	mov    0x8(%ebp),%edx
c010273a:	b8 20 50 12 c0       	mov    $0xc0125020,%eax
c010273f:	89 d3                	mov    %edx,%ebx
c0102741:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0102746:	8b 0b                	mov    (%ebx),%ecx
c0102748:	89 08                	mov    %ecx,(%eax)
c010274a:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c010274e:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0102752:	8d 78 04             	lea    0x4(%eax),%edi
c0102755:	83 e7 fc             	and    $0xfffffffc,%edi
c0102758:	29 f8                	sub    %edi,%eax
c010275a:	29 c3                	sub    %eax,%ebx
c010275c:	01 c2                	add    %eax,%edx
c010275e:	83 e2 fc             	and    $0xfffffffc,%edx
c0102761:	89 d0                	mov    %edx,%eax
c0102763:	c1 e8 02             	shr    $0x2,%eax
c0102766:	89 de                	mov    %ebx,%esi
c0102768:	89 c1                	mov    %eax,%ecx
c010276a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
c010276c:	66 c7 05 5c 50 12 c0 	movw   $0x1b,0xc012505c
c0102773:	1b 00 
        switchk2u.tf_ds = USER_DS;
c0102775:	66 c7 05 4c 50 12 c0 	movw   $0x23,0xc012504c
c010277c:	23 00 
        switchk2u.tf_es = USER_DS;
c010277e:	66 c7 05 48 50 12 c0 	movw   $0x23,0xc0125048
c0102785:	23 00 
        switchk2u.tf_ss = USER_DS;
c0102787:	66 c7 05 68 50 12 c0 	movw   $0x23,0xc0125068
c010278e:	23 00 
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c0102790:	a1 60 50 12 c0       	mov    0xc0125060,%eax
c0102795:	80 cc 30             	or     $0x30,%ah
c0102798:	a3 60 50 12 c0       	mov    %eax,0xc0125060
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c010279d:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a0:	83 e8 04             	sub    $0x4,%eax
c01027a3:	ba 20 50 12 c0       	mov    $0xc0125020,%edx
c01027a8:	89 10                	mov    %edx,(%eax)
        break;
c01027aa:	eb 68                	jmp    c0102814 <trap_dispatch+0x20b>
    case T_SWITCH_TOK:
        tf->tf_cs = KERNEL_CS;
c01027ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01027af:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c01027b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01027b8:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c01027be:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c1:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c01027c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ca:	8b 40 40             	mov    0x40(%eax),%eax
c01027cd:	80 e4 cf             	and    $0xcf,%ah
c01027d0:	89 c2                	mov    %eax,%edx
c01027d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d5:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c01027d8:	eb 3a                	jmp    c0102814 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01027da:	8b 45 08             	mov    0x8(%ebp),%eax
c01027dd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01027e1:	0f b7 c0             	movzwl %ax,%eax
c01027e4:	83 e0 03             	and    $0x3,%eax
c01027e7:	85 c0                	test   %eax,%eax
c01027e9:	75 29                	jne    c0102814 <trap_dispatch+0x20b>
            print_trapframe(tf);
c01027eb:	83 ec 0c             	sub    $0xc,%esp
c01027ee:	ff 75 08             	pushl  0x8(%ebp)
c01027f1:	e8 a7 fa ff ff       	call   c010229d <print_trapframe>
c01027f6:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c01027f9:	83 ec 04             	sub    $0x4,%esp
c01027fc:	68 3b 93 10 c0       	push   $0xc010933b
c0102801:	68 f3 00 00 00       	push   $0xf3
c0102806:	68 ee 92 10 c0       	push   $0xc01092ee
c010280b:	e8 e0 db ff ff       	call   c01003f0 <__panic>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c0102810:	90                   	nop
c0102811:	eb 01                	jmp    c0102814 <trap_dispatch+0x20b>
         */
        ticks++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
c0102813:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102814:	90                   	nop
c0102815:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102818:	5b                   	pop    %ebx
c0102819:	5e                   	pop    %esi
c010281a:	5f                   	pop    %edi
c010281b:	5d                   	pop    %ebp
c010281c:	c3                   	ret    

c010281d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010281d:	55                   	push   %ebp
c010281e:	89 e5                	mov    %esp,%ebp
c0102820:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102823:	83 ec 0c             	sub    $0xc,%esp
c0102826:	ff 75 08             	pushl  0x8(%ebp)
c0102829:	e8 db fd ff ff       	call   c0102609 <trap_dispatch>
c010282e:	83 c4 10             	add    $0x10,%esp
}
c0102831:	90                   	nop
c0102832:	c9                   	leave  
c0102833:	c3                   	ret    

c0102834 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $0
c0102836:	6a 00                	push   $0x0
  jmp __alltraps
c0102838:	e9 69 0a 00 00       	jmp    c01032a6 <__alltraps>

c010283d <vector1>:
.globl vector1
vector1:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $1
c010283f:	6a 01                	push   $0x1
  jmp __alltraps
c0102841:	e9 60 0a 00 00       	jmp    c01032a6 <__alltraps>

c0102846 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102846:	6a 00                	push   $0x0
  pushl $2
c0102848:	6a 02                	push   $0x2
  jmp __alltraps
c010284a:	e9 57 0a 00 00       	jmp    c01032a6 <__alltraps>

c010284f <vector3>:
.globl vector3
vector3:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $3
c0102851:	6a 03                	push   $0x3
  jmp __alltraps
c0102853:	e9 4e 0a 00 00       	jmp    c01032a6 <__alltraps>

c0102858 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $4
c010285a:	6a 04                	push   $0x4
  jmp __alltraps
c010285c:	e9 45 0a 00 00       	jmp    c01032a6 <__alltraps>

c0102861 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $5
c0102863:	6a 05                	push   $0x5
  jmp __alltraps
c0102865:	e9 3c 0a 00 00       	jmp    c01032a6 <__alltraps>

c010286a <vector6>:
.globl vector6
vector6:
  pushl $0
c010286a:	6a 00                	push   $0x0
  pushl $6
c010286c:	6a 06                	push   $0x6
  jmp __alltraps
c010286e:	e9 33 0a 00 00       	jmp    c01032a6 <__alltraps>

c0102873 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102873:	6a 00                	push   $0x0
  pushl $7
c0102875:	6a 07                	push   $0x7
  jmp __alltraps
c0102877:	e9 2a 0a 00 00       	jmp    c01032a6 <__alltraps>

c010287c <vector8>:
.globl vector8
vector8:
  pushl $8
c010287c:	6a 08                	push   $0x8
  jmp __alltraps
c010287e:	e9 23 0a 00 00       	jmp    c01032a6 <__alltraps>

c0102883 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $9
c0102885:	6a 09                	push   $0x9
  jmp __alltraps
c0102887:	e9 1a 0a 00 00       	jmp    c01032a6 <__alltraps>

c010288c <vector10>:
.globl vector10
vector10:
  pushl $10
c010288c:	6a 0a                	push   $0xa
  jmp __alltraps
c010288e:	e9 13 0a 00 00       	jmp    c01032a6 <__alltraps>

c0102893 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102893:	6a 0b                	push   $0xb
  jmp __alltraps
c0102895:	e9 0c 0a 00 00       	jmp    c01032a6 <__alltraps>

c010289a <vector12>:
.globl vector12
vector12:
  pushl $12
c010289a:	6a 0c                	push   $0xc
  jmp __alltraps
c010289c:	e9 05 0a 00 00       	jmp    c01032a6 <__alltraps>

c01028a1 <vector13>:
.globl vector13
vector13:
  pushl $13
c01028a1:	6a 0d                	push   $0xd
  jmp __alltraps
c01028a3:	e9 fe 09 00 00       	jmp    c01032a6 <__alltraps>

c01028a8 <vector14>:
.globl vector14
vector14:
  pushl $14
c01028a8:	6a 0e                	push   $0xe
  jmp __alltraps
c01028aa:	e9 f7 09 00 00       	jmp    c01032a6 <__alltraps>

c01028af <vector15>:
.globl vector15
vector15:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $15
c01028b1:	6a 0f                	push   $0xf
  jmp __alltraps
c01028b3:	e9 ee 09 00 00       	jmp    c01032a6 <__alltraps>

c01028b8 <vector16>:
.globl vector16
vector16:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $16
c01028ba:	6a 10                	push   $0x10
  jmp __alltraps
c01028bc:	e9 e5 09 00 00       	jmp    c01032a6 <__alltraps>

c01028c1 <vector17>:
.globl vector17
vector17:
  pushl $17
c01028c1:	6a 11                	push   $0x11
  jmp __alltraps
c01028c3:	e9 de 09 00 00       	jmp    c01032a6 <__alltraps>

c01028c8 <vector18>:
.globl vector18
vector18:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $18
c01028ca:	6a 12                	push   $0x12
  jmp __alltraps
c01028cc:	e9 d5 09 00 00       	jmp    c01032a6 <__alltraps>

c01028d1 <vector19>:
.globl vector19
vector19:
  pushl $0
c01028d1:	6a 00                	push   $0x0
  pushl $19
c01028d3:	6a 13                	push   $0x13
  jmp __alltraps
c01028d5:	e9 cc 09 00 00       	jmp    c01032a6 <__alltraps>

c01028da <vector20>:
.globl vector20
vector20:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $20
c01028dc:	6a 14                	push   $0x14
  jmp __alltraps
c01028de:	e9 c3 09 00 00       	jmp    c01032a6 <__alltraps>

c01028e3 <vector21>:
.globl vector21
vector21:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $21
c01028e5:	6a 15                	push   $0x15
  jmp __alltraps
c01028e7:	e9 ba 09 00 00       	jmp    c01032a6 <__alltraps>

c01028ec <vector22>:
.globl vector22
vector22:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $22
c01028ee:	6a 16                	push   $0x16
  jmp __alltraps
c01028f0:	e9 b1 09 00 00       	jmp    c01032a6 <__alltraps>

c01028f5 <vector23>:
.globl vector23
vector23:
  pushl $0
c01028f5:	6a 00                	push   $0x0
  pushl $23
c01028f7:	6a 17                	push   $0x17
  jmp __alltraps
c01028f9:	e9 a8 09 00 00       	jmp    c01032a6 <__alltraps>

c01028fe <vector24>:
.globl vector24
vector24:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $24
c0102900:	6a 18                	push   $0x18
  jmp __alltraps
c0102902:	e9 9f 09 00 00       	jmp    c01032a6 <__alltraps>

c0102907 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $25
c0102909:	6a 19                	push   $0x19
  jmp __alltraps
c010290b:	e9 96 09 00 00       	jmp    c01032a6 <__alltraps>

c0102910 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $26
c0102912:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102914:	e9 8d 09 00 00       	jmp    c01032a6 <__alltraps>

c0102919 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102919:	6a 00                	push   $0x0
  pushl $27
c010291b:	6a 1b                	push   $0x1b
  jmp __alltraps
c010291d:	e9 84 09 00 00       	jmp    c01032a6 <__alltraps>

c0102922 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $28
c0102924:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102926:	e9 7b 09 00 00       	jmp    c01032a6 <__alltraps>

c010292b <vector29>:
.globl vector29
vector29:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $29
c010292d:	6a 1d                	push   $0x1d
  jmp __alltraps
c010292f:	e9 72 09 00 00       	jmp    c01032a6 <__alltraps>

c0102934 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $30
c0102936:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102938:	e9 69 09 00 00       	jmp    c01032a6 <__alltraps>

c010293d <vector31>:
.globl vector31
vector31:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $31
c010293f:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102941:	e9 60 09 00 00       	jmp    c01032a6 <__alltraps>

c0102946 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $32
c0102948:	6a 20                	push   $0x20
  jmp __alltraps
c010294a:	e9 57 09 00 00       	jmp    c01032a6 <__alltraps>

c010294f <vector33>:
.globl vector33
vector33:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $33
c0102951:	6a 21                	push   $0x21
  jmp __alltraps
c0102953:	e9 4e 09 00 00       	jmp    c01032a6 <__alltraps>

c0102958 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $34
c010295a:	6a 22                	push   $0x22
  jmp __alltraps
c010295c:	e9 45 09 00 00       	jmp    c01032a6 <__alltraps>

c0102961 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102961:	6a 00                	push   $0x0
  pushl $35
c0102963:	6a 23                	push   $0x23
  jmp __alltraps
c0102965:	e9 3c 09 00 00       	jmp    c01032a6 <__alltraps>

c010296a <vector36>:
.globl vector36
vector36:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $36
c010296c:	6a 24                	push   $0x24
  jmp __alltraps
c010296e:	e9 33 09 00 00       	jmp    c01032a6 <__alltraps>

c0102973 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $37
c0102975:	6a 25                	push   $0x25
  jmp __alltraps
c0102977:	e9 2a 09 00 00       	jmp    c01032a6 <__alltraps>

c010297c <vector38>:
.globl vector38
vector38:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $38
c010297e:	6a 26                	push   $0x26
  jmp __alltraps
c0102980:	e9 21 09 00 00       	jmp    c01032a6 <__alltraps>

c0102985 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102985:	6a 00                	push   $0x0
  pushl $39
c0102987:	6a 27                	push   $0x27
  jmp __alltraps
c0102989:	e9 18 09 00 00       	jmp    c01032a6 <__alltraps>

c010298e <vector40>:
.globl vector40
vector40:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $40
c0102990:	6a 28                	push   $0x28
  jmp __alltraps
c0102992:	e9 0f 09 00 00       	jmp    c01032a6 <__alltraps>

c0102997 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $41
c0102999:	6a 29                	push   $0x29
  jmp __alltraps
c010299b:	e9 06 09 00 00       	jmp    c01032a6 <__alltraps>

c01029a0 <vector42>:
.globl vector42
vector42:
  pushl $0
c01029a0:	6a 00                	push   $0x0
  pushl $42
c01029a2:	6a 2a                	push   $0x2a
  jmp __alltraps
c01029a4:	e9 fd 08 00 00       	jmp    c01032a6 <__alltraps>

c01029a9 <vector43>:
.globl vector43
vector43:
  pushl $0
c01029a9:	6a 00                	push   $0x0
  pushl $43
c01029ab:	6a 2b                	push   $0x2b
  jmp __alltraps
c01029ad:	e9 f4 08 00 00       	jmp    c01032a6 <__alltraps>

c01029b2 <vector44>:
.globl vector44
vector44:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $44
c01029b4:	6a 2c                	push   $0x2c
  jmp __alltraps
c01029b6:	e9 eb 08 00 00       	jmp    c01032a6 <__alltraps>

c01029bb <vector45>:
.globl vector45
vector45:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $45
c01029bd:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029bf:	e9 e2 08 00 00       	jmp    c01032a6 <__alltraps>

c01029c4 <vector46>:
.globl vector46
vector46:
  pushl $0
c01029c4:	6a 00                	push   $0x0
  pushl $46
c01029c6:	6a 2e                	push   $0x2e
  jmp __alltraps
c01029c8:	e9 d9 08 00 00       	jmp    c01032a6 <__alltraps>

c01029cd <vector47>:
.globl vector47
vector47:
  pushl $0
c01029cd:	6a 00                	push   $0x0
  pushl $47
c01029cf:	6a 2f                	push   $0x2f
  jmp __alltraps
c01029d1:	e9 d0 08 00 00       	jmp    c01032a6 <__alltraps>

c01029d6 <vector48>:
.globl vector48
vector48:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $48
c01029d8:	6a 30                	push   $0x30
  jmp __alltraps
c01029da:	e9 c7 08 00 00       	jmp    c01032a6 <__alltraps>

c01029df <vector49>:
.globl vector49
vector49:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $49
c01029e1:	6a 31                	push   $0x31
  jmp __alltraps
c01029e3:	e9 be 08 00 00       	jmp    c01032a6 <__alltraps>

c01029e8 <vector50>:
.globl vector50
vector50:
  pushl $0
c01029e8:	6a 00                	push   $0x0
  pushl $50
c01029ea:	6a 32                	push   $0x32
  jmp __alltraps
c01029ec:	e9 b5 08 00 00       	jmp    c01032a6 <__alltraps>

c01029f1 <vector51>:
.globl vector51
vector51:
  pushl $0
c01029f1:	6a 00                	push   $0x0
  pushl $51
c01029f3:	6a 33                	push   $0x33
  jmp __alltraps
c01029f5:	e9 ac 08 00 00       	jmp    c01032a6 <__alltraps>

c01029fa <vector52>:
.globl vector52
vector52:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $52
c01029fc:	6a 34                	push   $0x34
  jmp __alltraps
c01029fe:	e9 a3 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a03 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $53
c0102a05:	6a 35                	push   $0x35
  jmp __alltraps
c0102a07:	e9 9a 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a0c <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a0c:	6a 00                	push   $0x0
  pushl $54
c0102a0e:	6a 36                	push   $0x36
  jmp __alltraps
c0102a10:	e9 91 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a15 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102a15:	6a 00                	push   $0x0
  pushl $55
c0102a17:	6a 37                	push   $0x37
  jmp __alltraps
c0102a19:	e9 88 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a1e <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $56
c0102a20:	6a 38                	push   $0x38
  jmp __alltraps
c0102a22:	e9 7f 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a27 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $57
c0102a29:	6a 39                	push   $0x39
  jmp __alltraps
c0102a2b:	e9 76 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a30 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a30:	6a 00                	push   $0x0
  pushl $58
c0102a32:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a34:	e9 6d 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a39 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a39:	6a 00                	push   $0x0
  pushl $59
c0102a3b:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a3d:	e9 64 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a42 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $60
c0102a44:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a46:	e9 5b 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a4b <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $61
c0102a4d:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a4f:	e9 52 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a54 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a54:	6a 00                	push   $0x0
  pushl $62
c0102a56:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a58:	e9 49 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a5d <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a5d:	6a 00                	push   $0x0
  pushl $63
c0102a5f:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a61:	e9 40 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a66 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $64
c0102a68:	6a 40                	push   $0x40
  jmp __alltraps
c0102a6a:	e9 37 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a6f <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $65
c0102a71:	6a 41                	push   $0x41
  jmp __alltraps
c0102a73:	e9 2e 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a78 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a78:	6a 00                	push   $0x0
  pushl $66
c0102a7a:	6a 42                	push   $0x42
  jmp __alltraps
c0102a7c:	e9 25 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a81 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a81:	6a 00                	push   $0x0
  pushl $67
c0102a83:	6a 43                	push   $0x43
  jmp __alltraps
c0102a85:	e9 1c 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a8a <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $68
c0102a8c:	6a 44                	push   $0x44
  jmp __alltraps
c0102a8e:	e9 13 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a93 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $69
c0102a95:	6a 45                	push   $0x45
  jmp __alltraps
c0102a97:	e9 0a 08 00 00       	jmp    c01032a6 <__alltraps>

c0102a9c <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a9c:	6a 00                	push   $0x0
  pushl $70
c0102a9e:	6a 46                	push   $0x46
  jmp __alltraps
c0102aa0:	e9 01 08 00 00       	jmp    c01032a6 <__alltraps>

c0102aa5 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $71
c0102aa7:	6a 47                	push   $0x47
  jmp __alltraps
c0102aa9:	e9 f8 07 00 00       	jmp    c01032a6 <__alltraps>

c0102aae <vector72>:
.globl vector72
vector72:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $72
c0102ab0:	6a 48                	push   $0x48
  jmp __alltraps
c0102ab2:	e9 ef 07 00 00       	jmp    c01032a6 <__alltraps>

c0102ab7 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $73
c0102ab9:	6a 49                	push   $0x49
  jmp __alltraps
c0102abb:	e9 e6 07 00 00       	jmp    c01032a6 <__alltraps>

c0102ac0 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102ac0:	6a 00                	push   $0x0
  pushl $74
c0102ac2:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102ac4:	e9 dd 07 00 00       	jmp    c01032a6 <__alltraps>

c0102ac9 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $75
c0102acb:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102acd:	e9 d4 07 00 00       	jmp    c01032a6 <__alltraps>

c0102ad2 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $76
c0102ad4:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102ad6:	e9 cb 07 00 00       	jmp    c01032a6 <__alltraps>

c0102adb <vector77>:
.globl vector77
vector77:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $77
c0102add:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102adf:	e9 c2 07 00 00       	jmp    c01032a6 <__alltraps>

c0102ae4 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102ae4:	6a 00                	push   $0x0
  pushl $78
c0102ae6:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102ae8:	e9 b9 07 00 00       	jmp    c01032a6 <__alltraps>

c0102aed <vector79>:
.globl vector79
vector79:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $79
c0102aef:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102af1:	e9 b0 07 00 00       	jmp    c01032a6 <__alltraps>

c0102af6 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $80
c0102af8:	6a 50                	push   $0x50
  jmp __alltraps
c0102afa:	e9 a7 07 00 00       	jmp    c01032a6 <__alltraps>

c0102aff <vector81>:
.globl vector81
vector81:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $81
c0102b01:	6a 51                	push   $0x51
  jmp __alltraps
c0102b03:	e9 9e 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b08 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $82
c0102b0a:	6a 52                	push   $0x52
  jmp __alltraps
c0102b0c:	e9 95 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b11 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $83
c0102b13:	6a 53                	push   $0x53
  jmp __alltraps
c0102b15:	e9 8c 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b1a <vector84>:
.globl vector84
vector84:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $84
c0102b1c:	6a 54                	push   $0x54
  jmp __alltraps
c0102b1e:	e9 83 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b23 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $85
c0102b25:	6a 55                	push   $0x55
  jmp __alltraps
c0102b27:	e9 7a 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b2c <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $86
c0102b2e:	6a 56                	push   $0x56
  jmp __alltraps
c0102b30:	e9 71 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b35 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $87
c0102b37:	6a 57                	push   $0x57
  jmp __alltraps
c0102b39:	e9 68 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b3e <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $88
c0102b40:	6a 58                	push   $0x58
  jmp __alltraps
c0102b42:	e9 5f 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b47 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $89
c0102b49:	6a 59                	push   $0x59
  jmp __alltraps
c0102b4b:	e9 56 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b50 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $90
c0102b52:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b54:	e9 4d 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b59 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $91
c0102b5b:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b5d:	e9 44 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b62 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $92
c0102b64:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b66:	e9 3b 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b6b <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $93
c0102b6d:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b6f:	e9 32 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b74 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $94
c0102b76:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b78:	e9 29 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b7d <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $95
c0102b7f:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b81:	e9 20 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b86 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $96
c0102b88:	6a 60                	push   $0x60
  jmp __alltraps
c0102b8a:	e9 17 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b8f <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $97
c0102b91:	6a 61                	push   $0x61
  jmp __alltraps
c0102b93:	e9 0e 07 00 00       	jmp    c01032a6 <__alltraps>

c0102b98 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $98
c0102b9a:	6a 62                	push   $0x62
  jmp __alltraps
c0102b9c:	e9 05 07 00 00       	jmp    c01032a6 <__alltraps>

c0102ba1 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $99
c0102ba3:	6a 63                	push   $0x63
  jmp __alltraps
c0102ba5:	e9 fc 06 00 00       	jmp    c01032a6 <__alltraps>

c0102baa <vector100>:
.globl vector100
vector100:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $100
c0102bac:	6a 64                	push   $0x64
  jmp __alltraps
c0102bae:	e9 f3 06 00 00       	jmp    c01032a6 <__alltraps>

c0102bb3 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $101
c0102bb5:	6a 65                	push   $0x65
  jmp __alltraps
c0102bb7:	e9 ea 06 00 00       	jmp    c01032a6 <__alltraps>

c0102bbc <vector102>:
.globl vector102
vector102:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $102
c0102bbe:	6a 66                	push   $0x66
  jmp __alltraps
c0102bc0:	e9 e1 06 00 00       	jmp    c01032a6 <__alltraps>

c0102bc5 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102bc5:	6a 00                	push   $0x0
  pushl $103
c0102bc7:	6a 67                	push   $0x67
  jmp __alltraps
c0102bc9:	e9 d8 06 00 00       	jmp    c01032a6 <__alltraps>

c0102bce <vector104>:
.globl vector104
vector104:
  pushl $0
c0102bce:	6a 00                	push   $0x0
  pushl $104
c0102bd0:	6a 68                	push   $0x68
  jmp __alltraps
c0102bd2:	e9 cf 06 00 00       	jmp    c01032a6 <__alltraps>

c0102bd7 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102bd7:	6a 00                	push   $0x0
  pushl $105
c0102bd9:	6a 69                	push   $0x69
  jmp __alltraps
c0102bdb:	e9 c6 06 00 00       	jmp    c01032a6 <__alltraps>

c0102be0 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102be0:	6a 00                	push   $0x0
  pushl $106
c0102be2:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102be4:	e9 bd 06 00 00       	jmp    c01032a6 <__alltraps>

c0102be9 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102be9:	6a 00                	push   $0x0
  pushl $107
c0102beb:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102bed:	e9 b4 06 00 00       	jmp    c01032a6 <__alltraps>

c0102bf2 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102bf2:	6a 00                	push   $0x0
  pushl $108
c0102bf4:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102bf6:	e9 ab 06 00 00       	jmp    c01032a6 <__alltraps>

c0102bfb <vector109>:
.globl vector109
vector109:
  pushl $0
c0102bfb:	6a 00                	push   $0x0
  pushl $109
c0102bfd:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102bff:	e9 a2 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c04 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102c04:	6a 00                	push   $0x0
  pushl $110
c0102c06:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c08:	e9 99 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c0d <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c0d:	6a 00                	push   $0x0
  pushl $111
c0102c0f:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c11:	e9 90 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c16 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102c16:	6a 00                	push   $0x0
  pushl $112
c0102c18:	6a 70                	push   $0x70
  jmp __alltraps
c0102c1a:	e9 87 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c1f <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c1f:	6a 00                	push   $0x0
  pushl $113
c0102c21:	6a 71                	push   $0x71
  jmp __alltraps
c0102c23:	e9 7e 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c28 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $114
c0102c2a:	6a 72                	push   $0x72
  jmp __alltraps
c0102c2c:	e9 75 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c31 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c31:	6a 00                	push   $0x0
  pushl $115
c0102c33:	6a 73                	push   $0x73
  jmp __alltraps
c0102c35:	e9 6c 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c3a <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c3a:	6a 00                	push   $0x0
  pushl $116
c0102c3c:	6a 74                	push   $0x74
  jmp __alltraps
c0102c3e:	e9 63 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c43 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c43:	6a 00                	push   $0x0
  pushl $117
c0102c45:	6a 75                	push   $0x75
  jmp __alltraps
c0102c47:	e9 5a 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c4c <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $118
c0102c4e:	6a 76                	push   $0x76
  jmp __alltraps
c0102c50:	e9 51 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c55 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c55:	6a 00                	push   $0x0
  pushl $119
c0102c57:	6a 77                	push   $0x77
  jmp __alltraps
c0102c59:	e9 48 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c5e <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c5e:	6a 00                	push   $0x0
  pushl $120
c0102c60:	6a 78                	push   $0x78
  jmp __alltraps
c0102c62:	e9 3f 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c67 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c67:	6a 00                	push   $0x0
  pushl $121
c0102c69:	6a 79                	push   $0x79
  jmp __alltraps
c0102c6b:	e9 36 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c70 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $122
c0102c72:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c74:	e9 2d 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c79 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c79:	6a 00                	push   $0x0
  pushl $123
c0102c7b:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c7d:	e9 24 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c82 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c82:	6a 00                	push   $0x0
  pushl $124
c0102c84:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c86:	e9 1b 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c8b <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c8b:	6a 00                	push   $0x0
  pushl $125
c0102c8d:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c8f:	e9 12 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c94 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $126
c0102c96:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c98:	e9 09 06 00 00       	jmp    c01032a6 <__alltraps>

c0102c9d <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c9d:	6a 00                	push   $0x0
  pushl $127
c0102c9f:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102ca1:	e9 00 06 00 00       	jmp    c01032a6 <__alltraps>

c0102ca6 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102ca6:	6a 00                	push   $0x0
  pushl $128
c0102ca8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102cad:	e9 f4 05 00 00       	jmp    c01032a6 <__alltraps>

c0102cb2 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102cb2:	6a 00                	push   $0x0
  pushl $129
c0102cb4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102cb9:	e9 e8 05 00 00       	jmp    c01032a6 <__alltraps>

c0102cbe <vector130>:
.globl vector130
vector130:
  pushl $0
c0102cbe:	6a 00                	push   $0x0
  pushl $130
c0102cc0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102cc5:	e9 dc 05 00 00       	jmp    c01032a6 <__alltraps>

c0102cca <vector131>:
.globl vector131
vector131:
  pushl $0
c0102cca:	6a 00                	push   $0x0
  pushl $131
c0102ccc:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102cd1:	e9 d0 05 00 00       	jmp    c01032a6 <__alltraps>

c0102cd6 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102cd6:	6a 00                	push   $0x0
  pushl $132
c0102cd8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102cdd:	e9 c4 05 00 00       	jmp    c01032a6 <__alltraps>

c0102ce2 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102ce2:	6a 00                	push   $0x0
  pushl $133
c0102ce4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102ce9:	e9 b8 05 00 00       	jmp    c01032a6 <__alltraps>

c0102cee <vector134>:
.globl vector134
vector134:
  pushl $0
c0102cee:	6a 00                	push   $0x0
  pushl $134
c0102cf0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102cf5:	e9 ac 05 00 00       	jmp    c01032a6 <__alltraps>

c0102cfa <vector135>:
.globl vector135
vector135:
  pushl $0
c0102cfa:	6a 00                	push   $0x0
  pushl $135
c0102cfc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102d01:	e9 a0 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d06 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102d06:	6a 00                	push   $0x0
  pushl $136
c0102d08:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d0d:	e9 94 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d12 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102d12:	6a 00                	push   $0x0
  pushl $137
c0102d14:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102d19:	e9 88 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d1e <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d1e:	6a 00                	push   $0x0
  pushl $138
c0102d20:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d25:	e9 7c 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d2a <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d2a:	6a 00                	push   $0x0
  pushl $139
c0102d2c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d31:	e9 70 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d36 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d36:	6a 00                	push   $0x0
  pushl $140
c0102d38:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d3d:	e9 64 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d42 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d42:	6a 00                	push   $0x0
  pushl $141
c0102d44:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d49:	e9 58 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d4e <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d4e:	6a 00                	push   $0x0
  pushl $142
c0102d50:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d55:	e9 4c 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d5a <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d5a:	6a 00                	push   $0x0
  pushl $143
c0102d5c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d61:	e9 40 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d66 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d66:	6a 00                	push   $0x0
  pushl $144
c0102d68:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d6d:	e9 34 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d72 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d72:	6a 00                	push   $0x0
  pushl $145
c0102d74:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d79:	e9 28 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d7e <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d7e:	6a 00                	push   $0x0
  pushl $146
c0102d80:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d85:	e9 1c 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d8a <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d8a:	6a 00                	push   $0x0
  pushl $147
c0102d8c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d91:	e9 10 05 00 00       	jmp    c01032a6 <__alltraps>

c0102d96 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d96:	6a 00                	push   $0x0
  pushl $148
c0102d98:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d9d:	e9 04 05 00 00       	jmp    c01032a6 <__alltraps>

c0102da2 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102da2:	6a 00                	push   $0x0
  pushl $149
c0102da4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102da9:	e9 f8 04 00 00       	jmp    c01032a6 <__alltraps>

c0102dae <vector150>:
.globl vector150
vector150:
  pushl $0
c0102dae:	6a 00                	push   $0x0
  pushl $150
c0102db0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102db5:	e9 ec 04 00 00       	jmp    c01032a6 <__alltraps>

c0102dba <vector151>:
.globl vector151
vector151:
  pushl $0
c0102dba:	6a 00                	push   $0x0
  pushl $151
c0102dbc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102dc1:	e9 e0 04 00 00       	jmp    c01032a6 <__alltraps>

c0102dc6 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102dc6:	6a 00                	push   $0x0
  pushl $152
c0102dc8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102dcd:	e9 d4 04 00 00       	jmp    c01032a6 <__alltraps>

c0102dd2 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102dd2:	6a 00                	push   $0x0
  pushl $153
c0102dd4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102dd9:	e9 c8 04 00 00       	jmp    c01032a6 <__alltraps>

c0102dde <vector154>:
.globl vector154
vector154:
  pushl $0
c0102dde:	6a 00                	push   $0x0
  pushl $154
c0102de0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102de5:	e9 bc 04 00 00       	jmp    c01032a6 <__alltraps>

c0102dea <vector155>:
.globl vector155
vector155:
  pushl $0
c0102dea:	6a 00                	push   $0x0
  pushl $155
c0102dec:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102df1:	e9 b0 04 00 00       	jmp    c01032a6 <__alltraps>

c0102df6 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102df6:	6a 00                	push   $0x0
  pushl $156
c0102df8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102dfd:	e9 a4 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e02 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102e02:	6a 00                	push   $0x0
  pushl $157
c0102e04:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e09:	e9 98 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e0e <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e0e:	6a 00                	push   $0x0
  pushl $158
c0102e10:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102e15:	e9 8c 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e1a <vector159>:
.globl vector159
vector159:
  pushl $0
c0102e1a:	6a 00                	push   $0x0
  pushl $159
c0102e1c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e21:	e9 80 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e26 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e26:	6a 00                	push   $0x0
  pushl $160
c0102e28:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e2d:	e9 74 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e32 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e32:	6a 00                	push   $0x0
  pushl $161
c0102e34:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e39:	e9 68 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e3e <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e3e:	6a 00                	push   $0x0
  pushl $162
c0102e40:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e45:	e9 5c 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e4a <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e4a:	6a 00                	push   $0x0
  pushl $163
c0102e4c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e51:	e9 50 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e56 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e56:	6a 00                	push   $0x0
  pushl $164
c0102e58:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e5d:	e9 44 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e62 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e62:	6a 00                	push   $0x0
  pushl $165
c0102e64:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e69:	e9 38 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e6e <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e6e:	6a 00                	push   $0x0
  pushl $166
c0102e70:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e75:	e9 2c 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e7a <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e7a:	6a 00                	push   $0x0
  pushl $167
c0102e7c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e81:	e9 20 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e86 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e86:	6a 00                	push   $0x0
  pushl $168
c0102e88:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e8d:	e9 14 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e92 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e92:	6a 00                	push   $0x0
  pushl $169
c0102e94:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e99:	e9 08 04 00 00       	jmp    c01032a6 <__alltraps>

c0102e9e <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e9e:	6a 00                	push   $0x0
  pushl $170
c0102ea0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102ea5:	e9 fc 03 00 00       	jmp    c01032a6 <__alltraps>

c0102eaa <vector171>:
.globl vector171
vector171:
  pushl $0
c0102eaa:	6a 00                	push   $0x0
  pushl $171
c0102eac:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102eb1:	e9 f0 03 00 00       	jmp    c01032a6 <__alltraps>

c0102eb6 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102eb6:	6a 00                	push   $0x0
  pushl $172
c0102eb8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102ebd:	e9 e4 03 00 00       	jmp    c01032a6 <__alltraps>

c0102ec2 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102ec2:	6a 00                	push   $0x0
  pushl $173
c0102ec4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102ec9:	e9 d8 03 00 00       	jmp    c01032a6 <__alltraps>

c0102ece <vector174>:
.globl vector174
vector174:
  pushl $0
c0102ece:	6a 00                	push   $0x0
  pushl $174
c0102ed0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102ed5:	e9 cc 03 00 00       	jmp    c01032a6 <__alltraps>

c0102eda <vector175>:
.globl vector175
vector175:
  pushl $0
c0102eda:	6a 00                	push   $0x0
  pushl $175
c0102edc:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102ee1:	e9 c0 03 00 00       	jmp    c01032a6 <__alltraps>

c0102ee6 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102ee6:	6a 00                	push   $0x0
  pushl $176
c0102ee8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102eed:	e9 b4 03 00 00       	jmp    c01032a6 <__alltraps>

c0102ef2 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102ef2:	6a 00                	push   $0x0
  pushl $177
c0102ef4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102ef9:	e9 a8 03 00 00       	jmp    c01032a6 <__alltraps>

c0102efe <vector178>:
.globl vector178
vector178:
  pushl $0
c0102efe:	6a 00                	push   $0x0
  pushl $178
c0102f00:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102f05:	e9 9c 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f0a <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f0a:	6a 00                	push   $0x0
  pushl $179
c0102f0c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f11:	e9 90 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f16 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102f16:	6a 00                	push   $0x0
  pushl $180
c0102f18:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f1d:	e9 84 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f22 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f22:	6a 00                	push   $0x0
  pushl $181
c0102f24:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f29:	e9 78 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f2e <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f2e:	6a 00                	push   $0x0
  pushl $182
c0102f30:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f35:	e9 6c 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f3a <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f3a:	6a 00                	push   $0x0
  pushl $183
c0102f3c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f41:	e9 60 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f46 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f46:	6a 00                	push   $0x0
  pushl $184
c0102f48:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f4d:	e9 54 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f52 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f52:	6a 00                	push   $0x0
  pushl $185
c0102f54:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f59:	e9 48 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f5e <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f5e:	6a 00                	push   $0x0
  pushl $186
c0102f60:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f65:	e9 3c 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f6a <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f6a:	6a 00                	push   $0x0
  pushl $187
c0102f6c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f71:	e9 30 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f76 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f76:	6a 00                	push   $0x0
  pushl $188
c0102f78:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f7d:	e9 24 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f82 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f82:	6a 00                	push   $0x0
  pushl $189
c0102f84:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f89:	e9 18 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f8e <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f8e:	6a 00                	push   $0x0
  pushl $190
c0102f90:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f95:	e9 0c 03 00 00       	jmp    c01032a6 <__alltraps>

c0102f9a <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f9a:	6a 00                	push   $0x0
  pushl $191
c0102f9c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102fa1:	e9 00 03 00 00       	jmp    c01032a6 <__alltraps>

c0102fa6 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102fa6:	6a 00                	push   $0x0
  pushl $192
c0102fa8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102fad:	e9 f4 02 00 00       	jmp    c01032a6 <__alltraps>

c0102fb2 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102fb2:	6a 00                	push   $0x0
  pushl $193
c0102fb4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102fb9:	e9 e8 02 00 00       	jmp    c01032a6 <__alltraps>

c0102fbe <vector194>:
.globl vector194
vector194:
  pushl $0
c0102fbe:	6a 00                	push   $0x0
  pushl $194
c0102fc0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102fc5:	e9 dc 02 00 00       	jmp    c01032a6 <__alltraps>

c0102fca <vector195>:
.globl vector195
vector195:
  pushl $0
c0102fca:	6a 00                	push   $0x0
  pushl $195
c0102fcc:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102fd1:	e9 d0 02 00 00       	jmp    c01032a6 <__alltraps>

c0102fd6 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102fd6:	6a 00                	push   $0x0
  pushl $196
c0102fd8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102fdd:	e9 c4 02 00 00       	jmp    c01032a6 <__alltraps>

c0102fe2 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102fe2:	6a 00                	push   $0x0
  pushl $197
c0102fe4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102fe9:	e9 b8 02 00 00       	jmp    c01032a6 <__alltraps>

c0102fee <vector198>:
.globl vector198
vector198:
  pushl $0
c0102fee:	6a 00                	push   $0x0
  pushl $198
c0102ff0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102ff5:	e9 ac 02 00 00       	jmp    c01032a6 <__alltraps>

c0102ffa <vector199>:
.globl vector199
vector199:
  pushl $0
c0102ffa:	6a 00                	push   $0x0
  pushl $199
c0102ffc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0103001:	e9 a0 02 00 00       	jmp    c01032a6 <__alltraps>

c0103006 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103006:	6a 00                	push   $0x0
  pushl $200
c0103008:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010300d:	e9 94 02 00 00       	jmp    c01032a6 <__alltraps>

c0103012 <vector201>:
.globl vector201
vector201:
  pushl $0
c0103012:	6a 00                	push   $0x0
  pushl $201
c0103014:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103019:	e9 88 02 00 00       	jmp    c01032a6 <__alltraps>

c010301e <vector202>:
.globl vector202
vector202:
  pushl $0
c010301e:	6a 00                	push   $0x0
  pushl $202
c0103020:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103025:	e9 7c 02 00 00       	jmp    c01032a6 <__alltraps>

c010302a <vector203>:
.globl vector203
vector203:
  pushl $0
c010302a:	6a 00                	push   $0x0
  pushl $203
c010302c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103031:	e9 70 02 00 00       	jmp    c01032a6 <__alltraps>

c0103036 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103036:	6a 00                	push   $0x0
  pushl $204
c0103038:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010303d:	e9 64 02 00 00       	jmp    c01032a6 <__alltraps>

c0103042 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103042:	6a 00                	push   $0x0
  pushl $205
c0103044:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103049:	e9 58 02 00 00       	jmp    c01032a6 <__alltraps>

c010304e <vector206>:
.globl vector206
vector206:
  pushl $0
c010304e:	6a 00                	push   $0x0
  pushl $206
c0103050:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103055:	e9 4c 02 00 00       	jmp    c01032a6 <__alltraps>

c010305a <vector207>:
.globl vector207
vector207:
  pushl $0
c010305a:	6a 00                	push   $0x0
  pushl $207
c010305c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103061:	e9 40 02 00 00       	jmp    c01032a6 <__alltraps>

c0103066 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103066:	6a 00                	push   $0x0
  pushl $208
c0103068:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010306d:	e9 34 02 00 00       	jmp    c01032a6 <__alltraps>

c0103072 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103072:	6a 00                	push   $0x0
  pushl $209
c0103074:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103079:	e9 28 02 00 00       	jmp    c01032a6 <__alltraps>

c010307e <vector210>:
.globl vector210
vector210:
  pushl $0
c010307e:	6a 00                	push   $0x0
  pushl $210
c0103080:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103085:	e9 1c 02 00 00       	jmp    c01032a6 <__alltraps>

c010308a <vector211>:
.globl vector211
vector211:
  pushl $0
c010308a:	6a 00                	push   $0x0
  pushl $211
c010308c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103091:	e9 10 02 00 00       	jmp    c01032a6 <__alltraps>

c0103096 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103096:	6a 00                	push   $0x0
  pushl $212
c0103098:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010309d:	e9 04 02 00 00       	jmp    c01032a6 <__alltraps>

c01030a2 <vector213>:
.globl vector213
vector213:
  pushl $0
c01030a2:	6a 00                	push   $0x0
  pushl $213
c01030a4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01030a9:	e9 f8 01 00 00       	jmp    c01032a6 <__alltraps>

c01030ae <vector214>:
.globl vector214
vector214:
  pushl $0
c01030ae:	6a 00                	push   $0x0
  pushl $214
c01030b0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01030b5:	e9 ec 01 00 00       	jmp    c01032a6 <__alltraps>

c01030ba <vector215>:
.globl vector215
vector215:
  pushl $0
c01030ba:	6a 00                	push   $0x0
  pushl $215
c01030bc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030c1:	e9 e0 01 00 00       	jmp    c01032a6 <__alltraps>

c01030c6 <vector216>:
.globl vector216
vector216:
  pushl $0
c01030c6:	6a 00                	push   $0x0
  pushl $216
c01030c8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01030cd:	e9 d4 01 00 00       	jmp    c01032a6 <__alltraps>

c01030d2 <vector217>:
.globl vector217
vector217:
  pushl $0
c01030d2:	6a 00                	push   $0x0
  pushl $217
c01030d4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030d9:	e9 c8 01 00 00       	jmp    c01032a6 <__alltraps>

c01030de <vector218>:
.globl vector218
vector218:
  pushl $0
c01030de:	6a 00                	push   $0x0
  pushl $218
c01030e0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01030e5:	e9 bc 01 00 00       	jmp    c01032a6 <__alltraps>

c01030ea <vector219>:
.globl vector219
vector219:
  pushl $0
c01030ea:	6a 00                	push   $0x0
  pushl $219
c01030ec:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01030f1:	e9 b0 01 00 00       	jmp    c01032a6 <__alltraps>

c01030f6 <vector220>:
.globl vector220
vector220:
  pushl $0
c01030f6:	6a 00                	push   $0x0
  pushl $220
c01030f8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01030fd:	e9 a4 01 00 00       	jmp    c01032a6 <__alltraps>

c0103102 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103102:	6a 00                	push   $0x0
  pushl $221
c0103104:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103109:	e9 98 01 00 00       	jmp    c01032a6 <__alltraps>

c010310e <vector222>:
.globl vector222
vector222:
  pushl $0
c010310e:	6a 00                	push   $0x0
  pushl $222
c0103110:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103115:	e9 8c 01 00 00       	jmp    c01032a6 <__alltraps>

c010311a <vector223>:
.globl vector223
vector223:
  pushl $0
c010311a:	6a 00                	push   $0x0
  pushl $223
c010311c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103121:	e9 80 01 00 00       	jmp    c01032a6 <__alltraps>

c0103126 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103126:	6a 00                	push   $0x0
  pushl $224
c0103128:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010312d:	e9 74 01 00 00       	jmp    c01032a6 <__alltraps>

c0103132 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103132:	6a 00                	push   $0x0
  pushl $225
c0103134:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103139:	e9 68 01 00 00       	jmp    c01032a6 <__alltraps>

c010313e <vector226>:
.globl vector226
vector226:
  pushl $0
c010313e:	6a 00                	push   $0x0
  pushl $226
c0103140:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103145:	e9 5c 01 00 00       	jmp    c01032a6 <__alltraps>

c010314a <vector227>:
.globl vector227
vector227:
  pushl $0
c010314a:	6a 00                	push   $0x0
  pushl $227
c010314c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103151:	e9 50 01 00 00       	jmp    c01032a6 <__alltraps>

c0103156 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103156:	6a 00                	push   $0x0
  pushl $228
c0103158:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010315d:	e9 44 01 00 00       	jmp    c01032a6 <__alltraps>

c0103162 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103162:	6a 00                	push   $0x0
  pushl $229
c0103164:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103169:	e9 38 01 00 00       	jmp    c01032a6 <__alltraps>

c010316e <vector230>:
.globl vector230
vector230:
  pushl $0
c010316e:	6a 00                	push   $0x0
  pushl $230
c0103170:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103175:	e9 2c 01 00 00       	jmp    c01032a6 <__alltraps>

c010317a <vector231>:
.globl vector231
vector231:
  pushl $0
c010317a:	6a 00                	push   $0x0
  pushl $231
c010317c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103181:	e9 20 01 00 00       	jmp    c01032a6 <__alltraps>

c0103186 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103186:	6a 00                	push   $0x0
  pushl $232
c0103188:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010318d:	e9 14 01 00 00       	jmp    c01032a6 <__alltraps>

c0103192 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103192:	6a 00                	push   $0x0
  pushl $233
c0103194:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103199:	e9 08 01 00 00       	jmp    c01032a6 <__alltraps>

c010319e <vector234>:
.globl vector234
vector234:
  pushl $0
c010319e:	6a 00                	push   $0x0
  pushl $234
c01031a0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01031a5:	e9 fc 00 00 00       	jmp    c01032a6 <__alltraps>

c01031aa <vector235>:
.globl vector235
vector235:
  pushl $0
c01031aa:	6a 00                	push   $0x0
  pushl $235
c01031ac:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01031b1:	e9 f0 00 00 00       	jmp    c01032a6 <__alltraps>

c01031b6 <vector236>:
.globl vector236
vector236:
  pushl $0
c01031b6:	6a 00                	push   $0x0
  pushl $236
c01031b8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031bd:	e9 e4 00 00 00       	jmp    c01032a6 <__alltraps>

c01031c2 <vector237>:
.globl vector237
vector237:
  pushl $0
c01031c2:	6a 00                	push   $0x0
  pushl $237
c01031c4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01031c9:	e9 d8 00 00 00       	jmp    c01032a6 <__alltraps>

c01031ce <vector238>:
.globl vector238
vector238:
  pushl $0
c01031ce:	6a 00                	push   $0x0
  pushl $238
c01031d0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01031d5:	e9 cc 00 00 00       	jmp    c01032a6 <__alltraps>

c01031da <vector239>:
.globl vector239
vector239:
  pushl $0
c01031da:	6a 00                	push   $0x0
  pushl $239
c01031dc:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01031e1:	e9 c0 00 00 00       	jmp    c01032a6 <__alltraps>

c01031e6 <vector240>:
.globl vector240
vector240:
  pushl $0
c01031e6:	6a 00                	push   $0x0
  pushl $240
c01031e8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01031ed:	e9 b4 00 00 00       	jmp    c01032a6 <__alltraps>

c01031f2 <vector241>:
.globl vector241
vector241:
  pushl $0
c01031f2:	6a 00                	push   $0x0
  pushl $241
c01031f4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01031f9:	e9 a8 00 00 00       	jmp    c01032a6 <__alltraps>

c01031fe <vector242>:
.globl vector242
vector242:
  pushl $0
c01031fe:	6a 00                	push   $0x0
  pushl $242
c0103200:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103205:	e9 9c 00 00 00       	jmp    c01032a6 <__alltraps>

c010320a <vector243>:
.globl vector243
vector243:
  pushl $0
c010320a:	6a 00                	push   $0x0
  pushl $243
c010320c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103211:	e9 90 00 00 00       	jmp    c01032a6 <__alltraps>

c0103216 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103216:	6a 00                	push   $0x0
  pushl $244
c0103218:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010321d:	e9 84 00 00 00       	jmp    c01032a6 <__alltraps>

c0103222 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103222:	6a 00                	push   $0x0
  pushl $245
c0103224:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103229:	e9 78 00 00 00       	jmp    c01032a6 <__alltraps>

c010322e <vector246>:
.globl vector246
vector246:
  pushl $0
c010322e:	6a 00                	push   $0x0
  pushl $246
c0103230:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103235:	e9 6c 00 00 00       	jmp    c01032a6 <__alltraps>

c010323a <vector247>:
.globl vector247
vector247:
  pushl $0
c010323a:	6a 00                	push   $0x0
  pushl $247
c010323c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103241:	e9 60 00 00 00       	jmp    c01032a6 <__alltraps>

c0103246 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103246:	6a 00                	push   $0x0
  pushl $248
c0103248:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010324d:	e9 54 00 00 00       	jmp    c01032a6 <__alltraps>

c0103252 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103252:	6a 00                	push   $0x0
  pushl $249
c0103254:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103259:	e9 48 00 00 00       	jmp    c01032a6 <__alltraps>

c010325e <vector250>:
.globl vector250
vector250:
  pushl $0
c010325e:	6a 00                	push   $0x0
  pushl $250
c0103260:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103265:	e9 3c 00 00 00       	jmp    c01032a6 <__alltraps>

c010326a <vector251>:
.globl vector251
vector251:
  pushl $0
c010326a:	6a 00                	push   $0x0
  pushl $251
c010326c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103271:	e9 30 00 00 00       	jmp    c01032a6 <__alltraps>

c0103276 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103276:	6a 00                	push   $0x0
  pushl $252
c0103278:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010327d:	e9 24 00 00 00       	jmp    c01032a6 <__alltraps>

c0103282 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103282:	6a 00                	push   $0x0
  pushl $253
c0103284:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103289:	e9 18 00 00 00       	jmp    c01032a6 <__alltraps>

c010328e <vector254>:
.globl vector254
vector254:
  pushl $0
c010328e:	6a 00                	push   $0x0
  pushl $254
c0103290:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103295:	e9 0c 00 00 00       	jmp    c01032a6 <__alltraps>

c010329a <vector255>:
.globl vector255
vector255:
  pushl $0
c010329a:	6a 00                	push   $0x0
  pushl $255
c010329c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01032a1:	e9 00 00 00 00       	jmp    c01032a6 <__alltraps>

c01032a6 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01032a6:	1e                   	push   %ds
    pushl %es
c01032a7:	06                   	push   %es
    pushl %fs
c01032a8:	0f a0                	push   %fs
    pushl %gs
c01032aa:	0f a8                	push   %gs
    pushal
c01032ac:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01032ad:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01032b2:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01032b4:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01032b6:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01032b7:	e8 61 f5 ff ff       	call   c010281d <trap>

    # pop the pushed stack pointer
    popl %esp
c01032bc:	5c                   	pop    %esp

c01032bd <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01032bd:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01032be:	0f a9                	pop    %gs
    popl %fs
c01032c0:	0f a1                	pop    %fs
    popl %es
c01032c2:	07                   	pop    %es
    popl %ds
c01032c3:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01032c4:	83 c4 08             	add    $0x8,%esp
    iret
c01032c7:	cf                   	iret   

c01032c8 <_enclock_init_mm>:
 * (2) _enclock_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_enclock_init_mm(struct mm_struct *mm)
{     
c01032c8:	55                   	push   %ebp
c01032c9:	89 e5                	mov    %esp,%ebp
c01032cb:	83 ec 18             	sub    $0x18,%esp
c01032ce:	c7 45 f4 70 50 12 c0 	movl   $0xc0125070,-0xc(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01032db:	89 50 04             	mov    %edx,0x4(%eax)
c01032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e1:	8b 50 04             	mov    0x4(%eax),%edx
c01032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e7:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     clock_ptr = &pra_list_head;
c01032e9:	c7 05 78 50 12 c0 70 	movl   $0xc0125070,0xc0125078
c01032f0:	50 12 c0 
     assert(clock_ptr != NULL);
c01032f3:	a1 78 50 12 c0       	mov    0xc0125078,%eax
c01032f8:	85 c0                	test   %eax,%eax
c01032fa:	75 16                	jne    c0103312 <_enclock_init_mm+0x4a>
c01032fc:	68 f0 94 10 c0       	push   $0xc01094f0
c0103301:	68 02 95 10 c0       	push   $0xc0109502
c0103306:	6a 20                	push   $0x20
c0103308:	68 17 95 10 c0       	push   $0xc0109517
c010330d:	e8 de d0 ff ff       	call   c01003f0 <__panic>
     mm->sm_priv = &sm_priv_enclock;
c0103312:	8b 45 08             	mov    0x8(%ebp),%eax
c0103315:	c7 40 14 e0 19 12 c0 	movl   $0xc01219e0,0x14(%eax)
     //cprintf(" mm->sm_priv %x in enclock_init_mm\n",mm->sm_priv);
     return 0;
c010331c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103321:	c9                   	leave  
c0103322:	c3                   	ret    

c0103323 <_enclock_map_swappable>:
/*
 * (3)_enclock_map_swappable: According enclock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_enclock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0103323:	55                   	push   %ebp
c0103324:	89 e5                	mov    %esp,%ebp
c0103326:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c0103329:	8b 45 08             	mov    0x8(%ebp),%eax
c010332c:	8b 40 14             	mov    0x14(%eax),%eax
c010332f:	8b 00                	mov    (%eax),%eax
c0103331:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c0103334:	8b 45 08             	mov    0x8(%ebp),%eax
c0103337:	8b 40 14             	mov    0x14(%eax),%eax
c010333a:	8b 40 04             	mov    0x4(%eax),%eax
c010333d:	8b 00                	mov    (%eax),%eax
c010333f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in swappable\n");
    // }
    list_entry_t *entry=&(page->pra_page_link);
c0103342:	8b 45 10             	mov    0x10(%ebp),%eax
c0103345:	83 c0 14             	add    $0x14,%eax
c0103348:	89 45 e8             	mov    %eax,-0x18(%ebp)
    
    assert(entry != NULL && head != NULL);
c010334b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010334f:	74 06                	je     c0103357 <_enclock_map_swappable+0x34>
c0103351:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103355:	75 16                	jne    c010336d <_enclock_map_swappable+0x4a>
c0103357:	68 2e 95 10 c0       	push   $0xc010952e
c010335c:	68 02 95 10 c0       	push   $0xc0109502
c0103361:	6a 32                	push   $0x32
c0103363:	68 17 95 10 c0       	push   $0xc0109517
c0103368:	e8 83 d0 ff ff       	call   c01003f0 <__panic>
    //record the page access situlation
    /*LAB3 CHALLENGE: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c010336d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0103371:	75 57                	jne    c01033ca <_enclock_map_swappable+0xa7>
        list_entry_t *le_prev = head, *le;
c0103373:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103376:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c0103379:	eb 38                	jmp    c01033b3 <_enclock_map_swappable+0x90>
            if (le == entry) {
c010337b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010337e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0103381:	75 2a                	jne    c01033ad <_enclock_map_swappable+0x8a>
c0103383:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103386:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103389:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010338c:	8b 40 04             	mov    0x4(%eax),%eax
c010338f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103392:	8b 12                	mov    (%edx),%edx
c0103394:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103397:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010339a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010339d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033a0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01033a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033a9:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c01033ab:	eb 1d                	jmp    c01033ca <_enclock_map_swappable+0xa7>
            }
            le_prev = le;        
c01033ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033bc:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 CHALLENGE: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c01033bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01033c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01033c8:	75 b1                	jne    c010337b <_enclock_map_swappable+0x58>
c01033ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01033d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033d9:	8b 00                	mov    (%eax),%eax
c01033db:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01033de:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01033e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01033e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01033ea:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01033ed:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01033f0:	89 10                	mov    %edx,(%eax)
c01033f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01033f5:	8b 10                	mov    (%eax),%edx
c01033f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033fa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01033fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103400:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103403:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103406:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103409:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010340c:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c010340e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103413:	c9                   	leave  
c0103414:	c3                   	ret    

c0103415 <_enclock_swap_out_victim>:
 *  (4)_enclock_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_enclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0103415:	55                   	push   %ebp
c0103416:	89 e5                	mov    %esp,%ebp
c0103418:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c010341b:	8b 45 08             	mov    0x8(%ebp),%eax
c010341e:	8b 40 14             	mov    0x14(%eax),%eax
c0103421:	8b 00                	mov    (%eax),%eax
c0103423:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c0103426:	8b 45 08             	mov    0x8(%ebp),%eax
c0103429:	8b 40 14             	mov    0x14(%eax),%eax
c010342c:	8b 40 04             	mov    0x4(%eax),%eax
c010342f:	8b 00                	mov    (%eax),%eax
c0103431:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in victim\n");
    // }
    assert(head != NULL);
c0103434:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103438:	75 16                	jne    c0103450 <_enclock_swap_out_victim+0x3b>
c010343a:	68 4c 95 10 c0       	push   $0xc010954c
c010343f:	68 02 95 10 c0       	push   $0xc0109502
c0103444:	6a 50                	push   $0x50
c0103446:	68 17 95 10 c0       	push   $0xc0109517
c010344b:	e8 a0 cf ff ff       	call   c01003f0 <__panic>
    assert(in_tick==0);
c0103450:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103454:	74 16                	je     c010346c <_enclock_swap_out_victim+0x57>
c0103456:	68 59 95 10 c0       	push   $0xc0109559
c010345b:	68 02 95 10 c0       	push   $0xc0109502
c0103460:	6a 51                	push   $0x51
c0103462:	68 17 95 10 c0       	push   $0xc0109517
c0103467:	e8 84 cf ff ff       	call   c01003f0 <__panic>
    /* Select the victim */
    /*LAB3 CHALLENGE 2: 2015010062*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
c010346c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010346f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int cnt = 0;
c0103472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (le = list_next(le_prev)) {
c0103479:	e9 2f 01 00 00       	jmp    c01035ad <_enclock_swap_out_victim+0x198>
        assert(cnt < 3);
c010347e:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
c0103482:	7e 16                	jle    c010349a <_enclock_swap_out_victim+0x85>
c0103484:	68 64 95 10 c0       	push   $0xc0109564
c0103489:	68 02 95 10 c0       	push   $0xc0109502
c010348e:	6a 58                	push   $0x58
c0103490:	68 17 95 10 c0       	push   $0xc0109517
c0103495:	e8 56 cf ff ff       	call   c01003f0 <__panic>
        if (le == head) {
c010349a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010349d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034a0:	75 0f                	jne    c01034b1 <_enclock_swap_out_victim+0x9c>
            cnt ++;
c01034a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
            le_prev = le;
c01034a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            continue;
c01034ac:	e9 fc 00 00 00       	jmp    c01035ad <_enclock_swap_out_victim+0x198>
        }
        struct Page *page = le2page(le, pra_page_link);
c01034b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034b4:	83 e8 14             	sub    $0x14,%eax
c01034b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        pte_t* ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
c01034ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034bd:	8b 50 1c             	mov    0x1c(%eax),%edx
c01034c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01034c3:	8b 40 0c             	mov    0xc(%eax),%eax
c01034c6:	83 ec 04             	sub    $0x4,%esp
c01034c9:	6a 00                	push   $0x0
c01034cb:	52                   	push   %edx
c01034cc:	50                   	push   %eax
c01034cd:	e8 b3 3a 00 00       	call   c0106f85 <get_pte>
c01034d2:	83 c4 10             	add    $0x10,%esp
c01034d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
        _enclock_print_pte(mm);
c01034d8:	83 ec 0c             	sub    $0xc,%esp
c01034db:	ff 75 08             	pushl  0x8(%ebp)
c01034de:	e8 f2 01 00 00       	call   c01036d5 <_enclock_print_pte>
c01034e3:	83 c4 10             	add    $0x10,%esp
        // cprintf("BEFORE: va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", page->pra_vaddr, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        if (*ptep & PTE_A) {
c01034e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034e9:	8b 00                	mov    (%eax),%eax
c01034eb:	83 e0 20             	and    $0x20,%eax
c01034ee:	85 c0                	test   %eax,%eax
c01034f0:	74 2d                	je     c010351f <_enclock_swap_out_victim+0x10a>
            // set access to 0
            *ptep &= ~PTE_A;
c01034f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034f5:	8b 00                	mov    (%eax),%eax
c01034f7:	83 e0 df             	and    $0xffffffdf,%eax
c01034fa:	89 c2                	mov    %eax,%edx
c01034fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034ff:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(mm->pgdir, page->pra_vaddr);
c0103501:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103504:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103507:	8b 45 08             	mov    0x8(%ebp),%eax
c010350a:	8b 40 0c             	mov    0xc(%eax),%eax
c010350d:	83 ec 08             	sub    $0x8,%esp
c0103510:	52                   	push   %edx
c0103511:	50                   	push   %eax
c0103512:	e8 66 3d 00 00       	call   c010727d <tlb_invalidate>
c0103517:	83 c4 10             	add    $0x10,%esp
c010351a:	e9 88 00 00 00       	jmp    c01035a7 <_enclock_swap_out_victim+0x192>
        } else {
            // cprintf("now a == 0\n");
            if (*ptep & PTE_D) {
c010351f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103522:	8b 00                	mov    (%eax),%eax
c0103524:	83 e0 40             	and    $0x40,%eax
c0103527:	85 c0                	test   %eax,%eax
c0103529:	74 63                	je     c010358e <_enclock_swap_out_victim+0x179>
                if (swapfs_write((page->pra_vaddr / PGSIZE + 1) << 8, page) == 0) {
c010352b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010352e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103531:	c1 e8 0c             	shr    $0xc,%eax
c0103534:	83 c0 01             	add    $0x1,%eax
c0103537:	c1 e0 08             	shl    $0x8,%eax
c010353a:	83 ec 08             	sub    $0x8,%esp
c010353d:	ff 75 dc             	pushl  -0x24(%ebp)
c0103540:	50                   	push   %eax
c0103541:	e8 27 4b 00 00       	call   c010806d <swapfs_write>
c0103546:	83 c4 10             	add    $0x10,%esp
c0103549:	85 c0                	test   %eax,%eax
c010354b:	75 17                	jne    c0103564 <_enclock_swap_out_victim+0x14f>
                    cprintf("write 0x%x to disk\n", page->pra_vaddr);
c010354d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103550:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103553:	83 ec 08             	sub    $0x8,%esp
c0103556:	50                   	push   %eax
c0103557:	68 6c 95 10 c0       	push   $0xc010956c
c010355c:	e8 29 cd ff ff       	call   c010028a <cprintf>
c0103561:	83 c4 10             	add    $0x10,%esp
                }
                // set dirty to 0
                *ptep = *ptep & ~PTE_D;
c0103564:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103567:	8b 00                	mov    (%eax),%eax
c0103569:	83 e0 bf             	and    $0xffffffbf,%eax
c010356c:	89 c2                	mov    %eax,%edx
c010356e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103571:	89 10                	mov    %edx,(%eax)
                tlb_invalidate(mm->pgdir, page->pra_vaddr);
c0103573:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103576:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103579:	8b 45 08             	mov    0x8(%ebp),%eax
c010357c:	8b 40 0c             	mov    0xc(%eax),%eax
c010357f:	83 ec 08             	sub    $0x8,%esp
c0103582:	52                   	push   %edx
c0103583:	50                   	push   %eax
c0103584:	e8 f4 3c 00 00       	call   c010727d <tlb_invalidate>
c0103589:	83 c4 10             	add    $0x10,%esp
c010358c:	eb 19                	jmp    c01035a7 <_enclock_swap_out_victim+0x192>
            } else {
                // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
                cprintf("victim is 0x%x\n", page->pra_vaddr);
c010358e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103591:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103594:	83 ec 08             	sub    $0x8,%esp
c0103597:	50                   	push   %eax
c0103598:	68 80 95 10 c0       	push   $0xc0109580
c010359d:	e8 e8 cc ff ff       	call   c010028a <cprintf>
c01035a2:	83 c4 10             	add    $0x10,%esp
                break;
c01035a5:	eb 1f                	jmp    c01035c6 <_enclock_swap_out_victim+0x1b1>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
c01035a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01035b6:	8b 40 04             	mov    0x4(%eax),%eax
    /* Select the victim */
    /*LAB3 CHALLENGE 2: 2015010062*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
    int cnt = 0;
    while (le = list_next(le_prev)) {
c01035b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01035c0:	0f 85 b8 fe ff ff    	jne    c010347e <_enclock_swap_out_victim+0x69>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
    }
    assert(le != head);
c01035c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01035cc:	75 16                	jne    c01035e4 <_enclock_swap_out_victim+0x1cf>
c01035ce:	68 90 95 10 c0       	push   $0xc0109590
c01035d3:	68 02 95 10 c0       	push   $0xc0109502
c01035d8:	6a 78                	push   $0x78
c01035da:	68 17 95 10 c0       	push   $0xc0109517
c01035df:	e8 0c ce ff ff       	call   c01003f0 <__panic>
c01035e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ed:	8b 40 04             	mov    0x4(%eax),%eax
c01035f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01035f3:	8b 12                	mov    (%edx),%edx
c01035f5:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01035f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035fe:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103601:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103604:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103607:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010360a:	89 10                	mov    %edx,(%eax)
    list_del(le);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(le, pra_page_link);
c010360c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010360f:	83 e8 14             	sub    $0x14,%eax
c0103612:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    assert(page != NULL);
c0103615:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103619:	75 16                	jne    c0103631 <_enclock_swap_out_victim+0x21c>
c010361b:	68 9b 95 10 c0       	push   $0xc010959b
c0103620:	68 02 95 10 c0       	push   $0xc0109502
c0103625:	6a 7c                	push   $0x7c
c0103627:	68 17 95 10 c0       	push   $0xc0109517
c010362c:	e8 bf cd ff ff       	call   c01003f0 <__panic>
    *ptr_page = page;
c0103631:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103634:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103637:	89 10                	mov    %edx,(%eax)
    //(2)update clock
    *(((struct enclock_struct*) mm->sm_priv)->clock) = le_prev;
c0103639:	8b 45 08             	mov    0x8(%ebp),%eax
c010363c:	8b 40 14             	mov    0x14(%eax),%eax
c010363f:	8b 40 04             	mov    0x4(%eax),%eax
c0103642:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103645:	89 10                	mov    %edx,(%eax)
    return 0;
c0103647:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010364c:	c9                   	leave  
c010364d:	c3                   	ret    

c010364e <_enclock_reset_pte>:

void
_enclock_reset_pte(pde_t* pgdir) {
c010364e:	55                   	push   %ebp
c010364f:	89 e5                	mov    %esp,%ebp
c0103651:	83 ec 18             	sub    $0x18,%esp
    cprintf("PTEs resetting...\n");
c0103654:	83 ec 0c             	sub    $0xc,%esp
c0103657:	68 a8 95 10 c0       	push   $0xc01095a8
c010365c:	e8 29 cc ff ff       	call   c010028a <cprintf>
c0103661:	83 c4 10             	add    $0x10,%esp
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c0103664:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
c010366b:	eb 4c                	jmp    c01036b9 <_enclock_reset_pte+0x6b>
        pte_t* ptep = get_pte(pgdir, va, 0);
c010366d:	83 ec 04             	sub    $0x4,%esp
c0103670:	6a 00                	push   $0x0
c0103672:	ff 75 f4             	pushl  -0xc(%ebp)
c0103675:	ff 75 08             	pushl  0x8(%ebp)
c0103678:	e8 08 39 00 00       	call   c0106f85 <get_pte>
c010367d:	83 c4 10             	add    $0x10,%esp
c0103680:	89 45 f0             	mov    %eax,-0x10(%ebp)
        *ptep = *ptep & ~PTE_A;
c0103683:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103686:	8b 00                	mov    (%eax),%eax
c0103688:	83 e0 df             	and    $0xffffffdf,%eax
c010368b:	89 c2                	mov    %eax,%edx
c010368d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103690:	89 10                	mov    %edx,(%eax)
        *ptep = *ptep & ~PTE_D;
c0103692:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103695:	8b 00                	mov    (%eax),%eax
c0103697:	83 e0 bf             	and    $0xffffffbf,%eax
c010369a:	89 c2                	mov    %eax,%edx
c010369c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010369f:	89 10                	mov    %edx,(%eax)
        tlb_invalidate(pgdir, va);
c01036a1:	83 ec 08             	sub    $0x8,%esp
c01036a4:	ff 75 f4             	pushl  -0xc(%ebp)
c01036a7:	ff 75 08             	pushl  0x8(%ebp)
c01036aa:	e8 ce 3b 00 00       	call   c010727d <tlb_invalidate>
c01036af:	83 c4 10             	add    $0x10,%esp
}

void
_enclock_reset_pte(pde_t* pgdir) {
    cprintf("PTEs resetting...\n");
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c01036b2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01036b9:	81 7d f4 00 40 00 00 	cmpl   $0x4000,-0xc(%ebp)
c01036c0:	76 ab                	jbe    c010366d <_enclock_reset_pte+0x1f>
        pte_t* ptep = get_pte(pgdir, va, 0);
        *ptep = *ptep & ~PTE_A;
        *ptep = *ptep & ~PTE_D;
        tlb_invalidate(pgdir, va);
    }
    cprintf("PTEs reseted!\n");
c01036c2:	83 ec 0c             	sub    $0xc,%esp
c01036c5:	68 bb 95 10 c0       	push   $0xc01095bb
c01036ca:	e8 bb cb ff ff       	call   c010028a <cprintf>
c01036cf:	83 c4 10             	add    $0x10,%esp
}
c01036d2:	90                   	nop
c01036d3:	c9                   	leave  
c01036d4:	c3                   	ret    

c01036d5 <_enclock_print_pte>:

void
_enclock_print_pte(struct mm_struct *mm) {
c01036d5:	55                   	push   %ebp
c01036d6:	89 e5                	mov    %esp,%ebp
c01036d8:	83 ec 18             	sub    $0x18,%esp
    cprintf("-------------------------\n");
c01036db:	83 ec 0c             	sub    $0xc,%esp
c01036de:	68 ca 95 10 c0       	push   $0xc01095ca
c01036e3:	e8 a2 cb ff ff       	call   c010028a <cprintf>
c01036e8:	83 c4 10             	add    $0x10,%esp
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c01036eb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
c01036f2:	eb 50                	jmp    c0103744 <_enclock_print_pte+0x6f>
        pte_t* ptep = get_pte(mm->pgdir, va, 0);
c01036f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f7:	8b 40 0c             	mov    0xc(%eax),%eax
c01036fa:	83 ec 04             	sub    $0x4,%esp
c01036fd:	6a 00                	push   $0x0
c01036ff:	ff 75 f4             	pushl  -0xc(%ebp)
c0103702:	50                   	push   %eax
c0103703:	e8 7d 38 00 00       	call   c0106f85 <get_pte>
c0103708:	83 c4 10             	add    $0x10,%esp
c010370b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        cprintf("va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", va, *ptep, *ptep & PTE_A, *ptep & PTE_D);
c010370e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103711:	8b 00                	mov    (%eax),%eax
c0103713:	83 e0 40             	and    $0x40,%eax
c0103716:	89 c1                	mov    %eax,%ecx
c0103718:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010371b:	8b 00                	mov    (%eax),%eax
c010371d:	83 e0 20             	and    $0x20,%eax
c0103720:	89 c2                	mov    %eax,%edx
c0103722:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103725:	8b 00                	mov    (%eax),%eax
c0103727:	83 ec 0c             	sub    $0xc,%esp
c010372a:	51                   	push   %ecx
c010372b:	52                   	push   %edx
c010372c:	50                   	push   %eax
c010372d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103730:	68 e8 95 10 c0       	push   $0xc01095e8
c0103735:	e8 50 cb ff ff       	call   c010028a <cprintf>
c010373a:	83 c4 20             	add    $0x20,%esp
}

void
_enclock_print_pte(struct mm_struct *mm) {
    cprintf("-------------------------\n");
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c010373d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103744:	81 7d f4 00 40 00 00 	cmpl   $0x4000,-0xc(%ebp)
c010374b:	76 a7                	jbe    c01036f4 <_enclock_print_pte+0x1f>
        pte_t* ptep = get_pte(mm->pgdir, va, 0);
        cprintf("va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", va, *ptep, *ptep & PTE_A, *ptep & PTE_D);
    }
    cprintf("-------------------------\n");
c010374d:	83 ec 0c             	sub    $0xc,%esp
c0103750:	68 ca 95 10 c0       	push   $0xc01095ca
c0103755:	e8 30 cb ff ff       	call   c010028a <cprintf>
c010375a:	83 c4 10             	add    $0x10,%esp
}
c010375d:	90                   	nop
c010375e:	c9                   	leave  
c010375f:	c3                   	ret    

c0103760 <_enclock_check_swap>:

static int
_enclock_check_swap(void) {
c0103760:	55                   	push   %ebp
c0103761:	89 e5                	mov    %esp,%ebp
c0103763:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103766:	0f 20 d8             	mov    %cr3,%eax
c0103769:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return cr3;
c010376c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    _enclock_reset_pte(KADDR(((pde_t *)rcr3())));
c010376f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103772:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103775:	c1 e8 0c             	shr    $0xc,%eax
c0103778:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010377b:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0103780:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103783:	72 17                	jb     c010379c <_enclock_check_swap+0x3c>
c0103785:	ff 75 f4             	pushl  -0xc(%ebp)
c0103788:	68 10 96 10 c0       	push   $0xc0109610
c010378d:	68 9b 00 00 00       	push   $0x9b
c0103792:	68 17 95 10 c0       	push   $0xc0109517
c0103797:	e8 54 cc ff ff       	call   c01003f0 <__panic>
c010379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010379f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037a4:	83 ec 0c             	sub    $0xc,%esp
c01037a7:	50                   	push   %eax
c01037a8:	e8 a1 fe ff ff       	call   c010364e <_enclock_reset_pte>
c01037ad:	83 c4 10             	add    $0x10,%esp
    cprintf("read Virt Page c in enclock_check_swap\n");
c01037b0:	83 ec 0c             	sub    $0xc,%esp
c01037b3:	68 34 96 10 c0       	push   $0xc0109634
c01037b8:	e8 cd ca ff ff       	call   c010028a <cprintf>
c01037bd:	83 c4 10             	add    $0x10,%esp
    unsigned char tmp = *(unsigned char *)0x3000;
c01037c0:	b8 00 30 00 00       	mov    $0x3000,%eax
c01037c5:	0f b6 00             	movzbl (%eax),%eax
c01037c8:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c01037cb:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01037d0:	83 f8 04             	cmp    $0x4,%eax
c01037d3:	74 19                	je     c01037ee <_enclock_check_swap+0x8e>
c01037d5:	68 5c 96 10 c0       	push   $0xc010965c
c01037da:	68 02 95 10 c0       	push   $0xc0109502
c01037df:	68 9e 00 00 00       	push   $0x9e
c01037e4:	68 17 95 10 c0       	push   $0xc0109517
c01037e9:	e8 02 cc ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c01037ee:	83 ec 0c             	sub    $0xc,%esp
c01037f1:	68 6c 96 10 c0       	push   $0xc010966c
c01037f6:	e8 8f ca ff ff       	call   c010028a <cprintf>
c01037fb:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01037fe:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103803:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0103806:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010380b:	83 f8 04             	cmp    $0x4,%eax
c010380e:	74 19                	je     c0103829 <_enclock_check_swap+0xc9>
c0103810:	68 5c 96 10 c0       	push   $0xc010965c
c0103815:	68 02 95 10 c0       	push   $0xc0109502
c010381a:	68 a1 00 00 00       	push   $0xa1
c010381f:	68 17 95 10 c0       	push   $0xc0109517
c0103824:	e8 c7 cb ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c0103829:	83 ec 0c             	sub    $0xc,%esp
c010382c:	68 98 96 10 c0       	push   $0xc0109698
c0103831:	e8 54 ca ff ff       	call   c010028a <cprintf>
c0103836:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c0103839:	b8 00 40 00 00       	mov    $0x4000,%eax
c010383e:	0f b6 00             	movzbl (%eax),%eax
c0103841:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c0103844:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103849:	83 f8 04             	cmp    $0x4,%eax
c010384c:	74 19                	je     c0103867 <_enclock_check_swap+0x107>
c010384e:	68 5c 96 10 c0       	push   $0xc010965c
c0103853:	68 02 95 10 c0       	push   $0xc0109502
c0103858:	68 a4 00 00 00       	push   $0xa4
c010385d:	68 17 95 10 c0       	push   $0xc0109517
c0103862:	e8 89 cb ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in enclock_check_swap\n");
c0103867:	83 ec 0c             	sub    $0xc,%esp
c010386a:	68 c0 96 10 c0       	push   $0xc01096c0
c010386f:	e8 16 ca ff ff       	call   c010028a <cprintf>
c0103874:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0103877:	b8 00 20 00 00       	mov    $0x2000,%eax
c010387c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010387f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103884:	83 f8 04             	cmp    $0x4,%eax
c0103887:	74 19                	je     c01038a2 <_enclock_check_swap+0x142>
c0103889:	68 5c 96 10 c0       	push   $0xc010965c
c010388e:	68 02 95 10 c0       	push   $0xc0109502
c0103893:	68 a7 00 00 00       	push   $0xa7
c0103898:	68 17 95 10 c0       	push   $0xc0109517
c010389d:	e8 4e cb ff ff       	call   c01003f0 <__panic>

    cprintf("write Virt Page e in enclock_check_swap\n");
c01038a2:	83 ec 0c             	sub    $0xc,%esp
c01038a5:	68 ec 96 10 c0       	push   $0xc01096ec
c01038aa:	e8 db c9 ff ff       	call   c010028a <cprintf>
c01038af:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c01038b2:	b8 00 50 00 00       	mov    $0x5000,%eax
c01038b7:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01038ba:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01038bf:	83 f8 05             	cmp    $0x5,%eax
c01038c2:	74 19                	je     c01038dd <_enclock_check_swap+0x17d>
c01038c4:	68 15 97 10 c0       	push   $0xc0109715
c01038c9:	68 02 95 10 c0       	push   $0xc0109502
c01038ce:	68 ab 00 00 00       	push   $0xab
c01038d3:	68 17 95 10 c0       	push   $0xc0109517
c01038d8:	e8 13 cb ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c01038dd:	83 ec 0c             	sub    $0xc,%esp
c01038e0:	68 24 97 10 c0       	push   $0xc0109724
c01038e5:	e8 a0 c9 ff ff       	call   c010028a <cprintf>
c01038ea:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c01038ed:	b8 00 20 00 00       	mov    $0x2000,%eax
c01038f2:	0f b6 00             	movzbl (%eax),%eax
c01038f5:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c01038f8:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01038fd:	83 f8 05             	cmp    $0x5,%eax
c0103900:	74 19                	je     c010391b <_enclock_check_swap+0x1bb>
c0103902:	68 15 97 10 c0       	push   $0xc0109715
c0103907:	68 02 95 10 c0       	push   $0xc0109502
c010390c:	68 ae 00 00 00       	push   $0xae
c0103911:	68 17 95 10 c0       	push   $0xc0109517
c0103916:	e8 d5 ca ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c010391b:	83 ec 0c             	sub    $0xc,%esp
c010391e:	68 6c 96 10 c0       	push   $0xc010966c
c0103923:	e8 62 c9 ff ff       	call   c010028a <cprintf>
c0103928:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c010392b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103930:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==5);
c0103933:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103938:	83 f8 05             	cmp    $0x5,%eax
c010393b:	74 19                	je     c0103956 <_enclock_check_swap+0x1f6>
c010393d:	68 15 97 10 c0       	push   $0xc0109715
c0103942:	68 02 95 10 c0       	push   $0xc0109502
c0103947:	68 b1 00 00 00       	push   $0xb1
c010394c:	68 17 95 10 c0       	push   $0xc0109517
c0103951:	e8 9a ca ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c0103956:	83 ec 0c             	sub    $0xc,%esp
c0103959:	68 24 97 10 c0       	push   $0xc0109724
c010395e:	e8 27 c9 ff ff       	call   c010028a <cprintf>
c0103963:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c0103966:	b8 00 20 00 00       	mov    $0x2000,%eax
c010396b:	0f b6 00             	movzbl (%eax),%eax
c010396e:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c0103971:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103976:	83 f8 05             	cmp    $0x5,%eax
c0103979:	74 19                	je     c0103994 <_enclock_check_swap+0x234>
c010397b:	68 15 97 10 c0       	push   $0xc0109715
c0103980:	68 02 95 10 c0       	push   $0xc0109502
c0103985:	68 b4 00 00 00       	push   $0xb4
c010398a:	68 17 95 10 c0       	push   $0xc0109517
c010398f:	e8 5c ca ff ff       	call   c01003f0 <__panic>

    cprintf("read Virt Page c in enclock_check_swap\n");
c0103994:	83 ec 0c             	sub    $0xc,%esp
c0103997:	68 34 96 10 c0       	push   $0xc0109634
c010399c:	e8 e9 c8 ff ff       	call   c010028a <cprintf>
c01039a1:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x3000;
c01039a4:	b8 00 30 00 00       	mov    $0x3000,%eax
c01039a9:	0f b6 00             	movzbl (%eax),%eax
c01039ac:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==6);
c01039af:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01039b4:	83 f8 06             	cmp    $0x6,%eax
c01039b7:	74 19                	je     c01039d2 <_enclock_check_swap+0x272>
c01039b9:	68 4c 97 10 c0       	push   $0xc010974c
c01039be:	68 02 95 10 c0       	push   $0xc0109502
c01039c3:	68 b8 00 00 00       	push   $0xb8
c01039c8:	68 17 95 10 c0       	push   $0xc0109517
c01039cd:	e8 1e ca ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c01039d2:	83 ec 0c             	sub    $0xc,%esp
c01039d5:	68 98 96 10 c0       	push   $0xc0109698
c01039da:	e8 ab c8 ff ff       	call   c010028a <cprintf>
c01039df:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c01039e2:	b8 00 40 00 00       	mov    $0x4000,%eax
c01039e7:	0f b6 00             	movzbl (%eax),%eax
c01039ea:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==7);
c01039ed:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01039f2:	83 f8 07             	cmp    $0x7,%eax
c01039f5:	74 19                	je     c0103a10 <_enclock_check_swap+0x2b0>
c01039f7:	68 5b 97 10 c0       	push   $0xc010975b
c01039fc:	68 02 95 10 c0       	push   $0xc0109502
c0103a01:	68 bb 00 00 00       	push   $0xbb
c0103a06:	68 17 95 10 c0       	push   $0xc0109517
c0103a0b:	e8 e0 c9 ff ff       	call   c01003f0 <__panic>
    return 0;
c0103a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a15:	c9                   	leave  
c0103a16:	c3                   	ret    

c0103a17 <_enclock_init>:


static int
_enclock_init(void)
{
c0103a17:	55                   	push   %ebp
c0103a18:	89 e5                	mov    %esp,%ebp
    return 0;
c0103a1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a1f:	5d                   	pop    %ebp
c0103a20:	c3                   	ret    

c0103a21 <_enclock_set_unswappable>:

static int
_enclock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0103a21:	55                   	push   %ebp
c0103a22:	89 e5                	mov    %esp,%ebp
    return 0;
c0103a24:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a29:	5d                   	pop    %ebp
c0103a2a:	c3                   	ret    

c0103a2b <_enclock_tick_event>:

static int
_enclock_tick_event(struct mm_struct *mm)
{ return 0; }
c0103a2b:	55                   	push   %ebp
c0103a2c:	89 e5                	mov    %esp,%ebp
c0103a2e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103a33:	5d                   	pop    %ebp
c0103a34:	c3                   	ret    

c0103a35 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a35:	55                   	push   %ebp
c0103a36:	89 e5                	mov    %esp,%ebp
c0103a38:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0103a3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3e:	c1 e8 0c             	shr    $0xc,%eax
c0103a41:	89 c2                	mov    %eax,%edx
c0103a43:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0103a48:	39 c2                	cmp    %eax,%edx
c0103a4a:	72 14                	jb     c0103a60 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0103a4c:	83 ec 04             	sub    $0x4,%esp
c0103a4f:	68 80 97 10 c0       	push   $0xc0109780
c0103a54:	6a 5b                	push   $0x5b
c0103a56:	68 9f 97 10 c0       	push   $0xc010979f
c0103a5b:	e8 90 c9 ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0103a60:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0103a65:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a68:	c1 ea 0c             	shr    $0xc,%edx
c0103a6b:	c1 e2 05             	shl    $0x5,%edx
c0103a6e:	01 d0                	add    %edx,%eax
}
c0103a70:	c9                   	leave  
c0103a71:	c3                   	ret    

c0103a72 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0103a72:	55                   	push   %ebp
c0103a73:	89 e5                	mov    %esp,%ebp
c0103a75:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0103a78:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a80:	83 ec 0c             	sub    $0xc,%esp
c0103a83:	50                   	push   %eax
c0103a84:	e8 ac ff ff ff       	call   c0103a35 <pa2page>
c0103a89:	83 c4 10             	add    $0x10,%esp
}
c0103a8c:	c9                   	leave  
c0103a8d:	c3                   	ret    

c0103a8e <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0103a8e:	55                   	push   %ebp
c0103a8f:	89 e5                	mov    %esp,%ebp
c0103a91:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0103a94:	83 ec 0c             	sub    $0xc,%esp
c0103a97:	6a 18                	push   $0x18
c0103a99:	e8 af 43 00 00       	call   c0107e4d <kmalloc>
c0103a9e:	83 c4 10             	add    $0x10,%esp
c0103aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0103aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103aa8:	74 5b                	je     c0103b05 <mm_create+0x77>
        list_init(&(mm->mmap_list));
c0103aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103ab6:	89 50 04             	mov    %edx,0x4(%eax)
c0103ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103abc:	8b 50 04             	mov    0x4(%eax),%edx
c0103abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ac2:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0103ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ac7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0103ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103adb:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0103ae2:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0103ae7:	85 c0                	test   %eax,%eax
c0103ae9:	74 10                	je     c0103afb <mm_create+0x6d>
c0103aeb:	83 ec 0c             	sub    $0xc,%esp
c0103aee:	ff 75 f4             	pushl  -0xc(%ebp)
c0103af1:	e8 77 11 00 00       	call   c0104c6d <swap_init_mm>
c0103af6:	83 c4 10             	add    $0x10,%esp
c0103af9:	eb 0a                	jmp    c0103b05 <mm_create+0x77>
        else mm->sm_priv = NULL;
c0103afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103afe:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0103b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103b08:	c9                   	leave  
c0103b09:	c3                   	ret    

c0103b0a <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0103b0a:	55                   	push   %ebp
c0103b0b:	89 e5                	mov    %esp,%ebp
c0103b0d:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103b10:	83 ec 0c             	sub    $0xc,%esp
c0103b13:	6a 18                	push   $0x18
c0103b15:	e8 33 43 00 00       	call   c0107e4d <kmalloc>
c0103b1a:	83 c4 10             	add    $0x10,%esp
c0103b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0103b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b24:	74 1b                	je     c0103b41 <vma_create+0x37>
        vma->vm_start = vm_start;
c0103b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b29:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b2c:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0103b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b32:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b35:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0103b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b3b:	8b 55 10             	mov    0x10(%ebp),%edx
c0103b3e:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0103b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103b44:	c9                   	leave  
c0103b45:	c3                   	ret    

c0103b46 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0103b46:	55                   	push   %ebp
c0103b47:	89 e5                	mov    %esp,%ebp
c0103b49:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0103b4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0103b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b57:	0f 84 95 00 00 00    	je     c0103bf2 <find_vma+0xac>
        vma = mm->mmap_cache;
c0103b5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b60:	8b 40 08             	mov    0x8(%eax),%eax
c0103b63:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0103b66:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103b6a:	74 16                	je     c0103b82 <find_vma+0x3c>
c0103b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b6f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b72:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b75:	77 0b                	ja     c0103b82 <find_vma+0x3c>
c0103b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b7a:	8b 40 08             	mov    0x8(%eax),%eax
c0103b7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b80:	77 61                	ja     c0103be3 <find_vma+0x9d>
                bool found = 0;
c0103b82:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0103b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103b95:	eb 28                	jmp    c0103bbf <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0103b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b9a:	83 e8 10             	sub    $0x10,%eax
c0103b9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ba3:	8b 40 04             	mov    0x4(%eax),%eax
c0103ba6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ba9:	77 14                	ja     c0103bbf <find_vma+0x79>
c0103bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103bae:	8b 40 08             	mov    0x8(%eax),%eax
c0103bb1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103bb4:	76 09                	jbe    c0103bbf <find_vma+0x79>
                        found = 1;
c0103bb6:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103bbd:	eb 17                	jmp    c0103bd6 <find_vma+0x90>
c0103bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bc8:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0103bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bd1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103bd4:	75 c1                	jne    c0103b97 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0103bd6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103bda:	75 07                	jne    c0103be3 <find_vma+0x9d>
                    vma = NULL;
c0103bdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103be3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103be7:	74 09                	je     c0103bf2 <find_vma+0xac>
            mm->mmap_cache = vma;
c0103be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bec:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103bef:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103bf5:	c9                   	leave  
c0103bf6:	c3                   	ret    

c0103bf7 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0103bf7:	55                   	push   %ebp
c0103bf8:	89 e5                	mov    %esp,%ebp
c0103bfa:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
c0103bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c00:	8b 50 04             	mov    0x4(%eax),%edx
c0103c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c06:	8b 40 08             	mov    0x8(%eax),%eax
c0103c09:	39 c2                	cmp    %eax,%edx
c0103c0b:	72 16                	jb     c0103c23 <check_vma_overlap+0x2c>
c0103c0d:	68 ad 97 10 c0       	push   $0xc01097ad
c0103c12:	68 cb 97 10 c0       	push   $0xc01097cb
c0103c17:	6a 67                	push   $0x67
c0103c19:	68 e0 97 10 c0       	push   $0xc01097e0
c0103c1e:	e8 cd c7 ff ff       	call   c01003f0 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c26:	8b 50 08             	mov    0x8(%eax),%edx
c0103c29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c2c:	8b 40 04             	mov    0x4(%eax),%eax
c0103c2f:	39 c2                	cmp    %eax,%edx
c0103c31:	76 16                	jbe    c0103c49 <check_vma_overlap+0x52>
c0103c33:	68 f0 97 10 c0       	push   $0xc01097f0
c0103c38:	68 cb 97 10 c0       	push   $0xc01097cb
c0103c3d:	6a 68                	push   $0x68
c0103c3f:	68 e0 97 10 c0       	push   $0xc01097e0
c0103c44:	e8 a7 c7 ff ff       	call   c01003f0 <__panic>
    assert(next->vm_start < next->vm_end);
c0103c49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c4c:	8b 50 04             	mov    0x4(%eax),%edx
c0103c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c52:	8b 40 08             	mov    0x8(%eax),%eax
c0103c55:	39 c2                	cmp    %eax,%edx
c0103c57:	72 16                	jb     c0103c6f <check_vma_overlap+0x78>
c0103c59:	68 0f 98 10 c0       	push   $0xc010980f
c0103c5e:	68 cb 97 10 c0       	push   $0xc01097cb
c0103c63:	6a 69                	push   $0x69
c0103c65:	68 e0 97 10 c0       	push   $0xc01097e0
c0103c6a:	e8 81 c7 ff ff       	call   c01003f0 <__panic>
}
c0103c6f:	90                   	nop
c0103c70:	c9                   	leave  
c0103c71:	c3                   	ret    

c0103c72 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103c72:	55                   	push   %ebp
c0103c73:	89 e5                	mov    %esp,%ebp
c0103c75:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
c0103c78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c7b:	8b 50 04             	mov    0x4(%eax),%edx
c0103c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c81:	8b 40 08             	mov    0x8(%eax),%eax
c0103c84:	39 c2                	cmp    %eax,%edx
c0103c86:	72 16                	jb     c0103c9e <insert_vma_struct+0x2c>
c0103c88:	68 2d 98 10 c0       	push   $0xc010982d
c0103c8d:	68 cb 97 10 c0       	push   $0xc01097cb
c0103c92:	6a 70                	push   $0x70
c0103c94:	68 e0 97 10 c0       	push   $0xc01097e0
c0103c99:	e8 52 c7 ff ff       	call   c01003f0 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ca1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)

    list_entry_t *le = list;
c0103caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((le = list_next(le)) != list) {
c0103cb0:	eb 1f                	jmp    c0103cd1 <insert_vma_struct+0x5f>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb5:	83 e8 10             	sub    $0x10,%eax
c0103cb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (mmap_prev->vm_start > vma->vm_start) {
c0103cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cbe:	8b 50 04             	mov    0x4(%eax),%edx
c0103cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103cc4:	8b 40 04             	mov    0x4(%eax),%eax
c0103cc7:	39 c2                	cmp    %eax,%edx
c0103cc9:	77 1f                	ja     c0103cea <insert_vma_struct+0x78>
            break;
        }
        le_prev = le;
c0103ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103cd7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cda:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

    list_entry_t *le = list;
    while ((le = list_next(le)) != list) {
c0103cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ce3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103ce6:	75 ca                	jne    c0103cb2 <insert_vma_struct+0x40>
c0103ce8:	eb 01                	jmp    c0103ceb <insert_vma_struct+0x79>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start) {
            break;
c0103cea:	90                   	nop
c0103ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cee:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cf4:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le_prev = le;
    }

    le_next = list_next(le_prev);
c0103cf7:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0103cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cfd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d00:	74 15                	je     c0103d17 <insert_vma_struct+0xa5>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d05:	83 e8 10             	sub    $0x10,%eax
c0103d08:	83 ec 08             	sub    $0x8,%esp
c0103d0b:	ff 75 0c             	pushl  0xc(%ebp)
c0103d0e:	50                   	push   %eax
c0103d0f:	e8 e3 fe ff ff       	call   c0103bf7 <check_vma_overlap>
c0103d14:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
c0103d17:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d1d:	74 15                	je     c0103d34 <insert_vma_struct+0xc2>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103d1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d22:	83 e8 10             	sub    $0x10,%eax
c0103d25:	83 ec 08             	sub    $0x8,%esp
c0103d28:	50                   	push   %eax
c0103d29:	ff 75 0c             	pushl  0xc(%ebp)
c0103d2c:	e8 c6 fe ff ff       	call   c0103bf7 <check_vma_overlap>
c0103d31:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
c0103d34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d37:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d3a:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d3f:	8d 50 10             	lea    0x10(%eax),%edx
c0103d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d45:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d48:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d4e:	8b 40 04             	mov    0x4(%eax),%eax
c0103d51:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d54:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103d57:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103d5a:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103d5d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103d60:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d63:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d66:	89 10                	mov    %edx,(%eax)
c0103d68:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d6b:	8b 10                	mov    (%eax),%edx
c0103d6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d70:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103d73:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d76:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103d79:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103d7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d7f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103d82:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d87:	8b 40 10             	mov    0x10(%eax),%eax
c0103d8a:	8d 50 01             	lea    0x1(%eax),%edx
c0103d8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d90:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103d93:	90                   	nop
c0103d94:	c9                   	leave  
c0103d95:	c3                   	ret    

c0103d96 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0103d96:	55                   	push   %ebp
c0103d97:	89 e5                	mov    %esp,%ebp
c0103d99:	83 ec 28             	sub    $0x28,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103da2:	eb 3c                	jmp    c0103de0 <mm_destroy+0x4a>
c0103da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dad:	8b 40 04             	mov    0x4(%eax),%eax
c0103db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103db3:	8b 12                	mov    (%edx),%edx
c0103db5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0103db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103dc1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103dc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103dca:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0103dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dcf:	83 e8 10             	sub    $0x10,%eax
c0103dd2:	83 ec 08             	sub    $0x8,%esp
c0103dd5:	6a 18                	push   $0x18
c0103dd7:	50                   	push   %eax
c0103dd8:	e8 01 41 00 00       	call   c0107ede <kfree>
c0103ddd:	83 c4 10             	add    $0x10,%esp
c0103de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103de9:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0103dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103def:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103df2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103df5:	75 ad                	jne    c0103da4 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0103df7:	83 ec 08             	sub    $0x8,%esp
c0103dfa:	6a 18                	push   $0x18
c0103dfc:	ff 75 08             	pushl  0x8(%ebp)
c0103dff:	e8 da 40 00 00       	call   c0107ede <kfree>
c0103e04:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
c0103e07:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0103e0e:	90                   	nop
c0103e0f:	c9                   	leave  
c0103e10:	c3                   	ret    

c0103e11 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0103e11:	55                   	push   %ebp
c0103e12:	89 e5                	mov    %esp,%ebp
c0103e14:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103e17:	e8 03 00 00 00       	call   c0103e1f <check_vmm>
}
c0103e1c:	90                   	nop
c0103e1d:	c9                   	leave  
c0103e1e:	c3                   	ret    

c0103e1f <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0103e1f:	55                   	push   %ebp
c0103e20:	89 e5                	mov    %esp,%ebp
c0103e22:	83 ec 18             	sub    $0x18,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e25:	e8 95 2b 00 00       	call   c01069bf <nr_free_pages>
c0103e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103e2d:	e8 3b 00 00 00       	call   c0103e6d <check_vma_struct>
    check_pgfault();
c0103e32:	e8 56 04 00 00       	call   c010428d <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0103e37:	e8 83 2b 00 00       	call   c01069bf <nr_free_pages>
c0103e3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103e3f:	74 19                	je     c0103e5a <check_vmm+0x3b>
c0103e41:	68 4c 98 10 c0       	push   $0xc010984c
c0103e46:	68 cb 97 10 c0       	push   $0xc01097cb
c0103e4b:	68 a9 00 00 00       	push   $0xa9
c0103e50:	68 e0 97 10 c0       	push   $0xc01097e0
c0103e55:	e8 96 c5 ff ff       	call   c01003f0 <__panic>

    cprintf("check_vmm() succeeded.\n");
c0103e5a:	83 ec 0c             	sub    $0xc,%esp
c0103e5d:	68 73 98 10 c0       	push   $0xc0109873
c0103e62:	e8 23 c4 ff ff       	call   c010028a <cprintf>
c0103e67:	83 c4 10             	add    $0x10,%esp
}
c0103e6a:	90                   	nop
c0103e6b:	c9                   	leave  
c0103e6c:	c3                   	ret    

c0103e6d <check_vma_struct>:

static void
check_vma_struct(void) {
c0103e6d:	55                   	push   %ebp
c0103e6e:	89 e5                	mov    %esp,%ebp
c0103e70:	83 ec 58             	sub    $0x58,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e73:	e8 47 2b 00 00       	call   c01069bf <nr_free_pages>
c0103e78:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0103e7b:	e8 0e fc ff ff       	call   c0103a8e <mm_create>
c0103e80:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103e83:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103e87:	75 19                	jne    c0103ea2 <check_vma_struct+0x35>
c0103e89:	68 8b 98 10 c0       	push   $0xc010988b
c0103e8e:	68 cb 97 10 c0       	push   $0xc01097cb
c0103e93:	68 b3 00 00 00       	push   $0xb3
c0103e98:	68 e0 97 10 c0       	push   $0xc01097e0
c0103e9d:	e8 4e c5 ff ff       	call   c01003f0 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103ea2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0103ea9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103eac:	89 d0                	mov    %edx,%eax
c0103eae:	c1 e0 02             	shl    $0x2,%eax
c0103eb1:	01 d0                	add    %edx,%eax
c0103eb3:	01 c0                	add    %eax,%eax
c0103eb5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0103eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ebe:	eb 5f                	jmp    c0103f1f <check_vma_struct+0xb2>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ec3:	89 d0                	mov    %edx,%eax
c0103ec5:	c1 e0 02             	shl    $0x2,%eax
c0103ec8:	01 d0                	add    %edx,%eax
c0103eca:	83 c0 02             	add    $0x2,%eax
c0103ecd:	89 c1                	mov    %eax,%ecx
c0103ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ed2:	89 d0                	mov    %edx,%eax
c0103ed4:	c1 e0 02             	shl    $0x2,%eax
c0103ed7:	01 d0                	add    %edx,%eax
c0103ed9:	83 ec 04             	sub    $0x4,%esp
c0103edc:	6a 00                	push   $0x0
c0103ede:	51                   	push   %ecx
c0103edf:	50                   	push   %eax
c0103ee0:	e8 25 fc ff ff       	call   c0103b0a <vma_create>
c0103ee5:	83 c4 10             	add    $0x10,%esp
c0103ee8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0103eeb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103eef:	75 19                	jne    c0103f0a <check_vma_struct+0x9d>
c0103ef1:	68 96 98 10 c0       	push   $0xc0109896
c0103ef6:	68 cb 97 10 c0       	push   $0xc01097cb
c0103efb:	68 ba 00 00 00       	push   $0xba
c0103f00:	68 e0 97 10 c0       	push   $0xc01097e0
c0103f05:	e8 e6 c4 ff ff       	call   c01003f0 <__panic>
        insert_vma_struct(mm, vma);
c0103f0a:	83 ec 08             	sub    $0x8,%esp
c0103f0d:	ff 75 dc             	pushl  -0x24(%ebp)
c0103f10:	ff 75 e8             	pushl  -0x18(%ebp)
c0103f13:	e8 5a fd ff ff       	call   c0103c72 <insert_vma_struct>
c0103f18:	83 c4 10             	add    $0x10,%esp
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0103f1b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103f1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103f23:	7f 9b                	jg     c0103ec0 <check_vma_struct+0x53>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f28:	83 c0 01             	add    $0x1,%eax
c0103f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103f2e:	eb 5f                	jmp    c0103f8f <check_vma_struct+0x122>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f33:	89 d0                	mov    %edx,%eax
c0103f35:	c1 e0 02             	shl    $0x2,%eax
c0103f38:	01 d0                	add    %edx,%eax
c0103f3a:	83 c0 02             	add    $0x2,%eax
c0103f3d:	89 c1                	mov    %eax,%ecx
c0103f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f42:	89 d0                	mov    %edx,%eax
c0103f44:	c1 e0 02             	shl    $0x2,%eax
c0103f47:	01 d0                	add    %edx,%eax
c0103f49:	83 ec 04             	sub    $0x4,%esp
c0103f4c:	6a 00                	push   $0x0
c0103f4e:	51                   	push   %ecx
c0103f4f:	50                   	push   %eax
c0103f50:	e8 b5 fb ff ff       	call   c0103b0a <vma_create>
c0103f55:	83 c4 10             	add    $0x10,%esp
c0103f58:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0103f5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103f5f:	75 19                	jne    c0103f7a <check_vma_struct+0x10d>
c0103f61:	68 96 98 10 c0       	push   $0xc0109896
c0103f66:	68 cb 97 10 c0       	push   $0xc01097cb
c0103f6b:	68 c0 00 00 00       	push   $0xc0
c0103f70:	68 e0 97 10 c0       	push   $0xc01097e0
c0103f75:	e8 76 c4 ff ff       	call   c01003f0 <__panic>
        insert_vma_struct(mm, vma);
c0103f7a:	83 ec 08             	sub    $0x8,%esp
c0103f7d:	ff 75 d8             	pushl  -0x28(%ebp)
c0103f80:	ff 75 e8             	pushl  -0x18(%ebp)
c0103f83:	e8 ea fc ff ff       	call   c0103c72 <insert_vma_struct>
c0103f88:	83 c4 10             	add    $0x10,%esp
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103f8b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f92:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103f95:	7e 99                	jle    c0103f30 <check_vma_struct+0xc3>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0103f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f9a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103f9d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103fa0:	8b 40 04             	mov    0x4(%eax),%eax
c0103fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103fa6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103fad:	e9 81 00 00 00       	jmp    c0104033 <check_vma_struct+0x1c6>
        assert(le != &(mm->mmap_list));
c0103fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103fb8:	75 19                	jne    c0103fd3 <check_vma_struct+0x166>
c0103fba:	68 a2 98 10 c0       	push   $0xc01098a2
c0103fbf:	68 cb 97 10 c0       	push   $0xc01097cb
c0103fc4:	68 c7 00 00 00       	push   $0xc7
c0103fc9:	68 e0 97 10 c0       	push   $0xc01097e0
c0103fce:	e8 1d c4 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fd6:	83 e8 10             	sub    $0x10,%eax
c0103fd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103fdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fdf:	8b 48 04             	mov    0x4(%eax),%ecx
c0103fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103fe5:	89 d0                	mov    %edx,%eax
c0103fe7:	c1 e0 02             	shl    $0x2,%eax
c0103fea:	01 d0                	add    %edx,%eax
c0103fec:	39 c1                	cmp    %eax,%ecx
c0103fee:	75 17                	jne    c0104007 <check_vma_struct+0x19a>
c0103ff0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ff3:	8b 48 08             	mov    0x8(%eax),%ecx
c0103ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ff9:	89 d0                	mov    %edx,%eax
c0103ffb:	c1 e0 02             	shl    $0x2,%eax
c0103ffe:	01 d0                	add    %edx,%eax
c0104000:	83 c0 02             	add    $0x2,%eax
c0104003:	39 c1                	cmp    %eax,%ecx
c0104005:	74 19                	je     c0104020 <check_vma_struct+0x1b3>
c0104007:	68 bc 98 10 c0       	push   $0xc01098bc
c010400c:	68 cb 97 10 c0       	push   $0xc01097cb
c0104011:	68 c9 00 00 00       	push   $0xc9
c0104016:	68 e0 97 10 c0       	push   $0xc01097e0
c010401b:	e8 d0 c3 ff ff       	call   c01003f0 <__panic>
c0104020:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104023:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104026:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104029:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010402c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c010402f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104033:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104036:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104039:	0f 8e 73 ff ff ff    	jle    c0103fb2 <check_vma_struct+0x145>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010403f:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0104046:	e9 80 01 00 00       	jmp    c01041cb <check_vma_struct+0x35e>
        struct vma_struct *vma1 = find_vma(mm, i);
c010404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010404e:	83 ec 08             	sub    $0x8,%esp
c0104051:	50                   	push   %eax
c0104052:	ff 75 e8             	pushl  -0x18(%ebp)
c0104055:	e8 ec fa ff ff       	call   c0103b46 <find_vma>
c010405a:	83 c4 10             	add    $0x10,%esp
c010405d:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c0104060:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104064:	75 19                	jne    c010407f <check_vma_struct+0x212>
c0104066:	68 f1 98 10 c0       	push   $0xc01098f1
c010406b:	68 cb 97 10 c0       	push   $0xc01097cb
c0104070:	68 cf 00 00 00       	push   $0xcf
c0104075:	68 e0 97 10 c0       	push   $0xc01097e0
c010407a:	e8 71 c3 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c010407f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104082:	83 c0 01             	add    $0x1,%eax
c0104085:	83 ec 08             	sub    $0x8,%esp
c0104088:	50                   	push   %eax
c0104089:	ff 75 e8             	pushl  -0x18(%ebp)
c010408c:	e8 b5 fa ff ff       	call   c0103b46 <find_vma>
c0104091:	83 c4 10             	add    $0x10,%esp
c0104094:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c0104097:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010409b:	75 19                	jne    c01040b6 <check_vma_struct+0x249>
c010409d:	68 fe 98 10 c0       	push   $0xc01098fe
c01040a2:	68 cb 97 10 c0       	push   $0xc01097cb
c01040a7:	68 d1 00 00 00       	push   $0xd1
c01040ac:	68 e0 97 10 c0       	push   $0xc01097e0
c01040b1:	e8 3a c3 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c01040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040b9:	83 c0 02             	add    $0x2,%eax
c01040bc:	83 ec 08             	sub    $0x8,%esp
c01040bf:	50                   	push   %eax
c01040c0:	ff 75 e8             	pushl  -0x18(%ebp)
c01040c3:	e8 7e fa ff ff       	call   c0103b46 <find_vma>
c01040c8:	83 c4 10             	add    $0x10,%esp
c01040cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c01040ce:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01040d2:	74 19                	je     c01040ed <check_vma_struct+0x280>
c01040d4:	68 0b 99 10 c0       	push   $0xc010990b
c01040d9:	68 cb 97 10 c0       	push   $0xc01097cb
c01040de:	68 d3 00 00 00       	push   $0xd3
c01040e3:	68 e0 97 10 c0       	push   $0xc01097e0
c01040e8:	e8 03 c3 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01040ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040f0:	83 c0 03             	add    $0x3,%eax
c01040f3:	83 ec 08             	sub    $0x8,%esp
c01040f6:	50                   	push   %eax
c01040f7:	ff 75 e8             	pushl  -0x18(%ebp)
c01040fa:	e8 47 fa ff ff       	call   c0103b46 <find_vma>
c01040ff:	83 c4 10             	add    $0x10,%esp
c0104102:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c0104105:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0104109:	74 19                	je     c0104124 <check_vma_struct+0x2b7>
c010410b:	68 18 99 10 c0       	push   $0xc0109918
c0104110:	68 cb 97 10 c0       	push   $0xc01097cb
c0104115:	68 d5 00 00 00       	push   $0xd5
c010411a:	68 e0 97 10 c0       	push   $0xc01097e0
c010411f:	e8 cc c2 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0104124:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104127:	83 c0 04             	add    $0x4,%eax
c010412a:	83 ec 08             	sub    $0x8,%esp
c010412d:	50                   	push   %eax
c010412e:	ff 75 e8             	pushl  -0x18(%ebp)
c0104131:	e8 10 fa ff ff       	call   c0103b46 <find_vma>
c0104136:	83 c4 10             	add    $0x10,%esp
c0104139:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c010413c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104140:	74 19                	je     c010415b <check_vma_struct+0x2ee>
c0104142:	68 25 99 10 c0       	push   $0xc0109925
c0104147:	68 cb 97 10 c0       	push   $0xc01097cb
c010414c:	68 d7 00 00 00       	push   $0xd7
c0104151:	68 e0 97 10 c0       	push   $0xc01097e0
c0104156:	e8 95 c2 ff ff       	call   c01003f0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c010415b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010415e:	8b 50 04             	mov    0x4(%eax),%edx
c0104161:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104164:	39 c2                	cmp    %eax,%edx
c0104166:	75 10                	jne    c0104178 <check_vma_struct+0x30b>
c0104168:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010416b:	8b 40 08             	mov    0x8(%eax),%eax
c010416e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104171:	83 c2 02             	add    $0x2,%edx
c0104174:	39 d0                	cmp    %edx,%eax
c0104176:	74 19                	je     c0104191 <check_vma_struct+0x324>
c0104178:	68 34 99 10 c0       	push   $0xc0109934
c010417d:	68 cb 97 10 c0       	push   $0xc01097cb
c0104182:	68 d9 00 00 00       	push   $0xd9
c0104187:	68 e0 97 10 c0       	push   $0xc01097e0
c010418c:	e8 5f c2 ff ff       	call   c01003f0 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0104191:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104194:	8b 50 04             	mov    0x4(%eax),%edx
c0104197:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010419a:	39 c2                	cmp    %eax,%edx
c010419c:	75 10                	jne    c01041ae <check_vma_struct+0x341>
c010419e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041a1:	8b 40 08             	mov    0x8(%eax),%eax
c01041a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01041a7:	83 c2 02             	add    $0x2,%edx
c01041aa:	39 d0                	cmp    %edx,%eax
c01041ac:	74 19                	je     c01041c7 <check_vma_struct+0x35a>
c01041ae:	68 64 99 10 c0       	push   $0xc0109964
c01041b3:	68 cb 97 10 c0       	push   $0xc01097cb
c01041b8:	68 da 00 00 00       	push   $0xda
c01041bd:	68 e0 97 10 c0       	push   $0xc01097e0
c01041c2:	e8 29 c2 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01041c7:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01041cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041ce:	89 d0                	mov    %edx,%eax
c01041d0:	c1 e0 02             	shl    $0x2,%eax
c01041d3:	01 d0                	add    %edx,%eax
c01041d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01041d8:	0f 8d 6d fe ff ff    	jge    c010404b <check_vma_struct+0x1de>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01041de:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01041e5:	eb 5c                	jmp    c0104243 <check_vma_struct+0x3d6>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01041e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ea:	83 ec 08             	sub    $0x8,%esp
c01041ed:	50                   	push   %eax
c01041ee:	ff 75 e8             	pushl  -0x18(%ebp)
c01041f1:	e8 50 f9 ff ff       	call   c0103b46 <find_vma>
c01041f6:	83 c4 10             	add    $0x10,%esp
c01041f9:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL ) {
c01041fc:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104200:	74 1e                	je     c0104220 <check_vma_struct+0x3b3>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0104202:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104205:	8b 50 08             	mov    0x8(%eax),%edx
c0104208:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010420b:	8b 40 04             	mov    0x4(%eax),%eax
c010420e:	52                   	push   %edx
c010420f:	50                   	push   %eax
c0104210:	ff 75 f4             	pushl  -0xc(%ebp)
c0104213:	68 94 99 10 c0       	push   $0xc0109994
c0104218:	e8 6d c0 ff ff       	call   c010028a <cprintf>
c010421d:	83 c4 10             	add    $0x10,%esp
        }
        assert(vma_below_5 == NULL);
c0104220:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104224:	74 19                	je     c010423f <check_vma_struct+0x3d2>
c0104226:	68 b9 99 10 c0       	push   $0xc01099b9
c010422b:	68 cb 97 10 c0       	push   $0xc01097cb
c0104230:	68 e2 00 00 00       	push   $0xe2
c0104235:	68 e0 97 10 c0       	push   $0xc01097e0
c010423a:	e8 b1 c1 ff ff       	call   c01003f0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010423f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104247:	79 9e                	jns    c01041e7 <check_vma_struct+0x37a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0104249:	83 ec 0c             	sub    $0xc,%esp
c010424c:	ff 75 e8             	pushl  -0x18(%ebp)
c010424f:	e8 42 fb ff ff       	call   c0103d96 <mm_destroy>
c0104254:	83 c4 10             	add    $0x10,%esp

    assert(nr_free_pages_store == nr_free_pages());
c0104257:	e8 63 27 00 00       	call   c01069bf <nr_free_pages>
c010425c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010425f:	74 19                	je     c010427a <check_vma_struct+0x40d>
c0104261:	68 4c 98 10 c0       	push   $0xc010984c
c0104266:	68 cb 97 10 c0       	push   $0xc01097cb
c010426b:	68 e7 00 00 00       	push   $0xe7
c0104270:	68 e0 97 10 c0       	push   $0xc01097e0
c0104275:	e8 76 c1 ff ff       	call   c01003f0 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c010427a:	83 ec 0c             	sub    $0xc,%esp
c010427d:	68 d0 99 10 c0       	push   $0xc01099d0
c0104282:	e8 03 c0 ff ff       	call   c010028a <cprintf>
c0104287:	83 c4 10             	add    $0x10,%esp
}
c010428a:	90                   	nop
c010428b:	c9                   	leave  
c010428c:	c3                   	ret    

c010428d <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c010428d:	55                   	push   %ebp
c010428e:	89 e5                	mov    %esp,%ebp
c0104290:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0104293:	e8 27 27 00 00       	call   c01069bf <nr_free_pages>
c0104298:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c010429b:	e8 ee f7 ff ff       	call   c0103a8e <mm_create>
c01042a0:	a3 7c 50 12 c0       	mov    %eax,0xc012507c
    assert(check_mm_struct != NULL);
c01042a5:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c01042aa:	85 c0                	test   %eax,%eax
c01042ac:	75 19                	jne    c01042c7 <check_pgfault+0x3a>
c01042ae:	68 ef 99 10 c0       	push   $0xc01099ef
c01042b3:	68 cb 97 10 c0       	push   $0xc01097cb
c01042b8:	68 f4 00 00 00       	push   $0xf4
c01042bd:	68 e0 97 10 c0       	push   $0xc01097e0
c01042c2:	e8 29 c1 ff ff       	call   c01003f0 <__panic>

    struct mm_struct *mm = check_mm_struct;
c01042c7:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c01042cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c01042cf:	8b 15 40 1a 12 c0    	mov    0xc0121a40,%edx
c01042d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042d8:	89 50 0c             	mov    %edx,0xc(%eax)
c01042db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042de:	8b 40 0c             	mov    0xc(%eax),%eax
c01042e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c01042e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042e7:	8b 00                	mov    (%eax),%eax
c01042e9:	85 c0                	test   %eax,%eax
c01042eb:	74 19                	je     c0104306 <check_pgfault+0x79>
c01042ed:	68 07 9a 10 c0       	push   $0xc0109a07
c01042f2:	68 cb 97 10 c0       	push   $0xc01097cb
c01042f7:	68 f8 00 00 00       	push   $0xf8
c01042fc:	68 e0 97 10 c0       	push   $0xc01097e0
c0104301:	e8 ea c0 ff ff       	call   c01003f0 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0104306:	83 ec 04             	sub    $0x4,%esp
c0104309:	6a 02                	push   $0x2
c010430b:	68 00 00 40 00       	push   $0x400000
c0104310:	6a 00                	push   $0x0
c0104312:	e8 f3 f7 ff ff       	call   c0103b0a <vma_create>
c0104317:	83 c4 10             	add    $0x10,%esp
c010431a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c010431d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104321:	75 19                	jne    c010433c <check_pgfault+0xaf>
c0104323:	68 96 98 10 c0       	push   $0xc0109896
c0104328:	68 cb 97 10 c0       	push   $0xc01097cb
c010432d:	68 fb 00 00 00       	push   $0xfb
c0104332:	68 e0 97 10 c0       	push   $0xc01097e0
c0104337:	e8 b4 c0 ff ff       	call   c01003f0 <__panic>

    insert_vma_struct(mm, vma);
c010433c:	83 ec 08             	sub    $0x8,%esp
c010433f:	ff 75 e0             	pushl  -0x20(%ebp)
c0104342:	ff 75 e8             	pushl  -0x18(%ebp)
c0104345:	e8 28 f9 ff ff       	call   c0103c72 <insert_vma_struct>
c010434a:	83 c4 10             	add    $0x10,%esp

    uintptr_t addr = 0x100;
c010434d:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0104354:	83 ec 08             	sub    $0x8,%esp
c0104357:	ff 75 dc             	pushl  -0x24(%ebp)
c010435a:	ff 75 e8             	pushl  -0x18(%ebp)
c010435d:	e8 e4 f7 ff ff       	call   c0103b46 <find_vma>
c0104362:	83 c4 10             	add    $0x10,%esp
c0104365:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104368:	74 19                	je     c0104383 <check_pgfault+0xf6>
c010436a:	68 15 9a 10 c0       	push   $0xc0109a15
c010436f:	68 cb 97 10 c0       	push   $0xc01097cb
c0104374:	68 00 01 00 00       	push   $0x100
c0104379:	68 e0 97 10 c0       	push   $0xc01097e0
c010437e:	e8 6d c0 ff ff       	call   c01003f0 <__panic>

    int i, sum = 0;
c0104383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c010438a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104391:	eb 19                	jmp    c01043ac <check_pgfault+0x11f>
        *(char *)(addr + i) = i;
c0104393:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104396:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104399:	01 d0                	add    %edx,%eax
c010439b:	89 c2                	mov    %eax,%edx
c010439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a0:	88 02                	mov    %al,(%edx)
        sum += i;
c01043a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a5:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c01043a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01043ac:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01043b0:	7e e1                	jle    c0104393 <check_pgfault+0x106>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c01043b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01043b9:	eb 15                	jmp    c01043d0 <check_pgfault+0x143>
        sum -= *(char *)(addr + i);
c01043bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01043be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043c1:	01 d0                	add    %edx,%eax
c01043c3:	0f b6 00             	movzbl (%eax),%eax
c01043c6:	0f be c0             	movsbl %al,%eax
c01043c9:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c01043cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01043d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01043d4:	7e e5                	jle    c01043bb <check_pgfault+0x12e>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c01043d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043da:	74 19                	je     c01043f5 <check_pgfault+0x168>
c01043dc:	68 2f 9a 10 c0       	push   $0xc0109a2f
c01043e1:	68 cb 97 10 c0       	push   $0xc01097cb
c01043e6:	68 0a 01 00 00       	push   $0x10a
c01043eb:	68 e0 97 10 c0       	push   $0xc01097e0
c01043f0:	e8 fb bf ff ff       	call   c01003f0 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01043f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01043fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104403:	83 ec 08             	sub    $0x8,%esp
c0104406:	50                   	push   %eax
c0104407:	ff 75 e4             	pushl  -0x1c(%ebp)
c010440a:	e8 7c 2d 00 00       	call   c010718b <page_remove>
c010440f:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(pgdir[0]));
c0104412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104415:	8b 00                	mov    (%eax),%eax
c0104417:	83 ec 0c             	sub    $0xc,%esp
c010441a:	50                   	push   %eax
c010441b:	e8 52 f6 ff ff       	call   c0103a72 <pde2page>
c0104420:	83 c4 10             	add    $0x10,%esp
c0104423:	83 ec 08             	sub    $0x8,%esp
c0104426:	6a 01                	push   $0x1
c0104428:	50                   	push   %eax
c0104429:	e8 5c 25 00 00       	call   c010698a <free_pages>
c010442e:	83 c4 10             	add    $0x10,%esp
    pgdir[0] = 0;
c0104431:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104434:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c010443a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010443d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0104444:	83 ec 0c             	sub    $0xc,%esp
c0104447:	ff 75 e8             	pushl  -0x18(%ebp)
c010444a:	e8 47 f9 ff ff       	call   c0103d96 <mm_destroy>
c010444f:	83 c4 10             	add    $0x10,%esp
    check_mm_struct = NULL;
c0104452:	c7 05 7c 50 12 c0 00 	movl   $0x0,0xc012507c
c0104459:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c010445c:	e8 5e 25 00 00       	call   c01069bf <nr_free_pages>
c0104461:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104464:	74 19                	je     c010447f <check_pgfault+0x1f2>
c0104466:	68 4c 98 10 c0       	push   $0xc010984c
c010446b:	68 cb 97 10 c0       	push   $0xc01097cb
c0104470:	68 14 01 00 00       	push   $0x114
c0104475:	68 e0 97 10 c0       	push   $0xc01097e0
c010447a:	e8 71 bf ff ff       	call   c01003f0 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c010447f:	83 ec 0c             	sub    $0xc,%esp
c0104482:	68 38 9a 10 c0       	push   $0xc0109a38
c0104487:	e8 fe bd ff ff       	call   c010028a <cprintf>
c010448c:	83 c4 10             	add    $0x10,%esp
}
c010448f:	90                   	nop
c0104490:	c9                   	leave  
c0104491:	c3                   	ret    

c0104492 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0104492:	55                   	push   %ebp
c0104493:	89 e5                	mov    %esp,%ebp
c0104495:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_INVAL;
c0104498:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c010449f:	ff 75 10             	pushl  0x10(%ebp)
c01044a2:	ff 75 08             	pushl  0x8(%ebp)
c01044a5:	e8 9c f6 ff ff       	call   c0103b46 <find_vma>
c01044aa:	83 c4 08             	add    $0x8,%esp
c01044ad:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c01044b0:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01044b5:	83 c0 01             	add    $0x1,%eax
c01044b8:	a3 64 4f 12 c0       	mov    %eax,0xc0124f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c01044bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01044c1:	74 0b                	je     c01044ce <do_pgfault+0x3c>
c01044c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044c6:	8b 40 04             	mov    0x4(%eax),%eax
c01044c9:	3b 45 10             	cmp    0x10(%ebp),%eax
c01044cc:	76 18                	jbe    c01044e6 <do_pgfault+0x54>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c01044ce:	83 ec 08             	sub    $0x8,%esp
c01044d1:	ff 75 10             	pushl  0x10(%ebp)
c01044d4:	68 54 9a 10 c0       	push   $0xc0109a54
c01044d9:	e8 ac bd ff ff       	call   c010028a <cprintf>
c01044de:	83 c4 10             	add    $0x10,%esp
        goto failed;
c01044e1:	e9 b4 01 00 00       	jmp    c010469a <do_pgfault+0x208>
    }
    //check the error_code
    switch (error_code & 3) {
c01044e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044e9:	83 e0 03             	and    $0x3,%eax
c01044ec:	85 c0                	test   %eax,%eax
c01044ee:	74 3c                	je     c010452c <do_pgfault+0x9a>
c01044f0:	83 f8 01             	cmp    $0x1,%eax
c01044f3:	74 22                	je     c0104517 <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
            // this happens when privilege conflict
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01044f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044f8:	8b 40 0c             	mov    0xc(%eax),%eax
c01044fb:	83 e0 02             	and    $0x2,%eax
c01044fe:	85 c0                	test   %eax,%eax
c0104500:	75 4c                	jne    c010454e <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0104502:	83 ec 0c             	sub    $0xc,%esp
c0104505:	68 84 9a 10 c0       	push   $0xc0109a84
c010450a:	e8 7b bd ff ff       	call   c010028a <cprintf>
c010450f:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0104512:	e9 83 01 00 00       	jmp    c010469a <do_pgfault+0x208>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        // this should not happen!
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0104517:	83 ec 0c             	sub    $0xc,%esp
c010451a:	68 e4 9a 10 c0       	push   $0xc0109ae4
c010451f:	e8 66 bd ff ff       	call   c010028a <cprintf>
c0104524:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0104527:	e9 6e 01 00 00       	jmp    c010469a <do_pgfault+0x208>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c010452c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010452f:	8b 40 0c             	mov    0xc(%eax),%eax
c0104532:	83 e0 05             	and    $0x5,%eax
c0104535:	85 c0                	test   %eax,%eax
c0104537:	75 16                	jne    c010454f <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0104539:	83 ec 0c             	sub    $0xc,%esp
c010453c:	68 1c 9b 10 c0       	push   $0xc0109b1c
c0104541:	e8 44 bd ff ff       	call   c010028a <cprintf>
c0104546:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0104549:	e9 4c 01 00 00       	jmp    c010469a <do_pgfault+0x208>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c010454e:	90                   	nop
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    // constitute permission
    uint32_t perm = PTE_U;
c010454f:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0104556:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104559:	8b 40 0c             	mov    0xc(%eax),%eax
c010455c:	83 e0 02             	and    $0x2,%eax
c010455f:	85 c0                	test   %eax,%eax
c0104561:	74 04                	je     c0104567 <do_pgfault+0xd5>
        perm |= PTE_W;
c0104563:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0104567:	8b 45 10             	mov    0x10(%ebp),%eax
c010456a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010456d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104570:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104575:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0104578:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c010457f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: 2015010062*/
    ptep = get_pte(mm->pgdir, addr, 1);              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0104586:	8b 45 08             	mov    0x8(%ebp),%eax
c0104589:	8b 40 0c             	mov    0xc(%eax),%eax
c010458c:	83 ec 04             	sub    $0x4,%esp
c010458f:	6a 01                	push   $0x1
c0104591:	ff 75 10             	pushl  0x10(%ebp)
c0104594:	50                   	push   %eax
c0104595:	e8 eb 29 00 00       	call   c0106f85 <get_pte>
c010459a:	83 c4 10             	add    $0x10,%esp
c010459d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(ptep != NULL);
c01045a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01045a4:	75 19                	jne    c01045bf <do_pgfault+0x12d>
c01045a6:	68 7f 9b 10 c0       	push   $0xc0109b7f
c01045ab:	68 cb 97 10 c0       	push   $0xc01097cb
c01045b0:	68 74 01 00 00       	push   $0x174
c01045b5:	68 e0 97 10 c0       	push   $0xc01097e0
c01045ba:	e8 31 be ff ff       	call   c01003f0 <__panic>
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0) {
c01045bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045c2:	8b 00                	mov    (%eax),%eax
c01045c4:	85 c0                	test   %eax,%eax
c01045c6:	75 39                	jne    c0104601 <do_pgfault+0x16f>
        assert(pgdir_alloc_page(mm->pgdir, addr, perm) != NULL);
c01045c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01045cb:	8b 40 0c             	mov    0xc(%eax),%eax
c01045ce:	83 ec 04             	sub    $0x4,%esp
c01045d1:	ff 75 f0             	pushl  -0x10(%ebp)
c01045d4:	ff 75 10             	pushl  0x10(%ebp)
c01045d7:	50                   	push   %eax
c01045d8:	e8 f0 2c 00 00       	call   c01072cd <pgdir_alloc_page>
c01045dd:	83 c4 10             	add    $0x10,%esp
c01045e0:	85 c0                	test   %eax,%eax
c01045e2:	0f 85 ab 00 00 00    	jne    c0104693 <do_pgfault+0x201>
c01045e8:	68 8c 9b 10 c0       	push   $0xc0109b8c
c01045ed:	68 cb 97 10 c0       	push   $0xc01097cb
c01045f2:	68 77 01 00 00       	push   $0x177
c01045f7:	68 e0 97 10 c0       	push   $0xc01097e0
c01045fc:	e8 ef bd ff ff       	call   c01003f0 <__panic>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0104601:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0104606:	85 c0                	test   %eax,%eax
c0104608:	74 71                	je     c010467b <do_pgfault+0x1e9>
            struct Page *page=NULL;
c010460a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page
            //    into the memory which page managed.
            assert(swap_in(mm, addr, &page) == 0);
c0104611:	83 ec 04             	sub    $0x4,%esp
c0104614:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0104617:	50                   	push   %eax
c0104618:	ff 75 10             	pushl  0x10(%ebp)
c010461b:	ff 75 08             	pushl  0x8(%ebp)
c010461e:	e8 10 08 00 00       	call   c0104e33 <swap_in>
c0104623:	83 c4 10             	add    $0x10,%esp
c0104626:	85 c0                	test   %eax,%eax
c0104628:	74 19                	je     c0104643 <do_pgfault+0x1b1>
c010462a:	68 bc 9b 10 c0       	push   $0xc0109bbc
c010462f:	68 cb 97 10 c0       	push   $0xc01097cb
c0104634:	68 89 01 00 00       	push   $0x189
c0104639:	68 e0 97 10 c0       	push   $0xc01097e0
c010463e:	e8 ad bd ff ff       	call   c01003f0 <__panic>
            page->pra_vaddr = addr;
c0104643:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104646:	8b 55 10             	mov    0x10(%ebp),%edx
c0104649:	89 50 1c             	mov    %edx,0x1c(%eax)
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            page_insert(mm->pgdir, page, addr, perm);
c010464c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010464f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104652:	8b 40 0c             	mov    0xc(%eax),%eax
c0104655:	ff 75 f0             	pushl  -0x10(%ebp)
c0104658:	ff 75 10             	pushl  0x10(%ebp)
c010465b:	52                   	push   %edx
c010465c:	50                   	push   %eax
c010465d:	e8 62 2b 00 00       	call   c01071c4 <page_insert>
c0104662:	83 c4 10             	add    $0x10,%esp
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c0104665:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104668:	6a 01                	push   $0x1
c010466a:	50                   	push   %eax
c010466b:	ff 75 10             	pushl  0x10(%ebp)
c010466e:	ff 75 08             	pushl  0x8(%ebp)
c0104671:	e8 2d 06 00 00       	call   c0104ca3 <swap_map_swappable>
c0104676:	83 c4 10             	add    $0x10,%esp
c0104679:	eb 18                	jmp    c0104693 <do_pgfault+0x201>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c010467b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010467e:	8b 00                	mov    (%eax),%eax
c0104680:	83 ec 08             	sub    $0x8,%esp
c0104683:	50                   	push   %eax
c0104684:	68 dc 9b 10 c0       	push   $0xc0109bdc
c0104689:	e8 fc bb ff ff       	call   c010028a <cprintf>
c010468e:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0104691:	eb 07                	jmp    c010469a <do_pgfault+0x208>
        }
   }
   ret = 0;
c0104693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010469d:	c9                   	leave  
c010469e:	c3                   	ret    

c010469f <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010469f:	55                   	push   %ebp
c01046a0:	89 e5                	mov    %esp,%ebp
c01046a2:	83 ec 10             	sub    $0x10,%esp
c01046a5:	c7 45 fc 70 50 12 c0 	movl   $0xc0125070,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01046ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01046af:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01046b2:	89 50 04             	mov    %edx,0x4(%eax)
c01046b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01046b8:	8b 50 04             	mov    0x4(%eax),%edx
c01046bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01046be:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01046c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c3:	c7 40 14 70 50 12 c0 	movl   $0xc0125070,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01046ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046cf:	c9                   	leave  
c01046d0:	c3                   	ret    

c01046d1 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01046d1:	55                   	push   %ebp
c01046d2:	89 e5                	mov    %esp,%ebp
c01046d4:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01046d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046da:	8b 40 14             	mov    0x14(%eax),%eax
c01046dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01046e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01046e3:	83 c0 14             	add    $0x14,%eax
c01046e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    
    assert(entry != NULL && head != NULL);
c01046e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01046ed:	74 06                	je     c01046f5 <_fifo_map_swappable+0x24>
c01046ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046f3:	75 16                	jne    c010470b <_fifo_map_swappable+0x3a>
c01046f5:	68 04 9c 10 c0       	push   $0xc0109c04
c01046fa:	68 22 9c 10 c0       	push   $0xc0109c22
c01046ff:	6a 32                	push   $0x32
c0104701:	68 37 9c 10 c0       	push   $0xc0109c37
c0104706:	e8 e5 bc ff ff       	call   c01003f0 <__panic>
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c010470b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010470f:	75 57                	jne    c0104768 <_fifo_map_swappable+0x97>
        list_entry_t *le_prev = head, *le;
c0104711:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104714:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c0104717:	eb 38                	jmp    c0104751 <_fifo_map_swappable+0x80>
            if (le == entry) {
c0104719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010471c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010471f:	75 2a                	jne    c010474b <_fifo_map_swappable+0x7a>
c0104721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104724:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104727:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010472a:	8b 40 04             	mov    0x4(%eax),%eax
c010472d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104730:	8b 12                	mov    (%edx),%edx
c0104732:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104735:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104738:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010473b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010473e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104741:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104744:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104747:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c0104749:	eb 1d                	jmp    c0104768 <_fifo_map_swappable+0x97>
            }
            le_prev = le;        
c010474b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010474e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104754:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104757:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010475a:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c010475d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104763:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104766:	75 b1                	jne    c0104719 <_fifo_map_swappable+0x48>
c0104768:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010476b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010476e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104771:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104774:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104777:	8b 00                	mov    (%eax),%eax
c0104779:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010477c:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010477f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104782:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104785:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104788:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010478b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010478e:	89 10                	mov    %edx,(%eax)
c0104790:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104793:	8b 10                	mov    (%eax),%edx
c0104795:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104798:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010479b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010479e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01047a1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01047a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01047a7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01047aa:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c01047ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047b1:	c9                   	leave  
c01047b2:	c3                   	ret    

c01047b3 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01047b3:	55                   	push   %ebp
c01047b4:	89 e5                	mov    %esp,%ebp
c01047b6:	83 ec 28             	sub    $0x28,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01047b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047bc:	8b 40 14             	mov    0x14(%eax),%eax
c01047bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != NULL);
c01047c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047c6:	75 16                	jne    c01047de <_fifo_swap_out_victim+0x2b>
c01047c8:	68 4b 9c 10 c0       	push   $0xc0109c4b
c01047cd:	68 22 9c 10 c0       	push   $0xc0109c22
c01047d2:	6a 4c                	push   $0x4c
c01047d4:	68 37 9c 10 c0       	push   $0xc0109c37
c01047d9:	e8 12 bc ff ff       	call   c01003f0 <__panic>
    assert(in_tick==0);
c01047de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01047e2:	74 16                	je     c01047fa <_fifo_swap_out_victim+0x47>
c01047e4:	68 58 9c 10 c0       	push   $0xc0109c58
c01047e9:	68 22 9c 10 c0       	push   $0xc0109c22
c01047ee:	6a 4d                	push   $0x4d
c01047f0:	68 37 9c 10 c0       	push   $0xc0109c37
c01047f5:	e8 f6 bb ff ff       	call   c01003f0 <__panic>
c01047fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104803:	8b 40 04             	mov    0x4(%eax),%eax
    /* Select the victim */
    /*LAB3 EXERCISE 2: 2015010062*/ 
    //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
    list_entry_t *front = list_next(head);
c0104806:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(front != head);
c0104809:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010480c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010480f:	75 16                	jne    c0104827 <_fifo_swap_out_victim+0x74>
c0104811:	68 63 9c 10 c0       	push   $0xc0109c63
c0104816:	68 22 9c 10 c0       	push   $0xc0109c22
c010481b:	6a 52                	push   $0x52
c010481d:	68 37 9c 10 c0       	push   $0xc0109c37
c0104822:	e8 c9 bb ff ff       	call   c01003f0 <__panic>
c0104827:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010482a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010482d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104830:	8b 40 04             	mov    0x4(%eax),%eax
c0104833:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104836:	8b 12                	mov    (%edx),%edx
c0104838:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010483b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010483e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104841:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104844:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104847:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010484a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010484d:	89 10                	mov    %edx,(%eax)
    list_del(front);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(front, pra_page_link);
c010484f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104852:	83 e8 14             	sub    $0x14,%eax
c0104855:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(page != NULL);
c0104858:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010485c:	75 16                	jne    c0104874 <_fifo_swap_out_victim+0xc1>
c010485e:	68 71 9c 10 c0       	push   $0xc0109c71
c0104863:	68 22 9c 10 c0       	push   $0xc0109c22
c0104868:	6a 56                	push   $0x56
c010486a:	68 37 9c 10 c0       	push   $0xc0109c37
c010486f:	e8 7c bb ff ff       	call   c01003f0 <__panic>
    *ptr_page = page;
c0104874:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104877:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010487a:	89 10                	mov    %edx,(%eax)
    return 0;
c010487c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104881:	c9                   	leave  
c0104882:	c3                   	ret    

c0104883 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0104883:	55                   	push   %ebp
c0104884:	89 e5                	mov    %esp,%ebp
c0104886:	83 ec 08             	sub    $0x8,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104889:	83 ec 0c             	sub    $0xc,%esp
c010488c:	68 80 9c 10 c0       	push   $0xc0109c80
c0104891:	e8 f4 b9 ff ff       	call   c010028a <cprintf>
c0104896:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0104899:	b8 00 30 00 00       	mov    $0x3000,%eax
c010489e:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01048a1:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01048a6:	83 f8 04             	cmp    $0x4,%eax
c01048a9:	74 16                	je     c01048c1 <_fifo_check_swap+0x3e>
c01048ab:	68 a6 9c 10 c0       	push   $0xc0109ca6
c01048b0:	68 22 9c 10 c0       	push   $0xc0109c22
c01048b5:	6a 5f                	push   $0x5f
c01048b7:	68 37 9c 10 c0       	push   $0xc0109c37
c01048bc:	e8 2f bb ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01048c1:	83 ec 0c             	sub    $0xc,%esp
c01048c4:	68 b8 9c 10 c0       	push   $0xc0109cb8
c01048c9:	e8 bc b9 ff ff       	call   c010028a <cprintf>
c01048ce:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01048d1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01048d6:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01048d9:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01048de:	83 f8 04             	cmp    $0x4,%eax
c01048e1:	74 16                	je     c01048f9 <_fifo_check_swap+0x76>
c01048e3:	68 a6 9c 10 c0       	push   $0xc0109ca6
c01048e8:	68 22 9c 10 c0       	push   $0xc0109c22
c01048ed:	6a 62                	push   $0x62
c01048ef:	68 37 9c 10 c0       	push   $0xc0109c37
c01048f4:	e8 f7 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01048f9:	83 ec 0c             	sub    $0xc,%esp
c01048fc:	68 e0 9c 10 c0       	push   $0xc0109ce0
c0104901:	e8 84 b9 ff ff       	call   c010028a <cprintf>
c0104906:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0104909:	b8 00 40 00 00       	mov    $0x4000,%eax
c010490e:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0104911:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104916:	83 f8 04             	cmp    $0x4,%eax
c0104919:	74 16                	je     c0104931 <_fifo_check_swap+0xae>
c010491b:	68 a6 9c 10 c0       	push   $0xc0109ca6
c0104920:	68 22 9c 10 c0       	push   $0xc0109c22
c0104925:	6a 65                	push   $0x65
c0104927:	68 37 9c 10 c0       	push   $0xc0109c37
c010492c:	e8 bf ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0104931:	83 ec 0c             	sub    $0xc,%esp
c0104934:	68 08 9d 10 c0       	push   $0xc0109d08
c0104939:	e8 4c b9 ff ff       	call   c010028a <cprintf>
c010493e:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0104941:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104946:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0104949:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010494e:	83 f8 04             	cmp    $0x4,%eax
c0104951:	74 16                	je     c0104969 <_fifo_check_swap+0xe6>
c0104953:	68 a6 9c 10 c0       	push   $0xc0109ca6
c0104958:	68 22 9c 10 c0       	push   $0xc0109c22
c010495d:	6a 68                	push   $0x68
c010495f:	68 37 9c 10 c0       	push   $0xc0109c37
c0104964:	e8 87 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104969:	83 ec 0c             	sub    $0xc,%esp
c010496c:	68 30 9d 10 c0       	push   $0xc0109d30
c0104971:	e8 14 b9 ff ff       	call   c010028a <cprintf>
c0104976:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104979:	b8 00 50 00 00       	mov    $0x5000,%eax
c010497e:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0104981:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104986:	83 f8 05             	cmp    $0x5,%eax
c0104989:	74 16                	je     c01049a1 <_fifo_check_swap+0x11e>
c010498b:	68 56 9d 10 c0       	push   $0xc0109d56
c0104990:	68 22 9c 10 c0       	push   $0xc0109c22
c0104995:	6a 6b                	push   $0x6b
c0104997:	68 37 9c 10 c0       	push   $0xc0109c37
c010499c:	e8 4f ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01049a1:	83 ec 0c             	sub    $0xc,%esp
c01049a4:	68 08 9d 10 c0       	push   $0xc0109d08
c01049a9:	e8 dc b8 ff ff       	call   c010028a <cprintf>
c01049ae:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c01049b1:	b8 00 20 00 00       	mov    $0x2000,%eax
c01049b6:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01049b9:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01049be:	83 f8 05             	cmp    $0x5,%eax
c01049c1:	74 16                	je     c01049d9 <_fifo_check_swap+0x156>
c01049c3:	68 56 9d 10 c0       	push   $0xc0109d56
c01049c8:	68 22 9c 10 c0       	push   $0xc0109c22
c01049cd:	6a 6e                	push   $0x6e
c01049cf:	68 37 9c 10 c0       	push   $0xc0109c37
c01049d4:	e8 17 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01049d9:	83 ec 0c             	sub    $0xc,%esp
c01049dc:	68 b8 9c 10 c0       	push   $0xc0109cb8
c01049e1:	e8 a4 b8 ff ff       	call   c010028a <cprintf>
c01049e6:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01049e9:	b8 00 10 00 00       	mov    $0x1000,%eax
c01049ee:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01049f1:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01049f6:	83 f8 06             	cmp    $0x6,%eax
c01049f9:	74 16                	je     c0104a11 <_fifo_check_swap+0x18e>
c01049fb:	68 65 9d 10 c0       	push   $0xc0109d65
c0104a00:	68 22 9c 10 c0       	push   $0xc0109c22
c0104a05:	6a 71                	push   $0x71
c0104a07:	68 37 9c 10 c0       	push   $0xc0109c37
c0104a0c:	e8 df b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0104a11:	83 ec 0c             	sub    $0xc,%esp
c0104a14:	68 08 9d 10 c0       	push   $0xc0109d08
c0104a19:	e8 6c b8 ff ff       	call   c010028a <cprintf>
c0104a1e:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0104a21:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104a26:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0104a29:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a2e:	83 f8 07             	cmp    $0x7,%eax
c0104a31:	74 16                	je     c0104a49 <_fifo_check_swap+0x1c6>
c0104a33:	68 74 9d 10 c0       	push   $0xc0109d74
c0104a38:	68 22 9c 10 c0       	push   $0xc0109c22
c0104a3d:	6a 74                	push   $0x74
c0104a3f:	68 37 9c 10 c0       	push   $0xc0109c37
c0104a44:	e8 a7 b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104a49:	83 ec 0c             	sub    $0xc,%esp
c0104a4c:	68 80 9c 10 c0       	push   $0xc0109c80
c0104a51:	e8 34 b8 ff ff       	call   c010028a <cprintf>
c0104a56:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0104a59:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104a5e:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0104a61:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a66:	83 f8 08             	cmp    $0x8,%eax
c0104a69:	74 16                	je     c0104a81 <_fifo_check_swap+0x1fe>
c0104a6b:	68 83 9d 10 c0       	push   $0xc0109d83
c0104a70:	68 22 9c 10 c0       	push   $0xc0109c22
c0104a75:	6a 77                	push   $0x77
c0104a77:	68 37 9c 10 c0       	push   $0xc0109c37
c0104a7c:	e8 6f b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0104a81:	83 ec 0c             	sub    $0xc,%esp
c0104a84:	68 e0 9c 10 c0       	push   $0xc0109ce0
c0104a89:	e8 fc b7 ff ff       	call   c010028a <cprintf>
c0104a8e:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0104a91:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104a96:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0104a99:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a9e:	83 f8 09             	cmp    $0x9,%eax
c0104aa1:	74 16                	je     c0104ab9 <_fifo_check_swap+0x236>
c0104aa3:	68 92 9d 10 c0       	push   $0xc0109d92
c0104aa8:	68 22 9c 10 c0       	push   $0xc0109c22
c0104aad:	6a 7a                	push   $0x7a
c0104aaf:	68 37 9c 10 c0       	push   $0xc0109c37
c0104ab4:	e8 37 b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104ab9:	83 ec 0c             	sub    $0xc,%esp
c0104abc:	68 30 9d 10 c0       	push   $0xc0109d30
c0104ac1:	e8 c4 b7 ff ff       	call   c010028a <cprintf>
c0104ac6:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104ac9:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104ace:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0104ad1:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104ad6:	83 f8 0a             	cmp    $0xa,%eax
c0104ad9:	74 16                	je     c0104af1 <_fifo_check_swap+0x26e>
c0104adb:	68 a1 9d 10 c0       	push   $0xc0109da1
c0104ae0:	68 22 9c 10 c0       	push   $0xc0109c22
c0104ae5:	6a 7d                	push   $0x7d
c0104ae7:	68 37 9c 10 c0       	push   $0xc0109c37
c0104aec:	e8 ff b8 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104af1:	83 ec 0c             	sub    $0xc,%esp
c0104af4:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0104af9:	e8 8c b7 ff ff       	call   c010028a <cprintf>
c0104afe:	83 c4 10             	add    $0x10,%esp
    assert(*(unsigned char *)0x1000 == 0x0a);
c0104b01:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104b06:	0f b6 00             	movzbl (%eax),%eax
c0104b09:	3c 0a                	cmp    $0xa,%al
c0104b0b:	74 16                	je     c0104b23 <_fifo_check_swap+0x2a0>
c0104b0d:	68 b4 9d 10 c0       	push   $0xc0109db4
c0104b12:	68 22 9c 10 c0       	push   $0xc0109c22
c0104b17:	6a 7f                	push   $0x7f
c0104b19:	68 37 9c 10 c0       	push   $0xc0109c37
c0104b1e:	e8 cd b8 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0104b23:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104b28:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0104b2b:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b30:	83 f8 0b             	cmp    $0xb,%eax
c0104b33:	74 19                	je     c0104b4e <_fifo_check_swap+0x2cb>
c0104b35:	68 d5 9d 10 c0       	push   $0xc0109dd5
c0104b3a:	68 22 9c 10 c0       	push   $0xc0109c22
c0104b3f:	68 81 00 00 00       	push   $0x81
c0104b44:	68 37 9c 10 c0       	push   $0xc0109c37
c0104b49:	e8 a2 b8 ff ff       	call   c01003f0 <__panic>
    return 0;
c0104b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b53:	c9                   	leave  
c0104b54:	c3                   	ret    

c0104b55 <_fifo_init>:


static int
_fifo_init(void)
{
c0104b55:	55                   	push   %ebp
c0104b56:	89 e5                	mov    %esp,%ebp
    return 0;
c0104b58:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b5d:	5d                   	pop    %ebp
c0104b5e:	c3                   	ret    

c0104b5f <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104b5f:	55                   	push   %ebp
c0104b60:	89 e5                	mov    %esp,%ebp
    return 0;
c0104b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b67:	5d                   	pop    %ebp
c0104b68:	c3                   	ret    

c0104b69 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0104b69:	55                   	push   %ebp
c0104b6a:	89 e5                	mov    %esp,%ebp
c0104b6c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b71:	5d                   	pop    %ebp
c0104b72:	c3                   	ret    

c0104b73 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b73:	55                   	push   %ebp
c0104b74:	89 e5                	mov    %esp,%ebp
c0104b76:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0104b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b7c:	c1 e8 0c             	shr    $0xc,%eax
c0104b7f:	89 c2                	mov    %eax,%edx
c0104b81:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0104b86:	39 c2                	cmp    %eax,%edx
c0104b88:	72 14                	jb     c0104b9e <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0104b8a:	83 ec 04             	sub    $0x4,%esp
c0104b8d:	68 f8 9d 10 c0       	push   $0xc0109df8
c0104b92:	6a 5b                	push   $0x5b
c0104b94:	68 17 9e 10 c0       	push   $0xc0109e17
c0104b99:	e8 52 b8 ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0104b9e:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0104ba3:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ba6:	c1 ea 0c             	shr    $0xc,%edx
c0104ba9:	c1 e2 05             	shl    $0x5,%edx
c0104bac:	01 d0                	add    %edx,%eax
}
c0104bae:	c9                   	leave  
c0104baf:	c3                   	ret    

c0104bb0 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104bb0:	55                   	push   %ebp
c0104bb1:	89 e5                	mov    %esp,%ebp
c0104bb3:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0104bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bb9:	83 e0 01             	and    $0x1,%eax
c0104bbc:	85 c0                	test   %eax,%eax
c0104bbe:	75 14                	jne    c0104bd4 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0104bc0:	83 ec 04             	sub    $0x4,%esp
c0104bc3:	68 28 9e 10 c0       	push   $0xc0109e28
c0104bc8:	6a 6d                	push   $0x6d
c0104bca:	68 17 9e 10 c0       	push   $0xc0109e17
c0104bcf:	e8 1c b8 ff ff       	call   c01003f0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bdc:	83 ec 0c             	sub    $0xc,%esp
c0104bdf:	50                   	push   %eax
c0104be0:	e8 8e ff ff ff       	call   c0104b73 <pa2page>
c0104be5:	83 c4 10             	add    $0x10,%esp
}
c0104be8:	c9                   	leave  
c0104be9:	c3                   	ret    

c0104bea <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0104bea:	55                   	push   %ebp
c0104beb:	89 e5                	mov    %esp,%ebp
c0104bed:	83 ec 18             	sub    $0x18,%esp
    swapfs_init();
c0104bf0:	e8 dc 33 00 00       	call   c0107fd1 <swapfs_init>

    if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0104bf5:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0104bfa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0104bff:	76 0c                	jbe    c0104c0d <swap_init+0x23>
c0104c01:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0104c06:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0104c0b:	76 17                	jbe    c0104c24 <swap_init+0x3a>
    {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0104c0d:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0104c12:	50                   	push   %eax
c0104c13:	68 49 9e 10 c0       	push   $0xc0109e49
c0104c18:	6a 26                	push   $0x26
c0104c1a:	68 64 9e 10 c0       	push   $0xc0109e64
c0104c1f:	e8 cc b7 ff ff       	call   c01003f0 <__panic>
    }
     
    // LAB3: set sm as fifo
    // sm = &swap_manager_fifo;
    sm = &swap_manager_enclock;
c0104c24:	c7 05 70 4f 12 c0 00 	movl   $0xc0121a00,0xc0124f70
c0104c2b:	1a 12 c0 
    int r = sm->init();
c0104c2e:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c33:	8b 40 04             	mov    0x4(%eax),%eax
c0104c36:	ff d0                	call   *%eax
c0104c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    if (r == 0)
c0104c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c3f:	75 27                	jne    c0104c68 <swap_init+0x7e>
    {
        swap_init_ok = 1;
c0104c41:	c7 05 68 4f 12 c0 01 	movl   $0x1,0xc0124f68
c0104c48:	00 00 00 
        cprintf("SWAP: manager = %s\n", sm->name);
c0104c4b:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c50:	8b 00                	mov    (%eax),%eax
c0104c52:	83 ec 08             	sub    $0x8,%esp
c0104c55:	50                   	push   %eax
c0104c56:	68 73 9e 10 c0       	push   $0xc0109e73
c0104c5b:	e8 2a b6 ff ff       	call   c010028a <cprintf>
c0104c60:	83 c4 10             	add    $0x10,%esp
        check_swap();
c0104c63:	e8 f7 03 00 00       	call   c010505f <check_swap>
    }

    return r;
c0104c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104c6b:	c9                   	leave  
c0104c6c:	c3                   	ret    

c0104c6d <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0104c6d:	55                   	push   %ebp
c0104c6e:	89 e5                	mov    %esp,%ebp
c0104c70:	83 ec 08             	sub    $0x8,%esp
    return sm->init_mm(mm);
c0104c73:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c78:	8b 40 08             	mov    0x8(%eax),%eax
c0104c7b:	83 ec 0c             	sub    $0xc,%esp
c0104c7e:	ff 75 08             	pushl  0x8(%ebp)
c0104c81:	ff d0                	call   *%eax
c0104c83:	83 c4 10             	add    $0x10,%esp
}
c0104c86:	c9                   	leave  
c0104c87:	c3                   	ret    

c0104c88 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0104c88:	55                   	push   %ebp
c0104c89:	89 e5                	mov    %esp,%ebp
c0104c8b:	83 ec 08             	sub    $0x8,%esp
    return sm->tick_event(mm);
c0104c8e:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c93:	8b 40 0c             	mov    0xc(%eax),%eax
c0104c96:	83 ec 0c             	sub    $0xc,%esp
c0104c99:	ff 75 08             	pushl  0x8(%ebp)
c0104c9c:	ff d0                	call   *%eax
c0104c9e:	83 c4 10             	add    $0x10,%esp
}
c0104ca1:	c9                   	leave  
c0104ca2:	c3                   	ret    

c0104ca3 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104ca3:	55                   	push   %ebp
c0104ca4:	89 e5                	mov    %esp,%ebp
c0104ca6:	83 ec 08             	sub    $0x8,%esp
    return sm->map_swappable(mm, addr, page, swap_in);
c0104ca9:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104cae:	8b 40 10             	mov    0x10(%eax),%eax
c0104cb1:	ff 75 14             	pushl  0x14(%ebp)
c0104cb4:	ff 75 10             	pushl  0x10(%ebp)
c0104cb7:	ff 75 0c             	pushl  0xc(%ebp)
c0104cba:	ff 75 08             	pushl  0x8(%ebp)
c0104cbd:	ff d0                	call   *%eax
c0104cbf:	83 c4 10             	add    $0x10,%esp
}
c0104cc2:	c9                   	leave  
c0104cc3:	c3                   	ret    

c0104cc4 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104cc4:	55                   	push   %ebp
c0104cc5:	89 e5                	mov    %esp,%ebp
c0104cc7:	83 ec 08             	sub    $0x8,%esp
    return sm->set_unswappable(mm, addr);
c0104cca:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104ccf:	8b 40 14             	mov    0x14(%eax),%eax
c0104cd2:	83 ec 08             	sub    $0x8,%esp
c0104cd5:	ff 75 0c             	pushl  0xc(%ebp)
c0104cd8:	ff 75 08             	pushl  0x8(%ebp)
c0104cdb:	ff d0                	call   *%eax
c0104cdd:	83 c4 10             	add    $0x10,%esp
}
c0104ce0:	c9                   	leave  
c0104ce1:	c3                   	ret    

c0104ce2 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0104ce2:	55                   	push   %ebp
c0104ce3:	89 e5                	mov    %esp,%ebp
c0104ce5:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i != n; ++ i)
c0104ce8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104cef:	e9 2e 01 00 00       	jmp    c0104e22 <swap_out+0x140>
    {
        uintptr_t v;
        //struct Page **ptr_page=NULL;
        struct Page *page;
        // cprintf("i %d, SWAP: call swap_out_victim\n",i);
        int r = sm->swap_out_victim(mm, &page, in_tick);
c0104cf4:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104cf9:	8b 40 18             	mov    0x18(%eax),%eax
c0104cfc:	83 ec 04             	sub    $0x4,%esp
c0104cff:	ff 75 10             	pushl  0x10(%ebp)
c0104d02:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0104d05:	52                   	push   %edx
c0104d06:	ff 75 08             	pushl  0x8(%ebp)
c0104d09:	ff d0                	call   *%eax
c0104d0b:	83 c4 10             	add    $0x10,%esp
c0104d0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (r != 0) {
c0104d11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d15:	74 18                	je     c0104d2f <swap_out+0x4d>
            cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0104d17:	83 ec 08             	sub    $0x8,%esp
c0104d1a:	ff 75 f4             	pushl  -0xc(%ebp)
c0104d1d:	68 88 9e 10 c0       	push   $0xc0109e88
c0104d22:	e8 63 b5 ff ff       	call   c010028a <cprintf>
c0104d27:	83 c4 10             	add    $0x10,%esp
c0104d2a:	e9 ff 00 00 00       	jmp    c0104e2e <swap_out+0x14c>
        }          
        //assert(!PageReserved(page));

        //cprintf("SWAP: choose victim page 0x%08x\n", page);
        
        v=page->pra_vaddr; 
c0104d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d32:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
        pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0104d38:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d3b:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d3e:	83 ec 04             	sub    $0x4,%esp
c0104d41:	6a 00                	push   $0x0
c0104d43:	ff 75 ec             	pushl  -0x14(%ebp)
c0104d46:	50                   	push   %eax
c0104d47:	e8 39 22 00 00       	call   c0106f85 <get_pte>
c0104d4c:	83 c4 10             	add    $0x10,%esp
c0104d4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert((*ptep & PTE_P) != 0);
c0104d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d55:	8b 00                	mov    (%eax),%eax
c0104d57:	83 e0 01             	and    $0x1,%eax
c0104d5a:	85 c0                	test   %eax,%eax
c0104d5c:	75 16                	jne    c0104d74 <swap_out+0x92>
c0104d5e:	68 b5 9e 10 c0       	push   $0xc0109eb5
c0104d63:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104d68:	6a 67                	push   $0x67
c0104d6a:	68 64 9e 10 c0       	push   $0xc0109e64
c0104d6f:	e8 7c b6 ff ff       	call   c01003f0 <__panic>

        if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0104d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d7a:	8b 52 1c             	mov    0x1c(%edx),%edx
c0104d7d:	c1 ea 0c             	shr    $0xc,%edx
c0104d80:	83 c2 01             	add    $0x1,%edx
c0104d83:	c1 e2 08             	shl    $0x8,%edx
c0104d86:	83 ec 08             	sub    $0x8,%esp
c0104d89:	50                   	push   %eax
c0104d8a:	52                   	push   %edx
c0104d8b:	e8 dd 32 00 00       	call   c010806d <swapfs_write>
c0104d90:	83 c4 10             	add    $0x10,%esp
c0104d93:	85 c0                	test   %eax,%eax
c0104d95:	74 2b                	je     c0104dc2 <swap_out+0xe0>
            cprintf("SWAP: failed to save\n");
c0104d97:	83 ec 0c             	sub    $0xc,%esp
c0104d9a:	68 df 9e 10 c0       	push   $0xc0109edf
c0104d9f:	e8 e6 b4 ff ff       	call   c010028a <cprintf>
c0104da4:	83 c4 10             	add    $0x10,%esp
            sm->map_swappable(mm, v, page, 0);
c0104da7:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104dac:	8b 40 10             	mov    0x10(%eax),%eax
c0104daf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104db2:	6a 00                	push   $0x0
c0104db4:	52                   	push   %edx
c0104db5:	ff 75 ec             	pushl  -0x14(%ebp)
c0104db8:	ff 75 08             	pushl  0x8(%ebp)
c0104dbb:	ff d0                	call   *%eax
c0104dbd:	83 c4 10             	add    $0x10,%esp
c0104dc0:	eb 5c                	jmp    c0104e1e <swap_out+0x13c>
            continue;
        }
        else {
            cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0104dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dc5:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104dc8:	c1 e8 0c             	shr    $0xc,%eax
c0104dcb:	83 c0 01             	add    $0x1,%eax
c0104dce:	50                   	push   %eax
c0104dcf:	ff 75 ec             	pushl  -0x14(%ebp)
c0104dd2:	ff 75 f4             	pushl  -0xc(%ebp)
c0104dd5:	68 f8 9e 10 c0       	push   $0xc0109ef8
c0104dda:	e8 ab b4 ff ff       	call   c010028a <cprintf>
c0104ddf:	83 c4 10             	add    $0x10,%esp
            *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0104de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104de5:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104de8:	c1 e8 0c             	shr    $0xc,%eax
c0104deb:	83 c0 01             	add    $0x1,%eax
c0104dee:	c1 e0 08             	shl    $0x8,%eax
c0104df1:	89 c2                	mov    %eax,%edx
c0104df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104df6:	89 10                	mov    %edx,(%eax)
            free_page(page);
c0104df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dfb:	83 ec 08             	sub    $0x8,%esp
c0104dfe:	6a 01                	push   $0x1
c0104e00:	50                   	push   %eax
c0104e01:	e8 84 1b 00 00       	call   c010698a <free_pages>
c0104e06:	83 c4 10             	add    $0x10,%esp
        }
        
        tlb_invalidate(mm->pgdir, v);
c0104e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e0c:	8b 40 0c             	mov    0xc(%eax),%eax
c0104e0f:	83 ec 08             	sub    $0x8,%esp
c0104e12:	ff 75 ec             	pushl  -0x14(%ebp)
c0104e15:	50                   	push   %eax
c0104e16:	e8 62 24 00 00       	call   c010727d <tlb_invalidate>
c0104e1b:	83 c4 10             	add    $0x10,%esp

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
    int i;
    for (i = 0; i != n; ++ i)
c0104e1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e25:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e28:	0f 85 c6 fe ff ff    	jne    c0104cf4 <swap_out+0x12>
            free_page(page);
        }
        
        tlb_invalidate(mm->pgdir, v);
    }
    return i;
c0104e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104e31:	c9                   	leave  
c0104e32:	c3                   	ret    

c0104e33 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0104e33:	55                   	push   %ebp
c0104e34:	89 e5                	mov    %esp,%ebp
c0104e36:	83 ec 18             	sub    $0x18,%esp
    struct Page *result = alloc_page();
c0104e39:	83 ec 0c             	sub    $0xc,%esp
c0104e3c:	6a 01                	push   $0x1
c0104e3e:	e8 db 1a 00 00       	call   c010691e <alloc_pages>
c0104e43:	83 c4 10             	add    $0x10,%esp
c0104e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(result!=NULL);
c0104e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e4d:	75 16                	jne    c0104e65 <swap_in+0x32>
c0104e4f:	68 38 9f 10 c0       	push   $0xc0109f38
c0104e54:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104e59:	6a 7d                	push   $0x7d
c0104e5b:	68 64 9e 10 c0       	push   $0xc0109e64
c0104e60:	e8 8b b5 ff ff       	call   c01003f0 <__panic>

    pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0104e65:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e68:	8b 40 0c             	mov    0xc(%eax),%eax
c0104e6b:	83 ec 04             	sub    $0x4,%esp
c0104e6e:	6a 00                	push   $0x0
c0104e70:	ff 75 0c             	pushl  0xc(%ebp)
c0104e73:	50                   	push   %eax
c0104e74:	e8 0c 21 00 00       	call   c0106f85 <get_pte>
c0104e79:	83 c4 10             	add    $0x10,%esp
c0104e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));

    int r;
    if ((r = swapfs_read((*ptep), result)) != 0)
c0104e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e82:	8b 00                	mov    (%eax),%eax
c0104e84:	83 ec 08             	sub    $0x8,%esp
c0104e87:	ff 75 f4             	pushl  -0xc(%ebp)
c0104e8a:	50                   	push   %eax
c0104e8b:	e8 84 31 00 00       	call   c0108014 <swapfs_read>
c0104e90:	83 c4 10             	add    $0x10,%esp
c0104e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e9a:	74 1f                	je     c0104ebb <swap_in+0x88>
    {
        assert(r!=0);
c0104e9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104ea0:	75 19                	jne    c0104ebb <swap_in+0x88>
c0104ea2:	68 45 9f 10 c0       	push   $0xc0109f45
c0104ea7:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104eac:	68 85 00 00 00       	push   $0x85
c0104eb1:	68 64 9e 10 c0       	push   $0xc0109e64
c0104eb6:	e8 35 b5 ff ff       	call   c01003f0 <__panic>
    }
    cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0104ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ebe:	8b 00                	mov    (%eax),%eax
c0104ec0:	c1 e8 08             	shr    $0x8,%eax
c0104ec3:	83 ec 04             	sub    $0x4,%esp
c0104ec6:	ff 75 0c             	pushl  0xc(%ebp)
c0104ec9:	50                   	push   %eax
c0104eca:	68 4c 9f 10 c0       	push   $0xc0109f4c
c0104ecf:	e8 b6 b3 ff ff       	call   c010028a <cprintf>
c0104ed4:	83 c4 10             	add    $0x10,%esp
    *ptr_result=result;
c0104ed7:	8b 45 10             	mov    0x10(%ebp),%eax
c0104eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104edd:	89 10                	mov    %edx,(%eax)
    return 0;
c0104edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ee4:	c9                   	leave  
c0104ee5:	c3                   	ret    

c0104ee6 <check_content_set>:



static inline void
check_content_set(void)
{
c0104ee6:	55                   	push   %ebp
c0104ee7:	89 e5                	mov    %esp,%ebp
c0104ee9:	83 ec 08             	sub    $0x8,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0104eec:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104ef1:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==1);
c0104ef4:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104ef9:	83 f8 01             	cmp    $0x1,%eax
c0104efc:	74 19                	je     c0104f17 <check_content_set+0x31>
c0104efe:	68 8a 9f 10 c0       	push   $0xc0109f8a
c0104f03:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104f08:	68 92 00 00 00       	push   $0x92
c0104f0d:	68 64 9e 10 c0       	push   $0xc0109e64
c0104f12:	e8 d9 b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x1010 = 0x0a;
c0104f17:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104f1c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==1);
c0104f1f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104f24:	83 f8 01             	cmp    $0x1,%eax
c0104f27:	74 19                	je     c0104f42 <check_content_set+0x5c>
c0104f29:	68 8a 9f 10 c0       	push   $0xc0109f8a
c0104f2e:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104f33:	68 94 00 00 00       	push   $0x94
c0104f38:	68 64 9e 10 c0       	push   $0xc0109e64
c0104f3d:	e8 ae b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x2000 = 0x0b;
c0104f42:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104f47:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==2);
c0104f4a:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104f4f:	83 f8 02             	cmp    $0x2,%eax
c0104f52:	74 19                	je     c0104f6d <check_content_set+0x87>
c0104f54:	68 99 9f 10 c0       	push   $0xc0109f99
c0104f59:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104f5e:	68 96 00 00 00       	push   $0x96
c0104f63:	68 64 9e 10 c0       	push   $0xc0109e64
c0104f68:	e8 83 b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x2010 = 0x0b;
c0104f6d:	b8 10 20 00 00       	mov    $0x2010,%eax
c0104f72:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==2);
c0104f75:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104f7a:	83 f8 02             	cmp    $0x2,%eax
c0104f7d:	74 19                	je     c0104f98 <check_content_set+0xb2>
c0104f7f:	68 99 9f 10 c0       	push   $0xc0109f99
c0104f84:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104f89:	68 98 00 00 00       	push   $0x98
c0104f8e:	68 64 9e 10 c0       	push   $0xc0109e64
c0104f93:	e8 58 b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x3000 = 0x0c;
c0104f98:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104f9d:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==3);
c0104fa0:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104fa5:	83 f8 03             	cmp    $0x3,%eax
c0104fa8:	74 19                	je     c0104fc3 <check_content_set+0xdd>
c0104faa:	68 a8 9f 10 c0       	push   $0xc0109fa8
c0104faf:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104fb4:	68 9a 00 00 00       	push   $0x9a
c0104fb9:	68 64 9e 10 c0       	push   $0xc0109e64
c0104fbe:	e8 2d b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x3010 = 0x0c;
c0104fc3:	b8 10 30 00 00       	mov    $0x3010,%eax
c0104fc8:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==3);
c0104fcb:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104fd0:	83 f8 03             	cmp    $0x3,%eax
c0104fd3:	74 19                	je     c0104fee <check_content_set+0x108>
c0104fd5:	68 a8 9f 10 c0       	push   $0xc0109fa8
c0104fda:	68 ca 9e 10 c0       	push   $0xc0109eca
c0104fdf:	68 9c 00 00 00       	push   $0x9c
c0104fe4:	68 64 9e 10 c0       	push   $0xc0109e64
c0104fe9:	e8 02 b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x4000 = 0x0d;
c0104fee:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104ff3:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0104ff6:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104ffb:	83 f8 04             	cmp    $0x4,%eax
c0104ffe:	74 19                	je     c0105019 <check_content_set+0x133>
c0105000:	68 b7 9f 10 c0       	push   $0xc0109fb7
c0105005:	68 ca 9e 10 c0       	push   $0xc0109eca
c010500a:	68 9e 00 00 00       	push   $0x9e
c010500f:	68 64 9e 10 c0       	push   $0xc0109e64
c0105014:	e8 d7 b3 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x4010 = 0x0d;
c0105019:	b8 10 40 00 00       	mov    $0x4010,%eax
c010501e:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0105021:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105026:	83 f8 04             	cmp    $0x4,%eax
c0105029:	74 19                	je     c0105044 <check_content_set+0x15e>
c010502b:	68 b7 9f 10 c0       	push   $0xc0109fb7
c0105030:	68 ca 9e 10 c0       	push   $0xc0109eca
c0105035:	68 a0 00 00 00       	push   $0xa0
c010503a:	68 64 9e 10 c0       	push   $0xc0109e64
c010503f:	e8 ac b3 ff ff       	call   c01003f0 <__panic>
}
c0105044:	90                   	nop
c0105045:	c9                   	leave  
c0105046:	c3                   	ret    

c0105047 <check_content_access>:

static inline int
check_content_access(void)
{
c0105047:	55                   	push   %ebp
c0105048:	89 e5                	mov    %esp,%ebp
c010504a:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010504d:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0105052:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105055:	ff d0                	call   *%eax
c0105057:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010505a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010505d:	c9                   	leave  
c010505e:	c3                   	ret    

c010505f <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c010505f:	55                   	push   %ebp
c0105060:	89 e5                	mov    %esp,%ebp
c0105062:	83 ec 68             	sub    $0x68,%esp
    //backup mem env
    int ret, count = 0, total = 0, i;
c0105065:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010506c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105073:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010507a:	eb 60                	jmp    c01050dc <check_swap+0x7d>
    struct Page *p = le2page(le, page_link);
c010507c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010507f:	83 e8 0c             	sub    $0xc,%eax
c0105082:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(PageProperty(p));
c0105085:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105088:	83 c0 04             	add    $0x4,%eax
c010508b:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105092:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105095:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105098:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010509b:	0f a3 10             	bt     %edx,(%eax)
c010509e:	19 c0                	sbb    %eax,%eax
c01050a0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c01050a3:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c01050a7:	0f 95 c0             	setne  %al
c01050aa:	0f b6 c0             	movzbl %al,%eax
c01050ad:	85 c0                	test   %eax,%eax
c01050af:	75 19                	jne    c01050ca <check_swap+0x6b>
c01050b1:	68 c6 9f 10 c0       	push   $0xc0109fc6
c01050b6:	68 ca 9e 10 c0       	push   $0xc0109eca
c01050bb:	68 bb 00 00 00       	push   $0xbb
c01050c0:	68 64 9e 10 c0       	push   $0xc0109e64
c01050c5:	e8 26 b3 ff ff       	call   c01003f0 <__panic>
    count ++, total += p->property;
c01050ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01050ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050d1:	8b 50 08             	mov    0x8(%eax),%edx
c01050d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050d7:	01 d0                	add    %edx,%eax
c01050d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050df:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01050e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050e5:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
    int ret, count = 0, total = 0, i;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01050e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050eb:	81 7d e8 44 51 12 c0 	cmpl   $0xc0125144,-0x18(%ebp)
c01050f2:	75 88                	jne    c010507c <check_swap+0x1d>
    struct Page *p = le2page(le, page_link);
    assert(PageProperty(p));
    count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01050f4:	e8 c6 18 00 00       	call   c01069bf <nr_free_pages>
c01050f9:	89 c2                	mov    %eax,%edx
c01050fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050fe:	39 c2                	cmp    %eax,%edx
c0105100:	74 19                	je     c010511b <check_swap+0xbc>
c0105102:	68 d6 9f 10 c0       	push   $0xc0109fd6
c0105107:	68 ca 9e 10 c0       	push   $0xc0109eca
c010510c:	68 be 00 00 00       	push   $0xbe
c0105111:	68 64 9e 10 c0       	push   $0xc0109e64
c0105116:	e8 d5 b2 ff ff       	call   c01003f0 <__panic>
    cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010511b:	83 ec 04             	sub    $0x4,%esp
c010511e:	ff 75 f0             	pushl  -0x10(%ebp)
c0105121:	ff 75 f4             	pushl  -0xc(%ebp)
c0105124:	68 f0 9f 10 c0       	push   $0xc0109ff0
c0105129:	e8 5c b1 ff ff       	call   c010028a <cprintf>
c010512e:	83 c4 10             	add    $0x10,%esp
    
    //now we set the phy pages env     
    struct mm_struct *mm = mm_create();
c0105131:	e8 58 e9 ff ff       	call   c0103a8e <mm_create>
c0105136:	89 45 d8             	mov    %eax,-0x28(%ebp)
    assert(mm != NULL);
c0105139:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010513d:	75 19                	jne    c0105158 <check_swap+0xf9>
c010513f:	68 16 a0 10 c0       	push   $0xc010a016
c0105144:	68 ca 9e 10 c0       	push   $0xc0109eca
c0105149:	68 c3 00 00 00       	push   $0xc3
c010514e:	68 64 9e 10 c0       	push   $0xc0109e64
c0105153:	e8 98 b2 ff ff       	call   c01003f0 <__panic>

    extern struct mm_struct *check_mm_struct;
    assert(check_mm_struct == NULL);
c0105158:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c010515d:	85 c0                	test   %eax,%eax
c010515f:	74 19                	je     c010517a <check_swap+0x11b>
c0105161:	68 21 a0 10 c0       	push   $0xc010a021
c0105166:	68 ca 9e 10 c0       	push   $0xc0109eca
c010516b:	68 c6 00 00 00       	push   $0xc6
c0105170:	68 64 9e 10 c0       	push   $0xc0109e64
c0105175:	e8 76 b2 ff ff       	call   c01003f0 <__panic>

    check_mm_struct = mm;
c010517a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010517d:	a3 7c 50 12 c0       	mov    %eax,0xc012507c

    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0105182:	8b 15 40 1a 12 c0    	mov    0xc0121a40,%edx
c0105188:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010518b:	89 50 0c             	mov    %edx,0xc(%eax)
c010518e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105191:	8b 40 0c             	mov    0xc(%eax),%eax
c0105194:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    assert(pgdir[0] == 0);
c0105197:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010519a:	8b 00                	mov    (%eax),%eax
c010519c:	85 c0                	test   %eax,%eax
c010519e:	74 19                	je     c01051b9 <check_swap+0x15a>
c01051a0:	68 39 a0 10 c0       	push   $0xc010a039
c01051a5:	68 ca 9e 10 c0       	push   $0xc0109eca
c01051aa:	68 cb 00 00 00       	push   $0xcb
c01051af:	68 64 9e 10 c0       	push   $0xc0109e64
c01051b4:	e8 37 b2 ff ff       	call   c01003f0 <__panic>

    struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01051b9:	83 ec 04             	sub    $0x4,%esp
c01051bc:	6a 03                	push   $0x3
c01051be:	68 00 60 00 00       	push   $0x6000
c01051c3:	68 00 10 00 00       	push   $0x1000
c01051c8:	e8 3d e9 ff ff       	call   c0103b0a <vma_create>
c01051cd:	83 c4 10             	add    $0x10,%esp
c01051d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    assert(vma != NULL);
c01051d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01051d7:	75 19                	jne    c01051f2 <check_swap+0x193>
c01051d9:	68 47 a0 10 c0       	push   $0xc010a047
c01051de:	68 ca 9e 10 c0       	push   $0xc0109eca
c01051e3:	68 ce 00 00 00       	push   $0xce
c01051e8:	68 64 9e 10 c0       	push   $0xc0109e64
c01051ed:	e8 fe b1 ff ff       	call   c01003f0 <__panic>

    insert_vma_struct(mm, vma);
c01051f2:	83 ec 08             	sub    $0x8,%esp
c01051f5:	ff 75 d0             	pushl  -0x30(%ebp)
c01051f8:	ff 75 d8             	pushl  -0x28(%ebp)
c01051fb:	e8 72 ea ff ff       	call   c0103c72 <insert_vma_struct>
c0105200:	83 c4 10             	add    $0x10,%esp

    //setup the temp Page Table vaddr 0~4MB
    cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0105203:	83 ec 0c             	sub    $0xc,%esp
c0105206:	68 54 a0 10 c0       	push   $0xc010a054
c010520b:	e8 7a b0 ff ff       	call   c010028a <cprintf>
c0105210:	83 c4 10             	add    $0x10,%esp
    pte_t *temp_ptep=NULL;
c0105213:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
    temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010521a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010521d:	8b 40 0c             	mov    0xc(%eax),%eax
c0105220:	83 ec 04             	sub    $0x4,%esp
c0105223:	6a 01                	push   $0x1
c0105225:	68 00 10 00 00       	push   $0x1000
c010522a:	50                   	push   %eax
c010522b:	e8 55 1d 00 00       	call   c0106f85 <get_pte>
c0105230:	83 c4 10             	add    $0x10,%esp
c0105233:	89 45 cc             	mov    %eax,-0x34(%ebp)
    assert(temp_ptep!= NULL);
c0105236:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010523a:	75 19                	jne    c0105255 <check_swap+0x1f6>
c010523c:	68 88 a0 10 c0       	push   $0xc010a088
c0105241:	68 ca 9e 10 c0       	push   $0xc0109eca
c0105246:	68 d6 00 00 00       	push   $0xd6
c010524b:	68 64 9e 10 c0       	push   $0xc0109e64
c0105250:	e8 9b b1 ff ff       	call   c01003f0 <__panic>
    cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0105255:	83 ec 0c             	sub    $0xc,%esp
c0105258:	68 9c a0 10 c0       	push   $0xc010a09c
c010525d:	e8 28 b0 ff ff       	call   c010028a <cprintf>
c0105262:	83 c4 10             	add    $0x10,%esp
    
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105265:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010526c:	e9 90 00 00 00       	jmp    c0105301 <check_swap+0x2a2>
        check_rp[i] = alloc_page();
c0105271:	83 ec 0c             	sub    $0xc,%esp
c0105274:	6a 01                	push   $0x1
c0105276:	e8 a3 16 00 00       	call   c010691e <alloc_pages>
c010527b:	83 c4 10             	add    $0x10,%esp
c010527e:	89 c2                	mov    %eax,%edx
c0105280:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105283:	89 14 85 80 50 12 c0 	mov    %edx,-0x3fedaf80(,%eax,4)
        assert(check_rp[i] != NULL );
c010528a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010528d:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c0105294:	85 c0                	test   %eax,%eax
c0105296:	75 19                	jne    c01052b1 <check_swap+0x252>
c0105298:	68 c0 a0 10 c0       	push   $0xc010a0c0
c010529d:	68 ca 9e 10 c0       	push   $0xc0109eca
c01052a2:	68 db 00 00 00       	push   $0xdb
c01052a7:	68 64 9e 10 c0       	push   $0xc0109e64
c01052ac:	e8 3f b1 ff ff       	call   c01003f0 <__panic>
        assert(!PageProperty(check_rp[i]));
c01052b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052b4:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c01052bb:	83 c0 04             	add    $0x4,%eax
c01052be:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01052c5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01052cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052ce:	0f a3 10             	bt     %edx,(%eax)
c01052d1:	19 c0                	sbb    %eax,%eax
c01052d3:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c01052d6:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c01052da:	0f 95 c0             	setne  %al
c01052dd:	0f b6 c0             	movzbl %al,%eax
c01052e0:	85 c0                	test   %eax,%eax
c01052e2:	74 19                	je     c01052fd <check_swap+0x29e>
c01052e4:	68 d4 a0 10 c0       	push   $0xc010a0d4
c01052e9:	68 ca 9e 10 c0       	push   $0xc0109eca
c01052ee:	68 dc 00 00 00       	push   $0xdc
c01052f3:	68 64 9e 10 c0       	push   $0xc0109e64
c01052f8:	e8 f3 b0 ff ff       	call   c01003f0 <__panic>
    pte_t *temp_ptep=NULL;
    temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
    assert(temp_ptep!= NULL);
    cprintf("setup Page Table vaddr 0~4MB OVER!\n");
    
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01052fd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105301:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105305:	0f 8e 66 ff ff ff    	jle    c0105271 <check_swap+0x212>
        check_rp[i] = alloc_page();
        assert(check_rp[i] != NULL );
        assert(!PageProperty(check_rp[i]));
    }
    list_entry_t free_list_store = free_list;
c010530b:	a1 44 51 12 c0       	mov    0xc0125144,%eax
c0105310:	8b 15 48 51 12 c0    	mov    0xc0125148,%edx
c0105316:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105319:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010531c:	c7 45 c0 44 51 12 c0 	movl   $0xc0125144,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105323:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105326:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105329:	89 50 04             	mov    %edx,0x4(%eax)
c010532c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010532f:	8b 50 04             	mov    0x4(%eax),%edx
c0105332:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105335:	89 10                	mov    %edx,(%eax)
c0105337:	c7 45 c8 44 51 12 c0 	movl   $0xc0125144,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010533e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105341:	8b 40 04             	mov    0x4(%eax),%eax
c0105344:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c0105347:	0f 94 c0             	sete   %al
c010534a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010534d:	85 c0                	test   %eax,%eax
c010534f:	75 19                	jne    c010536a <check_swap+0x30b>
c0105351:	68 ef a0 10 c0       	push   $0xc010a0ef
c0105356:	68 ca 9e 10 c0       	push   $0xc0109eca
c010535b:	68 e0 00 00 00       	push   $0xe0
c0105360:	68 64 9e 10 c0       	push   $0xc0109e64
c0105365:	e8 86 b0 ff ff       	call   c01003f0 <__panic>
    
    //assert(alloc_page() == NULL);
    
    unsigned int nr_free_store = nr_free;
c010536a:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c010536f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    nr_free = 0;
c0105372:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c0105379:	00 00 00 
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010537c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105383:	eb 1c                	jmp    c01053a1 <check_swap+0x342>
    free_pages(check_rp[i],1);
c0105385:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105388:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c010538f:	83 ec 08             	sub    $0x8,%esp
c0105392:	6a 01                	push   $0x1
c0105394:	50                   	push   %eax
c0105395:	e8 f0 15 00 00       	call   c010698a <free_pages>
c010539a:	83 c4 10             	add    $0x10,%esp
    
    //assert(alloc_page() == NULL);
    
    unsigned int nr_free_store = nr_free;
    nr_free = 0;
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010539d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01053a1:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01053a5:	7e de                	jle    c0105385 <check_swap+0x326>
    free_pages(check_rp[i],1);
    }
    assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01053a7:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c01053ac:	83 f8 04             	cmp    $0x4,%eax
c01053af:	74 19                	je     c01053ca <check_swap+0x36b>
c01053b1:	68 08 a1 10 c0       	push   $0xc010a108
c01053b6:	68 ca 9e 10 c0       	push   $0xc0109eca
c01053bb:	68 e9 00 00 00       	push   $0xe9
c01053c0:	68 64 9e 10 c0       	push   $0xc0109e64
c01053c5:	e8 26 b0 ff ff       	call   c01003f0 <__panic>
    
    cprintf("set up init env for check_swap begin!\n");
c01053ca:	83 ec 0c             	sub    $0xc,%esp
c01053cd:	68 2c a1 10 c0       	push   $0xc010a12c
c01053d2:	e8 b3 ae ff ff       	call   c010028a <cprintf>
c01053d7:	83 c4 10             	add    $0x10,%esp
    //setup initial vir_page<->phy_page environment for page relpacement algorithm 

    
    pgfault_num=0;
c01053da:	c7 05 64 4f 12 c0 00 	movl   $0x0,0xc0124f64
c01053e1:	00 00 00 
    
    check_content_set();
c01053e4:	e8 fd fa ff ff       	call   c0104ee6 <check_content_set>
    assert( nr_free == 0);         
c01053e9:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c01053ee:	85 c0                	test   %eax,%eax
c01053f0:	74 19                	je     c010540b <check_swap+0x3ac>
c01053f2:	68 53 a1 10 c0       	push   $0xc010a153
c01053f7:	68 ca 9e 10 c0       	push   $0xc0109eca
c01053fc:	68 f2 00 00 00       	push   $0xf2
c0105401:	68 64 9e 10 c0       	push   $0xc0109e64
c0105406:	e8 e5 af ff ff       	call   c01003f0 <__panic>
    for(i = 0; i<MAX_SEQ_NO ; i++) 
c010540b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105412:	eb 26                	jmp    c010543a <check_swap+0x3db>
        swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0105414:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105417:	c7 04 85 a0 50 12 c0 	movl   $0xffffffff,-0x3fedaf60(,%eax,4)
c010541e:	ff ff ff ff 
c0105422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105425:	8b 14 85 a0 50 12 c0 	mov    -0x3fedaf60(,%eax,4),%edx
c010542c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010542f:	89 14 85 e0 50 12 c0 	mov    %edx,-0x3fedaf20(,%eax,4)
    
    pgfault_num=0;
    
    check_content_set();
    assert( nr_free == 0);         
    for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105436:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010543a:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c010543e:	7e d4                	jle    c0105414 <check_swap+0x3b5>
        swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
    
    for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105440:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105447:	e9 cc 00 00 00       	jmp    c0105518 <check_swap+0x4b9>
        check_ptep[i]=0;
c010544c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010544f:	c7 04 85 34 51 12 c0 	movl   $0x0,-0x3fedaecc(,%eax,4)
c0105456:	00 00 00 00 
        check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c010545a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010545d:	83 c0 01             	add    $0x1,%eax
c0105460:	c1 e0 0c             	shl    $0xc,%eax
c0105463:	83 ec 04             	sub    $0x4,%esp
c0105466:	6a 00                	push   $0x0
c0105468:	50                   	push   %eax
c0105469:	ff 75 d4             	pushl  -0x2c(%ebp)
c010546c:	e8 14 1b 00 00       	call   c0106f85 <get_pte>
c0105471:	83 c4 10             	add    $0x10,%esp
c0105474:	89 c2                	mov    %eax,%edx
c0105476:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105479:	89 14 85 34 51 12 c0 	mov    %edx,-0x3fedaecc(,%eax,4)
        //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
        assert(check_ptep[i] != NULL);
c0105480:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105483:	8b 04 85 34 51 12 c0 	mov    -0x3fedaecc(,%eax,4),%eax
c010548a:	85 c0                	test   %eax,%eax
c010548c:	75 19                	jne    c01054a7 <check_swap+0x448>
c010548e:	68 60 a1 10 c0       	push   $0xc010a160
c0105493:	68 ca 9e 10 c0       	push   $0xc0109eca
c0105498:	68 fa 00 00 00       	push   $0xfa
c010549d:	68 64 9e 10 c0       	push   $0xc0109e64
c01054a2:	e8 49 af ff ff       	call   c01003f0 <__panic>
        assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01054a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054aa:	8b 04 85 34 51 12 c0 	mov    -0x3fedaecc(,%eax,4),%eax
c01054b1:	8b 00                	mov    (%eax),%eax
c01054b3:	83 ec 0c             	sub    $0xc,%esp
c01054b6:	50                   	push   %eax
c01054b7:	e8 f4 f6 ff ff       	call   c0104bb0 <pte2page>
c01054bc:	83 c4 10             	add    $0x10,%esp
c01054bf:	89 c2                	mov    %eax,%edx
c01054c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054c4:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c01054cb:	39 c2                	cmp    %eax,%edx
c01054cd:	74 19                	je     c01054e8 <check_swap+0x489>
c01054cf:	68 78 a1 10 c0       	push   $0xc010a178
c01054d4:	68 ca 9e 10 c0       	push   $0xc0109eca
c01054d9:	68 fb 00 00 00       	push   $0xfb
c01054de:	68 64 9e 10 c0       	push   $0xc0109e64
c01054e3:	e8 08 af ff ff       	call   c01003f0 <__panic>
        assert((*check_ptep[i] & PTE_P));          
c01054e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054eb:	8b 04 85 34 51 12 c0 	mov    -0x3fedaecc(,%eax,4),%eax
c01054f2:	8b 00                	mov    (%eax),%eax
c01054f4:	83 e0 01             	and    $0x1,%eax
c01054f7:	85 c0                	test   %eax,%eax
c01054f9:	75 19                	jne    c0105514 <check_swap+0x4b5>
c01054fb:	68 a0 a1 10 c0       	push   $0xc010a1a0
c0105500:	68 ca 9e 10 c0       	push   $0xc0109eca
c0105505:	68 fc 00 00 00       	push   $0xfc
c010550a:	68 64 9e 10 c0       	push   $0xc0109e64
c010550f:	e8 dc ae ff ff       	call   c01003f0 <__panic>
    check_content_set();
    assert( nr_free == 0);         
    for(i = 0; i<MAX_SEQ_NO ; i++) 
        swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
    
    for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105514:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105518:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010551c:	0f 8e 2a ff ff ff    	jle    c010544c <check_swap+0x3ed>
        //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
        assert(check_ptep[i] != NULL);
        assert(pte2page(*check_ptep[i]) == check_rp[i]);
        assert((*check_ptep[i] & PTE_P));          
    }
    cprintf("set up init env for check_swap over!\n");
c0105522:	83 ec 0c             	sub    $0xc,%esp
c0105525:	68 bc a1 10 c0       	push   $0xc010a1bc
c010552a:	e8 5b ad ff ff       	call   c010028a <cprintf>
c010552f:	83 c4 10             	add    $0x10,%esp
    // now access the virt pages to test  page relpacement algorithm 
    ret=check_content_access();
c0105532:	e8 10 fb ff ff       	call   c0105047 <check_content_access>
c0105537:	89 45 b8             	mov    %eax,-0x48(%ebp)
    assert(ret==0);
c010553a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010553e:	74 19                	je     c0105559 <check_swap+0x4fa>
c0105540:	68 e2 a1 10 c0       	push   $0xc010a1e2
c0105545:	68 ca 9e 10 c0       	push   $0xc0109eca
c010554a:	68 01 01 00 00       	push   $0x101
c010554f:	68 64 9e 10 c0       	push   $0xc0109e64
c0105554:	e8 97 ae ff ff       	call   c01003f0 <__panic>
    
    //restore kernel mem env
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105559:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105560:	eb 1c                	jmp    c010557e <check_swap+0x51f>
        free_pages(check_rp[i],1);
c0105562:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105565:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c010556c:	83 ec 08             	sub    $0x8,%esp
c010556f:	6a 01                	push   $0x1
c0105571:	50                   	push   %eax
c0105572:	e8 13 14 00 00       	call   c010698a <free_pages>
c0105577:	83 c4 10             	add    $0x10,%esp
    // now access the virt pages to test  page relpacement algorithm 
    ret=check_content_access();
    assert(ret==0);
    
    //restore kernel mem env
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010557a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010557e:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105582:	7e de                	jle    c0105562 <check_swap+0x503>
        free_pages(check_rp[i],1);
    } 

    //free_page(pte2page(*temp_ptep));
    
    mm_destroy(mm);
c0105584:	83 ec 0c             	sub    $0xc,%esp
c0105587:	ff 75 d8             	pushl  -0x28(%ebp)
c010558a:	e8 07 e8 ff ff       	call   c0103d96 <mm_destroy>
c010558f:	83 c4 10             	add    $0x10,%esp
        
    nr_free = nr_free_store;
c0105592:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105595:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
    free_list = free_list_store;
c010559a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010559d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01055a0:	a3 44 51 12 c0       	mov    %eax,0xc0125144
c01055a5:	89 15 48 51 12 c0    	mov    %edx,0xc0125148

    
    le = &free_list;
c01055ab:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01055b2:	eb 1d                	jmp    c01055d1 <check_swap+0x572>
        struct Page *p = le2page(le, page_link);
c01055b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055b7:	83 e8 0c             	sub    $0xc,%eax
c01055ba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c01055bd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01055c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01055c4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01055c7:	8b 40 08             	mov    0x8(%eax),%eax
c01055ca:	29 c2                	sub    %eax,%edx
c01055cc:	89 d0                	mov    %edx,%eax
c01055ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01055d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01055da:	8b 40 04             	mov    0x4(%eax),%eax
    nr_free = nr_free_store;
    free_list = free_list_store;

    
    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01055dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055e0:	81 7d e8 44 51 12 c0 	cmpl   $0xc0125144,-0x18(%ebp)
c01055e7:	75 cb                	jne    c01055b4 <check_swap+0x555>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    cprintf("count is %d, total is %d\n",count,total);
c01055e9:	83 ec 04             	sub    $0x4,%esp
c01055ec:	ff 75 f0             	pushl  -0x10(%ebp)
c01055ef:	ff 75 f4             	pushl  -0xc(%ebp)
c01055f2:	68 e9 a1 10 c0       	push   $0xc010a1e9
c01055f7:	e8 8e ac ff ff       	call   c010028a <cprintf>
c01055fc:	83 c4 10             	add    $0x10,%esp
    //assert(count == 0);
    
    cprintf("check_swap() succeeded!\n");
c01055ff:	83 ec 0c             	sub    $0xc,%esp
c0105602:	68 03 a2 10 c0       	push   $0xc010a203
c0105607:	e8 7e ac ff ff       	call   c010028a <cprintf>
c010560c:	83 c4 10             	add    $0x10,%esp
}
c010560f:	90                   	nop
c0105610:	c9                   	leave  
c0105611:	c3                   	ret    

c0105612 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0105612:	55                   	push   %ebp
c0105613:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0105615:	8b 45 08             	mov    0x8(%ebp),%eax
c0105618:	8b 15 58 51 12 c0    	mov    0xc0125158,%edx
c010561e:	29 d0                	sub    %edx,%eax
c0105620:	c1 f8 05             	sar    $0x5,%eax
}
c0105623:	5d                   	pop    %ebp
c0105624:	c3                   	ret    

c0105625 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0105625:	55                   	push   %ebp
c0105626:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0105628:	ff 75 08             	pushl  0x8(%ebp)
c010562b:	e8 e2 ff ff ff       	call   c0105612 <page2ppn>
c0105630:	83 c4 04             	add    $0x4,%esp
c0105633:	c1 e0 0c             	shl    $0xc,%eax
}
c0105636:	c9                   	leave  
c0105637:	c3                   	ret    

c0105638 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0105638:	55                   	push   %ebp
c0105639:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010563b:	8b 45 08             	mov    0x8(%ebp),%eax
c010563e:	8b 00                	mov    (%eax),%eax
}
c0105640:	5d                   	pop    %ebp
c0105641:	c3                   	ret    

c0105642 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0105642:	55                   	push   %ebp
c0105643:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105645:	8b 45 08             	mov    0x8(%ebp),%eax
c0105648:	8b 55 0c             	mov    0xc(%ebp),%edx
c010564b:	89 10                	mov    %edx,(%eax)
}
c010564d:	90                   	nop
c010564e:	5d                   	pop    %ebp
c010564f:	c3                   	ret    

c0105650 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0105650:	55                   	push   %ebp
c0105651:	89 e5                	mov    %esp,%ebp
c0105653:	83 ec 10             	sub    $0x10,%esp
c0105656:	c7 45 fc 44 51 12 c0 	movl   $0xc0125144,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010565d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105660:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0105663:	89 50 04             	mov    %edx,0x4(%eax)
c0105666:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105669:	8b 50 04             	mov    0x4(%eax),%edx
c010566c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010566f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0105671:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c0105678:	00 00 00 
}
c010567b:	90                   	nop
c010567c:	c9                   	leave  
c010567d:	c3                   	ret    

c010567e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010567e:	55                   	push   %ebp
c010567f:	89 e5                	mov    %esp,%ebp
c0105681:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0105684:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105688:	75 16                	jne    c01056a0 <default_init_memmap+0x22>
c010568a:	68 1c a2 10 c0       	push   $0xc010a21c
c010568f:	68 22 a2 10 c0       	push   $0xc010a222
c0105694:	6a 6d                	push   $0x6d
c0105696:	68 37 a2 10 c0       	push   $0xc010a237
c010569b:	e8 50 ad ff ff       	call   c01003f0 <__panic>
    struct Page *p = base;
c01056a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01056a6:	eb 6c                	jmp    c0105714 <default_init_memmap+0x96>
        assert(PageReserved(p));
c01056a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ab:	83 c0 04             	add    $0x4,%eax
c01056ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01056b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01056b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01056be:	0f a3 10             	bt     %edx,(%eax)
c01056c1:	19 c0                	sbb    %eax,%eax
c01056c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c01056c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01056ca:	0f 95 c0             	setne  %al
c01056cd:	0f b6 c0             	movzbl %al,%eax
c01056d0:	85 c0                	test   %eax,%eax
c01056d2:	75 16                	jne    c01056ea <default_init_memmap+0x6c>
c01056d4:	68 4d a2 10 c0       	push   $0xc010a24d
c01056d9:	68 22 a2 10 c0       	push   $0xc010a222
c01056de:	6a 70                	push   $0x70
c01056e0:	68 37 a2 10 c0       	push   $0xc010a237
c01056e5:	e8 06 ad ff ff       	call   c01003f0 <__panic>
        p->flags = p->property = 0;
c01056ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01056f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056f7:	8b 50 08             	mov    0x8(%eax),%edx
c01056fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056fd:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0105700:	83 ec 08             	sub    $0x8,%esp
c0105703:	6a 00                	push   $0x0
c0105705:	ff 75 f4             	pushl  -0xc(%ebp)
c0105708:	e8 35 ff ff ff       	call   c0105642 <set_page_ref>
c010570d:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0105710:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105714:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105717:	c1 e0 05             	shl    $0x5,%eax
c010571a:	89 c2                	mov    %eax,%edx
c010571c:	8b 45 08             	mov    0x8(%ebp),%eax
c010571f:	01 d0                	add    %edx,%eax
c0105721:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105724:	75 82                	jne    c01056a8 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0105726:	8b 45 08             	mov    0x8(%ebp),%eax
c0105729:	8b 55 0c             	mov    0xc(%ebp),%edx
c010572c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010572f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105732:	83 c0 04             	add    $0x4,%eax
c0105735:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c010573c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010573f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105742:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105745:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105748:	8b 15 4c 51 12 c0    	mov    0xc012514c,%edx
c010574e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105751:	01 d0                	add    %edx,%eax
c0105753:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
    list_add(&free_list, &(base->page_link));
c0105758:	8b 45 08             	mov    0x8(%ebp),%eax
c010575b:	83 c0 0c             	add    $0xc,%eax
c010575e:	c7 45 f0 44 51 12 c0 	movl   $0xc0125144,-0x10(%ebp)
c0105765:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105768:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010576b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010576e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105774:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105777:	8b 40 04             	mov    0x4(%eax),%eax
c010577a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010577d:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0105780:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105783:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105786:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105789:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010578c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010578f:	89 10                	mov    %edx,(%eax)
c0105791:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105794:	8b 10                	mov    (%eax),%edx
c0105796:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105799:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010579c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010579f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01057a2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01057a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01057a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01057ab:	89 10                	mov    %edx,(%eax)
}
c01057ad:	90                   	nop
c01057ae:	c9                   	leave  
c01057af:	c3                   	ret    

c01057b0 <default_alloc_pages>:

// LAB2 MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
c01057b0:	55                   	push   %ebp
c01057b1:	89 e5                	mov    %esp,%ebp
c01057b3:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01057b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01057ba:	75 16                	jne    c01057d2 <default_alloc_pages+0x22>
c01057bc:	68 1c a2 10 c0       	push   $0xc010a21c
c01057c1:	68 22 a2 10 c0       	push   $0xc010a222
c01057c6:	6a 7d                	push   $0x7d
c01057c8:	68 37 a2 10 c0       	push   $0xc010a237
c01057cd:	e8 1e ac ff ff       	call   c01003f0 <__panic>
    if (n > nr_free) {
c01057d2:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c01057d7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01057da:	73 0a                	jae    c01057e6 <default_alloc_pages+0x36>
        return NULL;
c01057dc:	b8 00 00 00 00       	mov    $0x0,%eax
c01057e1:	e9 41 01 00 00       	jmp    c0105927 <default_alloc_pages+0x177>
    }
    struct Page *page = NULL;
c01057e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01057ed:	c7 45 f0 44 51 12 c0 	movl   $0xc0125144,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01057f4:	eb 1c                	jmp    c0105812 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c01057f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f9:	83 e8 0c             	sub    $0xc,%eax
c01057fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c01057ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105802:	8b 40 08             	mov    0x8(%eax),%eax
c0105805:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105808:	72 08                	jb     c0105812 <default_alloc_pages+0x62>
            page = p;
c010580a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010580d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0105810:	eb 18                	jmp    c010582a <default_alloc_pages+0x7a>
c0105812:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105815:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105818:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010581b:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010581e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105821:	81 7d f0 44 51 12 c0 	cmpl   $0xc0125144,-0x10(%ebp)
c0105828:	75 cc                	jne    c01057f6 <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c010582a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010582e:	0f 84 f0 00 00 00    	je     c0105924 <default_alloc_pages+0x174>
c0105834:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105837:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010583a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010583d:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
c0105840:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
c0105843:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105846:	83 c0 0c             	add    $0xc,%eax
c0105849:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010584c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010584f:	8b 40 04             	mov    0x4(%eax),%eax
c0105852:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105855:	8b 12                	mov    (%edx),%edx
c0105857:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010585a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010585d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105860:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105863:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105866:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105869:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010586c:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c010586e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105871:	8b 40 08             	mov    0x8(%eax),%eax
c0105874:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105877:	0f 86 81 00 00 00    	jbe    c01058fe <default_alloc_pages+0x14e>
            struct Page *p = page + n;                      // split the allocated page
c010587d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105880:	c1 e0 05             	shl    $0x5,%eax
c0105883:	89 c2                	mov    %eax,%edx
c0105885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105888:	01 d0                	add    %edx,%eax
c010588a:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
c010588d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105890:	8b 40 08             	mov    0x8(%eax),%eax
c0105893:	2b 45 08             	sub    0x8(%ebp),%eax
c0105896:	89 c2                	mov    %eax,%edx
c0105898:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010589b:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
c010589e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01058a1:	83 c0 04             	add    $0x4,%eax
c01058a4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01058ab:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01058ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01058b1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01058b4:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
c01058b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01058ba:	8d 50 0c             	lea    0xc(%eax),%edx
c01058bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058c3:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01058c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058c9:	8b 00                	mov    (%eax),%eax
c01058cb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01058ce:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01058d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01058d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01058da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01058dd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01058e0:	89 10                	mov    %edx,(%eax)
c01058e2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01058e5:	8b 10                	mov    (%eax),%edx
c01058e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01058ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01058ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01058f0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01058f3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01058f6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01058f9:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01058fc:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c01058fe:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0105903:	2b 45 08             	sub    0x8(%ebp),%eax
c0105906:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
        ClearPageProperty(page);    // mark as "not head page"
c010590b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010590e:	83 c0 04             	add    $0x4,%eax
c0105911:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105918:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010591b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010591e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105921:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0105924:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105927:	c9                   	leave  
c0105928:	c3                   	ret    

c0105929 <default_free_pages>:

// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
c0105929:	55                   	push   %ebp
c010592a:	89 e5                	mov    %esp,%ebp
c010592c:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0105932:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105936:	75 19                	jne    c0105951 <default_free_pages+0x28>
c0105938:	68 1c a2 10 c0       	push   $0xc010a21c
c010593d:	68 22 a2 10 c0       	push   $0xc010a222
c0105942:	68 9c 00 00 00       	push   $0x9c
c0105947:	68 37 a2 10 c0       	push   $0xc010a237
c010594c:	e8 9f aa ff ff       	call   c01003f0 <__panic>
    struct Page *p = base;
c0105951:	8b 45 08             	mov    0x8(%ebp),%eax
c0105954:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105957:	e9 8f 00 00 00       	jmp    c01059eb <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c010595c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010595f:	83 c0 04             	add    $0x4,%eax
c0105962:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0105969:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010596c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010596f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105972:	0f a3 10             	bt     %edx,(%eax)
c0105975:	19 c0                	sbb    %eax,%eax
c0105977:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010597a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010597e:	0f 95 c0             	setne  %al
c0105981:	0f b6 c0             	movzbl %al,%eax
c0105984:	85 c0                	test   %eax,%eax
c0105986:	75 2c                	jne    c01059b4 <default_free_pages+0x8b>
c0105988:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010598b:	83 c0 04             	add    $0x4,%eax
c010598e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0105995:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105998:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010599b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010599e:	0f a3 10             	bt     %edx,(%eax)
c01059a1:	19 c0                	sbb    %eax,%eax
c01059a3:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
c01059a6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
c01059aa:	0f 95 c0             	setne  %al
c01059ad:	0f b6 c0             	movzbl %al,%eax
c01059b0:	85 c0                	test   %eax,%eax
c01059b2:	74 19                	je     c01059cd <default_free_pages+0xa4>
c01059b4:	68 60 a2 10 c0       	push   $0xc010a260
c01059b9:	68 22 a2 10 c0       	push   $0xc010a222
c01059be:	68 9f 00 00 00       	push   $0x9f
c01059c3:	68 37 a2 10 c0       	push   $0xc010a237
c01059c8:	e8 23 aa ff ff       	call   c01003f0 <__panic>
        p->flags = 0;
c01059cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
c01059d7:	83 ec 08             	sub    $0x8,%esp
c01059da:	6a 00                	push   $0x0
c01059dc:	ff 75 f4             	pushl  -0xc(%ebp)
c01059df:	e8 5e fc ff ff       	call   c0105642 <set_page_ref>
c01059e4:	83 c4 10             	add    $0x10,%esp
// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01059e7:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01059eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ee:	c1 e0 05             	shl    $0x5,%eax
c01059f1:	89 c2                	mov    %eax,%edx
c01059f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f6:	01 d0                	add    %edx,%eax
c01059f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01059fb:	0f 85 5b ff ff ff    	jne    c010595c <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
c0105a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a04:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a07:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105a0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0d:	83 c0 04             	add    $0x4,%eax
c0105a10:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0105a17:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105a1a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105a1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a20:	0f ab 10             	bts    %edx,(%eax)
c0105a23:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a2d:	8b 40 04             	mov    0x4(%eax),%eax
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
c0105a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105a33:	e9 0e 01 00 00       	jmp    c0105b46 <default_free_pages+0x21d>
        p = le2page(le, page_link);
c0105a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a3b:	83 e8 0c             	sub    $0xc,%eax
c0105a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a4a:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
c0105a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a53:	8b 40 08             	mov    0x8(%eax),%eax
c0105a56:	c1 e0 05             	shl    $0x5,%eax
c0105a59:	89 c2                	mov    %eax,%edx
c0105a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5e:	01 d0                	add    %edx,%eax
c0105a60:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105a63:	75 64                	jne    c0105ac9 <default_free_pages+0x1a0>
            base->property += p->property;
c0105a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a68:	8b 50 08             	mov    0x8(%eax),%edx
c0105a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a6e:	8b 40 08             	mov    0x8(%eax),%eax
c0105a71:	01 c2                	add    %eax,%edx
c0105a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a76:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
c0105a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c0105a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a86:	83 c0 04             	add    $0x4,%eax
c0105a89:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105a90:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105a93:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105a96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105a99:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a9f:	83 c0 0c             	add    $0xc,%eax
c0105aa2:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105aa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105aa8:	8b 40 04             	mov    0x4(%eax),%eax
c0105aab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105aae:	8b 12                	mov    (%edx),%edx
c0105ab0:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0105ab3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105ab6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105ab9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105abc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105abf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105ac2:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105ac5:	89 10                	mov    %edx,(%eax)
c0105ac7:	eb 7d                	jmp    c0105b46 <default_free_pages+0x21d>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
c0105ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105acc:	8b 40 08             	mov    0x8(%eax),%eax
c0105acf:	c1 e0 05             	shl    $0x5,%eax
c0105ad2:	89 c2                	mov    %eax,%edx
c0105ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ad7:	01 d0                	add    %edx,%eax
c0105ad9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105adc:	75 68                	jne    c0105b46 <default_free_pages+0x21d>
            p->property += base->property;
c0105ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ae1:	8b 50 08             	mov    0x8(%eax),%edx
c0105ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae7:	8b 40 08             	mov    0x8(%eax),%eax
c0105aea:	01 c2                	add    %eax,%edx
c0105aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105aef:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
c0105af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
c0105afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aff:	83 c0 04             	add    $0x4,%eax
c0105b02:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0105b09:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105b0c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105b0f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105b12:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0105b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b18:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b1e:	83 c0 0c             	add    $0xc,%eax
c0105b21:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105b24:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105b27:	8b 40 04             	mov    0x4(%eax),%eax
c0105b2a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105b2d:	8b 12                	mov    (%edx),%edx
c0105b2f:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105b32:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105b35:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105b38:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105b3b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105b3e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105b41:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105b44:	89 10                	mov    %edx,(%eax)
    }
    base->property = n;
    SetPageProperty(base);
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0105b46:	81 7d f0 44 51 12 c0 	cmpl   $0xc0125144,-0x10(%ebp)
c0105b4d:	0f 85 e5 fe ff ff    	jne    c0105a38 <default_free_pages+0x10f>
c0105b53:	c7 45 d0 44 51 12 c0 	movl   $0xc0125144,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105b5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105b5d:	8b 40 04             	mov    0x4(%eax),%eax
            base = p;
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
c0105b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105b63:	eb 20                	jmp    c0105b85 <default_free_pages+0x25c>
        p = le2page(le, page_link);
c0105b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b68:	83 e8 0c             	sub    $0xc,%eax
c0105b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
c0105b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b71:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105b74:	77 1a                	ja     c0105b90 <default_free_pages+0x267>
c0105b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b79:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105b7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105b7f:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
c0105b85:	81 7d f0 44 51 12 c0 	cmpl   $0xc0125144,-0x10(%ebp)
c0105b8c:	75 d7                	jne    c0105b65 <default_free_pages+0x23c>
c0105b8e:	eb 01                	jmp    c0105b91 <default_free_pages+0x268>
        p = le2page(le, page_link);
        if (p > base) {
            break;
c0105b90:	90                   	nop
        }
        le = list_next(le);
    }
    nr_free += n;
c0105b91:	8b 15 4c 51 12 c0    	mov    0xc012514c,%edx
c0105b97:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9a:	01 d0                	add    %edx,%eax
c0105b9c:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
    list_add_before(le, &(base->page_link)); 
c0105ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba4:	8d 50 0c             	lea    0xc(%eax),%edx
c0105ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105baa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0105bad:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105bb0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105bb3:	8b 00                	mov    (%eax),%eax
c0105bb5:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105bb8:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105bbb:	89 45 88             	mov    %eax,-0x78(%ebp)
c0105bbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105bc1:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105bc4:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105bc7:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105bca:	89 10                	mov    %edx,(%eax)
c0105bcc:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105bcf:	8b 10                	mov    (%eax),%edx
c0105bd1:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105bd4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105bd7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105bda:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105bdd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105be0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105be3:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105be6:	89 10                	mov    %edx,(%eax)
}
c0105be8:	90                   	nop
c0105be9:	c9                   	leave  
c0105bea:	c3                   	ret    

c0105beb <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105beb:	55                   	push   %ebp
c0105bec:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105bee:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
}
c0105bf3:	5d                   	pop    %ebp
c0105bf4:	c3                   	ret    

c0105bf5 <basic_check>:

static void
basic_check(void) {
c0105bf5:	55                   	push   %ebp
c0105bf6:	89 e5                	mov    %esp,%ebp
c0105bf8:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105bfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105c0e:	83 ec 0c             	sub    $0xc,%esp
c0105c11:	6a 01                	push   $0x1
c0105c13:	e8 06 0d 00 00       	call   c010691e <alloc_pages>
c0105c18:	83 c4 10             	add    $0x10,%esp
c0105c1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105c22:	75 19                	jne    c0105c3d <basic_check+0x48>
c0105c24:	68 85 a2 10 c0       	push   $0xc010a285
c0105c29:	68 22 a2 10 c0       	push   $0xc010a222
c0105c2e:	68 d0 00 00 00       	push   $0xd0
c0105c33:	68 37 a2 10 c0       	push   $0xc010a237
c0105c38:	e8 b3 a7 ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105c3d:	83 ec 0c             	sub    $0xc,%esp
c0105c40:	6a 01                	push   $0x1
c0105c42:	e8 d7 0c 00 00       	call   c010691e <alloc_pages>
c0105c47:	83 c4 10             	add    $0x10,%esp
c0105c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105c51:	75 19                	jne    c0105c6c <basic_check+0x77>
c0105c53:	68 a1 a2 10 c0       	push   $0xc010a2a1
c0105c58:	68 22 a2 10 c0       	push   $0xc010a222
c0105c5d:	68 d1 00 00 00       	push   $0xd1
c0105c62:	68 37 a2 10 c0       	push   $0xc010a237
c0105c67:	e8 84 a7 ff ff       	call   c01003f0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105c6c:	83 ec 0c             	sub    $0xc,%esp
c0105c6f:	6a 01                	push   $0x1
c0105c71:	e8 a8 0c 00 00       	call   c010691e <alloc_pages>
c0105c76:	83 c4 10             	add    $0x10,%esp
c0105c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c80:	75 19                	jne    c0105c9b <basic_check+0xa6>
c0105c82:	68 bd a2 10 c0       	push   $0xc010a2bd
c0105c87:	68 22 a2 10 c0       	push   $0xc010a222
c0105c8c:	68 d2 00 00 00       	push   $0xd2
c0105c91:	68 37 a2 10 c0       	push   $0xc010a237
c0105c96:	e8 55 a7 ff ff       	call   c01003f0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c9e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105ca1:	74 10                	je     c0105cb3 <basic_check+0xbe>
c0105ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ca6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105ca9:	74 08                	je     c0105cb3 <basic_check+0xbe>
c0105cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105cb1:	75 19                	jne    c0105ccc <basic_check+0xd7>
c0105cb3:	68 dc a2 10 c0       	push   $0xc010a2dc
c0105cb8:	68 22 a2 10 c0       	push   $0xc010a222
c0105cbd:	68 d4 00 00 00       	push   $0xd4
c0105cc2:	68 37 a2 10 c0       	push   $0xc010a237
c0105cc7:	e8 24 a7 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105ccc:	83 ec 0c             	sub    $0xc,%esp
c0105ccf:	ff 75 ec             	pushl  -0x14(%ebp)
c0105cd2:	e8 61 f9 ff ff       	call   c0105638 <page_ref>
c0105cd7:	83 c4 10             	add    $0x10,%esp
c0105cda:	85 c0                	test   %eax,%eax
c0105cdc:	75 24                	jne    c0105d02 <basic_check+0x10d>
c0105cde:	83 ec 0c             	sub    $0xc,%esp
c0105ce1:	ff 75 f0             	pushl  -0x10(%ebp)
c0105ce4:	e8 4f f9 ff ff       	call   c0105638 <page_ref>
c0105ce9:	83 c4 10             	add    $0x10,%esp
c0105cec:	85 c0                	test   %eax,%eax
c0105cee:	75 12                	jne    c0105d02 <basic_check+0x10d>
c0105cf0:	83 ec 0c             	sub    $0xc,%esp
c0105cf3:	ff 75 f4             	pushl  -0xc(%ebp)
c0105cf6:	e8 3d f9 ff ff       	call   c0105638 <page_ref>
c0105cfb:	83 c4 10             	add    $0x10,%esp
c0105cfe:	85 c0                	test   %eax,%eax
c0105d00:	74 19                	je     c0105d1b <basic_check+0x126>
c0105d02:	68 00 a3 10 c0       	push   $0xc010a300
c0105d07:	68 22 a2 10 c0       	push   $0xc010a222
c0105d0c:	68 d5 00 00 00       	push   $0xd5
c0105d11:	68 37 a2 10 c0       	push   $0xc010a237
c0105d16:	e8 d5 a6 ff ff       	call   c01003f0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105d1b:	83 ec 0c             	sub    $0xc,%esp
c0105d1e:	ff 75 ec             	pushl  -0x14(%ebp)
c0105d21:	e8 ff f8 ff ff       	call   c0105625 <page2pa>
c0105d26:	83 c4 10             	add    $0x10,%esp
c0105d29:	89 c2                	mov    %eax,%edx
c0105d2b:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0105d30:	c1 e0 0c             	shl    $0xc,%eax
c0105d33:	39 c2                	cmp    %eax,%edx
c0105d35:	72 19                	jb     c0105d50 <basic_check+0x15b>
c0105d37:	68 3c a3 10 c0       	push   $0xc010a33c
c0105d3c:	68 22 a2 10 c0       	push   $0xc010a222
c0105d41:	68 d7 00 00 00       	push   $0xd7
c0105d46:	68 37 a2 10 c0       	push   $0xc010a237
c0105d4b:	e8 a0 a6 ff ff       	call   c01003f0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105d50:	83 ec 0c             	sub    $0xc,%esp
c0105d53:	ff 75 f0             	pushl  -0x10(%ebp)
c0105d56:	e8 ca f8 ff ff       	call   c0105625 <page2pa>
c0105d5b:	83 c4 10             	add    $0x10,%esp
c0105d5e:	89 c2                	mov    %eax,%edx
c0105d60:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0105d65:	c1 e0 0c             	shl    $0xc,%eax
c0105d68:	39 c2                	cmp    %eax,%edx
c0105d6a:	72 19                	jb     c0105d85 <basic_check+0x190>
c0105d6c:	68 59 a3 10 c0       	push   $0xc010a359
c0105d71:	68 22 a2 10 c0       	push   $0xc010a222
c0105d76:	68 d8 00 00 00       	push   $0xd8
c0105d7b:	68 37 a2 10 c0       	push   $0xc010a237
c0105d80:	e8 6b a6 ff ff       	call   c01003f0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105d85:	83 ec 0c             	sub    $0xc,%esp
c0105d88:	ff 75 f4             	pushl  -0xc(%ebp)
c0105d8b:	e8 95 f8 ff ff       	call   c0105625 <page2pa>
c0105d90:	83 c4 10             	add    $0x10,%esp
c0105d93:	89 c2                	mov    %eax,%edx
c0105d95:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0105d9a:	c1 e0 0c             	shl    $0xc,%eax
c0105d9d:	39 c2                	cmp    %eax,%edx
c0105d9f:	72 19                	jb     c0105dba <basic_check+0x1c5>
c0105da1:	68 76 a3 10 c0       	push   $0xc010a376
c0105da6:	68 22 a2 10 c0       	push   $0xc010a222
c0105dab:	68 d9 00 00 00       	push   $0xd9
c0105db0:	68 37 a2 10 c0       	push   $0xc010a237
c0105db5:	e8 36 a6 ff ff       	call   c01003f0 <__panic>

    list_entry_t free_list_store = free_list;
c0105dba:	a1 44 51 12 c0       	mov    0xc0125144,%eax
c0105dbf:	8b 15 48 51 12 c0    	mov    0xc0125148,%edx
c0105dc5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105dc8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105dcb:	c7 45 e4 44 51 12 c0 	movl   $0xc0125144,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105dd8:	89 50 04             	mov    %edx,0x4(%eax)
c0105ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dde:	8b 50 04             	mov    0x4(%eax),%edx
c0105de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105de4:	89 10                	mov    %edx,(%eax)
c0105de6:	c7 45 d8 44 51 12 c0 	movl   $0xc0125144,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0105ded:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105df0:	8b 40 04             	mov    0x4(%eax),%eax
c0105df3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105df6:	0f 94 c0             	sete   %al
c0105df9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105dfc:	85 c0                	test   %eax,%eax
c0105dfe:	75 19                	jne    c0105e19 <basic_check+0x224>
c0105e00:	68 93 a3 10 c0       	push   $0xc010a393
c0105e05:	68 22 a2 10 c0       	push   $0xc010a222
c0105e0a:	68 dd 00 00 00       	push   $0xdd
c0105e0f:	68 37 a2 10 c0       	push   $0xc010a237
c0105e14:	e8 d7 a5 ff ff       	call   c01003f0 <__panic>

    unsigned int nr_free_store = nr_free;
c0105e19:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0105e1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0105e21:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c0105e28:	00 00 00 

    assert(alloc_page() == NULL);
c0105e2b:	83 ec 0c             	sub    $0xc,%esp
c0105e2e:	6a 01                	push   $0x1
c0105e30:	e8 e9 0a 00 00       	call   c010691e <alloc_pages>
c0105e35:	83 c4 10             	add    $0x10,%esp
c0105e38:	85 c0                	test   %eax,%eax
c0105e3a:	74 19                	je     c0105e55 <basic_check+0x260>
c0105e3c:	68 aa a3 10 c0       	push   $0xc010a3aa
c0105e41:	68 22 a2 10 c0       	push   $0xc010a222
c0105e46:	68 e2 00 00 00       	push   $0xe2
c0105e4b:	68 37 a2 10 c0       	push   $0xc010a237
c0105e50:	e8 9b a5 ff ff       	call   c01003f0 <__panic>

    free_page(p0);
c0105e55:	83 ec 08             	sub    $0x8,%esp
c0105e58:	6a 01                	push   $0x1
c0105e5a:	ff 75 ec             	pushl  -0x14(%ebp)
c0105e5d:	e8 28 0b 00 00       	call   c010698a <free_pages>
c0105e62:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0105e65:	83 ec 08             	sub    $0x8,%esp
c0105e68:	6a 01                	push   $0x1
c0105e6a:	ff 75 f0             	pushl  -0x10(%ebp)
c0105e6d:	e8 18 0b 00 00       	call   c010698a <free_pages>
c0105e72:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105e75:	83 ec 08             	sub    $0x8,%esp
c0105e78:	6a 01                	push   $0x1
c0105e7a:	ff 75 f4             	pushl  -0xc(%ebp)
c0105e7d:	e8 08 0b 00 00       	call   c010698a <free_pages>
c0105e82:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0105e85:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0105e8a:	83 f8 03             	cmp    $0x3,%eax
c0105e8d:	74 19                	je     c0105ea8 <basic_check+0x2b3>
c0105e8f:	68 bf a3 10 c0       	push   $0xc010a3bf
c0105e94:	68 22 a2 10 c0       	push   $0xc010a222
c0105e99:	68 e7 00 00 00       	push   $0xe7
c0105e9e:	68 37 a2 10 c0       	push   $0xc010a237
c0105ea3:	e8 48 a5 ff ff       	call   c01003f0 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105ea8:	83 ec 0c             	sub    $0xc,%esp
c0105eab:	6a 01                	push   $0x1
c0105ead:	e8 6c 0a 00 00       	call   c010691e <alloc_pages>
c0105eb2:	83 c4 10             	add    $0x10,%esp
c0105eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105eb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105ebc:	75 19                	jne    c0105ed7 <basic_check+0x2e2>
c0105ebe:	68 85 a2 10 c0       	push   $0xc010a285
c0105ec3:	68 22 a2 10 c0       	push   $0xc010a222
c0105ec8:	68 e9 00 00 00       	push   $0xe9
c0105ecd:	68 37 a2 10 c0       	push   $0xc010a237
c0105ed2:	e8 19 a5 ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105ed7:	83 ec 0c             	sub    $0xc,%esp
c0105eda:	6a 01                	push   $0x1
c0105edc:	e8 3d 0a 00 00       	call   c010691e <alloc_pages>
c0105ee1:	83 c4 10             	add    $0x10,%esp
c0105ee4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ee7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105eeb:	75 19                	jne    c0105f06 <basic_check+0x311>
c0105eed:	68 a1 a2 10 c0       	push   $0xc010a2a1
c0105ef2:	68 22 a2 10 c0       	push   $0xc010a222
c0105ef7:	68 ea 00 00 00       	push   $0xea
c0105efc:	68 37 a2 10 c0       	push   $0xc010a237
c0105f01:	e8 ea a4 ff ff       	call   c01003f0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105f06:	83 ec 0c             	sub    $0xc,%esp
c0105f09:	6a 01                	push   $0x1
c0105f0b:	e8 0e 0a 00 00       	call   c010691e <alloc_pages>
c0105f10:	83 c4 10             	add    $0x10,%esp
c0105f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105f1a:	75 19                	jne    c0105f35 <basic_check+0x340>
c0105f1c:	68 bd a2 10 c0       	push   $0xc010a2bd
c0105f21:	68 22 a2 10 c0       	push   $0xc010a222
c0105f26:	68 eb 00 00 00       	push   $0xeb
c0105f2b:	68 37 a2 10 c0       	push   $0xc010a237
c0105f30:	e8 bb a4 ff ff       	call   c01003f0 <__panic>

    assert(alloc_page() == NULL);
c0105f35:	83 ec 0c             	sub    $0xc,%esp
c0105f38:	6a 01                	push   $0x1
c0105f3a:	e8 df 09 00 00       	call   c010691e <alloc_pages>
c0105f3f:	83 c4 10             	add    $0x10,%esp
c0105f42:	85 c0                	test   %eax,%eax
c0105f44:	74 19                	je     c0105f5f <basic_check+0x36a>
c0105f46:	68 aa a3 10 c0       	push   $0xc010a3aa
c0105f4b:	68 22 a2 10 c0       	push   $0xc010a222
c0105f50:	68 ed 00 00 00       	push   $0xed
c0105f55:	68 37 a2 10 c0       	push   $0xc010a237
c0105f5a:	e8 91 a4 ff ff       	call   c01003f0 <__panic>

    free_page(p0);
c0105f5f:	83 ec 08             	sub    $0x8,%esp
c0105f62:	6a 01                	push   $0x1
c0105f64:	ff 75 ec             	pushl  -0x14(%ebp)
c0105f67:	e8 1e 0a 00 00       	call   c010698a <free_pages>
c0105f6c:	83 c4 10             	add    $0x10,%esp
c0105f6f:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
c0105f76:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f79:	8b 40 04             	mov    0x4(%eax),%eax
c0105f7c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105f7f:	0f 94 c0             	sete   %al
c0105f82:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105f85:	85 c0                	test   %eax,%eax
c0105f87:	74 19                	je     c0105fa2 <basic_check+0x3ad>
c0105f89:	68 cc a3 10 c0       	push   $0xc010a3cc
c0105f8e:	68 22 a2 10 c0       	push   $0xc010a222
c0105f93:	68 f0 00 00 00       	push   $0xf0
c0105f98:	68 37 a2 10 c0       	push   $0xc010a237
c0105f9d:	e8 4e a4 ff ff       	call   c01003f0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105fa2:	83 ec 0c             	sub    $0xc,%esp
c0105fa5:	6a 01                	push   $0x1
c0105fa7:	e8 72 09 00 00       	call   c010691e <alloc_pages>
c0105fac:	83 c4 10             	add    $0x10,%esp
c0105faf:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105fb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105fb5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105fb8:	74 19                	je     c0105fd3 <basic_check+0x3de>
c0105fba:	68 e4 a3 10 c0       	push   $0xc010a3e4
c0105fbf:	68 22 a2 10 c0       	push   $0xc010a222
c0105fc4:	68 f3 00 00 00       	push   $0xf3
c0105fc9:	68 37 a2 10 c0       	push   $0xc010a237
c0105fce:	e8 1d a4 ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c0105fd3:	83 ec 0c             	sub    $0xc,%esp
c0105fd6:	6a 01                	push   $0x1
c0105fd8:	e8 41 09 00 00       	call   c010691e <alloc_pages>
c0105fdd:	83 c4 10             	add    $0x10,%esp
c0105fe0:	85 c0                	test   %eax,%eax
c0105fe2:	74 19                	je     c0105ffd <basic_check+0x408>
c0105fe4:	68 aa a3 10 c0       	push   $0xc010a3aa
c0105fe9:	68 22 a2 10 c0       	push   $0xc010a222
c0105fee:	68 f4 00 00 00       	push   $0xf4
c0105ff3:	68 37 a2 10 c0       	push   $0xc010a237
c0105ff8:	e8 f3 a3 ff ff       	call   c01003f0 <__panic>

    assert(nr_free == 0);
c0105ffd:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0106002:	85 c0                	test   %eax,%eax
c0106004:	74 19                	je     c010601f <basic_check+0x42a>
c0106006:	68 fd a3 10 c0       	push   $0xc010a3fd
c010600b:	68 22 a2 10 c0       	push   $0xc010a222
c0106010:	68 f6 00 00 00       	push   $0xf6
c0106015:	68 37 a2 10 c0       	push   $0xc010a237
c010601a:	e8 d1 a3 ff ff       	call   c01003f0 <__panic>
    free_list = free_list_store;
c010601f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106022:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106025:	a3 44 51 12 c0       	mov    %eax,0xc0125144
c010602a:	89 15 48 51 12 c0    	mov    %edx,0xc0125148
    nr_free = nr_free_store;
c0106030:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106033:	a3 4c 51 12 c0       	mov    %eax,0xc012514c

    free_page(p);
c0106038:	83 ec 08             	sub    $0x8,%esp
c010603b:	6a 01                	push   $0x1
c010603d:	ff 75 dc             	pushl  -0x24(%ebp)
c0106040:	e8 45 09 00 00       	call   c010698a <free_pages>
c0106045:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0106048:	83 ec 08             	sub    $0x8,%esp
c010604b:	6a 01                	push   $0x1
c010604d:	ff 75 f0             	pushl  -0x10(%ebp)
c0106050:	e8 35 09 00 00       	call   c010698a <free_pages>
c0106055:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0106058:	83 ec 08             	sub    $0x8,%esp
c010605b:	6a 01                	push   $0x1
c010605d:	ff 75 f4             	pushl  -0xc(%ebp)
c0106060:	e8 25 09 00 00       	call   c010698a <free_pages>
c0106065:	83 c4 10             	add    $0x10,%esp
}
c0106068:	90                   	nop
c0106069:	c9                   	leave  
c010606a:	c3                   	ret    

c010606b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010606b:	55                   	push   %ebp
c010606c:	89 e5                	mov    %esp,%ebp
c010606e:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0106074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010607b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0106082:	c7 45 ec 44 51 12 c0 	movl   $0xc0125144,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106089:	eb 60                	jmp    c01060eb <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c010608b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010608e:	83 e8 0c             	sub    $0xc,%eax
c0106091:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106097:	83 c0 04             	add    $0x4,%eax
c010609a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01060a1:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01060a4:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01060a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01060aa:	0f a3 10             	bt     %edx,(%eax)
c01060ad:	19 c0                	sbb    %eax,%eax
c01060af:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c01060b2:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c01060b6:	0f 95 c0             	setne  %al
c01060b9:	0f b6 c0             	movzbl %al,%eax
c01060bc:	85 c0                	test   %eax,%eax
c01060be:	75 19                	jne    c01060d9 <default_check+0x6e>
c01060c0:	68 0a a4 10 c0       	push   $0xc010a40a
c01060c5:	68 22 a2 10 c0       	push   $0xc010a222
c01060ca:	68 07 01 00 00       	push   $0x107
c01060cf:	68 37 a2 10 c0       	push   $0xc010a237
c01060d4:	e8 17 a3 ff ff       	call   c01003f0 <__panic>
        count ++, total += p->property;
c01060d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01060dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060e0:	8b 50 08             	mov    0x8(%eax),%edx
c01060e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060e6:	01 d0                	add    %edx,%eax
c01060e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01060f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01060f4:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01060f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060fa:	81 7d ec 44 51 12 c0 	cmpl   $0xc0125144,-0x14(%ebp)
c0106101:	75 88                	jne    c010608b <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0106103:	e8 b7 08 00 00       	call   c01069bf <nr_free_pages>
c0106108:	89 c2                	mov    %eax,%edx
c010610a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010610d:	39 c2                	cmp    %eax,%edx
c010610f:	74 19                	je     c010612a <default_check+0xbf>
c0106111:	68 1a a4 10 c0       	push   $0xc010a41a
c0106116:	68 22 a2 10 c0       	push   $0xc010a222
c010611b:	68 0a 01 00 00       	push   $0x10a
c0106120:	68 37 a2 10 c0       	push   $0xc010a237
c0106125:	e8 c6 a2 ff ff       	call   c01003f0 <__panic>

    basic_check();
c010612a:	e8 c6 fa ff ff       	call   c0105bf5 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010612f:	83 ec 0c             	sub    $0xc,%esp
c0106132:	6a 05                	push   $0x5
c0106134:	e8 e5 07 00 00       	call   c010691e <alloc_pages>
c0106139:	83 c4 10             	add    $0x10,%esp
c010613c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c010613f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106143:	75 19                	jne    c010615e <default_check+0xf3>
c0106145:	68 33 a4 10 c0       	push   $0xc010a433
c010614a:	68 22 a2 10 c0       	push   $0xc010a222
c010614f:	68 0f 01 00 00       	push   $0x10f
c0106154:	68 37 a2 10 c0       	push   $0xc010a237
c0106159:	e8 92 a2 ff ff       	call   c01003f0 <__panic>
    assert(!PageProperty(p0));
c010615e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106161:	83 c0 04             	add    $0x4,%eax
c0106164:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c010616b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010616e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106171:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106174:	0f a3 10             	bt     %edx,(%eax)
c0106177:	19 c0                	sbb    %eax,%eax
c0106179:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c010617c:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0106180:	0f 95 c0             	setne  %al
c0106183:	0f b6 c0             	movzbl %al,%eax
c0106186:	85 c0                	test   %eax,%eax
c0106188:	74 19                	je     c01061a3 <default_check+0x138>
c010618a:	68 3e a4 10 c0       	push   $0xc010a43e
c010618f:	68 22 a2 10 c0       	push   $0xc010a222
c0106194:	68 10 01 00 00       	push   $0x110
c0106199:	68 37 a2 10 c0       	push   $0xc010a237
c010619e:	e8 4d a2 ff ff       	call   c01003f0 <__panic>

    list_entry_t free_list_store = free_list;
c01061a3:	a1 44 51 12 c0       	mov    0xc0125144,%eax
c01061a8:	8b 15 48 51 12 c0    	mov    0xc0125148,%edx
c01061ae:	89 45 80             	mov    %eax,-0x80(%ebp)
c01061b1:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01061b4:	c7 45 d0 44 51 12 c0 	movl   $0xc0125144,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01061bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01061be:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01061c1:	89 50 04             	mov    %edx,0x4(%eax)
c01061c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01061c7:	8b 50 04             	mov    0x4(%eax),%edx
c01061ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01061cd:	89 10                	mov    %edx,(%eax)
c01061cf:	c7 45 d8 44 51 12 c0 	movl   $0xc0125144,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01061d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01061d9:	8b 40 04             	mov    0x4(%eax),%eax
c01061dc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01061df:	0f 94 c0             	sete   %al
c01061e2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01061e5:	85 c0                	test   %eax,%eax
c01061e7:	75 19                	jne    c0106202 <default_check+0x197>
c01061e9:	68 93 a3 10 c0       	push   $0xc010a393
c01061ee:	68 22 a2 10 c0       	push   $0xc010a222
c01061f3:	68 14 01 00 00       	push   $0x114
c01061f8:	68 37 a2 10 c0       	push   $0xc010a237
c01061fd:	e8 ee a1 ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c0106202:	83 ec 0c             	sub    $0xc,%esp
c0106205:	6a 01                	push   $0x1
c0106207:	e8 12 07 00 00       	call   c010691e <alloc_pages>
c010620c:	83 c4 10             	add    $0x10,%esp
c010620f:	85 c0                	test   %eax,%eax
c0106211:	74 19                	je     c010622c <default_check+0x1c1>
c0106213:	68 aa a3 10 c0       	push   $0xc010a3aa
c0106218:	68 22 a2 10 c0       	push   $0xc010a222
c010621d:	68 15 01 00 00       	push   $0x115
c0106222:	68 37 a2 10 c0       	push   $0xc010a237
c0106227:	e8 c4 a1 ff ff       	call   c01003f0 <__panic>

    unsigned int nr_free_store = nr_free;
c010622c:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0106231:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0106234:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c010623b:	00 00 00 

    free_pages(p0 + 2, 3);
c010623e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106241:	83 c0 40             	add    $0x40,%eax
c0106244:	83 ec 08             	sub    $0x8,%esp
c0106247:	6a 03                	push   $0x3
c0106249:	50                   	push   %eax
c010624a:	e8 3b 07 00 00       	call   c010698a <free_pages>
c010624f:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0106252:	83 ec 0c             	sub    $0xc,%esp
c0106255:	6a 04                	push   $0x4
c0106257:	e8 c2 06 00 00       	call   c010691e <alloc_pages>
c010625c:	83 c4 10             	add    $0x10,%esp
c010625f:	85 c0                	test   %eax,%eax
c0106261:	74 19                	je     c010627c <default_check+0x211>
c0106263:	68 50 a4 10 c0       	push   $0xc010a450
c0106268:	68 22 a2 10 c0       	push   $0xc010a222
c010626d:	68 1b 01 00 00       	push   $0x11b
c0106272:	68 37 a2 10 c0       	push   $0xc010a237
c0106277:	e8 74 a1 ff ff       	call   c01003f0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010627c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010627f:	83 c0 40             	add    $0x40,%eax
c0106282:	83 c0 04             	add    $0x4,%eax
c0106285:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010628c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010628f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106292:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106295:	0f a3 10             	bt     %edx,(%eax)
c0106298:	19 c0                	sbb    %eax,%eax
c010629a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010629d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01062a1:	0f 95 c0             	setne  %al
c01062a4:	0f b6 c0             	movzbl %al,%eax
c01062a7:	85 c0                	test   %eax,%eax
c01062a9:	74 0e                	je     c01062b9 <default_check+0x24e>
c01062ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01062ae:	83 c0 40             	add    $0x40,%eax
c01062b1:	8b 40 08             	mov    0x8(%eax),%eax
c01062b4:	83 f8 03             	cmp    $0x3,%eax
c01062b7:	74 19                	je     c01062d2 <default_check+0x267>
c01062b9:	68 68 a4 10 c0       	push   $0xc010a468
c01062be:	68 22 a2 10 c0       	push   $0xc010a222
c01062c3:	68 1c 01 00 00       	push   $0x11c
c01062c8:	68 37 a2 10 c0       	push   $0xc010a237
c01062cd:	e8 1e a1 ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01062d2:	83 ec 0c             	sub    $0xc,%esp
c01062d5:	6a 03                	push   $0x3
c01062d7:	e8 42 06 00 00       	call   c010691e <alloc_pages>
c01062dc:	83 c4 10             	add    $0x10,%esp
c01062df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01062e2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01062e6:	75 19                	jne    c0106301 <default_check+0x296>
c01062e8:	68 94 a4 10 c0       	push   $0xc010a494
c01062ed:	68 22 a2 10 c0       	push   $0xc010a222
c01062f2:	68 1d 01 00 00       	push   $0x11d
c01062f7:	68 37 a2 10 c0       	push   $0xc010a237
c01062fc:	e8 ef a0 ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c0106301:	83 ec 0c             	sub    $0xc,%esp
c0106304:	6a 01                	push   $0x1
c0106306:	e8 13 06 00 00       	call   c010691e <alloc_pages>
c010630b:	83 c4 10             	add    $0x10,%esp
c010630e:	85 c0                	test   %eax,%eax
c0106310:	74 19                	je     c010632b <default_check+0x2c0>
c0106312:	68 aa a3 10 c0       	push   $0xc010a3aa
c0106317:	68 22 a2 10 c0       	push   $0xc010a222
c010631c:	68 1e 01 00 00       	push   $0x11e
c0106321:	68 37 a2 10 c0       	push   $0xc010a237
c0106326:	e8 c5 a0 ff ff       	call   c01003f0 <__panic>
    assert(p0 + 2 == p1);
c010632b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010632e:	83 c0 40             	add    $0x40,%eax
c0106331:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0106334:	74 19                	je     c010634f <default_check+0x2e4>
c0106336:	68 b2 a4 10 c0       	push   $0xc010a4b2
c010633b:	68 22 a2 10 c0       	push   $0xc010a222
c0106340:	68 1f 01 00 00       	push   $0x11f
c0106345:	68 37 a2 10 c0       	push   $0xc010a237
c010634a:	e8 a1 a0 ff ff       	call   c01003f0 <__panic>

    p2 = p0 + 1;
c010634f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106352:	83 c0 20             	add    $0x20,%eax
c0106355:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0106358:	83 ec 08             	sub    $0x8,%esp
c010635b:	6a 01                	push   $0x1
c010635d:	ff 75 dc             	pushl  -0x24(%ebp)
c0106360:	e8 25 06 00 00       	call   c010698a <free_pages>
c0106365:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0106368:	83 ec 08             	sub    $0x8,%esp
c010636b:	6a 03                	push   $0x3
c010636d:	ff 75 c4             	pushl  -0x3c(%ebp)
c0106370:	e8 15 06 00 00       	call   c010698a <free_pages>
c0106375:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0106378:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010637b:	83 c0 04             	add    $0x4,%eax
c010637e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0106385:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106388:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010638b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010638e:	0f a3 10             	bt     %edx,(%eax)
c0106391:	19 c0                	sbb    %eax,%eax
c0106393:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0106396:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c010639a:	0f 95 c0             	setne  %al
c010639d:	0f b6 c0             	movzbl %al,%eax
c01063a0:	85 c0                	test   %eax,%eax
c01063a2:	74 0b                	je     c01063af <default_check+0x344>
c01063a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01063a7:	8b 40 08             	mov    0x8(%eax),%eax
c01063aa:	83 f8 01             	cmp    $0x1,%eax
c01063ad:	74 19                	je     c01063c8 <default_check+0x35d>
c01063af:	68 c0 a4 10 c0       	push   $0xc010a4c0
c01063b4:	68 22 a2 10 c0       	push   $0xc010a222
c01063b9:	68 24 01 00 00       	push   $0x124
c01063be:	68 37 a2 10 c0       	push   $0xc010a237
c01063c3:	e8 28 a0 ff ff       	call   c01003f0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01063c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01063cb:	83 c0 04             	add    $0x4,%eax
c01063ce:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c01063d5:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01063d8:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01063db:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01063de:	0f a3 10             	bt     %edx,(%eax)
c01063e1:	19 c0                	sbb    %eax,%eax
c01063e3:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c01063e6:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c01063ea:	0f 95 c0             	setne  %al
c01063ed:	0f b6 c0             	movzbl %al,%eax
c01063f0:	85 c0                	test   %eax,%eax
c01063f2:	74 0b                	je     c01063ff <default_check+0x394>
c01063f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01063f7:	8b 40 08             	mov    0x8(%eax),%eax
c01063fa:	83 f8 03             	cmp    $0x3,%eax
c01063fd:	74 19                	je     c0106418 <default_check+0x3ad>
c01063ff:	68 e8 a4 10 c0       	push   $0xc010a4e8
c0106404:	68 22 a2 10 c0       	push   $0xc010a222
c0106409:	68 25 01 00 00       	push   $0x125
c010640e:	68 37 a2 10 c0       	push   $0xc010a237
c0106413:	e8 d8 9f ff ff       	call   c01003f0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0106418:	83 ec 0c             	sub    $0xc,%esp
c010641b:	6a 01                	push   $0x1
c010641d:	e8 fc 04 00 00       	call   c010691e <alloc_pages>
c0106422:	83 c4 10             	add    $0x10,%esp
c0106425:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106428:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010642b:	83 e8 20             	sub    $0x20,%eax
c010642e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106431:	74 19                	je     c010644c <default_check+0x3e1>
c0106433:	68 0e a5 10 c0       	push   $0xc010a50e
c0106438:	68 22 a2 10 c0       	push   $0xc010a222
c010643d:	68 27 01 00 00       	push   $0x127
c0106442:	68 37 a2 10 c0       	push   $0xc010a237
c0106447:	e8 a4 9f ff ff       	call   c01003f0 <__panic>
    free_page(p0);
c010644c:	83 ec 08             	sub    $0x8,%esp
c010644f:	6a 01                	push   $0x1
c0106451:	ff 75 dc             	pushl  -0x24(%ebp)
c0106454:	e8 31 05 00 00       	call   c010698a <free_pages>
c0106459:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010645c:	83 ec 0c             	sub    $0xc,%esp
c010645f:	6a 02                	push   $0x2
c0106461:	e8 b8 04 00 00       	call   c010691e <alloc_pages>
c0106466:	83 c4 10             	add    $0x10,%esp
c0106469:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010646c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010646f:	83 c0 20             	add    $0x20,%eax
c0106472:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106475:	74 19                	je     c0106490 <default_check+0x425>
c0106477:	68 2c a5 10 c0       	push   $0xc010a52c
c010647c:	68 22 a2 10 c0       	push   $0xc010a222
c0106481:	68 29 01 00 00       	push   $0x129
c0106486:	68 37 a2 10 c0       	push   $0xc010a237
c010648b:	e8 60 9f ff ff       	call   c01003f0 <__panic>

    free_pages(p0, 2);
c0106490:	83 ec 08             	sub    $0x8,%esp
c0106493:	6a 02                	push   $0x2
c0106495:	ff 75 dc             	pushl  -0x24(%ebp)
c0106498:	e8 ed 04 00 00       	call   c010698a <free_pages>
c010649d:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01064a0:	83 ec 08             	sub    $0x8,%esp
c01064a3:	6a 01                	push   $0x1
c01064a5:	ff 75 c0             	pushl  -0x40(%ebp)
c01064a8:	e8 dd 04 00 00       	call   c010698a <free_pages>
c01064ad:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c01064b0:	83 ec 0c             	sub    $0xc,%esp
c01064b3:	6a 05                	push   $0x5
c01064b5:	e8 64 04 00 00       	call   c010691e <alloc_pages>
c01064ba:	83 c4 10             	add    $0x10,%esp
c01064bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01064c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01064c4:	75 19                	jne    c01064df <default_check+0x474>
c01064c6:	68 4c a5 10 c0       	push   $0xc010a54c
c01064cb:	68 22 a2 10 c0       	push   $0xc010a222
c01064d0:	68 2e 01 00 00       	push   $0x12e
c01064d5:	68 37 a2 10 c0       	push   $0xc010a237
c01064da:	e8 11 9f ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c01064df:	83 ec 0c             	sub    $0xc,%esp
c01064e2:	6a 01                	push   $0x1
c01064e4:	e8 35 04 00 00       	call   c010691e <alloc_pages>
c01064e9:	83 c4 10             	add    $0x10,%esp
c01064ec:	85 c0                	test   %eax,%eax
c01064ee:	74 19                	je     c0106509 <default_check+0x49e>
c01064f0:	68 aa a3 10 c0       	push   $0xc010a3aa
c01064f5:	68 22 a2 10 c0       	push   $0xc010a222
c01064fa:	68 2f 01 00 00       	push   $0x12f
c01064ff:	68 37 a2 10 c0       	push   $0xc010a237
c0106504:	e8 e7 9e ff ff       	call   c01003f0 <__panic>

    assert(nr_free == 0);
c0106509:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c010650e:	85 c0                	test   %eax,%eax
c0106510:	74 19                	je     c010652b <default_check+0x4c0>
c0106512:	68 fd a3 10 c0       	push   $0xc010a3fd
c0106517:	68 22 a2 10 c0       	push   $0xc010a222
c010651c:	68 31 01 00 00       	push   $0x131
c0106521:	68 37 a2 10 c0       	push   $0xc010a237
c0106526:	e8 c5 9e ff ff       	call   c01003f0 <__panic>
    nr_free = nr_free_store;
c010652b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010652e:	a3 4c 51 12 c0       	mov    %eax,0xc012514c

    free_list = free_list_store;
c0106533:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106536:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106539:	a3 44 51 12 c0       	mov    %eax,0xc0125144
c010653e:	89 15 48 51 12 c0    	mov    %edx,0xc0125148
    free_pages(p0, 5);
c0106544:	83 ec 08             	sub    $0x8,%esp
c0106547:	6a 05                	push   $0x5
c0106549:	ff 75 dc             	pushl  -0x24(%ebp)
c010654c:	e8 39 04 00 00       	call   c010698a <free_pages>
c0106551:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0106554:	c7 45 ec 44 51 12 c0 	movl   $0xc0125144,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010655b:	eb 1d                	jmp    c010657a <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c010655d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106560:	83 e8 0c             	sub    $0xc,%eax
c0106563:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0106566:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010656a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010656d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106570:	8b 40 08             	mov    0x8(%eax),%eax
c0106573:	29 c2                	sub    %eax,%edx
c0106575:	89 d0                	mov    %edx,%eax
c0106577:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010657a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010657d:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106580:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106583:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0106586:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106589:	81 7d ec 44 51 12 c0 	cmpl   $0xc0125144,-0x14(%ebp)
c0106590:	75 cb                	jne    c010655d <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0106592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106596:	74 19                	je     c01065b1 <default_check+0x546>
c0106598:	68 6a a5 10 c0       	push   $0xc010a56a
c010659d:	68 22 a2 10 c0       	push   $0xc010a222
c01065a2:	68 3c 01 00 00       	push   $0x13c
c01065a7:	68 37 a2 10 c0       	push   $0xc010a237
c01065ac:	e8 3f 9e ff ff       	call   c01003f0 <__panic>
    assert(total == 0);
c01065b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01065b5:	74 19                	je     c01065d0 <default_check+0x565>
c01065b7:	68 75 a5 10 c0       	push   $0xc010a575
c01065bc:	68 22 a2 10 c0       	push   $0xc010a222
c01065c1:	68 3d 01 00 00       	push   $0x13d
c01065c6:	68 37 a2 10 c0       	push   $0xc010a237
c01065cb:	e8 20 9e ff ff       	call   c01003f0 <__panic>
}
c01065d0:	90                   	nop
c01065d1:	c9                   	leave  
c01065d2:	c3                   	ret    

c01065d3 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01065d3:	55                   	push   %ebp
c01065d4:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01065d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01065d9:	8b 15 58 51 12 c0    	mov    0xc0125158,%edx
c01065df:	29 d0                	sub    %edx,%eax
c01065e1:	c1 f8 05             	sar    $0x5,%eax
}
c01065e4:	5d                   	pop    %ebp
c01065e5:	c3                   	ret    

c01065e6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01065e6:	55                   	push   %ebp
c01065e7:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01065e9:	ff 75 08             	pushl  0x8(%ebp)
c01065ec:	e8 e2 ff ff ff       	call   c01065d3 <page2ppn>
c01065f1:	83 c4 04             	add    $0x4,%esp
c01065f4:	c1 e0 0c             	shl    $0xc,%eax
}
c01065f7:	c9                   	leave  
c01065f8:	c3                   	ret    

c01065f9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01065f9:	55                   	push   %ebp
c01065fa:	89 e5                	mov    %esp,%ebp
c01065fc:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01065ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0106602:	c1 e8 0c             	shr    $0xc,%eax
c0106605:	89 c2                	mov    %eax,%edx
c0106607:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010660c:	39 c2                	cmp    %eax,%edx
c010660e:	72 14                	jb     c0106624 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0106610:	83 ec 04             	sub    $0x4,%esp
c0106613:	68 b0 a5 10 c0       	push   $0xc010a5b0
c0106618:	6a 5b                	push   $0x5b
c010661a:	68 cf a5 10 c0       	push   $0xc010a5cf
c010661f:	e8 cc 9d ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0106624:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0106629:	8b 55 08             	mov    0x8(%ebp),%edx
c010662c:	c1 ea 0c             	shr    $0xc,%edx
c010662f:	c1 e2 05             	shl    $0x5,%edx
c0106632:	01 d0                	add    %edx,%eax
}
c0106634:	c9                   	leave  
c0106635:	c3                   	ret    

c0106636 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0106636:	55                   	push   %ebp
c0106637:	89 e5                	mov    %esp,%ebp
c0106639:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c010663c:	ff 75 08             	pushl  0x8(%ebp)
c010663f:	e8 a2 ff ff ff       	call   c01065e6 <page2pa>
c0106644:	83 c4 04             	add    $0x4,%esp
c0106647:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010664a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010664d:	c1 e8 0c             	shr    $0xc,%eax
c0106650:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106653:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106658:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010665b:	72 14                	jb     c0106671 <page2kva+0x3b>
c010665d:	ff 75 f4             	pushl  -0xc(%ebp)
c0106660:	68 e0 a5 10 c0       	push   $0xc010a5e0
c0106665:	6a 62                	push   $0x62
c0106667:	68 cf a5 10 c0       	push   $0xc010a5cf
c010666c:	e8 7f 9d ff ff       	call   c01003f0 <__panic>
c0106671:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106674:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0106679:	c9                   	leave  
c010667a:	c3                   	ret    

c010667b <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010667b:	55                   	push   %ebp
c010667c:	89 e5                	mov    %esp,%ebp
c010667e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c0106681:	8b 45 08             	mov    0x8(%ebp),%eax
c0106684:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106687:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010668e:	77 14                	ja     c01066a4 <kva2page+0x29>
c0106690:	ff 75 f4             	pushl  -0xc(%ebp)
c0106693:	68 04 a6 10 c0       	push   $0xc010a604
c0106698:	6a 67                	push   $0x67
c010669a:	68 cf a5 10 c0       	push   $0xc010a5cf
c010669f:	e8 4c 9d ff ff       	call   c01003f0 <__panic>
c01066a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01066a7:	05 00 00 00 40       	add    $0x40000000,%eax
c01066ac:	83 ec 0c             	sub    $0xc,%esp
c01066af:	50                   	push   %eax
c01066b0:	e8 44 ff ff ff       	call   c01065f9 <pa2page>
c01066b5:	83 c4 10             	add    $0x10,%esp
}
c01066b8:	c9                   	leave  
c01066b9:	c3                   	ret    

c01066ba <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c01066ba:	55                   	push   %ebp
c01066bb:	89 e5                	mov    %esp,%ebp
c01066bd:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c01066c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01066c3:	83 e0 01             	and    $0x1,%eax
c01066c6:	85 c0                	test   %eax,%eax
c01066c8:	75 14                	jne    c01066de <pte2page+0x24>
        panic("pte2page called with invalid pte");
c01066ca:	83 ec 04             	sub    $0x4,%esp
c01066cd:	68 28 a6 10 c0       	push   $0xc010a628
c01066d2:	6a 6d                	push   $0x6d
c01066d4:	68 cf a5 10 c0       	push   $0xc010a5cf
c01066d9:	e8 12 9d ff ff       	call   c01003f0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01066de:	8b 45 08             	mov    0x8(%ebp),%eax
c01066e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01066e6:	83 ec 0c             	sub    $0xc,%esp
c01066e9:	50                   	push   %eax
c01066ea:	e8 0a ff ff ff       	call   c01065f9 <pa2page>
c01066ef:	83 c4 10             	add    $0x10,%esp
}
c01066f2:	c9                   	leave  
c01066f3:	c3                   	ret    

c01066f4 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c01066f4:	55                   	push   %ebp
c01066f5:	89 e5                	mov    %esp,%ebp
c01066f7:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c01066fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01066fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106702:	83 ec 0c             	sub    $0xc,%esp
c0106705:	50                   	push   %eax
c0106706:	e8 ee fe ff ff       	call   c01065f9 <pa2page>
c010670b:	83 c4 10             	add    $0x10,%esp
}
c010670e:	c9                   	leave  
c010670f:	c3                   	ret    

c0106710 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0106710:	55                   	push   %ebp
c0106711:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106713:	8b 45 08             	mov    0x8(%ebp),%eax
c0106716:	8b 00                	mov    (%eax),%eax
}
c0106718:	5d                   	pop    %ebp
c0106719:	c3                   	ret    

c010671a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010671a:	55                   	push   %ebp
c010671b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010671d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106720:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106723:	89 10                	mov    %edx,(%eax)
}
c0106725:	90                   	nop
c0106726:	5d                   	pop    %ebp
c0106727:	c3                   	ret    

c0106728 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106728:	55                   	push   %ebp
c0106729:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010672b:	8b 45 08             	mov    0x8(%ebp),%eax
c010672e:	8b 00                	mov    (%eax),%eax
c0106730:	8d 50 01             	lea    0x1(%eax),%edx
c0106733:	8b 45 08             	mov    0x8(%ebp),%eax
c0106736:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106738:	8b 45 08             	mov    0x8(%ebp),%eax
c010673b:	8b 00                	mov    (%eax),%eax
}
c010673d:	5d                   	pop    %ebp
c010673e:	c3                   	ret    

c010673f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010673f:	55                   	push   %ebp
c0106740:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106742:	8b 45 08             	mov    0x8(%ebp),%eax
c0106745:	8b 00                	mov    (%eax),%eax
c0106747:	8d 50 ff             	lea    -0x1(%eax),%edx
c010674a:	8b 45 08             	mov    0x8(%ebp),%eax
c010674d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010674f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106752:	8b 00                	mov    (%eax),%eax
}
c0106754:	5d                   	pop    %ebp
c0106755:	c3                   	ret    

c0106756 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0106756:	55                   	push   %ebp
c0106757:	89 e5                	mov    %esp,%ebp
c0106759:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010675c:	9c                   	pushf  
c010675d:	58                   	pop    %eax
c010675e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106761:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106764:	25 00 02 00 00       	and    $0x200,%eax
c0106769:	85 c0                	test   %eax,%eax
c010676b:	74 0c                	je     c0106779 <__intr_save+0x23>
        intr_disable();
c010676d:	e8 51 b9 ff ff       	call   c01020c3 <intr_disable>
        return 1;
c0106772:	b8 01 00 00 00       	mov    $0x1,%eax
c0106777:	eb 05                	jmp    c010677e <__intr_save+0x28>
    }
    return 0;
c0106779:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010677e:	c9                   	leave  
c010677f:	c3                   	ret    

c0106780 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0106780:	55                   	push   %ebp
c0106781:	89 e5                	mov    %esp,%ebp
c0106783:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010678a:	74 05                	je     c0106791 <__intr_restore+0x11>
        intr_enable();
c010678c:	e8 2b b9 ff ff       	call   c01020bc <intr_enable>
    }
}
c0106791:	90                   	nop
c0106792:	c9                   	leave  
c0106793:	c3                   	ret    

c0106794 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106794:	55                   	push   %ebp
c0106795:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106797:	8b 45 08             	mov    0x8(%ebp),%eax
c010679a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010679d:	b8 23 00 00 00       	mov    $0x23,%eax
c01067a2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01067a4:	b8 23 00 00 00       	mov    $0x23,%eax
c01067a9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01067ab:	b8 10 00 00 00       	mov    $0x10,%eax
c01067b0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01067b2:	b8 10 00 00 00       	mov    $0x10,%eax
c01067b7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01067b9:	b8 10 00 00 00       	mov    $0x10,%eax
c01067be:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01067c0:	ea c7 67 10 c0 08 00 	ljmp   $0x8,$0xc01067c7
}
c01067c7:	90                   	nop
c01067c8:	5d                   	pop    %ebp
c01067c9:	c3                   	ret    

c01067ca <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01067ca:	55                   	push   %ebp
c01067cb:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01067cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01067d0:	a3 a4 4f 12 c0       	mov    %eax,0xc0124fa4
}
c01067d5:	90                   	nop
c01067d6:	5d                   	pop    %ebp
c01067d7:	c3                   	ret    

c01067d8 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01067d8:	55                   	push   %ebp
c01067d9:	89 e5                	mov    %esp,%ebp
c01067db:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01067de:	b8 00 10 12 c0       	mov    $0xc0121000,%eax
c01067e3:	50                   	push   %eax
c01067e4:	e8 e1 ff ff ff       	call   c01067ca <load_esp0>
c01067e9:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c01067ec:	66 c7 05 a8 4f 12 c0 	movw   $0x10,0xc0124fa8
c01067f3:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01067f5:	66 c7 05 88 1a 12 c0 	movw   $0x68,0xc0121a88
c01067fc:	68 00 
c01067fe:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106803:	66 a3 8a 1a 12 c0    	mov    %ax,0xc0121a8a
c0106809:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c010680e:	c1 e8 10             	shr    $0x10,%eax
c0106811:	a2 8c 1a 12 c0       	mov    %al,0xc0121a8c
c0106816:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c010681d:	83 e0 f0             	and    $0xfffffff0,%eax
c0106820:	83 c8 09             	or     $0x9,%eax
c0106823:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106828:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c010682f:	83 e0 ef             	and    $0xffffffef,%eax
c0106832:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106837:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c010683e:	83 e0 9f             	and    $0xffffff9f,%eax
c0106841:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106846:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c010684d:	83 c8 80             	or     $0xffffff80,%eax
c0106850:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106855:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c010685c:	83 e0 f0             	and    $0xfffffff0,%eax
c010685f:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c0106864:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c010686b:	83 e0 ef             	and    $0xffffffef,%eax
c010686e:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c0106873:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c010687a:	83 e0 df             	and    $0xffffffdf,%eax
c010687d:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c0106882:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c0106889:	83 c8 40             	or     $0x40,%eax
c010688c:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c0106891:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c0106898:	83 e0 7f             	and    $0x7f,%eax
c010689b:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c01068a0:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c01068a5:	c1 e8 18             	shr    $0x18,%eax
c01068a8:	a2 8f 1a 12 c0       	mov    %al,0xc0121a8f

    // reload all segment registers
    lgdt(&gdt_pd);
c01068ad:	68 90 1a 12 c0       	push   $0xc0121a90
c01068b2:	e8 dd fe ff ff       	call   c0106794 <lgdt>
c01068b7:	83 c4 04             	add    $0x4,%esp
c01068ba:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01068c0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01068c4:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01068c7:	90                   	nop
c01068c8:	c9                   	leave  
c01068c9:	c3                   	ret    

c01068ca <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01068ca:	55                   	push   %ebp
c01068cb:	89 e5                	mov    %esp,%ebp
c01068cd:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c01068d0:	c7 05 50 51 12 c0 94 	movl   $0xc010a594,0xc0125150
c01068d7:	a5 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01068da:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c01068df:	8b 00                	mov    (%eax),%eax
c01068e1:	83 ec 08             	sub    $0x8,%esp
c01068e4:	50                   	push   %eax
c01068e5:	68 54 a6 10 c0       	push   $0xc010a654
c01068ea:	e8 9b 99 ff ff       	call   c010028a <cprintf>
c01068ef:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c01068f2:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c01068f7:	8b 40 04             	mov    0x4(%eax),%eax
c01068fa:	ff d0                	call   *%eax
}
c01068fc:	90                   	nop
c01068fd:	c9                   	leave  
c01068fe:	c3                   	ret    

c01068ff <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01068ff:	55                   	push   %ebp
c0106900:	89 e5                	mov    %esp,%ebp
c0106902:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0106905:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c010690a:	8b 40 08             	mov    0x8(%eax),%eax
c010690d:	83 ec 08             	sub    $0x8,%esp
c0106910:	ff 75 0c             	pushl  0xc(%ebp)
c0106913:	ff 75 08             	pushl  0x8(%ebp)
c0106916:	ff d0                	call   *%eax
c0106918:	83 c4 10             	add    $0x10,%esp
}
c010691b:	90                   	nop
c010691c:	c9                   	leave  
c010691d:	c3                   	ret    

c010691e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010691e:	55                   	push   %ebp
c010691f:	89 e5                	mov    %esp,%ebp
c0106921:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0106924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010692b:	e8 26 fe ff ff       	call   c0106756 <__intr_save>
c0106930:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106933:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c0106938:	8b 40 0c             	mov    0xc(%eax),%eax
c010693b:	83 ec 0c             	sub    $0xc,%esp
c010693e:	ff 75 08             	pushl  0x8(%ebp)
c0106941:	ff d0                	call   *%eax
c0106943:	83 c4 10             	add    $0x10,%esp
c0106946:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106949:	83 ec 0c             	sub    $0xc,%esp
c010694c:	ff 75 f0             	pushl  -0x10(%ebp)
c010694f:	e8 2c fe ff ff       	call   c0106780 <__intr_restore>
c0106954:	83 c4 10             	add    $0x10,%esp

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010695b:	75 28                	jne    c0106985 <alloc_pages+0x67>
c010695d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106961:	77 22                	ja     c0106985 <alloc_pages+0x67>
c0106963:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0106968:	85 c0                	test   %eax,%eax
c010696a:	74 19                	je     c0106985 <alloc_pages+0x67>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c010696c:	8b 55 08             	mov    0x8(%ebp),%edx
c010696f:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c0106974:	83 ec 04             	sub    $0x4,%esp
c0106977:	6a 00                	push   $0x0
c0106979:	52                   	push   %edx
c010697a:	50                   	push   %eax
c010697b:	e8 62 e3 ff ff       	call   c0104ce2 <swap_out>
c0106980:	83 c4 10             	add    $0x10,%esp
    }
c0106983:	eb a6                	jmp    c010692b <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0106985:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106988:	c9                   	leave  
c0106989:	c3                   	ret    

c010698a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c010698a:	55                   	push   %ebp
c010698b:	89 e5                	mov    %esp,%ebp
c010698d:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0106990:	e8 c1 fd ff ff       	call   c0106756 <__intr_save>
c0106995:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106998:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c010699d:	8b 40 10             	mov    0x10(%eax),%eax
c01069a0:	83 ec 08             	sub    $0x8,%esp
c01069a3:	ff 75 0c             	pushl  0xc(%ebp)
c01069a6:	ff 75 08             	pushl  0x8(%ebp)
c01069a9:	ff d0                	call   *%eax
c01069ab:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c01069ae:	83 ec 0c             	sub    $0xc,%esp
c01069b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01069b4:	e8 c7 fd ff ff       	call   c0106780 <__intr_restore>
c01069b9:	83 c4 10             	add    $0x10,%esp
}
c01069bc:	90                   	nop
c01069bd:	c9                   	leave  
c01069be:	c3                   	ret    

c01069bf <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01069bf:	55                   	push   %ebp
c01069c0:	89 e5                	mov    %esp,%ebp
c01069c2:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01069c5:	e8 8c fd ff ff       	call   c0106756 <__intr_save>
c01069ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01069cd:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c01069d2:	8b 40 14             	mov    0x14(%eax),%eax
c01069d5:	ff d0                	call   *%eax
c01069d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01069da:	83 ec 0c             	sub    $0xc,%esp
c01069dd:	ff 75 f4             	pushl  -0xc(%ebp)
c01069e0:	e8 9b fd ff ff       	call   c0106780 <__intr_restore>
c01069e5:	83 c4 10             	add    $0x10,%esp
    return ret;
c01069e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01069eb:	c9                   	leave  
c01069ec:	c3                   	ret    

c01069ed <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01069ed:	55                   	push   %ebp
c01069ee:	89 e5                	mov    %esp,%ebp
c01069f0:	57                   	push   %edi
c01069f1:	56                   	push   %esi
c01069f2:	53                   	push   %ebx
c01069f3:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01069f6:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01069fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0106a04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0106a0b:	83 ec 0c             	sub    $0xc,%esp
c0106a0e:	68 6b a6 10 c0       	push   $0xc010a66b
c0106a13:	e8 72 98 ff ff       	call   c010028a <cprintf>
c0106a18:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106a1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106a22:	e9 fc 00 00 00       	jmp    c0106b23 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106a27:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a2d:	89 d0                	mov    %edx,%eax
c0106a2f:	c1 e0 02             	shl    $0x2,%eax
c0106a32:	01 d0                	add    %edx,%eax
c0106a34:	c1 e0 02             	shl    $0x2,%eax
c0106a37:	01 c8                	add    %ecx,%eax
c0106a39:	8b 50 08             	mov    0x8(%eax),%edx
c0106a3c:	8b 40 04             	mov    0x4(%eax),%eax
c0106a3f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106a42:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0106a45:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a48:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a4b:	89 d0                	mov    %edx,%eax
c0106a4d:	c1 e0 02             	shl    $0x2,%eax
c0106a50:	01 d0                	add    %edx,%eax
c0106a52:	c1 e0 02             	shl    $0x2,%eax
c0106a55:	01 c8                	add    %ecx,%eax
c0106a57:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106a5a:	8b 58 10             	mov    0x10(%eax),%ebx
c0106a5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106a60:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106a63:	01 c8                	add    %ecx,%eax
c0106a65:	11 da                	adc    %ebx,%edx
c0106a67:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106a6a:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106a6d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a70:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a73:	89 d0                	mov    %edx,%eax
c0106a75:	c1 e0 02             	shl    $0x2,%eax
c0106a78:	01 d0                	add    %edx,%eax
c0106a7a:	c1 e0 02             	shl    $0x2,%eax
c0106a7d:	01 c8                	add    %ecx,%eax
c0106a7f:	83 c0 14             	add    $0x14,%eax
c0106a82:	8b 00                	mov    (%eax),%eax
c0106a84:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0106a87:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106a8a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106a8d:	83 c0 ff             	add    $0xffffffff,%eax
c0106a90:	83 d2 ff             	adc    $0xffffffff,%edx
c0106a93:	89 c1                	mov    %eax,%ecx
c0106a95:	89 d3                	mov    %edx,%ebx
c0106a97:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106a9a:	89 55 80             	mov    %edx,-0x80(%ebp)
c0106a9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106aa0:	89 d0                	mov    %edx,%eax
c0106aa2:	c1 e0 02             	shl    $0x2,%eax
c0106aa5:	01 d0                	add    %edx,%eax
c0106aa7:	c1 e0 02             	shl    $0x2,%eax
c0106aaa:	03 45 80             	add    -0x80(%ebp),%eax
c0106aad:	8b 50 10             	mov    0x10(%eax),%edx
c0106ab0:	8b 40 0c             	mov    0xc(%eax),%eax
c0106ab3:	ff 75 84             	pushl  -0x7c(%ebp)
c0106ab6:	53                   	push   %ebx
c0106ab7:	51                   	push   %ecx
c0106ab8:	ff 75 bc             	pushl  -0x44(%ebp)
c0106abb:	ff 75 b8             	pushl  -0x48(%ebp)
c0106abe:	52                   	push   %edx
c0106abf:	50                   	push   %eax
c0106ac0:	68 78 a6 10 c0       	push   $0xc010a678
c0106ac5:	e8 c0 97 ff ff       	call   c010028a <cprintf>
c0106aca:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0106acd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106ad0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ad3:	89 d0                	mov    %edx,%eax
c0106ad5:	c1 e0 02             	shl    $0x2,%eax
c0106ad8:	01 d0                	add    %edx,%eax
c0106ada:	c1 e0 02             	shl    $0x2,%eax
c0106add:	01 c8                	add    %ecx,%eax
c0106adf:	83 c0 14             	add    $0x14,%eax
c0106ae2:	8b 00                	mov    (%eax),%eax
c0106ae4:	83 f8 01             	cmp    $0x1,%eax
c0106ae7:	75 36                	jne    c0106b1f <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0106ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106aec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106aef:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106af2:	77 2b                	ja     c0106b1f <page_init+0x132>
c0106af4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106af7:	72 05                	jb     c0106afe <page_init+0x111>
c0106af9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0106afc:	73 21                	jae    c0106b1f <page_init+0x132>
c0106afe:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106b02:	77 1b                	ja     c0106b1f <page_init+0x132>
c0106b04:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106b08:	72 09                	jb     c0106b13 <page_init+0x126>
c0106b0a:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0106b11:	77 0c                	ja     c0106b1f <page_init+0x132>
                maxpa = end;
c0106b13:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106b16:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106b19:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106b1c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106b1f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106b23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106b26:	8b 00                	mov    (%eax),%eax
c0106b28:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106b2b:	0f 8f f6 fe ff ff    	jg     c0106a27 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106b31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106b35:	72 1d                	jb     c0106b54 <page_init+0x167>
c0106b37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106b3b:	77 09                	ja     c0106b46 <page_init+0x159>
c0106b3d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0106b44:	76 0e                	jbe    c0106b54 <page_init+0x167>
        maxpa = KMEMSIZE;
c0106b46:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106b4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0106b54:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b5a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106b5e:	c1 ea 0c             	shr    $0xc,%edx
c0106b61:	a3 80 4f 12 c0       	mov    %eax,0xc0124f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0106b66:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0106b6d:	b8 5c 51 12 c0       	mov    $0xc012515c,%eax
c0106b72:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106b75:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106b78:	01 d0                	add    %edx,%eax
c0106b7a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106b7d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106b80:	ba 00 00 00 00       	mov    $0x0,%edx
c0106b85:	f7 75 ac             	divl   -0x54(%ebp)
c0106b88:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106b8b:	29 d0                	sub    %edx,%eax
c0106b8d:	a3 58 51 12 c0       	mov    %eax,0xc0125158

    for (i = 0; i < npage; i ++) {
c0106b92:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106b99:	eb 27                	jmp    c0106bc2 <page_init+0x1d5>
        SetPageReserved(pages + i);
c0106b9b:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0106ba0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ba3:	c1 e2 05             	shl    $0x5,%edx
c0106ba6:	01 d0                	add    %edx,%eax
c0106ba8:	83 c0 04             	add    $0x4,%eax
c0106bab:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0106bb2:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106bb5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106bb8:	8b 55 90             	mov    -0x70(%ebp),%edx
c0106bbb:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0106bbe:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106bc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106bc5:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106bca:	39 c2                	cmp    %eax,%edx
c0106bcc:	72 cd                	jb     c0106b9b <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0106bce:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106bd3:	c1 e0 05             	shl    $0x5,%eax
c0106bd6:	89 c2                	mov    %eax,%edx
c0106bd8:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0106bdd:	01 d0                	add    %edx,%eax
c0106bdf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0106be2:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0106be9:	77 17                	ja     c0106c02 <page_init+0x215>
c0106beb:	ff 75 a4             	pushl  -0x5c(%ebp)
c0106bee:	68 04 a6 10 c0       	push   $0xc010a604
c0106bf3:	68 e9 00 00 00       	push   $0xe9
c0106bf8:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0106bfd:	e8 ee 97 ff ff       	call   c01003f0 <__panic>
c0106c02:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106c05:	05 00 00 00 40       	add    $0x40000000,%eax
c0106c0a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0106c0d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106c14:	e9 69 01 00 00       	jmp    c0106d82 <page_init+0x395>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106c19:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106c1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c1f:	89 d0                	mov    %edx,%eax
c0106c21:	c1 e0 02             	shl    $0x2,%eax
c0106c24:	01 d0                	add    %edx,%eax
c0106c26:	c1 e0 02             	shl    $0x2,%eax
c0106c29:	01 c8                	add    %ecx,%eax
c0106c2b:	8b 50 08             	mov    0x8(%eax),%edx
c0106c2e:	8b 40 04             	mov    0x4(%eax),%eax
c0106c31:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106c34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106c37:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106c3a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c3d:	89 d0                	mov    %edx,%eax
c0106c3f:	c1 e0 02             	shl    $0x2,%eax
c0106c42:	01 d0                	add    %edx,%eax
c0106c44:	c1 e0 02             	shl    $0x2,%eax
c0106c47:	01 c8                	add    %ecx,%eax
c0106c49:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106c4c:	8b 58 10             	mov    0x10(%eax),%ebx
c0106c4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106c55:	01 c8                	add    %ecx,%eax
c0106c57:	11 da                	adc    %ebx,%edx
c0106c59:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106c5c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0106c5f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106c62:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c65:	89 d0                	mov    %edx,%eax
c0106c67:	c1 e0 02             	shl    $0x2,%eax
c0106c6a:	01 d0                	add    %edx,%eax
c0106c6c:	c1 e0 02             	shl    $0x2,%eax
c0106c6f:	01 c8                	add    %ecx,%eax
c0106c71:	83 c0 14             	add    $0x14,%eax
c0106c74:	8b 00                	mov    (%eax),%eax
c0106c76:	83 f8 01             	cmp    $0x1,%eax
c0106c79:	0f 85 ff 00 00 00    	jne    c0106d7e <page_init+0x391>
            if (begin < freemem) {
c0106c7f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106c82:	ba 00 00 00 00       	mov    $0x0,%edx
c0106c87:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106c8a:	72 17                	jb     c0106ca3 <page_init+0x2b6>
c0106c8c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106c8f:	77 05                	ja     c0106c96 <page_init+0x2a9>
c0106c91:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0106c94:	76 0d                	jbe    c0106ca3 <page_init+0x2b6>
                begin = freemem;
c0106c96:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106c99:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106c9c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0106ca3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106ca7:	72 1d                	jb     c0106cc6 <page_init+0x2d9>
c0106ca9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106cad:	77 09                	ja     c0106cb8 <page_init+0x2cb>
c0106caf:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0106cb6:	76 0e                	jbe    c0106cc6 <page_init+0x2d9>
                end = KMEMSIZE;
c0106cb8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0106cbf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0106cc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106cc9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106ccc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106ccf:	0f 87 a9 00 00 00    	ja     c0106d7e <page_init+0x391>
c0106cd5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106cd8:	72 09                	jb     c0106ce3 <page_init+0x2f6>
c0106cda:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106cdd:	0f 83 9b 00 00 00    	jae    c0106d7e <page_init+0x391>
                begin = ROUNDUP(begin, PGSIZE);
c0106ce3:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0106cea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106ced:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106cf0:	01 d0                	add    %edx,%eax
c0106cf2:	83 e8 01             	sub    $0x1,%eax
c0106cf5:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106cf8:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106cfb:	ba 00 00 00 00       	mov    $0x0,%edx
c0106d00:	f7 75 9c             	divl   -0x64(%ebp)
c0106d03:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106d06:	29 d0                	sub    %edx,%eax
c0106d08:	ba 00 00 00 00       	mov    $0x0,%edx
c0106d0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106d10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0106d13:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106d16:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0106d19:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106d1c:	ba 00 00 00 00       	mov    $0x0,%edx
c0106d21:	89 c3                	mov    %eax,%ebx
c0106d23:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0106d29:	89 de                	mov    %ebx,%esi
c0106d2b:	89 d0                	mov    %edx,%eax
c0106d2d:	83 e0 00             	and    $0x0,%eax
c0106d30:	89 c7                	mov    %eax,%edi
c0106d32:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0106d35:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0106d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106d3e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106d41:	77 3b                	ja     c0106d7e <page_init+0x391>
c0106d43:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106d46:	72 05                	jb     c0106d4d <page_init+0x360>
c0106d48:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106d4b:	73 31                	jae    c0106d7e <page_init+0x391>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0106d4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106d50:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106d53:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0106d56:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0106d59:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106d5d:	c1 ea 0c             	shr    $0xc,%edx
c0106d60:	89 c3                	mov    %eax,%ebx
c0106d62:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d65:	83 ec 0c             	sub    $0xc,%esp
c0106d68:	50                   	push   %eax
c0106d69:	e8 8b f8 ff ff       	call   c01065f9 <pa2page>
c0106d6e:	83 c4 10             	add    $0x10,%esp
c0106d71:	83 ec 08             	sub    $0x8,%esp
c0106d74:	53                   	push   %ebx
c0106d75:	50                   	push   %eax
c0106d76:	e8 84 fb ff ff       	call   c01068ff <init_memmap>
c0106d7b:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0106d7e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106d82:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106d85:	8b 00                	mov    (%eax),%eax
c0106d87:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106d8a:	0f 8f 89 fe ff ff    	jg     c0106c19 <page_init+0x22c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0106d90:	90                   	nop
c0106d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106d94:	5b                   	pop    %ebx
c0106d95:	5e                   	pop    %esi
c0106d96:	5f                   	pop    %edi
c0106d97:	5d                   	pop    %ebp
c0106d98:	c3                   	ret    

c0106d99 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0106d99:	55                   	push   %ebp
c0106d9a:	89 e5                	mov    %esp,%ebp
c0106d9c:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0106d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106da2:	33 45 14             	xor    0x14(%ebp),%eax
c0106da5:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106daa:	85 c0                	test   %eax,%eax
c0106dac:	74 19                	je     c0106dc7 <boot_map_segment+0x2e>
c0106dae:	68 b6 a6 10 c0       	push   $0xc010a6b6
c0106db3:	68 cd a6 10 c0       	push   $0xc010a6cd
c0106db8:	68 07 01 00 00       	push   $0x107
c0106dbd:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0106dc2:	e8 29 96 ff ff       	call   c01003f0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0106dc7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0106dce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dd1:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106dd6:	89 c2                	mov    %eax,%edx
c0106dd8:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ddb:	01 c2                	add    %eax,%edx
c0106ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106de0:	01 d0                	add    %edx,%eax
c0106de2:	83 e8 01             	sub    $0x1,%eax
c0106de5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106deb:	ba 00 00 00 00       	mov    $0x0,%edx
c0106df0:	f7 75 f0             	divl   -0x10(%ebp)
c0106df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106df6:	29 d0                	sub    %edx,%eax
c0106df8:	c1 e8 0c             	shr    $0xc,%eax
c0106dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0106dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e01:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106e07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106e0c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0106e0f:	8b 45 14             	mov    0x14(%ebp),%eax
c0106e12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106e1d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0106e20:	eb 57                	jmp    c0106e79 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0106e22:	83 ec 04             	sub    $0x4,%esp
c0106e25:	6a 01                	push   $0x1
c0106e27:	ff 75 0c             	pushl  0xc(%ebp)
c0106e2a:	ff 75 08             	pushl  0x8(%ebp)
c0106e2d:	e8 53 01 00 00       	call   c0106f85 <get_pte>
c0106e32:	83 c4 10             	add    $0x10,%esp
c0106e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0106e38:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106e3c:	75 19                	jne    c0106e57 <boot_map_segment+0xbe>
c0106e3e:	68 e2 a6 10 c0       	push   $0xc010a6e2
c0106e43:	68 cd a6 10 c0       	push   $0xc010a6cd
c0106e48:	68 0d 01 00 00       	push   $0x10d
c0106e4d:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0106e52:	e8 99 95 ff ff       	call   c01003f0 <__panic>
        *ptep = pa | PTE_P | perm;
c0106e57:	8b 45 14             	mov    0x14(%ebp),%eax
c0106e5a:	0b 45 18             	or     0x18(%ebp),%eax
c0106e5d:	83 c8 01             	or     $0x1,%eax
c0106e60:	89 c2                	mov    %eax,%edx
c0106e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e65:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0106e67:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106e6b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0106e72:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0106e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e7d:	75 a3                	jne    c0106e22 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0106e7f:	90                   	nop
c0106e80:	c9                   	leave  
c0106e81:	c3                   	ret    

c0106e82 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0106e82:	55                   	push   %ebp
c0106e83:	89 e5                	mov    %esp,%ebp
c0106e85:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0106e88:	83 ec 0c             	sub    $0xc,%esp
c0106e8b:	6a 01                	push   $0x1
c0106e8d:	e8 8c fa ff ff       	call   c010691e <alloc_pages>
c0106e92:	83 c4 10             	add    $0x10,%esp
c0106e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0106e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e9c:	75 17                	jne    c0106eb5 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0106e9e:	83 ec 04             	sub    $0x4,%esp
c0106ea1:	68 ef a6 10 c0       	push   $0xc010a6ef
c0106ea6:	68 19 01 00 00       	push   $0x119
c0106eab:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0106eb0:	e8 3b 95 ff ff       	call   c01003f0 <__panic>
    }
    return page2kva(p);
c0106eb5:	83 ec 0c             	sub    $0xc,%esp
c0106eb8:	ff 75 f4             	pushl  -0xc(%ebp)
c0106ebb:	e8 76 f7 ff ff       	call   c0106636 <page2kva>
c0106ec0:	83 c4 10             	add    $0x10,%esp
}
c0106ec3:	c9                   	leave  
c0106ec4:	c3                   	ret    

c0106ec5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0106ec5:	55                   	push   %ebp
c0106ec6:	89 e5                	mov    %esp,%ebp
c0106ec8:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0106ecb:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106ed3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0106eda:	77 17                	ja     c0106ef3 <pmm_init+0x2e>
c0106edc:	ff 75 f4             	pushl  -0xc(%ebp)
c0106edf:	68 04 a6 10 c0       	push   $0xc010a604
c0106ee4:	68 23 01 00 00       	push   $0x123
c0106ee9:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0106eee:	e8 fd 94 ff ff       	call   c01003f0 <__panic>
c0106ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ef6:	05 00 00 00 40       	add    $0x40000000,%eax
c0106efb:	a3 54 51 12 c0       	mov    %eax,0xc0125154
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0106f00:	e8 c5 f9 ff ff       	call   c01068ca <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0106f05:	e8 e3 fa ff ff       	call   c01069ed <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0106f0a:	e8 66 04 00 00       	call   c0107375 <check_alloc_page>

    check_pgdir();
c0106f0f:	e8 84 04 00 00       	call   c0107398 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0106f14:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106f19:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0106f1f:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106f27:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0106f2e:	77 17                	ja     c0106f47 <pmm_init+0x82>
c0106f30:	ff 75 f0             	pushl  -0x10(%ebp)
c0106f33:	68 04 a6 10 c0       	push   $0xc010a604
c0106f38:	68 39 01 00 00       	push   $0x139
c0106f3d:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0106f42:	e8 a9 94 ff ff       	call   c01003f0 <__panic>
c0106f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f4a:	05 00 00 00 40       	add    $0x40000000,%eax
c0106f4f:	83 c8 03             	or     $0x3,%eax
c0106f52:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0106f54:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106f59:	83 ec 0c             	sub    $0xc,%esp
c0106f5c:	6a 02                	push   $0x2
c0106f5e:	6a 00                	push   $0x0
c0106f60:	68 00 00 00 38       	push   $0x38000000
c0106f65:	68 00 00 00 c0       	push   $0xc0000000
c0106f6a:	50                   	push   %eax
c0106f6b:	e8 29 fe ff ff       	call   c0106d99 <boot_map_segment>
c0106f70:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0106f73:	e8 60 f8 ff ff       	call   c01067d8 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0106f78:	e8 81 09 00 00       	call   c01078fe <check_boot_pgdir>

    print_pgdir();
c0106f7d:	e8 77 0d 00 00       	call   c0107cf9 <print_pgdir>

}
c0106f82:	90                   	nop
c0106f83:	c9                   	leave  
c0106f84:	c3                   	ret    

c0106f85 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0106f85:	55                   	push   %ebp
c0106f86:	89 e5                	mov    %esp,%ebp
c0106f88:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
c0106f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f8e:	c1 e8 16             	shr    $0x16,%eax
c0106f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
c0106f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106f9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fa1:	01 d0                	add    %edx,%eax
c0106fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
c0106fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fa9:	8b 00                	mov    (%eax),%eax
c0106fab:	83 e0 01             	and    $0x1,%eax
c0106fae:	85 c0                	test   %eax,%eax
c0106fb0:	0f 85 ae 00 00 00    	jne    c0107064 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
c0106fb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106fba:	75 0a                	jne    c0106fc6 <get_pte+0x41>
            return NULL;
c0106fbc:	b8 00 00 00 00       	mov    $0x0,%eax
c0106fc1:	e9 01 01 00 00       	jmp    c01070c7 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
c0106fc6:	83 ec 0c             	sub    $0xc,%esp
c0106fc9:	6a 01                	push   $0x1
c0106fcb:	e8 4e f9 ff ff       	call   c010691e <alloc_pages>
c0106fd0:	83 c4 10             	add    $0x10,%esp
c0106fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
c0106fd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106fda:	75 0a                	jne    c0106fe6 <get_pte+0x61>
            return NULL;
c0106fdc:	b8 00 00 00 00       	mov    $0x0,%eax
c0106fe1:	e9 e1 00 00 00       	jmp    c01070c7 <get_pte+0x142>
        }
        // (4) set page reference
        set_page_ref(pt_page, 1);
c0106fe6:	83 ec 08             	sub    $0x8,%esp
c0106fe9:	6a 01                	push   $0x1
c0106feb:	ff 75 ec             	pushl  -0x14(%ebp)
c0106fee:	e8 27 f7 ff ff       	call   c010671a <set_page_ref>
c0106ff3:	83 c4 10             	add    $0x10,%esp
        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
c0106ff6:	83 ec 0c             	sub    $0xc,%esp
c0106ff9:	ff 75 ec             	pushl  -0x14(%ebp)
c0106ffc:	e8 e5 f5 ff ff       	call   c01065e6 <page2pa>
c0107001:	83 c4 10             	add    $0x10,%esp
c0107004:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
c0107007:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010700a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010700d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107010:	c1 e8 0c             	shr    $0xc,%eax
c0107013:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107016:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010701b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010701e:	72 17                	jb     c0107037 <get_pte+0xb2>
c0107020:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107023:	68 e0 a5 10 c0       	push   $0xc010a5e0
c0107028:	68 8a 01 00 00       	push   $0x18a
c010702d:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107032:	e8 b9 93 ff ff       	call   c01003f0 <__panic>
c0107037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010703a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010703f:	83 ec 04             	sub    $0x4,%esp
c0107042:	68 00 10 00 00       	push   $0x1000
c0107047:	6a 00                	push   $0x0
c0107049:	50                   	push   %eax
c010704a:	e8 a8 13 00 00       	call   c01083f7 <memset>
c010704f:	83 c4 10             	add    $0x10,%esp
        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
c0107052:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010705a:	83 c8 07             	or     $0x7,%eax
c010705d:	89 c2                	mov    %eax,%edx
c010705f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107062:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
c0107064:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107067:	c1 e8 0c             	shr    $0xc,%eax
c010706a:	25 ff 03 00 00       	and    $0x3ff,%eax
c010706f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
c0107072:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107075:	8b 00                	mov    (%eax),%eax
c0107077:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010707c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
c010707f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107082:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0107085:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107088:	c1 e8 0c             	shr    $0xc,%eax
c010708b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010708e:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107093:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0107096:	72 17                	jb     c01070af <get_pte+0x12a>
c0107098:	ff 75 d4             	pushl  -0x2c(%ebp)
c010709b:	68 e0 a5 10 c0       	push   $0xc010a5e0
c01070a0:	68 91 01 00 00       	push   $0x191
c01070a5:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01070aa:	e8 41 93 ff ff       	call   c01003f0 <__panic>
c01070af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01070b2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01070b7:	89 c2                	mov    %eax,%edx
c01070b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01070bc:	c1 e0 02             	shl    $0x2,%eax
c01070bf:	01 d0                	add    %edx,%eax
c01070c1:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
c01070c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
c01070c7:	c9                   	leave  
c01070c8:	c3                   	ret    

c01070c9 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01070c9:	55                   	push   %ebp
c01070ca:	89 e5                	mov    %esp,%ebp
c01070cc:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01070cf:	83 ec 04             	sub    $0x4,%esp
c01070d2:	6a 00                	push   $0x0
c01070d4:	ff 75 0c             	pushl  0xc(%ebp)
c01070d7:	ff 75 08             	pushl  0x8(%ebp)
c01070da:	e8 a6 fe ff ff       	call   c0106f85 <get_pte>
c01070df:	83 c4 10             	add    $0x10,%esp
c01070e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01070e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01070e9:	74 08                	je     c01070f3 <get_page+0x2a>
        *ptep_store = ptep;
c01070eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01070ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01070f1:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01070f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01070f7:	74 1f                	je     c0107118 <get_page+0x4f>
c01070f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070fc:	8b 00                	mov    (%eax),%eax
c01070fe:	83 e0 01             	and    $0x1,%eax
c0107101:	85 c0                	test   %eax,%eax
c0107103:	74 13                	je     c0107118 <get_page+0x4f>
        return pte2page(*ptep);
c0107105:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107108:	8b 00                	mov    (%eax),%eax
c010710a:	83 ec 0c             	sub    $0xc,%esp
c010710d:	50                   	push   %eax
c010710e:	e8 a7 f5 ff ff       	call   c01066ba <pte2page>
c0107113:	83 c4 10             	add    $0x10,%esp
c0107116:	eb 05                	jmp    c010711d <get_page+0x54>
    }
    return NULL;
c0107118:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010711d:	c9                   	leave  
c010711e:	c3                   	ret    

c010711f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010711f:	55                   	push   %ebp
c0107120:	89 e5                	mov    %esp,%ebp
c0107122:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
c0107125:	8b 45 10             	mov    0x10(%ebp),%eax
c0107128:	8b 00                	mov    (%eax),%eax
c010712a:	83 e0 01             	and    $0x1,%eax
c010712d:	85 c0                	test   %eax,%eax
c010712f:	74 57                	je     c0107188 <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
c0107131:	8b 45 10             	mov    0x10(%ebp),%eax
c0107134:	8b 00                	mov    (%eax),%eax
c0107136:	83 ec 0c             	sub    $0xc,%esp
c0107139:	50                   	push   %eax
c010713a:	e8 7b f5 ff ff       	call   c01066ba <pte2page>
c010713f:	83 c4 10             	add    $0x10,%esp
c0107142:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //(3) decrease page reference
    page_ref_dec(page);
c0107145:	83 ec 0c             	sub    $0xc,%esp
c0107148:	ff 75 f4             	pushl  -0xc(%ebp)
c010714b:	e8 ef f5 ff ff       	call   c010673f <page_ref_dec>
c0107150:	83 c4 10             	add    $0x10,%esp
    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
c0107153:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107156:	8b 00                	mov    (%eax),%eax
c0107158:	85 c0                	test   %eax,%eax
c010715a:	75 10                	jne    c010716c <page_remove_pte+0x4d>
        free_page(page);
c010715c:	83 ec 08             	sub    $0x8,%esp
c010715f:	6a 01                	push   $0x1
c0107161:	ff 75 f4             	pushl  -0xc(%ebp)
c0107164:	e8 21 f8 ff ff       	call   c010698a <free_pages>
c0107169:	83 c4 10             	add    $0x10,%esp
    }
    //(5) clear second page table entry
    *ptep = 0;
c010716c:	8b 45 10             	mov    0x10(%ebp),%eax
c010716f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
c0107175:	83 ec 08             	sub    $0x8,%esp
c0107178:	ff 75 0c             	pushl  0xc(%ebp)
c010717b:	ff 75 08             	pushl  0x8(%ebp)
c010717e:	e8 fa 00 00 00       	call   c010727d <tlb_invalidate>
c0107183:	83 c4 10             	add    $0x10,%esp
c0107186:	eb 01                	jmp    c0107189 <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
c0107188:	90                   	nop
    }
    //(5) clear second page table entry
    *ptep = 0;
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
c0107189:	c9                   	leave  
c010718a:	c3                   	ret    

c010718b <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010718b:	55                   	push   %ebp
c010718c:	89 e5                	mov    %esp,%ebp
c010718e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0107191:	83 ec 04             	sub    $0x4,%esp
c0107194:	6a 00                	push   $0x0
c0107196:	ff 75 0c             	pushl  0xc(%ebp)
c0107199:	ff 75 08             	pushl  0x8(%ebp)
c010719c:	e8 e4 fd ff ff       	call   c0106f85 <get_pte>
c01071a1:	83 c4 10             	add    $0x10,%esp
c01071a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01071a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071ab:	74 14                	je     c01071c1 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c01071ad:	83 ec 04             	sub    $0x4,%esp
c01071b0:	ff 75 f4             	pushl  -0xc(%ebp)
c01071b3:	ff 75 0c             	pushl  0xc(%ebp)
c01071b6:	ff 75 08             	pushl  0x8(%ebp)
c01071b9:	e8 61 ff ff ff       	call   c010711f <page_remove_pte>
c01071be:	83 c4 10             	add    $0x10,%esp
    }
}
c01071c1:	90                   	nop
c01071c2:	c9                   	leave  
c01071c3:	c3                   	ret    

c01071c4 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01071c4:	55                   	push   %ebp
c01071c5:	89 e5                	mov    %esp,%ebp
c01071c7:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01071ca:	83 ec 04             	sub    $0x4,%esp
c01071cd:	6a 01                	push   $0x1
c01071cf:	ff 75 10             	pushl  0x10(%ebp)
c01071d2:	ff 75 08             	pushl  0x8(%ebp)
c01071d5:	e8 ab fd ff ff       	call   c0106f85 <get_pte>
c01071da:	83 c4 10             	add    $0x10,%esp
c01071dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01071e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071e4:	75 0a                	jne    c01071f0 <page_insert+0x2c>
        return -E_NO_MEM;
c01071e6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01071eb:	e9 8b 00 00 00       	jmp    c010727b <page_insert+0xb7>
    }
    page_ref_inc(page);
c01071f0:	83 ec 0c             	sub    $0xc,%esp
c01071f3:	ff 75 0c             	pushl  0xc(%ebp)
c01071f6:	e8 2d f5 ff ff       	call   c0106728 <page_ref_inc>
c01071fb:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01071fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107201:	8b 00                	mov    (%eax),%eax
c0107203:	83 e0 01             	and    $0x1,%eax
c0107206:	85 c0                	test   %eax,%eax
c0107208:	74 40                	je     c010724a <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c010720a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010720d:	8b 00                	mov    (%eax),%eax
c010720f:	83 ec 0c             	sub    $0xc,%esp
c0107212:	50                   	push   %eax
c0107213:	e8 a2 f4 ff ff       	call   c01066ba <pte2page>
c0107218:	83 c4 10             	add    $0x10,%esp
c010721b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010721e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107221:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107224:	75 10                	jne    c0107236 <page_insert+0x72>
            page_ref_dec(page);
c0107226:	83 ec 0c             	sub    $0xc,%esp
c0107229:	ff 75 0c             	pushl  0xc(%ebp)
c010722c:	e8 0e f5 ff ff       	call   c010673f <page_ref_dec>
c0107231:	83 c4 10             	add    $0x10,%esp
c0107234:	eb 14                	jmp    c010724a <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0107236:	83 ec 04             	sub    $0x4,%esp
c0107239:	ff 75 f4             	pushl  -0xc(%ebp)
c010723c:	ff 75 10             	pushl  0x10(%ebp)
c010723f:	ff 75 08             	pushl  0x8(%ebp)
c0107242:	e8 d8 fe ff ff       	call   c010711f <page_remove_pte>
c0107247:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010724a:	83 ec 0c             	sub    $0xc,%esp
c010724d:	ff 75 0c             	pushl  0xc(%ebp)
c0107250:	e8 91 f3 ff ff       	call   c01065e6 <page2pa>
c0107255:	83 c4 10             	add    $0x10,%esp
c0107258:	0b 45 14             	or     0x14(%ebp),%eax
c010725b:	83 c8 01             	or     $0x1,%eax
c010725e:	89 c2                	mov    %eax,%edx
c0107260:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107263:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0107265:	83 ec 08             	sub    $0x8,%esp
c0107268:	ff 75 10             	pushl  0x10(%ebp)
c010726b:	ff 75 08             	pushl  0x8(%ebp)
c010726e:	e8 0a 00 00 00       	call   c010727d <tlb_invalidate>
c0107273:	83 c4 10             	add    $0x10,%esp
    return 0;
c0107276:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010727b:	c9                   	leave  
c010727c:	c3                   	ret    

c010727d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010727d:	55                   	push   %ebp
c010727e:	89 e5                	mov    %esp,%ebp
c0107280:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0107283:	0f 20 d8             	mov    %cr3,%eax
c0107286:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0107289:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010728c:	8b 45 08             	mov    0x8(%ebp),%eax
c010728f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107292:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107299:	77 17                	ja     c01072b2 <tlb_invalidate+0x35>
c010729b:	ff 75 f0             	pushl  -0x10(%ebp)
c010729e:	68 04 a6 10 c0       	push   $0xc010a604
c01072a3:	68 fc 01 00 00       	push   $0x1fc
c01072a8:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01072ad:	e8 3e 91 ff ff       	call   c01003f0 <__panic>
c01072b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072b5:	05 00 00 00 40       	add    $0x40000000,%eax
c01072ba:	39 c2                	cmp    %eax,%edx
c01072bc:	75 0c                	jne    c01072ca <tlb_invalidate+0x4d>
        invlpg((void *)la);
c01072be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01072c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072c7:	0f 01 38             	invlpg (%eax)
    }
}
c01072ca:	90                   	nop
c01072cb:	c9                   	leave  
c01072cc:	c3                   	ret    

c01072cd <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01072cd:	55                   	push   %ebp
c01072ce:	89 e5                	mov    %esp,%ebp
c01072d0:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_page();
c01072d3:	83 ec 0c             	sub    $0xc,%esp
c01072d6:	6a 01                	push   $0x1
c01072d8:	e8 41 f6 ff ff       	call   c010691e <alloc_pages>
c01072dd:	83 c4 10             	add    $0x10,%esp
c01072e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01072e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01072e7:	0f 84 83 00 00 00    	je     c0107370 <pgdir_alloc_page+0xa3>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01072ed:	ff 75 10             	pushl  0x10(%ebp)
c01072f0:	ff 75 0c             	pushl  0xc(%ebp)
c01072f3:	ff 75 f4             	pushl  -0xc(%ebp)
c01072f6:	ff 75 08             	pushl  0x8(%ebp)
c01072f9:	e8 c6 fe ff ff       	call   c01071c4 <page_insert>
c01072fe:	83 c4 10             	add    $0x10,%esp
c0107301:	85 c0                	test   %eax,%eax
c0107303:	74 17                	je     c010731c <pgdir_alloc_page+0x4f>
            free_page(page);
c0107305:	83 ec 08             	sub    $0x8,%esp
c0107308:	6a 01                	push   $0x1
c010730a:	ff 75 f4             	pushl  -0xc(%ebp)
c010730d:	e8 78 f6 ff ff       	call   c010698a <free_pages>
c0107312:	83 c4 10             	add    $0x10,%esp
            return NULL;
c0107315:	b8 00 00 00 00       	mov    $0x0,%eax
c010731a:	eb 57                	jmp    c0107373 <pgdir_alloc_page+0xa6>
        }
        if (swap_init_ok){
c010731c:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0107321:	85 c0                	test   %eax,%eax
c0107323:	74 4b                	je     c0107370 <pgdir_alloc_page+0xa3>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0107325:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c010732a:	6a 00                	push   $0x0
c010732c:	ff 75 f4             	pushl  -0xc(%ebp)
c010732f:	ff 75 0c             	pushl  0xc(%ebp)
c0107332:	50                   	push   %eax
c0107333:	e8 6b d9 ff ff       	call   c0104ca3 <swap_map_swappable>
c0107338:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr=la;
c010733b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010733e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107341:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0107344:	83 ec 0c             	sub    $0xc,%esp
c0107347:	ff 75 f4             	pushl  -0xc(%ebp)
c010734a:	e8 c1 f3 ff ff       	call   c0106710 <page_ref>
c010734f:	83 c4 10             	add    $0x10,%esp
c0107352:	83 f8 01             	cmp    $0x1,%eax
c0107355:	74 19                	je     c0107370 <pgdir_alloc_page+0xa3>
c0107357:	68 08 a7 10 c0       	push   $0xc010a708
c010735c:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107361:	68 0f 02 00 00       	push   $0x20f
c0107366:	68 a8 a6 10 c0       	push   $0xc010a6a8
c010736b:	e8 80 90 ff ff       	call   c01003f0 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0107370:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107373:	c9                   	leave  
c0107374:	c3                   	ret    

c0107375 <check_alloc_page>:

static void
check_alloc_page(void) {
c0107375:	55                   	push   %ebp
c0107376:	89 e5                	mov    %esp,%ebp
c0107378:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c010737b:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c0107380:	8b 40 18             	mov    0x18(%eax),%eax
c0107383:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0107385:	83 ec 0c             	sub    $0xc,%esp
c0107388:	68 1c a7 10 c0       	push   $0xc010a71c
c010738d:	e8 f8 8e ff ff       	call   c010028a <cprintf>
c0107392:	83 c4 10             	add    $0x10,%esp
}
c0107395:	90                   	nop
c0107396:	c9                   	leave  
c0107397:	c3                   	ret    

c0107398 <check_pgdir>:

static void
check_pgdir(void) {
c0107398:	55                   	push   %ebp
c0107399:	89 e5                	mov    %esp,%ebp
c010739b:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010739e:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01073a3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01073a8:	76 19                	jbe    c01073c3 <check_pgdir+0x2b>
c01073aa:	68 3b a7 10 c0       	push   $0xc010a73b
c01073af:	68 cd a6 10 c0       	push   $0xc010a6cd
c01073b4:	68 20 02 00 00       	push   $0x220
c01073b9:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01073be:	e8 2d 90 ff ff       	call   c01003f0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01073c3:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01073c8:	85 c0                	test   %eax,%eax
c01073ca:	74 0e                	je     c01073da <check_pgdir+0x42>
c01073cc:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01073d1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01073d6:	85 c0                	test   %eax,%eax
c01073d8:	74 19                	je     c01073f3 <check_pgdir+0x5b>
c01073da:	68 58 a7 10 c0       	push   $0xc010a758
c01073df:	68 cd a6 10 c0       	push   $0xc010a6cd
c01073e4:	68 21 02 00 00       	push   $0x221
c01073e9:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01073ee:	e8 fd 8f ff ff       	call   c01003f0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01073f3:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01073f8:	83 ec 04             	sub    $0x4,%esp
c01073fb:	6a 00                	push   $0x0
c01073fd:	6a 00                	push   $0x0
c01073ff:	50                   	push   %eax
c0107400:	e8 c4 fc ff ff       	call   c01070c9 <get_page>
c0107405:	83 c4 10             	add    $0x10,%esp
c0107408:	85 c0                	test   %eax,%eax
c010740a:	74 19                	je     c0107425 <check_pgdir+0x8d>
c010740c:	68 90 a7 10 c0       	push   $0xc010a790
c0107411:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107416:	68 22 02 00 00       	push   $0x222
c010741b:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107420:	e8 cb 8f ff ff       	call   c01003f0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107425:	83 ec 0c             	sub    $0xc,%esp
c0107428:	6a 01                	push   $0x1
c010742a:	e8 ef f4 ff ff       	call   c010691e <alloc_pages>
c010742f:	83 c4 10             	add    $0x10,%esp
c0107432:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107435:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010743a:	6a 00                	push   $0x0
c010743c:	6a 00                	push   $0x0
c010743e:	ff 75 f4             	pushl  -0xc(%ebp)
c0107441:	50                   	push   %eax
c0107442:	e8 7d fd ff ff       	call   c01071c4 <page_insert>
c0107447:	83 c4 10             	add    $0x10,%esp
c010744a:	85 c0                	test   %eax,%eax
c010744c:	74 19                	je     c0107467 <check_pgdir+0xcf>
c010744e:	68 b8 a7 10 c0       	push   $0xc010a7b8
c0107453:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107458:	68 26 02 00 00       	push   $0x226
c010745d:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107462:	e8 89 8f ff ff       	call   c01003f0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0107467:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010746c:	83 ec 04             	sub    $0x4,%esp
c010746f:	6a 00                	push   $0x0
c0107471:	6a 00                	push   $0x0
c0107473:	50                   	push   %eax
c0107474:	e8 0c fb ff ff       	call   c0106f85 <get_pte>
c0107479:	83 c4 10             	add    $0x10,%esp
c010747c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010747f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107483:	75 19                	jne    c010749e <check_pgdir+0x106>
c0107485:	68 e4 a7 10 c0       	push   $0xc010a7e4
c010748a:	68 cd a6 10 c0       	push   $0xc010a6cd
c010748f:	68 29 02 00 00       	push   $0x229
c0107494:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107499:	e8 52 8f ff ff       	call   c01003f0 <__panic>
    assert(pte2page(*ptep) == p1);
c010749e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074a1:	8b 00                	mov    (%eax),%eax
c01074a3:	83 ec 0c             	sub    $0xc,%esp
c01074a6:	50                   	push   %eax
c01074a7:	e8 0e f2 ff ff       	call   c01066ba <pte2page>
c01074ac:	83 c4 10             	add    $0x10,%esp
c01074af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01074b2:	74 19                	je     c01074cd <check_pgdir+0x135>
c01074b4:	68 11 a8 10 c0       	push   $0xc010a811
c01074b9:	68 cd a6 10 c0       	push   $0xc010a6cd
c01074be:	68 2a 02 00 00       	push   $0x22a
c01074c3:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01074c8:	e8 23 8f ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p1) == 1);
c01074cd:	83 ec 0c             	sub    $0xc,%esp
c01074d0:	ff 75 f4             	pushl  -0xc(%ebp)
c01074d3:	e8 38 f2 ff ff       	call   c0106710 <page_ref>
c01074d8:	83 c4 10             	add    $0x10,%esp
c01074db:	83 f8 01             	cmp    $0x1,%eax
c01074de:	74 19                	je     c01074f9 <check_pgdir+0x161>
c01074e0:	68 27 a8 10 c0       	push   $0xc010a827
c01074e5:	68 cd a6 10 c0       	push   $0xc010a6cd
c01074ea:	68 2b 02 00 00       	push   $0x22b
c01074ef:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01074f4:	e8 f7 8e ff ff       	call   c01003f0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01074f9:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01074fe:	8b 00                	mov    (%eax),%eax
c0107500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107505:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107508:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010750b:	c1 e8 0c             	shr    $0xc,%eax
c010750e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107511:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107516:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107519:	72 17                	jb     c0107532 <check_pgdir+0x19a>
c010751b:	ff 75 ec             	pushl  -0x14(%ebp)
c010751e:	68 e0 a5 10 c0       	push   $0xc010a5e0
c0107523:	68 2d 02 00 00       	push   $0x22d
c0107528:	68 a8 a6 10 c0       	push   $0xc010a6a8
c010752d:	e8 be 8e ff ff       	call   c01003f0 <__panic>
c0107532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107535:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010753a:	83 c0 04             	add    $0x4,%eax
c010753d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0107540:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107545:	83 ec 04             	sub    $0x4,%esp
c0107548:	6a 00                	push   $0x0
c010754a:	68 00 10 00 00       	push   $0x1000
c010754f:	50                   	push   %eax
c0107550:	e8 30 fa ff ff       	call   c0106f85 <get_pte>
c0107555:	83 c4 10             	add    $0x10,%esp
c0107558:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010755b:	74 19                	je     c0107576 <check_pgdir+0x1de>
c010755d:	68 3c a8 10 c0       	push   $0xc010a83c
c0107562:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107567:	68 2e 02 00 00       	push   $0x22e
c010756c:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107571:	e8 7a 8e ff ff       	call   c01003f0 <__panic>

    p2 = alloc_page();
c0107576:	83 ec 0c             	sub    $0xc,%esp
c0107579:	6a 01                	push   $0x1
c010757b:	e8 9e f3 ff ff       	call   c010691e <alloc_pages>
c0107580:	83 c4 10             	add    $0x10,%esp
c0107583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107586:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010758b:	6a 06                	push   $0x6
c010758d:	68 00 10 00 00       	push   $0x1000
c0107592:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107595:	50                   	push   %eax
c0107596:	e8 29 fc ff ff       	call   c01071c4 <page_insert>
c010759b:	83 c4 10             	add    $0x10,%esp
c010759e:	85 c0                	test   %eax,%eax
c01075a0:	74 19                	je     c01075bb <check_pgdir+0x223>
c01075a2:	68 64 a8 10 c0       	push   $0xc010a864
c01075a7:	68 cd a6 10 c0       	push   $0xc010a6cd
c01075ac:	68 31 02 00 00       	push   $0x231
c01075b1:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01075b6:	e8 35 8e ff ff       	call   c01003f0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01075bb:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01075c0:	83 ec 04             	sub    $0x4,%esp
c01075c3:	6a 00                	push   $0x0
c01075c5:	68 00 10 00 00       	push   $0x1000
c01075ca:	50                   	push   %eax
c01075cb:	e8 b5 f9 ff ff       	call   c0106f85 <get_pte>
c01075d0:	83 c4 10             	add    $0x10,%esp
c01075d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01075d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01075da:	75 19                	jne    c01075f5 <check_pgdir+0x25d>
c01075dc:	68 9c a8 10 c0       	push   $0xc010a89c
c01075e1:	68 cd a6 10 c0       	push   $0xc010a6cd
c01075e6:	68 32 02 00 00       	push   $0x232
c01075eb:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01075f0:	e8 fb 8d ff ff       	call   c01003f0 <__panic>
    assert(*ptep & PTE_U);
c01075f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075f8:	8b 00                	mov    (%eax),%eax
c01075fa:	83 e0 04             	and    $0x4,%eax
c01075fd:	85 c0                	test   %eax,%eax
c01075ff:	75 19                	jne    c010761a <check_pgdir+0x282>
c0107601:	68 cc a8 10 c0       	push   $0xc010a8cc
c0107606:	68 cd a6 10 c0       	push   $0xc010a6cd
c010760b:	68 33 02 00 00       	push   $0x233
c0107610:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107615:	e8 d6 8d ff ff       	call   c01003f0 <__panic>
    assert(*ptep & PTE_W);
c010761a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010761d:	8b 00                	mov    (%eax),%eax
c010761f:	83 e0 02             	and    $0x2,%eax
c0107622:	85 c0                	test   %eax,%eax
c0107624:	75 19                	jne    c010763f <check_pgdir+0x2a7>
c0107626:	68 da a8 10 c0       	push   $0xc010a8da
c010762b:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107630:	68 34 02 00 00       	push   $0x234
c0107635:	68 a8 a6 10 c0       	push   $0xc010a6a8
c010763a:	e8 b1 8d ff ff       	call   c01003f0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010763f:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107644:	8b 00                	mov    (%eax),%eax
c0107646:	83 e0 04             	and    $0x4,%eax
c0107649:	85 c0                	test   %eax,%eax
c010764b:	75 19                	jne    c0107666 <check_pgdir+0x2ce>
c010764d:	68 e8 a8 10 c0       	push   $0xc010a8e8
c0107652:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107657:	68 35 02 00 00       	push   $0x235
c010765c:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107661:	e8 8a 8d ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 1);
c0107666:	83 ec 0c             	sub    $0xc,%esp
c0107669:	ff 75 e4             	pushl  -0x1c(%ebp)
c010766c:	e8 9f f0 ff ff       	call   c0106710 <page_ref>
c0107671:	83 c4 10             	add    $0x10,%esp
c0107674:	83 f8 01             	cmp    $0x1,%eax
c0107677:	74 19                	je     c0107692 <check_pgdir+0x2fa>
c0107679:	68 fe a8 10 c0       	push   $0xc010a8fe
c010767e:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107683:	68 36 02 00 00       	push   $0x236
c0107688:	68 a8 a6 10 c0       	push   $0xc010a6a8
c010768d:	e8 5e 8d ff ff       	call   c01003f0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107692:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107697:	6a 00                	push   $0x0
c0107699:	68 00 10 00 00       	push   $0x1000
c010769e:	ff 75 f4             	pushl  -0xc(%ebp)
c01076a1:	50                   	push   %eax
c01076a2:	e8 1d fb ff ff       	call   c01071c4 <page_insert>
c01076a7:	83 c4 10             	add    $0x10,%esp
c01076aa:	85 c0                	test   %eax,%eax
c01076ac:	74 19                	je     c01076c7 <check_pgdir+0x32f>
c01076ae:	68 10 a9 10 c0       	push   $0xc010a910
c01076b3:	68 cd a6 10 c0       	push   $0xc010a6cd
c01076b8:	68 38 02 00 00       	push   $0x238
c01076bd:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01076c2:	e8 29 8d ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p1) == 2);
c01076c7:	83 ec 0c             	sub    $0xc,%esp
c01076ca:	ff 75 f4             	pushl  -0xc(%ebp)
c01076cd:	e8 3e f0 ff ff       	call   c0106710 <page_ref>
c01076d2:	83 c4 10             	add    $0x10,%esp
c01076d5:	83 f8 02             	cmp    $0x2,%eax
c01076d8:	74 19                	je     c01076f3 <check_pgdir+0x35b>
c01076da:	68 3c a9 10 c0       	push   $0xc010a93c
c01076df:	68 cd a6 10 c0       	push   $0xc010a6cd
c01076e4:	68 39 02 00 00       	push   $0x239
c01076e9:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01076ee:	e8 fd 8c ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c01076f3:	83 ec 0c             	sub    $0xc,%esp
c01076f6:	ff 75 e4             	pushl  -0x1c(%ebp)
c01076f9:	e8 12 f0 ff ff       	call   c0106710 <page_ref>
c01076fe:	83 c4 10             	add    $0x10,%esp
c0107701:	85 c0                	test   %eax,%eax
c0107703:	74 19                	je     c010771e <check_pgdir+0x386>
c0107705:	68 4e a9 10 c0       	push   $0xc010a94e
c010770a:	68 cd a6 10 c0       	push   $0xc010a6cd
c010770f:	68 3a 02 00 00       	push   $0x23a
c0107714:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107719:	e8 d2 8c ff ff       	call   c01003f0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010771e:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107723:	83 ec 04             	sub    $0x4,%esp
c0107726:	6a 00                	push   $0x0
c0107728:	68 00 10 00 00       	push   $0x1000
c010772d:	50                   	push   %eax
c010772e:	e8 52 f8 ff ff       	call   c0106f85 <get_pte>
c0107733:	83 c4 10             	add    $0x10,%esp
c0107736:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107739:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010773d:	75 19                	jne    c0107758 <check_pgdir+0x3c0>
c010773f:	68 9c a8 10 c0       	push   $0xc010a89c
c0107744:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107749:	68 3b 02 00 00       	push   $0x23b
c010774e:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107753:	e8 98 8c ff ff       	call   c01003f0 <__panic>
    assert(pte2page(*ptep) == p1);
c0107758:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010775b:	8b 00                	mov    (%eax),%eax
c010775d:	83 ec 0c             	sub    $0xc,%esp
c0107760:	50                   	push   %eax
c0107761:	e8 54 ef ff ff       	call   c01066ba <pte2page>
c0107766:	83 c4 10             	add    $0x10,%esp
c0107769:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010776c:	74 19                	je     c0107787 <check_pgdir+0x3ef>
c010776e:	68 11 a8 10 c0       	push   $0xc010a811
c0107773:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107778:	68 3c 02 00 00       	push   $0x23c
c010777d:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107782:	e8 69 8c ff ff       	call   c01003f0 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107787:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010778a:	8b 00                	mov    (%eax),%eax
c010778c:	83 e0 04             	and    $0x4,%eax
c010778f:	85 c0                	test   %eax,%eax
c0107791:	74 19                	je     c01077ac <check_pgdir+0x414>
c0107793:	68 60 a9 10 c0       	push   $0xc010a960
c0107798:	68 cd a6 10 c0       	push   $0xc010a6cd
c010779d:	68 3d 02 00 00       	push   $0x23d
c01077a2:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01077a7:	e8 44 8c ff ff       	call   c01003f0 <__panic>

    page_remove(boot_pgdir, 0x0);
c01077ac:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01077b1:	83 ec 08             	sub    $0x8,%esp
c01077b4:	6a 00                	push   $0x0
c01077b6:	50                   	push   %eax
c01077b7:	e8 cf f9 ff ff       	call   c010718b <page_remove>
c01077bc:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c01077bf:	83 ec 0c             	sub    $0xc,%esp
c01077c2:	ff 75 f4             	pushl  -0xc(%ebp)
c01077c5:	e8 46 ef ff ff       	call   c0106710 <page_ref>
c01077ca:	83 c4 10             	add    $0x10,%esp
c01077cd:	83 f8 01             	cmp    $0x1,%eax
c01077d0:	74 19                	je     c01077eb <check_pgdir+0x453>
c01077d2:	68 27 a8 10 c0       	push   $0xc010a827
c01077d7:	68 cd a6 10 c0       	push   $0xc010a6cd
c01077dc:	68 40 02 00 00       	push   $0x240
c01077e1:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01077e6:	e8 05 8c ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c01077eb:	83 ec 0c             	sub    $0xc,%esp
c01077ee:	ff 75 e4             	pushl  -0x1c(%ebp)
c01077f1:	e8 1a ef ff ff       	call   c0106710 <page_ref>
c01077f6:	83 c4 10             	add    $0x10,%esp
c01077f9:	85 c0                	test   %eax,%eax
c01077fb:	74 19                	je     c0107816 <check_pgdir+0x47e>
c01077fd:	68 4e a9 10 c0       	push   $0xc010a94e
c0107802:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107807:	68 41 02 00 00       	push   $0x241
c010780c:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107811:	e8 da 8b ff ff       	call   c01003f0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107816:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010781b:	83 ec 08             	sub    $0x8,%esp
c010781e:	68 00 10 00 00       	push   $0x1000
c0107823:	50                   	push   %eax
c0107824:	e8 62 f9 ff ff       	call   c010718b <page_remove>
c0107829:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c010782c:	83 ec 0c             	sub    $0xc,%esp
c010782f:	ff 75 f4             	pushl  -0xc(%ebp)
c0107832:	e8 d9 ee ff ff       	call   c0106710 <page_ref>
c0107837:	83 c4 10             	add    $0x10,%esp
c010783a:	85 c0                	test   %eax,%eax
c010783c:	74 19                	je     c0107857 <check_pgdir+0x4bf>
c010783e:	68 75 a9 10 c0       	push   $0xc010a975
c0107843:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107848:	68 44 02 00 00       	push   $0x244
c010784d:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107852:	e8 99 8b ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c0107857:	83 ec 0c             	sub    $0xc,%esp
c010785a:	ff 75 e4             	pushl  -0x1c(%ebp)
c010785d:	e8 ae ee ff ff       	call   c0106710 <page_ref>
c0107862:	83 c4 10             	add    $0x10,%esp
c0107865:	85 c0                	test   %eax,%eax
c0107867:	74 19                	je     c0107882 <check_pgdir+0x4ea>
c0107869:	68 4e a9 10 c0       	push   $0xc010a94e
c010786e:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107873:	68 45 02 00 00       	push   $0x245
c0107878:	68 a8 a6 10 c0       	push   $0xc010a6a8
c010787d:	e8 6e 8b ff ff       	call   c01003f0 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107882:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107887:	8b 00                	mov    (%eax),%eax
c0107889:	83 ec 0c             	sub    $0xc,%esp
c010788c:	50                   	push   %eax
c010788d:	e8 62 ee ff ff       	call   c01066f4 <pde2page>
c0107892:	83 c4 10             	add    $0x10,%esp
c0107895:	83 ec 0c             	sub    $0xc,%esp
c0107898:	50                   	push   %eax
c0107899:	e8 72 ee ff ff       	call   c0106710 <page_ref>
c010789e:	83 c4 10             	add    $0x10,%esp
c01078a1:	83 f8 01             	cmp    $0x1,%eax
c01078a4:	74 19                	je     c01078bf <check_pgdir+0x527>
c01078a6:	68 88 a9 10 c0       	push   $0xc010a988
c01078ab:	68 cd a6 10 c0       	push   $0xc010a6cd
c01078b0:	68 47 02 00 00       	push   $0x247
c01078b5:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01078ba:	e8 31 8b ff ff       	call   c01003f0 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01078bf:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01078c4:	8b 00                	mov    (%eax),%eax
c01078c6:	83 ec 0c             	sub    $0xc,%esp
c01078c9:	50                   	push   %eax
c01078ca:	e8 25 ee ff ff       	call   c01066f4 <pde2page>
c01078cf:	83 c4 10             	add    $0x10,%esp
c01078d2:	83 ec 08             	sub    $0x8,%esp
c01078d5:	6a 01                	push   $0x1
c01078d7:	50                   	push   %eax
c01078d8:	e8 ad f0 ff ff       	call   c010698a <free_pages>
c01078dd:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01078e0:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01078e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01078eb:	83 ec 0c             	sub    $0xc,%esp
c01078ee:	68 af a9 10 c0       	push   $0xc010a9af
c01078f3:	e8 92 89 ff ff       	call   c010028a <cprintf>
c01078f8:	83 c4 10             	add    $0x10,%esp
}
c01078fb:	90                   	nop
c01078fc:	c9                   	leave  
c01078fd:	c3                   	ret    

c01078fe <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01078fe:	55                   	push   %ebp
c01078ff:	89 e5                	mov    %esp,%ebp
c0107901:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107904:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010790b:	e9 a3 00 00 00       	jmp    c01079b3 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107910:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107913:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107916:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107919:	c1 e8 0c             	shr    $0xc,%eax
c010791c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010791f:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107924:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107927:	72 17                	jb     c0107940 <check_boot_pgdir+0x42>
c0107929:	ff 75 f0             	pushl  -0x10(%ebp)
c010792c:	68 e0 a5 10 c0       	push   $0xc010a5e0
c0107931:	68 53 02 00 00       	push   $0x253
c0107936:	68 a8 a6 10 c0       	push   $0xc010a6a8
c010793b:	e8 b0 8a ff ff       	call   c01003f0 <__panic>
c0107940:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107943:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107948:	89 c2                	mov    %eax,%edx
c010794a:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010794f:	83 ec 04             	sub    $0x4,%esp
c0107952:	6a 00                	push   $0x0
c0107954:	52                   	push   %edx
c0107955:	50                   	push   %eax
c0107956:	e8 2a f6 ff ff       	call   c0106f85 <get_pte>
c010795b:	83 c4 10             	add    $0x10,%esp
c010795e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107961:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107965:	75 19                	jne    c0107980 <check_boot_pgdir+0x82>
c0107967:	68 cc a9 10 c0       	push   $0xc010a9cc
c010796c:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107971:	68 53 02 00 00       	push   $0x253
c0107976:	68 a8 a6 10 c0       	push   $0xc010a6a8
c010797b:	e8 70 8a ff ff       	call   c01003f0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0107980:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107983:	8b 00                	mov    (%eax),%eax
c0107985:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010798a:	89 c2                	mov    %eax,%edx
c010798c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010798f:	39 c2                	cmp    %eax,%edx
c0107991:	74 19                	je     c01079ac <check_boot_pgdir+0xae>
c0107993:	68 09 aa 10 c0       	push   $0xc010aa09
c0107998:	68 cd a6 10 c0       	push   $0xc010a6cd
c010799d:	68 54 02 00 00       	push   $0x254
c01079a2:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01079a7:	e8 44 8a ff ff       	call   c01003f0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01079ac:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01079b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01079b6:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01079bb:	39 c2                	cmp    %eax,%edx
c01079bd:	0f 82 4d ff ff ff    	jb     c0107910 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01079c3:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01079c8:	05 ac 0f 00 00       	add    $0xfac,%eax
c01079cd:	8b 00                	mov    (%eax),%eax
c01079cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01079d4:	89 c2                	mov    %eax,%edx
c01079d6:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01079db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01079de:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01079e5:	77 17                	ja     c01079fe <check_boot_pgdir+0x100>
c01079e7:	ff 75 e4             	pushl  -0x1c(%ebp)
c01079ea:	68 04 a6 10 c0       	push   $0xc010a604
c01079ef:	68 57 02 00 00       	push   $0x257
c01079f4:	68 a8 a6 10 c0       	push   $0xc010a6a8
c01079f9:	e8 f2 89 ff ff       	call   c01003f0 <__panic>
c01079fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a01:	05 00 00 00 40       	add    $0x40000000,%eax
c0107a06:	39 c2                	cmp    %eax,%edx
c0107a08:	74 19                	je     c0107a23 <check_boot_pgdir+0x125>
c0107a0a:	68 20 aa 10 c0       	push   $0xc010aa20
c0107a0f:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107a14:	68 57 02 00 00       	push   $0x257
c0107a19:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107a1e:	e8 cd 89 ff ff       	call   c01003f0 <__panic>

    assert(boot_pgdir[0] == 0);
c0107a23:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107a28:	8b 00                	mov    (%eax),%eax
c0107a2a:	85 c0                	test   %eax,%eax
c0107a2c:	74 19                	je     c0107a47 <check_boot_pgdir+0x149>
c0107a2e:	68 54 aa 10 c0       	push   $0xc010aa54
c0107a33:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107a38:	68 59 02 00 00       	push   $0x259
c0107a3d:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107a42:	e8 a9 89 ff ff       	call   c01003f0 <__panic>

    struct Page *p;
    p = alloc_page();
c0107a47:	83 ec 0c             	sub    $0xc,%esp
c0107a4a:	6a 01                	push   $0x1
c0107a4c:	e8 cd ee ff ff       	call   c010691e <alloc_pages>
c0107a51:	83 c4 10             	add    $0x10,%esp
c0107a54:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0107a57:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107a5c:	6a 02                	push   $0x2
c0107a5e:	68 00 01 00 00       	push   $0x100
c0107a63:	ff 75 e0             	pushl  -0x20(%ebp)
c0107a66:	50                   	push   %eax
c0107a67:	e8 58 f7 ff ff       	call   c01071c4 <page_insert>
c0107a6c:	83 c4 10             	add    $0x10,%esp
c0107a6f:	85 c0                	test   %eax,%eax
c0107a71:	74 19                	je     c0107a8c <check_boot_pgdir+0x18e>
c0107a73:	68 68 aa 10 c0       	push   $0xc010aa68
c0107a78:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107a7d:	68 5d 02 00 00       	push   $0x25d
c0107a82:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107a87:	e8 64 89 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p) == 1);
c0107a8c:	83 ec 0c             	sub    $0xc,%esp
c0107a8f:	ff 75 e0             	pushl  -0x20(%ebp)
c0107a92:	e8 79 ec ff ff       	call   c0106710 <page_ref>
c0107a97:	83 c4 10             	add    $0x10,%esp
c0107a9a:	83 f8 01             	cmp    $0x1,%eax
c0107a9d:	74 19                	je     c0107ab8 <check_boot_pgdir+0x1ba>
c0107a9f:	68 96 aa 10 c0       	push   $0xc010aa96
c0107aa4:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107aa9:	68 5e 02 00 00       	push   $0x25e
c0107aae:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107ab3:	e8 38 89 ff ff       	call   c01003f0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0107ab8:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107abd:	6a 02                	push   $0x2
c0107abf:	68 00 11 00 00       	push   $0x1100
c0107ac4:	ff 75 e0             	pushl  -0x20(%ebp)
c0107ac7:	50                   	push   %eax
c0107ac8:	e8 f7 f6 ff ff       	call   c01071c4 <page_insert>
c0107acd:	83 c4 10             	add    $0x10,%esp
c0107ad0:	85 c0                	test   %eax,%eax
c0107ad2:	74 19                	je     c0107aed <check_boot_pgdir+0x1ef>
c0107ad4:	68 a8 aa 10 c0       	push   $0xc010aaa8
c0107ad9:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107ade:	68 5f 02 00 00       	push   $0x25f
c0107ae3:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107ae8:	e8 03 89 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p) == 2);
c0107aed:	83 ec 0c             	sub    $0xc,%esp
c0107af0:	ff 75 e0             	pushl  -0x20(%ebp)
c0107af3:	e8 18 ec ff ff       	call   c0106710 <page_ref>
c0107af8:	83 c4 10             	add    $0x10,%esp
c0107afb:	83 f8 02             	cmp    $0x2,%eax
c0107afe:	74 19                	je     c0107b19 <check_boot_pgdir+0x21b>
c0107b00:	68 df aa 10 c0       	push   $0xc010aadf
c0107b05:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107b0a:	68 60 02 00 00       	push   $0x260
c0107b0f:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107b14:	e8 d7 88 ff ff       	call   c01003f0 <__panic>

    const char *str = "ucore: Hello world!!";
c0107b19:	c7 45 dc f0 aa 10 c0 	movl   $0xc010aaf0,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0107b20:	83 ec 08             	sub    $0x8,%esp
c0107b23:	ff 75 dc             	pushl  -0x24(%ebp)
c0107b26:	68 00 01 00 00       	push   $0x100
c0107b2b:	e8 ee 05 00 00       	call   c010811e <strcpy>
c0107b30:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0107b33:	83 ec 08             	sub    $0x8,%esp
c0107b36:	68 00 11 00 00       	push   $0x1100
c0107b3b:	68 00 01 00 00       	push   $0x100
c0107b40:	e8 53 06 00 00       	call   c0108198 <strcmp>
c0107b45:	83 c4 10             	add    $0x10,%esp
c0107b48:	85 c0                	test   %eax,%eax
c0107b4a:	74 19                	je     c0107b65 <check_boot_pgdir+0x267>
c0107b4c:	68 08 ab 10 c0       	push   $0xc010ab08
c0107b51:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107b56:	68 64 02 00 00       	push   $0x264
c0107b5b:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107b60:	e8 8b 88 ff ff       	call   c01003f0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0107b65:	83 ec 0c             	sub    $0xc,%esp
c0107b68:	ff 75 e0             	pushl  -0x20(%ebp)
c0107b6b:	e8 c6 ea ff ff       	call   c0106636 <page2kva>
c0107b70:	83 c4 10             	add    $0x10,%esp
c0107b73:	05 00 01 00 00       	add    $0x100,%eax
c0107b78:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0107b7b:	83 ec 0c             	sub    $0xc,%esp
c0107b7e:	68 00 01 00 00       	push   $0x100
c0107b83:	e8 3e 05 00 00       	call   c01080c6 <strlen>
c0107b88:	83 c4 10             	add    $0x10,%esp
c0107b8b:	85 c0                	test   %eax,%eax
c0107b8d:	74 19                	je     c0107ba8 <check_boot_pgdir+0x2aa>
c0107b8f:	68 40 ab 10 c0       	push   $0xc010ab40
c0107b94:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107b99:	68 67 02 00 00       	push   $0x267
c0107b9e:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107ba3:	e8 48 88 ff ff       	call   c01003f0 <__panic>

    free_page(p);
c0107ba8:	83 ec 08             	sub    $0x8,%esp
c0107bab:	6a 01                	push   $0x1
c0107bad:	ff 75 e0             	pushl  -0x20(%ebp)
c0107bb0:	e8 d5 ed ff ff       	call   c010698a <free_pages>
c0107bb5:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0107bb8:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107bbd:	8b 00                	mov    (%eax),%eax
c0107bbf:	83 ec 0c             	sub    $0xc,%esp
c0107bc2:	50                   	push   %eax
c0107bc3:	e8 2c eb ff ff       	call   c01066f4 <pde2page>
c0107bc8:	83 c4 10             	add    $0x10,%esp
c0107bcb:	83 ec 08             	sub    $0x8,%esp
c0107bce:	6a 01                	push   $0x1
c0107bd0:	50                   	push   %eax
c0107bd1:	e8 b4 ed ff ff       	call   c010698a <free_pages>
c0107bd6:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0107bd9:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0107be4:	83 ec 0c             	sub    $0xc,%esp
c0107be7:	68 64 ab 10 c0       	push   $0xc010ab64
c0107bec:	e8 99 86 ff ff       	call   c010028a <cprintf>
c0107bf1:	83 c4 10             	add    $0x10,%esp
}
c0107bf4:	90                   	nop
c0107bf5:	c9                   	leave  
c0107bf6:	c3                   	ret    

c0107bf7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0107bf7:	55                   	push   %ebp
c0107bf8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0107bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bfd:	83 e0 04             	and    $0x4,%eax
c0107c00:	85 c0                	test   %eax,%eax
c0107c02:	74 07                	je     c0107c0b <perm2str+0x14>
c0107c04:	b8 75 00 00 00       	mov    $0x75,%eax
c0107c09:	eb 05                	jmp    c0107c10 <perm2str+0x19>
c0107c0b:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0107c10:	a2 08 50 12 c0       	mov    %al,0xc0125008
    str[1] = 'r';
c0107c15:	c6 05 09 50 12 c0 72 	movb   $0x72,0xc0125009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0107c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c1f:	83 e0 02             	and    $0x2,%eax
c0107c22:	85 c0                	test   %eax,%eax
c0107c24:	74 07                	je     c0107c2d <perm2str+0x36>
c0107c26:	b8 77 00 00 00       	mov    $0x77,%eax
c0107c2b:	eb 05                	jmp    c0107c32 <perm2str+0x3b>
c0107c2d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0107c32:	a2 0a 50 12 c0       	mov    %al,0xc012500a
    str[3] = '\0';
c0107c37:	c6 05 0b 50 12 c0 00 	movb   $0x0,0xc012500b
    return str;
c0107c3e:	b8 08 50 12 c0       	mov    $0xc0125008,%eax
}
c0107c43:	5d                   	pop    %ebp
c0107c44:	c3                   	ret    

c0107c45 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0107c45:	55                   	push   %ebp
c0107c46:	89 e5                	mov    %esp,%ebp
c0107c48:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0107c4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c4e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c51:	72 0e                	jb     c0107c61 <get_pgtable_items+0x1c>
        return 0;
c0107c53:	b8 00 00 00 00       	mov    $0x0,%eax
c0107c58:	e9 9a 00 00 00       	jmp    c0107cf7 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0107c5d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0107c61:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c64:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c67:	73 18                	jae    c0107c81 <get_pgtable_items+0x3c>
c0107c69:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107c73:	8b 45 14             	mov    0x14(%ebp),%eax
c0107c76:	01 d0                	add    %edx,%eax
c0107c78:	8b 00                	mov    (%eax),%eax
c0107c7a:	83 e0 01             	and    $0x1,%eax
c0107c7d:	85 c0                	test   %eax,%eax
c0107c7f:	74 dc                	je     c0107c5d <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0107c81:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c84:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c87:	73 69                	jae    c0107cf2 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0107c89:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0107c8d:	74 08                	je     c0107c97 <get_pgtable_items+0x52>
            *left_store = start;
c0107c8f:	8b 45 18             	mov    0x18(%ebp),%eax
c0107c92:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c95:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0107c97:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c9a:	8d 50 01             	lea    0x1(%eax),%edx
c0107c9d:	89 55 10             	mov    %edx,0x10(%ebp)
c0107ca0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107ca7:	8b 45 14             	mov    0x14(%ebp),%eax
c0107caa:	01 d0                	add    %edx,%eax
c0107cac:	8b 00                	mov    (%eax),%eax
c0107cae:	83 e0 07             	and    $0x7,%eax
c0107cb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0107cb4:	eb 04                	jmp    c0107cba <get_pgtable_items+0x75>
            start ++;
c0107cb6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0107cba:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cbd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107cc0:	73 1d                	jae    c0107cdf <get_pgtable_items+0x9a>
c0107cc2:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107ccc:	8b 45 14             	mov    0x14(%ebp),%eax
c0107ccf:	01 d0                	add    %edx,%eax
c0107cd1:	8b 00                	mov    (%eax),%eax
c0107cd3:	83 e0 07             	and    $0x7,%eax
c0107cd6:	89 c2                	mov    %eax,%edx
c0107cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107cdb:	39 c2                	cmp    %eax,%edx
c0107cdd:	74 d7                	je     c0107cb6 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0107cdf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107ce3:	74 08                	je     c0107ced <get_pgtable_items+0xa8>
            *right_store = start;
c0107ce5:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107ce8:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ceb:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0107ced:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107cf0:	eb 05                	jmp    c0107cf7 <get_pgtable_items+0xb2>
    }
    return 0;
c0107cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107cf7:	c9                   	leave  
c0107cf8:	c3                   	ret    

c0107cf9 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0107cf9:	55                   	push   %ebp
c0107cfa:	89 e5                	mov    %esp,%ebp
c0107cfc:	57                   	push   %edi
c0107cfd:	56                   	push   %esi
c0107cfe:	53                   	push   %ebx
c0107cff:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0107d02:	83 ec 0c             	sub    $0xc,%esp
c0107d05:	68 84 ab 10 c0       	push   $0xc010ab84
c0107d0a:	e8 7b 85 ff ff       	call   c010028a <cprintf>
c0107d0f:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0107d12:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0107d19:	e9 e5 00 00 00       	jmp    c0107e03 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d21:	83 ec 0c             	sub    $0xc,%esp
c0107d24:	50                   	push   %eax
c0107d25:	e8 cd fe ff ff       	call   c0107bf7 <perm2str>
c0107d2a:	83 c4 10             	add    $0x10,%esp
c0107d2d:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0107d2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d35:	29 c2                	sub    %eax,%edx
c0107d37:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107d39:	c1 e0 16             	shl    $0x16,%eax
c0107d3c:	89 c3                	mov    %eax,%ebx
c0107d3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d41:	c1 e0 16             	shl    $0x16,%eax
c0107d44:	89 c1                	mov    %eax,%ecx
c0107d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d49:	c1 e0 16             	shl    $0x16,%eax
c0107d4c:	89 c2                	mov    %eax,%edx
c0107d4e:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0107d51:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d54:	29 c6                	sub    %eax,%esi
c0107d56:	89 f0                	mov    %esi,%eax
c0107d58:	83 ec 08             	sub    $0x8,%esp
c0107d5b:	57                   	push   %edi
c0107d5c:	53                   	push   %ebx
c0107d5d:	51                   	push   %ecx
c0107d5e:	52                   	push   %edx
c0107d5f:	50                   	push   %eax
c0107d60:	68 b5 ab 10 c0       	push   $0xc010abb5
c0107d65:	e8 20 85 ff ff       	call   c010028a <cprintf>
c0107d6a:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0107d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d70:	c1 e0 0a             	shl    $0xa,%eax
c0107d73:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0107d76:	eb 4f                	jmp    c0107dc7 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0107d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d7b:	83 ec 0c             	sub    $0xc,%esp
c0107d7e:	50                   	push   %eax
c0107d7f:	e8 73 fe ff ff       	call   c0107bf7 <perm2str>
c0107d84:	83 c4 10             	add    $0x10,%esp
c0107d87:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0107d89:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107d8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d8f:	29 c2                	sub    %eax,%edx
c0107d91:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0107d93:	c1 e0 0c             	shl    $0xc,%eax
c0107d96:	89 c3                	mov    %eax,%ebx
c0107d98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107d9b:	c1 e0 0c             	shl    $0xc,%eax
c0107d9e:	89 c1                	mov    %eax,%ecx
c0107da0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107da3:	c1 e0 0c             	shl    $0xc,%eax
c0107da6:	89 c2                	mov    %eax,%edx
c0107da8:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0107dab:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107dae:	29 c6                	sub    %eax,%esi
c0107db0:	89 f0                	mov    %esi,%eax
c0107db2:	83 ec 08             	sub    $0x8,%esp
c0107db5:	57                   	push   %edi
c0107db6:	53                   	push   %ebx
c0107db7:	51                   	push   %ecx
c0107db8:	52                   	push   %edx
c0107db9:	50                   	push   %eax
c0107dba:	68 d4 ab 10 c0       	push   $0xc010abd4
c0107dbf:	e8 c6 84 ff ff       	call   c010028a <cprintf>
c0107dc4:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0107dc7:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0107dcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107dcf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107dd2:	89 d3                	mov    %edx,%ebx
c0107dd4:	c1 e3 0a             	shl    $0xa,%ebx
c0107dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107dda:	89 d1                	mov    %edx,%ecx
c0107ddc:	c1 e1 0a             	shl    $0xa,%ecx
c0107ddf:	83 ec 08             	sub    $0x8,%esp
c0107de2:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0107de5:	52                   	push   %edx
c0107de6:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0107de9:	52                   	push   %edx
c0107dea:	56                   	push   %esi
c0107deb:	50                   	push   %eax
c0107dec:	53                   	push   %ebx
c0107ded:	51                   	push   %ecx
c0107dee:	e8 52 fe ff ff       	call   c0107c45 <get_pgtable_items>
c0107df3:	83 c4 20             	add    $0x20,%esp
c0107df6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107df9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107dfd:	0f 85 75 ff ff ff    	jne    c0107d78 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0107e03:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0107e08:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107e0b:	83 ec 08             	sub    $0x8,%esp
c0107e0e:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0107e11:	52                   	push   %edx
c0107e12:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0107e15:	52                   	push   %edx
c0107e16:	51                   	push   %ecx
c0107e17:	50                   	push   %eax
c0107e18:	68 00 04 00 00       	push   $0x400
c0107e1d:	6a 00                	push   $0x0
c0107e1f:	e8 21 fe ff ff       	call   c0107c45 <get_pgtable_items>
c0107e24:	83 c4 20             	add    $0x20,%esp
c0107e27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107e2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107e2e:	0f 85 ea fe ff ff    	jne    c0107d1e <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0107e34:	83 ec 0c             	sub    $0xc,%esp
c0107e37:	68 f8 ab 10 c0       	push   $0xc010abf8
c0107e3c:	e8 49 84 ff ff       	call   c010028a <cprintf>
c0107e41:	83 c4 10             	add    $0x10,%esp
}
c0107e44:	90                   	nop
c0107e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0107e48:	5b                   	pop    %ebx
c0107e49:	5e                   	pop    %esi
c0107e4a:	5f                   	pop    %edi
c0107e4b:	5d                   	pop    %ebp
c0107e4c:	c3                   	ret    

c0107e4d <kmalloc>:

void *
kmalloc(size_t n) {
c0107e4d:	55                   	push   %ebp
c0107e4e:	89 e5                	mov    %esp,%ebp
c0107e50:	83 ec 18             	sub    $0x18,%esp
    void * ptr=NULL;
c0107e53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0107e5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0107e61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107e65:	74 09                	je     c0107e70 <kmalloc+0x23>
c0107e67:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0107e6e:	76 19                	jbe    c0107e89 <kmalloc+0x3c>
c0107e70:	68 29 ac 10 c0       	push   $0xc010ac29
c0107e75:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107e7a:	68 b3 02 00 00       	push   $0x2b3
c0107e7f:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107e84:	e8 67 85 ff ff       	call   c01003f0 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0107e89:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e8c:	05 ff 0f 00 00       	add    $0xfff,%eax
c0107e91:	c1 e8 0c             	shr    $0xc,%eax
c0107e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0107e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e9a:	83 ec 0c             	sub    $0xc,%esp
c0107e9d:	50                   	push   %eax
c0107e9e:	e8 7b ea ff ff       	call   c010691e <alloc_pages>
c0107ea3:	83 c4 10             	add    $0x10,%esp
c0107ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0107ea9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ead:	75 19                	jne    c0107ec8 <kmalloc+0x7b>
c0107eaf:	68 40 ac 10 c0       	push   $0xc010ac40
c0107eb4:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107eb9:	68 b6 02 00 00       	push   $0x2b6
c0107ebe:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107ec3:	e8 28 85 ff ff       	call   c01003f0 <__panic>
    ptr=page2kva(base);
c0107ec8:	83 ec 0c             	sub    $0xc,%esp
c0107ecb:	ff 75 f0             	pushl  -0x10(%ebp)
c0107ece:	e8 63 e7 ff ff       	call   c0106636 <page2kva>
c0107ed3:	83 c4 10             	add    $0x10,%esp
c0107ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0107ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107edc:	c9                   	leave  
c0107edd:	c3                   	ret    

c0107ede <kfree>:

void 
kfree(void *ptr, size_t n) {
c0107ede:	55                   	push   %ebp
c0107edf:	89 e5                	mov    %esp,%ebp
c0107ee1:	83 ec 18             	sub    $0x18,%esp
    assert(n > 0 && n < 1024*0124);
c0107ee4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107ee8:	74 09                	je     c0107ef3 <kfree+0x15>
c0107eea:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0107ef1:	76 19                	jbe    c0107f0c <kfree+0x2e>
c0107ef3:	68 29 ac 10 c0       	push   $0xc010ac29
c0107ef8:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107efd:	68 bd 02 00 00       	push   $0x2bd
c0107f02:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107f07:	e8 e4 84 ff ff       	call   c01003f0 <__panic>
    assert(ptr != NULL);
c0107f0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107f10:	75 19                	jne    c0107f2b <kfree+0x4d>
c0107f12:	68 4d ac 10 c0       	push   $0xc010ac4d
c0107f17:	68 cd a6 10 c0       	push   $0xc010a6cd
c0107f1c:	68 be 02 00 00       	push   $0x2be
c0107f21:	68 a8 a6 10 c0       	push   $0xc010a6a8
c0107f26:	e8 c5 84 ff ff       	call   c01003f0 <__panic>
    struct Page *base=NULL;
c0107f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0107f32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f35:	05 ff 0f 00 00       	add    $0xfff,%eax
c0107f3a:	c1 e8 0c             	shr    $0xc,%eax
c0107f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0107f40:	83 ec 0c             	sub    $0xc,%esp
c0107f43:	ff 75 08             	pushl  0x8(%ebp)
c0107f46:	e8 30 e7 ff ff       	call   c010667b <kva2page>
c0107f4b:	83 c4 10             	add    $0x10,%esp
c0107f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0107f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f54:	83 ec 08             	sub    $0x8,%esp
c0107f57:	50                   	push   %eax
c0107f58:	ff 75 f4             	pushl  -0xc(%ebp)
c0107f5b:	e8 2a ea ff ff       	call   c010698a <free_pages>
c0107f60:	83 c4 10             	add    $0x10,%esp
}
c0107f63:	90                   	nop
c0107f64:	c9                   	leave  
c0107f65:	c3                   	ret    

c0107f66 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107f66:	55                   	push   %ebp
c0107f67:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107f69:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f6c:	8b 15 58 51 12 c0    	mov    0xc0125158,%edx
c0107f72:	29 d0                	sub    %edx,%eax
c0107f74:	c1 f8 05             	sar    $0x5,%eax
}
c0107f77:	5d                   	pop    %ebp
c0107f78:	c3                   	ret    

c0107f79 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107f79:	55                   	push   %ebp
c0107f7a:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0107f7c:	ff 75 08             	pushl  0x8(%ebp)
c0107f7f:	e8 e2 ff ff ff       	call   c0107f66 <page2ppn>
c0107f84:	83 c4 04             	add    $0x4,%esp
c0107f87:	c1 e0 0c             	shl    $0xc,%eax
}
c0107f8a:	c9                   	leave  
c0107f8b:	c3                   	ret    

c0107f8c <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107f8c:	55                   	push   %ebp
c0107f8d:	89 e5                	mov    %esp,%ebp
c0107f8f:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0107f92:	ff 75 08             	pushl  0x8(%ebp)
c0107f95:	e8 df ff ff ff       	call   c0107f79 <page2pa>
c0107f9a:	83 c4 04             	add    $0x4,%esp
c0107f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fa3:	c1 e8 0c             	shr    $0xc,%eax
c0107fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107fa9:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107fae:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107fb1:	72 14                	jb     c0107fc7 <page2kva+0x3b>
c0107fb3:	ff 75 f4             	pushl  -0xc(%ebp)
c0107fb6:	68 5c ac 10 c0       	push   $0xc010ac5c
c0107fbb:	6a 62                	push   $0x62
c0107fbd:	68 7f ac 10 c0       	push   $0xc010ac7f
c0107fc2:	e8 29 84 ff ff       	call   c01003f0 <__panic>
c0107fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fca:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107fcf:	c9                   	leave  
c0107fd0:	c3                   	ret    

c0107fd1 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107fd1:	55                   	push   %ebp
c0107fd2:	89 e5                	mov    %esp,%ebp
c0107fd4:	83 ec 08             	sub    $0x8,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107fd7:	83 ec 0c             	sub    $0xc,%esp
c0107fda:	6a 01                	push   $0x1
c0107fdc:	e8 ff 90 ff ff       	call   c01010e0 <ide_device_valid>
c0107fe1:	83 c4 10             	add    $0x10,%esp
c0107fe4:	85 c0                	test   %eax,%eax
c0107fe6:	75 14                	jne    c0107ffc <swapfs_init+0x2b>
        panic("swap fs isn't available.\n");
c0107fe8:	83 ec 04             	sub    $0x4,%esp
c0107feb:	68 8d ac 10 c0       	push   $0xc010ac8d
c0107ff0:	6a 0d                	push   $0xd
c0107ff2:	68 a7 ac 10 c0       	push   $0xc010aca7
c0107ff7:	e8 f4 83 ff ff       	call   c01003f0 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107ffc:	83 ec 0c             	sub    $0xc,%esp
c0107fff:	6a 01                	push   $0x1
c0108001:	e8 1a 91 ff ff       	call   c0101120 <ide_device_size>
c0108006:	83 c4 10             	add    $0x10,%esp
c0108009:	c1 e8 03             	shr    $0x3,%eax
c010800c:	a3 1c 51 12 c0       	mov    %eax,0xc012511c
}
c0108011:	90                   	nop
c0108012:	c9                   	leave  
c0108013:	c3                   	ret    

c0108014 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108014:	55                   	push   %ebp
c0108015:	89 e5                	mov    %esp,%ebp
c0108017:	83 ec 18             	sub    $0x18,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010801a:	83 ec 0c             	sub    $0xc,%esp
c010801d:	ff 75 0c             	pushl  0xc(%ebp)
c0108020:	e8 67 ff ff ff       	call   c0107f8c <page2kva>
c0108025:	83 c4 10             	add    $0x10,%esp
c0108028:	89 c2                	mov    %eax,%edx
c010802a:	8b 45 08             	mov    0x8(%ebp),%eax
c010802d:	c1 e8 08             	shr    $0x8,%eax
c0108030:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108037:	74 0a                	je     c0108043 <swapfs_read+0x2f>
c0108039:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c010803e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0108041:	72 14                	jb     c0108057 <swapfs_read+0x43>
c0108043:	ff 75 08             	pushl  0x8(%ebp)
c0108046:	68 b8 ac 10 c0       	push   $0xc010acb8
c010804b:	6a 14                	push   $0x14
c010804d:	68 a7 ac 10 c0       	push   $0xc010aca7
c0108052:	e8 99 83 ff ff       	call   c01003f0 <__panic>
c0108057:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010805a:	c1 e0 03             	shl    $0x3,%eax
c010805d:	6a 08                	push   $0x8
c010805f:	52                   	push   %edx
c0108060:	50                   	push   %eax
c0108061:	6a 01                	push   $0x1
c0108063:	e8 f8 90 ff ff       	call   c0101160 <ide_read_secs>
c0108068:	83 c4 10             	add    $0x10,%esp
}
c010806b:	c9                   	leave  
c010806c:	c3                   	ret    

c010806d <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010806d:	55                   	push   %ebp
c010806e:	89 e5                	mov    %esp,%ebp
c0108070:	83 ec 18             	sub    $0x18,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108073:	83 ec 0c             	sub    $0xc,%esp
c0108076:	ff 75 0c             	pushl  0xc(%ebp)
c0108079:	e8 0e ff ff ff       	call   c0107f8c <page2kva>
c010807e:	83 c4 10             	add    $0x10,%esp
c0108081:	89 c2                	mov    %eax,%edx
c0108083:	8b 45 08             	mov    0x8(%ebp),%eax
c0108086:	c1 e8 08             	shr    $0x8,%eax
c0108089:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010808c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108090:	74 0a                	je     c010809c <swapfs_write+0x2f>
c0108092:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0108097:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010809a:	72 14                	jb     c01080b0 <swapfs_write+0x43>
c010809c:	ff 75 08             	pushl  0x8(%ebp)
c010809f:	68 b8 ac 10 c0       	push   $0xc010acb8
c01080a4:	6a 19                	push   $0x19
c01080a6:	68 a7 ac 10 c0       	push   $0xc010aca7
c01080ab:	e8 40 83 ff ff       	call   c01003f0 <__panic>
c01080b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080b3:	c1 e0 03             	shl    $0x3,%eax
c01080b6:	6a 08                	push   $0x8
c01080b8:	52                   	push   %edx
c01080b9:	50                   	push   %eax
c01080ba:	6a 01                	push   $0x1
c01080bc:	e8 c9 92 ff ff       	call   c010138a <ide_write_secs>
c01080c1:	83 c4 10             	add    $0x10,%esp
}
c01080c4:	c9                   	leave  
c01080c5:	c3                   	ret    

c01080c6 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01080c6:	55                   	push   %ebp
c01080c7:	89 e5                	mov    %esp,%ebp
c01080c9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01080cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01080d3:	eb 04                	jmp    c01080d9 <strlen+0x13>
        cnt ++;
c01080d5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01080d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01080dc:	8d 50 01             	lea    0x1(%eax),%edx
c01080df:	89 55 08             	mov    %edx,0x8(%ebp)
c01080e2:	0f b6 00             	movzbl (%eax),%eax
c01080e5:	84 c0                	test   %al,%al
c01080e7:	75 ec                	jne    c01080d5 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01080e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01080ec:	c9                   	leave  
c01080ed:	c3                   	ret    

c01080ee <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01080ee:	55                   	push   %ebp
c01080ef:	89 e5                	mov    %esp,%ebp
c01080f1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01080f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01080fb:	eb 04                	jmp    c0108101 <strnlen+0x13>
        cnt ++;
c01080fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0108101:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108104:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108107:	73 10                	jae    c0108119 <strnlen+0x2b>
c0108109:	8b 45 08             	mov    0x8(%ebp),%eax
c010810c:	8d 50 01             	lea    0x1(%eax),%edx
c010810f:	89 55 08             	mov    %edx,0x8(%ebp)
c0108112:	0f b6 00             	movzbl (%eax),%eax
c0108115:	84 c0                	test   %al,%al
c0108117:	75 e4                	jne    c01080fd <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108119:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010811c:	c9                   	leave  
c010811d:	c3                   	ret    

c010811e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010811e:	55                   	push   %ebp
c010811f:	89 e5                	mov    %esp,%ebp
c0108121:	57                   	push   %edi
c0108122:	56                   	push   %esi
c0108123:	83 ec 20             	sub    $0x20,%esp
c0108126:	8b 45 08             	mov    0x8(%ebp),%eax
c0108129:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010812c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010812f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108132:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108135:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108138:	89 d1                	mov    %edx,%ecx
c010813a:	89 c2                	mov    %eax,%edx
c010813c:	89 ce                	mov    %ecx,%esi
c010813e:	89 d7                	mov    %edx,%edi
c0108140:	ac                   	lods   %ds:(%esi),%al
c0108141:	aa                   	stos   %al,%es:(%edi)
c0108142:	84 c0                	test   %al,%al
c0108144:	75 fa                	jne    c0108140 <strcpy+0x22>
c0108146:	89 fa                	mov    %edi,%edx
c0108148:	89 f1                	mov    %esi,%ecx
c010814a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010814d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0108153:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0108156:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108157:	83 c4 20             	add    $0x20,%esp
c010815a:	5e                   	pop    %esi
c010815b:	5f                   	pop    %edi
c010815c:	5d                   	pop    %ebp
c010815d:	c3                   	ret    

c010815e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010815e:	55                   	push   %ebp
c010815f:	89 e5                	mov    %esp,%ebp
c0108161:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108164:	8b 45 08             	mov    0x8(%ebp),%eax
c0108167:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010816a:	eb 21                	jmp    c010818d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010816c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010816f:	0f b6 10             	movzbl (%eax),%edx
c0108172:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108175:	88 10                	mov    %dl,(%eax)
c0108177:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010817a:	0f b6 00             	movzbl (%eax),%eax
c010817d:	84 c0                	test   %al,%al
c010817f:	74 04                	je     c0108185 <strncpy+0x27>
            src ++;
c0108181:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0108185:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108189:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010818d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108191:	75 d9                	jne    c010816c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0108193:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108196:	c9                   	leave  
c0108197:	c3                   	ret    

c0108198 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108198:	55                   	push   %ebp
c0108199:	89 e5                	mov    %esp,%ebp
c010819b:	57                   	push   %edi
c010819c:	56                   	push   %esi
c010819d:	83 ec 20             	sub    $0x20,%esp
c01081a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01081a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01081a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01081ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01081af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081b2:	89 d1                	mov    %edx,%ecx
c01081b4:	89 c2                	mov    %eax,%edx
c01081b6:	89 ce                	mov    %ecx,%esi
c01081b8:	89 d7                	mov    %edx,%edi
c01081ba:	ac                   	lods   %ds:(%esi),%al
c01081bb:	ae                   	scas   %es:(%edi),%al
c01081bc:	75 08                	jne    c01081c6 <strcmp+0x2e>
c01081be:	84 c0                	test   %al,%al
c01081c0:	75 f8                	jne    c01081ba <strcmp+0x22>
c01081c2:	31 c0                	xor    %eax,%eax
c01081c4:	eb 04                	jmp    c01081ca <strcmp+0x32>
c01081c6:	19 c0                	sbb    %eax,%eax
c01081c8:	0c 01                	or     $0x1,%al
c01081ca:	89 fa                	mov    %edi,%edx
c01081cc:	89 f1                	mov    %esi,%ecx
c01081ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01081d1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01081d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01081d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01081da:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01081db:	83 c4 20             	add    $0x20,%esp
c01081de:	5e                   	pop    %esi
c01081df:	5f                   	pop    %edi
c01081e0:	5d                   	pop    %ebp
c01081e1:	c3                   	ret    

c01081e2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01081e2:	55                   	push   %ebp
c01081e3:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01081e5:	eb 0c                	jmp    c01081f3 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01081e7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01081eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01081ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01081f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01081f7:	74 1a                	je     c0108213 <strncmp+0x31>
c01081f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01081fc:	0f b6 00             	movzbl (%eax),%eax
c01081ff:	84 c0                	test   %al,%al
c0108201:	74 10                	je     c0108213 <strncmp+0x31>
c0108203:	8b 45 08             	mov    0x8(%ebp),%eax
c0108206:	0f b6 10             	movzbl (%eax),%edx
c0108209:	8b 45 0c             	mov    0xc(%ebp),%eax
c010820c:	0f b6 00             	movzbl (%eax),%eax
c010820f:	38 c2                	cmp    %al,%dl
c0108211:	74 d4                	je     c01081e7 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108213:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108217:	74 18                	je     c0108231 <strncmp+0x4f>
c0108219:	8b 45 08             	mov    0x8(%ebp),%eax
c010821c:	0f b6 00             	movzbl (%eax),%eax
c010821f:	0f b6 d0             	movzbl %al,%edx
c0108222:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108225:	0f b6 00             	movzbl (%eax),%eax
c0108228:	0f b6 c0             	movzbl %al,%eax
c010822b:	29 c2                	sub    %eax,%edx
c010822d:	89 d0                	mov    %edx,%eax
c010822f:	eb 05                	jmp    c0108236 <strncmp+0x54>
c0108231:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108236:	5d                   	pop    %ebp
c0108237:	c3                   	ret    

c0108238 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108238:	55                   	push   %ebp
c0108239:	89 e5                	mov    %esp,%ebp
c010823b:	83 ec 04             	sub    $0x4,%esp
c010823e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108241:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108244:	eb 14                	jmp    c010825a <strchr+0x22>
        if (*s == c) {
c0108246:	8b 45 08             	mov    0x8(%ebp),%eax
c0108249:	0f b6 00             	movzbl (%eax),%eax
c010824c:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010824f:	75 05                	jne    c0108256 <strchr+0x1e>
            return (char *)s;
c0108251:	8b 45 08             	mov    0x8(%ebp),%eax
c0108254:	eb 13                	jmp    c0108269 <strchr+0x31>
        }
        s ++;
c0108256:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010825a:	8b 45 08             	mov    0x8(%ebp),%eax
c010825d:	0f b6 00             	movzbl (%eax),%eax
c0108260:	84 c0                	test   %al,%al
c0108262:	75 e2                	jne    c0108246 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0108264:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108269:	c9                   	leave  
c010826a:	c3                   	ret    

c010826b <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010826b:	55                   	push   %ebp
c010826c:	89 e5                	mov    %esp,%ebp
c010826e:	83 ec 04             	sub    $0x4,%esp
c0108271:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108274:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108277:	eb 0f                	jmp    c0108288 <strfind+0x1d>
        if (*s == c) {
c0108279:	8b 45 08             	mov    0x8(%ebp),%eax
c010827c:	0f b6 00             	movzbl (%eax),%eax
c010827f:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108282:	74 10                	je     c0108294 <strfind+0x29>
            break;
        }
        s ++;
c0108284:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108288:	8b 45 08             	mov    0x8(%ebp),%eax
c010828b:	0f b6 00             	movzbl (%eax),%eax
c010828e:	84 c0                	test   %al,%al
c0108290:	75 e7                	jne    c0108279 <strfind+0xe>
c0108292:	eb 01                	jmp    c0108295 <strfind+0x2a>
        if (*s == c) {
            break;
c0108294:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0108295:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108298:	c9                   	leave  
c0108299:	c3                   	ret    

c010829a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010829a:	55                   	push   %ebp
c010829b:	89 e5                	mov    %esp,%ebp
c010829d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01082a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01082a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01082ae:	eb 04                	jmp    c01082b4 <strtol+0x1a>
        s ++;
c01082b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01082b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01082b7:	0f b6 00             	movzbl (%eax),%eax
c01082ba:	3c 20                	cmp    $0x20,%al
c01082bc:	74 f2                	je     c01082b0 <strtol+0x16>
c01082be:	8b 45 08             	mov    0x8(%ebp),%eax
c01082c1:	0f b6 00             	movzbl (%eax),%eax
c01082c4:	3c 09                	cmp    $0x9,%al
c01082c6:	74 e8                	je     c01082b0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01082c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01082cb:	0f b6 00             	movzbl (%eax),%eax
c01082ce:	3c 2b                	cmp    $0x2b,%al
c01082d0:	75 06                	jne    c01082d8 <strtol+0x3e>
        s ++;
c01082d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01082d6:	eb 15                	jmp    c01082ed <strtol+0x53>
    }
    else if (*s == '-') {
c01082d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01082db:	0f b6 00             	movzbl (%eax),%eax
c01082de:	3c 2d                	cmp    $0x2d,%al
c01082e0:	75 0b                	jne    c01082ed <strtol+0x53>
        s ++, neg = 1;
c01082e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01082e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01082ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01082f1:	74 06                	je     c01082f9 <strtol+0x5f>
c01082f3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01082f7:	75 24                	jne    c010831d <strtol+0x83>
c01082f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082fc:	0f b6 00             	movzbl (%eax),%eax
c01082ff:	3c 30                	cmp    $0x30,%al
c0108301:	75 1a                	jne    c010831d <strtol+0x83>
c0108303:	8b 45 08             	mov    0x8(%ebp),%eax
c0108306:	83 c0 01             	add    $0x1,%eax
c0108309:	0f b6 00             	movzbl (%eax),%eax
c010830c:	3c 78                	cmp    $0x78,%al
c010830e:	75 0d                	jne    c010831d <strtol+0x83>
        s += 2, base = 16;
c0108310:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108314:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010831b:	eb 2a                	jmp    c0108347 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010831d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108321:	75 17                	jne    c010833a <strtol+0xa0>
c0108323:	8b 45 08             	mov    0x8(%ebp),%eax
c0108326:	0f b6 00             	movzbl (%eax),%eax
c0108329:	3c 30                	cmp    $0x30,%al
c010832b:	75 0d                	jne    c010833a <strtol+0xa0>
        s ++, base = 8;
c010832d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108331:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108338:	eb 0d                	jmp    c0108347 <strtol+0xad>
    }
    else if (base == 0) {
c010833a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010833e:	75 07                	jne    c0108347 <strtol+0xad>
        base = 10;
c0108340:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108347:	8b 45 08             	mov    0x8(%ebp),%eax
c010834a:	0f b6 00             	movzbl (%eax),%eax
c010834d:	3c 2f                	cmp    $0x2f,%al
c010834f:	7e 1b                	jle    c010836c <strtol+0xd2>
c0108351:	8b 45 08             	mov    0x8(%ebp),%eax
c0108354:	0f b6 00             	movzbl (%eax),%eax
c0108357:	3c 39                	cmp    $0x39,%al
c0108359:	7f 11                	jg     c010836c <strtol+0xd2>
            dig = *s - '0';
c010835b:	8b 45 08             	mov    0x8(%ebp),%eax
c010835e:	0f b6 00             	movzbl (%eax),%eax
c0108361:	0f be c0             	movsbl %al,%eax
c0108364:	83 e8 30             	sub    $0x30,%eax
c0108367:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010836a:	eb 48                	jmp    c01083b4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010836c:	8b 45 08             	mov    0x8(%ebp),%eax
c010836f:	0f b6 00             	movzbl (%eax),%eax
c0108372:	3c 60                	cmp    $0x60,%al
c0108374:	7e 1b                	jle    c0108391 <strtol+0xf7>
c0108376:	8b 45 08             	mov    0x8(%ebp),%eax
c0108379:	0f b6 00             	movzbl (%eax),%eax
c010837c:	3c 7a                	cmp    $0x7a,%al
c010837e:	7f 11                	jg     c0108391 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108380:	8b 45 08             	mov    0x8(%ebp),%eax
c0108383:	0f b6 00             	movzbl (%eax),%eax
c0108386:	0f be c0             	movsbl %al,%eax
c0108389:	83 e8 57             	sub    $0x57,%eax
c010838c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010838f:	eb 23                	jmp    c01083b4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108391:	8b 45 08             	mov    0x8(%ebp),%eax
c0108394:	0f b6 00             	movzbl (%eax),%eax
c0108397:	3c 40                	cmp    $0x40,%al
c0108399:	7e 3c                	jle    c01083d7 <strtol+0x13d>
c010839b:	8b 45 08             	mov    0x8(%ebp),%eax
c010839e:	0f b6 00             	movzbl (%eax),%eax
c01083a1:	3c 5a                	cmp    $0x5a,%al
c01083a3:	7f 32                	jg     c01083d7 <strtol+0x13d>
            dig = *s - 'A' + 10;
c01083a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a8:	0f b6 00             	movzbl (%eax),%eax
c01083ab:	0f be c0             	movsbl %al,%eax
c01083ae:	83 e8 37             	sub    $0x37,%eax
c01083b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01083b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083b7:	3b 45 10             	cmp    0x10(%ebp),%eax
c01083ba:	7d 1a                	jge    c01083d6 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c01083bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01083c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01083c3:	0f af 45 10          	imul   0x10(%ebp),%eax
c01083c7:	89 c2                	mov    %eax,%edx
c01083c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083cc:	01 d0                	add    %edx,%eax
c01083ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01083d1:	e9 71 ff ff ff       	jmp    c0108347 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c01083d6:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c01083d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01083db:	74 08                	je     c01083e5 <strtol+0x14b>
        *endptr = (char *) s;
c01083dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083e0:	8b 55 08             	mov    0x8(%ebp),%edx
c01083e3:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01083e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01083e9:	74 07                	je     c01083f2 <strtol+0x158>
c01083eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01083ee:	f7 d8                	neg    %eax
c01083f0:	eb 03                	jmp    c01083f5 <strtol+0x15b>
c01083f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01083f5:	c9                   	leave  
c01083f6:	c3                   	ret    

c01083f7 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01083f7:	55                   	push   %ebp
c01083f8:	89 e5                	mov    %esp,%ebp
c01083fa:	57                   	push   %edi
c01083fb:	83 ec 24             	sub    $0x24,%esp
c01083fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108401:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108404:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108408:	8b 55 08             	mov    0x8(%ebp),%edx
c010840b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010840e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108411:	8b 45 10             	mov    0x10(%ebp),%eax
c0108414:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108417:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010841a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010841e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108421:	89 d7                	mov    %edx,%edi
c0108423:	f3 aa                	rep stos %al,%es:(%edi)
c0108425:	89 fa                	mov    %edi,%edx
c0108427:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010842a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010842d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108430:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108431:	83 c4 24             	add    $0x24,%esp
c0108434:	5f                   	pop    %edi
c0108435:	5d                   	pop    %ebp
c0108436:	c3                   	ret    

c0108437 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108437:	55                   	push   %ebp
c0108438:	89 e5                	mov    %esp,%ebp
c010843a:	57                   	push   %edi
c010843b:	56                   	push   %esi
c010843c:	53                   	push   %ebx
c010843d:	83 ec 30             	sub    $0x30,%esp
c0108440:	8b 45 08             	mov    0x8(%ebp),%eax
c0108443:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108446:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108449:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010844c:	8b 45 10             	mov    0x10(%ebp),%eax
c010844f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108455:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108458:	73 42                	jae    c010849c <memmove+0x65>
c010845a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010845d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108460:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108463:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108466:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108469:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010846c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010846f:	c1 e8 02             	shr    $0x2,%eax
c0108472:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108474:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108477:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010847a:	89 d7                	mov    %edx,%edi
c010847c:	89 c6                	mov    %eax,%esi
c010847e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108480:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108483:	83 e1 03             	and    $0x3,%ecx
c0108486:	74 02                	je     c010848a <memmove+0x53>
c0108488:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010848a:	89 f0                	mov    %esi,%eax
c010848c:	89 fa                	mov    %edi,%edx
c010848e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108491:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108494:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010849a:	eb 36                	jmp    c01084d2 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010849c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010849f:	8d 50 ff             	lea    -0x1(%eax),%edx
c01084a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01084a5:	01 c2                	add    %eax,%edx
c01084a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01084aa:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01084ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084b0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01084b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01084b6:	89 c1                	mov    %eax,%ecx
c01084b8:	89 d8                	mov    %ebx,%eax
c01084ba:	89 d6                	mov    %edx,%esi
c01084bc:	89 c7                	mov    %eax,%edi
c01084be:	fd                   	std    
c01084bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01084c1:	fc                   	cld    
c01084c2:	89 f8                	mov    %edi,%eax
c01084c4:	89 f2                	mov    %esi,%edx
c01084c6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01084c9:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01084cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01084cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01084d2:	83 c4 30             	add    $0x30,%esp
c01084d5:	5b                   	pop    %ebx
c01084d6:	5e                   	pop    %esi
c01084d7:	5f                   	pop    %edi
c01084d8:	5d                   	pop    %ebp
c01084d9:	c3                   	ret    

c01084da <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01084da:	55                   	push   %ebp
c01084db:	89 e5                	mov    %esp,%ebp
c01084dd:	57                   	push   %edi
c01084de:	56                   	push   %esi
c01084df:	83 ec 20             	sub    $0x20,%esp
c01084e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01084e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01084e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01084f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01084f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01084f7:	c1 e8 02             	shr    $0x2,%eax
c01084fa:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01084fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108502:	89 d7                	mov    %edx,%edi
c0108504:	89 c6                	mov    %eax,%esi
c0108506:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108508:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010850b:	83 e1 03             	and    $0x3,%ecx
c010850e:	74 02                	je     c0108512 <memcpy+0x38>
c0108510:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108512:	89 f0                	mov    %esi,%eax
c0108514:	89 fa                	mov    %edi,%edx
c0108516:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108519:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010851c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010851f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0108522:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108523:	83 c4 20             	add    $0x20,%esp
c0108526:	5e                   	pop    %esi
c0108527:	5f                   	pop    %edi
c0108528:	5d                   	pop    %ebp
c0108529:	c3                   	ret    

c010852a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010852a:	55                   	push   %ebp
c010852b:	89 e5                	mov    %esp,%ebp
c010852d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108530:	8b 45 08             	mov    0x8(%ebp),%eax
c0108533:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108536:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108539:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010853c:	eb 30                	jmp    c010856e <memcmp+0x44>
        if (*s1 != *s2) {
c010853e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108541:	0f b6 10             	movzbl (%eax),%edx
c0108544:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108547:	0f b6 00             	movzbl (%eax),%eax
c010854a:	38 c2                	cmp    %al,%dl
c010854c:	74 18                	je     c0108566 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010854e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108551:	0f b6 00             	movzbl (%eax),%eax
c0108554:	0f b6 d0             	movzbl %al,%edx
c0108557:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010855a:	0f b6 00             	movzbl (%eax),%eax
c010855d:	0f b6 c0             	movzbl %al,%eax
c0108560:	29 c2                	sub    %eax,%edx
c0108562:	89 d0                	mov    %edx,%eax
c0108564:	eb 1a                	jmp    c0108580 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108566:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010856a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010856e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108571:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108574:	89 55 10             	mov    %edx,0x10(%ebp)
c0108577:	85 c0                	test   %eax,%eax
c0108579:	75 c3                	jne    c010853e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010857b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108580:	c9                   	leave  
c0108581:	c3                   	ret    

c0108582 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0108582:	55                   	push   %ebp
c0108583:	89 e5                	mov    %esp,%ebp
c0108585:	83 ec 38             	sub    $0x38,%esp
c0108588:	8b 45 10             	mov    0x10(%ebp),%eax
c010858b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010858e:	8b 45 14             	mov    0x14(%ebp),%eax
c0108591:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108594:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108597:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010859a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010859d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01085a0:	8b 45 18             	mov    0x18(%ebp),%eax
c01085a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01085a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01085ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01085af:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01085b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01085bc:	74 1c                	je     c01085da <printnum+0x58>
c01085be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01085c6:	f7 75 e4             	divl   -0x1c(%ebp)
c01085c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01085cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085cf:	ba 00 00 00 00       	mov    $0x0,%edx
c01085d4:	f7 75 e4             	divl   -0x1c(%ebp)
c01085d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01085e0:	f7 75 e4             	divl   -0x1c(%ebp)
c01085e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01085e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01085e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01085ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01085f2:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01085f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01085f8:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01085fb:	8b 45 18             	mov    0x18(%ebp),%eax
c01085fe:	ba 00 00 00 00       	mov    $0x0,%edx
c0108603:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108606:	77 41                	ja     c0108649 <printnum+0xc7>
c0108608:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010860b:	72 05                	jb     c0108612 <printnum+0x90>
c010860d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108610:	77 37                	ja     c0108649 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108612:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108615:	83 e8 01             	sub    $0x1,%eax
c0108618:	83 ec 04             	sub    $0x4,%esp
c010861b:	ff 75 20             	pushl  0x20(%ebp)
c010861e:	50                   	push   %eax
c010861f:	ff 75 18             	pushl  0x18(%ebp)
c0108622:	ff 75 ec             	pushl  -0x14(%ebp)
c0108625:	ff 75 e8             	pushl  -0x18(%ebp)
c0108628:	ff 75 0c             	pushl  0xc(%ebp)
c010862b:	ff 75 08             	pushl  0x8(%ebp)
c010862e:	e8 4f ff ff ff       	call   c0108582 <printnum>
c0108633:	83 c4 20             	add    $0x20,%esp
c0108636:	eb 1b                	jmp    c0108653 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108638:	83 ec 08             	sub    $0x8,%esp
c010863b:	ff 75 0c             	pushl  0xc(%ebp)
c010863e:	ff 75 20             	pushl  0x20(%ebp)
c0108641:	8b 45 08             	mov    0x8(%ebp),%eax
c0108644:	ff d0                	call   *%eax
c0108646:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0108649:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010864d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108651:	7f e5                	jg     c0108638 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0108653:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108656:	05 58 ad 10 c0       	add    $0xc010ad58,%eax
c010865b:	0f b6 00             	movzbl (%eax),%eax
c010865e:	0f be c0             	movsbl %al,%eax
c0108661:	83 ec 08             	sub    $0x8,%esp
c0108664:	ff 75 0c             	pushl  0xc(%ebp)
c0108667:	50                   	push   %eax
c0108668:	8b 45 08             	mov    0x8(%ebp),%eax
c010866b:	ff d0                	call   *%eax
c010866d:	83 c4 10             	add    $0x10,%esp
}
c0108670:	90                   	nop
c0108671:	c9                   	leave  
c0108672:	c3                   	ret    

c0108673 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108673:	55                   	push   %ebp
c0108674:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108676:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010867a:	7e 14                	jle    c0108690 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010867c:	8b 45 08             	mov    0x8(%ebp),%eax
c010867f:	8b 00                	mov    (%eax),%eax
c0108681:	8d 48 08             	lea    0x8(%eax),%ecx
c0108684:	8b 55 08             	mov    0x8(%ebp),%edx
c0108687:	89 0a                	mov    %ecx,(%edx)
c0108689:	8b 50 04             	mov    0x4(%eax),%edx
c010868c:	8b 00                	mov    (%eax),%eax
c010868e:	eb 30                	jmp    c01086c0 <getuint+0x4d>
    }
    else if (lflag) {
c0108690:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108694:	74 16                	je     c01086ac <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108696:	8b 45 08             	mov    0x8(%ebp),%eax
c0108699:	8b 00                	mov    (%eax),%eax
c010869b:	8d 48 04             	lea    0x4(%eax),%ecx
c010869e:	8b 55 08             	mov    0x8(%ebp),%edx
c01086a1:	89 0a                	mov    %ecx,(%edx)
c01086a3:	8b 00                	mov    (%eax),%eax
c01086a5:	ba 00 00 00 00       	mov    $0x0,%edx
c01086aa:	eb 14                	jmp    c01086c0 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01086ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01086af:	8b 00                	mov    (%eax),%eax
c01086b1:	8d 48 04             	lea    0x4(%eax),%ecx
c01086b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01086b7:	89 0a                	mov    %ecx,(%edx)
c01086b9:	8b 00                	mov    (%eax),%eax
c01086bb:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01086c0:	5d                   	pop    %ebp
c01086c1:	c3                   	ret    

c01086c2 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01086c2:	55                   	push   %ebp
c01086c3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01086c5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01086c9:	7e 14                	jle    c01086df <getint+0x1d>
        return va_arg(*ap, long long);
c01086cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ce:	8b 00                	mov    (%eax),%eax
c01086d0:	8d 48 08             	lea    0x8(%eax),%ecx
c01086d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01086d6:	89 0a                	mov    %ecx,(%edx)
c01086d8:	8b 50 04             	mov    0x4(%eax),%edx
c01086db:	8b 00                	mov    (%eax),%eax
c01086dd:	eb 28                	jmp    c0108707 <getint+0x45>
    }
    else if (lflag) {
c01086df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01086e3:	74 12                	je     c01086f7 <getint+0x35>
        return va_arg(*ap, long);
c01086e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01086e8:	8b 00                	mov    (%eax),%eax
c01086ea:	8d 48 04             	lea    0x4(%eax),%ecx
c01086ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01086f0:	89 0a                	mov    %ecx,(%edx)
c01086f2:	8b 00                	mov    (%eax),%eax
c01086f4:	99                   	cltd   
c01086f5:	eb 10                	jmp    c0108707 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01086f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01086fa:	8b 00                	mov    (%eax),%eax
c01086fc:	8d 48 04             	lea    0x4(%eax),%ecx
c01086ff:	8b 55 08             	mov    0x8(%ebp),%edx
c0108702:	89 0a                	mov    %ecx,(%edx)
c0108704:	8b 00                	mov    (%eax),%eax
c0108706:	99                   	cltd   
    }
}
c0108707:	5d                   	pop    %ebp
c0108708:	c3                   	ret    

c0108709 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108709:	55                   	push   %ebp
c010870a:	89 e5                	mov    %esp,%ebp
c010870c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010870f:	8d 45 14             	lea    0x14(%ebp),%eax
c0108712:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108715:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108718:	50                   	push   %eax
c0108719:	ff 75 10             	pushl  0x10(%ebp)
c010871c:	ff 75 0c             	pushl  0xc(%ebp)
c010871f:	ff 75 08             	pushl  0x8(%ebp)
c0108722:	e8 06 00 00 00       	call   c010872d <vprintfmt>
c0108727:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010872a:	90                   	nop
c010872b:	c9                   	leave  
c010872c:	c3                   	ret    

c010872d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010872d:	55                   	push   %ebp
c010872e:	89 e5                	mov    %esp,%ebp
c0108730:	56                   	push   %esi
c0108731:	53                   	push   %ebx
c0108732:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108735:	eb 17                	jmp    c010874e <vprintfmt+0x21>
            if (ch == '\0') {
c0108737:	85 db                	test   %ebx,%ebx
c0108739:	0f 84 8e 03 00 00    	je     c0108acd <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c010873f:	83 ec 08             	sub    $0x8,%esp
c0108742:	ff 75 0c             	pushl  0xc(%ebp)
c0108745:	53                   	push   %ebx
c0108746:	8b 45 08             	mov    0x8(%ebp),%eax
c0108749:	ff d0                	call   *%eax
c010874b:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010874e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108751:	8d 50 01             	lea    0x1(%eax),%edx
c0108754:	89 55 10             	mov    %edx,0x10(%ebp)
c0108757:	0f b6 00             	movzbl (%eax),%eax
c010875a:	0f b6 d8             	movzbl %al,%ebx
c010875d:	83 fb 25             	cmp    $0x25,%ebx
c0108760:	75 d5                	jne    c0108737 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108762:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108766:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010876d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108770:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108773:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010877a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010877d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108780:	8b 45 10             	mov    0x10(%ebp),%eax
c0108783:	8d 50 01             	lea    0x1(%eax),%edx
c0108786:	89 55 10             	mov    %edx,0x10(%ebp)
c0108789:	0f b6 00             	movzbl (%eax),%eax
c010878c:	0f b6 d8             	movzbl %al,%ebx
c010878f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108792:	83 f8 55             	cmp    $0x55,%eax
c0108795:	0f 87 05 03 00 00    	ja     c0108aa0 <vprintfmt+0x373>
c010879b:	8b 04 85 7c ad 10 c0 	mov    -0x3fef5284(,%eax,4),%eax
c01087a2:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01087a4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01087a8:	eb d6                	jmp    c0108780 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01087aa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01087ae:	eb d0                	jmp    c0108780 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01087b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01087b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01087ba:	89 d0                	mov    %edx,%eax
c01087bc:	c1 e0 02             	shl    $0x2,%eax
c01087bf:	01 d0                	add    %edx,%eax
c01087c1:	01 c0                	add    %eax,%eax
c01087c3:	01 d8                	add    %ebx,%eax
c01087c5:	83 e8 30             	sub    $0x30,%eax
c01087c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01087cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01087ce:	0f b6 00             	movzbl (%eax),%eax
c01087d1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01087d4:	83 fb 2f             	cmp    $0x2f,%ebx
c01087d7:	7e 39                	jle    c0108812 <vprintfmt+0xe5>
c01087d9:	83 fb 39             	cmp    $0x39,%ebx
c01087dc:	7f 34                	jg     c0108812 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01087de:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01087e2:	eb d3                	jmp    c01087b7 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01087e4:	8b 45 14             	mov    0x14(%ebp),%eax
c01087e7:	8d 50 04             	lea    0x4(%eax),%edx
c01087ea:	89 55 14             	mov    %edx,0x14(%ebp)
c01087ed:	8b 00                	mov    (%eax),%eax
c01087ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01087f2:	eb 1f                	jmp    c0108813 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01087f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01087f8:	79 86                	jns    c0108780 <vprintfmt+0x53>
                width = 0;
c01087fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108801:	e9 7a ff ff ff       	jmp    c0108780 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0108806:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010880d:	e9 6e ff ff ff       	jmp    c0108780 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0108812:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0108813:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108817:	0f 89 63 ff ff ff    	jns    c0108780 <vprintfmt+0x53>
                width = precision, precision = -1;
c010881d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108820:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108823:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010882a:	e9 51 ff ff ff       	jmp    c0108780 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010882f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0108833:	e9 48 ff ff ff       	jmp    c0108780 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108838:	8b 45 14             	mov    0x14(%ebp),%eax
c010883b:	8d 50 04             	lea    0x4(%eax),%edx
c010883e:	89 55 14             	mov    %edx,0x14(%ebp)
c0108841:	8b 00                	mov    (%eax),%eax
c0108843:	83 ec 08             	sub    $0x8,%esp
c0108846:	ff 75 0c             	pushl  0xc(%ebp)
c0108849:	50                   	push   %eax
c010884a:	8b 45 08             	mov    0x8(%ebp),%eax
c010884d:	ff d0                	call   *%eax
c010884f:	83 c4 10             	add    $0x10,%esp
            break;
c0108852:	e9 71 02 00 00       	jmp    c0108ac8 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108857:	8b 45 14             	mov    0x14(%ebp),%eax
c010885a:	8d 50 04             	lea    0x4(%eax),%edx
c010885d:	89 55 14             	mov    %edx,0x14(%ebp)
c0108860:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108862:	85 db                	test   %ebx,%ebx
c0108864:	79 02                	jns    c0108868 <vprintfmt+0x13b>
                err = -err;
c0108866:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108868:	83 fb 06             	cmp    $0x6,%ebx
c010886b:	7f 0b                	jg     c0108878 <vprintfmt+0x14b>
c010886d:	8b 34 9d 3c ad 10 c0 	mov    -0x3fef52c4(,%ebx,4),%esi
c0108874:	85 f6                	test   %esi,%esi
c0108876:	75 19                	jne    c0108891 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0108878:	53                   	push   %ebx
c0108879:	68 69 ad 10 c0       	push   $0xc010ad69
c010887e:	ff 75 0c             	pushl  0xc(%ebp)
c0108881:	ff 75 08             	pushl  0x8(%ebp)
c0108884:	e8 80 fe ff ff       	call   c0108709 <printfmt>
c0108889:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010888c:	e9 37 02 00 00       	jmp    c0108ac8 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0108891:	56                   	push   %esi
c0108892:	68 72 ad 10 c0       	push   $0xc010ad72
c0108897:	ff 75 0c             	pushl  0xc(%ebp)
c010889a:	ff 75 08             	pushl  0x8(%ebp)
c010889d:	e8 67 fe ff ff       	call   c0108709 <printfmt>
c01088a2:	83 c4 10             	add    $0x10,%esp
            }
            break;
c01088a5:	e9 1e 02 00 00       	jmp    c0108ac8 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01088aa:	8b 45 14             	mov    0x14(%ebp),%eax
c01088ad:	8d 50 04             	lea    0x4(%eax),%edx
c01088b0:	89 55 14             	mov    %edx,0x14(%ebp)
c01088b3:	8b 30                	mov    (%eax),%esi
c01088b5:	85 f6                	test   %esi,%esi
c01088b7:	75 05                	jne    c01088be <vprintfmt+0x191>
                p = "(null)";
c01088b9:	be 75 ad 10 c0       	mov    $0xc010ad75,%esi
            }
            if (width > 0 && padc != '-') {
c01088be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01088c2:	7e 76                	jle    c010893a <vprintfmt+0x20d>
c01088c4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01088c8:	74 70                	je     c010893a <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01088ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088cd:	83 ec 08             	sub    $0x8,%esp
c01088d0:	50                   	push   %eax
c01088d1:	56                   	push   %esi
c01088d2:	e8 17 f8 ff ff       	call   c01080ee <strnlen>
c01088d7:	83 c4 10             	add    $0x10,%esp
c01088da:	89 c2                	mov    %eax,%edx
c01088dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088df:	29 d0                	sub    %edx,%eax
c01088e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01088e4:	eb 17                	jmp    c01088fd <vprintfmt+0x1d0>
                    putch(padc, putdat);
c01088e6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01088ea:	83 ec 08             	sub    $0x8,%esp
c01088ed:	ff 75 0c             	pushl  0xc(%ebp)
c01088f0:	50                   	push   %eax
c01088f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01088f4:	ff d0                	call   *%eax
c01088f6:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01088f9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01088fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108901:	7f e3                	jg     c01088e6 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108903:	eb 35                	jmp    c010893a <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108905:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108909:	74 1c                	je     c0108927 <vprintfmt+0x1fa>
c010890b:	83 fb 1f             	cmp    $0x1f,%ebx
c010890e:	7e 05                	jle    c0108915 <vprintfmt+0x1e8>
c0108910:	83 fb 7e             	cmp    $0x7e,%ebx
c0108913:	7e 12                	jle    c0108927 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0108915:	83 ec 08             	sub    $0x8,%esp
c0108918:	ff 75 0c             	pushl  0xc(%ebp)
c010891b:	6a 3f                	push   $0x3f
c010891d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108920:	ff d0                	call   *%eax
c0108922:	83 c4 10             	add    $0x10,%esp
c0108925:	eb 0f                	jmp    c0108936 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0108927:	83 ec 08             	sub    $0x8,%esp
c010892a:	ff 75 0c             	pushl  0xc(%ebp)
c010892d:	53                   	push   %ebx
c010892e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108931:	ff d0                	call   *%eax
c0108933:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108936:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010893a:	89 f0                	mov    %esi,%eax
c010893c:	8d 70 01             	lea    0x1(%eax),%esi
c010893f:	0f b6 00             	movzbl (%eax),%eax
c0108942:	0f be d8             	movsbl %al,%ebx
c0108945:	85 db                	test   %ebx,%ebx
c0108947:	74 26                	je     c010896f <vprintfmt+0x242>
c0108949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010894d:	78 b6                	js     c0108905 <vprintfmt+0x1d8>
c010894f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108957:	79 ac                	jns    c0108905 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108959:	eb 14                	jmp    c010896f <vprintfmt+0x242>
                putch(' ', putdat);
c010895b:	83 ec 08             	sub    $0x8,%esp
c010895e:	ff 75 0c             	pushl  0xc(%ebp)
c0108961:	6a 20                	push   $0x20
c0108963:	8b 45 08             	mov    0x8(%ebp),%eax
c0108966:	ff d0                	call   *%eax
c0108968:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010896b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010896f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108973:	7f e6                	jg     c010895b <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0108975:	e9 4e 01 00 00       	jmp    c0108ac8 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010897a:	83 ec 08             	sub    $0x8,%esp
c010897d:	ff 75 e0             	pushl  -0x20(%ebp)
c0108980:	8d 45 14             	lea    0x14(%ebp),%eax
c0108983:	50                   	push   %eax
c0108984:	e8 39 fd ff ff       	call   c01086c2 <getint>
c0108989:	83 c4 10             	add    $0x10,%esp
c010898c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010898f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108992:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108995:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108998:	85 d2                	test   %edx,%edx
c010899a:	79 23                	jns    c01089bf <vprintfmt+0x292>
                putch('-', putdat);
c010899c:	83 ec 08             	sub    $0x8,%esp
c010899f:	ff 75 0c             	pushl  0xc(%ebp)
c01089a2:	6a 2d                	push   $0x2d
c01089a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01089a7:	ff d0                	call   *%eax
c01089a9:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c01089ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089af:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01089b2:	f7 d8                	neg    %eax
c01089b4:	83 d2 00             	adc    $0x0,%edx
c01089b7:	f7 da                	neg    %edx
c01089b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01089bf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01089c6:	e9 9f 00 00 00       	jmp    c0108a6a <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01089cb:	83 ec 08             	sub    $0x8,%esp
c01089ce:	ff 75 e0             	pushl  -0x20(%ebp)
c01089d1:	8d 45 14             	lea    0x14(%ebp),%eax
c01089d4:	50                   	push   %eax
c01089d5:	e8 99 fc ff ff       	call   c0108673 <getuint>
c01089da:	83 c4 10             	add    $0x10,%esp
c01089dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01089e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01089ea:	eb 7e                	jmp    c0108a6a <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01089ec:	83 ec 08             	sub    $0x8,%esp
c01089ef:	ff 75 e0             	pushl  -0x20(%ebp)
c01089f2:	8d 45 14             	lea    0x14(%ebp),%eax
c01089f5:	50                   	push   %eax
c01089f6:	e8 78 fc ff ff       	call   c0108673 <getuint>
c01089fb:	83 c4 10             	add    $0x10,%esp
c01089fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a01:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0108a04:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108a0b:	eb 5d                	jmp    c0108a6a <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0108a0d:	83 ec 08             	sub    $0x8,%esp
c0108a10:	ff 75 0c             	pushl  0xc(%ebp)
c0108a13:	6a 30                	push   $0x30
c0108a15:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a18:	ff d0                	call   *%eax
c0108a1a:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0108a1d:	83 ec 08             	sub    $0x8,%esp
c0108a20:	ff 75 0c             	pushl  0xc(%ebp)
c0108a23:	6a 78                	push   $0x78
c0108a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a28:	ff d0                	call   *%eax
c0108a2a:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108a2d:	8b 45 14             	mov    0x14(%ebp),%eax
c0108a30:	8d 50 04             	lea    0x4(%eax),%edx
c0108a33:	89 55 14             	mov    %edx,0x14(%ebp)
c0108a36:	8b 00                	mov    (%eax),%eax
c0108a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108a42:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108a49:	eb 1f                	jmp    c0108a6a <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108a4b:	83 ec 08             	sub    $0x8,%esp
c0108a4e:	ff 75 e0             	pushl  -0x20(%ebp)
c0108a51:	8d 45 14             	lea    0x14(%ebp),%eax
c0108a54:	50                   	push   %eax
c0108a55:	e8 19 fc ff ff       	call   c0108673 <getuint>
c0108a5a:	83 c4 10             	add    $0x10,%esp
c0108a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108a63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108a6a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a71:	83 ec 04             	sub    $0x4,%esp
c0108a74:	52                   	push   %edx
c0108a75:	ff 75 e8             	pushl  -0x18(%ebp)
c0108a78:	50                   	push   %eax
c0108a79:	ff 75 f4             	pushl  -0xc(%ebp)
c0108a7c:	ff 75 f0             	pushl  -0x10(%ebp)
c0108a7f:	ff 75 0c             	pushl  0xc(%ebp)
c0108a82:	ff 75 08             	pushl  0x8(%ebp)
c0108a85:	e8 f8 fa ff ff       	call   c0108582 <printnum>
c0108a8a:	83 c4 20             	add    $0x20,%esp
            break;
c0108a8d:	eb 39                	jmp    c0108ac8 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108a8f:	83 ec 08             	sub    $0x8,%esp
c0108a92:	ff 75 0c             	pushl  0xc(%ebp)
c0108a95:	53                   	push   %ebx
c0108a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a99:	ff d0                	call   *%eax
c0108a9b:	83 c4 10             	add    $0x10,%esp
            break;
c0108a9e:	eb 28                	jmp    c0108ac8 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108aa0:	83 ec 08             	sub    $0x8,%esp
c0108aa3:	ff 75 0c             	pushl  0xc(%ebp)
c0108aa6:	6a 25                	push   $0x25
c0108aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aab:	ff d0                	call   *%eax
c0108aad:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108ab0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108ab4:	eb 04                	jmp    c0108aba <vprintfmt+0x38d>
c0108ab6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108aba:	8b 45 10             	mov    0x10(%ebp),%eax
c0108abd:	83 e8 01             	sub    $0x1,%eax
c0108ac0:	0f b6 00             	movzbl (%eax),%eax
c0108ac3:	3c 25                	cmp    $0x25,%al
c0108ac5:	75 ef                	jne    c0108ab6 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0108ac7:	90                   	nop
        }
    }
c0108ac8:	e9 68 fc ff ff       	jmp    c0108735 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0108acd:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0108ad1:	5b                   	pop    %ebx
c0108ad2:	5e                   	pop    %esi
c0108ad3:	5d                   	pop    %ebp
c0108ad4:	c3                   	ret    

c0108ad5 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108ad5:	55                   	push   %ebp
c0108ad6:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0108ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108adb:	8b 40 08             	mov    0x8(%eax),%eax
c0108ade:	8d 50 01             	lea    0x1(%eax),%edx
c0108ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ae4:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0108ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aea:	8b 10                	mov    (%eax),%edx
c0108aec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aef:	8b 40 04             	mov    0x4(%eax),%eax
c0108af2:	39 c2                	cmp    %eax,%edx
c0108af4:	73 12                	jae    c0108b08 <sprintputch+0x33>
        *b->buf ++ = ch;
c0108af6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108af9:	8b 00                	mov    (%eax),%eax
c0108afb:	8d 48 01             	lea    0x1(%eax),%ecx
c0108afe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108b01:	89 0a                	mov    %ecx,(%edx)
c0108b03:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b06:	88 10                	mov    %dl,(%eax)
    }
}
c0108b08:	90                   	nop
c0108b09:	5d                   	pop    %ebp
c0108b0a:	c3                   	ret    

c0108b0b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108b0b:	55                   	push   %ebp
c0108b0c:	89 e5                	mov    %esp,%ebp
c0108b0e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108b11:	8d 45 14             	lea    0x14(%ebp),%eax
c0108b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0108b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b1a:	50                   	push   %eax
c0108b1b:	ff 75 10             	pushl  0x10(%ebp)
c0108b1e:	ff 75 0c             	pushl  0xc(%ebp)
c0108b21:	ff 75 08             	pushl  0x8(%ebp)
c0108b24:	e8 0b 00 00 00       	call   c0108b34 <vsnprintf>
c0108b29:	83 c4 10             	add    $0x10,%esp
c0108b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108b32:	c9                   	leave  
c0108b33:	c3                   	ret    

c0108b34 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108b34:	55                   	push   %ebp
c0108b35:	89 e5                	mov    %esp,%ebp
c0108b37:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108b40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b43:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b49:	01 d0                	add    %edx,%eax
c0108b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108b59:	74 0a                	je     c0108b65 <vsnprintf+0x31>
c0108b5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b61:	39 c2                	cmp    %eax,%edx
c0108b63:	76 07                	jbe    c0108b6c <vsnprintf+0x38>
        return -E_INVAL;
c0108b65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108b6a:	eb 20                	jmp    c0108b8c <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108b6c:	ff 75 14             	pushl  0x14(%ebp)
c0108b6f:	ff 75 10             	pushl  0x10(%ebp)
c0108b72:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0108b75:	50                   	push   %eax
c0108b76:	68 d5 8a 10 c0       	push   $0xc0108ad5
c0108b7b:	e8 ad fb ff ff       	call   c010872d <vprintfmt>
c0108b80:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0108b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b86:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108b8c:	c9                   	leave  
c0108b8d:	c3                   	ret    

c0108b8e <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108b8e:	55                   	push   %ebp
c0108b8f:	89 e5                	mov    %esp,%ebp
c0108b91:	57                   	push   %edi
c0108b92:	56                   	push   %esi
c0108b93:	53                   	push   %ebx
c0108b94:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108b97:	a1 98 1a 12 c0       	mov    0xc0121a98,%eax
c0108b9c:	8b 15 9c 1a 12 c0    	mov    0xc0121a9c,%edx
c0108ba2:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108ba8:	6b f0 05             	imul   $0x5,%eax,%esi
c0108bab:	01 fe                	add    %edi,%esi
c0108bad:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0108bb2:	f7 e7                	mul    %edi
c0108bb4:	01 d6                	add    %edx,%esi
c0108bb6:	89 f2                	mov    %esi,%edx
c0108bb8:	83 c0 0b             	add    $0xb,%eax
c0108bbb:	83 d2 00             	adc    $0x0,%edx
c0108bbe:	89 c7                	mov    %eax,%edi
c0108bc0:	83 e7 ff             	and    $0xffffffff,%edi
c0108bc3:	89 f9                	mov    %edi,%ecx
c0108bc5:	0f b7 da             	movzwl %dx,%ebx
c0108bc8:	89 0d 98 1a 12 c0    	mov    %ecx,0xc0121a98
c0108bce:	89 1d 9c 1a 12 c0    	mov    %ebx,0xc0121a9c
    unsigned long long result = (next >> 12);
c0108bd4:	a1 98 1a 12 c0       	mov    0xc0121a98,%eax
c0108bd9:	8b 15 9c 1a 12 c0    	mov    0xc0121a9c,%edx
c0108bdf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0108be3:	c1 ea 0c             	shr    $0xc,%edx
c0108be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108be9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108bec:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0108bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108bf6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108bf9:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108bfc:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108c05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108c09:	74 1c                	je     c0108c27 <rand+0x99>
c0108c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c0e:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c13:	f7 75 dc             	divl   -0x24(%ebp)
c0108c16:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c1c:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c21:	f7 75 dc             	divl   -0x24(%ebp)
c0108c24:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108c27:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108c2d:	f7 75 dc             	divl   -0x24(%ebp)
c0108c30:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108c33:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108c36:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c39:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108c3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108c3f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108c42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108c45:	83 c4 24             	add    $0x24,%esp
c0108c48:	5b                   	pop    %ebx
c0108c49:	5e                   	pop    %esi
c0108c4a:	5f                   	pop    %edi
c0108c4b:	5d                   	pop    %ebp
c0108c4c:	c3                   	ret    

c0108c4d <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108c4d:	55                   	push   %ebp
c0108c4e:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c53:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c58:	a3 98 1a 12 c0       	mov    %eax,0xc0121a98
c0108c5d:	89 15 9c 1a 12 c0    	mov    %edx,0xc0121a9c
}
c0108c63:	90                   	nop
c0108c64:	5d                   	pop    %ebp
c0108c65:	c3                   	ret    
