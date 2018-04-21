
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 70 12 00       	mov    $0x127000,%eax
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
    leal next, %eax
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
c0100020:	a3 00 70 12 c0       	mov    %eax,0xc0127000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 60 12 c0       	mov    $0xc0126000,%esp
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
c010003c:	ba a4 c1 12 c0       	mov    $0xc012c1a4,%edx
c0100041:	b8 00 90 12 c0       	mov    $0xc0129000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	83 ec 04             	sub    $0x4,%esp
c010004d:	50                   	push   %eax
c010004e:	6a 00                	push   $0x0
c0100050:	68 00 90 12 c0       	push   $0xc0129000
c0100055:	e8 ca 94 00 00       	call   c0109524 <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 c8 1d 00 00       	call   c0101e2a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 c0 9d 10 c0 	movl   $0xc0109dc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 dc 9d 10 c0       	push   $0xc0109ddc
c0100074:	e8 19 02 00 00       	call   c0100292 <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 b0 08 00 00       	call   c0100931 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 8b 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 04 75 00 00       	call   c010758f <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 0c 1f 00 00       	call   c0101f9c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 8e 20 00 00       	call   c0102123 <idt_init>

    vmm_init();                 // init virtual memory management
c0100095:	e8 74 3d 00 00       	call   c0103e0e <vmm_init>
    proc_init();                // init process table
c010009a:	e8 53 8e 00 00       	call   c0108ef2 <proc_init>
    
    ide_init();                 // init ide devices
c010009f:	e8 55 0d 00 00       	call   c0100df9 <ide_init>
    swap_init();                // init swap
c01000a4:	e8 47 52 00 00       	call   c01052f0 <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 23 15 00 00       	call   c01015d1 <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 26 20 00 00       	call   c01020d9 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000b3:	e8 da 8f 00 00       	call   c0109092 <cpu_idle>

c01000b8 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b8:	55                   	push   %ebp
c01000b9:	89 e5                	mov    %esp,%ebp
c01000bb:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000be:	83 ec 04             	sub    $0x4,%esp
c01000c1:	6a 00                	push   $0x0
c01000c3:	6a 00                	push   $0x0
c01000c5:	6a 00                	push   $0x0
c01000c7:	e8 c1 0c 00 00       	call   c0100d8d <mon_backtrace>
c01000cc:	83 c4 10             	add    $0x10,%esp
}
c01000cf:	90                   	nop
c01000d0:	c9                   	leave  
c01000d1:	c3                   	ret    

c01000d2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d2:	55                   	push   %ebp
c01000d3:	89 e5                	mov    %esp,%ebp
c01000d5:	53                   	push   %ebx
c01000d6:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000df:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e5:	51                   	push   %ecx
c01000e6:	52                   	push   %edx
c01000e7:	53                   	push   %ebx
c01000e8:	50                   	push   %eax
c01000e9:	e8 ca ff ff ff       	call   c01000b8 <grade_backtrace2>
c01000ee:	83 c4 10             	add    $0x10,%esp
}
c01000f1:	90                   	nop
c01000f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000f5:	c9                   	leave  
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	83 ec 08             	sub    $0x8,%esp
c0100100:	ff 75 10             	pushl  0x10(%ebp)
c0100103:	ff 75 08             	pushl  0x8(%ebp)
c0100106:	e8 c7 ff ff ff       	call   c01000d2 <grade_backtrace1>
c010010b:	83 c4 10             	add    $0x10,%esp
}
c010010e:	90                   	nop
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	83 ec 04             	sub    $0x4,%esp
c010011f:	68 00 00 ff ff       	push   $0xffff0000
c0100124:	50                   	push   %eax
c0100125:	6a 00                	push   $0x0
c0100127:	e8 cb ff ff ff       	call   c01000f7 <grade_backtrace0>
c010012c:	83 c4 10             	add    $0x10,%esp
}
c010012f:	90                   	nop
c0100130:	c9                   	leave  
c0100131:	c3                   	ret    

c0100132 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100132:	55                   	push   %ebp
c0100133:	89 e5                	mov    %esp,%ebp
c0100135:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100138:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013b:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013e:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100141:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 c0             	movzwl %ax,%eax
c010014b:	83 e0 03             	and    $0x3,%eax
c010014e:	89 c2                	mov    %eax,%edx
c0100150:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c0100155:	83 ec 04             	sub    $0x4,%esp
c0100158:	52                   	push   %edx
c0100159:	50                   	push   %eax
c010015a:	68 e1 9d 10 c0       	push   $0xc0109de1
c010015f:	e8 2e 01 00 00       	call   c0100292 <cprintf>
c0100164:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100167:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010016b:	0f b7 d0             	movzwl %ax,%edx
c010016e:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c0100173:	83 ec 04             	sub    $0x4,%esp
c0100176:	52                   	push   %edx
c0100177:	50                   	push   %eax
c0100178:	68 ef 9d 10 c0       	push   $0xc0109def
c010017d:	e8 10 01 00 00       	call   c0100292 <cprintf>
c0100182:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100189:	0f b7 d0             	movzwl %ax,%edx
c010018c:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c0100191:	83 ec 04             	sub    $0x4,%esp
c0100194:	52                   	push   %edx
c0100195:	50                   	push   %eax
c0100196:	68 fd 9d 10 c0       	push   $0xc0109dfd
c010019b:	e8 f2 00 00 00       	call   c0100292 <cprintf>
c01001a0:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c01001a3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a7:	0f b7 d0             	movzwl %ax,%edx
c01001aa:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c01001af:	83 ec 04             	sub    $0x4,%esp
c01001b2:	52                   	push   %edx
c01001b3:	50                   	push   %eax
c01001b4:	68 0b 9e 10 c0       	push   $0xc0109e0b
c01001b9:	e8 d4 00 00 00       	call   c0100292 <cprintf>
c01001be:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c01001cd:	83 ec 04             	sub    $0x4,%esp
c01001d0:	52                   	push   %edx
c01001d1:	50                   	push   %eax
c01001d2:	68 19 9e 10 c0       	push   $0xc0109e19
c01001d7:	e8 b6 00 00 00       	call   c0100292 <cprintf>
c01001dc:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001df:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c01001e4:	83 c0 01             	add    $0x1,%eax
c01001e7:	a3 00 90 12 c0       	mov    %eax,0xc0129000
}
c01001ec:	90                   	nop
c01001ed:	c9                   	leave  
c01001ee:	c3                   	ret    

c01001ef <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ef:	55                   	push   %ebp
c01001f0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
c01001f2:	cd 78                	int    $0x78
c01001f4:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c01001f6:	90                   	nop
c01001f7:	5d                   	pop    %ebp
c01001f8:	c3                   	ret    

c01001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f9:	55                   	push   %ebp
c01001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    // cprintf("in lab1_switch_to_kernel\n");
    asm volatile (
c01001fc:	cd 79                	int    $0x79
c01001fe:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
        : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100200:	90                   	nop
c0100201:	5d                   	pop    %ebp
c0100202:	c3                   	ret    

c0100203 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100203:	55                   	push   %ebp
c0100204:	89 e5                	mov    %esp,%ebp
c0100206:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c0100209:	e8 24 ff ff ff       	call   c0100132 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020e:	83 ec 0c             	sub    $0xc,%esp
c0100211:	68 28 9e 10 c0       	push   $0xc0109e28
c0100216:	e8 77 00 00 00       	call   c0100292 <cprintf>
c010021b:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c010021e:	e8 cc ff ff ff       	call   c01001ef <lab1_switch_to_user>
    lab1_print_cur_status();
c0100223:	e8 0a ff ff ff       	call   c0100132 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100228:	83 ec 0c             	sub    $0xc,%esp
c010022b:	68 48 9e 10 c0       	push   $0xc0109e48
c0100230:	e8 5d 00 00 00       	call   c0100292 <cprintf>
c0100235:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100238:	e8 bc ff ff ff       	call   c01001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023d:	e8 f0 fe ff ff       	call   c0100132 <lab1_print_cur_status>
}
c0100242:	90                   	nop
c0100243:	c9                   	leave  
c0100244:	c3                   	ret    

c0100245 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100245:	55                   	push   %ebp
c0100246:	89 e5                	mov    %esp,%ebp
c0100248:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c010024b:	83 ec 0c             	sub    $0xc,%esp
c010024e:	ff 75 08             	pushl  0x8(%ebp)
c0100251:	e8 05 1c 00 00       	call   c0101e5b <cons_putc>
c0100256:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c0100259:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025c:	8b 00                	mov    (%eax),%eax
c010025e:	8d 50 01             	lea    0x1(%eax),%edx
c0100261:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100264:	89 10                	mov    %edx,(%eax)
}
c0100266:	90                   	nop
c0100267:	c9                   	leave  
c0100268:	c3                   	ret    

c0100269 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100269:	55                   	push   %ebp
c010026a:	89 e5                	mov    %esp,%ebp
c010026c:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c010026f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100276:	ff 75 0c             	pushl  0xc(%ebp)
c0100279:	ff 75 08             	pushl  0x8(%ebp)
c010027c:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010027f:	50                   	push   %eax
c0100280:	68 45 02 10 c0       	push   $0xc0100245
c0100285:	e8 d0 95 00 00       	call   c010985a <vprintfmt>
c010028a:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100290:	c9                   	leave  
c0100291:	c3                   	ret    

c0100292 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100292:	55                   	push   %ebp
c0100293:	89 e5                	mov    %esp,%ebp
c0100295:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100298:	8d 45 0c             	lea    0xc(%ebp),%eax
c010029b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010029e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a1:	83 ec 08             	sub    $0x8,%esp
c01002a4:	50                   	push   %eax
c01002a5:	ff 75 08             	pushl  0x8(%ebp)
c01002a8:	e8 bc ff ff ff       	call   c0100269 <vcprintf>
c01002ad:	83 c4 10             	add    $0x10,%esp
c01002b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b6:	c9                   	leave  
c01002b7:	c3                   	ret    

c01002b8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b8:	55                   	push   %ebp
c01002b9:	89 e5                	mov    %esp,%ebp
c01002bb:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002be:	83 ec 0c             	sub    $0xc,%esp
c01002c1:	ff 75 08             	pushl  0x8(%ebp)
c01002c4:	e8 92 1b 00 00       	call   c0101e5b <cons_putc>
c01002c9:	83 c4 10             	add    $0x10,%esp
}
c01002cc:	90                   	nop
c01002cd:	c9                   	leave  
c01002ce:	c3                   	ret    

c01002cf <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002cf:	55                   	push   %ebp
c01002d0:	89 e5                	mov    %esp,%ebp
c01002d2:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002dc:	eb 14                	jmp    c01002f2 <cputs+0x23>
        cputch(c, &cnt);
c01002de:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002e2:	83 ec 08             	sub    $0x8,%esp
c01002e5:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002e8:	52                   	push   %edx
c01002e9:	50                   	push   %eax
c01002ea:	e8 56 ff ff ff       	call   c0100245 <cputch>
c01002ef:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f5:	8d 50 01             	lea    0x1(%eax),%edx
c01002f8:	89 55 08             	mov    %edx,0x8(%ebp)
c01002fb:	0f b6 00             	movzbl (%eax),%eax
c01002fe:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100301:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100305:	75 d7                	jne    c01002de <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c0100307:	83 ec 08             	sub    $0x8,%esp
c010030a:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010030d:	50                   	push   %eax
c010030e:	6a 0a                	push   $0xa
c0100310:	e8 30 ff ff ff       	call   c0100245 <cputch>
c0100315:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100318:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010031b:	c9                   	leave  
c010031c:	c3                   	ret    

c010031d <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010031d:	55                   	push   %ebp
c010031e:	89 e5                	mov    %esp,%ebp
c0100320:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100323:	e8 7c 1b 00 00       	call   c0101ea4 <cons_getc>
c0100328:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010032b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010032f:	74 f2                	je     c0100323 <getchar+0x6>
        /* do nothing */;
    return c;
c0100331:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100334:	c9                   	leave  
c0100335:	c3                   	ret    

c0100336 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100336:	55                   	push   %ebp
c0100337:	89 e5                	mov    %esp,%ebp
c0100339:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c010033c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100340:	74 13                	je     c0100355 <readline+0x1f>
        cprintf("%s", prompt);
c0100342:	83 ec 08             	sub    $0x8,%esp
c0100345:	ff 75 08             	pushl  0x8(%ebp)
c0100348:	68 67 9e 10 c0       	push   $0xc0109e67
c010034d:	e8 40 ff ff ff       	call   c0100292 <cprintf>
c0100352:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100355:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010035c:	e8 bc ff ff ff       	call   c010031d <getchar>
c0100361:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100368:	79 0a                	jns    c0100374 <readline+0x3e>
            return NULL;
c010036a:	b8 00 00 00 00       	mov    $0x0,%eax
c010036f:	e9 82 00 00 00       	jmp    c01003f6 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100374:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100378:	7e 2b                	jle    c01003a5 <readline+0x6f>
c010037a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100381:	7f 22                	jg     c01003a5 <readline+0x6f>
            cputchar(c);
c0100383:	83 ec 0c             	sub    $0xc,%esp
c0100386:	ff 75 f0             	pushl  -0x10(%ebp)
c0100389:	e8 2a ff ff ff       	call   c01002b8 <cputchar>
c010038e:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100391:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100394:	8d 50 01             	lea    0x1(%eax),%edx
c0100397:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010039a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010039d:	88 90 20 90 12 c0    	mov    %dl,-0x3fed6fe0(%eax)
c01003a3:	eb 4c                	jmp    c01003f1 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c01003a5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003a9:	75 1a                	jne    c01003c5 <readline+0x8f>
c01003ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003af:	7e 14                	jle    c01003c5 <readline+0x8f>
            cputchar(c);
c01003b1:	83 ec 0c             	sub    $0xc,%esp
c01003b4:	ff 75 f0             	pushl  -0x10(%ebp)
c01003b7:	e8 fc fe ff ff       	call   c01002b8 <cputchar>
c01003bc:	83 c4 10             	add    $0x10,%esp
            i --;
c01003bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003c3:	eb 2c                	jmp    c01003f1 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01003c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003c9:	74 06                	je     c01003d1 <readline+0x9b>
c01003cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003cf:	75 8b                	jne    c010035c <readline+0x26>
            cputchar(c);
c01003d1:	83 ec 0c             	sub    $0xc,%esp
c01003d4:	ff 75 f0             	pushl  -0x10(%ebp)
c01003d7:	e8 dc fe ff ff       	call   c01002b8 <cputchar>
c01003dc:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e2:	05 20 90 12 c0       	add    $0xc0129020,%eax
c01003e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003ea:	b8 20 90 12 c0       	mov    $0xc0129020,%eax
c01003ef:	eb 05                	jmp    c01003f6 <readline+0xc0>
        }
    }
c01003f1:	e9 66 ff ff ff       	jmp    c010035c <readline+0x26>
}
c01003f6:	c9                   	leave  
c01003f7:	c3                   	ret    

c01003f8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f8:	55                   	push   %ebp
c01003f9:	89 e5                	mov    %esp,%ebp
c01003fb:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003fe:	a1 20 94 12 c0       	mov    0xc0129420,%eax
c0100403:	85 c0                	test   %eax,%eax
c0100405:	75 5f                	jne    c0100466 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100407:	c7 05 20 94 12 c0 01 	movl   $0x1,0xc0129420
c010040e:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100411:	8d 45 14             	lea    0x14(%ebp),%eax
c0100414:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100417:	83 ec 04             	sub    $0x4,%esp
c010041a:	ff 75 0c             	pushl  0xc(%ebp)
c010041d:	ff 75 08             	pushl  0x8(%ebp)
c0100420:	68 6a 9e 10 c0       	push   $0xc0109e6a
c0100425:	e8 68 fe ff ff       	call   c0100292 <cprintf>
c010042a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010042d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100430:	83 ec 08             	sub    $0x8,%esp
c0100433:	50                   	push   %eax
c0100434:	ff 75 10             	pushl  0x10(%ebp)
c0100437:	e8 2d fe ff ff       	call   c0100269 <vcprintf>
c010043c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010043f:	83 ec 0c             	sub    $0xc,%esp
c0100442:	68 86 9e 10 c0       	push   $0xc0109e86
c0100447:	e8 46 fe ff ff       	call   c0100292 <cprintf>
c010044c:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c010044f:	83 ec 0c             	sub    $0xc,%esp
c0100452:	68 88 9e 10 c0       	push   $0xc0109e88
c0100457:	e8 36 fe ff ff       	call   c0100292 <cprintf>
c010045c:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c010045f:	e8 17 06 00 00       	call   c0100a7b <print_stackframe>
c0100464:	eb 01                	jmp    c0100467 <__panic+0x6f>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100466:	90                   	nop
    print_stackframe();
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100467:	e8 74 1c 00 00       	call   c01020e0 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010046c:	83 ec 0c             	sub    $0xc,%esp
c010046f:	6a 00                	push   $0x0
c0100471:	e8 3d 08 00 00       	call   c0100cb3 <kmonitor>
c0100476:	83 c4 10             	add    $0x10,%esp
    }
c0100479:	eb f1                	jmp    c010046c <__panic+0x74>

c010047b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010047b:	55                   	push   %ebp
c010047c:	89 e5                	mov    %esp,%ebp
c010047e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100481:	8d 45 14             	lea    0x14(%ebp),%eax
c0100484:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100487:	83 ec 04             	sub    $0x4,%esp
c010048a:	ff 75 0c             	pushl  0xc(%ebp)
c010048d:	ff 75 08             	pushl  0x8(%ebp)
c0100490:	68 9a 9e 10 c0       	push   $0xc0109e9a
c0100495:	e8 f8 fd ff ff       	call   c0100292 <cprintf>
c010049a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a0:	83 ec 08             	sub    $0x8,%esp
c01004a3:	50                   	push   %eax
c01004a4:	ff 75 10             	pushl  0x10(%ebp)
c01004a7:	e8 bd fd ff ff       	call   c0100269 <vcprintf>
c01004ac:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c01004af:	83 ec 0c             	sub    $0xc,%esp
c01004b2:	68 86 9e 10 c0       	push   $0xc0109e86
c01004b7:	e8 d6 fd ff ff       	call   c0100292 <cprintf>
c01004bc:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01004bf:	90                   	nop
c01004c0:	c9                   	leave  
c01004c1:	c3                   	ret    

c01004c2 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004c2:	55                   	push   %ebp
c01004c3:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004c5:	a1 20 94 12 c0       	mov    0xc0129420,%eax
}
c01004ca:	5d                   	pop    %ebp
c01004cb:	c3                   	ret    

c01004cc <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004cc:	55                   	push   %ebp
c01004cd:	89 e5                	mov    %esp,%ebp
c01004cf:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d5:	8b 00                	mov    (%eax),%eax
c01004d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004da:	8b 45 10             	mov    0x10(%ebp),%eax
c01004dd:	8b 00                	mov    (%eax),%eax
c01004df:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004e9:	e9 d2 00 00 00       	jmp    c01005c0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004f4:	01 d0                	add    %edx,%eax
c01004f6:	89 c2                	mov    %eax,%edx
c01004f8:	c1 ea 1f             	shr    $0x1f,%edx
c01004fb:	01 d0                	add    %edx,%eax
c01004fd:	d1 f8                	sar    %eax
c01004ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100505:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100508:	eb 04                	jmp    c010050e <stab_binsearch+0x42>
            m --;
c010050a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010050e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100514:	7c 1f                	jl     c0100535 <stab_binsearch+0x69>
c0100516:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100519:	89 d0                	mov    %edx,%eax
c010051b:	01 c0                	add    %eax,%eax
c010051d:	01 d0                	add    %edx,%eax
c010051f:	c1 e0 02             	shl    $0x2,%eax
c0100522:	89 c2                	mov    %eax,%edx
c0100524:	8b 45 08             	mov    0x8(%ebp),%eax
c0100527:	01 d0                	add    %edx,%eax
c0100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052d:	0f b6 c0             	movzbl %al,%eax
c0100530:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100533:	75 d5                	jne    c010050a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100535:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100538:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010053b:	7d 0b                	jge    c0100548 <stab_binsearch+0x7c>
            l = true_m + 1;
c010053d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100540:	83 c0 01             	add    $0x1,%eax
c0100543:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100546:	eb 78                	jmp    c01005c0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100548:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010054f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100552:	89 d0                	mov    %edx,%eax
c0100554:	01 c0                	add    %eax,%eax
c0100556:	01 d0                	add    %edx,%eax
c0100558:	c1 e0 02             	shl    $0x2,%eax
c010055b:	89 c2                	mov    %eax,%edx
c010055d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100560:	01 d0                	add    %edx,%eax
c0100562:	8b 40 08             	mov    0x8(%eax),%eax
c0100565:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100568:	73 13                	jae    c010057d <stab_binsearch+0xb1>
            *region_left = m;
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100570:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100572:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100575:	83 c0 01             	add    $0x1,%eax
c0100578:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010057b:	eb 43                	jmp    c01005c0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100580:	89 d0                	mov    %edx,%eax
c0100582:	01 c0                	add    %eax,%eax
c0100584:	01 d0                	add    %edx,%eax
c0100586:	c1 e0 02             	shl    $0x2,%eax
c0100589:	89 c2                	mov    %eax,%edx
c010058b:	8b 45 08             	mov    0x8(%ebp),%eax
c010058e:	01 d0                	add    %edx,%eax
c0100590:	8b 40 08             	mov    0x8(%eax),%eax
c0100593:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100596:	76 16                	jbe    c01005ae <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100598:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059e:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005a6:	83 e8 01             	sub    $0x1,%eax
c01005a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005ac:	eb 12                	jmp    c01005c0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b4:	89 10                	mov    %edx,(%eax)
            l = m;
c01005b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005bc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01005c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005c6:	0f 8e 22 ff ff ff    	jle    c01004ee <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01005cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005d0:	75 0f                	jne    c01005e1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d5:	8b 00                	mov    (%eax),%eax
c01005d7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005da:	8b 45 10             	mov    0x10(%ebp),%eax
c01005dd:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005df:	eb 3f                	jmp    c0100620 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e4:	8b 00                	mov    (%eax),%eax
c01005e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005e9:	eb 04                	jmp    c01005ef <stab_binsearch+0x123>
c01005eb:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f2:	8b 00                	mov    (%eax),%eax
c01005f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005f7:	7d 1f                	jge    c0100618 <stab_binsearch+0x14c>
c01005f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005fc:	89 d0                	mov    %edx,%eax
c01005fe:	01 c0                	add    %eax,%eax
c0100600:	01 d0                	add    %edx,%eax
c0100602:	c1 e0 02             	shl    $0x2,%eax
c0100605:	89 c2                	mov    %eax,%edx
c0100607:	8b 45 08             	mov    0x8(%ebp),%eax
c010060a:	01 d0                	add    %edx,%eax
c010060c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100610:	0f b6 c0             	movzbl %al,%eax
c0100613:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100616:	75 d3                	jne    c01005eb <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100618:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010061e:	89 10                	mov    %edx,(%eax)
    }
}
c0100620:	90                   	nop
c0100621:	c9                   	leave  
c0100622:	c3                   	ret    

c0100623 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100623:	55                   	push   %ebp
c0100624:	89 e5                	mov    %esp,%ebp
c0100626:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100629:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062c:	c7 00 b8 9e 10 c0    	movl   $0xc0109eb8,(%eax)
    info->eip_line = 0;
c0100632:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010063c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063f:	c7 40 08 b8 9e 10 c0 	movl   $0xc0109eb8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100646:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100649:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100650:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100653:	8b 55 08             	mov    0x8(%ebp),%edx
c0100656:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100659:	8b 45 0c             	mov    0xc(%ebp),%eax
c010065c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100663:	c7 45 f4 f8 c2 10 c0 	movl   $0xc010c2f8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010066a:	c7 45 f0 c4 e9 11 c0 	movl   $0xc011e9c4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100671:	c7 45 ec c5 e9 11 c0 	movl   $0xc011e9c5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100678:	c7 45 e8 ea 34 12 c0 	movl   $0xc01234ea,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010067f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100682:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100685:	76 0d                	jbe    c0100694 <debuginfo_eip+0x71>
c0100687:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010068a:	83 e8 01             	sub    $0x1,%eax
c010068d:	0f b6 00             	movzbl (%eax),%eax
c0100690:	84 c0                	test   %al,%al
c0100692:	74 0a                	je     c010069e <debuginfo_eip+0x7b>
        return -1;
c0100694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100699:	e9 91 02 00 00       	jmp    c010092f <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010069e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ab:	29 c2                	sub    %eax,%edx
c01006ad:	89 d0                	mov    %edx,%eax
c01006af:	c1 f8 02             	sar    $0x2,%eax
c01006b2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006b8:	83 e8 01             	sub    $0x1,%eax
c01006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006be:	ff 75 08             	pushl  0x8(%ebp)
c01006c1:	6a 64                	push   $0x64
c01006c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c6:	50                   	push   %eax
c01006c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006ca:	50                   	push   %eax
c01006cb:	ff 75 f4             	pushl  -0xc(%ebp)
c01006ce:	e8 f9 fd ff ff       	call   c01004cc <stab_binsearch>
c01006d3:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	85 c0                	test   %eax,%eax
c01006db:	75 0a                	jne    c01006e7 <debuginfo_eip+0xc4>
        return -1;
c01006dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006e2:	e9 48 02 00 00       	jmp    c010092f <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006f3:	ff 75 08             	pushl  0x8(%ebp)
c01006f6:	6a 24                	push   $0x24
c01006f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006fb:	50                   	push   %eax
c01006fc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006ff:	50                   	push   %eax
c0100700:	ff 75 f4             	pushl  -0xc(%ebp)
c0100703:	e8 c4 fd ff ff       	call   c01004cc <stab_binsearch>
c0100708:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c010070b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010070e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100711:	39 c2                	cmp    %eax,%edx
c0100713:	7f 7c                	jg     c0100791 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100715:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100718:	89 c2                	mov    %eax,%edx
c010071a:	89 d0                	mov    %edx,%eax
c010071c:	01 c0                	add    %eax,%eax
c010071e:	01 d0                	add    %edx,%eax
c0100720:	c1 e0 02             	shl    $0x2,%eax
c0100723:	89 c2                	mov    %eax,%edx
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	01 d0                	add    %edx,%eax
c010072a:	8b 00                	mov    (%eax),%eax
c010072c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010072f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100732:	29 d1                	sub    %edx,%ecx
c0100734:	89 ca                	mov    %ecx,%edx
c0100736:	39 d0                	cmp    %edx,%eax
c0100738:	73 22                	jae    c010075c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010073a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	8b 10                	mov    (%eax),%edx
c0100751:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100754:	01 c2                	add    %eax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010075f:	89 c2                	mov    %eax,%edx
c0100761:	89 d0                	mov    %edx,%eax
c0100763:	01 c0                	add    %eax,%eax
c0100765:	01 d0                	add    %edx,%eax
c0100767:	c1 e0 02             	shl    $0x2,%eax
c010076a:	89 c2                	mov    %eax,%edx
c010076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010076f:	01 d0                	add    %edx,%eax
c0100771:	8b 50 08             	mov    0x8(%eax),%edx
c0100774:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100777:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010077a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077d:	8b 40 10             	mov    0x10(%eax),%eax
c0100780:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100783:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100786:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100789:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010078c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010078f:	eb 15                	jmp    c01007a6 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100791:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100794:	8b 55 08             	mov    0x8(%ebp),%edx
c0100797:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010079a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010079d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a9:	8b 40 08             	mov    0x8(%eax),%eax
c01007ac:	83 ec 08             	sub    $0x8,%esp
c01007af:	6a 3a                	push   $0x3a
c01007b1:	50                   	push   %eax
c01007b2:	e8 e1 8b 00 00       	call   c0109398 <strfind>
c01007b7:	83 c4 10             	add    $0x10,%esp
c01007ba:	89 c2                	mov    %eax,%edx
c01007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bf:	8b 40 08             	mov    0x8(%eax),%eax
c01007c2:	29 c2                	sub    %eax,%edx
c01007c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c7:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007ca:	83 ec 0c             	sub    $0xc,%esp
c01007cd:	ff 75 08             	pushl  0x8(%ebp)
c01007d0:	6a 44                	push   $0x44
c01007d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007d5:	50                   	push   %eax
c01007d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007d9:	50                   	push   %eax
c01007da:	ff 75 f4             	pushl  -0xc(%ebp)
c01007dd:	e8 ea fc ff ff       	call   c01004cc <stab_binsearch>
c01007e2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007eb:	39 c2                	cmp    %eax,%edx
c01007ed:	7f 24                	jg     c0100813 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f2:	89 c2                	mov    %eax,%edx
c01007f4:	89 d0                	mov    %edx,%eax
c01007f6:	01 c0                	add    %eax,%eax
c01007f8:	01 d0                	add    %edx,%eax
c01007fa:	c1 e0 02             	shl    $0x2,%eax
c01007fd:	89 c2                	mov    %eax,%edx
c01007ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100802:	01 d0                	add    %edx,%eax
c0100804:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100808:	0f b7 d0             	movzwl %ax,%edx
c010080b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010080e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100811:	eb 13                	jmp    c0100826 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100818:	e9 12 01 00 00       	jmp    c010092f <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100820:	83 e8 01             	sub    $0x1,%eax
c0100823:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010082c:	39 c2                	cmp    %eax,%edx
c010082e:	7c 56                	jl     c0100886 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
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
c0100849:	3c 84                	cmp    $0x84,%al
c010084b:	74 39                	je     c0100886 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100850:	89 c2                	mov    %eax,%edx
c0100852:	89 d0                	mov    %edx,%eax
c0100854:	01 c0                	add    %eax,%eax
c0100856:	01 d0                	add    %edx,%eax
c0100858:	c1 e0 02             	shl    $0x2,%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100866:	3c 64                	cmp    $0x64,%al
c0100868:	75 b3                	jne    c010081d <debuginfo_eip+0x1fa>
c010086a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086d:	89 c2                	mov    %eax,%edx
c010086f:	89 d0                	mov    %edx,%eax
c0100871:	01 c0                	add    %eax,%eax
c0100873:	01 d0                	add    %edx,%eax
c0100875:	c1 e0 02             	shl    $0x2,%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087d:	01 d0                	add    %edx,%eax
c010087f:	8b 40 08             	mov    0x8(%eax),%eax
c0100882:	85 c0                	test   %eax,%eax
c0100884:	74 97                	je     c010081d <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100886:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010088c:	39 c2                	cmp    %eax,%edx
c010088e:	7c 46                	jl     c01008d6 <debuginfo_eip+0x2b3>
c0100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100893:	89 c2                	mov    %eax,%edx
c0100895:	89 d0                	mov    %edx,%eax
c0100897:	01 c0                	add    %eax,%eax
c0100899:	01 d0                	add    %edx,%eax
c010089b:	c1 e0 02             	shl    $0x2,%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a3:	01 d0                	add    %edx,%eax
c01008a5:	8b 00                	mov    (%eax),%eax
c01008a7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008ad:	29 d1                	sub    %edx,%ecx
c01008af:	89 ca                	mov    %ecx,%edx
c01008b1:	39 d0                	cmp    %edx,%eax
c01008b3:	73 21                	jae    c01008d6 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b8:	89 c2                	mov    %eax,%edx
c01008ba:	89 d0                	mov    %edx,%eax
c01008bc:	01 c0                	add    %eax,%eax
c01008be:	01 d0                	add    %edx,%eax
c01008c0:	c1 e0 02             	shl    $0x2,%eax
c01008c3:	89 c2                	mov    %eax,%edx
c01008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c8:	01 d0                	add    %edx,%eax
c01008ca:	8b 10                	mov    (%eax),%edx
c01008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008cf:	01 c2                	add    %eax,%edx
c01008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008d4:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008dc:	39 c2                	cmp    %eax,%edx
c01008de:	7d 4a                	jge    c010092a <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008e3:	83 c0 01             	add    $0x1,%eax
c01008e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008e9:	eb 18                	jmp    c0100903 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ee:	8b 40 14             	mov    0x14(%eax),%eax
c01008f1:	8d 50 01             	lea    0x1(%eax),%edx
c01008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008fd:	83 c0 01             	add    $0x1,%eax
c0100900:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100903:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100906:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100909:	39 c2                	cmp    %eax,%edx
c010090b:	7d 1d                	jge    c010092a <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010090d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100910:	89 c2                	mov    %eax,%edx
c0100912:	89 d0                	mov    %edx,%eax
c0100914:	01 c0                	add    %eax,%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	c1 e0 02             	shl    $0x2,%eax
c010091b:	89 c2                	mov    %eax,%edx
c010091d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100920:	01 d0                	add    %edx,%eax
c0100922:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100926:	3c a0                	cmp    $0xa0,%al
c0100928:	74 c1                	je     c01008eb <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010092a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010092f:	c9                   	leave  
c0100930:	c3                   	ret    

c0100931 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100931:	55                   	push   %ebp
c0100932:	89 e5                	mov    %esp,%ebp
c0100934:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100937:	83 ec 0c             	sub    $0xc,%esp
c010093a:	68 c2 9e 10 c0       	push   $0xc0109ec2
c010093f:	e8 4e f9 ff ff       	call   c0100292 <cprintf>
c0100944:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100947:	83 ec 08             	sub    $0x8,%esp
c010094a:	68 36 00 10 c0       	push   $0xc0100036
c010094f:	68 db 9e 10 c0       	push   $0xc0109edb
c0100954:	e8 39 f9 ff ff       	call   c0100292 <cprintf>
c0100959:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010095c:	83 ec 08             	sub    $0x8,%esp
c010095f:	68 b8 9d 10 c0       	push   $0xc0109db8
c0100964:	68 f3 9e 10 c0       	push   $0xc0109ef3
c0100969:	e8 24 f9 ff ff       	call   c0100292 <cprintf>
c010096e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100971:	83 ec 08             	sub    $0x8,%esp
c0100974:	68 00 90 12 c0       	push   $0xc0129000
c0100979:	68 0b 9f 10 c0       	push   $0xc0109f0b
c010097e:	e8 0f f9 ff ff       	call   c0100292 <cprintf>
c0100983:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100986:	83 ec 08             	sub    $0x8,%esp
c0100989:	68 a4 c1 12 c0       	push   $0xc012c1a4
c010098e:	68 23 9f 10 c0       	push   $0xc0109f23
c0100993:	e8 fa f8 ff ff       	call   c0100292 <cprintf>
c0100998:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010099b:	b8 a4 c1 12 c0       	mov    $0xc012c1a4,%eax
c01009a0:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009a5:	ba 36 00 10 c0       	mov    $0xc0100036,%edx
c01009aa:	29 d0                	sub    %edx,%eax
c01009ac:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b2:	85 c0                	test   %eax,%eax
c01009b4:	0f 48 c2             	cmovs  %edx,%eax
c01009b7:	c1 f8 0a             	sar    $0xa,%eax
c01009ba:	83 ec 08             	sub    $0x8,%esp
c01009bd:	50                   	push   %eax
c01009be:	68 3c 9f 10 c0       	push   $0xc0109f3c
c01009c3:	e8 ca f8 ff ff       	call   c0100292 <cprintf>
c01009c8:	83 c4 10             	add    $0x10,%esp
}
c01009cb:	90                   	nop
c01009cc:	c9                   	leave  
c01009cd:	c3                   	ret    

c01009ce <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009ce:	55                   	push   %ebp
c01009cf:	89 e5                	mov    %esp,%ebp
c01009d1:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d7:	83 ec 08             	sub    $0x8,%esp
c01009da:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009dd:	50                   	push   %eax
c01009de:	ff 75 08             	pushl  0x8(%ebp)
c01009e1:	e8 3d fc ff ff       	call   c0100623 <debuginfo_eip>
c01009e6:	83 c4 10             	add    $0x10,%esp
c01009e9:	85 c0                	test   %eax,%eax
c01009eb:	74 15                	je     c0100a02 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ed:	83 ec 08             	sub    $0x8,%esp
c01009f0:	ff 75 08             	pushl  0x8(%ebp)
c01009f3:	68 66 9f 10 c0       	push   $0xc0109f66
c01009f8:	e8 95 f8 ff ff       	call   c0100292 <cprintf>
c01009fd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a00:	eb 65                	jmp    c0100a67 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a09:	eb 1c                	jmp    c0100a27 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a11:	01 d0                	add    %edx,%eax
c0100a13:	0f b6 00             	movzbl (%eax),%eax
c0100a16:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a1f:	01 ca                	add    %ecx,%edx
c0100a21:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a2a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a2d:	7f dc                	jg     c0100a0b <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a2f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a38:	01 d0                	add    %edx,%eax
c0100a3a:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a40:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a43:	89 d1                	mov    %edx,%ecx
c0100a45:	29 c1                	sub    %eax,%ecx
c0100a47:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a4d:	83 ec 0c             	sub    $0xc,%esp
c0100a50:	51                   	push   %ecx
c0100a51:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a57:	51                   	push   %ecx
c0100a58:	52                   	push   %edx
c0100a59:	50                   	push   %eax
c0100a5a:	68 82 9f 10 c0       	push   $0xc0109f82
c0100a5f:	e8 2e f8 ff ff       	call   c0100292 <cprintf>
c0100a64:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a67:	90                   	nop
c0100a68:	c9                   	leave  
c0100a69:	c3                   	ret    

c0100a6a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a6a:	55                   	push   %ebp
c0100a6b:	89 e5                	mov    %esp,%ebp
c0100a6d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a70:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a79:	c9                   	leave  
c0100a7a:	c3                   	ret    

c0100a7b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a7b:	55                   	push   %ebp
c0100a7c:	89 e5                	mov    %esp,%ebp
c0100a7e:	53                   	push   %ebx
c0100a7f:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a82:	89 e8                	mov    %ebp,%eax
c0100a84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
c0100a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
c0100a8d:	e8 d8 ff ff ff       	call   c0100a6a <read_eip>
c0100a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c0100a95:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a9c:	e9 93 00 00 00       	jmp    c0100b34 <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
c0100aa1:	83 ec 04             	sub    $0x4,%esp
c0100aa4:	ff 75 f0             	pushl  -0x10(%ebp)
c0100aa7:	ff 75 f4             	pushl  -0xc(%ebp)
c0100aaa:	68 94 9f 10 c0       	push   $0xc0109f94
c0100aaf:	e8 de f7 ff ff       	call   c0100292 <cprintf>
c0100ab4:	83 c4 10             	add    $0x10,%esp
        // get args
        for (int j = 0; j < 4; j++) {
c0100ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100abe:	eb 1f                	jmp    c0100adf <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
c0100ac0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ac3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100acd:	01 d0                	add    %edx,%eax
c0100acf:	83 c0 08             	add    $0x8,%eax
c0100ad2:	8b 10                	mov    (%eax),%edx
c0100ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ad7:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
        // get args
        for (int j = 0; j < 4; j++) {
c0100adb:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100adf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ae3:	7e db                	jle    c0100ac0 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
c0100ae5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c0100ae8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0100aeb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0100aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100af1:	83 ec 0c             	sub    $0xc,%esp
c0100af4:	53                   	push   %ebx
c0100af5:	51                   	push   %ecx
c0100af6:	52                   	push   %edx
c0100af7:	50                   	push   %eax
c0100af8:	68 ac 9f 10 c0       	push   $0xc0109fac
c0100afd:	e8 90 f7 ff ff       	call   c0100292 <cprintf>
c0100b02:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);
        // print function info
        print_debuginfo(stack_val_eip - 1);
c0100b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b08:	83 e8 01             	sub    $0x1,%eax
c0100b0b:	83 ec 0c             	sub    $0xc,%esp
c0100b0e:	50                   	push   %eax
c0100b0f:	e8 ba fe ff ff       	call   c01009ce <print_debuginfo>
c0100b14:	83 c4 10             	add    $0x10,%esp
        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
c0100b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b1a:	83 c0 04             	add    $0x4,%eax
c0100b1d:	8b 00                	mov    (%eax),%eax
c0100b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
c0100b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b25:	8b 00                	mov    (%eax),%eax
c0100b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // ebp should be valid
        if (stack_val_ebp <= 0) {
c0100b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b2e:	74 10                	je     c0100b40 <print_stackframe+0xc5>
    uint32_t stack_val_ebp = read_ebp();
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c0100b30:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b34:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b38:	0f 8e 63 ff ff ff    	jle    c0100aa1 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
c0100b3e:	eb 01                	jmp    c0100b41 <print_stackframe+0xc6>
        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
c0100b40:	90                   	nop
        }
    }
}
c0100b41:	90                   	nop
c0100b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100b45:	c9                   	leave  
c0100b46:	c3                   	ret    

c0100b47 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b47:	55                   	push   %ebp
c0100b48:	89 e5                	mov    %esp,%ebp
c0100b4a:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b54:	eb 0c                	jmp    c0100b62 <parse+0x1b>
            *buf ++ = '\0';
c0100b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b59:	8d 50 01             	lea    0x1(%eax),%edx
c0100b5c:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b5f:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b65:	0f b6 00             	movzbl (%eax),%eax
c0100b68:	84 c0                	test   %al,%al
c0100b6a:	74 1e                	je     c0100b8a <parse+0x43>
c0100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6f:	0f b6 00             	movzbl (%eax),%eax
c0100b72:	0f be c0             	movsbl %al,%eax
c0100b75:	83 ec 08             	sub    $0x8,%esp
c0100b78:	50                   	push   %eax
c0100b79:	68 50 a0 10 c0       	push   $0xc010a050
c0100b7e:	e8 e2 87 00 00       	call   c0109365 <strchr>
c0100b83:	83 c4 10             	add    $0x10,%esp
c0100b86:	85 c0                	test   %eax,%eax
c0100b88:	75 cc                	jne    c0100b56 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8d:	0f b6 00             	movzbl (%eax),%eax
c0100b90:	84 c0                	test   %al,%al
c0100b92:	74 69                	je     c0100bfd <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b94:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b98:	75 12                	jne    c0100bac <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b9a:	83 ec 08             	sub    $0x8,%esp
c0100b9d:	6a 10                	push   $0x10
c0100b9f:	68 55 a0 10 c0       	push   $0xc010a055
c0100ba4:	e8 e9 f6 ff ff       	call   c0100292 <cprintf>
c0100ba9:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100baf:	8d 50 01             	lea    0x1(%eax),%edx
c0100bb2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bbf:	01 c2                	add    %eax,%edx
c0100bc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc4:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bc6:	eb 04                	jmp    c0100bcc <parse+0x85>
            buf ++;
c0100bc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bcf:	0f b6 00             	movzbl (%eax),%eax
c0100bd2:	84 c0                	test   %al,%al
c0100bd4:	0f 84 7a ff ff ff    	je     c0100b54 <parse+0xd>
c0100bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdd:	0f b6 00             	movzbl (%eax),%eax
c0100be0:	0f be c0             	movsbl %al,%eax
c0100be3:	83 ec 08             	sub    $0x8,%esp
c0100be6:	50                   	push   %eax
c0100be7:	68 50 a0 10 c0       	push   $0xc010a050
c0100bec:	e8 74 87 00 00       	call   c0109365 <strchr>
c0100bf1:	83 c4 10             	add    $0x10,%esp
c0100bf4:	85 c0                	test   %eax,%eax
c0100bf6:	74 d0                	je     c0100bc8 <parse+0x81>
            buf ++;
        }
    }
c0100bf8:	e9 57 ff ff ff       	jmp    c0100b54 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bfd:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c01:	c9                   	leave  
c0100c02:	c3                   	ret    

c0100c03 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c03:	55                   	push   %ebp
c0100c04:	89 e5                	mov    %esp,%ebp
c0100c06:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c09:	83 ec 08             	sub    $0x8,%esp
c0100c0c:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c0f:	50                   	push   %eax
c0100c10:	ff 75 08             	pushl  0x8(%ebp)
c0100c13:	e8 2f ff ff ff       	call   c0100b47 <parse>
c0100c18:	83 c4 10             	add    $0x10,%esp
c0100c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c22:	75 0a                	jne    c0100c2e <runcmd+0x2b>
        return 0;
c0100c24:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c29:	e9 83 00 00 00       	jmp    c0100cb1 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c35:	eb 59                	jmp    c0100c90 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c37:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c3d:	89 d0                	mov    %edx,%eax
c0100c3f:	01 c0                	add    %eax,%eax
c0100c41:	01 d0                	add    %edx,%eax
c0100c43:	c1 e0 02             	shl    $0x2,%eax
c0100c46:	05 00 60 12 c0       	add    $0xc0126000,%eax
c0100c4b:	8b 00                	mov    (%eax),%eax
c0100c4d:	83 ec 08             	sub    $0x8,%esp
c0100c50:	51                   	push   %ecx
c0100c51:	50                   	push   %eax
c0100c52:	e8 6e 86 00 00       	call   c01092c5 <strcmp>
c0100c57:	83 c4 10             	add    $0x10,%esp
c0100c5a:	85 c0                	test   %eax,%eax
c0100c5c:	75 2e                	jne    c0100c8c <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c61:	89 d0                	mov    %edx,%eax
c0100c63:	01 c0                	add    %eax,%eax
c0100c65:	01 d0                	add    %edx,%eax
c0100c67:	c1 e0 02             	shl    $0x2,%eax
c0100c6a:	05 08 60 12 c0       	add    $0xc0126008,%eax
c0100c6f:	8b 10                	mov    (%eax),%edx
c0100c71:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c74:	83 c0 04             	add    $0x4,%eax
c0100c77:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c7a:	83 e9 01             	sub    $0x1,%ecx
c0100c7d:	83 ec 04             	sub    $0x4,%esp
c0100c80:	ff 75 0c             	pushl  0xc(%ebp)
c0100c83:	50                   	push   %eax
c0100c84:	51                   	push   %ecx
c0100c85:	ff d2                	call   *%edx
c0100c87:	83 c4 10             	add    $0x10,%esp
c0100c8a:	eb 25                	jmp    c0100cb1 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c93:	83 f8 02             	cmp    $0x2,%eax
c0100c96:	76 9f                	jbe    c0100c37 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c98:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c9b:	83 ec 08             	sub    $0x8,%esp
c0100c9e:	50                   	push   %eax
c0100c9f:	68 73 a0 10 c0       	push   $0xc010a073
c0100ca4:	e8 e9 f5 ff ff       	call   c0100292 <cprintf>
c0100ca9:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb1:	c9                   	leave  
c0100cb2:	c3                   	ret    

c0100cb3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cb9:	83 ec 0c             	sub    $0xc,%esp
c0100cbc:	68 8c a0 10 c0       	push   $0xc010a08c
c0100cc1:	e8 cc f5 ff ff       	call   c0100292 <cprintf>
c0100cc6:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100cc9:	83 ec 0c             	sub    $0xc,%esp
c0100ccc:	68 b4 a0 10 c0       	push   $0xc010a0b4
c0100cd1:	e8 bc f5 ff ff       	call   c0100292 <cprintf>
c0100cd6:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cdd:	74 0e                	je     c0100ced <kmonitor+0x3a>
        print_trapframe(tf);
c0100cdf:	83 ec 0c             	sub    $0xc,%esp
c0100ce2:	ff 75 08             	pushl  0x8(%ebp)
c0100ce5:	e8 f1 15 00 00       	call   c01022db <print_trapframe>
c0100cea:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100ced:	83 ec 0c             	sub    $0xc,%esp
c0100cf0:	68 d9 a0 10 c0       	push   $0xc010a0d9
c0100cf5:	e8 3c f6 ff ff       	call   c0100336 <readline>
c0100cfa:	83 c4 10             	add    $0x10,%esp
c0100cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d04:	74 e7                	je     c0100ced <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100d06:	83 ec 08             	sub    $0x8,%esp
c0100d09:	ff 75 08             	pushl  0x8(%ebp)
c0100d0c:	ff 75 f4             	pushl  -0xc(%ebp)
c0100d0f:	e8 ef fe ff ff       	call   c0100c03 <runcmd>
c0100d14:	83 c4 10             	add    $0x10,%esp
c0100d17:	85 c0                	test   %eax,%eax
c0100d19:	78 02                	js     c0100d1d <kmonitor+0x6a>
                break;
            }
        }
    }
c0100d1b:	eb d0                	jmp    c0100ced <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100d1d:	90                   	nop
            }
        }
    }
}
c0100d1e:	90                   	nop
c0100d1f:	c9                   	leave  
c0100d20:	c3                   	ret    

c0100d21 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d21:	55                   	push   %ebp
c0100d22:	89 e5                	mov    %esp,%ebp
c0100d24:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d2e:	eb 3c                	jmp    c0100d6c <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d30:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d33:	89 d0                	mov    %edx,%eax
c0100d35:	01 c0                	add    %eax,%eax
c0100d37:	01 d0                	add    %edx,%eax
c0100d39:	c1 e0 02             	shl    $0x2,%eax
c0100d3c:	05 04 60 12 c0       	add    $0xc0126004,%eax
c0100d41:	8b 08                	mov    (%eax),%ecx
c0100d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d46:	89 d0                	mov    %edx,%eax
c0100d48:	01 c0                	add    %eax,%eax
c0100d4a:	01 d0                	add    %edx,%eax
c0100d4c:	c1 e0 02             	shl    $0x2,%eax
c0100d4f:	05 00 60 12 c0       	add    $0xc0126000,%eax
c0100d54:	8b 00                	mov    (%eax),%eax
c0100d56:	83 ec 04             	sub    $0x4,%esp
c0100d59:	51                   	push   %ecx
c0100d5a:	50                   	push   %eax
c0100d5b:	68 dd a0 10 c0       	push   $0xc010a0dd
c0100d60:	e8 2d f5 ff ff       	call   c0100292 <cprintf>
c0100d65:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d6f:	83 f8 02             	cmp    $0x2,%eax
c0100d72:	76 bc                	jbe    c0100d30 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d79:	c9                   	leave  
c0100d7a:	c3                   	ret    

c0100d7b <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d7b:	55                   	push   %ebp
c0100d7c:	89 e5                	mov    %esp,%ebp
c0100d7e:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d81:	e8 ab fb ff ff       	call   c0100931 <print_kerninfo>
    return 0;
c0100d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d8b:	c9                   	leave  
c0100d8c:	c3                   	ret    

c0100d8d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d8d:	55                   	push   %ebp
c0100d8e:	89 e5                	mov    %esp,%ebp
c0100d90:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d93:	e8 e3 fc ff ff       	call   c0100a7b <print_stackframe>
    return 0;
c0100d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d9d:	c9                   	leave  
c0100d9e:	c3                   	ret    

c0100d9f <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100d9f:	55                   	push   %ebp
c0100da0:	89 e5                	mov    %esp,%ebp
c0100da2:	83 ec 14             	sub    $0x14,%esp
c0100da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100da8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100dac:	90                   	nop
c0100dad:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0100db1:	83 c0 07             	add    $0x7,%eax
c0100db4:	0f b7 c0             	movzwl %ax,%eax
c0100db7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100dbb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100dbf:	89 c2                	mov    %eax,%edx
c0100dc1:	ec                   	in     (%dx),%al
c0100dc2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100dc5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100dc9:	0f b6 c0             	movzbl %al,%eax
c0100dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd2:	25 80 00 00 00       	and    $0x80,%eax
c0100dd7:	85 c0                	test   %eax,%eax
c0100dd9:	75 d2                	jne    c0100dad <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100ddb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100ddf:	74 11                	je     c0100df2 <ide_wait_ready+0x53>
c0100de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100de4:	83 e0 21             	and    $0x21,%eax
c0100de7:	85 c0                	test   %eax,%eax
c0100de9:	74 07                	je     c0100df2 <ide_wait_ready+0x53>
        return -1;
c0100deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100df0:	eb 05                	jmp    c0100df7 <ide_wait_ready+0x58>
    }
    return 0;
c0100df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df7:	c9                   	leave  
c0100df8:	c3                   	ret    

c0100df9 <ide_init>:

void
ide_init(void) {
c0100df9:	55                   	push   %ebp
c0100dfa:	89 e5                	mov    %esp,%ebp
c0100dfc:	57                   	push   %edi
c0100dfd:	53                   	push   %ebx
c0100dfe:	81 ec 40 02 00 00    	sub    $0x240,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100e04:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100e0a:	e9 c1 02 00 00       	jmp    c01010d0 <ide_init+0x2d7>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100e0f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e13:	c1 e0 03             	shl    $0x3,%eax
c0100e16:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100e1d:	29 c2                	sub    %eax,%edx
c0100e1f:	89 d0                	mov    %edx,%eax
c0100e21:	05 40 94 12 c0       	add    $0xc0129440,%eax
c0100e26:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e29:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e2d:	66 d1 e8             	shr    %ax
c0100e30:	0f b7 c0             	movzwl %ax,%eax
c0100e33:	0f b7 04 85 e8 a0 10 	movzwl -0x3fef5f18(,%eax,4),%eax
c0100e3a:	c0 
c0100e3b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e3f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e43:	6a 00                	push   $0x0
c0100e45:	50                   	push   %eax
c0100e46:	e8 54 ff ff ff       	call   c0100d9f <ide_wait_ready>
c0100e4b:	83 c4 08             	add    $0x8,%esp

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e52:	83 e0 01             	and    $0x1,%eax
c0100e55:	c1 e0 04             	shl    $0x4,%eax
c0100e58:	83 c8 e0             	or     $0xffffffe0,%eax
c0100e5b:	0f b6 c0             	movzbl %al,%eax
c0100e5e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e62:	83 c2 06             	add    $0x6,%edx
c0100e65:	0f b7 d2             	movzwl %dx,%edx
c0100e68:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0100e6c:	88 45 c7             	mov    %al,-0x39(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e6f:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
c0100e73:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100e77:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e78:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e7c:	6a 00                	push   $0x0
c0100e7e:	50                   	push   %eax
c0100e7f:	e8 1b ff ff ff       	call   c0100d9f <ide_wait_ready>
c0100e84:	83 c4 08             	add    $0x8,%esp

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100e87:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e8b:	83 c0 07             	add    $0x7,%eax
c0100e8e:	0f b7 c0             	movzwl %ax,%eax
c0100e91:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
c0100e95:	c6 45 c8 ec          	movb   $0xec,-0x38(%ebp)
c0100e99:	0f b6 45 c8          	movzbl -0x38(%ebp),%eax
c0100e9d:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c0100ea1:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100ea2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ea6:	6a 00                	push   $0x0
c0100ea8:	50                   	push   %eax
c0100ea9:	e8 f1 fe ff ff       	call   c0100d9f <ide_wait_ready>
c0100eae:	83 c4 08             	add    $0x8,%esp

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100eb1:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100eb5:	83 c0 07             	add    $0x7,%eax
c0100eb8:	0f b7 c0             	movzwl %ax,%eax
c0100ebb:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ebf:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0100ec3:	89 c2                	mov    %eax,%edx
c0100ec5:	ec                   	in     (%dx),%al
c0100ec6:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0100ec9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100ecd:	84 c0                	test   %al,%al
c0100ecf:	0f 84 ef 01 00 00    	je     c01010c4 <ide_init+0x2cb>
c0100ed5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ed9:	6a 01                	push   $0x1
c0100edb:	50                   	push   %eax
c0100edc:	e8 be fe ff ff       	call   c0100d9f <ide_wait_ready>
c0100ee1:	83 c4 08             	add    $0x8,%esp
c0100ee4:	85 c0                	test   %eax,%eax
c0100ee6:	0f 85 d8 01 00 00    	jne    c01010c4 <ide_init+0x2cb>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100eec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ef0:	c1 e0 03             	shl    $0x3,%eax
c0100ef3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100efa:	29 c2                	sub    %eax,%edx
c0100efc:	89 d0                	mov    %edx,%eax
c0100efe:	05 40 94 12 c0       	add    $0xc0129440,%eax
c0100f03:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100f06:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100f0d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f13:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100f16:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0100f1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100f20:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100f23:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100f26:	89 cb                	mov    %ecx,%ebx
c0100f28:	89 df                	mov    %ebx,%edi
c0100f2a:	89 c1                	mov    %eax,%ecx
c0100f2c:	fc                   	cld    
c0100f2d:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100f2f:	89 c8                	mov    %ecx,%eax
c0100f31:	89 fb                	mov    %edi,%ebx
c0100f33:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f36:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f39:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f3f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f42:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f45:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f51:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f56:	85 c0                	test   %eax,%eax
c0100f58:	74 0e                	je     c0100f68 <ide_init+0x16f>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f5d:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100f66:	eb 09                	jmp    c0100f71 <ide_init+0x178>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100f68:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100f6b:	8b 40 78             	mov    0x78(%eax),%eax
c0100f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100f71:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f75:	c1 e0 03             	shl    $0x3,%eax
c0100f78:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f7f:	29 c2                	sub    %eax,%edx
c0100f81:	89 d0                	mov    %edx,%eax
c0100f83:	8d 90 44 94 12 c0    	lea    -0x3fed6bbc(%eax),%edx
c0100f89:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f8c:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100f8e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f92:	c1 e0 03             	shl    $0x3,%eax
c0100f95:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f9c:	29 c2                	sub    %eax,%edx
c0100f9e:	89 d0                	mov    %edx,%eax
c0100fa0:	8d 90 48 94 12 c0    	lea    -0x3fed6bb8(%eax),%edx
c0100fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100fa9:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100fae:	83 c0 62             	add    $0x62,%eax
c0100fb1:	0f b7 00             	movzwl (%eax),%eax
c0100fb4:	0f b7 c0             	movzwl %ax,%eax
c0100fb7:	25 00 02 00 00       	and    $0x200,%eax
c0100fbc:	85 c0                	test   %eax,%eax
c0100fbe:	75 16                	jne    c0100fd6 <ide_init+0x1dd>
c0100fc0:	68 f0 a0 10 c0       	push   $0xc010a0f0
c0100fc5:	68 33 a1 10 c0       	push   $0xc010a133
c0100fca:	6a 7d                	push   $0x7d
c0100fcc:	68 48 a1 10 c0       	push   $0xc010a148
c0100fd1:	e8 22 f4 ff ff       	call   c01003f8 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0100fd6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fda:	89 c2                	mov    %eax,%edx
c0100fdc:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fe3:	89 c2                	mov    %eax,%edx
c0100fe5:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fec:	29 d0                	sub    %edx,%eax
c0100fee:	05 40 94 12 c0       	add    $0xc0129440,%eax
c0100ff3:	83 c0 0c             	add    $0xc,%eax
c0100ff6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100ffc:	83 c0 36             	add    $0x36,%eax
c0100fff:	89 45 d0             	mov    %eax,-0x30(%ebp)
        unsigned int i, length = 40;
c0101002:	c7 45 cc 28 00 00 00 	movl   $0x28,-0x34(%ebp)
        for (i = 0; i < length; i += 2) {
c0101009:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101010:	eb 34                	jmp    c0101046 <ide_init+0x24d>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101012:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101015:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101018:	01 c2                	add    %eax,%edx
c010101a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010101d:	8d 48 01             	lea    0x1(%eax),%ecx
c0101020:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101023:	01 c8                	add    %ecx,%eax
c0101025:	0f b6 00             	movzbl (%eax),%eax
c0101028:	88 02                	mov    %al,(%edx)
c010102a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010102d:	8d 50 01             	lea    0x1(%eax),%edx
c0101030:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101033:	01 c2                	add    %eax,%edx
c0101035:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101038:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010103b:	01 c8                	add    %ecx,%eax
c010103d:	0f b6 00             	movzbl (%eax),%eax
c0101040:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101042:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101046:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101049:	3b 45 cc             	cmp    -0x34(%ebp),%eax
c010104c:	72 c4                	jb     c0101012 <ide_init+0x219>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c010104e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101051:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101054:	01 d0                	add    %edx,%eax
c0101056:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101059:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010105c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010105f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101062:	85 c0                	test   %eax,%eax
c0101064:	74 0f                	je     c0101075 <ide_init+0x27c>
c0101066:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101069:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010106c:	01 d0                	add    %edx,%eax
c010106e:	0f b6 00             	movzbl (%eax),%eax
c0101071:	3c 20                	cmp    $0x20,%al
c0101073:	74 d9                	je     c010104e <ide_init+0x255>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101075:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101079:	89 c2                	mov    %eax,%edx
c010107b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0101082:	89 c2                	mov    %eax,%edx
c0101084:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c010108b:	29 d0                	sub    %edx,%eax
c010108d:	05 40 94 12 c0       	add    $0xc0129440,%eax
c0101092:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101095:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101099:	c1 e0 03             	shl    $0x3,%eax
c010109c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010a3:	29 c2                	sub    %eax,%edx
c01010a5:	89 d0                	mov    %edx,%eax
c01010a7:	05 48 94 12 c0       	add    $0xc0129448,%eax
c01010ac:	8b 10                	mov    (%eax),%edx
c01010ae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010b2:	51                   	push   %ecx
c01010b3:	52                   	push   %edx
c01010b4:	50                   	push   %eax
c01010b5:	68 5a a1 10 c0       	push   $0xc010a15a
c01010ba:	e8 d3 f1 ff ff       	call   c0100292 <cprintf>
c01010bf:	83 c4 10             	add    $0x10,%esp
c01010c2:	eb 01                	jmp    c01010c5 <ide_init+0x2cc>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c01010c4:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01010c5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010c9:	83 c0 01             	add    $0x1,%eax
c01010cc:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01010d0:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01010d5:	0f 86 34 fd ff ff    	jbe    c0100e0f <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01010db:	83 ec 0c             	sub    $0xc,%esp
c01010de:	6a 0e                	push   $0xe
c01010e0:	e8 8a 0e 00 00       	call   c0101f6f <pic_enable>
c01010e5:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_IDE2);
c01010e8:	83 ec 0c             	sub    $0xc,%esp
c01010eb:	6a 0f                	push   $0xf
c01010ed:	e8 7d 0e 00 00       	call   c0101f6f <pic_enable>
c01010f2:	83 c4 10             	add    $0x10,%esp
}
c01010f5:	90                   	nop
c01010f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01010f9:	5b                   	pop    %ebx
c01010fa:	5f                   	pop    %edi
c01010fb:	5d                   	pop    %ebp
c01010fc:	c3                   	ret    

c01010fd <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c01010fd:	55                   	push   %ebp
c01010fe:	89 e5                	mov    %esp,%ebp
c0101100:	83 ec 04             	sub    $0x4,%esp
c0101103:	8b 45 08             	mov    0x8(%ebp),%eax
c0101106:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c010110a:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c010110f:	77 25                	ja     c0101136 <ide_device_valid+0x39>
c0101111:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101115:	c1 e0 03             	shl    $0x3,%eax
c0101118:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010111f:	29 c2                	sub    %eax,%edx
c0101121:	89 d0                	mov    %edx,%eax
c0101123:	05 40 94 12 c0       	add    $0xc0129440,%eax
c0101128:	0f b6 00             	movzbl (%eax),%eax
c010112b:	84 c0                	test   %al,%al
c010112d:	74 07                	je     c0101136 <ide_device_valid+0x39>
c010112f:	b8 01 00 00 00       	mov    $0x1,%eax
c0101134:	eb 05                	jmp    c010113b <ide_device_valid+0x3e>
c0101136:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010113b:	c9                   	leave  
c010113c:	c3                   	ret    

c010113d <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c010113d:	55                   	push   %ebp
c010113e:	89 e5                	mov    %esp,%ebp
c0101140:	83 ec 04             	sub    $0x4,%esp
c0101143:	8b 45 08             	mov    0x8(%ebp),%eax
c0101146:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c010114a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c010114e:	50                   	push   %eax
c010114f:	e8 a9 ff ff ff       	call   c01010fd <ide_device_valid>
c0101154:	83 c4 04             	add    $0x4,%esp
c0101157:	85 c0                	test   %eax,%eax
c0101159:	74 1b                	je     c0101176 <ide_device_size+0x39>
        return ide_devices[ideno].size;
c010115b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c010115f:	c1 e0 03             	shl    $0x3,%eax
c0101162:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101169:	29 c2                	sub    %eax,%edx
c010116b:	89 d0                	mov    %edx,%eax
c010116d:	05 48 94 12 c0       	add    $0xc0129448,%eax
c0101172:	8b 00                	mov    (%eax),%eax
c0101174:	eb 05                	jmp    c010117b <ide_device_size+0x3e>
    }
    return 0;
c0101176:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010117b:	c9                   	leave  
c010117c:	c3                   	ret    

c010117d <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c010117d:	55                   	push   %ebp
c010117e:	89 e5                	mov    %esp,%ebp
c0101180:	57                   	push   %edi
c0101181:	53                   	push   %ebx
c0101182:	83 ec 40             	sub    $0x40,%esp
c0101185:	8b 45 08             	mov    0x8(%ebp),%eax
c0101188:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c010118c:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101193:	77 25                	ja     c01011ba <ide_read_secs+0x3d>
c0101195:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c010119a:	77 1e                	ja     c01011ba <ide_read_secs+0x3d>
c010119c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011a0:	c1 e0 03             	shl    $0x3,%eax
c01011a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011aa:	29 c2                	sub    %eax,%edx
c01011ac:	89 d0                	mov    %edx,%eax
c01011ae:	05 40 94 12 c0       	add    $0xc0129440,%eax
c01011b3:	0f b6 00             	movzbl (%eax),%eax
c01011b6:	84 c0                	test   %al,%al
c01011b8:	75 19                	jne    c01011d3 <ide_read_secs+0x56>
c01011ba:	68 78 a1 10 c0       	push   $0xc010a178
c01011bf:	68 33 a1 10 c0       	push   $0xc010a133
c01011c4:	68 9f 00 00 00       	push   $0x9f
c01011c9:	68 48 a1 10 c0       	push   $0xc010a148
c01011ce:	e8 25 f2 ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011d3:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01011da:	77 0f                	ja     c01011eb <ide_read_secs+0x6e>
c01011dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01011df:	8b 45 14             	mov    0x14(%ebp),%eax
c01011e2:	01 d0                	add    %edx,%eax
c01011e4:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01011e9:	76 19                	jbe    c0101204 <ide_read_secs+0x87>
c01011eb:	68 a0 a1 10 c0       	push   $0xc010a1a0
c01011f0:	68 33 a1 10 c0       	push   $0xc010a133
c01011f5:	68 a0 00 00 00       	push   $0xa0
c01011fa:	68 48 a1 10 c0       	push   $0xc010a148
c01011ff:	e8 f4 f1 ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101204:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101208:	66 d1 e8             	shr    %ax
c010120b:	0f b7 c0             	movzwl %ax,%eax
c010120e:	0f b7 04 85 e8 a0 10 	movzwl -0x3fef5f18(,%eax,4),%eax
c0101215:	c0 
c0101216:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010121a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010121e:	66 d1 e8             	shr    %ax
c0101221:	0f b7 c0             	movzwl %ax,%eax
c0101224:	0f b7 04 85 ea a0 10 	movzwl -0x3fef5f16(,%eax,4),%eax
c010122b:	c0 
c010122c:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101230:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101234:	83 ec 08             	sub    $0x8,%esp
c0101237:	6a 00                	push   $0x0
c0101239:	50                   	push   %eax
c010123a:	e8 60 fb ff ff       	call   c0100d9f <ide_wait_ready>
c010123f:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101242:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101246:	83 c0 02             	add    $0x2,%eax
c0101249:	0f b7 c0             	movzwl %ax,%eax
c010124c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101250:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101254:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101258:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010125c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c010125d:	8b 45 14             	mov    0x14(%ebp),%eax
c0101260:	0f b6 c0             	movzbl %al,%eax
c0101263:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101267:	83 c2 02             	add    $0x2,%edx
c010126a:	0f b7 d2             	movzwl %dx,%edx
c010126d:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c0101271:	88 45 d8             	mov    %al,-0x28(%ebp)
c0101274:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101278:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010127c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c010127d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101280:	0f b6 c0             	movzbl %al,%eax
c0101283:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101287:	83 c2 03             	add    $0x3,%edx
c010128a:	0f b7 d2             	movzwl %dx,%edx
c010128d:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101291:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101294:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101298:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010129c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c010129d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012a0:	c1 e8 08             	shr    $0x8,%eax
c01012a3:	0f b6 c0             	movzbl %al,%eax
c01012a6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012aa:	83 c2 04             	add    $0x4,%edx
c01012ad:	0f b7 d2             	movzwl %dx,%edx
c01012b0:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c01012b4:	88 45 da             	mov    %al,-0x26(%ebp)
c01012b7:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c01012bb:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c01012bf:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01012c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012c3:	c1 e8 10             	shr    $0x10,%eax
c01012c6:	0f b6 c0             	movzbl %al,%eax
c01012c9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012cd:	83 c2 05             	add    $0x5,%edx
c01012d0:	0f b7 d2             	movzwl %dx,%edx
c01012d3:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01012d7:	88 45 db             	mov    %al,-0x25(%ebp)
c01012da:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01012de:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01012e2:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c01012e3:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01012e7:	83 e0 01             	and    $0x1,%eax
c01012ea:	c1 e0 04             	shl    $0x4,%eax
c01012ed:	89 c2                	mov    %eax,%edx
c01012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012f2:	c1 e8 18             	shr    $0x18,%eax
c01012f5:	83 e0 0f             	and    $0xf,%eax
c01012f8:	09 d0                	or     %edx,%eax
c01012fa:	83 c8 e0             	or     $0xffffffe0,%eax
c01012fd:	0f b6 c0             	movzbl %al,%eax
c0101300:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101304:	83 c2 06             	add    $0x6,%edx
c0101307:	0f b7 d2             	movzwl %dx,%edx
c010130a:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c010130e:	88 45 dc             	mov    %al,-0x24(%ebp)
c0101311:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0101315:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c0101319:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c010131a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010131e:	83 c0 07             	add    $0x7,%eax
c0101321:	0f b7 c0             	movzwl %ax,%eax
c0101324:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c0101328:	c6 45 dd 20          	movb   $0x20,-0x23(%ebp)
c010132c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101330:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101334:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101335:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c010133c:	eb 56                	jmp    c0101394 <ide_read_secs+0x217>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c010133e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101342:	83 ec 08             	sub    $0x8,%esp
c0101345:	6a 01                	push   $0x1
c0101347:	50                   	push   %eax
c0101348:	e8 52 fa ff ff       	call   c0100d9f <ide_wait_ready>
c010134d:	83 c4 10             	add    $0x10,%esp
c0101350:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101357:	75 43                	jne    c010139c <ide_read_secs+0x21f>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101359:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010135d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0101360:	8b 45 10             	mov    0x10(%ebp),%eax
c0101363:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101366:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010136d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101370:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0101373:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0101376:	89 cb                	mov    %ecx,%ebx
c0101378:	89 df                	mov    %ebx,%edi
c010137a:	89 c1                	mov    %eax,%ecx
c010137c:	fc                   	cld    
c010137d:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010137f:	89 c8                	mov    %ecx,%eax
c0101381:	89 fb                	mov    %edi,%ebx
c0101383:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c0101386:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101389:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c010138d:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101394:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101398:	75 a4                	jne    c010133e <ide_read_secs+0x1c1>
c010139a:	eb 01                	jmp    c010139d <ide_read_secs+0x220>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c010139c:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c010139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01013a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01013a3:	5b                   	pop    %ebx
c01013a4:	5f                   	pop    %edi
c01013a5:	5d                   	pop    %ebp
c01013a6:	c3                   	ret    

c01013a7 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c01013a7:	55                   	push   %ebp
c01013a8:	89 e5                	mov    %esp,%ebp
c01013aa:	56                   	push   %esi
c01013ab:	53                   	push   %ebx
c01013ac:	83 ec 40             	sub    $0x40,%esp
c01013af:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b2:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01013b6:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01013bd:	77 25                	ja     c01013e4 <ide_write_secs+0x3d>
c01013bf:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c01013c4:	77 1e                	ja     c01013e4 <ide_write_secs+0x3d>
c01013c6:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01013ca:	c1 e0 03             	shl    $0x3,%eax
c01013cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01013d4:	29 c2                	sub    %eax,%edx
c01013d6:	89 d0                	mov    %edx,%eax
c01013d8:	05 40 94 12 c0       	add    $0xc0129440,%eax
c01013dd:	0f b6 00             	movzbl (%eax),%eax
c01013e0:	84 c0                	test   %al,%al
c01013e2:	75 19                	jne    c01013fd <ide_write_secs+0x56>
c01013e4:	68 78 a1 10 c0       	push   $0xc010a178
c01013e9:	68 33 a1 10 c0       	push   $0xc010a133
c01013ee:	68 bc 00 00 00       	push   $0xbc
c01013f3:	68 48 a1 10 c0       	push   $0xc010a148
c01013f8:	e8 fb ef ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01013fd:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101404:	77 0f                	ja     c0101415 <ide_write_secs+0x6e>
c0101406:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101409:	8b 45 14             	mov    0x14(%ebp),%eax
c010140c:	01 d0                	add    %edx,%eax
c010140e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101413:	76 19                	jbe    c010142e <ide_write_secs+0x87>
c0101415:	68 a0 a1 10 c0       	push   $0xc010a1a0
c010141a:	68 33 a1 10 c0       	push   $0xc010a133
c010141f:	68 bd 00 00 00       	push   $0xbd
c0101424:	68 48 a1 10 c0       	push   $0xc010a148
c0101429:	e8 ca ef ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010142e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101432:	66 d1 e8             	shr    %ax
c0101435:	0f b7 c0             	movzwl %ax,%eax
c0101438:	0f b7 04 85 e8 a0 10 	movzwl -0x3fef5f18(,%eax,4),%eax
c010143f:	c0 
c0101440:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101444:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101448:	66 d1 e8             	shr    %ax
c010144b:	0f b7 c0             	movzwl %ax,%eax
c010144e:	0f b7 04 85 ea a0 10 	movzwl -0x3fef5f16(,%eax,4),%eax
c0101455:	c0 
c0101456:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c010145a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010145e:	83 ec 08             	sub    $0x8,%esp
c0101461:	6a 00                	push   $0x0
c0101463:	50                   	push   %eax
c0101464:	e8 36 f9 ff ff       	call   c0100d9f <ide_wait_ready>
c0101469:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c010146c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101470:	83 c0 02             	add    $0x2,%eax
c0101473:	0f b7 c0             	movzwl %ax,%eax
c0101476:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010147a:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010147e:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101482:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101486:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101487:	8b 45 14             	mov    0x14(%ebp),%eax
c010148a:	0f b6 c0             	movzbl %al,%eax
c010148d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101491:	83 c2 02             	add    $0x2,%edx
c0101494:	0f b7 d2             	movzwl %dx,%edx
c0101497:	66 89 55 e8          	mov    %dx,-0x18(%ebp)
c010149b:	88 45 d8             	mov    %al,-0x28(%ebp)
c010149e:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c01014a2:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01014a6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01014a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014b1:	83 c2 03             	add    $0x3,%edx
c01014b4:	0f b7 d2             	movzwl %dx,%edx
c01014b7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01014bb:	88 45 d9             	mov    %al,-0x27(%ebp)
c01014be:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01014c2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01014c6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01014c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014ca:	c1 e8 08             	shr    $0x8,%eax
c01014cd:	0f b6 c0             	movzbl %al,%eax
c01014d0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014d4:	83 c2 04             	add    $0x4,%edx
c01014d7:	0f b7 d2             	movzwl %dx,%edx
c01014da:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
c01014de:	88 45 da             	mov    %al,-0x26(%ebp)
c01014e1:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c01014e5:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c01014e9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014ed:	c1 e8 10             	shr    $0x10,%eax
c01014f0:	0f b6 c0             	movzbl %al,%eax
c01014f3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014f7:	83 c2 05             	add    $0x5,%edx
c01014fa:	0f b7 d2             	movzwl %dx,%edx
c01014fd:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101501:	88 45 db             	mov    %al,-0x25(%ebp)
c0101504:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101508:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010150c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010150d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101511:	83 e0 01             	and    $0x1,%eax
c0101514:	c1 e0 04             	shl    $0x4,%eax
c0101517:	89 c2                	mov    %eax,%edx
c0101519:	8b 45 0c             	mov    0xc(%ebp),%eax
c010151c:	c1 e8 18             	shr    $0x18,%eax
c010151f:	83 e0 0f             	and    $0xf,%eax
c0101522:	09 d0                	or     %edx,%eax
c0101524:	83 c8 e0             	or     $0xffffffe0,%eax
c0101527:	0f b6 c0             	movzbl %al,%eax
c010152a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010152e:	83 c2 06             	add    $0x6,%edx
c0101531:	0f b7 d2             	movzwl %dx,%edx
c0101534:	66 89 55 e0          	mov    %dx,-0x20(%ebp)
c0101538:	88 45 dc             	mov    %al,-0x24(%ebp)
c010153b:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c010153f:	0f b7 55 e0          	movzwl -0x20(%ebp),%edx
c0101543:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101544:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101548:	83 c0 07             	add    $0x7,%eax
c010154b:	0f b7 c0             	movzwl %ax,%eax
c010154e:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c0101552:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
c0101556:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010155a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010155e:	ee                   	out    %al,(%dx)

    int ret = 0;
c010155f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101566:	eb 56                	jmp    c01015be <ide_write_secs+0x217>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101568:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010156c:	83 ec 08             	sub    $0x8,%esp
c010156f:	6a 01                	push   $0x1
c0101571:	50                   	push   %eax
c0101572:	e8 28 f8 ff ff       	call   c0100d9f <ide_wait_ready>
c0101577:	83 c4 10             	add    $0x10,%esp
c010157a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010157d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101581:	75 43                	jne    c01015c6 <ide_write_secs+0x21f>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101583:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101587:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010158a:	8b 45 10             	mov    0x10(%ebp),%eax
c010158d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101590:	c7 45 cc 80 00 00 00 	movl   $0x80,-0x34(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101597:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010159a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010159d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01015a0:	89 cb                	mov    %ecx,%ebx
c01015a2:	89 de                	mov    %ebx,%esi
c01015a4:	89 c1                	mov    %eax,%ecx
c01015a6:	fc                   	cld    
c01015a7:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c01015a9:	89 c8                	mov    %ecx,%eax
c01015ab:	89 f3                	mov    %esi,%ebx
c01015ad:	89 5d d0             	mov    %ebx,-0x30(%ebp)
c01015b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01015b3:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c01015b7:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01015be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01015c2:	75 a4                	jne    c0101568 <ide_write_secs+0x1c1>
c01015c4:	eb 01                	jmp    c01015c7 <ide_write_secs+0x220>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c01015c6:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c01015c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01015cd:	5b                   	pop    %ebx
c01015ce:	5e                   	pop    %esi
c01015cf:	5d                   	pop    %ebp
c01015d0:	c3                   	ret    

c01015d1 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c01015d1:	55                   	push   %ebp
c01015d2:	89 e5                	mov    %esp,%ebp
c01015d4:	83 ec 18             	sub    $0x18,%esp
c01015d7:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c01015dd:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01015e5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01015e9:	ee                   	out    %al,(%dx)
c01015ea:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c01015f0:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c01015f4:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c01015f8:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01015fc:	ee                   	out    %al,(%dx)
c01015fd:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0101603:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0101607:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010160b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010160f:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0101610:	c7 05 54 c0 12 c0 00 	movl   $0x0,0xc012c054
c0101617:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c010161a:	83 ec 0c             	sub    $0xc,%esp
c010161d:	68 da a1 10 c0       	push   $0xc010a1da
c0101622:	e8 6b ec ff ff       	call   c0100292 <cprintf>
c0101627:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c010162a:	83 ec 0c             	sub    $0xc,%esp
c010162d:	6a 00                	push   $0x0
c010162f:	e8 3b 09 00 00       	call   c0101f6f <pic_enable>
c0101634:	83 c4 10             	add    $0x10,%esp
}
c0101637:	90                   	nop
c0101638:	c9                   	leave  
c0101639:	c3                   	ret    

c010163a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010163a:	55                   	push   %ebp
c010163b:	89 e5                	mov    %esp,%ebp
c010163d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0101640:	9c                   	pushf  
c0101641:	58                   	pop    %eax
c0101642:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0101645:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0101648:	25 00 02 00 00       	and    $0x200,%eax
c010164d:	85 c0                	test   %eax,%eax
c010164f:	74 0c                	je     c010165d <__intr_save+0x23>
        intr_disable();
c0101651:	e8 8a 0a 00 00       	call   c01020e0 <intr_disable>
        return 1;
c0101656:	b8 01 00 00 00       	mov    $0x1,%eax
c010165b:	eb 05                	jmp    c0101662 <__intr_save+0x28>
    }
    return 0;
c010165d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101662:	c9                   	leave  
c0101663:	c3                   	ret    

c0101664 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0101664:	55                   	push   %ebp
c0101665:	89 e5                	mov    %esp,%ebp
c0101667:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010166a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010166e:	74 05                	je     c0101675 <__intr_restore+0x11>
        intr_enable();
c0101670:	e8 64 0a 00 00       	call   c01020d9 <intr_enable>
    }
}
c0101675:	90                   	nop
c0101676:	c9                   	leave  
c0101677:	c3                   	ret    

c0101678 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0101678:	55                   	push   %ebp
c0101679:	89 e5                	mov    %esp,%ebp
c010167b:	83 ec 10             	sub    $0x10,%esp
c010167e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101684:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0101688:	89 c2                	mov    %eax,%edx
c010168a:	ec                   	in     (%dx),%al
c010168b:	88 45 f4             	mov    %al,-0xc(%ebp)
c010168e:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0101694:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101698:	89 c2                	mov    %eax,%edx
c010169a:	ec                   	in     (%dx),%al
c010169b:	88 45 f5             	mov    %al,-0xb(%ebp)
c010169e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c01016a4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016a8:	89 c2                	mov    %eax,%edx
c01016aa:	ec                   	in     (%dx),%al
c01016ab:	88 45 f6             	mov    %al,-0xa(%ebp)
c01016ae:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c01016b4:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01016b8:	89 c2                	mov    %eax,%edx
c01016ba:	ec                   	in     (%dx),%al
c01016bb:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c01016be:	90                   	nop
c01016bf:	c9                   	leave  
c01016c0:	c3                   	ret    

c01016c1 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c01016c1:	55                   	push   %ebp
c01016c2:	89 e5                	mov    %esp,%ebp
c01016c4:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c01016c7:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c01016ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016d1:	0f b7 00             	movzwl (%eax),%eax
c01016d4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c01016d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016db:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c01016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e3:	0f b7 00             	movzwl (%eax),%eax
c01016e6:	66 3d 5a a5          	cmp    $0xa55a,%ax
c01016ea:	74 12                	je     c01016fe <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c01016ec:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c01016f3:	66 c7 05 26 95 12 c0 	movw   $0x3b4,0xc0129526
c01016fa:	b4 03 
c01016fc:	eb 13                	jmp    c0101711 <cga_init+0x50>
    } else {
        *cp = was;
c01016fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101701:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101705:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0101708:	66 c7 05 26 95 12 c0 	movw   $0x3d4,0xc0129526
c010170f:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0101711:	0f b7 05 26 95 12 c0 	movzwl 0xc0129526,%eax
c0101718:	0f b7 c0             	movzwl %ax,%eax
c010171b:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c010171f:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101723:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101727:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010172b:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c010172c:	0f b7 05 26 95 12 c0 	movzwl 0xc0129526,%eax
c0101733:	83 c0 01             	add    $0x1,%eax
c0101736:	0f b7 c0             	movzwl %ax,%eax
c0101739:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010173d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101741:	89 c2                	mov    %eax,%edx
c0101743:	ec                   	in     (%dx),%al
c0101744:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101747:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010174b:	0f b6 c0             	movzbl %al,%eax
c010174e:	c1 e0 08             	shl    $0x8,%eax
c0101751:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0101754:	0f b7 05 26 95 12 c0 	movzwl 0xc0129526,%eax
c010175b:	0f b7 c0             	movzwl %ax,%eax
c010175e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0101762:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101766:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010176a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c010176f:	0f b7 05 26 95 12 c0 	movzwl 0xc0129526,%eax
c0101776:	83 c0 01             	add    $0x1,%eax
c0101779:	0f b7 c0             	movzwl %ax,%eax
c010177c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101780:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101784:	89 c2                	mov    %eax,%edx
c0101786:	ec                   	in     (%dx),%al
c0101787:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010178a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010178e:	0f b6 c0             	movzbl %al,%eax
c0101791:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0101794:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101797:	a3 20 95 12 c0       	mov    %eax,0xc0129520
    crt_pos = pos;
c010179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010179f:	66 a3 24 95 12 c0    	mov    %ax,0xc0129524
}
c01017a5:	90                   	nop
c01017a6:	c9                   	leave  
c01017a7:	c3                   	ret    

c01017a8 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c01017a8:	55                   	push   %ebp
c01017a9:	89 e5                	mov    %esp,%ebp
c01017ab:	83 ec 28             	sub    $0x28,%esp
c01017ae:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c01017b4:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017b8:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c01017bc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017c0:	ee                   	out    %al,(%dx)
c01017c1:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c01017c7:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c01017cb:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01017cf:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01017d3:	ee                   	out    %al,(%dx)
c01017d4:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c01017da:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c01017de:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017e2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017e6:	ee                   	out    %al,(%dx)
c01017e7:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c01017ed:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c01017f1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f5:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017f9:	ee                   	out    %al,(%dx)
c01017fa:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0101800:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0101804:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0101808:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010180c:	ee                   	out    %al,(%dx)
c010180d:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0101813:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0101817:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c010181b:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c010181f:	ee                   	out    %al,(%dx)
c0101820:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101826:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c010182a:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c010182e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101832:	ee                   	out    %al,(%dx)
c0101833:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101839:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c010183d:	89 c2                	mov    %eax,%edx
c010183f:	ec                   	in     (%dx),%al
c0101840:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0101843:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101847:	3c ff                	cmp    $0xff,%al
c0101849:	0f 95 c0             	setne  %al
c010184c:	0f b6 c0             	movzbl %al,%eax
c010184f:	a3 28 95 12 c0       	mov    %eax,0xc0129528
c0101854:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010185a:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c010185e:	89 c2                	mov    %eax,%edx
c0101860:	ec                   	in     (%dx),%al
c0101861:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0101864:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c010186a:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c010186e:	89 c2                	mov    %eax,%edx
c0101870:	ec                   	in     (%dx),%al
c0101871:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101874:	a1 28 95 12 c0       	mov    0xc0129528,%eax
c0101879:	85 c0                	test   %eax,%eax
c010187b:	74 0d                	je     c010188a <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c010187d:	83 ec 0c             	sub    $0xc,%esp
c0101880:	6a 04                	push   $0x4
c0101882:	e8 e8 06 00 00       	call   c0101f6f <pic_enable>
c0101887:	83 c4 10             	add    $0x10,%esp
    }
}
c010188a:	90                   	nop
c010188b:	c9                   	leave  
c010188c:	c3                   	ret    

c010188d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010188d:	55                   	push   %ebp
c010188e:	89 e5                	mov    %esp,%ebp
c0101890:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101893:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010189a:	eb 09                	jmp    c01018a5 <lpt_putc_sub+0x18>
        delay();
c010189c:	e8 d7 fd ff ff       	call   c0101678 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018a1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018a5:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c01018ab:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01018af:	89 c2                	mov    %eax,%edx
c01018b1:	ec                   	in     (%dx),%al
c01018b2:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c01018b5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01018b9:	84 c0                	test   %al,%al
c01018bb:	78 09                	js     c01018c6 <lpt_putc_sub+0x39>
c01018bd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01018c4:	7e d6                	jle    c010189c <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c01018c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01018c9:	0f b6 c0             	movzbl %al,%eax
c01018cc:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c01018d2:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d5:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c01018d9:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c01018dd:	ee                   	out    %al,(%dx)
c01018de:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01018e4:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01018e8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018ec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018f0:	ee                   	out    %al,(%dx)
c01018f1:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c01018f7:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c01018fb:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c01018ff:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101903:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101904:	90                   	nop
c0101905:	c9                   	leave  
c0101906:	c3                   	ret    

c0101907 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101907:	55                   	push   %ebp
c0101908:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c010190a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010190e:	74 0d                	je     c010191d <lpt_putc+0x16>
        lpt_putc_sub(c);
c0101910:	ff 75 08             	pushl  0x8(%ebp)
c0101913:	e8 75 ff ff ff       	call   c010188d <lpt_putc_sub>
c0101918:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010191b:	eb 1e                	jmp    c010193b <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c010191d:	6a 08                	push   $0x8
c010191f:	e8 69 ff ff ff       	call   c010188d <lpt_putc_sub>
c0101924:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c0101927:	6a 20                	push   $0x20
c0101929:	e8 5f ff ff ff       	call   c010188d <lpt_putc_sub>
c010192e:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c0101931:	6a 08                	push   $0x8
c0101933:	e8 55 ff ff ff       	call   c010188d <lpt_putc_sub>
c0101938:	83 c4 04             	add    $0x4,%esp
    }
}
c010193b:	90                   	nop
c010193c:	c9                   	leave  
c010193d:	c3                   	ret    

c010193e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010193e:	55                   	push   %ebp
c010193f:	89 e5                	mov    %esp,%ebp
c0101941:	53                   	push   %ebx
c0101942:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101945:	8b 45 08             	mov    0x8(%ebp),%eax
c0101948:	b0 00                	mov    $0x0,%al
c010194a:	85 c0                	test   %eax,%eax
c010194c:	75 07                	jne    c0101955 <cga_putc+0x17>
        c |= 0x0700;
c010194e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101955:	8b 45 08             	mov    0x8(%ebp),%eax
c0101958:	0f b6 c0             	movzbl %al,%eax
c010195b:	83 f8 0a             	cmp    $0xa,%eax
c010195e:	74 4e                	je     c01019ae <cga_putc+0x70>
c0101960:	83 f8 0d             	cmp    $0xd,%eax
c0101963:	74 59                	je     c01019be <cga_putc+0x80>
c0101965:	83 f8 08             	cmp    $0x8,%eax
c0101968:	0f 85 8a 00 00 00    	jne    c01019f8 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c010196e:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c0101975:	66 85 c0             	test   %ax,%ax
c0101978:	0f 84 a0 00 00 00    	je     c0101a1e <cga_putc+0xe0>
            crt_pos --;
c010197e:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c0101985:	83 e8 01             	sub    $0x1,%eax
c0101988:	66 a3 24 95 12 c0    	mov    %ax,0xc0129524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010198e:	a1 20 95 12 c0       	mov    0xc0129520,%eax
c0101993:	0f b7 15 24 95 12 c0 	movzwl 0xc0129524,%edx
c010199a:	0f b7 d2             	movzwl %dx,%edx
c010199d:	01 d2                	add    %edx,%edx
c010199f:	01 d0                	add    %edx,%eax
c01019a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01019a4:	b2 00                	mov    $0x0,%dl
c01019a6:	83 ca 20             	or     $0x20,%edx
c01019a9:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c01019ac:	eb 70                	jmp    c0101a1e <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c01019ae:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c01019b5:	83 c0 50             	add    $0x50,%eax
c01019b8:	66 a3 24 95 12 c0    	mov    %ax,0xc0129524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01019be:	0f b7 1d 24 95 12 c0 	movzwl 0xc0129524,%ebx
c01019c5:	0f b7 0d 24 95 12 c0 	movzwl 0xc0129524,%ecx
c01019cc:	0f b7 c1             	movzwl %cx,%eax
c01019cf:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01019d5:	c1 e8 10             	shr    $0x10,%eax
c01019d8:	89 c2                	mov    %eax,%edx
c01019da:	66 c1 ea 06          	shr    $0x6,%dx
c01019de:	89 d0                	mov    %edx,%eax
c01019e0:	c1 e0 02             	shl    $0x2,%eax
c01019e3:	01 d0                	add    %edx,%eax
c01019e5:	c1 e0 04             	shl    $0x4,%eax
c01019e8:	29 c1                	sub    %eax,%ecx
c01019ea:	89 ca                	mov    %ecx,%edx
c01019ec:	89 d8                	mov    %ebx,%eax
c01019ee:	29 d0                	sub    %edx,%eax
c01019f0:	66 a3 24 95 12 c0    	mov    %ax,0xc0129524
        break;
c01019f6:	eb 27                	jmp    c0101a1f <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01019f8:	8b 0d 20 95 12 c0    	mov    0xc0129520,%ecx
c01019fe:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c0101a05:	8d 50 01             	lea    0x1(%eax),%edx
c0101a08:	66 89 15 24 95 12 c0 	mov    %dx,0xc0129524
c0101a0f:	0f b7 c0             	movzwl %ax,%eax
c0101a12:	01 c0                	add    %eax,%eax
c0101a14:	01 c8                	add    %ecx,%eax
c0101a16:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a19:	66 89 10             	mov    %dx,(%eax)
        break;
c0101a1c:	eb 01                	jmp    c0101a1f <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101a1e:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101a1f:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c0101a26:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101a2a:	76 59                	jbe    c0101a85 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a2c:	a1 20 95 12 c0       	mov    0xc0129520,%eax
c0101a31:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101a37:	a1 20 95 12 c0       	mov    0xc0129520,%eax
c0101a3c:	83 ec 04             	sub    $0x4,%esp
c0101a3f:	68 00 0f 00 00       	push   $0xf00
c0101a44:	52                   	push   %edx
c0101a45:	50                   	push   %eax
c0101a46:	e8 19 7b 00 00       	call   c0109564 <memmove>
c0101a4b:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a4e:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101a55:	eb 15                	jmp    c0101a6c <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c0101a57:	a1 20 95 12 c0       	mov    0xc0129520,%eax
c0101a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101a5f:	01 d2                	add    %edx,%edx
c0101a61:	01 d0                	add    %edx,%eax
c0101a63:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101a6c:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101a73:	7e e2                	jle    c0101a57 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101a75:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c0101a7c:	83 e8 50             	sub    $0x50,%eax
c0101a7f:	66 a3 24 95 12 c0    	mov    %ax,0xc0129524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101a85:	0f b7 05 26 95 12 c0 	movzwl 0xc0129526,%eax
c0101a8c:	0f b7 c0             	movzwl %ax,%eax
c0101a8f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101a93:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101a97:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101a9b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101a9f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101aa0:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c0101aa7:	66 c1 e8 08          	shr    $0x8,%ax
c0101aab:	0f b6 c0             	movzbl %al,%eax
c0101aae:	0f b7 15 26 95 12 c0 	movzwl 0xc0129526,%edx
c0101ab5:	83 c2 01             	add    $0x1,%edx
c0101ab8:	0f b7 d2             	movzwl %dx,%edx
c0101abb:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101abf:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ac2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101ac6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101aca:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101acb:	0f b7 05 26 95 12 c0 	movzwl 0xc0129526,%eax
c0101ad2:	0f b7 c0             	movzwl %ax,%eax
c0101ad5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ad9:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101add:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101ae1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ae5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101ae6:	0f b7 05 24 95 12 c0 	movzwl 0xc0129524,%eax
c0101aed:	0f b6 c0             	movzbl %al,%eax
c0101af0:	0f b7 15 26 95 12 c0 	movzwl 0xc0129526,%edx
c0101af7:	83 c2 01             	add    $0x1,%edx
c0101afa:	0f b7 d2             	movzwl %dx,%edx
c0101afd:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101b01:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101b04:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101b08:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101b0c:	ee                   	out    %al,(%dx)
}
c0101b0d:	90                   	nop
c0101b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101b11:	c9                   	leave  
c0101b12:	c3                   	ret    

c0101b13 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101b13:	55                   	push   %ebp
c0101b14:	89 e5                	mov    %esp,%ebp
c0101b16:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b20:	eb 09                	jmp    c0101b2b <serial_putc_sub+0x18>
        delay();
c0101b22:	e8 51 fb ff ff       	call   c0101678 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b27:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b2b:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b31:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101b35:	89 c2                	mov    %eax,%edx
c0101b37:	ec                   	in     (%dx),%al
c0101b38:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101b3b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101b3f:	0f b6 c0             	movzbl %al,%eax
c0101b42:	83 e0 20             	and    $0x20,%eax
c0101b45:	85 c0                	test   %eax,%eax
c0101b47:	75 09                	jne    c0101b52 <serial_putc_sub+0x3f>
c0101b49:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101b50:	7e d0                	jle    c0101b22 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b55:	0f b6 c0             	movzbl %al,%eax
c0101b58:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c0101b5e:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b61:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c0101b65:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101b69:	ee                   	out    %al,(%dx)
}
c0101b6a:	90                   	nop
c0101b6b:	c9                   	leave  
c0101b6c:	c3                   	ret    

c0101b6d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101b6d:	55                   	push   %ebp
c0101b6e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101b70:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101b74:	74 0d                	je     c0101b83 <serial_putc+0x16>
        serial_putc_sub(c);
c0101b76:	ff 75 08             	pushl  0x8(%ebp)
c0101b79:	e8 95 ff ff ff       	call   c0101b13 <serial_putc_sub>
c0101b7e:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101b81:	eb 1e                	jmp    c0101ba1 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101b83:	6a 08                	push   $0x8
c0101b85:	e8 89 ff ff ff       	call   c0101b13 <serial_putc_sub>
c0101b8a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101b8d:	6a 20                	push   $0x20
c0101b8f:	e8 7f ff ff ff       	call   c0101b13 <serial_putc_sub>
c0101b94:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101b97:	6a 08                	push   $0x8
c0101b99:	e8 75 ff ff ff       	call   c0101b13 <serial_putc_sub>
c0101b9e:	83 c4 04             	add    $0x4,%esp
    }
}
c0101ba1:	90                   	nop
c0101ba2:	c9                   	leave  
c0101ba3:	c3                   	ret    

c0101ba4 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101ba4:	55                   	push   %ebp
c0101ba5:	89 e5                	mov    %esp,%ebp
c0101ba7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101baa:	eb 33                	jmp    c0101bdf <cons_intr+0x3b>
        if (c != 0) {
c0101bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101bb0:	74 2d                	je     c0101bdf <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101bb2:	a1 44 97 12 c0       	mov    0xc0129744,%eax
c0101bb7:	8d 50 01             	lea    0x1(%eax),%edx
c0101bba:	89 15 44 97 12 c0    	mov    %edx,0xc0129744
c0101bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bc3:	88 90 40 95 12 c0    	mov    %dl,-0x3fed6ac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101bc9:	a1 44 97 12 c0       	mov    0xc0129744,%eax
c0101bce:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101bd3:	75 0a                	jne    c0101bdf <cons_intr+0x3b>
                cons.wpos = 0;
c0101bd5:	c7 05 44 97 12 c0 00 	movl   $0x0,0xc0129744
c0101bdc:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be2:	ff d0                	call   *%eax
c0101be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101be7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101beb:	75 bf                	jne    c0101bac <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101bed:	90                   	nop
c0101bee:	c9                   	leave  
c0101bef:	c3                   	ret    

c0101bf0 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101bf0:	55                   	push   %ebp
c0101bf1:	89 e5                	mov    %esp,%ebp
c0101bf3:	83 ec 10             	sub    $0x10,%esp
c0101bf6:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101bfc:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101c00:	89 c2                	mov    %eax,%edx
c0101c02:	ec                   	in     (%dx),%al
c0101c03:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101c06:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101c0a:	0f b6 c0             	movzbl %al,%eax
c0101c0d:	83 e0 01             	and    $0x1,%eax
c0101c10:	85 c0                	test   %eax,%eax
c0101c12:	75 07                	jne    c0101c1b <serial_proc_data+0x2b>
        return -1;
c0101c14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c19:	eb 2a                	jmp    c0101c45 <serial_proc_data+0x55>
c0101c1b:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c21:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101c25:	89 c2                	mov    %eax,%edx
c0101c27:	ec                   	in     (%dx),%al
c0101c28:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c0101c2b:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101c2f:	0f b6 c0             	movzbl %al,%eax
c0101c32:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101c35:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101c39:	75 07                	jne    c0101c42 <serial_proc_data+0x52>
        c = '\b';
c0101c3b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101c45:	c9                   	leave  
c0101c46:	c3                   	ret    

c0101c47 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101c47:	55                   	push   %ebp
c0101c48:	89 e5                	mov    %esp,%ebp
c0101c4a:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c0101c4d:	a1 28 95 12 c0       	mov    0xc0129528,%eax
c0101c52:	85 c0                	test   %eax,%eax
c0101c54:	74 10                	je     c0101c66 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c0101c56:	83 ec 0c             	sub    $0xc,%esp
c0101c59:	68 f0 1b 10 c0       	push   $0xc0101bf0
c0101c5e:	e8 41 ff ff ff       	call   c0101ba4 <cons_intr>
c0101c63:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c66:	90                   	nop
c0101c67:	c9                   	leave  
c0101c68:	c3                   	ret    

c0101c69 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101c69:	55                   	push   %ebp
c0101c6a:	89 e5                	mov    %esp,%ebp
c0101c6c:	83 ec 18             	sub    $0x18,%esp
c0101c6f:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c75:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101c79:	89 c2                	mov    %eax,%edx
c0101c7b:	ec                   	in     (%dx),%al
c0101c7c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101c7f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101c83:	0f b6 c0             	movzbl %al,%eax
c0101c86:	83 e0 01             	and    $0x1,%eax
c0101c89:	85 c0                	test   %eax,%eax
c0101c8b:	75 0a                	jne    c0101c97 <kbd_proc_data+0x2e>
        return -1;
c0101c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c92:	e9 5d 01 00 00       	jmp    c0101df4 <kbd_proc_data+0x18b>
c0101c97:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c9d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ca1:	89 c2                	mov    %eax,%edx
c0101ca3:	ec                   	in     (%dx),%al
c0101ca4:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101ca7:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101cab:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101cae:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101cb2:	75 17                	jne    c0101ccb <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101cb4:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101cb9:	83 c8 40             	or     $0x40,%eax
c0101cbc:	a3 48 97 12 c0       	mov    %eax,0xc0129748
        return 0;
c0101cc1:	b8 00 00 00 00       	mov    $0x0,%eax
c0101cc6:	e9 29 01 00 00       	jmp    c0101df4 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101ccb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101ccf:	84 c0                	test   %al,%al
c0101cd1:	79 47                	jns    c0101d1a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101cd3:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101cd8:	83 e0 40             	and    $0x40,%eax
c0101cdb:	85 c0                	test   %eax,%eax
c0101cdd:	75 09                	jne    c0101ce8 <kbd_proc_data+0x7f>
c0101cdf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101ce3:	83 e0 7f             	and    $0x7f,%eax
c0101ce6:	eb 04                	jmp    c0101cec <kbd_proc_data+0x83>
c0101ce8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cec:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101cef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cf3:	0f b6 80 40 60 12 c0 	movzbl -0x3fed9fc0(%eax),%eax
c0101cfa:	83 c8 40             	or     $0x40,%eax
c0101cfd:	0f b6 c0             	movzbl %al,%eax
c0101d00:	f7 d0                	not    %eax
c0101d02:	89 c2                	mov    %eax,%edx
c0101d04:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101d09:	21 d0                	and    %edx,%eax
c0101d0b:	a3 48 97 12 c0       	mov    %eax,0xc0129748
        return 0;
c0101d10:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d15:	e9 da 00 00 00       	jmp    c0101df4 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c0101d1a:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101d1f:	83 e0 40             	and    $0x40,%eax
c0101d22:	85 c0                	test   %eax,%eax
c0101d24:	74 11                	je     c0101d37 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d26:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d2a:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101d2f:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d32:	a3 48 97 12 c0       	mov    %eax,0xc0129748
    }

    shift |= shiftcode[data];
c0101d37:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d3b:	0f b6 80 40 60 12 c0 	movzbl -0x3fed9fc0(%eax),%eax
c0101d42:	0f b6 d0             	movzbl %al,%edx
c0101d45:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101d4a:	09 d0                	or     %edx,%eax
c0101d4c:	a3 48 97 12 c0       	mov    %eax,0xc0129748
    shift ^= togglecode[data];
c0101d51:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d55:	0f b6 80 40 61 12 c0 	movzbl -0x3fed9ec0(%eax),%eax
c0101d5c:	0f b6 d0             	movzbl %al,%edx
c0101d5f:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101d64:	31 d0                	xor    %edx,%eax
c0101d66:	a3 48 97 12 c0       	mov    %eax,0xc0129748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101d6b:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101d70:	83 e0 03             	and    $0x3,%eax
c0101d73:	8b 14 85 40 65 12 c0 	mov    -0x3fed9ac0(,%eax,4),%edx
c0101d7a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d7e:	01 d0                	add    %edx,%eax
c0101d80:	0f b6 00             	movzbl (%eax),%eax
c0101d83:	0f b6 c0             	movzbl %al,%eax
c0101d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101d89:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101d8e:	83 e0 08             	and    $0x8,%eax
c0101d91:	85 c0                	test   %eax,%eax
c0101d93:	74 22                	je     c0101db7 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101d95:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101d99:	7e 0c                	jle    c0101da7 <kbd_proc_data+0x13e>
c0101d9b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101d9f:	7f 06                	jg     c0101da7 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101da1:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101da5:	eb 10                	jmp    c0101db7 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101da7:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101dab:	7e 0a                	jle    c0101db7 <kbd_proc_data+0x14e>
c0101dad:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101db1:	7f 04                	jg     c0101db7 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101db3:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101db7:	a1 48 97 12 c0       	mov    0xc0129748,%eax
c0101dbc:	f7 d0                	not    %eax
c0101dbe:	83 e0 06             	and    $0x6,%eax
c0101dc1:	85 c0                	test   %eax,%eax
c0101dc3:	75 2c                	jne    c0101df1 <kbd_proc_data+0x188>
c0101dc5:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101dcc:	75 23                	jne    c0101df1 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101dce:	83 ec 0c             	sub    $0xc,%esp
c0101dd1:	68 f5 a1 10 c0       	push   $0xc010a1f5
c0101dd6:	e8 b7 e4 ff ff       	call   c0100292 <cprintf>
c0101ddb:	83 c4 10             	add    $0x10,%esp
c0101dde:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101de4:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101de8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dec:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101df0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101df4:	c9                   	leave  
c0101df5:	c3                   	ret    

c0101df6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101df6:	55                   	push   %ebp
c0101df7:	89 e5                	mov    %esp,%ebp
c0101df9:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101dfc:	83 ec 0c             	sub    $0xc,%esp
c0101dff:	68 69 1c 10 c0       	push   $0xc0101c69
c0101e04:	e8 9b fd ff ff       	call   c0101ba4 <cons_intr>
c0101e09:	83 c4 10             	add    $0x10,%esp
}
c0101e0c:	90                   	nop
c0101e0d:	c9                   	leave  
c0101e0e:	c3                   	ret    

c0101e0f <kbd_init>:

static void
kbd_init(void) {
c0101e0f:	55                   	push   %ebp
c0101e10:	89 e5                	mov    %esp,%ebp
c0101e12:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101e15:	e8 dc ff ff ff       	call   c0101df6 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101e1a:	83 ec 0c             	sub    $0xc,%esp
c0101e1d:	6a 01                	push   $0x1
c0101e1f:	e8 4b 01 00 00       	call   c0101f6f <pic_enable>
c0101e24:	83 c4 10             	add    $0x10,%esp
}
c0101e27:	90                   	nop
c0101e28:	c9                   	leave  
c0101e29:	c3                   	ret    

c0101e2a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101e2a:	55                   	push   %ebp
c0101e2b:	89 e5                	mov    %esp,%ebp
c0101e2d:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c0101e30:	e8 8c f8 ff ff       	call   c01016c1 <cga_init>
    serial_init();
c0101e35:	e8 6e f9 ff ff       	call   c01017a8 <serial_init>
    kbd_init();
c0101e3a:	e8 d0 ff ff ff       	call   c0101e0f <kbd_init>
    if (!serial_exists) {
c0101e3f:	a1 28 95 12 c0       	mov    0xc0129528,%eax
c0101e44:	85 c0                	test   %eax,%eax
c0101e46:	75 10                	jne    c0101e58 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c0101e48:	83 ec 0c             	sub    $0xc,%esp
c0101e4b:	68 01 a2 10 c0       	push   $0xc010a201
c0101e50:	e8 3d e4 ff ff       	call   c0100292 <cprintf>
c0101e55:	83 c4 10             	add    $0x10,%esp
    }
}
c0101e58:	90                   	nop
c0101e59:	c9                   	leave  
c0101e5a:	c3                   	ret    

c0101e5b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101e5b:	55                   	push   %ebp
c0101e5c:	89 e5                	mov    %esp,%ebp
c0101e5e:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e61:	e8 d4 f7 ff ff       	call   c010163a <__intr_save>
c0101e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101e69:	83 ec 0c             	sub    $0xc,%esp
c0101e6c:	ff 75 08             	pushl  0x8(%ebp)
c0101e6f:	e8 93 fa ff ff       	call   c0101907 <lpt_putc>
c0101e74:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c0101e77:	83 ec 0c             	sub    $0xc,%esp
c0101e7a:	ff 75 08             	pushl  0x8(%ebp)
c0101e7d:	e8 bc fa ff ff       	call   c010193e <cga_putc>
c0101e82:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101e85:	83 ec 0c             	sub    $0xc,%esp
c0101e88:	ff 75 08             	pushl  0x8(%ebp)
c0101e8b:	e8 dd fc ff ff       	call   c0101b6d <serial_putc>
c0101e90:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101e93:	83 ec 0c             	sub    $0xc,%esp
c0101e96:	ff 75 f4             	pushl  -0xc(%ebp)
c0101e99:	e8 c6 f7 ff ff       	call   c0101664 <__intr_restore>
c0101e9e:	83 c4 10             	add    $0x10,%esp
}
c0101ea1:	90                   	nop
c0101ea2:	c9                   	leave  
c0101ea3:	c3                   	ret    

c0101ea4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101ea4:	55                   	push   %ebp
c0101ea5:	89 e5                	mov    %esp,%ebp
c0101ea7:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101eb1:	e8 84 f7 ff ff       	call   c010163a <__intr_save>
c0101eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101eb9:	e8 89 fd ff ff       	call   c0101c47 <serial_intr>
        kbd_intr();
c0101ebe:	e8 33 ff ff ff       	call   c0101df6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101ec3:	8b 15 40 97 12 c0    	mov    0xc0129740,%edx
c0101ec9:	a1 44 97 12 c0       	mov    0xc0129744,%eax
c0101ece:	39 c2                	cmp    %eax,%edx
c0101ed0:	74 31                	je     c0101f03 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101ed2:	a1 40 97 12 c0       	mov    0xc0129740,%eax
c0101ed7:	8d 50 01             	lea    0x1(%eax),%edx
c0101eda:	89 15 40 97 12 c0    	mov    %edx,0xc0129740
c0101ee0:	0f b6 80 40 95 12 c0 	movzbl -0x3fed6ac0(%eax),%eax
c0101ee7:	0f b6 c0             	movzbl %al,%eax
c0101eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101eed:	a1 40 97 12 c0       	mov    0xc0129740,%eax
c0101ef2:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101ef7:	75 0a                	jne    c0101f03 <cons_getc+0x5f>
                cons.rpos = 0;
c0101ef9:	c7 05 40 97 12 c0 00 	movl   $0x0,0xc0129740
c0101f00:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101f03:	83 ec 0c             	sub    $0xc,%esp
c0101f06:	ff 75 f0             	pushl  -0x10(%ebp)
c0101f09:	e8 56 f7 ff ff       	call   c0101664 <__intr_restore>
c0101f0e:	83 c4 10             	add    $0x10,%esp
    return c;
c0101f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f14:	c9                   	leave  
c0101f15:	c3                   	ret    

c0101f16 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f16:	55                   	push   %ebp
c0101f17:	89 e5                	mov    %esp,%ebp
c0101f19:	83 ec 14             	sub    $0x14,%esp
c0101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f1f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f23:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f27:	66 a3 50 65 12 c0    	mov    %ax,0xc0126550
    if (did_init) {
c0101f2d:	a1 4c 97 12 c0       	mov    0xc012974c,%eax
c0101f32:	85 c0                	test   %eax,%eax
c0101f34:	74 36                	je     c0101f6c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f36:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f3a:	0f b6 c0             	movzbl %al,%eax
c0101f3d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f43:	88 45 fa             	mov    %al,-0x6(%ebp)
c0101f46:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c0101f4a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f4e:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f4f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f53:	66 c1 e8 08          	shr    $0x8,%ax
c0101f57:	0f b6 c0             	movzbl %al,%eax
c0101f5a:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101f60:	88 45 fb             	mov    %al,-0x5(%ebp)
c0101f63:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101f67:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101f6b:	ee                   	out    %al,(%dx)
    }
}
c0101f6c:	90                   	nop
c0101f6d:	c9                   	leave  
c0101f6e:	c3                   	ret    

c0101f6f <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f6f:	55                   	push   %ebp
c0101f70:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f75:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f7a:	89 c1                	mov    %eax,%ecx
c0101f7c:	d3 e2                	shl    %cl,%edx
c0101f7e:	89 d0                	mov    %edx,%eax
c0101f80:	f7 d0                	not    %eax
c0101f82:	89 c2                	mov    %eax,%edx
c0101f84:	0f b7 05 50 65 12 c0 	movzwl 0xc0126550,%eax
c0101f8b:	21 d0                	and    %edx,%eax
c0101f8d:	0f b7 c0             	movzwl %ax,%eax
c0101f90:	50                   	push   %eax
c0101f91:	e8 80 ff ff ff       	call   c0101f16 <pic_setmask>
c0101f96:	83 c4 04             	add    $0x4,%esp
}
c0101f99:	90                   	nop
c0101f9a:	c9                   	leave  
c0101f9b:	c3                   	ret    

c0101f9c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101f9c:	55                   	push   %ebp
c0101f9d:	89 e5                	mov    %esp,%ebp
c0101f9f:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101fa2:	c7 05 4c 97 12 c0 01 	movl   $0x1,0xc012974c
c0101fa9:	00 00 00 
c0101fac:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fb2:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0101fb6:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101fba:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fbe:	ee                   	out    %al,(%dx)
c0101fbf:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101fc5:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0101fc9:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101fcd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101fd1:	ee                   	out    %al,(%dx)
c0101fd2:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0101fd8:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101fdc:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101fe0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fe4:	ee                   	out    %al,(%dx)
c0101fe5:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0101feb:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101fef:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101ff3:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101ff7:	ee                   	out    %al,(%dx)
c0101ff8:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0101ffe:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0102002:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0102006:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010200a:	ee                   	out    %al,(%dx)
c010200b:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0102011:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0102015:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0102019:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c010201d:	ee                   	out    %al,(%dx)
c010201e:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c0102024:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c0102028:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c010202c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102030:	ee                   	out    %al,(%dx)
c0102031:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c0102037:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c010203b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010203f:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0102043:	ee                   	out    %al,(%dx)
c0102044:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010204a:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c010204e:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0102052:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102056:	ee                   	out    %al,(%dx)
c0102057:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c010205d:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c0102061:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0102065:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0102069:	ee                   	out    %al,(%dx)
c010206a:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c0102070:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c0102074:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0102078:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010207c:	ee                   	out    %al,(%dx)
c010207d:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0102083:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c0102087:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010208b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010208f:	ee                   	out    %al,(%dx)
c0102090:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102096:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c010209a:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c010209e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01020a2:	ee                   	out    %al,(%dx)
c01020a3:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c01020a9:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c01020ad:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01020b1:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c01020b5:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020b6:	0f b7 05 50 65 12 c0 	movzwl 0xc0126550,%eax
c01020bd:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020c1:	74 13                	je     c01020d6 <pic_init+0x13a>
        pic_setmask(irq_mask);
c01020c3:	0f b7 05 50 65 12 c0 	movzwl 0xc0126550,%eax
c01020ca:	0f b7 c0             	movzwl %ax,%eax
c01020cd:	50                   	push   %eax
c01020ce:	e8 43 fe ff ff       	call   c0101f16 <pic_setmask>
c01020d3:	83 c4 04             	add    $0x4,%esp
    }
}
c01020d6:	90                   	nop
c01020d7:	c9                   	leave  
c01020d8:	c3                   	ret    

c01020d9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01020d9:	55                   	push   %ebp
c01020da:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01020dc:	fb                   	sti    
    sti();
}
c01020dd:	90                   	nop
c01020de:	5d                   	pop    %ebp
c01020df:	c3                   	ret    

c01020e0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01020e0:	55                   	push   %ebp
c01020e1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01020e3:	fa                   	cli    
    cli();
}
c01020e4:	90                   	nop
c01020e5:	5d                   	pop    %ebp
c01020e6:	c3                   	ret    

c01020e7 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020e7:	55                   	push   %ebp
c01020e8:	89 e5                	mov    %esp,%ebp
c01020ea:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020ed:	83 ec 08             	sub    $0x8,%esp
c01020f0:	6a 64                	push   $0x64
c01020f2:	68 20 a2 10 c0       	push   $0xc010a220
c01020f7:	e8 96 e1 ff ff       	call   c0100292 <cprintf>
c01020fc:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01020ff:	83 ec 0c             	sub    $0xc,%esp
c0102102:	68 2a a2 10 c0       	push   $0xc010a22a
c0102107:	e8 86 e1 ff ff       	call   c0100292 <cprintf>
c010210c:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c010210f:	83 ec 04             	sub    $0x4,%esp
c0102112:	68 38 a2 10 c0       	push   $0xc010a238
c0102117:	6a 14                	push   $0x14
c0102119:	68 4e a2 10 c0       	push   $0xc010a24e
c010211e:	e8 d5 e2 ff ff       	call   c01003f8 <__panic>

c0102123 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102123:	55                   	push   %ebp
c0102124:	89 e5                	mov    %esp,%ebp
c0102126:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c0102129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102130:	e9 c3 00 00 00       	jmp    c01021f8 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102135:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102138:	8b 04 85 e0 65 12 c0 	mov    -0x3fed9a20(,%eax,4),%eax
c010213f:	89 c2                	mov    %eax,%edx
c0102141:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102144:	66 89 14 c5 60 97 12 	mov    %dx,-0x3fed68a0(,%eax,8)
c010214b:	c0 
c010214c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010214f:	66 c7 04 c5 62 97 12 	movw   $0x8,-0x3fed689e(,%eax,8)
c0102156:	c0 08 00 
c0102159:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215c:	0f b6 14 c5 64 97 12 	movzbl -0x3fed689c(,%eax,8),%edx
c0102163:	c0 
c0102164:	83 e2 e0             	and    $0xffffffe0,%edx
c0102167:	88 14 c5 64 97 12 c0 	mov    %dl,-0x3fed689c(,%eax,8)
c010216e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102171:	0f b6 14 c5 64 97 12 	movzbl -0x3fed689c(,%eax,8),%edx
c0102178:	c0 
c0102179:	83 e2 1f             	and    $0x1f,%edx
c010217c:	88 14 c5 64 97 12 c0 	mov    %dl,-0x3fed689c(,%eax,8)
c0102183:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102186:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c010218d:	c0 
c010218e:	83 e2 f0             	and    $0xfffffff0,%edx
c0102191:	83 ca 0e             	or     $0xe,%edx
c0102194:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c010219b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010219e:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c01021a5:	c0 
c01021a6:	83 e2 ef             	and    $0xffffffef,%edx
c01021a9:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c01021b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b3:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c01021ba:	c0 
c01021bb:	83 e2 9f             	and    $0xffffff9f,%edx
c01021be:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c01021c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021c8:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c01021cf:	c0 
c01021d0:	83 ca 80             	or     $0xffffff80,%edx
c01021d3:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c01021da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021dd:	8b 04 85 e0 65 12 c0 	mov    -0x3fed9a20(,%eax,4),%eax
c01021e4:	c1 e8 10             	shr    $0x10,%eax
c01021e7:	89 c2                	mov    %eax,%edx
c01021e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ec:	66 89 14 c5 66 97 12 	mov    %dx,-0x3fed689a(,%eax,8)
c01021f3:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c01021f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021f8:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01021ff:	0f 8e 30 ff ff ff    	jle    c0102135 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0102205:	a1 c4 67 12 c0       	mov    0xc01267c4,%eax
c010220a:	66 a3 28 9b 12 c0    	mov    %ax,0xc0129b28
c0102210:	66 c7 05 2a 9b 12 c0 	movw   $0x8,0xc0129b2a
c0102217:	08 00 
c0102219:	0f b6 05 2c 9b 12 c0 	movzbl 0xc0129b2c,%eax
c0102220:	83 e0 e0             	and    $0xffffffe0,%eax
c0102223:	a2 2c 9b 12 c0       	mov    %al,0xc0129b2c
c0102228:	0f b6 05 2c 9b 12 c0 	movzbl 0xc0129b2c,%eax
c010222f:	83 e0 1f             	and    $0x1f,%eax
c0102232:	a2 2c 9b 12 c0       	mov    %al,0xc0129b2c
c0102237:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c010223e:	83 e0 f0             	and    $0xfffffff0,%eax
c0102241:	83 c8 0e             	or     $0xe,%eax
c0102244:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102249:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c0102250:	83 e0 ef             	and    $0xffffffef,%eax
c0102253:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102258:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c010225f:	83 c8 60             	or     $0x60,%eax
c0102262:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102267:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c010226e:	83 c8 80             	or     $0xffffff80,%eax
c0102271:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102276:	a1 c4 67 12 c0       	mov    0xc01267c4,%eax
c010227b:	c1 e8 10             	shr    $0x10,%eax
c010227e:	66 a3 2e 9b 12 c0    	mov    %ax,0xc0129b2e
c0102284:	c7 45 f8 60 65 12 c0 	movl   $0xc0126560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010228b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010228e:	0f 01 18             	lidtl  (%eax)
    // 3. LIDT
    lidt(&idt_pd);
}
c0102291:	90                   	nop
c0102292:	c9                   	leave  
c0102293:	c3                   	ret    

c0102294 <trapname>:

static const char *
trapname(int trapno) {
c0102294:	55                   	push   %ebp
c0102295:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102297:	8b 45 08             	mov    0x8(%ebp),%eax
c010229a:	83 f8 13             	cmp    $0x13,%eax
c010229d:	77 0c                	ja     c01022ab <trapname+0x17>
        return excnames[trapno];
c010229f:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a2:	8b 04 85 00 a6 10 c0 	mov    -0x3fef5a00(,%eax,4),%eax
c01022a9:	eb 18                	jmp    c01022c3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022ab:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022af:	7e 0d                	jle    c01022be <trapname+0x2a>
c01022b1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022b5:	7f 07                	jg     c01022be <trapname+0x2a>
        return "Hardware Interrupt";
c01022b7:	b8 5f a2 10 c0       	mov    $0xc010a25f,%eax
c01022bc:	eb 05                	jmp    c01022c3 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022be:	b8 72 a2 10 c0       	mov    $0xc010a272,%eax
}
c01022c3:	5d                   	pop    %ebp
c01022c4:	c3                   	ret    

c01022c5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022c5:	55                   	push   %ebp
c01022c6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022cb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022cf:	66 83 f8 08          	cmp    $0x8,%ax
c01022d3:	0f 94 c0             	sete   %al
c01022d6:	0f b6 c0             	movzbl %al,%eax
}
c01022d9:	5d                   	pop    %ebp
c01022da:	c3                   	ret    

c01022db <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022db:	55                   	push   %ebp
c01022dc:	89 e5                	mov    %esp,%ebp
c01022de:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c01022e1:	83 ec 08             	sub    $0x8,%esp
c01022e4:	ff 75 08             	pushl  0x8(%ebp)
c01022e7:	68 b3 a2 10 c0       	push   $0xc010a2b3
c01022ec:	e8 a1 df ff ff       	call   c0100292 <cprintf>
c01022f1:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c01022f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f7:	83 ec 0c             	sub    $0xc,%esp
c01022fa:	50                   	push   %eax
c01022fb:	e8 b8 01 00 00       	call   c01024b8 <print_regs>
c0102300:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102303:	8b 45 08             	mov    0x8(%ebp),%eax
c0102306:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010230a:	0f b7 c0             	movzwl %ax,%eax
c010230d:	83 ec 08             	sub    $0x8,%esp
c0102310:	50                   	push   %eax
c0102311:	68 c4 a2 10 c0       	push   $0xc010a2c4
c0102316:	e8 77 df ff ff       	call   c0100292 <cprintf>
c010231b:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010231e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102321:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102325:	0f b7 c0             	movzwl %ax,%eax
c0102328:	83 ec 08             	sub    $0x8,%esp
c010232b:	50                   	push   %eax
c010232c:	68 d7 a2 10 c0       	push   $0xc010a2d7
c0102331:	e8 5c df ff ff       	call   c0100292 <cprintf>
c0102336:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102339:	8b 45 08             	mov    0x8(%ebp),%eax
c010233c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102340:	0f b7 c0             	movzwl %ax,%eax
c0102343:	83 ec 08             	sub    $0x8,%esp
c0102346:	50                   	push   %eax
c0102347:	68 ea a2 10 c0       	push   $0xc010a2ea
c010234c:	e8 41 df ff ff       	call   c0100292 <cprintf>
c0102351:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102354:	8b 45 08             	mov    0x8(%ebp),%eax
c0102357:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010235b:	0f b7 c0             	movzwl %ax,%eax
c010235e:	83 ec 08             	sub    $0x8,%esp
c0102361:	50                   	push   %eax
c0102362:	68 fd a2 10 c0       	push   $0xc010a2fd
c0102367:	e8 26 df ff ff       	call   c0100292 <cprintf>
c010236c:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010236f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102372:	8b 40 30             	mov    0x30(%eax),%eax
c0102375:	83 ec 0c             	sub    $0xc,%esp
c0102378:	50                   	push   %eax
c0102379:	e8 16 ff ff ff       	call   c0102294 <trapname>
c010237e:	83 c4 10             	add    $0x10,%esp
c0102381:	89 c2                	mov    %eax,%edx
c0102383:	8b 45 08             	mov    0x8(%ebp),%eax
c0102386:	8b 40 30             	mov    0x30(%eax),%eax
c0102389:	83 ec 04             	sub    $0x4,%esp
c010238c:	52                   	push   %edx
c010238d:	50                   	push   %eax
c010238e:	68 10 a3 10 c0       	push   $0xc010a310
c0102393:	e8 fa de ff ff       	call   c0100292 <cprintf>
c0102398:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c010239b:	8b 45 08             	mov    0x8(%ebp),%eax
c010239e:	8b 40 34             	mov    0x34(%eax),%eax
c01023a1:	83 ec 08             	sub    $0x8,%esp
c01023a4:	50                   	push   %eax
c01023a5:	68 22 a3 10 c0       	push   $0xc010a322
c01023aa:	e8 e3 de ff ff       	call   c0100292 <cprintf>
c01023af:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b5:	8b 40 38             	mov    0x38(%eax),%eax
c01023b8:	83 ec 08             	sub    $0x8,%esp
c01023bb:	50                   	push   %eax
c01023bc:	68 31 a3 10 c0       	push   $0xc010a331
c01023c1:	e8 cc de ff ff       	call   c0100292 <cprintf>
c01023c6:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023d0:	0f b7 c0             	movzwl %ax,%eax
c01023d3:	83 ec 08             	sub    $0x8,%esp
c01023d6:	50                   	push   %eax
c01023d7:	68 40 a3 10 c0       	push   $0xc010a340
c01023dc:	e8 b1 de ff ff       	call   c0100292 <cprintf>
c01023e1:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e7:	8b 40 40             	mov    0x40(%eax),%eax
c01023ea:	83 ec 08             	sub    $0x8,%esp
c01023ed:	50                   	push   %eax
c01023ee:	68 53 a3 10 c0       	push   $0xc010a353
c01023f3:	e8 9a de ff ff       	call   c0100292 <cprintf>
c01023f8:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102402:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102409:	eb 3f                	jmp    c010244a <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c010240b:	8b 45 08             	mov    0x8(%ebp),%eax
c010240e:	8b 50 40             	mov    0x40(%eax),%edx
c0102411:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102414:	21 d0                	and    %edx,%eax
c0102416:	85 c0                	test   %eax,%eax
c0102418:	74 29                	je     c0102443 <print_trapframe+0x168>
c010241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010241d:	8b 04 85 80 65 12 c0 	mov    -0x3fed9a80(,%eax,4),%eax
c0102424:	85 c0                	test   %eax,%eax
c0102426:	74 1b                	je     c0102443 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0102428:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010242b:	8b 04 85 80 65 12 c0 	mov    -0x3fed9a80(,%eax,4),%eax
c0102432:	83 ec 08             	sub    $0x8,%esp
c0102435:	50                   	push   %eax
c0102436:	68 62 a3 10 c0       	push   $0xc010a362
c010243b:	e8 52 de ff ff       	call   c0100292 <cprintf>
c0102440:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102443:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102447:	d1 65 f0             	shll   -0x10(%ebp)
c010244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010244d:	83 f8 17             	cmp    $0x17,%eax
c0102450:	76 b9                	jbe    c010240b <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102452:	8b 45 08             	mov    0x8(%ebp),%eax
c0102455:	8b 40 40             	mov    0x40(%eax),%eax
c0102458:	25 00 30 00 00       	and    $0x3000,%eax
c010245d:	c1 e8 0c             	shr    $0xc,%eax
c0102460:	83 ec 08             	sub    $0x8,%esp
c0102463:	50                   	push   %eax
c0102464:	68 66 a3 10 c0       	push   $0xc010a366
c0102469:	e8 24 de ff ff       	call   c0100292 <cprintf>
c010246e:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0102471:	83 ec 0c             	sub    $0xc,%esp
c0102474:	ff 75 08             	pushl  0x8(%ebp)
c0102477:	e8 49 fe ff ff       	call   c01022c5 <trap_in_kernel>
c010247c:	83 c4 10             	add    $0x10,%esp
c010247f:	85 c0                	test   %eax,%eax
c0102481:	75 32                	jne    c01024b5 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102483:	8b 45 08             	mov    0x8(%ebp),%eax
c0102486:	8b 40 44             	mov    0x44(%eax),%eax
c0102489:	83 ec 08             	sub    $0x8,%esp
c010248c:	50                   	push   %eax
c010248d:	68 6f a3 10 c0       	push   $0xc010a36f
c0102492:	e8 fb dd ff ff       	call   c0100292 <cprintf>
c0102497:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010249a:	8b 45 08             	mov    0x8(%ebp),%eax
c010249d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024a1:	0f b7 c0             	movzwl %ax,%eax
c01024a4:	83 ec 08             	sub    $0x8,%esp
c01024a7:	50                   	push   %eax
c01024a8:	68 7e a3 10 c0       	push   $0xc010a37e
c01024ad:	e8 e0 dd ff ff       	call   c0100292 <cprintf>
c01024b2:	83 c4 10             	add    $0x10,%esp
    }
}
c01024b5:	90                   	nop
c01024b6:	c9                   	leave  
c01024b7:	c3                   	ret    

c01024b8 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024b8:	55                   	push   %ebp
c01024b9:	89 e5                	mov    %esp,%ebp
c01024bb:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024be:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c1:	8b 00                	mov    (%eax),%eax
c01024c3:	83 ec 08             	sub    $0x8,%esp
c01024c6:	50                   	push   %eax
c01024c7:	68 91 a3 10 c0       	push   $0xc010a391
c01024cc:	e8 c1 dd ff ff       	call   c0100292 <cprintf>
c01024d1:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d7:	8b 40 04             	mov    0x4(%eax),%eax
c01024da:	83 ec 08             	sub    $0x8,%esp
c01024dd:	50                   	push   %eax
c01024de:	68 a0 a3 10 c0       	push   $0xc010a3a0
c01024e3:	e8 aa dd ff ff       	call   c0100292 <cprintf>
c01024e8:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ee:	8b 40 08             	mov    0x8(%eax),%eax
c01024f1:	83 ec 08             	sub    $0x8,%esp
c01024f4:	50                   	push   %eax
c01024f5:	68 af a3 10 c0       	push   $0xc010a3af
c01024fa:	e8 93 dd ff ff       	call   c0100292 <cprintf>
c01024ff:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102502:	8b 45 08             	mov    0x8(%ebp),%eax
c0102505:	8b 40 0c             	mov    0xc(%eax),%eax
c0102508:	83 ec 08             	sub    $0x8,%esp
c010250b:	50                   	push   %eax
c010250c:	68 be a3 10 c0       	push   $0xc010a3be
c0102511:	e8 7c dd ff ff       	call   c0100292 <cprintf>
c0102516:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102519:	8b 45 08             	mov    0x8(%ebp),%eax
c010251c:	8b 40 10             	mov    0x10(%eax),%eax
c010251f:	83 ec 08             	sub    $0x8,%esp
c0102522:	50                   	push   %eax
c0102523:	68 cd a3 10 c0       	push   $0xc010a3cd
c0102528:	e8 65 dd ff ff       	call   c0100292 <cprintf>
c010252d:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102530:	8b 45 08             	mov    0x8(%ebp),%eax
c0102533:	8b 40 14             	mov    0x14(%eax),%eax
c0102536:	83 ec 08             	sub    $0x8,%esp
c0102539:	50                   	push   %eax
c010253a:	68 dc a3 10 c0       	push   $0xc010a3dc
c010253f:	e8 4e dd ff ff       	call   c0100292 <cprintf>
c0102544:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102547:	8b 45 08             	mov    0x8(%ebp),%eax
c010254a:	8b 40 18             	mov    0x18(%eax),%eax
c010254d:	83 ec 08             	sub    $0x8,%esp
c0102550:	50                   	push   %eax
c0102551:	68 eb a3 10 c0       	push   $0xc010a3eb
c0102556:	e8 37 dd ff ff       	call   c0100292 <cprintf>
c010255b:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010255e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102561:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102564:	83 ec 08             	sub    $0x8,%esp
c0102567:	50                   	push   %eax
c0102568:	68 fa a3 10 c0       	push   $0xc010a3fa
c010256d:	e8 20 dd ff ff       	call   c0100292 <cprintf>
c0102572:	83 c4 10             	add    $0x10,%esp
}
c0102575:	90                   	nop
c0102576:	c9                   	leave  
c0102577:	c3                   	ret    

c0102578 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102578:	55                   	push   %ebp
c0102579:	89 e5                	mov    %esp,%ebp
c010257b:	53                   	push   %ebx
c010257c:	83 ec 14             	sub    $0x14,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010257f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102582:	8b 40 34             	mov    0x34(%eax),%eax
c0102585:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102588:	85 c0                	test   %eax,%eax
c010258a:	74 07                	je     c0102593 <print_pgfault+0x1b>
c010258c:	bb 09 a4 10 c0       	mov    $0xc010a409,%ebx
c0102591:	eb 05                	jmp    c0102598 <print_pgfault+0x20>
c0102593:	bb 1a a4 10 c0       	mov    $0xc010a41a,%ebx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102598:	8b 45 08             	mov    0x8(%ebp),%eax
c010259b:	8b 40 34             	mov    0x34(%eax),%eax
c010259e:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025a1:	85 c0                	test   %eax,%eax
c01025a3:	74 07                	je     c01025ac <print_pgfault+0x34>
c01025a5:	b9 57 00 00 00       	mov    $0x57,%ecx
c01025aa:	eb 05                	jmp    c01025b1 <print_pgfault+0x39>
c01025ac:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025b4:	8b 40 34             	mov    0x34(%eax),%eax
c01025b7:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025ba:	85 c0                	test   %eax,%eax
c01025bc:	74 07                	je     c01025c5 <print_pgfault+0x4d>
c01025be:	ba 55 00 00 00       	mov    $0x55,%edx
c01025c3:	eb 05                	jmp    c01025ca <print_pgfault+0x52>
c01025c5:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025ca:	0f 20 d0             	mov    %cr2,%eax
c01025cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025d3:	83 ec 0c             	sub    $0xc,%esp
c01025d6:	53                   	push   %ebx
c01025d7:	51                   	push   %ecx
c01025d8:	52                   	push   %edx
c01025d9:	50                   	push   %eax
c01025da:	68 28 a4 10 c0       	push   $0xc010a428
c01025df:	e8 ae dc ff ff       	call   c0100292 <cprintf>
c01025e4:	83 c4 20             	add    $0x20,%esp
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025e7:	90                   	nop
c01025e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01025eb:	c9                   	leave  
c01025ec:	c3                   	ret    

c01025ed <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025ed:	55                   	push   %ebp
c01025ee:	89 e5                	mov    %esp,%ebp
c01025f0:	83 ec 18             	sub    $0x18,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025f3:	83 ec 0c             	sub    $0xc,%esp
c01025f6:	ff 75 08             	pushl  0x8(%ebp)
c01025f9:	e8 7a ff ff ff       	call   c0102578 <print_pgfault>
c01025fe:	83 c4 10             	add    $0x10,%esp
    if (check_mm_struct != NULL) {
c0102601:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c0102606:	85 c0                	test   %eax,%eax
c0102608:	74 24                	je     c010262e <pgfault_handler+0x41>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010260a:	0f 20 d0             	mov    %cr2,%eax
c010260d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102610:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102613:	8b 45 08             	mov    0x8(%ebp),%eax
c0102616:	8b 50 34             	mov    0x34(%eax),%edx
c0102619:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c010261e:	83 ec 04             	sub    $0x4,%esp
c0102621:	51                   	push   %ecx
c0102622:	52                   	push   %edx
c0102623:	50                   	push   %eax
c0102624:	e8 20 1e 00 00       	call   c0104449 <do_pgfault>
c0102629:	83 c4 10             	add    $0x10,%esp
c010262c:	eb 17                	jmp    c0102645 <pgfault_handler+0x58>
    }
    panic("unhandled page fault.\n");
c010262e:	83 ec 04             	sub    $0x4,%esp
c0102631:	68 4b a4 10 c0       	push   $0xc010a44b
c0102636:	68 a9 00 00 00       	push   $0xa9
c010263b:	68 4e a2 10 c0       	push   $0xc010a24e
c0102640:	e8 b3 dd ff ff       	call   c01003f8 <__panic>
}
c0102645:	c9                   	leave  
c0102646:	c3                   	ret    

c0102647 <trap_dispatch>:
// LAB1 YOU SHOULD ALSO COPY THIS
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

static void
trap_dispatch(struct trapframe *tf) {
c0102647:	55                   	push   %ebp
c0102648:	89 e5                	mov    %esp,%ebp
c010264a:	57                   	push   %edi
c010264b:	56                   	push   %esi
c010264c:	53                   	push   %ebx
c010264d:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102650:	8b 45 08             	mov    0x8(%ebp),%eax
c0102653:	8b 40 30             	mov    0x30(%eax),%eax
c0102656:	83 f8 24             	cmp    $0x24,%eax
c0102659:	0f 84 c8 00 00 00    	je     c0102727 <trap_dispatch+0xe0>
c010265f:	83 f8 24             	cmp    $0x24,%eax
c0102662:	77 1c                	ja     c0102680 <trap_dispatch+0x39>
c0102664:	83 f8 20             	cmp    $0x20,%eax
c0102667:	0f 84 80 00 00 00    	je     c01026ed <trap_dispatch+0xa6>
c010266d:	83 f8 21             	cmp    $0x21,%eax
c0102670:	0f 84 d8 00 00 00    	je     c010274e <trap_dispatch+0x107>
c0102676:	83 f8 0e             	cmp    $0xe,%eax
c0102679:	74 32                	je     c01026ad <trap_dispatch+0x66>
c010267b:	e9 98 01 00 00       	jmp    c0102818 <trap_dispatch+0x1d1>
c0102680:	83 f8 78             	cmp    $0x78,%eax
c0102683:	0f 84 ec 00 00 00    	je     c0102775 <trap_dispatch+0x12e>
c0102689:	83 f8 78             	cmp    $0x78,%eax
c010268c:	77 11                	ja     c010269f <trap_dispatch+0x58>
c010268e:	83 e8 2e             	sub    $0x2e,%eax
c0102691:	83 f8 01             	cmp    $0x1,%eax
c0102694:	0f 87 7e 01 00 00    	ja     c0102818 <trap_dispatch+0x1d1>
    // end of copy

    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010269a:	e9 b3 01 00 00       	jmp    c0102852 <trap_dispatch+0x20b>
trap_dispatch(struct trapframe *tf) {
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010269f:	83 f8 79             	cmp    $0x79,%eax
c01026a2:	0f 84 42 01 00 00    	je     c01027ea <trap_dispatch+0x1a3>
c01026a8:	e9 6b 01 00 00       	jmp    c0102818 <trap_dispatch+0x1d1>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01026ad:	83 ec 0c             	sub    $0xc,%esp
c01026b0:	ff 75 08             	pushl  0x8(%ebp)
c01026b3:	e8 35 ff ff ff       	call   c01025ed <pgfault_handler>
c01026b8:	83 c4 10             	add    $0x10,%esp
c01026bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01026be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01026c2:	0f 84 86 01 00 00    	je     c010284e <trap_dispatch+0x207>
            print_trapframe(tf);
c01026c8:	83 ec 0c             	sub    $0xc,%esp
c01026cb:	ff 75 08             	pushl  0x8(%ebp)
c01026ce:	e8 08 fc ff ff       	call   c01022db <print_trapframe>
c01026d3:	83 c4 10             	add    $0x10,%esp
            panic("handle pgfault failed. %e\n", ret);
c01026d6:	ff 75 e4             	pushl  -0x1c(%ebp)
c01026d9:	68 62 a4 10 c0       	push   $0xc010a462
c01026de:	68 bd 00 00 00       	push   $0xbd
c01026e3:	68 4e a2 10 c0       	push   $0xc010a24e
c01026e8:	e8 0b dd ff ff       	call   c01003f8 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c01026ed:	a1 54 c0 12 c0       	mov    0xc012c054,%eax
c01026f2:	83 c0 01             	add    $0x1,%eax
c01026f5:	a3 54 c0 12 c0       	mov    %eax,0xc012c054
        if (ticks % TICK_NUM == 0) {
c01026fa:	8b 0d 54 c0 12 c0    	mov    0xc012c054,%ecx
c0102700:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102705:	89 c8                	mov    %ecx,%eax
c0102707:	f7 e2                	mul    %edx
c0102709:	89 d0                	mov    %edx,%eax
c010270b:	c1 e8 05             	shr    $0x5,%eax
c010270e:	6b c0 64             	imul   $0x64,%eax,%eax
c0102711:	29 c1                	sub    %eax,%ecx
c0102713:	89 c8                	mov    %ecx,%eax
c0102715:	85 c0                	test   %eax,%eax
c0102717:	0f 85 34 01 00 00    	jne    c0102851 <trap_dispatch+0x20a>
            print_ticks();
c010271d:	e8 c5 f9 ff ff       	call   c01020e7 <print_ticks>
        }
        break;
c0102722:	e9 2a 01 00 00       	jmp    c0102851 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102727:	e8 78 f7 ff ff       	call   c0101ea4 <cons_getc>
c010272c:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010272f:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c0102733:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c0102737:	83 ec 04             	sub    $0x4,%esp
c010273a:	52                   	push   %edx
c010273b:	50                   	push   %eax
c010273c:	68 7d a4 10 c0       	push   $0xc010a47d
c0102741:	e8 4c db ff ff       	call   c0100292 <cprintf>
c0102746:	83 c4 10             	add    $0x10,%esp
        break;
c0102749:	e9 04 01 00 00       	jmp    c0102852 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010274e:	e8 51 f7 ff ff       	call   c0101ea4 <cons_getc>
c0102753:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102756:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c010275a:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c010275e:	83 ec 04             	sub    $0x4,%esp
c0102761:	52                   	push   %edx
c0102762:	50                   	push   %eax
c0102763:	68 8f a4 10 c0       	push   $0xc010a48f
c0102768:	e8 25 db ff ff       	call   c0100292 <cprintf>
c010276d:	83 c4 10             	add    $0x10,%esp
        break;
c0102770:	e9 dd 00 00 00       	jmp    c0102852 <trap_dispatch+0x20b>
        
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
c0102775:	8b 55 08             	mov    0x8(%ebp),%edx
c0102778:	b8 60 c0 12 c0       	mov    $0xc012c060,%eax
c010277d:	89 d3                	mov    %edx,%ebx
c010277f:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0102784:	8b 0b                	mov    (%ebx),%ecx
c0102786:	89 08                	mov    %ecx,(%eax)
c0102788:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c010278c:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0102790:	8d 78 04             	lea    0x4(%eax),%edi
c0102793:	83 e7 fc             	and    $0xfffffffc,%edi
c0102796:	29 f8                	sub    %edi,%eax
c0102798:	29 c3                	sub    %eax,%ebx
c010279a:	01 c2                	add    %eax,%edx
c010279c:	83 e2 fc             	and    $0xfffffffc,%edx
c010279f:	89 d0                	mov    %edx,%eax
c01027a1:	c1 e8 02             	shr    $0x2,%eax
c01027a4:	89 de                	mov    %ebx,%esi
c01027a6:	89 c1                	mov    %eax,%ecx
c01027a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
c01027aa:	66 c7 05 9c c0 12 c0 	movw   $0x1b,0xc012c09c
c01027b1:	1b 00 
        switchk2u.tf_ds = USER_DS;
c01027b3:	66 c7 05 8c c0 12 c0 	movw   $0x23,0xc012c08c
c01027ba:	23 00 
        switchk2u.tf_es = USER_DS;
c01027bc:	66 c7 05 88 c0 12 c0 	movw   $0x23,0xc012c088
c01027c3:	23 00 
        switchk2u.tf_ss = USER_DS;
c01027c5:	66 c7 05 a8 c0 12 c0 	movw   $0x23,0xc012c0a8
c01027cc:	23 00 
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c01027ce:	a1 a0 c0 12 c0       	mov    0xc012c0a0,%eax
c01027d3:	80 cc 30             	or     $0x30,%ah
c01027d6:	a3 a0 c0 12 c0       	mov    %eax,0xc012c0a0
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c01027db:	8b 45 08             	mov    0x8(%ebp),%eax
c01027de:	83 e8 04             	sub    $0x4,%eax
c01027e1:	ba 60 c0 12 c0       	mov    $0xc012c060,%edx
c01027e6:	89 10                	mov    %edx,(%eax)
        break;
c01027e8:	eb 68                	jmp    c0102852 <trap_dispatch+0x20b>
    case T_SWITCH_TOK:
        tf->tf_cs = KERNEL_CS;
c01027ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ed:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c01027f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01027f6:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c01027fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ff:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c0102805:	8b 45 08             	mov    0x8(%ebp),%eax
c0102808:	8b 40 40             	mov    0x40(%eax),%eax
c010280b:	80 e4 cf             	and    $0xcf,%ah
c010280e:	89 c2                	mov    %eax,%edx
c0102810:	8b 45 08             	mov    0x8(%ebp),%eax
c0102813:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c0102816:	eb 3a                	jmp    c0102852 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102818:	8b 45 08             	mov    0x8(%ebp),%eax
c010281b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010281f:	0f b7 c0             	movzwl %ax,%eax
c0102822:	83 e0 03             	and    $0x3,%eax
c0102825:	85 c0                	test   %eax,%eax
c0102827:	75 29                	jne    c0102852 <trap_dispatch+0x20b>
            print_trapframe(tf);
c0102829:	83 ec 0c             	sub    $0xc,%esp
c010282c:	ff 75 08             	pushl  0x8(%ebp)
c010282f:	e8 a7 fa ff ff       	call   c01022db <print_trapframe>
c0102834:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0102837:	83 ec 04             	sub    $0x4,%esp
c010283a:	68 9e a4 10 c0       	push   $0xc010a49e
c010283f:	68 f3 00 00 00       	push   $0xf3
c0102844:	68 4e a2 10 c0       	push   $0xc010a24e
c0102849:	e8 aa db ff ff       	call   c01003f8 <__panic>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c010284e:	90                   	nop
c010284f:	eb 01                	jmp    c0102852 <trap_dispatch+0x20b>
         */
        ticks++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
c0102851:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102852:	90                   	nop
c0102853:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102856:	5b                   	pop    %ebx
c0102857:	5e                   	pop    %esi
c0102858:	5f                   	pop    %edi
c0102859:	5d                   	pop    %ebp
c010285a:	c3                   	ret    

c010285b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010285b:	55                   	push   %ebp
c010285c:	89 e5                	mov    %esp,%ebp
c010285e:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102861:	83 ec 0c             	sub    $0xc,%esp
c0102864:	ff 75 08             	pushl  0x8(%ebp)
c0102867:	e8 db fd ff ff       	call   c0102647 <trap_dispatch>
c010286c:	83 c4 10             	add    $0x10,%esp
}
c010286f:	90                   	nop
c0102870:	c9                   	leave  
c0102871:	c3                   	ret    

c0102872 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102872:	6a 00                	push   $0x0
  pushl $0
c0102874:	6a 00                	push   $0x0
  jmp __alltraps
c0102876:	e9 69 0a 00 00       	jmp    c01032e4 <__alltraps>

c010287b <vector1>:
.globl vector1
vector1:
  pushl $0
c010287b:	6a 00                	push   $0x0
  pushl $1
c010287d:	6a 01                	push   $0x1
  jmp __alltraps
c010287f:	e9 60 0a 00 00       	jmp    c01032e4 <__alltraps>

c0102884 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $2
c0102886:	6a 02                	push   $0x2
  jmp __alltraps
c0102888:	e9 57 0a 00 00       	jmp    c01032e4 <__alltraps>

c010288d <vector3>:
.globl vector3
vector3:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $3
c010288f:	6a 03                	push   $0x3
  jmp __alltraps
c0102891:	e9 4e 0a 00 00       	jmp    c01032e4 <__alltraps>

c0102896 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102896:	6a 00                	push   $0x0
  pushl $4
c0102898:	6a 04                	push   $0x4
  jmp __alltraps
c010289a:	e9 45 0a 00 00       	jmp    c01032e4 <__alltraps>

c010289f <vector5>:
.globl vector5
vector5:
  pushl $0
c010289f:	6a 00                	push   $0x0
  pushl $5
c01028a1:	6a 05                	push   $0x5
  jmp __alltraps
c01028a3:	e9 3c 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028a8 <vector6>:
.globl vector6
vector6:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $6
c01028aa:	6a 06                	push   $0x6
  jmp __alltraps
c01028ac:	e9 33 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028b1 <vector7>:
.globl vector7
vector7:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $7
c01028b3:	6a 07                	push   $0x7
  jmp __alltraps
c01028b5:	e9 2a 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028ba <vector8>:
.globl vector8
vector8:
  pushl $8
c01028ba:	6a 08                	push   $0x8
  jmp __alltraps
c01028bc:	e9 23 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028c1 <vector9>:
.globl vector9
vector9:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $9
c01028c3:	6a 09                	push   $0x9
  jmp __alltraps
c01028c5:	e9 1a 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028ca <vector10>:
.globl vector10
vector10:
  pushl $10
c01028ca:	6a 0a                	push   $0xa
  jmp __alltraps
c01028cc:	e9 13 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028d1 <vector11>:
.globl vector11
vector11:
  pushl $11
c01028d1:	6a 0b                	push   $0xb
  jmp __alltraps
c01028d3:	e9 0c 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028d8 <vector12>:
.globl vector12
vector12:
  pushl $12
c01028d8:	6a 0c                	push   $0xc
  jmp __alltraps
c01028da:	e9 05 0a 00 00       	jmp    c01032e4 <__alltraps>

c01028df <vector13>:
.globl vector13
vector13:
  pushl $13
c01028df:	6a 0d                	push   $0xd
  jmp __alltraps
c01028e1:	e9 fe 09 00 00       	jmp    c01032e4 <__alltraps>

c01028e6 <vector14>:
.globl vector14
vector14:
  pushl $14
c01028e6:	6a 0e                	push   $0xe
  jmp __alltraps
c01028e8:	e9 f7 09 00 00       	jmp    c01032e4 <__alltraps>

c01028ed <vector15>:
.globl vector15
vector15:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $15
c01028ef:	6a 0f                	push   $0xf
  jmp __alltraps
c01028f1:	e9 ee 09 00 00       	jmp    c01032e4 <__alltraps>

c01028f6 <vector16>:
.globl vector16
vector16:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $16
c01028f8:	6a 10                	push   $0x10
  jmp __alltraps
c01028fa:	e9 e5 09 00 00       	jmp    c01032e4 <__alltraps>

c01028ff <vector17>:
.globl vector17
vector17:
  pushl $17
c01028ff:	6a 11                	push   $0x11
  jmp __alltraps
c0102901:	e9 de 09 00 00       	jmp    c01032e4 <__alltraps>

c0102906 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102906:	6a 00                	push   $0x0
  pushl $18
c0102908:	6a 12                	push   $0x12
  jmp __alltraps
c010290a:	e9 d5 09 00 00       	jmp    c01032e4 <__alltraps>

c010290f <vector19>:
.globl vector19
vector19:
  pushl $0
c010290f:	6a 00                	push   $0x0
  pushl $19
c0102911:	6a 13                	push   $0x13
  jmp __alltraps
c0102913:	e9 cc 09 00 00       	jmp    c01032e4 <__alltraps>

c0102918 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $20
c010291a:	6a 14                	push   $0x14
  jmp __alltraps
c010291c:	e9 c3 09 00 00       	jmp    c01032e4 <__alltraps>

c0102921 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $21
c0102923:	6a 15                	push   $0x15
  jmp __alltraps
c0102925:	e9 ba 09 00 00       	jmp    c01032e4 <__alltraps>

c010292a <vector22>:
.globl vector22
vector22:
  pushl $0
c010292a:	6a 00                	push   $0x0
  pushl $22
c010292c:	6a 16                	push   $0x16
  jmp __alltraps
c010292e:	e9 b1 09 00 00       	jmp    c01032e4 <__alltraps>

c0102933 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102933:	6a 00                	push   $0x0
  pushl $23
c0102935:	6a 17                	push   $0x17
  jmp __alltraps
c0102937:	e9 a8 09 00 00       	jmp    c01032e4 <__alltraps>

c010293c <vector24>:
.globl vector24
vector24:
  pushl $0
c010293c:	6a 00                	push   $0x0
  pushl $24
c010293e:	6a 18                	push   $0x18
  jmp __alltraps
c0102940:	e9 9f 09 00 00       	jmp    c01032e4 <__alltraps>

c0102945 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $25
c0102947:	6a 19                	push   $0x19
  jmp __alltraps
c0102949:	e9 96 09 00 00       	jmp    c01032e4 <__alltraps>

c010294e <vector26>:
.globl vector26
vector26:
  pushl $0
c010294e:	6a 00                	push   $0x0
  pushl $26
c0102950:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102952:	e9 8d 09 00 00       	jmp    c01032e4 <__alltraps>

c0102957 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102957:	6a 00                	push   $0x0
  pushl $27
c0102959:	6a 1b                	push   $0x1b
  jmp __alltraps
c010295b:	e9 84 09 00 00       	jmp    c01032e4 <__alltraps>

c0102960 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102960:	6a 00                	push   $0x0
  pushl $28
c0102962:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102964:	e9 7b 09 00 00       	jmp    c01032e4 <__alltraps>

c0102969 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102969:	6a 00                	push   $0x0
  pushl $29
c010296b:	6a 1d                	push   $0x1d
  jmp __alltraps
c010296d:	e9 72 09 00 00       	jmp    c01032e4 <__alltraps>

c0102972 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102972:	6a 00                	push   $0x0
  pushl $30
c0102974:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102976:	e9 69 09 00 00       	jmp    c01032e4 <__alltraps>

c010297b <vector31>:
.globl vector31
vector31:
  pushl $0
c010297b:	6a 00                	push   $0x0
  pushl $31
c010297d:	6a 1f                	push   $0x1f
  jmp __alltraps
c010297f:	e9 60 09 00 00       	jmp    c01032e4 <__alltraps>

c0102984 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102984:	6a 00                	push   $0x0
  pushl $32
c0102986:	6a 20                	push   $0x20
  jmp __alltraps
c0102988:	e9 57 09 00 00       	jmp    c01032e4 <__alltraps>

c010298d <vector33>:
.globl vector33
vector33:
  pushl $0
c010298d:	6a 00                	push   $0x0
  pushl $33
c010298f:	6a 21                	push   $0x21
  jmp __alltraps
c0102991:	e9 4e 09 00 00       	jmp    c01032e4 <__alltraps>

c0102996 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102996:	6a 00                	push   $0x0
  pushl $34
c0102998:	6a 22                	push   $0x22
  jmp __alltraps
c010299a:	e9 45 09 00 00       	jmp    c01032e4 <__alltraps>

c010299f <vector35>:
.globl vector35
vector35:
  pushl $0
c010299f:	6a 00                	push   $0x0
  pushl $35
c01029a1:	6a 23                	push   $0x23
  jmp __alltraps
c01029a3:	e9 3c 09 00 00       	jmp    c01032e4 <__alltraps>

c01029a8 <vector36>:
.globl vector36
vector36:
  pushl $0
c01029a8:	6a 00                	push   $0x0
  pushl $36
c01029aa:	6a 24                	push   $0x24
  jmp __alltraps
c01029ac:	e9 33 09 00 00       	jmp    c01032e4 <__alltraps>

c01029b1 <vector37>:
.globl vector37
vector37:
  pushl $0
c01029b1:	6a 00                	push   $0x0
  pushl $37
c01029b3:	6a 25                	push   $0x25
  jmp __alltraps
c01029b5:	e9 2a 09 00 00       	jmp    c01032e4 <__alltraps>

c01029ba <vector38>:
.globl vector38
vector38:
  pushl $0
c01029ba:	6a 00                	push   $0x0
  pushl $38
c01029bc:	6a 26                	push   $0x26
  jmp __alltraps
c01029be:	e9 21 09 00 00       	jmp    c01032e4 <__alltraps>

c01029c3 <vector39>:
.globl vector39
vector39:
  pushl $0
c01029c3:	6a 00                	push   $0x0
  pushl $39
c01029c5:	6a 27                	push   $0x27
  jmp __alltraps
c01029c7:	e9 18 09 00 00       	jmp    c01032e4 <__alltraps>

c01029cc <vector40>:
.globl vector40
vector40:
  pushl $0
c01029cc:	6a 00                	push   $0x0
  pushl $40
c01029ce:	6a 28                	push   $0x28
  jmp __alltraps
c01029d0:	e9 0f 09 00 00       	jmp    c01032e4 <__alltraps>

c01029d5 <vector41>:
.globl vector41
vector41:
  pushl $0
c01029d5:	6a 00                	push   $0x0
  pushl $41
c01029d7:	6a 29                	push   $0x29
  jmp __alltraps
c01029d9:	e9 06 09 00 00       	jmp    c01032e4 <__alltraps>

c01029de <vector42>:
.globl vector42
vector42:
  pushl $0
c01029de:	6a 00                	push   $0x0
  pushl $42
c01029e0:	6a 2a                	push   $0x2a
  jmp __alltraps
c01029e2:	e9 fd 08 00 00       	jmp    c01032e4 <__alltraps>

c01029e7 <vector43>:
.globl vector43
vector43:
  pushl $0
c01029e7:	6a 00                	push   $0x0
  pushl $43
c01029e9:	6a 2b                	push   $0x2b
  jmp __alltraps
c01029eb:	e9 f4 08 00 00       	jmp    c01032e4 <__alltraps>

c01029f0 <vector44>:
.globl vector44
vector44:
  pushl $0
c01029f0:	6a 00                	push   $0x0
  pushl $44
c01029f2:	6a 2c                	push   $0x2c
  jmp __alltraps
c01029f4:	e9 eb 08 00 00       	jmp    c01032e4 <__alltraps>

c01029f9 <vector45>:
.globl vector45
vector45:
  pushl $0
c01029f9:	6a 00                	push   $0x0
  pushl $45
c01029fb:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029fd:	e9 e2 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a02 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102a02:	6a 00                	push   $0x0
  pushl $46
c0102a04:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102a06:	e9 d9 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a0b <vector47>:
.globl vector47
vector47:
  pushl $0
c0102a0b:	6a 00                	push   $0x0
  pushl $47
c0102a0d:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102a0f:	e9 d0 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a14 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102a14:	6a 00                	push   $0x0
  pushl $48
c0102a16:	6a 30                	push   $0x30
  jmp __alltraps
c0102a18:	e9 c7 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a1d <vector49>:
.globl vector49
vector49:
  pushl $0
c0102a1d:	6a 00                	push   $0x0
  pushl $49
c0102a1f:	6a 31                	push   $0x31
  jmp __alltraps
c0102a21:	e9 be 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a26 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102a26:	6a 00                	push   $0x0
  pushl $50
c0102a28:	6a 32                	push   $0x32
  jmp __alltraps
c0102a2a:	e9 b5 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a2f <vector51>:
.globl vector51
vector51:
  pushl $0
c0102a2f:	6a 00                	push   $0x0
  pushl $51
c0102a31:	6a 33                	push   $0x33
  jmp __alltraps
c0102a33:	e9 ac 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a38 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102a38:	6a 00                	push   $0x0
  pushl $52
c0102a3a:	6a 34                	push   $0x34
  jmp __alltraps
c0102a3c:	e9 a3 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a41 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102a41:	6a 00                	push   $0x0
  pushl $53
c0102a43:	6a 35                	push   $0x35
  jmp __alltraps
c0102a45:	e9 9a 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a4a <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a4a:	6a 00                	push   $0x0
  pushl $54
c0102a4c:	6a 36                	push   $0x36
  jmp __alltraps
c0102a4e:	e9 91 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a53 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102a53:	6a 00                	push   $0x0
  pushl $55
c0102a55:	6a 37                	push   $0x37
  jmp __alltraps
c0102a57:	e9 88 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a5c <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a5c:	6a 00                	push   $0x0
  pushl $56
c0102a5e:	6a 38                	push   $0x38
  jmp __alltraps
c0102a60:	e9 7f 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a65 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a65:	6a 00                	push   $0x0
  pushl $57
c0102a67:	6a 39                	push   $0x39
  jmp __alltraps
c0102a69:	e9 76 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a6e <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a6e:	6a 00                	push   $0x0
  pushl $58
c0102a70:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a72:	e9 6d 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a77 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a77:	6a 00                	push   $0x0
  pushl $59
c0102a79:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a7b:	e9 64 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a80 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a80:	6a 00                	push   $0x0
  pushl $60
c0102a82:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a84:	e9 5b 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a89 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a89:	6a 00                	push   $0x0
  pushl $61
c0102a8b:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a8d:	e9 52 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a92 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a92:	6a 00                	push   $0x0
  pushl $62
c0102a94:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a96:	e9 49 08 00 00       	jmp    c01032e4 <__alltraps>

c0102a9b <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a9b:	6a 00                	push   $0x0
  pushl $63
c0102a9d:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a9f:	e9 40 08 00 00       	jmp    c01032e4 <__alltraps>

c0102aa4 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102aa4:	6a 00                	push   $0x0
  pushl $64
c0102aa6:	6a 40                	push   $0x40
  jmp __alltraps
c0102aa8:	e9 37 08 00 00       	jmp    c01032e4 <__alltraps>

c0102aad <vector65>:
.globl vector65
vector65:
  pushl $0
c0102aad:	6a 00                	push   $0x0
  pushl $65
c0102aaf:	6a 41                	push   $0x41
  jmp __alltraps
c0102ab1:	e9 2e 08 00 00       	jmp    c01032e4 <__alltraps>

c0102ab6 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102ab6:	6a 00                	push   $0x0
  pushl $66
c0102ab8:	6a 42                	push   $0x42
  jmp __alltraps
c0102aba:	e9 25 08 00 00       	jmp    c01032e4 <__alltraps>

c0102abf <vector67>:
.globl vector67
vector67:
  pushl $0
c0102abf:	6a 00                	push   $0x0
  pushl $67
c0102ac1:	6a 43                	push   $0x43
  jmp __alltraps
c0102ac3:	e9 1c 08 00 00       	jmp    c01032e4 <__alltraps>

c0102ac8 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102ac8:	6a 00                	push   $0x0
  pushl $68
c0102aca:	6a 44                	push   $0x44
  jmp __alltraps
c0102acc:	e9 13 08 00 00       	jmp    c01032e4 <__alltraps>

c0102ad1 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102ad1:	6a 00                	push   $0x0
  pushl $69
c0102ad3:	6a 45                	push   $0x45
  jmp __alltraps
c0102ad5:	e9 0a 08 00 00       	jmp    c01032e4 <__alltraps>

c0102ada <vector70>:
.globl vector70
vector70:
  pushl $0
c0102ada:	6a 00                	push   $0x0
  pushl $70
c0102adc:	6a 46                	push   $0x46
  jmp __alltraps
c0102ade:	e9 01 08 00 00       	jmp    c01032e4 <__alltraps>

c0102ae3 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102ae3:	6a 00                	push   $0x0
  pushl $71
c0102ae5:	6a 47                	push   $0x47
  jmp __alltraps
c0102ae7:	e9 f8 07 00 00       	jmp    c01032e4 <__alltraps>

c0102aec <vector72>:
.globl vector72
vector72:
  pushl $0
c0102aec:	6a 00                	push   $0x0
  pushl $72
c0102aee:	6a 48                	push   $0x48
  jmp __alltraps
c0102af0:	e9 ef 07 00 00       	jmp    c01032e4 <__alltraps>

c0102af5 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102af5:	6a 00                	push   $0x0
  pushl $73
c0102af7:	6a 49                	push   $0x49
  jmp __alltraps
c0102af9:	e9 e6 07 00 00       	jmp    c01032e4 <__alltraps>

c0102afe <vector74>:
.globl vector74
vector74:
  pushl $0
c0102afe:	6a 00                	push   $0x0
  pushl $74
c0102b00:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102b02:	e9 dd 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b07 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102b07:	6a 00                	push   $0x0
  pushl $75
c0102b09:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102b0b:	e9 d4 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b10 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102b10:	6a 00                	push   $0x0
  pushl $76
c0102b12:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102b14:	e9 cb 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b19 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102b19:	6a 00                	push   $0x0
  pushl $77
c0102b1b:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102b1d:	e9 c2 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b22 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102b22:	6a 00                	push   $0x0
  pushl $78
c0102b24:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102b26:	e9 b9 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b2b <vector79>:
.globl vector79
vector79:
  pushl $0
c0102b2b:	6a 00                	push   $0x0
  pushl $79
c0102b2d:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102b2f:	e9 b0 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b34 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102b34:	6a 00                	push   $0x0
  pushl $80
c0102b36:	6a 50                	push   $0x50
  jmp __alltraps
c0102b38:	e9 a7 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b3d <vector81>:
.globl vector81
vector81:
  pushl $0
c0102b3d:	6a 00                	push   $0x0
  pushl $81
c0102b3f:	6a 51                	push   $0x51
  jmp __alltraps
c0102b41:	e9 9e 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b46 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b46:	6a 00                	push   $0x0
  pushl $82
c0102b48:	6a 52                	push   $0x52
  jmp __alltraps
c0102b4a:	e9 95 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b4f <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b4f:	6a 00                	push   $0x0
  pushl $83
c0102b51:	6a 53                	push   $0x53
  jmp __alltraps
c0102b53:	e9 8c 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b58 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102b58:	6a 00                	push   $0x0
  pushl $84
c0102b5a:	6a 54                	push   $0x54
  jmp __alltraps
c0102b5c:	e9 83 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b61 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b61:	6a 00                	push   $0x0
  pushl $85
c0102b63:	6a 55                	push   $0x55
  jmp __alltraps
c0102b65:	e9 7a 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b6a <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b6a:	6a 00                	push   $0x0
  pushl $86
c0102b6c:	6a 56                	push   $0x56
  jmp __alltraps
c0102b6e:	e9 71 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b73 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b73:	6a 00                	push   $0x0
  pushl $87
c0102b75:	6a 57                	push   $0x57
  jmp __alltraps
c0102b77:	e9 68 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b7c <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b7c:	6a 00                	push   $0x0
  pushl $88
c0102b7e:	6a 58                	push   $0x58
  jmp __alltraps
c0102b80:	e9 5f 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b85 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b85:	6a 00                	push   $0x0
  pushl $89
c0102b87:	6a 59                	push   $0x59
  jmp __alltraps
c0102b89:	e9 56 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b8e <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b8e:	6a 00                	push   $0x0
  pushl $90
c0102b90:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b92:	e9 4d 07 00 00       	jmp    c01032e4 <__alltraps>

c0102b97 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b97:	6a 00                	push   $0x0
  pushl $91
c0102b99:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b9b:	e9 44 07 00 00       	jmp    c01032e4 <__alltraps>

c0102ba0 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102ba0:	6a 00                	push   $0x0
  pushl $92
c0102ba2:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102ba4:	e9 3b 07 00 00       	jmp    c01032e4 <__alltraps>

c0102ba9 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102ba9:	6a 00                	push   $0x0
  pushl $93
c0102bab:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102bad:	e9 32 07 00 00       	jmp    c01032e4 <__alltraps>

c0102bb2 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102bb2:	6a 00                	push   $0x0
  pushl $94
c0102bb4:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102bb6:	e9 29 07 00 00       	jmp    c01032e4 <__alltraps>

c0102bbb <vector95>:
.globl vector95
vector95:
  pushl $0
c0102bbb:	6a 00                	push   $0x0
  pushl $95
c0102bbd:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102bbf:	e9 20 07 00 00       	jmp    c01032e4 <__alltraps>

c0102bc4 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102bc4:	6a 00                	push   $0x0
  pushl $96
c0102bc6:	6a 60                	push   $0x60
  jmp __alltraps
c0102bc8:	e9 17 07 00 00       	jmp    c01032e4 <__alltraps>

c0102bcd <vector97>:
.globl vector97
vector97:
  pushl $0
c0102bcd:	6a 00                	push   $0x0
  pushl $97
c0102bcf:	6a 61                	push   $0x61
  jmp __alltraps
c0102bd1:	e9 0e 07 00 00       	jmp    c01032e4 <__alltraps>

c0102bd6 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102bd6:	6a 00                	push   $0x0
  pushl $98
c0102bd8:	6a 62                	push   $0x62
  jmp __alltraps
c0102bda:	e9 05 07 00 00       	jmp    c01032e4 <__alltraps>

c0102bdf <vector99>:
.globl vector99
vector99:
  pushl $0
c0102bdf:	6a 00                	push   $0x0
  pushl $99
c0102be1:	6a 63                	push   $0x63
  jmp __alltraps
c0102be3:	e9 fc 06 00 00       	jmp    c01032e4 <__alltraps>

c0102be8 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102be8:	6a 00                	push   $0x0
  pushl $100
c0102bea:	6a 64                	push   $0x64
  jmp __alltraps
c0102bec:	e9 f3 06 00 00       	jmp    c01032e4 <__alltraps>

c0102bf1 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102bf1:	6a 00                	push   $0x0
  pushl $101
c0102bf3:	6a 65                	push   $0x65
  jmp __alltraps
c0102bf5:	e9 ea 06 00 00       	jmp    c01032e4 <__alltraps>

c0102bfa <vector102>:
.globl vector102
vector102:
  pushl $0
c0102bfa:	6a 00                	push   $0x0
  pushl $102
c0102bfc:	6a 66                	push   $0x66
  jmp __alltraps
c0102bfe:	e9 e1 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c03 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102c03:	6a 00                	push   $0x0
  pushl $103
c0102c05:	6a 67                	push   $0x67
  jmp __alltraps
c0102c07:	e9 d8 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c0c <vector104>:
.globl vector104
vector104:
  pushl $0
c0102c0c:	6a 00                	push   $0x0
  pushl $104
c0102c0e:	6a 68                	push   $0x68
  jmp __alltraps
c0102c10:	e9 cf 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c15 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102c15:	6a 00                	push   $0x0
  pushl $105
c0102c17:	6a 69                	push   $0x69
  jmp __alltraps
c0102c19:	e9 c6 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c1e <vector106>:
.globl vector106
vector106:
  pushl $0
c0102c1e:	6a 00                	push   $0x0
  pushl $106
c0102c20:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102c22:	e9 bd 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c27 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102c27:	6a 00                	push   $0x0
  pushl $107
c0102c29:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102c2b:	e9 b4 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c30 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102c30:	6a 00                	push   $0x0
  pushl $108
c0102c32:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102c34:	e9 ab 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c39 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102c39:	6a 00                	push   $0x0
  pushl $109
c0102c3b:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102c3d:	e9 a2 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c42 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102c42:	6a 00                	push   $0x0
  pushl $110
c0102c44:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c46:	e9 99 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c4b <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c4b:	6a 00                	push   $0x0
  pushl $111
c0102c4d:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c4f:	e9 90 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c54 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102c54:	6a 00                	push   $0x0
  pushl $112
c0102c56:	6a 70                	push   $0x70
  jmp __alltraps
c0102c58:	e9 87 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c5d <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c5d:	6a 00                	push   $0x0
  pushl $113
c0102c5f:	6a 71                	push   $0x71
  jmp __alltraps
c0102c61:	e9 7e 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c66 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c66:	6a 00                	push   $0x0
  pushl $114
c0102c68:	6a 72                	push   $0x72
  jmp __alltraps
c0102c6a:	e9 75 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c6f <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c6f:	6a 00                	push   $0x0
  pushl $115
c0102c71:	6a 73                	push   $0x73
  jmp __alltraps
c0102c73:	e9 6c 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c78 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c78:	6a 00                	push   $0x0
  pushl $116
c0102c7a:	6a 74                	push   $0x74
  jmp __alltraps
c0102c7c:	e9 63 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c81 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c81:	6a 00                	push   $0x0
  pushl $117
c0102c83:	6a 75                	push   $0x75
  jmp __alltraps
c0102c85:	e9 5a 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c8a <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c8a:	6a 00                	push   $0x0
  pushl $118
c0102c8c:	6a 76                	push   $0x76
  jmp __alltraps
c0102c8e:	e9 51 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c93 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c93:	6a 00                	push   $0x0
  pushl $119
c0102c95:	6a 77                	push   $0x77
  jmp __alltraps
c0102c97:	e9 48 06 00 00       	jmp    c01032e4 <__alltraps>

c0102c9c <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c9c:	6a 00                	push   $0x0
  pushl $120
c0102c9e:	6a 78                	push   $0x78
  jmp __alltraps
c0102ca0:	e9 3f 06 00 00       	jmp    c01032e4 <__alltraps>

c0102ca5 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102ca5:	6a 00                	push   $0x0
  pushl $121
c0102ca7:	6a 79                	push   $0x79
  jmp __alltraps
c0102ca9:	e9 36 06 00 00       	jmp    c01032e4 <__alltraps>

c0102cae <vector122>:
.globl vector122
vector122:
  pushl $0
c0102cae:	6a 00                	push   $0x0
  pushl $122
c0102cb0:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102cb2:	e9 2d 06 00 00       	jmp    c01032e4 <__alltraps>

c0102cb7 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102cb7:	6a 00                	push   $0x0
  pushl $123
c0102cb9:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102cbb:	e9 24 06 00 00       	jmp    c01032e4 <__alltraps>

c0102cc0 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102cc0:	6a 00                	push   $0x0
  pushl $124
c0102cc2:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102cc4:	e9 1b 06 00 00       	jmp    c01032e4 <__alltraps>

c0102cc9 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102cc9:	6a 00                	push   $0x0
  pushl $125
c0102ccb:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102ccd:	e9 12 06 00 00       	jmp    c01032e4 <__alltraps>

c0102cd2 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102cd2:	6a 00                	push   $0x0
  pushl $126
c0102cd4:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102cd6:	e9 09 06 00 00       	jmp    c01032e4 <__alltraps>

c0102cdb <vector127>:
.globl vector127
vector127:
  pushl $0
c0102cdb:	6a 00                	push   $0x0
  pushl $127
c0102cdd:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102cdf:	e9 00 06 00 00       	jmp    c01032e4 <__alltraps>

c0102ce4 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102ce4:	6a 00                	push   $0x0
  pushl $128
c0102ce6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102ceb:	e9 f4 05 00 00       	jmp    c01032e4 <__alltraps>

c0102cf0 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102cf0:	6a 00                	push   $0x0
  pushl $129
c0102cf2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102cf7:	e9 e8 05 00 00       	jmp    c01032e4 <__alltraps>

c0102cfc <vector130>:
.globl vector130
vector130:
  pushl $0
c0102cfc:	6a 00                	push   $0x0
  pushl $130
c0102cfe:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102d03:	e9 dc 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d08 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102d08:	6a 00                	push   $0x0
  pushl $131
c0102d0a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102d0f:	e9 d0 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d14 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102d14:	6a 00                	push   $0x0
  pushl $132
c0102d16:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102d1b:	e9 c4 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d20 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102d20:	6a 00                	push   $0x0
  pushl $133
c0102d22:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102d27:	e9 b8 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d2c <vector134>:
.globl vector134
vector134:
  pushl $0
c0102d2c:	6a 00                	push   $0x0
  pushl $134
c0102d2e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102d33:	e9 ac 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d38 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102d38:	6a 00                	push   $0x0
  pushl $135
c0102d3a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102d3f:	e9 a0 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d44 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102d44:	6a 00                	push   $0x0
  pushl $136
c0102d46:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d4b:	e9 94 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d50 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102d50:	6a 00                	push   $0x0
  pushl $137
c0102d52:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102d57:	e9 88 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d5c <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d5c:	6a 00                	push   $0x0
  pushl $138
c0102d5e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d63:	e9 7c 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d68 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d68:	6a 00                	push   $0x0
  pushl $139
c0102d6a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d6f:	e9 70 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d74 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d74:	6a 00                	push   $0x0
  pushl $140
c0102d76:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d7b:	e9 64 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d80 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d80:	6a 00                	push   $0x0
  pushl $141
c0102d82:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d87:	e9 58 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d8c <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d8c:	6a 00                	push   $0x0
  pushl $142
c0102d8e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d93:	e9 4c 05 00 00       	jmp    c01032e4 <__alltraps>

c0102d98 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d98:	6a 00                	push   $0x0
  pushl $143
c0102d9a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d9f:	e9 40 05 00 00       	jmp    c01032e4 <__alltraps>

c0102da4 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102da4:	6a 00                	push   $0x0
  pushl $144
c0102da6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102dab:	e9 34 05 00 00       	jmp    c01032e4 <__alltraps>

c0102db0 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102db0:	6a 00                	push   $0x0
  pushl $145
c0102db2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102db7:	e9 28 05 00 00       	jmp    c01032e4 <__alltraps>

c0102dbc <vector146>:
.globl vector146
vector146:
  pushl $0
c0102dbc:	6a 00                	push   $0x0
  pushl $146
c0102dbe:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102dc3:	e9 1c 05 00 00       	jmp    c01032e4 <__alltraps>

c0102dc8 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102dc8:	6a 00                	push   $0x0
  pushl $147
c0102dca:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102dcf:	e9 10 05 00 00       	jmp    c01032e4 <__alltraps>

c0102dd4 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102dd4:	6a 00                	push   $0x0
  pushl $148
c0102dd6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102ddb:	e9 04 05 00 00       	jmp    c01032e4 <__alltraps>

c0102de0 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102de0:	6a 00                	push   $0x0
  pushl $149
c0102de2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102de7:	e9 f8 04 00 00       	jmp    c01032e4 <__alltraps>

c0102dec <vector150>:
.globl vector150
vector150:
  pushl $0
c0102dec:	6a 00                	push   $0x0
  pushl $150
c0102dee:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102df3:	e9 ec 04 00 00       	jmp    c01032e4 <__alltraps>

c0102df8 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102df8:	6a 00                	push   $0x0
  pushl $151
c0102dfa:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102dff:	e9 e0 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e04 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102e04:	6a 00                	push   $0x0
  pushl $152
c0102e06:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102e0b:	e9 d4 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e10 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102e10:	6a 00                	push   $0x0
  pushl $153
c0102e12:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102e17:	e9 c8 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e1c <vector154>:
.globl vector154
vector154:
  pushl $0
c0102e1c:	6a 00                	push   $0x0
  pushl $154
c0102e1e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102e23:	e9 bc 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e28 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102e28:	6a 00                	push   $0x0
  pushl $155
c0102e2a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102e2f:	e9 b0 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e34 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102e34:	6a 00                	push   $0x0
  pushl $156
c0102e36:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102e3b:	e9 a4 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e40 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102e40:	6a 00                	push   $0x0
  pushl $157
c0102e42:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e47:	e9 98 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e4c <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e4c:	6a 00                	push   $0x0
  pushl $158
c0102e4e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102e53:	e9 8c 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e58 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102e58:	6a 00                	push   $0x0
  pushl $159
c0102e5a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e5f:	e9 80 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e64 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e64:	6a 00                	push   $0x0
  pushl $160
c0102e66:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e6b:	e9 74 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e70 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e70:	6a 00                	push   $0x0
  pushl $161
c0102e72:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e77:	e9 68 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e7c <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e7c:	6a 00                	push   $0x0
  pushl $162
c0102e7e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e83:	e9 5c 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e88 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e88:	6a 00                	push   $0x0
  pushl $163
c0102e8a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e8f:	e9 50 04 00 00       	jmp    c01032e4 <__alltraps>

c0102e94 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e94:	6a 00                	push   $0x0
  pushl $164
c0102e96:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e9b:	e9 44 04 00 00       	jmp    c01032e4 <__alltraps>

c0102ea0 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102ea0:	6a 00                	push   $0x0
  pushl $165
c0102ea2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102ea7:	e9 38 04 00 00       	jmp    c01032e4 <__alltraps>

c0102eac <vector166>:
.globl vector166
vector166:
  pushl $0
c0102eac:	6a 00                	push   $0x0
  pushl $166
c0102eae:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102eb3:	e9 2c 04 00 00       	jmp    c01032e4 <__alltraps>

c0102eb8 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102eb8:	6a 00                	push   $0x0
  pushl $167
c0102eba:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102ebf:	e9 20 04 00 00       	jmp    c01032e4 <__alltraps>

c0102ec4 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102ec4:	6a 00                	push   $0x0
  pushl $168
c0102ec6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102ecb:	e9 14 04 00 00       	jmp    c01032e4 <__alltraps>

c0102ed0 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102ed0:	6a 00                	push   $0x0
  pushl $169
c0102ed2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102ed7:	e9 08 04 00 00       	jmp    c01032e4 <__alltraps>

c0102edc <vector170>:
.globl vector170
vector170:
  pushl $0
c0102edc:	6a 00                	push   $0x0
  pushl $170
c0102ede:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102ee3:	e9 fc 03 00 00       	jmp    c01032e4 <__alltraps>

c0102ee8 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102ee8:	6a 00                	push   $0x0
  pushl $171
c0102eea:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102eef:	e9 f0 03 00 00       	jmp    c01032e4 <__alltraps>

c0102ef4 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102ef4:	6a 00                	push   $0x0
  pushl $172
c0102ef6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102efb:	e9 e4 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f00 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102f00:	6a 00                	push   $0x0
  pushl $173
c0102f02:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102f07:	e9 d8 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f0c <vector174>:
.globl vector174
vector174:
  pushl $0
c0102f0c:	6a 00                	push   $0x0
  pushl $174
c0102f0e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102f13:	e9 cc 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f18 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102f18:	6a 00                	push   $0x0
  pushl $175
c0102f1a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102f1f:	e9 c0 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f24 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102f24:	6a 00                	push   $0x0
  pushl $176
c0102f26:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102f2b:	e9 b4 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f30 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102f30:	6a 00                	push   $0x0
  pushl $177
c0102f32:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102f37:	e9 a8 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f3c <vector178>:
.globl vector178
vector178:
  pushl $0
c0102f3c:	6a 00                	push   $0x0
  pushl $178
c0102f3e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102f43:	e9 9c 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f48 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f48:	6a 00                	push   $0x0
  pushl $179
c0102f4a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f4f:	e9 90 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f54 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102f54:	6a 00                	push   $0x0
  pushl $180
c0102f56:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f5b:	e9 84 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f60 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f60:	6a 00                	push   $0x0
  pushl $181
c0102f62:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f67:	e9 78 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f6c <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f6c:	6a 00                	push   $0x0
  pushl $182
c0102f6e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f73:	e9 6c 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f78 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f78:	6a 00                	push   $0x0
  pushl $183
c0102f7a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f7f:	e9 60 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f84 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f84:	6a 00                	push   $0x0
  pushl $184
c0102f86:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f8b:	e9 54 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f90 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f90:	6a 00                	push   $0x0
  pushl $185
c0102f92:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f97:	e9 48 03 00 00       	jmp    c01032e4 <__alltraps>

c0102f9c <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f9c:	6a 00                	push   $0x0
  pushl $186
c0102f9e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102fa3:	e9 3c 03 00 00       	jmp    c01032e4 <__alltraps>

c0102fa8 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102fa8:	6a 00                	push   $0x0
  pushl $187
c0102faa:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102faf:	e9 30 03 00 00       	jmp    c01032e4 <__alltraps>

c0102fb4 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102fb4:	6a 00                	push   $0x0
  pushl $188
c0102fb6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102fbb:	e9 24 03 00 00       	jmp    c01032e4 <__alltraps>

c0102fc0 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102fc0:	6a 00                	push   $0x0
  pushl $189
c0102fc2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102fc7:	e9 18 03 00 00       	jmp    c01032e4 <__alltraps>

c0102fcc <vector190>:
.globl vector190
vector190:
  pushl $0
c0102fcc:	6a 00                	push   $0x0
  pushl $190
c0102fce:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102fd3:	e9 0c 03 00 00       	jmp    c01032e4 <__alltraps>

c0102fd8 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102fd8:	6a 00                	push   $0x0
  pushl $191
c0102fda:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102fdf:	e9 00 03 00 00       	jmp    c01032e4 <__alltraps>

c0102fe4 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102fe4:	6a 00                	push   $0x0
  pushl $192
c0102fe6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102feb:	e9 f4 02 00 00       	jmp    c01032e4 <__alltraps>

c0102ff0 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102ff0:	6a 00                	push   $0x0
  pushl $193
c0102ff2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ff7:	e9 e8 02 00 00       	jmp    c01032e4 <__alltraps>

c0102ffc <vector194>:
.globl vector194
vector194:
  pushl $0
c0102ffc:	6a 00                	push   $0x0
  pushl $194
c0102ffe:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103003:	e9 dc 02 00 00       	jmp    c01032e4 <__alltraps>

c0103008 <vector195>:
.globl vector195
vector195:
  pushl $0
c0103008:	6a 00                	push   $0x0
  pushl $195
c010300a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010300f:	e9 d0 02 00 00       	jmp    c01032e4 <__alltraps>

c0103014 <vector196>:
.globl vector196
vector196:
  pushl $0
c0103014:	6a 00                	push   $0x0
  pushl $196
c0103016:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010301b:	e9 c4 02 00 00       	jmp    c01032e4 <__alltraps>

c0103020 <vector197>:
.globl vector197
vector197:
  pushl $0
c0103020:	6a 00                	push   $0x0
  pushl $197
c0103022:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103027:	e9 b8 02 00 00       	jmp    c01032e4 <__alltraps>

c010302c <vector198>:
.globl vector198
vector198:
  pushl $0
c010302c:	6a 00                	push   $0x0
  pushl $198
c010302e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103033:	e9 ac 02 00 00       	jmp    c01032e4 <__alltraps>

c0103038 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103038:	6a 00                	push   $0x0
  pushl $199
c010303a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010303f:	e9 a0 02 00 00       	jmp    c01032e4 <__alltraps>

c0103044 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103044:	6a 00                	push   $0x0
  pushl $200
c0103046:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010304b:	e9 94 02 00 00       	jmp    c01032e4 <__alltraps>

c0103050 <vector201>:
.globl vector201
vector201:
  pushl $0
c0103050:	6a 00                	push   $0x0
  pushl $201
c0103052:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103057:	e9 88 02 00 00       	jmp    c01032e4 <__alltraps>

c010305c <vector202>:
.globl vector202
vector202:
  pushl $0
c010305c:	6a 00                	push   $0x0
  pushl $202
c010305e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103063:	e9 7c 02 00 00       	jmp    c01032e4 <__alltraps>

c0103068 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103068:	6a 00                	push   $0x0
  pushl $203
c010306a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010306f:	e9 70 02 00 00       	jmp    c01032e4 <__alltraps>

c0103074 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103074:	6a 00                	push   $0x0
  pushl $204
c0103076:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010307b:	e9 64 02 00 00       	jmp    c01032e4 <__alltraps>

c0103080 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103080:	6a 00                	push   $0x0
  pushl $205
c0103082:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103087:	e9 58 02 00 00       	jmp    c01032e4 <__alltraps>

c010308c <vector206>:
.globl vector206
vector206:
  pushl $0
c010308c:	6a 00                	push   $0x0
  pushl $206
c010308e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103093:	e9 4c 02 00 00       	jmp    c01032e4 <__alltraps>

c0103098 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103098:	6a 00                	push   $0x0
  pushl $207
c010309a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010309f:	e9 40 02 00 00       	jmp    c01032e4 <__alltraps>

c01030a4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01030a4:	6a 00                	push   $0x0
  pushl $208
c01030a6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01030ab:	e9 34 02 00 00       	jmp    c01032e4 <__alltraps>

c01030b0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01030b0:	6a 00                	push   $0x0
  pushl $209
c01030b2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01030b7:	e9 28 02 00 00       	jmp    c01032e4 <__alltraps>

c01030bc <vector210>:
.globl vector210
vector210:
  pushl $0
c01030bc:	6a 00                	push   $0x0
  pushl $210
c01030be:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01030c3:	e9 1c 02 00 00       	jmp    c01032e4 <__alltraps>

c01030c8 <vector211>:
.globl vector211
vector211:
  pushl $0
c01030c8:	6a 00                	push   $0x0
  pushl $211
c01030ca:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01030cf:	e9 10 02 00 00       	jmp    c01032e4 <__alltraps>

c01030d4 <vector212>:
.globl vector212
vector212:
  pushl $0
c01030d4:	6a 00                	push   $0x0
  pushl $212
c01030d6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01030db:	e9 04 02 00 00       	jmp    c01032e4 <__alltraps>

c01030e0 <vector213>:
.globl vector213
vector213:
  pushl $0
c01030e0:	6a 00                	push   $0x0
  pushl $213
c01030e2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01030e7:	e9 f8 01 00 00       	jmp    c01032e4 <__alltraps>

c01030ec <vector214>:
.globl vector214
vector214:
  pushl $0
c01030ec:	6a 00                	push   $0x0
  pushl $214
c01030ee:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01030f3:	e9 ec 01 00 00       	jmp    c01032e4 <__alltraps>

c01030f8 <vector215>:
.globl vector215
vector215:
  pushl $0
c01030f8:	6a 00                	push   $0x0
  pushl $215
c01030fa:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030ff:	e9 e0 01 00 00       	jmp    c01032e4 <__alltraps>

c0103104 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103104:	6a 00                	push   $0x0
  pushl $216
c0103106:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010310b:	e9 d4 01 00 00       	jmp    c01032e4 <__alltraps>

c0103110 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103110:	6a 00                	push   $0x0
  pushl $217
c0103112:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103117:	e9 c8 01 00 00       	jmp    c01032e4 <__alltraps>

c010311c <vector218>:
.globl vector218
vector218:
  pushl $0
c010311c:	6a 00                	push   $0x0
  pushl $218
c010311e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103123:	e9 bc 01 00 00       	jmp    c01032e4 <__alltraps>

c0103128 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103128:	6a 00                	push   $0x0
  pushl $219
c010312a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010312f:	e9 b0 01 00 00       	jmp    c01032e4 <__alltraps>

c0103134 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103134:	6a 00                	push   $0x0
  pushl $220
c0103136:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010313b:	e9 a4 01 00 00       	jmp    c01032e4 <__alltraps>

c0103140 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103140:	6a 00                	push   $0x0
  pushl $221
c0103142:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103147:	e9 98 01 00 00       	jmp    c01032e4 <__alltraps>

c010314c <vector222>:
.globl vector222
vector222:
  pushl $0
c010314c:	6a 00                	push   $0x0
  pushl $222
c010314e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103153:	e9 8c 01 00 00       	jmp    c01032e4 <__alltraps>

c0103158 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103158:	6a 00                	push   $0x0
  pushl $223
c010315a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010315f:	e9 80 01 00 00       	jmp    c01032e4 <__alltraps>

c0103164 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103164:	6a 00                	push   $0x0
  pushl $224
c0103166:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010316b:	e9 74 01 00 00       	jmp    c01032e4 <__alltraps>

c0103170 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103170:	6a 00                	push   $0x0
  pushl $225
c0103172:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103177:	e9 68 01 00 00       	jmp    c01032e4 <__alltraps>

c010317c <vector226>:
.globl vector226
vector226:
  pushl $0
c010317c:	6a 00                	push   $0x0
  pushl $226
c010317e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103183:	e9 5c 01 00 00       	jmp    c01032e4 <__alltraps>

c0103188 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103188:	6a 00                	push   $0x0
  pushl $227
c010318a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010318f:	e9 50 01 00 00       	jmp    c01032e4 <__alltraps>

c0103194 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103194:	6a 00                	push   $0x0
  pushl $228
c0103196:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010319b:	e9 44 01 00 00       	jmp    c01032e4 <__alltraps>

c01031a0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01031a0:	6a 00                	push   $0x0
  pushl $229
c01031a2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01031a7:	e9 38 01 00 00       	jmp    c01032e4 <__alltraps>

c01031ac <vector230>:
.globl vector230
vector230:
  pushl $0
c01031ac:	6a 00                	push   $0x0
  pushl $230
c01031ae:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01031b3:	e9 2c 01 00 00       	jmp    c01032e4 <__alltraps>

c01031b8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01031b8:	6a 00                	push   $0x0
  pushl $231
c01031ba:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01031bf:	e9 20 01 00 00       	jmp    c01032e4 <__alltraps>

c01031c4 <vector232>:
.globl vector232
vector232:
  pushl $0
c01031c4:	6a 00                	push   $0x0
  pushl $232
c01031c6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01031cb:	e9 14 01 00 00       	jmp    c01032e4 <__alltraps>

c01031d0 <vector233>:
.globl vector233
vector233:
  pushl $0
c01031d0:	6a 00                	push   $0x0
  pushl $233
c01031d2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01031d7:	e9 08 01 00 00       	jmp    c01032e4 <__alltraps>

c01031dc <vector234>:
.globl vector234
vector234:
  pushl $0
c01031dc:	6a 00                	push   $0x0
  pushl $234
c01031de:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01031e3:	e9 fc 00 00 00       	jmp    c01032e4 <__alltraps>

c01031e8 <vector235>:
.globl vector235
vector235:
  pushl $0
c01031e8:	6a 00                	push   $0x0
  pushl $235
c01031ea:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01031ef:	e9 f0 00 00 00       	jmp    c01032e4 <__alltraps>

c01031f4 <vector236>:
.globl vector236
vector236:
  pushl $0
c01031f4:	6a 00                	push   $0x0
  pushl $236
c01031f6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031fb:	e9 e4 00 00 00       	jmp    c01032e4 <__alltraps>

c0103200 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103200:	6a 00                	push   $0x0
  pushl $237
c0103202:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103207:	e9 d8 00 00 00       	jmp    c01032e4 <__alltraps>

c010320c <vector238>:
.globl vector238
vector238:
  pushl $0
c010320c:	6a 00                	push   $0x0
  pushl $238
c010320e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103213:	e9 cc 00 00 00       	jmp    c01032e4 <__alltraps>

c0103218 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103218:	6a 00                	push   $0x0
  pushl $239
c010321a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010321f:	e9 c0 00 00 00       	jmp    c01032e4 <__alltraps>

c0103224 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103224:	6a 00                	push   $0x0
  pushl $240
c0103226:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010322b:	e9 b4 00 00 00       	jmp    c01032e4 <__alltraps>

c0103230 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103230:	6a 00                	push   $0x0
  pushl $241
c0103232:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103237:	e9 a8 00 00 00       	jmp    c01032e4 <__alltraps>

c010323c <vector242>:
.globl vector242
vector242:
  pushl $0
c010323c:	6a 00                	push   $0x0
  pushl $242
c010323e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103243:	e9 9c 00 00 00       	jmp    c01032e4 <__alltraps>

c0103248 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103248:	6a 00                	push   $0x0
  pushl $243
c010324a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010324f:	e9 90 00 00 00       	jmp    c01032e4 <__alltraps>

c0103254 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103254:	6a 00                	push   $0x0
  pushl $244
c0103256:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010325b:	e9 84 00 00 00       	jmp    c01032e4 <__alltraps>

c0103260 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103260:	6a 00                	push   $0x0
  pushl $245
c0103262:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103267:	e9 78 00 00 00       	jmp    c01032e4 <__alltraps>

c010326c <vector246>:
.globl vector246
vector246:
  pushl $0
c010326c:	6a 00                	push   $0x0
  pushl $246
c010326e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103273:	e9 6c 00 00 00       	jmp    c01032e4 <__alltraps>

c0103278 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103278:	6a 00                	push   $0x0
  pushl $247
c010327a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010327f:	e9 60 00 00 00       	jmp    c01032e4 <__alltraps>

c0103284 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103284:	6a 00                	push   $0x0
  pushl $248
c0103286:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010328b:	e9 54 00 00 00       	jmp    c01032e4 <__alltraps>

c0103290 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103290:	6a 00                	push   $0x0
  pushl $249
c0103292:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103297:	e9 48 00 00 00       	jmp    c01032e4 <__alltraps>

c010329c <vector250>:
.globl vector250
vector250:
  pushl $0
c010329c:	6a 00                	push   $0x0
  pushl $250
c010329e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01032a3:	e9 3c 00 00 00       	jmp    c01032e4 <__alltraps>

c01032a8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01032a8:	6a 00                	push   $0x0
  pushl $251
c01032aa:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01032af:	e9 30 00 00 00       	jmp    c01032e4 <__alltraps>

c01032b4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01032b4:	6a 00                	push   $0x0
  pushl $252
c01032b6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01032bb:	e9 24 00 00 00       	jmp    c01032e4 <__alltraps>

c01032c0 <vector253>:
.globl vector253
vector253:
  pushl $0
c01032c0:	6a 00                	push   $0x0
  pushl $253
c01032c2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01032c7:	e9 18 00 00 00       	jmp    c01032e4 <__alltraps>

c01032cc <vector254>:
.globl vector254
vector254:
  pushl $0
c01032cc:	6a 00                	push   $0x0
  pushl $254
c01032ce:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01032d3:	e9 0c 00 00 00       	jmp    c01032e4 <__alltraps>

c01032d8 <vector255>:
.globl vector255
vector255:
  pushl $0
c01032d8:	6a 00                	push   $0x0
  pushl $255
c01032da:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01032df:	e9 00 00 00 00       	jmp    c01032e4 <__alltraps>

c01032e4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01032e4:	1e                   	push   %ds
    pushl %es
c01032e5:	06                   	push   %es
    pushl %fs
c01032e6:	0f a0                	push   %fs
    pushl %gs
c01032e8:	0f a8                	push   %gs
    pushal
c01032ea:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01032eb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01032f0:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01032f2:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01032f4:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01032f5:	e8 61 f5 ff ff       	call   c010285b <trap>

    # pop the pushed stack pointer
    popl %esp
c01032fa:	5c                   	pop    %esp

c01032fb <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01032fb:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01032fc:	0f a9                	pop    %gs
    popl %fs
c01032fe:	0f a1                	pop    %fs
    popl %es
c0103300:	07                   	pop    %es
    popl %ds
c0103301:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0103302:	83 c4 08             	add    $0x8,%esp
    iret
c0103305:	cf                   	iret   

c0103306 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0103306:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c010330a:	eb ef                	jmp    c01032fb <__trapret>

c010330c <_enclock_init_mm>:
 * (2) _enclock_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_enclock_init_mm(struct mm_struct *mm)
{     
c010330c:	55                   	push   %ebp
c010330d:	89 e5                	mov    %esp,%ebp
c010330f:	83 ec 18             	sub    $0x18,%esp
c0103312:	c7 45 f4 b0 c0 12 c0 	movl   $0xc012c0b0,-0xc(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103319:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010331c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010331f:	89 50 04             	mov    %edx,0x4(%eax)
c0103322:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103325:	8b 50 04             	mov    0x4(%eax),%edx
c0103328:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010332b:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     clock_ptr = &pra_list_head;
c010332d:	c7 05 b8 c0 12 c0 b0 	movl   $0xc012c0b0,0xc012c0b8
c0103334:	c0 12 c0 
     assert(clock_ptr != NULL);
c0103337:	a1 b8 c0 12 c0       	mov    0xc012c0b8,%eax
c010333c:	85 c0                	test   %eax,%eax
c010333e:	75 16                	jne    c0103356 <_enclock_init_mm+0x4a>
c0103340:	68 50 a6 10 c0       	push   $0xc010a650
c0103345:	68 62 a6 10 c0       	push   $0xc010a662
c010334a:	6a 20                	push   $0x20
c010334c:	68 77 a6 10 c0       	push   $0xc010a677
c0103351:	e8 a2 d0 ff ff       	call   c01003f8 <__panic>
     mm->sm_priv = &sm_priv_enclock;
c0103356:	8b 45 08             	mov    0x8(%ebp),%eax
c0103359:	c7 40 14 e0 69 12 c0 	movl   $0xc01269e0,0x14(%eax)
     //cprintf(" mm->sm_priv %x in enclock_init_mm\n",mm->sm_priv);
     return 0;
c0103360:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103365:	c9                   	leave  
c0103366:	c3                   	ret    

c0103367 <_enclock_map_swappable>:
/*
 * (3)_enclock_map_swappable: According enclock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_enclock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0103367:	55                   	push   %ebp
c0103368:	89 e5                	mov    %esp,%ebp
c010336a:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c010336d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103370:	8b 40 14             	mov    0x14(%eax),%eax
c0103373:	8b 00                	mov    (%eax),%eax
c0103375:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c0103378:	8b 45 08             	mov    0x8(%ebp),%eax
c010337b:	8b 40 14             	mov    0x14(%eax),%eax
c010337e:	8b 40 04             	mov    0x4(%eax),%eax
c0103381:	8b 00                	mov    (%eax),%eax
c0103383:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in swappable\n");
    // }
    list_entry_t *entry=&(page->pra_page_link);
c0103386:	8b 45 10             	mov    0x10(%ebp),%eax
c0103389:	83 c0 14             	add    $0x14,%eax
c010338c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    
    assert(entry != NULL && head != NULL);
c010338f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103393:	74 06                	je     c010339b <_enclock_map_swappable+0x34>
c0103395:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103399:	75 16                	jne    c01033b1 <_enclock_map_swappable+0x4a>
c010339b:	68 8e a6 10 c0       	push   $0xc010a68e
c01033a0:	68 62 a6 10 c0       	push   $0xc010a662
c01033a5:	6a 32                	push   $0x32
c01033a7:	68 77 a6 10 c0       	push   $0xc010a677
c01033ac:	e8 47 d0 ff ff       	call   c01003f8 <__panic>
    //record the page access situlation
    /*LAB3 CHALLENGE: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c01033b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01033b5:	75 57                	jne    c010340e <_enclock_map_swappable+0xa7>
        list_entry_t *le_prev = head, *le;
c01033b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c01033bd:	eb 38                	jmp    c01033f7 <_enclock_map_swappable+0x90>
            if (le == entry) {
c01033bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033c2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01033c5:	75 2a                	jne    c01033f1 <_enclock_map_swappable+0x8a>
c01033c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01033cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033d0:	8b 40 04             	mov    0x4(%eax),%eax
c01033d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01033d6:	8b 12                	mov    (%edx),%edx
c01033d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033db:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01033de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033e1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033e4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01033e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033ed:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c01033ef:	eb 1d                	jmp    c010340e <_enclock_map_swappable+0xa7>
            }
            le_prev = le;        
c01033f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103400:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 CHALLENGE: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c0103403:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103406:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103409:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010340c:	75 b1                	jne    c01033bf <_enclock_map_swappable+0x58>
c010340e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103414:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103417:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010341a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010341d:	8b 00                	mov    (%eax),%eax
c010341f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103422:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103425:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0103428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010342b:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010342e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103431:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103434:	89 10                	mov    %edx,(%eax)
c0103436:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103439:	8b 10                	mov    (%eax),%edx
c010343b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010343e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103441:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103444:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103447:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010344a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010344d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103450:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c0103452:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103457:	c9                   	leave  
c0103458:	c3                   	ret    

c0103459 <_enclock_swap_out_victim>:
 *  (4)_enclock_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_enclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0103459:	55                   	push   %ebp
c010345a:	89 e5                	mov    %esp,%ebp
c010345c:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c010345f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103462:	8b 40 14             	mov    0x14(%eax),%eax
c0103465:	8b 00                	mov    (%eax),%eax
c0103467:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c010346a:	8b 45 08             	mov    0x8(%ebp),%eax
c010346d:	8b 40 14             	mov    0x14(%eax),%eax
c0103470:	8b 40 04             	mov    0x4(%eax),%eax
c0103473:	8b 00                	mov    (%eax),%eax
c0103475:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in victim\n");
    // }
    assert(head != NULL);
c0103478:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010347c:	75 16                	jne    c0103494 <_enclock_swap_out_victim+0x3b>
c010347e:	68 ac a6 10 c0       	push   $0xc010a6ac
c0103483:	68 62 a6 10 c0       	push   $0xc010a662
c0103488:	6a 50                	push   $0x50
c010348a:	68 77 a6 10 c0       	push   $0xc010a677
c010348f:	e8 64 cf ff ff       	call   c01003f8 <__panic>
    assert(in_tick==0);
c0103494:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103498:	74 16                	je     c01034b0 <_enclock_swap_out_victim+0x57>
c010349a:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010349f:	68 62 a6 10 c0       	push   $0xc010a662
c01034a4:	6a 51                	push   $0x51
c01034a6:	68 77 a6 10 c0       	push   $0xc010a677
c01034ab:	e8 48 cf ff ff       	call   c01003f8 <__panic>
    /* Select the victim */
    /*LAB3 CHALLENGE 2: YOUR CODE*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
c01034b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int cnt = 0;
c01034b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (le = list_next(le_prev)) {
c01034bd:	e9 36 01 00 00       	jmp    c01035f8 <_enclock_swap_out_victim+0x19f>
        assert(cnt < 3);
c01034c2:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
c01034c6:	7e 16                	jle    c01034de <_enclock_swap_out_victim+0x85>
c01034c8:	68 c4 a6 10 c0       	push   $0xc010a6c4
c01034cd:	68 62 a6 10 c0       	push   $0xc010a662
c01034d2:	6a 58                	push   $0x58
c01034d4:	68 77 a6 10 c0       	push   $0xc010a677
c01034d9:	e8 1a cf ff ff       	call   c01003f8 <__panic>
        if (le == head) {
c01034de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034e1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034e4:	75 0f                	jne    c01034f5 <_enclock_swap_out_victim+0x9c>
            cnt ++;
c01034e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
            le_prev = le;
c01034ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
            continue;
c01034f0:	e9 03 01 00 00       	jmp    c01035f8 <_enclock_swap_out_victim+0x19f>
        }
        struct Page *page = le2page(le, pra_page_link);
c01034f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034f8:	83 e8 14             	sub    $0x14,%eax
c01034fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
        pte_t* ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
c01034fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103501:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103504:	8b 45 08             	mov    0x8(%ebp),%eax
c0103507:	8b 40 0c             	mov    0xc(%eax),%eax
c010350a:	83 ec 04             	sub    $0x4,%esp
c010350d:	6a 00                	push   $0x0
c010350f:	52                   	push   %edx
c0103510:	50                   	push   %eax
c0103511:	e8 3e 41 00 00       	call   c0107654 <get_pte>
c0103516:	83 c4 10             	add    $0x10,%esp
c0103519:	89 45 d8             	mov    %eax,-0x28(%ebp)
        _enclock_print_pte(ptep, page->pra_vaddr);
c010351c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010351f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103522:	83 ec 08             	sub    $0x8,%esp
c0103525:	50                   	push   %eax
c0103526:	ff 75 d8             	pushl  -0x28(%ebp)
c0103529:	e8 fb 01 00 00       	call   c0103729 <_enclock_print_pte>
c010352e:	83 c4 10             	add    $0x10,%esp
        // cprintf("BEFORE: va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", page->pra_vaddr, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        if (*ptep & PTE_A) {
c0103531:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103534:	8b 00                	mov    (%eax),%eax
c0103536:	83 e0 20             	and    $0x20,%eax
c0103539:	85 c0                	test   %eax,%eax
c010353b:	74 2d                	je     c010356a <_enclock_swap_out_victim+0x111>
            // set access to 0
            *ptep &= ~PTE_A;
c010353d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103540:	8b 00                	mov    (%eax),%eax
c0103542:	83 e0 df             	and    $0xffffffdf,%eax
c0103545:	89 c2                	mov    %eax,%edx
c0103547:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010354a:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(mm->pgdir, page->pra_vaddr);
c010354c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010354f:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103552:	8b 45 08             	mov    0x8(%ebp),%eax
c0103555:	8b 40 0c             	mov    0xc(%eax),%eax
c0103558:	83 ec 08             	sub    $0x8,%esp
c010355b:	52                   	push   %edx
c010355c:	50                   	push   %eax
c010355d:	e8 ea 43 00 00       	call   c010794c <tlb_invalidate>
c0103562:	83 c4 10             	add    $0x10,%esp
c0103565:	e9 88 00 00 00       	jmp    c01035f2 <_enclock_swap_out_victim+0x199>
        } else {
            // cprintf("now a == 0\n");
            if (*ptep & PTE_D) {
c010356a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010356d:	8b 00                	mov    (%eax),%eax
c010356f:	83 e0 40             	and    $0x40,%eax
c0103572:	85 c0                	test   %eax,%eax
c0103574:	74 63                	je     c01035d9 <_enclock_swap_out_victim+0x180>
                if (swapfs_write((page->pra_vaddr / PGSIZE + 1) << 8, page) == 0) {
c0103576:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103579:	8b 40 1c             	mov    0x1c(%eax),%eax
c010357c:	c1 e8 0c             	shr    $0xc,%eax
c010357f:	83 c0 01             	add    $0x1,%eax
c0103582:	c1 e0 08             	shl    $0x8,%eax
c0103585:	83 ec 08             	sub    $0x8,%esp
c0103588:	ff 75 dc             	pushl  -0x24(%ebp)
c010358b:	50                   	push   %eax
c010358c:	e8 92 50 00 00       	call   c0108623 <swapfs_write>
c0103591:	83 c4 10             	add    $0x10,%esp
c0103594:	85 c0                	test   %eax,%eax
c0103596:	75 17                	jne    c01035af <_enclock_swap_out_victim+0x156>
                    cprintf("write 0x%x to disk\n", page->pra_vaddr);
c0103598:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010359b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010359e:	83 ec 08             	sub    $0x8,%esp
c01035a1:	50                   	push   %eax
c01035a2:	68 cc a6 10 c0       	push   $0xc010a6cc
c01035a7:	e8 e6 cc ff ff       	call   c0100292 <cprintf>
c01035ac:	83 c4 10             	add    $0x10,%esp
                }
                // set dirty to 0
                *ptep = *ptep & ~PTE_D;
c01035af:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035b2:	8b 00                	mov    (%eax),%eax
c01035b4:	83 e0 bf             	and    $0xffffffbf,%eax
c01035b7:	89 c2                	mov    %eax,%edx
c01035b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035bc:	89 10                	mov    %edx,(%eax)
                tlb_invalidate(mm->pgdir, page->pra_vaddr);
c01035be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035c1:	8b 50 1c             	mov    0x1c(%eax),%edx
c01035c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01035c7:	8b 40 0c             	mov    0xc(%eax),%eax
c01035ca:	83 ec 08             	sub    $0x8,%esp
c01035cd:	52                   	push   %edx
c01035ce:	50                   	push   %eax
c01035cf:	e8 78 43 00 00       	call   c010794c <tlb_invalidate>
c01035d4:	83 c4 10             	add    $0x10,%esp
c01035d7:	eb 19                	jmp    c01035f2 <_enclock_swap_out_victim+0x199>
            } else {
                // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
                cprintf("victim is 0x%x\n", page->pra_vaddr);
c01035d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035dc:	8b 40 1c             	mov    0x1c(%eax),%eax
c01035df:	83 ec 08             	sub    $0x8,%esp
c01035e2:	50                   	push   %eax
c01035e3:	68 e0 a6 10 c0       	push   $0xc010a6e0
c01035e8:	e8 a5 cc ff ff       	call   c0100292 <cprintf>
c01035ed:	83 c4 10             	add    $0x10,%esp
                break;
c01035f0:	eb 1f                	jmp    c0103611 <_enclock_swap_out_victim+0x1b8>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
c01035f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103601:	8b 40 04             	mov    0x4(%eax),%eax
    /* Select the victim */
    /*LAB3 CHALLENGE 2: YOUR CODE*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
    int cnt = 0;
    while (le = list_next(le_prev)) {
c0103604:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103607:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010360b:	0f 85 b1 fe ff ff    	jne    c01034c2 <_enclock_swap_out_victim+0x69>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
    }
    assert(le != head);
c0103611:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103614:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103617:	75 16                	jne    c010362f <_enclock_swap_out_victim+0x1d6>
c0103619:	68 f0 a6 10 c0       	push   $0xc010a6f0
c010361e:	68 62 a6 10 c0       	push   $0xc010a662
c0103623:	6a 78                	push   $0x78
c0103625:	68 77 a6 10 c0       	push   $0xc010a677
c010362a:	e8 c9 cd ff ff       	call   c01003f8 <__panic>
c010362f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103632:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103638:	8b 40 04             	mov    0x4(%eax),%eax
c010363b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010363e:	8b 12                	mov    (%edx),%edx
c0103640:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103643:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103646:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103649:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010364c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010364f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103652:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103655:	89 10                	mov    %edx,(%eax)
    list_del(le);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(le, pra_page_link);
c0103657:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010365a:	83 e8 14             	sub    $0x14,%eax
c010365d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    assert(page != NULL);
c0103660:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103664:	75 16                	jne    c010367c <_enclock_swap_out_victim+0x223>
c0103666:	68 fb a6 10 c0       	push   $0xc010a6fb
c010366b:	68 62 a6 10 c0       	push   $0xc010a662
c0103670:	6a 7c                	push   $0x7c
c0103672:	68 77 a6 10 c0       	push   $0xc010a677
c0103677:	e8 7c cd ff ff       	call   c01003f8 <__panic>
    *ptr_page = page;
c010367c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010367f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103682:	89 10                	mov    %edx,(%eax)
    //(2)update clock
    *(((struct enclock_struct*) mm->sm_priv)->clock) = list_next(le_prev);
c0103684:	8b 45 08             	mov    0x8(%ebp),%eax
c0103687:	8b 40 14             	mov    0x14(%eax),%eax
c010368a:	8b 40 04             	mov    0x4(%eax),%eax
c010368d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103690:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103693:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103696:	8b 52 04             	mov    0x4(%edx),%edx
c0103699:	89 10                	mov    %edx,(%eax)
    return 0;
c010369b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01036a0:	c9                   	leave  
c01036a1:	c3                   	ret    

c01036a2 <_enclock_reset_pte>:

void
_enclock_reset_pte(pde_t* pgdir) {
c01036a2:	55                   	push   %ebp
c01036a3:	89 e5                	mov    %esp,%ebp
c01036a5:	83 ec 18             	sub    $0x18,%esp
    cprintf("PTEs resetting...\n");
c01036a8:	83 ec 0c             	sub    $0xc,%esp
c01036ab:	68 08 a7 10 c0       	push   $0xc010a708
c01036b0:	e8 dd cb ff ff       	call   c0100292 <cprintf>
c01036b5:	83 c4 10             	add    $0x10,%esp
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c01036b8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
c01036bf:	eb 4c                	jmp    c010370d <_enclock_reset_pte+0x6b>
        pte_t* ptep = get_pte(pgdir, va, 0);
c01036c1:	83 ec 04             	sub    $0x4,%esp
c01036c4:	6a 00                	push   $0x0
c01036c6:	ff 75 f4             	pushl  -0xc(%ebp)
c01036c9:	ff 75 08             	pushl  0x8(%ebp)
c01036cc:	e8 83 3f 00 00       	call   c0107654 <get_pte>
c01036d1:	83 c4 10             	add    $0x10,%esp
c01036d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        *ptep = *ptep & ~PTE_A;
c01036d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036da:	8b 00                	mov    (%eax),%eax
c01036dc:	83 e0 df             	and    $0xffffffdf,%eax
c01036df:	89 c2                	mov    %eax,%edx
c01036e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e4:	89 10                	mov    %edx,(%eax)
        *ptep = *ptep & ~PTE_D;
c01036e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e9:	8b 00                	mov    (%eax),%eax
c01036eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01036ee:	89 c2                	mov    %eax,%edx
c01036f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036f3:	89 10                	mov    %edx,(%eax)
        tlb_invalidate(pgdir, va);
c01036f5:	83 ec 08             	sub    $0x8,%esp
c01036f8:	ff 75 f4             	pushl  -0xc(%ebp)
c01036fb:	ff 75 08             	pushl  0x8(%ebp)
c01036fe:	e8 49 42 00 00       	call   c010794c <tlb_invalidate>
c0103703:	83 c4 10             	add    $0x10,%esp
}

void
_enclock_reset_pte(pde_t* pgdir) {
    cprintf("PTEs resetting...\n");
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c0103706:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010370d:	81 7d f4 00 40 00 00 	cmpl   $0x4000,-0xc(%ebp)
c0103714:	76 ab                	jbe    c01036c1 <_enclock_reset_pte+0x1f>
        pte_t* ptep = get_pte(pgdir, va, 0);
        *ptep = *ptep & ~PTE_A;
        *ptep = *ptep & ~PTE_D;
        tlb_invalidate(pgdir, va);
    }
    cprintf("PTEs reseted!\n");
c0103716:	83 ec 0c             	sub    $0xc,%esp
c0103719:	68 1b a7 10 c0       	push   $0xc010a71b
c010371e:	e8 6f cb ff ff       	call   c0100292 <cprintf>
c0103723:	83 c4 10             	add    $0x10,%esp
}
c0103726:	90                   	nop
c0103727:	c9                   	leave  
c0103728:	c3                   	ret    

c0103729 <_enclock_print_pte>:

void
_enclock_print_pte(pte_t* ptep, unsigned int va) {
c0103729:	55                   	push   %ebp
c010372a:	89 e5                	mov    %esp,%ebp
c010372c:	83 ec 08             	sub    $0x8,%esp
    cprintf("va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", va, *ptep, *ptep & PTE_A, *ptep & PTE_D);
c010372f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103732:	8b 00                	mov    (%eax),%eax
c0103734:	83 e0 40             	and    $0x40,%eax
c0103737:	89 c1                	mov    %eax,%ecx
c0103739:	8b 45 08             	mov    0x8(%ebp),%eax
c010373c:	8b 00                	mov    (%eax),%eax
c010373e:	83 e0 20             	and    $0x20,%eax
c0103741:	89 c2                	mov    %eax,%edx
c0103743:	8b 45 08             	mov    0x8(%ebp),%eax
c0103746:	8b 00                	mov    (%eax),%eax
c0103748:	83 ec 0c             	sub    $0xc,%esp
c010374b:	51                   	push   %ecx
c010374c:	52                   	push   %edx
c010374d:	50                   	push   %eax
c010374e:	ff 75 0c             	pushl  0xc(%ebp)
c0103751:	68 2c a7 10 c0       	push   $0xc010a72c
c0103756:	e8 37 cb ff ff       	call   c0100292 <cprintf>
c010375b:	83 c4 20             	add    $0x20,%esp
}
c010375e:	90                   	nop
c010375f:	c9                   	leave  
c0103760:	c3                   	ret    

c0103761 <_enclock_check_swap>:

static int
_enclock_check_swap(void) {
c0103761:	55                   	push   %ebp
c0103762:	89 e5                	mov    %esp,%ebp
c0103764:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103767:	0f 20 d8             	mov    %cr3,%eax
c010376a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return cr3;
c010376d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    _enclock_reset_pte(KADDR(((pde_t *)rcr3())));
c0103770:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103776:	c1 e8 0c             	shr    $0xc,%eax
c0103779:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010377c:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0103781:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103784:	72 17                	jb     c010379d <_enclock_check_swap+0x3c>
c0103786:	ff 75 f4             	pushl  -0xc(%ebp)
c0103789:	68 54 a7 10 c0       	push   $0xc010a754
c010378e:	68 96 00 00 00       	push   $0x96
c0103793:	68 77 a6 10 c0       	push   $0xc010a677
c0103798:	e8 5b cc ff ff       	call   c01003f8 <__panic>
c010379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037a0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037a5:	83 ec 0c             	sub    $0xc,%esp
c01037a8:	50                   	push   %eax
c01037a9:	e8 f4 fe ff ff       	call   c01036a2 <_enclock_reset_pte>
c01037ae:	83 c4 10             	add    $0x10,%esp
    cprintf("read Virt Page c in enclock_check_swap\n");
c01037b1:	83 ec 0c             	sub    $0xc,%esp
c01037b4:	68 78 a7 10 c0       	push   $0xc010a778
c01037b9:	e8 d4 ca ff ff       	call   c0100292 <cprintf>
c01037be:	83 c4 10             	add    $0x10,%esp
    unsigned char tmp = *(unsigned char *)0x3000;
c01037c1:	b8 00 30 00 00       	mov    $0x3000,%eax
c01037c6:	0f b6 00             	movzbl (%eax),%eax
c01037c9:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c01037cc:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01037d1:	83 f8 04             	cmp    $0x4,%eax
c01037d4:	74 19                	je     c01037ef <_enclock_check_swap+0x8e>
c01037d6:	68 a0 a7 10 c0       	push   $0xc010a7a0
c01037db:	68 62 a6 10 c0       	push   $0xc010a662
c01037e0:	68 99 00 00 00       	push   $0x99
c01037e5:	68 77 a6 10 c0       	push   $0xc010a677
c01037ea:	e8 09 cc ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c01037ef:	83 ec 0c             	sub    $0xc,%esp
c01037f2:	68 b0 a7 10 c0       	push   $0xc010a7b0
c01037f7:	e8 96 ca ff ff       	call   c0100292 <cprintf>
c01037fc:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01037ff:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103804:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0103807:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010380c:	83 f8 04             	cmp    $0x4,%eax
c010380f:	74 19                	je     c010382a <_enclock_check_swap+0xc9>
c0103811:	68 a0 a7 10 c0       	push   $0xc010a7a0
c0103816:	68 62 a6 10 c0       	push   $0xc010a662
c010381b:	68 9c 00 00 00       	push   $0x9c
c0103820:	68 77 a6 10 c0       	push   $0xc010a677
c0103825:	e8 ce cb ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c010382a:	83 ec 0c             	sub    $0xc,%esp
c010382d:	68 dc a7 10 c0       	push   $0xc010a7dc
c0103832:	e8 5b ca ff ff       	call   c0100292 <cprintf>
c0103837:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c010383a:	b8 00 40 00 00       	mov    $0x4000,%eax
c010383f:	0f b6 00             	movzbl (%eax),%eax
c0103842:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c0103845:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010384a:	83 f8 04             	cmp    $0x4,%eax
c010384d:	74 19                	je     c0103868 <_enclock_check_swap+0x107>
c010384f:	68 a0 a7 10 c0       	push   $0xc010a7a0
c0103854:	68 62 a6 10 c0       	push   $0xc010a662
c0103859:	68 9f 00 00 00       	push   $0x9f
c010385e:	68 77 a6 10 c0       	push   $0xc010a677
c0103863:	e8 90 cb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in enclock_check_swap\n");
c0103868:	83 ec 0c             	sub    $0xc,%esp
c010386b:	68 04 a8 10 c0       	push   $0xc010a804
c0103870:	e8 1d ca ff ff       	call   c0100292 <cprintf>
c0103875:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0103878:	b8 00 20 00 00       	mov    $0x2000,%eax
c010387d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0103880:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103885:	83 f8 04             	cmp    $0x4,%eax
c0103888:	74 19                	je     c01038a3 <_enclock_check_swap+0x142>
c010388a:	68 a0 a7 10 c0       	push   $0xc010a7a0
c010388f:	68 62 a6 10 c0       	push   $0xc010a662
c0103894:	68 a2 00 00 00       	push   $0xa2
c0103899:	68 77 a6 10 c0       	push   $0xc010a677
c010389e:	e8 55 cb ff ff       	call   c01003f8 <__panic>

    cprintf("write Virt Page e in enclock_check_swap\n");
c01038a3:	83 ec 0c             	sub    $0xc,%esp
c01038a6:	68 30 a8 10 c0       	push   $0xc010a830
c01038ab:	e8 e2 c9 ff ff       	call   c0100292 <cprintf>
c01038b0:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c01038b3:	b8 00 50 00 00       	mov    $0x5000,%eax
c01038b8:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01038bb:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01038c0:	83 f8 05             	cmp    $0x5,%eax
c01038c3:	74 19                	je     c01038de <_enclock_check_swap+0x17d>
c01038c5:	68 59 a8 10 c0       	push   $0xc010a859
c01038ca:	68 62 a6 10 c0       	push   $0xc010a662
c01038cf:	68 a6 00 00 00       	push   $0xa6
c01038d4:	68 77 a6 10 c0       	push   $0xc010a677
c01038d9:	e8 1a cb ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c01038de:	83 ec 0c             	sub    $0xc,%esp
c01038e1:	68 68 a8 10 c0       	push   $0xc010a868
c01038e6:	e8 a7 c9 ff ff       	call   c0100292 <cprintf>
c01038eb:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c01038ee:	b8 00 20 00 00       	mov    $0x2000,%eax
c01038f3:	0f b6 00             	movzbl (%eax),%eax
c01038f6:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c01038f9:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01038fe:	83 f8 05             	cmp    $0x5,%eax
c0103901:	74 19                	je     c010391c <_enclock_check_swap+0x1bb>
c0103903:	68 59 a8 10 c0       	push   $0xc010a859
c0103908:	68 62 a6 10 c0       	push   $0xc010a662
c010390d:	68 a9 00 00 00       	push   $0xa9
c0103912:	68 77 a6 10 c0       	push   $0xc010a677
c0103917:	e8 dc ca ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c010391c:	83 ec 0c             	sub    $0xc,%esp
c010391f:	68 b0 a7 10 c0       	push   $0xc010a7b0
c0103924:	e8 69 c9 ff ff       	call   c0100292 <cprintf>
c0103929:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c010392c:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103931:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==5);
c0103934:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103939:	83 f8 05             	cmp    $0x5,%eax
c010393c:	74 19                	je     c0103957 <_enclock_check_swap+0x1f6>
c010393e:	68 59 a8 10 c0       	push   $0xc010a859
c0103943:	68 62 a6 10 c0       	push   $0xc010a662
c0103948:	68 ac 00 00 00       	push   $0xac
c010394d:	68 77 a6 10 c0       	push   $0xc010a677
c0103952:	e8 a1 ca ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c0103957:	83 ec 0c             	sub    $0xc,%esp
c010395a:	68 68 a8 10 c0       	push   $0xc010a868
c010395f:	e8 2e c9 ff ff       	call   c0100292 <cprintf>
c0103964:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c0103967:	b8 00 20 00 00       	mov    $0x2000,%eax
c010396c:	0f b6 00             	movzbl (%eax),%eax
c010396f:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c0103972:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103977:	83 f8 05             	cmp    $0x5,%eax
c010397a:	74 19                	je     c0103995 <_enclock_check_swap+0x234>
c010397c:	68 59 a8 10 c0       	push   $0xc010a859
c0103981:	68 62 a6 10 c0       	push   $0xc010a662
c0103986:	68 af 00 00 00       	push   $0xaf
c010398b:	68 77 a6 10 c0       	push   $0xc010a677
c0103990:	e8 63 ca ff ff       	call   c01003f8 <__panic>

    cprintf("read Virt Page c in enclock_check_swap\n");
c0103995:	83 ec 0c             	sub    $0xc,%esp
c0103998:	68 78 a7 10 c0       	push   $0xc010a778
c010399d:	e8 f0 c8 ff ff       	call   c0100292 <cprintf>
c01039a2:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x3000;
c01039a5:	b8 00 30 00 00       	mov    $0x3000,%eax
c01039aa:	0f b6 00             	movzbl (%eax),%eax
c01039ad:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==6);
c01039b0:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01039b5:	83 f8 06             	cmp    $0x6,%eax
c01039b8:	74 19                	je     c01039d3 <_enclock_check_swap+0x272>
c01039ba:	68 90 a8 10 c0       	push   $0xc010a890
c01039bf:	68 62 a6 10 c0       	push   $0xc010a662
c01039c4:	68 b3 00 00 00       	push   $0xb3
c01039c9:	68 77 a6 10 c0       	push   $0xc010a677
c01039ce:	e8 25 ca ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c01039d3:	83 ec 0c             	sub    $0xc,%esp
c01039d6:	68 dc a7 10 c0       	push   $0xc010a7dc
c01039db:	e8 b2 c8 ff ff       	call   c0100292 <cprintf>
c01039e0:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c01039e3:	b8 00 40 00 00       	mov    $0x4000,%eax
c01039e8:	0f b6 00             	movzbl (%eax),%eax
c01039eb:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==7);
c01039ee:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01039f3:	83 f8 07             	cmp    $0x7,%eax
c01039f6:	74 19                	je     c0103a11 <_enclock_check_swap+0x2b0>
c01039f8:	68 9f a8 10 c0       	push   $0xc010a89f
c01039fd:	68 62 a6 10 c0       	push   $0xc010a662
c0103a02:	68 b6 00 00 00       	push   $0xb6
c0103a07:	68 77 a6 10 c0       	push   $0xc010a677
c0103a0c:	e8 e7 c9 ff ff       	call   c01003f8 <__panic>
    return 0;
c0103a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a16:	c9                   	leave  
c0103a17:	c3                   	ret    

c0103a18 <_enclock_init>:


static int
_enclock_init(void)
{
c0103a18:	55                   	push   %ebp
c0103a19:	89 e5                	mov    %esp,%ebp
    return 0;
c0103a1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a20:	5d                   	pop    %ebp
c0103a21:	c3                   	ret    

c0103a22 <_enclock_set_unswappable>:

static int
_enclock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0103a22:	55                   	push   %ebp
c0103a23:	89 e5                	mov    %esp,%ebp
    return 0;
c0103a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a2a:	5d                   	pop    %ebp
c0103a2b:	c3                   	ret    

c0103a2c <_enclock_tick_event>:

static int
_enclock_tick_event(struct mm_struct *mm)
{ return 0; }
c0103a2c:	55                   	push   %ebp
c0103a2d:	89 e5                	mov    %esp,%ebp
c0103a2f:	b8 00 00 00 00       	mov    $0x0,%eax
c0103a34:	5d                   	pop    %ebp
c0103a35:	c3                   	ret    

c0103a36 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a36:	55                   	push   %ebp
c0103a37:	89 e5                	mov    %esp,%ebp
c0103a39:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0103a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3f:	c1 e8 0c             	shr    $0xc,%eax
c0103a42:	89 c2                	mov    %eax,%edx
c0103a44:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0103a49:	39 c2                	cmp    %eax,%edx
c0103a4b:	72 14                	jb     c0103a61 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0103a4d:	83 ec 04             	sub    $0x4,%esp
c0103a50:	68 cc a8 10 c0       	push   $0xc010a8cc
c0103a55:	6a 5f                	push   $0x5f
c0103a57:	68 eb a8 10 c0       	push   $0xc010a8eb
c0103a5c:	e8 97 c9 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0103a61:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0103a66:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a69:	c1 ea 0c             	shr    $0xc,%edx
c0103a6c:	c1 e2 05             	shl    $0x5,%edx
c0103a6f:	01 d0                	add    %edx,%eax
}
c0103a71:	c9                   	leave  
c0103a72:	c3                   	ret    

c0103a73 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0103a73:	55                   	push   %ebp
c0103a74:	89 e5                	mov    %esp,%ebp
c0103a76:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0103a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a81:	83 ec 0c             	sub    $0xc,%esp
c0103a84:	50                   	push   %eax
c0103a85:	e8 ac ff ff ff       	call   c0103a36 <pa2page>
c0103a8a:	83 c4 10             	add    $0x10,%esp
}
c0103a8d:	c9                   	leave  
c0103a8e:	c3                   	ret    

c0103a8f <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0103a8f:	55                   	push   %ebp
c0103a90:	89 e5                	mov    %esp,%ebp
c0103a92:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0103a95:	83 ec 0c             	sub    $0xc,%esp
c0103a98:	6a 18                	push   $0x18
c0103a9a:	e8 74 16 00 00       	call   c0105113 <kmalloc>
c0103a9f:	83 c4 10             	add    $0x10,%esp
c0103aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0103aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103aa9:	74 5b                	je     c0103b06 <mm_create+0x77>
        list_init(&(mm->mmap_list));
c0103aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ab4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103ab7:	89 50 04             	mov    %edx,0x4(%eax)
c0103aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103abd:	8b 50 04             	mov    0x4(%eax),%edx
c0103ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ac3:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0103ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ac8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0103ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103adc:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0103ae3:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c0103ae8:	85 c0                	test   %eax,%eax
c0103aea:	74 10                	je     c0103afc <mm_create+0x6d>
c0103aec:	83 ec 0c             	sub    $0xc,%esp
c0103aef:	ff 75 f4             	pushl  -0xc(%ebp)
c0103af2:	e8 7c 18 00 00       	call   c0105373 <swap_init_mm>
c0103af7:	83 c4 10             	add    $0x10,%esp
c0103afa:	eb 0a                	jmp    c0103b06 <mm_create+0x77>
        else mm->sm_priv = NULL;
c0103afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aff:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0103b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103b09:	c9                   	leave  
c0103b0a:	c3                   	ret    

c0103b0b <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0103b0b:	55                   	push   %ebp
c0103b0c:	89 e5                	mov    %esp,%ebp
c0103b0e:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103b11:	83 ec 0c             	sub    $0xc,%esp
c0103b14:	6a 18                	push   $0x18
c0103b16:	e8 f8 15 00 00       	call   c0105113 <kmalloc>
c0103b1b:	83 c4 10             	add    $0x10,%esp
c0103b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0103b21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b25:	74 1b                	je     c0103b42 <vma_create+0x37>
        vma->vm_start = vm_start;
c0103b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b2a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b2d:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0103b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b33:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b36:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0103b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b3c:	8b 55 10             	mov    0x10(%ebp),%edx
c0103b3f:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0103b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103b45:	c9                   	leave  
c0103b46:	c3                   	ret    

c0103b47 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0103b47:	55                   	push   %ebp
c0103b48:	89 e5                	mov    %esp,%ebp
c0103b4a:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0103b4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0103b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b58:	0f 84 95 00 00 00    	je     c0103bf3 <find_vma+0xac>
        vma = mm->mmap_cache;
c0103b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b61:	8b 40 08             	mov    0x8(%eax),%eax
c0103b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0103b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103b6b:	74 16                	je     c0103b83 <find_vma+0x3c>
c0103b6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b70:	8b 40 04             	mov    0x4(%eax),%eax
c0103b73:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b76:	77 0b                	ja     c0103b83 <find_vma+0x3c>
c0103b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b7b:	8b 40 08             	mov    0x8(%eax),%eax
c0103b7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b81:	77 61                	ja     c0103be4 <find_vma+0x9d>
                bool found = 0;
c0103b83:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0103b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103b96:	eb 28                	jmp    c0103bc0 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0103b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b9b:	83 e8 10             	sub    $0x10,%eax
c0103b9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ba4:	8b 40 04             	mov    0x4(%eax),%eax
c0103ba7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103baa:	77 14                	ja     c0103bc0 <find_vma+0x79>
c0103bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103baf:	8b 40 08             	mov    0x8(%eax),%eax
c0103bb2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103bb5:	76 09                	jbe    c0103bc0 <find_vma+0x79>
                        found = 1;
c0103bb7:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103bbe:	eb 17                	jmp    c0103bd7 <find_vma+0x90>
c0103bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bc9:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0103bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bd2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103bd5:	75 c1                	jne    c0103b98 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0103bd7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103bdb:	75 07                	jne    c0103be4 <find_vma+0x9d>
                    vma = NULL;
c0103bdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103be4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103be8:	74 09                	je     c0103bf3 <find_vma+0xac>
            mm->mmap_cache = vma;
c0103bea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bed:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103bf0:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103bf6:	c9                   	leave  
c0103bf7:	c3                   	ret    

c0103bf8 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0103bf8:	55                   	push   %ebp
c0103bf9:	89 e5                	mov    %esp,%ebp
c0103bfb:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
c0103bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c01:	8b 50 04             	mov    0x4(%eax),%edx
c0103c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c07:	8b 40 08             	mov    0x8(%eax),%eax
c0103c0a:	39 c2                	cmp    %eax,%edx
c0103c0c:	72 16                	jb     c0103c24 <check_vma_overlap+0x2c>
c0103c0e:	68 f9 a8 10 c0       	push   $0xc010a8f9
c0103c13:	68 17 a9 10 c0       	push   $0xc010a917
c0103c18:	6a 68                	push   $0x68
c0103c1a:	68 2c a9 10 c0       	push   $0xc010a92c
c0103c1f:	e8 d4 c7 ff ff       	call   c01003f8 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c27:	8b 50 08             	mov    0x8(%eax),%edx
c0103c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c2d:	8b 40 04             	mov    0x4(%eax),%eax
c0103c30:	39 c2                	cmp    %eax,%edx
c0103c32:	76 16                	jbe    c0103c4a <check_vma_overlap+0x52>
c0103c34:	68 3c a9 10 c0       	push   $0xc010a93c
c0103c39:	68 17 a9 10 c0       	push   $0xc010a917
c0103c3e:	6a 69                	push   $0x69
c0103c40:	68 2c a9 10 c0       	push   $0xc010a92c
c0103c45:	e8 ae c7 ff ff       	call   c01003f8 <__panic>
    assert(next->vm_start < next->vm_end);
c0103c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c4d:	8b 50 04             	mov    0x4(%eax),%edx
c0103c50:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c53:	8b 40 08             	mov    0x8(%eax),%eax
c0103c56:	39 c2                	cmp    %eax,%edx
c0103c58:	72 16                	jb     c0103c70 <check_vma_overlap+0x78>
c0103c5a:	68 5b a9 10 c0       	push   $0xc010a95b
c0103c5f:	68 17 a9 10 c0       	push   $0xc010a917
c0103c64:	6a 6a                	push   $0x6a
c0103c66:	68 2c a9 10 c0       	push   $0xc010a92c
c0103c6b:	e8 88 c7 ff ff       	call   c01003f8 <__panic>
}
c0103c70:	90                   	nop
c0103c71:	c9                   	leave  
c0103c72:	c3                   	ret    

c0103c73 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103c73:	55                   	push   %ebp
c0103c74:	89 e5                	mov    %esp,%ebp
c0103c76:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
c0103c79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c7c:	8b 50 04             	mov    0x4(%eax),%edx
c0103c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c82:	8b 40 08             	mov    0x8(%eax),%eax
c0103c85:	39 c2                	cmp    %eax,%edx
c0103c87:	72 16                	jb     c0103c9f <insert_vma_struct+0x2c>
c0103c89:	68 79 a9 10 c0       	push   $0xc010a979
c0103c8e:	68 17 a9 10 c0       	push   $0xc010a917
c0103c93:	6a 71                	push   $0x71
c0103c95:	68 2c a9 10 c0       	push   $0xc010a92c
c0103c9a:	e8 59 c7 ff ff       	call   c01003f8 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ca2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0103cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0103cb1:	eb 1f                	jmp    c0103cd2 <insert_vma_struct+0x5f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb6:	83 e8 10             	sub    $0x10,%eax
c0103cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0103cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cbf:	8b 50 04             	mov    0x4(%eax),%edx
c0103cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103cc5:	8b 40 04             	mov    0x4(%eax),%eax
c0103cc8:	39 c2                	cmp    %eax,%edx
c0103cca:	77 1f                	ja     c0103ceb <insert_vma_struct+0x78>
                break;
            }
            le_prev = le;
c0103ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103cd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cdb:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0103cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ce4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103ce7:	75 ca                	jne    c0103cb3 <insert_vma_struct+0x40>
c0103ce9:	eb 01                	jmp    c0103cec <insert_vma_struct+0x79>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
c0103ceb:	90                   	nop
c0103cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103cf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cf5:	8b 40 04             	mov    0x4(%eax),%eax
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0103cf8:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0103cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cfe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d01:	74 15                	je     c0103d18 <insert_vma_struct+0xa5>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d06:	83 e8 10             	sub    $0x10,%eax
c0103d09:	83 ec 08             	sub    $0x8,%esp
c0103d0c:	ff 75 0c             	pushl  0xc(%ebp)
c0103d0f:	50                   	push   %eax
c0103d10:	e8 e3 fe ff ff       	call   c0103bf8 <check_vma_overlap>
c0103d15:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
c0103d18:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d1b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d1e:	74 15                	je     c0103d35 <insert_vma_struct+0xc2>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103d20:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d23:	83 e8 10             	sub    $0x10,%eax
c0103d26:	83 ec 08             	sub    $0x8,%esp
c0103d29:	50                   	push   %eax
c0103d2a:	ff 75 0c             	pushl  0xc(%ebp)
c0103d2d:	e8 c6 fe ff ff       	call   c0103bf8 <check_vma_overlap>
c0103d32:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
c0103d35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d38:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d3b:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d40:	8d 50 10             	lea    0x10(%eax),%edx
c0103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d49:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d4f:	8b 40 04             	mov    0x4(%eax),%eax
c0103d52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d55:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103d58:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103d5b:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103d5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103d61:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d64:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d67:	89 10                	mov    %edx,(%eax)
c0103d69:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d6c:	8b 10                	mov    (%eax),%edx
c0103d6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d71:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103d74:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d77:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103d7a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103d7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d80:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103d83:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103d85:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d88:	8b 40 10             	mov    0x10(%eax),%eax
c0103d8b:	8d 50 01             	lea    0x1(%eax),%edx
c0103d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d91:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103d94:	90                   	nop
c0103d95:	c9                   	leave  
c0103d96:	c3                   	ret    

c0103d97 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0103d97:	55                   	push   %ebp
c0103d98:	89 e5                	mov    %esp,%ebp
c0103d9a:	83 ec 28             	sub    $0x28,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103d9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103da3:	eb 3a                	jmp    c0103ddf <mm_destroy+0x48>
c0103da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103da8:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dae:	8b 40 04             	mov    0x4(%eax),%eax
c0103db1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103db4:	8b 12                	mov    (%edx),%edx
c0103db6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0103db9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103dc2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103dc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103dcb:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0103dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dd0:	83 e8 10             	sub    $0x10,%eax
c0103dd3:	83 ec 0c             	sub    $0xc,%esp
c0103dd6:	50                   	push   %eax
c0103dd7:	e8 4f 13 00 00       	call   c010512b <kfree>
c0103ddc:	83 c4 10             	add    $0x10,%esp
c0103ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103de5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103de8:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0103deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103df1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103df4:	75 af                	jne    c0103da5 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0103df6:	83 ec 0c             	sub    $0xc,%esp
c0103df9:	ff 75 08             	pushl  0x8(%ebp)
c0103dfc:	e8 2a 13 00 00       	call   c010512b <kfree>
c0103e01:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
c0103e04:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0103e0b:	90                   	nop
c0103e0c:	c9                   	leave  
c0103e0d:	c3                   	ret    

c0103e0e <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0103e0e:	55                   	push   %ebp
c0103e0f:	89 e5                	mov    %esp,%ebp
c0103e11:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103e14:	e8 03 00 00 00       	call   c0103e1c <check_vmm>
}
c0103e19:	90                   	nop
c0103e1a:	c9                   	leave  
c0103e1b:	c3                   	ret    

c0103e1c <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0103e1c:	55                   	push   %ebp
c0103e1d:	89 e5                	mov    %esp,%ebp
c0103e1f:	83 ec 18             	sub    $0x18,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e22:	e8 62 32 00 00       	call   c0107089 <nr_free_pages>
c0103e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103e2a:	e8 18 00 00 00       	call   c0103e47 <check_vma_struct>
    check_pgfault();
c0103e2f:	e8 10 04 00 00       	call   c0104244 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0103e34:	83 ec 0c             	sub    $0xc,%esp
c0103e37:	68 95 a9 10 c0       	push   $0xc010a995
c0103e3c:	e8 51 c4 ff ff       	call   c0100292 <cprintf>
c0103e41:	83 c4 10             	add    $0x10,%esp
}
c0103e44:	90                   	nop
c0103e45:	c9                   	leave  
c0103e46:	c3                   	ret    

c0103e47 <check_vma_struct>:

static void
check_vma_struct(void) {
c0103e47:	55                   	push   %ebp
c0103e48:	89 e5                	mov    %esp,%ebp
c0103e4a:	83 ec 58             	sub    $0x58,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e4d:	e8 37 32 00 00       	call   c0107089 <nr_free_pages>
c0103e52:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0103e55:	e8 35 fc ff ff       	call   c0103a8f <mm_create>
c0103e5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103e5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103e61:	75 19                	jne    c0103e7c <check_vma_struct+0x35>
c0103e63:	68 ad a9 10 c0       	push   $0xc010a9ad
c0103e68:	68 17 a9 10 c0       	push   $0xc010a917
c0103e6d:	68 b2 00 00 00       	push   $0xb2
c0103e72:	68 2c a9 10 c0       	push   $0xc010a92c
c0103e77:	e8 7c c5 ff ff       	call   c01003f8 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103e7c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0103e83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e86:	89 d0                	mov    %edx,%eax
c0103e88:	c1 e0 02             	shl    $0x2,%eax
c0103e8b:	01 d0                	add    %edx,%eax
c0103e8d:	01 c0                	add    %eax,%eax
c0103e8f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0103e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103e98:	eb 5f                	jmp    c0103ef9 <check_vma_struct+0xb2>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e9d:	89 d0                	mov    %edx,%eax
c0103e9f:	c1 e0 02             	shl    $0x2,%eax
c0103ea2:	01 d0                	add    %edx,%eax
c0103ea4:	83 c0 02             	add    $0x2,%eax
c0103ea7:	89 c1                	mov    %eax,%ecx
c0103ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103eac:	89 d0                	mov    %edx,%eax
c0103eae:	c1 e0 02             	shl    $0x2,%eax
c0103eb1:	01 d0                	add    %edx,%eax
c0103eb3:	83 ec 04             	sub    $0x4,%esp
c0103eb6:	6a 00                	push   $0x0
c0103eb8:	51                   	push   %ecx
c0103eb9:	50                   	push   %eax
c0103eba:	e8 4c fc ff ff       	call   c0103b0b <vma_create>
c0103ebf:	83 c4 10             	add    $0x10,%esp
c0103ec2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0103ec5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103ec9:	75 19                	jne    c0103ee4 <check_vma_struct+0x9d>
c0103ecb:	68 b8 a9 10 c0       	push   $0xc010a9b8
c0103ed0:	68 17 a9 10 c0       	push   $0xc010a917
c0103ed5:	68 b9 00 00 00       	push   $0xb9
c0103eda:	68 2c a9 10 c0       	push   $0xc010a92c
c0103edf:	e8 14 c5 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103ee4:	83 ec 08             	sub    $0x8,%esp
c0103ee7:	ff 75 dc             	pushl  -0x24(%ebp)
c0103eea:	ff 75 e8             	pushl  -0x18(%ebp)
c0103eed:	e8 81 fd ff ff       	call   c0103c73 <insert_vma_struct>
c0103ef2:	83 c4 10             	add    $0x10,%esp
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0103ef5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103ef9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103efd:	7f 9b                	jg     c0103e9a <check_vma_struct+0x53>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103eff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f02:	83 c0 01             	add    $0x1,%eax
c0103f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103f08:	eb 5f                	jmp    c0103f69 <check_vma_struct+0x122>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f0d:	89 d0                	mov    %edx,%eax
c0103f0f:	c1 e0 02             	shl    $0x2,%eax
c0103f12:	01 d0                	add    %edx,%eax
c0103f14:	83 c0 02             	add    $0x2,%eax
c0103f17:	89 c1                	mov    %eax,%ecx
c0103f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f1c:	89 d0                	mov    %edx,%eax
c0103f1e:	c1 e0 02             	shl    $0x2,%eax
c0103f21:	01 d0                	add    %edx,%eax
c0103f23:	83 ec 04             	sub    $0x4,%esp
c0103f26:	6a 00                	push   $0x0
c0103f28:	51                   	push   %ecx
c0103f29:	50                   	push   %eax
c0103f2a:	e8 dc fb ff ff       	call   c0103b0b <vma_create>
c0103f2f:	83 c4 10             	add    $0x10,%esp
c0103f32:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0103f35:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103f39:	75 19                	jne    c0103f54 <check_vma_struct+0x10d>
c0103f3b:	68 b8 a9 10 c0       	push   $0xc010a9b8
c0103f40:	68 17 a9 10 c0       	push   $0xc010a917
c0103f45:	68 bf 00 00 00       	push   $0xbf
c0103f4a:	68 2c a9 10 c0       	push   $0xc010a92c
c0103f4f:	e8 a4 c4 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103f54:	83 ec 08             	sub    $0x8,%esp
c0103f57:	ff 75 d8             	pushl  -0x28(%ebp)
c0103f5a:	ff 75 e8             	pushl  -0x18(%ebp)
c0103f5d:	e8 11 fd ff ff       	call   c0103c73 <insert_vma_struct>
c0103f62:	83 c4 10             	add    $0x10,%esp
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103f65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f6c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103f6f:	7e 99                	jle    c0103f0a <check_vma_struct+0xc3>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0103f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f74:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103f77:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f7a:	8b 40 04             	mov    0x4(%eax),%eax
c0103f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103f80:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103f87:	e9 81 00 00 00       	jmp    c010400d <check_vma_struct+0x1c6>
        assert(le != &(mm->mmap_list));
c0103f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103f92:	75 19                	jne    c0103fad <check_vma_struct+0x166>
c0103f94:	68 c4 a9 10 c0       	push   $0xc010a9c4
c0103f99:	68 17 a9 10 c0       	push   $0xc010a917
c0103f9e:	68 c6 00 00 00       	push   $0xc6
c0103fa3:	68 2c a9 10 c0       	push   $0xc010a92c
c0103fa8:	e8 4b c4 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fb0:	83 e8 10             	sub    $0x10,%eax
c0103fb3:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103fb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fb9:	8b 48 04             	mov    0x4(%eax),%ecx
c0103fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103fbf:	89 d0                	mov    %edx,%eax
c0103fc1:	c1 e0 02             	shl    $0x2,%eax
c0103fc4:	01 d0                	add    %edx,%eax
c0103fc6:	39 c1                	cmp    %eax,%ecx
c0103fc8:	75 17                	jne    c0103fe1 <check_vma_struct+0x19a>
c0103fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fcd:	8b 48 08             	mov    0x8(%eax),%ecx
c0103fd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103fd3:	89 d0                	mov    %edx,%eax
c0103fd5:	c1 e0 02             	shl    $0x2,%eax
c0103fd8:	01 d0                	add    %edx,%eax
c0103fda:	83 c0 02             	add    $0x2,%eax
c0103fdd:	39 c1                	cmp    %eax,%ecx
c0103fdf:	74 19                	je     c0103ffa <check_vma_struct+0x1b3>
c0103fe1:	68 dc a9 10 c0       	push   $0xc010a9dc
c0103fe6:	68 17 a9 10 c0       	push   $0xc010a917
c0103feb:	68 c8 00 00 00       	push   $0xc8
c0103ff0:	68 2c a9 10 c0       	push   $0xc010a92c
c0103ff5:	e8 fe c3 ff ff       	call   c01003f8 <__panic>
c0103ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ffd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104000:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104003:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104006:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0104009:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010400d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104010:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104013:	0f 8e 73 ff ff ff    	jle    c0103f8c <check_vma_struct+0x145>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0104019:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0104020:	e9 80 01 00 00       	jmp    c01041a5 <check_vma_struct+0x35e>
        struct vma_struct *vma1 = find_vma(mm, i);
c0104025:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104028:	83 ec 08             	sub    $0x8,%esp
c010402b:	50                   	push   %eax
c010402c:	ff 75 e8             	pushl  -0x18(%ebp)
c010402f:	e8 13 fb ff ff       	call   c0103b47 <find_vma>
c0104034:	83 c4 10             	add    $0x10,%esp
c0104037:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c010403a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010403e:	75 19                	jne    c0104059 <check_vma_struct+0x212>
c0104040:	68 11 aa 10 c0       	push   $0xc010aa11
c0104045:	68 17 a9 10 c0       	push   $0xc010a917
c010404a:	68 ce 00 00 00       	push   $0xce
c010404f:	68 2c a9 10 c0       	push   $0xc010a92c
c0104054:	e8 9f c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0104059:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010405c:	83 c0 01             	add    $0x1,%eax
c010405f:	83 ec 08             	sub    $0x8,%esp
c0104062:	50                   	push   %eax
c0104063:	ff 75 e8             	pushl  -0x18(%ebp)
c0104066:	e8 dc fa ff ff       	call   c0103b47 <find_vma>
c010406b:	83 c4 10             	add    $0x10,%esp
c010406e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c0104071:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104075:	75 19                	jne    c0104090 <check_vma_struct+0x249>
c0104077:	68 1e aa 10 c0       	push   $0xc010aa1e
c010407c:	68 17 a9 10 c0       	push   $0xc010a917
c0104081:	68 d0 00 00 00       	push   $0xd0
c0104086:	68 2c a9 10 c0       	push   $0xc010a92c
c010408b:	e8 68 c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0104090:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104093:	83 c0 02             	add    $0x2,%eax
c0104096:	83 ec 08             	sub    $0x8,%esp
c0104099:	50                   	push   %eax
c010409a:	ff 75 e8             	pushl  -0x18(%ebp)
c010409d:	e8 a5 fa ff ff       	call   c0103b47 <find_vma>
c01040a2:	83 c4 10             	add    $0x10,%esp
c01040a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c01040a8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01040ac:	74 19                	je     c01040c7 <check_vma_struct+0x280>
c01040ae:	68 2b aa 10 c0       	push   $0xc010aa2b
c01040b3:	68 17 a9 10 c0       	push   $0xc010a917
c01040b8:	68 d2 00 00 00       	push   $0xd2
c01040bd:	68 2c a9 10 c0       	push   $0xc010a92c
c01040c2:	e8 31 c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01040c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040ca:	83 c0 03             	add    $0x3,%eax
c01040cd:	83 ec 08             	sub    $0x8,%esp
c01040d0:	50                   	push   %eax
c01040d1:	ff 75 e8             	pushl  -0x18(%ebp)
c01040d4:	e8 6e fa ff ff       	call   c0103b47 <find_vma>
c01040d9:	83 c4 10             	add    $0x10,%esp
c01040dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c01040df:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01040e3:	74 19                	je     c01040fe <check_vma_struct+0x2b7>
c01040e5:	68 38 aa 10 c0       	push   $0xc010aa38
c01040ea:	68 17 a9 10 c0       	push   $0xc010a917
c01040ef:	68 d4 00 00 00       	push   $0xd4
c01040f4:	68 2c a9 10 c0       	push   $0xc010a92c
c01040f9:	e8 fa c2 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01040fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104101:	83 c0 04             	add    $0x4,%eax
c0104104:	83 ec 08             	sub    $0x8,%esp
c0104107:	50                   	push   %eax
c0104108:	ff 75 e8             	pushl  -0x18(%ebp)
c010410b:	e8 37 fa ff ff       	call   c0103b47 <find_vma>
c0104110:	83 c4 10             	add    $0x10,%esp
c0104113:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c0104116:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010411a:	74 19                	je     c0104135 <check_vma_struct+0x2ee>
c010411c:	68 45 aa 10 c0       	push   $0xc010aa45
c0104121:	68 17 a9 10 c0       	push   $0xc010a917
c0104126:	68 d6 00 00 00       	push   $0xd6
c010412b:	68 2c a9 10 c0       	push   $0xc010a92c
c0104130:	e8 c3 c2 ff ff       	call   c01003f8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0104135:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104138:	8b 50 04             	mov    0x4(%eax),%edx
c010413b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010413e:	39 c2                	cmp    %eax,%edx
c0104140:	75 10                	jne    c0104152 <check_vma_struct+0x30b>
c0104142:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104145:	8b 40 08             	mov    0x8(%eax),%eax
c0104148:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010414b:	83 c2 02             	add    $0x2,%edx
c010414e:	39 d0                	cmp    %edx,%eax
c0104150:	74 19                	je     c010416b <check_vma_struct+0x324>
c0104152:	68 54 aa 10 c0       	push   $0xc010aa54
c0104157:	68 17 a9 10 c0       	push   $0xc010a917
c010415c:	68 d8 00 00 00       	push   $0xd8
c0104161:	68 2c a9 10 c0       	push   $0xc010a92c
c0104166:	e8 8d c2 ff ff       	call   c01003f8 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010416b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010416e:	8b 50 04             	mov    0x4(%eax),%edx
c0104171:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104174:	39 c2                	cmp    %eax,%edx
c0104176:	75 10                	jne    c0104188 <check_vma_struct+0x341>
c0104178:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010417b:	8b 40 08             	mov    0x8(%eax),%eax
c010417e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104181:	83 c2 02             	add    $0x2,%edx
c0104184:	39 d0                	cmp    %edx,%eax
c0104186:	74 19                	je     c01041a1 <check_vma_struct+0x35a>
c0104188:	68 84 aa 10 c0       	push   $0xc010aa84
c010418d:	68 17 a9 10 c0       	push   $0xc010a917
c0104192:	68 d9 00 00 00       	push   $0xd9
c0104197:	68 2c a9 10 c0       	push   $0xc010a92c
c010419c:	e8 57 c2 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01041a1:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01041a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041a8:	89 d0                	mov    %edx,%eax
c01041aa:	c1 e0 02             	shl    $0x2,%eax
c01041ad:	01 d0                	add    %edx,%eax
c01041af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01041b2:	0f 8d 6d fe ff ff    	jge    c0104025 <check_vma_struct+0x1de>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01041b8:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01041bf:	eb 5c                	jmp    c010421d <check_vma_struct+0x3d6>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041c4:	83 ec 08             	sub    $0x8,%esp
c01041c7:	50                   	push   %eax
c01041c8:	ff 75 e8             	pushl  -0x18(%ebp)
c01041cb:	e8 77 f9 ff ff       	call   c0103b47 <find_vma>
c01041d0:	83 c4 10             	add    $0x10,%esp
c01041d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL ) {
c01041d6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01041da:	74 1e                	je     c01041fa <check_vma_struct+0x3b3>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01041dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041df:	8b 50 08             	mov    0x8(%eax),%edx
c01041e2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041e5:	8b 40 04             	mov    0x4(%eax),%eax
c01041e8:	52                   	push   %edx
c01041e9:	50                   	push   %eax
c01041ea:	ff 75 f4             	pushl  -0xc(%ebp)
c01041ed:	68 b4 aa 10 c0       	push   $0xc010aab4
c01041f2:	e8 9b c0 ff ff       	call   c0100292 <cprintf>
c01041f7:	83 c4 10             	add    $0x10,%esp
        }
        assert(vma_below_5 == NULL);
c01041fa:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01041fe:	74 19                	je     c0104219 <check_vma_struct+0x3d2>
c0104200:	68 d9 aa 10 c0       	push   $0xc010aad9
c0104205:	68 17 a9 10 c0       	push   $0xc010a917
c010420a:	68 e1 00 00 00       	push   $0xe1
c010420f:	68 2c a9 10 c0       	push   $0xc010a92c
c0104214:	e8 df c1 ff ff       	call   c01003f8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0104219:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010421d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104221:	79 9e                	jns    c01041c1 <check_vma_struct+0x37a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0104223:	83 ec 0c             	sub    $0xc,%esp
c0104226:	ff 75 e8             	pushl  -0x18(%ebp)
c0104229:	e8 69 fb ff ff       	call   c0103d97 <mm_destroy>
c010422e:	83 c4 10             	add    $0x10,%esp

    cprintf("check_vma_struct() succeeded!\n");
c0104231:	83 ec 0c             	sub    $0xc,%esp
c0104234:	68 f0 aa 10 c0       	push   $0xc010aaf0
c0104239:	e8 54 c0 ff ff       	call   c0100292 <cprintf>
c010423e:	83 c4 10             	add    $0x10,%esp
}
c0104241:	90                   	nop
c0104242:	c9                   	leave  
c0104243:	c3                   	ret    

c0104244 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0104244:	55                   	push   %ebp
c0104245:	89 e5                	mov    %esp,%ebp
c0104247:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010424a:	e8 3a 2e 00 00       	call   c0107089 <nr_free_pages>
c010424f:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0104252:	e8 38 f8 ff ff       	call   c0103a8f <mm_create>
c0104257:	a3 bc c0 12 c0       	mov    %eax,0xc012c0bc
    assert(check_mm_struct != NULL);
c010425c:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c0104261:	85 c0                	test   %eax,%eax
c0104263:	75 19                	jne    c010427e <check_pgfault+0x3a>
c0104265:	68 0f ab 10 c0       	push   $0xc010ab0f
c010426a:	68 17 a9 10 c0       	push   $0xc010a917
c010426f:	68 f1 00 00 00       	push   $0xf1
c0104274:	68 2c a9 10 c0       	push   $0xc010a92c
c0104279:	e8 7a c1 ff ff       	call   c01003f8 <__panic>

    struct mm_struct *mm = check_mm_struct;
c010427e:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c0104283:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0104286:	8b 15 60 6a 12 c0    	mov    0xc0126a60,%edx
c010428c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010428f:	89 50 0c             	mov    %edx,0xc(%eax)
c0104292:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104295:	8b 40 0c             	mov    0xc(%eax),%eax
c0104298:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c010429b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010429e:	8b 00                	mov    (%eax),%eax
c01042a0:	85 c0                	test   %eax,%eax
c01042a2:	74 19                	je     c01042bd <check_pgfault+0x79>
c01042a4:	68 27 ab 10 c0       	push   $0xc010ab27
c01042a9:	68 17 a9 10 c0       	push   $0xc010a917
c01042ae:	68 f5 00 00 00       	push   $0xf5
c01042b3:	68 2c a9 10 c0       	push   $0xc010a92c
c01042b8:	e8 3b c1 ff ff       	call   c01003f8 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01042bd:	83 ec 04             	sub    $0x4,%esp
c01042c0:	6a 02                	push   $0x2
c01042c2:	68 00 00 40 00       	push   $0x400000
c01042c7:	6a 00                	push   $0x0
c01042c9:	e8 3d f8 ff ff       	call   c0103b0b <vma_create>
c01042ce:	83 c4 10             	add    $0x10,%esp
c01042d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01042d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042d8:	75 19                	jne    c01042f3 <check_pgfault+0xaf>
c01042da:	68 b8 a9 10 c0       	push   $0xc010a9b8
c01042df:	68 17 a9 10 c0       	push   $0xc010a917
c01042e4:	68 f8 00 00 00       	push   $0xf8
c01042e9:	68 2c a9 10 c0       	push   $0xc010a92c
c01042ee:	e8 05 c1 ff ff       	call   c01003f8 <__panic>

    insert_vma_struct(mm, vma);
c01042f3:	83 ec 08             	sub    $0x8,%esp
c01042f6:	ff 75 e0             	pushl  -0x20(%ebp)
c01042f9:	ff 75 e8             	pushl  -0x18(%ebp)
c01042fc:	e8 72 f9 ff ff       	call   c0103c73 <insert_vma_struct>
c0104301:	83 c4 10             	add    $0x10,%esp

    uintptr_t addr = 0x100;
c0104304:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c010430b:	83 ec 08             	sub    $0x8,%esp
c010430e:	ff 75 dc             	pushl  -0x24(%ebp)
c0104311:	ff 75 e8             	pushl  -0x18(%ebp)
c0104314:	e8 2e f8 ff ff       	call   c0103b47 <find_vma>
c0104319:	83 c4 10             	add    $0x10,%esp
c010431c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010431f:	74 19                	je     c010433a <check_pgfault+0xf6>
c0104321:	68 35 ab 10 c0       	push   $0xc010ab35
c0104326:	68 17 a9 10 c0       	push   $0xc010a917
c010432b:	68 fd 00 00 00       	push   $0xfd
c0104330:	68 2c a9 10 c0       	push   $0xc010a92c
c0104335:	e8 be c0 ff ff       	call   c01003f8 <__panic>

    int i, sum = 0;
c010433a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0104341:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104348:	eb 19                	jmp    c0104363 <check_pgfault+0x11f>
        *(char *)(addr + i) = i;
c010434a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010434d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104350:	01 d0                	add    %edx,%eax
c0104352:	89 c2                	mov    %eax,%edx
c0104354:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104357:	88 02                	mov    %al,(%edx)
        sum += i;
c0104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010435c:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c010435f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104363:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0104367:	7e e1                	jle    c010434a <check_pgfault+0x106>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0104369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104370:	eb 15                	jmp    c0104387 <check_pgfault+0x143>
        sum -= *(char *)(addr + i);
c0104372:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104375:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104378:	01 d0                	add    %edx,%eax
c010437a:	0f b6 00             	movzbl (%eax),%eax
c010437d:	0f be c0             	movsbl %al,%eax
c0104380:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0104383:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104387:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010438b:	7e e5                	jle    c0104372 <check_pgfault+0x12e>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c010438d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104391:	74 19                	je     c01043ac <check_pgfault+0x168>
c0104393:	68 4f ab 10 c0       	push   $0xc010ab4f
c0104398:	68 17 a9 10 c0       	push   $0xc010a917
c010439d:	68 07 01 00 00       	push   $0x107
c01043a2:	68 2c a9 10 c0       	push   $0xc010a92c
c01043a7:	e8 4c c0 ff ff       	call   c01003f8 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01043ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043af:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01043b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043ba:	83 ec 08             	sub    $0x8,%esp
c01043bd:	50                   	push   %eax
c01043be:	ff 75 e4             	pushl  -0x1c(%ebp)
c01043c1:	e8 94 34 00 00       	call   c010785a <page_remove>
c01043c6:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(pgdir[0]));
c01043c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043cc:	8b 00                	mov    (%eax),%eax
c01043ce:	83 ec 0c             	sub    $0xc,%esp
c01043d1:	50                   	push   %eax
c01043d2:	e8 9c f6 ff ff       	call   c0103a73 <pde2page>
c01043d7:	83 c4 10             	add    $0x10,%esp
c01043da:	83 ec 08             	sub    $0x8,%esp
c01043dd:	6a 01                	push   $0x1
c01043df:	50                   	push   %eax
c01043e0:	e8 6f 2c 00 00       	call   c0107054 <free_pages>
c01043e5:	83 c4 10             	add    $0x10,%esp
    pgdir[0] = 0;
c01043e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01043f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c01043fb:	83 ec 0c             	sub    $0xc,%esp
c01043fe:	ff 75 e8             	pushl  -0x18(%ebp)
c0104401:	e8 91 f9 ff ff       	call   c0103d97 <mm_destroy>
c0104406:	83 c4 10             	add    $0x10,%esp
    check_mm_struct = NULL;
c0104409:	c7 05 bc c0 12 c0 00 	movl   $0x0,0xc012c0bc
c0104410:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0104413:	e8 71 2c 00 00       	call   c0107089 <nr_free_pages>
c0104418:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010441b:	74 19                	je     c0104436 <check_pgfault+0x1f2>
c010441d:	68 58 ab 10 c0       	push   $0xc010ab58
c0104422:	68 17 a9 10 c0       	push   $0xc010a917
c0104427:	68 11 01 00 00       	push   $0x111
c010442c:	68 2c a9 10 c0       	push   $0xc010a92c
c0104431:	e8 c2 bf ff ff       	call   c01003f8 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0104436:	83 ec 0c             	sub    $0xc,%esp
c0104439:	68 7f ab 10 c0       	push   $0xc010ab7f
c010443e:	e8 4f be ff ff       	call   c0100292 <cprintf>
c0104443:	83 c4 10             	add    $0x10,%esp
}
c0104446:	90                   	nop
c0104447:	c9                   	leave  
c0104448:	c3                   	ret    

c0104449 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0104449:	55                   	push   %ebp
c010444a:	89 e5                	mov    %esp,%ebp
c010444c:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_INVAL;
c010444f:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0104456:	ff 75 10             	pushl  0x10(%ebp)
c0104459:	ff 75 08             	pushl  0x8(%ebp)
c010445c:	e8 e6 f6 ff ff       	call   c0103b47 <find_vma>
c0104461:	83 c4 08             	add    $0x8,%esp
c0104464:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0104467:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010446c:	83 c0 01             	add    $0x1,%eax
c010446f:	a3 64 9f 12 c0       	mov    %eax,0xc0129f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0104474:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104478:	74 0b                	je     c0104485 <do_pgfault+0x3c>
c010447a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010447d:	8b 40 04             	mov    0x4(%eax),%eax
c0104480:	3b 45 10             	cmp    0x10(%ebp),%eax
c0104483:	76 18                	jbe    c010449d <do_pgfault+0x54>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0104485:	83 ec 08             	sub    $0x8,%esp
c0104488:	ff 75 10             	pushl  0x10(%ebp)
c010448b:	68 9c ab 10 c0       	push   $0xc010ab9c
c0104490:	e8 fd bd ff ff       	call   c0100292 <cprintf>
c0104495:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0104498:	e9 b4 01 00 00       	jmp    c0104651 <do_pgfault+0x208>
    }
    //check the error_code
    switch (error_code & 3) {
c010449d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044a0:	83 e0 03             	and    $0x3,%eax
c01044a3:	85 c0                	test   %eax,%eax
c01044a5:	74 3c                	je     c01044e3 <do_pgfault+0x9a>
c01044a7:	83 f8 01             	cmp    $0x1,%eax
c01044aa:	74 22                	je     c01044ce <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01044ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044af:	8b 40 0c             	mov    0xc(%eax),%eax
c01044b2:	83 e0 02             	and    $0x2,%eax
c01044b5:	85 c0                	test   %eax,%eax
c01044b7:	75 4c                	jne    c0104505 <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01044b9:	83 ec 0c             	sub    $0xc,%esp
c01044bc:	68 cc ab 10 c0       	push   $0xc010abcc
c01044c1:	e8 cc bd ff ff       	call   c0100292 <cprintf>
c01044c6:	83 c4 10             	add    $0x10,%esp
            goto failed;
c01044c9:	e9 83 01 00 00       	jmp    c0104651 <do_pgfault+0x208>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01044ce:	83 ec 0c             	sub    $0xc,%esp
c01044d1:	68 2c ac 10 c0       	push   $0xc010ac2c
c01044d6:	e8 b7 bd ff ff       	call   c0100292 <cprintf>
c01044db:	83 c4 10             	add    $0x10,%esp
        goto failed;
c01044de:	e9 6e 01 00 00       	jmp    c0104651 <do_pgfault+0x208>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01044e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044e6:	8b 40 0c             	mov    0xc(%eax),%eax
c01044e9:	83 e0 05             	and    $0x5,%eax
c01044ec:	85 c0                	test   %eax,%eax
c01044ee:	75 16                	jne    c0104506 <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01044f0:	83 ec 0c             	sub    $0xc,%esp
c01044f3:	68 64 ac 10 c0       	push   $0xc010ac64
c01044f8:	e8 95 bd ff ff       	call   c0100292 <cprintf>
c01044fd:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0104500:	e9 4c 01 00 00       	jmp    c0104651 <do_pgfault+0x208>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0104505:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0104506:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c010450d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104510:	8b 40 0c             	mov    0xc(%eax),%eax
c0104513:	83 e0 02             	and    $0x2,%eax
c0104516:	85 c0                	test   %eax,%eax
c0104518:	74 04                	je     c010451e <do_pgfault+0xd5>
        perm |= PTE_W;
c010451a:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c010451e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104521:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104524:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104527:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010452c:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c010452f:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0104536:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: YOUR CODE*/
    ptep = get_pte(mm->pgdir, addr, 1);              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c010453d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104540:	8b 40 0c             	mov    0xc(%eax),%eax
c0104543:	83 ec 04             	sub    $0x4,%esp
c0104546:	6a 01                	push   $0x1
c0104548:	ff 75 10             	pushl  0x10(%ebp)
c010454b:	50                   	push   %eax
c010454c:	e8 03 31 00 00       	call   c0107654 <get_pte>
c0104551:	83 c4 10             	add    $0x10,%esp
c0104554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(ptep != NULL);
c0104557:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010455b:	75 19                	jne    c0104576 <do_pgfault+0x12d>
c010455d:	68 c7 ac 10 c0       	push   $0xc010acc7
c0104562:	68 17 a9 10 c0       	push   $0xc010a917
c0104567:	68 6e 01 00 00       	push   $0x16e
c010456c:	68 2c a9 10 c0       	push   $0xc010a92c
c0104571:	e8 82 be ff ff       	call   c01003f8 <__panic>
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0) {
c0104576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104579:	8b 00                	mov    (%eax),%eax
c010457b:	85 c0                	test   %eax,%eax
c010457d:	75 39                	jne    c01045b8 <do_pgfault+0x16f>
        assert(pgdir_alloc_page(mm->pgdir, addr, perm) != NULL);
c010457f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104582:	8b 40 0c             	mov    0xc(%eax),%eax
c0104585:	83 ec 04             	sub    $0x4,%esp
c0104588:	ff 75 f0             	pushl  -0x10(%ebp)
c010458b:	ff 75 10             	pushl  0x10(%ebp)
c010458e:	50                   	push   %eax
c010458f:	e8 08 34 00 00       	call   c010799c <pgdir_alloc_page>
c0104594:	83 c4 10             	add    $0x10,%esp
c0104597:	85 c0                	test   %eax,%eax
c0104599:	0f 85 ab 00 00 00    	jne    c010464a <do_pgfault+0x201>
c010459f:	68 d4 ac 10 c0       	push   $0xc010acd4
c01045a4:	68 17 a9 10 c0       	push   $0xc010a917
c01045a9:	68 71 01 00 00       	push   $0x171
c01045ae:	68 2c a9 10 c0       	push   $0xc010a92c
c01045b3:	e8 40 be ff ff       	call   c01003f8 <__panic>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c01045b8:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c01045bd:	85 c0                	test   %eax,%eax
c01045bf:	74 71                	je     c0104632 <do_pgfault+0x1e9>
            struct Page *page=NULL;
c01045c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page
            //    into the memory which page managed.
            assert(swap_in(mm, addr, &page) == 0);
c01045c8:	83 ec 04             	sub    $0x4,%esp
c01045cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01045ce:	50                   	push   %eax
c01045cf:	ff 75 10             	pushl  0x10(%ebp)
c01045d2:	ff 75 08             	pushl  0x8(%ebp)
c01045d5:	e8 5f 0f 00 00       	call   c0105539 <swap_in>
c01045da:	83 c4 10             	add    $0x10,%esp
c01045dd:	85 c0                	test   %eax,%eax
c01045df:	74 19                	je     c01045fa <do_pgfault+0x1b1>
c01045e1:	68 04 ad 10 c0       	push   $0xc010ad04
c01045e6:	68 17 a9 10 c0       	push   $0xc010a917
c01045eb:	68 83 01 00 00       	push   $0x183
c01045f0:	68 2c a9 10 c0       	push   $0xc010a92c
c01045f5:	e8 fe bd ff ff       	call   c01003f8 <__panic>
            page->pra_vaddr = addr;
c01045fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045fd:	8b 55 10             	mov    0x10(%ebp),%edx
c0104600:	89 50 1c             	mov    %edx,0x1c(%eax)
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            page_insert(mm->pgdir, page, addr, perm);
c0104603:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104606:	8b 45 08             	mov    0x8(%ebp),%eax
c0104609:	8b 40 0c             	mov    0xc(%eax),%eax
c010460c:	ff 75 f0             	pushl  -0x10(%ebp)
c010460f:	ff 75 10             	pushl  0x10(%ebp)
c0104612:	52                   	push   %edx
c0104613:	50                   	push   %eax
c0104614:	e8 7a 32 00 00       	call   c0107893 <page_insert>
c0104619:	83 c4 10             	add    $0x10,%esp
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c010461c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010461f:	6a 01                	push   $0x1
c0104621:	50                   	push   %eax
c0104622:	ff 75 10             	pushl  0x10(%ebp)
c0104625:	ff 75 08             	pushl  0x8(%ebp)
c0104628:	e8 7c 0d 00 00       	call   c01053a9 <swap_map_swappable>
c010462d:	83 c4 10             	add    $0x10,%esp
c0104630:	eb 18                	jmp    c010464a <do_pgfault+0x201>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0104632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104635:	8b 00                	mov    (%eax),%eax
c0104637:	83 ec 08             	sub    $0x8,%esp
c010463a:	50                   	push   %eax
c010463b:	68 24 ad 10 c0       	push   $0xc010ad24
c0104640:	e8 4d bc ff ff       	call   c0100292 <cprintf>
c0104645:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0104648:	eb 07                	jmp    c0104651 <do_pgfault+0x208>
        }
   }
   ret = 0;
c010464a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0104651:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104654:	c9                   	leave  
c0104655:	c3                   	ret    

c0104656 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0104656:	55                   	push   %ebp
c0104657:	89 e5                	mov    %esp,%ebp
c0104659:	83 ec 10             	sub    $0x10,%esp
c010465c:	c7 45 fc b0 c0 12 c0 	movl   $0xc012c0b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104663:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104666:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104669:	89 50 04             	mov    %edx,0x4(%eax)
c010466c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010466f:	8b 50 04             	mov    0x4(%eax),%edx
c0104672:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104675:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0104677:	8b 45 08             	mov    0x8(%ebp),%eax
c010467a:	c7 40 14 b0 c0 12 c0 	movl   $0xc012c0b0,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0104681:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104686:	c9                   	leave  
c0104687:	c3                   	ret    

c0104688 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104688:	55                   	push   %ebp
c0104689:	89 e5                	mov    %esp,%ebp
c010468b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010468e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104691:	8b 40 14             	mov    0x14(%eax),%eax
c0104694:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0104697:	8b 45 10             	mov    0x10(%ebp),%eax
c010469a:	83 c0 14             	add    $0x14,%eax
c010469d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
    assert(entry != NULL && head != NULL);
c01046a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01046a4:	74 06                	je     c01046ac <_fifo_map_swappable+0x24>
c01046a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046aa:	75 16                	jne    c01046c2 <_fifo_map_swappable+0x3a>
c01046ac:	68 4c ad 10 c0       	push   $0xc010ad4c
c01046b1:	68 6a ad 10 c0       	push   $0xc010ad6a
c01046b6:	6a 32                	push   $0x32
c01046b8:	68 7f ad 10 c0       	push   $0xc010ad7f
c01046bd:	e8 36 bd ff ff       	call   c01003f8 <__panic>
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c01046c2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01046c6:	75 57                	jne    c010471f <_fifo_map_swappable+0x97>
        list_entry_t *le_prev = head, *le;
c01046c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c01046ce:	eb 38                	jmp    c0104708 <_fifo_map_swappable+0x80>
            if (le == entry) {
c01046d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01046d6:	75 2a                	jne    c0104702 <_fifo_map_swappable+0x7a>
c01046d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046db:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01046de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046e1:	8b 40 04             	mov    0x4(%eax),%eax
c01046e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01046e7:	8b 12                	mov    (%edx),%edx
c01046e9:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01046ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01046ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01046f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01046f5:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01046f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046fe:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c0104700:	eb 1d                	jmp    c010471f <_fifo_map_swappable+0x97>
            }
            le_prev = le;        
c0104702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104705:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104708:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010470b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010470e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104711:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c0104714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010471a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010471d:	75 b1                	jne    c01046d0 <_fifo_map_swappable+0x48>
c010471f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104722:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104725:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104728:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010472b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010472e:	8b 00                	mov    (%eax),%eax
c0104730:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104733:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104736:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104739:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010473c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010473f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104742:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104745:	89 10                	mov    %edx,(%eax)
c0104747:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010474a:	8b 10                	mov    (%eax),%edx
c010474c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010474f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104752:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104755:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104758:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010475b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010475e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104761:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c0104763:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104768:	c9                   	leave  
c0104769:	c3                   	ret    

c010476a <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c010476a:	55                   	push   %ebp
c010476b:	89 e5                	mov    %esp,%ebp
c010476d:	83 ec 28             	sub    $0x28,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0104770:	8b 45 08             	mov    0x8(%ebp),%eax
c0104773:	8b 40 14             	mov    0x14(%eax),%eax
c0104776:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0104779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010477d:	75 16                	jne    c0104795 <_fifo_swap_out_victim+0x2b>
c010477f:	68 93 ad 10 c0       	push   $0xc010ad93
c0104784:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104789:	6a 4c                	push   $0x4c
c010478b:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104790:	e8 63 bc ff ff       	call   c01003f8 <__panic>
     assert(in_tick==0);
c0104795:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104799:	74 16                	je     c01047b1 <_fifo_swap_out_victim+0x47>
c010479b:	68 a0 ad 10 c0       	push   $0xc010ada0
c01047a0:	68 6a ad 10 c0       	push   $0xc010ad6a
c01047a5:	6a 4d                	push   $0x4d
c01047a7:	68 7f ad 10 c0       	push   $0xc010ad7f
c01047ac:	e8 47 bc ff ff       	call   c01003f8 <__panic>
c01047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01047b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047ba:	8b 40 04             	mov    0x4(%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
    list_entry_t *front = list_next(head);
c01047bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(front != head);
c01047c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047c6:	75 16                	jne    c01047de <_fifo_swap_out_victim+0x74>
c01047c8:	68 ab ad 10 c0       	push   $0xc010adab
c01047cd:	68 6a ad 10 c0       	push   $0xc010ad6a
c01047d2:	6a 52                	push   $0x52
c01047d4:	68 7f ad 10 c0       	push   $0xc010ad7f
c01047d9:	e8 1a bc ff ff       	call   c01003f8 <__panic>
c01047de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01047e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047e7:	8b 40 04             	mov    0x4(%eax),%eax
c01047ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01047ed:	8b 12                	mov    (%edx),%edx
c01047ef:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01047f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01047f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047fb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01047fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104801:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104804:	89 10                	mov    %edx,(%eax)
    list_del(front);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(front, pra_page_link);
c0104806:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104809:	83 e8 14             	sub    $0x14,%eax
c010480c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(page != NULL);
c010480f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104813:	75 16                	jne    c010482b <_fifo_swap_out_victim+0xc1>
c0104815:	68 b9 ad 10 c0       	push   $0xc010adb9
c010481a:	68 6a ad 10 c0       	push   $0xc010ad6a
c010481f:	6a 56                	push   $0x56
c0104821:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104826:	e8 cd bb ff ff       	call   c01003f8 <__panic>
    *ptr_page = page;
c010482b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010482e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104831:	89 10                	mov    %edx,(%eax)
    return 0;
c0104833:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104838:	c9                   	leave  
c0104839:	c3                   	ret    

c010483a <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c010483a:	55                   	push   %ebp
c010483b:	89 e5                	mov    %esp,%ebp
c010483d:	83 ec 08             	sub    $0x8,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104840:	83 ec 0c             	sub    $0xc,%esp
c0104843:	68 c8 ad 10 c0       	push   $0xc010adc8
c0104848:	e8 45 ba ff ff       	call   c0100292 <cprintf>
c010484d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0104850:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104855:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0104858:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010485d:	83 f8 04             	cmp    $0x4,%eax
c0104860:	74 16                	je     c0104878 <_fifo_check_swap+0x3e>
c0104862:	68 ee ad 10 c0       	push   $0xc010adee
c0104867:	68 6a ad 10 c0       	push   $0xc010ad6a
c010486c:	6a 5f                	push   $0x5f
c010486e:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104873:	e8 80 bb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104878:	83 ec 0c             	sub    $0xc,%esp
c010487b:	68 00 ae 10 c0       	push   $0xc010ae00
c0104880:	e8 0d ba ff ff       	call   c0100292 <cprintf>
c0104885:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0104888:	b8 00 10 00 00       	mov    $0x1000,%eax
c010488d:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0104890:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104895:	83 f8 04             	cmp    $0x4,%eax
c0104898:	74 16                	je     c01048b0 <_fifo_check_swap+0x76>
c010489a:	68 ee ad 10 c0       	push   $0xc010adee
c010489f:	68 6a ad 10 c0       	push   $0xc010ad6a
c01048a4:	6a 62                	push   $0x62
c01048a6:	68 7f ad 10 c0       	push   $0xc010ad7f
c01048ab:	e8 48 bb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01048b0:	83 ec 0c             	sub    $0xc,%esp
c01048b3:	68 28 ae 10 c0       	push   $0xc010ae28
c01048b8:	e8 d5 b9 ff ff       	call   c0100292 <cprintf>
c01048bd:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c01048c0:	b8 00 40 00 00       	mov    $0x4000,%eax
c01048c5:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01048c8:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01048cd:	83 f8 04             	cmp    $0x4,%eax
c01048d0:	74 16                	je     c01048e8 <_fifo_check_swap+0xae>
c01048d2:	68 ee ad 10 c0       	push   $0xc010adee
c01048d7:	68 6a ad 10 c0       	push   $0xc010ad6a
c01048dc:	6a 65                	push   $0x65
c01048de:	68 7f ad 10 c0       	push   $0xc010ad7f
c01048e3:	e8 10 bb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01048e8:	83 ec 0c             	sub    $0xc,%esp
c01048eb:	68 50 ae 10 c0       	push   $0xc010ae50
c01048f0:	e8 9d b9 ff ff       	call   c0100292 <cprintf>
c01048f5:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c01048f8:	b8 00 20 00 00       	mov    $0x2000,%eax
c01048fd:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0104900:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104905:	83 f8 04             	cmp    $0x4,%eax
c0104908:	74 16                	je     c0104920 <_fifo_check_swap+0xe6>
c010490a:	68 ee ad 10 c0       	push   $0xc010adee
c010490f:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104914:	6a 68                	push   $0x68
c0104916:	68 7f ad 10 c0       	push   $0xc010ad7f
c010491b:	e8 d8 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104920:	83 ec 0c             	sub    $0xc,%esp
c0104923:	68 78 ae 10 c0       	push   $0xc010ae78
c0104928:	e8 65 b9 ff ff       	call   c0100292 <cprintf>
c010492d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104930:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104935:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0104938:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010493d:	83 f8 05             	cmp    $0x5,%eax
c0104940:	74 16                	je     c0104958 <_fifo_check_swap+0x11e>
c0104942:	68 9e ae 10 c0       	push   $0xc010ae9e
c0104947:	68 6a ad 10 c0       	push   $0xc010ad6a
c010494c:	6a 6b                	push   $0x6b
c010494e:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104953:	e8 a0 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0104958:	83 ec 0c             	sub    $0xc,%esp
c010495b:	68 50 ae 10 c0       	push   $0xc010ae50
c0104960:	e8 2d b9 ff ff       	call   c0100292 <cprintf>
c0104965:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0104968:	b8 00 20 00 00       	mov    $0x2000,%eax
c010496d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0104970:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104975:	83 f8 05             	cmp    $0x5,%eax
c0104978:	74 16                	je     c0104990 <_fifo_check_swap+0x156>
c010497a:	68 9e ae 10 c0       	push   $0xc010ae9e
c010497f:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104984:	6a 6e                	push   $0x6e
c0104986:	68 7f ad 10 c0       	push   $0xc010ad7f
c010498b:	e8 68 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104990:	83 ec 0c             	sub    $0xc,%esp
c0104993:	68 00 ae 10 c0       	push   $0xc010ae00
c0104998:	e8 f5 b8 ff ff       	call   c0100292 <cprintf>
c010499d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01049a0:	b8 00 10 00 00       	mov    $0x1000,%eax
c01049a5:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01049a8:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01049ad:	83 f8 06             	cmp    $0x6,%eax
c01049b0:	74 16                	je     c01049c8 <_fifo_check_swap+0x18e>
c01049b2:	68 ad ae 10 c0       	push   $0xc010aead
c01049b7:	68 6a ad 10 c0       	push   $0xc010ad6a
c01049bc:	6a 71                	push   $0x71
c01049be:	68 7f ad 10 c0       	push   $0xc010ad7f
c01049c3:	e8 30 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01049c8:	83 ec 0c             	sub    $0xc,%esp
c01049cb:	68 50 ae 10 c0       	push   $0xc010ae50
c01049d0:	e8 bd b8 ff ff       	call   c0100292 <cprintf>
c01049d5:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c01049d8:	b8 00 20 00 00       	mov    $0x2000,%eax
c01049dd:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01049e0:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01049e5:	83 f8 07             	cmp    $0x7,%eax
c01049e8:	74 16                	je     c0104a00 <_fifo_check_swap+0x1c6>
c01049ea:	68 bc ae 10 c0       	push   $0xc010aebc
c01049ef:	68 6a ad 10 c0       	push   $0xc010ad6a
c01049f4:	6a 74                	push   $0x74
c01049f6:	68 7f ad 10 c0       	push   $0xc010ad7f
c01049fb:	e8 f8 b9 ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104a00:	83 ec 0c             	sub    $0xc,%esp
c0104a03:	68 c8 ad 10 c0       	push   $0xc010adc8
c0104a08:	e8 85 b8 ff ff       	call   c0100292 <cprintf>
c0104a0d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0104a10:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104a15:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0104a18:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104a1d:	83 f8 08             	cmp    $0x8,%eax
c0104a20:	74 16                	je     c0104a38 <_fifo_check_swap+0x1fe>
c0104a22:	68 cb ae 10 c0       	push   $0xc010aecb
c0104a27:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104a2c:	6a 77                	push   $0x77
c0104a2e:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104a33:	e8 c0 b9 ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0104a38:	83 ec 0c             	sub    $0xc,%esp
c0104a3b:	68 28 ae 10 c0       	push   $0xc010ae28
c0104a40:	e8 4d b8 ff ff       	call   c0100292 <cprintf>
c0104a45:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0104a48:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104a4d:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0104a50:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104a55:	83 f8 09             	cmp    $0x9,%eax
c0104a58:	74 16                	je     c0104a70 <_fifo_check_swap+0x236>
c0104a5a:	68 da ae 10 c0       	push   $0xc010aeda
c0104a5f:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104a64:	6a 7a                	push   $0x7a
c0104a66:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104a6b:	e8 88 b9 ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104a70:	83 ec 0c             	sub    $0xc,%esp
c0104a73:	68 78 ae 10 c0       	push   $0xc010ae78
c0104a78:	e8 15 b8 ff ff       	call   c0100292 <cprintf>
c0104a7d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104a80:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104a85:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0104a88:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104a8d:	83 f8 0a             	cmp    $0xa,%eax
c0104a90:	74 16                	je     c0104aa8 <_fifo_check_swap+0x26e>
c0104a92:	68 e9 ae 10 c0       	push   $0xc010aee9
c0104a97:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104a9c:	6a 7d                	push   $0x7d
c0104a9e:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104aa3:	e8 50 b9 ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104aa8:	83 ec 0c             	sub    $0xc,%esp
c0104aab:	68 00 ae 10 c0       	push   $0xc010ae00
c0104ab0:	e8 dd b7 ff ff       	call   c0100292 <cprintf>
c0104ab5:	83 c4 10             	add    $0x10,%esp
    assert(*(unsigned char *)0x1000 == 0x0a);
c0104ab8:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104abd:	0f b6 00             	movzbl (%eax),%eax
c0104ac0:	3c 0a                	cmp    $0xa,%al
c0104ac2:	74 16                	je     c0104ada <_fifo_check_swap+0x2a0>
c0104ac4:	68 fc ae 10 c0       	push   $0xc010aefc
c0104ac9:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104ace:	6a 7f                	push   $0x7f
c0104ad0:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104ad5:	e8 1e b9 ff ff       	call   c01003f8 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0104ada:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104adf:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0104ae2:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104ae7:	83 f8 0b             	cmp    $0xb,%eax
c0104aea:	74 19                	je     c0104b05 <_fifo_check_swap+0x2cb>
c0104aec:	68 1d af 10 c0       	push   $0xc010af1d
c0104af1:	68 6a ad 10 c0       	push   $0xc010ad6a
c0104af6:	68 81 00 00 00       	push   $0x81
c0104afb:	68 7f ad 10 c0       	push   $0xc010ad7f
c0104b00:	e8 f3 b8 ff ff       	call   c01003f8 <__panic>
    return 0;
c0104b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b0a:	c9                   	leave  
c0104b0b:	c3                   	ret    

c0104b0c <_fifo_init>:


static int
_fifo_init(void)
{
c0104b0c:	55                   	push   %ebp
c0104b0d:	89 e5                	mov    %esp,%ebp
    return 0;
c0104b0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b14:	5d                   	pop    %ebp
c0104b15:	c3                   	ret    

c0104b16 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104b16:	55                   	push   %ebp
c0104b17:	89 e5                	mov    %esp,%ebp
    return 0;
c0104b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b1e:	5d                   	pop    %ebp
c0104b1f:	c3                   	ret    

c0104b20 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0104b20:	55                   	push   %ebp
c0104b21:	89 e5                	mov    %esp,%ebp
c0104b23:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b28:	5d                   	pop    %ebp
c0104b29:	c3                   	ret    

c0104b2a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104b2a:	55                   	push   %ebp
c0104b2b:	89 e5                	mov    %esp,%ebp
c0104b2d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104b30:	9c                   	pushf  
c0104b31:	58                   	pop    %eax
c0104b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104b38:	25 00 02 00 00       	and    $0x200,%eax
c0104b3d:	85 c0                	test   %eax,%eax
c0104b3f:	74 0c                	je     c0104b4d <__intr_save+0x23>
        intr_disable();
c0104b41:	e8 9a d5 ff ff       	call   c01020e0 <intr_disable>
        return 1;
c0104b46:	b8 01 00 00 00       	mov    $0x1,%eax
c0104b4b:	eb 05                	jmp    c0104b52 <__intr_save+0x28>
    }
    return 0;
c0104b4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b52:	c9                   	leave  
c0104b53:	c3                   	ret    

c0104b54 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104b54:	55                   	push   %ebp
c0104b55:	89 e5                	mov    %esp,%ebp
c0104b57:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b5e:	74 05                	je     c0104b65 <__intr_restore+0x11>
        intr_enable();
c0104b60:	e8 74 d5 ff ff       	call   c01020d9 <intr_enable>
    }
}
c0104b65:	90                   	nop
c0104b66:	c9                   	leave  
c0104b67:	c3                   	ret    

c0104b68 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104b68:	55                   	push   %ebp
c0104b69:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b6e:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0104b74:	29 d0                	sub    %edx,%eax
c0104b76:	c1 f8 05             	sar    $0x5,%eax
}
c0104b79:	5d                   	pop    %ebp
c0104b7a:	c3                   	ret    

c0104b7b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104b7b:	55                   	push   %ebp
c0104b7c:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104b7e:	ff 75 08             	pushl  0x8(%ebp)
c0104b81:	e8 e2 ff ff ff       	call   c0104b68 <page2ppn>
c0104b86:	83 c4 04             	add    $0x4,%esp
c0104b89:	c1 e0 0c             	shl    $0xc,%eax
}
c0104b8c:	c9                   	leave  
c0104b8d:	c3                   	ret    

c0104b8e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b8e:	55                   	push   %ebp
c0104b8f:	89 e5                	mov    %esp,%ebp
c0104b91:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0104b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b97:	c1 e8 0c             	shr    $0xc,%eax
c0104b9a:	89 c2                	mov    %eax,%edx
c0104b9c:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0104ba1:	39 c2                	cmp    %eax,%edx
c0104ba3:	72 14                	jb     c0104bb9 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0104ba5:	83 ec 04             	sub    $0x4,%esp
c0104ba8:	68 40 af 10 c0       	push   $0xc010af40
c0104bad:	6a 5f                	push   $0x5f
c0104baf:	68 5f af 10 c0       	push   $0xc010af5f
c0104bb4:	e8 3f b8 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0104bb9:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0104bbe:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bc1:	c1 ea 0c             	shr    $0xc,%edx
c0104bc4:	c1 e2 05             	shl    $0x5,%edx
c0104bc7:	01 d0                	add    %edx,%eax
}
c0104bc9:	c9                   	leave  
c0104bca:	c3                   	ret    

c0104bcb <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104bcb:	55                   	push   %ebp
c0104bcc:	89 e5                	mov    %esp,%ebp
c0104bce:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0104bd1:	ff 75 08             	pushl  0x8(%ebp)
c0104bd4:	e8 a2 ff ff ff       	call   c0104b7b <page2pa>
c0104bd9:	83 c4 04             	add    $0x4,%esp
c0104bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be2:	c1 e8 0c             	shr    $0xc,%eax
c0104be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104be8:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0104bed:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104bf0:	72 14                	jb     c0104c06 <page2kva+0x3b>
c0104bf2:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bf5:	68 70 af 10 c0       	push   $0xc010af70
c0104bfa:	6a 66                	push   $0x66
c0104bfc:	68 5f af 10 c0       	push   $0xc010af5f
c0104c01:	e8 f2 b7 ff ff       	call   c01003f8 <__panic>
c0104c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c09:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104c0e:	c9                   	leave  
c0104c0f:	c3                   	ret    

c0104c10 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104c10:	55                   	push   %ebp
c0104c11:	89 e5                	mov    %esp,%ebp
c0104c13:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c0104c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c1c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104c23:	77 14                	ja     c0104c39 <kva2page+0x29>
c0104c25:	ff 75 f4             	pushl  -0xc(%ebp)
c0104c28:	68 94 af 10 c0       	push   $0xc010af94
c0104c2d:	6a 6b                	push   $0x6b
c0104c2f:	68 5f af 10 c0       	push   $0xc010af5f
c0104c34:	e8 bf b7 ff ff       	call   c01003f8 <__panic>
c0104c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c3c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104c41:	83 ec 0c             	sub    $0xc,%esp
c0104c44:	50                   	push   %eax
c0104c45:	e8 44 ff ff ff       	call   c0104b8e <pa2page>
c0104c4a:	83 c4 10             	add    $0x10,%esp
}
c0104c4d:	c9                   	leave  
c0104c4e:	c3                   	ret    

c0104c4f <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104c4f:	55                   	push   %ebp
c0104c50:	89 e5                	mov    %esp,%ebp
c0104c52:	83 ec 18             	sub    $0x18,%esp
  struct Page * page = alloc_pages(1 << order);
c0104c55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c58:	ba 01 00 00 00       	mov    $0x1,%edx
c0104c5d:	89 c1                	mov    %eax,%ecx
c0104c5f:	d3 e2                	shl    %cl,%edx
c0104c61:	89 d0                	mov    %edx,%eax
c0104c63:	83 ec 0c             	sub    $0xc,%esp
c0104c66:	50                   	push   %eax
c0104c67:	e8 7c 23 00 00       	call   c0106fe8 <alloc_pages>
c0104c6c:	83 c4 10             	add    $0x10,%esp
c0104c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c76:	75 07                	jne    c0104c7f <__slob_get_free_pages+0x30>
    return NULL;
c0104c78:	b8 00 00 00 00       	mov    $0x0,%eax
c0104c7d:	eb 0e                	jmp    c0104c8d <__slob_get_free_pages+0x3e>
  return page2kva(page);
c0104c7f:	83 ec 0c             	sub    $0xc,%esp
c0104c82:	ff 75 f4             	pushl  -0xc(%ebp)
c0104c85:	e8 41 ff ff ff       	call   c0104bcb <page2kva>
c0104c8a:	83 c4 10             	add    $0x10,%esp
}
c0104c8d:	c9                   	leave  
c0104c8e:	c3                   	ret    

c0104c8f <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104c8f:	55                   	push   %ebp
c0104c90:	89 e5                	mov    %esp,%ebp
c0104c92:	53                   	push   %ebx
c0104c93:	83 ec 04             	sub    $0x4,%esp
  free_pages(kva2page(kva), 1 << order);
c0104c96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c99:	ba 01 00 00 00       	mov    $0x1,%edx
c0104c9e:	89 c1                	mov    %eax,%ecx
c0104ca0:	d3 e2                	shl    %cl,%edx
c0104ca2:	89 d0                	mov    %edx,%eax
c0104ca4:	89 c3                	mov    %eax,%ebx
c0104ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ca9:	83 ec 0c             	sub    $0xc,%esp
c0104cac:	50                   	push   %eax
c0104cad:	e8 5e ff ff ff       	call   c0104c10 <kva2page>
c0104cb2:	83 c4 10             	add    $0x10,%esp
c0104cb5:	83 ec 08             	sub    $0x8,%esp
c0104cb8:	53                   	push   %ebx
c0104cb9:	50                   	push   %eax
c0104cba:	e8 95 23 00 00       	call   c0107054 <free_pages>
c0104cbf:	83 c4 10             	add    $0x10,%esp
}
c0104cc2:	90                   	nop
c0104cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104cc6:	c9                   	leave  
c0104cc7:	c3                   	ret    

c0104cc8 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104cc8:	55                   	push   %ebp
c0104cc9:	89 e5                	mov    %esp,%ebp
c0104ccb:	83 ec 28             	sub    $0x28,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cd1:	83 c0 08             	add    $0x8,%eax
c0104cd4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104cd9:	76 16                	jbe    c0104cf1 <slob_alloc+0x29>
c0104cdb:	68 b8 af 10 c0       	push   $0xc010afb8
c0104ce0:	68 d7 af 10 c0       	push   $0xc010afd7
c0104ce5:	6a 64                	push   $0x64
c0104ce7:	68 ec af 10 c0       	push   $0xc010afec
c0104cec:	e8 07 b7 ff ff       	call   c01003f8 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104cf1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104cf8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d02:	83 c0 07             	add    $0x7,%eax
c0104d05:	c1 e8 03             	shr    $0x3,%eax
c0104d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104d0b:	e8 1a fe ff ff       	call   c0104b2a <__intr_save>
c0104d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c0104d13:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d1e:	8b 40 04             	mov    0x4(%eax),%eax
c0104d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104d28:	74 25                	je     c0104d4f <slob_alloc+0x87>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104d2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d30:	01 d0                	add    %edx,%eax
c0104d32:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104d35:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d38:	f7 d8                	neg    %eax
c0104d3a:	21 d0                	and    %edx,%eax
c0104d3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104d3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d45:	29 c2                	sub    %eax,%edx
c0104d47:	89 d0                	mov    %edx,%eax
c0104d49:	c1 f8 03             	sar    $0x3,%eax
c0104d4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d52:	8b 00                	mov    (%eax),%eax
c0104d54:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104d57:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104d5a:	01 ca                	add    %ecx,%edx
c0104d5c:	39 d0                	cmp    %edx,%eax
c0104d5e:	0f 8c b1 00 00 00    	jl     c0104e15 <slob_alloc+0x14d>
			if (delta) { /* need to fragment head to align? */
c0104d64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104d68:	74 38                	je     c0104da2 <slob_alloc+0xda>
				aligned->units = cur->units - delta;
c0104d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d6d:	8b 00                	mov    (%eax),%eax
c0104d6f:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104d72:	89 c2                	mov    %eax,%edx
c0104d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d77:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d7c:	8b 50 04             	mov    0x4(%eax),%edx
c0104d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d82:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d88:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104d8b:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d91:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104d94:	89 10                	mov    %edx,(%eax)
				prev = cur;
c0104d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104da5:	8b 00                	mov    (%eax),%eax
c0104da7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104daa:	75 0e                	jne    c0104dba <slob_alloc+0xf2>
				prev->next = cur->next; /* unlink */
c0104dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104daf:	8b 50 04             	mov    0x4(%eax),%edx
c0104db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db5:	89 50 04             	mov    %edx,0x4(%eax)
c0104db8:	eb 3c                	jmp    c0104df6 <slob_alloc+0x12e>
			else { /* fragment */
				prev->next = cur + units;
c0104dba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104dbd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dc7:	01 c2                	add    %eax,%edx
c0104dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dcc:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd2:	8b 40 04             	mov    0x4(%eax),%eax
c0104dd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104dd8:	8b 12                	mov    (%edx),%edx
c0104dda:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104ddd:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104de2:	8b 40 04             	mov    0x4(%eax),%eax
c0104de5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104de8:	8b 52 04             	mov    0x4(%edx),%edx
c0104deb:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104df1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104df4:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df9:	a3 48 6a 12 c0       	mov    %eax,0xc0126a48
			spin_unlock_irqrestore(&slob_lock, flags);
c0104dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e01:	83 ec 0c             	sub    $0xc,%esp
c0104e04:	50                   	push   %eax
c0104e05:	e8 4a fd ff ff       	call   c0104b54 <__intr_restore>
c0104e0a:	83 c4 10             	add    $0x10,%esp
			return cur;
c0104e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e10:	e9 80 00 00 00       	jmp    c0104e95 <slob_alloc+0x1cd>
		}
		if (cur == slobfree) {
c0104e15:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104e1a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104e1d:	75 62                	jne    c0104e81 <slob_alloc+0x1b9>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104e1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e22:	83 ec 0c             	sub    $0xc,%esp
c0104e25:	50                   	push   %eax
c0104e26:	e8 29 fd ff ff       	call   c0104b54 <__intr_restore>
c0104e2b:	83 c4 10             	add    $0x10,%esp

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c0104e2e:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104e35:	75 07                	jne    c0104e3e <slob_alloc+0x176>
				return 0;
c0104e37:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e3c:	eb 57                	jmp    c0104e95 <slob_alloc+0x1cd>

			cur = (slob_t *)__slob_get_free_page(gfp);
c0104e3e:	83 ec 08             	sub    $0x8,%esp
c0104e41:	6a 00                	push   $0x0
c0104e43:	ff 75 0c             	pushl  0xc(%ebp)
c0104e46:	e8 04 fe ff ff       	call   c0104c4f <__slob_get_free_pages>
c0104e4b:	83 c4 10             	add    $0x10,%esp
c0104e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104e51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e55:	75 07                	jne    c0104e5e <slob_alloc+0x196>
				return 0;
c0104e57:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e5c:	eb 37                	jmp    c0104e95 <slob_alloc+0x1cd>

			slob_free(cur, PAGE_SIZE);
c0104e5e:	83 ec 08             	sub    $0x8,%esp
c0104e61:	68 00 10 00 00       	push   $0x1000
c0104e66:	ff 75 f0             	pushl  -0x10(%ebp)
c0104e69:	e8 29 00 00 00       	call   c0104e97 <slob_free>
c0104e6e:	83 c4 10             	add    $0x10,%esp
			spin_lock_irqsave(&slob_lock, flags);
c0104e71:	e8 b4 fc ff ff       	call   c0104b2a <__intr_save>
c0104e76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104e79:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e8a:	8b 40 04             	mov    0x4(%eax),%eax
c0104e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104e90:	e9 8f fe ff ff       	jmp    c0104d24 <slob_alloc+0x5c>
}
c0104e95:	c9                   	leave  
c0104e96:	c3                   	ret    

c0104e97 <slob_free>:

static void slob_free(void *block, int size)
{
c0104e97:	55                   	push   %ebp
c0104e98:	89 e5                	mov    %esp,%ebp
c0104e9a:	83 ec 18             	sub    $0x18,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ea7:	0f 84 05 01 00 00    	je     c0104fb2 <slob_free+0x11b>
		return;

	if (size)
c0104ead:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104eb1:	74 10                	je     c0104ec3 <slob_free+0x2c>
		b->units = SLOB_UNITS(size);
c0104eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104eb6:	83 c0 07             	add    $0x7,%eax
c0104eb9:	c1 e8 03             	shr    $0x3,%eax
c0104ebc:	89 c2                	mov    %eax,%edx
c0104ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ec1:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104ec3:	e8 62 fc ff ff       	call   c0104b2a <__intr_save>
c0104ec8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104ecb:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ed3:	eb 27                	jmp    c0104efc <slob_free+0x65>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed8:	8b 40 04             	mov    0x4(%eax),%eax
c0104edb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ede:	77 13                	ja     c0104ef3 <slob_free+0x5c>
c0104ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ee6:	77 27                	ja     c0104f0f <slob_free+0x78>
c0104ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eeb:	8b 40 04             	mov    0x4(%eax),%eax
c0104eee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ef1:	77 1c                	ja     c0104f0f <slob_free+0x78>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef6:	8b 40 04             	mov    0x4(%eax),%eax
c0104ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104eff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f02:	76 d1                	jbe    c0104ed5 <slob_free+0x3e>
c0104f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f07:	8b 40 04             	mov    0x4(%eax),%eax
c0104f0a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104f0d:	76 c6                	jbe    c0104ed5 <slob_free+0x3e>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f12:	8b 00                	mov    (%eax),%eax
c0104f14:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f1e:	01 c2                	add    %eax,%edx
c0104f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f23:	8b 40 04             	mov    0x4(%eax),%eax
c0104f26:	39 c2                	cmp    %eax,%edx
c0104f28:	75 25                	jne    c0104f4f <slob_free+0xb8>
		b->units += cur->next->units;
c0104f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f2d:	8b 10                	mov    (%eax),%edx
c0104f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f32:	8b 40 04             	mov    0x4(%eax),%eax
c0104f35:	8b 00                	mov    (%eax),%eax
c0104f37:	01 c2                	add    %eax,%edx
c0104f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f3c:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f41:	8b 40 04             	mov    0x4(%eax),%eax
c0104f44:	8b 50 04             	mov    0x4(%eax),%edx
c0104f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f4a:	89 50 04             	mov    %edx,0x4(%eax)
c0104f4d:	eb 0c                	jmp    c0104f5b <slob_free+0xc4>
	} else
		b->next = cur->next;
c0104f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f52:	8b 50 04             	mov    0x4(%eax),%edx
c0104f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f58:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f5e:	8b 00                	mov    (%eax),%eax
c0104f60:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f6a:	01 d0                	add    %edx,%eax
c0104f6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104f6f:	75 1f                	jne    c0104f90 <slob_free+0xf9>
		cur->units += b->units;
c0104f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f74:	8b 10                	mov    (%eax),%edx
c0104f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f79:	8b 00                	mov    (%eax),%eax
c0104f7b:	01 c2                	add    %eax,%edx
c0104f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f80:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f85:	8b 50 04             	mov    0x4(%eax),%edx
c0104f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f8b:	89 50 04             	mov    %edx,0x4(%eax)
c0104f8e:	eb 09                	jmp    c0104f99 <slob_free+0x102>
	} else
		cur->next = b;
c0104f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f93:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f96:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f9c:	a3 48 6a 12 c0       	mov    %eax,0xc0126a48

	spin_unlock_irqrestore(&slob_lock, flags);
c0104fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fa4:	83 ec 0c             	sub    $0xc,%esp
c0104fa7:	50                   	push   %eax
c0104fa8:	e8 a7 fb ff ff       	call   c0104b54 <__intr_restore>
c0104fad:	83 c4 10             	add    $0x10,%esp
c0104fb0:	eb 01                	jmp    c0104fb3 <slob_free+0x11c>
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
		return;
c0104fb2:	90                   	nop
		cur->next = b;

	slobfree = cur;

	spin_unlock_irqrestore(&slob_lock, flags);
}
c0104fb3:	c9                   	leave  
c0104fb4:	c3                   	ret    

c0104fb5 <slob_init>:



void
slob_init(void) {
c0104fb5:	55                   	push   %ebp
c0104fb6:	89 e5                	mov    %esp,%ebp
c0104fb8:	83 ec 08             	sub    $0x8,%esp
  cprintf("use SLOB allocator\n");
c0104fbb:	83 ec 0c             	sub    $0xc,%esp
c0104fbe:	68 fe af 10 c0       	push   $0xc010affe
c0104fc3:	e8 ca b2 ff ff       	call   c0100292 <cprintf>
c0104fc8:	83 c4 10             	add    $0x10,%esp
}
c0104fcb:	90                   	nop
c0104fcc:	c9                   	leave  
c0104fcd:	c3                   	ret    

c0104fce <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104fce:	55                   	push   %ebp
c0104fcf:	89 e5                	mov    %esp,%ebp
c0104fd1:	83 ec 08             	sub    $0x8,%esp
    slob_init();
c0104fd4:	e8 dc ff ff ff       	call   c0104fb5 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104fd9:	83 ec 0c             	sub    $0xc,%esp
c0104fdc:	68 12 b0 10 c0       	push   $0xc010b012
c0104fe1:	e8 ac b2 ff ff       	call   c0100292 <cprintf>
c0104fe6:	83 c4 10             	add    $0x10,%esp
}
c0104fe9:	90                   	nop
c0104fea:	c9                   	leave  
c0104feb:	c3                   	ret    

c0104fec <slob_allocated>:

size_t
slob_allocated(void) {
c0104fec:	55                   	push   %ebp
c0104fed:	89 e5                	mov    %esp,%ebp
  return 0;
c0104fef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ff4:	5d                   	pop    %ebp
c0104ff5:	c3                   	ret    

c0104ff6 <kallocated>:

size_t
kallocated(void) {
c0104ff6:	55                   	push   %ebp
c0104ff7:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104ff9:	e8 ee ff ff ff       	call   c0104fec <slob_allocated>
}
c0104ffe:	5d                   	pop    %ebp
c0104fff:	c3                   	ret    

c0105000 <find_order>:

static int find_order(int size)
{
c0105000:	55                   	push   %ebp
c0105001:	89 e5                	mov    %esp,%ebp
c0105003:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0105006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c010500d:	eb 07                	jmp    c0105016 <find_order+0x16>
		order++;
c010500f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0105013:	d1 7d 08             	sarl   0x8(%ebp)
c0105016:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c010501d:	7f f0                	jg     c010500f <find_order+0xf>
		order++;
	return order;
c010501f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105022:	c9                   	leave  
c0105023:	c3                   	ret    

c0105024 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0105024:	55                   	push   %ebp
c0105025:	89 e5                	mov    %esp,%ebp
c0105027:	83 ec 18             	sub    $0x18,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c010502a:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0105031:	77 35                	ja     c0105068 <__kmalloc+0x44>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0105033:	8b 45 08             	mov    0x8(%ebp),%eax
c0105036:	83 c0 08             	add    $0x8,%eax
c0105039:	83 ec 04             	sub    $0x4,%esp
c010503c:	6a 00                	push   $0x0
c010503e:	ff 75 0c             	pushl  0xc(%ebp)
c0105041:	50                   	push   %eax
c0105042:	e8 81 fc ff ff       	call   c0104cc8 <slob_alloc>
c0105047:	83 c4 10             	add    $0x10,%esp
c010504a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c010504d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105051:	74 0b                	je     c010505e <__kmalloc+0x3a>
c0105053:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105056:	83 c0 08             	add    $0x8,%eax
c0105059:	e9 b3 00 00 00       	jmp    c0105111 <__kmalloc+0xed>
c010505e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105063:	e9 a9 00 00 00       	jmp    c0105111 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0105068:	83 ec 04             	sub    $0x4,%esp
c010506b:	6a 00                	push   $0x0
c010506d:	ff 75 0c             	pushl  0xc(%ebp)
c0105070:	6a 0c                	push   $0xc
c0105072:	e8 51 fc ff ff       	call   c0104cc8 <slob_alloc>
c0105077:	83 c4 10             	add    $0x10,%esp
c010507a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c010507d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105081:	75 0a                	jne    c010508d <__kmalloc+0x69>
		return 0;
c0105083:	b8 00 00 00 00       	mov    $0x0,%eax
c0105088:	e9 84 00 00 00       	jmp    c0105111 <__kmalloc+0xed>

	bb->order = find_order(size);
c010508d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105090:	83 ec 0c             	sub    $0xc,%esp
c0105093:	50                   	push   %eax
c0105094:	e8 67 ff ff ff       	call   c0105000 <find_order>
c0105099:	83 c4 10             	add    $0x10,%esp
c010509c:	89 c2                	mov    %eax,%edx
c010509e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050a1:	89 10                	mov    %edx,(%eax)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c01050a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050a6:	8b 00                	mov    (%eax),%eax
c01050a8:	83 ec 08             	sub    $0x8,%esp
c01050ab:	50                   	push   %eax
c01050ac:	ff 75 0c             	pushl  0xc(%ebp)
c01050af:	e8 9b fb ff ff       	call   c0104c4f <__slob_get_free_pages>
c01050b4:	83 c4 10             	add    $0x10,%esp
c01050b7:	89 c2                	mov    %eax,%edx
c01050b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050bc:	89 50 04             	mov    %edx,0x4(%eax)

	if (bb->pages) {
c01050bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050c2:	8b 40 04             	mov    0x4(%eax),%eax
c01050c5:	85 c0                	test   %eax,%eax
c01050c7:	74 33                	je     c01050fc <__kmalloc+0xd8>
		spin_lock_irqsave(&block_lock, flags);
c01050c9:	e8 5c fa ff ff       	call   c0104b2a <__intr_save>
c01050ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c01050d1:	8b 15 68 9f 12 c0    	mov    0xc0129f68,%edx
c01050d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050da:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c01050dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050e0:	a3 68 9f 12 c0       	mov    %eax,0xc0129f68
		spin_unlock_irqrestore(&block_lock, flags);
c01050e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050e8:	83 ec 0c             	sub    $0xc,%esp
c01050eb:	50                   	push   %eax
c01050ec:	e8 63 fa ff ff       	call   c0104b54 <__intr_restore>
c01050f1:	83 c4 10             	add    $0x10,%esp
		return bb->pages;
c01050f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050f7:	8b 40 04             	mov    0x4(%eax),%eax
c01050fa:	eb 15                	jmp    c0105111 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c01050fc:	83 ec 08             	sub    $0x8,%esp
c01050ff:	6a 0c                	push   $0xc
c0105101:	ff 75 f0             	pushl  -0x10(%ebp)
c0105104:	e8 8e fd ff ff       	call   c0104e97 <slob_free>
c0105109:	83 c4 10             	add    $0x10,%esp
	return 0;
c010510c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105111:	c9                   	leave  
c0105112:	c3                   	ret    

c0105113 <kmalloc>:

void *
kmalloc(size_t size)
{
c0105113:	55                   	push   %ebp
c0105114:	89 e5                	mov    %esp,%ebp
c0105116:	83 ec 08             	sub    $0x8,%esp
  return __kmalloc(size, 0);
c0105119:	83 ec 08             	sub    $0x8,%esp
c010511c:	6a 00                	push   $0x0
c010511e:	ff 75 08             	pushl  0x8(%ebp)
c0105121:	e8 fe fe ff ff       	call   c0105024 <__kmalloc>
c0105126:	83 c4 10             	add    $0x10,%esp
}
c0105129:	c9                   	leave  
c010512a:	c3                   	ret    

c010512b <kfree>:


void kfree(void *block)
{
c010512b:	55                   	push   %ebp
c010512c:	89 e5                	mov    %esp,%ebp
c010512e:	83 ec 18             	sub    $0x18,%esp
	bigblock_t *bb, **last = &bigblocks;
c0105131:	c7 45 f0 68 9f 12 c0 	movl   $0xc0129f68,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0105138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010513c:	0f 84 ac 00 00 00    	je     c01051ee <kfree+0xc3>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0105142:	8b 45 08             	mov    0x8(%ebp),%eax
c0105145:	25 ff 0f 00 00       	and    $0xfff,%eax
c010514a:	85 c0                	test   %eax,%eax
c010514c:	0f 85 85 00 00 00    	jne    c01051d7 <kfree+0xac>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0105152:	e8 d3 f9 ff ff       	call   c0104b2a <__intr_save>
c0105157:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c010515a:	a1 68 9f 12 c0       	mov    0xc0129f68,%eax
c010515f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105162:	eb 5e                	jmp    c01051c2 <kfree+0x97>
			if (bb->pages == block) {
c0105164:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105167:	8b 40 04             	mov    0x4(%eax),%eax
c010516a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010516d:	75 41                	jne    c01051b0 <kfree+0x85>
				*last = bb->next;
c010516f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105172:	8b 50 08             	mov    0x8(%eax),%edx
c0105175:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105178:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c010517a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010517d:	83 ec 0c             	sub    $0xc,%esp
c0105180:	50                   	push   %eax
c0105181:	e8 ce f9 ff ff       	call   c0104b54 <__intr_restore>
c0105186:	83 c4 10             	add    $0x10,%esp
				__slob_free_pages((unsigned long)block, bb->order);
c0105189:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010518c:	8b 10                	mov    (%eax),%edx
c010518e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105191:	83 ec 08             	sub    $0x8,%esp
c0105194:	52                   	push   %edx
c0105195:	50                   	push   %eax
c0105196:	e8 f4 fa ff ff       	call   c0104c8f <__slob_free_pages>
c010519b:	83 c4 10             	add    $0x10,%esp
				slob_free(bb, sizeof(bigblock_t));
c010519e:	83 ec 08             	sub    $0x8,%esp
c01051a1:	6a 0c                	push   $0xc
c01051a3:	ff 75 f4             	pushl  -0xc(%ebp)
c01051a6:	e8 ec fc ff ff       	call   c0104e97 <slob_free>
c01051ab:	83 c4 10             	add    $0x10,%esp
				return;
c01051ae:	eb 3f                	jmp    c01051ef <kfree+0xc4>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01051b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051b3:	83 c0 08             	add    $0x8,%eax
c01051b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051bc:	8b 40 08             	mov    0x8(%eax),%eax
c01051bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051c6:	75 9c                	jne    c0105164 <kfree+0x39>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c01051c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051cb:	83 ec 0c             	sub    $0xc,%esp
c01051ce:	50                   	push   %eax
c01051cf:	e8 80 f9 ff ff       	call   c0104b54 <__intr_restore>
c01051d4:	83 c4 10             	add    $0x10,%esp
	}

	slob_free((slob_t *)block - 1, 0);
c01051d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01051da:	83 e8 08             	sub    $0x8,%eax
c01051dd:	83 ec 08             	sub    $0x8,%esp
c01051e0:	6a 00                	push   $0x0
c01051e2:	50                   	push   %eax
c01051e3:	e8 af fc ff ff       	call   c0104e97 <slob_free>
c01051e8:	83 c4 10             	add    $0x10,%esp
	return;
c01051eb:	90                   	nop
c01051ec:	eb 01                	jmp    c01051ef <kfree+0xc4>
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;
c01051ee:	90                   	nop
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
c01051ef:	c9                   	leave  
c01051f0:	c3                   	ret    

c01051f1 <ksize>:


unsigned int ksize(const void *block)
{
c01051f1:	55                   	push   %ebp
c01051f2:	89 e5                	mov    %esp,%ebp
c01051f4:	83 ec 18             	sub    $0x18,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c01051f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01051fb:	75 07                	jne    c0105204 <ksize+0x13>
		return 0;
c01051fd:	b8 00 00 00 00       	mov    $0x0,%eax
c0105202:	eb 73                	jmp    c0105277 <ksize+0x86>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0105204:	8b 45 08             	mov    0x8(%ebp),%eax
c0105207:	25 ff 0f 00 00       	and    $0xfff,%eax
c010520c:	85 c0                	test   %eax,%eax
c010520e:	75 5c                	jne    c010526c <ksize+0x7b>
		spin_lock_irqsave(&block_lock, flags);
c0105210:	e8 15 f9 ff ff       	call   c0104b2a <__intr_save>
c0105215:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0105218:	a1 68 9f 12 c0       	mov    0xc0129f68,%eax
c010521d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105220:	eb 35                	jmp    c0105257 <ksize+0x66>
			if (bb->pages == block) {
c0105222:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105225:	8b 40 04             	mov    0x4(%eax),%eax
c0105228:	3b 45 08             	cmp    0x8(%ebp),%eax
c010522b:	75 21                	jne    c010524e <ksize+0x5d>
				spin_unlock_irqrestore(&slob_lock, flags);
c010522d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105230:	83 ec 0c             	sub    $0xc,%esp
c0105233:	50                   	push   %eax
c0105234:	e8 1b f9 ff ff       	call   c0104b54 <__intr_restore>
c0105239:	83 c4 10             	add    $0x10,%esp
				return PAGE_SIZE << bb->order;
c010523c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010523f:	8b 00                	mov    (%eax),%eax
c0105241:	ba 00 10 00 00       	mov    $0x1000,%edx
c0105246:	89 c1                	mov    %eax,%ecx
c0105248:	d3 e2                	shl    %cl,%edx
c010524a:	89 d0                	mov    %edx,%eax
c010524c:	eb 29                	jmp    c0105277 <ksize+0x86>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c010524e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105251:	8b 40 08             	mov    0x8(%eax),%eax
c0105254:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105257:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010525b:	75 c5                	jne    c0105222 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c010525d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105260:	83 ec 0c             	sub    $0xc,%esp
c0105263:	50                   	push   %eax
c0105264:	e8 eb f8 ff ff       	call   c0104b54 <__intr_restore>
c0105269:	83 c4 10             	add    $0x10,%esp
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c010526c:	8b 45 08             	mov    0x8(%ebp),%eax
c010526f:	83 e8 08             	sub    $0x8,%eax
c0105272:	8b 00                	mov    (%eax),%eax
c0105274:	c1 e0 03             	shl    $0x3,%eax
}
c0105277:	c9                   	leave  
c0105278:	c3                   	ret    

c0105279 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105279:	55                   	push   %ebp
c010527a:	89 e5                	mov    %esp,%ebp
c010527c:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c010527f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105282:	c1 e8 0c             	shr    $0xc,%eax
c0105285:	89 c2                	mov    %eax,%edx
c0105287:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010528c:	39 c2                	cmp    %eax,%edx
c010528e:	72 14                	jb     c01052a4 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0105290:	83 ec 04             	sub    $0x4,%esp
c0105293:	68 30 b0 10 c0       	push   $0xc010b030
c0105298:	6a 5f                	push   $0x5f
c010529a:	68 4f b0 10 c0       	push   $0xc010b04f
c010529f:	e8 54 b1 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c01052a4:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c01052a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01052ac:	c1 ea 0c             	shr    $0xc,%edx
c01052af:	c1 e2 05             	shl    $0x5,%edx
c01052b2:	01 d0                	add    %edx,%eax
}
c01052b4:	c9                   	leave  
c01052b5:	c3                   	ret    

c01052b6 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01052b6:	55                   	push   %ebp
c01052b7:	89 e5                	mov    %esp,%ebp
c01052b9:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c01052bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01052bf:	83 e0 01             	and    $0x1,%eax
c01052c2:	85 c0                	test   %eax,%eax
c01052c4:	75 14                	jne    c01052da <pte2page+0x24>
        panic("pte2page called with invalid pte");
c01052c6:	83 ec 04             	sub    $0x4,%esp
c01052c9:	68 60 b0 10 c0       	push   $0xc010b060
c01052ce:	6a 71                	push   $0x71
c01052d0:	68 4f b0 10 c0       	push   $0xc010b04f
c01052d5:	e8 1e b1 ff ff       	call   c01003f8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01052da:	8b 45 08             	mov    0x8(%ebp),%eax
c01052dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01052e2:	83 ec 0c             	sub    $0xc,%esp
c01052e5:	50                   	push   %eax
c01052e6:	e8 8e ff ff ff       	call   c0105279 <pa2page>
c01052eb:	83 c4 10             	add    $0x10,%esp
}
c01052ee:	c9                   	leave  
c01052ef:	c3                   	ret    

c01052f0 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01052f0:	55                   	push   %ebp
c01052f1:	89 e5                	mov    %esp,%ebp
c01052f3:	83 ec 18             	sub    $0x18,%esp
     swapfs_init();
c01052f6:	e8 8c 32 00 00       	call   c0108587 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01052fb:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c0105300:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0105305:	76 0c                	jbe    c0105313 <swap_init+0x23>
c0105307:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c010530c:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0105311:	76 17                	jbe    c010532a <swap_init+0x3a>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0105313:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c0105318:	50                   	push   %eax
c0105319:	68 81 b0 10 c0       	push   $0xc010b081
c010531e:	6a 27                	push   $0x27
c0105320:	68 9c b0 10 c0       	push   $0xc010b09c
c0105325:	e8 ce b0 ff ff       	call   c01003f8 <__panic>
     }
     

    // LAB3 : set sm as FIFO/ENHANCED CLOCK
    sm = &swap_manager_fifo;
c010532a:	c7 05 74 9f 12 c0 20 	movl   $0xc0126a20,0xc0129f74
c0105331:	6a 12 c0 
    // sm = &swap_manager_enclock;

     int r = sm->init();
c0105334:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105339:	8b 40 04             	mov    0x4(%eax),%eax
c010533c:	ff d0                	call   *%eax
c010533e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0105341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105345:	75 27                	jne    c010536e <swap_init+0x7e>
     {
          swap_init_ok = 1;
c0105347:	c7 05 6c 9f 12 c0 01 	movl   $0x1,0xc0129f6c
c010534e:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0105351:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105356:	8b 00                	mov    (%eax),%eax
c0105358:	83 ec 08             	sub    $0x8,%esp
c010535b:	50                   	push   %eax
c010535c:	68 ab b0 10 c0       	push   $0xc010b0ab
c0105361:	e8 2c af ff ff       	call   c0100292 <cprintf>
c0105366:	83 c4 10             	add    $0x10,%esp
          check_swap();
c0105369:	e8 fa 03 00 00       	call   c0105768 <check_swap>
     }

     return r;
c010536e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105371:	c9                   	leave  
c0105372:	c3                   	ret    

c0105373 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0105373:	55                   	push   %ebp
c0105374:	89 e5                	mov    %esp,%ebp
c0105376:	83 ec 08             	sub    $0x8,%esp
     return sm->init_mm(mm);
c0105379:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c010537e:	8b 40 08             	mov    0x8(%eax),%eax
c0105381:	83 ec 0c             	sub    $0xc,%esp
c0105384:	ff 75 08             	pushl  0x8(%ebp)
c0105387:	ff d0                	call   *%eax
c0105389:	83 c4 10             	add    $0x10,%esp
}
c010538c:	c9                   	leave  
c010538d:	c3                   	ret    

c010538e <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010538e:	55                   	push   %ebp
c010538f:	89 e5                	mov    %esp,%ebp
c0105391:	83 ec 08             	sub    $0x8,%esp
     return sm->tick_event(mm);
c0105394:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105399:	8b 40 0c             	mov    0xc(%eax),%eax
c010539c:	83 ec 0c             	sub    $0xc,%esp
c010539f:	ff 75 08             	pushl  0x8(%ebp)
c01053a2:	ff d0                	call   *%eax
c01053a4:	83 c4 10             	add    $0x10,%esp
}
c01053a7:	c9                   	leave  
c01053a8:	c3                   	ret    

c01053a9 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01053a9:	55                   	push   %ebp
c01053aa:	89 e5                	mov    %esp,%ebp
c01053ac:	83 ec 08             	sub    $0x8,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01053af:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c01053b4:	8b 40 10             	mov    0x10(%eax),%eax
c01053b7:	ff 75 14             	pushl  0x14(%ebp)
c01053ba:	ff 75 10             	pushl  0x10(%ebp)
c01053bd:	ff 75 0c             	pushl  0xc(%ebp)
c01053c0:	ff 75 08             	pushl  0x8(%ebp)
c01053c3:	ff d0                	call   *%eax
c01053c5:	83 c4 10             	add    $0x10,%esp
}
c01053c8:	c9                   	leave  
c01053c9:	c3                   	ret    

c01053ca <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01053ca:	55                   	push   %ebp
c01053cb:	89 e5                	mov    %esp,%ebp
c01053cd:	83 ec 08             	sub    $0x8,%esp
     return sm->set_unswappable(mm, addr);
c01053d0:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c01053d5:	8b 40 14             	mov    0x14(%eax),%eax
c01053d8:	83 ec 08             	sub    $0x8,%esp
c01053db:	ff 75 0c             	pushl  0xc(%ebp)
c01053de:	ff 75 08             	pushl  0x8(%ebp)
c01053e1:	ff d0                	call   *%eax
c01053e3:	83 c4 10             	add    $0x10,%esp
}
c01053e6:	c9                   	leave  
c01053e7:	c3                   	ret    

c01053e8 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01053e8:	55                   	push   %ebp
c01053e9:	89 e5                	mov    %esp,%ebp
c01053eb:	83 ec 28             	sub    $0x28,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01053ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01053f5:	e9 2e 01 00 00       	jmp    c0105528 <swap_out+0x140>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01053fa:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c01053ff:	8b 40 18             	mov    0x18(%eax),%eax
c0105402:	83 ec 04             	sub    $0x4,%esp
c0105405:	ff 75 10             	pushl  0x10(%ebp)
c0105408:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c010540b:	52                   	push   %edx
c010540c:	ff 75 08             	pushl  0x8(%ebp)
c010540f:	ff d0                	call   *%eax
c0105411:	83 c4 10             	add    $0x10,%esp
c0105414:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0105417:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010541b:	74 18                	je     c0105435 <swap_out+0x4d>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c010541d:	83 ec 08             	sub    $0x8,%esp
c0105420:	ff 75 f4             	pushl  -0xc(%ebp)
c0105423:	68 c0 b0 10 c0       	push   $0xc010b0c0
c0105428:	e8 65 ae ff ff       	call   c0100292 <cprintf>
c010542d:	83 c4 10             	add    $0x10,%esp
c0105430:	e9 ff 00 00 00       	jmp    c0105534 <swap_out+0x14c>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0105435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105438:	8b 40 1c             	mov    0x1c(%eax),%eax
c010543b:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010543e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105441:	8b 40 0c             	mov    0xc(%eax),%eax
c0105444:	83 ec 04             	sub    $0x4,%esp
c0105447:	6a 00                	push   $0x0
c0105449:	ff 75 ec             	pushl  -0x14(%ebp)
c010544c:	50                   	push   %eax
c010544d:	e8 02 22 00 00       	call   c0107654 <get_pte>
c0105452:	83 c4 10             	add    $0x10,%esp
c0105455:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0105458:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010545b:	8b 00                	mov    (%eax),%eax
c010545d:	83 e0 01             	and    $0x1,%eax
c0105460:	85 c0                	test   %eax,%eax
c0105462:	75 16                	jne    c010547a <swap_out+0x92>
c0105464:	68 ed b0 10 c0       	push   $0xc010b0ed
c0105469:	68 02 b1 10 c0       	push   $0xc010b102
c010546e:	6a 6a                	push   $0x6a
c0105470:	68 9c b0 10 c0       	push   $0xc010b09c
c0105475:	e8 7e af ff ff       	call   c01003f8 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010547a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010547d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105480:	8b 52 1c             	mov    0x1c(%edx),%edx
c0105483:	c1 ea 0c             	shr    $0xc,%edx
c0105486:	83 c2 01             	add    $0x1,%edx
c0105489:	c1 e2 08             	shl    $0x8,%edx
c010548c:	83 ec 08             	sub    $0x8,%esp
c010548f:	50                   	push   %eax
c0105490:	52                   	push   %edx
c0105491:	e8 8d 31 00 00       	call   c0108623 <swapfs_write>
c0105496:	83 c4 10             	add    $0x10,%esp
c0105499:	85 c0                	test   %eax,%eax
c010549b:	74 2b                	je     c01054c8 <swap_out+0xe0>
                    cprintf("SWAP: failed to save\n");
c010549d:	83 ec 0c             	sub    $0xc,%esp
c01054a0:	68 17 b1 10 c0       	push   $0xc010b117
c01054a5:	e8 e8 ad ff ff       	call   c0100292 <cprintf>
c01054aa:	83 c4 10             	add    $0x10,%esp
                    sm->map_swappable(mm, v, page, 0);
c01054ad:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c01054b2:	8b 40 10             	mov    0x10(%eax),%eax
c01054b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054b8:	6a 00                	push   $0x0
c01054ba:	52                   	push   %edx
c01054bb:	ff 75 ec             	pushl  -0x14(%ebp)
c01054be:	ff 75 08             	pushl  0x8(%ebp)
c01054c1:	ff d0                	call   *%eax
c01054c3:	83 c4 10             	add    $0x10,%esp
c01054c6:	eb 5c                	jmp    c0105524 <swap_out+0x13c>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01054c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054cb:	8b 40 1c             	mov    0x1c(%eax),%eax
c01054ce:	c1 e8 0c             	shr    $0xc,%eax
c01054d1:	83 c0 01             	add    $0x1,%eax
c01054d4:	50                   	push   %eax
c01054d5:	ff 75 ec             	pushl  -0x14(%ebp)
c01054d8:	ff 75 f4             	pushl  -0xc(%ebp)
c01054db:	68 30 b1 10 c0       	push   $0xc010b130
c01054e0:	e8 ad ad ff ff       	call   c0100292 <cprintf>
c01054e5:	83 c4 10             	add    $0x10,%esp
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01054e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054eb:	8b 40 1c             	mov    0x1c(%eax),%eax
c01054ee:	c1 e8 0c             	shr    $0xc,%eax
c01054f1:	83 c0 01             	add    $0x1,%eax
c01054f4:	c1 e0 08             	shl    $0x8,%eax
c01054f7:	89 c2                	mov    %eax,%edx
c01054f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054fc:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01054fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105501:	83 ec 08             	sub    $0x8,%esp
c0105504:	6a 01                	push   $0x1
c0105506:	50                   	push   %eax
c0105507:	e8 48 1b 00 00       	call   c0107054 <free_pages>
c010550c:	83 c4 10             	add    $0x10,%esp
          }
          
          tlb_invalidate(mm->pgdir, v);
c010550f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105512:	8b 40 0c             	mov    0xc(%eax),%eax
c0105515:	83 ec 08             	sub    $0x8,%esp
c0105518:	ff 75 ec             	pushl  -0x14(%ebp)
c010551b:	50                   	push   %eax
c010551c:	e8 2b 24 00 00       	call   c010794c <tlb_invalidate>
c0105521:	83 c4 10             	add    $0x10,%esp

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0105524:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010552b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010552e:	0f 85 c6 fe ff ff    	jne    c01053fa <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0105534:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105537:	c9                   	leave  
c0105538:	c3                   	ret    

c0105539 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0105539:	55                   	push   %ebp
c010553a:	89 e5                	mov    %esp,%ebp
c010553c:	83 ec 18             	sub    $0x18,%esp
     struct Page *result = alloc_page();
c010553f:	83 ec 0c             	sub    $0xc,%esp
c0105542:	6a 01                	push   $0x1
c0105544:	e8 9f 1a 00 00       	call   c0106fe8 <alloc_pages>
c0105549:	83 c4 10             	add    $0x10,%esp
c010554c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c010554f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105553:	75 19                	jne    c010556e <swap_in+0x35>
c0105555:	68 70 b1 10 c0       	push   $0xc010b170
c010555a:	68 02 b1 10 c0       	push   $0xc010b102
c010555f:	68 80 00 00 00       	push   $0x80
c0105564:	68 9c b0 10 c0       	push   $0xc010b09c
c0105569:	e8 8a ae ff ff       	call   c01003f8 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010556e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105571:	8b 40 0c             	mov    0xc(%eax),%eax
c0105574:	83 ec 04             	sub    $0x4,%esp
c0105577:	6a 00                	push   $0x0
c0105579:	ff 75 0c             	pushl  0xc(%ebp)
c010557c:	50                   	push   %eax
c010557d:	e8 d2 20 00 00       	call   c0107654 <get_pte>
c0105582:	83 c4 10             	add    $0x10,%esp
c0105585:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0105588:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010558b:	8b 00                	mov    (%eax),%eax
c010558d:	83 ec 08             	sub    $0x8,%esp
c0105590:	ff 75 f4             	pushl  -0xc(%ebp)
c0105593:	50                   	push   %eax
c0105594:	e8 31 30 00 00       	call   c01085ca <swapfs_read>
c0105599:	83 c4 10             	add    $0x10,%esp
c010559c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010559f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01055a3:	74 1f                	je     c01055c4 <swap_in+0x8b>
     {
        assert(r!=0);
c01055a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01055a9:	75 19                	jne    c01055c4 <swap_in+0x8b>
c01055ab:	68 7d b1 10 c0       	push   $0xc010b17d
c01055b0:	68 02 b1 10 c0       	push   $0xc010b102
c01055b5:	68 88 00 00 00       	push   $0x88
c01055ba:	68 9c b0 10 c0       	push   $0xc010b09c
c01055bf:	e8 34 ae ff ff       	call   c01003f8 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01055c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055c7:	8b 00                	mov    (%eax),%eax
c01055c9:	c1 e8 08             	shr    $0x8,%eax
c01055cc:	83 ec 04             	sub    $0x4,%esp
c01055cf:	ff 75 0c             	pushl  0xc(%ebp)
c01055d2:	50                   	push   %eax
c01055d3:	68 84 b1 10 c0       	push   $0xc010b184
c01055d8:	e8 b5 ac ff ff       	call   c0100292 <cprintf>
c01055dd:	83 c4 10             	add    $0x10,%esp
     *ptr_result=result;
c01055e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01055e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055e6:	89 10                	mov    %edx,(%eax)
     return 0;
c01055e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01055ed:	c9                   	leave  
c01055ee:	c3                   	ret    

c01055ef <check_content_set>:



static inline void
check_content_set(void)
{
c01055ef:	55                   	push   %ebp
c01055f0:	89 e5                	mov    %esp,%ebp
c01055f2:	83 ec 08             	sub    $0x8,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01055f5:	b8 00 10 00 00       	mov    $0x1000,%eax
c01055fa:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01055fd:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0105602:	83 f8 01             	cmp    $0x1,%eax
c0105605:	74 19                	je     c0105620 <check_content_set+0x31>
c0105607:	68 c2 b1 10 c0       	push   $0xc010b1c2
c010560c:	68 02 b1 10 c0       	push   $0xc010b102
c0105611:	68 95 00 00 00       	push   $0x95
c0105616:	68 9c b0 10 c0       	push   $0xc010b09c
c010561b:	e8 d8 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0105620:	b8 10 10 00 00       	mov    $0x1010,%eax
c0105625:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0105628:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010562d:	83 f8 01             	cmp    $0x1,%eax
c0105630:	74 19                	je     c010564b <check_content_set+0x5c>
c0105632:	68 c2 b1 10 c0       	push   $0xc010b1c2
c0105637:	68 02 b1 10 c0       	push   $0xc010b102
c010563c:	68 97 00 00 00       	push   $0x97
c0105641:	68 9c b0 10 c0       	push   $0xc010b09c
c0105646:	e8 ad ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010564b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105650:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0105653:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0105658:	83 f8 02             	cmp    $0x2,%eax
c010565b:	74 19                	je     c0105676 <check_content_set+0x87>
c010565d:	68 d1 b1 10 c0       	push   $0xc010b1d1
c0105662:	68 02 b1 10 c0       	push   $0xc010b102
c0105667:	68 99 00 00 00       	push   $0x99
c010566c:	68 9c b0 10 c0       	push   $0xc010b09c
c0105671:	e8 82 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0105676:	b8 10 20 00 00       	mov    $0x2010,%eax
c010567b:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010567e:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0105683:	83 f8 02             	cmp    $0x2,%eax
c0105686:	74 19                	je     c01056a1 <check_content_set+0xb2>
c0105688:	68 d1 b1 10 c0       	push   $0xc010b1d1
c010568d:	68 02 b1 10 c0       	push   $0xc010b102
c0105692:	68 9b 00 00 00       	push   $0x9b
c0105697:	68 9c b0 10 c0       	push   $0xc010b09c
c010569c:	e8 57 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01056a1:	b8 00 30 00 00       	mov    $0x3000,%eax
c01056a6:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01056a9:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01056ae:	83 f8 03             	cmp    $0x3,%eax
c01056b1:	74 19                	je     c01056cc <check_content_set+0xdd>
c01056b3:	68 e0 b1 10 c0       	push   $0xc010b1e0
c01056b8:	68 02 b1 10 c0       	push   $0xc010b102
c01056bd:	68 9d 00 00 00       	push   $0x9d
c01056c2:	68 9c b0 10 c0       	push   $0xc010b09c
c01056c7:	e8 2c ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01056cc:	b8 10 30 00 00       	mov    $0x3010,%eax
c01056d1:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01056d4:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01056d9:	83 f8 03             	cmp    $0x3,%eax
c01056dc:	74 19                	je     c01056f7 <check_content_set+0x108>
c01056de:	68 e0 b1 10 c0       	push   $0xc010b1e0
c01056e3:	68 02 b1 10 c0       	push   $0xc010b102
c01056e8:	68 9f 00 00 00       	push   $0x9f
c01056ed:	68 9c b0 10 c0       	push   $0xc010b09c
c01056f2:	e8 01 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01056f7:	b8 00 40 00 00       	mov    $0x4000,%eax
c01056fc:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01056ff:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0105704:	83 f8 04             	cmp    $0x4,%eax
c0105707:	74 19                	je     c0105722 <check_content_set+0x133>
c0105709:	68 ef b1 10 c0       	push   $0xc010b1ef
c010570e:	68 02 b1 10 c0       	push   $0xc010b102
c0105713:	68 a1 00 00 00       	push   $0xa1
c0105718:	68 9c b0 10 c0       	push   $0xc010b09c
c010571d:	e8 d6 ac ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0105722:	b8 10 40 00 00       	mov    $0x4010,%eax
c0105727:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010572a:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010572f:	83 f8 04             	cmp    $0x4,%eax
c0105732:	74 19                	je     c010574d <check_content_set+0x15e>
c0105734:	68 ef b1 10 c0       	push   $0xc010b1ef
c0105739:	68 02 b1 10 c0       	push   $0xc010b102
c010573e:	68 a3 00 00 00       	push   $0xa3
c0105743:	68 9c b0 10 c0       	push   $0xc010b09c
c0105748:	e8 ab ac ff ff       	call   c01003f8 <__panic>
}
c010574d:	90                   	nop
c010574e:	c9                   	leave  
c010574f:	c3                   	ret    

c0105750 <check_content_access>:

static inline int
check_content_access(void)
{
c0105750:	55                   	push   %ebp
c0105751:	89 e5                	mov    %esp,%ebp
c0105753:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0105756:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c010575b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010575e:	ff d0                	call   *%eax
c0105760:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0105763:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105766:	c9                   	leave  
c0105767:	c3                   	ret    

c0105768 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0105768:	55                   	push   %ebp
c0105769:	89 e5                	mov    %esp,%ebp
c010576b:	83 ec 68             	sub    $0x68,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010576e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105775:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010577c:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0105783:	eb 60                	jmp    c01057e5 <check_swap+0x7d>
        struct Page *p = le2page(le, page_link);
c0105785:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105788:	83 e8 0c             	sub    $0xc,%eax
c010578b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(PageProperty(p));
c010578e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105791:	83 c0 04             	add    $0x4,%eax
c0105794:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010579b:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010579e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01057a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01057a4:	0f a3 10             	bt     %edx,(%eax)
c01057a7:	19 c0                	sbb    %eax,%eax
c01057a9:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c01057ac:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c01057b0:	0f 95 c0             	setne  %al
c01057b3:	0f b6 c0             	movzbl %al,%eax
c01057b6:	85 c0                	test   %eax,%eax
c01057b8:	75 19                	jne    c01057d3 <check_swap+0x6b>
c01057ba:	68 fe b1 10 c0       	push   $0xc010b1fe
c01057bf:	68 02 b1 10 c0       	push   $0xc010b102
c01057c4:	68 be 00 00 00       	push   $0xbe
c01057c9:	68 9c b0 10 c0       	push   $0xc010b09c
c01057ce:	e8 25 ac ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c01057d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01057d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057da:	8b 50 08             	mov    0x8(%eax),%edx
c01057dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057e0:	01 d0                	add    %edx,%eax
c01057e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01057eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057ee:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01057f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057f4:	81 7d e8 84 c1 12 c0 	cmpl   $0xc012c184,-0x18(%ebp)
c01057fb:	75 88                	jne    c0105785 <check_swap+0x1d>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01057fd:	e8 87 18 00 00       	call   c0107089 <nr_free_pages>
c0105802:	89 c2                	mov    %eax,%edx
c0105804:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105807:	39 c2                	cmp    %eax,%edx
c0105809:	74 19                	je     c0105824 <check_swap+0xbc>
c010580b:	68 0e b2 10 c0       	push   $0xc010b20e
c0105810:	68 02 b1 10 c0       	push   $0xc010b102
c0105815:	68 c1 00 00 00       	push   $0xc1
c010581a:	68 9c b0 10 c0       	push   $0xc010b09c
c010581f:	e8 d4 ab ff ff       	call   c01003f8 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0105824:	83 ec 04             	sub    $0x4,%esp
c0105827:	ff 75 f0             	pushl  -0x10(%ebp)
c010582a:	ff 75 f4             	pushl  -0xc(%ebp)
c010582d:	68 28 b2 10 c0       	push   $0xc010b228
c0105832:	e8 5b aa ff ff       	call   c0100292 <cprintf>
c0105837:	83 c4 10             	add    $0x10,%esp
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c010583a:	e8 50 e2 ff ff       	call   c0103a8f <mm_create>
c010583f:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(mm != NULL);
c0105842:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105846:	75 19                	jne    c0105861 <check_swap+0xf9>
c0105848:	68 4e b2 10 c0       	push   $0xc010b24e
c010584d:	68 02 b1 10 c0       	push   $0xc010b102
c0105852:	68 c6 00 00 00       	push   $0xc6
c0105857:	68 9c b0 10 c0       	push   $0xc010b09c
c010585c:	e8 97 ab ff ff       	call   c01003f8 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0105861:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c0105866:	85 c0                	test   %eax,%eax
c0105868:	74 19                	je     c0105883 <check_swap+0x11b>
c010586a:	68 59 b2 10 c0       	push   $0xc010b259
c010586f:	68 02 b1 10 c0       	push   $0xc010b102
c0105874:	68 c9 00 00 00       	push   $0xc9
c0105879:	68 9c b0 10 c0       	push   $0xc010b09c
c010587e:	e8 75 ab ff ff       	call   c01003f8 <__panic>

     check_mm_struct = mm;
c0105883:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105886:	a3 bc c0 12 c0       	mov    %eax,0xc012c0bc

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010588b:	8b 15 60 6a 12 c0    	mov    0xc0126a60,%edx
c0105891:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105894:	89 50 0c             	mov    %edx,0xc(%eax)
c0105897:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010589a:	8b 40 0c             	mov    0xc(%eax),%eax
c010589d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(pgdir[0] == 0);
c01058a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058a3:	8b 00                	mov    (%eax),%eax
c01058a5:	85 c0                	test   %eax,%eax
c01058a7:	74 19                	je     c01058c2 <check_swap+0x15a>
c01058a9:	68 71 b2 10 c0       	push   $0xc010b271
c01058ae:	68 02 b1 10 c0       	push   $0xc010b102
c01058b3:	68 ce 00 00 00       	push   $0xce
c01058b8:	68 9c b0 10 c0       	push   $0xc010b09c
c01058bd:	e8 36 ab ff ff       	call   c01003f8 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01058c2:	83 ec 04             	sub    $0x4,%esp
c01058c5:	6a 03                	push   $0x3
c01058c7:	68 00 60 00 00       	push   $0x6000
c01058cc:	68 00 10 00 00       	push   $0x1000
c01058d1:	e8 35 e2 ff ff       	call   c0103b0b <vma_create>
c01058d6:	83 c4 10             	add    $0x10,%esp
c01058d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(vma != NULL);
c01058dc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01058e0:	75 19                	jne    c01058fb <check_swap+0x193>
c01058e2:	68 7f b2 10 c0       	push   $0xc010b27f
c01058e7:	68 02 b1 10 c0       	push   $0xc010b102
c01058ec:	68 d1 00 00 00       	push   $0xd1
c01058f1:	68 9c b0 10 c0       	push   $0xc010b09c
c01058f6:	e8 fd aa ff ff       	call   c01003f8 <__panic>

     insert_vma_struct(mm, vma);
c01058fb:	83 ec 08             	sub    $0x8,%esp
c01058fe:	ff 75 d0             	pushl  -0x30(%ebp)
c0105901:	ff 75 d8             	pushl  -0x28(%ebp)
c0105904:	e8 6a e3 ff ff       	call   c0103c73 <insert_vma_struct>
c0105909:	83 c4 10             	add    $0x10,%esp

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010590c:	83 ec 0c             	sub    $0xc,%esp
c010590f:	68 8c b2 10 c0       	push   $0xc010b28c
c0105914:	e8 79 a9 ff ff       	call   c0100292 <cprintf>
c0105919:	83 c4 10             	add    $0x10,%esp
     pte_t *temp_ptep=NULL;
c010591c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0105923:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105926:	8b 40 0c             	mov    0xc(%eax),%eax
c0105929:	83 ec 04             	sub    $0x4,%esp
c010592c:	6a 01                	push   $0x1
c010592e:	68 00 10 00 00       	push   $0x1000
c0105933:	50                   	push   %eax
c0105934:	e8 1b 1d 00 00       	call   c0107654 <get_pte>
c0105939:	83 c4 10             	add    $0x10,%esp
c010593c:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(temp_ptep!= NULL);
c010593f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105943:	75 19                	jne    c010595e <check_swap+0x1f6>
c0105945:	68 c0 b2 10 c0       	push   $0xc010b2c0
c010594a:	68 02 b1 10 c0       	push   $0xc010b102
c010594f:	68 d9 00 00 00       	push   $0xd9
c0105954:	68 9c b0 10 c0       	push   $0xc010b09c
c0105959:	e8 9a aa ff ff       	call   c01003f8 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c010595e:	83 ec 0c             	sub    $0xc,%esp
c0105961:	68 d4 b2 10 c0       	push   $0xc010b2d4
c0105966:	e8 27 a9 ff ff       	call   c0100292 <cprintf>
c010596b:	83 c4 10             	add    $0x10,%esp
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010596e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105975:	e9 90 00 00 00       	jmp    c0105a0a <check_swap+0x2a2>
          check_rp[i] = alloc_page();
c010597a:	83 ec 0c             	sub    $0xc,%esp
c010597d:	6a 01                	push   $0x1
c010597f:	e8 64 16 00 00       	call   c0106fe8 <alloc_pages>
c0105984:	83 c4 10             	add    $0x10,%esp
c0105987:	89 c2                	mov    %eax,%edx
c0105989:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010598c:	89 14 85 c0 c0 12 c0 	mov    %edx,-0x3fed3f40(,%eax,4)
          assert(check_rp[i] != NULL );
c0105993:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105996:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c010599d:	85 c0                	test   %eax,%eax
c010599f:	75 19                	jne    c01059ba <check_swap+0x252>
c01059a1:	68 f8 b2 10 c0       	push   $0xc010b2f8
c01059a6:	68 02 b1 10 c0       	push   $0xc010b102
c01059ab:	68 de 00 00 00       	push   $0xde
c01059b0:	68 9c b0 10 c0       	push   $0xc010b09c
c01059b5:	e8 3e aa ff ff       	call   c01003f8 <__panic>
          assert(!PageProperty(check_rp[i]));
c01059ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059bd:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c01059c4:	83 c0 04             	add    $0x4,%eax
c01059c7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01059ce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01059d1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01059d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059d7:	0f a3 10             	bt     %edx,(%eax)
c01059da:	19 c0                	sbb    %eax,%eax
c01059dc:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c01059df:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c01059e3:	0f 95 c0             	setne  %al
c01059e6:	0f b6 c0             	movzbl %al,%eax
c01059e9:	85 c0                	test   %eax,%eax
c01059eb:	74 19                	je     c0105a06 <check_swap+0x29e>
c01059ed:	68 0c b3 10 c0       	push   $0xc010b30c
c01059f2:	68 02 b1 10 c0       	push   $0xc010b102
c01059f7:	68 df 00 00 00       	push   $0xdf
c01059fc:	68 9c b0 10 c0       	push   $0xc010b09c
c0105a01:	e8 f2 a9 ff ff       	call   c01003f8 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105a06:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105a0a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105a0e:	0f 8e 66 ff ff ff    	jle    c010597a <check_swap+0x212>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0105a14:	a1 84 c1 12 c0       	mov    0xc012c184,%eax
c0105a19:	8b 15 88 c1 12 c0    	mov    0xc012c188,%edx
c0105a1f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105a22:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105a25:	c7 45 c0 84 c1 12 c0 	movl   $0xc012c184,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105a2c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a2f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105a32:	89 50 04             	mov    %edx,0x4(%eax)
c0105a35:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a38:	8b 50 04             	mov    0x4(%eax),%edx
c0105a3b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a3e:	89 10                	mov    %edx,(%eax)
c0105a40:	c7 45 c8 84 c1 12 c0 	movl   $0xc012c184,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0105a47:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105a4a:	8b 40 04             	mov    0x4(%eax),%eax
c0105a4d:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c0105a50:	0f 94 c0             	sete   %al
c0105a53:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0105a56:	85 c0                	test   %eax,%eax
c0105a58:	75 19                	jne    c0105a73 <check_swap+0x30b>
c0105a5a:	68 27 b3 10 c0       	push   $0xc010b327
c0105a5f:	68 02 b1 10 c0       	push   $0xc010b102
c0105a64:	68 e3 00 00 00       	push   $0xe3
c0105a69:	68 9c b0 10 c0       	push   $0xc010b09c
c0105a6e:	e8 85 a9 ff ff       	call   c01003f8 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0105a73:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105a78:	89 45 bc             	mov    %eax,-0x44(%ebp)
     nr_free = 0;
c0105a7b:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0105a82:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105a85:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105a8c:	eb 1c                	jmp    c0105aaa <check_swap+0x342>
        free_pages(check_rp[i],1);
c0105a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a91:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c0105a98:	83 ec 08             	sub    $0x8,%esp
c0105a9b:	6a 01                	push   $0x1
c0105a9d:	50                   	push   %eax
c0105a9e:	e8 b1 15 00 00       	call   c0107054 <free_pages>
c0105aa3:	83 c4 10             	add    $0x10,%esp
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105aa6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105aaa:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105aae:	7e de                	jle    c0105a8e <check_swap+0x326>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0105ab0:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105ab5:	83 f8 04             	cmp    $0x4,%eax
c0105ab8:	74 19                	je     c0105ad3 <check_swap+0x36b>
c0105aba:	68 40 b3 10 c0       	push   $0xc010b340
c0105abf:	68 02 b1 10 c0       	push   $0xc010b102
c0105ac4:	68 ec 00 00 00       	push   $0xec
c0105ac9:	68 9c b0 10 c0       	push   $0xc010b09c
c0105ace:	e8 25 a9 ff ff       	call   c01003f8 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0105ad3:	83 ec 0c             	sub    $0xc,%esp
c0105ad6:	68 64 b3 10 c0       	push   $0xc010b364
c0105adb:	e8 b2 a7 ff ff       	call   c0100292 <cprintf>
c0105ae0:	83 c4 10             	add    $0x10,%esp
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0105ae3:	c7 05 64 9f 12 c0 00 	movl   $0x0,0xc0129f64
c0105aea:	00 00 00 
     
     check_content_set();
c0105aed:	e8 fd fa ff ff       	call   c01055ef <check_content_set>
     assert( nr_free == 0);         
c0105af2:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105af7:	85 c0                	test   %eax,%eax
c0105af9:	74 19                	je     c0105b14 <check_swap+0x3ac>
c0105afb:	68 8b b3 10 c0       	push   $0xc010b38b
c0105b00:	68 02 b1 10 c0       	push   $0xc010b102
c0105b05:	68 f5 00 00 00       	push   $0xf5
c0105b0a:	68 9c b0 10 c0       	push   $0xc010b09c
c0105b0f:	e8 e4 a8 ff ff       	call   c01003f8 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105b14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105b1b:	eb 26                	jmp    c0105b43 <check_swap+0x3db>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0105b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b20:	c7 04 85 e0 c0 12 c0 	movl   $0xffffffff,-0x3fed3f20(,%eax,4)
c0105b27:	ff ff ff ff 
c0105b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b2e:	8b 14 85 e0 c0 12 c0 	mov    -0x3fed3f20(,%eax,4),%edx
c0105b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b38:	89 14 85 20 c1 12 c0 	mov    %edx,-0x3fed3ee0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105b3f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105b43:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0105b47:	7e d4                	jle    c0105b1d <check_swap+0x3b5>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105b49:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105b50:	e9 cc 00 00 00       	jmp    c0105c21 <check_swap+0x4b9>
         check_ptep[i]=0;
c0105b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b58:	c7 04 85 74 c1 12 c0 	movl   $0x0,-0x3fed3e8c(,%eax,4)
c0105b5f:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0105b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b66:	83 c0 01             	add    $0x1,%eax
c0105b69:	c1 e0 0c             	shl    $0xc,%eax
c0105b6c:	83 ec 04             	sub    $0x4,%esp
c0105b6f:	6a 00                	push   $0x0
c0105b71:	50                   	push   %eax
c0105b72:	ff 75 d4             	pushl  -0x2c(%ebp)
c0105b75:	e8 da 1a 00 00       	call   c0107654 <get_pte>
c0105b7a:	83 c4 10             	add    $0x10,%esp
c0105b7d:	89 c2                	mov    %eax,%edx
c0105b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b82:	89 14 85 74 c1 12 c0 	mov    %edx,-0x3fed3e8c(,%eax,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0105b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b8c:	8b 04 85 74 c1 12 c0 	mov    -0x3fed3e8c(,%eax,4),%eax
c0105b93:	85 c0                	test   %eax,%eax
c0105b95:	75 19                	jne    c0105bb0 <check_swap+0x448>
c0105b97:	68 98 b3 10 c0       	push   $0xc010b398
c0105b9c:	68 02 b1 10 c0       	push   $0xc010b102
c0105ba1:	68 fd 00 00 00       	push   $0xfd
c0105ba6:	68 9c b0 10 c0       	push   $0xc010b09c
c0105bab:	e8 48 a8 ff ff       	call   c01003f8 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0105bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bb3:	8b 04 85 74 c1 12 c0 	mov    -0x3fed3e8c(,%eax,4),%eax
c0105bba:	8b 00                	mov    (%eax),%eax
c0105bbc:	83 ec 0c             	sub    $0xc,%esp
c0105bbf:	50                   	push   %eax
c0105bc0:	e8 f1 f6 ff ff       	call   c01052b6 <pte2page>
c0105bc5:	83 c4 10             	add    $0x10,%esp
c0105bc8:	89 c2                	mov    %eax,%edx
c0105bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bcd:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c0105bd4:	39 c2                	cmp    %eax,%edx
c0105bd6:	74 19                	je     c0105bf1 <check_swap+0x489>
c0105bd8:	68 b0 b3 10 c0       	push   $0xc010b3b0
c0105bdd:	68 02 b1 10 c0       	push   $0xc010b102
c0105be2:	68 fe 00 00 00       	push   $0xfe
c0105be7:	68 9c b0 10 c0       	push   $0xc010b09c
c0105bec:	e8 07 a8 ff ff       	call   c01003f8 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0105bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bf4:	8b 04 85 74 c1 12 c0 	mov    -0x3fed3e8c(,%eax,4),%eax
c0105bfb:	8b 00                	mov    (%eax),%eax
c0105bfd:	83 e0 01             	and    $0x1,%eax
c0105c00:	85 c0                	test   %eax,%eax
c0105c02:	75 19                	jne    c0105c1d <check_swap+0x4b5>
c0105c04:	68 d8 b3 10 c0       	push   $0xc010b3d8
c0105c09:	68 02 b1 10 c0       	push   $0xc010b102
c0105c0e:	68 ff 00 00 00       	push   $0xff
c0105c13:	68 9c b0 10 c0       	push   $0xc010b09c
c0105c18:	e8 db a7 ff ff       	call   c01003f8 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105c1d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105c21:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105c25:	0f 8e 2a ff ff ff    	jle    c0105b55 <check_swap+0x3ed>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0105c2b:	83 ec 0c             	sub    $0xc,%esp
c0105c2e:	68 f4 b3 10 c0       	push   $0xc010b3f4
c0105c33:	e8 5a a6 ff ff       	call   c0100292 <cprintf>
c0105c38:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0105c3b:	e8 10 fb ff ff       	call   c0105750 <check_content_access>
c0105c40:	89 45 b8             	mov    %eax,-0x48(%ebp)
     assert(ret==0);
c0105c43:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105c47:	74 19                	je     c0105c62 <check_swap+0x4fa>
c0105c49:	68 1a b4 10 c0       	push   $0xc010b41a
c0105c4e:	68 02 b1 10 c0       	push   $0xc010b102
c0105c53:	68 04 01 00 00       	push   $0x104
c0105c58:	68 9c b0 10 c0       	push   $0xc010b09c
c0105c5d:	e8 96 a7 ff ff       	call   c01003f8 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105c62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105c69:	eb 1c                	jmp    c0105c87 <check_swap+0x51f>
         free_pages(check_rp[i],1);
c0105c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c6e:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c0105c75:	83 ec 08             	sub    $0x8,%esp
c0105c78:	6a 01                	push   $0x1
c0105c7a:	50                   	push   %eax
c0105c7b:	e8 d4 13 00 00       	call   c0107054 <free_pages>
c0105c80:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105c83:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105c87:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105c8b:	7e de                	jle    c0105c6b <check_swap+0x503>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0105c8d:	83 ec 0c             	sub    $0xc,%esp
c0105c90:	ff 75 d8             	pushl  -0x28(%ebp)
c0105c93:	e8 ff e0 ff ff       	call   c0103d97 <mm_destroy>
c0105c98:	83 c4 10             	add    $0x10,%esp
         
     nr_free = nr_free_store;
c0105c9b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105c9e:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
     free_list = free_list_store;
c0105ca3:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105ca6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105ca9:	a3 84 c1 12 c0       	mov    %eax,0xc012c184
c0105cae:	89 15 88 c1 12 c0    	mov    %edx,0xc012c188

     
     le = &free_list;
c0105cb4:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0105cbb:	eb 1d                	jmp    c0105cda <check_swap+0x572>
         struct Page *p = le2page(le, page_link);
c0105cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cc0:	83 e8 0c             	sub    $0xc,%eax
c0105cc3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
         count --, total -= p->property;
c0105cc6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105cca:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ccd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105cd0:	8b 40 08             	mov    0x8(%eax),%eax
c0105cd3:	29 c2                	sub    %eax,%edx
c0105cd5:	89 d0                	mov    %edx,%eax
c0105cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cda:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cdd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105ce0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105ce3:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0105ce6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ce9:	81 7d e8 84 c1 12 c0 	cmpl   $0xc012c184,-0x18(%ebp)
c0105cf0:	75 cb                	jne    c0105cbd <check_swap+0x555>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0105cf2:	83 ec 04             	sub    $0x4,%esp
c0105cf5:	ff 75 f0             	pushl  -0x10(%ebp)
c0105cf8:	ff 75 f4             	pushl  -0xc(%ebp)
c0105cfb:	68 21 b4 10 c0       	push   $0xc010b421
c0105d00:	e8 8d a5 ff ff       	call   c0100292 <cprintf>
c0105d05:	83 c4 10             	add    $0x10,%esp
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0105d08:	83 ec 0c             	sub    $0xc,%esp
c0105d0b:	68 3b b4 10 c0       	push   $0xc010b43b
c0105d10:	e8 7d a5 ff ff       	call   c0100292 <cprintf>
c0105d15:	83 c4 10             	add    $0x10,%esp
}
c0105d18:	90                   	nop
c0105d19:	c9                   	leave  
c0105d1a:	c3                   	ret    

c0105d1b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0105d1b:	55                   	push   %ebp
c0105d1c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0105d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d21:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0105d27:	29 d0                	sub    %edx,%eax
c0105d29:	c1 f8 05             	sar    $0x5,%eax
}
c0105d2c:	5d                   	pop    %ebp
c0105d2d:	c3                   	ret    

c0105d2e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0105d2e:	55                   	push   %ebp
c0105d2f:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0105d31:	ff 75 08             	pushl  0x8(%ebp)
c0105d34:	e8 e2 ff ff ff       	call   c0105d1b <page2ppn>
c0105d39:	83 c4 04             	add    $0x4,%esp
c0105d3c:	c1 e0 0c             	shl    $0xc,%eax
}
c0105d3f:	c9                   	leave  
c0105d40:	c3                   	ret    

c0105d41 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0105d41:	55                   	push   %ebp
c0105d42:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d47:	8b 00                	mov    (%eax),%eax
}
c0105d49:	5d                   	pop    %ebp
c0105d4a:	c3                   	ret    

c0105d4b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0105d4b:	55                   	push   %ebp
c0105d4c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d54:	89 10                	mov    %edx,(%eax)
}
c0105d56:	90                   	nop
c0105d57:	5d                   	pop    %ebp
c0105d58:	c3                   	ret    

c0105d59 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0105d59:	55                   	push   %ebp
c0105d5a:	89 e5                	mov    %esp,%ebp
c0105d5c:	83 ec 10             	sub    $0x10,%esp
c0105d5f:	c7 45 fc 84 c1 12 c0 	movl   $0xc012c184,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d69:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0105d6c:	89 50 04             	mov    %edx,0x4(%eax)
c0105d6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d72:	8b 50 04             	mov    0x4(%eax),%edx
c0105d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d78:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0105d7a:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0105d81:	00 00 00 
}
c0105d84:	90                   	nop
c0105d85:	c9                   	leave  
c0105d86:	c3                   	ret    

c0105d87 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0105d87:	55                   	push   %ebp
c0105d88:	89 e5                	mov    %esp,%ebp
c0105d8a:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0105d8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d91:	75 16                	jne    c0105da9 <default_init_memmap+0x22>
c0105d93:	68 54 b4 10 c0       	push   $0xc010b454
c0105d98:	68 5a b4 10 c0       	push   $0xc010b45a
c0105d9d:	6a 6d                	push   $0x6d
c0105d9f:	68 6f b4 10 c0       	push   $0xc010b46f
c0105da4:	e8 4f a6 ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c0105da9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105daf:	eb 6c                	jmp    c0105e1d <default_init_memmap+0x96>
        assert(PageReserved(p));
c0105db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105db4:	83 c0 04             	add    $0x4,%eax
c0105db7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0105dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105dc7:	0f a3 10             	bt     %edx,(%eax)
c0105dca:	19 c0                	sbb    %eax,%eax
c0105dcc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0105dcf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105dd3:	0f 95 c0             	setne  %al
c0105dd6:	0f b6 c0             	movzbl %al,%eax
c0105dd9:	85 c0                	test   %eax,%eax
c0105ddb:	75 16                	jne    c0105df3 <default_init_memmap+0x6c>
c0105ddd:	68 85 b4 10 c0       	push   $0xc010b485
c0105de2:	68 5a b4 10 c0       	push   $0xc010b45a
c0105de7:	6a 70                	push   $0x70
c0105de9:	68 6f b4 10 c0       	push   $0xc010b46f
c0105dee:	e8 05 a6 ff ff       	call   c01003f8 <__panic>
        p->flags = p->property = 0;
c0105df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105df6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0105dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e00:	8b 50 08             	mov    0x8(%eax),%edx
c0105e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e06:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0105e09:	83 ec 08             	sub    $0x8,%esp
c0105e0c:	6a 00                	push   $0x0
c0105e0e:	ff 75 f4             	pushl  -0xc(%ebp)
c0105e11:	e8 35 ff ff ff       	call   c0105d4b <set_page_ref>
c0105e16:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0105e19:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e20:	c1 e0 05             	shl    $0x5,%eax
c0105e23:	89 c2                	mov    %eax,%edx
c0105e25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e28:	01 d0                	add    %edx,%eax
c0105e2a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e2d:	75 82                	jne    c0105db1 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0105e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e32:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e35:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3b:	83 c0 04             	add    $0x4,%eax
c0105e3e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0105e45:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105e48:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105e4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e4e:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105e51:	8b 15 8c c1 12 c0    	mov    0xc012c18c,%edx
c0105e57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e5a:	01 d0                	add    %edx,%eax
c0105e5c:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
    list_add(&free_list, &(base->page_link));
c0105e61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e64:	83 c0 0c             	add    $0xc,%eax
c0105e67:	c7 45 f0 84 c1 12 c0 	movl   $0xc012c184,-0x10(%ebp)
c0105e6e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e74:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105e7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e80:	8b 40 04             	mov    0x4(%eax),%eax
c0105e83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105e86:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0105e89:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e8c:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105e8f:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105e92:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105e95:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105e98:	89 10                	mov    %edx,(%eax)
c0105e9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105e9d:	8b 10                	mov    (%eax),%edx
c0105e9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105ea2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105ea5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105ea8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105eab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105eae:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105eb1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105eb4:	89 10                	mov    %edx,(%eax)
}
c0105eb6:	90                   	nop
c0105eb7:	c9                   	leave  
c0105eb8:	c3                   	ret    

c0105eb9 <default_alloc_pages>:

// LAB2 MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
c0105eb9:	55                   	push   %ebp
c0105eba:	89 e5                	mov    %esp,%ebp
c0105ebc:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0105ebf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ec3:	75 16                	jne    c0105edb <default_alloc_pages+0x22>
c0105ec5:	68 54 b4 10 c0       	push   $0xc010b454
c0105eca:	68 5a b4 10 c0       	push   $0xc010b45a
c0105ecf:	6a 7d                	push   $0x7d
c0105ed1:	68 6f b4 10 c0       	push   $0xc010b46f
c0105ed6:	e8 1d a5 ff ff       	call   c01003f8 <__panic>
    if (n > nr_free) {
c0105edb:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105ee0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105ee3:	73 0a                	jae    c0105eef <default_alloc_pages+0x36>
        return NULL;
c0105ee5:	b8 00 00 00 00       	mov    $0x0,%eax
c0105eea:	e9 41 01 00 00       	jmp    c0106030 <default_alloc_pages+0x177>
    }
    struct Page *page = NULL;
c0105eef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0105ef6:	c7 45 f0 84 c1 12 c0 	movl   $0xc012c184,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105efd:	eb 1c                	jmp    c0105f1b <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c0105eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f02:	83 e8 0c             	sub    $0xc,%eax
c0105f05:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0105f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f0b:	8b 40 08             	mov    0x8(%eax),%eax
c0105f0e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105f11:	72 08                	jb     c0105f1b <default_alloc_pages+0x62>
            page = p;
c0105f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0105f19:	eb 18                	jmp    c0105f33 <default_alloc_pages+0x7a>
c0105f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105f21:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105f24:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0105f27:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f2a:	81 7d f0 84 c1 12 c0 	cmpl   $0xc012c184,-0x10(%ebp)
c0105f31:	75 cc                	jne    c0105eff <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0105f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105f37:	0f 84 f0 00 00 00    	je     c010602d <default_alloc_pages+0x174>
c0105f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f40:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105f43:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f46:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
c0105f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
c0105f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f4f:	83 c0 0c             	add    $0xc,%eax
c0105f52:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f58:	8b 40 04             	mov    0x4(%eax),%eax
c0105f5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105f5e:	8b 12                	mov    (%edx),%edx
c0105f60:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f63:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105f66:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105f69:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105f6c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105f6f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105f72:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105f75:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0105f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f7a:	8b 40 08             	mov    0x8(%eax),%eax
c0105f7d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105f80:	0f 86 81 00 00 00    	jbe    c0106007 <default_alloc_pages+0x14e>
            struct Page *p = page + n;                      // split the allocated page
c0105f86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f89:	c1 e0 05             	shl    $0x5,%eax
c0105f8c:	89 c2                	mov    %eax,%edx
c0105f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f91:	01 d0                	add    %edx,%eax
c0105f93:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
c0105f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f99:	8b 40 08             	mov    0x8(%eax),%eax
c0105f9c:	2b 45 08             	sub    0x8(%ebp),%eax
c0105f9f:	89 c2                	mov    %eax,%edx
c0105fa1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105fa4:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
c0105fa7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105faa:	83 c0 04             	add    $0x4,%eax
c0105fad:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105fb4:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105fb7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105fba:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105fbd:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
c0105fc0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105fc3:	8d 50 0c             	lea    0xc(%eax),%edx
c0105fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105fcc:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fd2:	8b 00                	mov    (%eax),%eax
c0105fd4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105fd7:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105fda:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0105fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fe0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105fe3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105fe6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105fe9:	89 10                	mov    %edx,(%eax)
c0105feb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105fee:	8b 10                	mov    (%eax),%edx
c0105ff0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105ff3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105ff6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105ff9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105ffc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105fff:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106002:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0106005:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c0106007:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c010600c:	2b 45 08             	sub    0x8(%ebp),%eax
c010600f:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
        ClearPageProperty(page);    // mark as "not head page"
c0106014:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106017:	83 c0 04             	add    $0x4,%eax
c010601a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0106021:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106024:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106027:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010602a:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010602d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106030:	c9                   	leave  
c0106031:	c3                   	ret    

c0106032 <default_free_pages>:

// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
c0106032:	55                   	push   %ebp
c0106033:	89 e5                	mov    %esp,%ebp
c0106035:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010603b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010603f:	75 19                	jne    c010605a <default_free_pages+0x28>
c0106041:	68 54 b4 10 c0       	push   $0xc010b454
c0106046:	68 5a b4 10 c0       	push   $0xc010b45a
c010604b:	68 9c 00 00 00       	push   $0x9c
c0106050:	68 6f b4 10 c0       	push   $0xc010b46f
c0106055:	e8 9e a3 ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c010605a:	8b 45 08             	mov    0x8(%ebp),%eax
c010605d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0106060:	e9 8f 00 00 00       	jmp    c01060f4 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c0106065:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106068:	83 c0 04             	add    $0x4,%eax
c010606b:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0106072:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106075:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106078:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010607b:	0f a3 10             	bt     %edx,(%eax)
c010607e:	19 c0                	sbb    %eax,%eax
c0106080:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0106083:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0106087:	0f 95 c0             	setne  %al
c010608a:	0f b6 c0             	movzbl %al,%eax
c010608d:	85 c0                	test   %eax,%eax
c010608f:	75 2c                	jne    c01060bd <default_free_pages+0x8b>
c0106091:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106094:	83 c0 04             	add    $0x4,%eax
c0106097:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c010609e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01060a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01060a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01060a7:	0f a3 10             	bt     %edx,(%eax)
c01060aa:	19 c0                	sbb    %eax,%eax
c01060ac:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
c01060af:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
c01060b3:	0f 95 c0             	setne  %al
c01060b6:	0f b6 c0             	movzbl %al,%eax
c01060b9:	85 c0                	test   %eax,%eax
c01060bb:	74 19                	je     c01060d6 <default_free_pages+0xa4>
c01060bd:	68 98 b4 10 c0       	push   $0xc010b498
c01060c2:	68 5a b4 10 c0       	push   $0xc010b45a
c01060c7:	68 9f 00 00 00       	push   $0x9f
c01060cc:	68 6f b4 10 c0       	push   $0xc010b46f
c01060d1:	e8 22 a3 ff ff       	call   c01003f8 <__panic>
        p->flags = 0;
c01060d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
c01060e0:	83 ec 08             	sub    $0x8,%esp
c01060e3:	6a 00                	push   $0x0
c01060e5:	ff 75 f4             	pushl  -0xc(%ebp)
c01060e8:	e8 5e fc ff ff       	call   c0105d4b <set_page_ref>
c01060ed:	83 c4 10             	add    $0x10,%esp
// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01060f0:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01060f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060f7:	c1 e0 05             	shl    $0x5,%eax
c01060fa:	89 c2                	mov    %eax,%edx
c01060fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ff:	01 d0                	add    %edx,%eax
c0106101:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106104:	0f 85 5b ff ff ff    	jne    c0106065 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
c010610a:	8b 45 08             	mov    0x8(%ebp),%eax
c010610d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106110:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0106113:	8b 45 08             	mov    0x8(%ebp),%eax
c0106116:	83 c0 04             	add    $0x4,%eax
c0106119:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0106120:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106123:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106126:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106129:	0f ab 10             	bts    %edx,(%eax)
c010612c:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106133:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106136:	8b 40 04             	mov    0x4(%eax),%eax
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
c0106139:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010613c:	e9 0e 01 00 00       	jmp    c010624f <default_free_pages+0x21d>
        p = le2page(le, page_link);
c0106141:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106144:	83 e8 0c             	sub    $0xc,%eax
c0106147:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010614a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010614d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106153:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0106156:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
c0106159:	8b 45 08             	mov    0x8(%ebp),%eax
c010615c:	8b 40 08             	mov    0x8(%eax),%eax
c010615f:	c1 e0 05             	shl    $0x5,%eax
c0106162:	89 c2                	mov    %eax,%edx
c0106164:	8b 45 08             	mov    0x8(%ebp),%eax
c0106167:	01 d0                	add    %edx,%eax
c0106169:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010616c:	75 64                	jne    c01061d2 <default_free_pages+0x1a0>
            base->property += p->property;
c010616e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106171:	8b 50 08             	mov    0x8(%eax),%edx
c0106174:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106177:	8b 40 08             	mov    0x8(%eax),%eax
c010617a:	01 c2                	add    %eax,%edx
c010617c:	8b 45 08             	mov    0x8(%ebp),%eax
c010617f:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
c0106182:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106185:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c010618c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010618f:	83 c0 04             	add    $0x4,%eax
c0106192:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0106199:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010619c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010619f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01061a2:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c01061a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061a8:	83 c0 0c             	add    $0xc,%eax
c01061ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01061ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01061b1:	8b 40 04             	mov    0x4(%eax),%eax
c01061b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01061b7:	8b 12                	mov    (%edx),%edx
c01061b9:	89 55 a8             	mov    %edx,-0x58(%ebp)
c01061bc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01061bf:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01061c2:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01061c5:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01061c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01061cb:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01061ce:	89 10                	mov    %edx,(%eax)
c01061d0:	eb 7d                	jmp    c010624f <default_free_pages+0x21d>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
c01061d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061d5:	8b 40 08             	mov    0x8(%eax),%eax
c01061d8:	c1 e0 05             	shl    $0x5,%eax
c01061db:	89 c2                	mov    %eax,%edx
c01061dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061e0:	01 d0                	add    %edx,%eax
c01061e2:	3b 45 08             	cmp    0x8(%ebp),%eax
c01061e5:	75 68                	jne    c010624f <default_free_pages+0x21d>
            p->property += base->property;
c01061e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061ea:	8b 50 08             	mov    0x8(%eax),%edx
c01061ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01061f0:	8b 40 08             	mov    0x8(%eax),%eax
c01061f3:	01 c2                	add    %eax,%edx
c01061f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061f8:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
c01061fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01061fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
c0106205:	8b 45 08             	mov    0x8(%ebp),%eax
c0106208:	83 c0 04             	add    $0x4,%eax
c010620b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0106212:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0106215:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106218:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010621b:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c010621e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106221:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0106224:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106227:	83 c0 0c             	add    $0xc,%eax
c010622a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010622d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106230:	8b 40 04             	mov    0x4(%eax),%eax
c0106233:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106236:	8b 12                	mov    (%edx),%edx
c0106238:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010623b:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010623e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106241:	8b 55 98             	mov    -0x68(%ebp),%edx
c0106244:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106247:	8b 45 98             	mov    -0x68(%ebp),%eax
c010624a:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010624d:	89 10                	mov    %edx,(%eax)
    }
    base->property = n;
    SetPageProperty(base);
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c010624f:	81 7d f0 84 c1 12 c0 	cmpl   $0xc012c184,-0x10(%ebp)
c0106256:	0f 85 e5 fe ff ff    	jne    c0106141 <default_free_pages+0x10f>
c010625c:	c7 45 d0 84 c1 12 c0 	movl   $0xc012c184,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106263:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106266:	8b 40 04             	mov    0x4(%eax),%eax
            base = p;
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
c0106269:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010626c:	eb 20                	jmp    c010628e <default_free_pages+0x25c>
        p = le2page(le, page_link);
c010626e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106271:	83 e8 0c             	sub    $0xc,%eax
c0106274:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
c0106277:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010627a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010627d:	77 1a                	ja     c0106299 <default_free_pages+0x267>
c010627f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106282:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106285:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106288:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c010628b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
c010628e:	81 7d f0 84 c1 12 c0 	cmpl   $0xc012c184,-0x10(%ebp)
c0106295:	75 d7                	jne    c010626e <default_free_pages+0x23c>
c0106297:	eb 01                	jmp    c010629a <default_free_pages+0x268>
        p = le2page(le, page_link);
        if (p > base) {
            break;
c0106299:	90                   	nop
        }
        le = list_next(le);
    }
    nr_free += n;
c010629a:	8b 15 8c c1 12 c0    	mov    0xc012c18c,%edx
c01062a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062a3:	01 d0                	add    %edx,%eax
c01062a5:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
    list_add_before(le, &(base->page_link)); 
c01062aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01062ad:	8d 50 0c             	lea    0xc(%eax),%edx
c01062b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062b3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01062b6:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01062b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01062bc:	8b 00                	mov    (%eax),%eax
c01062be:	8b 55 90             	mov    -0x70(%ebp),%edx
c01062c1:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01062c4:	89 45 88             	mov    %eax,-0x78(%ebp)
c01062c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01062ca:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01062cd:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01062d0:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01062d3:	89 10                	mov    %edx,(%eax)
c01062d5:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01062d8:	8b 10                	mov    (%eax),%edx
c01062da:	8b 45 88             	mov    -0x78(%ebp),%eax
c01062dd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01062e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01062e3:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01062e6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01062e9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01062ec:	8b 55 88             	mov    -0x78(%ebp),%edx
c01062ef:	89 10                	mov    %edx,(%eax)
}
c01062f1:	90                   	nop
c01062f2:	c9                   	leave  
c01062f3:	c3                   	ret    

c01062f4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01062f4:	55                   	push   %ebp
c01062f5:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01062f7:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
}
c01062fc:	5d                   	pop    %ebp
c01062fd:	c3                   	ret    

c01062fe <basic_check>:

static void
basic_check(void) {
c01062fe:	55                   	push   %ebp
c01062ff:	89 e5                	mov    %esp,%ebp
c0106301:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0106304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010630b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010630e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106311:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106314:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0106317:	83 ec 0c             	sub    $0xc,%esp
c010631a:	6a 01                	push   $0x1
c010631c:	e8 c7 0c 00 00       	call   c0106fe8 <alloc_pages>
c0106321:	83 c4 10             	add    $0x10,%esp
c0106324:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106327:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010632b:	75 19                	jne    c0106346 <basic_check+0x48>
c010632d:	68 bd b4 10 c0       	push   $0xc010b4bd
c0106332:	68 5a b4 10 c0       	push   $0xc010b45a
c0106337:	68 d0 00 00 00       	push   $0xd0
c010633c:	68 6f b4 10 c0       	push   $0xc010b46f
c0106341:	e8 b2 a0 ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0106346:	83 ec 0c             	sub    $0xc,%esp
c0106349:	6a 01                	push   $0x1
c010634b:	e8 98 0c 00 00       	call   c0106fe8 <alloc_pages>
c0106350:	83 c4 10             	add    $0x10,%esp
c0106353:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010635a:	75 19                	jne    c0106375 <basic_check+0x77>
c010635c:	68 d9 b4 10 c0       	push   $0xc010b4d9
c0106361:	68 5a b4 10 c0       	push   $0xc010b45a
c0106366:	68 d1 00 00 00       	push   $0xd1
c010636b:	68 6f b4 10 c0       	push   $0xc010b46f
c0106370:	e8 83 a0 ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0106375:	83 ec 0c             	sub    $0xc,%esp
c0106378:	6a 01                	push   $0x1
c010637a:	e8 69 0c 00 00       	call   c0106fe8 <alloc_pages>
c010637f:	83 c4 10             	add    $0x10,%esp
c0106382:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106389:	75 19                	jne    c01063a4 <basic_check+0xa6>
c010638b:	68 f5 b4 10 c0       	push   $0xc010b4f5
c0106390:	68 5a b4 10 c0       	push   $0xc010b45a
c0106395:	68 d2 00 00 00       	push   $0xd2
c010639a:	68 6f b4 10 c0       	push   $0xc010b46f
c010639f:	e8 54 a0 ff ff       	call   c01003f8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01063a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01063aa:	74 10                	je     c01063bc <basic_check+0xbe>
c01063ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01063b2:	74 08                	je     c01063bc <basic_check+0xbe>
c01063b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01063ba:	75 19                	jne    c01063d5 <basic_check+0xd7>
c01063bc:	68 14 b5 10 c0       	push   $0xc010b514
c01063c1:	68 5a b4 10 c0       	push   $0xc010b45a
c01063c6:	68 d4 00 00 00       	push   $0xd4
c01063cb:	68 6f b4 10 c0       	push   $0xc010b46f
c01063d0:	e8 23 a0 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01063d5:	83 ec 0c             	sub    $0xc,%esp
c01063d8:	ff 75 ec             	pushl  -0x14(%ebp)
c01063db:	e8 61 f9 ff ff       	call   c0105d41 <page_ref>
c01063e0:	83 c4 10             	add    $0x10,%esp
c01063e3:	85 c0                	test   %eax,%eax
c01063e5:	75 24                	jne    c010640b <basic_check+0x10d>
c01063e7:	83 ec 0c             	sub    $0xc,%esp
c01063ea:	ff 75 f0             	pushl  -0x10(%ebp)
c01063ed:	e8 4f f9 ff ff       	call   c0105d41 <page_ref>
c01063f2:	83 c4 10             	add    $0x10,%esp
c01063f5:	85 c0                	test   %eax,%eax
c01063f7:	75 12                	jne    c010640b <basic_check+0x10d>
c01063f9:	83 ec 0c             	sub    $0xc,%esp
c01063fc:	ff 75 f4             	pushl  -0xc(%ebp)
c01063ff:	e8 3d f9 ff ff       	call   c0105d41 <page_ref>
c0106404:	83 c4 10             	add    $0x10,%esp
c0106407:	85 c0                	test   %eax,%eax
c0106409:	74 19                	je     c0106424 <basic_check+0x126>
c010640b:	68 38 b5 10 c0       	push   $0xc010b538
c0106410:	68 5a b4 10 c0       	push   $0xc010b45a
c0106415:	68 d5 00 00 00       	push   $0xd5
c010641a:	68 6f b4 10 c0       	push   $0xc010b46f
c010641f:	e8 d4 9f ff ff       	call   c01003f8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0106424:	83 ec 0c             	sub    $0xc,%esp
c0106427:	ff 75 ec             	pushl  -0x14(%ebp)
c010642a:	e8 ff f8 ff ff       	call   c0105d2e <page2pa>
c010642f:	83 c4 10             	add    $0x10,%esp
c0106432:	89 c2                	mov    %eax,%edx
c0106434:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0106439:	c1 e0 0c             	shl    $0xc,%eax
c010643c:	39 c2                	cmp    %eax,%edx
c010643e:	72 19                	jb     c0106459 <basic_check+0x15b>
c0106440:	68 74 b5 10 c0       	push   $0xc010b574
c0106445:	68 5a b4 10 c0       	push   $0xc010b45a
c010644a:	68 d7 00 00 00       	push   $0xd7
c010644f:	68 6f b4 10 c0       	push   $0xc010b46f
c0106454:	e8 9f 9f ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0106459:	83 ec 0c             	sub    $0xc,%esp
c010645c:	ff 75 f0             	pushl  -0x10(%ebp)
c010645f:	e8 ca f8 ff ff       	call   c0105d2e <page2pa>
c0106464:	83 c4 10             	add    $0x10,%esp
c0106467:	89 c2                	mov    %eax,%edx
c0106469:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010646e:	c1 e0 0c             	shl    $0xc,%eax
c0106471:	39 c2                	cmp    %eax,%edx
c0106473:	72 19                	jb     c010648e <basic_check+0x190>
c0106475:	68 91 b5 10 c0       	push   $0xc010b591
c010647a:	68 5a b4 10 c0       	push   $0xc010b45a
c010647f:	68 d8 00 00 00       	push   $0xd8
c0106484:	68 6f b4 10 c0       	push   $0xc010b46f
c0106489:	e8 6a 9f ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010648e:	83 ec 0c             	sub    $0xc,%esp
c0106491:	ff 75 f4             	pushl  -0xc(%ebp)
c0106494:	e8 95 f8 ff ff       	call   c0105d2e <page2pa>
c0106499:	83 c4 10             	add    $0x10,%esp
c010649c:	89 c2                	mov    %eax,%edx
c010649e:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c01064a3:	c1 e0 0c             	shl    $0xc,%eax
c01064a6:	39 c2                	cmp    %eax,%edx
c01064a8:	72 19                	jb     c01064c3 <basic_check+0x1c5>
c01064aa:	68 ae b5 10 c0       	push   $0xc010b5ae
c01064af:	68 5a b4 10 c0       	push   $0xc010b45a
c01064b4:	68 d9 00 00 00       	push   $0xd9
c01064b9:	68 6f b4 10 c0       	push   $0xc010b46f
c01064be:	e8 35 9f ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c01064c3:	a1 84 c1 12 c0       	mov    0xc012c184,%eax
c01064c8:	8b 15 88 c1 12 c0    	mov    0xc012c188,%edx
c01064ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01064d1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01064d4:	c7 45 e4 84 c1 12 c0 	movl   $0xc012c184,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01064db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01064e1:	89 50 04             	mov    %edx,0x4(%eax)
c01064e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064e7:	8b 50 04             	mov    0x4(%eax),%edx
c01064ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064ed:	89 10                	mov    %edx,(%eax)
c01064ef:	c7 45 d8 84 c1 12 c0 	movl   $0xc012c184,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01064f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01064f9:	8b 40 04             	mov    0x4(%eax),%eax
c01064fc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01064ff:	0f 94 c0             	sete   %al
c0106502:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0106505:	85 c0                	test   %eax,%eax
c0106507:	75 19                	jne    c0106522 <basic_check+0x224>
c0106509:	68 cb b5 10 c0       	push   $0xc010b5cb
c010650e:	68 5a b4 10 c0       	push   $0xc010b45a
c0106513:	68 dd 00 00 00       	push   $0xdd
c0106518:	68 6f b4 10 c0       	push   $0xc010b46f
c010651d:	e8 d6 9e ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c0106522:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0106527:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010652a:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0106531:	00 00 00 

    assert(alloc_page() == NULL);
c0106534:	83 ec 0c             	sub    $0xc,%esp
c0106537:	6a 01                	push   $0x1
c0106539:	e8 aa 0a 00 00       	call   c0106fe8 <alloc_pages>
c010653e:	83 c4 10             	add    $0x10,%esp
c0106541:	85 c0                	test   %eax,%eax
c0106543:	74 19                	je     c010655e <basic_check+0x260>
c0106545:	68 e2 b5 10 c0       	push   $0xc010b5e2
c010654a:	68 5a b4 10 c0       	push   $0xc010b45a
c010654f:	68 e2 00 00 00       	push   $0xe2
c0106554:	68 6f b4 10 c0       	push   $0xc010b46f
c0106559:	e8 9a 9e ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c010655e:	83 ec 08             	sub    $0x8,%esp
c0106561:	6a 01                	push   $0x1
c0106563:	ff 75 ec             	pushl  -0x14(%ebp)
c0106566:	e8 e9 0a 00 00       	call   c0107054 <free_pages>
c010656b:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010656e:	83 ec 08             	sub    $0x8,%esp
c0106571:	6a 01                	push   $0x1
c0106573:	ff 75 f0             	pushl  -0x10(%ebp)
c0106576:	e8 d9 0a 00 00       	call   c0107054 <free_pages>
c010657b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010657e:	83 ec 08             	sub    $0x8,%esp
c0106581:	6a 01                	push   $0x1
c0106583:	ff 75 f4             	pushl  -0xc(%ebp)
c0106586:	e8 c9 0a 00 00       	call   c0107054 <free_pages>
c010658b:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010658e:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0106593:	83 f8 03             	cmp    $0x3,%eax
c0106596:	74 19                	je     c01065b1 <basic_check+0x2b3>
c0106598:	68 f7 b5 10 c0       	push   $0xc010b5f7
c010659d:	68 5a b4 10 c0       	push   $0xc010b45a
c01065a2:	68 e7 00 00 00       	push   $0xe7
c01065a7:	68 6f b4 10 c0       	push   $0xc010b46f
c01065ac:	e8 47 9e ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01065b1:	83 ec 0c             	sub    $0xc,%esp
c01065b4:	6a 01                	push   $0x1
c01065b6:	e8 2d 0a 00 00       	call   c0106fe8 <alloc_pages>
c01065bb:	83 c4 10             	add    $0x10,%esp
c01065be:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01065c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01065c5:	75 19                	jne    c01065e0 <basic_check+0x2e2>
c01065c7:	68 bd b4 10 c0       	push   $0xc010b4bd
c01065cc:	68 5a b4 10 c0       	push   $0xc010b45a
c01065d1:	68 e9 00 00 00       	push   $0xe9
c01065d6:	68 6f b4 10 c0       	push   $0xc010b46f
c01065db:	e8 18 9e ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01065e0:	83 ec 0c             	sub    $0xc,%esp
c01065e3:	6a 01                	push   $0x1
c01065e5:	e8 fe 09 00 00       	call   c0106fe8 <alloc_pages>
c01065ea:	83 c4 10             	add    $0x10,%esp
c01065ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01065f4:	75 19                	jne    c010660f <basic_check+0x311>
c01065f6:	68 d9 b4 10 c0       	push   $0xc010b4d9
c01065fb:	68 5a b4 10 c0       	push   $0xc010b45a
c0106600:	68 ea 00 00 00       	push   $0xea
c0106605:	68 6f b4 10 c0       	push   $0xc010b46f
c010660a:	e8 e9 9d ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010660f:	83 ec 0c             	sub    $0xc,%esp
c0106612:	6a 01                	push   $0x1
c0106614:	e8 cf 09 00 00       	call   c0106fe8 <alloc_pages>
c0106619:	83 c4 10             	add    $0x10,%esp
c010661c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010661f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106623:	75 19                	jne    c010663e <basic_check+0x340>
c0106625:	68 f5 b4 10 c0       	push   $0xc010b4f5
c010662a:	68 5a b4 10 c0       	push   $0xc010b45a
c010662f:	68 eb 00 00 00       	push   $0xeb
c0106634:	68 6f b4 10 c0       	push   $0xc010b46f
c0106639:	e8 ba 9d ff ff       	call   c01003f8 <__panic>

    assert(alloc_page() == NULL);
c010663e:	83 ec 0c             	sub    $0xc,%esp
c0106641:	6a 01                	push   $0x1
c0106643:	e8 a0 09 00 00       	call   c0106fe8 <alloc_pages>
c0106648:	83 c4 10             	add    $0x10,%esp
c010664b:	85 c0                	test   %eax,%eax
c010664d:	74 19                	je     c0106668 <basic_check+0x36a>
c010664f:	68 e2 b5 10 c0       	push   $0xc010b5e2
c0106654:	68 5a b4 10 c0       	push   $0xc010b45a
c0106659:	68 ed 00 00 00       	push   $0xed
c010665e:	68 6f b4 10 c0       	push   $0xc010b46f
c0106663:	e8 90 9d ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c0106668:	83 ec 08             	sub    $0x8,%esp
c010666b:	6a 01                	push   $0x1
c010666d:	ff 75 ec             	pushl  -0x14(%ebp)
c0106670:	e8 df 09 00 00       	call   c0107054 <free_pages>
c0106675:	83 c4 10             	add    $0x10,%esp
c0106678:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
c010667f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106682:	8b 40 04             	mov    0x4(%eax),%eax
c0106685:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106688:	0f 94 c0             	sete   %al
c010668b:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010668e:	85 c0                	test   %eax,%eax
c0106690:	74 19                	je     c01066ab <basic_check+0x3ad>
c0106692:	68 04 b6 10 c0       	push   $0xc010b604
c0106697:	68 5a b4 10 c0       	push   $0xc010b45a
c010669c:	68 f0 00 00 00       	push   $0xf0
c01066a1:	68 6f b4 10 c0       	push   $0xc010b46f
c01066a6:	e8 4d 9d ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01066ab:	83 ec 0c             	sub    $0xc,%esp
c01066ae:	6a 01                	push   $0x1
c01066b0:	e8 33 09 00 00       	call   c0106fe8 <alloc_pages>
c01066b5:	83 c4 10             	add    $0x10,%esp
c01066b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01066bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01066c1:	74 19                	je     c01066dc <basic_check+0x3de>
c01066c3:	68 1c b6 10 c0       	push   $0xc010b61c
c01066c8:	68 5a b4 10 c0       	push   $0xc010b45a
c01066cd:	68 f3 00 00 00       	push   $0xf3
c01066d2:	68 6f b4 10 c0       	push   $0xc010b46f
c01066d7:	e8 1c 9d ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01066dc:	83 ec 0c             	sub    $0xc,%esp
c01066df:	6a 01                	push   $0x1
c01066e1:	e8 02 09 00 00       	call   c0106fe8 <alloc_pages>
c01066e6:	83 c4 10             	add    $0x10,%esp
c01066e9:	85 c0                	test   %eax,%eax
c01066eb:	74 19                	je     c0106706 <basic_check+0x408>
c01066ed:	68 e2 b5 10 c0       	push   $0xc010b5e2
c01066f2:	68 5a b4 10 c0       	push   $0xc010b45a
c01066f7:	68 f4 00 00 00       	push   $0xf4
c01066fc:	68 6f b4 10 c0       	push   $0xc010b46f
c0106701:	e8 f2 9c ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c0106706:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c010670b:	85 c0                	test   %eax,%eax
c010670d:	74 19                	je     c0106728 <basic_check+0x42a>
c010670f:	68 35 b6 10 c0       	push   $0xc010b635
c0106714:	68 5a b4 10 c0       	push   $0xc010b45a
c0106719:	68 f6 00 00 00       	push   $0xf6
c010671e:	68 6f b4 10 c0       	push   $0xc010b46f
c0106723:	e8 d0 9c ff ff       	call   c01003f8 <__panic>
    free_list = free_list_store;
c0106728:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010672b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010672e:	a3 84 c1 12 c0       	mov    %eax,0xc012c184
c0106733:	89 15 88 c1 12 c0    	mov    %edx,0xc012c188
    nr_free = nr_free_store;
c0106739:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010673c:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c

    free_page(p);
c0106741:	83 ec 08             	sub    $0x8,%esp
c0106744:	6a 01                	push   $0x1
c0106746:	ff 75 dc             	pushl  -0x24(%ebp)
c0106749:	e8 06 09 00 00       	call   c0107054 <free_pages>
c010674e:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0106751:	83 ec 08             	sub    $0x8,%esp
c0106754:	6a 01                	push   $0x1
c0106756:	ff 75 f0             	pushl  -0x10(%ebp)
c0106759:	e8 f6 08 00 00       	call   c0107054 <free_pages>
c010675e:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0106761:	83 ec 08             	sub    $0x8,%esp
c0106764:	6a 01                	push   $0x1
c0106766:	ff 75 f4             	pushl  -0xc(%ebp)
c0106769:	e8 e6 08 00 00       	call   c0107054 <free_pages>
c010676e:	83 c4 10             	add    $0x10,%esp
}
c0106771:	90                   	nop
c0106772:	c9                   	leave  
c0106773:	c3                   	ret    

c0106774 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0106774:	55                   	push   %ebp
c0106775:	89 e5                	mov    %esp,%ebp
c0106777:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c010677d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106784:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010678b:	c7 45 ec 84 c1 12 c0 	movl   $0xc012c184,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106792:	eb 60                	jmp    c01067f4 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0106794:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106797:	83 e8 0c             	sub    $0xc,%eax
c010679a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c010679d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067a0:	83 c0 04             	add    $0x4,%eax
c01067a3:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01067aa:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01067ad:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01067b0:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01067b3:	0f a3 10             	bt     %edx,(%eax)
c01067b6:	19 c0                	sbb    %eax,%eax
c01067b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c01067bb:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c01067bf:	0f 95 c0             	setne  %al
c01067c2:	0f b6 c0             	movzbl %al,%eax
c01067c5:	85 c0                	test   %eax,%eax
c01067c7:	75 19                	jne    c01067e2 <default_check+0x6e>
c01067c9:	68 42 b6 10 c0       	push   $0xc010b642
c01067ce:	68 5a b4 10 c0       	push   $0xc010b45a
c01067d3:	68 07 01 00 00       	push   $0x107
c01067d8:	68 6f b4 10 c0       	push   $0xc010b46f
c01067dd:	e8 16 9c ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c01067e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01067e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067e9:	8b 50 08             	mov    0x8(%eax),%edx
c01067ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067ef:	01 d0                	add    %edx,%eax
c01067f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01067f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01067fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067fd:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0106800:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106803:	81 7d ec 84 c1 12 c0 	cmpl   $0xc012c184,-0x14(%ebp)
c010680a:	75 88                	jne    c0106794 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010680c:	e8 78 08 00 00       	call   c0107089 <nr_free_pages>
c0106811:	89 c2                	mov    %eax,%edx
c0106813:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106816:	39 c2                	cmp    %eax,%edx
c0106818:	74 19                	je     c0106833 <default_check+0xbf>
c010681a:	68 52 b6 10 c0       	push   $0xc010b652
c010681f:	68 5a b4 10 c0       	push   $0xc010b45a
c0106824:	68 0a 01 00 00       	push   $0x10a
c0106829:	68 6f b4 10 c0       	push   $0xc010b46f
c010682e:	e8 c5 9b ff ff       	call   c01003f8 <__panic>

    basic_check();
c0106833:	e8 c6 fa ff ff       	call   c01062fe <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0106838:	83 ec 0c             	sub    $0xc,%esp
c010683b:	6a 05                	push   $0x5
c010683d:	e8 a6 07 00 00       	call   c0106fe8 <alloc_pages>
c0106842:	83 c4 10             	add    $0x10,%esp
c0106845:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0106848:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010684c:	75 19                	jne    c0106867 <default_check+0xf3>
c010684e:	68 6b b6 10 c0       	push   $0xc010b66b
c0106853:	68 5a b4 10 c0       	push   $0xc010b45a
c0106858:	68 0f 01 00 00       	push   $0x10f
c010685d:	68 6f b4 10 c0       	push   $0xc010b46f
c0106862:	e8 91 9b ff ff       	call   c01003f8 <__panic>
    assert(!PageProperty(p0));
c0106867:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010686a:	83 c0 04             	add    $0x4,%eax
c010686d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0106874:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106877:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010687a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010687d:	0f a3 10             	bt     %edx,(%eax)
c0106880:	19 c0                	sbb    %eax,%eax
c0106882:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0106885:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0106889:	0f 95 c0             	setne  %al
c010688c:	0f b6 c0             	movzbl %al,%eax
c010688f:	85 c0                	test   %eax,%eax
c0106891:	74 19                	je     c01068ac <default_check+0x138>
c0106893:	68 76 b6 10 c0       	push   $0xc010b676
c0106898:	68 5a b4 10 c0       	push   $0xc010b45a
c010689d:	68 10 01 00 00       	push   $0x110
c01068a2:	68 6f b4 10 c0       	push   $0xc010b46f
c01068a7:	e8 4c 9b ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c01068ac:	a1 84 c1 12 c0       	mov    0xc012c184,%eax
c01068b1:	8b 15 88 c1 12 c0    	mov    0xc012c188,%edx
c01068b7:	89 45 80             	mov    %eax,-0x80(%ebp)
c01068ba:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01068bd:	c7 45 d0 84 c1 12 c0 	movl   $0xc012c184,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01068c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068c7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01068ca:	89 50 04             	mov    %edx,0x4(%eax)
c01068cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068d0:	8b 50 04             	mov    0x4(%eax),%edx
c01068d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068d6:	89 10                	mov    %edx,(%eax)
c01068d8:	c7 45 d8 84 c1 12 c0 	movl   $0xc012c184,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01068df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01068e2:	8b 40 04             	mov    0x4(%eax),%eax
c01068e5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01068e8:	0f 94 c0             	sete   %al
c01068eb:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01068ee:	85 c0                	test   %eax,%eax
c01068f0:	75 19                	jne    c010690b <default_check+0x197>
c01068f2:	68 cb b5 10 c0       	push   $0xc010b5cb
c01068f7:	68 5a b4 10 c0       	push   $0xc010b45a
c01068fc:	68 14 01 00 00       	push   $0x114
c0106901:	68 6f b4 10 c0       	push   $0xc010b46f
c0106906:	e8 ed 9a ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c010690b:	83 ec 0c             	sub    $0xc,%esp
c010690e:	6a 01                	push   $0x1
c0106910:	e8 d3 06 00 00       	call   c0106fe8 <alloc_pages>
c0106915:	83 c4 10             	add    $0x10,%esp
c0106918:	85 c0                	test   %eax,%eax
c010691a:	74 19                	je     c0106935 <default_check+0x1c1>
c010691c:	68 e2 b5 10 c0       	push   $0xc010b5e2
c0106921:	68 5a b4 10 c0       	push   $0xc010b45a
c0106926:	68 15 01 00 00       	push   $0x115
c010692b:	68 6f b4 10 c0       	push   $0xc010b46f
c0106930:	e8 c3 9a ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c0106935:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c010693a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c010693d:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0106944:	00 00 00 

    free_pages(p0 + 2, 3);
c0106947:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010694a:	83 c0 40             	add    $0x40,%eax
c010694d:	83 ec 08             	sub    $0x8,%esp
c0106950:	6a 03                	push   $0x3
c0106952:	50                   	push   %eax
c0106953:	e8 fc 06 00 00       	call   c0107054 <free_pages>
c0106958:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c010695b:	83 ec 0c             	sub    $0xc,%esp
c010695e:	6a 04                	push   $0x4
c0106960:	e8 83 06 00 00       	call   c0106fe8 <alloc_pages>
c0106965:	83 c4 10             	add    $0x10,%esp
c0106968:	85 c0                	test   %eax,%eax
c010696a:	74 19                	je     c0106985 <default_check+0x211>
c010696c:	68 88 b6 10 c0       	push   $0xc010b688
c0106971:	68 5a b4 10 c0       	push   $0xc010b45a
c0106976:	68 1b 01 00 00       	push   $0x11b
c010697b:	68 6f b4 10 c0       	push   $0xc010b46f
c0106980:	e8 73 9a ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0106985:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106988:	83 c0 40             	add    $0x40,%eax
c010698b:	83 c0 04             	add    $0x4,%eax
c010698e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0106995:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106998:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010699b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010699e:	0f a3 10             	bt     %edx,(%eax)
c01069a1:	19 c0                	sbb    %eax,%eax
c01069a3:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01069a6:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01069aa:	0f 95 c0             	setne  %al
c01069ad:	0f b6 c0             	movzbl %al,%eax
c01069b0:	85 c0                	test   %eax,%eax
c01069b2:	74 0e                	je     c01069c2 <default_check+0x24e>
c01069b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01069b7:	83 c0 40             	add    $0x40,%eax
c01069ba:	8b 40 08             	mov    0x8(%eax),%eax
c01069bd:	83 f8 03             	cmp    $0x3,%eax
c01069c0:	74 19                	je     c01069db <default_check+0x267>
c01069c2:	68 a0 b6 10 c0       	push   $0xc010b6a0
c01069c7:	68 5a b4 10 c0       	push   $0xc010b45a
c01069cc:	68 1c 01 00 00       	push   $0x11c
c01069d1:	68 6f b4 10 c0       	push   $0xc010b46f
c01069d6:	e8 1d 9a ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01069db:	83 ec 0c             	sub    $0xc,%esp
c01069de:	6a 03                	push   $0x3
c01069e0:	e8 03 06 00 00       	call   c0106fe8 <alloc_pages>
c01069e5:	83 c4 10             	add    $0x10,%esp
c01069e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01069eb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01069ef:	75 19                	jne    c0106a0a <default_check+0x296>
c01069f1:	68 cc b6 10 c0       	push   $0xc010b6cc
c01069f6:	68 5a b4 10 c0       	push   $0xc010b45a
c01069fb:	68 1d 01 00 00       	push   $0x11d
c0106a00:	68 6f b4 10 c0       	push   $0xc010b46f
c0106a05:	e8 ee 99 ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c0106a0a:	83 ec 0c             	sub    $0xc,%esp
c0106a0d:	6a 01                	push   $0x1
c0106a0f:	e8 d4 05 00 00       	call   c0106fe8 <alloc_pages>
c0106a14:	83 c4 10             	add    $0x10,%esp
c0106a17:	85 c0                	test   %eax,%eax
c0106a19:	74 19                	je     c0106a34 <default_check+0x2c0>
c0106a1b:	68 e2 b5 10 c0       	push   $0xc010b5e2
c0106a20:	68 5a b4 10 c0       	push   $0xc010b45a
c0106a25:	68 1e 01 00 00       	push   $0x11e
c0106a2a:	68 6f b4 10 c0       	push   $0xc010b46f
c0106a2f:	e8 c4 99 ff ff       	call   c01003f8 <__panic>
    assert(p0 + 2 == p1);
c0106a34:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a37:	83 c0 40             	add    $0x40,%eax
c0106a3a:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0106a3d:	74 19                	je     c0106a58 <default_check+0x2e4>
c0106a3f:	68 ea b6 10 c0       	push   $0xc010b6ea
c0106a44:	68 5a b4 10 c0       	push   $0xc010b45a
c0106a49:	68 1f 01 00 00       	push   $0x11f
c0106a4e:	68 6f b4 10 c0       	push   $0xc010b46f
c0106a53:	e8 a0 99 ff ff       	call   c01003f8 <__panic>

    p2 = p0 + 1;
c0106a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a5b:	83 c0 20             	add    $0x20,%eax
c0106a5e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0106a61:	83 ec 08             	sub    $0x8,%esp
c0106a64:	6a 01                	push   $0x1
c0106a66:	ff 75 dc             	pushl  -0x24(%ebp)
c0106a69:	e8 e6 05 00 00       	call   c0107054 <free_pages>
c0106a6e:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0106a71:	83 ec 08             	sub    $0x8,%esp
c0106a74:	6a 03                	push   $0x3
c0106a76:	ff 75 c4             	pushl  -0x3c(%ebp)
c0106a79:	e8 d6 05 00 00       	call   c0107054 <free_pages>
c0106a7e:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0106a81:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a84:	83 c0 04             	add    $0x4,%eax
c0106a87:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0106a8e:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106a91:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106a94:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0106a97:	0f a3 10             	bt     %edx,(%eax)
c0106a9a:	19 c0                	sbb    %eax,%eax
c0106a9c:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0106a9f:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0106aa3:	0f 95 c0             	setne  %al
c0106aa6:	0f b6 c0             	movzbl %al,%eax
c0106aa9:	85 c0                	test   %eax,%eax
c0106aab:	74 0b                	je     c0106ab8 <default_check+0x344>
c0106aad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106ab0:	8b 40 08             	mov    0x8(%eax),%eax
c0106ab3:	83 f8 01             	cmp    $0x1,%eax
c0106ab6:	74 19                	je     c0106ad1 <default_check+0x35d>
c0106ab8:	68 f8 b6 10 c0       	push   $0xc010b6f8
c0106abd:	68 5a b4 10 c0       	push   $0xc010b45a
c0106ac2:	68 24 01 00 00       	push   $0x124
c0106ac7:	68 6f b4 10 c0       	push   $0xc010b46f
c0106acc:	e8 27 99 ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0106ad1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106ad4:	83 c0 04             	add    $0x4,%eax
c0106ad7:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0106ade:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106ae1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106ae4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106ae7:	0f a3 10             	bt     %edx,(%eax)
c0106aea:	19 c0                	sbb    %eax,%eax
c0106aec:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0106aef:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0106af3:	0f 95 c0             	setne  %al
c0106af6:	0f b6 c0             	movzbl %al,%eax
c0106af9:	85 c0                	test   %eax,%eax
c0106afb:	74 0b                	je     c0106b08 <default_check+0x394>
c0106afd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106b00:	8b 40 08             	mov    0x8(%eax),%eax
c0106b03:	83 f8 03             	cmp    $0x3,%eax
c0106b06:	74 19                	je     c0106b21 <default_check+0x3ad>
c0106b08:	68 20 b7 10 c0       	push   $0xc010b720
c0106b0d:	68 5a b4 10 c0       	push   $0xc010b45a
c0106b12:	68 25 01 00 00       	push   $0x125
c0106b17:	68 6f b4 10 c0       	push   $0xc010b46f
c0106b1c:	e8 d7 98 ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0106b21:	83 ec 0c             	sub    $0xc,%esp
c0106b24:	6a 01                	push   $0x1
c0106b26:	e8 bd 04 00 00       	call   c0106fe8 <alloc_pages>
c0106b2b:	83 c4 10             	add    $0x10,%esp
c0106b2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106b31:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b34:	83 e8 20             	sub    $0x20,%eax
c0106b37:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106b3a:	74 19                	je     c0106b55 <default_check+0x3e1>
c0106b3c:	68 46 b7 10 c0       	push   $0xc010b746
c0106b41:	68 5a b4 10 c0       	push   $0xc010b45a
c0106b46:	68 27 01 00 00       	push   $0x127
c0106b4b:	68 6f b4 10 c0       	push   $0xc010b46f
c0106b50:	e8 a3 98 ff ff       	call   c01003f8 <__panic>
    free_page(p0);
c0106b55:	83 ec 08             	sub    $0x8,%esp
c0106b58:	6a 01                	push   $0x1
c0106b5a:	ff 75 dc             	pushl  -0x24(%ebp)
c0106b5d:	e8 f2 04 00 00       	call   c0107054 <free_pages>
c0106b62:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0106b65:	83 ec 0c             	sub    $0xc,%esp
c0106b68:	6a 02                	push   $0x2
c0106b6a:	e8 79 04 00 00       	call   c0106fe8 <alloc_pages>
c0106b6f:	83 c4 10             	add    $0x10,%esp
c0106b72:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106b75:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b78:	83 c0 20             	add    $0x20,%eax
c0106b7b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106b7e:	74 19                	je     c0106b99 <default_check+0x425>
c0106b80:	68 64 b7 10 c0       	push   $0xc010b764
c0106b85:	68 5a b4 10 c0       	push   $0xc010b45a
c0106b8a:	68 29 01 00 00       	push   $0x129
c0106b8f:	68 6f b4 10 c0       	push   $0xc010b46f
c0106b94:	e8 5f 98 ff ff       	call   c01003f8 <__panic>

    free_pages(p0, 2);
c0106b99:	83 ec 08             	sub    $0x8,%esp
c0106b9c:	6a 02                	push   $0x2
c0106b9e:	ff 75 dc             	pushl  -0x24(%ebp)
c0106ba1:	e8 ae 04 00 00       	call   c0107054 <free_pages>
c0106ba6:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0106ba9:	83 ec 08             	sub    $0x8,%esp
c0106bac:	6a 01                	push   $0x1
c0106bae:	ff 75 c0             	pushl  -0x40(%ebp)
c0106bb1:	e8 9e 04 00 00       	call   c0107054 <free_pages>
c0106bb6:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0106bb9:	83 ec 0c             	sub    $0xc,%esp
c0106bbc:	6a 05                	push   $0x5
c0106bbe:	e8 25 04 00 00       	call   c0106fe8 <alloc_pages>
c0106bc3:	83 c4 10             	add    $0x10,%esp
c0106bc6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106bc9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106bcd:	75 19                	jne    c0106be8 <default_check+0x474>
c0106bcf:	68 84 b7 10 c0       	push   $0xc010b784
c0106bd4:	68 5a b4 10 c0       	push   $0xc010b45a
c0106bd9:	68 2e 01 00 00       	push   $0x12e
c0106bde:	68 6f b4 10 c0       	push   $0xc010b46f
c0106be3:	e8 10 98 ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c0106be8:	83 ec 0c             	sub    $0xc,%esp
c0106beb:	6a 01                	push   $0x1
c0106bed:	e8 f6 03 00 00       	call   c0106fe8 <alloc_pages>
c0106bf2:	83 c4 10             	add    $0x10,%esp
c0106bf5:	85 c0                	test   %eax,%eax
c0106bf7:	74 19                	je     c0106c12 <default_check+0x49e>
c0106bf9:	68 e2 b5 10 c0       	push   $0xc010b5e2
c0106bfe:	68 5a b4 10 c0       	push   $0xc010b45a
c0106c03:	68 2f 01 00 00       	push   $0x12f
c0106c08:	68 6f b4 10 c0       	push   $0xc010b46f
c0106c0d:	e8 e6 97 ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c0106c12:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0106c17:	85 c0                	test   %eax,%eax
c0106c19:	74 19                	je     c0106c34 <default_check+0x4c0>
c0106c1b:	68 35 b6 10 c0       	push   $0xc010b635
c0106c20:	68 5a b4 10 c0       	push   $0xc010b45a
c0106c25:	68 31 01 00 00       	push   $0x131
c0106c2a:	68 6f b4 10 c0       	push   $0xc010b46f
c0106c2f:	e8 c4 97 ff ff       	call   c01003f8 <__panic>
    nr_free = nr_free_store;
c0106c34:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106c37:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c

    free_list = free_list_store;
c0106c3c:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106c3f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106c42:	a3 84 c1 12 c0       	mov    %eax,0xc012c184
c0106c47:	89 15 88 c1 12 c0    	mov    %edx,0xc012c188
    free_pages(p0, 5);
c0106c4d:	83 ec 08             	sub    $0x8,%esp
c0106c50:	6a 05                	push   $0x5
c0106c52:	ff 75 dc             	pushl  -0x24(%ebp)
c0106c55:	e8 fa 03 00 00       	call   c0107054 <free_pages>
c0106c5a:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0106c5d:	c7 45 ec 84 c1 12 c0 	movl   $0xc012c184,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106c64:	eb 1d                	jmp    c0106c83 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0106c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c69:	83 e8 0c             	sub    $0xc,%eax
c0106c6c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0106c6f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106c73:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106c76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106c79:	8b 40 08             	mov    0x8(%eax),%eax
c0106c7c:	29 c2                	sub    %eax,%edx
c0106c7e:	89 d0                	mov    %edx,%eax
c0106c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c86:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106c89:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106c8c:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0106c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c92:	81 7d ec 84 c1 12 c0 	cmpl   $0xc012c184,-0x14(%ebp)
c0106c99:	75 cb                	jne    c0106c66 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0106c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c9f:	74 19                	je     c0106cba <default_check+0x546>
c0106ca1:	68 a2 b7 10 c0       	push   $0xc010b7a2
c0106ca6:	68 5a b4 10 c0       	push   $0xc010b45a
c0106cab:	68 3c 01 00 00       	push   $0x13c
c0106cb0:	68 6f b4 10 c0       	push   $0xc010b46f
c0106cb5:	e8 3e 97 ff ff       	call   c01003f8 <__panic>
    assert(total == 0);
c0106cba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106cbe:	74 19                	je     c0106cd9 <default_check+0x565>
c0106cc0:	68 ad b7 10 c0       	push   $0xc010b7ad
c0106cc5:	68 5a b4 10 c0       	push   $0xc010b45a
c0106cca:	68 3d 01 00 00       	push   $0x13d
c0106ccf:	68 6f b4 10 c0       	push   $0xc010b46f
c0106cd4:	e8 1f 97 ff ff       	call   c01003f8 <__panic>
}
c0106cd9:	90                   	nop
c0106cda:	c9                   	leave  
c0106cdb:	c3                   	ret    

c0106cdc <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0106cdc:	55                   	push   %ebp
c0106cdd:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0106cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ce2:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0106ce8:	29 d0                	sub    %edx,%eax
c0106cea:	c1 f8 05             	sar    $0x5,%eax
}
c0106ced:	5d                   	pop    %ebp
c0106cee:	c3                   	ret    

c0106cef <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0106cef:	55                   	push   %ebp
c0106cf0:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0106cf2:	ff 75 08             	pushl  0x8(%ebp)
c0106cf5:	e8 e2 ff ff ff       	call   c0106cdc <page2ppn>
c0106cfa:	83 c4 04             	add    $0x4,%esp
c0106cfd:	c1 e0 0c             	shl    $0xc,%eax
}
c0106d00:	c9                   	leave  
c0106d01:	c3                   	ret    

c0106d02 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0106d02:	55                   	push   %ebp
c0106d03:	89 e5                	mov    %esp,%ebp
c0106d05:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0106d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d0b:	c1 e8 0c             	shr    $0xc,%eax
c0106d0e:	89 c2                	mov    %eax,%edx
c0106d10:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0106d15:	39 c2                	cmp    %eax,%edx
c0106d17:	72 14                	jb     c0106d2d <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0106d19:	83 ec 04             	sub    $0x4,%esp
c0106d1c:	68 e8 b7 10 c0       	push   $0xc010b7e8
c0106d21:	6a 5f                	push   $0x5f
c0106d23:	68 07 b8 10 c0       	push   $0xc010b807
c0106d28:	e8 cb 96 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0106d2d:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0106d32:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d35:	c1 ea 0c             	shr    $0xc,%edx
c0106d38:	c1 e2 05             	shl    $0x5,%edx
c0106d3b:	01 d0                	add    %edx,%eax
}
c0106d3d:	c9                   	leave  
c0106d3e:	c3                   	ret    

c0106d3f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0106d3f:	55                   	push   %ebp
c0106d40:	89 e5                	mov    %esp,%ebp
c0106d42:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0106d45:	ff 75 08             	pushl  0x8(%ebp)
c0106d48:	e8 a2 ff ff ff       	call   c0106cef <page2pa>
c0106d4d:	83 c4 04             	add    $0x4,%esp
c0106d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d56:	c1 e8 0c             	shr    $0xc,%eax
c0106d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d5c:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0106d61:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106d64:	72 14                	jb     c0106d7a <page2kva+0x3b>
c0106d66:	ff 75 f4             	pushl  -0xc(%ebp)
c0106d69:	68 18 b8 10 c0       	push   $0xc010b818
c0106d6e:	6a 66                	push   $0x66
c0106d70:	68 07 b8 10 c0       	push   $0xc010b807
c0106d75:	e8 7e 96 ff ff       	call   c01003f8 <__panic>
c0106d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d7d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0106d82:	c9                   	leave  
c0106d83:	c3                   	ret    

c0106d84 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106d84:	55                   	push   %ebp
c0106d85:	89 e5                	mov    %esp,%ebp
c0106d87:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0106d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d8d:	83 e0 01             	and    $0x1,%eax
c0106d90:	85 c0                	test   %eax,%eax
c0106d92:	75 14                	jne    c0106da8 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0106d94:	83 ec 04             	sub    $0x4,%esp
c0106d97:	68 3c b8 10 c0       	push   $0xc010b83c
c0106d9c:	6a 71                	push   $0x71
c0106d9e:	68 07 b8 10 c0       	push   $0xc010b807
c0106da3:	e8 50 96 ff ff       	call   c01003f8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106db0:	83 ec 0c             	sub    $0xc,%esp
c0106db3:	50                   	push   %eax
c0106db4:	e8 49 ff ff ff       	call   c0106d02 <pa2page>
c0106db9:	83 c4 10             	add    $0x10,%esp
}
c0106dbc:	c9                   	leave  
c0106dbd:	c3                   	ret    

c0106dbe <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0106dbe:	55                   	push   %ebp
c0106dbf:	89 e5                	mov    %esp,%ebp
c0106dc1:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0106dc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106dcc:	83 ec 0c             	sub    $0xc,%esp
c0106dcf:	50                   	push   %eax
c0106dd0:	e8 2d ff ff ff       	call   c0106d02 <pa2page>
c0106dd5:	83 c4 10             	add    $0x10,%esp
}
c0106dd8:	c9                   	leave  
c0106dd9:	c3                   	ret    

c0106dda <page_ref>:

static inline int
page_ref(struct Page *page) {
c0106dda:	55                   	push   %ebp
c0106ddb:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106de0:	8b 00                	mov    (%eax),%eax
}
c0106de2:	5d                   	pop    %ebp
c0106de3:	c3                   	ret    

c0106de4 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0106de4:	55                   	push   %ebp
c0106de5:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0106de7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dea:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106ded:	89 10                	mov    %edx,(%eax)
}
c0106def:	90                   	nop
c0106df0:	5d                   	pop    %ebp
c0106df1:	c3                   	ret    

c0106df2 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106df2:	55                   	push   %ebp
c0106df3:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106df5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106df8:	8b 00                	mov    (%eax),%eax
c0106dfa:	8d 50 01             	lea    0x1(%eax),%edx
c0106dfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e00:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106e02:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e05:	8b 00                	mov    (%eax),%eax
}
c0106e07:	5d                   	pop    %ebp
c0106e08:	c3                   	ret    

c0106e09 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0106e09:	55                   	push   %ebp
c0106e0a:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106e0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e0f:	8b 00                	mov    (%eax),%eax
c0106e11:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e17:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106e19:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e1c:	8b 00                	mov    (%eax),%eax
}
c0106e1e:	5d                   	pop    %ebp
c0106e1f:	c3                   	ret    

c0106e20 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0106e20:	55                   	push   %ebp
c0106e21:	89 e5                	mov    %esp,%ebp
c0106e23:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0106e26:	9c                   	pushf  
c0106e27:	58                   	pop    %eax
c0106e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106e2e:	25 00 02 00 00       	and    $0x200,%eax
c0106e33:	85 c0                	test   %eax,%eax
c0106e35:	74 0c                	je     c0106e43 <__intr_save+0x23>
        intr_disable();
c0106e37:	e8 a4 b2 ff ff       	call   c01020e0 <intr_disable>
        return 1;
c0106e3c:	b8 01 00 00 00       	mov    $0x1,%eax
c0106e41:	eb 05                	jmp    c0106e48 <__intr_save+0x28>
    }
    return 0;
c0106e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106e48:	c9                   	leave  
c0106e49:	c3                   	ret    

c0106e4a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0106e4a:	55                   	push   %ebp
c0106e4b:	89 e5                	mov    %esp,%ebp
c0106e4d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106e50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106e54:	74 05                	je     c0106e5b <__intr_restore+0x11>
        intr_enable();
c0106e56:	e8 7e b2 ff ff       	call   c01020d9 <intr_enable>
    }
}
c0106e5b:	90                   	nop
c0106e5c:	c9                   	leave  
c0106e5d:	c3                   	ret    

c0106e5e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106e5e:	55                   	push   %ebp
c0106e5f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106e61:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e64:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0106e67:	b8 23 00 00 00       	mov    $0x23,%eax
c0106e6c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106e6e:	b8 23 00 00 00       	mov    $0x23,%eax
c0106e73:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106e75:	b8 10 00 00 00       	mov    $0x10,%eax
c0106e7a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106e7c:	b8 10 00 00 00       	mov    $0x10,%eax
c0106e81:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106e83:	b8 10 00 00 00       	mov    $0x10,%eax
c0106e88:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0106e8a:	ea 91 6e 10 c0 08 00 	ljmp   $0x8,$0xc0106e91
}
c0106e91:	90                   	nop
c0106e92:	5d                   	pop    %ebp
c0106e93:	c3                   	ret    

c0106e94 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0106e94:	55                   	push   %ebp
c0106e95:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0106e97:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e9a:	a3 a4 9f 12 c0       	mov    %eax,0xc0129fa4
}
c0106e9f:	90                   	nop
c0106ea0:	5d                   	pop    %ebp
c0106ea1:	c3                   	ret    

c0106ea2 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106ea2:	55                   	push   %ebp
c0106ea3:	89 e5                	mov    %esp,%ebp
c0106ea5:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0106ea8:	b8 00 60 12 c0       	mov    $0xc0126000,%eax
c0106ead:	50                   	push   %eax
c0106eae:	e8 e1 ff ff ff       	call   c0106e94 <load_esp0>
c0106eb3:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0106eb6:	66 c7 05 a8 9f 12 c0 	movw   $0x10,0xc0129fa8
c0106ebd:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106ebf:	66 c7 05 a8 6a 12 c0 	movw   $0x68,0xc0126aa8
c0106ec6:	68 00 
c0106ec8:	b8 a0 9f 12 c0       	mov    $0xc0129fa0,%eax
c0106ecd:	66 a3 aa 6a 12 c0    	mov    %ax,0xc0126aaa
c0106ed3:	b8 a0 9f 12 c0       	mov    $0xc0129fa0,%eax
c0106ed8:	c1 e8 10             	shr    $0x10,%eax
c0106edb:	a2 ac 6a 12 c0       	mov    %al,0xc0126aac
c0106ee0:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106ee7:	83 e0 f0             	and    $0xfffffff0,%eax
c0106eea:	83 c8 09             	or     $0x9,%eax
c0106eed:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106ef2:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106ef9:	83 e0 ef             	and    $0xffffffef,%eax
c0106efc:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106f01:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106f08:	83 e0 9f             	and    $0xffffff9f,%eax
c0106f0b:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106f10:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106f17:	83 c8 80             	or     $0xffffff80,%eax
c0106f1a:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106f1f:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f26:	83 e0 f0             	and    $0xfffffff0,%eax
c0106f29:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f2e:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f35:	83 e0 ef             	and    $0xffffffef,%eax
c0106f38:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f3d:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f44:	83 e0 df             	and    $0xffffffdf,%eax
c0106f47:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f4c:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f53:	83 c8 40             	or     $0x40,%eax
c0106f56:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f5b:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f62:	83 e0 7f             	and    $0x7f,%eax
c0106f65:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f6a:	b8 a0 9f 12 c0       	mov    $0xc0129fa0,%eax
c0106f6f:	c1 e8 18             	shr    $0x18,%eax
c0106f72:	a2 af 6a 12 c0       	mov    %al,0xc0126aaf

    // reload all segment registers
    lgdt(&gdt_pd);
c0106f77:	68 b0 6a 12 c0       	push   $0xc0126ab0
c0106f7c:	e8 dd fe ff ff       	call   c0106e5e <lgdt>
c0106f81:	83 c4 04             	add    $0x4,%esp
c0106f84:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0106f8a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0106f8e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0106f91:	90                   	nop
c0106f92:	c9                   	leave  
c0106f93:	c3                   	ret    

c0106f94 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0106f94:	55                   	push   %ebp
c0106f95:	89 e5                	mov    %esp,%ebp
c0106f97:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0106f9a:	c7 05 90 c1 12 c0 cc 	movl   $0xc010b7cc,0xc012c190
c0106fa1:	b7 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106fa4:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0106fa9:	8b 00                	mov    (%eax),%eax
c0106fab:	83 ec 08             	sub    $0x8,%esp
c0106fae:	50                   	push   %eax
c0106faf:	68 68 b8 10 c0       	push   $0xc010b868
c0106fb4:	e8 d9 92 ff ff       	call   c0100292 <cprintf>
c0106fb9:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0106fbc:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0106fc1:	8b 40 04             	mov    0x4(%eax),%eax
c0106fc4:	ff d0                	call   *%eax
}
c0106fc6:	90                   	nop
c0106fc7:	c9                   	leave  
c0106fc8:	c3                   	ret    

c0106fc9 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106fc9:	55                   	push   %ebp
c0106fca:	89 e5                	mov    %esp,%ebp
c0106fcc:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0106fcf:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0106fd4:	8b 40 08             	mov    0x8(%eax),%eax
c0106fd7:	83 ec 08             	sub    $0x8,%esp
c0106fda:	ff 75 0c             	pushl  0xc(%ebp)
c0106fdd:	ff 75 08             	pushl  0x8(%ebp)
c0106fe0:	ff d0                	call   *%eax
c0106fe2:	83 c4 10             	add    $0x10,%esp
}
c0106fe5:	90                   	nop
c0106fe6:	c9                   	leave  
c0106fe7:	c3                   	ret    

c0106fe8 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106fe8:	55                   	push   %ebp
c0106fe9:	89 e5                	mov    %esp,%ebp
c0106feb:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0106fee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106ff5:	e8 26 fe ff ff       	call   c0106e20 <__intr_save>
c0106ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106ffd:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0107002:	8b 40 0c             	mov    0xc(%eax),%eax
c0107005:	83 ec 0c             	sub    $0xc,%esp
c0107008:	ff 75 08             	pushl  0x8(%ebp)
c010700b:	ff d0                	call   *%eax
c010700d:	83 c4 10             	add    $0x10,%esp
c0107010:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0107013:	83 ec 0c             	sub    $0xc,%esp
c0107016:	ff 75 f0             	pushl  -0x10(%ebp)
c0107019:	e8 2c fe ff ff       	call   c0106e4a <__intr_restore>
c010701e:	83 c4 10             	add    $0x10,%esp

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0107021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107025:	75 28                	jne    c010704f <alloc_pages+0x67>
c0107027:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010702b:	77 22                	ja     c010704f <alloc_pages+0x67>
c010702d:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c0107032:	85 c0                	test   %eax,%eax
c0107034:	74 19                	je     c010704f <alloc_pages+0x67>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0107036:	8b 55 08             	mov    0x8(%ebp),%edx
c0107039:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c010703e:	83 ec 04             	sub    $0x4,%esp
c0107041:	6a 00                	push   $0x0
c0107043:	52                   	push   %edx
c0107044:	50                   	push   %eax
c0107045:	e8 9e e3 ff ff       	call   c01053e8 <swap_out>
c010704a:	83 c4 10             	add    $0x10,%esp
    }
c010704d:	eb a6                	jmp    c0106ff5 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010704f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107052:	c9                   	leave  
c0107053:	c3                   	ret    

c0107054 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0107054:	55                   	push   %ebp
c0107055:	89 e5                	mov    %esp,%ebp
c0107057:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010705a:	e8 c1 fd ff ff       	call   c0106e20 <__intr_save>
c010705f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0107062:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0107067:	8b 40 10             	mov    0x10(%eax),%eax
c010706a:	83 ec 08             	sub    $0x8,%esp
c010706d:	ff 75 0c             	pushl  0xc(%ebp)
c0107070:	ff 75 08             	pushl  0x8(%ebp)
c0107073:	ff d0                	call   *%eax
c0107075:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0107078:	83 ec 0c             	sub    $0xc,%esp
c010707b:	ff 75 f4             	pushl  -0xc(%ebp)
c010707e:	e8 c7 fd ff ff       	call   c0106e4a <__intr_restore>
c0107083:	83 c4 10             	add    $0x10,%esp
}
c0107086:	90                   	nop
c0107087:	c9                   	leave  
c0107088:	c3                   	ret    

c0107089 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0107089:	55                   	push   %ebp
c010708a:	89 e5                	mov    %esp,%ebp
c010708c:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010708f:	e8 8c fd ff ff       	call   c0106e20 <__intr_save>
c0107094:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0107097:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c010709c:	8b 40 14             	mov    0x14(%eax),%eax
c010709f:	ff d0                	call   *%eax
c01070a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01070a4:	83 ec 0c             	sub    $0xc,%esp
c01070a7:	ff 75 f4             	pushl  -0xc(%ebp)
c01070aa:	e8 9b fd ff ff       	call   c0106e4a <__intr_restore>
c01070af:	83 c4 10             	add    $0x10,%esp
    return ret;
c01070b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01070b5:	c9                   	leave  
c01070b6:	c3                   	ret    

c01070b7 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01070b7:	55                   	push   %ebp
c01070b8:	89 e5                	mov    %esp,%ebp
c01070ba:	57                   	push   %edi
c01070bb:	56                   	push   %esi
c01070bc:	53                   	push   %ebx
c01070bd:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01070c0:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01070c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01070ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01070d5:	83 ec 0c             	sub    $0xc,%esp
c01070d8:	68 7f b8 10 c0       	push   $0xc010b87f
c01070dd:	e8 b0 91 ff ff       	call   c0100292 <cprintf>
c01070e2:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01070e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01070ec:	e9 fc 00 00 00       	jmp    c01071ed <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01070f1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01070f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01070f7:	89 d0                	mov    %edx,%eax
c01070f9:	c1 e0 02             	shl    $0x2,%eax
c01070fc:	01 d0                	add    %edx,%eax
c01070fe:	c1 e0 02             	shl    $0x2,%eax
c0107101:	01 c8                	add    %ecx,%eax
c0107103:	8b 50 08             	mov    0x8(%eax),%edx
c0107106:	8b 40 04             	mov    0x4(%eax),%eax
c0107109:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010710c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010710f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107112:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107115:	89 d0                	mov    %edx,%eax
c0107117:	c1 e0 02             	shl    $0x2,%eax
c010711a:	01 d0                	add    %edx,%eax
c010711c:	c1 e0 02             	shl    $0x2,%eax
c010711f:	01 c8                	add    %ecx,%eax
c0107121:	8b 48 0c             	mov    0xc(%eax),%ecx
c0107124:	8b 58 10             	mov    0x10(%eax),%ebx
c0107127:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010712a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010712d:	01 c8                	add    %ecx,%eax
c010712f:	11 da                	adc    %ebx,%edx
c0107131:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0107134:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0107137:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010713a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010713d:	89 d0                	mov    %edx,%eax
c010713f:	c1 e0 02             	shl    $0x2,%eax
c0107142:	01 d0                	add    %edx,%eax
c0107144:	c1 e0 02             	shl    $0x2,%eax
c0107147:	01 c8                	add    %ecx,%eax
c0107149:	83 c0 14             	add    $0x14,%eax
c010714c:	8b 00                	mov    (%eax),%eax
c010714e:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0107151:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107154:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107157:	83 c0 ff             	add    $0xffffffff,%eax
c010715a:	83 d2 ff             	adc    $0xffffffff,%edx
c010715d:	89 c1                	mov    %eax,%ecx
c010715f:	89 d3                	mov    %edx,%ebx
c0107161:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0107164:	89 55 80             	mov    %edx,-0x80(%ebp)
c0107167:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010716a:	89 d0                	mov    %edx,%eax
c010716c:	c1 e0 02             	shl    $0x2,%eax
c010716f:	01 d0                	add    %edx,%eax
c0107171:	c1 e0 02             	shl    $0x2,%eax
c0107174:	03 45 80             	add    -0x80(%ebp),%eax
c0107177:	8b 50 10             	mov    0x10(%eax),%edx
c010717a:	8b 40 0c             	mov    0xc(%eax),%eax
c010717d:	ff 75 84             	pushl  -0x7c(%ebp)
c0107180:	53                   	push   %ebx
c0107181:	51                   	push   %ecx
c0107182:	ff 75 bc             	pushl  -0x44(%ebp)
c0107185:	ff 75 b8             	pushl  -0x48(%ebp)
c0107188:	52                   	push   %edx
c0107189:	50                   	push   %eax
c010718a:	68 8c b8 10 c0       	push   $0xc010b88c
c010718f:	e8 fe 90 ff ff       	call   c0100292 <cprintf>
c0107194:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0107197:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010719a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010719d:	89 d0                	mov    %edx,%eax
c010719f:	c1 e0 02             	shl    $0x2,%eax
c01071a2:	01 d0                	add    %edx,%eax
c01071a4:	c1 e0 02             	shl    $0x2,%eax
c01071a7:	01 c8                	add    %ecx,%eax
c01071a9:	83 c0 14             	add    $0x14,%eax
c01071ac:	8b 00                	mov    (%eax),%eax
c01071ae:	83 f8 01             	cmp    $0x1,%eax
c01071b1:	75 36                	jne    c01071e9 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c01071b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01071b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01071b9:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01071bc:	77 2b                	ja     c01071e9 <page_init+0x132>
c01071be:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01071c1:	72 05                	jb     c01071c8 <page_init+0x111>
c01071c3:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01071c6:	73 21                	jae    c01071e9 <page_init+0x132>
c01071c8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01071cc:	77 1b                	ja     c01071e9 <page_init+0x132>
c01071ce:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01071d2:	72 09                	jb     c01071dd <page_init+0x126>
c01071d4:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01071db:	77 0c                	ja     c01071e9 <page_init+0x132>
                maxpa = end;
c01071dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01071e0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01071e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01071e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01071e9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01071ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01071f0:	8b 00                	mov    (%eax),%eax
c01071f2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01071f5:	0f 8f f6 fe ff ff    	jg     c01070f1 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01071fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01071ff:	72 1d                	jb     c010721e <page_init+0x167>
c0107201:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107205:	77 09                	ja     c0107210 <page_init+0x159>
c0107207:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010720e:	76 0e                	jbe    c010721e <page_init+0x167>
        maxpa = KMEMSIZE;
c0107210:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0107217:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010721e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107224:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107228:	c1 ea 0c             	shr    $0xc,%edx
c010722b:	a3 80 9f 12 c0       	mov    %eax,0xc0129f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0107230:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0107237:	b8 a4 c1 12 c0       	mov    $0xc012c1a4,%eax
c010723c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010723f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107242:	01 d0                	add    %edx,%eax
c0107244:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0107247:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010724a:	ba 00 00 00 00       	mov    $0x0,%edx
c010724f:	f7 75 ac             	divl   -0x54(%ebp)
c0107252:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107255:	29 d0                	sub    %edx,%eax
c0107257:	a3 98 c1 12 c0       	mov    %eax,0xc012c198

    for (i = 0; i < npage; i ++) {
c010725c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0107263:	eb 27                	jmp    c010728c <page_init+0x1d5>
        SetPageReserved(pages + i);
c0107265:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c010726a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010726d:	c1 e2 05             	shl    $0x5,%edx
c0107270:	01 d0                	add    %edx,%eax
c0107272:	83 c0 04             	add    $0x4,%eax
c0107275:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010727c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010727f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0107282:	8b 55 90             	mov    -0x70(%ebp),%edx
c0107285:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0107288:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010728c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010728f:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107294:	39 c2                	cmp    %eax,%edx
c0107296:	72 cd                	jb     c0107265 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0107298:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010729d:	c1 e0 05             	shl    $0x5,%eax
c01072a0:	89 c2                	mov    %eax,%edx
c01072a2:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c01072a7:	01 d0                	add    %edx,%eax
c01072a9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01072ac:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01072b3:	77 17                	ja     c01072cc <page_init+0x215>
c01072b5:	ff 75 a4             	pushl  -0x5c(%ebp)
c01072b8:	68 bc b8 10 c0       	push   $0xc010b8bc
c01072bd:	68 ea 00 00 00       	push   $0xea
c01072c2:	68 e0 b8 10 c0       	push   $0xc010b8e0
c01072c7:	e8 2c 91 ff ff       	call   c01003f8 <__panic>
c01072cc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01072cf:	05 00 00 00 40       	add    $0x40000000,%eax
c01072d4:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01072d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01072de:	e9 69 01 00 00       	jmp    c010744c <page_init+0x395>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01072e3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01072e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01072e9:	89 d0                	mov    %edx,%eax
c01072eb:	c1 e0 02             	shl    $0x2,%eax
c01072ee:	01 d0                	add    %edx,%eax
c01072f0:	c1 e0 02             	shl    $0x2,%eax
c01072f3:	01 c8                	add    %ecx,%eax
c01072f5:	8b 50 08             	mov    0x8(%eax),%edx
c01072f8:	8b 40 04             	mov    0x4(%eax),%eax
c01072fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01072fe:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0107301:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107304:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107307:	89 d0                	mov    %edx,%eax
c0107309:	c1 e0 02             	shl    $0x2,%eax
c010730c:	01 d0                	add    %edx,%eax
c010730e:	c1 e0 02             	shl    $0x2,%eax
c0107311:	01 c8                	add    %ecx,%eax
c0107313:	8b 48 0c             	mov    0xc(%eax),%ecx
c0107316:	8b 58 10             	mov    0x10(%eax),%ebx
c0107319:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010731c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010731f:	01 c8                	add    %ecx,%eax
c0107321:	11 da                	adc    %ebx,%edx
c0107323:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0107326:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0107329:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010732c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010732f:	89 d0                	mov    %edx,%eax
c0107331:	c1 e0 02             	shl    $0x2,%eax
c0107334:	01 d0                	add    %edx,%eax
c0107336:	c1 e0 02             	shl    $0x2,%eax
c0107339:	01 c8                	add    %ecx,%eax
c010733b:	83 c0 14             	add    $0x14,%eax
c010733e:	8b 00                	mov    (%eax),%eax
c0107340:	83 f8 01             	cmp    $0x1,%eax
c0107343:	0f 85 ff 00 00 00    	jne    c0107448 <page_init+0x391>
            if (begin < freemem) {
c0107349:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010734c:	ba 00 00 00 00       	mov    $0x0,%edx
c0107351:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107354:	72 17                	jb     c010736d <page_init+0x2b6>
c0107356:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107359:	77 05                	ja     c0107360 <page_init+0x2a9>
c010735b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010735e:	76 0d                	jbe    c010736d <page_init+0x2b6>
                begin = freemem;
c0107360:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107363:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107366:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010736d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107371:	72 1d                	jb     c0107390 <page_init+0x2d9>
c0107373:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107377:	77 09                	ja     c0107382 <page_init+0x2cb>
c0107379:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0107380:	76 0e                	jbe    c0107390 <page_init+0x2d9>
                end = KMEMSIZE;
c0107382:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0107389:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0107390:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107393:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107396:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107399:	0f 87 a9 00 00 00    	ja     c0107448 <page_init+0x391>
c010739f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01073a2:	72 09                	jb     c01073ad <page_init+0x2f6>
c01073a4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01073a7:	0f 83 9b 00 00 00    	jae    c0107448 <page_init+0x391>
                begin = ROUNDUP(begin, PGSIZE);
c01073ad:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01073b4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01073b7:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01073ba:	01 d0                	add    %edx,%eax
c01073bc:	83 e8 01             	sub    $0x1,%eax
c01073bf:	89 45 98             	mov    %eax,-0x68(%ebp)
c01073c2:	8b 45 98             	mov    -0x68(%ebp),%eax
c01073c5:	ba 00 00 00 00       	mov    $0x0,%edx
c01073ca:	f7 75 9c             	divl   -0x64(%ebp)
c01073cd:	8b 45 98             	mov    -0x68(%ebp),%eax
c01073d0:	29 d0                	sub    %edx,%eax
c01073d2:	ba 00 00 00 00       	mov    $0x0,%edx
c01073d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01073da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01073dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01073e0:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01073e3:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01073e6:	ba 00 00 00 00       	mov    $0x0,%edx
c01073eb:	89 c3                	mov    %eax,%ebx
c01073ed:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01073f3:	89 de                	mov    %ebx,%esi
c01073f5:	89 d0                	mov    %edx,%eax
c01073f7:	83 e0 00             	and    $0x0,%eax
c01073fa:	89 c7                	mov    %eax,%edi
c01073fc:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01073ff:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0107402:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107405:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107408:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010740b:	77 3b                	ja     c0107448 <page_init+0x391>
c010740d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107410:	72 05                	jb     c0107417 <page_init+0x360>
c0107412:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0107415:	73 31                	jae    c0107448 <page_init+0x391>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0107417:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010741a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010741d:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0107420:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0107423:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107427:	c1 ea 0c             	shr    $0xc,%edx
c010742a:	89 c3                	mov    %eax,%ebx
c010742c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010742f:	83 ec 0c             	sub    $0xc,%esp
c0107432:	50                   	push   %eax
c0107433:	e8 ca f8 ff ff       	call   c0106d02 <pa2page>
c0107438:	83 c4 10             	add    $0x10,%esp
c010743b:	83 ec 08             	sub    $0x8,%esp
c010743e:	53                   	push   %ebx
c010743f:	50                   	push   %eax
c0107440:	e8 84 fb ff ff       	call   c0106fc9 <init_memmap>
c0107445:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0107448:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010744c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010744f:	8b 00                	mov    (%eax),%eax
c0107451:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0107454:	0f 8f 89 fe ff ff    	jg     c01072e3 <page_init+0x22c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010745a:	90                   	nop
c010745b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010745e:	5b                   	pop    %ebx
c010745f:	5e                   	pop    %esi
c0107460:	5f                   	pop    %edi
c0107461:	5d                   	pop    %ebp
c0107462:	c3                   	ret    

c0107463 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0107463:	55                   	push   %ebp
c0107464:	89 e5                	mov    %esp,%ebp
c0107466:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0107469:	8b 45 0c             	mov    0xc(%ebp),%eax
c010746c:	33 45 14             	xor    0x14(%ebp),%eax
c010746f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107474:	85 c0                	test   %eax,%eax
c0107476:	74 19                	je     c0107491 <boot_map_segment+0x2e>
c0107478:	68 ee b8 10 c0       	push   $0xc010b8ee
c010747d:	68 05 b9 10 c0       	push   $0xc010b905
c0107482:	68 08 01 00 00       	push   $0x108
c0107487:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010748c:	e8 67 8f ff ff       	call   c01003f8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0107491:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0107498:	8b 45 0c             	mov    0xc(%ebp),%eax
c010749b:	25 ff 0f 00 00       	and    $0xfff,%eax
c01074a0:	89 c2                	mov    %eax,%edx
c01074a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01074a5:	01 c2                	add    %eax,%edx
c01074a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074aa:	01 d0                	add    %edx,%eax
c01074ac:	83 e8 01             	sub    $0x1,%eax
c01074af:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01074b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074b5:	ba 00 00 00 00       	mov    $0x0,%edx
c01074ba:	f7 75 f0             	divl   -0x10(%ebp)
c01074bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074c0:	29 d0                	sub    %edx,%eax
c01074c2:	c1 e8 0c             	shr    $0xc,%eax
c01074c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01074c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01074ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01074d6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01074d9:	8b 45 14             	mov    0x14(%ebp),%eax
c01074dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01074df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01074e7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01074ea:	eb 57                	jmp    c0107543 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01074ec:	83 ec 04             	sub    $0x4,%esp
c01074ef:	6a 01                	push   $0x1
c01074f1:	ff 75 0c             	pushl  0xc(%ebp)
c01074f4:	ff 75 08             	pushl  0x8(%ebp)
c01074f7:	e8 58 01 00 00       	call   c0107654 <get_pte>
c01074fc:	83 c4 10             	add    $0x10,%esp
c01074ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0107502:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107506:	75 19                	jne    c0107521 <boot_map_segment+0xbe>
c0107508:	68 1a b9 10 c0       	push   $0xc010b91a
c010750d:	68 05 b9 10 c0       	push   $0xc010b905
c0107512:	68 0e 01 00 00       	push   $0x10e
c0107517:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010751c:	e8 d7 8e ff ff       	call   c01003f8 <__panic>
        *ptep = pa | PTE_P | perm;
c0107521:	8b 45 14             	mov    0x14(%ebp),%eax
c0107524:	0b 45 18             	or     0x18(%ebp),%eax
c0107527:	83 c8 01             	or     $0x1,%eax
c010752a:	89 c2                	mov    %eax,%edx
c010752c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010752f:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0107531:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107535:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010753c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0107543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107547:	75 a3                	jne    c01074ec <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0107549:	90                   	nop
c010754a:	c9                   	leave  
c010754b:	c3                   	ret    

c010754c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010754c:	55                   	push   %ebp
c010754d:	89 e5                	mov    %esp,%ebp
c010754f:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0107552:	83 ec 0c             	sub    $0xc,%esp
c0107555:	6a 01                	push   $0x1
c0107557:	e8 8c fa ff ff       	call   c0106fe8 <alloc_pages>
c010755c:	83 c4 10             	add    $0x10,%esp
c010755f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0107562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107566:	75 17                	jne    c010757f <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0107568:	83 ec 04             	sub    $0x4,%esp
c010756b:	68 27 b9 10 c0       	push   $0xc010b927
c0107570:	68 1a 01 00 00       	push   $0x11a
c0107575:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010757a:	e8 79 8e ff ff       	call   c01003f8 <__panic>
    }
    return page2kva(p);
c010757f:	83 ec 0c             	sub    $0xc,%esp
c0107582:	ff 75 f4             	pushl  -0xc(%ebp)
c0107585:	e8 b5 f7 ff ff       	call   c0106d3f <page2kva>
c010758a:	83 c4 10             	add    $0x10,%esp
}
c010758d:	c9                   	leave  
c010758e:	c3                   	ret    

c010758f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010758f:	55                   	push   %ebp
c0107590:	89 e5                	mov    %esp,%ebp
c0107592:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0107595:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010759a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010759d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01075a4:	77 17                	ja     c01075bd <pmm_init+0x2e>
c01075a6:	ff 75 f4             	pushl  -0xc(%ebp)
c01075a9:	68 bc b8 10 c0       	push   $0xc010b8bc
c01075ae:	68 24 01 00 00       	push   $0x124
c01075b3:	68 e0 b8 10 c0       	push   $0xc010b8e0
c01075b8:	e8 3b 8e ff ff       	call   c01003f8 <__panic>
c01075bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075c0:	05 00 00 00 40       	add    $0x40000000,%eax
c01075c5:	a3 94 c1 12 c0       	mov    %eax,0xc012c194
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01075ca:	e8 c5 f9 ff ff       	call   c0106f94 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01075cf:	e8 e3 fa ff ff       	call   c01070b7 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01075d4:	e8 6b 04 00 00       	call   c0107a44 <check_alloc_page>

    check_pgdir();
c01075d9:	e8 89 04 00 00       	call   c0107a67 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01075de:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01075e3:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01075e9:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01075ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01075f1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01075f8:	77 17                	ja     c0107611 <pmm_init+0x82>
c01075fa:	ff 75 f0             	pushl  -0x10(%ebp)
c01075fd:	68 bc b8 10 c0       	push   $0xc010b8bc
c0107602:	68 3a 01 00 00       	push   $0x13a
c0107607:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010760c:	e8 e7 8d ff ff       	call   c01003f8 <__panic>
c0107611:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107614:	05 00 00 00 40       	add    $0x40000000,%eax
c0107619:	83 c8 03             	or     $0x3,%eax
c010761c:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010761e:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107623:	83 ec 0c             	sub    $0xc,%esp
c0107626:	6a 02                	push   $0x2
c0107628:	6a 00                	push   $0x0
c010762a:	68 00 00 00 38       	push   $0x38000000
c010762f:	68 00 00 00 c0       	push   $0xc0000000
c0107634:	50                   	push   %eax
c0107635:	e8 29 fe ff ff       	call   c0107463 <boot_map_segment>
c010763a:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010763d:	e8 60 f8 ff ff       	call   c0106ea2 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0107642:	e8 86 09 00 00       	call   c0107fcd <check_boot_pgdir>

    print_pgdir();
c0107647:	e8 7c 0d 00 00       	call   c01083c8 <print_pgdir>
    
    kmalloc_init();
c010764c:	e8 7d d9 ff ff       	call   c0104fce <kmalloc_init>

}
c0107651:	90                   	nop
c0107652:	c9                   	leave  
c0107653:	c3                   	ret    

c0107654 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0107654:	55                   	push   %ebp
c0107655:	89 e5                	mov    %esp,%ebp
c0107657:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
c010765a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010765d:	c1 e8 16             	shr    $0x16,%eax
c0107660:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
c0107663:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107666:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010766d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107670:	01 d0                	add    %edx,%eax
c0107672:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
c0107675:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107678:	8b 00                	mov    (%eax),%eax
c010767a:	83 e0 01             	and    $0x1,%eax
c010767d:	85 c0                	test   %eax,%eax
c010767f:	0f 85 ae 00 00 00    	jne    c0107733 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
c0107685:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107689:	75 0a                	jne    c0107695 <get_pte+0x41>
            return NULL;
c010768b:	b8 00 00 00 00       	mov    $0x0,%eax
c0107690:	e9 01 01 00 00       	jmp    c0107796 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
c0107695:	83 ec 0c             	sub    $0xc,%esp
c0107698:	6a 01                	push   $0x1
c010769a:	e8 49 f9 ff ff       	call   c0106fe8 <alloc_pages>
c010769f:	83 c4 10             	add    $0x10,%esp
c01076a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
c01076a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01076a9:	75 0a                	jne    c01076b5 <get_pte+0x61>
            return NULL;
c01076ab:	b8 00 00 00 00       	mov    $0x0,%eax
c01076b0:	e9 e1 00 00 00       	jmp    c0107796 <get_pte+0x142>
        }
        // (4) set page reference
        set_page_ref(pt_page, 1);
c01076b5:	83 ec 08             	sub    $0x8,%esp
c01076b8:	6a 01                	push   $0x1
c01076ba:	ff 75 ec             	pushl  -0x14(%ebp)
c01076bd:	e8 22 f7 ff ff       	call   c0106de4 <set_page_ref>
c01076c2:	83 c4 10             	add    $0x10,%esp
        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
c01076c5:	83 ec 0c             	sub    $0xc,%esp
c01076c8:	ff 75 ec             	pushl  -0x14(%ebp)
c01076cb:	e8 1f f6 ff ff       	call   c0106cef <page2pa>
c01076d0:	83 c4 10             	add    $0x10,%esp
c01076d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
c01076d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01076dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076df:	c1 e8 0c             	shr    $0xc,%eax
c01076e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01076e5:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c01076ea:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01076ed:	72 17                	jb     c0107706 <get_pte+0xb2>
c01076ef:	ff 75 e4             	pushl  -0x1c(%ebp)
c01076f2:	68 18 b8 10 c0       	push   $0xc010b818
c01076f7:	68 8d 01 00 00       	push   $0x18d
c01076fc:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107701:	e8 f2 8c ff ff       	call   c01003f8 <__panic>
c0107706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107709:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010770e:	83 ec 04             	sub    $0x4,%esp
c0107711:	68 00 10 00 00       	push   $0x1000
c0107716:	6a 00                	push   $0x0
c0107718:	50                   	push   %eax
c0107719:	e8 06 1e 00 00       	call   c0109524 <memset>
c010771e:	83 c4 10             	add    $0x10,%esp
        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
c0107721:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107724:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107729:	83 c8 07             	or     $0x7,%eax
c010772c:	89 c2                	mov    %eax,%edx
c010772e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107731:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
c0107733:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107736:	c1 e8 0c             	shr    $0xc,%eax
c0107739:	25 ff 03 00 00       	and    $0x3ff,%eax
c010773e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
c0107741:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107744:	8b 00                	mov    (%eax),%eax
c0107746:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010774b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
c010774e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107751:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0107754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107757:	c1 e8 0c             	shr    $0xc,%eax
c010775a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010775d:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107762:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0107765:	72 17                	jb     c010777e <get_pte+0x12a>
c0107767:	ff 75 d4             	pushl  -0x2c(%ebp)
c010776a:	68 18 b8 10 c0       	push   $0xc010b818
c010776f:	68 94 01 00 00       	push   $0x194
c0107774:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107779:	e8 7a 8c ff ff       	call   c01003f8 <__panic>
c010777e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107781:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107786:	89 c2                	mov    %eax,%edx
c0107788:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010778b:	c1 e0 02             	shl    $0x2,%eax
c010778e:	01 d0                	add    %edx,%eax
c0107790:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
c0107793:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
c0107796:	c9                   	leave  
c0107797:	c3                   	ret    

c0107798 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0107798:	55                   	push   %ebp
c0107799:	89 e5                	mov    %esp,%ebp
c010779b:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010779e:	83 ec 04             	sub    $0x4,%esp
c01077a1:	6a 00                	push   $0x0
c01077a3:	ff 75 0c             	pushl  0xc(%ebp)
c01077a6:	ff 75 08             	pushl  0x8(%ebp)
c01077a9:	e8 a6 fe ff ff       	call   c0107654 <get_pte>
c01077ae:	83 c4 10             	add    $0x10,%esp
c01077b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01077b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01077b8:	74 08                	je     c01077c2 <get_page+0x2a>
        *ptep_store = ptep;
c01077ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01077bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01077c0:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01077c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077c6:	74 1f                	je     c01077e7 <get_page+0x4f>
c01077c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077cb:	8b 00                	mov    (%eax),%eax
c01077cd:	83 e0 01             	and    $0x1,%eax
c01077d0:	85 c0                	test   %eax,%eax
c01077d2:	74 13                	je     c01077e7 <get_page+0x4f>
        return pte2page(*ptep);
c01077d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077d7:	8b 00                	mov    (%eax),%eax
c01077d9:	83 ec 0c             	sub    $0xc,%esp
c01077dc:	50                   	push   %eax
c01077dd:	e8 a2 f5 ff ff       	call   c0106d84 <pte2page>
c01077e2:	83 c4 10             	add    $0x10,%esp
c01077e5:	eb 05                	jmp    c01077ec <get_page+0x54>
    }
    return NULL;
c01077e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01077ec:	c9                   	leave  
c01077ed:	c3                   	ret    

c01077ee <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01077ee:	55                   	push   %ebp
c01077ef:	89 e5                	mov    %esp,%ebp
c01077f1:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
c01077f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01077f7:	8b 00                	mov    (%eax),%eax
c01077f9:	83 e0 01             	and    $0x1,%eax
c01077fc:	85 c0                	test   %eax,%eax
c01077fe:	74 57                	je     c0107857 <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
c0107800:	8b 45 10             	mov    0x10(%ebp),%eax
c0107803:	8b 00                	mov    (%eax),%eax
c0107805:	83 ec 0c             	sub    $0xc,%esp
c0107808:	50                   	push   %eax
c0107809:	e8 76 f5 ff ff       	call   c0106d84 <pte2page>
c010780e:	83 c4 10             	add    $0x10,%esp
c0107811:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //(3) decrease page reference
    page_ref_dec(page);
c0107814:	83 ec 0c             	sub    $0xc,%esp
c0107817:	ff 75 f4             	pushl  -0xc(%ebp)
c010781a:	e8 ea f5 ff ff       	call   c0106e09 <page_ref_dec>
c010781f:	83 c4 10             	add    $0x10,%esp
    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
c0107822:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107825:	8b 00                	mov    (%eax),%eax
c0107827:	85 c0                	test   %eax,%eax
c0107829:	75 10                	jne    c010783b <page_remove_pte+0x4d>
        free_page(page);
c010782b:	83 ec 08             	sub    $0x8,%esp
c010782e:	6a 01                	push   $0x1
c0107830:	ff 75 f4             	pushl  -0xc(%ebp)
c0107833:	e8 1c f8 ff ff       	call   c0107054 <free_pages>
c0107838:	83 c4 10             	add    $0x10,%esp
    }
    //(5) clear second page table entry
    *ptep = 0;
c010783b:	8b 45 10             	mov    0x10(%ebp),%eax
c010783e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
c0107844:	83 ec 08             	sub    $0x8,%esp
c0107847:	ff 75 0c             	pushl  0xc(%ebp)
c010784a:	ff 75 08             	pushl  0x8(%ebp)
c010784d:	e8 fa 00 00 00       	call   c010794c <tlb_invalidate>
c0107852:	83 c4 10             	add    $0x10,%esp
c0107855:	eb 01                	jmp    c0107858 <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
c0107857:	90                   	nop
    }
    //(5) clear second page table entry
    *ptep = 0;
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
c0107858:	c9                   	leave  
c0107859:	c3                   	ret    

c010785a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010785a:	55                   	push   %ebp
c010785b:	89 e5                	mov    %esp,%ebp
c010785d:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0107860:	83 ec 04             	sub    $0x4,%esp
c0107863:	6a 00                	push   $0x0
c0107865:	ff 75 0c             	pushl  0xc(%ebp)
c0107868:	ff 75 08             	pushl  0x8(%ebp)
c010786b:	e8 e4 fd ff ff       	call   c0107654 <get_pte>
c0107870:	83 c4 10             	add    $0x10,%esp
c0107873:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0107876:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010787a:	74 14                	je     c0107890 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010787c:	83 ec 04             	sub    $0x4,%esp
c010787f:	ff 75 f4             	pushl  -0xc(%ebp)
c0107882:	ff 75 0c             	pushl  0xc(%ebp)
c0107885:	ff 75 08             	pushl  0x8(%ebp)
c0107888:	e8 61 ff ff ff       	call   c01077ee <page_remove_pte>
c010788d:	83 c4 10             	add    $0x10,%esp
    }
}
c0107890:	90                   	nop
c0107891:	c9                   	leave  
c0107892:	c3                   	ret    

c0107893 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0107893:	55                   	push   %ebp
c0107894:	89 e5                	mov    %esp,%ebp
c0107896:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0107899:	83 ec 04             	sub    $0x4,%esp
c010789c:	6a 01                	push   $0x1
c010789e:	ff 75 10             	pushl  0x10(%ebp)
c01078a1:	ff 75 08             	pushl  0x8(%ebp)
c01078a4:	e8 ab fd ff ff       	call   c0107654 <get_pte>
c01078a9:	83 c4 10             	add    $0x10,%esp
c01078ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01078af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01078b3:	75 0a                	jne    c01078bf <page_insert+0x2c>
        return -E_NO_MEM;
c01078b5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01078ba:	e9 8b 00 00 00       	jmp    c010794a <page_insert+0xb7>
    }
    page_ref_inc(page);
c01078bf:	83 ec 0c             	sub    $0xc,%esp
c01078c2:	ff 75 0c             	pushl  0xc(%ebp)
c01078c5:	e8 28 f5 ff ff       	call   c0106df2 <page_ref_inc>
c01078ca:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01078cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078d0:	8b 00                	mov    (%eax),%eax
c01078d2:	83 e0 01             	and    $0x1,%eax
c01078d5:	85 c0                	test   %eax,%eax
c01078d7:	74 40                	je     c0107919 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01078d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078dc:	8b 00                	mov    (%eax),%eax
c01078de:	83 ec 0c             	sub    $0xc,%esp
c01078e1:	50                   	push   %eax
c01078e2:	e8 9d f4 ff ff       	call   c0106d84 <pte2page>
c01078e7:	83 c4 10             	add    $0x10,%esp
c01078ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01078ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01078f3:	75 10                	jne    c0107905 <page_insert+0x72>
            page_ref_dec(page);
c01078f5:	83 ec 0c             	sub    $0xc,%esp
c01078f8:	ff 75 0c             	pushl  0xc(%ebp)
c01078fb:	e8 09 f5 ff ff       	call   c0106e09 <page_ref_dec>
c0107900:	83 c4 10             	add    $0x10,%esp
c0107903:	eb 14                	jmp    c0107919 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0107905:	83 ec 04             	sub    $0x4,%esp
c0107908:	ff 75 f4             	pushl  -0xc(%ebp)
c010790b:	ff 75 10             	pushl  0x10(%ebp)
c010790e:	ff 75 08             	pushl  0x8(%ebp)
c0107911:	e8 d8 fe ff ff       	call   c01077ee <page_remove_pte>
c0107916:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0107919:	83 ec 0c             	sub    $0xc,%esp
c010791c:	ff 75 0c             	pushl  0xc(%ebp)
c010791f:	e8 cb f3 ff ff       	call   c0106cef <page2pa>
c0107924:	83 c4 10             	add    $0x10,%esp
c0107927:	0b 45 14             	or     0x14(%ebp),%eax
c010792a:	83 c8 01             	or     $0x1,%eax
c010792d:	89 c2                	mov    %eax,%edx
c010792f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107932:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0107934:	83 ec 08             	sub    $0x8,%esp
c0107937:	ff 75 10             	pushl  0x10(%ebp)
c010793a:	ff 75 08             	pushl  0x8(%ebp)
c010793d:	e8 0a 00 00 00       	call   c010794c <tlb_invalidate>
c0107942:	83 c4 10             	add    $0x10,%esp
    return 0;
c0107945:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010794a:	c9                   	leave  
c010794b:	c3                   	ret    

c010794c <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010794c:	55                   	push   %ebp
c010794d:	89 e5                	mov    %esp,%ebp
c010794f:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0107952:	0f 20 d8             	mov    %cr3,%eax
c0107955:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0107958:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010795b:	8b 45 08             	mov    0x8(%ebp),%eax
c010795e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107961:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107968:	77 17                	ja     c0107981 <tlb_invalidate+0x35>
c010796a:	ff 75 f0             	pushl  -0x10(%ebp)
c010796d:	68 bc b8 10 c0       	push   $0xc010b8bc
c0107972:	68 ff 01 00 00       	push   $0x1ff
c0107977:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010797c:	e8 77 8a ff ff       	call   c01003f8 <__panic>
c0107981:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107984:	05 00 00 00 40       	add    $0x40000000,%eax
c0107989:	39 c2                	cmp    %eax,%edx
c010798b:	75 0c                	jne    c0107999 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c010798d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107990:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0107993:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107996:	0f 01 38             	invlpg (%eax)
    }
}
c0107999:	90                   	nop
c010799a:	c9                   	leave  
c010799b:	c3                   	ret    

c010799c <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010799c:	55                   	push   %ebp
c010799d:	89 e5                	mov    %esp,%ebp
c010799f:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_page();
c01079a2:	83 ec 0c             	sub    $0xc,%esp
c01079a5:	6a 01                	push   $0x1
c01079a7:	e8 3c f6 ff ff       	call   c0106fe8 <alloc_pages>
c01079ac:	83 c4 10             	add    $0x10,%esp
c01079af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01079b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01079b6:	0f 84 83 00 00 00    	je     c0107a3f <pgdir_alloc_page+0xa3>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01079bc:	ff 75 10             	pushl  0x10(%ebp)
c01079bf:	ff 75 0c             	pushl  0xc(%ebp)
c01079c2:	ff 75 f4             	pushl  -0xc(%ebp)
c01079c5:	ff 75 08             	pushl  0x8(%ebp)
c01079c8:	e8 c6 fe ff ff       	call   c0107893 <page_insert>
c01079cd:	83 c4 10             	add    $0x10,%esp
c01079d0:	85 c0                	test   %eax,%eax
c01079d2:	74 17                	je     c01079eb <pgdir_alloc_page+0x4f>
            free_page(page);
c01079d4:	83 ec 08             	sub    $0x8,%esp
c01079d7:	6a 01                	push   $0x1
c01079d9:	ff 75 f4             	pushl  -0xc(%ebp)
c01079dc:	e8 73 f6 ff ff       	call   c0107054 <free_pages>
c01079e1:	83 c4 10             	add    $0x10,%esp
            return NULL;
c01079e4:	b8 00 00 00 00       	mov    $0x0,%eax
c01079e9:	eb 57                	jmp    c0107a42 <pgdir_alloc_page+0xa6>
        }
        if (swap_init_ok){
c01079eb:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c01079f0:	85 c0                	test   %eax,%eax
c01079f2:	74 4b                	je     c0107a3f <pgdir_alloc_page+0xa3>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01079f4:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c01079f9:	6a 00                	push   $0x0
c01079fb:	ff 75 f4             	pushl  -0xc(%ebp)
c01079fe:	ff 75 0c             	pushl  0xc(%ebp)
c0107a01:	50                   	push   %eax
c0107a02:	e8 a2 d9 ff ff       	call   c01053a9 <swap_map_swappable>
c0107a07:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr=la;
c0107a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107a10:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0107a13:	83 ec 0c             	sub    $0xc,%esp
c0107a16:	ff 75 f4             	pushl  -0xc(%ebp)
c0107a19:	e8 bc f3 ff ff       	call   c0106dda <page_ref>
c0107a1e:	83 c4 10             	add    $0x10,%esp
c0107a21:	83 f8 01             	cmp    $0x1,%eax
c0107a24:	74 19                	je     c0107a3f <pgdir_alloc_page+0xa3>
c0107a26:	68 40 b9 10 c0       	push   $0xc010b940
c0107a2b:	68 05 b9 10 c0       	push   $0xc010b905
c0107a30:	68 12 02 00 00       	push   $0x212
c0107a35:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107a3a:	e8 b9 89 ff ff       	call   c01003f8 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0107a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107a42:	c9                   	leave  
c0107a43:	c3                   	ret    

c0107a44 <check_alloc_page>:

static void
check_alloc_page(void) {
c0107a44:	55                   	push   %ebp
c0107a45:	89 e5                	mov    %esp,%ebp
c0107a47:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0107a4a:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0107a4f:	8b 40 18             	mov    0x18(%eax),%eax
c0107a52:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0107a54:	83 ec 0c             	sub    $0xc,%esp
c0107a57:	68 54 b9 10 c0       	push   $0xc010b954
c0107a5c:	e8 31 88 ff ff       	call   c0100292 <cprintf>
c0107a61:	83 c4 10             	add    $0x10,%esp
}
c0107a64:	90                   	nop
c0107a65:	c9                   	leave  
c0107a66:	c3                   	ret    

c0107a67 <check_pgdir>:

static void
check_pgdir(void) {
c0107a67:	55                   	push   %ebp
c0107a68:	89 e5                	mov    %esp,%ebp
c0107a6a:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0107a6d:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107a72:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0107a77:	76 19                	jbe    c0107a92 <check_pgdir+0x2b>
c0107a79:	68 73 b9 10 c0       	push   $0xc010b973
c0107a7e:	68 05 b9 10 c0       	push   $0xc010b905
c0107a83:	68 23 02 00 00       	push   $0x223
c0107a88:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107a8d:	e8 66 89 ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0107a92:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107a97:	85 c0                	test   %eax,%eax
c0107a99:	74 0e                	je     c0107aa9 <check_pgdir+0x42>
c0107a9b:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107aa0:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107aa5:	85 c0                	test   %eax,%eax
c0107aa7:	74 19                	je     c0107ac2 <check_pgdir+0x5b>
c0107aa9:	68 90 b9 10 c0       	push   $0xc010b990
c0107aae:	68 05 b9 10 c0       	push   $0xc010b905
c0107ab3:	68 24 02 00 00       	push   $0x224
c0107ab8:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107abd:	e8 36 89 ff ff       	call   c01003f8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0107ac2:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107ac7:	83 ec 04             	sub    $0x4,%esp
c0107aca:	6a 00                	push   $0x0
c0107acc:	6a 00                	push   $0x0
c0107ace:	50                   	push   %eax
c0107acf:	e8 c4 fc ff ff       	call   c0107798 <get_page>
c0107ad4:	83 c4 10             	add    $0x10,%esp
c0107ad7:	85 c0                	test   %eax,%eax
c0107ad9:	74 19                	je     c0107af4 <check_pgdir+0x8d>
c0107adb:	68 c8 b9 10 c0       	push   $0xc010b9c8
c0107ae0:	68 05 b9 10 c0       	push   $0xc010b905
c0107ae5:	68 25 02 00 00       	push   $0x225
c0107aea:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107aef:	e8 04 89 ff ff       	call   c01003f8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107af4:	83 ec 0c             	sub    $0xc,%esp
c0107af7:	6a 01                	push   $0x1
c0107af9:	e8 ea f4 ff ff       	call   c0106fe8 <alloc_pages>
c0107afe:	83 c4 10             	add    $0x10,%esp
c0107b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107b04:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107b09:	6a 00                	push   $0x0
c0107b0b:	6a 00                	push   $0x0
c0107b0d:	ff 75 f4             	pushl  -0xc(%ebp)
c0107b10:	50                   	push   %eax
c0107b11:	e8 7d fd ff ff       	call   c0107893 <page_insert>
c0107b16:	83 c4 10             	add    $0x10,%esp
c0107b19:	85 c0                	test   %eax,%eax
c0107b1b:	74 19                	je     c0107b36 <check_pgdir+0xcf>
c0107b1d:	68 f0 b9 10 c0       	push   $0xc010b9f0
c0107b22:	68 05 b9 10 c0       	push   $0xc010b905
c0107b27:	68 29 02 00 00       	push   $0x229
c0107b2c:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107b31:	e8 c2 88 ff ff       	call   c01003f8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0107b36:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107b3b:	83 ec 04             	sub    $0x4,%esp
c0107b3e:	6a 00                	push   $0x0
c0107b40:	6a 00                	push   $0x0
c0107b42:	50                   	push   %eax
c0107b43:	e8 0c fb ff ff       	call   c0107654 <get_pte>
c0107b48:	83 c4 10             	add    $0x10,%esp
c0107b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107b52:	75 19                	jne    c0107b6d <check_pgdir+0x106>
c0107b54:	68 1c ba 10 c0       	push   $0xc010ba1c
c0107b59:	68 05 b9 10 c0       	push   $0xc010b905
c0107b5e:	68 2c 02 00 00       	push   $0x22c
c0107b63:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107b68:	e8 8b 88 ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c0107b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b70:	8b 00                	mov    (%eax),%eax
c0107b72:	83 ec 0c             	sub    $0xc,%esp
c0107b75:	50                   	push   %eax
c0107b76:	e8 09 f2 ff ff       	call   c0106d84 <pte2page>
c0107b7b:	83 c4 10             	add    $0x10,%esp
c0107b7e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107b81:	74 19                	je     c0107b9c <check_pgdir+0x135>
c0107b83:	68 49 ba 10 c0       	push   $0xc010ba49
c0107b88:	68 05 b9 10 c0       	push   $0xc010b905
c0107b8d:	68 2d 02 00 00       	push   $0x22d
c0107b92:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107b97:	e8 5c 88 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 1);
c0107b9c:	83 ec 0c             	sub    $0xc,%esp
c0107b9f:	ff 75 f4             	pushl  -0xc(%ebp)
c0107ba2:	e8 33 f2 ff ff       	call   c0106dda <page_ref>
c0107ba7:	83 c4 10             	add    $0x10,%esp
c0107baa:	83 f8 01             	cmp    $0x1,%eax
c0107bad:	74 19                	je     c0107bc8 <check_pgdir+0x161>
c0107baf:	68 5f ba 10 c0       	push   $0xc010ba5f
c0107bb4:	68 05 b9 10 c0       	push   $0xc010b905
c0107bb9:	68 2e 02 00 00       	push   $0x22e
c0107bbe:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107bc3:	e8 30 88 ff ff       	call   c01003f8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0107bc8:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107bcd:	8b 00                	mov    (%eax),%eax
c0107bcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107bd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bda:	c1 e8 0c             	shr    $0xc,%eax
c0107bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107be0:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107be5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107be8:	72 17                	jb     c0107c01 <check_pgdir+0x19a>
c0107bea:	ff 75 ec             	pushl  -0x14(%ebp)
c0107bed:	68 18 b8 10 c0       	push   $0xc010b818
c0107bf2:	68 30 02 00 00       	push   $0x230
c0107bf7:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107bfc:	e8 f7 87 ff ff       	call   c01003f8 <__panic>
c0107c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c04:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107c09:	83 c0 04             	add    $0x4,%eax
c0107c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0107c0f:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107c14:	83 ec 04             	sub    $0x4,%esp
c0107c17:	6a 00                	push   $0x0
c0107c19:	68 00 10 00 00       	push   $0x1000
c0107c1e:	50                   	push   %eax
c0107c1f:	e8 30 fa ff ff       	call   c0107654 <get_pte>
c0107c24:	83 c4 10             	add    $0x10,%esp
c0107c27:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107c2a:	74 19                	je     c0107c45 <check_pgdir+0x1de>
c0107c2c:	68 74 ba 10 c0       	push   $0xc010ba74
c0107c31:	68 05 b9 10 c0       	push   $0xc010b905
c0107c36:	68 31 02 00 00       	push   $0x231
c0107c3b:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107c40:	e8 b3 87 ff ff       	call   c01003f8 <__panic>

    p2 = alloc_page();
c0107c45:	83 ec 0c             	sub    $0xc,%esp
c0107c48:	6a 01                	push   $0x1
c0107c4a:	e8 99 f3 ff ff       	call   c0106fe8 <alloc_pages>
c0107c4f:	83 c4 10             	add    $0x10,%esp
c0107c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107c55:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107c5a:	6a 06                	push   $0x6
c0107c5c:	68 00 10 00 00       	push   $0x1000
c0107c61:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107c64:	50                   	push   %eax
c0107c65:	e8 29 fc ff ff       	call   c0107893 <page_insert>
c0107c6a:	83 c4 10             	add    $0x10,%esp
c0107c6d:	85 c0                	test   %eax,%eax
c0107c6f:	74 19                	je     c0107c8a <check_pgdir+0x223>
c0107c71:	68 9c ba 10 c0       	push   $0xc010ba9c
c0107c76:	68 05 b9 10 c0       	push   $0xc010b905
c0107c7b:	68 34 02 00 00       	push   $0x234
c0107c80:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107c85:	e8 6e 87 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107c8a:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107c8f:	83 ec 04             	sub    $0x4,%esp
c0107c92:	6a 00                	push   $0x0
c0107c94:	68 00 10 00 00       	push   $0x1000
c0107c99:	50                   	push   %eax
c0107c9a:	e8 b5 f9 ff ff       	call   c0107654 <get_pte>
c0107c9f:	83 c4 10             	add    $0x10,%esp
c0107ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107ca5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ca9:	75 19                	jne    c0107cc4 <check_pgdir+0x25d>
c0107cab:	68 d4 ba 10 c0       	push   $0xc010bad4
c0107cb0:	68 05 b9 10 c0       	push   $0xc010b905
c0107cb5:	68 35 02 00 00       	push   $0x235
c0107cba:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107cbf:	e8 34 87 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_U);
c0107cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cc7:	8b 00                	mov    (%eax),%eax
c0107cc9:	83 e0 04             	and    $0x4,%eax
c0107ccc:	85 c0                	test   %eax,%eax
c0107cce:	75 19                	jne    c0107ce9 <check_pgdir+0x282>
c0107cd0:	68 04 bb 10 c0       	push   $0xc010bb04
c0107cd5:	68 05 b9 10 c0       	push   $0xc010b905
c0107cda:	68 36 02 00 00       	push   $0x236
c0107cdf:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107ce4:	e8 0f 87 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_W);
c0107ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cec:	8b 00                	mov    (%eax),%eax
c0107cee:	83 e0 02             	and    $0x2,%eax
c0107cf1:	85 c0                	test   %eax,%eax
c0107cf3:	75 19                	jne    c0107d0e <check_pgdir+0x2a7>
c0107cf5:	68 12 bb 10 c0       	push   $0xc010bb12
c0107cfa:	68 05 b9 10 c0       	push   $0xc010b905
c0107cff:	68 37 02 00 00       	push   $0x237
c0107d04:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107d09:	e8 ea 86 ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0107d0e:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107d13:	8b 00                	mov    (%eax),%eax
c0107d15:	83 e0 04             	and    $0x4,%eax
c0107d18:	85 c0                	test   %eax,%eax
c0107d1a:	75 19                	jne    c0107d35 <check_pgdir+0x2ce>
c0107d1c:	68 20 bb 10 c0       	push   $0xc010bb20
c0107d21:	68 05 b9 10 c0       	push   $0xc010b905
c0107d26:	68 38 02 00 00       	push   $0x238
c0107d2b:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107d30:	e8 c3 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 1);
c0107d35:	83 ec 0c             	sub    $0xc,%esp
c0107d38:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107d3b:	e8 9a f0 ff ff       	call   c0106dda <page_ref>
c0107d40:	83 c4 10             	add    $0x10,%esp
c0107d43:	83 f8 01             	cmp    $0x1,%eax
c0107d46:	74 19                	je     c0107d61 <check_pgdir+0x2fa>
c0107d48:	68 36 bb 10 c0       	push   $0xc010bb36
c0107d4d:	68 05 b9 10 c0       	push   $0xc010b905
c0107d52:	68 39 02 00 00       	push   $0x239
c0107d57:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107d5c:	e8 97 86 ff ff       	call   c01003f8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107d61:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107d66:	6a 00                	push   $0x0
c0107d68:	68 00 10 00 00       	push   $0x1000
c0107d6d:	ff 75 f4             	pushl  -0xc(%ebp)
c0107d70:	50                   	push   %eax
c0107d71:	e8 1d fb ff ff       	call   c0107893 <page_insert>
c0107d76:	83 c4 10             	add    $0x10,%esp
c0107d79:	85 c0                	test   %eax,%eax
c0107d7b:	74 19                	je     c0107d96 <check_pgdir+0x32f>
c0107d7d:	68 48 bb 10 c0       	push   $0xc010bb48
c0107d82:	68 05 b9 10 c0       	push   $0xc010b905
c0107d87:	68 3b 02 00 00       	push   $0x23b
c0107d8c:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107d91:	e8 62 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 2);
c0107d96:	83 ec 0c             	sub    $0xc,%esp
c0107d99:	ff 75 f4             	pushl  -0xc(%ebp)
c0107d9c:	e8 39 f0 ff ff       	call   c0106dda <page_ref>
c0107da1:	83 c4 10             	add    $0x10,%esp
c0107da4:	83 f8 02             	cmp    $0x2,%eax
c0107da7:	74 19                	je     c0107dc2 <check_pgdir+0x35b>
c0107da9:	68 74 bb 10 c0       	push   $0xc010bb74
c0107dae:	68 05 b9 10 c0       	push   $0xc010b905
c0107db3:	68 3c 02 00 00       	push   $0x23c
c0107db8:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107dbd:	e8 36 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107dc2:	83 ec 0c             	sub    $0xc,%esp
c0107dc5:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107dc8:	e8 0d f0 ff ff       	call   c0106dda <page_ref>
c0107dcd:	83 c4 10             	add    $0x10,%esp
c0107dd0:	85 c0                	test   %eax,%eax
c0107dd2:	74 19                	je     c0107ded <check_pgdir+0x386>
c0107dd4:	68 86 bb 10 c0       	push   $0xc010bb86
c0107dd9:	68 05 b9 10 c0       	push   $0xc010b905
c0107dde:	68 3d 02 00 00       	push   $0x23d
c0107de3:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107de8:	e8 0b 86 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107ded:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107df2:	83 ec 04             	sub    $0x4,%esp
c0107df5:	6a 00                	push   $0x0
c0107df7:	68 00 10 00 00       	push   $0x1000
c0107dfc:	50                   	push   %eax
c0107dfd:	e8 52 f8 ff ff       	call   c0107654 <get_pte>
c0107e02:	83 c4 10             	add    $0x10,%esp
c0107e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107e08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107e0c:	75 19                	jne    c0107e27 <check_pgdir+0x3c0>
c0107e0e:	68 d4 ba 10 c0       	push   $0xc010bad4
c0107e13:	68 05 b9 10 c0       	push   $0xc010b905
c0107e18:	68 3e 02 00 00       	push   $0x23e
c0107e1d:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107e22:	e8 d1 85 ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c0107e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e2a:	8b 00                	mov    (%eax),%eax
c0107e2c:	83 ec 0c             	sub    $0xc,%esp
c0107e2f:	50                   	push   %eax
c0107e30:	e8 4f ef ff ff       	call   c0106d84 <pte2page>
c0107e35:	83 c4 10             	add    $0x10,%esp
c0107e38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107e3b:	74 19                	je     c0107e56 <check_pgdir+0x3ef>
c0107e3d:	68 49 ba 10 c0       	push   $0xc010ba49
c0107e42:	68 05 b9 10 c0       	push   $0xc010b905
c0107e47:	68 3f 02 00 00       	push   $0x23f
c0107e4c:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107e51:	e8 a2 85 ff ff       	call   c01003f8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e59:	8b 00                	mov    (%eax),%eax
c0107e5b:	83 e0 04             	and    $0x4,%eax
c0107e5e:	85 c0                	test   %eax,%eax
c0107e60:	74 19                	je     c0107e7b <check_pgdir+0x414>
c0107e62:	68 98 bb 10 c0       	push   $0xc010bb98
c0107e67:	68 05 b9 10 c0       	push   $0xc010b905
c0107e6c:	68 40 02 00 00       	push   $0x240
c0107e71:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107e76:	e8 7d 85 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0107e7b:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107e80:	83 ec 08             	sub    $0x8,%esp
c0107e83:	6a 00                	push   $0x0
c0107e85:	50                   	push   %eax
c0107e86:	e8 cf f9 ff ff       	call   c010785a <page_remove>
c0107e8b:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0107e8e:	83 ec 0c             	sub    $0xc,%esp
c0107e91:	ff 75 f4             	pushl  -0xc(%ebp)
c0107e94:	e8 41 ef ff ff       	call   c0106dda <page_ref>
c0107e99:	83 c4 10             	add    $0x10,%esp
c0107e9c:	83 f8 01             	cmp    $0x1,%eax
c0107e9f:	74 19                	je     c0107eba <check_pgdir+0x453>
c0107ea1:	68 5f ba 10 c0       	push   $0xc010ba5f
c0107ea6:	68 05 b9 10 c0       	push   $0xc010b905
c0107eab:	68 43 02 00 00       	push   $0x243
c0107eb0:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107eb5:	e8 3e 85 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107eba:	83 ec 0c             	sub    $0xc,%esp
c0107ebd:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107ec0:	e8 15 ef ff ff       	call   c0106dda <page_ref>
c0107ec5:	83 c4 10             	add    $0x10,%esp
c0107ec8:	85 c0                	test   %eax,%eax
c0107eca:	74 19                	je     c0107ee5 <check_pgdir+0x47e>
c0107ecc:	68 86 bb 10 c0       	push   $0xc010bb86
c0107ed1:	68 05 b9 10 c0       	push   $0xc010b905
c0107ed6:	68 44 02 00 00       	push   $0x244
c0107edb:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107ee0:	e8 13 85 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107ee5:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107eea:	83 ec 08             	sub    $0x8,%esp
c0107eed:	68 00 10 00 00       	push   $0x1000
c0107ef2:	50                   	push   %eax
c0107ef3:	e8 62 f9 ff ff       	call   c010785a <page_remove>
c0107ef8:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0107efb:	83 ec 0c             	sub    $0xc,%esp
c0107efe:	ff 75 f4             	pushl  -0xc(%ebp)
c0107f01:	e8 d4 ee ff ff       	call   c0106dda <page_ref>
c0107f06:	83 c4 10             	add    $0x10,%esp
c0107f09:	85 c0                	test   %eax,%eax
c0107f0b:	74 19                	je     c0107f26 <check_pgdir+0x4bf>
c0107f0d:	68 ad bb 10 c0       	push   $0xc010bbad
c0107f12:	68 05 b9 10 c0       	push   $0xc010b905
c0107f17:	68 47 02 00 00       	push   $0x247
c0107f1c:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107f21:	e8 d2 84 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107f26:	83 ec 0c             	sub    $0xc,%esp
c0107f29:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107f2c:	e8 a9 ee ff ff       	call   c0106dda <page_ref>
c0107f31:	83 c4 10             	add    $0x10,%esp
c0107f34:	85 c0                	test   %eax,%eax
c0107f36:	74 19                	je     c0107f51 <check_pgdir+0x4ea>
c0107f38:	68 86 bb 10 c0       	push   $0xc010bb86
c0107f3d:	68 05 b9 10 c0       	push   $0xc010b905
c0107f42:	68 48 02 00 00       	push   $0x248
c0107f47:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107f4c:	e8 a7 84 ff ff       	call   c01003f8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107f51:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107f56:	8b 00                	mov    (%eax),%eax
c0107f58:	83 ec 0c             	sub    $0xc,%esp
c0107f5b:	50                   	push   %eax
c0107f5c:	e8 5d ee ff ff       	call   c0106dbe <pde2page>
c0107f61:	83 c4 10             	add    $0x10,%esp
c0107f64:	83 ec 0c             	sub    $0xc,%esp
c0107f67:	50                   	push   %eax
c0107f68:	e8 6d ee ff ff       	call   c0106dda <page_ref>
c0107f6d:	83 c4 10             	add    $0x10,%esp
c0107f70:	83 f8 01             	cmp    $0x1,%eax
c0107f73:	74 19                	je     c0107f8e <check_pgdir+0x527>
c0107f75:	68 c0 bb 10 c0       	push   $0xc010bbc0
c0107f7a:	68 05 b9 10 c0       	push   $0xc010b905
c0107f7f:	68 4a 02 00 00       	push   $0x24a
c0107f84:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0107f89:	e8 6a 84 ff ff       	call   c01003f8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0107f8e:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107f93:	8b 00                	mov    (%eax),%eax
c0107f95:	83 ec 0c             	sub    $0xc,%esp
c0107f98:	50                   	push   %eax
c0107f99:	e8 20 ee ff ff       	call   c0106dbe <pde2page>
c0107f9e:	83 c4 10             	add    $0x10,%esp
c0107fa1:	83 ec 08             	sub    $0x8,%esp
c0107fa4:	6a 01                	push   $0x1
c0107fa6:	50                   	push   %eax
c0107fa7:	e8 a8 f0 ff ff       	call   c0107054 <free_pages>
c0107fac:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0107faf:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0107fba:	83 ec 0c             	sub    $0xc,%esp
c0107fbd:	68 e7 bb 10 c0       	push   $0xc010bbe7
c0107fc2:	e8 cb 82 ff ff       	call   c0100292 <cprintf>
c0107fc7:	83 c4 10             	add    $0x10,%esp
}
c0107fca:	90                   	nop
c0107fcb:	c9                   	leave  
c0107fcc:	c3                   	ret    

c0107fcd <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0107fcd:	55                   	push   %ebp
c0107fce:	89 e5                	mov    %esp,%ebp
c0107fd0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107fd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107fda:	e9 a3 00 00 00       	jmp    c0108082 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107fe8:	c1 e8 0c             	shr    $0xc,%eax
c0107feb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107fee:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107ff3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107ff6:	72 17                	jb     c010800f <check_boot_pgdir+0x42>
c0107ff8:	ff 75 f0             	pushl  -0x10(%ebp)
c0107ffb:	68 18 b8 10 c0       	push   $0xc010b818
c0108000:	68 56 02 00 00       	push   $0x256
c0108005:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010800a:	e8 e9 83 ff ff       	call   c01003f8 <__panic>
c010800f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108012:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0108017:	89 c2                	mov    %eax,%edx
c0108019:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010801e:	83 ec 04             	sub    $0x4,%esp
c0108021:	6a 00                	push   $0x0
c0108023:	52                   	push   %edx
c0108024:	50                   	push   %eax
c0108025:	e8 2a f6 ff ff       	call   c0107654 <get_pte>
c010802a:	83 c4 10             	add    $0x10,%esp
c010802d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108030:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108034:	75 19                	jne    c010804f <check_boot_pgdir+0x82>
c0108036:	68 04 bc 10 c0       	push   $0xc010bc04
c010803b:	68 05 b9 10 c0       	push   $0xc010b905
c0108040:	68 56 02 00 00       	push   $0x256
c0108045:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010804a:	e8 a9 83 ff ff       	call   c01003f8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010804f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108052:	8b 00                	mov    (%eax),%eax
c0108054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108059:	89 c2                	mov    %eax,%edx
c010805b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010805e:	39 c2                	cmp    %eax,%edx
c0108060:	74 19                	je     c010807b <check_boot_pgdir+0xae>
c0108062:	68 41 bc 10 c0       	push   $0xc010bc41
c0108067:	68 05 b9 10 c0       	push   $0xc010b905
c010806c:	68 57 02 00 00       	push   $0x257
c0108071:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0108076:	e8 7d 83 ff ff       	call   c01003f8 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010807b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0108082:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108085:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010808a:	39 c2                	cmp    %eax,%edx
c010808c:	0f 82 4d ff ff ff    	jb     c0107fdf <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0108092:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0108097:	05 ac 0f 00 00       	add    $0xfac,%eax
c010809c:	8b 00                	mov    (%eax),%eax
c010809e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01080a3:	89 c2                	mov    %eax,%edx
c01080a5:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01080aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01080ad:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01080b4:	77 17                	ja     c01080cd <check_boot_pgdir+0x100>
c01080b6:	ff 75 e4             	pushl  -0x1c(%ebp)
c01080b9:	68 bc b8 10 c0       	push   $0xc010b8bc
c01080be:	68 5a 02 00 00       	push   $0x25a
c01080c3:	68 e0 b8 10 c0       	push   $0xc010b8e0
c01080c8:	e8 2b 83 ff ff       	call   c01003f8 <__panic>
c01080cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080d0:	05 00 00 00 40       	add    $0x40000000,%eax
c01080d5:	39 c2                	cmp    %eax,%edx
c01080d7:	74 19                	je     c01080f2 <check_boot_pgdir+0x125>
c01080d9:	68 58 bc 10 c0       	push   $0xc010bc58
c01080de:	68 05 b9 10 c0       	push   $0xc010b905
c01080e3:	68 5a 02 00 00       	push   $0x25a
c01080e8:	68 e0 b8 10 c0       	push   $0xc010b8e0
c01080ed:	e8 06 83 ff ff       	call   c01003f8 <__panic>

    assert(boot_pgdir[0] == 0);
c01080f2:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01080f7:	8b 00                	mov    (%eax),%eax
c01080f9:	85 c0                	test   %eax,%eax
c01080fb:	74 19                	je     c0108116 <check_boot_pgdir+0x149>
c01080fd:	68 8c bc 10 c0       	push   $0xc010bc8c
c0108102:	68 05 b9 10 c0       	push   $0xc010b905
c0108107:	68 5c 02 00 00       	push   $0x25c
c010810c:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0108111:	e8 e2 82 ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    p = alloc_page();
c0108116:	83 ec 0c             	sub    $0xc,%esp
c0108119:	6a 01                	push   $0x1
c010811b:	e8 c8 ee ff ff       	call   c0106fe8 <alloc_pages>
c0108120:	83 c4 10             	add    $0x10,%esp
c0108123:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0108126:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010812b:	6a 02                	push   $0x2
c010812d:	68 00 01 00 00       	push   $0x100
c0108132:	ff 75 e0             	pushl  -0x20(%ebp)
c0108135:	50                   	push   %eax
c0108136:	e8 58 f7 ff ff       	call   c0107893 <page_insert>
c010813b:	83 c4 10             	add    $0x10,%esp
c010813e:	85 c0                	test   %eax,%eax
c0108140:	74 19                	je     c010815b <check_boot_pgdir+0x18e>
c0108142:	68 a0 bc 10 c0       	push   $0xc010bca0
c0108147:	68 05 b9 10 c0       	push   $0xc010b905
c010814c:	68 60 02 00 00       	push   $0x260
c0108151:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0108156:	e8 9d 82 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 1);
c010815b:	83 ec 0c             	sub    $0xc,%esp
c010815e:	ff 75 e0             	pushl  -0x20(%ebp)
c0108161:	e8 74 ec ff ff       	call   c0106dda <page_ref>
c0108166:	83 c4 10             	add    $0x10,%esp
c0108169:	83 f8 01             	cmp    $0x1,%eax
c010816c:	74 19                	je     c0108187 <check_boot_pgdir+0x1ba>
c010816e:	68 ce bc 10 c0       	push   $0xc010bcce
c0108173:	68 05 b9 10 c0       	push   $0xc010b905
c0108178:	68 61 02 00 00       	push   $0x261
c010817d:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0108182:	e8 71 82 ff ff       	call   c01003f8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0108187:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010818c:	6a 02                	push   $0x2
c010818e:	68 00 11 00 00       	push   $0x1100
c0108193:	ff 75 e0             	pushl  -0x20(%ebp)
c0108196:	50                   	push   %eax
c0108197:	e8 f7 f6 ff ff       	call   c0107893 <page_insert>
c010819c:	83 c4 10             	add    $0x10,%esp
c010819f:	85 c0                	test   %eax,%eax
c01081a1:	74 19                	je     c01081bc <check_boot_pgdir+0x1ef>
c01081a3:	68 e0 bc 10 c0       	push   $0xc010bce0
c01081a8:	68 05 b9 10 c0       	push   $0xc010b905
c01081ad:	68 62 02 00 00       	push   $0x262
c01081b2:	68 e0 b8 10 c0       	push   $0xc010b8e0
c01081b7:	e8 3c 82 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 2);
c01081bc:	83 ec 0c             	sub    $0xc,%esp
c01081bf:	ff 75 e0             	pushl  -0x20(%ebp)
c01081c2:	e8 13 ec ff ff       	call   c0106dda <page_ref>
c01081c7:	83 c4 10             	add    $0x10,%esp
c01081ca:	83 f8 02             	cmp    $0x2,%eax
c01081cd:	74 19                	je     c01081e8 <check_boot_pgdir+0x21b>
c01081cf:	68 17 bd 10 c0       	push   $0xc010bd17
c01081d4:	68 05 b9 10 c0       	push   $0xc010b905
c01081d9:	68 63 02 00 00       	push   $0x263
c01081de:	68 e0 b8 10 c0       	push   $0xc010b8e0
c01081e3:	e8 10 82 ff ff       	call   c01003f8 <__panic>

    const char *str = "ucore: Hello world!!";
c01081e8:	c7 45 dc 28 bd 10 c0 	movl   $0xc010bd28,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01081ef:	83 ec 08             	sub    $0x8,%esp
c01081f2:	ff 75 dc             	pushl  -0x24(%ebp)
c01081f5:	68 00 01 00 00       	push   $0x100
c01081fa:	e8 4c 10 00 00       	call   c010924b <strcpy>
c01081ff:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0108202:	83 ec 08             	sub    $0x8,%esp
c0108205:	68 00 11 00 00       	push   $0x1100
c010820a:	68 00 01 00 00       	push   $0x100
c010820f:	e8 b1 10 00 00       	call   c01092c5 <strcmp>
c0108214:	83 c4 10             	add    $0x10,%esp
c0108217:	85 c0                	test   %eax,%eax
c0108219:	74 19                	je     c0108234 <check_boot_pgdir+0x267>
c010821b:	68 40 bd 10 c0       	push   $0xc010bd40
c0108220:	68 05 b9 10 c0       	push   $0xc010b905
c0108225:	68 67 02 00 00       	push   $0x267
c010822a:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010822f:	e8 c4 81 ff ff       	call   c01003f8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0108234:	83 ec 0c             	sub    $0xc,%esp
c0108237:	ff 75 e0             	pushl  -0x20(%ebp)
c010823a:	e8 00 eb ff ff       	call   c0106d3f <page2kva>
c010823f:	83 c4 10             	add    $0x10,%esp
c0108242:	05 00 01 00 00       	add    $0x100,%eax
c0108247:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010824a:	83 ec 0c             	sub    $0xc,%esp
c010824d:	68 00 01 00 00       	push   $0x100
c0108252:	e8 9c 0f 00 00       	call   c01091f3 <strlen>
c0108257:	83 c4 10             	add    $0x10,%esp
c010825a:	85 c0                	test   %eax,%eax
c010825c:	74 19                	je     c0108277 <check_boot_pgdir+0x2aa>
c010825e:	68 78 bd 10 c0       	push   $0xc010bd78
c0108263:	68 05 b9 10 c0       	push   $0xc010b905
c0108268:	68 6a 02 00 00       	push   $0x26a
c010826d:	68 e0 b8 10 c0       	push   $0xc010b8e0
c0108272:	e8 81 81 ff ff       	call   c01003f8 <__panic>

    free_page(p);
c0108277:	83 ec 08             	sub    $0x8,%esp
c010827a:	6a 01                	push   $0x1
c010827c:	ff 75 e0             	pushl  -0x20(%ebp)
c010827f:	e8 d0 ed ff ff       	call   c0107054 <free_pages>
c0108284:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0108287:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010828c:	8b 00                	mov    (%eax),%eax
c010828e:	83 ec 0c             	sub    $0xc,%esp
c0108291:	50                   	push   %eax
c0108292:	e8 27 eb ff ff       	call   c0106dbe <pde2page>
c0108297:	83 c4 10             	add    $0x10,%esp
c010829a:	83 ec 08             	sub    $0x8,%esp
c010829d:	6a 01                	push   $0x1
c010829f:	50                   	push   %eax
c01082a0:	e8 af ed ff ff       	call   c0107054 <free_pages>
c01082a5:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01082a8:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01082ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01082b3:	83 ec 0c             	sub    $0xc,%esp
c01082b6:	68 9c bd 10 c0       	push   $0xc010bd9c
c01082bb:	e8 d2 7f ff ff       	call   c0100292 <cprintf>
c01082c0:	83 c4 10             	add    $0x10,%esp
}
c01082c3:	90                   	nop
c01082c4:	c9                   	leave  
c01082c5:	c3                   	ret    

c01082c6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01082c6:	55                   	push   %ebp
c01082c7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01082c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082cc:	83 e0 04             	and    $0x4,%eax
c01082cf:	85 c0                	test   %eax,%eax
c01082d1:	74 07                	je     c01082da <perm2str+0x14>
c01082d3:	b8 75 00 00 00       	mov    $0x75,%eax
c01082d8:	eb 05                	jmp    c01082df <perm2str+0x19>
c01082da:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01082df:	a2 08 a0 12 c0       	mov    %al,0xc012a008
    str[1] = 'r';
c01082e4:	c6 05 09 a0 12 c0 72 	movb   $0x72,0xc012a009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01082eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01082ee:	83 e0 02             	and    $0x2,%eax
c01082f1:	85 c0                	test   %eax,%eax
c01082f3:	74 07                	je     c01082fc <perm2str+0x36>
c01082f5:	b8 77 00 00 00       	mov    $0x77,%eax
c01082fa:	eb 05                	jmp    c0108301 <perm2str+0x3b>
c01082fc:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0108301:	a2 0a a0 12 c0       	mov    %al,0xc012a00a
    str[3] = '\0';
c0108306:	c6 05 0b a0 12 c0 00 	movb   $0x0,0xc012a00b
    return str;
c010830d:	b8 08 a0 12 c0       	mov    $0xc012a008,%eax
}
c0108312:	5d                   	pop    %ebp
c0108313:	c3                   	ret    

c0108314 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0108314:	55                   	push   %ebp
c0108315:	89 e5                	mov    %esp,%ebp
c0108317:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010831a:	8b 45 10             	mov    0x10(%ebp),%eax
c010831d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108320:	72 0e                	jb     c0108330 <get_pgtable_items+0x1c>
        return 0;
c0108322:	b8 00 00 00 00       	mov    $0x0,%eax
c0108327:	e9 9a 00 00 00       	jmp    c01083c6 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010832c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0108330:	8b 45 10             	mov    0x10(%ebp),%eax
c0108333:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108336:	73 18                	jae    c0108350 <get_pgtable_items+0x3c>
c0108338:	8b 45 10             	mov    0x10(%ebp),%eax
c010833b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108342:	8b 45 14             	mov    0x14(%ebp),%eax
c0108345:	01 d0                	add    %edx,%eax
c0108347:	8b 00                	mov    (%eax),%eax
c0108349:	83 e0 01             	and    $0x1,%eax
c010834c:	85 c0                	test   %eax,%eax
c010834e:	74 dc                	je     c010832c <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0108350:	8b 45 10             	mov    0x10(%ebp),%eax
c0108353:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108356:	73 69                	jae    c01083c1 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0108358:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010835c:	74 08                	je     c0108366 <get_pgtable_items+0x52>
            *left_store = start;
c010835e:	8b 45 18             	mov    0x18(%ebp),%eax
c0108361:	8b 55 10             	mov    0x10(%ebp),%edx
c0108364:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0108366:	8b 45 10             	mov    0x10(%ebp),%eax
c0108369:	8d 50 01             	lea    0x1(%eax),%edx
c010836c:	89 55 10             	mov    %edx,0x10(%ebp)
c010836f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108376:	8b 45 14             	mov    0x14(%ebp),%eax
c0108379:	01 d0                	add    %edx,%eax
c010837b:	8b 00                	mov    (%eax),%eax
c010837d:	83 e0 07             	and    $0x7,%eax
c0108380:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108383:	eb 04                	jmp    c0108389 <get_pgtable_items+0x75>
            start ++;
c0108385:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108389:	8b 45 10             	mov    0x10(%ebp),%eax
c010838c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010838f:	73 1d                	jae    c01083ae <get_pgtable_items+0x9a>
c0108391:	8b 45 10             	mov    0x10(%ebp),%eax
c0108394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010839b:	8b 45 14             	mov    0x14(%ebp),%eax
c010839e:	01 d0                	add    %edx,%eax
c01083a0:	8b 00                	mov    (%eax),%eax
c01083a2:	83 e0 07             	and    $0x7,%eax
c01083a5:	89 c2                	mov    %eax,%edx
c01083a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01083aa:	39 c2                	cmp    %eax,%edx
c01083ac:	74 d7                	je     c0108385 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c01083ae:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01083b2:	74 08                	je     c01083bc <get_pgtable_items+0xa8>
            *right_store = start;
c01083b4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01083b7:	8b 55 10             	mov    0x10(%ebp),%edx
c01083ba:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01083bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01083bf:	eb 05                	jmp    c01083c6 <get_pgtable_items+0xb2>
    }
    return 0;
c01083c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01083c6:	c9                   	leave  
c01083c7:	c3                   	ret    

c01083c8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01083c8:	55                   	push   %ebp
c01083c9:	89 e5                	mov    %esp,%ebp
c01083cb:	57                   	push   %edi
c01083cc:	56                   	push   %esi
c01083cd:	53                   	push   %ebx
c01083ce:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01083d1:	83 ec 0c             	sub    $0xc,%esp
c01083d4:	68 bc bd 10 c0       	push   $0xc010bdbc
c01083d9:	e8 b4 7e ff ff       	call   c0100292 <cprintf>
c01083de:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c01083e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01083e8:	e9 e5 00 00 00       	jmp    c01084d2 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01083ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083f0:	83 ec 0c             	sub    $0xc,%esp
c01083f3:	50                   	push   %eax
c01083f4:	e8 cd fe ff ff       	call   c01082c6 <perm2str>
c01083f9:	83 c4 10             	add    $0x10,%esp
c01083fc:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01083fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108401:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108404:	29 c2                	sub    %eax,%edx
c0108406:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0108408:	c1 e0 16             	shl    $0x16,%eax
c010840b:	89 c3                	mov    %eax,%ebx
c010840d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108410:	c1 e0 16             	shl    $0x16,%eax
c0108413:	89 c1                	mov    %eax,%ecx
c0108415:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108418:	c1 e0 16             	shl    $0x16,%eax
c010841b:	89 c2                	mov    %eax,%edx
c010841d:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0108420:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108423:	29 c6                	sub    %eax,%esi
c0108425:	89 f0                	mov    %esi,%eax
c0108427:	83 ec 08             	sub    $0x8,%esp
c010842a:	57                   	push   %edi
c010842b:	53                   	push   %ebx
c010842c:	51                   	push   %ecx
c010842d:	52                   	push   %edx
c010842e:	50                   	push   %eax
c010842f:	68 ed bd 10 c0       	push   $0xc010bded
c0108434:	e8 59 7e ff ff       	call   c0100292 <cprintf>
c0108439:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010843c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010843f:	c1 e0 0a             	shl    $0xa,%eax
c0108442:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108445:	eb 4f                	jmp    c0108496 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0108447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010844a:	83 ec 0c             	sub    $0xc,%esp
c010844d:	50                   	push   %eax
c010844e:	e8 73 fe ff ff       	call   c01082c6 <perm2str>
c0108453:	83 c4 10             	add    $0x10,%esp
c0108456:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0108458:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010845b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010845e:	29 c2                	sub    %eax,%edx
c0108460:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0108462:	c1 e0 0c             	shl    $0xc,%eax
c0108465:	89 c3                	mov    %eax,%ebx
c0108467:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010846a:	c1 e0 0c             	shl    $0xc,%eax
c010846d:	89 c1                	mov    %eax,%ecx
c010846f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108472:	c1 e0 0c             	shl    $0xc,%eax
c0108475:	89 c2                	mov    %eax,%edx
c0108477:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c010847a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010847d:	29 c6                	sub    %eax,%esi
c010847f:	89 f0                	mov    %esi,%eax
c0108481:	83 ec 08             	sub    $0x8,%esp
c0108484:	57                   	push   %edi
c0108485:	53                   	push   %ebx
c0108486:	51                   	push   %ecx
c0108487:	52                   	push   %edx
c0108488:	50                   	push   %eax
c0108489:	68 0c be 10 c0       	push   $0xc010be0c
c010848e:	e8 ff 7d ff ff       	call   c0100292 <cprintf>
c0108493:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108496:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010849b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010849e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01084a1:	89 d3                	mov    %edx,%ebx
c01084a3:	c1 e3 0a             	shl    $0xa,%ebx
c01084a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01084a9:	89 d1                	mov    %edx,%ecx
c01084ab:	c1 e1 0a             	shl    $0xa,%ecx
c01084ae:	83 ec 08             	sub    $0x8,%esp
c01084b1:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01084b4:	52                   	push   %edx
c01084b5:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01084b8:	52                   	push   %edx
c01084b9:	56                   	push   %esi
c01084ba:	50                   	push   %eax
c01084bb:	53                   	push   %ebx
c01084bc:	51                   	push   %ecx
c01084bd:	e8 52 fe ff ff       	call   c0108314 <get_pgtable_items>
c01084c2:	83 c4 20             	add    $0x20,%esp
c01084c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01084c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084cc:	0f 85 75 ff ff ff    	jne    c0108447 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01084d2:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01084d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084da:	83 ec 08             	sub    $0x8,%esp
c01084dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01084e0:	52                   	push   %edx
c01084e1:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01084e4:	52                   	push   %edx
c01084e5:	51                   	push   %ecx
c01084e6:	50                   	push   %eax
c01084e7:	68 00 04 00 00       	push   $0x400
c01084ec:	6a 00                	push   $0x0
c01084ee:	e8 21 fe ff ff       	call   c0108314 <get_pgtable_items>
c01084f3:	83 c4 20             	add    $0x20,%esp
c01084f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01084f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084fd:	0f 85 ea fe ff ff    	jne    c01083ed <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0108503:	83 ec 0c             	sub    $0xc,%esp
c0108506:	68 30 be 10 c0       	push   $0xc010be30
c010850b:	e8 82 7d ff ff       	call   c0100292 <cprintf>
c0108510:	83 c4 10             	add    $0x10,%esp
}
c0108513:	90                   	nop
c0108514:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0108517:	5b                   	pop    %ebx
c0108518:	5e                   	pop    %esi
c0108519:	5f                   	pop    %edi
c010851a:	5d                   	pop    %ebp
c010851b:	c3                   	ret    

c010851c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010851c:	55                   	push   %ebp
c010851d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010851f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108522:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0108528:	29 d0                	sub    %edx,%eax
c010852a:	c1 f8 05             	sar    $0x5,%eax
}
c010852d:	5d                   	pop    %ebp
c010852e:	c3                   	ret    

c010852f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010852f:	55                   	push   %ebp
c0108530:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0108532:	ff 75 08             	pushl  0x8(%ebp)
c0108535:	e8 e2 ff ff ff       	call   c010851c <page2ppn>
c010853a:	83 c4 04             	add    $0x4,%esp
c010853d:	c1 e0 0c             	shl    $0xc,%eax
}
c0108540:	c9                   	leave  
c0108541:	c3                   	ret    

c0108542 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108542:	55                   	push   %ebp
c0108543:	89 e5                	mov    %esp,%ebp
c0108545:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0108548:	ff 75 08             	pushl  0x8(%ebp)
c010854b:	e8 df ff ff ff       	call   c010852f <page2pa>
c0108550:	83 c4 04             	add    $0x4,%esp
c0108553:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108556:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108559:	c1 e8 0c             	shr    $0xc,%eax
c010855c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010855f:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0108564:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108567:	72 14                	jb     c010857d <page2kva+0x3b>
c0108569:	ff 75 f4             	pushl  -0xc(%ebp)
c010856c:	68 64 be 10 c0       	push   $0xc010be64
c0108571:	6a 66                	push   $0x66
c0108573:	68 87 be 10 c0       	push   $0xc010be87
c0108578:	e8 7b 7e ff ff       	call   c01003f8 <__panic>
c010857d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108580:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108585:	c9                   	leave  
c0108586:	c3                   	ret    

c0108587 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108587:	55                   	push   %ebp
c0108588:	89 e5                	mov    %esp,%ebp
c010858a:	83 ec 08             	sub    $0x8,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010858d:	83 ec 0c             	sub    $0xc,%esp
c0108590:	6a 01                	push   $0x1
c0108592:	e8 66 8b ff ff       	call   c01010fd <ide_device_valid>
c0108597:	83 c4 10             	add    $0x10,%esp
c010859a:	85 c0                	test   %eax,%eax
c010859c:	75 14                	jne    c01085b2 <swapfs_init+0x2b>
        panic("swap fs isn't available.\n");
c010859e:	83 ec 04             	sub    $0x4,%esp
c01085a1:	68 95 be 10 c0       	push   $0xc010be95
c01085a6:	6a 0d                	push   $0xd
c01085a8:	68 af be 10 c0       	push   $0xc010beaf
c01085ad:	e8 46 7e ff ff       	call   c01003f8 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01085b2:	83 ec 0c             	sub    $0xc,%esp
c01085b5:	6a 01                	push   $0x1
c01085b7:	e8 81 8b ff ff       	call   c010113d <ide_device_size>
c01085bc:	83 c4 10             	add    $0x10,%esp
c01085bf:	c1 e8 03             	shr    $0x3,%eax
c01085c2:	a3 5c c1 12 c0       	mov    %eax,0xc012c15c
}
c01085c7:	90                   	nop
c01085c8:	c9                   	leave  
c01085c9:	c3                   	ret    

c01085ca <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01085ca:	55                   	push   %ebp
c01085cb:	89 e5                	mov    %esp,%ebp
c01085cd:	83 ec 18             	sub    $0x18,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01085d0:	83 ec 0c             	sub    $0xc,%esp
c01085d3:	ff 75 0c             	pushl  0xc(%ebp)
c01085d6:	e8 67 ff ff ff       	call   c0108542 <page2kva>
c01085db:	83 c4 10             	add    $0x10,%esp
c01085de:	89 c2                	mov    %eax,%edx
c01085e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01085e3:	c1 e8 08             	shr    $0x8,%eax
c01085e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01085ed:	74 0a                	je     c01085f9 <swapfs_read+0x2f>
c01085ef:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c01085f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01085f7:	72 14                	jb     c010860d <swapfs_read+0x43>
c01085f9:	ff 75 08             	pushl  0x8(%ebp)
c01085fc:	68 c0 be 10 c0       	push   $0xc010bec0
c0108601:	6a 14                	push   $0x14
c0108603:	68 af be 10 c0       	push   $0xc010beaf
c0108608:	e8 eb 7d ff ff       	call   c01003f8 <__panic>
c010860d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108610:	c1 e0 03             	shl    $0x3,%eax
c0108613:	6a 08                	push   $0x8
c0108615:	52                   	push   %edx
c0108616:	50                   	push   %eax
c0108617:	6a 01                	push   $0x1
c0108619:	e8 5f 8b ff ff       	call   c010117d <ide_read_secs>
c010861e:	83 c4 10             	add    $0x10,%esp
}
c0108621:	c9                   	leave  
c0108622:	c3                   	ret    

c0108623 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108623:	55                   	push   %ebp
c0108624:	89 e5                	mov    %esp,%ebp
c0108626:	83 ec 18             	sub    $0x18,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108629:	83 ec 0c             	sub    $0xc,%esp
c010862c:	ff 75 0c             	pushl  0xc(%ebp)
c010862f:	e8 0e ff ff ff       	call   c0108542 <page2kva>
c0108634:	83 c4 10             	add    $0x10,%esp
c0108637:	89 c2                	mov    %eax,%edx
c0108639:	8b 45 08             	mov    0x8(%ebp),%eax
c010863c:	c1 e8 08             	shr    $0x8,%eax
c010863f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108646:	74 0a                	je     c0108652 <swapfs_write+0x2f>
c0108648:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c010864d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0108650:	72 14                	jb     c0108666 <swapfs_write+0x43>
c0108652:	ff 75 08             	pushl  0x8(%ebp)
c0108655:	68 c0 be 10 c0       	push   $0xc010bec0
c010865a:	6a 19                	push   $0x19
c010865c:	68 af be 10 c0       	push   $0xc010beaf
c0108661:	e8 92 7d ff ff       	call   c01003f8 <__panic>
c0108666:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108669:	c1 e0 03             	shl    $0x3,%eax
c010866c:	6a 08                	push   $0x8
c010866e:	52                   	push   %edx
c010866f:	50                   	push   %eax
c0108670:	6a 01                	push   $0x1
c0108672:	e8 30 8d ff ff       	call   c01013a7 <ide_write_secs>
c0108677:	83 c4 10             	add    $0x10,%esp
}
c010867a:	c9                   	leave  
c010867b:	c3                   	ret    

c010867c <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c010867c:	52                   	push   %edx
    call *%ebx              # call fn
c010867d:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c010867f:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108680:	e8 f3 07 00 00       	call   c0108e78 <do_exit>

c0108685 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108685:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108689:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)          # save esp::context of from
c010868b:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)          # save ebx::context of from
c010868e:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)         # save ecx::context of from
c0108691:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)         # save edx::context of from
c0108694:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)         # save esi::context of from
c0108697:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)         # save edi::context of from
c010869a:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)         # save ebp::context of from
c010869d:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c01086a0:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp         # restore ebp::context of to
c01086a4:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi         # restore edi::context of to
c01086a7:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi         # restore esi::context of to
c01086aa:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx         # restore edx::context of to
c01086ad:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx         # restore ecx::context of to
c01086b0:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx          # restore ebx::context of to
c01086b3:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp          # restore esp::context of to
c01086b6:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c01086b9:	ff 30                	pushl  (%eax)

    ret
c01086bb:	c3                   	ret    

c01086bc <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01086bc:	55                   	push   %ebp
c01086bd:	89 e5                	mov    %esp,%ebp
c01086bf:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01086c2:	9c                   	pushf  
c01086c3:	58                   	pop    %eax
c01086c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01086c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01086ca:	25 00 02 00 00       	and    $0x200,%eax
c01086cf:	85 c0                	test   %eax,%eax
c01086d1:	74 0c                	je     c01086df <__intr_save+0x23>
        intr_disable();
c01086d3:	e8 08 9a ff ff       	call   c01020e0 <intr_disable>
        return 1;
c01086d8:	b8 01 00 00 00       	mov    $0x1,%eax
c01086dd:	eb 05                	jmp    c01086e4 <__intr_save+0x28>
    }
    return 0;
c01086df:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01086e4:	c9                   	leave  
c01086e5:	c3                   	ret    

c01086e6 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01086e6:	55                   	push   %ebp
c01086e7:	89 e5                	mov    %esp,%ebp
c01086e9:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01086ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01086f0:	74 05                	je     c01086f7 <__intr_restore+0x11>
        intr_enable();
c01086f2:	e8 e2 99 ff ff       	call   c01020d9 <intr_enable>
    }
}
c01086f7:	90                   	nop
c01086f8:	c9                   	leave  
c01086f9:	c3                   	ret    

c01086fa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01086fa:	55                   	push   %ebp
c01086fb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01086fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108700:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0108706:	29 d0                	sub    %edx,%eax
c0108708:	c1 f8 05             	sar    $0x5,%eax
}
c010870b:	5d                   	pop    %ebp
c010870c:	c3                   	ret    

c010870d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010870d:	55                   	push   %ebp
c010870e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0108710:	ff 75 08             	pushl  0x8(%ebp)
c0108713:	e8 e2 ff ff ff       	call   c01086fa <page2ppn>
c0108718:	83 c4 04             	add    $0x4,%esp
c010871b:	c1 e0 0c             	shl    $0xc,%eax
}
c010871e:	c9                   	leave  
c010871f:	c3                   	ret    

c0108720 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0108720:	55                   	push   %ebp
c0108721:	89 e5                	mov    %esp,%ebp
c0108723:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0108726:	8b 45 08             	mov    0x8(%ebp),%eax
c0108729:	c1 e8 0c             	shr    $0xc,%eax
c010872c:	89 c2                	mov    %eax,%edx
c010872e:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0108733:	39 c2                	cmp    %eax,%edx
c0108735:	72 14                	jb     c010874b <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0108737:	83 ec 04             	sub    $0x4,%esp
c010873a:	68 e0 be 10 c0       	push   $0xc010bee0
c010873f:	6a 5f                	push   $0x5f
c0108741:	68 ff be 10 c0       	push   $0xc010beff
c0108746:	e8 ad 7c ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c010874b:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0108750:	8b 55 08             	mov    0x8(%ebp),%edx
c0108753:	c1 ea 0c             	shr    $0xc,%edx
c0108756:	c1 e2 05             	shl    $0x5,%edx
c0108759:	01 d0                	add    %edx,%eax
}
c010875b:	c9                   	leave  
c010875c:	c3                   	ret    

c010875d <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010875d:	55                   	push   %ebp
c010875e:	89 e5                	mov    %esp,%ebp
c0108760:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0108763:	ff 75 08             	pushl  0x8(%ebp)
c0108766:	e8 a2 ff ff ff       	call   c010870d <page2pa>
c010876b:	83 c4 04             	add    $0x4,%esp
c010876e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108774:	c1 e8 0c             	shr    $0xc,%eax
c0108777:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010877a:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010877f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108782:	72 14                	jb     c0108798 <page2kva+0x3b>
c0108784:	ff 75 f4             	pushl  -0xc(%ebp)
c0108787:	68 10 bf 10 c0       	push   $0xc010bf10
c010878c:	6a 66                	push   $0x66
c010878e:	68 ff be 10 c0       	push   $0xc010beff
c0108793:	e8 60 7c ff ff       	call   c01003f8 <__panic>
c0108798:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010879b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01087a0:	c9                   	leave  
c01087a1:	c3                   	ret    

c01087a2 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01087a2:	55                   	push   %ebp
c01087a3:	89 e5                	mov    %esp,%ebp
c01087a5:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c01087a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087ae:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01087b5:	77 14                	ja     c01087cb <kva2page+0x29>
c01087b7:	ff 75 f4             	pushl  -0xc(%ebp)
c01087ba:	68 34 bf 10 c0       	push   $0xc010bf34
c01087bf:	6a 6b                	push   $0x6b
c01087c1:	68 ff be 10 c0       	push   $0xc010beff
c01087c6:	e8 2d 7c ff ff       	call   c01003f8 <__panic>
c01087cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087ce:	05 00 00 00 40       	add    $0x40000000,%eax
c01087d3:	83 ec 0c             	sub    $0xc,%esp
c01087d6:	50                   	push   %eax
c01087d7:	e8 44 ff ff ff       	call   c0108720 <pa2page>
c01087dc:	83 c4 10             	add    $0x10,%esp
}
c01087df:	c9                   	leave  
c01087e0:	c3                   	ret    

c01087e1 <alloc_proc>:
void forkrets(struct trapframe *tf);    // resotore esp, and then jmp to trapret just like ret from trap
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01087e1:	55                   	push   %ebp
c01087e2:	89 e5                	mov    %esp,%ebp
c01087e4:	83 ec 18             	sub    $0x18,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01087e7:	83 ec 0c             	sub    $0xc,%esp
c01087ea:	6a 68                	push   $0x68
c01087ec:	e8 22 c9 ff ff       	call   c0105113 <kmalloc>
c01087f1:	83 c4 10             	add    $0x10,%esp
c01087f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c01087f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01087fb:	0f 84 91 00 00 00    	je     c0108892 <alloc_proc+0xb1>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT;
c0108801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108804:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = -1;         // an invalid pid
c010880a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010880d:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->runs = 0;
c0108814:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108817:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        proc->kstack = 0;
c010881e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108821:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        proc->need_resched = 0;
c0108828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010882b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent = NULL;
c0108832:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108835:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        proc->mm = NULL;
c010883c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010883f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        proc->tf = NULL;
c0108846:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108849:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3 = boot_cr3;   // kernel threads share boot_cr3
c0108850:	8b 15 94 c1 12 c0    	mov    0xc012c194,%edx
c0108856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108859:	89 50 40             	mov    %edx,0x40(%eax)
        proc->flags = 0;
c010885c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010885f:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)

        memset(&(proc->context), 0, sizeof(struct context));
c0108866:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108869:	83 c0 1c             	add    $0x1c,%eax
c010886c:	83 ec 04             	sub    $0x4,%esp
c010886f:	6a 20                	push   $0x20
c0108871:	6a 00                	push   $0x0
c0108873:	50                   	push   %eax
c0108874:	e8 ab 0c 00 00       	call   c0109524 <memset>
c0108879:	83 c4 10             	add    $0x10,%esp
        memset(proc->name, 0, sizeof(char) * (PROC_NAME_LEN + 1));
c010887c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010887f:	83 c0 48             	add    $0x48,%eax
c0108882:	83 ec 04             	sub    $0x4,%esp
c0108885:	6a 10                	push   $0x10
c0108887:	6a 00                	push   $0x0
c0108889:	50                   	push   %eax
c010888a:	e8 95 0c 00 00       	call   c0109524 <memset>
c010888f:	83 c4 10             	add    $0x10,%esp
    }
    return proc;
c0108892:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108895:	c9                   	leave  
c0108896:	c3                   	ret    

c0108897 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108897:	55                   	push   %ebp
c0108898:	89 e5                	mov    %esp,%ebp
c010889a:	83 ec 08             	sub    $0x8,%esp
    memset(proc->name, 0, sizeof(proc->name));
c010889d:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a0:	83 c0 48             	add    $0x48,%eax
c01088a3:	83 ec 04             	sub    $0x4,%esp
c01088a6:	6a 10                	push   $0x10
c01088a8:	6a 00                	push   $0x0
c01088aa:	50                   	push   %eax
c01088ab:	e8 74 0c 00 00       	call   c0109524 <memset>
c01088b0:	83 c4 10             	add    $0x10,%esp
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01088b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01088b6:	83 c0 48             	add    $0x48,%eax
c01088b9:	83 ec 04             	sub    $0x4,%esp
c01088bc:	6a 0f                	push   $0xf
c01088be:	ff 75 0c             	pushl  0xc(%ebp)
c01088c1:	50                   	push   %eax
c01088c2:	e8 40 0d 00 00       	call   c0109607 <memcpy>
c01088c7:	83 c4 10             	add    $0x10,%esp
}
c01088ca:	c9                   	leave  
c01088cb:	c3                   	ret    

c01088cc <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c01088cc:	55                   	push   %ebp
c01088cd:	89 e5                	mov    %esp,%ebp
c01088cf:	83 ec 08             	sub    $0x8,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c01088d2:	83 ec 04             	sub    $0x4,%esp
c01088d5:	6a 10                	push   $0x10
c01088d7:	6a 00                	push   $0x0
c01088d9:	68 44 c0 12 c0       	push   $0xc012c044
c01088de:	e8 41 0c 00 00       	call   c0109524 <memset>
c01088e3:	83 c4 10             	add    $0x10,%esp
    return memcpy(name, proc->name, PROC_NAME_LEN);
c01088e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01088e9:	83 c0 48             	add    $0x48,%eax
c01088ec:	83 ec 04             	sub    $0x4,%esp
c01088ef:	6a 0f                	push   $0xf
c01088f1:	50                   	push   %eax
c01088f2:	68 44 c0 12 c0       	push   $0xc012c044
c01088f7:	e8 0b 0d 00 00       	call   c0109607 <memcpy>
c01088fc:	83 c4 10             	add    $0x10,%esp
}
c01088ff:	c9                   	leave  
c0108900:	c3                   	ret    

c0108901 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0108901:	55                   	push   %ebp
c0108902:	89 e5                	mov    %esp,%ebp
c0108904:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108907:	c7 45 f8 9c c1 12 c0 	movl   $0xc012c19c,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c010890e:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c0108913:	83 c0 01             	add    $0x1,%eax
c0108916:	a3 b8 6a 12 c0       	mov    %eax,0xc0126ab8
c010891b:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c0108920:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108925:	7e 0c                	jle    c0108933 <get_pid+0x32>
        last_pid = 1;
c0108927:	c7 05 b8 6a 12 c0 01 	movl   $0x1,0xc0126ab8
c010892e:	00 00 00 
        goto inside;
c0108931:	eb 13                	jmp    c0108946 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c0108933:	8b 15 b8 6a 12 c0    	mov    0xc0126ab8,%edx
c0108939:	a1 bc 6a 12 c0       	mov    0xc0126abc,%eax
c010893e:	39 c2                	cmp    %eax,%edx
c0108940:	0f 8c ac 00 00 00    	jl     c01089f2 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0108946:	c7 05 bc 6a 12 c0 00 	movl   $0x2000,0xc0126abc
c010894d:	20 00 00 
    repeat:
        le = list;
c0108950:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108953:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108956:	eb 7f                	jmp    c01089d7 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0108958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010895b:	83 e8 58             	sub    $0x58,%eax
c010895e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0108961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108964:	8b 50 04             	mov    0x4(%eax),%edx
c0108967:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c010896c:	39 c2                	cmp    %eax,%edx
c010896e:	75 3e                	jne    c01089ae <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0108970:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c0108975:	83 c0 01             	add    $0x1,%eax
c0108978:	a3 b8 6a 12 c0       	mov    %eax,0xc0126ab8
c010897d:	8b 15 b8 6a 12 c0    	mov    0xc0126ab8,%edx
c0108983:	a1 bc 6a 12 c0       	mov    0xc0126abc,%eax
c0108988:	39 c2                	cmp    %eax,%edx
c010898a:	7c 4b                	jl     c01089d7 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c010898c:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c0108991:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108996:	7e 0a                	jle    c01089a2 <get_pid+0xa1>
                        last_pid = 1;
c0108998:	c7 05 b8 6a 12 c0 01 	movl   $0x1,0xc0126ab8
c010899f:	00 00 00 
                    }
                    next_safe = MAX_PID;
c01089a2:	c7 05 bc 6a 12 c0 00 	movl   $0x2000,0xc0126abc
c01089a9:	20 00 00 
                    goto repeat;
c01089ac:	eb a2                	jmp    c0108950 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c01089ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089b1:	8b 50 04             	mov    0x4(%eax),%edx
c01089b4:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c01089b9:	39 c2                	cmp    %eax,%edx
c01089bb:	7e 1a                	jle    c01089d7 <get_pid+0xd6>
c01089bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089c0:	8b 50 04             	mov    0x4(%eax),%edx
c01089c3:	a1 bc 6a 12 c0       	mov    0xc0126abc,%eax
c01089c8:	39 c2                	cmp    %eax,%edx
c01089ca:	7d 0b                	jge    c01089d7 <get_pid+0xd6>
                next_safe = proc->pid;
c01089cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089cf:	8b 40 04             	mov    0x4(%eax),%eax
c01089d2:	a3 bc 6a 12 c0       	mov    %eax,0xc0126abc
c01089d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01089da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089e0:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c01089e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01089e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01089e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01089ec:	0f 85 66 ff ff ff    	jne    c0108958 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c01089f2:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
}
c01089f7:	c9                   	leave  
c01089f8:	c3                   	ret    

c01089f9 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c01089f9:	55                   	push   %ebp
c01089fa:	89 e5                	mov    %esp,%ebp
c01089fc:	83 ec 18             	sub    $0x18,%esp
    if (proc != current) {
c01089ff:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108a04:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108a07:	74 6b                	je     c0108a74 <proc_run+0x7b>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108a09:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108a17:	e8 a0 fc ff ff       	call   c01086bc <__intr_save>
c0108a1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a22:	a3 28 a0 12 c0       	mov    %eax,0xc012a028
            load_esp0(next->kstack + KSTACKSIZE);   // kstack is the lowest(base) addr of the stack, but esp points to the higest addr
c0108a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a2a:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a2d:	05 00 20 00 00       	add    $0x2000,%eax
c0108a32:	83 ec 0c             	sub    $0xc,%esp
c0108a35:	50                   	push   %eax
c0108a36:	e8 59 e4 ff ff       	call   c0106e94 <load_esp0>
c0108a3b:	83 c4 10             	add    $0x10,%esp
            lcr3(next->cr3);
c0108a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a41:	8b 40 40             	mov    0x40(%eax),%eax
c0108a44:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0108a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a4a:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a50:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a56:	83 c0 1c             	add    $0x1c,%eax
c0108a59:	83 ec 08             	sub    $0x8,%esp
c0108a5c:	52                   	push   %edx
c0108a5d:	50                   	push   %eax
c0108a5e:	e8 22 fc ff ff       	call   c0108685 <switch_to>
c0108a63:	83 c4 10             	add    $0x10,%esp
        }
        local_intr_restore(intr_flag);
c0108a66:	83 ec 0c             	sub    $0xc,%esp
c0108a69:	ff 75 ec             	pushl  -0x14(%ebp)
c0108a6c:	e8 75 fc ff ff       	call   c01086e6 <__intr_restore>
c0108a71:	83 c4 10             	add    $0x10,%esp
    }
}
c0108a74:	90                   	nop
c0108a75:	c9                   	leave  
c0108a76:	c3                   	ret    

c0108a77 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108a77:	55                   	push   %ebp
c0108a78:	89 e5                	mov    %esp,%ebp
c0108a7a:	83 ec 08             	sub    $0x8,%esp
    forkrets(current->tf);
c0108a7d:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108a82:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108a85:	83 ec 0c             	sub    $0xc,%esp
c0108a88:	50                   	push   %eax
c0108a89:	e8 78 a8 ff ff       	call   c0103306 <forkrets>
c0108a8e:	83 c4 10             	add    $0x10,%esp
}
c0108a91:	90                   	nop
c0108a92:	c9                   	leave  
c0108a93:	c3                   	ret    

c0108a94 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0108a94:	55                   	push   %ebp
c0108a95:	89 e5                	mov    %esp,%ebp
c0108a97:	53                   	push   %ebx
c0108a98:	83 ec 24             	sub    $0x24,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a9e:	8d 58 60             	lea    0x60(%eax),%ebx
c0108aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aa4:	8b 40 04             	mov    0x4(%eax),%eax
c0108aa7:	83 ec 08             	sub    $0x8,%esp
c0108aaa:	6a 0a                	push   $0xa
c0108aac:	50                   	push   %eax
c0108aad:	e8 09 12 00 00       	call   c0109cbb <hash32>
c0108ab2:	83 c4 10             	add    $0x10,%esp
c0108ab5:	c1 e0 03             	shl    $0x3,%eax
c0108ab8:	05 40 a0 12 c0       	add    $0xc012a040,%eax
c0108abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ac0:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ac6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108acc:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ad2:	8b 40 04             	mov    0x4(%eax),%eax
c0108ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108ad8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108adb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108ade:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108ae1:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108ae4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108aea:	89 10                	mov    %edx,(%eax)
c0108aec:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108aef:	8b 10                	mov    (%eax),%edx
c0108af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108af4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108afa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108afd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108b03:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108b06:	89 10                	mov    %edx,(%eax)
}
c0108b08:	90                   	nop
c0108b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0108b0c:	c9                   	leave  
c0108b0d:	c3                   	ret    

c0108b0e <find_proc>:

// find_proc - find proc from proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108b0e:	55                   	push   %ebp
c0108b0f:	89 e5                	mov    %esp,%ebp
c0108b11:	83 ec 18             	sub    $0x18,%esp
    if (0 < pid && pid < MAX_PID) {
c0108b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108b18:	7e 5d                	jle    c0108b77 <find_proc+0x69>
c0108b1a:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108b21:	7f 54                	jg     c0108b77 <find_proc+0x69>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b26:	83 ec 08             	sub    $0x8,%esp
c0108b29:	6a 0a                	push   $0xa
c0108b2b:	50                   	push   %eax
c0108b2c:	e8 8a 11 00 00       	call   c0109cbb <hash32>
c0108b31:	83 c4 10             	add    $0x10,%esp
c0108b34:	c1 e0 03             	shl    $0x3,%eax
c0108b37:	05 40 a0 12 c0       	add    $0xc012a040,%eax
c0108b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108b45:	eb 19                	jmp    c0108b60 <find_proc+0x52>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b4a:	83 e8 60             	sub    $0x60,%eax
c0108b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b53:	8b 40 04             	mov    0x4(%eax),%eax
c0108b56:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108b59:	75 05                	jne    c0108b60 <find_proc+0x52>
                return proc;
c0108b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b5e:	eb 1c                	jmp    c0108b7c <find_proc+0x6e>
c0108b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108b66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b69:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc from proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0108b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b72:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108b75:	75 d0                	jne    c0108b47 <find_proc+0x39>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b7c:	c9                   	leave  
c0108b7d:	c3                   	ret    

c0108b7e <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108b7e:	55                   	push   %ebp
c0108b7f:	89 e5                	mov    %esp,%ebp
c0108b81:	83 ec 58             	sub    $0x58,%esp
    struct trapframe tf;        // this is just a tmp var
    memset(&tf, 0, sizeof(struct trapframe));
c0108b84:	83 ec 04             	sub    $0x4,%esp
c0108b87:	6a 4c                	push   $0x4c
c0108b89:	6a 00                	push   $0x0
c0108b8b:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108b8e:	50                   	push   %eax
c0108b8f:	e8 90 09 00 00       	call   c0109524 <memset>
c0108b94:	83 c4 10             	add    $0x10,%esp
    tf.tf_cs = KERNEL_CS;
c0108b97:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108b9d:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108ba3:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108ba7:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108bab:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108baf:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;              // this is the function this thread will truly exec
c0108bb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;             // this is the arg of fn
c0108bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bbc:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;      // as soon as the kthread start to run, it will exec k_t_entry
c0108bbf:	b8 7c 86 10 c0       	mov    $0xc010867c,%eax
c0108bc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108bc7:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bca:	80 cc 01             	or     $0x1,%ah
c0108bcd:	89 c2                	mov    %eax,%edx
c0108bcf:	83 ec 04             	sub    $0x4,%esp
c0108bd2:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108bd5:	50                   	push   %eax
c0108bd6:	6a 00                	push   $0x0
c0108bd8:	52                   	push   %edx
c0108bd9:	e8 3c 01 00 00       	call   c0108d1a <do_fork>
c0108bde:	83 c4 10             	add    $0x10,%esp
}
c0108be1:	c9                   	leave  
c0108be2:	c3                   	ret    

c0108be3 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108be3:	55                   	push   %ebp
c0108be4:	89 e5                	mov    %esp,%ebp
c0108be6:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108be9:	83 ec 0c             	sub    $0xc,%esp
c0108bec:	6a 02                	push   $0x2
c0108bee:	e8 f5 e3 ff ff       	call   c0106fe8 <alloc_pages>
c0108bf3:	83 c4 10             	add    $0x10,%esp
c0108bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108bfd:	74 1d                	je     c0108c1c <setup_kstack+0x39>
        proc->kstack = (uintptr_t)page2kva(page);
c0108bff:	83 ec 0c             	sub    $0xc,%esp
c0108c02:	ff 75 f4             	pushl  -0xc(%ebp)
c0108c05:	e8 53 fb ff ff       	call   c010875d <page2kva>
c0108c0a:	83 c4 10             	add    $0x10,%esp
c0108c0d:	89 c2                	mov    %eax,%edx
c0108c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c12:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108c15:	b8 00 00 00 00       	mov    $0x0,%eax
c0108c1a:	eb 05                	jmp    c0108c21 <setup_kstack+0x3e>
    }
    return -E_NO_MEM;
c0108c1c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108c21:	c9                   	leave  
c0108c22:	c3                   	ret    

c0108c23 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108c23:	55                   	push   %ebp
c0108c24:	89 e5                	mov    %esp,%ebp
c0108c26:	83 ec 08             	sub    $0x8,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c2c:	8b 40 0c             	mov    0xc(%eax),%eax
c0108c2f:	83 ec 0c             	sub    $0xc,%esp
c0108c32:	50                   	push   %eax
c0108c33:	e8 6a fb ff ff       	call   c01087a2 <kva2page>
c0108c38:	83 c4 10             	add    $0x10,%esp
c0108c3b:	83 ec 08             	sub    $0x8,%esp
c0108c3e:	6a 02                	push   $0x2
c0108c40:	50                   	push   %eax
c0108c41:	e8 0e e4 ff ff       	call   c0107054 <free_pages>
c0108c46:	83 c4 10             	add    $0x10,%esp
}
c0108c49:	90                   	nop
c0108c4a:	c9                   	leave  
c0108c4b:	c3                   	ret    

c0108c4c <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108c4c:	55                   	push   %ebp
c0108c4d:	89 e5                	mov    %esp,%ebp
c0108c4f:	83 ec 08             	sub    $0x8,%esp
    assert(current->mm == NULL);
c0108c52:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108c57:	8b 40 18             	mov    0x18(%eax),%eax
c0108c5a:	85 c0                	test   %eax,%eax
c0108c5c:	74 19                	je     c0108c77 <copy_mm+0x2b>
c0108c5e:	68 58 bf 10 c0       	push   $0xc010bf58
c0108c63:	68 6c bf 10 c0       	push   $0xc010bf6c
c0108c68:	68 ff 00 00 00       	push   $0xff
c0108c6d:	68 81 bf 10 c0       	push   $0xc010bf81
c0108c72:	e8 81 77 ff ff       	call   c01003f8 <__panic>
    /* do nothing in this project */
    return 0;
c0108c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108c7c:	c9                   	leave  
c0108c7d:	c3                   	ret    

c0108c7e <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108c7e:	55                   	push   %ebp
c0108c7f:	89 e5                	mov    %esp,%ebp
c0108c81:	57                   	push   %edi
c0108c82:	56                   	push   %esi
c0108c83:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;     // at the top of kstack
c0108c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c87:	8b 40 0c             	mov    0xc(%eax),%eax
c0108c8a:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108c8f:	89 c2                	mov    %eax,%edx
c0108c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c94:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c9a:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c9d:	8b 55 10             	mov    0x10(%ebp),%edx
c0108ca0:	89 d3                	mov    %edx,%ebx
c0108ca2:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0108ca7:	8b 0b                	mov    (%ebx),%ecx
c0108ca9:	89 08                	mov    %ecx,(%eax)
c0108cab:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c0108caf:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0108cb3:	8d 78 04             	lea    0x4(%eax),%edi
c0108cb6:	83 e7 fc             	and    $0xfffffffc,%edi
c0108cb9:	29 f8                	sub    %edi,%eax
c0108cbb:	29 c3                	sub    %eax,%ebx
c0108cbd:	01 c2                	add    %eax,%edx
c0108cbf:	83 e2 fc             	and    $0xfffffffc,%edx
c0108cc2:	89 d0                	mov    %edx,%eax
c0108cc4:	c1 e8 02             	shr    $0x2,%eax
c0108cc7:	89 de                	mov    %ebx,%esi
c0108cc9:	89 c1                	mov    %eax,%ecx
c0108ccb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    proc->tf->tf_regs.reg_eax = 0;
c0108ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cd0:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108cd3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cdd:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108ce3:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ce9:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108cec:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cef:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108cf2:	8b 52 40             	mov    0x40(%edx),%edx
c0108cf5:	80 ce 02             	or     $0x2,%dh
c0108cf8:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;     // as soon as this proc starts, it will exec forkret
c0108cfb:	ba 77 8a 10 c0       	mov    $0xc0108a77,%edx
c0108d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d03:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);  // esp is at the available top of kstack (just under tf space)
c0108d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d09:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108d0c:	89 c2                	mov    %eax,%edx
c0108d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d11:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108d14:	90                   	nop
c0108d15:	5b                   	pop    %ebx
c0108d16:	5e                   	pop    %esi
c0108d17:	5f                   	pop    %edi
c0108d18:	5d                   	pop    %ebp
c0108d19:	c3                   	ret    

c0108d1a <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108d1a:	55                   	push   %ebp
c0108d1b:	89 e5                	mov    %esp,%ebp
c0108d1d:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_NO_FREE_PROC;
c0108d20:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108d27:	a1 40 c0 12 c0       	mov    0xc012c040,%eax
c0108d2c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108d31:	0f 8f 14 01 00 00    	jg     c0108e4b <do_fork+0x131>
        goto fork_out;
    }
    ret = -E_NO_MEM;
c0108d37:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    proc = alloc_proc();
c0108d3e:	e8 9e fa ff ff       	call   c01087e1 <alloc_proc>
c0108d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (proc == NULL) {
c0108d46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108d4a:	0f 84 fe 00 00 00    	je     c0108e4e <do_fork+0x134>
        goto fork_out;
    }
    proc->parent = current;
c0108d50:	8b 15 28 a0 12 c0    	mov    0xc012a028,%edx
c0108d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d59:	89 50 14             	mov    %edx,0x14(%eax)
    //    2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc) != 0) {
c0108d5c:	83 ec 0c             	sub    $0xc,%esp
c0108d5f:	ff 75 f0             	pushl  -0x10(%ebp)
c0108d62:	e8 7c fe ff ff       	call   c0108be3 <setup_kstack>
c0108d67:	83 c4 10             	add    $0x10,%esp
c0108d6a:	85 c0                	test   %eax,%eax
c0108d6c:	0f 85 f3 00 00 00    	jne    c0108e65 <do_fork+0x14b>
        goto bad_fork_cleanup_proc;
    }
    //    3. call copy_mm to dup OR share mm according clone_flag
    if (copy_mm(clone_flags, proc) != 0) {
c0108d72:	83 ec 08             	sub    $0x8,%esp
c0108d75:	ff 75 f0             	pushl  -0x10(%ebp)
c0108d78:	ff 75 08             	pushl  0x8(%ebp)
c0108d7b:	e8 cc fe ff ff       	call   c0108c4c <copy_mm>
c0108d80:	83 c4 10             	add    $0x10,%esp
c0108d83:	85 c0                	test   %eax,%eax
c0108d85:	0f 85 c9 00 00 00    	jne    c0108e54 <do_fork+0x13a>
        goto bad_fork_cleanup_kstack;
    }
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);   // note: if stack == 0, this is a kernel thread
c0108d8b:	83 ec 04             	sub    $0x4,%esp
c0108d8e:	ff 75 10             	pushl  0x10(%ebp)
c0108d91:	ff 75 0c             	pushl  0xc(%ebp)
c0108d94:	ff 75 f0             	pushl  -0x10(%ebp)
c0108d97:	e8 e2 fe ff ff       	call   c0108c7e <copy_thread>
c0108d9c:	83 c4 10             	add    $0x10,%esp
    //    5. insert proc_struct into hash_list && proc_list
    // this need disabling interrupt
    bool intr_flag;
    local_intr_save(intr_flag);
c0108d9f:	e8 18 f9 ff ff       	call   c01086bc <__intr_save>
c0108da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        proc->pid = get_pid();
c0108da7:	e8 55 fb ff ff       	call   c0108901 <get_pid>
c0108dac:	89 c2                	mov    %eax,%edx
c0108dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108db1:	89 50 04             	mov    %edx,0x4(%eax)
        hash_proc(proc);
c0108db4:	83 ec 0c             	sub    $0xc,%esp
c0108db7:	ff 75 f0             	pushl  -0x10(%ebp)
c0108dba:	e8 d5 fc ff ff       	call   c0108a94 <hash_proc>
c0108dbf:	83 c4 10             	add    $0x10,%esp
        list_add(&proc_list, &(proc->list_link));
c0108dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108dc5:	83 c0 58             	add    $0x58,%eax
c0108dc8:	c7 45 e8 9c c1 12 c0 	movl   $0xc012c19c,-0x18(%ebp)
c0108dcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108dd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108ddb:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108de1:	8b 40 04             	mov    0x4(%eax),%eax
c0108de4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108de7:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108dea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108ded:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108df0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108df3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108df6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108df9:	89 10                	mov    %edx,(%eax)
c0108dfb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108dfe:	8b 10                	mov    (%eax),%edx
c0108e00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108e03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108e06:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108e09:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108e0c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108e12:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108e15:	89 10                	mov    %edx,(%eax)
        nr_process++;
c0108e17:	a1 40 c0 12 c0       	mov    0xc012c040,%eax
c0108e1c:	83 c0 01             	add    $0x1,%eax
c0108e1f:	a3 40 c0 12 c0       	mov    %eax,0xc012c040
    }
    local_intr_restore(intr_flag);
c0108e24:	83 ec 0c             	sub    $0xc,%esp
c0108e27:	ff 75 ec             	pushl  -0x14(%ebp)
c0108e2a:	e8 b7 f8 ff ff       	call   c01086e6 <__intr_restore>
c0108e2f:	83 c4 10             	add    $0x10,%esp
    //    6. call wakeup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
c0108e32:	83 ec 0c             	sub    $0xc,%esp
c0108e35:	ff 75 f0             	pushl  -0x10(%ebp)
c0108e38:	e8 ac 02 00 00       	call   c01090e9 <wakeup_proc>
c0108e3d:	83 c4 10             	add    $0x10,%esp
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
c0108e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e43:	8b 40 04             	mov    0x4(%eax),%eax
c0108e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108e49:	eb 04                	jmp    c0108e4f <do_fork+0x135>
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
c0108e4b:	90                   	nop
c0108e4c:	eb 01                	jmp    c0108e4f <do_fork+0x135>
     */

    //    1. call alloc_proc to allocate a proc_struct
    proc = alloc_proc();
    if (proc == NULL) {
        goto fork_out;
c0108e4e:	90                   	nop
    wakeup_proc(proc);
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
    
fork_out:
    return ret;
c0108e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108e52:	eb 22                	jmp    c0108e76 <do_fork+0x15c>
    if (setup_kstack(proc) != 0) {
        goto bad_fork_cleanup_proc;
    }
    //    3. call copy_mm to dup OR share mm according clone_flag
    if (copy_mm(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
c0108e54:	90                   	nop
    
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108e55:	83 ec 0c             	sub    $0xc,%esp
c0108e58:	ff 75 f0             	pushl  -0x10(%ebp)
c0108e5b:	e8 c3 fd ff ff       	call   c0108c23 <put_kstack>
c0108e60:	83 c4 10             	add    $0x10,%esp
c0108e63:	eb 01                	jmp    c0108e66 <do_fork+0x14c>
        goto fork_out;
    }
    proc->parent = current;
    //    2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc) != 0) {
        goto bad_fork_cleanup_proc;
c0108e65:	90                   	nop
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108e66:	83 ec 0c             	sub    $0xc,%esp
c0108e69:	ff 75 f0             	pushl  -0x10(%ebp)
c0108e6c:	e8 ba c2 ff ff       	call   c010512b <kfree>
c0108e71:	83 c4 10             	add    $0x10,%esp
    goto fork_out;
c0108e74:	eb d9                	jmp    c0108e4f <do_fork+0x135>
}
c0108e76:	c9                   	leave  
c0108e77:	c3                   	ret    

c0108e78 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108e78:	55                   	push   %ebp
c0108e79:	89 e5                	mov    %esp,%ebp
c0108e7b:	83 ec 08             	sub    $0x8,%esp
    panic("process exit!!.\n");
c0108e7e:	83 ec 04             	sub    $0x4,%esp
c0108e81:	68 95 bf 10 c0       	push   $0xc010bf95
c0108e86:	68 61 01 00 00       	push   $0x161
c0108e8b:	68 81 bf 10 c0       	push   $0xc010bf81
c0108e90:	e8 63 75 ff ff       	call   c01003f8 <__panic>

c0108e95 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108e95:	55                   	push   %ebp
c0108e96:	89 e5                	mov    %esp,%ebp
c0108e98:	83 ec 08             	sub    $0x8,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108e9b:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108ea0:	83 ec 0c             	sub    $0xc,%esp
c0108ea3:	50                   	push   %eax
c0108ea4:	e8 23 fa ff ff       	call   c01088cc <get_proc_name>
c0108ea9:	83 c4 10             	add    $0x10,%esp
c0108eac:	89 c2                	mov    %eax,%edx
c0108eae:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108eb3:	8b 40 04             	mov    0x4(%eax),%eax
c0108eb6:	83 ec 04             	sub    $0x4,%esp
c0108eb9:	52                   	push   %edx
c0108eba:	50                   	push   %eax
c0108ebb:	68 a8 bf 10 c0       	push   $0xc010bfa8
c0108ec0:	e8 cd 73 ff ff       	call   c0100292 <cprintf>
c0108ec5:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108ec8:	83 ec 08             	sub    $0x8,%esp
c0108ecb:	ff 75 08             	pushl  0x8(%ebp)
c0108ece:	68 ce bf 10 c0       	push   $0xc010bfce
c0108ed3:	e8 ba 73 ff ff       	call   c0100292 <cprintf>
c0108ed8:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108edb:	83 ec 0c             	sub    $0xc,%esp
c0108ede:	68 db bf 10 c0       	push   $0xc010bfdb
c0108ee3:	e8 aa 73 ff ff       	call   c0100292 <cprintf>
c0108ee8:	83 c4 10             	add    $0x10,%esp
    return 0;
c0108eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ef0:	c9                   	leave  
c0108ef1:	c3                   	ret    

c0108ef2 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108ef2:	55                   	push   %ebp
c0108ef3:	89 e5                	mov    %esp,%ebp
c0108ef5:	83 ec 18             	sub    $0x18,%esp
c0108ef8:	c7 45 e8 9c c1 12 c0 	movl   $0xc012c19c,-0x18(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f02:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108f05:	89 50 04             	mov    %edx,0x4(%eax)
c0108f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f0b:	8b 50 04             	mov    0x4(%eax),%edx
c0108f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f11:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    // fill in all hash list
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108f13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108f1a:	eb 26                	jmp    c0108f42 <proc_init+0x50>
        list_init(hash_list + i);
c0108f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f1f:	c1 e0 03             	shl    $0x3,%eax
c0108f22:	05 40 a0 12 c0       	add    $0xc012a040,%eax
c0108f27:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108f30:	89 50 04             	mov    %edx,0x4(%eax)
c0108f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f36:	8b 50 04             	mov    0x4(%eax),%edx
c0108f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f3c:	89 10                	mov    %edx,(%eax)
proc_init(void) {
    int i;

    list_init(&proc_list);
    // fill in all hash list
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108f3e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108f42:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108f49:	7e d1                	jle    c0108f1c <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108f4b:	e8 91 f8 ff ff       	call   c01087e1 <alloc_proc>
c0108f50:	a3 20 a0 12 c0       	mov    %eax,0xc012a020
c0108f55:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108f5a:	85 c0                	test   %eax,%eax
c0108f5c:	75 17                	jne    c0108f75 <proc_init+0x83>
        panic("cannot alloc idleproc.\n");
c0108f5e:	83 ec 04             	sub    $0x4,%esp
c0108f61:	68 f7 bf 10 c0       	push   $0xc010bff7
c0108f66:	68 7a 01 00 00       	push   $0x17a
c0108f6b:	68 81 bf 10 c0       	push   $0xc010bf81
c0108f70:	e8 83 74 ff ff       	call   c01003f8 <__panic>
    }

    idleproc->pid = 0;
c0108f75:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108f7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108f81:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108f86:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108f8c:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108f91:	ba 00 40 12 c0       	mov    $0xc0124000,%edx
c0108f96:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108f99:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108f9e:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108fa5:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108faa:	83 ec 08             	sub    $0x8,%esp
c0108fad:	68 0f c0 10 c0       	push   $0xc010c00f
c0108fb2:	50                   	push   %eax
c0108fb3:	e8 df f8 ff ff       	call   c0108897 <set_proc_name>
c0108fb8:	83 c4 10             	add    $0x10,%esp
    nr_process ++;
c0108fbb:	a1 40 c0 12 c0       	mov    0xc012c040,%eax
c0108fc0:	83 c0 01             	add    $0x1,%eax
c0108fc3:	a3 40 c0 12 c0       	mov    %eax,0xc012c040

    current = idleproc;
c0108fc8:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108fcd:	a3 28 a0 12 c0       	mov    %eax,0xc012a028

    // create the init_proc
    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108fd2:	83 ec 04             	sub    $0x4,%esp
c0108fd5:	6a 00                	push   $0x0
c0108fd7:	68 14 c0 10 c0       	push   $0xc010c014
c0108fdc:	68 95 8e 10 c0       	push   $0xc0108e95
c0108fe1:	e8 98 fb ff ff       	call   c0108b7e <kernel_thread>
c0108fe6:	83 c4 10             	add    $0x10,%esp
c0108fe9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c0108fec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108ff0:	7f 17                	jg     c0109009 <proc_init+0x117>
        panic("create init_main failed.\n");
c0108ff2:	83 ec 04             	sub    $0x4,%esp
c0108ff5:	68 22 c0 10 c0       	push   $0xc010c022
c0108ffa:	68 89 01 00 00       	push   $0x189
c0108fff:	68 81 bf 10 c0       	push   $0xc010bf81
c0109004:	e8 ef 73 ff ff       	call   c01003f8 <__panic>
    }

    initproc = find_proc(pid);
c0109009:	83 ec 0c             	sub    $0xc,%esp
c010900c:	ff 75 ec             	pushl  -0x14(%ebp)
c010900f:	e8 fa fa ff ff       	call   c0108b0e <find_proc>
c0109014:	83 c4 10             	add    $0x10,%esp
c0109017:	a3 24 a0 12 c0       	mov    %eax,0xc012a024
    set_proc_name(initproc, "init");
c010901c:	a1 24 a0 12 c0       	mov    0xc012a024,%eax
c0109021:	83 ec 08             	sub    $0x8,%esp
c0109024:	68 3c c0 10 c0       	push   $0xc010c03c
c0109029:	50                   	push   %eax
c010902a:	e8 68 f8 ff ff       	call   c0108897 <set_proc_name>
c010902f:	83 c4 10             	add    $0x10,%esp

    assert(idleproc != NULL && idleproc->pid == 0);
c0109032:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0109037:	85 c0                	test   %eax,%eax
c0109039:	74 0c                	je     c0109047 <proc_init+0x155>
c010903b:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0109040:	8b 40 04             	mov    0x4(%eax),%eax
c0109043:	85 c0                	test   %eax,%eax
c0109045:	74 19                	je     c0109060 <proc_init+0x16e>
c0109047:	68 44 c0 10 c0       	push   $0xc010c044
c010904c:	68 6c bf 10 c0       	push   $0xc010bf6c
c0109051:	68 8f 01 00 00       	push   $0x18f
c0109056:	68 81 bf 10 c0       	push   $0xc010bf81
c010905b:	e8 98 73 ff ff       	call   c01003f8 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0109060:	a1 24 a0 12 c0       	mov    0xc012a024,%eax
c0109065:	85 c0                	test   %eax,%eax
c0109067:	74 0d                	je     c0109076 <proc_init+0x184>
c0109069:	a1 24 a0 12 c0       	mov    0xc012a024,%eax
c010906e:	8b 40 04             	mov    0x4(%eax),%eax
c0109071:	83 f8 01             	cmp    $0x1,%eax
c0109074:	74 19                	je     c010908f <proc_init+0x19d>
c0109076:	68 6c c0 10 c0       	push   $0xc010c06c
c010907b:	68 6c bf 10 c0       	push   $0xc010bf6c
c0109080:	68 90 01 00 00       	push   $0x190
c0109085:	68 81 bf 10 c0       	push   $0xc010bf81
c010908a:	e8 69 73 ff ff       	call   c01003f8 <__panic>
}
c010908f:	90                   	nop
c0109090:	c9                   	leave  
c0109091:	c3                   	ret    

c0109092 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0109092:	55                   	push   %ebp
c0109093:	89 e5                	mov    %esp,%ebp
c0109095:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c0109098:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c010909d:	8b 40 10             	mov    0x10(%eax),%eax
c01090a0:	85 c0                	test   %eax,%eax
c01090a2:	74 f4                	je     c0109098 <cpu_idle+0x6>
            schedule();
c01090a4:	e8 7c 00 00 00       	call   c0109125 <schedule>
        }
    }
c01090a9:	eb ed                	jmp    c0109098 <cpu_idle+0x6>

c01090ab <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01090ab:	55                   	push   %ebp
c01090ac:	89 e5                	mov    %esp,%ebp
c01090ae:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01090b1:	9c                   	pushf  
c01090b2:	58                   	pop    %eax
c01090b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01090b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01090b9:	25 00 02 00 00       	and    $0x200,%eax
c01090be:	85 c0                	test   %eax,%eax
c01090c0:	74 0c                	je     c01090ce <__intr_save+0x23>
        intr_disable();
c01090c2:	e8 19 90 ff ff       	call   c01020e0 <intr_disable>
        return 1;
c01090c7:	b8 01 00 00 00       	mov    $0x1,%eax
c01090cc:	eb 05                	jmp    c01090d3 <__intr_save+0x28>
    }
    return 0;
c01090ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01090d3:	c9                   	leave  
c01090d4:	c3                   	ret    

c01090d5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01090d5:	55                   	push   %ebp
c01090d6:	89 e5                	mov    %esp,%ebp
c01090d8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01090db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01090df:	74 05                	je     c01090e6 <__intr_restore+0x11>
        intr_enable();
c01090e1:	e8 f3 8f ff ff       	call   c01020d9 <intr_enable>
    }
}
c01090e6:	90                   	nop
c01090e7:	c9                   	leave  
c01090e8:	c3                   	ret    

c01090e9 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c01090e9:	55                   	push   %ebp
c01090ea:	89 e5                	mov    %esp,%ebp
c01090ec:	83 ec 08             	sub    $0x8,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c01090ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01090f2:	8b 00                	mov    (%eax),%eax
c01090f4:	83 f8 03             	cmp    $0x3,%eax
c01090f7:	74 0a                	je     c0109103 <wakeup_proc+0x1a>
c01090f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01090fc:	8b 00                	mov    (%eax),%eax
c01090fe:	83 f8 02             	cmp    $0x2,%eax
c0109101:	75 16                	jne    c0109119 <wakeup_proc+0x30>
c0109103:	68 94 c0 10 c0       	push   $0xc010c094
c0109108:	68 cf c0 10 c0       	push   $0xc010c0cf
c010910d:	6a 09                	push   $0x9
c010910f:	68 e4 c0 10 c0       	push   $0xc010c0e4
c0109114:	e8 df 72 ff ff       	call   c01003f8 <__panic>
    proc->state = PROC_RUNNABLE;
c0109119:	8b 45 08             	mov    0x8(%ebp),%eax
c010911c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c0109122:	90                   	nop
c0109123:	c9                   	leave  
c0109124:	c3                   	ret    

c0109125 <schedule>:

void
schedule(void) {
c0109125:	55                   	push   %ebp
c0109126:	89 e5                	mov    %esp,%ebp
c0109128:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010912b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0109132:	e8 74 ff ff ff       	call   c01090ab <__intr_save>
c0109137:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010913a:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c010913f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0109146:	8b 15 28 a0 12 c0    	mov    0xc012a028,%edx
c010914c:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0109151:	39 c2                	cmp    %eax,%edx
c0109153:	74 0a                	je     c010915f <schedule+0x3a>
c0109155:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c010915a:	83 c0 58             	add    $0x58,%eax
c010915d:	eb 05                	jmp    c0109164 <schedule+0x3f>
c010915f:	b8 9c c1 12 c0       	mov    $0xc012c19c,%eax
c0109164:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0109167:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010916a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010916d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109176:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0109179:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010917c:	81 7d f4 9c c1 12 c0 	cmpl   $0xc012c19c,-0xc(%ebp)
c0109183:	74 13                	je     c0109198 <schedule+0x73>
                next = le2proc(le, list_link);
c0109185:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109188:	83 e8 58             	sub    $0x58,%eax
c010918b:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010918e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109191:	8b 00                	mov    (%eax),%eax
c0109193:	83 f8 02             	cmp    $0x2,%eax
c0109196:	74 0a                	je     c01091a2 <schedule+0x7d>
                    break;
                }
            }
        } while (le != last);
c0109198:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010919b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010919e:	75 cd                	jne    c010916d <schedule+0x48>
c01091a0:	eb 01                	jmp    c01091a3 <schedule+0x7e>
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
c01091a2:	90                   	nop
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
c01091a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01091a7:	74 0a                	je     c01091b3 <schedule+0x8e>
c01091a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091ac:	8b 00                	mov    (%eax),%eax
c01091ae:	83 f8 02             	cmp    $0x2,%eax
c01091b1:	74 08                	je     c01091bb <schedule+0x96>
            next = idleproc;
c01091b3:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c01091b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c01091bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091be:	8b 40 08             	mov    0x8(%eax),%eax
c01091c1:	8d 50 01             	lea    0x1(%eax),%edx
c01091c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091c7:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c01091ca:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c01091cf:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01091d2:	74 0e                	je     c01091e2 <schedule+0xbd>
            proc_run(next);
c01091d4:	83 ec 0c             	sub    $0xc,%esp
c01091d7:	ff 75 f0             	pushl  -0x10(%ebp)
c01091da:	e8 1a f8 ff ff       	call   c01089f9 <proc_run>
c01091df:	83 c4 10             	add    $0x10,%esp
        }
    }
    local_intr_restore(intr_flag);
c01091e2:	83 ec 0c             	sub    $0xc,%esp
c01091e5:	ff 75 ec             	pushl  -0x14(%ebp)
c01091e8:	e8 e8 fe ff ff       	call   c01090d5 <__intr_restore>
c01091ed:	83 c4 10             	add    $0x10,%esp
}
c01091f0:	90                   	nop
c01091f1:	c9                   	leave  
c01091f2:	c3                   	ret    

c01091f3 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01091f3:	55                   	push   %ebp
c01091f4:	89 e5                	mov    %esp,%ebp
c01091f6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01091f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109200:	eb 04                	jmp    c0109206 <strlen+0x13>
        cnt ++;
c0109202:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109206:	8b 45 08             	mov    0x8(%ebp),%eax
c0109209:	8d 50 01             	lea    0x1(%eax),%edx
c010920c:	89 55 08             	mov    %edx,0x8(%ebp)
c010920f:	0f b6 00             	movzbl (%eax),%eax
c0109212:	84 c0                	test   %al,%al
c0109214:	75 ec                	jne    c0109202 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0109216:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109219:	c9                   	leave  
c010921a:	c3                   	ret    

c010921b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010921b:	55                   	push   %ebp
c010921c:	89 e5                	mov    %esp,%ebp
c010921e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109228:	eb 04                	jmp    c010922e <strnlen+0x13>
        cnt ++;
c010922a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010922e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109231:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109234:	73 10                	jae    c0109246 <strnlen+0x2b>
c0109236:	8b 45 08             	mov    0x8(%ebp),%eax
c0109239:	8d 50 01             	lea    0x1(%eax),%edx
c010923c:	89 55 08             	mov    %edx,0x8(%ebp)
c010923f:	0f b6 00             	movzbl (%eax),%eax
c0109242:	84 c0                	test   %al,%al
c0109244:	75 e4                	jne    c010922a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109246:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109249:	c9                   	leave  
c010924a:	c3                   	ret    

c010924b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010924b:	55                   	push   %ebp
c010924c:	89 e5                	mov    %esp,%ebp
c010924e:	57                   	push   %edi
c010924f:	56                   	push   %esi
c0109250:	83 ec 20             	sub    $0x20,%esp
c0109253:	8b 45 08             	mov    0x8(%ebp),%eax
c0109256:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109259:	8b 45 0c             	mov    0xc(%ebp),%eax
c010925c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010925f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109262:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109265:	89 d1                	mov    %edx,%ecx
c0109267:	89 c2                	mov    %eax,%edx
c0109269:	89 ce                	mov    %ecx,%esi
c010926b:	89 d7                	mov    %edx,%edi
c010926d:	ac                   	lods   %ds:(%esi),%al
c010926e:	aa                   	stos   %al,%es:(%edi)
c010926f:	84 c0                	test   %al,%al
c0109271:	75 fa                	jne    c010926d <strcpy+0x22>
c0109273:	89 fa                	mov    %edi,%edx
c0109275:	89 f1                	mov    %esi,%ecx
c0109277:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010927a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010927d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109280:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0109283:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109284:	83 c4 20             	add    $0x20,%esp
c0109287:	5e                   	pop    %esi
c0109288:	5f                   	pop    %edi
c0109289:	5d                   	pop    %ebp
c010928a:	c3                   	ret    

c010928b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010928b:	55                   	push   %ebp
c010928c:	89 e5                	mov    %esp,%ebp
c010928e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109291:	8b 45 08             	mov    0x8(%ebp),%eax
c0109294:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109297:	eb 21                	jmp    c01092ba <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0109299:	8b 45 0c             	mov    0xc(%ebp),%eax
c010929c:	0f b6 10             	movzbl (%eax),%edx
c010929f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01092a2:	88 10                	mov    %dl,(%eax)
c01092a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01092a7:	0f b6 00             	movzbl (%eax),%eax
c01092aa:	84 c0                	test   %al,%al
c01092ac:	74 04                	je     c01092b2 <strncpy+0x27>
            src ++;
c01092ae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01092b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01092b6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01092ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01092be:	75 d9                	jne    c0109299 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01092c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01092c3:	c9                   	leave  
c01092c4:	c3                   	ret    

c01092c5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01092c5:	55                   	push   %ebp
c01092c6:	89 e5                	mov    %esp,%ebp
c01092c8:	57                   	push   %edi
c01092c9:	56                   	push   %esi
c01092ca:	83 ec 20             	sub    $0x20,%esp
c01092cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01092d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01092d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01092dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01092df:	89 d1                	mov    %edx,%ecx
c01092e1:	89 c2                	mov    %eax,%edx
c01092e3:	89 ce                	mov    %ecx,%esi
c01092e5:	89 d7                	mov    %edx,%edi
c01092e7:	ac                   	lods   %ds:(%esi),%al
c01092e8:	ae                   	scas   %es:(%edi),%al
c01092e9:	75 08                	jne    c01092f3 <strcmp+0x2e>
c01092eb:	84 c0                	test   %al,%al
c01092ed:	75 f8                	jne    c01092e7 <strcmp+0x22>
c01092ef:	31 c0                	xor    %eax,%eax
c01092f1:	eb 04                	jmp    c01092f7 <strcmp+0x32>
c01092f3:	19 c0                	sbb    %eax,%eax
c01092f5:	0c 01                	or     $0x1,%al
c01092f7:	89 fa                	mov    %edi,%edx
c01092f9:	89 f1                	mov    %esi,%ecx
c01092fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01092fe:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109301:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109304:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0109307:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109308:	83 c4 20             	add    $0x20,%esp
c010930b:	5e                   	pop    %esi
c010930c:	5f                   	pop    %edi
c010930d:	5d                   	pop    %ebp
c010930e:	c3                   	ret    

c010930f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010930f:	55                   	push   %ebp
c0109310:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109312:	eb 0c                	jmp    c0109320 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109314:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109318:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010931c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109324:	74 1a                	je     c0109340 <strncmp+0x31>
c0109326:	8b 45 08             	mov    0x8(%ebp),%eax
c0109329:	0f b6 00             	movzbl (%eax),%eax
c010932c:	84 c0                	test   %al,%al
c010932e:	74 10                	je     c0109340 <strncmp+0x31>
c0109330:	8b 45 08             	mov    0x8(%ebp),%eax
c0109333:	0f b6 10             	movzbl (%eax),%edx
c0109336:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109339:	0f b6 00             	movzbl (%eax),%eax
c010933c:	38 c2                	cmp    %al,%dl
c010933e:	74 d4                	je     c0109314 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109340:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109344:	74 18                	je     c010935e <strncmp+0x4f>
c0109346:	8b 45 08             	mov    0x8(%ebp),%eax
c0109349:	0f b6 00             	movzbl (%eax),%eax
c010934c:	0f b6 d0             	movzbl %al,%edx
c010934f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109352:	0f b6 00             	movzbl (%eax),%eax
c0109355:	0f b6 c0             	movzbl %al,%eax
c0109358:	29 c2                	sub    %eax,%edx
c010935a:	89 d0                	mov    %edx,%eax
c010935c:	eb 05                	jmp    c0109363 <strncmp+0x54>
c010935e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109363:	5d                   	pop    %ebp
c0109364:	c3                   	ret    

c0109365 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109365:	55                   	push   %ebp
c0109366:	89 e5                	mov    %esp,%ebp
c0109368:	83 ec 04             	sub    $0x4,%esp
c010936b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010936e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109371:	eb 14                	jmp    c0109387 <strchr+0x22>
        if (*s == c) {
c0109373:	8b 45 08             	mov    0x8(%ebp),%eax
c0109376:	0f b6 00             	movzbl (%eax),%eax
c0109379:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010937c:	75 05                	jne    c0109383 <strchr+0x1e>
            return (char *)s;
c010937e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109381:	eb 13                	jmp    c0109396 <strchr+0x31>
        }
        s ++;
c0109383:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109387:	8b 45 08             	mov    0x8(%ebp),%eax
c010938a:	0f b6 00             	movzbl (%eax),%eax
c010938d:	84 c0                	test   %al,%al
c010938f:	75 e2                	jne    c0109373 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0109391:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109396:	c9                   	leave  
c0109397:	c3                   	ret    

c0109398 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109398:	55                   	push   %ebp
c0109399:	89 e5                	mov    %esp,%ebp
c010939b:	83 ec 04             	sub    $0x4,%esp
c010939e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093a1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01093a4:	eb 0f                	jmp    c01093b5 <strfind+0x1d>
        if (*s == c) {
c01093a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01093a9:	0f b6 00             	movzbl (%eax),%eax
c01093ac:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01093af:	74 10                	je     c01093c1 <strfind+0x29>
            break;
        }
        s ++;
c01093b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01093b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01093b8:	0f b6 00             	movzbl (%eax),%eax
c01093bb:	84 c0                	test   %al,%al
c01093bd:	75 e7                	jne    c01093a6 <strfind+0xe>
c01093bf:	eb 01                	jmp    c01093c2 <strfind+0x2a>
        if (*s == c) {
            break;
c01093c1:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c01093c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01093c5:	c9                   	leave  
c01093c6:	c3                   	ret    

c01093c7 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01093c7:	55                   	push   %ebp
c01093c8:	89 e5                	mov    %esp,%ebp
c01093ca:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01093cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01093d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01093db:	eb 04                	jmp    c01093e1 <strtol+0x1a>
        s ++;
c01093dd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01093e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01093e4:	0f b6 00             	movzbl (%eax),%eax
c01093e7:	3c 20                	cmp    $0x20,%al
c01093e9:	74 f2                	je     c01093dd <strtol+0x16>
c01093eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01093ee:	0f b6 00             	movzbl (%eax),%eax
c01093f1:	3c 09                	cmp    $0x9,%al
c01093f3:	74 e8                	je     c01093dd <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01093f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01093f8:	0f b6 00             	movzbl (%eax),%eax
c01093fb:	3c 2b                	cmp    $0x2b,%al
c01093fd:	75 06                	jne    c0109405 <strtol+0x3e>
        s ++;
c01093ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109403:	eb 15                	jmp    c010941a <strtol+0x53>
    }
    else if (*s == '-') {
c0109405:	8b 45 08             	mov    0x8(%ebp),%eax
c0109408:	0f b6 00             	movzbl (%eax),%eax
c010940b:	3c 2d                	cmp    $0x2d,%al
c010940d:	75 0b                	jne    c010941a <strtol+0x53>
        s ++, neg = 1;
c010940f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109413:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010941a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010941e:	74 06                	je     c0109426 <strtol+0x5f>
c0109420:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109424:	75 24                	jne    c010944a <strtol+0x83>
c0109426:	8b 45 08             	mov    0x8(%ebp),%eax
c0109429:	0f b6 00             	movzbl (%eax),%eax
c010942c:	3c 30                	cmp    $0x30,%al
c010942e:	75 1a                	jne    c010944a <strtol+0x83>
c0109430:	8b 45 08             	mov    0x8(%ebp),%eax
c0109433:	83 c0 01             	add    $0x1,%eax
c0109436:	0f b6 00             	movzbl (%eax),%eax
c0109439:	3c 78                	cmp    $0x78,%al
c010943b:	75 0d                	jne    c010944a <strtol+0x83>
        s += 2, base = 16;
c010943d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109441:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109448:	eb 2a                	jmp    c0109474 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010944a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010944e:	75 17                	jne    c0109467 <strtol+0xa0>
c0109450:	8b 45 08             	mov    0x8(%ebp),%eax
c0109453:	0f b6 00             	movzbl (%eax),%eax
c0109456:	3c 30                	cmp    $0x30,%al
c0109458:	75 0d                	jne    c0109467 <strtol+0xa0>
        s ++, base = 8;
c010945a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010945e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109465:	eb 0d                	jmp    c0109474 <strtol+0xad>
    }
    else if (base == 0) {
c0109467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010946b:	75 07                	jne    c0109474 <strtol+0xad>
        base = 10;
c010946d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109474:	8b 45 08             	mov    0x8(%ebp),%eax
c0109477:	0f b6 00             	movzbl (%eax),%eax
c010947a:	3c 2f                	cmp    $0x2f,%al
c010947c:	7e 1b                	jle    c0109499 <strtol+0xd2>
c010947e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109481:	0f b6 00             	movzbl (%eax),%eax
c0109484:	3c 39                	cmp    $0x39,%al
c0109486:	7f 11                	jg     c0109499 <strtol+0xd2>
            dig = *s - '0';
c0109488:	8b 45 08             	mov    0x8(%ebp),%eax
c010948b:	0f b6 00             	movzbl (%eax),%eax
c010948e:	0f be c0             	movsbl %al,%eax
c0109491:	83 e8 30             	sub    $0x30,%eax
c0109494:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109497:	eb 48                	jmp    c01094e1 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109499:	8b 45 08             	mov    0x8(%ebp),%eax
c010949c:	0f b6 00             	movzbl (%eax),%eax
c010949f:	3c 60                	cmp    $0x60,%al
c01094a1:	7e 1b                	jle    c01094be <strtol+0xf7>
c01094a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01094a6:	0f b6 00             	movzbl (%eax),%eax
c01094a9:	3c 7a                	cmp    $0x7a,%al
c01094ab:	7f 11                	jg     c01094be <strtol+0xf7>
            dig = *s - 'a' + 10;
c01094ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01094b0:	0f b6 00             	movzbl (%eax),%eax
c01094b3:	0f be c0             	movsbl %al,%eax
c01094b6:	83 e8 57             	sub    $0x57,%eax
c01094b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01094bc:	eb 23                	jmp    c01094e1 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01094be:	8b 45 08             	mov    0x8(%ebp),%eax
c01094c1:	0f b6 00             	movzbl (%eax),%eax
c01094c4:	3c 40                	cmp    $0x40,%al
c01094c6:	7e 3c                	jle    c0109504 <strtol+0x13d>
c01094c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01094cb:	0f b6 00             	movzbl (%eax),%eax
c01094ce:	3c 5a                	cmp    $0x5a,%al
c01094d0:	7f 32                	jg     c0109504 <strtol+0x13d>
            dig = *s - 'A' + 10;
c01094d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01094d5:	0f b6 00             	movzbl (%eax),%eax
c01094d8:	0f be c0             	movsbl %al,%eax
c01094db:	83 e8 37             	sub    $0x37,%eax
c01094de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01094e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094e4:	3b 45 10             	cmp    0x10(%ebp),%eax
c01094e7:	7d 1a                	jge    c0109503 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c01094e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01094ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01094f0:	0f af 45 10          	imul   0x10(%ebp),%eax
c01094f4:	89 c2                	mov    %eax,%edx
c01094f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094f9:	01 d0                	add    %edx,%eax
c01094fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01094fe:	e9 71 ff ff ff       	jmp    c0109474 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0109503:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0109504:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109508:	74 08                	je     c0109512 <strtol+0x14b>
        *endptr = (char *) s;
c010950a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010950d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109510:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109512:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109516:	74 07                	je     c010951f <strtol+0x158>
c0109518:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010951b:	f7 d8                	neg    %eax
c010951d:	eb 03                	jmp    c0109522 <strtol+0x15b>
c010951f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109522:	c9                   	leave  
c0109523:	c3                   	ret    

c0109524 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109524:	55                   	push   %ebp
c0109525:	89 e5                	mov    %esp,%ebp
c0109527:	57                   	push   %edi
c0109528:	83 ec 24             	sub    $0x24,%esp
c010952b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010952e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109531:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109535:	8b 55 08             	mov    0x8(%ebp),%edx
c0109538:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010953b:	88 45 f7             	mov    %al,-0x9(%ebp)
c010953e:	8b 45 10             	mov    0x10(%ebp),%eax
c0109541:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109544:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109547:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010954b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010954e:	89 d7                	mov    %edx,%edi
c0109550:	f3 aa                	rep stos %al,%es:(%edi)
c0109552:	89 fa                	mov    %edi,%edx
c0109554:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109557:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010955a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010955d:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010955e:	83 c4 24             	add    $0x24,%esp
c0109561:	5f                   	pop    %edi
c0109562:	5d                   	pop    %ebp
c0109563:	c3                   	ret    

c0109564 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109564:	55                   	push   %ebp
c0109565:	89 e5                	mov    %esp,%ebp
c0109567:	57                   	push   %edi
c0109568:	56                   	push   %esi
c0109569:	53                   	push   %ebx
c010956a:	83 ec 30             	sub    $0x30,%esp
c010956d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109570:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109573:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109576:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109579:	8b 45 10             	mov    0x10(%ebp),%eax
c010957c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010957f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109582:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109585:	73 42                	jae    c01095c9 <memmove+0x65>
c0109587:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010958a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010958d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109590:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109593:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109596:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109599:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010959c:	c1 e8 02             	shr    $0x2,%eax
c010959f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01095a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01095a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01095a7:	89 d7                	mov    %edx,%edi
c01095a9:	89 c6                	mov    %eax,%esi
c01095ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01095ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01095b0:	83 e1 03             	and    $0x3,%ecx
c01095b3:	74 02                	je     c01095b7 <memmove+0x53>
c01095b5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01095b7:	89 f0                	mov    %esi,%eax
c01095b9:	89 fa                	mov    %edi,%edx
c01095bb:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01095be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01095c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01095c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01095c7:	eb 36                	jmp    c01095ff <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01095c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01095cc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01095cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095d2:	01 c2                	add    %eax,%edx
c01095d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01095d7:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01095da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01095dd:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01095e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01095e3:	89 c1                	mov    %eax,%ecx
c01095e5:	89 d8                	mov    %ebx,%eax
c01095e7:	89 d6                	mov    %edx,%esi
c01095e9:	89 c7                	mov    %eax,%edi
c01095eb:	fd                   	std    
c01095ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01095ee:	fc                   	cld    
c01095ef:	89 f8                	mov    %edi,%eax
c01095f1:	89 f2                	mov    %esi,%edx
c01095f3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01095f6:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01095f9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01095fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01095ff:	83 c4 30             	add    $0x30,%esp
c0109602:	5b                   	pop    %ebx
c0109603:	5e                   	pop    %esi
c0109604:	5f                   	pop    %edi
c0109605:	5d                   	pop    %ebp
c0109606:	c3                   	ret    

c0109607 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109607:	55                   	push   %ebp
c0109608:	89 e5                	mov    %esp,%ebp
c010960a:	57                   	push   %edi
c010960b:	56                   	push   %esi
c010960c:	83 ec 20             	sub    $0x20,%esp
c010960f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109612:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109618:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010961b:	8b 45 10             	mov    0x10(%ebp),%eax
c010961e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109621:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109624:	c1 e8 02             	shr    $0x2,%eax
c0109627:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109629:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010962c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010962f:	89 d7                	mov    %edx,%edi
c0109631:	89 c6                	mov    %eax,%esi
c0109633:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109635:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109638:	83 e1 03             	and    $0x3,%ecx
c010963b:	74 02                	je     c010963f <memcpy+0x38>
c010963d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010963f:	89 f0                	mov    %esi,%eax
c0109641:	89 fa                	mov    %edi,%edx
c0109643:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109646:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109649:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010964c:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010964f:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109650:	83 c4 20             	add    $0x20,%esp
c0109653:	5e                   	pop    %esi
c0109654:	5f                   	pop    %edi
c0109655:	5d                   	pop    %ebp
c0109656:	c3                   	ret    

c0109657 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109657:	55                   	push   %ebp
c0109658:	89 e5                	mov    %esp,%ebp
c010965a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010965d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109660:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109663:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109666:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109669:	eb 30                	jmp    c010969b <memcmp+0x44>
        if (*s1 != *s2) {
c010966b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010966e:	0f b6 10             	movzbl (%eax),%edx
c0109671:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109674:	0f b6 00             	movzbl (%eax),%eax
c0109677:	38 c2                	cmp    %al,%dl
c0109679:	74 18                	je     c0109693 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010967b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010967e:	0f b6 00             	movzbl (%eax),%eax
c0109681:	0f b6 d0             	movzbl %al,%edx
c0109684:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109687:	0f b6 00             	movzbl (%eax),%eax
c010968a:	0f b6 c0             	movzbl %al,%eax
c010968d:	29 c2                	sub    %eax,%edx
c010968f:	89 d0                	mov    %edx,%eax
c0109691:	eb 1a                	jmp    c01096ad <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109693:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109697:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010969b:	8b 45 10             	mov    0x10(%ebp),%eax
c010969e:	8d 50 ff             	lea    -0x1(%eax),%edx
c01096a1:	89 55 10             	mov    %edx,0x10(%ebp)
c01096a4:	85 c0                	test   %eax,%eax
c01096a6:	75 c3                	jne    c010966b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01096a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01096ad:	c9                   	leave  
c01096ae:	c3                   	ret    

c01096af <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01096af:	55                   	push   %ebp
c01096b0:	89 e5                	mov    %esp,%ebp
c01096b2:	83 ec 38             	sub    $0x38,%esp
c01096b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01096b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01096bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01096be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01096c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01096c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01096c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01096ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01096cd:	8b 45 18             	mov    0x18(%ebp),%eax
c01096d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01096d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01096d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01096dc:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01096df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01096e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01096e9:	74 1c                	je     c0109707 <printnum+0x58>
c01096eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096ee:	ba 00 00 00 00       	mov    $0x0,%edx
c01096f3:	f7 75 e4             	divl   -0x1c(%ebp)
c01096f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01096f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096fc:	ba 00 00 00 00       	mov    $0x0,%edx
c0109701:	f7 75 e4             	divl   -0x1c(%ebp)
c0109704:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109707:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010970a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010970d:	f7 75 e4             	divl   -0x1c(%ebp)
c0109710:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109713:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109716:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109719:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010971c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010971f:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109722:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109725:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109728:	8b 45 18             	mov    0x18(%ebp),%eax
c010972b:	ba 00 00 00 00       	mov    $0x0,%edx
c0109730:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109733:	77 41                	ja     c0109776 <printnum+0xc7>
c0109735:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109738:	72 05                	jb     c010973f <printnum+0x90>
c010973a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010973d:	77 37                	ja     c0109776 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010973f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0109742:	83 e8 01             	sub    $0x1,%eax
c0109745:	83 ec 04             	sub    $0x4,%esp
c0109748:	ff 75 20             	pushl  0x20(%ebp)
c010974b:	50                   	push   %eax
c010974c:	ff 75 18             	pushl  0x18(%ebp)
c010974f:	ff 75 ec             	pushl  -0x14(%ebp)
c0109752:	ff 75 e8             	pushl  -0x18(%ebp)
c0109755:	ff 75 0c             	pushl  0xc(%ebp)
c0109758:	ff 75 08             	pushl  0x8(%ebp)
c010975b:	e8 4f ff ff ff       	call   c01096af <printnum>
c0109760:	83 c4 20             	add    $0x20,%esp
c0109763:	eb 1b                	jmp    c0109780 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109765:	83 ec 08             	sub    $0x8,%esp
c0109768:	ff 75 0c             	pushl  0xc(%ebp)
c010976b:	ff 75 20             	pushl  0x20(%ebp)
c010976e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109771:	ff d0                	call   *%eax
c0109773:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0109776:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010977a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010977e:	7f e5                	jg     c0109765 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0109780:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109783:	05 7c c1 10 c0       	add    $0xc010c17c,%eax
c0109788:	0f b6 00             	movzbl (%eax),%eax
c010978b:	0f be c0             	movsbl %al,%eax
c010978e:	83 ec 08             	sub    $0x8,%esp
c0109791:	ff 75 0c             	pushl  0xc(%ebp)
c0109794:	50                   	push   %eax
c0109795:	8b 45 08             	mov    0x8(%ebp),%eax
c0109798:	ff d0                	call   *%eax
c010979a:	83 c4 10             	add    $0x10,%esp
}
c010979d:	90                   	nop
c010979e:	c9                   	leave  
c010979f:	c3                   	ret    

c01097a0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01097a0:	55                   	push   %ebp
c01097a1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01097a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01097a7:	7e 14                	jle    c01097bd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01097a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01097ac:	8b 00                	mov    (%eax),%eax
c01097ae:	8d 48 08             	lea    0x8(%eax),%ecx
c01097b1:	8b 55 08             	mov    0x8(%ebp),%edx
c01097b4:	89 0a                	mov    %ecx,(%edx)
c01097b6:	8b 50 04             	mov    0x4(%eax),%edx
c01097b9:	8b 00                	mov    (%eax),%eax
c01097bb:	eb 30                	jmp    c01097ed <getuint+0x4d>
    }
    else if (lflag) {
c01097bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01097c1:	74 16                	je     c01097d9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01097c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01097c6:	8b 00                	mov    (%eax),%eax
c01097c8:	8d 48 04             	lea    0x4(%eax),%ecx
c01097cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01097ce:	89 0a                	mov    %ecx,(%edx)
c01097d0:	8b 00                	mov    (%eax),%eax
c01097d2:	ba 00 00 00 00       	mov    $0x0,%edx
c01097d7:	eb 14                	jmp    c01097ed <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01097d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01097dc:	8b 00                	mov    (%eax),%eax
c01097de:	8d 48 04             	lea    0x4(%eax),%ecx
c01097e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01097e4:	89 0a                	mov    %ecx,(%edx)
c01097e6:	8b 00                	mov    (%eax),%eax
c01097e8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01097ed:	5d                   	pop    %ebp
c01097ee:	c3                   	ret    

c01097ef <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01097ef:	55                   	push   %ebp
c01097f0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01097f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01097f6:	7e 14                	jle    c010980c <getint+0x1d>
        return va_arg(*ap, long long);
c01097f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01097fb:	8b 00                	mov    (%eax),%eax
c01097fd:	8d 48 08             	lea    0x8(%eax),%ecx
c0109800:	8b 55 08             	mov    0x8(%ebp),%edx
c0109803:	89 0a                	mov    %ecx,(%edx)
c0109805:	8b 50 04             	mov    0x4(%eax),%edx
c0109808:	8b 00                	mov    (%eax),%eax
c010980a:	eb 28                	jmp    c0109834 <getint+0x45>
    }
    else if (lflag) {
c010980c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109810:	74 12                	je     c0109824 <getint+0x35>
        return va_arg(*ap, long);
c0109812:	8b 45 08             	mov    0x8(%ebp),%eax
c0109815:	8b 00                	mov    (%eax),%eax
c0109817:	8d 48 04             	lea    0x4(%eax),%ecx
c010981a:	8b 55 08             	mov    0x8(%ebp),%edx
c010981d:	89 0a                	mov    %ecx,(%edx)
c010981f:	8b 00                	mov    (%eax),%eax
c0109821:	99                   	cltd   
c0109822:	eb 10                	jmp    c0109834 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109824:	8b 45 08             	mov    0x8(%ebp),%eax
c0109827:	8b 00                	mov    (%eax),%eax
c0109829:	8d 48 04             	lea    0x4(%eax),%ecx
c010982c:	8b 55 08             	mov    0x8(%ebp),%edx
c010982f:	89 0a                	mov    %ecx,(%edx)
c0109831:	8b 00                	mov    (%eax),%eax
c0109833:	99                   	cltd   
    }
}
c0109834:	5d                   	pop    %ebp
c0109835:	c3                   	ret    

c0109836 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109836:	55                   	push   %ebp
c0109837:	89 e5                	mov    %esp,%ebp
c0109839:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010983c:	8d 45 14             	lea    0x14(%ebp),%eax
c010983f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109842:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109845:	50                   	push   %eax
c0109846:	ff 75 10             	pushl  0x10(%ebp)
c0109849:	ff 75 0c             	pushl  0xc(%ebp)
c010984c:	ff 75 08             	pushl  0x8(%ebp)
c010984f:	e8 06 00 00 00       	call   c010985a <vprintfmt>
c0109854:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0109857:	90                   	nop
c0109858:	c9                   	leave  
c0109859:	c3                   	ret    

c010985a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010985a:	55                   	push   %ebp
c010985b:	89 e5                	mov    %esp,%ebp
c010985d:	56                   	push   %esi
c010985e:	53                   	push   %ebx
c010985f:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109862:	eb 17                	jmp    c010987b <vprintfmt+0x21>
            if (ch == '\0') {
c0109864:	85 db                	test   %ebx,%ebx
c0109866:	0f 84 8e 03 00 00    	je     c0109bfa <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c010986c:	83 ec 08             	sub    $0x8,%esp
c010986f:	ff 75 0c             	pushl  0xc(%ebp)
c0109872:	53                   	push   %ebx
c0109873:	8b 45 08             	mov    0x8(%ebp),%eax
c0109876:	ff d0                	call   *%eax
c0109878:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010987b:	8b 45 10             	mov    0x10(%ebp),%eax
c010987e:	8d 50 01             	lea    0x1(%eax),%edx
c0109881:	89 55 10             	mov    %edx,0x10(%ebp)
c0109884:	0f b6 00             	movzbl (%eax),%eax
c0109887:	0f b6 d8             	movzbl %al,%ebx
c010988a:	83 fb 25             	cmp    $0x25,%ebx
c010988d:	75 d5                	jne    c0109864 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010988f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0109893:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010989a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010989d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01098a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01098a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01098aa:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01098ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01098b0:	8d 50 01             	lea    0x1(%eax),%edx
c01098b3:	89 55 10             	mov    %edx,0x10(%ebp)
c01098b6:	0f b6 00             	movzbl (%eax),%eax
c01098b9:	0f b6 d8             	movzbl %al,%ebx
c01098bc:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01098bf:	83 f8 55             	cmp    $0x55,%eax
c01098c2:	0f 87 05 03 00 00    	ja     c0109bcd <vprintfmt+0x373>
c01098c8:	8b 04 85 a0 c1 10 c0 	mov    -0x3fef3e60(,%eax,4),%eax
c01098cf:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01098d1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01098d5:	eb d6                	jmp    c01098ad <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01098d7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01098db:	eb d0                	jmp    c01098ad <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01098dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01098e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01098e7:	89 d0                	mov    %edx,%eax
c01098e9:	c1 e0 02             	shl    $0x2,%eax
c01098ec:	01 d0                	add    %edx,%eax
c01098ee:	01 c0                	add    %eax,%eax
c01098f0:	01 d8                	add    %ebx,%eax
c01098f2:	83 e8 30             	sub    $0x30,%eax
c01098f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01098f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01098fb:	0f b6 00             	movzbl (%eax),%eax
c01098fe:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109901:	83 fb 2f             	cmp    $0x2f,%ebx
c0109904:	7e 39                	jle    c010993f <vprintfmt+0xe5>
c0109906:	83 fb 39             	cmp    $0x39,%ebx
c0109909:	7f 34                	jg     c010993f <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010990b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010990f:	eb d3                	jmp    c01098e4 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0109911:	8b 45 14             	mov    0x14(%ebp),%eax
c0109914:	8d 50 04             	lea    0x4(%eax),%edx
c0109917:	89 55 14             	mov    %edx,0x14(%ebp)
c010991a:	8b 00                	mov    (%eax),%eax
c010991c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010991f:	eb 1f                	jmp    c0109940 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0109921:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109925:	79 86                	jns    c01098ad <vprintfmt+0x53>
                width = 0;
c0109927:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010992e:	e9 7a ff ff ff       	jmp    c01098ad <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0109933:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010993a:	e9 6e ff ff ff       	jmp    c01098ad <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c010993f:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0109940:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109944:	0f 89 63 ff ff ff    	jns    c01098ad <vprintfmt+0x53>
                width = precision, precision = -1;
c010994a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010994d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109950:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109957:	e9 51 ff ff ff       	jmp    c01098ad <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010995c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0109960:	e9 48 ff ff ff       	jmp    c01098ad <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109965:	8b 45 14             	mov    0x14(%ebp),%eax
c0109968:	8d 50 04             	lea    0x4(%eax),%edx
c010996b:	89 55 14             	mov    %edx,0x14(%ebp)
c010996e:	8b 00                	mov    (%eax),%eax
c0109970:	83 ec 08             	sub    $0x8,%esp
c0109973:	ff 75 0c             	pushl  0xc(%ebp)
c0109976:	50                   	push   %eax
c0109977:	8b 45 08             	mov    0x8(%ebp),%eax
c010997a:	ff d0                	call   *%eax
c010997c:	83 c4 10             	add    $0x10,%esp
            break;
c010997f:	e9 71 02 00 00       	jmp    c0109bf5 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109984:	8b 45 14             	mov    0x14(%ebp),%eax
c0109987:	8d 50 04             	lea    0x4(%eax),%edx
c010998a:	89 55 14             	mov    %edx,0x14(%ebp)
c010998d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010998f:	85 db                	test   %ebx,%ebx
c0109991:	79 02                	jns    c0109995 <vprintfmt+0x13b>
                err = -err;
c0109993:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109995:	83 fb 06             	cmp    $0x6,%ebx
c0109998:	7f 0b                	jg     c01099a5 <vprintfmt+0x14b>
c010999a:	8b 34 9d 60 c1 10 c0 	mov    -0x3fef3ea0(,%ebx,4),%esi
c01099a1:	85 f6                	test   %esi,%esi
c01099a3:	75 19                	jne    c01099be <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c01099a5:	53                   	push   %ebx
c01099a6:	68 8d c1 10 c0       	push   $0xc010c18d
c01099ab:	ff 75 0c             	pushl  0xc(%ebp)
c01099ae:	ff 75 08             	pushl  0x8(%ebp)
c01099b1:	e8 80 fe ff ff       	call   c0109836 <printfmt>
c01099b6:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01099b9:	e9 37 02 00 00       	jmp    c0109bf5 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01099be:	56                   	push   %esi
c01099bf:	68 96 c1 10 c0       	push   $0xc010c196
c01099c4:	ff 75 0c             	pushl  0xc(%ebp)
c01099c7:	ff 75 08             	pushl  0x8(%ebp)
c01099ca:	e8 67 fe ff ff       	call   c0109836 <printfmt>
c01099cf:	83 c4 10             	add    $0x10,%esp
            }
            break;
c01099d2:	e9 1e 02 00 00       	jmp    c0109bf5 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01099d7:	8b 45 14             	mov    0x14(%ebp),%eax
c01099da:	8d 50 04             	lea    0x4(%eax),%edx
c01099dd:	89 55 14             	mov    %edx,0x14(%ebp)
c01099e0:	8b 30                	mov    (%eax),%esi
c01099e2:	85 f6                	test   %esi,%esi
c01099e4:	75 05                	jne    c01099eb <vprintfmt+0x191>
                p = "(null)";
c01099e6:	be 99 c1 10 c0       	mov    $0xc010c199,%esi
            }
            if (width > 0 && padc != '-') {
c01099eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01099ef:	7e 76                	jle    c0109a67 <vprintfmt+0x20d>
c01099f1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01099f5:	74 70                	je     c0109a67 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01099f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01099fa:	83 ec 08             	sub    $0x8,%esp
c01099fd:	50                   	push   %eax
c01099fe:	56                   	push   %esi
c01099ff:	e8 17 f8 ff ff       	call   c010921b <strnlen>
c0109a04:	83 c4 10             	add    $0x10,%esp
c0109a07:	89 c2                	mov    %eax,%edx
c0109a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109a0c:	29 d0                	sub    %edx,%eax
c0109a0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109a11:	eb 17                	jmp    c0109a2a <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0109a13:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109a17:	83 ec 08             	sub    $0x8,%esp
c0109a1a:	ff 75 0c             	pushl  0xc(%ebp)
c0109a1d:	50                   	push   %eax
c0109a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a21:	ff d0                	call   *%eax
c0109a23:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109a26:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109a2a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109a2e:	7f e3                	jg     c0109a13 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109a30:	eb 35                	jmp    c0109a67 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109a32:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109a36:	74 1c                	je     c0109a54 <vprintfmt+0x1fa>
c0109a38:	83 fb 1f             	cmp    $0x1f,%ebx
c0109a3b:	7e 05                	jle    c0109a42 <vprintfmt+0x1e8>
c0109a3d:	83 fb 7e             	cmp    $0x7e,%ebx
c0109a40:	7e 12                	jle    c0109a54 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0109a42:	83 ec 08             	sub    $0x8,%esp
c0109a45:	ff 75 0c             	pushl  0xc(%ebp)
c0109a48:	6a 3f                	push   $0x3f
c0109a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a4d:	ff d0                	call   *%eax
c0109a4f:	83 c4 10             	add    $0x10,%esp
c0109a52:	eb 0f                	jmp    c0109a63 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0109a54:	83 ec 08             	sub    $0x8,%esp
c0109a57:	ff 75 0c             	pushl  0xc(%ebp)
c0109a5a:	53                   	push   %ebx
c0109a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a5e:	ff d0                	call   *%eax
c0109a60:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109a63:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109a67:	89 f0                	mov    %esi,%eax
c0109a69:	8d 70 01             	lea    0x1(%eax),%esi
c0109a6c:	0f b6 00             	movzbl (%eax),%eax
c0109a6f:	0f be d8             	movsbl %al,%ebx
c0109a72:	85 db                	test   %ebx,%ebx
c0109a74:	74 26                	je     c0109a9c <vprintfmt+0x242>
c0109a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109a7a:	78 b6                	js     c0109a32 <vprintfmt+0x1d8>
c0109a7c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109a80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109a84:	79 ac                	jns    c0109a32 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109a86:	eb 14                	jmp    c0109a9c <vprintfmt+0x242>
                putch(' ', putdat);
c0109a88:	83 ec 08             	sub    $0x8,%esp
c0109a8b:	ff 75 0c             	pushl  0xc(%ebp)
c0109a8e:	6a 20                	push   $0x20
c0109a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a93:	ff d0                	call   *%eax
c0109a95:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109a98:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109a9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109aa0:	7f e6                	jg     c0109a88 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0109aa2:	e9 4e 01 00 00       	jmp    c0109bf5 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109aa7:	83 ec 08             	sub    $0x8,%esp
c0109aaa:	ff 75 e0             	pushl  -0x20(%ebp)
c0109aad:	8d 45 14             	lea    0x14(%ebp),%eax
c0109ab0:	50                   	push   %eax
c0109ab1:	e8 39 fd ff ff       	call   c01097ef <getint>
c0109ab6:	83 c4 10             	add    $0x10,%esp
c0109ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109abc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109ac5:	85 d2                	test   %edx,%edx
c0109ac7:	79 23                	jns    c0109aec <vprintfmt+0x292>
                putch('-', putdat);
c0109ac9:	83 ec 08             	sub    $0x8,%esp
c0109acc:	ff 75 0c             	pushl  0xc(%ebp)
c0109acf:	6a 2d                	push   $0x2d
c0109ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ad4:	ff d0                	call   *%eax
c0109ad6:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0109ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109adf:	f7 d8                	neg    %eax
c0109ae1:	83 d2 00             	adc    $0x0,%edx
c0109ae4:	f7 da                	neg    %edx
c0109ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109ae9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109aec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109af3:	e9 9f 00 00 00       	jmp    c0109b97 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109af8:	83 ec 08             	sub    $0x8,%esp
c0109afb:	ff 75 e0             	pushl  -0x20(%ebp)
c0109afe:	8d 45 14             	lea    0x14(%ebp),%eax
c0109b01:	50                   	push   %eax
c0109b02:	e8 99 fc ff ff       	call   c01097a0 <getuint>
c0109b07:	83 c4 10             	add    $0x10,%esp
c0109b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109b10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109b17:	eb 7e                	jmp    c0109b97 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109b19:	83 ec 08             	sub    $0x8,%esp
c0109b1c:	ff 75 e0             	pushl  -0x20(%ebp)
c0109b1f:	8d 45 14             	lea    0x14(%ebp),%eax
c0109b22:	50                   	push   %eax
c0109b23:	e8 78 fc ff ff       	call   c01097a0 <getuint>
c0109b28:	83 c4 10             	add    $0x10,%esp
c0109b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109b31:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109b38:	eb 5d                	jmp    c0109b97 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0109b3a:	83 ec 08             	sub    $0x8,%esp
c0109b3d:	ff 75 0c             	pushl  0xc(%ebp)
c0109b40:	6a 30                	push   $0x30
c0109b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b45:	ff d0                	call   *%eax
c0109b47:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0109b4a:	83 ec 08             	sub    $0x8,%esp
c0109b4d:	ff 75 0c             	pushl  0xc(%ebp)
c0109b50:	6a 78                	push   $0x78
c0109b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b55:	ff d0                	call   *%eax
c0109b57:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109b5a:	8b 45 14             	mov    0x14(%ebp),%eax
c0109b5d:	8d 50 04             	lea    0x4(%eax),%edx
c0109b60:	89 55 14             	mov    %edx,0x14(%ebp)
c0109b63:	8b 00                	mov    (%eax),%eax
c0109b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109b6f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109b76:	eb 1f                	jmp    c0109b97 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109b78:	83 ec 08             	sub    $0x8,%esp
c0109b7b:	ff 75 e0             	pushl  -0x20(%ebp)
c0109b7e:	8d 45 14             	lea    0x14(%ebp),%eax
c0109b81:	50                   	push   %eax
c0109b82:	e8 19 fc ff ff       	call   c01097a0 <getuint>
c0109b87:	83 c4 10             	add    $0x10,%esp
c0109b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109b90:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109b97:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b9e:	83 ec 04             	sub    $0x4,%esp
c0109ba1:	52                   	push   %edx
c0109ba2:	ff 75 e8             	pushl  -0x18(%ebp)
c0109ba5:	50                   	push   %eax
c0109ba6:	ff 75 f4             	pushl  -0xc(%ebp)
c0109ba9:	ff 75 f0             	pushl  -0x10(%ebp)
c0109bac:	ff 75 0c             	pushl  0xc(%ebp)
c0109baf:	ff 75 08             	pushl  0x8(%ebp)
c0109bb2:	e8 f8 fa ff ff       	call   c01096af <printnum>
c0109bb7:	83 c4 20             	add    $0x20,%esp
            break;
c0109bba:	eb 39                	jmp    c0109bf5 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109bbc:	83 ec 08             	sub    $0x8,%esp
c0109bbf:	ff 75 0c             	pushl  0xc(%ebp)
c0109bc2:	53                   	push   %ebx
c0109bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bc6:	ff d0                	call   *%eax
c0109bc8:	83 c4 10             	add    $0x10,%esp
            break;
c0109bcb:	eb 28                	jmp    c0109bf5 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109bcd:	83 ec 08             	sub    $0x8,%esp
c0109bd0:	ff 75 0c             	pushl  0xc(%ebp)
c0109bd3:	6a 25                	push   $0x25
c0109bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bd8:	ff d0                	call   *%eax
c0109bda:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109bdd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109be1:	eb 04                	jmp    c0109be7 <vprintfmt+0x38d>
c0109be3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109be7:	8b 45 10             	mov    0x10(%ebp),%eax
c0109bea:	83 e8 01             	sub    $0x1,%eax
c0109bed:	0f b6 00             	movzbl (%eax),%eax
c0109bf0:	3c 25                	cmp    $0x25,%al
c0109bf2:	75 ef                	jne    c0109be3 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0109bf4:	90                   	nop
        }
    }
c0109bf5:	e9 68 fc ff ff       	jmp    c0109862 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0109bfa:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109bfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0109bfe:	5b                   	pop    %ebx
c0109bff:	5e                   	pop    %esi
c0109c00:	5d                   	pop    %ebp
c0109c01:	c3                   	ret    

c0109c02 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109c02:	55                   	push   %ebp
c0109c03:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c08:	8b 40 08             	mov    0x8(%eax),%eax
c0109c0b:	8d 50 01             	lea    0x1(%eax),%edx
c0109c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c11:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109c14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c17:	8b 10                	mov    (%eax),%edx
c0109c19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c1c:	8b 40 04             	mov    0x4(%eax),%eax
c0109c1f:	39 c2                	cmp    %eax,%edx
c0109c21:	73 12                	jae    c0109c35 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109c23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c26:	8b 00                	mov    (%eax),%eax
c0109c28:	8d 48 01             	lea    0x1(%eax),%ecx
c0109c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109c2e:	89 0a                	mov    %ecx,(%edx)
c0109c30:	8b 55 08             	mov    0x8(%ebp),%edx
c0109c33:	88 10                	mov    %dl,(%eax)
    }
}
c0109c35:	90                   	nop
c0109c36:	5d                   	pop    %ebp
c0109c37:	c3                   	ret    

c0109c38 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109c38:	55                   	push   %ebp
c0109c39:	89 e5                	mov    %esp,%ebp
c0109c3b:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109c3e:	8d 45 14             	lea    0x14(%ebp),%eax
c0109c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c47:	50                   	push   %eax
c0109c48:	ff 75 10             	pushl  0x10(%ebp)
c0109c4b:	ff 75 0c             	pushl  0xc(%ebp)
c0109c4e:	ff 75 08             	pushl  0x8(%ebp)
c0109c51:	e8 0b 00 00 00       	call   c0109c61 <vsnprintf>
c0109c56:	83 c4 10             	add    $0x10,%esp
c0109c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109c5f:	c9                   	leave  
c0109c60:	c3                   	ret    

c0109c61 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109c61:	55                   	push   %ebp
c0109c62:	89 e5                	mov    %esp,%ebp
c0109c64:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c70:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c76:	01 d0                	add    %edx,%eax
c0109c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109c82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109c86:	74 0a                	je     c0109c92 <vsnprintf+0x31>
c0109c88:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c8e:	39 c2                	cmp    %eax,%edx
c0109c90:	76 07                	jbe    c0109c99 <vsnprintf+0x38>
        return -E_INVAL;
c0109c92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109c97:	eb 20                	jmp    c0109cb9 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109c99:	ff 75 14             	pushl  0x14(%ebp)
c0109c9c:	ff 75 10             	pushl  0x10(%ebp)
c0109c9f:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109ca2:	50                   	push   %eax
c0109ca3:	68 02 9c 10 c0       	push   $0xc0109c02
c0109ca8:	e8 ad fb ff ff       	call   c010985a <vprintfmt>
c0109cad:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0109cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109cb3:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109cb9:	c9                   	leave  
c0109cba:	c3                   	ret    

c0109cbb <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109cbb:	55                   	push   %ebp
c0109cbc:	89 e5                	mov    %esp,%ebp
c0109cbe:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c0109cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cc4:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109ccd:	b8 20 00 00 00       	mov    $0x20,%eax
c0109cd2:	2b 45 0c             	sub    0xc(%ebp),%eax
c0109cd5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109cd8:	89 c1                	mov    %eax,%ecx
c0109cda:	d3 ea                	shr    %cl,%edx
c0109cdc:	89 d0                	mov    %edx,%eax
}
c0109cde:	c9                   	leave  
c0109cdf:	c3                   	ret    

c0109ce0 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109ce0:	55                   	push   %ebp
c0109ce1:	89 e5                	mov    %esp,%ebp
c0109ce3:	57                   	push   %edi
c0109ce4:	56                   	push   %esi
c0109ce5:	53                   	push   %ebx
c0109ce6:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109ce9:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c0109cee:	8b 15 c4 6a 12 c0    	mov    0xc0126ac4,%edx
c0109cf4:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109cfa:	6b f0 05             	imul   $0x5,%eax,%esi
c0109cfd:	01 fe                	add    %edi,%esi
c0109cff:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0109d04:	f7 e7                	mul    %edi
c0109d06:	01 d6                	add    %edx,%esi
c0109d08:	89 f2                	mov    %esi,%edx
c0109d0a:	83 c0 0b             	add    $0xb,%eax
c0109d0d:	83 d2 00             	adc    $0x0,%edx
c0109d10:	89 c7                	mov    %eax,%edi
c0109d12:	83 e7 ff             	and    $0xffffffff,%edi
c0109d15:	89 f9                	mov    %edi,%ecx
c0109d17:	0f b7 da             	movzwl %dx,%ebx
c0109d1a:	89 0d c0 6a 12 c0    	mov    %ecx,0xc0126ac0
c0109d20:	89 1d c4 6a 12 c0    	mov    %ebx,0xc0126ac4
    unsigned long long result = (next >> 12);
c0109d26:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c0109d2b:	8b 15 c4 6a 12 c0    	mov    0xc0126ac4,%edx
c0109d31:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109d35:	c1 ea 0c             	shr    $0xc,%edx
c0109d38:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109d3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109d3e:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109d48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109d4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109d4e:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109d51:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d54:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109d57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109d5b:	74 1c                	je     c0109d79 <rand+0x99>
c0109d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d60:	ba 00 00 00 00       	mov    $0x0,%edx
c0109d65:	f7 75 dc             	divl   -0x24(%ebp)
c0109d68:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d6e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109d73:	f7 75 dc             	divl   -0x24(%ebp)
c0109d76:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109d79:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109d7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109d7f:	f7 75 dc             	divl   -0x24(%ebp)
c0109d82:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109d85:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109d8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109d8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109d91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109d94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109d97:	83 c4 24             	add    $0x24,%esp
c0109d9a:	5b                   	pop    %ebx
c0109d9b:	5e                   	pop    %esi
c0109d9c:	5f                   	pop    %edi
c0109d9d:	5d                   	pop    %ebp
c0109d9e:	c3                   	ret    

c0109d9f <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109d9f:	55                   	push   %ebp
c0109da0:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109da5:	ba 00 00 00 00       	mov    $0x0,%edx
c0109daa:	a3 c0 6a 12 c0       	mov    %eax,0xc0126ac0
c0109daf:	89 15 c4 6a 12 c0    	mov    %edx,0xc0126ac4
}
c0109db5:	90                   	nop
c0109db6:	5d                   	pop    %ebp
c0109db7:	c3                   	ret    
