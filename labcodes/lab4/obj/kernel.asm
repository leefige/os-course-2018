
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
c0100055:	e8 d8 92 00 00       	call   c0109332 <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 c8 1d 00 00       	call   c0101e2a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 e0 9b 10 c0 	movl   $0xc0109be0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 fc 9b 10 c0       	push   $0xc0109bfc
c0100074:	e8 19 02 00 00       	call   c0100292 <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 b0 08 00 00       	call   c0100931 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 8b 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 e3 74 00 00       	call   c010756e <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 0c 1f 00 00       	call   c0101f9c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 6d 20 00 00       	call   c0102102 <idt_init>

    vmm_init();                 // init virtual memory management
c0100095:	e8 53 3d 00 00       	call   c0103ded <vmm_init>
    proc_init();                // init process table
c010009a:	e8 61 8c 00 00       	call   c0108d00 <proc_init>
    
    ide_init();                 // init ide devices
c010009f:	e8 55 0d 00 00       	call   c0100df9 <ide_init>
    swap_init();                // init swap
c01000a4:	e8 26 52 00 00       	call   c01052cf <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 23 15 00 00       	call   c01015d1 <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 26 20 00 00       	call   c01020d9 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000b3:	e8 e8 8d 00 00       	call   c0108ea0 <cpu_idle>

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
c010015a:	68 01 9c 10 c0       	push   $0xc0109c01
c010015f:	e8 2e 01 00 00       	call   c0100292 <cprintf>
c0100164:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100167:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010016b:	0f b7 d0             	movzwl %ax,%edx
c010016e:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c0100173:	83 ec 04             	sub    $0x4,%esp
c0100176:	52                   	push   %edx
c0100177:	50                   	push   %eax
c0100178:	68 0f 9c 10 c0       	push   $0xc0109c0f
c010017d:	e8 10 01 00 00       	call   c0100292 <cprintf>
c0100182:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100189:	0f b7 d0             	movzwl %ax,%edx
c010018c:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c0100191:	83 ec 04             	sub    $0x4,%esp
c0100194:	52                   	push   %edx
c0100195:	50                   	push   %eax
c0100196:	68 1d 9c 10 c0       	push   $0xc0109c1d
c010019b:	e8 f2 00 00 00       	call   c0100292 <cprintf>
c01001a0:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c01001a3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a7:	0f b7 d0             	movzwl %ax,%edx
c01001aa:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c01001af:	83 ec 04             	sub    $0x4,%esp
c01001b2:	52                   	push   %edx
c01001b3:	50                   	push   %eax
c01001b4:	68 2b 9c 10 c0       	push   $0xc0109c2b
c01001b9:	e8 d4 00 00 00       	call   c0100292 <cprintf>
c01001be:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 00 90 12 c0       	mov    0xc0129000,%eax
c01001cd:	83 ec 04             	sub    $0x4,%esp
c01001d0:	52                   	push   %edx
c01001d1:	50                   	push   %eax
c01001d2:	68 39 9c 10 c0       	push   $0xc0109c39
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
c0100211:	68 48 9c 10 c0       	push   $0xc0109c48
c0100216:	e8 77 00 00 00       	call   c0100292 <cprintf>
c010021b:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c010021e:	e8 cc ff ff ff       	call   c01001ef <lab1_switch_to_user>
    lab1_print_cur_status();
c0100223:	e8 0a ff ff ff       	call   c0100132 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100228:	83 ec 0c             	sub    $0xc,%esp
c010022b:	68 68 9c 10 c0       	push   $0xc0109c68
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
c0100285:	e8 de 93 00 00       	call   c0109668 <vprintfmt>
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
c0100348:	68 87 9c 10 c0       	push   $0xc0109c87
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
c0100420:	68 8a 9c 10 c0       	push   $0xc0109c8a
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
c0100442:	68 a6 9c 10 c0       	push   $0xc0109ca6
c0100447:	e8 46 fe ff ff       	call   c0100292 <cprintf>
c010044c:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c010044f:	83 ec 0c             	sub    $0xc,%esp
c0100452:	68 a8 9c 10 c0       	push   $0xc0109ca8
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
c0100490:	68 ba 9c 10 c0       	push   $0xc0109cba
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
c01004b2:	68 a6 9c 10 c0       	push   $0xc0109ca6
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
c010062c:	c7 00 d8 9c 10 c0    	movl   $0xc0109cd8,(%eax)
    info->eip_line = 0;
c0100632:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010063c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063f:	c7 40 08 d8 9c 10 c0 	movl   $0xc0109cd8,0x8(%eax)
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
c0100663:	c7 45 f4 f8 c0 10 c0 	movl   $0xc010c0f8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010066a:	c7 45 f0 cc e5 11 c0 	movl   $0xc011e5cc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100671:	c7 45 ec cd e5 11 c0 	movl   $0xc011e5cd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100678:	c7 45 e8 f2 30 12 c0 	movl   $0xc01230f2,-0x18(%ebp)

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
c01007b2:	e8 ef 89 00 00       	call   c01091a6 <strfind>
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
c010093a:	68 e2 9c 10 c0       	push   $0xc0109ce2
c010093f:	e8 4e f9 ff ff       	call   c0100292 <cprintf>
c0100944:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100947:	83 ec 08             	sub    $0x8,%esp
c010094a:	68 36 00 10 c0       	push   $0xc0100036
c010094f:	68 fb 9c 10 c0       	push   $0xc0109cfb
c0100954:	e8 39 f9 ff ff       	call   c0100292 <cprintf>
c0100959:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010095c:	83 ec 08             	sub    $0x8,%esp
c010095f:	68 c6 9b 10 c0       	push   $0xc0109bc6
c0100964:	68 13 9d 10 c0       	push   $0xc0109d13
c0100969:	e8 24 f9 ff ff       	call   c0100292 <cprintf>
c010096e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100971:	83 ec 08             	sub    $0x8,%esp
c0100974:	68 00 90 12 c0       	push   $0xc0129000
c0100979:	68 2b 9d 10 c0       	push   $0xc0109d2b
c010097e:	e8 0f f9 ff ff       	call   c0100292 <cprintf>
c0100983:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100986:	83 ec 08             	sub    $0x8,%esp
c0100989:	68 a4 c1 12 c0       	push   $0xc012c1a4
c010098e:	68 43 9d 10 c0       	push   $0xc0109d43
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
c01009be:	68 5c 9d 10 c0       	push   $0xc0109d5c
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
c01009f3:	68 86 9d 10 c0       	push   $0xc0109d86
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
c0100a5a:	68 a2 9d 10 c0       	push   $0xc0109da2
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
c0100aaa:	68 b4 9d 10 c0       	push   $0xc0109db4
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
c0100af8:	68 cc 9d 10 c0       	push   $0xc0109dcc
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
c0100b79:	68 70 9e 10 c0       	push   $0xc0109e70
c0100b7e:	e8 f0 85 00 00       	call   c0109173 <strchr>
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
c0100b9f:	68 75 9e 10 c0       	push   $0xc0109e75
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
c0100be7:	68 70 9e 10 c0       	push   $0xc0109e70
c0100bec:	e8 82 85 00 00       	call   c0109173 <strchr>
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
c0100c52:	e8 7c 84 00 00       	call   c01090d3 <strcmp>
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
c0100c9f:	68 93 9e 10 c0       	push   $0xc0109e93
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
c0100cbc:	68 ac 9e 10 c0       	push   $0xc0109eac
c0100cc1:	e8 cc f5 ff ff       	call   c0100292 <cprintf>
c0100cc6:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100cc9:	83 ec 0c             	sub    $0xc,%esp
c0100ccc:	68 d4 9e 10 c0       	push   $0xc0109ed4
c0100cd1:	e8 bc f5 ff ff       	call   c0100292 <cprintf>
c0100cd6:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cdd:	74 0e                	je     c0100ced <kmonitor+0x3a>
        print_trapframe(tf);
c0100cdf:	83 ec 0c             	sub    $0xc,%esp
c0100ce2:	ff 75 08             	pushl  0x8(%ebp)
c0100ce5:	e8 d0 15 00 00       	call   c01022ba <print_trapframe>
c0100cea:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100ced:	83 ec 0c             	sub    $0xc,%esp
c0100cf0:	68 f9 9e 10 c0       	push   $0xc0109ef9
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
c0100d5b:	68 fd 9e 10 c0       	push   $0xc0109efd
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
c0100e33:	0f b7 04 85 08 9f 10 	movzwl -0x3fef60f8(,%eax,4),%eax
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
c0100fc0:	68 10 9f 10 c0       	push   $0xc0109f10
c0100fc5:	68 53 9f 10 c0       	push   $0xc0109f53
c0100fca:	6a 7d                	push   $0x7d
c0100fcc:	68 68 9f 10 c0       	push   $0xc0109f68
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
c01010b5:	68 7a 9f 10 c0       	push   $0xc0109f7a
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
c01011ba:	68 98 9f 10 c0       	push   $0xc0109f98
c01011bf:	68 53 9f 10 c0       	push   $0xc0109f53
c01011c4:	68 9f 00 00 00       	push   $0x9f
c01011c9:	68 68 9f 10 c0       	push   $0xc0109f68
c01011ce:	e8 25 f2 ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011d3:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01011da:	77 0f                	ja     c01011eb <ide_read_secs+0x6e>
c01011dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01011df:	8b 45 14             	mov    0x14(%ebp),%eax
c01011e2:	01 d0                	add    %edx,%eax
c01011e4:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01011e9:	76 19                	jbe    c0101204 <ide_read_secs+0x87>
c01011eb:	68 c0 9f 10 c0       	push   $0xc0109fc0
c01011f0:	68 53 9f 10 c0       	push   $0xc0109f53
c01011f5:	68 a0 00 00 00       	push   $0xa0
c01011fa:	68 68 9f 10 c0       	push   $0xc0109f68
c01011ff:	e8 f4 f1 ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101204:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101208:	66 d1 e8             	shr    %ax
c010120b:	0f b7 c0             	movzwl %ax,%eax
c010120e:	0f b7 04 85 08 9f 10 	movzwl -0x3fef60f8(,%eax,4),%eax
c0101215:	c0 
c0101216:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010121a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010121e:	66 d1 e8             	shr    %ax
c0101221:	0f b7 c0             	movzwl %ax,%eax
c0101224:	0f b7 04 85 0a 9f 10 	movzwl -0x3fef60f6(,%eax,4),%eax
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
c01013e4:	68 98 9f 10 c0       	push   $0xc0109f98
c01013e9:	68 53 9f 10 c0       	push   $0xc0109f53
c01013ee:	68 bc 00 00 00       	push   $0xbc
c01013f3:	68 68 9f 10 c0       	push   $0xc0109f68
c01013f8:	e8 fb ef ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01013fd:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101404:	77 0f                	ja     c0101415 <ide_write_secs+0x6e>
c0101406:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101409:	8b 45 14             	mov    0x14(%ebp),%eax
c010140c:	01 d0                	add    %edx,%eax
c010140e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101413:	76 19                	jbe    c010142e <ide_write_secs+0x87>
c0101415:	68 c0 9f 10 c0       	push   $0xc0109fc0
c010141a:	68 53 9f 10 c0       	push   $0xc0109f53
c010141f:	68 bd 00 00 00       	push   $0xbd
c0101424:	68 68 9f 10 c0       	push   $0xc0109f68
c0101429:	e8 ca ef ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010142e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101432:	66 d1 e8             	shr    %ax
c0101435:	0f b7 c0             	movzwl %ax,%eax
c0101438:	0f b7 04 85 08 9f 10 	movzwl -0x3fef60f8(,%eax,4),%eax
c010143f:	c0 
c0101440:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101444:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101448:	66 d1 e8             	shr    %ax
c010144b:	0f b7 c0             	movzwl %ax,%eax
c010144e:	0f b7 04 85 0a 9f 10 	movzwl -0x3fef60f6(,%eax,4),%eax
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
c010161d:	68 fa 9f 10 c0       	push   $0xc0109ffa
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
c0101a46:	e8 27 79 00 00       	call   c0109372 <memmove>
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
c0101dd1:	68 15 a0 10 c0       	push   $0xc010a015
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
c0101e4b:	68 21 a0 10 c0       	push   $0xc010a021
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
c01020f2:	68 40 a0 10 c0       	push   $0xc010a040
c01020f7:	e8 96 e1 ff ff       	call   c0100292 <cprintf>
c01020fc:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01020ff:	90                   	nop
c0102100:	c9                   	leave  
c0102101:	c3                   	ret    

c0102102 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102102:	55                   	push   %ebp
c0102103:	89 e5                	mov    %esp,%ebp
c0102105:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c0102108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010210f:	e9 c3 00 00 00       	jmp    c01021d7 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102114:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102117:	8b 04 85 e0 65 12 c0 	mov    -0x3fed9a20(,%eax,4),%eax
c010211e:	89 c2                	mov    %eax,%edx
c0102120:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102123:	66 89 14 c5 60 97 12 	mov    %dx,-0x3fed68a0(,%eax,8)
c010212a:	c0 
c010212b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010212e:	66 c7 04 c5 62 97 12 	movw   $0x8,-0x3fed689e(,%eax,8)
c0102135:	c0 08 00 
c0102138:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213b:	0f b6 14 c5 64 97 12 	movzbl -0x3fed689c(,%eax,8),%edx
c0102142:	c0 
c0102143:	83 e2 e0             	and    $0xffffffe0,%edx
c0102146:	88 14 c5 64 97 12 c0 	mov    %dl,-0x3fed689c(,%eax,8)
c010214d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102150:	0f b6 14 c5 64 97 12 	movzbl -0x3fed689c(,%eax,8),%edx
c0102157:	c0 
c0102158:	83 e2 1f             	and    $0x1f,%edx
c010215b:	88 14 c5 64 97 12 c0 	mov    %dl,-0x3fed689c(,%eax,8)
c0102162:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102165:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c010216c:	c0 
c010216d:	83 e2 f0             	and    $0xfffffff0,%edx
c0102170:	83 ca 0e             	or     $0xe,%edx
c0102173:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c010217a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217d:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c0102184:	c0 
c0102185:	83 e2 ef             	and    $0xffffffef,%edx
c0102188:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c010218f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102192:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c0102199:	c0 
c010219a:	83 e2 9f             	and    $0xffffff9f,%edx
c010219d:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c01021a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a7:	0f b6 14 c5 65 97 12 	movzbl -0x3fed689b(,%eax,8),%edx
c01021ae:	c0 
c01021af:	83 ca 80             	or     $0xffffff80,%edx
c01021b2:	88 14 c5 65 97 12 c0 	mov    %dl,-0x3fed689b(,%eax,8)
c01021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bc:	8b 04 85 e0 65 12 c0 	mov    -0x3fed9a20(,%eax,4),%eax
c01021c3:	c1 e8 10             	shr    $0x10,%eax
c01021c6:	89 c2                	mov    %eax,%edx
c01021c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021cb:	66 89 14 c5 66 97 12 	mov    %dx,-0x3fed689a(,%eax,8)
c01021d2:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c01021d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021d7:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01021de:	0f 8e 30 ff ff ff    	jle    c0102114 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01021e4:	a1 c4 67 12 c0       	mov    0xc01267c4,%eax
c01021e9:	66 a3 28 9b 12 c0    	mov    %ax,0xc0129b28
c01021ef:	66 c7 05 2a 9b 12 c0 	movw   $0x8,0xc0129b2a
c01021f6:	08 00 
c01021f8:	0f b6 05 2c 9b 12 c0 	movzbl 0xc0129b2c,%eax
c01021ff:	83 e0 e0             	and    $0xffffffe0,%eax
c0102202:	a2 2c 9b 12 c0       	mov    %al,0xc0129b2c
c0102207:	0f b6 05 2c 9b 12 c0 	movzbl 0xc0129b2c,%eax
c010220e:	83 e0 1f             	and    $0x1f,%eax
c0102211:	a2 2c 9b 12 c0       	mov    %al,0xc0129b2c
c0102216:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c010221d:	83 e0 f0             	and    $0xfffffff0,%eax
c0102220:	83 c8 0e             	or     $0xe,%eax
c0102223:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102228:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c010222f:	83 e0 ef             	and    $0xffffffef,%eax
c0102232:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102237:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c010223e:	83 c8 60             	or     $0x60,%eax
c0102241:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102246:	0f b6 05 2d 9b 12 c0 	movzbl 0xc0129b2d,%eax
c010224d:	83 c8 80             	or     $0xffffff80,%eax
c0102250:	a2 2d 9b 12 c0       	mov    %al,0xc0129b2d
c0102255:	a1 c4 67 12 c0       	mov    0xc01267c4,%eax
c010225a:	c1 e8 10             	shr    $0x10,%eax
c010225d:	66 a3 2e 9b 12 c0    	mov    %ax,0xc0129b2e
c0102263:	c7 45 f8 60 65 12 c0 	movl   $0xc0126560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010226a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010226d:	0f 01 18             	lidtl  (%eax)
    // 3. LIDT
    lidt(&idt_pd);
}
c0102270:	90                   	nop
c0102271:	c9                   	leave  
c0102272:	c3                   	ret    

c0102273 <trapname>:

static const char *
trapname(int trapno) {
c0102273:	55                   	push   %ebp
c0102274:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102276:	8b 45 08             	mov    0x8(%ebp),%eax
c0102279:	83 f8 13             	cmp    $0x13,%eax
c010227c:	77 0c                	ja     c010228a <trapname+0x17>
        return excnames[trapno];
c010227e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102281:	8b 04 85 00 a4 10 c0 	mov    -0x3fef5c00(,%eax,4),%eax
c0102288:	eb 18                	jmp    c01022a2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010228a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010228e:	7e 0d                	jle    c010229d <trapname+0x2a>
c0102290:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102294:	7f 07                	jg     c010229d <trapname+0x2a>
        return "Hardware Interrupt";
c0102296:	b8 4a a0 10 c0       	mov    $0xc010a04a,%eax
c010229b:	eb 05                	jmp    c01022a2 <trapname+0x2f>
    }
    return "(unknown trap)";
c010229d:	b8 5d a0 10 c0       	mov    $0xc010a05d,%eax
}
c01022a2:	5d                   	pop    %ebp
c01022a3:	c3                   	ret    

c01022a4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022a4:	55                   	push   %ebp
c01022a5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01022aa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022ae:	66 83 f8 08          	cmp    $0x8,%ax
c01022b2:	0f 94 c0             	sete   %al
c01022b5:	0f b6 c0             	movzbl %al,%eax
}
c01022b8:	5d                   	pop    %ebp
c01022b9:	c3                   	ret    

c01022ba <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022ba:	55                   	push   %ebp
c01022bb:	89 e5                	mov    %esp,%ebp
c01022bd:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c01022c0:	83 ec 08             	sub    $0x8,%esp
c01022c3:	ff 75 08             	pushl  0x8(%ebp)
c01022c6:	68 9e a0 10 c0       	push   $0xc010a09e
c01022cb:	e8 c2 df ff ff       	call   c0100292 <cprintf>
c01022d0:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c01022d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d6:	83 ec 0c             	sub    $0xc,%esp
c01022d9:	50                   	push   %eax
c01022da:	e8 b8 01 00 00       	call   c0102497 <print_regs>
c01022df:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022e9:	0f b7 c0             	movzwl %ax,%eax
c01022ec:	83 ec 08             	sub    $0x8,%esp
c01022ef:	50                   	push   %eax
c01022f0:	68 af a0 10 c0       	push   $0xc010a0af
c01022f5:	e8 98 df ff ff       	call   c0100292 <cprintf>
c01022fa:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102300:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102304:	0f b7 c0             	movzwl %ax,%eax
c0102307:	83 ec 08             	sub    $0x8,%esp
c010230a:	50                   	push   %eax
c010230b:	68 c2 a0 10 c0       	push   $0xc010a0c2
c0102310:	e8 7d df ff ff       	call   c0100292 <cprintf>
c0102315:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102318:	8b 45 08             	mov    0x8(%ebp),%eax
c010231b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010231f:	0f b7 c0             	movzwl %ax,%eax
c0102322:	83 ec 08             	sub    $0x8,%esp
c0102325:	50                   	push   %eax
c0102326:	68 d5 a0 10 c0       	push   $0xc010a0d5
c010232b:	e8 62 df ff ff       	call   c0100292 <cprintf>
c0102330:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102333:	8b 45 08             	mov    0x8(%ebp),%eax
c0102336:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010233a:	0f b7 c0             	movzwl %ax,%eax
c010233d:	83 ec 08             	sub    $0x8,%esp
c0102340:	50                   	push   %eax
c0102341:	68 e8 a0 10 c0       	push   $0xc010a0e8
c0102346:	e8 47 df ff ff       	call   c0100292 <cprintf>
c010234b:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010234e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102351:	8b 40 30             	mov    0x30(%eax),%eax
c0102354:	83 ec 0c             	sub    $0xc,%esp
c0102357:	50                   	push   %eax
c0102358:	e8 16 ff ff ff       	call   c0102273 <trapname>
c010235d:	83 c4 10             	add    $0x10,%esp
c0102360:	89 c2                	mov    %eax,%edx
c0102362:	8b 45 08             	mov    0x8(%ebp),%eax
c0102365:	8b 40 30             	mov    0x30(%eax),%eax
c0102368:	83 ec 04             	sub    $0x4,%esp
c010236b:	52                   	push   %edx
c010236c:	50                   	push   %eax
c010236d:	68 fb a0 10 c0       	push   $0xc010a0fb
c0102372:	e8 1b df ff ff       	call   c0100292 <cprintf>
c0102377:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c010237a:	8b 45 08             	mov    0x8(%ebp),%eax
c010237d:	8b 40 34             	mov    0x34(%eax),%eax
c0102380:	83 ec 08             	sub    $0x8,%esp
c0102383:	50                   	push   %eax
c0102384:	68 0d a1 10 c0       	push   $0xc010a10d
c0102389:	e8 04 df ff ff       	call   c0100292 <cprintf>
c010238e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102391:	8b 45 08             	mov    0x8(%ebp),%eax
c0102394:	8b 40 38             	mov    0x38(%eax),%eax
c0102397:	83 ec 08             	sub    $0x8,%esp
c010239a:	50                   	push   %eax
c010239b:	68 1c a1 10 c0       	push   $0xc010a11c
c01023a0:	e8 ed de ff ff       	call   c0100292 <cprintf>
c01023a5:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ab:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023af:	0f b7 c0             	movzwl %ax,%eax
c01023b2:	83 ec 08             	sub    $0x8,%esp
c01023b5:	50                   	push   %eax
c01023b6:	68 2b a1 10 c0       	push   $0xc010a12b
c01023bb:	e8 d2 de ff ff       	call   c0100292 <cprintf>
c01023c0:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c6:	8b 40 40             	mov    0x40(%eax),%eax
c01023c9:	83 ec 08             	sub    $0x8,%esp
c01023cc:	50                   	push   %eax
c01023cd:	68 3e a1 10 c0       	push   $0xc010a13e
c01023d2:	e8 bb de ff ff       	call   c0100292 <cprintf>
c01023d7:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023e8:	eb 3f                	jmp    c0102429 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ed:	8b 50 40             	mov    0x40(%eax),%edx
c01023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023f3:	21 d0                	and    %edx,%eax
c01023f5:	85 c0                	test   %eax,%eax
c01023f7:	74 29                	je     c0102422 <print_trapframe+0x168>
c01023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023fc:	8b 04 85 80 65 12 c0 	mov    -0x3fed9a80(,%eax,4),%eax
c0102403:	85 c0                	test   %eax,%eax
c0102405:	74 1b                	je     c0102422 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0102407:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010240a:	8b 04 85 80 65 12 c0 	mov    -0x3fed9a80(,%eax,4),%eax
c0102411:	83 ec 08             	sub    $0x8,%esp
c0102414:	50                   	push   %eax
c0102415:	68 4d a1 10 c0       	push   $0xc010a14d
c010241a:	e8 73 de ff ff       	call   c0100292 <cprintf>
c010241f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102422:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102426:	d1 65 f0             	shll   -0x10(%ebp)
c0102429:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010242c:	83 f8 17             	cmp    $0x17,%eax
c010242f:	76 b9                	jbe    c01023ea <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102431:	8b 45 08             	mov    0x8(%ebp),%eax
c0102434:	8b 40 40             	mov    0x40(%eax),%eax
c0102437:	25 00 30 00 00       	and    $0x3000,%eax
c010243c:	c1 e8 0c             	shr    $0xc,%eax
c010243f:	83 ec 08             	sub    $0x8,%esp
c0102442:	50                   	push   %eax
c0102443:	68 51 a1 10 c0       	push   $0xc010a151
c0102448:	e8 45 de ff ff       	call   c0100292 <cprintf>
c010244d:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0102450:	83 ec 0c             	sub    $0xc,%esp
c0102453:	ff 75 08             	pushl  0x8(%ebp)
c0102456:	e8 49 fe ff ff       	call   c01022a4 <trap_in_kernel>
c010245b:	83 c4 10             	add    $0x10,%esp
c010245e:	85 c0                	test   %eax,%eax
c0102460:	75 32                	jne    c0102494 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102462:	8b 45 08             	mov    0x8(%ebp),%eax
c0102465:	8b 40 44             	mov    0x44(%eax),%eax
c0102468:	83 ec 08             	sub    $0x8,%esp
c010246b:	50                   	push   %eax
c010246c:	68 5a a1 10 c0       	push   $0xc010a15a
c0102471:	e8 1c de ff ff       	call   c0100292 <cprintf>
c0102476:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102479:	8b 45 08             	mov    0x8(%ebp),%eax
c010247c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102480:	0f b7 c0             	movzwl %ax,%eax
c0102483:	83 ec 08             	sub    $0x8,%esp
c0102486:	50                   	push   %eax
c0102487:	68 69 a1 10 c0       	push   $0xc010a169
c010248c:	e8 01 de ff ff       	call   c0100292 <cprintf>
c0102491:	83 c4 10             	add    $0x10,%esp
    }
}
c0102494:	90                   	nop
c0102495:	c9                   	leave  
c0102496:	c3                   	ret    

c0102497 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102497:	55                   	push   %ebp
c0102498:	89 e5                	mov    %esp,%ebp
c010249a:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010249d:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a0:	8b 00                	mov    (%eax),%eax
c01024a2:	83 ec 08             	sub    $0x8,%esp
c01024a5:	50                   	push   %eax
c01024a6:	68 7c a1 10 c0       	push   $0xc010a17c
c01024ab:	e8 e2 dd ff ff       	call   c0100292 <cprintf>
c01024b0:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b6:	8b 40 04             	mov    0x4(%eax),%eax
c01024b9:	83 ec 08             	sub    $0x8,%esp
c01024bc:	50                   	push   %eax
c01024bd:	68 8b a1 10 c0       	push   $0xc010a18b
c01024c2:	e8 cb dd ff ff       	call   c0100292 <cprintf>
c01024c7:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01024cd:	8b 40 08             	mov    0x8(%eax),%eax
c01024d0:	83 ec 08             	sub    $0x8,%esp
c01024d3:	50                   	push   %eax
c01024d4:	68 9a a1 10 c0       	push   $0xc010a19a
c01024d9:	e8 b4 dd ff ff       	call   c0100292 <cprintf>
c01024de:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e4:	8b 40 0c             	mov    0xc(%eax),%eax
c01024e7:	83 ec 08             	sub    $0x8,%esp
c01024ea:	50                   	push   %eax
c01024eb:	68 a9 a1 10 c0       	push   $0xc010a1a9
c01024f0:	e8 9d dd ff ff       	call   c0100292 <cprintf>
c01024f5:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01024fb:	8b 40 10             	mov    0x10(%eax),%eax
c01024fe:	83 ec 08             	sub    $0x8,%esp
c0102501:	50                   	push   %eax
c0102502:	68 b8 a1 10 c0       	push   $0xc010a1b8
c0102507:	e8 86 dd ff ff       	call   c0100292 <cprintf>
c010250c:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010250f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102512:	8b 40 14             	mov    0x14(%eax),%eax
c0102515:	83 ec 08             	sub    $0x8,%esp
c0102518:	50                   	push   %eax
c0102519:	68 c7 a1 10 c0       	push   $0xc010a1c7
c010251e:	e8 6f dd ff ff       	call   c0100292 <cprintf>
c0102523:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102526:	8b 45 08             	mov    0x8(%ebp),%eax
c0102529:	8b 40 18             	mov    0x18(%eax),%eax
c010252c:	83 ec 08             	sub    $0x8,%esp
c010252f:	50                   	push   %eax
c0102530:	68 d6 a1 10 c0       	push   $0xc010a1d6
c0102535:	e8 58 dd ff ff       	call   c0100292 <cprintf>
c010253a:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010253d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102540:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102543:	83 ec 08             	sub    $0x8,%esp
c0102546:	50                   	push   %eax
c0102547:	68 e5 a1 10 c0       	push   $0xc010a1e5
c010254c:	e8 41 dd ff ff       	call   c0100292 <cprintf>
c0102551:	83 c4 10             	add    $0x10,%esp
}
c0102554:	90                   	nop
c0102555:	c9                   	leave  
c0102556:	c3                   	ret    

c0102557 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102557:	55                   	push   %ebp
c0102558:	89 e5                	mov    %esp,%ebp
c010255a:	53                   	push   %ebx
c010255b:	83 ec 14             	sub    $0x14,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010255e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102561:	8b 40 34             	mov    0x34(%eax),%eax
c0102564:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102567:	85 c0                	test   %eax,%eax
c0102569:	74 07                	je     c0102572 <print_pgfault+0x1b>
c010256b:	bb f4 a1 10 c0       	mov    $0xc010a1f4,%ebx
c0102570:	eb 05                	jmp    c0102577 <print_pgfault+0x20>
c0102572:	bb 05 a2 10 c0       	mov    $0xc010a205,%ebx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102577:	8b 45 08             	mov    0x8(%ebp),%eax
c010257a:	8b 40 34             	mov    0x34(%eax),%eax
c010257d:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102580:	85 c0                	test   %eax,%eax
c0102582:	74 07                	je     c010258b <print_pgfault+0x34>
c0102584:	b9 57 00 00 00       	mov    $0x57,%ecx
c0102589:	eb 05                	jmp    c0102590 <print_pgfault+0x39>
c010258b:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102590:	8b 45 08             	mov    0x8(%ebp),%eax
c0102593:	8b 40 34             	mov    0x34(%eax),%eax
c0102596:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102599:	85 c0                	test   %eax,%eax
c010259b:	74 07                	je     c01025a4 <print_pgfault+0x4d>
c010259d:	ba 55 00 00 00       	mov    $0x55,%edx
c01025a2:	eb 05                	jmp    c01025a9 <print_pgfault+0x52>
c01025a4:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025a9:	0f 20 d0             	mov    %cr2,%eax
c01025ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025b2:	83 ec 0c             	sub    $0xc,%esp
c01025b5:	53                   	push   %ebx
c01025b6:	51                   	push   %ecx
c01025b7:	52                   	push   %edx
c01025b8:	50                   	push   %eax
c01025b9:	68 14 a2 10 c0       	push   $0xc010a214
c01025be:	e8 cf dc ff ff       	call   c0100292 <cprintf>
c01025c3:	83 c4 20             	add    $0x20,%esp
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025c6:	90                   	nop
c01025c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01025ca:	c9                   	leave  
c01025cb:	c3                   	ret    

c01025cc <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025cc:	55                   	push   %ebp
c01025cd:	89 e5                	mov    %esp,%ebp
c01025cf:	83 ec 18             	sub    $0x18,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025d2:	83 ec 0c             	sub    $0xc,%esp
c01025d5:	ff 75 08             	pushl  0x8(%ebp)
c01025d8:	e8 7a ff ff ff       	call   c0102557 <print_pgfault>
c01025dd:	83 c4 10             	add    $0x10,%esp
    if (check_mm_struct != NULL) {
c01025e0:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c01025e5:	85 c0                	test   %eax,%eax
c01025e7:	74 24                	je     c010260d <pgfault_handler+0x41>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025e9:	0f 20 d0             	mov    %cr2,%eax
c01025ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025ef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f5:	8b 50 34             	mov    0x34(%eax),%edx
c01025f8:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c01025fd:	83 ec 04             	sub    $0x4,%esp
c0102600:	51                   	push   %ecx
c0102601:	52                   	push   %edx
c0102602:	50                   	push   %eax
c0102603:	e8 20 1e 00 00       	call   c0104428 <do_pgfault>
c0102608:	83 c4 10             	add    $0x10,%esp
c010260b:	eb 17                	jmp    c0102624 <pgfault_handler+0x58>
    }
    panic("unhandled page fault.\n");
c010260d:	83 ec 04             	sub    $0x4,%esp
c0102610:	68 37 a2 10 c0       	push   $0xc010a237
c0102615:	68 a9 00 00 00       	push   $0xa9
c010261a:	68 4e a2 10 c0       	push   $0xc010a24e
c010261f:	e8 d4 dd ff ff       	call   c01003f8 <__panic>
}
c0102624:	c9                   	leave  
c0102625:	c3                   	ret    

c0102626 <trap_dispatch>:
// LAB1 YOU SHOULD ALSO COPY THIS
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

static void
trap_dispatch(struct trapframe *tf) {
c0102626:	55                   	push   %ebp
c0102627:	89 e5                	mov    %esp,%ebp
c0102629:	57                   	push   %edi
c010262a:	56                   	push   %esi
c010262b:	53                   	push   %ebx
c010262c:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010262f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102632:	8b 40 30             	mov    0x30(%eax),%eax
c0102635:	83 f8 24             	cmp    $0x24,%eax
c0102638:	0f 84 c8 00 00 00    	je     c0102706 <trap_dispatch+0xe0>
c010263e:	83 f8 24             	cmp    $0x24,%eax
c0102641:	77 1c                	ja     c010265f <trap_dispatch+0x39>
c0102643:	83 f8 20             	cmp    $0x20,%eax
c0102646:	0f 84 80 00 00 00    	je     c01026cc <trap_dispatch+0xa6>
c010264c:	83 f8 21             	cmp    $0x21,%eax
c010264f:	0f 84 d8 00 00 00    	je     c010272d <trap_dispatch+0x107>
c0102655:	83 f8 0e             	cmp    $0xe,%eax
c0102658:	74 32                	je     c010268c <trap_dispatch+0x66>
c010265a:	e9 98 01 00 00       	jmp    c01027f7 <trap_dispatch+0x1d1>
c010265f:	83 f8 78             	cmp    $0x78,%eax
c0102662:	0f 84 ec 00 00 00    	je     c0102754 <trap_dispatch+0x12e>
c0102668:	83 f8 78             	cmp    $0x78,%eax
c010266b:	77 11                	ja     c010267e <trap_dispatch+0x58>
c010266d:	83 e8 2e             	sub    $0x2e,%eax
c0102670:	83 f8 01             	cmp    $0x1,%eax
c0102673:	0f 87 7e 01 00 00    	ja     c01027f7 <trap_dispatch+0x1d1>
    // end of copy

    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102679:	e9 b3 01 00 00       	jmp    c0102831 <trap_dispatch+0x20b>
trap_dispatch(struct trapframe *tf) {
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010267e:	83 f8 79             	cmp    $0x79,%eax
c0102681:	0f 84 42 01 00 00    	je     c01027c9 <trap_dispatch+0x1a3>
c0102687:	e9 6b 01 00 00       	jmp    c01027f7 <trap_dispatch+0x1d1>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c010268c:	83 ec 0c             	sub    $0xc,%esp
c010268f:	ff 75 08             	pushl  0x8(%ebp)
c0102692:	e8 35 ff ff ff       	call   c01025cc <pgfault_handler>
c0102697:	83 c4 10             	add    $0x10,%esp
c010269a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010269d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01026a1:	0f 84 86 01 00 00    	je     c010282d <trap_dispatch+0x207>
            print_trapframe(tf);
c01026a7:	83 ec 0c             	sub    $0xc,%esp
c01026aa:	ff 75 08             	pushl  0x8(%ebp)
c01026ad:	e8 08 fc ff ff       	call   c01022ba <print_trapframe>
c01026b2:	83 c4 10             	add    $0x10,%esp
            panic("handle pgfault failed. %e\n", ret);
c01026b5:	ff 75 e4             	pushl  -0x1c(%ebp)
c01026b8:	68 5f a2 10 c0       	push   $0xc010a25f
c01026bd:	68 bd 00 00 00       	push   $0xbd
c01026c2:	68 4e a2 10 c0       	push   $0xc010a24e
c01026c7:	e8 2c dd ff ff       	call   c01003f8 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c01026cc:	a1 54 c0 12 c0       	mov    0xc012c054,%eax
c01026d1:	83 c0 01             	add    $0x1,%eax
c01026d4:	a3 54 c0 12 c0       	mov    %eax,0xc012c054
        if (ticks % TICK_NUM == 0) {
c01026d9:	8b 0d 54 c0 12 c0    	mov    0xc012c054,%ecx
c01026df:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01026e4:	89 c8                	mov    %ecx,%eax
c01026e6:	f7 e2                	mul    %edx
c01026e8:	89 d0                	mov    %edx,%eax
c01026ea:	c1 e8 05             	shr    $0x5,%eax
c01026ed:	6b c0 64             	imul   $0x64,%eax,%eax
c01026f0:	29 c1                	sub    %eax,%ecx
c01026f2:	89 c8                	mov    %ecx,%eax
c01026f4:	85 c0                	test   %eax,%eax
c01026f6:	0f 85 34 01 00 00    	jne    c0102830 <trap_dispatch+0x20a>
            print_ticks();
c01026fc:	e8 e6 f9 ff ff       	call   c01020e7 <print_ticks>
        }
        break;
c0102701:	e9 2a 01 00 00       	jmp    c0102830 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102706:	e8 99 f7 ff ff       	call   c0101ea4 <cons_getc>
c010270b:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010270e:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c0102712:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c0102716:	83 ec 04             	sub    $0x4,%esp
c0102719:	52                   	push   %edx
c010271a:	50                   	push   %eax
c010271b:	68 7a a2 10 c0       	push   $0xc010a27a
c0102720:	e8 6d db ff ff       	call   c0100292 <cprintf>
c0102725:	83 c4 10             	add    $0x10,%esp
        break;
c0102728:	e9 04 01 00 00       	jmp    c0102831 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010272d:	e8 72 f7 ff ff       	call   c0101ea4 <cons_getc>
c0102732:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102735:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c0102739:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c010273d:	83 ec 04             	sub    $0x4,%esp
c0102740:	52                   	push   %edx
c0102741:	50                   	push   %eax
c0102742:	68 8c a2 10 c0       	push   $0xc010a28c
c0102747:	e8 46 db ff ff       	call   c0100292 <cprintf>
c010274c:	83 c4 10             	add    $0x10,%esp
        break;
c010274f:	e9 dd 00 00 00       	jmp    c0102831 <trap_dispatch+0x20b>
        
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
c0102754:	8b 55 08             	mov    0x8(%ebp),%edx
c0102757:	b8 60 c0 12 c0       	mov    $0xc012c060,%eax
c010275c:	89 d3                	mov    %edx,%ebx
c010275e:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0102763:	8b 0b                	mov    (%ebx),%ecx
c0102765:	89 08                	mov    %ecx,(%eax)
c0102767:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c010276b:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c010276f:	8d 78 04             	lea    0x4(%eax),%edi
c0102772:	83 e7 fc             	and    $0xfffffffc,%edi
c0102775:	29 f8                	sub    %edi,%eax
c0102777:	29 c3                	sub    %eax,%ebx
c0102779:	01 c2                	add    %eax,%edx
c010277b:	83 e2 fc             	and    $0xfffffffc,%edx
c010277e:	89 d0                	mov    %edx,%eax
c0102780:	c1 e8 02             	shr    $0x2,%eax
c0102783:	89 de                	mov    %ebx,%esi
c0102785:	89 c1                	mov    %eax,%ecx
c0102787:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
c0102789:	66 c7 05 9c c0 12 c0 	movw   $0x1b,0xc012c09c
c0102790:	1b 00 
        switchk2u.tf_ds = USER_DS;
c0102792:	66 c7 05 8c c0 12 c0 	movw   $0x23,0xc012c08c
c0102799:	23 00 
        switchk2u.tf_es = USER_DS;
c010279b:	66 c7 05 88 c0 12 c0 	movw   $0x23,0xc012c088
c01027a2:	23 00 
        switchk2u.tf_ss = USER_DS;
c01027a4:	66 c7 05 a8 c0 12 c0 	movw   $0x23,0xc012c0a8
c01027ab:	23 00 
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c01027ad:	a1 a0 c0 12 c0       	mov    0xc012c0a0,%eax
c01027b2:	80 cc 30             	or     $0x30,%ah
c01027b5:	a3 a0 c0 12 c0       	mov    %eax,0xc012c0a0
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c01027ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01027bd:	83 e8 04             	sub    $0x4,%eax
c01027c0:	ba 60 c0 12 c0       	mov    $0xc012c060,%edx
c01027c5:	89 10                	mov    %edx,(%eax)
        break;
c01027c7:	eb 68                	jmp    c0102831 <trap_dispatch+0x20b>
    case T_SWITCH_TOK:
        tf->tf_cs = KERNEL_CS;
c01027c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01027cc:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c01027d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d5:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c01027db:	8b 45 08             	mov    0x8(%ebp),%eax
c01027de:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c01027e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e7:	8b 40 40             	mov    0x40(%eax),%eax
c01027ea:	80 e4 cf             	and    $0xcf,%ah
c01027ed:	89 c2                	mov    %eax,%edx
c01027ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01027f2:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c01027f5:	eb 3a                	jmp    c0102831 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01027f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01027fa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01027fe:	0f b7 c0             	movzwl %ax,%eax
c0102801:	83 e0 03             	and    $0x3,%eax
c0102804:	85 c0                	test   %eax,%eax
c0102806:	75 29                	jne    c0102831 <trap_dispatch+0x20b>
            print_trapframe(tf);
c0102808:	83 ec 0c             	sub    $0xc,%esp
c010280b:	ff 75 08             	pushl  0x8(%ebp)
c010280e:	e8 a7 fa ff ff       	call   c01022ba <print_trapframe>
c0102813:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0102816:	83 ec 04             	sub    $0x4,%esp
c0102819:	68 9b a2 10 c0       	push   $0xc010a29b
c010281e:	68 f3 00 00 00       	push   $0xf3
c0102823:	68 4e a2 10 c0       	push   $0xc010a24e
c0102828:	e8 cb db ff ff       	call   c01003f8 <__panic>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c010282d:	90                   	nop
c010282e:	eb 01                	jmp    c0102831 <trap_dispatch+0x20b>
         */
        ticks++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
c0102830:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102831:	90                   	nop
c0102832:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102835:	5b                   	pop    %ebx
c0102836:	5e                   	pop    %esi
c0102837:	5f                   	pop    %edi
c0102838:	5d                   	pop    %ebp
c0102839:	c3                   	ret    

c010283a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010283a:	55                   	push   %ebp
c010283b:	89 e5                	mov    %esp,%ebp
c010283d:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102840:	83 ec 0c             	sub    $0xc,%esp
c0102843:	ff 75 08             	pushl  0x8(%ebp)
c0102846:	e8 db fd ff ff       	call   c0102626 <trap_dispatch>
c010284b:	83 c4 10             	add    $0x10,%esp
}
c010284e:	90                   	nop
c010284f:	c9                   	leave  
c0102850:	c3                   	ret    

c0102851 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $0
c0102853:	6a 00                	push   $0x0
  jmp __alltraps
c0102855:	e9 69 0a 00 00       	jmp    c01032c3 <__alltraps>

c010285a <vector1>:
.globl vector1
vector1:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $1
c010285c:	6a 01                	push   $0x1
  jmp __alltraps
c010285e:	e9 60 0a 00 00       	jmp    c01032c3 <__alltraps>

c0102863 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102863:	6a 00                	push   $0x0
  pushl $2
c0102865:	6a 02                	push   $0x2
  jmp __alltraps
c0102867:	e9 57 0a 00 00       	jmp    c01032c3 <__alltraps>

c010286c <vector3>:
.globl vector3
vector3:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $3
c010286e:	6a 03                	push   $0x3
  jmp __alltraps
c0102870:	e9 4e 0a 00 00       	jmp    c01032c3 <__alltraps>

c0102875 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $4
c0102877:	6a 04                	push   $0x4
  jmp __alltraps
c0102879:	e9 45 0a 00 00       	jmp    c01032c3 <__alltraps>

c010287e <vector5>:
.globl vector5
vector5:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $5
c0102880:	6a 05                	push   $0x5
  jmp __alltraps
c0102882:	e9 3c 0a 00 00       	jmp    c01032c3 <__alltraps>

c0102887 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102887:	6a 00                	push   $0x0
  pushl $6
c0102889:	6a 06                	push   $0x6
  jmp __alltraps
c010288b:	e9 33 0a 00 00       	jmp    c01032c3 <__alltraps>

c0102890 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $7
c0102892:	6a 07                	push   $0x7
  jmp __alltraps
c0102894:	e9 2a 0a 00 00       	jmp    c01032c3 <__alltraps>

c0102899 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102899:	6a 08                	push   $0x8
  jmp __alltraps
c010289b:	e9 23 0a 00 00       	jmp    c01032c3 <__alltraps>

c01028a0 <vector9>:
.globl vector9
vector9:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $9
c01028a2:	6a 09                	push   $0x9
  jmp __alltraps
c01028a4:	e9 1a 0a 00 00       	jmp    c01032c3 <__alltraps>

c01028a9 <vector10>:
.globl vector10
vector10:
  pushl $10
c01028a9:	6a 0a                	push   $0xa
  jmp __alltraps
c01028ab:	e9 13 0a 00 00       	jmp    c01032c3 <__alltraps>

c01028b0 <vector11>:
.globl vector11
vector11:
  pushl $11
c01028b0:	6a 0b                	push   $0xb
  jmp __alltraps
c01028b2:	e9 0c 0a 00 00       	jmp    c01032c3 <__alltraps>

c01028b7 <vector12>:
.globl vector12
vector12:
  pushl $12
c01028b7:	6a 0c                	push   $0xc
  jmp __alltraps
c01028b9:	e9 05 0a 00 00       	jmp    c01032c3 <__alltraps>

c01028be <vector13>:
.globl vector13
vector13:
  pushl $13
c01028be:	6a 0d                	push   $0xd
  jmp __alltraps
c01028c0:	e9 fe 09 00 00       	jmp    c01032c3 <__alltraps>

c01028c5 <vector14>:
.globl vector14
vector14:
  pushl $14
c01028c5:	6a 0e                	push   $0xe
  jmp __alltraps
c01028c7:	e9 f7 09 00 00       	jmp    c01032c3 <__alltraps>

c01028cc <vector15>:
.globl vector15
vector15:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $15
c01028ce:	6a 0f                	push   $0xf
  jmp __alltraps
c01028d0:	e9 ee 09 00 00       	jmp    c01032c3 <__alltraps>

c01028d5 <vector16>:
.globl vector16
vector16:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $16
c01028d7:	6a 10                	push   $0x10
  jmp __alltraps
c01028d9:	e9 e5 09 00 00       	jmp    c01032c3 <__alltraps>

c01028de <vector17>:
.globl vector17
vector17:
  pushl $17
c01028de:	6a 11                	push   $0x11
  jmp __alltraps
c01028e0:	e9 de 09 00 00       	jmp    c01032c3 <__alltraps>

c01028e5 <vector18>:
.globl vector18
vector18:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $18
c01028e7:	6a 12                	push   $0x12
  jmp __alltraps
c01028e9:	e9 d5 09 00 00       	jmp    c01032c3 <__alltraps>

c01028ee <vector19>:
.globl vector19
vector19:
  pushl $0
c01028ee:	6a 00                	push   $0x0
  pushl $19
c01028f0:	6a 13                	push   $0x13
  jmp __alltraps
c01028f2:	e9 cc 09 00 00       	jmp    c01032c3 <__alltraps>

c01028f7 <vector20>:
.globl vector20
vector20:
  pushl $0
c01028f7:	6a 00                	push   $0x0
  pushl $20
c01028f9:	6a 14                	push   $0x14
  jmp __alltraps
c01028fb:	e9 c3 09 00 00       	jmp    c01032c3 <__alltraps>

c0102900 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $21
c0102902:	6a 15                	push   $0x15
  jmp __alltraps
c0102904:	e9 ba 09 00 00       	jmp    c01032c3 <__alltraps>

c0102909 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $22
c010290b:	6a 16                	push   $0x16
  jmp __alltraps
c010290d:	e9 b1 09 00 00       	jmp    c01032c3 <__alltraps>

c0102912 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102912:	6a 00                	push   $0x0
  pushl $23
c0102914:	6a 17                	push   $0x17
  jmp __alltraps
c0102916:	e9 a8 09 00 00       	jmp    c01032c3 <__alltraps>

c010291b <vector24>:
.globl vector24
vector24:
  pushl $0
c010291b:	6a 00                	push   $0x0
  pushl $24
c010291d:	6a 18                	push   $0x18
  jmp __alltraps
c010291f:	e9 9f 09 00 00       	jmp    c01032c3 <__alltraps>

c0102924 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $25
c0102926:	6a 19                	push   $0x19
  jmp __alltraps
c0102928:	e9 96 09 00 00       	jmp    c01032c3 <__alltraps>

c010292d <vector26>:
.globl vector26
vector26:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $26
c010292f:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102931:	e9 8d 09 00 00       	jmp    c01032c3 <__alltraps>

c0102936 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102936:	6a 00                	push   $0x0
  pushl $27
c0102938:	6a 1b                	push   $0x1b
  jmp __alltraps
c010293a:	e9 84 09 00 00       	jmp    c01032c3 <__alltraps>

c010293f <vector28>:
.globl vector28
vector28:
  pushl $0
c010293f:	6a 00                	push   $0x0
  pushl $28
c0102941:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102943:	e9 7b 09 00 00       	jmp    c01032c3 <__alltraps>

c0102948 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $29
c010294a:	6a 1d                	push   $0x1d
  jmp __alltraps
c010294c:	e9 72 09 00 00       	jmp    c01032c3 <__alltraps>

c0102951 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $30
c0102953:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102955:	e9 69 09 00 00       	jmp    c01032c3 <__alltraps>

c010295a <vector31>:
.globl vector31
vector31:
  pushl $0
c010295a:	6a 00                	push   $0x0
  pushl $31
c010295c:	6a 1f                	push   $0x1f
  jmp __alltraps
c010295e:	e9 60 09 00 00       	jmp    c01032c3 <__alltraps>

c0102963 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102963:	6a 00                	push   $0x0
  pushl $32
c0102965:	6a 20                	push   $0x20
  jmp __alltraps
c0102967:	e9 57 09 00 00       	jmp    c01032c3 <__alltraps>

c010296c <vector33>:
.globl vector33
vector33:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $33
c010296e:	6a 21                	push   $0x21
  jmp __alltraps
c0102970:	e9 4e 09 00 00       	jmp    c01032c3 <__alltraps>

c0102975 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $34
c0102977:	6a 22                	push   $0x22
  jmp __alltraps
c0102979:	e9 45 09 00 00       	jmp    c01032c3 <__alltraps>

c010297e <vector35>:
.globl vector35
vector35:
  pushl $0
c010297e:	6a 00                	push   $0x0
  pushl $35
c0102980:	6a 23                	push   $0x23
  jmp __alltraps
c0102982:	e9 3c 09 00 00       	jmp    c01032c3 <__alltraps>

c0102987 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102987:	6a 00                	push   $0x0
  pushl $36
c0102989:	6a 24                	push   $0x24
  jmp __alltraps
c010298b:	e9 33 09 00 00       	jmp    c01032c3 <__alltraps>

c0102990 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $37
c0102992:	6a 25                	push   $0x25
  jmp __alltraps
c0102994:	e9 2a 09 00 00       	jmp    c01032c3 <__alltraps>

c0102999 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $38
c010299b:	6a 26                	push   $0x26
  jmp __alltraps
c010299d:	e9 21 09 00 00       	jmp    c01032c3 <__alltraps>

c01029a2 <vector39>:
.globl vector39
vector39:
  pushl $0
c01029a2:	6a 00                	push   $0x0
  pushl $39
c01029a4:	6a 27                	push   $0x27
  jmp __alltraps
c01029a6:	e9 18 09 00 00       	jmp    c01032c3 <__alltraps>

c01029ab <vector40>:
.globl vector40
vector40:
  pushl $0
c01029ab:	6a 00                	push   $0x0
  pushl $40
c01029ad:	6a 28                	push   $0x28
  jmp __alltraps
c01029af:	e9 0f 09 00 00       	jmp    c01032c3 <__alltraps>

c01029b4 <vector41>:
.globl vector41
vector41:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $41
c01029b6:	6a 29                	push   $0x29
  jmp __alltraps
c01029b8:	e9 06 09 00 00       	jmp    c01032c3 <__alltraps>

c01029bd <vector42>:
.globl vector42
vector42:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $42
c01029bf:	6a 2a                	push   $0x2a
  jmp __alltraps
c01029c1:	e9 fd 08 00 00       	jmp    c01032c3 <__alltraps>

c01029c6 <vector43>:
.globl vector43
vector43:
  pushl $0
c01029c6:	6a 00                	push   $0x0
  pushl $43
c01029c8:	6a 2b                	push   $0x2b
  jmp __alltraps
c01029ca:	e9 f4 08 00 00       	jmp    c01032c3 <__alltraps>

c01029cf <vector44>:
.globl vector44
vector44:
  pushl $0
c01029cf:	6a 00                	push   $0x0
  pushl $44
c01029d1:	6a 2c                	push   $0x2c
  jmp __alltraps
c01029d3:	e9 eb 08 00 00       	jmp    c01032c3 <__alltraps>

c01029d8 <vector45>:
.globl vector45
vector45:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $45
c01029da:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029dc:	e9 e2 08 00 00       	jmp    c01032c3 <__alltraps>

c01029e1 <vector46>:
.globl vector46
vector46:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $46
c01029e3:	6a 2e                	push   $0x2e
  jmp __alltraps
c01029e5:	e9 d9 08 00 00       	jmp    c01032c3 <__alltraps>

c01029ea <vector47>:
.globl vector47
vector47:
  pushl $0
c01029ea:	6a 00                	push   $0x0
  pushl $47
c01029ec:	6a 2f                	push   $0x2f
  jmp __alltraps
c01029ee:	e9 d0 08 00 00       	jmp    c01032c3 <__alltraps>

c01029f3 <vector48>:
.globl vector48
vector48:
  pushl $0
c01029f3:	6a 00                	push   $0x0
  pushl $48
c01029f5:	6a 30                	push   $0x30
  jmp __alltraps
c01029f7:	e9 c7 08 00 00       	jmp    c01032c3 <__alltraps>

c01029fc <vector49>:
.globl vector49
vector49:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $49
c01029fe:	6a 31                	push   $0x31
  jmp __alltraps
c0102a00:	e9 be 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a05 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $50
c0102a07:	6a 32                	push   $0x32
  jmp __alltraps
c0102a09:	e9 b5 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a0e <vector51>:
.globl vector51
vector51:
  pushl $0
c0102a0e:	6a 00                	push   $0x0
  pushl $51
c0102a10:	6a 33                	push   $0x33
  jmp __alltraps
c0102a12:	e9 ac 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a17 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102a17:	6a 00                	push   $0x0
  pushl $52
c0102a19:	6a 34                	push   $0x34
  jmp __alltraps
c0102a1b:	e9 a3 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a20 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $53
c0102a22:	6a 35                	push   $0x35
  jmp __alltraps
c0102a24:	e9 9a 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a29 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $54
c0102a2b:	6a 36                	push   $0x36
  jmp __alltraps
c0102a2d:	e9 91 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a32 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102a32:	6a 00                	push   $0x0
  pushl $55
c0102a34:	6a 37                	push   $0x37
  jmp __alltraps
c0102a36:	e9 88 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a3b <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a3b:	6a 00                	push   $0x0
  pushl $56
c0102a3d:	6a 38                	push   $0x38
  jmp __alltraps
c0102a3f:	e9 7f 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a44 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a44:	6a 00                	push   $0x0
  pushl $57
c0102a46:	6a 39                	push   $0x39
  jmp __alltraps
c0102a48:	e9 76 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a4d <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $58
c0102a4f:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a51:	e9 6d 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a56 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a56:	6a 00                	push   $0x0
  pushl $59
c0102a58:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a5a:	e9 64 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a5f <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a5f:	6a 00                	push   $0x0
  pushl $60
c0102a61:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a63:	e9 5b 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a68 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a68:	6a 00                	push   $0x0
  pushl $61
c0102a6a:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a6c:	e9 52 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a71 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $62
c0102a73:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a75:	e9 49 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a7a <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a7a:	6a 00                	push   $0x0
  pushl $63
c0102a7c:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a7e:	e9 40 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a83 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a83:	6a 00                	push   $0x0
  pushl $64
c0102a85:	6a 40                	push   $0x40
  jmp __alltraps
c0102a87:	e9 37 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a8c <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $65
c0102a8e:	6a 41                	push   $0x41
  jmp __alltraps
c0102a90:	e9 2e 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a95 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $66
c0102a97:	6a 42                	push   $0x42
  jmp __alltraps
c0102a99:	e9 25 08 00 00       	jmp    c01032c3 <__alltraps>

c0102a9e <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a9e:	6a 00                	push   $0x0
  pushl $67
c0102aa0:	6a 43                	push   $0x43
  jmp __alltraps
c0102aa2:	e9 1c 08 00 00       	jmp    c01032c3 <__alltraps>

c0102aa7 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102aa7:	6a 00                	push   $0x0
  pushl $68
c0102aa9:	6a 44                	push   $0x44
  jmp __alltraps
c0102aab:	e9 13 08 00 00       	jmp    c01032c3 <__alltraps>

c0102ab0 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102ab0:	6a 00                	push   $0x0
  pushl $69
c0102ab2:	6a 45                	push   $0x45
  jmp __alltraps
c0102ab4:	e9 0a 08 00 00       	jmp    c01032c3 <__alltraps>

c0102ab9 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $70
c0102abb:	6a 46                	push   $0x46
  jmp __alltraps
c0102abd:	e9 01 08 00 00       	jmp    c01032c3 <__alltraps>

c0102ac2 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102ac2:	6a 00                	push   $0x0
  pushl $71
c0102ac4:	6a 47                	push   $0x47
  jmp __alltraps
c0102ac6:	e9 f8 07 00 00       	jmp    c01032c3 <__alltraps>

c0102acb <vector72>:
.globl vector72
vector72:
  pushl $0
c0102acb:	6a 00                	push   $0x0
  pushl $72
c0102acd:	6a 48                	push   $0x48
  jmp __alltraps
c0102acf:	e9 ef 07 00 00       	jmp    c01032c3 <__alltraps>

c0102ad4 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102ad4:	6a 00                	push   $0x0
  pushl $73
c0102ad6:	6a 49                	push   $0x49
  jmp __alltraps
c0102ad8:	e9 e6 07 00 00       	jmp    c01032c3 <__alltraps>

c0102add <vector74>:
.globl vector74
vector74:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $74
c0102adf:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102ae1:	e9 dd 07 00 00       	jmp    c01032c3 <__alltraps>

c0102ae6 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ae6:	6a 00                	push   $0x0
  pushl $75
c0102ae8:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102aea:	e9 d4 07 00 00       	jmp    c01032c3 <__alltraps>

c0102aef <vector76>:
.globl vector76
vector76:
  pushl $0
c0102aef:	6a 00                	push   $0x0
  pushl $76
c0102af1:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102af3:	e9 cb 07 00 00       	jmp    c01032c3 <__alltraps>

c0102af8 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102af8:	6a 00                	push   $0x0
  pushl $77
c0102afa:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102afc:	e9 c2 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b01 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $78
c0102b03:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102b05:	e9 b9 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b0a <vector79>:
.globl vector79
vector79:
  pushl $0
c0102b0a:	6a 00                	push   $0x0
  pushl $79
c0102b0c:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102b0e:	e9 b0 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b13 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102b13:	6a 00                	push   $0x0
  pushl $80
c0102b15:	6a 50                	push   $0x50
  jmp __alltraps
c0102b17:	e9 a7 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b1c <vector81>:
.globl vector81
vector81:
  pushl $0
c0102b1c:	6a 00                	push   $0x0
  pushl $81
c0102b1e:	6a 51                	push   $0x51
  jmp __alltraps
c0102b20:	e9 9e 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b25 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b25:	6a 00                	push   $0x0
  pushl $82
c0102b27:	6a 52                	push   $0x52
  jmp __alltraps
c0102b29:	e9 95 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b2e <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b2e:	6a 00                	push   $0x0
  pushl $83
c0102b30:	6a 53                	push   $0x53
  jmp __alltraps
c0102b32:	e9 8c 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b37 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102b37:	6a 00                	push   $0x0
  pushl $84
c0102b39:	6a 54                	push   $0x54
  jmp __alltraps
c0102b3b:	e9 83 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b40 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b40:	6a 00                	push   $0x0
  pushl $85
c0102b42:	6a 55                	push   $0x55
  jmp __alltraps
c0102b44:	e9 7a 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b49 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b49:	6a 00                	push   $0x0
  pushl $86
c0102b4b:	6a 56                	push   $0x56
  jmp __alltraps
c0102b4d:	e9 71 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b52 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b52:	6a 00                	push   $0x0
  pushl $87
c0102b54:	6a 57                	push   $0x57
  jmp __alltraps
c0102b56:	e9 68 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b5b <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b5b:	6a 00                	push   $0x0
  pushl $88
c0102b5d:	6a 58                	push   $0x58
  jmp __alltraps
c0102b5f:	e9 5f 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b64 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b64:	6a 00                	push   $0x0
  pushl $89
c0102b66:	6a 59                	push   $0x59
  jmp __alltraps
c0102b68:	e9 56 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b6d <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b6d:	6a 00                	push   $0x0
  pushl $90
c0102b6f:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b71:	e9 4d 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b76 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b76:	6a 00                	push   $0x0
  pushl $91
c0102b78:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b7a:	e9 44 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b7f <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b7f:	6a 00                	push   $0x0
  pushl $92
c0102b81:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b83:	e9 3b 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b88 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b88:	6a 00                	push   $0x0
  pushl $93
c0102b8a:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b8c:	e9 32 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b91 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b91:	6a 00                	push   $0x0
  pushl $94
c0102b93:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b95:	e9 29 07 00 00       	jmp    c01032c3 <__alltraps>

c0102b9a <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b9a:	6a 00                	push   $0x0
  pushl $95
c0102b9c:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b9e:	e9 20 07 00 00       	jmp    c01032c3 <__alltraps>

c0102ba3 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102ba3:	6a 00                	push   $0x0
  pushl $96
c0102ba5:	6a 60                	push   $0x60
  jmp __alltraps
c0102ba7:	e9 17 07 00 00       	jmp    c01032c3 <__alltraps>

c0102bac <vector97>:
.globl vector97
vector97:
  pushl $0
c0102bac:	6a 00                	push   $0x0
  pushl $97
c0102bae:	6a 61                	push   $0x61
  jmp __alltraps
c0102bb0:	e9 0e 07 00 00       	jmp    c01032c3 <__alltraps>

c0102bb5 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102bb5:	6a 00                	push   $0x0
  pushl $98
c0102bb7:	6a 62                	push   $0x62
  jmp __alltraps
c0102bb9:	e9 05 07 00 00       	jmp    c01032c3 <__alltraps>

c0102bbe <vector99>:
.globl vector99
vector99:
  pushl $0
c0102bbe:	6a 00                	push   $0x0
  pushl $99
c0102bc0:	6a 63                	push   $0x63
  jmp __alltraps
c0102bc2:	e9 fc 06 00 00       	jmp    c01032c3 <__alltraps>

c0102bc7 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102bc7:	6a 00                	push   $0x0
  pushl $100
c0102bc9:	6a 64                	push   $0x64
  jmp __alltraps
c0102bcb:	e9 f3 06 00 00       	jmp    c01032c3 <__alltraps>

c0102bd0 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102bd0:	6a 00                	push   $0x0
  pushl $101
c0102bd2:	6a 65                	push   $0x65
  jmp __alltraps
c0102bd4:	e9 ea 06 00 00       	jmp    c01032c3 <__alltraps>

c0102bd9 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102bd9:	6a 00                	push   $0x0
  pushl $102
c0102bdb:	6a 66                	push   $0x66
  jmp __alltraps
c0102bdd:	e9 e1 06 00 00       	jmp    c01032c3 <__alltraps>

c0102be2 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102be2:	6a 00                	push   $0x0
  pushl $103
c0102be4:	6a 67                	push   $0x67
  jmp __alltraps
c0102be6:	e9 d8 06 00 00       	jmp    c01032c3 <__alltraps>

c0102beb <vector104>:
.globl vector104
vector104:
  pushl $0
c0102beb:	6a 00                	push   $0x0
  pushl $104
c0102bed:	6a 68                	push   $0x68
  jmp __alltraps
c0102bef:	e9 cf 06 00 00       	jmp    c01032c3 <__alltraps>

c0102bf4 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102bf4:	6a 00                	push   $0x0
  pushl $105
c0102bf6:	6a 69                	push   $0x69
  jmp __alltraps
c0102bf8:	e9 c6 06 00 00       	jmp    c01032c3 <__alltraps>

c0102bfd <vector106>:
.globl vector106
vector106:
  pushl $0
c0102bfd:	6a 00                	push   $0x0
  pushl $106
c0102bff:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102c01:	e9 bd 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c06 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102c06:	6a 00                	push   $0x0
  pushl $107
c0102c08:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102c0a:	e9 b4 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c0f <vector108>:
.globl vector108
vector108:
  pushl $0
c0102c0f:	6a 00                	push   $0x0
  pushl $108
c0102c11:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102c13:	e9 ab 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c18 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102c18:	6a 00                	push   $0x0
  pushl $109
c0102c1a:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102c1c:	e9 a2 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c21 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102c21:	6a 00                	push   $0x0
  pushl $110
c0102c23:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c25:	e9 99 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c2a <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c2a:	6a 00                	push   $0x0
  pushl $111
c0102c2c:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c2e:	e9 90 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c33 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102c33:	6a 00                	push   $0x0
  pushl $112
c0102c35:	6a 70                	push   $0x70
  jmp __alltraps
c0102c37:	e9 87 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c3c <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c3c:	6a 00                	push   $0x0
  pushl $113
c0102c3e:	6a 71                	push   $0x71
  jmp __alltraps
c0102c40:	e9 7e 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c45 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c45:	6a 00                	push   $0x0
  pushl $114
c0102c47:	6a 72                	push   $0x72
  jmp __alltraps
c0102c49:	e9 75 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c4e <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c4e:	6a 00                	push   $0x0
  pushl $115
c0102c50:	6a 73                	push   $0x73
  jmp __alltraps
c0102c52:	e9 6c 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c57 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c57:	6a 00                	push   $0x0
  pushl $116
c0102c59:	6a 74                	push   $0x74
  jmp __alltraps
c0102c5b:	e9 63 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c60 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c60:	6a 00                	push   $0x0
  pushl $117
c0102c62:	6a 75                	push   $0x75
  jmp __alltraps
c0102c64:	e9 5a 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c69 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c69:	6a 00                	push   $0x0
  pushl $118
c0102c6b:	6a 76                	push   $0x76
  jmp __alltraps
c0102c6d:	e9 51 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c72 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c72:	6a 00                	push   $0x0
  pushl $119
c0102c74:	6a 77                	push   $0x77
  jmp __alltraps
c0102c76:	e9 48 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c7b <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c7b:	6a 00                	push   $0x0
  pushl $120
c0102c7d:	6a 78                	push   $0x78
  jmp __alltraps
c0102c7f:	e9 3f 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c84 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c84:	6a 00                	push   $0x0
  pushl $121
c0102c86:	6a 79                	push   $0x79
  jmp __alltraps
c0102c88:	e9 36 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c8d <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c8d:	6a 00                	push   $0x0
  pushl $122
c0102c8f:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c91:	e9 2d 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c96 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c96:	6a 00                	push   $0x0
  pushl $123
c0102c98:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c9a:	e9 24 06 00 00       	jmp    c01032c3 <__alltraps>

c0102c9f <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c9f:	6a 00                	push   $0x0
  pushl $124
c0102ca1:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102ca3:	e9 1b 06 00 00       	jmp    c01032c3 <__alltraps>

c0102ca8 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102ca8:	6a 00                	push   $0x0
  pushl $125
c0102caa:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102cac:	e9 12 06 00 00       	jmp    c01032c3 <__alltraps>

c0102cb1 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102cb1:	6a 00                	push   $0x0
  pushl $126
c0102cb3:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102cb5:	e9 09 06 00 00       	jmp    c01032c3 <__alltraps>

c0102cba <vector127>:
.globl vector127
vector127:
  pushl $0
c0102cba:	6a 00                	push   $0x0
  pushl $127
c0102cbc:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102cbe:	e9 00 06 00 00       	jmp    c01032c3 <__alltraps>

c0102cc3 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102cc3:	6a 00                	push   $0x0
  pushl $128
c0102cc5:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102cca:	e9 f4 05 00 00       	jmp    c01032c3 <__alltraps>

c0102ccf <vector129>:
.globl vector129
vector129:
  pushl $0
c0102ccf:	6a 00                	push   $0x0
  pushl $129
c0102cd1:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102cd6:	e9 e8 05 00 00       	jmp    c01032c3 <__alltraps>

c0102cdb <vector130>:
.globl vector130
vector130:
  pushl $0
c0102cdb:	6a 00                	push   $0x0
  pushl $130
c0102cdd:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102ce2:	e9 dc 05 00 00       	jmp    c01032c3 <__alltraps>

c0102ce7 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102ce7:	6a 00                	push   $0x0
  pushl $131
c0102ce9:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102cee:	e9 d0 05 00 00       	jmp    c01032c3 <__alltraps>

c0102cf3 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102cf3:	6a 00                	push   $0x0
  pushl $132
c0102cf5:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102cfa:	e9 c4 05 00 00       	jmp    c01032c3 <__alltraps>

c0102cff <vector133>:
.globl vector133
vector133:
  pushl $0
c0102cff:	6a 00                	push   $0x0
  pushl $133
c0102d01:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102d06:	e9 b8 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d0b <vector134>:
.globl vector134
vector134:
  pushl $0
c0102d0b:	6a 00                	push   $0x0
  pushl $134
c0102d0d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102d12:	e9 ac 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d17 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102d17:	6a 00                	push   $0x0
  pushl $135
c0102d19:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102d1e:	e9 a0 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d23 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102d23:	6a 00                	push   $0x0
  pushl $136
c0102d25:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d2a:	e9 94 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d2f <vector137>:
.globl vector137
vector137:
  pushl $0
c0102d2f:	6a 00                	push   $0x0
  pushl $137
c0102d31:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102d36:	e9 88 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d3b <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d3b:	6a 00                	push   $0x0
  pushl $138
c0102d3d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d42:	e9 7c 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d47 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d47:	6a 00                	push   $0x0
  pushl $139
c0102d49:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d4e:	e9 70 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d53 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d53:	6a 00                	push   $0x0
  pushl $140
c0102d55:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d5a:	e9 64 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d5f <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d5f:	6a 00                	push   $0x0
  pushl $141
c0102d61:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d66:	e9 58 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d6b <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d6b:	6a 00                	push   $0x0
  pushl $142
c0102d6d:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d72:	e9 4c 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d77 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d77:	6a 00                	push   $0x0
  pushl $143
c0102d79:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d7e:	e9 40 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d83 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d83:	6a 00                	push   $0x0
  pushl $144
c0102d85:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d8a:	e9 34 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d8f <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d8f:	6a 00                	push   $0x0
  pushl $145
c0102d91:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d96:	e9 28 05 00 00       	jmp    c01032c3 <__alltraps>

c0102d9b <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d9b:	6a 00                	push   $0x0
  pushl $146
c0102d9d:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102da2:	e9 1c 05 00 00       	jmp    c01032c3 <__alltraps>

c0102da7 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102da7:	6a 00                	push   $0x0
  pushl $147
c0102da9:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102dae:	e9 10 05 00 00       	jmp    c01032c3 <__alltraps>

c0102db3 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102db3:	6a 00                	push   $0x0
  pushl $148
c0102db5:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102dba:	e9 04 05 00 00       	jmp    c01032c3 <__alltraps>

c0102dbf <vector149>:
.globl vector149
vector149:
  pushl $0
c0102dbf:	6a 00                	push   $0x0
  pushl $149
c0102dc1:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102dc6:	e9 f8 04 00 00       	jmp    c01032c3 <__alltraps>

c0102dcb <vector150>:
.globl vector150
vector150:
  pushl $0
c0102dcb:	6a 00                	push   $0x0
  pushl $150
c0102dcd:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102dd2:	e9 ec 04 00 00       	jmp    c01032c3 <__alltraps>

c0102dd7 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102dd7:	6a 00                	push   $0x0
  pushl $151
c0102dd9:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102dde:	e9 e0 04 00 00       	jmp    c01032c3 <__alltraps>

c0102de3 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102de3:	6a 00                	push   $0x0
  pushl $152
c0102de5:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102dea:	e9 d4 04 00 00       	jmp    c01032c3 <__alltraps>

c0102def <vector153>:
.globl vector153
vector153:
  pushl $0
c0102def:	6a 00                	push   $0x0
  pushl $153
c0102df1:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102df6:	e9 c8 04 00 00       	jmp    c01032c3 <__alltraps>

c0102dfb <vector154>:
.globl vector154
vector154:
  pushl $0
c0102dfb:	6a 00                	push   $0x0
  pushl $154
c0102dfd:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102e02:	e9 bc 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e07 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102e07:	6a 00                	push   $0x0
  pushl $155
c0102e09:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102e0e:	e9 b0 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e13 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102e13:	6a 00                	push   $0x0
  pushl $156
c0102e15:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102e1a:	e9 a4 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e1f <vector157>:
.globl vector157
vector157:
  pushl $0
c0102e1f:	6a 00                	push   $0x0
  pushl $157
c0102e21:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e26:	e9 98 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e2b <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e2b:	6a 00                	push   $0x0
  pushl $158
c0102e2d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102e32:	e9 8c 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e37 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102e37:	6a 00                	push   $0x0
  pushl $159
c0102e39:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e3e:	e9 80 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e43 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e43:	6a 00                	push   $0x0
  pushl $160
c0102e45:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e4a:	e9 74 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e4f <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e4f:	6a 00                	push   $0x0
  pushl $161
c0102e51:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e56:	e9 68 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e5b <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e5b:	6a 00                	push   $0x0
  pushl $162
c0102e5d:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e62:	e9 5c 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e67 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e67:	6a 00                	push   $0x0
  pushl $163
c0102e69:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e6e:	e9 50 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e73 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e73:	6a 00                	push   $0x0
  pushl $164
c0102e75:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e7a:	e9 44 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e7f <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e7f:	6a 00                	push   $0x0
  pushl $165
c0102e81:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e86:	e9 38 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e8b <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e8b:	6a 00                	push   $0x0
  pushl $166
c0102e8d:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e92:	e9 2c 04 00 00       	jmp    c01032c3 <__alltraps>

c0102e97 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e97:	6a 00                	push   $0x0
  pushl $167
c0102e99:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e9e:	e9 20 04 00 00       	jmp    c01032c3 <__alltraps>

c0102ea3 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102ea3:	6a 00                	push   $0x0
  pushl $168
c0102ea5:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102eaa:	e9 14 04 00 00       	jmp    c01032c3 <__alltraps>

c0102eaf <vector169>:
.globl vector169
vector169:
  pushl $0
c0102eaf:	6a 00                	push   $0x0
  pushl $169
c0102eb1:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102eb6:	e9 08 04 00 00       	jmp    c01032c3 <__alltraps>

c0102ebb <vector170>:
.globl vector170
vector170:
  pushl $0
c0102ebb:	6a 00                	push   $0x0
  pushl $170
c0102ebd:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102ec2:	e9 fc 03 00 00       	jmp    c01032c3 <__alltraps>

c0102ec7 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102ec7:	6a 00                	push   $0x0
  pushl $171
c0102ec9:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102ece:	e9 f0 03 00 00       	jmp    c01032c3 <__alltraps>

c0102ed3 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102ed3:	6a 00                	push   $0x0
  pushl $172
c0102ed5:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102eda:	e9 e4 03 00 00       	jmp    c01032c3 <__alltraps>

c0102edf <vector173>:
.globl vector173
vector173:
  pushl $0
c0102edf:	6a 00                	push   $0x0
  pushl $173
c0102ee1:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102ee6:	e9 d8 03 00 00       	jmp    c01032c3 <__alltraps>

c0102eeb <vector174>:
.globl vector174
vector174:
  pushl $0
c0102eeb:	6a 00                	push   $0x0
  pushl $174
c0102eed:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102ef2:	e9 cc 03 00 00       	jmp    c01032c3 <__alltraps>

c0102ef7 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102ef7:	6a 00                	push   $0x0
  pushl $175
c0102ef9:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102efe:	e9 c0 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f03 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102f03:	6a 00                	push   $0x0
  pushl $176
c0102f05:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102f0a:	e9 b4 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f0f <vector177>:
.globl vector177
vector177:
  pushl $0
c0102f0f:	6a 00                	push   $0x0
  pushl $177
c0102f11:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102f16:	e9 a8 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f1b <vector178>:
.globl vector178
vector178:
  pushl $0
c0102f1b:	6a 00                	push   $0x0
  pushl $178
c0102f1d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102f22:	e9 9c 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f27 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f27:	6a 00                	push   $0x0
  pushl $179
c0102f29:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f2e:	e9 90 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f33 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102f33:	6a 00                	push   $0x0
  pushl $180
c0102f35:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f3a:	e9 84 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f3f <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f3f:	6a 00                	push   $0x0
  pushl $181
c0102f41:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f46:	e9 78 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f4b <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f4b:	6a 00                	push   $0x0
  pushl $182
c0102f4d:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f52:	e9 6c 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f57 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f57:	6a 00                	push   $0x0
  pushl $183
c0102f59:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f5e:	e9 60 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f63 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f63:	6a 00                	push   $0x0
  pushl $184
c0102f65:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f6a:	e9 54 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f6f <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f6f:	6a 00                	push   $0x0
  pushl $185
c0102f71:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f76:	e9 48 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f7b <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f7b:	6a 00                	push   $0x0
  pushl $186
c0102f7d:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f82:	e9 3c 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f87 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f87:	6a 00                	push   $0x0
  pushl $187
c0102f89:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f8e:	e9 30 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f93 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f93:	6a 00                	push   $0x0
  pushl $188
c0102f95:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f9a:	e9 24 03 00 00       	jmp    c01032c3 <__alltraps>

c0102f9f <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f9f:	6a 00                	push   $0x0
  pushl $189
c0102fa1:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102fa6:	e9 18 03 00 00       	jmp    c01032c3 <__alltraps>

c0102fab <vector190>:
.globl vector190
vector190:
  pushl $0
c0102fab:	6a 00                	push   $0x0
  pushl $190
c0102fad:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102fb2:	e9 0c 03 00 00       	jmp    c01032c3 <__alltraps>

c0102fb7 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102fb7:	6a 00                	push   $0x0
  pushl $191
c0102fb9:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102fbe:	e9 00 03 00 00       	jmp    c01032c3 <__alltraps>

c0102fc3 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102fc3:	6a 00                	push   $0x0
  pushl $192
c0102fc5:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102fca:	e9 f4 02 00 00       	jmp    c01032c3 <__alltraps>

c0102fcf <vector193>:
.globl vector193
vector193:
  pushl $0
c0102fcf:	6a 00                	push   $0x0
  pushl $193
c0102fd1:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102fd6:	e9 e8 02 00 00       	jmp    c01032c3 <__alltraps>

c0102fdb <vector194>:
.globl vector194
vector194:
  pushl $0
c0102fdb:	6a 00                	push   $0x0
  pushl $194
c0102fdd:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102fe2:	e9 dc 02 00 00       	jmp    c01032c3 <__alltraps>

c0102fe7 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102fe7:	6a 00                	push   $0x0
  pushl $195
c0102fe9:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102fee:	e9 d0 02 00 00       	jmp    c01032c3 <__alltraps>

c0102ff3 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102ff3:	6a 00                	push   $0x0
  pushl $196
c0102ff5:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102ffa:	e9 c4 02 00 00       	jmp    c01032c3 <__alltraps>

c0102fff <vector197>:
.globl vector197
vector197:
  pushl $0
c0102fff:	6a 00                	push   $0x0
  pushl $197
c0103001:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103006:	e9 b8 02 00 00       	jmp    c01032c3 <__alltraps>

c010300b <vector198>:
.globl vector198
vector198:
  pushl $0
c010300b:	6a 00                	push   $0x0
  pushl $198
c010300d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103012:	e9 ac 02 00 00       	jmp    c01032c3 <__alltraps>

c0103017 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103017:	6a 00                	push   $0x0
  pushl $199
c0103019:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010301e:	e9 a0 02 00 00       	jmp    c01032c3 <__alltraps>

c0103023 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103023:	6a 00                	push   $0x0
  pushl $200
c0103025:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010302a:	e9 94 02 00 00       	jmp    c01032c3 <__alltraps>

c010302f <vector201>:
.globl vector201
vector201:
  pushl $0
c010302f:	6a 00                	push   $0x0
  pushl $201
c0103031:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103036:	e9 88 02 00 00       	jmp    c01032c3 <__alltraps>

c010303b <vector202>:
.globl vector202
vector202:
  pushl $0
c010303b:	6a 00                	push   $0x0
  pushl $202
c010303d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103042:	e9 7c 02 00 00       	jmp    c01032c3 <__alltraps>

c0103047 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103047:	6a 00                	push   $0x0
  pushl $203
c0103049:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010304e:	e9 70 02 00 00       	jmp    c01032c3 <__alltraps>

c0103053 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103053:	6a 00                	push   $0x0
  pushl $204
c0103055:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010305a:	e9 64 02 00 00       	jmp    c01032c3 <__alltraps>

c010305f <vector205>:
.globl vector205
vector205:
  pushl $0
c010305f:	6a 00                	push   $0x0
  pushl $205
c0103061:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103066:	e9 58 02 00 00       	jmp    c01032c3 <__alltraps>

c010306b <vector206>:
.globl vector206
vector206:
  pushl $0
c010306b:	6a 00                	push   $0x0
  pushl $206
c010306d:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103072:	e9 4c 02 00 00       	jmp    c01032c3 <__alltraps>

c0103077 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103077:	6a 00                	push   $0x0
  pushl $207
c0103079:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010307e:	e9 40 02 00 00       	jmp    c01032c3 <__alltraps>

c0103083 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103083:	6a 00                	push   $0x0
  pushl $208
c0103085:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010308a:	e9 34 02 00 00       	jmp    c01032c3 <__alltraps>

c010308f <vector209>:
.globl vector209
vector209:
  pushl $0
c010308f:	6a 00                	push   $0x0
  pushl $209
c0103091:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103096:	e9 28 02 00 00       	jmp    c01032c3 <__alltraps>

c010309b <vector210>:
.globl vector210
vector210:
  pushl $0
c010309b:	6a 00                	push   $0x0
  pushl $210
c010309d:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01030a2:	e9 1c 02 00 00       	jmp    c01032c3 <__alltraps>

c01030a7 <vector211>:
.globl vector211
vector211:
  pushl $0
c01030a7:	6a 00                	push   $0x0
  pushl $211
c01030a9:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01030ae:	e9 10 02 00 00       	jmp    c01032c3 <__alltraps>

c01030b3 <vector212>:
.globl vector212
vector212:
  pushl $0
c01030b3:	6a 00                	push   $0x0
  pushl $212
c01030b5:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01030ba:	e9 04 02 00 00       	jmp    c01032c3 <__alltraps>

c01030bf <vector213>:
.globl vector213
vector213:
  pushl $0
c01030bf:	6a 00                	push   $0x0
  pushl $213
c01030c1:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01030c6:	e9 f8 01 00 00       	jmp    c01032c3 <__alltraps>

c01030cb <vector214>:
.globl vector214
vector214:
  pushl $0
c01030cb:	6a 00                	push   $0x0
  pushl $214
c01030cd:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01030d2:	e9 ec 01 00 00       	jmp    c01032c3 <__alltraps>

c01030d7 <vector215>:
.globl vector215
vector215:
  pushl $0
c01030d7:	6a 00                	push   $0x0
  pushl $215
c01030d9:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030de:	e9 e0 01 00 00       	jmp    c01032c3 <__alltraps>

c01030e3 <vector216>:
.globl vector216
vector216:
  pushl $0
c01030e3:	6a 00                	push   $0x0
  pushl $216
c01030e5:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01030ea:	e9 d4 01 00 00       	jmp    c01032c3 <__alltraps>

c01030ef <vector217>:
.globl vector217
vector217:
  pushl $0
c01030ef:	6a 00                	push   $0x0
  pushl $217
c01030f1:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030f6:	e9 c8 01 00 00       	jmp    c01032c3 <__alltraps>

c01030fb <vector218>:
.globl vector218
vector218:
  pushl $0
c01030fb:	6a 00                	push   $0x0
  pushl $218
c01030fd:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103102:	e9 bc 01 00 00       	jmp    c01032c3 <__alltraps>

c0103107 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103107:	6a 00                	push   $0x0
  pushl $219
c0103109:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010310e:	e9 b0 01 00 00       	jmp    c01032c3 <__alltraps>

c0103113 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103113:	6a 00                	push   $0x0
  pushl $220
c0103115:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010311a:	e9 a4 01 00 00       	jmp    c01032c3 <__alltraps>

c010311f <vector221>:
.globl vector221
vector221:
  pushl $0
c010311f:	6a 00                	push   $0x0
  pushl $221
c0103121:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103126:	e9 98 01 00 00       	jmp    c01032c3 <__alltraps>

c010312b <vector222>:
.globl vector222
vector222:
  pushl $0
c010312b:	6a 00                	push   $0x0
  pushl $222
c010312d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103132:	e9 8c 01 00 00       	jmp    c01032c3 <__alltraps>

c0103137 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103137:	6a 00                	push   $0x0
  pushl $223
c0103139:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010313e:	e9 80 01 00 00       	jmp    c01032c3 <__alltraps>

c0103143 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103143:	6a 00                	push   $0x0
  pushl $224
c0103145:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010314a:	e9 74 01 00 00       	jmp    c01032c3 <__alltraps>

c010314f <vector225>:
.globl vector225
vector225:
  pushl $0
c010314f:	6a 00                	push   $0x0
  pushl $225
c0103151:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103156:	e9 68 01 00 00       	jmp    c01032c3 <__alltraps>

c010315b <vector226>:
.globl vector226
vector226:
  pushl $0
c010315b:	6a 00                	push   $0x0
  pushl $226
c010315d:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103162:	e9 5c 01 00 00       	jmp    c01032c3 <__alltraps>

c0103167 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103167:	6a 00                	push   $0x0
  pushl $227
c0103169:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010316e:	e9 50 01 00 00       	jmp    c01032c3 <__alltraps>

c0103173 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103173:	6a 00                	push   $0x0
  pushl $228
c0103175:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010317a:	e9 44 01 00 00       	jmp    c01032c3 <__alltraps>

c010317f <vector229>:
.globl vector229
vector229:
  pushl $0
c010317f:	6a 00                	push   $0x0
  pushl $229
c0103181:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103186:	e9 38 01 00 00       	jmp    c01032c3 <__alltraps>

c010318b <vector230>:
.globl vector230
vector230:
  pushl $0
c010318b:	6a 00                	push   $0x0
  pushl $230
c010318d:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103192:	e9 2c 01 00 00       	jmp    c01032c3 <__alltraps>

c0103197 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103197:	6a 00                	push   $0x0
  pushl $231
c0103199:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010319e:	e9 20 01 00 00       	jmp    c01032c3 <__alltraps>

c01031a3 <vector232>:
.globl vector232
vector232:
  pushl $0
c01031a3:	6a 00                	push   $0x0
  pushl $232
c01031a5:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01031aa:	e9 14 01 00 00       	jmp    c01032c3 <__alltraps>

c01031af <vector233>:
.globl vector233
vector233:
  pushl $0
c01031af:	6a 00                	push   $0x0
  pushl $233
c01031b1:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01031b6:	e9 08 01 00 00       	jmp    c01032c3 <__alltraps>

c01031bb <vector234>:
.globl vector234
vector234:
  pushl $0
c01031bb:	6a 00                	push   $0x0
  pushl $234
c01031bd:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01031c2:	e9 fc 00 00 00       	jmp    c01032c3 <__alltraps>

c01031c7 <vector235>:
.globl vector235
vector235:
  pushl $0
c01031c7:	6a 00                	push   $0x0
  pushl $235
c01031c9:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01031ce:	e9 f0 00 00 00       	jmp    c01032c3 <__alltraps>

c01031d3 <vector236>:
.globl vector236
vector236:
  pushl $0
c01031d3:	6a 00                	push   $0x0
  pushl $236
c01031d5:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031da:	e9 e4 00 00 00       	jmp    c01032c3 <__alltraps>

c01031df <vector237>:
.globl vector237
vector237:
  pushl $0
c01031df:	6a 00                	push   $0x0
  pushl $237
c01031e1:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01031e6:	e9 d8 00 00 00       	jmp    c01032c3 <__alltraps>

c01031eb <vector238>:
.globl vector238
vector238:
  pushl $0
c01031eb:	6a 00                	push   $0x0
  pushl $238
c01031ed:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01031f2:	e9 cc 00 00 00       	jmp    c01032c3 <__alltraps>

c01031f7 <vector239>:
.globl vector239
vector239:
  pushl $0
c01031f7:	6a 00                	push   $0x0
  pushl $239
c01031f9:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01031fe:	e9 c0 00 00 00       	jmp    c01032c3 <__alltraps>

c0103203 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103203:	6a 00                	push   $0x0
  pushl $240
c0103205:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010320a:	e9 b4 00 00 00       	jmp    c01032c3 <__alltraps>

c010320f <vector241>:
.globl vector241
vector241:
  pushl $0
c010320f:	6a 00                	push   $0x0
  pushl $241
c0103211:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103216:	e9 a8 00 00 00       	jmp    c01032c3 <__alltraps>

c010321b <vector242>:
.globl vector242
vector242:
  pushl $0
c010321b:	6a 00                	push   $0x0
  pushl $242
c010321d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103222:	e9 9c 00 00 00       	jmp    c01032c3 <__alltraps>

c0103227 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103227:	6a 00                	push   $0x0
  pushl $243
c0103229:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010322e:	e9 90 00 00 00       	jmp    c01032c3 <__alltraps>

c0103233 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103233:	6a 00                	push   $0x0
  pushl $244
c0103235:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010323a:	e9 84 00 00 00       	jmp    c01032c3 <__alltraps>

c010323f <vector245>:
.globl vector245
vector245:
  pushl $0
c010323f:	6a 00                	push   $0x0
  pushl $245
c0103241:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103246:	e9 78 00 00 00       	jmp    c01032c3 <__alltraps>

c010324b <vector246>:
.globl vector246
vector246:
  pushl $0
c010324b:	6a 00                	push   $0x0
  pushl $246
c010324d:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103252:	e9 6c 00 00 00       	jmp    c01032c3 <__alltraps>

c0103257 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103257:	6a 00                	push   $0x0
  pushl $247
c0103259:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010325e:	e9 60 00 00 00       	jmp    c01032c3 <__alltraps>

c0103263 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103263:	6a 00                	push   $0x0
  pushl $248
c0103265:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010326a:	e9 54 00 00 00       	jmp    c01032c3 <__alltraps>

c010326f <vector249>:
.globl vector249
vector249:
  pushl $0
c010326f:	6a 00                	push   $0x0
  pushl $249
c0103271:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103276:	e9 48 00 00 00       	jmp    c01032c3 <__alltraps>

c010327b <vector250>:
.globl vector250
vector250:
  pushl $0
c010327b:	6a 00                	push   $0x0
  pushl $250
c010327d:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103282:	e9 3c 00 00 00       	jmp    c01032c3 <__alltraps>

c0103287 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103287:	6a 00                	push   $0x0
  pushl $251
c0103289:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010328e:	e9 30 00 00 00       	jmp    c01032c3 <__alltraps>

c0103293 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103293:	6a 00                	push   $0x0
  pushl $252
c0103295:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010329a:	e9 24 00 00 00       	jmp    c01032c3 <__alltraps>

c010329f <vector253>:
.globl vector253
vector253:
  pushl $0
c010329f:	6a 00                	push   $0x0
  pushl $253
c01032a1:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01032a6:	e9 18 00 00 00       	jmp    c01032c3 <__alltraps>

c01032ab <vector254>:
.globl vector254
vector254:
  pushl $0
c01032ab:	6a 00                	push   $0x0
  pushl $254
c01032ad:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01032b2:	e9 0c 00 00 00       	jmp    c01032c3 <__alltraps>

c01032b7 <vector255>:
.globl vector255
vector255:
  pushl $0
c01032b7:	6a 00                	push   $0x0
  pushl $255
c01032b9:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01032be:	e9 00 00 00 00       	jmp    c01032c3 <__alltraps>

c01032c3 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01032c3:	1e                   	push   %ds
    pushl %es
c01032c4:	06                   	push   %es
    pushl %fs
c01032c5:	0f a0                	push   %fs
    pushl %gs
c01032c7:	0f a8                	push   %gs
    pushal
c01032c9:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01032ca:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01032cf:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01032d1:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01032d3:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01032d4:	e8 61 f5 ff ff       	call   c010283a <trap>

    # pop the pushed stack pointer
    popl %esp
c01032d9:	5c                   	pop    %esp

c01032da <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01032da:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01032db:	0f a9                	pop    %gs
    popl %fs
c01032dd:	0f a1                	pop    %fs
    popl %es
c01032df:	07                   	pop    %es
    popl %ds
c01032e0:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01032e1:	83 c4 08             	add    $0x8,%esp
    iret
c01032e4:	cf                   	iret   

c01032e5 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c01032e5:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c01032e9:	eb ef                	jmp    c01032da <__trapret>

c01032eb <_enclock_init_mm>:
 * (2) _enclock_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_enclock_init_mm(struct mm_struct *mm)
{     
c01032eb:	55                   	push   %ebp
c01032ec:	89 e5                	mov    %esp,%ebp
c01032ee:	83 ec 18             	sub    $0x18,%esp
c01032f1:	c7 45 f4 b0 c0 12 c0 	movl   $0xc012c0b0,-0xc(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01032fe:	89 50 04             	mov    %edx,0x4(%eax)
c0103301:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103304:	8b 50 04             	mov    0x4(%eax),%edx
c0103307:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010330a:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     clock_ptr = &pra_list_head;
c010330c:	c7 05 b8 c0 12 c0 b0 	movl   $0xc012c0b0,0xc012c0b8
c0103313:	c0 12 c0 
     assert(clock_ptr != NULL);
c0103316:	a1 b8 c0 12 c0       	mov    0xc012c0b8,%eax
c010331b:	85 c0                	test   %eax,%eax
c010331d:	75 16                	jne    c0103335 <_enclock_init_mm+0x4a>
c010331f:	68 50 a4 10 c0       	push   $0xc010a450
c0103324:	68 62 a4 10 c0       	push   $0xc010a462
c0103329:	6a 20                	push   $0x20
c010332b:	68 77 a4 10 c0       	push   $0xc010a477
c0103330:	e8 c3 d0 ff ff       	call   c01003f8 <__panic>
     mm->sm_priv = &sm_priv_enclock;
c0103335:	8b 45 08             	mov    0x8(%ebp),%eax
c0103338:	c7 40 14 e0 69 12 c0 	movl   $0xc01269e0,0x14(%eax)
     //cprintf(" mm->sm_priv %x in enclock_init_mm\n",mm->sm_priv);
     return 0;
c010333f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103344:	c9                   	leave  
c0103345:	c3                   	ret    

c0103346 <_enclock_map_swappable>:
/*
 * (3)_enclock_map_swappable: According enclock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_enclock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0103346:	55                   	push   %ebp
c0103347:	89 e5                	mov    %esp,%ebp
c0103349:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c010334c:	8b 45 08             	mov    0x8(%ebp),%eax
c010334f:	8b 40 14             	mov    0x14(%eax),%eax
c0103352:	8b 00                	mov    (%eax),%eax
c0103354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c0103357:	8b 45 08             	mov    0x8(%ebp),%eax
c010335a:	8b 40 14             	mov    0x14(%eax),%eax
c010335d:	8b 40 04             	mov    0x4(%eax),%eax
c0103360:	8b 00                	mov    (%eax),%eax
c0103362:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in swappable\n");
    // }
    list_entry_t *entry=&(page->pra_page_link);
c0103365:	8b 45 10             	mov    0x10(%ebp),%eax
c0103368:	83 c0 14             	add    $0x14,%eax
c010336b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    
    assert(entry != NULL && head != NULL);
c010336e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103372:	74 06                	je     c010337a <_enclock_map_swappable+0x34>
c0103374:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103378:	75 16                	jne    c0103390 <_enclock_map_swappable+0x4a>
c010337a:	68 8e a4 10 c0       	push   $0xc010a48e
c010337f:	68 62 a4 10 c0       	push   $0xc010a462
c0103384:	6a 32                	push   $0x32
c0103386:	68 77 a4 10 c0       	push   $0xc010a477
c010338b:	e8 68 d0 ff ff       	call   c01003f8 <__panic>
    //record the page access situlation
    /*LAB3 CHALLENGE: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c0103390:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0103394:	75 57                	jne    c01033ed <_enclock_map_swappable+0xa7>
        list_entry_t *le_prev = head, *le;
c0103396:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103399:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c010339c:	eb 38                	jmp    c01033d6 <_enclock_map_swappable+0x90>
            if (le == entry) {
c010339e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01033a4:	75 2a                	jne    c01033d0 <_enclock_map_swappable+0x8a>
c01033a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01033ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033af:	8b 40 04             	mov    0x4(%eax),%eax
c01033b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01033b5:	8b 12                	mov    (%edx),%edx
c01033b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01033bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033c0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033c3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01033c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033cc:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c01033ce:	eb 1d                	jmp    c01033ed <_enclock_map_swappable+0xa7>
            }
            le_prev = le;        
c01033d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033df:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 CHALLENGE: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c01033e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01033e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01033eb:	75 b1                	jne    c010339e <_enclock_map_swappable+0x58>
c01033ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033f6:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01033f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033fc:	8b 00                	mov    (%eax),%eax
c01033fe:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103401:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103404:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0103407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010340a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010340d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103410:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103413:	89 10                	mov    %edx,(%eax)
c0103415:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103418:	8b 10                	mov    (%eax),%edx
c010341a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010341d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103420:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103423:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103426:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103429:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010342c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010342f:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c0103431:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103436:	c9                   	leave  
c0103437:	c3                   	ret    

c0103438 <_enclock_swap_out_victim>:
 *  (4)_enclock_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_enclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0103438:	55                   	push   %ebp
c0103439:	89 e5                	mov    %esp,%ebp
c010343b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c010343e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103441:	8b 40 14             	mov    0x14(%eax),%eax
c0103444:	8b 00                	mov    (%eax),%eax
c0103446:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c0103449:	8b 45 08             	mov    0x8(%ebp),%eax
c010344c:	8b 40 14             	mov    0x14(%eax),%eax
c010344f:	8b 40 04             	mov    0x4(%eax),%eax
c0103452:	8b 00                	mov    (%eax),%eax
c0103454:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in victim\n");
    // }
    assert(head != NULL);
c0103457:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010345b:	75 16                	jne    c0103473 <_enclock_swap_out_victim+0x3b>
c010345d:	68 ac a4 10 c0       	push   $0xc010a4ac
c0103462:	68 62 a4 10 c0       	push   $0xc010a462
c0103467:	6a 50                	push   $0x50
c0103469:	68 77 a4 10 c0       	push   $0xc010a477
c010346e:	e8 85 cf ff ff       	call   c01003f8 <__panic>
    assert(in_tick==0);
c0103473:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103477:	74 16                	je     c010348f <_enclock_swap_out_victim+0x57>
c0103479:	68 b9 a4 10 c0       	push   $0xc010a4b9
c010347e:	68 62 a4 10 c0       	push   $0xc010a462
c0103483:	6a 51                	push   $0x51
c0103485:	68 77 a4 10 c0       	push   $0xc010a477
c010348a:	e8 69 cf ff ff       	call   c01003f8 <__panic>
    /* Select the victim */
    /*LAB3 CHALLENGE 2: YOUR CODE*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
c010348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103492:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int cnt = 0;
c0103495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (le = list_next(le_prev)) {
c010349c:	e9 36 01 00 00       	jmp    c01035d7 <_enclock_swap_out_victim+0x19f>
        assert(cnt < 3);
c01034a1:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
c01034a5:	7e 16                	jle    c01034bd <_enclock_swap_out_victim+0x85>
c01034a7:	68 c4 a4 10 c0       	push   $0xc010a4c4
c01034ac:	68 62 a4 10 c0       	push   $0xc010a462
c01034b1:	6a 58                	push   $0x58
c01034b3:	68 77 a4 10 c0       	push   $0xc010a477
c01034b8:	e8 3b cf ff ff       	call   c01003f8 <__panic>
        if (le == head) {
c01034bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034c3:	75 0f                	jne    c01034d4 <_enclock_swap_out_victim+0x9c>
            cnt ++;
c01034c5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
            le_prev = le;
c01034c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            continue;
c01034cf:	e9 03 01 00 00       	jmp    c01035d7 <_enclock_swap_out_victim+0x19f>
        }
        struct Page *page = le2page(le, pra_page_link);
c01034d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034d7:	83 e8 14             	sub    $0x14,%eax
c01034da:	89 45 dc             	mov    %eax,-0x24(%ebp)
        pte_t* ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
c01034dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034e0:	8b 50 1c             	mov    0x1c(%eax),%edx
c01034e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01034e6:	8b 40 0c             	mov    0xc(%eax),%eax
c01034e9:	83 ec 04             	sub    $0x4,%esp
c01034ec:	6a 00                	push   $0x0
c01034ee:	52                   	push   %edx
c01034ef:	50                   	push   %eax
c01034f0:	e8 3e 41 00 00       	call   c0107633 <get_pte>
c01034f5:	83 c4 10             	add    $0x10,%esp
c01034f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
        _enclock_print_pte(ptep, page->pra_vaddr);
c01034fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034fe:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103501:	83 ec 08             	sub    $0x8,%esp
c0103504:	50                   	push   %eax
c0103505:	ff 75 d8             	pushl  -0x28(%ebp)
c0103508:	e8 fb 01 00 00       	call   c0103708 <_enclock_print_pte>
c010350d:	83 c4 10             	add    $0x10,%esp
        // cprintf("BEFORE: va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", page->pra_vaddr, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        if (*ptep & PTE_A) {
c0103510:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103513:	8b 00                	mov    (%eax),%eax
c0103515:	83 e0 20             	and    $0x20,%eax
c0103518:	85 c0                	test   %eax,%eax
c010351a:	74 2d                	je     c0103549 <_enclock_swap_out_victim+0x111>
            // set access to 0
            *ptep &= ~PTE_A;
c010351c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010351f:	8b 00                	mov    (%eax),%eax
c0103521:	83 e0 df             	and    $0xffffffdf,%eax
c0103524:	89 c2                	mov    %eax,%edx
c0103526:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103529:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(mm->pgdir, page->pra_vaddr);
c010352b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010352e:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103531:	8b 45 08             	mov    0x8(%ebp),%eax
c0103534:	8b 40 0c             	mov    0xc(%eax),%eax
c0103537:	83 ec 08             	sub    $0x8,%esp
c010353a:	52                   	push   %edx
c010353b:	50                   	push   %eax
c010353c:	e8 ea 43 00 00       	call   c010792b <tlb_invalidate>
c0103541:	83 c4 10             	add    $0x10,%esp
c0103544:	e9 88 00 00 00       	jmp    c01035d1 <_enclock_swap_out_victim+0x199>
        } else {
            // cprintf("now a == 0\n");
            if (*ptep & PTE_D) {
c0103549:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010354c:	8b 00                	mov    (%eax),%eax
c010354e:	83 e0 40             	and    $0x40,%eax
c0103551:	85 c0                	test   %eax,%eax
c0103553:	74 63                	je     c01035b8 <_enclock_swap_out_victim+0x180>
                if (swapfs_write((page->pra_vaddr / PGSIZE + 1) << 8, page) == 0) {
c0103555:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103558:	8b 40 1c             	mov    0x1c(%eax),%eax
c010355b:	c1 e8 0c             	shr    $0xc,%eax
c010355e:	83 c0 01             	add    $0x1,%eax
c0103561:	c1 e0 08             	shl    $0x8,%eax
c0103564:	83 ec 08             	sub    $0x8,%esp
c0103567:	ff 75 dc             	pushl  -0x24(%ebp)
c010356a:	50                   	push   %eax
c010356b:	e8 92 50 00 00       	call   c0108602 <swapfs_write>
c0103570:	83 c4 10             	add    $0x10,%esp
c0103573:	85 c0                	test   %eax,%eax
c0103575:	75 17                	jne    c010358e <_enclock_swap_out_victim+0x156>
                    cprintf("write 0x%x to disk\n", page->pra_vaddr);
c0103577:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010357a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010357d:	83 ec 08             	sub    $0x8,%esp
c0103580:	50                   	push   %eax
c0103581:	68 cc a4 10 c0       	push   $0xc010a4cc
c0103586:	e8 07 cd ff ff       	call   c0100292 <cprintf>
c010358b:	83 c4 10             	add    $0x10,%esp
                }
                // set dirty to 0
                *ptep = *ptep & ~PTE_D;
c010358e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103591:	8b 00                	mov    (%eax),%eax
c0103593:	83 e0 bf             	and    $0xffffffbf,%eax
c0103596:	89 c2                	mov    %eax,%edx
c0103598:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010359b:	89 10                	mov    %edx,(%eax)
                tlb_invalidate(mm->pgdir, page->pra_vaddr);
c010359d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035a0:	8b 50 1c             	mov    0x1c(%eax),%edx
c01035a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01035a6:	8b 40 0c             	mov    0xc(%eax),%eax
c01035a9:	83 ec 08             	sub    $0x8,%esp
c01035ac:	52                   	push   %edx
c01035ad:	50                   	push   %eax
c01035ae:	e8 78 43 00 00       	call   c010792b <tlb_invalidate>
c01035b3:	83 c4 10             	add    $0x10,%esp
c01035b6:	eb 19                	jmp    c01035d1 <_enclock_swap_out_victim+0x199>
            } else {
                // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
                cprintf("victim is 0x%x\n", page->pra_vaddr);
c01035b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035bb:	8b 40 1c             	mov    0x1c(%eax),%eax
c01035be:	83 ec 08             	sub    $0x8,%esp
c01035c1:	50                   	push   %eax
c01035c2:	68 e0 a4 10 c0       	push   $0xc010a4e0
c01035c7:	e8 c6 cc ff ff       	call   c0100292 <cprintf>
c01035cc:	83 c4 10             	add    $0x10,%esp
                break;
c01035cf:	eb 1f                	jmp    c01035f0 <_enclock_swap_out_victim+0x1b8>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
c01035d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035da:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035e0:	8b 40 04             	mov    0x4(%eax),%eax
    /* Select the victim */
    /*LAB3 CHALLENGE 2: YOUR CODE*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
    int cnt = 0;
    while (le = list_next(le_prev)) {
c01035e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01035ea:	0f 85 b1 fe ff ff    	jne    c01034a1 <_enclock_swap_out_victim+0x69>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
    }
    assert(le != head);
c01035f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01035f6:	75 16                	jne    c010360e <_enclock_swap_out_victim+0x1d6>
c01035f8:	68 f0 a4 10 c0       	push   $0xc010a4f0
c01035fd:	68 62 a4 10 c0       	push   $0xc010a462
c0103602:	6a 78                	push   $0x78
c0103604:	68 77 a4 10 c0       	push   $0xc010a477
c0103609:	e8 ea cd ff ff       	call   c01003f8 <__panic>
c010360e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103617:	8b 40 04             	mov    0x4(%eax),%eax
c010361a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010361d:	8b 12                	mov    (%edx),%edx
c010361f:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103622:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103625:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103628:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010362b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010362e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103631:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103634:	89 10                	mov    %edx,(%eax)
    list_del(le);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(le, pra_page_link);
c0103636:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103639:	83 e8 14             	sub    $0x14,%eax
c010363c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    assert(page != NULL);
c010363f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103643:	75 16                	jne    c010365b <_enclock_swap_out_victim+0x223>
c0103645:	68 fb a4 10 c0       	push   $0xc010a4fb
c010364a:	68 62 a4 10 c0       	push   $0xc010a462
c010364f:	6a 7c                	push   $0x7c
c0103651:	68 77 a4 10 c0       	push   $0xc010a477
c0103656:	e8 9d cd ff ff       	call   c01003f8 <__panic>
    *ptr_page = page;
c010365b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010365e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103661:	89 10                	mov    %edx,(%eax)
    //(2)update clock
    *(((struct enclock_struct*) mm->sm_priv)->clock) = list_next(le_prev);
c0103663:	8b 45 08             	mov    0x8(%ebp),%eax
c0103666:	8b 40 14             	mov    0x14(%eax),%eax
c0103669:	8b 40 04             	mov    0x4(%eax),%eax
c010366c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010366f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103672:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103675:	8b 52 04             	mov    0x4(%edx),%edx
c0103678:	89 10                	mov    %edx,(%eax)
    return 0;
c010367a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010367f:	c9                   	leave  
c0103680:	c3                   	ret    

c0103681 <_enclock_reset_pte>:

void
_enclock_reset_pte(pde_t* pgdir) {
c0103681:	55                   	push   %ebp
c0103682:	89 e5                	mov    %esp,%ebp
c0103684:	83 ec 18             	sub    $0x18,%esp
    cprintf("PTEs resetting...\n");
c0103687:	83 ec 0c             	sub    $0xc,%esp
c010368a:	68 08 a5 10 c0       	push   $0xc010a508
c010368f:	e8 fe cb ff ff       	call   c0100292 <cprintf>
c0103694:	83 c4 10             	add    $0x10,%esp
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c0103697:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
c010369e:	eb 4c                	jmp    c01036ec <_enclock_reset_pte+0x6b>
        pte_t* ptep = get_pte(pgdir, va, 0);
c01036a0:	83 ec 04             	sub    $0x4,%esp
c01036a3:	6a 00                	push   $0x0
c01036a5:	ff 75 f4             	pushl  -0xc(%ebp)
c01036a8:	ff 75 08             	pushl  0x8(%ebp)
c01036ab:	e8 83 3f 00 00       	call   c0107633 <get_pte>
c01036b0:	83 c4 10             	add    $0x10,%esp
c01036b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        *ptep = *ptep & ~PTE_A;
c01036b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b9:	8b 00                	mov    (%eax),%eax
c01036bb:	83 e0 df             	and    $0xffffffdf,%eax
c01036be:	89 c2                	mov    %eax,%edx
c01036c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c3:	89 10                	mov    %edx,(%eax)
        *ptep = *ptep & ~PTE_D;
c01036c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c8:	8b 00                	mov    (%eax),%eax
c01036ca:	83 e0 bf             	and    $0xffffffbf,%eax
c01036cd:	89 c2                	mov    %eax,%edx
c01036cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036d2:	89 10                	mov    %edx,(%eax)
        tlb_invalidate(pgdir, va);
c01036d4:	83 ec 08             	sub    $0x8,%esp
c01036d7:	ff 75 f4             	pushl  -0xc(%ebp)
c01036da:	ff 75 08             	pushl  0x8(%ebp)
c01036dd:	e8 49 42 00 00       	call   c010792b <tlb_invalidate>
c01036e2:	83 c4 10             	add    $0x10,%esp
}

void
_enclock_reset_pte(pde_t* pgdir) {
    cprintf("PTEs resetting...\n");
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c01036e5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01036ec:	81 7d f4 00 40 00 00 	cmpl   $0x4000,-0xc(%ebp)
c01036f3:	76 ab                	jbe    c01036a0 <_enclock_reset_pte+0x1f>
        pte_t* ptep = get_pte(pgdir, va, 0);
        *ptep = *ptep & ~PTE_A;
        *ptep = *ptep & ~PTE_D;
        tlb_invalidate(pgdir, va);
    }
    cprintf("PTEs reseted!\n");
c01036f5:	83 ec 0c             	sub    $0xc,%esp
c01036f8:	68 1b a5 10 c0       	push   $0xc010a51b
c01036fd:	e8 90 cb ff ff       	call   c0100292 <cprintf>
c0103702:	83 c4 10             	add    $0x10,%esp
}
c0103705:	90                   	nop
c0103706:	c9                   	leave  
c0103707:	c3                   	ret    

c0103708 <_enclock_print_pte>:

void
_enclock_print_pte(pte_t* ptep, unsigned int va) {
c0103708:	55                   	push   %ebp
c0103709:	89 e5                	mov    %esp,%ebp
c010370b:	83 ec 08             	sub    $0x8,%esp
    cprintf("va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", va, *ptep, *ptep & PTE_A, *ptep & PTE_D);
c010370e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103711:	8b 00                	mov    (%eax),%eax
c0103713:	83 e0 40             	and    $0x40,%eax
c0103716:	89 c1                	mov    %eax,%ecx
c0103718:	8b 45 08             	mov    0x8(%ebp),%eax
c010371b:	8b 00                	mov    (%eax),%eax
c010371d:	83 e0 20             	and    $0x20,%eax
c0103720:	89 c2                	mov    %eax,%edx
c0103722:	8b 45 08             	mov    0x8(%ebp),%eax
c0103725:	8b 00                	mov    (%eax),%eax
c0103727:	83 ec 0c             	sub    $0xc,%esp
c010372a:	51                   	push   %ecx
c010372b:	52                   	push   %edx
c010372c:	50                   	push   %eax
c010372d:	ff 75 0c             	pushl  0xc(%ebp)
c0103730:	68 2c a5 10 c0       	push   $0xc010a52c
c0103735:	e8 58 cb ff ff       	call   c0100292 <cprintf>
c010373a:	83 c4 20             	add    $0x20,%esp
}
c010373d:	90                   	nop
c010373e:	c9                   	leave  
c010373f:	c3                   	ret    

c0103740 <_enclock_check_swap>:

static int
_enclock_check_swap(void) {
c0103740:	55                   	push   %ebp
c0103741:	89 e5                	mov    %esp,%ebp
c0103743:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103746:	0f 20 d8             	mov    %cr3,%eax
c0103749:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return cr3;
c010374c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    _enclock_reset_pte(KADDR(((pde_t *)rcr3())));
c010374f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103755:	c1 e8 0c             	shr    $0xc,%eax
c0103758:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010375b:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0103760:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103763:	72 17                	jb     c010377c <_enclock_check_swap+0x3c>
c0103765:	ff 75 f4             	pushl  -0xc(%ebp)
c0103768:	68 54 a5 10 c0       	push   $0xc010a554
c010376d:	68 96 00 00 00       	push   $0x96
c0103772:	68 77 a4 10 c0       	push   $0xc010a477
c0103777:	e8 7c cc ff ff       	call   c01003f8 <__panic>
c010377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103784:	83 ec 0c             	sub    $0xc,%esp
c0103787:	50                   	push   %eax
c0103788:	e8 f4 fe ff ff       	call   c0103681 <_enclock_reset_pte>
c010378d:	83 c4 10             	add    $0x10,%esp
    cprintf("read Virt Page c in enclock_check_swap\n");
c0103790:	83 ec 0c             	sub    $0xc,%esp
c0103793:	68 78 a5 10 c0       	push   $0xc010a578
c0103798:	e8 f5 ca ff ff       	call   c0100292 <cprintf>
c010379d:	83 c4 10             	add    $0x10,%esp
    unsigned char tmp = *(unsigned char *)0x3000;
c01037a0:	b8 00 30 00 00       	mov    $0x3000,%eax
c01037a5:	0f b6 00             	movzbl (%eax),%eax
c01037a8:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c01037ab:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01037b0:	83 f8 04             	cmp    $0x4,%eax
c01037b3:	74 19                	je     c01037ce <_enclock_check_swap+0x8e>
c01037b5:	68 a0 a5 10 c0       	push   $0xc010a5a0
c01037ba:	68 62 a4 10 c0       	push   $0xc010a462
c01037bf:	68 99 00 00 00       	push   $0x99
c01037c4:	68 77 a4 10 c0       	push   $0xc010a477
c01037c9:	e8 2a cc ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c01037ce:	83 ec 0c             	sub    $0xc,%esp
c01037d1:	68 b0 a5 10 c0       	push   $0xc010a5b0
c01037d6:	e8 b7 ca ff ff       	call   c0100292 <cprintf>
c01037db:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01037de:	b8 00 10 00 00       	mov    $0x1000,%eax
c01037e3:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01037e6:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01037eb:	83 f8 04             	cmp    $0x4,%eax
c01037ee:	74 19                	je     c0103809 <_enclock_check_swap+0xc9>
c01037f0:	68 a0 a5 10 c0       	push   $0xc010a5a0
c01037f5:	68 62 a4 10 c0       	push   $0xc010a462
c01037fa:	68 9c 00 00 00       	push   $0x9c
c01037ff:	68 77 a4 10 c0       	push   $0xc010a477
c0103804:	e8 ef cb ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c0103809:	83 ec 0c             	sub    $0xc,%esp
c010380c:	68 dc a5 10 c0       	push   $0xc010a5dc
c0103811:	e8 7c ca ff ff       	call   c0100292 <cprintf>
c0103816:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c0103819:	b8 00 40 00 00       	mov    $0x4000,%eax
c010381e:	0f b6 00             	movzbl (%eax),%eax
c0103821:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c0103824:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103829:	83 f8 04             	cmp    $0x4,%eax
c010382c:	74 19                	je     c0103847 <_enclock_check_swap+0x107>
c010382e:	68 a0 a5 10 c0       	push   $0xc010a5a0
c0103833:	68 62 a4 10 c0       	push   $0xc010a462
c0103838:	68 9f 00 00 00       	push   $0x9f
c010383d:	68 77 a4 10 c0       	push   $0xc010a477
c0103842:	e8 b1 cb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in enclock_check_swap\n");
c0103847:	83 ec 0c             	sub    $0xc,%esp
c010384a:	68 04 a6 10 c0       	push   $0xc010a604
c010384f:	e8 3e ca ff ff       	call   c0100292 <cprintf>
c0103854:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0103857:	b8 00 20 00 00       	mov    $0x2000,%eax
c010385c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010385f:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103864:	83 f8 04             	cmp    $0x4,%eax
c0103867:	74 19                	je     c0103882 <_enclock_check_swap+0x142>
c0103869:	68 a0 a5 10 c0       	push   $0xc010a5a0
c010386e:	68 62 a4 10 c0       	push   $0xc010a462
c0103873:	68 a2 00 00 00       	push   $0xa2
c0103878:	68 77 a4 10 c0       	push   $0xc010a477
c010387d:	e8 76 cb ff ff       	call   c01003f8 <__panic>

    cprintf("write Virt Page e in enclock_check_swap\n");
c0103882:	83 ec 0c             	sub    $0xc,%esp
c0103885:	68 30 a6 10 c0       	push   $0xc010a630
c010388a:	e8 03 ca ff ff       	call   c0100292 <cprintf>
c010388f:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0103892:	b8 00 50 00 00       	mov    $0x5000,%eax
c0103897:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c010389a:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010389f:	83 f8 05             	cmp    $0x5,%eax
c01038a2:	74 19                	je     c01038bd <_enclock_check_swap+0x17d>
c01038a4:	68 59 a6 10 c0       	push   $0xc010a659
c01038a9:	68 62 a4 10 c0       	push   $0xc010a462
c01038ae:	68 a6 00 00 00       	push   $0xa6
c01038b3:	68 77 a4 10 c0       	push   $0xc010a477
c01038b8:	e8 3b cb ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c01038bd:	83 ec 0c             	sub    $0xc,%esp
c01038c0:	68 68 a6 10 c0       	push   $0xc010a668
c01038c5:	e8 c8 c9 ff ff       	call   c0100292 <cprintf>
c01038ca:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c01038cd:	b8 00 20 00 00       	mov    $0x2000,%eax
c01038d2:	0f b6 00             	movzbl (%eax),%eax
c01038d5:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c01038d8:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01038dd:	83 f8 05             	cmp    $0x5,%eax
c01038e0:	74 19                	je     c01038fb <_enclock_check_swap+0x1bb>
c01038e2:	68 59 a6 10 c0       	push   $0xc010a659
c01038e7:	68 62 a4 10 c0       	push   $0xc010a462
c01038ec:	68 a9 00 00 00       	push   $0xa9
c01038f1:	68 77 a4 10 c0       	push   $0xc010a477
c01038f6:	e8 fd ca ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c01038fb:	83 ec 0c             	sub    $0xc,%esp
c01038fe:	68 b0 a5 10 c0       	push   $0xc010a5b0
c0103903:	e8 8a c9 ff ff       	call   c0100292 <cprintf>
c0103908:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c010390b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103910:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==5);
c0103913:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103918:	83 f8 05             	cmp    $0x5,%eax
c010391b:	74 19                	je     c0103936 <_enclock_check_swap+0x1f6>
c010391d:	68 59 a6 10 c0       	push   $0xc010a659
c0103922:	68 62 a4 10 c0       	push   $0xc010a462
c0103927:	68 ac 00 00 00       	push   $0xac
c010392c:	68 77 a4 10 c0       	push   $0xc010a477
c0103931:	e8 c2 ca ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c0103936:	83 ec 0c             	sub    $0xc,%esp
c0103939:	68 68 a6 10 c0       	push   $0xc010a668
c010393e:	e8 4f c9 ff ff       	call   c0100292 <cprintf>
c0103943:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c0103946:	b8 00 20 00 00       	mov    $0x2000,%eax
c010394b:	0f b6 00             	movzbl (%eax),%eax
c010394e:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c0103951:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103956:	83 f8 05             	cmp    $0x5,%eax
c0103959:	74 19                	je     c0103974 <_enclock_check_swap+0x234>
c010395b:	68 59 a6 10 c0       	push   $0xc010a659
c0103960:	68 62 a4 10 c0       	push   $0xc010a462
c0103965:	68 af 00 00 00       	push   $0xaf
c010396a:	68 77 a4 10 c0       	push   $0xc010a477
c010396f:	e8 84 ca ff ff       	call   c01003f8 <__panic>

    cprintf("read Virt Page c in enclock_check_swap\n");
c0103974:	83 ec 0c             	sub    $0xc,%esp
c0103977:	68 78 a5 10 c0       	push   $0xc010a578
c010397c:	e8 11 c9 ff ff       	call   c0100292 <cprintf>
c0103981:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x3000;
c0103984:	b8 00 30 00 00       	mov    $0x3000,%eax
c0103989:	0f b6 00             	movzbl (%eax),%eax
c010398c:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==6);
c010398f:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0103994:	83 f8 06             	cmp    $0x6,%eax
c0103997:	74 19                	je     c01039b2 <_enclock_check_swap+0x272>
c0103999:	68 90 a6 10 c0       	push   $0xc010a690
c010399e:	68 62 a4 10 c0       	push   $0xc010a462
c01039a3:	68 b3 00 00 00       	push   $0xb3
c01039a8:	68 77 a4 10 c0       	push   $0xc010a477
c01039ad:	e8 46 ca ff ff       	call   c01003f8 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c01039b2:	83 ec 0c             	sub    $0xc,%esp
c01039b5:	68 dc a5 10 c0       	push   $0xc010a5dc
c01039ba:	e8 d3 c8 ff ff       	call   c0100292 <cprintf>
c01039bf:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c01039c2:	b8 00 40 00 00       	mov    $0x4000,%eax
c01039c7:	0f b6 00             	movzbl (%eax),%eax
c01039ca:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==7);
c01039cd:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01039d2:	83 f8 07             	cmp    $0x7,%eax
c01039d5:	74 19                	je     c01039f0 <_enclock_check_swap+0x2b0>
c01039d7:	68 9f a6 10 c0       	push   $0xc010a69f
c01039dc:	68 62 a4 10 c0       	push   $0xc010a462
c01039e1:	68 b6 00 00 00       	push   $0xb6
c01039e6:	68 77 a4 10 c0       	push   $0xc010a477
c01039eb:	e8 08 ca ff ff       	call   c01003f8 <__panic>
    return 0;
c01039f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01039f5:	c9                   	leave  
c01039f6:	c3                   	ret    

c01039f7 <_enclock_init>:


static int
_enclock_init(void)
{
c01039f7:	55                   	push   %ebp
c01039f8:	89 e5                	mov    %esp,%ebp
    return 0;
c01039fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01039ff:	5d                   	pop    %ebp
c0103a00:	c3                   	ret    

c0103a01 <_enclock_set_unswappable>:

static int
_enclock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0103a01:	55                   	push   %ebp
c0103a02:	89 e5                	mov    %esp,%ebp
    return 0;
c0103a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a09:	5d                   	pop    %ebp
c0103a0a:	c3                   	ret    

c0103a0b <_enclock_tick_event>:

static int
_enclock_tick_event(struct mm_struct *mm)
{ return 0; }
c0103a0b:	55                   	push   %ebp
c0103a0c:	89 e5                	mov    %esp,%ebp
c0103a0e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103a13:	5d                   	pop    %ebp
c0103a14:	c3                   	ret    

c0103a15 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a15:	55                   	push   %ebp
c0103a16:	89 e5                	mov    %esp,%ebp
c0103a18:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0103a1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1e:	c1 e8 0c             	shr    $0xc,%eax
c0103a21:	89 c2                	mov    %eax,%edx
c0103a23:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0103a28:	39 c2                	cmp    %eax,%edx
c0103a2a:	72 14                	jb     c0103a40 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0103a2c:	83 ec 04             	sub    $0x4,%esp
c0103a2f:	68 cc a6 10 c0       	push   $0xc010a6cc
c0103a34:	6a 5f                	push   $0x5f
c0103a36:	68 eb a6 10 c0       	push   $0xc010a6eb
c0103a3b:	e8 b8 c9 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0103a40:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0103a45:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a48:	c1 ea 0c             	shr    $0xc,%edx
c0103a4b:	c1 e2 05             	shl    $0x5,%edx
c0103a4e:	01 d0                	add    %edx,%eax
}
c0103a50:	c9                   	leave  
c0103a51:	c3                   	ret    

c0103a52 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0103a52:	55                   	push   %ebp
c0103a53:	89 e5                	mov    %esp,%ebp
c0103a55:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0103a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a60:	83 ec 0c             	sub    $0xc,%esp
c0103a63:	50                   	push   %eax
c0103a64:	e8 ac ff ff ff       	call   c0103a15 <pa2page>
c0103a69:	83 c4 10             	add    $0x10,%esp
}
c0103a6c:	c9                   	leave  
c0103a6d:	c3                   	ret    

c0103a6e <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0103a6e:	55                   	push   %ebp
c0103a6f:	89 e5                	mov    %esp,%ebp
c0103a71:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0103a74:	83 ec 0c             	sub    $0xc,%esp
c0103a77:	6a 18                	push   $0x18
c0103a79:	e8 74 16 00 00       	call   c01050f2 <kmalloc>
c0103a7e:	83 c4 10             	add    $0x10,%esp
c0103a81:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0103a84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a88:	74 5b                	je     c0103ae5 <mm_create+0x77>
        list_init(&(mm->mmap_list));
c0103a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a93:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103a96:	89 50 04             	mov    %edx,0x4(%eax)
c0103a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a9c:	8b 50 04             	mov    0x4(%eax),%edx
c0103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aa2:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0103aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0103ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103abb:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0103ac2:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c0103ac7:	85 c0                	test   %eax,%eax
c0103ac9:	74 10                	je     c0103adb <mm_create+0x6d>
c0103acb:	83 ec 0c             	sub    $0xc,%esp
c0103ace:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ad1:	e8 7c 18 00 00       	call   c0105352 <swap_init_mm>
c0103ad6:	83 c4 10             	add    $0x10,%esp
c0103ad9:	eb 0a                	jmp    c0103ae5 <mm_create+0x77>
        else mm->sm_priv = NULL;
c0103adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ade:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0103ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103ae8:	c9                   	leave  
c0103ae9:	c3                   	ret    

c0103aea <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0103aea:	55                   	push   %ebp
c0103aeb:	89 e5                	mov    %esp,%ebp
c0103aed:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103af0:	83 ec 0c             	sub    $0xc,%esp
c0103af3:	6a 18                	push   $0x18
c0103af5:	e8 f8 15 00 00       	call   c01050f2 <kmalloc>
c0103afa:	83 c4 10             	add    $0x10,%esp
c0103afd:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0103b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b04:	74 1b                	je     c0103b21 <vma_create+0x37>
        vma->vm_start = vm_start;
c0103b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b09:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b0c:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0103b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b12:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b15:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0103b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b1b:	8b 55 10             	mov    0x10(%ebp),%edx
c0103b1e:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0103b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103b24:	c9                   	leave  
c0103b25:	c3                   	ret    

c0103b26 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0103b26:	55                   	push   %ebp
c0103b27:	89 e5                	mov    %esp,%ebp
c0103b29:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0103b2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0103b33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b37:	0f 84 95 00 00 00    	je     c0103bd2 <find_vma+0xac>
        vma = mm->mmap_cache;
c0103b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b40:	8b 40 08             	mov    0x8(%eax),%eax
c0103b43:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0103b46:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103b4a:	74 16                	je     c0103b62 <find_vma+0x3c>
c0103b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b4f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b52:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b55:	77 0b                	ja     c0103b62 <find_vma+0x3c>
c0103b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b5a:	8b 40 08             	mov    0x8(%eax),%eax
c0103b5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b60:	77 61                	ja     c0103bc3 <find_vma+0x9d>
                bool found = 0;
c0103b62:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0103b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103b75:	eb 28                	jmp    c0103b9f <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0103b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b7a:	83 e8 10             	sub    $0x10,%eax
c0103b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b83:	8b 40 04             	mov    0x4(%eax),%eax
c0103b86:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b89:	77 14                	ja     c0103b9f <find_vma+0x79>
c0103b8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b8e:	8b 40 08             	mov    0x8(%eax),%eax
c0103b91:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b94:	76 09                	jbe    c0103b9f <find_vma+0x79>
                        found = 1;
c0103b96:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103b9d:	eb 17                	jmp    c0103bb6 <find_vma+0x90>
c0103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ba8:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0103bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bb1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103bb4:	75 c1                	jne    c0103b77 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0103bb6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103bba:	75 07                	jne    c0103bc3 <find_vma+0x9d>
                    vma = NULL;
c0103bbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103bc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103bc7:	74 09                	je     c0103bd2 <find_vma+0xac>
            mm->mmap_cache = vma;
c0103bc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103bcf:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103bd5:	c9                   	leave  
c0103bd6:	c3                   	ret    

c0103bd7 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0103bd7:	55                   	push   %ebp
c0103bd8:	89 e5                	mov    %esp,%ebp
c0103bda:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
c0103bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be0:	8b 50 04             	mov    0x4(%eax),%edx
c0103be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be6:	8b 40 08             	mov    0x8(%eax),%eax
c0103be9:	39 c2                	cmp    %eax,%edx
c0103beb:	72 16                	jb     c0103c03 <check_vma_overlap+0x2c>
c0103bed:	68 f9 a6 10 c0       	push   $0xc010a6f9
c0103bf2:	68 17 a7 10 c0       	push   $0xc010a717
c0103bf7:	6a 68                	push   $0x68
c0103bf9:	68 2c a7 10 c0       	push   $0xc010a72c
c0103bfe:	e8 f5 c7 ff ff       	call   c01003f8 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c06:	8b 50 08             	mov    0x8(%eax),%edx
c0103c09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c0c:	8b 40 04             	mov    0x4(%eax),%eax
c0103c0f:	39 c2                	cmp    %eax,%edx
c0103c11:	76 16                	jbe    c0103c29 <check_vma_overlap+0x52>
c0103c13:	68 3c a7 10 c0       	push   $0xc010a73c
c0103c18:	68 17 a7 10 c0       	push   $0xc010a717
c0103c1d:	6a 69                	push   $0x69
c0103c1f:	68 2c a7 10 c0       	push   $0xc010a72c
c0103c24:	e8 cf c7 ff ff       	call   c01003f8 <__panic>
    assert(next->vm_start < next->vm_end);
c0103c29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c2c:	8b 50 04             	mov    0x4(%eax),%edx
c0103c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c32:	8b 40 08             	mov    0x8(%eax),%eax
c0103c35:	39 c2                	cmp    %eax,%edx
c0103c37:	72 16                	jb     c0103c4f <check_vma_overlap+0x78>
c0103c39:	68 5b a7 10 c0       	push   $0xc010a75b
c0103c3e:	68 17 a7 10 c0       	push   $0xc010a717
c0103c43:	6a 6a                	push   $0x6a
c0103c45:	68 2c a7 10 c0       	push   $0xc010a72c
c0103c4a:	e8 a9 c7 ff ff       	call   c01003f8 <__panic>
}
c0103c4f:	90                   	nop
c0103c50:	c9                   	leave  
c0103c51:	c3                   	ret    

c0103c52 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103c52:	55                   	push   %ebp
c0103c53:	89 e5                	mov    %esp,%ebp
c0103c55:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
c0103c58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c5b:	8b 50 04             	mov    0x4(%eax),%edx
c0103c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c61:	8b 40 08             	mov    0x8(%eax),%eax
c0103c64:	39 c2                	cmp    %eax,%edx
c0103c66:	72 16                	jb     c0103c7e <insert_vma_struct+0x2c>
c0103c68:	68 79 a7 10 c0       	push   $0xc010a779
c0103c6d:	68 17 a7 10 c0       	push   $0xc010a717
c0103c72:	6a 71                	push   $0x71
c0103c74:	68 2c a7 10 c0       	push   $0xc010a72c
c0103c79:	e8 7a c7 ff ff       	call   c01003f8 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c81:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c87:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0103c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0103c90:	eb 1f                	jmp    c0103cb1 <insert_vma_struct+0x5f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c95:	83 e8 10             	sub    $0x10,%eax
c0103c98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0103c9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c9e:	8b 50 04             	mov    0x4(%eax),%edx
c0103ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ca4:	8b 40 04             	mov    0x4(%eax),%eax
c0103ca7:	39 c2                	cmp    %eax,%edx
c0103ca9:	77 1f                	ja     c0103cca <insert_vma_struct+0x78>
                break;
            }
            le_prev = le;
c0103cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103cb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cba:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0103cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cc6:	75 ca                	jne    c0103c92 <insert_vma_struct+0x40>
c0103cc8:	eb 01                	jmp    c0103ccb <insert_vma_struct+0x79>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
c0103cca:	90                   	nop
c0103ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cce:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103cd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cd4:	8b 40 04             	mov    0x4(%eax),%eax
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0103cd7:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0103cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cdd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103ce0:	74 15                	je     c0103cf7 <insert_vma_struct+0xa5>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce5:	83 e8 10             	sub    $0x10,%eax
c0103ce8:	83 ec 08             	sub    $0x8,%esp
c0103ceb:	ff 75 0c             	pushl  0xc(%ebp)
c0103cee:	50                   	push   %eax
c0103cef:	e8 e3 fe ff ff       	call   c0103bd7 <check_vma_overlap>
c0103cf4:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
c0103cf7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103cfa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cfd:	74 15                	je     c0103d14 <insert_vma_struct+0xc2>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103cff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d02:	83 e8 10             	sub    $0x10,%eax
c0103d05:	83 ec 08             	sub    $0x8,%esp
c0103d08:	50                   	push   %eax
c0103d09:	ff 75 0c             	pushl  0xc(%ebp)
c0103d0c:	e8 c6 fe ff ff       	call   c0103bd7 <check_vma_overlap>
c0103d11:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
c0103d14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d17:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d1a:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d1f:	8d 50 10             	lea    0x10(%eax),%edx
c0103d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d25:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d28:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d2e:	8b 40 04             	mov    0x4(%eax),%eax
c0103d31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d34:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103d37:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103d3a:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103d3d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103d40:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d43:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d46:	89 10                	mov    %edx,(%eax)
c0103d48:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d4b:	8b 10                	mov    (%eax),%edx
c0103d4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d50:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103d53:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d56:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103d59:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103d5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103d62:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103d64:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d67:	8b 40 10             	mov    0x10(%eax),%eax
c0103d6a:	8d 50 01             	lea    0x1(%eax),%edx
c0103d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d70:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103d73:	90                   	nop
c0103d74:	c9                   	leave  
c0103d75:	c3                   	ret    

c0103d76 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0103d76:	55                   	push   %ebp
c0103d77:	89 e5                	mov    %esp,%ebp
c0103d79:	83 ec 28             	sub    $0x28,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103d7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103d82:	eb 3a                	jmp    c0103dbe <mm_destroy+0x48>
c0103d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d87:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103d8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d8d:	8b 40 04             	mov    0x4(%eax),%eax
c0103d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103d93:	8b 12                	mov    (%edx),%edx
c0103d95:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0103d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103da1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103da7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103daa:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0103dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103daf:	83 e8 10             	sub    $0x10,%eax
c0103db2:	83 ec 0c             	sub    $0xc,%esp
c0103db5:	50                   	push   %eax
c0103db6:	e8 4f 13 00 00       	call   c010510a <kfree>
c0103dbb:	83 c4 10             	add    $0x10,%esp
c0103dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dc7:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0103dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dd0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103dd3:	75 af                	jne    c0103d84 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0103dd5:	83 ec 0c             	sub    $0xc,%esp
c0103dd8:	ff 75 08             	pushl  0x8(%ebp)
c0103ddb:	e8 2a 13 00 00       	call   c010510a <kfree>
c0103de0:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
c0103de3:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0103dea:	90                   	nop
c0103deb:	c9                   	leave  
c0103dec:	c3                   	ret    

c0103ded <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0103ded:	55                   	push   %ebp
c0103dee:	89 e5                	mov    %esp,%ebp
c0103df0:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103df3:	e8 03 00 00 00       	call   c0103dfb <check_vmm>
}
c0103df8:	90                   	nop
c0103df9:	c9                   	leave  
c0103dfa:	c3                   	ret    

c0103dfb <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0103dfb:	55                   	push   %ebp
c0103dfc:	89 e5                	mov    %esp,%ebp
c0103dfe:	83 ec 18             	sub    $0x18,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e01:	e8 62 32 00 00       	call   c0107068 <nr_free_pages>
c0103e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103e09:	e8 18 00 00 00       	call   c0103e26 <check_vma_struct>
    check_pgfault();
c0103e0e:	e8 10 04 00 00       	call   c0104223 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0103e13:	83 ec 0c             	sub    $0xc,%esp
c0103e16:	68 95 a7 10 c0       	push   $0xc010a795
c0103e1b:	e8 72 c4 ff ff       	call   c0100292 <cprintf>
c0103e20:	83 c4 10             	add    $0x10,%esp
}
c0103e23:	90                   	nop
c0103e24:	c9                   	leave  
c0103e25:	c3                   	ret    

c0103e26 <check_vma_struct>:

static void
check_vma_struct(void) {
c0103e26:	55                   	push   %ebp
c0103e27:	89 e5                	mov    %esp,%ebp
c0103e29:	83 ec 58             	sub    $0x58,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e2c:	e8 37 32 00 00       	call   c0107068 <nr_free_pages>
c0103e31:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0103e34:	e8 35 fc ff ff       	call   c0103a6e <mm_create>
c0103e39:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103e3c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103e40:	75 19                	jne    c0103e5b <check_vma_struct+0x35>
c0103e42:	68 ad a7 10 c0       	push   $0xc010a7ad
c0103e47:	68 17 a7 10 c0       	push   $0xc010a717
c0103e4c:	68 b2 00 00 00       	push   $0xb2
c0103e51:	68 2c a7 10 c0       	push   $0xc010a72c
c0103e56:	e8 9d c5 ff ff       	call   c01003f8 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103e5b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0103e62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e65:	89 d0                	mov    %edx,%eax
c0103e67:	c1 e0 02             	shl    $0x2,%eax
c0103e6a:	01 d0                	add    %edx,%eax
c0103e6c:	01 c0                	add    %eax,%eax
c0103e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0103e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103e77:	eb 5f                	jmp    c0103ed8 <check_vma_struct+0xb2>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e7c:	89 d0                	mov    %edx,%eax
c0103e7e:	c1 e0 02             	shl    $0x2,%eax
c0103e81:	01 d0                	add    %edx,%eax
c0103e83:	83 c0 02             	add    $0x2,%eax
c0103e86:	89 c1                	mov    %eax,%ecx
c0103e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e8b:	89 d0                	mov    %edx,%eax
c0103e8d:	c1 e0 02             	shl    $0x2,%eax
c0103e90:	01 d0                	add    %edx,%eax
c0103e92:	83 ec 04             	sub    $0x4,%esp
c0103e95:	6a 00                	push   $0x0
c0103e97:	51                   	push   %ecx
c0103e98:	50                   	push   %eax
c0103e99:	e8 4c fc ff ff       	call   c0103aea <vma_create>
c0103e9e:	83 c4 10             	add    $0x10,%esp
c0103ea1:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0103ea4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103ea8:	75 19                	jne    c0103ec3 <check_vma_struct+0x9d>
c0103eaa:	68 b8 a7 10 c0       	push   $0xc010a7b8
c0103eaf:	68 17 a7 10 c0       	push   $0xc010a717
c0103eb4:	68 b9 00 00 00       	push   $0xb9
c0103eb9:	68 2c a7 10 c0       	push   $0xc010a72c
c0103ebe:	e8 35 c5 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103ec3:	83 ec 08             	sub    $0x8,%esp
c0103ec6:	ff 75 dc             	pushl  -0x24(%ebp)
c0103ec9:	ff 75 e8             	pushl  -0x18(%ebp)
c0103ecc:	e8 81 fd ff ff       	call   c0103c52 <insert_vma_struct>
c0103ed1:	83 c4 10             	add    $0x10,%esp
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0103ed4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103edc:	7f 9b                	jg     c0103e79 <check_vma_struct+0x53>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103ede:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ee1:	83 c0 01             	add    $0x1,%eax
c0103ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ee7:	eb 5f                	jmp    c0103f48 <check_vma_struct+0x122>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103eec:	89 d0                	mov    %edx,%eax
c0103eee:	c1 e0 02             	shl    $0x2,%eax
c0103ef1:	01 d0                	add    %edx,%eax
c0103ef3:	83 c0 02             	add    $0x2,%eax
c0103ef6:	89 c1                	mov    %eax,%ecx
c0103ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103efb:	89 d0                	mov    %edx,%eax
c0103efd:	c1 e0 02             	shl    $0x2,%eax
c0103f00:	01 d0                	add    %edx,%eax
c0103f02:	83 ec 04             	sub    $0x4,%esp
c0103f05:	6a 00                	push   $0x0
c0103f07:	51                   	push   %ecx
c0103f08:	50                   	push   %eax
c0103f09:	e8 dc fb ff ff       	call   c0103aea <vma_create>
c0103f0e:	83 c4 10             	add    $0x10,%esp
c0103f11:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0103f14:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103f18:	75 19                	jne    c0103f33 <check_vma_struct+0x10d>
c0103f1a:	68 b8 a7 10 c0       	push   $0xc010a7b8
c0103f1f:	68 17 a7 10 c0       	push   $0xc010a717
c0103f24:	68 bf 00 00 00       	push   $0xbf
c0103f29:	68 2c a7 10 c0       	push   $0xc010a72c
c0103f2e:	e8 c5 c4 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103f33:	83 ec 08             	sub    $0x8,%esp
c0103f36:	ff 75 d8             	pushl  -0x28(%ebp)
c0103f39:	ff 75 e8             	pushl  -0x18(%ebp)
c0103f3c:	e8 11 fd ff ff       	call   c0103c52 <insert_vma_struct>
c0103f41:	83 c4 10             	add    $0x10,%esp
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103f44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f4b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103f4e:	7e 99                	jle    c0103ee9 <check_vma_struct+0xc3>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0103f50:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f53:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103f56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f59:	8b 40 04             	mov    0x4(%eax),%eax
c0103f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103f5f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103f66:	e9 81 00 00 00       	jmp    c0103fec <check_vma_struct+0x1c6>
        assert(le != &(mm->mmap_list));
c0103f6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103f71:	75 19                	jne    c0103f8c <check_vma_struct+0x166>
c0103f73:	68 c4 a7 10 c0       	push   $0xc010a7c4
c0103f78:	68 17 a7 10 c0       	push   $0xc010a717
c0103f7d:	68 c6 00 00 00       	push   $0xc6
c0103f82:	68 2c a7 10 c0       	push   $0xc010a72c
c0103f87:	e8 6c c4 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f8f:	83 e8 10             	sub    $0x10,%eax
c0103f92:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103f95:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f98:	8b 48 04             	mov    0x4(%eax),%ecx
c0103f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f9e:	89 d0                	mov    %edx,%eax
c0103fa0:	c1 e0 02             	shl    $0x2,%eax
c0103fa3:	01 d0                	add    %edx,%eax
c0103fa5:	39 c1                	cmp    %eax,%ecx
c0103fa7:	75 17                	jne    c0103fc0 <check_vma_struct+0x19a>
c0103fa9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fac:	8b 48 08             	mov    0x8(%eax),%ecx
c0103faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103fb2:	89 d0                	mov    %edx,%eax
c0103fb4:	c1 e0 02             	shl    $0x2,%eax
c0103fb7:	01 d0                	add    %edx,%eax
c0103fb9:	83 c0 02             	add    $0x2,%eax
c0103fbc:	39 c1                	cmp    %eax,%ecx
c0103fbe:	74 19                	je     c0103fd9 <check_vma_struct+0x1b3>
c0103fc0:	68 dc a7 10 c0       	push   $0xc010a7dc
c0103fc5:	68 17 a7 10 c0       	push   $0xc010a717
c0103fca:	68 c8 00 00 00       	push   $0xc8
c0103fcf:	68 2c a7 10 c0       	push   $0xc010a72c
c0103fd4:	e8 1f c4 ff ff       	call   c01003f8 <__panic>
c0103fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fdc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103fdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103fe2:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0103fe8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fef:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103ff2:	0f 8e 73 ff ff ff    	jle    c0103f6b <check_vma_struct+0x145>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0103ff8:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0103fff:	e9 80 01 00 00       	jmp    c0104184 <check_vma_struct+0x35e>
        struct vma_struct *vma1 = find_vma(mm, i);
c0104004:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104007:	83 ec 08             	sub    $0x8,%esp
c010400a:	50                   	push   %eax
c010400b:	ff 75 e8             	pushl  -0x18(%ebp)
c010400e:	e8 13 fb ff ff       	call   c0103b26 <find_vma>
c0104013:	83 c4 10             	add    $0x10,%esp
c0104016:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c0104019:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010401d:	75 19                	jne    c0104038 <check_vma_struct+0x212>
c010401f:	68 11 a8 10 c0       	push   $0xc010a811
c0104024:	68 17 a7 10 c0       	push   $0xc010a717
c0104029:	68 ce 00 00 00       	push   $0xce
c010402e:	68 2c a7 10 c0       	push   $0xc010a72c
c0104033:	e8 c0 c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0104038:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010403b:	83 c0 01             	add    $0x1,%eax
c010403e:	83 ec 08             	sub    $0x8,%esp
c0104041:	50                   	push   %eax
c0104042:	ff 75 e8             	pushl  -0x18(%ebp)
c0104045:	e8 dc fa ff ff       	call   c0103b26 <find_vma>
c010404a:	83 c4 10             	add    $0x10,%esp
c010404d:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c0104050:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104054:	75 19                	jne    c010406f <check_vma_struct+0x249>
c0104056:	68 1e a8 10 c0       	push   $0xc010a81e
c010405b:	68 17 a7 10 c0       	push   $0xc010a717
c0104060:	68 d0 00 00 00       	push   $0xd0
c0104065:	68 2c a7 10 c0       	push   $0xc010a72c
c010406a:	e8 89 c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c010406f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104072:	83 c0 02             	add    $0x2,%eax
c0104075:	83 ec 08             	sub    $0x8,%esp
c0104078:	50                   	push   %eax
c0104079:	ff 75 e8             	pushl  -0x18(%ebp)
c010407c:	e8 a5 fa ff ff       	call   c0103b26 <find_vma>
c0104081:	83 c4 10             	add    $0x10,%esp
c0104084:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c0104087:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c010408b:	74 19                	je     c01040a6 <check_vma_struct+0x280>
c010408d:	68 2b a8 10 c0       	push   $0xc010a82b
c0104092:	68 17 a7 10 c0       	push   $0xc010a717
c0104097:	68 d2 00 00 00       	push   $0xd2
c010409c:	68 2c a7 10 c0       	push   $0xc010a72c
c01040a1:	e8 52 c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01040a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040a9:	83 c0 03             	add    $0x3,%eax
c01040ac:	83 ec 08             	sub    $0x8,%esp
c01040af:	50                   	push   %eax
c01040b0:	ff 75 e8             	pushl  -0x18(%ebp)
c01040b3:	e8 6e fa ff ff       	call   c0103b26 <find_vma>
c01040b8:	83 c4 10             	add    $0x10,%esp
c01040bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c01040be:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01040c2:	74 19                	je     c01040dd <check_vma_struct+0x2b7>
c01040c4:	68 38 a8 10 c0       	push   $0xc010a838
c01040c9:	68 17 a7 10 c0       	push   $0xc010a717
c01040ce:	68 d4 00 00 00       	push   $0xd4
c01040d3:	68 2c a7 10 c0       	push   $0xc010a72c
c01040d8:	e8 1b c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01040dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040e0:	83 c0 04             	add    $0x4,%eax
c01040e3:	83 ec 08             	sub    $0x8,%esp
c01040e6:	50                   	push   %eax
c01040e7:	ff 75 e8             	pushl  -0x18(%ebp)
c01040ea:	e8 37 fa ff ff       	call   c0103b26 <find_vma>
c01040ef:	83 c4 10             	add    $0x10,%esp
c01040f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c01040f5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01040f9:	74 19                	je     c0104114 <check_vma_struct+0x2ee>
c01040fb:	68 45 a8 10 c0       	push   $0xc010a845
c0104100:	68 17 a7 10 c0       	push   $0xc010a717
c0104105:	68 d6 00 00 00       	push   $0xd6
c010410a:	68 2c a7 10 c0       	push   $0xc010a72c
c010410f:	e8 e4 c2 ff ff       	call   c01003f8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0104114:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104117:	8b 50 04             	mov    0x4(%eax),%edx
c010411a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010411d:	39 c2                	cmp    %eax,%edx
c010411f:	75 10                	jne    c0104131 <check_vma_struct+0x30b>
c0104121:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104124:	8b 40 08             	mov    0x8(%eax),%eax
c0104127:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010412a:	83 c2 02             	add    $0x2,%edx
c010412d:	39 d0                	cmp    %edx,%eax
c010412f:	74 19                	je     c010414a <check_vma_struct+0x324>
c0104131:	68 54 a8 10 c0       	push   $0xc010a854
c0104136:	68 17 a7 10 c0       	push   $0xc010a717
c010413b:	68 d8 00 00 00       	push   $0xd8
c0104140:	68 2c a7 10 c0       	push   $0xc010a72c
c0104145:	e8 ae c2 ff ff       	call   c01003f8 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010414a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010414d:	8b 50 04             	mov    0x4(%eax),%edx
c0104150:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104153:	39 c2                	cmp    %eax,%edx
c0104155:	75 10                	jne    c0104167 <check_vma_struct+0x341>
c0104157:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010415a:	8b 40 08             	mov    0x8(%eax),%eax
c010415d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104160:	83 c2 02             	add    $0x2,%edx
c0104163:	39 d0                	cmp    %edx,%eax
c0104165:	74 19                	je     c0104180 <check_vma_struct+0x35a>
c0104167:	68 84 a8 10 c0       	push   $0xc010a884
c010416c:	68 17 a7 10 c0       	push   $0xc010a717
c0104171:	68 d9 00 00 00       	push   $0xd9
c0104176:	68 2c a7 10 c0       	push   $0xc010a72c
c010417b:	e8 78 c2 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0104180:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0104184:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104187:	89 d0                	mov    %edx,%eax
c0104189:	c1 e0 02             	shl    $0x2,%eax
c010418c:	01 d0                	add    %edx,%eax
c010418e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104191:	0f 8d 6d fe ff ff    	jge    c0104004 <check_vma_struct+0x1de>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0104197:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c010419e:	eb 5c                	jmp    c01041fc <check_vma_struct+0x3d6>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01041a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041a3:	83 ec 08             	sub    $0x8,%esp
c01041a6:	50                   	push   %eax
c01041a7:	ff 75 e8             	pushl  -0x18(%ebp)
c01041aa:	e8 77 f9 ff ff       	call   c0103b26 <find_vma>
c01041af:	83 c4 10             	add    $0x10,%esp
c01041b2:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL ) {
c01041b5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01041b9:	74 1e                	je     c01041d9 <check_vma_struct+0x3b3>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01041bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041be:	8b 50 08             	mov    0x8(%eax),%edx
c01041c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041c4:	8b 40 04             	mov    0x4(%eax),%eax
c01041c7:	52                   	push   %edx
c01041c8:	50                   	push   %eax
c01041c9:	ff 75 f4             	pushl  -0xc(%ebp)
c01041cc:	68 b4 a8 10 c0       	push   $0xc010a8b4
c01041d1:	e8 bc c0 ff ff       	call   c0100292 <cprintf>
c01041d6:	83 c4 10             	add    $0x10,%esp
        }
        assert(vma_below_5 == NULL);
c01041d9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01041dd:	74 19                	je     c01041f8 <check_vma_struct+0x3d2>
c01041df:	68 d9 a8 10 c0       	push   $0xc010a8d9
c01041e4:	68 17 a7 10 c0       	push   $0xc010a717
c01041e9:	68 e1 00 00 00       	push   $0xe1
c01041ee:	68 2c a7 10 c0       	push   $0xc010a72c
c01041f3:	e8 00 c2 ff ff       	call   c01003f8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01041f8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01041fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104200:	79 9e                	jns    c01041a0 <check_vma_struct+0x37a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0104202:	83 ec 0c             	sub    $0xc,%esp
c0104205:	ff 75 e8             	pushl  -0x18(%ebp)
c0104208:	e8 69 fb ff ff       	call   c0103d76 <mm_destroy>
c010420d:	83 c4 10             	add    $0x10,%esp

    cprintf("check_vma_struct() succeeded!\n");
c0104210:	83 ec 0c             	sub    $0xc,%esp
c0104213:	68 f0 a8 10 c0       	push   $0xc010a8f0
c0104218:	e8 75 c0 ff ff       	call   c0100292 <cprintf>
c010421d:	83 c4 10             	add    $0x10,%esp
}
c0104220:	90                   	nop
c0104221:	c9                   	leave  
c0104222:	c3                   	ret    

c0104223 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0104223:	55                   	push   %ebp
c0104224:	89 e5                	mov    %esp,%ebp
c0104226:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0104229:	e8 3a 2e 00 00       	call   c0107068 <nr_free_pages>
c010422e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0104231:	e8 38 f8 ff ff       	call   c0103a6e <mm_create>
c0104236:	a3 bc c0 12 c0       	mov    %eax,0xc012c0bc
    assert(check_mm_struct != NULL);
c010423b:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c0104240:	85 c0                	test   %eax,%eax
c0104242:	75 19                	jne    c010425d <check_pgfault+0x3a>
c0104244:	68 0f a9 10 c0       	push   $0xc010a90f
c0104249:	68 17 a7 10 c0       	push   $0xc010a717
c010424e:	68 f1 00 00 00       	push   $0xf1
c0104253:	68 2c a7 10 c0       	push   $0xc010a72c
c0104258:	e8 9b c1 ff ff       	call   c01003f8 <__panic>

    struct mm_struct *mm = check_mm_struct;
c010425d:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c0104262:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0104265:	8b 15 60 6a 12 c0    	mov    0xc0126a60,%edx
c010426b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010426e:	89 50 0c             	mov    %edx,0xc(%eax)
c0104271:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104274:	8b 40 0c             	mov    0xc(%eax),%eax
c0104277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c010427a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010427d:	8b 00                	mov    (%eax),%eax
c010427f:	85 c0                	test   %eax,%eax
c0104281:	74 19                	je     c010429c <check_pgfault+0x79>
c0104283:	68 27 a9 10 c0       	push   $0xc010a927
c0104288:	68 17 a7 10 c0       	push   $0xc010a717
c010428d:	68 f5 00 00 00       	push   $0xf5
c0104292:	68 2c a7 10 c0       	push   $0xc010a72c
c0104297:	e8 5c c1 ff ff       	call   c01003f8 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c010429c:	83 ec 04             	sub    $0x4,%esp
c010429f:	6a 02                	push   $0x2
c01042a1:	68 00 00 40 00       	push   $0x400000
c01042a6:	6a 00                	push   $0x0
c01042a8:	e8 3d f8 ff ff       	call   c0103aea <vma_create>
c01042ad:	83 c4 10             	add    $0x10,%esp
c01042b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01042b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042b7:	75 19                	jne    c01042d2 <check_pgfault+0xaf>
c01042b9:	68 b8 a7 10 c0       	push   $0xc010a7b8
c01042be:	68 17 a7 10 c0       	push   $0xc010a717
c01042c3:	68 f8 00 00 00       	push   $0xf8
c01042c8:	68 2c a7 10 c0       	push   $0xc010a72c
c01042cd:	e8 26 c1 ff ff       	call   c01003f8 <__panic>

    insert_vma_struct(mm, vma);
c01042d2:	83 ec 08             	sub    $0x8,%esp
c01042d5:	ff 75 e0             	pushl  -0x20(%ebp)
c01042d8:	ff 75 e8             	pushl  -0x18(%ebp)
c01042db:	e8 72 f9 ff ff       	call   c0103c52 <insert_vma_struct>
c01042e0:	83 c4 10             	add    $0x10,%esp

    uintptr_t addr = 0x100;
c01042e3:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c01042ea:	83 ec 08             	sub    $0x8,%esp
c01042ed:	ff 75 dc             	pushl  -0x24(%ebp)
c01042f0:	ff 75 e8             	pushl  -0x18(%ebp)
c01042f3:	e8 2e f8 ff ff       	call   c0103b26 <find_vma>
c01042f8:	83 c4 10             	add    $0x10,%esp
c01042fb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01042fe:	74 19                	je     c0104319 <check_pgfault+0xf6>
c0104300:	68 35 a9 10 c0       	push   $0xc010a935
c0104305:	68 17 a7 10 c0       	push   $0xc010a717
c010430a:	68 fd 00 00 00       	push   $0xfd
c010430f:	68 2c a7 10 c0       	push   $0xc010a72c
c0104314:	e8 df c0 ff ff       	call   c01003f8 <__panic>

    int i, sum = 0;
c0104319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0104320:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104327:	eb 19                	jmp    c0104342 <check_pgfault+0x11f>
        *(char *)(addr + i) = i;
c0104329:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010432c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010432f:	01 d0                	add    %edx,%eax
c0104331:	89 c2                	mov    %eax,%edx
c0104333:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104336:	88 02                	mov    %al,(%edx)
        sum += i;
c0104338:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433b:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c010433e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104342:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0104346:	7e e1                	jle    c0104329 <check_pgfault+0x106>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0104348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010434f:	eb 15                	jmp    c0104366 <check_pgfault+0x143>
        sum -= *(char *)(addr + i);
c0104351:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104354:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104357:	01 d0                	add    %edx,%eax
c0104359:	0f b6 00             	movzbl (%eax),%eax
c010435c:	0f be c0             	movsbl %al,%eax
c010435f:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0104362:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104366:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010436a:	7e e5                	jle    c0104351 <check_pgfault+0x12e>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c010436c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104370:	74 19                	je     c010438b <check_pgfault+0x168>
c0104372:	68 4f a9 10 c0       	push   $0xc010a94f
c0104377:	68 17 a7 10 c0       	push   $0xc010a717
c010437c:	68 07 01 00 00       	push   $0x107
c0104381:	68 2c a7 10 c0       	push   $0xc010a72c
c0104386:	e8 6d c0 ff ff       	call   c01003f8 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010438b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010438e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104391:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104399:	83 ec 08             	sub    $0x8,%esp
c010439c:	50                   	push   %eax
c010439d:	ff 75 e4             	pushl  -0x1c(%ebp)
c01043a0:	e8 94 34 00 00       	call   c0107839 <page_remove>
c01043a5:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(pgdir[0]));
c01043a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043ab:	8b 00                	mov    (%eax),%eax
c01043ad:	83 ec 0c             	sub    $0xc,%esp
c01043b0:	50                   	push   %eax
c01043b1:	e8 9c f6 ff ff       	call   c0103a52 <pde2page>
c01043b6:	83 c4 10             	add    $0x10,%esp
c01043b9:	83 ec 08             	sub    $0x8,%esp
c01043bc:	6a 01                	push   $0x1
c01043be:	50                   	push   %eax
c01043bf:	e8 6f 2c 00 00       	call   c0107033 <free_pages>
c01043c4:	83 c4 10             	add    $0x10,%esp
    pgdir[0] = 0;
c01043c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01043d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c01043da:	83 ec 0c             	sub    $0xc,%esp
c01043dd:	ff 75 e8             	pushl  -0x18(%ebp)
c01043e0:	e8 91 f9 ff ff       	call   c0103d76 <mm_destroy>
c01043e5:	83 c4 10             	add    $0x10,%esp
    check_mm_struct = NULL;
c01043e8:	c7 05 bc c0 12 c0 00 	movl   $0x0,0xc012c0bc
c01043ef:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01043f2:	e8 71 2c 00 00       	call   c0107068 <nr_free_pages>
c01043f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01043fa:	74 19                	je     c0104415 <check_pgfault+0x1f2>
c01043fc:	68 58 a9 10 c0       	push   $0xc010a958
c0104401:	68 17 a7 10 c0       	push   $0xc010a717
c0104406:	68 11 01 00 00       	push   $0x111
c010440b:	68 2c a7 10 c0       	push   $0xc010a72c
c0104410:	e8 e3 bf ff ff       	call   c01003f8 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0104415:	83 ec 0c             	sub    $0xc,%esp
c0104418:	68 7f a9 10 c0       	push   $0xc010a97f
c010441d:	e8 70 be ff ff       	call   c0100292 <cprintf>
c0104422:	83 c4 10             	add    $0x10,%esp
}
c0104425:	90                   	nop
c0104426:	c9                   	leave  
c0104427:	c3                   	ret    

c0104428 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0104428:	55                   	push   %ebp
c0104429:	89 e5                	mov    %esp,%ebp
c010442b:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_INVAL;
c010442e:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0104435:	ff 75 10             	pushl  0x10(%ebp)
c0104438:	ff 75 08             	pushl  0x8(%ebp)
c010443b:	e8 e6 f6 ff ff       	call   c0103b26 <find_vma>
c0104440:	83 c4 08             	add    $0x8,%esp
c0104443:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0104446:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010444b:	83 c0 01             	add    $0x1,%eax
c010444e:	a3 64 9f 12 c0       	mov    %eax,0xc0129f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0104453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104457:	74 0b                	je     c0104464 <do_pgfault+0x3c>
c0104459:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010445c:	8b 40 04             	mov    0x4(%eax),%eax
c010445f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0104462:	76 18                	jbe    c010447c <do_pgfault+0x54>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0104464:	83 ec 08             	sub    $0x8,%esp
c0104467:	ff 75 10             	pushl  0x10(%ebp)
c010446a:	68 9c a9 10 c0       	push   $0xc010a99c
c010446f:	e8 1e be ff ff       	call   c0100292 <cprintf>
c0104474:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0104477:	e9 b4 01 00 00       	jmp    c0104630 <do_pgfault+0x208>
    }
    //check the error_code
    switch (error_code & 3) {
c010447c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010447f:	83 e0 03             	and    $0x3,%eax
c0104482:	85 c0                	test   %eax,%eax
c0104484:	74 3c                	je     c01044c2 <do_pgfault+0x9a>
c0104486:	83 f8 01             	cmp    $0x1,%eax
c0104489:	74 22                	je     c01044ad <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c010448b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010448e:	8b 40 0c             	mov    0xc(%eax),%eax
c0104491:	83 e0 02             	and    $0x2,%eax
c0104494:	85 c0                	test   %eax,%eax
c0104496:	75 4c                	jne    c01044e4 <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0104498:	83 ec 0c             	sub    $0xc,%esp
c010449b:	68 cc a9 10 c0       	push   $0xc010a9cc
c01044a0:	e8 ed bd ff ff       	call   c0100292 <cprintf>
c01044a5:	83 c4 10             	add    $0x10,%esp
            goto failed;
c01044a8:	e9 83 01 00 00       	jmp    c0104630 <do_pgfault+0x208>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01044ad:	83 ec 0c             	sub    $0xc,%esp
c01044b0:	68 2c aa 10 c0       	push   $0xc010aa2c
c01044b5:	e8 d8 bd ff ff       	call   c0100292 <cprintf>
c01044ba:	83 c4 10             	add    $0x10,%esp
        goto failed;
c01044bd:	e9 6e 01 00 00       	jmp    c0104630 <do_pgfault+0x208>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01044c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044c5:	8b 40 0c             	mov    0xc(%eax),%eax
c01044c8:	83 e0 05             	and    $0x5,%eax
c01044cb:	85 c0                	test   %eax,%eax
c01044cd:	75 16                	jne    c01044e5 <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01044cf:	83 ec 0c             	sub    $0xc,%esp
c01044d2:	68 64 aa 10 c0       	push   $0xc010aa64
c01044d7:	e8 b6 bd ff ff       	call   c0100292 <cprintf>
c01044dc:	83 c4 10             	add    $0x10,%esp
            goto failed;
c01044df:	e9 4c 01 00 00       	jmp    c0104630 <do_pgfault+0x208>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c01044e4:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c01044e5:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c01044ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044ef:	8b 40 0c             	mov    0xc(%eax),%eax
c01044f2:	83 e0 02             	and    $0x2,%eax
c01044f5:	85 c0                	test   %eax,%eax
c01044f7:	74 04                	je     c01044fd <do_pgfault+0xd5>
        perm |= PTE_W;
c01044f9:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c01044fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0104500:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104503:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104506:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010450b:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c010450e:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0104515:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: YOUR CODE*/
    ptep = get_pte(mm->pgdir, addr, 1);              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c010451c:	8b 45 08             	mov    0x8(%ebp),%eax
c010451f:	8b 40 0c             	mov    0xc(%eax),%eax
c0104522:	83 ec 04             	sub    $0x4,%esp
c0104525:	6a 01                	push   $0x1
c0104527:	ff 75 10             	pushl  0x10(%ebp)
c010452a:	50                   	push   %eax
c010452b:	e8 03 31 00 00       	call   c0107633 <get_pte>
c0104530:	83 c4 10             	add    $0x10,%esp
c0104533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(ptep != NULL);
c0104536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010453a:	75 19                	jne    c0104555 <do_pgfault+0x12d>
c010453c:	68 c7 aa 10 c0       	push   $0xc010aac7
c0104541:	68 17 a7 10 c0       	push   $0xc010a717
c0104546:	68 6e 01 00 00       	push   $0x16e
c010454b:	68 2c a7 10 c0       	push   $0xc010a72c
c0104550:	e8 a3 be ff ff       	call   c01003f8 <__panic>
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0) {
c0104555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104558:	8b 00                	mov    (%eax),%eax
c010455a:	85 c0                	test   %eax,%eax
c010455c:	75 39                	jne    c0104597 <do_pgfault+0x16f>
        assert(pgdir_alloc_page(mm->pgdir, addr, perm) != NULL);
c010455e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104561:	8b 40 0c             	mov    0xc(%eax),%eax
c0104564:	83 ec 04             	sub    $0x4,%esp
c0104567:	ff 75 f0             	pushl  -0x10(%ebp)
c010456a:	ff 75 10             	pushl  0x10(%ebp)
c010456d:	50                   	push   %eax
c010456e:	e8 08 34 00 00       	call   c010797b <pgdir_alloc_page>
c0104573:	83 c4 10             	add    $0x10,%esp
c0104576:	85 c0                	test   %eax,%eax
c0104578:	0f 85 ab 00 00 00    	jne    c0104629 <do_pgfault+0x201>
c010457e:	68 d4 aa 10 c0       	push   $0xc010aad4
c0104583:	68 17 a7 10 c0       	push   $0xc010a717
c0104588:	68 71 01 00 00       	push   $0x171
c010458d:	68 2c a7 10 c0       	push   $0xc010a72c
c0104592:	e8 61 be ff ff       	call   c01003f8 <__panic>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0104597:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c010459c:	85 c0                	test   %eax,%eax
c010459e:	74 71                	je     c0104611 <do_pgfault+0x1e9>
            struct Page *page=NULL;
c01045a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page
            //    into the memory which page managed.
            assert(swap_in(mm, addr, &page) == 0);
c01045a7:	83 ec 04             	sub    $0x4,%esp
c01045aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01045ad:	50                   	push   %eax
c01045ae:	ff 75 10             	pushl  0x10(%ebp)
c01045b1:	ff 75 08             	pushl  0x8(%ebp)
c01045b4:	e8 5f 0f 00 00       	call   c0105518 <swap_in>
c01045b9:	83 c4 10             	add    $0x10,%esp
c01045bc:	85 c0                	test   %eax,%eax
c01045be:	74 19                	je     c01045d9 <do_pgfault+0x1b1>
c01045c0:	68 04 ab 10 c0       	push   $0xc010ab04
c01045c5:	68 17 a7 10 c0       	push   $0xc010a717
c01045ca:	68 83 01 00 00       	push   $0x183
c01045cf:	68 2c a7 10 c0       	push   $0xc010a72c
c01045d4:	e8 1f be ff ff       	call   c01003f8 <__panic>
            page->pra_vaddr = addr;
c01045d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045dc:	8b 55 10             	mov    0x10(%ebp),%edx
c01045df:	89 50 1c             	mov    %edx,0x1c(%eax)
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            page_insert(mm->pgdir, page, addr, perm);
c01045e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e8:	8b 40 0c             	mov    0xc(%eax),%eax
c01045eb:	ff 75 f0             	pushl  -0x10(%ebp)
c01045ee:	ff 75 10             	pushl  0x10(%ebp)
c01045f1:	52                   	push   %edx
c01045f2:	50                   	push   %eax
c01045f3:	e8 7a 32 00 00       	call   c0107872 <page_insert>
c01045f8:	83 c4 10             	add    $0x10,%esp
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c01045fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045fe:	6a 01                	push   $0x1
c0104600:	50                   	push   %eax
c0104601:	ff 75 10             	pushl  0x10(%ebp)
c0104604:	ff 75 08             	pushl  0x8(%ebp)
c0104607:	e8 7c 0d 00 00       	call   c0105388 <swap_map_swappable>
c010460c:	83 c4 10             	add    $0x10,%esp
c010460f:	eb 18                	jmp    c0104629 <do_pgfault+0x201>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0104611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104614:	8b 00                	mov    (%eax),%eax
c0104616:	83 ec 08             	sub    $0x8,%esp
c0104619:	50                   	push   %eax
c010461a:	68 24 ab 10 c0       	push   $0xc010ab24
c010461f:	e8 6e bc ff ff       	call   c0100292 <cprintf>
c0104624:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0104627:	eb 07                	jmp    c0104630 <do_pgfault+0x208>
        }
   }
   ret = 0;
c0104629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0104630:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104633:	c9                   	leave  
c0104634:	c3                   	ret    

c0104635 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0104635:	55                   	push   %ebp
c0104636:	89 e5                	mov    %esp,%ebp
c0104638:	83 ec 10             	sub    $0x10,%esp
c010463b:	c7 45 fc b0 c0 12 c0 	movl   $0xc012c0b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104642:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104645:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104648:	89 50 04             	mov    %edx,0x4(%eax)
c010464b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010464e:	8b 50 04             	mov    0x4(%eax),%edx
c0104651:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104654:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0104656:	8b 45 08             	mov    0x8(%ebp),%eax
c0104659:	c7 40 14 b0 c0 12 c0 	movl   $0xc012c0b0,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0104660:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104665:	c9                   	leave  
c0104666:	c3                   	ret    

c0104667 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104667:	55                   	push   %ebp
c0104668:	89 e5                	mov    %esp,%ebp
c010466a:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010466d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104670:	8b 40 14             	mov    0x14(%eax),%eax
c0104673:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0104676:	8b 45 10             	mov    0x10(%ebp),%eax
c0104679:	83 c0 14             	add    $0x14,%eax
c010467c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
    assert(entry != NULL && head != NULL);
c010467f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104683:	74 06                	je     c010468b <_fifo_map_swappable+0x24>
c0104685:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104689:	75 16                	jne    c01046a1 <_fifo_map_swappable+0x3a>
c010468b:	68 4c ab 10 c0       	push   $0xc010ab4c
c0104690:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104695:	6a 32                	push   $0x32
c0104697:	68 7f ab 10 c0       	push   $0xc010ab7f
c010469c:	e8 57 bd ff ff       	call   c01003f8 <__panic>
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c01046a1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01046a5:	75 57                	jne    c01046fe <_fifo_map_swappable+0x97>
        list_entry_t *le_prev = head, *le;
c01046a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c01046ad:	eb 38                	jmp    c01046e7 <_fifo_map_swappable+0x80>
            if (le == entry) {
c01046af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01046b5:	75 2a                	jne    c01046e1 <_fifo_map_swappable+0x7a>
c01046b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01046bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046c0:	8b 40 04             	mov    0x4(%eax),%eax
c01046c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01046c6:	8b 12                	mov    (%edx),%edx
c01046c8:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01046cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01046ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01046d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01046d4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01046d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046da:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046dd:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c01046df:	eb 1d                	jmp    c01046fe <_fifo_map_swappable+0x97>
            }
            le_prev = le;        
c01046e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01046ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046f0:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c01046f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01046fc:	75 b1                	jne    c01046af <_fifo_map_swappable+0x48>
c01046fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104701:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104704:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104707:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010470a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010470d:	8b 00                	mov    (%eax),%eax
c010470f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104712:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104715:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104718:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010471b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010471e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104721:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104724:	89 10                	mov    %edx,(%eax)
c0104726:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104729:	8b 10                	mov    (%eax),%edx
c010472b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010472e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104731:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104734:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104737:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010473a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010473d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104740:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c0104742:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104747:	c9                   	leave  
c0104748:	c3                   	ret    

c0104749 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0104749:	55                   	push   %ebp
c010474a:	89 e5                	mov    %esp,%ebp
c010474c:	83 ec 28             	sub    $0x28,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010474f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104752:	8b 40 14             	mov    0x14(%eax),%eax
c0104755:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0104758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010475c:	75 16                	jne    c0104774 <_fifo_swap_out_victim+0x2b>
c010475e:	68 93 ab 10 c0       	push   $0xc010ab93
c0104763:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104768:	6a 4c                	push   $0x4c
c010476a:	68 7f ab 10 c0       	push   $0xc010ab7f
c010476f:	e8 84 bc ff ff       	call   c01003f8 <__panic>
     assert(in_tick==0);
c0104774:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104778:	74 16                	je     c0104790 <_fifo_swap_out_victim+0x47>
c010477a:	68 a0 ab 10 c0       	push   $0xc010aba0
c010477f:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104784:	6a 4d                	push   $0x4d
c0104786:	68 7f ab 10 c0       	push   $0xc010ab7f
c010478b:	e8 68 bc ff ff       	call   c01003f8 <__panic>
c0104790:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104799:	8b 40 04             	mov    0x4(%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
    list_entry_t *front = list_next(head);
c010479c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(front != head);
c010479f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047a5:	75 16                	jne    c01047bd <_fifo_swap_out_victim+0x74>
c01047a7:	68 ab ab 10 c0       	push   $0xc010abab
c01047ac:	68 6a ab 10 c0       	push   $0xc010ab6a
c01047b1:	6a 52                	push   $0x52
c01047b3:	68 7f ab 10 c0       	push   $0xc010ab7f
c01047b8:	e8 3b bc ff ff       	call   c01003f8 <__panic>
c01047bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01047c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047c6:	8b 40 04             	mov    0x4(%eax),%eax
c01047c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01047cc:	8b 12                	mov    (%edx),%edx
c01047ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01047d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01047d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047da:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01047dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01047e3:	89 10                	mov    %edx,(%eax)
    list_del(front);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(front, pra_page_link);
c01047e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047e8:	83 e8 14             	sub    $0x14,%eax
c01047eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(page != NULL);
c01047ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01047f2:	75 16                	jne    c010480a <_fifo_swap_out_victim+0xc1>
c01047f4:	68 b9 ab 10 c0       	push   $0xc010abb9
c01047f9:	68 6a ab 10 c0       	push   $0xc010ab6a
c01047fe:	6a 56                	push   $0x56
c0104800:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104805:	e8 ee bb ff ff       	call   c01003f8 <__panic>
    *ptr_page = page;
c010480a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010480d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104810:	89 10                	mov    %edx,(%eax)
    return 0;
c0104812:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104817:	c9                   	leave  
c0104818:	c3                   	ret    

c0104819 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0104819:	55                   	push   %ebp
c010481a:	89 e5                	mov    %esp,%ebp
c010481c:	83 ec 08             	sub    $0x8,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c010481f:	83 ec 0c             	sub    $0xc,%esp
c0104822:	68 c8 ab 10 c0       	push   $0xc010abc8
c0104827:	e8 66 ba ff ff       	call   c0100292 <cprintf>
c010482c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c010482f:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104834:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0104837:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010483c:	83 f8 04             	cmp    $0x4,%eax
c010483f:	74 16                	je     c0104857 <_fifo_check_swap+0x3e>
c0104841:	68 ee ab 10 c0       	push   $0xc010abee
c0104846:	68 6a ab 10 c0       	push   $0xc010ab6a
c010484b:	6a 5f                	push   $0x5f
c010484d:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104852:	e8 a1 bb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104857:	83 ec 0c             	sub    $0xc,%esp
c010485a:	68 00 ac 10 c0       	push   $0xc010ac00
c010485f:	e8 2e ba ff ff       	call   c0100292 <cprintf>
c0104864:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0104867:	b8 00 10 00 00       	mov    $0x1000,%eax
c010486c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c010486f:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104874:	83 f8 04             	cmp    $0x4,%eax
c0104877:	74 16                	je     c010488f <_fifo_check_swap+0x76>
c0104879:	68 ee ab 10 c0       	push   $0xc010abee
c010487e:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104883:	6a 62                	push   $0x62
c0104885:	68 7f ab 10 c0       	push   $0xc010ab7f
c010488a:	e8 69 bb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010488f:	83 ec 0c             	sub    $0xc,%esp
c0104892:	68 28 ac 10 c0       	push   $0xc010ac28
c0104897:	e8 f6 b9 ff ff       	call   c0100292 <cprintf>
c010489c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c010489f:	b8 00 40 00 00       	mov    $0x4000,%eax
c01048a4:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01048a7:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01048ac:	83 f8 04             	cmp    $0x4,%eax
c01048af:	74 16                	je     c01048c7 <_fifo_check_swap+0xae>
c01048b1:	68 ee ab 10 c0       	push   $0xc010abee
c01048b6:	68 6a ab 10 c0       	push   $0xc010ab6a
c01048bb:	6a 65                	push   $0x65
c01048bd:	68 7f ab 10 c0       	push   $0xc010ab7f
c01048c2:	e8 31 bb ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01048c7:	83 ec 0c             	sub    $0xc,%esp
c01048ca:	68 50 ac 10 c0       	push   $0xc010ac50
c01048cf:	e8 be b9 ff ff       	call   c0100292 <cprintf>
c01048d4:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c01048d7:	b8 00 20 00 00       	mov    $0x2000,%eax
c01048dc:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c01048df:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01048e4:	83 f8 04             	cmp    $0x4,%eax
c01048e7:	74 16                	je     c01048ff <_fifo_check_swap+0xe6>
c01048e9:	68 ee ab 10 c0       	push   $0xc010abee
c01048ee:	68 6a ab 10 c0       	push   $0xc010ab6a
c01048f3:	6a 68                	push   $0x68
c01048f5:	68 7f ab 10 c0       	push   $0xc010ab7f
c01048fa:	e8 f9 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01048ff:	83 ec 0c             	sub    $0xc,%esp
c0104902:	68 78 ac 10 c0       	push   $0xc010ac78
c0104907:	e8 86 b9 ff ff       	call   c0100292 <cprintf>
c010490c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c010490f:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104914:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0104917:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010491c:	83 f8 05             	cmp    $0x5,%eax
c010491f:	74 16                	je     c0104937 <_fifo_check_swap+0x11e>
c0104921:	68 9e ac 10 c0       	push   $0xc010ac9e
c0104926:	68 6a ab 10 c0       	push   $0xc010ab6a
c010492b:	6a 6b                	push   $0x6b
c010492d:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104932:	e8 c1 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0104937:	83 ec 0c             	sub    $0xc,%esp
c010493a:	68 50 ac 10 c0       	push   $0xc010ac50
c010493f:	e8 4e b9 ff ff       	call   c0100292 <cprintf>
c0104944:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0104947:	b8 00 20 00 00       	mov    $0x2000,%eax
c010494c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c010494f:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104954:	83 f8 05             	cmp    $0x5,%eax
c0104957:	74 16                	je     c010496f <_fifo_check_swap+0x156>
c0104959:	68 9e ac 10 c0       	push   $0xc010ac9e
c010495e:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104963:	6a 6e                	push   $0x6e
c0104965:	68 7f ab 10 c0       	push   $0xc010ab7f
c010496a:	e8 89 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010496f:	83 ec 0c             	sub    $0xc,%esp
c0104972:	68 00 ac 10 c0       	push   $0xc010ac00
c0104977:	e8 16 b9 ff ff       	call   c0100292 <cprintf>
c010497c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c010497f:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104984:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0104987:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010498c:	83 f8 06             	cmp    $0x6,%eax
c010498f:	74 16                	je     c01049a7 <_fifo_check_swap+0x18e>
c0104991:	68 ad ac 10 c0       	push   $0xc010acad
c0104996:	68 6a ab 10 c0       	push   $0xc010ab6a
c010499b:	6a 71                	push   $0x71
c010499d:	68 7f ab 10 c0       	push   $0xc010ab7f
c01049a2:	e8 51 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01049a7:	83 ec 0c             	sub    $0xc,%esp
c01049aa:	68 50 ac 10 c0       	push   $0xc010ac50
c01049af:	e8 de b8 ff ff       	call   c0100292 <cprintf>
c01049b4:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c01049b7:	b8 00 20 00 00       	mov    $0x2000,%eax
c01049bc:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01049bf:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01049c4:	83 f8 07             	cmp    $0x7,%eax
c01049c7:	74 16                	je     c01049df <_fifo_check_swap+0x1c6>
c01049c9:	68 bc ac 10 c0       	push   $0xc010acbc
c01049ce:	68 6a ab 10 c0       	push   $0xc010ab6a
c01049d3:	6a 74                	push   $0x74
c01049d5:	68 7f ab 10 c0       	push   $0xc010ab7f
c01049da:	e8 19 ba ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01049df:	83 ec 0c             	sub    $0xc,%esp
c01049e2:	68 c8 ab 10 c0       	push   $0xc010abc8
c01049e7:	e8 a6 b8 ff ff       	call   c0100292 <cprintf>
c01049ec:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c01049ef:	b8 00 30 00 00       	mov    $0x3000,%eax
c01049f4:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01049f7:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01049fc:	83 f8 08             	cmp    $0x8,%eax
c01049ff:	74 16                	je     c0104a17 <_fifo_check_swap+0x1fe>
c0104a01:	68 cb ac 10 c0       	push   $0xc010accb
c0104a06:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104a0b:	6a 77                	push   $0x77
c0104a0d:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104a12:	e8 e1 b9 ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0104a17:	83 ec 0c             	sub    $0xc,%esp
c0104a1a:	68 28 ac 10 c0       	push   $0xc010ac28
c0104a1f:	e8 6e b8 ff ff       	call   c0100292 <cprintf>
c0104a24:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0104a27:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104a2c:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0104a2f:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104a34:	83 f8 09             	cmp    $0x9,%eax
c0104a37:	74 16                	je     c0104a4f <_fifo_check_swap+0x236>
c0104a39:	68 da ac 10 c0       	push   $0xc010acda
c0104a3e:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104a43:	6a 7a                	push   $0x7a
c0104a45:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104a4a:	e8 a9 b9 ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104a4f:	83 ec 0c             	sub    $0xc,%esp
c0104a52:	68 78 ac 10 c0       	push   $0xc010ac78
c0104a57:	e8 36 b8 ff ff       	call   c0100292 <cprintf>
c0104a5c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104a5f:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104a64:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0104a67:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104a6c:	83 f8 0a             	cmp    $0xa,%eax
c0104a6f:	74 16                	je     c0104a87 <_fifo_check_swap+0x26e>
c0104a71:	68 e9 ac 10 c0       	push   $0xc010ace9
c0104a76:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104a7b:	6a 7d                	push   $0x7d
c0104a7d:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104a82:	e8 71 b9 ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104a87:	83 ec 0c             	sub    $0xc,%esp
c0104a8a:	68 00 ac 10 c0       	push   $0xc010ac00
c0104a8f:	e8 fe b7 ff ff       	call   c0100292 <cprintf>
c0104a94:	83 c4 10             	add    $0x10,%esp
    assert(*(unsigned char *)0x1000 == 0x0a);
c0104a97:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104a9c:	0f b6 00             	movzbl (%eax),%eax
c0104a9f:	3c 0a                	cmp    $0xa,%al
c0104aa1:	74 16                	je     c0104ab9 <_fifo_check_swap+0x2a0>
c0104aa3:	68 fc ac 10 c0       	push   $0xc010acfc
c0104aa8:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104aad:	6a 7f                	push   $0x7f
c0104aaf:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104ab4:	e8 3f b9 ff ff       	call   c01003f8 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0104ab9:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104abe:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0104ac1:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0104ac6:	83 f8 0b             	cmp    $0xb,%eax
c0104ac9:	74 19                	je     c0104ae4 <_fifo_check_swap+0x2cb>
c0104acb:	68 1d ad 10 c0       	push   $0xc010ad1d
c0104ad0:	68 6a ab 10 c0       	push   $0xc010ab6a
c0104ad5:	68 81 00 00 00       	push   $0x81
c0104ada:	68 7f ab 10 c0       	push   $0xc010ab7f
c0104adf:	e8 14 b9 ff ff       	call   c01003f8 <__panic>
    return 0;
c0104ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ae9:	c9                   	leave  
c0104aea:	c3                   	ret    

c0104aeb <_fifo_init>:


static int
_fifo_init(void)
{
c0104aeb:	55                   	push   %ebp
c0104aec:	89 e5                	mov    %esp,%ebp
    return 0;
c0104aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104af3:	5d                   	pop    %ebp
c0104af4:	c3                   	ret    

c0104af5 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104af5:	55                   	push   %ebp
c0104af6:	89 e5                	mov    %esp,%ebp
    return 0;
c0104af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104afd:	5d                   	pop    %ebp
c0104afe:	c3                   	ret    

c0104aff <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0104aff:	55                   	push   %ebp
c0104b00:	89 e5                	mov    %esp,%ebp
c0104b02:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b07:	5d                   	pop    %ebp
c0104b08:	c3                   	ret    

c0104b09 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104b09:	55                   	push   %ebp
c0104b0a:	89 e5                	mov    %esp,%ebp
c0104b0c:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104b0f:	9c                   	pushf  
c0104b10:	58                   	pop    %eax
c0104b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104b17:	25 00 02 00 00       	and    $0x200,%eax
c0104b1c:	85 c0                	test   %eax,%eax
c0104b1e:	74 0c                	je     c0104b2c <__intr_save+0x23>
        intr_disable();
c0104b20:	e8 bb d5 ff ff       	call   c01020e0 <intr_disable>
        return 1;
c0104b25:	b8 01 00 00 00       	mov    $0x1,%eax
c0104b2a:	eb 05                	jmp    c0104b31 <__intr_save+0x28>
    }
    return 0;
c0104b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b31:	c9                   	leave  
c0104b32:	c3                   	ret    

c0104b33 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104b33:	55                   	push   %ebp
c0104b34:	89 e5                	mov    %esp,%ebp
c0104b36:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b3d:	74 05                	je     c0104b44 <__intr_restore+0x11>
        intr_enable();
c0104b3f:	e8 95 d5 ff ff       	call   c01020d9 <intr_enable>
    }
}
c0104b44:	90                   	nop
c0104b45:	c9                   	leave  
c0104b46:	c3                   	ret    

c0104b47 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104b47:	55                   	push   %ebp
c0104b48:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4d:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0104b53:	29 d0                	sub    %edx,%eax
c0104b55:	c1 f8 05             	sar    $0x5,%eax
}
c0104b58:	5d                   	pop    %ebp
c0104b59:	c3                   	ret    

c0104b5a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104b5a:	55                   	push   %ebp
c0104b5b:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104b5d:	ff 75 08             	pushl  0x8(%ebp)
c0104b60:	e8 e2 ff ff ff       	call   c0104b47 <page2ppn>
c0104b65:	83 c4 04             	add    $0x4,%esp
c0104b68:	c1 e0 0c             	shl    $0xc,%eax
}
c0104b6b:	c9                   	leave  
c0104b6c:	c3                   	ret    

c0104b6d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b6d:	55                   	push   %ebp
c0104b6e:	89 e5                	mov    %esp,%ebp
c0104b70:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0104b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b76:	c1 e8 0c             	shr    $0xc,%eax
c0104b79:	89 c2                	mov    %eax,%edx
c0104b7b:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0104b80:	39 c2                	cmp    %eax,%edx
c0104b82:	72 14                	jb     c0104b98 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0104b84:	83 ec 04             	sub    $0x4,%esp
c0104b87:	68 40 ad 10 c0       	push   $0xc010ad40
c0104b8c:	6a 5f                	push   $0x5f
c0104b8e:	68 5f ad 10 c0       	push   $0xc010ad5f
c0104b93:	e8 60 b8 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0104b98:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0104b9d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ba0:	c1 ea 0c             	shr    $0xc,%edx
c0104ba3:	c1 e2 05             	shl    $0x5,%edx
c0104ba6:	01 d0                	add    %edx,%eax
}
c0104ba8:	c9                   	leave  
c0104ba9:	c3                   	ret    

c0104baa <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104baa:	55                   	push   %ebp
c0104bab:	89 e5                	mov    %esp,%ebp
c0104bad:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0104bb0:	ff 75 08             	pushl  0x8(%ebp)
c0104bb3:	e8 a2 ff ff ff       	call   c0104b5a <page2pa>
c0104bb8:	83 c4 04             	add    $0x4,%esp
c0104bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc1:	c1 e8 0c             	shr    $0xc,%eax
c0104bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bc7:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0104bcc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104bcf:	72 14                	jb     c0104be5 <page2kva+0x3b>
c0104bd1:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bd4:	68 70 ad 10 c0       	push   $0xc010ad70
c0104bd9:	6a 66                	push   $0x66
c0104bdb:	68 5f ad 10 c0       	push   $0xc010ad5f
c0104be0:	e8 13 b8 ff ff       	call   c01003f8 <__panic>
c0104be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be8:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104bed:	c9                   	leave  
c0104bee:	c3                   	ret    

c0104bef <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104bef:	55                   	push   %ebp
c0104bf0:	89 e5                	mov    %esp,%ebp
c0104bf2:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c0104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104bfb:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104c02:	77 14                	ja     c0104c18 <kva2page+0x29>
c0104c04:	ff 75 f4             	pushl  -0xc(%ebp)
c0104c07:	68 94 ad 10 c0       	push   $0xc010ad94
c0104c0c:	6a 6b                	push   $0x6b
c0104c0e:	68 5f ad 10 c0       	push   $0xc010ad5f
c0104c13:	e8 e0 b7 ff ff       	call   c01003f8 <__panic>
c0104c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c1b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104c20:	83 ec 0c             	sub    $0xc,%esp
c0104c23:	50                   	push   %eax
c0104c24:	e8 44 ff ff ff       	call   c0104b6d <pa2page>
c0104c29:	83 c4 10             	add    $0x10,%esp
}
c0104c2c:	c9                   	leave  
c0104c2d:	c3                   	ret    

c0104c2e <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104c2e:	55                   	push   %ebp
c0104c2f:	89 e5                	mov    %esp,%ebp
c0104c31:	83 ec 18             	sub    $0x18,%esp
  struct Page * page = alloc_pages(1 << order);
c0104c34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c37:	ba 01 00 00 00       	mov    $0x1,%edx
c0104c3c:	89 c1                	mov    %eax,%ecx
c0104c3e:	d3 e2                	shl    %cl,%edx
c0104c40:	89 d0                	mov    %edx,%eax
c0104c42:	83 ec 0c             	sub    $0xc,%esp
c0104c45:	50                   	push   %eax
c0104c46:	e8 7c 23 00 00       	call   c0106fc7 <alloc_pages>
c0104c4b:	83 c4 10             	add    $0x10,%esp
c0104c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104c51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c55:	75 07                	jne    c0104c5e <__slob_get_free_pages+0x30>
    return NULL;
c0104c57:	b8 00 00 00 00       	mov    $0x0,%eax
c0104c5c:	eb 0e                	jmp    c0104c6c <__slob_get_free_pages+0x3e>
  return page2kva(page);
c0104c5e:	83 ec 0c             	sub    $0xc,%esp
c0104c61:	ff 75 f4             	pushl  -0xc(%ebp)
c0104c64:	e8 41 ff ff ff       	call   c0104baa <page2kva>
c0104c69:	83 c4 10             	add    $0x10,%esp
}
c0104c6c:	c9                   	leave  
c0104c6d:	c3                   	ret    

c0104c6e <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104c6e:	55                   	push   %ebp
c0104c6f:	89 e5                	mov    %esp,%ebp
c0104c71:	53                   	push   %ebx
c0104c72:	83 ec 04             	sub    $0x4,%esp
  free_pages(kva2page(kva), 1 << order);
c0104c75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c78:	ba 01 00 00 00       	mov    $0x1,%edx
c0104c7d:	89 c1                	mov    %eax,%ecx
c0104c7f:	d3 e2                	shl    %cl,%edx
c0104c81:	89 d0                	mov    %edx,%eax
c0104c83:	89 c3                	mov    %eax,%ebx
c0104c85:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c88:	83 ec 0c             	sub    $0xc,%esp
c0104c8b:	50                   	push   %eax
c0104c8c:	e8 5e ff ff ff       	call   c0104bef <kva2page>
c0104c91:	83 c4 10             	add    $0x10,%esp
c0104c94:	83 ec 08             	sub    $0x8,%esp
c0104c97:	53                   	push   %ebx
c0104c98:	50                   	push   %eax
c0104c99:	e8 95 23 00 00       	call   c0107033 <free_pages>
c0104c9e:	83 c4 10             	add    $0x10,%esp
}
c0104ca1:	90                   	nop
c0104ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104ca5:	c9                   	leave  
c0104ca6:	c3                   	ret    

c0104ca7 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104ca7:	55                   	push   %ebp
c0104ca8:	89 e5                	mov    %esp,%ebp
c0104caa:	83 ec 28             	sub    $0x28,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cb0:	83 c0 08             	add    $0x8,%eax
c0104cb3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104cb8:	76 16                	jbe    c0104cd0 <slob_alloc+0x29>
c0104cba:	68 b8 ad 10 c0       	push   $0xc010adb8
c0104cbf:	68 d7 ad 10 c0       	push   $0xc010add7
c0104cc4:	6a 64                	push   $0x64
c0104cc6:	68 ec ad 10 c0       	push   $0xc010adec
c0104ccb:	e8 28 b7 ff ff       	call   c01003f8 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104cd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104cd7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ce1:	83 c0 07             	add    $0x7,%eax
c0104ce4:	c1 e8 03             	shr    $0x3,%eax
c0104ce7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104cea:	e8 1a fe ff ff       	call   c0104b09 <__intr_save>
c0104cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c0104cf2:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cfd:	8b 40 04             	mov    0x4(%eax),%eax
c0104d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104d03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104d07:	74 25                	je     c0104d2e <slob_alloc+0x87>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104d09:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104d0c:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d0f:	01 d0                	add    %edx,%eax
c0104d11:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104d14:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d17:	f7 d8                	neg    %eax
c0104d19:	21 d0                	and    %edx,%eax
c0104d1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104d1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d24:	29 c2                	sub    %eax,%edx
c0104d26:	89 d0                	mov    %edx,%eax
c0104d28:	c1 f8 03             	sar    $0x3,%eax
c0104d2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d31:	8b 00                	mov    (%eax),%eax
c0104d33:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104d36:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104d39:	01 ca                	add    %ecx,%edx
c0104d3b:	39 d0                	cmp    %edx,%eax
c0104d3d:	0f 8c b1 00 00 00    	jl     c0104df4 <slob_alloc+0x14d>
			if (delta) { /* need to fragment head to align? */
c0104d43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104d47:	74 38                	je     c0104d81 <slob_alloc+0xda>
				aligned->units = cur->units - delta;
c0104d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d4c:	8b 00                	mov    (%eax),%eax
c0104d4e:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104d51:	89 c2                	mov    %eax,%edx
c0104d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d56:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d5b:	8b 50 04             	mov    0x4(%eax),%edx
c0104d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d61:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d67:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104d6a:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d70:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104d73:	89 10                	mov    %edx,(%eax)
				prev = cur;
c0104d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d84:	8b 00                	mov    (%eax),%eax
c0104d86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104d89:	75 0e                	jne    c0104d99 <slob_alloc+0xf2>
				prev->next = cur->next; /* unlink */
c0104d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d8e:	8b 50 04             	mov    0x4(%eax),%edx
c0104d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d94:	89 50 04             	mov    %edx,0x4(%eax)
c0104d97:	eb 3c                	jmp    c0104dd5 <slob_alloc+0x12e>
			else { /* fragment */
				prev->next = cur + units;
c0104d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d9c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104da6:	01 c2                	add    %eax,%edx
c0104da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dab:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db1:	8b 40 04             	mov    0x4(%eax),%eax
c0104db4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104db7:	8b 12                	mov    (%edx),%edx
c0104db9:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104dbc:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc1:	8b 40 04             	mov    0x4(%eax),%eax
c0104dc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104dc7:	8b 52 04             	mov    0x4(%edx),%edx
c0104dca:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104dd3:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd8:	a3 48 6a 12 c0       	mov    %eax,0xc0126a48
			spin_unlock_irqrestore(&slob_lock, flags);
c0104ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104de0:	83 ec 0c             	sub    $0xc,%esp
c0104de3:	50                   	push   %eax
c0104de4:	e8 4a fd ff ff       	call   c0104b33 <__intr_restore>
c0104de9:	83 c4 10             	add    $0x10,%esp
			return cur;
c0104dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104def:	e9 80 00 00 00       	jmp    c0104e74 <slob_alloc+0x1cd>
		}
		if (cur == slobfree) {
c0104df4:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104df9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104dfc:	75 62                	jne    c0104e60 <slob_alloc+0x1b9>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e01:	83 ec 0c             	sub    $0xc,%esp
c0104e04:	50                   	push   %eax
c0104e05:	e8 29 fd ff ff       	call   c0104b33 <__intr_restore>
c0104e0a:	83 c4 10             	add    $0x10,%esp

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c0104e0d:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104e14:	75 07                	jne    c0104e1d <slob_alloc+0x176>
				return 0;
c0104e16:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e1b:	eb 57                	jmp    c0104e74 <slob_alloc+0x1cd>

			cur = (slob_t *)__slob_get_free_page(gfp);
c0104e1d:	83 ec 08             	sub    $0x8,%esp
c0104e20:	6a 00                	push   $0x0
c0104e22:	ff 75 0c             	pushl  0xc(%ebp)
c0104e25:	e8 04 fe ff ff       	call   c0104c2e <__slob_get_free_pages>
c0104e2a:	83 c4 10             	add    $0x10,%esp
c0104e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104e30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e34:	75 07                	jne    c0104e3d <slob_alloc+0x196>
				return 0;
c0104e36:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e3b:	eb 37                	jmp    c0104e74 <slob_alloc+0x1cd>

			slob_free(cur, PAGE_SIZE);
c0104e3d:	83 ec 08             	sub    $0x8,%esp
c0104e40:	68 00 10 00 00       	push   $0x1000
c0104e45:	ff 75 f0             	pushl  -0x10(%ebp)
c0104e48:	e8 29 00 00 00       	call   c0104e76 <slob_free>
c0104e4d:	83 c4 10             	add    $0x10,%esp
			spin_lock_irqsave(&slob_lock, flags);
c0104e50:	e8 b4 fc ff ff       	call   c0104b09 <__intr_save>
c0104e55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104e58:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e69:	8b 40 04             	mov    0x4(%eax),%eax
c0104e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104e6f:	e9 8f fe ff ff       	jmp    c0104d03 <slob_alloc+0x5c>
}
c0104e74:	c9                   	leave  
c0104e75:	c3                   	ret    

c0104e76 <slob_free>:

static void slob_free(void *block, int size)
{
c0104e76:	55                   	push   %ebp
c0104e77:	89 e5                	mov    %esp,%ebp
c0104e79:	83 ec 18             	sub    $0x18,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104e7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104e82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104e86:	0f 84 05 01 00 00    	je     c0104f91 <slob_free+0x11b>
		return;

	if (size)
c0104e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104e90:	74 10                	je     c0104ea2 <slob_free+0x2c>
		b->units = SLOB_UNITS(size);
c0104e92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e95:	83 c0 07             	add    $0x7,%eax
c0104e98:	c1 e8 03             	shr    $0x3,%eax
c0104e9b:	89 c2                	mov    %eax,%edx
c0104e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ea0:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104ea2:	e8 62 fc ff ff       	call   c0104b09 <__intr_save>
c0104ea7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104eaa:	a1 48 6a 12 c0       	mov    0xc0126a48,%eax
c0104eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104eb2:	eb 27                	jmp    c0104edb <slob_free+0x65>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb7:	8b 40 04             	mov    0x4(%eax),%eax
c0104eba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ebd:	77 13                	ja     c0104ed2 <slob_free+0x5c>
c0104ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ec2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ec5:	77 27                	ja     c0104eee <slob_free+0x78>
c0104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eca:	8b 40 04             	mov    0x4(%eax),%eax
c0104ecd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ed0:	77 1c                	ja     c0104eee <slob_free+0x78>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed5:	8b 40 04             	mov    0x4(%eax),%eax
c0104ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ede:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ee1:	76 d1                	jbe    c0104eb4 <slob_free+0x3e>
c0104ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ee6:	8b 40 04             	mov    0x4(%eax),%eax
c0104ee9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104eec:	76 c6                	jbe    c0104eb4 <slob_free+0x3e>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef1:	8b 00                	mov    (%eax),%eax
c0104ef3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104efd:	01 c2                	add    %eax,%edx
c0104eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f02:	8b 40 04             	mov    0x4(%eax),%eax
c0104f05:	39 c2                	cmp    %eax,%edx
c0104f07:	75 25                	jne    c0104f2e <slob_free+0xb8>
		b->units += cur->next->units;
c0104f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f0c:	8b 10                	mov    (%eax),%edx
c0104f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f11:	8b 40 04             	mov    0x4(%eax),%eax
c0104f14:	8b 00                	mov    (%eax),%eax
c0104f16:	01 c2                	add    %eax,%edx
c0104f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f1b:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f20:	8b 40 04             	mov    0x4(%eax),%eax
c0104f23:	8b 50 04             	mov    0x4(%eax),%edx
c0104f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f29:	89 50 04             	mov    %edx,0x4(%eax)
c0104f2c:	eb 0c                	jmp    c0104f3a <slob_free+0xc4>
	} else
		b->next = cur->next;
c0104f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f31:	8b 50 04             	mov    0x4(%eax),%edx
c0104f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f37:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f3d:	8b 00                	mov    (%eax),%eax
c0104f3f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f49:	01 d0                	add    %edx,%eax
c0104f4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104f4e:	75 1f                	jne    c0104f6f <slob_free+0xf9>
		cur->units += b->units;
c0104f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f53:	8b 10                	mov    (%eax),%edx
c0104f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f58:	8b 00                	mov    (%eax),%eax
c0104f5a:	01 c2                	add    %eax,%edx
c0104f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f5f:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f64:	8b 50 04             	mov    0x4(%eax),%edx
c0104f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f6a:	89 50 04             	mov    %edx,0x4(%eax)
c0104f6d:	eb 09                	jmp    c0104f78 <slob_free+0x102>
	} else
		cur->next = b;
c0104f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f75:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f7b:	a3 48 6a 12 c0       	mov    %eax,0xc0126a48

	spin_unlock_irqrestore(&slob_lock, flags);
c0104f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f83:	83 ec 0c             	sub    $0xc,%esp
c0104f86:	50                   	push   %eax
c0104f87:	e8 a7 fb ff ff       	call   c0104b33 <__intr_restore>
c0104f8c:	83 c4 10             	add    $0x10,%esp
c0104f8f:	eb 01                	jmp    c0104f92 <slob_free+0x11c>
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
		return;
c0104f91:	90                   	nop
		cur->next = b;

	slobfree = cur;

	spin_unlock_irqrestore(&slob_lock, flags);
}
c0104f92:	c9                   	leave  
c0104f93:	c3                   	ret    

c0104f94 <slob_init>:



void
slob_init(void) {
c0104f94:	55                   	push   %ebp
c0104f95:	89 e5                	mov    %esp,%ebp
c0104f97:	83 ec 08             	sub    $0x8,%esp
  cprintf("use SLOB allocator\n");
c0104f9a:	83 ec 0c             	sub    $0xc,%esp
c0104f9d:	68 fe ad 10 c0       	push   $0xc010adfe
c0104fa2:	e8 eb b2 ff ff       	call   c0100292 <cprintf>
c0104fa7:	83 c4 10             	add    $0x10,%esp
}
c0104faa:	90                   	nop
c0104fab:	c9                   	leave  
c0104fac:	c3                   	ret    

c0104fad <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104fad:	55                   	push   %ebp
c0104fae:	89 e5                	mov    %esp,%ebp
c0104fb0:	83 ec 08             	sub    $0x8,%esp
    slob_init();
c0104fb3:	e8 dc ff ff ff       	call   c0104f94 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104fb8:	83 ec 0c             	sub    $0xc,%esp
c0104fbb:	68 12 ae 10 c0       	push   $0xc010ae12
c0104fc0:	e8 cd b2 ff ff       	call   c0100292 <cprintf>
c0104fc5:	83 c4 10             	add    $0x10,%esp
}
c0104fc8:	90                   	nop
c0104fc9:	c9                   	leave  
c0104fca:	c3                   	ret    

c0104fcb <slob_allocated>:

size_t
slob_allocated(void) {
c0104fcb:	55                   	push   %ebp
c0104fcc:	89 e5                	mov    %esp,%ebp
  return 0;
c0104fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104fd3:	5d                   	pop    %ebp
c0104fd4:	c3                   	ret    

c0104fd5 <kallocated>:

size_t
kallocated(void) {
c0104fd5:	55                   	push   %ebp
c0104fd6:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104fd8:	e8 ee ff ff ff       	call   c0104fcb <slob_allocated>
}
c0104fdd:	5d                   	pop    %ebp
c0104fde:	c3                   	ret    

c0104fdf <find_order>:

static int find_order(int size)
{
c0104fdf:	55                   	push   %ebp
c0104fe0:	89 e5                	mov    %esp,%ebp
c0104fe2:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104fe5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104fec:	eb 07                	jmp    c0104ff5 <find_order+0x16>
		order++;
c0104fee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104ff2:	d1 7d 08             	sarl   0x8(%ebp)
c0104ff5:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104ffc:	7f f0                	jg     c0104fee <find_order+0xf>
		order++;
	return order;
c0104ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105001:	c9                   	leave  
c0105002:	c3                   	ret    

c0105003 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0105003:	55                   	push   %ebp
c0105004:	89 e5                	mov    %esp,%ebp
c0105006:	83 ec 18             	sub    $0x18,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0105009:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0105010:	77 35                	ja     c0105047 <__kmalloc+0x44>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0105012:	8b 45 08             	mov    0x8(%ebp),%eax
c0105015:	83 c0 08             	add    $0x8,%eax
c0105018:	83 ec 04             	sub    $0x4,%esp
c010501b:	6a 00                	push   $0x0
c010501d:	ff 75 0c             	pushl  0xc(%ebp)
c0105020:	50                   	push   %eax
c0105021:	e8 81 fc ff ff       	call   c0104ca7 <slob_alloc>
c0105026:	83 c4 10             	add    $0x10,%esp
c0105029:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c010502c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105030:	74 0b                	je     c010503d <__kmalloc+0x3a>
c0105032:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105035:	83 c0 08             	add    $0x8,%eax
c0105038:	e9 b3 00 00 00       	jmp    c01050f0 <__kmalloc+0xed>
c010503d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105042:	e9 a9 00 00 00       	jmp    c01050f0 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0105047:	83 ec 04             	sub    $0x4,%esp
c010504a:	6a 00                	push   $0x0
c010504c:	ff 75 0c             	pushl  0xc(%ebp)
c010504f:	6a 0c                	push   $0xc
c0105051:	e8 51 fc ff ff       	call   c0104ca7 <slob_alloc>
c0105056:	83 c4 10             	add    $0x10,%esp
c0105059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c010505c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105060:	75 0a                	jne    c010506c <__kmalloc+0x69>
		return 0;
c0105062:	b8 00 00 00 00       	mov    $0x0,%eax
c0105067:	e9 84 00 00 00       	jmp    c01050f0 <__kmalloc+0xed>

	bb->order = find_order(size);
c010506c:	8b 45 08             	mov    0x8(%ebp),%eax
c010506f:	83 ec 0c             	sub    $0xc,%esp
c0105072:	50                   	push   %eax
c0105073:	e8 67 ff ff ff       	call   c0104fdf <find_order>
c0105078:	83 c4 10             	add    $0x10,%esp
c010507b:	89 c2                	mov    %eax,%edx
c010507d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105080:	89 10                	mov    %edx,(%eax)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0105082:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105085:	8b 00                	mov    (%eax),%eax
c0105087:	83 ec 08             	sub    $0x8,%esp
c010508a:	50                   	push   %eax
c010508b:	ff 75 0c             	pushl  0xc(%ebp)
c010508e:	e8 9b fb ff ff       	call   c0104c2e <__slob_get_free_pages>
c0105093:	83 c4 10             	add    $0x10,%esp
c0105096:	89 c2                	mov    %eax,%edx
c0105098:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010509b:	89 50 04             	mov    %edx,0x4(%eax)

	if (bb->pages) {
c010509e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050a1:	8b 40 04             	mov    0x4(%eax),%eax
c01050a4:	85 c0                	test   %eax,%eax
c01050a6:	74 33                	je     c01050db <__kmalloc+0xd8>
		spin_lock_irqsave(&block_lock, flags);
c01050a8:	e8 5c fa ff ff       	call   c0104b09 <__intr_save>
c01050ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c01050b0:	8b 15 68 9f 12 c0    	mov    0xc0129f68,%edx
c01050b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050b9:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c01050bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050bf:	a3 68 9f 12 c0       	mov    %eax,0xc0129f68
		spin_unlock_irqrestore(&block_lock, flags);
c01050c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050c7:	83 ec 0c             	sub    $0xc,%esp
c01050ca:	50                   	push   %eax
c01050cb:	e8 63 fa ff ff       	call   c0104b33 <__intr_restore>
c01050d0:	83 c4 10             	add    $0x10,%esp
		return bb->pages;
c01050d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050d6:	8b 40 04             	mov    0x4(%eax),%eax
c01050d9:	eb 15                	jmp    c01050f0 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c01050db:	83 ec 08             	sub    $0x8,%esp
c01050de:	6a 0c                	push   $0xc
c01050e0:	ff 75 f0             	pushl  -0x10(%ebp)
c01050e3:	e8 8e fd ff ff       	call   c0104e76 <slob_free>
c01050e8:	83 c4 10             	add    $0x10,%esp
	return 0;
c01050eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050f0:	c9                   	leave  
c01050f1:	c3                   	ret    

c01050f2 <kmalloc>:

void *
kmalloc(size_t size)
{
c01050f2:	55                   	push   %ebp
c01050f3:	89 e5                	mov    %esp,%ebp
c01050f5:	83 ec 08             	sub    $0x8,%esp
  return __kmalloc(size, 0);
c01050f8:	83 ec 08             	sub    $0x8,%esp
c01050fb:	6a 00                	push   $0x0
c01050fd:	ff 75 08             	pushl  0x8(%ebp)
c0105100:	e8 fe fe ff ff       	call   c0105003 <__kmalloc>
c0105105:	83 c4 10             	add    $0x10,%esp
}
c0105108:	c9                   	leave  
c0105109:	c3                   	ret    

c010510a <kfree>:


void kfree(void *block)
{
c010510a:	55                   	push   %ebp
c010510b:	89 e5                	mov    %esp,%ebp
c010510d:	83 ec 18             	sub    $0x18,%esp
	bigblock_t *bb, **last = &bigblocks;
c0105110:	c7 45 f0 68 9f 12 c0 	movl   $0xc0129f68,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0105117:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010511b:	0f 84 ac 00 00 00    	je     c01051cd <kfree+0xc3>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0105121:	8b 45 08             	mov    0x8(%ebp),%eax
c0105124:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105129:	85 c0                	test   %eax,%eax
c010512b:	0f 85 85 00 00 00    	jne    c01051b6 <kfree+0xac>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0105131:	e8 d3 f9 ff ff       	call   c0104b09 <__intr_save>
c0105136:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0105139:	a1 68 9f 12 c0       	mov    0xc0129f68,%eax
c010513e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105141:	eb 5e                	jmp    c01051a1 <kfree+0x97>
			if (bb->pages == block) {
c0105143:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105146:	8b 40 04             	mov    0x4(%eax),%eax
c0105149:	3b 45 08             	cmp    0x8(%ebp),%eax
c010514c:	75 41                	jne    c010518f <kfree+0x85>
				*last = bb->next;
c010514e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105151:	8b 50 08             	mov    0x8(%eax),%edx
c0105154:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105157:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0105159:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010515c:	83 ec 0c             	sub    $0xc,%esp
c010515f:	50                   	push   %eax
c0105160:	e8 ce f9 ff ff       	call   c0104b33 <__intr_restore>
c0105165:	83 c4 10             	add    $0x10,%esp
				__slob_free_pages((unsigned long)block, bb->order);
c0105168:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010516b:	8b 10                	mov    (%eax),%edx
c010516d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105170:	83 ec 08             	sub    $0x8,%esp
c0105173:	52                   	push   %edx
c0105174:	50                   	push   %eax
c0105175:	e8 f4 fa ff ff       	call   c0104c6e <__slob_free_pages>
c010517a:	83 c4 10             	add    $0x10,%esp
				slob_free(bb, sizeof(bigblock_t));
c010517d:	83 ec 08             	sub    $0x8,%esp
c0105180:	6a 0c                	push   $0xc
c0105182:	ff 75 f4             	pushl  -0xc(%ebp)
c0105185:	e8 ec fc ff ff       	call   c0104e76 <slob_free>
c010518a:	83 c4 10             	add    $0x10,%esp
				return;
c010518d:	eb 3f                	jmp    c01051ce <kfree+0xc4>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c010518f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105192:	83 c0 08             	add    $0x8,%eax
c0105195:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105198:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010519b:	8b 40 08             	mov    0x8(%eax),%eax
c010519e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051a5:	75 9c                	jne    c0105143 <kfree+0x39>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c01051a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051aa:	83 ec 0c             	sub    $0xc,%esp
c01051ad:	50                   	push   %eax
c01051ae:	e8 80 f9 ff ff       	call   c0104b33 <__intr_restore>
c01051b3:	83 c4 10             	add    $0x10,%esp
	}

	slob_free((slob_t *)block - 1, 0);
c01051b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b9:	83 e8 08             	sub    $0x8,%eax
c01051bc:	83 ec 08             	sub    $0x8,%esp
c01051bf:	6a 00                	push   $0x0
c01051c1:	50                   	push   %eax
c01051c2:	e8 af fc ff ff       	call   c0104e76 <slob_free>
c01051c7:	83 c4 10             	add    $0x10,%esp
	return;
c01051ca:	90                   	nop
c01051cb:	eb 01                	jmp    c01051ce <kfree+0xc4>
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;
c01051cd:	90                   	nop
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
c01051ce:	c9                   	leave  
c01051cf:	c3                   	ret    

c01051d0 <ksize>:


unsigned int ksize(const void *block)
{
c01051d0:	55                   	push   %ebp
c01051d1:	89 e5                	mov    %esp,%ebp
c01051d3:	83 ec 18             	sub    $0x18,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c01051d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01051da:	75 07                	jne    c01051e3 <ksize+0x13>
		return 0;
c01051dc:	b8 00 00 00 00       	mov    $0x0,%eax
c01051e1:	eb 73                	jmp    c0105256 <ksize+0x86>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01051e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e6:	25 ff 0f 00 00       	and    $0xfff,%eax
c01051eb:	85 c0                	test   %eax,%eax
c01051ed:	75 5c                	jne    c010524b <ksize+0x7b>
		spin_lock_irqsave(&block_lock, flags);
c01051ef:	e8 15 f9 ff ff       	call   c0104b09 <__intr_save>
c01051f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c01051f7:	a1 68 9f 12 c0       	mov    0xc0129f68,%eax
c01051fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051ff:	eb 35                	jmp    c0105236 <ksize+0x66>
			if (bb->pages == block) {
c0105201:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105204:	8b 40 04             	mov    0x4(%eax),%eax
c0105207:	3b 45 08             	cmp    0x8(%ebp),%eax
c010520a:	75 21                	jne    c010522d <ksize+0x5d>
				spin_unlock_irqrestore(&slob_lock, flags);
c010520c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010520f:	83 ec 0c             	sub    $0xc,%esp
c0105212:	50                   	push   %eax
c0105213:	e8 1b f9 ff ff       	call   c0104b33 <__intr_restore>
c0105218:	83 c4 10             	add    $0x10,%esp
				return PAGE_SIZE << bb->order;
c010521b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010521e:	8b 00                	mov    (%eax),%eax
c0105220:	ba 00 10 00 00       	mov    $0x1000,%edx
c0105225:	89 c1                	mov    %eax,%ecx
c0105227:	d3 e2                	shl    %cl,%edx
c0105229:	89 d0                	mov    %edx,%eax
c010522b:	eb 29                	jmp    c0105256 <ksize+0x86>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c010522d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105230:	8b 40 08             	mov    0x8(%eax),%eax
c0105233:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010523a:	75 c5                	jne    c0105201 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c010523c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010523f:	83 ec 0c             	sub    $0xc,%esp
c0105242:	50                   	push   %eax
c0105243:	e8 eb f8 ff ff       	call   c0104b33 <__intr_restore>
c0105248:	83 c4 10             	add    $0x10,%esp
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c010524b:	8b 45 08             	mov    0x8(%ebp),%eax
c010524e:	83 e8 08             	sub    $0x8,%eax
c0105251:	8b 00                	mov    (%eax),%eax
c0105253:	c1 e0 03             	shl    $0x3,%eax
}
c0105256:	c9                   	leave  
c0105257:	c3                   	ret    

c0105258 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105258:	55                   	push   %ebp
c0105259:	89 e5                	mov    %esp,%ebp
c010525b:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c010525e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105261:	c1 e8 0c             	shr    $0xc,%eax
c0105264:	89 c2                	mov    %eax,%edx
c0105266:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010526b:	39 c2                	cmp    %eax,%edx
c010526d:	72 14                	jb     c0105283 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c010526f:	83 ec 04             	sub    $0x4,%esp
c0105272:	68 30 ae 10 c0       	push   $0xc010ae30
c0105277:	6a 5f                	push   $0x5f
c0105279:	68 4f ae 10 c0       	push   $0xc010ae4f
c010527e:	e8 75 b1 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0105283:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0105288:	8b 55 08             	mov    0x8(%ebp),%edx
c010528b:	c1 ea 0c             	shr    $0xc,%edx
c010528e:	c1 e2 05             	shl    $0x5,%edx
c0105291:	01 d0                	add    %edx,%eax
}
c0105293:	c9                   	leave  
c0105294:	c3                   	ret    

c0105295 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0105295:	55                   	push   %ebp
c0105296:	89 e5                	mov    %esp,%ebp
c0105298:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c010529b:	8b 45 08             	mov    0x8(%ebp),%eax
c010529e:	83 e0 01             	and    $0x1,%eax
c01052a1:	85 c0                	test   %eax,%eax
c01052a3:	75 14                	jne    c01052b9 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c01052a5:	83 ec 04             	sub    $0x4,%esp
c01052a8:	68 60 ae 10 c0       	push   $0xc010ae60
c01052ad:	6a 71                	push   $0x71
c01052af:	68 4f ae 10 c0       	push   $0xc010ae4f
c01052b4:	e8 3f b1 ff ff       	call   c01003f8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01052b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01052c1:	83 ec 0c             	sub    $0xc,%esp
c01052c4:	50                   	push   %eax
c01052c5:	e8 8e ff ff ff       	call   c0105258 <pa2page>
c01052ca:	83 c4 10             	add    $0x10,%esp
}
c01052cd:	c9                   	leave  
c01052ce:	c3                   	ret    

c01052cf <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01052cf:	55                   	push   %ebp
c01052d0:	89 e5                	mov    %esp,%ebp
c01052d2:	83 ec 18             	sub    $0x18,%esp
     swapfs_init();
c01052d5:	e8 8c 32 00 00       	call   c0108566 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01052da:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c01052df:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01052e4:	76 0c                	jbe    c01052f2 <swap_init+0x23>
c01052e6:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c01052eb:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01052f0:	76 17                	jbe    c0105309 <swap_init+0x3a>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01052f2:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c01052f7:	50                   	push   %eax
c01052f8:	68 81 ae 10 c0       	push   $0xc010ae81
c01052fd:	6a 27                	push   $0x27
c01052ff:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105304:	e8 ef b0 ff ff       	call   c01003f8 <__panic>
     }
     

    // LAB3 : set sm as FIFO/ENHANCED CLOCK
    sm = &swap_manager_fifo;
c0105309:	c7 05 74 9f 12 c0 20 	movl   $0xc0126a20,0xc0129f74
c0105310:	6a 12 c0 
    // sm = &swap_manager_enclock;

     int r = sm->init();
c0105313:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105318:	8b 40 04             	mov    0x4(%eax),%eax
c010531b:	ff d0                	call   *%eax
c010531d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0105320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105324:	75 27                	jne    c010534d <swap_init+0x7e>
     {
          swap_init_ok = 1;
c0105326:	c7 05 6c 9f 12 c0 01 	movl   $0x1,0xc0129f6c
c010532d:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0105330:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105335:	8b 00                	mov    (%eax),%eax
c0105337:	83 ec 08             	sub    $0x8,%esp
c010533a:	50                   	push   %eax
c010533b:	68 ab ae 10 c0       	push   $0xc010aeab
c0105340:	e8 4d af ff ff       	call   c0100292 <cprintf>
c0105345:	83 c4 10             	add    $0x10,%esp
          check_swap();
c0105348:	e8 fa 03 00 00       	call   c0105747 <check_swap>
     }

     return r;
c010534d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105350:	c9                   	leave  
c0105351:	c3                   	ret    

c0105352 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0105352:	55                   	push   %ebp
c0105353:	89 e5                	mov    %esp,%ebp
c0105355:	83 ec 08             	sub    $0x8,%esp
     return sm->init_mm(mm);
c0105358:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c010535d:	8b 40 08             	mov    0x8(%eax),%eax
c0105360:	83 ec 0c             	sub    $0xc,%esp
c0105363:	ff 75 08             	pushl  0x8(%ebp)
c0105366:	ff d0                	call   *%eax
c0105368:	83 c4 10             	add    $0x10,%esp
}
c010536b:	c9                   	leave  
c010536c:	c3                   	ret    

c010536d <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010536d:	55                   	push   %ebp
c010536e:	89 e5                	mov    %esp,%ebp
c0105370:	83 ec 08             	sub    $0x8,%esp
     return sm->tick_event(mm);
c0105373:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105378:	8b 40 0c             	mov    0xc(%eax),%eax
c010537b:	83 ec 0c             	sub    $0xc,%esp
c010537e:	ff 75 08             	pushl  0x8(%ebp)
c0105381:	ff d0                	call   *%eax
c0105383:	83 c4 10             	add    $0x10,%esp
}
c0105386:	c9                   	leave  
c0105387:	c3                   	ret    

c0105388 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0105388:	55                   	push   %ebp
c0105389:	89 e5                	mov    %esp,%ebp
c010538b:	83 ec 08             	sub    $0x8,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010538e:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105393:	8b 40 10             	mov    0x10(%eax),%eax
c0105396:	ff 75 14             	pushl  0x14(%ebp)
c0105399:	ff 75 10             	pushl  0x10(%ebp)
c010539c:	ff 75 0c             	pushl  0xc(%ebp)
c010539f:	ff 75 08             	pushl  0x8(%ebp)
c01053a2:	ff d0                	call   *%eax
c01053a4:	83 c4 10             	add    $0x10,%esp
}
c01053a7:	c9                   	leave  
c01053a8:	c3                   	ret    

c01053a9 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01053a9:	55                   	push   %ebp
c01053aa:	89 e5                	mov    %esp,%ebp
c01053ac:	83 ec 08             	sub    $0x8,%esp
     return sm->set_unswappable(mm, addr);
c01053af:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c01053b4:	8b 40 14             	mov    0x14(%eax),%eax
c01053b7:	83 ec 08             	sub    $0x8,%esp
c01053ba:	ff 75 0c             	pushl  0xc(%ebp)
c01053bd:	ff 75 08             	pushl  0x8(%ebp)
c01053c0:	ff d0                	call   *%eax
c01053c2:	83 c4 10             	add    $0x10,%esp
}
c01053c5:	c9                   	leave  
c01053c6:	c3                   	ret    

c01053c7 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01053c7:	55                   	push   %ebp
c01053c8:	89 e5                	mov    %esp,%ebp
c01053ca:	83 ec 28             	sub    $0x28,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01053cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01053d4:	e9 2e 01 00 00       	jmp    c0105507 <swap_out+0x140>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01053d9:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c01053de:	8b 40 18             	mov    0x18(%eax),%eax
c01053e1:	83 ec 04             	sub    $0x4,%esp
c01053e4:	ff 75 10             	pushl  0x10(%ebp)
c01053e7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01053ea:	52                   	push   %edx
c01053eb:	ff 75 08             	pushl  0x8(%ebp)
c01053ee:	ff d0                	call   *%eax
c01053f0:	83 c4 10             	add    $0x10,%esp
c01053f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01053f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053fa:	74 18                	je     c0105414 <swap_out+0x4d>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01053fc:	83 ec 08             	sub    $0x8,%esp
c01053ff:	ff 75 f4             	pushl  -0xc(%ebp)
c0105402:	68 c0 ae 10 c0       	push   $0xc010aec0
c0105407:	e8 86 ae ff ff       	call   c0100292 <cprintf>
c010540c:	83 c4 10             	add    $0x10,%esp
c010540f:	e9 ff 00 00 00       	jmp    c0105513 <swap_out+0x14c>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0105414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105417:	8b 40 1c             	mov    0x1c(%eax),%eax
c010541a:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010541d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105420:	8b 40 0c             	mov    0xc(%eax),%eax
c0105423:	83 ec 04             	sub    $0x4,%esp
c0105426:	6a 00                	push   $0x0
c0105428:	ff 75 ec             	pushl  -0x14(%ebp)
c010542b:	50                   	push   %eax
c010542c:	e8 02 22 00 00       	call   c0107633 <get_pte>
c0105431:	83 c4 10             	add    $0x10,%esp
c0105434:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0105437:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010543a:	8b 00                	mov    (%eax),%eax
c010543c:	83 e0 01             	and    $0x1,%eax
c010543f:	85 c0                	test   %eax,%eax
c0105441:	75 16                	jne    c0105459 <swap_out+0x92>
c0105443:	68 ed ae 10 c0       	push   $0xc010aeed
c0105448:	68 02 af 10 c0       	push   $0xc010af02
c010544d:	6a 6a                	push   $0x6a
c010544f:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105454:	e8 9f af ff ff       	call   c01003f8 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0105459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010545c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010545f:	8b 52 1c             	mov    0x1c(%edx),%edx
c0105462:	c1 ea 0c             	shr    $0xc,%edx
c0105465:	83 c2 01             	add    $0x1,%edx
c0105468:	c1 e2 08             	shl    $0x8,%edx
c010546b:	83 ec 08             	sub    $0x8,%esp
c010546e:	50                   	push   %eax
c010546f:	52                   	push   %edx
c0105470:	e8 8d 31 00 00       	call   c0108602 <swapfs_write>
c0105475:	83 c4 10             	add    $0x10,%esp
c0105478:	85 c0                	test   %eax,%eax
c010547a:	74 2b                	je     c01054a7 <swap_out+0xe0>
                    cprintf("SWAP: failed to save\n");
c010547c:	83 ec 0c             	sub    $0xc,%esp
c010547f:	68 17 af 10 c0       	push   $0xc010af17
c0105484:	e8 09 ae ff ff       	call   c0100292 <cprintf>
c0105489:	83 c4 10             	add    $0x10,%esp
                    sm->map_swappable(mm, v, page, 0);
c010548c:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c0105491:	8b 40 10             	mov    0x10(%eax),%eax
c0105494:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105497:	6a 00                	push   $0x0
c0105499:	52                   	push   %edx
c010549a:	ff 75 ec             	pushl  -0x14(%ebp)
c010549d:	ff 75 08             	pushl  0x8(%ebp)
c01054a0:	ff d0                	call   *%eax
c01054a2:	83 c4 10             	add    $0x10,%esp
c01054a5:	eb 5c                	jmp    c0105503 <swap_out+0x13c>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01054a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054aa:	8b 40 1c             	mov    0x1c(%eax),%eax
c01054ad:	c1 e8 0c             	shr    $0xc,%eax
c01054b0:	83 c0 01             	add    $0x1,%eax
c01054b3:	50                   	push   %eax
c01054b4:	ff 75 ec             	pushl  -0x14(%ebp)
c01054b7:	ff 75 f4             	pushl  -0xc(%ebp)
c01054ba:	68 30 af 10 c0       	push   $0xc010af30
c01054bf:	e8 ce ad ff ff       	call   c0100292 <cprintf>
c01054c4:	83 c4 10             	add    $0x10,%esp
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01054c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054ca:	8b 40 1c             	mov    0x1c(%eax),%eax
c01054cd:	c1 e8 0c             	shr    $0xc,%eax
c01054d0:	83 c0 01             	add    $0x1,%eax
c01054d3:	c1 e0 08             	shl    $0x8,%eax
c01054d6:	89 c2                	mov    %eax,%edx
c01054d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054db:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01054dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054e0:	83 ec 08             	sub    $0x8,%esp
c01054e3:	6a 01                	push   $0x1
c01054e5:	50                   	push   %eax
c01054e6:	e8 48 1b 00 00       	call   c0107033 <free_pages>
c01054eb:	83 c4 10             	add    $0x10,%esp
          }
          
          tlb_invalidate(mm->pgdir, v);
c01054ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f1:	8b 40 0c             	mov    0xc(%eax),%eax
c01054f4:	83 ec 08             	sub    $0x8,%esp
c01054f7:	ff 75 ec             	pushl  -0x14(%ebp)
c01054fa:	50                   	push   %eax
c01054fb:	e8 2b 24 00 00       	call   c010792b <tlb_invalidate>
c0105500:	83 c4 10             	add    $0x10,%esp

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0105503:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105507:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010550a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010550d:	0f 85 c6 fe ff ff    	jne    c01053d9 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0105513:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105516:	c9                   	leave  
c0105517:	c3                   	ret    

c0105518 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0105518:	55                   	push   %ebp
c0105519:	89 e5                	mov    %esp,%ebp
c010551b:	83 ec 18             	sub    $0x18,%esp
     struct Page *result = alloc_page();
c010551e:	83 ec 0c             	sub    $0xc,%esp
c0105521:	6a 01                	push   $0x1
c0105523:	e8 9f 1a 00 00       	call   c0106fc7 <alloc_pages>
c0105528:	83 c4 10             	add    $0x10,%esp
c010552b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c010552e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105532:	75 19                	jne    c010554d <swap_in+0x35>
c0105534:	68 70 af 10 c0       	push   $0xc010af70
c0105539:	68 02 af 10 c0       	push   $0xc010af02
c010553e:	68 80 00 00 00       	push   $0x80
c0105543:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105548:	e8 ab ae ff ff       	call   c01003f8 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010554d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105550:	8b 40 0c             	mov    0xc(%eax),%eax
c0105553:	83 ec 04             	sub    $0x4,%esp
c0105556:	6a 00                	push   $0x0
c0105558:	ff 75 0c             	pushl  0xc(%ebp)
c010555b:	50                   	push   %eax
c010555c:	e8 d2 20 00 00       	call   c0107633 <get_pte>
c0105561:	83 c4 10             	add    $0x10,%esp
c0105564:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0105567:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010556a:	8b 00                	mov    (%eax),%eax
c010556c:	83 ec 08             	sub    $0x8,%esp
c010556f:	ff 75 f4             	pushl  -0xc(%ebp)
c0105572:	50                   	push   %eax
c0105573:	e8 31 30 00 00       	call   c01085a9 <swapfs_read>
c0105578:	83 c4 10             	add    $0x10,%esp
c010557b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010557e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105582:	74 1f                	je     c01055a3 <swap_in+0x8b>
     {
        assert(r!=0);
c0105584:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105588:	75 19                	jne    c01055a3 <swap_in+0x8b>
c010558a:	68 7d af 10 c0       	push   $0xc010af7d
c010558f:	68 02 af 10 c0       	push   $0xc010af02
c0105594:	68 88 00 00 00       	push   $0x88
c0105599:	68 9c ae 10 c0       	push   $0xc010ae9c
c010559e:	e8 55 ae ff ff       	call   c01003f8 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01055a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055a6:	8b 00                	mov    (%eax),%eax
c01055a8:	c1 e8 08             	shr    $0x8,%eax
c01055ab:	83 ec 04             	sub    $0x4,%esp
c01055ae:	ff 75 0c             	pushl  0xc(%ebp)
c01055b1:	50                   	push   %eax
c01055b2:	68 84 af 10 c0       	push   $0xc010af84
c01055b7:	e8 d6 ac ff ff       	call   c0100292 <cprintf>
c01055bc:	83 c4 10             	add    $0x10,%esp
     *ptr_result=result;
c01055bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01055c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055c5:	89 10                	mov    %edx,(%eax)
     return 0;
c01055c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01055cc:	c9                   	leave  
c01055cd:	c3                   	ret    

c01055ce <check_content_set>:



static inline void
check_content_set(void)
{
c01055ce:	55                   	push   %ebp
c01055cf:	89 e5                	mov    %esp,%ebp
c01055d1:	83 ec 08             	sub    $0x8,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01055d4:	b8 00 10 00 00       	mov    $0x1000,%eax
c01055d9:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01055dc:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01055e1:	83 f8 01             	cmp    $0x1,%eax
c01055e4:	74 19                	je     c01055ff <check_content_set+0x31>
c01055e6:	68 c2 af 10 c0       	push   $0xc010afc2
c01055eb:	68 02 af 10 c0       	push   $0xc010af02
c01055f0:	68 95 00 00 00       	push   $0x95
c01055f5:	68 9c ae 10 c0       	push   $0xc010ae9c
c01055fa:	e8 f9 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01055ff:	b8 10 10 00 00       	mov    $0x1010,%eax
c0105604:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0105607:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010560c:	83 f8 01             	cmp    $0x1,%eax
c010560f:	74 19                	je     c010562a <check_content_set+0x5c>
c0105611:	68 c2 af 10 c0       	push   $0xc010afc2
c0105616:	68 02 af 10 c0       	push   $0xc010af02
c010561b:	68 97 00 00 00       	push   $0x97
c0105620:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105625:	e8 ce ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010562a:	b8 00 20 00 00       	mov    $0x2000,%eax
c010562f:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0105632:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0105637:	83 f8 02             	cmp    $0x2,%eax
c010563a:	74 19                	je     c0105655 <check_content_set+0x87>
c010563c:	68 d1 af 10 c0       	push   $0xc010afd1
c0105641:	68 02 af 10 c0       	push   $0xc010af02
c0105646:	68 99 00 00 00       	push   $0x99
c010564b:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105650:	e8 a3 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0105655:	b8 10 20 00 00       	mov    $0x2010,%eax
c010565a:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010565d:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c0105662:	83 f8 02             	cmp    $0x2,%eax
c0105665:	74 19                	je     c0105680 <check_content_set+0xb2>
c0105667:	68 d1 af 10 c0       	push   $0xc010afd1
c010566c:	68 02 af 10 c0       	push   $0xc010af02
c0105671:	68 9b 00 00 00       	push   $0x9b
c0105676:	68 9c ae 10 c0       	push   $0xc010ae9c
c010567b:	e8 78 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0105680:	b8 00 30 00 00       	mov    $0x3000,%eax
c0105685:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0105688:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010568d:	83 f8 03             	cmp    $0x3,%eax
c0105690:	74 19                	je     c01056ab <check_content_set+0xdd>
c0105692:	68 e0 af 10 c0       	push   $0xc010afe0
c0105697:	68 02 af 10 c0       	push   $0xc010af02
c010569c:	68 9d 00 00 00       	push   $0x9d
c01056a1:	68 9c ae 10 c0       	push   $0xc010ae9c
c01056a6:	e8 4d ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01056ab:	b8 10 30 00 00       	mov    $0x3010,%eax
c01056b0:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01056b3:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01056b8:	83 f8 03             	cmp    $0x3,%eax
c01056bb:	74 19                	je     c01056d6 <check_content_set+0x108>
c01056bd:	68 e0 af 10 c0       	push   $0xc010afe0
c01056c2:	68 02 af 10 c0       	push   $0xc010af02
c01056c7:	68 9f 00 00 00       	push   $0x9f
c01056cc:	68 9c ae 10 c0       	push   $0xc010ae9c
c01056d1:	e8 22 ad ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01056d6:	b8 00 40 00 00       	mov    $0x4000,%eax
c01056db:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01056de:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c01056e3:	83 f8 04             	cmp    $0x4,%eax
c01056e6:	74 19                	je     c0105701 <check_content_set+0x133>
c01056e8:	68 ef af 10 c0       	push   $0xc010afef
c01056ed:	68 02 af 10 c0       	push   $0xc010af02
c01056f2:	68 a1 00 00 00       	push   $0xa1
c01056f7:	68 9c ae 10 c0       	push   $0xc010ae9c
c01056fc:	e8 f7 ac ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0105701:	b8 10 40 00 00       	mov    $0x4010,%eax
c0105706:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0105709:	a1 64 9f 12 c0       	mov    0xc0129f64,%eax
c010570e:	83 f8 04             	cmp    $0x4,%eax
c0105711:	74 19                	je     c010572c <check_content_set+0x15e>
c0105713:	68 ef af 10 c0       	push   $0xc010afef
c0105718:	68 02 af 10 c0       	push   $0xc010af02
c010571d:	68 a3 00 00 00       	push   $0xa3
c0105722:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105727:	e8 cc ac ff ff       	call   c01003f8 <__panic>
}
c010572c:	90                   	nop
c010572d:	c9                   	leave  
c010572e:	c3                   	ret    

c010572f <check_content_access>:

static inline int
check_content_access(void)
{
c010572f:	55                   	push   %ebp
c0105730:	89 e5                	mov    %esp,%ebp
c0105732:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0105735:	a1 74 9f 12 c0       	mov    0xc0129f74,%eax
c010573a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010573d:	ff d0                	call   *%eax
c010573f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0105742:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105745:	c9                   	leave  
c0105746:	c3                   	ret    

c0105747 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0105747:	55                   	push   %ebp
c0105748:	89 e5                	mov    %esp,%ebp
c010574a:	83 ec 68             	sub    $0x68,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010574d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105754:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010575b:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0105762:	eb 60                	jmp    c01057c4 <check_swap+0x7d>
        struct Page *p = le2page(le, page_link);
c0105764:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105767:	83 e8 0c             	sub    $0xc,%eax
c010576a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(PageProperty(p));
c010576d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105770:	83 c0 04             	add    $0x4,%eax
c0105773:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010577a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010577d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105780:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105783:	0f a3 10             	bt     %edx,(%eax)
c0105786:	19 c0                	sbb    %eax,%eax
c0105788:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c010578b:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c010578f:	0f 95 c0             	setne  %al
c0105792:	0f b6 c0             	movzbl %al,%eax
c0105795:	85 c0                	test   %eax,%eax
c0105797:	75 19                	jne    c01057b2 <check_swap+0x6b>
c0105799:	68 fe af 10 c0       	push   $0xc010affe
c010579e:	68 02 af 10 c0       	push   $0xc010af02
c01057a3:	68 be 00 00 00       	push   $0xbe
c01057a8:	68 9c ae 10 c0       	push   $0xc010ae9c
c01057ad:	e8 46 ac ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c01057b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01057b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057b9:	8b 50 08             	mov    0x8(%eax),%edx
c01057bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057bf:	01 d0                	add    %edx,%eax
c01057c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01057ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057cd:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01057d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057d3:	81 7d e8 84 c1 12 c0 	cmpl   $0xc012c184,-0x18(%ebp)
c01057da:	75 88                	jne    c0105764 <check_swap+0x1d>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01057dc:	e8 87 18 00 00       	call   c0107068 <nr_free_pages>
c01057e1:	89 c2                	mov    %eax,%edx
c01057e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057e6:	39 c2                	cmp    %eax,%edx
c01057e8:	74 19                	je     c0105803 <check_swap+0xbc>
c01057ea:	68 0e b0 10 c0       	push   $0xc010b00e
c01057ef:	68 02 af 10 c0       	push   $0xc010af02
c01057f4:	68 c1 00 00 00       	push   $0xc1
c01057f9:	68 9c ae 10 c0       	push   $0xc010ae9c
c01057fe:	e8 f5 ab ff ff       	call   c01003f8 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0105803:	83 ec 04             	sub    $0x4,%esp
c0105806:	ff 75 f0             	pushl  -0x10(%ebp)
c0105809:	ff 75 f4             	pushl  -0xc(%ebp)
c010580c:	68 28 b0 10 c0       	push   $0xc010b028
c0105811:	e8 7c aa ff ff       	call   c0100292 <cprintf>
c0105816:	83 c4 10             	add    $0x10,%esp
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0105819:	e8 50 e2 ff ff       	call   c0103a6e <mm_create>
c010581e:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(mm != NULL);
c0105821:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105825:	75 19                	jne    c0105840 <check_swap+0xf9>
c0105827:	68 4e b0 10 c0       	push   $0xc010b04e
c010582c:	68 02 af 10 c0       	push   $0xc010af02
c0105831:	68 c6 00 00 00       	push   $0xc6
c0105836:	68 9c ae 10 c0       	push   $0xc010ae9c
c010583b:	e8 b8 ab ff ff       	call   c01003f8 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0105840:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c0105845:	85 c0                	test   %eax,%eax
c0105847:	74 19                	je     c0105862 <check_swap+0x11b>
c0105849:	68 59 b0 10 c0       	push   $0xc010b059
c010584e:	68 02 af 10 c0       	push   $0xc010af02
c0105853:	68 c9 00 00 00       	push   $0xc9
c0105858:	68 9c ae 10 c0       	push   $0xc010ae9c
c010585d:	e8 96 ab ff ff       	call   c01003f8 <__panic>

     check_mm_struct = mm;
c0105862:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105865:	a3 bc c0 12 c0       	mov    %eax,0xc012c0bc

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010586a:	8b 15 60 6a 12 c0    	mov    0xc0126a60,%edx
c0105870:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105873:	89 50 0c             	mov    %edx,0xc(%eax)
c0105876:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105879:	8b 40 0c             	mov    0xc(%eax),%eax
c010587c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(pgdir[0] == 0);
c010587f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105882:	8b 00                	mov    (%eax),%eax
c0105884:	85 c0                	test   %eax,%eax
c0105886:	74 19                	je     c01058a1 <check_swap+0x15a>
c0105888:	68 71 b0 10 c0       	push   $0xc010b071
c010588d:	68 02 af 10 c0       	push   $0xc010af02
c0105892:	68 ce 00 00 00       	push   $0xce
c0105897:	68 9c ae 10 c0       	push   $0xc010ae9c
c010589c:	e8 57 ab ff ff       	call   c01003f8 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01058a1:	83 ec 04             	sub    $0x4,%esp
c01058a4:	6a 03                	push   $0x3
c01058a6:	68 00 60 00 00       	push   $0x6000
c01058ab:	68 00 10 00 00       	push   $0x1000
c01058b0:	e8 35 e2 ff ff       	call   c0103aea <vma_create>
c01058b5:	83 c4 10             	add    $0x10,%esp
c01058b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(vma != NULL);
c01058bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01058bf:	75 19                	jne    c01058da <check_swap+0x193>
c01058c1:	68 7f b0 10 c0       	push   $0xc010b07f
c01058c6:	68 02 af 10 c0       	push   $0xc010af02
c01058cb:	68 d1 00 00 00       	push   $0xd1
c01058d0:	68 9c ae 10 c0       	push   $0xc010ae9c
c01058d5:	e8 1e ab ff ff       	call   c01003f8 <__panic>

     insert_vma_struct(mm, vma);
c01058da:	83 ec 08             	sub    $0x8,%esp
c01058dd:	ff 75 d0             	pushl  -0x30(%ebp)
c01058e0:	ff 75 d8             	pushl  -0x28(%ebp)
c01058e3:	e8 6a e3 ff ff       	call   c0103c52 <insert_vma_struct>
c01058e8:	83 c4 10             	add    $0x10,%esp

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01058eb:	83 ec 0c             	sub    $0xc,%esp
c01058ee:	68 8c b0 10 c0       	push   $0xc010b08c
c01058f3:	e8 9a a9 ff ff       	call   c0100292 <cprintf>
c01058f8:	83 c4 10             	add    $0x10,%esp
     pte_t *temp_ptep=NULL;
c01058fb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0105902:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105905:	8b 40 0c             	mov    0xc(%eax),%eax
c0105908:	83 ec 04             	sub    $0x4,%esp
c010590b:	6a 01                	push   $0x1
c010590d:	68 00 10 00 00       	push   $0x1000
c0105912:	50                   	push   %eax
c0105913:	e8 1b 1d 00 00       	call   c0107633 <get_pte>
c0105918:	83 c4 10             	add    $0x10,%esp
c010591b:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(temp_ptep!= NULL);
c010591e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105922:	75 19                	jne    c010593d <check_swap+0x1f6>
c0105924:	68 c0 b0 10 c0       	push   $0xc010b0c0
c0105929:	68 02 af 10 c0       	push   $0xc010af02
c010592e:	68 d9 00 00 00       	push   $0xd9
c0105933:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105938:	e8 bb aa ff ff       	call   c01003f8 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c010593d:	83 ec 0c             	sub    $0xc,%esp
c0105940:	68 d4 b0 10 c0       	push   $0xc010b0d4
c0105945:	e8 48 a9 ff ff       	call   c0100292 <cprintf>
c010594a:	83 c4 10             	add    $0x10,%esp
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010594d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105954:	e9 90 00 00 00       	jmp    c01059e9 <check_swap+0x2a2>
          check_rp[i] = alloc_page();
c0105959:	83 ec 0c             	sub    $0xc,%esp
c010595c:	6a 01                	push   $0x1
c010595e:	e8 64 16 00 00       	call   c0106fc7 <alloc_pages>
c0105963:	83 c4 10             	add    $0x10,%esp
c0105966:	89 c2                	mov    %eax,%edx
c0105968:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010596b:	89 14 85 c0 c0 12 c0 	mov    %edx,-0x3fed3f40(,%eax,4)
          assert(check_rp[i] != NULL );
c0105972:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105975:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c010597c:	85 c0                	test   %eax,%eax
c010597e:	75 19                	jne    c0105999 <check_swap+0x252>
c0105980:	68 f8 b0 10 c0       	push   $0xc010b0f8
c0105985:	68 02 af 10 c0       	push   $0xc010af02
c010598a:	68 de 00 00 00       	push   $0xde
c010598f:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105994:	e8 5f aa ff ff       	call   c01003f8 <__panic>
          assert(!PageProperty(check_rp[i]));
c0105999:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010599c:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c01059a3:	83 c0 04             	add    $0x4,%eax
c01059a6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01059ad:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01059b0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01059b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01059b6:	0f a3 10             	bt     %edx,(%eax)
c01059b9:	19 c0                	sbb    %eax,%eax
c01059bb:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c01059be:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c01059c2:	0f 95 c0             	setne  %al
c01059c5:	0f b6 c0             	movzbl %al,%eax
c01059c8:	85 c0                	test   %eax,%eax
c01059ca:	74 19                	je     c01059e5 <check_swap+0x29e>
c01059cc:	68 0c b1 10 c0       	push   $0xc010b10c
c01059d1:	68 02 af 10 c0       	push   $0xc010af02
c01059d6:	68 df 00 00 00       	push   $0xdf
c01059db:	68 9c ae 10 c0       	push   $0xc010ae9c
c01059e0:	e8 13 aa ff ff       	call   c01003f8 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01059e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01059e9:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01059ed:	0f 8e 66 ff ff ff    	jle    c0105959 <check_swap+0x212>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01059f3:	a1 84 c1 12 c0       	mov    0xc012c184,%eax
c01059f8:	8b 15 88 c1 12 c0    	mov    0xc012c188,%edx
c01059fe:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105a01:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105a04:	c7 45 c0 84 c1 12 c0 	movl   $0xc012c184,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105a0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a0e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105a11:	89 50 04             	mov    %edx,0x4(%eax)
c0105a14:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a17:	8b 50 04             	mov    0x4(%eax),%edx
c0105a1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a1d:	89 10                	mov    %edx,(%eax)
c0105a1f:	c7 45 c8 84 c1 12 c0 	movl   $0xc012c184,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0105a26:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105a29:	8b 40 04             	mov    0x4(%eax),%eax
c0105a2c:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c0105a2f:	0f 94 c0             	sete   %al
c0105a32:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0105a35:	85 c0                	test   %eax,%eax
c0105a37:	75 19                	jne    c0105a52 <check_swap+0x30b>
c0105a39:	68 27 b1 10 c0       	push   $0xc010b127
c0105a3e:	68 02 af 10 c0       	push   $0xc010af02
c0105a43:	68 e3 00 00 00       	push   $0xe3
c0105a48:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105a4d:	e8 a6 a9 ff ff       	call   c01003f8 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0105a52:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105a57:	89 45 bc             	mov    %eax,-0x44(%ebp)
     nr_free = 0;
c0105a5a:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0105a61:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105a64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105a6b:	eb 1c                	jmp    c0105a89 <check_swap+0x342>
        free_pages(check_rp[i],1);
c0105a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a70:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c0105a77:	83 ec 08             	sub    $0x8,%esp
c0105a7a:	6a 01                	push   $0x1
c0105a7c:	50                   	push   %eax
c0105a7d:	e8 b1 15 00 00       	call   c0107033 <free_pages>
c0105a82:	83 c4 10             	add    $0x10,%esp
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105a85:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105a89:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105a8d:	7e de                	jle    c0105a6d <check_swap+0x326>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0105a8f:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105a94:	83 f8 04             	cmp    $0x4,%eax
c0105a97:	74 19                	je     c0105ab2 <check_swap+0x36b>
c0105a99:	68 40 b1 10 c0       	push   $0xc010b140
c0105a9e:	68 02 af 10 c0       	push   $0xc010af02
c0105aa3:	68 ec 00 00 00       	push   $0xec
c0105aa8:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105aad:	e8 46 a9 ff ff       	call   c01003f8 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0105ab2:	83 ec 0c             	sub    $0xc,%esp
c0105ab5:	68 64 b1 10 c0       	push   $0xc010b164
c0105aba:	e8 d3 a7 ff ff       	call   c0100292 <cprintf>
c0105abf:	83 c4 10             	add    $0x10,%esp
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0105ac2:	c7 05 64 9f 12 c0 00 	movl   $0x0,0xc0129f64
c0105ac9:	00 00 00 
     
     check_content_set();
c0105acc:	e8 fd fa ff ff       	call   c01055ce <check_content_set>
     assert( nr_free == 0);         
c0105ad1:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105ad6:	85 c0                	test   %eax,%eax
c0105ad8:	74 19                	je     c0105af3 <check_swap+0x3ac>
c0105ada:	68 8b b1 10 c0       	push   $0xc010b18b
c0105adf:	68 02 af 10 c0       	push   $0xc010af02
c0105ae4:	68 f5 00 00 00       	push   $0xf5
c0105ae9:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105aee:	e8 05 a9 ff ff       	call   c01003f8 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105af3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105afa:	eb 26                	jmp    c0105b22 <check_swap+0x3db>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0105afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aff:	c7 04 85 e0 c0 12 c0 	movl   $0xffffffff,-0x3fed3f20(,%eax,4)
c0105b06:	ff ff ff ff 
c0105b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b0d:	8b 14 85 e0 c0 12 c0 	mov    -0x3fed3f20(,%eax,4),%edx
c0105b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b17:	89 14 85 20 c1 12 c0 	mov    %edx,-0x3fed3ee0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105b1e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105b22:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0105b26:	7e d4                	jle    c0105afc <check_swap+0x3b5>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105b28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105b2f:	e9 cc 00 00 00       	jmp    c0105c00 <check_swap+0x4b9>
         check_ptep[i]=0;
c0105b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b37:	c7 04 85 74 c1 12 c0 	movl   $0x0,-0x3fed3e8c(,%eax,4)
c0105b3e:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0105b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b45:	83 c0 01             	add    $0x1,%eax
c0105b48:	c1 e0 0c             	shl    $0xc,%eax
c0105b4b:	83 ec 04             	sub    $0x4,%esp
c0105b4e:	6a 00                	push   $0x0
c0105b50:	50                   	push   %eax
c0105b51:	ff 75 d4             	pushl  -0x2c(%ebp)
c0105b54:	e8 da 1a 00 00       	call   c0107633 <get_pte>
c0105b59:	83 c4 10             	add    $0x10,%esp
c0105b5c:	89 c2                	mov    %eax,%edx
c0105b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b61:	89 14 85 74 c1 12 c0 	mov    %edx,-0x3fed3e8c(,%eax,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0105b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b6b:	8b 04 85 74 c1 12 c0 	mov    -0x3fed3e8c(,%eax,4),%eax
c0105b72:	85 c0                	test   %eax,%eax
c0105b74:	75 19                	jne    c0105b8f <check_swap+0x448>
c0105b76:	68 98 b1 10 c0       	push   $0xc010b198
c0105b7b:	68 02 af 10 c0       	push   $0xc010af02
c0105b80:	68 fd 00 00 00       	push   $0xfd
c0105b85:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105b8a:	e8 69 a8 ff ff       	call   c01003f8 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0105b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b92:	8b 04 85 74 c1 12 c0 	mov    -0x3fed3e8c(,%eax,4),%eax
c0105b99:	8b 00                	mov    (%eax),%eax
c0105b9b:	83 ec 0c             	sub    $0xc,%esp
c0105b9e:	50                   	push   %eax
c0105b9f:	e8 f1 f6 ff ff       	call   c0105295 <pte2page>
c0105ba4:	83 c4 10             	add    $0x10,%esp
c0105ba7:	89 c2                	mov    %eax,%edx
c0105ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bac:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c0105bb3:	39 c2                	cmp    %eax,%edx
c0105bb5:	74 19                	je     c0105bd0 <check_swap+0x489>
c0105bb7:	68 b0 b1 10 c0       	push   $0xc010b1b0
c0105bbc:	68 02 af 10 c0       	push   $0xc010af02
c0105bc1:	68 fe 00 00 00       	push   $0xfe
c0105bc6:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105bcb:	e8 28 a8 ff ff       	call   c01003f8 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0105bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bd3:	8b 04 85 74 c1 12 c0 	mov    -0x3fed3e8c(,%eax,4),%eax
c0105bda:	8b 00                	mov    (%eax),%eax
c0105bdc:	83 e0 01             	and    $0x1,%eax
c0105bdf:	85 c0                	test   %eax,%eax
c0105be1:	75 19                	jne    c0105bfc <check_swap+0x4b5>
c0105be3:	68 d8 b1 10 c0       	push   $0xc010b1d8
c0105be8:	68 02 af 10 c0       	push   $0xc010af02
c0105bed:	68 ff 00 00 00       	push   $0xff
c0105bf2:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105bf7:	e8 fc a7 ff ff       	call   c01003f8 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105bfc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105c00:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105c04:	0f 8e 2a ff ff ff    	jle    c0105b34 <check_swap+0x3ed>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0105c0a:	83 ec 0c             	sub    $0xc,%esp
c0105c0d:	68 f4 b1 10 c0       	push   $0xc010b1f4
c0105c12:	e8 7b a6 ff ff       	call   c0100292 <cprintf>
c0105c17:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0105c1a:	e8 10 fb ff ff       	call   c010572f <check_content_access>
c0105c1f:	89 45 b8             	mov    %eax,-0x48(%ebp)
     assert(ret==0);
c0105c22:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105c26:	74 19                	je     c0105c41 <check_swap+0x4fa>
c0105c28:	68 1a b2 10 c0       	push   $0xc010b21a
c0105c2d:	68 02 af 10 c0       	push   $0xc010af02
c0105c32:	68 04 01 00 00       	push   $0x104
c0105c37:	68 9c ae 10 c0       	push   $0xc010ae9c
c0105c3c:	e8 b7 a7 ff ff       	call   c01003f8 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105c41:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105c48:	eb 1c                	jmp    c0105c66 <check_swap+0x51f>
         free_pages(check_rp[i],1);
c0105c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c4d:	8b 04 85 c0 c0 12 c0 	mov    -0x3fed3f40(,%eax,4),%eax
c0105c54:	83 ec 08             	sub    $0x8,%esp
c0105c57:	6a 01                	push   $0x1
c0105c59:	50                   	push   %eax
c0105c5a:	e8 d4 13 00 00       	call   c0107033 <free_pages>
c0105c5f:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105c62:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105c66:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105c6a:	7e de                	jle    c0105c4a <check_swap+0x503>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0105c6c:	83 ec 0c             	sub    $0xc,%esp
c0105c6f:	ff 75 d8             	pushl  -0x28(%ebp)
c0105c72:	e8 ff e0 ff ff       	call   c0103d76 <mm_destroy>
c0105c77:	83 c4 10             	add    $0x10,%esp
         
     nr_free = nr_free_store;
c0105c7a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105c7d:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
     free_list = free_list_store;
c0105c82:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105c85:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105c88:	a3 84 c1 12 c0       	mov    %eax,0xc012c184
c0105c8d:	89 15 88 c1 12 c0    	mov    %edx,0xc012c188

     
     le = &free_list;
c0105c93:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0105c9a:	eb 1d                	jmp    c0105cb9 <check_swap+0x572>
         struct Page *p = le2page(le, page_link);
c0105c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c9f:	83 e8 0c             	sub    $0xc,%eax
c0105ca2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
         count --, total -= p->property;
c0105ca5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105ca9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105cac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105caf:	8b 40 08             	mov    0x8(%eax),%eax
c0105cb2:	29 c2                	sub    %eax,%edx
c0105cb4:	89 d0                	mov    %edx,%eax
c0105cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cbc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105cbf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105cc2:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0105cc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105cc8:	81 7d e8 84 c1 12 c0 	cmpl   $0xc012c184,-0x18(%ebp)
c0105ccf:	75 cb                	jne    c0105c9c <check_swap+0x555>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0105cd1:	83 ec 04             	sub    $0x4,%esp
c0105cd4:	ff 75 f0             	pushl  -0x10(%ebp)
c0105cd7:	ff 75 f4             	pushl  -0xc(%ebp)
c0105cda:	68 21 b2 10 c0       	push   $0xc010b221
c0105cdf:	e8 ae a5 ff ff       	call   c0100292 <cprintf>
c0105ce4:	83 c4 10             	add    $0x10,%esp
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0105ce7:	83 ec 0c             	sub    $0xc,%esp
c0105cea:	68 3b b2 10 c0       	push   $0xc010b23b
c0105cef:	e8 9e a5 ff ff       	call   c0100292 <cprintf>
c0105cf4:	83 c4 10             	add    $0x10,%esp
}
c0105cf7:	90                   	nop
c0105cf8:	c9                   	leave  
c0105cf9:	c3                   	ret    

c0105cfa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0105cfa:	55                   	push   %ebp
c0105cfb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0105cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d00:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0105d06:	29 d0                	sub    %edx,%eax
c0105d08:	c1 f8 05             	sar    $0x5,%eax
}
c0105d0b:	5d                   	pop    %ebp
c0105d0c:	c3                   	ret    

c0105d0d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0105d0d:	55                   	push   %ebp
c0105d0e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0105d10:	ff 75 08             	pushl  0x8(%ebp)
c0105d13:	e8 e2 ff ff ff       	call   c0105cfa <page2ppn>
c0105d18:	83 c4 04             	add    $0x4,%esp
c0105d1b:	c1 e0 0c             	shl    $0xc,%eax
}
c0105d1e:	c9                   	leave  
c0105d1f:	c3                   	ret    

c0105d20 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0105d20:	55                   	push   %ebp
c0105d21:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d26:	8b 00                	mov    (%eax),%eax
}
c0105d28:	5d                   	pop    %ebp
c0105d29:	c3                   	ret    

c0105d2a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0105d2a:	55                   	push   %ebp
c0105d2b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d30:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d33:	89 10                	mov    %edx,(%eax)
}
c0105d35:	90                   	nop
c0105d36:	5d                   	pop    %ebp
c0105d37:	c3                   	ret    

c0105d38 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0105d38:	55                   	push   %ebp
c0105d39:	89 e5                	mov    %esp,%ebp
c0105d3b:	83 ec 10             	sub    $0x10,%esp
c0105d3e:	c7 45 fc 84 c1 12 c0 	movl   $0xc012c184,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d48:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0105d4b:	89 50 04             	mov    %edx,0x4(%eax)
c0105d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d51:	8b 50 04             	mov    0x4(%eax),%edx
c0105d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d57:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0105d59:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0105d60:	00 00 00 
}
c0105d63:	90                   	nop
c0105d64:	c9                   	leave  
c0105d65:	c3                   	ret    

c0105d66 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0105d66:	55                   	push   %ebp
c0105d67:	89 e5                	mov    %esp,%ebp
c0105d69:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0105d6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d70:	75 16                	jne    c0105d88 <default_init_memmap+0x22>
c0105d72:	68 54 b2 10 c0       	push   $0xc010b254
c0105d77:	68 5a b2 10 c0       	push   $0xc010b25a
c0105d7c:	6a 6d                	push   $0x6d
c0105d7e:	68 6f b2 10 c0       	push   $0xc010b26f
c0105d83:	e8 70 a6 ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c0105d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105d8e:	eb 6c                	jmp    c0105dfc <default_init_memmap+0x96>
        assert(PageReserved(p));
c0105d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d93:	83 c0 04             	add    $0x4,%eax
c0105d96:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0105d9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105da3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105da6:	0f a3 10             	bt     %edx,(%eax)
c0105da9:	19 c0                	sbb    %eax,%eax
c0105dab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0105dae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105db2:	0f 95 c0             	setne  %al
c0105db5:	0f b6 c0             	movzbl %al,%eax
c0105db8:	85 c0                	test   %eax,%eax
c0105dba:	75 16                	jne    c0105dd2 <default_init_memmap+0x6c>
c0105dbc:	68 85 b2 10 c0       	push   $0xc010b285
c0105dc1:	68 5a b2 10 c0       	push   $0xc010b25a
c0105dc6:	6a 70                	push   $0x70
c0105dc8:	68 6f b2 10 c0       	push   $0xc010b26f
c0105dcd:	e8 26 a6 ff ff       	call   c01003f8 <__panic>
        p->flags = p->property = 0;
c0105dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0105ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ddf:	8b 50 08             	mov    0x8(%eax),%edx
c0105de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105de5:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0105de8:	83 ec 08             	sub    $0x8,%esp
c0105deb:	6a 00                	push   $0x0
c0105ded:	ff 75 f4             	pushl  -0xc(%ebp)
c0105df0:	e8 35 ff ff ff       	call   c0105d2a <set_page_ref>
c0105df5:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0105df8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dff:	c1 e0 05             	shl    $0x5,%eax
c0105e02:	89 c2                	mov    %eax,%edx
c0105e04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e07:	01 d0                	add    %edx,%eax
c0105e09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e0c:	75 82                	jne    c0105d90 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0105e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e11:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e14:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1a:	83 c0 04             	add    $0x4,%eax
c0105e1d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0105e24:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105e27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105e2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e2d:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105e30:	8b 15 8c c1 12 c0    	mov    0xc012c18c,%edx
c0105e36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e39:	01 d0                	add    %edx,%eax
c0105e3b:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
    list_add(&free_list, &(base->page_link));
c0105e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e43:	83 c0 0c             	add    $0xc,%eax
c0105e46:	c7 45 f0 84 c1 12 c0 	movl   $0xc012c184,-0x10(%ebp)
c0105e4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e53:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105e56:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e59:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105e5c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e5f:	8b 40 04             	mov    0x4(%eax),%eax
c0105e62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105e65:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0105e68:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e6b:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105e6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105e71:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105e74:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105e77:	89 10                	mov    %edx,(%eax)
c0105e79:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105e7c:	8b 10                	mov    (%eax),%edx
c0105e7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105e81:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105e84:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105e87:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105e8a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105e8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105e90:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105e93:	89 10                	mov    %edx,(%eax)
}
c0105e95:	90                   	nop
c0105e96:	c9                   	leave  
c0105e97:	c3                   	ret    

c0105e98 <default_alloc_pages>:

// LAB2 MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
c0105e98:	55                   	push   %ebp
c0105e99:	89 e5                	mov    %esp,%ebp
c0105e9b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0105e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ea2:	75 16                	jne    c0105eba <default_alloc_pages+0x22>
c0105ea4:	68 54 b2 10 c0       	push   $0xc010b254
c0105ea9:	68 5a b2 10 c0       	push   $0xc010b25a
c0105eae:	6a 7d                	push   $0x7d
c0105eb0:	68 6f b2 10 c0       	push   $0xc010b26f
c0105eb5:	e8 3e a5 ff ff       	call   c01003f8 <__panic>
    if (n > nr_free) {
c0105eba:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105ebf:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105ec2:	73 0a                	jae    c0105ece <default_alloc_pages+0x36>
        return NULL;
c0105ec4:	b8 00 00 00 00       	mov    $0x0,%eax
c0105ec9:	e9 41 01 00 00       	jmp    c010600f <default_alloc_pages+0x177>
    }
    struct Page *page = NULL;
c0105ece:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0105ed5:	c7 45 f0 84 c1 12 c0 	movl   $0xc012c184,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105edc:	eb 1c                	jmp    c0105efa <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c0105ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee1:	83 e8 0c             	sub    $0xc,%eax
c0105ee4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0105ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eea:	8b 40 08             	mov    0x8(%eax),%eax
c0105eed:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105ef0:	72 08                	jb     c0105efa <default_alloc_pages+0x62>
            page = p;
c0105ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0105ef8:	eb 18                	jmp    c0105f12 <default_alloc_pages+0x7a>
c0105efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105efd:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105f00:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105f03:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0105f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f09:	81 7d f0 84 c1 12 c0 	cmpl   $0xc012c184,-0x10(%ebp)
c0105f10:	75 cc                	jne    c0105ede <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0105f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105f16:	0f 84 f0 00 00 00    	je     c010600c <default_alloc_pages+0x174>
c0105f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105f22:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f25:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
c0105f28:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
c0105f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f2e:	83 c0 0c             	add    $0xc,%eax
c0105f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f37:	8b 40 04             	mov    0x4(%eax),%eax
c0105f3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105f3d:	8b 12                	mov    (%edx),%edx
c0105f3f:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f42:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105f45:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105f48:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105f4b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105f4e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105f51:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105f54:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0105f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f59:	8b 40 08             	mov    0x8(%eax),%eax
c0105f5c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105f5f:	0f 86 81 00 00 00    	jbe    c0105fe6 <default_alloc_pages+0x14e>
            struct Page *p = page + n;                      // split the allocated page
c0105f65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f68:	c1 e0 05             	shl    $0x5,%eax
c0105f6b:	89 c2                	mov    %eax,%edx
c0105f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f70:	01 d0                	add    %edx,%eax
c0105f72:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
c0105f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f78:	8b 40 08             	mov    0x8(%eax),%eax
c0105f7b:	2b 45 08             	sub    0x8(%ebp),%eax
c0105f7e:	89 c2                	mov    %eax,%edx
c0105f80:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105f83:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
c0105f86:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105f89:	83 c0 04             	add    $0x4,%eax
c0105f8c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105f93:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105f96:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105f99:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105f9c:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
c0105f9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105fa2:	8d 50 0c             	lea    0xc(%eax),%edx
c0105fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105fab:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105fae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fb1:	8b 00                	mov    (%eax),%eax
c0105fb3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105fb6:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105fb9:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0105fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fbf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105fc2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105fc5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105fc8:	89 10                	mov    %edx,(%eax)
c0105fca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105fcd:	8b 10                	mov    (%eax),%edx
c0105fcf:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105fd2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105fd5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105fd8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105fdb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105fde:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105fe1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105fe4:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c0105fe6:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0105feb:	2b 45 08             	sub    0x8(%ebp),%eax
c0105fee:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
        ClearPageProperty(page);    // mark as "not head page"
c0105ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ff6:	83 c0 04             	add    $0x4,%eax
c0105ff9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0106000:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106003:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106006:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106009:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010600c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010600f:	c9                   	leave  
c0106010:	c3                   	ret    

c0106011 <default_free_pages>:

// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
c0106011:	55                   	push   %ebp
c0106012:	89 e5                	mov    %esp,%ebp
c0106014:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010601a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010601e:	75 19                	jne    c0106039 <default_free_pages+0x28>
c0106020:	68 54 b2 10 c0       	push   $0xc010b254
c0106025:	68 5a b2 10 c0       	push   $0xc010b25a
c010602a:	68 9c 00 00 00       	push   $0x9c
c010602f:	68 6f b2 10 c0       	push   $0xc010b26f
c0106034:	e8 bf a3 ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c0106039:	8b 45 08             	mov    0x8(%ebp),%eax
c010603c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010603f:	e9 8f 00 00 00       	jmp    c01060d3 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c0106044:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106047:	83 c0 04             	add    $0x4,%eax
c010604a:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0106051:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106054:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106057:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010605a:	0f a3 10             	bt     %edx,(%eax)
c010605d:	19 c0                	sbb    %eax,%eax
c010605f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0106062:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0106066:	0f 95 c0             	setne  %al
c0106069:	0f b6 c0             	movzbl %al,%eax
c010606c:	85 c0                	test   %eax,%eax
c010606e:	75 2c                	jne    c010609c <default_free_pages+0x8b>
c0106070:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106073:	83 c0 04             	add    $0x4,%eax
c0106076:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c010607d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106080:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106083:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106086:	0f a3 10             	bt     %edx,(%eax)
c0106089:	19 c0                	sbb    %eax,%eax
c010608b:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
c010608e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
c0106092:	0f 95 c0             	setne  %al
c0106095:	0f b6 c0             	movzbl %al,%eax
c0106098:	85 c0                	test   %eax,%eax
c010609a:	74 19                	je     c01060b5 <default_free_pages+0xa4>
c010609c:	68 98 b2 10 c0       	push   $0xc010b298
c01060a1:	68 5a b2 10 c0       	push   $0xc010b25a
c01060a6:	68 9f 00 00 00       	push   $0x9f
c01060ab:	68 6f b2 10 c0       	push   $0xc010b26f
c01060b0:	e8 43 a3 ff ff       	call   c01003f8 <__panic>
        p->flags = 0;
c01060b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
c01060bf:	83 ec 08             	sub    $0x8,%esp
c01060c2:	6a 00                	push   $0x0
c01060c4:	ff 75 f4             	pushl  -0xc(%ebp)
c01060c7:	e8 5e fc ff ff       	call   c0105d2a <set_page_ref>
c01060cc:	83 c4 10             	add    $0x10,%esp
// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01060cf:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01060d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060d6:	c1 e0 05             	shl    $0x5,%eax
c01060d9:	89 c2                	mov    %eax,%edx
c01060db:	8b 45 08             	mov    0x8(%ebp),%eax
c01060de:	01 d0                	add    %edx,%eax
c01060e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01060e3:	0f 85 5b ff ff ff    	jne    c0106044 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
c01060e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01060ef:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01060f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01060f5:	83 c0 04             	add    $0x4,%eax
c01060f8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01060ff:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106102:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106105:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106108:	0f ab 10             	bts    %edx,(%eax)
c010610b:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106112:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106115:	8b 40 04             	mov    0x4(%eax),%eax
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
c0106118:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010611b:	e9 0e 01 00 00       	jmp    c010622e <default_free_pages+0x21d>
        p = le2page(le, page_link);
c0106120:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106123:	83 e8 0c             	sub    $0xc,%eax
c0106126:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106129:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010612c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010612f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106132:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0106135:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
c0106138:	8b 45 08             	mov    0x8(%ebp),%eax
c010613b:	8b 40 08             	mov    0x8(%eax),%eax
c010613e:	c1 e0 05             	shl    $0x5,%eax
c0106141:	89 c2                	mov    %eax,%edx
c0106143:	8b 45 08             	mov    0x8(%ebp),%eax
c0106146:	01 d0                	add    %edx,%eax
c0106148:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010614b:	75 64                	jne    c01061b1 <default_free_pages+0x1a0>
            base->property += p->property;
c010614d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106150:	8b 50 08             	mov    0x8(%eax),%edx
c0106153:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106156:	8b 40 08             	mov    0x8(%eax),%eax
c0106159:	01 c2                	add    %eax,%edx
c010615b:	8b 45 08             	mov    0x8(%ebp),%eax
c010615e:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
c0106161:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106164:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c010616b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010616e:	83 c0 04             	add    $0x4,%eax
c0106171:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0106178:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010617b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010617e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106181:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0106184:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106187:	83 c0 0c             	add    $0xc,%eax
c010618a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010618d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106190:	8b 40 04             	mov    0x4(%eax),%eax
c0106193:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106196:	8b 12                	mov    (%edx),%edx
c0106198:	89 55 a8             	mov    %edx,-0x58(%ebp)
c010619b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010619e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01061a1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01061a4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01061a7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01061aa:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01061ad:	89 10                	mov    %edx,(%eax)
c01061af:	eb 7d                	jmp    c010622e <default_free_pages+0x21d>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
c01061b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061b4:	8b 40 08             	mov    0x8(%eax),%eax
c01061b7:	c1 e0 05             	shl    $0x5,%eax
c01061ba:	89 c2                	mov    %eax,%edx
c01061bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061bf:	01 d0                	add    %edx,%eax
c01061c1:	3b 45 08             	cmp    0x8(%ebp),%eax
c01061c4:	75 68                	jne    c010622e <default_free_pages+0x21d>
            p->property += base->property;
c01061c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061c9:	8b 50 08             	mov    0x8(%eax),%edx
c01061cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01061cf:	8b 40 08             	mov    0x8(%eax),%eax
c01061d2:	01 c2                	add    %eax,%edx
c01061d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061d7:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
c01061da:	8b 45 08             	mov    0x8(%ebp),%eax
c01061dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
c01061e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01061e7:	83 c0 04             	add    $0x4,%eax
c01061ea:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c01061f1:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01061f4:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01061f7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01061fa:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01061fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106200:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0106203:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106206:	83 c0 0c             	add    $0xc,%eax
c0106209:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010620c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010620f:	8b 40 04             	mov    0x4(%eax),%eax
c0106212:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106215:	8b 12                	mov    (%edx),%edx
c0106217:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010621a:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010621d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106220:	8b 55 98             	mov    -0x68(%ebp),%edx
c0106223:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106226:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106229:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010622c:	89 10                	mov    %edx,(%eax)
    }
    base->property = n;
    SetPageProperty(base);
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c010622e:	81 7d f0 84 c1 12 c0 	cmpl   $0xc012c184,-0x10(%ebp)
c0106235:	0f 85 e5 fe ff ff    	jne    c0106120 <default_free_pages+0x10f>
c010623b:	c7 45 d0 84 c1 12 c0 	movl   $0xc012c184,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106242:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106245:	8b 40 04             	mov    0x4(%eax),%eax
            base = p;
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
c0106248:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010624b:	eb 20                	jmp    c010626d <default_free_pages+0x25c>
        p = le2page(le, page_link);
c010624d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106250:	83 e8 0c             	sub    $0xc,%eax
c0106253:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
c0106256:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106259:	3b 45 08             	cmp    0x8(%ebp),%eax
c010625c:	77 1a                	ja     c0106278 <default_free_pages+0x267>
c010625e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106261:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106264:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106267:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c010626a:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
c010626d:	81 7d f0 84 c1 12 c0 	cmpl   $0xc012c184,-0x10(%ebp)
c0106274:	75 d7                	jne    c010624d <default_free_pages+0x23c>
c0106276:	eb 01                	jmp    c0106279 <default_free_pages+0x268>
        p = le2page(le, page_link);
        if (p > base) {
            break;
c0106278:	90                   	nop
        }
        le = list_next(le);
    }
    nr_free += n;
c0106279:	8b 15 8c c1 12 c0    	mov    0xc012c18c,%edx
c010627f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106282:	01 d0                	add    %edx,%eax
c0106284:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c
    list_add_before(le, &(base->page_link)); 
c0106289:	8b 45 08             	mov    0x8(%ebp),%eax
c010628c:	8d 50 0c             	lea    0xc(%eax),%edx
c010628f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106292:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0106295:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0106298:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010629b:	8b 00                	mov    (%eax),%eax
c010629d:	8b 55 90             	mov    -0x70(%ebp),%edx
c01062a0:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01062a3:	89 45 88             	mov    %eax,-0x78(%ebp)
c01062a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01062a9:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01062ac:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01062af:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01062b2:	89 10                	mov    %edx,(%eax)
c01062b4:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01062b7:	8b 10                	mov    (%eax),%edx
c01062b9:	8b 45 88             	mov    -0x78(%ebp),%eax
c01062bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01062bf:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01062c2:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01062c5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01062c8:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01062cb:	8b 55 88             	mov    -0x78(%ebp),%edx
c01062ce:	89 10                	mov    %edx,(%eax)
}
c01062d0:	90                   	nop
c01062d1:	c9                   	leave  
c01062d2:	c3                   	ret    

c01062d3 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01062d3:	55                   	push   %ebp
c01062d4:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01062d6:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
}
c01062db:	5d                   	pop    %ebp
c01062dc:	c3                   	ret    

c01062dd <basic_check>:

static void
basic_check(void) {
c01062dd:	55                   	push   %ebp
c01062de:	89 e5                	mov    %esp,%ebp
c01062e0:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01062e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01062ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01062f6:	83 ec 0c             	sub    $0xc,%esp
c01062f9:	6a 01                	push   $0x1
c01062fb:	e8 c7 0c 00 00       	call   c0106fc7 <alloc_pages>
c0106300:	83 c4 10             	add    $0x10,%esp
c0106303:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106306:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010630a:	75 19                	jne    c0106325 <basic_check+0x48>
c010630c:	68 bd b2 10 c0       	push   $0xc010b2bd
c0106311:	68 5a b2 10 c0       	push   $0xc010b25a
c0106316:	68 d0 00 00 00       	push   $0xd0
c010631b:	68 6f b2 10 c0       	push   $0xc010b26f
c0106320:	e8 d3 a0 ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0106325:	83 ec 0c             	sub    $0xc,%esp
c0106328:	6a 01                	push   $0x1
c010632a:	e8 98 0c 00 00       	call   c0106fc7 <alloc_pages>
c010632f:	83 c4 10             	add    $0x10,%esp
c0106332:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106335:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106339:	75 19                	jne    c0106354 <basic_check+0x77>
c010633b:	68 d9 b2 10 c0       	push   $0xc010b2d9
c0106340:	68 5a b2 10 c0       	push   $0xc010b25a
c0106345:	68 d1 00 00 00       	push   $0xd1
c010634a:	68 6f b2 10 c0       	push   $0xc010b26f
c010634f:	e8 a4 a0 ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0106354:	83 ec 0c             	sub    $0xc,%esp
c0106357:	6a 01                	push   $0x1
c0106359:	e8 69 0c 00 00       	call   c0106fc7 <alloc_pages>
c010635e:	83 c4 10             	add    $0x10,%esp
c0106361:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106368:	75 19                	jne    c0106383 <basic_check+0xa6>
c010636a:	68 f5 b2 10 c0       	push   $0xc010b2f5
c010636f:	68 5a b2 10 c0       	push   $0xc010b25a
c0106374:	68 d2 00 00 00       	push   $0xd2
c0106379:	68 6f b2 10 c0       	push   $0xc010b26f
c010637e:	e8 75 a0 ff ff       	call   c01003f8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0106383:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106386:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106389:	74 10                	je     c010639b <basic_check+0xbe>
c010638b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010638e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106391:	74 08                	je     c010639b <basic_check+0xbe>
c0106393:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106396:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106399:	75 19                	jne    c01063b4 <basic_check+0xd7>
c010639b:	68 14 b3 10 c0       	push   $0xc010b314
c01063a0:	68 5a b2 10 c0       	push   $0xc010b25a
c01063a5:	68 d4 00 00 00       	push   $0xd4
c01063aa:	68 6f b2 10 c0       	push   $0xc010b26f
c01063af:	e8 44 a0 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01063b4:	83 ec 0c             	sub    $0xc,%esp
c01063b7:	ff 75 ec             	pushl  -0x14(%ebp)
c01063ba:	e8 61 f9 ff ff       	call   c0105d20 <page_ref>
c01063bf:	83 c4 10             	add    $0x10,%esp
c01063c2:	85 c0                	test   %eax,%eax
c01063c4:	75 24                	jne    c01063ea <basic_check+0x10d>
c01063c6:	83 ec 0c             	sub    $0xc,%esp
c01063c9:	ff 75 f0             	pushl  -0x10(%ebp)
c01063cc:	e8 4f f9 ff ff       	call   c0105d20 <page_ref>
c01063d1:	83 c4 10             	add    $0x10,%esp
c01063d4:	85 c0                	test   %eax,%eax
c01063d6:	75 12                	jne    c01063ea <basic_check+0x10d>
c01063d8:	83 ec 0c             	sub    $0xc,%esp
c01063db:	ff 75 f4             	pushl  -0xc(%ebp)
c01063de:	e8 3d f9 ff ff       	call   c0105d20 <page_ref>
c01063e3:	83 c4 10             	add    $0x10,%esp
c01063e6:	85 c0                	test   %eax,%eax
c01063e8:	74 19                	je     c0106403 <basic_check+0x126>
c01063ea:	68 38 b3 10 c0       	push   $0xc010b338
c01063ef:	68 5a b2 10 c0       	push   $0xc010b25a
c01063f4:	68 d5 00 00 00       	push   $0xd5
c01063f9:	68 6f b2 10 c0       	push   $0xc010b26f
c01063fe:	e8 f5 9f ff ff       	call   c01003f8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0106403:	83 ec 0c             	sub    $0xc,%esp
c0106406:	ff 75 ec             	pushl  -0x14(%ebp)
c0106409:	e8 ff f8 ff ff       	call   c0105d0d <page2pa>
c010640e:	83 c4 10             	add    $0x10,%esp
c0106411:	89 c2                	mov    %eax,%edx
c0106413:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0106418:	c1 e0 0c             	shl    $0xc,%eax
c010641b:	39 c2                	cmp    %eax,%edx
c010641d:	72 19                	jb     c0106438 <basic_check+0x15b>
c010641f:	68 74 b3 10 c0       	push   $0xc010b374
c0106424:	68 5a b2 10 c0       	push   $0xc010b25a
c0106429:	68 d7 00 00 00       	push   $0xd7
c010642e:	68 6f b2 10 c0       	push   $0xc010b26f
c0106433:	e8 c0 9f ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0106438:	83 ec 0c             	sub    $0xc,%esp
c010643b:	ff 75 f0             	pushl  -0x10(%ebp)
c010643e:	e8 ca f8 ff ff       	call   c0105d0d <page2pa>
c0106443:	83 c4 10             	add    $0x10,%esp
c0106446:	89 c2                	mov    %eax,%edx
c0106448:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010644d:	c1 e0 0c             	shl    $0xc,%eax
c0106450:	39 c2                	cmp    %eax,%edx
c0106452:	72 19                	jb     c010646d <basic_check+0x190>
c0106454:	68 91 b3 10 c0       	push   $0xc010b391
c0106459:	68 5a b2 10 c0       	push   $0xc010b25a
c010645e:	68 d8 00 00 00       	push   $0xd8
c0106463:	68 6f b2 10 c0       	push   $0xc010b26f
c0106468:	e8 8b 9f ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010646d:	83 ec 0c             	sub    $0xc,%esp
c0106470:	ff 75 f4             	pushl  -0xc(%ebp)
c0106473:	e8 95 f8 ff ff       	call   c0105d0d <page2pa>
c0106478:	83 c4 10             	add    $0x10,%esp
c010647b:	89 c2                	mov    %eax,%edx
c010647d:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0106482:	c1 e0 0c             	shl    $0xc,%eax
c0106485:	39 c2                	cmp    %eax,%edx
c0106487:	72 19                	jb     c01064a2 <basic_check+0x1c5>
c0106489:	68 ae b3 10 c0       	push   $0xc010b3ae
c010648e:	68 5a b2 10 c0       	push   $0xc010b25a
c0106493:	68 d9 00 00 00       	push   $0xd9
c0106498:	68 6f b2 10 c0       	push   $0xc010b26f
c010649d:	e8 56 9f ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c01064a2:	a1 84 c1 12 c0       	mov    0xc012c184,%eax
c01064a7:	8b 15 88 c1 12 c0    	mov    0xc012c188,%edx
c01064ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01064b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01064b3:	c7 45 e4 84 c1 12 c0 	movl   $0xc012c184,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01064ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01064c0:	89 50 04             	mov    %edx,0x4(%eax)
c01064c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064c6:	8b 50 04             	mov    0x4(%eax),%edx
c01064c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064cc:	89 10                	mov    %edx,(%eax)
c01064ce:	c7 45 d8 84 c1 12 c0 	movl   $0xc012c184,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01064d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01064d8:	8b 40 04             	mov    0x4(%eax),%eax
c01064db:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01064de:	0f 94 c0             	sete   %al
c01064e1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01064e4:	85 c0                	test   %eax,%eax
c01064e6:	75 19                	jne    c0106501 <basic_check+0x224>
c01064e8:	68 cb b3 10 c0       	push   $0xc010b3cb
c01064ed:	68 5a b2 10 c0       	push   $0xc010b25a
c01064f2:	68 dd 00 00 00       	push   $0xdd
c01064f7:	68 6f b2 10 c0       	push   $0xc010b26f
c01064fc:	e8 f7 9e ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c0106501:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0106506:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0106509:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0106510:	00 00 00 

    assert(alloc_page() == NULL);
c0106513:	83 ec 0c             	sub    $0xc,%esp
c0106516:	6a 01                	push   $0x1
c0106518:	e8 aa 0a 00 00       	call   c0106fc7 <alloc_pages>
c010651d:	83 c4 10             	add    $0x10,%esp
c0106520:	85 c0                	test   %eax,%eax
c0106522:	74 19                	je     c010653d <basic_check+0x260>
c0106524:	68 e2 b3 10 c0       	push   $0xc010b3e2
c0106529:	68 5a b2 10 c0       	push   $0xc010b25a
c010652e:	68 e2 00 00 00       	push   $0xe2
c0106533:	68 6f b2 10 c0       	push   $0xc010b26f
c0106538:	e8 bb 9e ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c010653d:	83 ec 08             	sub    $0x8,%esp
c0106540:	6a 01                	push   $0x1
c0106542:	ff 75 ec             	pushl  -0x14(%ebp)
c0106545:	e8 e9 0a 00 00       	call   c0107033 <free_pages>
c010654a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010654d:	83 ec 08             	sub    $0x8,%esp
c0106550:	6a 01                	push   $0x1
c0106552:	ff 75 f0             	pushl  -0x10(%ebp)
c0106555:	e8 d9 0a 00 00       	call   c0107033 <free_pages>
c010655a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010655d:	83 ec 08             	sub    $0x8,%esp
c0106560:	6a 01                	push   $0x1
c0106562:	ff 75 f4             	pushl  -0xc(%ebp)
c0106565:	e8 c9 0a 00 00       	call   c0107033 <free_pages>
c010656a:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010656d:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0106572:	83 f8 03             	cmp    $0x3,%eax
c0106575:	74 19                	je     c0106590 <basic_check+0x2b3>
c0106577:	68 f7 b3 10 c0       	push   $0xc010b3f7
c010657c:	68 5a b2 10 c0       	push   $0xc010b25a
c0106581:	68 e7 00 00 00       	push   $0xe7
c0106586:	68 6f b2 10 c0       	push   $0xc010b26f
c010658b:	e8 68 9e ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0106590:	83 ec 0c             	sub    $0xc,%esp
c0106593:	6a 01                	push   $0x1
c0106595:	e8 2d 0a 00 00       	call   c0106fc7 <alloc_pages>
c010659a:	83 c4 10             	add    $0x10,%esp
c010659d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01065a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01065a4:	75 19                	jne    c01065bf <basic_check+0x2e2>
c01065a6:	68 bd b2 10 c0       	push   $0xc010b2bd
c01065ab:	68 5a b2 10 c0       	push   $0xc010b25a
c01065b0:	68 e9 00 00 00       	push   $0xe9
c01065b5:	68 6f b2 10 c0       	push   $0xc010b26f
c01065ba:	e8 39 9e ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01065bf:	83 ec 0c             	sub    $0xc,%esp
c01065c2:	6a 01                	push   $0x1
c01065c4:	e8 fe 09 00 00       	call   c0106fc7 <alloc_pages>
c01065c9:	83 c4 10             	add    $0x10,%esp
c01065cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01065d3:	75 19                	jne    c01065ee <basic_check+0x311>
c01065d5:	68 d9 b2 10 c0       	push   $0xc010b2d9
c01065da:	68 5a b2 10 c0       	push   $0xc010b25a
c01065df:	68 ea 00 00 00       	push   $0xea
c01065e4:	68 6f b2 10 c0       	push   $0xc010b26f
c01065e9:	e8 0a 9e ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01065ee:	83 ec 0c             	sub    $0xc,%esp
c01065f1:	6a 01                	push   $0x1
c01065f3:	e8 cf 09 00 00       	call   c0106fc7 <alloc_pages>
c01065f8:	83 c4 10             	add    $0x10,%esp
c01065fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01065fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106602:	75 19                	jne    c010661d <basic_check+0x340>
c0106604:	68 f5 b2 10 c0       	push   $0xc010b2f5
c0106609:	68 5a b2 10 c0       	push   $0xc010b25a
c010660e:	68 eb 00 00 00       	push   $0xeb
c0106613:	68 6f b2 10 c0       	push   $0xc010b26f
c0106618:	e8 db 9d ff ff       	call   c01003f8 <__panic>

    assert(alloc_page() == NULL);
c010661d:	83 ec 0c             	sub    $0xc,%esp
c0106620:	6a 01                	push   $0x1
c0106622:	e8 a0 09 00 00       	call   c0106fc7 <alloc_pages>
c0106627:	83 c4 10             	add    $0x10,%esp
c010662a:	85 c0                	test   %eax,%eax
c010662c:	74 19                	je     c0106647 <basic_check+0x36a>
c010662e:	68 e2 b3 10 c0       	push   $0xc010b3e2
c0106633:	68 5a b2 10 c0       	push   $0xc010b25a
c0106638:	68 ed 00 00 00       	push   $0xed
c010663d:	68 6f b2 10 c0       	push   $0xc010b26f
c0106642:	e8 b1 9d ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c0106647:	83 ec 08             	sub    $0x8,%esp
c010664a:	6a 01                	push   $0x1
c010664c:	ff 75 ec             	pushl  -0x14(%ebp)
c010664f:	e8 df 09 00 00       	call   c0107033 <free_pages>
c0106654:	83 c4 10             	add    $0x10,%esp
c0106657:	c7 45 e8 84 c1 12 c0 	movl   $0xc012c184,-0x18(%ebp)
c010665e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106661:	8b 40 04             	mov    0x4(%eax),%eax
c0106664:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106667:	0f 94 c0             	sete   %al
c010666a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010666d:	85 c0                	test   %eax,%eax
c010666f:	74 19                	je     c010668a <basic_check+0x3ad>
c0106671:	68 04 b4 10 c0       	push   $0xc010b404
c0106676:	68 5a b2 10 c0       	push   $0xc010b25a
c010667b:	68 f0 00 00 00       	push   $0xf0
c0106680:	68 6f b2 10 c0       	push   $0xc010b26f
c0106685:	e8 6e 9d ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010668a:	83 ec 0c             	sub    $0xc,%esp
c010668d:	6a 01                	push   $0x1
c010668f:	e8 33 09 00 00       	call   c0106fc7 <alloc_pages>
c0106694:	83 c4 10             	add    $0x10,%esp
c0106697:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010669a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010669d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01066a0:	74 19                	je     c01066bb <basic_check+0x3de>
c01066a2:	68 1c b4 10 c0       	push   $0xc010b41c
c01066a7:	68 5a b2 10 c0       	push   $0xc010b25a
c01066ac:	68 f3 00 00 00       	push   $0xf3
c01066b1:	68 6f b2 10 c0       	push   $0xc010b26f
c01066b6:	e8 3d 9d ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01066bb:	83 ec 0c             	sub    $0xc,%esp
c01066be:	6a 01                	push   $0x1
c01066c0:	e8 02 09 00 00       	call   c0106fc7 <alloc_pages>
c01066c5:	83 c4 10             	add    $0x10,%esp
c01066c8:	85 c0                	test   %eax,%eax
c01066ca:	74 19                	je     c01066e5 <basic_check+0x408>
c01066cc:	68 e2 b3 10 c0       	push   $0xc010b3e2
c01066d1:	68 5a b2 10 c0       	push   $0xc010b25a
c01066d6:	68 f4 00 00 00       	push   $0xf4
c01066db:	68 6f b2 10 c0       	push   $0xc010b26f
c01066e0:	e8 13 9d ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c01066e5:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c01066ea:	85 c0                	test   %eax,%eax
c01066ec:	74 19                	je     c0106707 <basic_check+0x42a>
c01066ee:	68 35 b4 10 c0       	push   $0xc010b435
c01066f3:	68 5a b2 10 c0       	push   $0xc010b25a
c01066f8:	68 f6 00 00 00       	push   $0xf6
c01066fd:	68 6f b2 10 c0       	push   $0xc010b26f
c0106702:	e8 f1 9c ff ff       	call   c01003f8 <__panic>
    free_list = free_list_store;
c0106707:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010670a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010670d:	a3 84 c1 12 c0       	mov    %eax,0xc012c184
c0106712:	89 15 88 c1 12 c0    	mov    %edx,0xc012c188
    nr_free = nr_free_store;
c0106718:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010671b:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c

    free_page(p);
c0106720:	83 ec 08             	sub    $0x8,%esp
c0106723:	6a 01                	push   $0x1
c0106725:	ff 75 dc             	pushl  -0x24(%ebp)
c0106728:	e8 06 09 00 00       	call   c0107033 <free_pages>
c010672d:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0106730:	83 ec 08             	sub    $0x8,%esp
c0106733:	6a 01                	push   $0x1
c0106735:	ff 75 f0             	pushl  -0x10(%ebp)
c0106738:	e8 f6 08 00 00       	call   c0107033 <free_pages>
c010673d:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0106740:	83 ec 08             	sub    $0x8,%esp
c0106743:	6a 01                	push   $0x1
c0106745:	ff 75 f4             	pushl  -0xc(%ebp)
c0106748:	e8 e6 08 00 00       	call   c0107033 <free_pages>
c010674d:	83 c4 10             	add    $0x10,%esp
}
c0106750:	90                   	nop
c0106751:	c9                   	leave  
c0106752:	c3                   	ret    

c0106753 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0106753:	55                   	push   %ebp
c0106754:	89 e5                	mov    %esp,%ebp
c0106756:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c010675c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010676a:	c7 45 ec 84 c1 12 c0 	movl   $0xc012c184,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106771:	eb 60                	jmp    c01067d3 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0106773:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106776:	83 e8 0c             	sub    $0xc,%eax
c0106779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c010677c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010677f:	83 c0 04             	add    $0x4,%eax
c0106782:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0106789:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010678c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010678f:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0106792:	0f a3 10             	bt     %edx,(%eax)
c0106795:	19 c0                	sbb    %eax,%eax
c0106797:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c010679a:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c010679e:	0f 95 c0             	setne  %al
c01067a1:	0f b6 c0             	movzbl %al,%eax
c01067a4:	85 c0                	test   %eax,%eax
c01067a6:	75 19                	jne    c01067c1 <default_check+0x6e>
c01067a8:	68 42 b4 10 c0       	push   $0xc010b442
c01067ad:	68 5a b2 10 c0       	push   $0xc010b25a
c01067b2:	68 07 01 00 00       	push   $0x107
c01067b7:	68 6f b2 10 c0       	push   $0xc010b26f
c01067bc:	e8 37 9c ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c01067c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01067c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067c8:	8b 50 08             	mov    0x8(%eax),%edx
c01067cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067ce:	01 d0                	add    %edx,%eax
c01067d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01067d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01067d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067dc:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01067df:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01067e2:	81 7d ec 84 c1 12 c0 	cmpl   $0xc012c184,-0x14(%ebp)
c01067e9:	75 88                	jne    c0106773 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01067eb:	e8 78 08 00 00       	call   c0107068 <nr_free_pages>
c01067f0:	89 c2                	mov    %eax,%edx
c01067f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067f5:	39 c2                	cmp    %eax,%edx
c01067f7:	74 19                	je     c0106812 <default_check+0xbf>
c01067f9:	68 52 b4 10 c0       	push   $0xc010b452
c01067fe:	68 5a b2 10 c0       	push   $0xc010b25a
c0106803:	68 0a 01 00 00       	push   $0x10a
c0106808:	68 6f b2 10 c0       	push   $0xc010b26f
c010680d:	e8 e6 9b ff ff       	call   c01003f8 <__panic>

    basic_check();
c0106812:	e8 c6 fa ff ff       	call   c01062dd <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0106817:	83 ec 0c             	sub    $0xc,%esp
c010681a:	6a 05                	push   $0x5
c010681c:	e8 a6 07 00 00       	call   c0106fc7 <alloc_pages>
c0106821:	83 c4 10             	add    $0x10,%esp
c0106824:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0106827:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010682b:	75 19                	jne    c0106846 <default_check+0xf3>
c010682d:	68 6b b4 10 c0       	push   $0xc010b46b
c0106832:	68 5a b2 10 c0       	push   $0xc010b25a
c0106837:	68 0f 01 00 00       	push   $0x10f
c010683c:	68 6f b2 10 c0       	push   $0xc010b26f
c0106841:	e8 b2 9b ff ff       	call   c01003f8 <__panic>
    assert(!PageProperty(p0));
c0106846:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106849:	83 c0 04             	add    $0x4,%eax
c010684c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0106853:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106856:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106859:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010685c:	0f a3 10             	bt     %edx,(%eax)
c010685f:	19 c0                	sbb    %eax,%eax
c0106861:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0106864:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0106868:	0f 95 c0             	setne  %al
c010686b:	0f b6 c0             	movzbl %al,%eax
c010686e:	85 c0                	test   %eax,%eax
c0106870:	74 19                	je     c010688b <default_check+0x138>
c0106872:	68 76 b4 10 c0       	push   $0xc010b476
c0106877:	68 5a b2 10 c0       	push   $0xc010b25a
c010687c:	68 10 01 00 00       	push   $0x110
c0106881:	68 6f b2 10 c0       	push   $0xc010b26f
c0106886:	e8 6d 9b ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c010688b:	a1 84 c1 12 c0       	mov    0xc012c184,%eax
c0106890:	8b 15 88 c1 12 c0    	mov    0xc012c188,%edx
c0106896:	89 45 80             	mov    %eax,-0x80(%ebp)
c0106899:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010689c:	c7 45 d0 84 c1 12 c0 	movl   $0xc012c184,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01068a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068a6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01068a9:	89 50 04             	mov    %edx,0x4(%eax)
c01068ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068af:	8b 50 04             	mov    0x4(%eax),%edx
c01068b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068b5:	89 10                	mov    %edx,(%eax)
c01068b7:	c7 45 d8 84 c1 12 c0 	movl   $0xc012c184,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01068be:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01068c1:	8b 40 04             	mov    0x4(%eax),%eax
c01068c4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01068c7:	0f 94 c0             	sete   %al
c01068ca:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01068cd:	85 c0                	test   %eax,%eax
c01068cf:	75 19                	jne    c01068ea <default_check+0x197>
c01068d1:	68 cb b3 10 c0       	push   $0xc010b3cb
c01068d6:	68 5a b2 10 c0       	push   $0xc010b25a
c01068db:	68 14 01 00 00       	push   $0x114
c01068e0:	68 6f b2 10 c0       	push   $0xc010b26f
c01068e5:	e8 0e 9b ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01068ea:	83 ec 0c             	sub    $0xc,%esp
c01068ed:	6a 01                	push   $0x1
c01068ef:	e8 d3 06 00 00       	call   c0106fc7 <alloc_pages>
c01068f4:	83 c4 10             	add    $0x10,%esp
c01068f7:	85 c0                	test   %eax,%eax
c01068f9:	74 19                	je     c0106914 <default_check+0x1c1>
c01068fb:	68 e2 b3 10 c0       	push   $0xc010b3e2
c0106900:	68 5a b2 10 c0       	push   $0xc010b25a
c0106905:	68 15 01 00 00       	push   $0x115
c010690a:	68 6f b2 10 c0       	push   $0xc010b26f
c010690f:	e8 e4 9a ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c0106914:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0106919:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c010691c:	c7 05 8c c1 12 c0 00 	movl   $0x0,0xc012c18c
c0106923:	00 00 00 

    free_pages(p0 + 2, 3);
c0106926:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106929:	83 c0 40             	add    $0x40,%eax
c010692c:	83 ec 08             	sub    $0x8,%esp
c010692f:	6a 03                	push   $0x3
c0106931:	50                   	push   %eax
c0106932:	e8 fc 06 00 00       	call   c0107033 <free_pages>
c0106937:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c010693a:	83 ec 0c             	sub    $0xc,%esp
c010693d:	6a 04                	push   $0x4
c010693f:	e8 83 06 00 00       	call   c0106fc7 <alloc_pages>
c0106944:	83 c4 10             	add    $0x10,%esp
c0106947:	85 c0                	test   %eax,%eax
c0106949:	74 19                	je     c0106964 <default_check+0x211>
c010694b:	68 88 b4 10 c0       	push   $0xc010b488
c0106950:	68 5a b2 10 c0       	push   $0xc010b25a
c0106955:	68 1b 01 00 00       	push   $0x11b
c010695a:	68 6f b2 10 c0       	push   $0xc010b26f
c010695f:	e8 94 9a ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0106964:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106967:	83 c0 40             	add    $0x40,%eax
c010696a:	83 c0 04             	add    $0x4,%eax
c010696d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0106974:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106977:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010697a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010697d:	0f a3 10             	bt     %edx,(%eax)
c0106980:	19 c0                	sbb    %eax,%eax
c0106982:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0106985:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0106989:	0f 95 c0             	setne  %al
c010698c:	0f b6 c0             	movzbl %al,%eax
c010698f:	85 c0                	test   %eax,%eax
c0106991:	74 0e                	je     c01069a1 <default_check+0x24e>
c0106993:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106996:	83 c0 40             	add    $0x40,%eax
c0106999:	8b 40 08             	mov    0x8(%eax),%eax
c010699c:	83 f8 03             	cmp    $0x3,%eax
c010699f:	74 19                	je     c01069ba <default_check+0x267>
c01069a1:	68 a0 b4 10 c0       	push   $0xc010b4a0
c01069a6:	68 5a b2 10 c0       	push   $0xc010b25a
c01069ab:	68 1c 01 00 00       	push   $0x11c
c01069b0:	68 6f b2 10 c0       	push   $0xc010b26f
c01069b5:	e8 3e 9a ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01069ba:	83 ec 0c             	sub    $0xc,%esp
c01069bd:	6a 03                	push   $0x3
c01069bf:	e8 03 06 00 00       	call   c0106fc7 <alloc_pages>
c01069c4:	83 c4 10             	add    $0x10,%esp
c01069c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01069ca:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01069ce:	75 19                	jne    c01069e9 <default_check+0x296>
c01069d0:	68 cc b4 10 c0       	push   $0xc010b4cc
c01069d5:	68 5a b2 10 c0       	push   $0xc010b25a
c01069da:	68 1d 01 00 00       	push   $0x11d
c01069df:	68 6f b2 10 c0       	push   $0xc010b26f
c01069e4:	e8 0f 9a ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01069e9:	83 ec 0c             	sub    $0xc,%esp
c01069ec:	6a 01                	push   $0x1
c01069ee:	e8 d4 05 00 00       	call   c0106fc7 <alloc_pages>
c01069f3:	83 c4 10             	add    $0x10,%esp
c01069f6:	85 c0                	test   %eax,%eax
c01069f8:	74 19                	je     c0106a13 <default_check+0x2c0>
c01069fa:	68 e2 b3 10 c0       	push   $0xc010b3e2
c01069ff:	68 5a b2 10 c0       	push   $0xc010b25a
c0106a04:	68 1e 01 00 00       	push   $0x11e
c0106a09:	68 6f b2 10 c0       	push   $0xc010b26f
c0106a0e:	e8 e5 99 ff ff       	call   c01003f8 <__panic>
    assert(p0 + 2 == p1);
c0106a13:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a16:	83 c0 40             	add    $0x40,%eax
c0106a19:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0106a1c:	74 19                	je     c0106a37 <default_check+0x2e4>
c0106a1e:	68 ea b4 10 c0       	push   $0xc010b4ea
c0106a23:	68 5a b2 10 c0       	push   $0xc010b25a
c0106a28:	68 1f 01 00 00       	push   $0x11f
c0106a2d:	68 6f b2 10 c0       	push   $0xc010b26f
c0106a32:	e8 c1 99 ff ff       	call   c01003f8 <__panic>

    p2 = p0 + 1;
c0106a37:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a3a:	83 c0 20             	add    $0x20,%eax
c0106a3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0106a40:	83 ec 08             	sub    $0x8,%esp
c0106a43:	6a 01                	push   $0x1
c0106a45:	ff 75 dc             	pushl  -0x24(%ebp)
c0106a48:	e8 e6 05 00 00       	call   c0107033 <free_pages>
c0106a4d:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0106a50:	83 ec 08             	sub    $0x8,%esp
c0106a53:	6a 03                	push   $0x3
c0106a55:	ff 75 c4             	pushl  -0x3c(%ebp)
c0106a58:	e8 d6 05 00 00       	call   c0107033 <free_pages>
c0106a5d:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0106a60:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a63:	83 c0 04             	add    $0x4,%eax
c0106a66:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0106a6d:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106a70:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106a73:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0106a76:	0f a3 10             	bt     %edx,(%eax)
c0106a79:	19 c0                	sbb    %eax,%eax
c0106a7b:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0106a7e:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0106a82:	0f 95 c0             	setne  %al
c0106a85:	0f b6 c0             	movzbl %al,%eax
c0106a88:	85 c0                	test   %eax,%eax
c0106a8a:	74 0b                	je     c0106a97 <default_check+0x344>
c0106a8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a8f:	8b 40 08             	mov    0x8(%eax),%eax
c0106a92:	83 f8 01             	cmp    $0x1,%eax
c0106a95:	74 19                	je     c0106ab0 <default_check+0x35d>
c0106a97:	68 f8 b4 10 c0       	push   $0xc010b4f8
c0106a9c:	68 5a b2 10 c0       	push   $0xc010b25a
c0106aa1:	68 24 01 00 00       	push   $0x124
c0106aa6:	68 6f b2 10 c0       	push   $0xc010b26f
c0106aab:	e8 48 99 ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0106ab0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106ab3:	83 c0 04             	add    $0x4,%eax
c0106ab6:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0106abd:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106ac0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106ac3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106ac6:	0f a3 10             	bt     %edx,(%eax)
c0106ac9:	19 c0                	sbb    %eax,%eax
c0106acb:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0106ace:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0106ad2:	0f 95 c0             	setne  %al
c0106ad5:	0f b6 c0             	movzbl %al,%eax
c0106ad8:	85 c0                	test   %eax,%eax
c0106ada:	74 0b                	je     c0106ae7 <default_check+0x394>
c0106adc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106adf:	8b 40 08             	mov    0x8(%eax),%eax
c0106ae2:	83 f8 03             	cmp    $0x3,%eax
c0106ae5:	74 19                	je     c0106b00 <default_check+0x3ad>
c0106ae7:	68 20 b5 10 c0       	push   $0xc010b520
c0106aec:	68 5a b2 10 c0       	push   $0xc010b25a
c0106af1:	68 25 01 00 00       	push   $0x125
c0106af6:	68 6f b2 10 c0       	push   $0xc010b26f
c0106afb:	e8 f8 98 ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0106b00:	83 ec 0c             	sub    $0xc,%esp
c0106b03:	6a 01                	push   $0x1
c0106b05:	e8 bd 04 00 00       	call   c0106fc7 <alloc_pages>
c0106b0a:	83 c4 10             	add    $0x10,%esp
c0106b0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106b10:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b13:	83 e8 20             	sub    $0x20,%eax
c0106b16:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106b19:	74 19                	je     c0106b34 <default_check+0x3e1>
c0106b1b:	68 46 b5 10 c0       	push   $0xc010b546
c0106b20:	68 5a b2 10 c0       	push   $0xc010b25a
c0106b25:	68 27 01 00 00       	push   $0x127
c0106b2a:	68 6f b2 10 c0       	push   $0xc010b26f
c0106b2f:	e8 c4 98 ff ff       	call   c01003f8 <__panic>
    free_page(p0);
c0106b34:	83 ec 08             	sub    $0x8,%esp
c0106b37:	6a 01                	push   $0x1
c0106b39:	ff 75 dc             	pushl  -0x24(%ebp)
c0106b3c:	e8 f2 04 00 00       	call   c0107033 <free_pages>
c0106b41:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0106b44:	83 ec 0c             	sub    $0xc,%esp
c0106b47:	6a 02                	push   $0x2
c0106b49:	e8 79 04 00 00       	call   c0106fc7 <alloc_pages>
c0106b4e:	83 c4 10             	add    $0x10,%esp
c0106b51:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106b54:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b57:	83 c0 20             	add    $0x20,%eax
c0106b5a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106b5d:	74 19                	je     c0106b78 <default_check+0x425>
c0106b5f:	68 64 b5 10 c0       	push   $0xc010b564
c0106b64:	68 5a b2 10 c0       	push   $0xc010b25a
c0106b69:	68 29 01 00 00       	push   $0x129
c0106b6e:	68 6f b2 10 c0       	push   $0xc010b26f
c0106b73:	e8 80 98 ff ff       	call   c01003f8 <__panic>

    free_pages(p0, 2);
c0106b78:	83 ec 08             	sub    $0x8,%esp
c0106b7b:	6a 02                	push   $0x2
c0106b7d:	ff 75 dc             	pushl  -0x24(%ebp)
c0106b80:	e8 ae 04 00 00       	call   c0107033 <free_pages>
c0106b85:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0106b88:	83 ec 08             	sub    $0x8,%esp
c0106b8b:	6a 01                	push   $0x1
c0106b8d:	ff 75 c0             	pushl  -0x40(%ebp)
c0106b90:	e8 9e 04 00 00       	call   c0107033 <free_pages>
c0106b95:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0106b98:	83 ec 0c             	sub    $0xc,%esp
c0106b9b:	6a 05                	push   $0x5
c0106b9d:	e8 25 04 00 00       	call   c0106fc7 <alloc_pages>
c0106ba2:	83 c4 10             	add    $0x10,%esp
c0106ba5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106ba8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106bac:	75 19                	jne    c0106bc7 <default_check+0x474>
c0106bae:	68 84 b5 10 c0       	push   $0xc010b584
c0106bb3:	68 5a b2 10 c0       	push   $0xc010b25a
c0106bb8:	68 2e 01 00 00       	push   $0x12e
c0106bbd:	68 6f b2 10 c0       	push   $0xc010b26f
c0106bc2:	e8 31 98 ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c0106bc7:	83 ec 0c             	sub    $0xc,%esp
c0106bca:	6a 01                	push   $0x1
c0106bcc:	e8 f6 03 00 00       	call   c0106fc7 <alloc_pages>
c0106bd1:	83 c4 10             	add    $0x10,%esp
c0106bd4:	85 c0                	test   %eax,%eax
c0106bd6:	74 19                	je     c0106bf1 <default_check+0x49e>
c0106bd8:	68 e2 b3 10 c0       	push   $0xc010b3e2
c0106bdd:	68 5a b2 10 c0       	push   $0xc010b25a
c0106be2:	68 2f 01 00 00       	push   $0x12f
c0106be7:	68 6f b2 10 c0       	push   $0xc010b26f
c0106bec:	e8 07 98 ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c0106bf1:	a1 8c c1 12 c0       	mov    0xc012c18c,%eax
c0106bf6:	85 c0                	test   %eax,%eax
c0106bf8:	74 19                	je     c0106c13 <default_check+0x4c0>
c0106bfa:	68 35 b4 10 c0       	push   $0xc010b435
c0106bff:	68 5a b2 10 c0       	push   $0xc010b25a
c0106c04:	68 31 01 00 00       	push   $0x131
c0106c09:	68 6f b2 10 c0       	push   $0xc010b26f
c0106c0e:	e8 e5 97 ff ff       	call   c01003f8 <__panic>
    nr_free = nr_free_store;
c0106c13:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106c16:	a3 8c c1 12 c0       	mov    %eax,0xc012c18c

    free_list = free_list_store;
c0106c1b:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106c1e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106c21:	a3 84 c1 12 c0       	mov    %eax,0xc012c184
c0106c26:	89 15 88 c1 12 c0    	mov    %edx,0xc012c188
    free_pages(p0, 5);
c0106c2c:	83 ec 08             	sub    $0x8,%esp
c0106c2f:	6a 05                	push   $0x5
c0106c31:	ff 75 dc             	pushl  -0x24(%ebp)
c0106c34:	e8 fa 03 00 00       	call   c0107033 <free_pages>
c0106c39:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0106c3c:	c7 45 ec 84 c1 12 c0 	movl   $0xc012c184,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106c43:	eb 1d                	jmp    c0106c62 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0106c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c48:	83 e8 0c             	sub    $0xc,%eax
c0106c4b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0106c4e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106c55:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106c58:	8b 40 08             	mov    0x8(%eax),%eax
c0106c5b:	29 c2                	sub    %eax,%edx
c0106c5d:	89 d0                	mov    %edx,%eax
c0106c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c65:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106c68:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106c6b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0106c6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c71:	81 7d ec 84 c1 12 c0 	cmpl   $0xc012c184,-0x14(%ebp)
c0106c78:	75 cb                	jne    c0106c45 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0106c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c7e:	74 19                	je     c0106c99 <default_check+0x546>
c0106c80:	68 a2 b5 10 c0       	push   $0xc010b5a2
c0106c85:	68 5a b2 10 c0       	push   $0xc010b25a
c0106c8a:	68 3c 01 00 00       	push   $0x13c
c0106c8f:	68 6f b2 10 c0       	push   $0xc010b26f
c0106c94:	e8 5f 97 ff ff       	call   c01003f8 <__panic>
    assert(total == 0);
c0106c99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106c9d:	74 19                	je     c0106cb8 <default_check+0x565>
c0106c9f:	68 ad b5 10 c0       	push   $0xc010b5ad
c0106ca4:	68 5a b2 10 c0       	push   $0xc010b25a
c0106ca9:	68 3d 01 00 00       	push   $0x13d
c0106cae:	68 6f b2 10 c0       	push   $0xc010b26f
c0106cb3:	e8 40 97 ff ff       	call   c01003f8 <__panic>
}
c0106cb8:	90                   	nop
c0106cb9:	c9                   	leave  
c0106cba:	c3                   	ret    

c0106cbb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0106cbb:	55                   	push   %ebp
c0106cbc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0106cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cc1:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0106cc7:	29 d0                	sub    %edx,%eax
c0106cc9:	c1 f8 05             	sar    $0x5,%eax
}
c0106ccc:	5d                   	pop    %ebp
c0106ccd:	c3                   	ret    

c0106cce <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0106cce:	55                   	push   %ebp
c0106ccf:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0106cd1:	ff 75 08             	pushl  0x8(%ebp)
c0106cd4:	e8 e2 ff ff ff       	call   c0106cbb <page2ppn>
c0106cd9:	83 c4 04             	add    $0x4,%esp
c0106cdc:	c1 e0 0c             	shl    $0xc,%eax
}
c0106cdf:	c9                   	leave  
c0106ce0:	c3                   	ret    

c0106ce1 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0106ce1:	55                   	push   %ebp
c0106ce2:	89 e5                	mov    %esp,%ebp
c0106ce4:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0106ce7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cea:	c1 e8 0c             	shr    $0xc,%eax
c0106ced:	89 c2                	mov    %eax,%edx
c0106cef:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0106cf4:	39 c2                	cmp    %eax,%edx
c0106cf6:	72 14                	jb     c0106d0c <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0106cf8:	83 ec 04             	sub    $0x4,%esp
c0106cfb:	68 e8 b5 10 c0       	push   $0xc010b5e8
c0106d00:	6a 5f                	push   $0x5f
c0106d02:	68 07 b6 10 c0       	push   $0xc010b607
c0106d07:	e8 ec 96 ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0106d0c:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0106d11:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d14:	c1 ea 0c             	shr    $0xc,%edx
c0106d17:	c1 e2 05             	shl    $0x5,%edx
c0106d1a:	01 d0                	add    %edx,%eax
}
c0106d1c:	c9                   	leave  
c0106d1d:	c3                   	ret    

c0106d1e <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0106d1e:	55                   	push   %ebp
c0106d1f:	89 e5                	mov    %esp,%ebp
c0106d21:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0106d24:	ff 75 08             	pushl  0x8(%ebp)
c0106d27:	e8 a2 ff ff ff       	call   c0106cce <page2pa>
c0106d2c:	83 c4 04             	add    $0x4,%esp
c0106d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d35:	c1 e8 0c             	shr    $0xc,%eax
c0106d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d3b:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0106d40:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106d43:	72 14                	jb     c0106d59 <page2kva+0x3b>
c0106d45:	ff 75 f4             	pushl  -0xc(%ebp)
c0106d48:	68 18 b6 10 c0       	push   $0xc010b618
c0106d4d:	6a 66                	push   $0x66
c0106d4f:	68 07 b6 10 c0       	push   $0xc010b607
c0106d54:	e8 9f 96 ff ff       	call   c01003f8 <__panic>
c0106d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d5c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0106d61:	c9                   	leave  
c0106d62:	c3                   	ret    

c0106d63 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106d63:	55                   	push   %ebp
c0106d64:	89 e5                	mov    %esp,%ebp
c0106d66:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0106d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d6c:	83 e0 01             	and    $0x1,%eax
c0106d6f:	85 c0                	test   %eax,%eax
c0106d71:	75 14                	jne    c0106d87 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0106d73:	83 ec 04             	sub    $0x4,%esp
c0106d76:	68 3c b6 10 c0       	push   $0xc010b63c
c0106d7b:	6a 71                	push   $0x71
c0106d7d:	68 07 b6 10 c0       	push   $0xc010b607
c0106d82:	e8 71 96 ff ff       	call   c01003f8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106d87:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106d8f:	83 ec 0c             	sub    $0xc,%esp
c0106d92:	50                   	push   %eax
c0106d93:	e8 49 ff ff ff       	call   c0106ce1 <pa2page>
c0106d98:	83 c4 10             	add    $0x10,%esp
}
c0106d9b:	c9                   	leave  
c0106d9c:	c3                   	ret    

c0106d9d <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0106d9d:	55                   	push   %ebp
c0106d9e:	89 e5                	mov    %esp,%ebp
c0106da0:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0106da3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106da6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106dab:	83 ec 0c             	sub    $0xc,%esp
c0106dae:	50                   	push   %eax
c0106daf:	e8 2d ff ff ff       	call   c0106ce1 <pa2page>
c0106db4:	83 c4 10             	add    $0x10,%esp
}
c0106db7:	c9                   	leave  
c0106db8:	c3                   	ret    

c0106db9 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0106db9:	55                   	push   %ebp
c0106dba:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dbf:	8b 00                	mov    (%eax),%eax
}
c0106dc1:	5d                   	pop    %ebp
c0106dc2:	c3                   	ret    

c0106dc3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0106dc3:	55                   	push   %ebp
c0106dc4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0106dc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106dcc:	89 10                	mov    %edx,(%eax)
}
c0106dce:	90                   	nop
c0106dcf:	5d                   	pop    %ebp
c0106dd0:	c3                   	ret    

c0106dd1 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106dd1:	55                   	push   %ebp
c0106dd2:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106dd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dd7:	8b 00                	mov    (%eax),%eax
c0106dd9:	8d 50 01             	lea    0x1(%eax),%edx
c0106ddc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ddf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106de1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106de4:	8b 00                	mov    (%eax),%eax
}
c0106de6:	5d                   	pop    %ebp
c0106de7:	c3                   	ret    

c0106de8 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0106de8:	55                   	push   %ebp
c0106de9:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dee:	8b 00                	mov    (%eax),%eax
c0106df0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106df6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dfb:	8b 00                	mov    (%eax),%eax
}
c0106dfd:	5d                   	pop    %ebp
c0106dfe:	c3                   	ret    

c0106dff <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0106dff:	55                   	push   %ebp
c0106e00:	89 e5                	mov    %esp,%ebp
c0106e02:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0106e05:	9c                   	pushf  
c0106e06:	58                   	pop    %eax
c0106e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106e0d:	25 00 02 00 00       	and    $0x200,%eax
c0106e12:	85 c0                	test   %eax,%eax
c0106e14:	74 0c                	je     c0106e22 <__intr_save+0x23>
        intr_disable();
c0106e16:	e8 c5 b2 ff ff       	call   c01020e0 <intr_disable>
        return 1;
c0106e1b:	b8 01 00 00 00       	mov    $0x1,%eax
c0106e20:	eb 05                	jmp    c0106e27 <__intr_save+0x28>
    }
    return 0;
c0106e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106e27:	c9                   	leave  
c0106e28:	c3                   	ret    

c0106e29 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0106e29:	55                   	push   %ebp
c0106e2a:	89 e5                	mov    %esp,%ebp
c0106e2c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106e2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106e33:	74 05                	je     c0106e3a <__intr_restore+0x11>
        intr_enable();
c0106e35:	e8 9f b2 ff ff       	call   c01020d9 <intr_enable>
    }
}
c0106e3a:	90                   	nop
c0106e3b:	c9                   	leave  
c0106e3c:	c3                   	ret    

c0106e3d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106e3d:	55                   	push   %ebp
c0106e3e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e43:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0106e46:	b8 23 00 00 00       	mov    $0x23,%eax
c0106e4b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106e4d:	b8 23 00 00 00       	mov    $0x23,%eax
c0106e52:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106e54:	b8 10 00 00 00       	mov    $0x10,%eax
c0106e59:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106e5b:	b8 10 00 00 00       	mov    $0x10,%eax
c0106e60:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106e62:	b8 10 00 00 00       	mov    $0x10,%eax
c0106e67:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0106e69:	ea 70 6e 10 c0 08 00 	ljmp   $0x8,$0xc0106e70
}
c0106e70:	90                   	nop
c0106e71:	5d                   	pop    %ebp
c0106e72:	c3                   	ret    

c0106e73 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0106e73:	55                   	push   %ebp
c0106e74:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0106e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e79:	a3 a4 9f 12 c0       	mov    %eax,0xc0129fa4
}
c0106e7e:	90                   	nop
c0106e7f:	5d                   	pop    %ebp
c0106e80:	c3                   	ret    

c0106e81 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106e81:	55                   	push   %ebp
c0106e82:	89 e5                	mov    %esp,%ebp
c0106e84:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0106e87:	b8 00 60 12 c0       	mov    $0xc0126000,%eax
c0106e8c:	50                   	push   %eax
c0106e8d:	e8 e1 ff ff ff       	call   c0106e73 <load_esp0>
c0106e92:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0106e95:	66 c7 05 a8 9f 12 c0 	movw   $0x10,0xc0129fa8
c0106e9c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106e9e:	66 c7 05 a8 6a 12 c0 	movw   $0x68,0xc0126aa8
c0106ea5:	68 00 
c0106ea7:	b8 a0 9f 12 c0       	mov    $0xc0129fa0,%eax
c0106eac:	66 a3 aa 6a 12 c0    	mov    %ax,0xc0126aaa
c0106eb2:	b8 a0 9f 12 c0       	mov    $0xc0129fa0,%eax
c0106eb7:	c1 e8 10             	shr    $0x10,%eax
c0106eba:	a2 ac 6a 12 c0       	mov    %al,0xc0126aac
c0106ebf:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106ec6:	83 e0 f0             	and    $0xfffffff0,%eax
c0106ec9:	83 c8 09             	or     $0x9,%eax
c0106ecc:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106ed1:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106ed8:	83 e0 ef             	and    $0xffffffef,%eax
c0106edb:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106ee0:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106ee7:	83 e0 9f             	and    $0xffffff9f,%eax
c0106eea:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106eef:	0f b6 05 ad 6a 12 c0 	movzbl 0xc0126aad,%eax
c0106ef6:	83 c8 80             	or     $0xffffff80,%eax
c0106ef9:	a2 ad 6a 12 c0       	mov    %al,0xc0126aad
c0106efe:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f05:	83 e0 f0             	and    $0xfffffff0,%eax
c0106f08:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f0d:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f14:	83 e0 ef             	and    $0xffffffef,%eax
c0106f17:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f1c:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f23:	83 e0 df             	and    $0xffffffdf,%eax
c0106f26:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f2b:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f32:	83 c8 40             	or     $0x40,%eax
c0106f35:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f3a:	0f b6 05 ae 6a 12 c0 	movzbl 0xc0126aae,%eax
c0106f41:	83 e0 7f             	and    $0x7f,%eax
c0106f44:	a2 ae 6a 12 c0       	mov    %al,0xc0126aae
c0106f49:	b8 a0 9f 12 c0       	mov    $0xc0129fa0,%eax
c0106f4e:	c1 e8 18             	shr    $0x18,%eax
c0106f51:	a2 af 6a 12 c0       	mov    %al,0xc0126aaf

    // reload all segment registers
    lgdt(&gdt_pd);
c0106f56:	68 b0 6a 12 c0       	push   $0xc0126ab0
c0106f5b:	e8 dd fe ff ff       	call   c0106e3d <lgdt>
c0106f60:	83 c4 04             	add    $0x4,%esp
c0106f63:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0106f69:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0106f6d:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0106f70:	90                   	nop
c0106f71:	c9                   	leave  
c0106f72:	c3                   	ret    

c0106f73 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0106f73:	55                   	push   %ebp
c0106f74:	89 e5                	mov    %esp,%ebp
c0106f76:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0106f79:	c7 05 90 c1 12 c0 cc 	movl   $0xc010b5cc,0xc012c190
c0106f80:	b5 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106f83:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0106f88:	8b 00                	mov    (%eax),%eax
c0106f8a:	83 ec 08             	sub    $0x8,%esp
c0106f8d:	50                   	push   %eax
c0106f8e:	68 68 b6 10 c0       	push   $0xc010b668
c0106f93:	e8 fa 92 ff ff       	call   c0100292 <cprintf>
c0106f98:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0106f9b:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0106fa0:	8b 40 04             	mov    0x4(%eax),%eax
c0106fa3:	ff d0                	call   *%eax
}
c0106fa5:	90                   	nop
c0106fa6:	c9                   	leave  
c0106fa7:	c3                   	ret    

c0106fa8 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106fa8:	55                   	push   %ebp
c0106fa9:	89 e5                	mov    %esp,%ebp
c0106fab:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0106fae:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0106fb3:	8b 40 08             	mov    0x8(%eax),%eax
c0106fb6:	83 ec 08             	sub    $0x8,%esp
c0106fb9:	ff 75 0c             	pushl  0xc(%ebp)
c0106fbc:	ff 75 08             	pushl  0x8(%ebp)
c0106fbf:	ff d0                	call   *%eax
c0106fc1:	83 c4 10             	add    $0x10,%esp
}
c0106fc4:	90                   	nop
c0106fc5:	c9                   	leave  
c0106fc6:	c3                   	ret    

c0106fc7 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106fc7:	55                   	push   %ebp
c0106fc8:	89 e5                	mov    %esp,%ebp
c0106fca:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0106fcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106fd4:	e8 26 fe ff ff       	call   c0106dff <__intr_save>
c0106fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106fdc:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0106fe1:	8b 40 0c             	mov    0xc(%eax),%eax
c0106fe4:	83 ec 0c             	sub    $0xc,%esp
c0106fe7:	ff 75 08             	pushl  0x8(%ebp)
c0106fea:	ff d0                	call   *%eax
c0106fec:	83 c4 10             	add    $0x10,%esp
c0106fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106ff2:	83 ec 0c             	sub    $0xc,%esp
c0106ff5:	ff 75 f0             	pushl  -0x10(%ebp)
c0106ff8:	e8 2c fe ff ff       	call   c0106e29 <__intr_restore>
c0106ffd:	83 c4 10             	add    $0x10,%esp

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0107000:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107004:	75 28                	jne    c010702e <alloc_pages+0x67>
c0107006:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010700a:	77 22                	ja     c010702e <alloc_pages+0x67>
c010700c:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c0107011:	85 c0                	test   %eax,%eax
c0107013:	74 19                	je     c010702e <alloc_pages+0x67>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0107015:	8b 55 08             	mov    0x8(%ebp),%edx
c0107018:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c010701d:	83 ec 04             	sub    $0x4,%esp
c0107020:	6a 00                	push   $0x0
c0107022:	52                   	push   %edx
c0107023:	50                   	push   %eax
c0107024:	e8 9e e3 ff ff       	call   c01053c7 <swap_out>
c0107029:	83 c4 10             	add    $0x10,%esp
    }
c010702c:	eb a6                	jmp    c0106fd4 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010702e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107031:	c9                   	leave  
c0107032:	c3                   	ret    

c0107033 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0107033:	55                   	push   %ebp
c0107034:	89 e5                	mov    %esp,%ebp
c0107036:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0107039:	e8 c1 fd ff ff       	call   c0106dff <__intr_save>
c010703e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0107041:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0107046:	8b 40 10             	mov    0x10(%eax),%eax
c0107049:	83 ec 08             	sub    $0x8,%esp
c010704c:	ff 75 0c             	pushl  0xc(%ebp)
c010704f:	ff 75 08             	pushl  0x8(%ebp)
c0107052:	ff d0                	call   *%eax
c0107054:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0107057:	83 ec 0c             	sub    $0xc,%esp
c010705a:	ff 75 f4             	pushl  -0xc(%ebp)
c010705d:	e8 c7 fd ff ff       	call   c0106e29 <__intr_restore>
c0107062:	83 c4 10             	add    $0x10,%esp
}
c0107065:	90                   	nop
c0107066:	c9                   	leave  
c0107067:	c3                   	ret    

c0107068 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0107068:	55                   	push   %ebp
c0107069:	89 e5                	mov    %esp,%ebp
c010706b:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010706e:	e8 8c fd ff ff       	call   c0106dff <__intr_save>
c0107073:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0107076:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c010707b:	8b 40 14             	mov    0x14(%eax),%eax
c010707e:	ff d0                	call   *%eax
c0107080:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0107083:	83 ec 0c             	sub    $0xc,%esp
c0107086:	ff 75 f4             	pushl  -0xc(%ebp)
c0107089:	e8 9b fd ff ff       	call   c0106e29 <__intr_restore>
c010708e:	83 c4 10             	add    $0x10,%esp
    return ret;
c0107091:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0107094:	c9                   	leave  
c0107095:	c3                   	ret    

c0107096 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0107096:	55                   	push   %ebp
c0107097:	89 e5                	mov    %esp,%ebp
c0107099:	57                   	push   %edi
c010709a:	56                   	push   %esi
c010709b:	53                   	push   %ebx
c010709c:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010709f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01070a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01070ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01070b4:	83 ec 0c             	sub    $0xc,%esp
c01070b7:	68 7f b6 10 c0       	push   $0xc010b67f
c01070bc:	e8 d1 91 ff ff       	call   c0100292 <cprintf>
c01070c1:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01070c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01070cb:	e9 fc 00 00 00       	jmp    c01071cc <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01070d0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01070d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01070d6:	89 d0                	mov    %edx,%eax
c01070d8:	c1 e0 02             	shl    $0x2,%eax
c01070db:	01 d0                	add    %edx,%eax
c01070dd:	c1 e0 02             	shl    $0x2,%eax
c01070e0:	01 c8                	add    %ecx,%eax
c01070e2:	8b 50 08             	mov    0x8(%eax),%edx
c01070e5:	8b 40 04             	mov    0x4(%eax),%eax
c01070e8:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01070eb:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01070ee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01070f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01070f4:	89 d0                	mov    %edx,%eax
c01070f6:	c1 e0 02             	shl    $0x2,%eax
c01070f9:	01 d0                	add    %edx,%eax
c01070fb:	c1 e0 02             	shl    $0x2,%eax
c01070fe:	01 c8                	add    %ecx,%eax
c0107100:	8b 48 0c             	mov    0xc(%eax),%ecx
c0107103:	8b 58 10             	mov    0x10(%eax),%ebx
c0107106:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107109:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010710c:	01 c8                	add    %ecx,%eax
c010710e:	11 da                	adc    %ebx,%edx
c0107110:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0107113:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0107116:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107119:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010711c:	89 d0                	mov    %edx,%eax
c010711e:	c1 e0 02             	shl    $0x2,%eax
c0107121:	01 d0                	add    %edx,%eax
c0107123:	c1 e0 02             	shl    $0x2,%eax
c0107126:	01 c8                	add    %ecx,%eax
c0107128:	83 c0 14             	add    $0x14,%eax
c010712b:	8b 00                	mov    (%eax),%eax
c010712d:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0107130:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107133:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107136:	83 c0 ff             	add    $0xffffffff,%eax
c0107139:	83 d2 ff             	adc    $0xffffffff,%edx
c010713c:	89 c1                	mov    %eax,%ecx
c010713e:	89 d3                	mov    %edx,%ebx
c0107140:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0107143:	89 55 80             	mov    %edx,-0x80(%ebp)
c0107146:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107149:	89 d0                	mov    %edx,%eax
c010714b:	c1 e0 02             	shl    $0x2,%eax
c010714e:	01 d0                	add    %edx,%eax
c0107150:	c1 e0 02             	shl    $0x2,%eax
c0107153:	03 45 80             	add    -0x80(%ebp),%eax
c0107156:	8b 50 10             	mov    0x10(%eax),%edx
c0107159:	8b 40 0c             	mov    0xc(%eax),%eax
c010715c:	ff 75 84             	pushl  -0x7c(%ebp)
c010715f:	53                   	push   %ebx
c0107160:	51                   	push   %ecx
c0107161:	ff 75 bc             	pushl  -0x44(%ebp)
c0107164:	ff 75 b8             	pushl  -0x48(%ebp)
c0107167:	52                   	push   %edx
c0107168:	50                   	push   %eax
c0107169:	68 8c b6 10 c0       	push   $0xc010b68c
c010716e:	e8 1f 91 ff ff       	call   c0100292 <cprintf>
c0107173:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0107176:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107179:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010717c:	89 d0                	mov    %edx,%eax
c010717e:	c1 e0 02             	shl    $0x2,%eax
c0107181:	01 d0                	add    %edx,%eax
c0107183:	c1 e0 02             	shl    $0x2,%eax
c0107186:	01 c8                	add    %ecx,%eax
c0107188:	83 c0 14             	add    $0x14,%eax
c010718b:	8b 00                	mov    (%eax),%eax
c010718d:	83 f8 01             	cmp    $0x1,%eax
c0107190:	75 36                	jne    c01071c8 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0107192:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107195:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107198:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010719b:	77 2b                	ja     c01071c8 <page_init+0x132>
c010719d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01071a0:	72 05                	jb     c01071a7 <page_init+0x111>
c01071a2:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01071a5:	73 21                	jae    c01071c8 <page_init+0x132>
c01071a7:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01071ab:	77 1b                	ja     c01071c8 <page_init+0x132>
c01071ad:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01071b1:	72 09                	jb     c01071bc <page_init+0x126>
c01071b3:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01071ba:	77 0c                	ja     c01071c8 <page_init+0x132>
                maxpa = end;
c01071bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01071bf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01071c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01071c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01071c8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01071cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01071cf:	8b 00                	mov    (%eax),%eax
c01071d1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01071d4:	0f 8f f6 fe ff ff    	jg     c01070d0 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01071da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01071de:	72 1d                	jb     c01071fd <page_init+0x167>
c01071e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01071e4:	77 09                	ja     c01071ef <page_init+0x159>
c01071e6:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01071ed:	76 0e                	jbe    c01071fd <page_init+0x167>
        maxpa = KMEMSIZE;
c01071ef:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01071f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01071fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107203:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107207:	c1 ea 0c             	shr    $0xc,%edx
c010720a:	a3 80 9f 12 c0       	mov    %eax,0xc0129f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010720f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0107216:	b8 a4 c1 12 c0       	mov    $0xc012c1a4,%eax
c010721b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010721e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107221:	01 d0                	add    %edx,%eax
c0107223:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0107226:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107229:	ba 00 00 00 00       	mov    $0x0,%edx
c010722e:	f7 75 ac             	divl   -0x54(%ebp)
c0107231:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107234:	29 d0                	sub    %edx,%eax
c0107236:	a3 98 c1 12 c0       	mov    %eax,0xc012c198

    for (i = 0; i < npage; i ++) {
c010723b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0107242:	eb 27                	jmp    c010726b <page_init+0x1d5>
        SetPageReserved(pages + i);
c0107244:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0107249:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010724c:	c1 e2 05             	shl    $0x5,%edx
c010724f:	01 d0                	add    %edx,%eax
c0107251:	83 c0 04             	add    $0x4,%eax
c0107254:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010725b:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010725e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0107261:	8b 55 90             	mov    -0x70(%ebp),%edx
c0107264:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0107267:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010726b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010726e:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107273:	39 c2                	cmp    %eax,%edx
c0107275:	72 cd                	jb     c0107244 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0107277:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010727c:	c1 e0 05             	shl    $0x5,%eax
c010727f:	89 c2                	mov    %eax,%edx
c0107281:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c0107286:	01 d0                	add    %edx,%eax
c0107288:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010728b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0107292:	77 17                	ja     c01072ab <page_init+0x215>
c0107294:	ff 75 a4             	pushl  -0x5c(%ebp)
c0107297:	68 bc b6 10 c0       	push   $0xc010b6bc
c010729c:	68 ea 00 00 00       	push   $0xea
c01072a1:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01072a6:	e8 4d 91 ff ff       	call   c01003f8 <__panic>
c01072ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01072ae:	05 00 00 00 40       	add    $0x40000000,%eax
c01072b3:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01072b6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01072bd:	e9 69 01 00 00       	jmp    c010742b <page_init+0x395>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01072c2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01072c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01072c8:	89 d0                	mov    %edx,%eax
c01072ca:	c1 e0 02             	shl    $0x2,%eax
c01072cd:	01 d0                	add    %edx,%eax
c01072cf:	c1 e0 02             	shl    $0x2,%eax
c01072d2:	01 c8                	add    %ecx,%eax
c01072d4:	8b 50 08             	mov    0x8(%eax),%edx
c01072d7:	8b 40 04             	mov    0x4(%eax),%eax
c01072da:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01072dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01072e0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01072e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01072e6:	89 d0                	mov    %edx,%eax
c01072e8:	c1 e0 02             	shl    $0x2,%eax
c01072eb:	01 d0                	add    %edx,%eax
c01072ed:	c1 e0 02             	shl    $0x2,%eax
c01072f0:	01 c8                	add    %ecx,%eax
c01072f2:	8b 48 0c             	mov    0xc(%eax),%ecx
c01072f5:	8b 58 10             	mov    0x10(%eax),%ebx
c01072f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01072fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01072fe:	01 c8                	add    %ecx,%eax
c0107300:	11 da                	adc    %ebx,%edx
c0107302:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0107305:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0107308:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010730b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010730e:	89 d0                	mov    %edx,%eax
c0107310:	c1 e0 02             	shl    $0x2,%eax
c0107313:	01 d0                	add    %edx,%eax
c0107315:	c1 e0 02             	shl    $0x2,%eax
c0107318:	01 c8                	add    %ecx,%eax
c010731a:	83 c0 14             	add    $0x14,%eax
c010731d:	8b 00                	mov    (%eax),%eax
c010731f:	83 f8 01             	cmp    $0x1,%eax
c0107322:	0f 85 ff 00 00 00    	jne    c0107427 <page_init+0x391>
            if (begin < freemem) {
c0107328:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010732b:	ba 00 00 00 00       	mov    $0x0,%edx
c0107330:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107333:	72 17                	jb     c010734c <page_init+0x2b6>
c0107335:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107338:	77 05                	ja     c010733f <page_init+0x2a9>
c010733a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010733d:	76 0d                	jbe    c010734c <page_init+0x2b6>
                begin = freemem;
c010733f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107342:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107345:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010734c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107350:	72 1d                	jb     c010736f <page_init+0x2d9>
c0107352:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107356:	77 09                	ja     c0107361 <page_init+0x2cb>
c0107358:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010735f:	76 0e                	jbe    c010736f <page_init+0x2d9>
                end = KMEMSIZE;
c0107361:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0107368:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010736f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107372:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107375:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107378:	0f 87 a9 00 00 00    	ja     c0107427 <page_init+0x391>
c010737e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107381:	72 09                	jb     c010738c <page_init+0x2f6>
c0107383:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0107386:	0f 83 9b 00 00 00    	jae    c0107427 <page_init+0x391>
                begin = ROUNDUP(begin, PGSIZE);
c010738c:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0107393:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107396:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0107399:	01 d0                	add    %edx,%eax
c010739b:	83 e8 01             	sub    $0x1,%eax
c010739e:	89 45 98             	mov    %eax,-0x68(%ebp)
c01073a1:	8b 45 98             	mov    -0x68(%ebp),%eax
c01073a4:	ba 00 00 00 00       	mov    $0x0,%edx
c01073a9:	f7 75 9c             	divl   -0x64(%ebp)
c01073ac:	8b 45 98             	mov    -0x68(%ebp),%eax
c01073af:	29 d0                	sub    %edx,%eax
c01073b1:	ba 00 00 00 00       	mov    $0x0,%edx
c01073b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01073b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01073bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01073bf:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01073c2:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01073c5:	ba 00 00 00 00       	mov    $0x0,%edx
c01073ca:	89 c3                	mov    %eax,%ebx
c01073cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01073d2:	89 de                	mov    %ebx,%esi
c01073d4:	89 d0                	mov    %edx,%eax
c01073d6:	83 e0 00             	and    $0x0,%eax
c01073d9:	89 c7                	mov    %eax,%edi
c01073db:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01073de:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01073e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01073e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01073e7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01073ea:	77 3b                	ja     c0107427 <page_init+0x391>
c01073ec:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01073ef:	72 05                	jb     c01073f6 <page_init+0x360>
c01073f1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01073f4:	73 31                	jae    c0107427 <page_init+0x391>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01073f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01073f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01073fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01073ff:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0107402:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107406:	c1 ea 0c             	shr    $0xc,%edx
c0107409:	89 c3                	mov    %eax,%ebx
c010740b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010740e:	83 ec 0c             	sub    $0xc,%esp
c0107411:	50                   	push   %eax
c0107412:	e8 ca f8 ff ff       	call   c0106ce1 <pa2page>
c0107417:	83 c4 10             	add    $0x10,%esp
c010741a:	83 ec 08             	sub    $0x8,%esp
c010741d:	53                   	push   %ebx
c010741e:	50                   	push   %eax
c010741f:	e8 84 fb ff ff       	call   c0106fa8 <init_memmap>
c0107424:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0107427:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010742b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010742e:	8b 00                	mov    (%eax),%eax
c0107430:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0107433:	0f 8f 89 fe ff ff    	jg     c01072c2 <page_init+0x22c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0107439:	90                   	nop
c010743a:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010743d:	5b                   	pop    %ebx
c010743e:	5e                   	pop    %esi
c010743f:	5f                   	pop    %edi
c0107440:	5d                   	pop    %ebp
c0107441:	c3                   	ret    

c0107442 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0107442:	55                   	push   %ebp
c0107443:	89 e5                	mov    %esp,%ebp
c0107445:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0107448:	8b 45 0c             	mov    0xc(%ebp),%eax
c010744b:	33 45 14             	xor    0x14(%ebp),%eax
c010744e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107453:	85 c0                	test   %eax,%eax
c0107455:	74 19                	je     c0107470 <boot_map_segment+0x2e>
c0107457:	68 ee b6 10 c0       	push   $0xc010b6ee
c010745c:	68 05 b7 10 c0       	push   $0xc010b705
c0107461:	68 08 01 00 00       	push   $0x108
c0107466:	68 e0 b6 10 c0       	push   $0xc010b6e0
c010746b:	e8 88 8f ff ff       	call   c01003f8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0107470:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0107477:	8b 45 0c             	mov    0xc(%ebp),%eax
c010747a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010747f:	89 c2                	mov    %eax,%edx
c0107481:	8b 45 10             	mov    0x10(%ebp),%eax
c0107484:	01 c2                	add    %eax,%edx
c0107486:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107489:	01 d0                	add    %edx,%eax
c010748b:	83 e8 01             	sub    $0x1,%eax
c010748e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107491:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107494:	ba 00 00 00 00       	mov    $0x0,%edx
c0107499:	f7 75 f0             	divl   -0x10(%ebp)
c010749c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010749f:	29 d0                	sub    %edx,%eax
c01074a1:	c1 e8 0c             	shr    $0xc,%eax
c01074a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01074a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01074ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01074b5:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01074b8:	8b 45 14             	mov    0x14(%ebp),%eax
c01074bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01074be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01074c6:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01074c9:	eb 57                	jmp    c0107522 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01074cb:	83 ec 04             	sub    $0x4,%esp
c01074ce:	6a 01                	push   $0x1
c01074d0:	ff 75 0c             	pushl  0xc(%ebp)
c01074d3:	ff 75 08             	pushl  0x8(%ebp)
c01074d6:	e8 58 01 00 00       	call   c0107633 <get_pte>
c01074db:	83 c4 10             	add    $0x10,%esp
c01074de:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01074e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01074e5:	75 19                	jne    c0107500 <boot_map_segment+0xbe>
c01074e7:	68 1a b7 10 c0       	push   $0xc010b71a
c01074ec:	68 05 b7 10 c0       	push   $0xc010b705
c01074f1:	68 0e 01 00 00       	push   $0x10e
c01074f6:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01074fb:	e8 f8 8e ff ff       	call   c01003f8 <__panic>
        *ptep = pa | PTE_P | perm;
c0107500:	8b 45 14             	mov    0x14(%ebp),%eax
c0107503:	0b 45 18             	or     0x18(%ebp),%eax
c0107506:	83 c8 01             	or     $0x1,%eax
c0107509:	89 c2                	mov    %eax,%edx
c010750b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010750e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0107510:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107514:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010751b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0107522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107526:	75 a3                	jne    c01074cb <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0107528:	90                   	nop
c0107529:	c9                   	leave  
c010752a:	c3                   	ret    

c010752b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010752b:	55                   	push   %ebp
c010752c:	89 e5                	mov    %esp,%ebp
c010752e:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0107531:	83 ec 0c             	sub    $0xc,%esp
c0107534:	6a 01                	push   $0x1
c0107536:	e8 8c fa ff ff       	call   c0106fc7 <alloc_pages>
c010753b:	83 c4 10             	add    $0x10,%esp
c010753e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0107541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107545:	75 17                	jne    c010755e <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0107547:	83 ec 04             	sub    $0x4,%esp
c010754a:	68 27 b7 10 c0       	push   $0xc010b727
c010754f:	68 1a 01 00 00       	push   $0x11a
c0107554:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107559:	e8 9a 8e ff ff       	call   c01003f8 <__panic>
    }
    return page2kva(p);
c010755e:	83 ec 0c             	sub    $0xc,%esp
c0107561:	ff 75 f4             	pushl  -0xc(%ebp)
c0107564:	e8 b5 f7 ff ff       	call   c0106d1e <page2kva>
c0107569:	83 c4 10             	add    $0x10,%esp
}
c010756c:	c9                   	leave  
c010756d:	c3                   	ret    

c010756e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010756e:	55                   	push   %ebp
c010756f:	89 e5                	mov    %esp,%ebp
c0107571:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0107574:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107579:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010757c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0107583:	77 17                	ja     c010759c <pmm_init+0x2e>
c0107585:	ff 75 f4             	pushl  -0xc(%ebp)
c0107588:	68 bc b6 10 c0       	push   $0xc010b6bc
c010758d:	68 24 01 00 00       	push   $0x124
c0107592:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107597:	e8 5c 8e ff ff       	call   c01003f8 <__panic>
c010759c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010759f:	05 00 00 00 40       	add    $0x40000000,%eax
c01075a4:	a3 94 c1 12 c0       	mov    %eax,0xc012c194
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01075a9:	e8 c5 f9 ff ff       	call   c0106f73 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01075ae:	e8 e3 fa ff ff       	call   c0107096 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01075b3:	e8 6b 04 00 00       	call   c0107a23 <check_alloc_page>

    check_pgdir();
c01075b8:	e8 89 04 00 00       	call   c0107a46 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01075bd:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01075c2:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01075c8:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01075cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01075d0:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01075d7:	77 17                	ja     c01075f0 <pmm_init+0x82>
c01075d9:	ff 75 f0             	pushl  -0x10(%ebp)
c01075dc:	68 bc b6 10 c0       	push   $0xc010b6bc
c01075e1:	68 3a 01 00 00       	push   $0x13a
c01075e6:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01075eb:	e8 08 8e ff ff       	call   c01003f8 <__panic>
c01075f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075f3:	05 00 00 00 40       	add    $0x40000000,%eax
c01075f8:	83 c8 03             	or     $0x3,%eax
c01075fb:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01075fd:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107602:	83 ec 0c             	sub    $0xc,%esp
c0107605:	6a 02                	push   $0x2
c0107607:	6a 00                	push   $0x0
c0107609:	68 00 00 00 38       	push   $0x38000000
c010760e:	68 00 00 00 c0       	push   $0xc0000000
c0107613:	50                   	push   %eax
c0107614:	e8 29 fe ff ff       	call   c0107442 <boot_map_segment>
c0107619:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010761c:	e8 60 f8 ff ff       	call   c0106e81 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0107621:	e8 86 09 00 00       	call   c0107fac <check_boot_pgdir>

    print_pgdir();
c0107626:	e8 7c 0d 00 00       	call   c01083a7 <print_pgdir>
    
    kmalloc_init();
c010762b:	e8 7d d9 ff ff       	call   c0104fad <kmalloc_init>

}
c0107630:	90                   	nop
c0107631:	c9                   	leave  
c0107632:	c3                   	ret    

c0107633 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0107633:	55                   	push   %ebp
c0107634:	89 e5                	mov    %esp,%ebp
c0107636:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
c0107639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010763c:	c1 e8 16             	shr    $0x16,%eax
c010763f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
c0107642:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010764c:	8b 45 08             	mov    0x8(%ebp),%eax
c010764f:	01 d0                	add    %edx,%eax
c0107651:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
c0107654:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107657:	8b 00                	mov    (%eax),%eax
c0107659:	83 e0 01             	and    $0x1,%eax
c010765c:	85 c0                	test   %eax,%eax
c010765e:	0f 85 ae 00 00 00    	jne    c0107712 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
c0107664:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107668:	75 0a                	jne    c0107674 <get_pte+0x41>
            return NULL;
c010766a:	b8 00 00 00 00       	mov    $0x0,%eax
c010766f:	e9 01 01 00 00       	jmp    c0107775 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
c0107674:	83 ec 0c             	sub    $0xc,%esp
c0107677:	6a 01                	push   $0x1
c0107679:	e8 49 f9 ff ff       	call   c0106fc7 <alloc_pages>
c010767e:	83 c4 10             	add    $0x10,%esp
c0107681:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
c0107684:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107688:	75 0a                	jne    c0107694 <get_pte+0x61>
            return NULL;
c010768a:	b8 00 00 00 00       	mov    $0x0,%eax
c010768f:	e9 e1 00 00 00       	jmp    c0107775 <get_pte+0x142>
        }
        // (4) set page reference
        set_page_ref(pt_page, 1);
c0107694:	83 ec 08             	sub    $0x8,%esp
c0107697:	6a 01                	push   $0x1
c0107699:	ff 75 ec             	pushl  -0x14(%ebp)
c010769c:	e8 22 f7 ff ff       	call   c0106dc3 <set_page_ref>
c01076a1:	83 c4 10             	add    $0x10,%esp
        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
c01076a4:	83 ec 0c             	sub    $0xc,%esp
c01076a7:	ff 75 ec             	pushl  -0x14(%ebp)
c01076aa:	e8 1f f6 ff ff       	call   c0106cce <page2pa>
c01076af:	83 c4 10             	add    $0x10,%esp
c01076b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
c01076b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01076bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076be:	c1 e8 0c             	shr    $0xc,%eax
c01076c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01076c4:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c01076c9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01076cc:	72 17                	jb     c01076e5 <get_pte+0xb2>
c01076ce:	ff 75 e4             	pushl  -0x1c(%ebp)
c01076d1:	68 18 b6 10 c0       	push   $0xc010b618
c01076d6:	68 8d 01 00 00       	push   $0x18d
c01076db:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01076e0:	e8 13 8d ff ff       	call   c01003f8 <__panic>
c01076e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076e8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01076ed:	83 ec 04             	sub    $0x4,%esp
c01076f0:	68 00 10 00 00       	push   $0x1000
c01076f5:	6a 00                	push   $0x0
c01076f7:	50                   	push   %eax
c01076f8:	e8 35 1c 00 00       	call   c0109332 <memset>
c01076fd:	83 c4 10             	add    $0x10,%esp
        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
c0107700:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107703:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107708:	83 c8 07             	or     $0x7,%eax
c010770b:	89 c2                	mov    %eax,%edx
c010770d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107710:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
c0107712:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107715:	c1 e8 0c             	shr    $0xc,%eax
c0107718:	25 ff 03 00 00       	and    $0x3ff,%eax
c010771d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
c0107720:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107723:	8b 00                	mov    (%eax),%eax
c0107725:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010772a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
c010772d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107730:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0107733:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107736:	c1 e8 0c             	shr    $0xc,%eax
c0107739:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010773c:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107741:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0107744:	72 17                	jb     c010775d <get_pte+0x12a>
c0107746:	ff 75 d4             	pushl  -0x2c(%ebp)
c0107749:	68 18 b6 10 c0       	push   $0xc010b618
c010774e:	68 94 01 00 00       	push   $0x194
c0107753:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107758:	e8 9b 8c ff ff       	call   c01003f8 <__panic>
c010775d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107760:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107765:	89 c2                	mov    %eax,%edx
c0107767:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010776a:	c1 e0 02             	shl    $0x2,%eax
c010776d:	01 d0                	add    %edx,%eax
c010776f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
c0107772:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
c0107775:	c9                   	leave  
c0107776:	c3                   	ret    

c0107777 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0107777:	55                   	push   %ebp
c0107778:	89 e5                	mov    %esp,%ebp
c010777a:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010777d:	83 ec 04             	sub    $0x4,%esp
c0107780:	6a 00                	push   $0x0
c0107782:	ff 75 0c             	pushl  0xc(%ebp)
c0107785:	ff 75 08             	pushl  0x8(%ebp)
c0107788:	e8 a6 fe ff ff       	call   c0107633 <get_pte>
c010778d:	83 c4 10             	add    $0x10,%esp
c0107790:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0107793:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107797:	74 08                	je     c01077a1 <get_page+0x2a>
        *ptep_store = ptep;
c0107799:	8b 45 10             	mov    0x10(%ebp),%eax
c010779c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010779f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01077a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077a5:	74 1f                	je     c01077c6 <get_page+0x4f>
c01077a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077aa:	8b 00                	mov    (%eax),%eax
c01077ac:	83 e0 01             	and    $0x1,%eax
c01077af:	85 c0                	test   %eax,%eax
c01077b1:	74 13                	je     c01077c6 <get_page+0x4f>
        return pte2page(*ptep);
c01077b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077b6:	8b 00                	mov    (%eax),%eax
c01077b8:	83 ec 0c             	sub    $0xc,%esp
c01077bb:	50                   	push   %eax
c01077bc:	e8 a2 f5 ff ff       	call   c0106d63 <pte2page>
c01077c1:	83 c4 10             	add    $0x10,%esp
c01077c4:	eb 05                	jmp    c01077cb <get_page+0x54>
    }
    return NULL;
c01077c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01077cb:	c9                   	leave  
c01077cc:	c3                   	ret    

c01077cd <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01077cd:	55                   	push   %ebp
c01077ce:	89 e5                	mov    %esp,%ebp
c01077d0:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
c01077d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01077d6:	8b 00                	mov    (%eax),%eax
c01077d8:	83 e0 01             	and    $0x1,%eax
c01077db:	85 c0                	test   %eax,%eax
c01077dd:	74 57                	je     c0107836 <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
c01077df:	8b 45 10             	mov    0x10(%ebp),%eax
c01077e2:	8b 00                	mov    (%eax),%eax
c01077e4:	83 ec 0c             	sub    $0xc,%esp
c01077e7:	50                   	push   %eax
c01077e8:	e8 76 f5 ff ff       	call   c0106d63 <pte2page>
c01077ed:	83 c4 10             	add    $0x10,%esp
c01077f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //(3) decrease page reference
    page_ref_dec(page);
c01077f3:	83 ec 0c             	sub    $0xc,%esp
c01077f6:	ff 75 f4             	pushl  -0xc(%ebp)
c01077f9:	e8 ea f5 ff ff       	call   c0106de8 <page_ref_dec>
c01077fe:	83 c4 10             	add    $0x10,%esp
    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
c0107801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107804:	8b 00                	mov    (%eax),%eax
c0107806:	85 c0                	test   %eax,%eax
c0107808:	75 10                	jne    c010781a <page_remove_pte+0x4d>
        free_page(page);
c010780a:	83 ec 08             	sub    $0x8,%esp
c010780d:	6a 01                	push   $0x1
c010780f:	ff 75 f4             	pushl  -0xc(%ebp)
c0107812:	e8 1c f8 ff ff       	call   c0107033 <free_pages>
c0107817:	83 c4 10             	add    $0x10,%esp
    }
    //(5) clear second page table entry
    *ptep = 0;
c010781a:	8b 45 10             	mov    0x10(%ebp),%eax
c010781d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
c0107823:	83 ec 08             	sub    $0x8,%esp
c0107826:	ff 75 0c             	pushl  0xc(%ebp)
c0107829:	ff 75 08             	pushl  0x8(%ebp)
c010782c:	e8 fa 00 00 00       	call   c010792b <tlb_invalidate>
c0107831:	83 c4 10             	add    $0x10,%esp
c0107834:	eb 01                	jmp    c0107837 <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
c0107836:	90                   	nop
    }
    //(5) clear second page table entry
    *ptep = 0;
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
c0107837:	c9                   	leave  
c0107838:	c3                   	ret    

c0107839 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0107839:	55                   	push   %ebp
c010783a:	89 e5                	mov    %esp,%ebp
c010783c:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010783f:	83 ec 04             	sub    $0x4,%esp
c0107842:	6a 00                	push   $0x0
c0107844:	ff 75 0c             	pushl  0xc(%ebp)
c0107847:	ff 75 08             	pushl  0x8(%ebp)
c010784a:	e8 e4 fd ff ff       	call   c0107633 <get_pte>
c010784f:	83 c4 10             	add    $0x10,%esp
c0107852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0107855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107859:	74 14                	je     c010786f <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010785b:	83 ec 04             	sub    $0x4,%esp
c010785e:	ff 75 f4             	pushl  -0xc(%ebp)
c0107861:	ff 75 0c             	pushl  0xc(%ebp)
c0107864:	ff 75 08             	pushl  0x8(%ebp)
c0107867:	e8 61 ff ff ff       	call   c01077cd <page_remove_pte>
c010786c:	83 c4 10             	add    $0x10,%esp
    }
}
c010786f:	90                   	nop
c0107870:	c9                   	leave  
c0107871:	c3                   	ret    

c0107872 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0107872:	55                   	push   %ebp
c0107873:	89 e5                	mov    %esp,%ebp
c0107875:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0107878:	83 ec 04             	sub    $0x4,%esp
c010787b:	6a 01                	push   $0x1
c010787d:	ff 75 10             	pushl  0x10(%ebp)
c0107880:	ff 75 08             	pushl  0x8(%ebp)
c0107883:	e8 ab fd ff ff       	call   c0107633 <get_pte>
c0107888:	83 c4 10             	add    $0x10,%esp
c010788b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010788e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107892:	75 0a                	jne    c010789e <page_insert+0x2c>
        return -E_NO_MEM;
c0107894:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0107899:	e9 8b 00 00 00       	jmp    c0107929 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010789e:	83 ec 0c             	sub    $0xc,%esp
c01078a1:	ff 75 0c             	pushl  0xc(%ebp)
c01078a4:	e8 28 f5 ff ff       	call   c0106dd1 <page_ref_inc>
c01078a9:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01078ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078af:	8b 00                	mov    (%eax),%eax
c01078b1:	83 e0 01             	and    $0x1,%eax
c01078b4:	85 c0                	test   %eax,%eax
c01078b6:	74 40                	je     c01078f8 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01078b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078bb:	8b 00                	mov    (%eax),%eax
c01078bd:	83 ec 0c             	sub    $0xc,%esp
c01078c0:	50                   	push   %eax
c01078c1:	e8 9d f4 ff ff       	call   c0106d63 <pte2page>
c01078c6:	83 c4 10             	add    $0x10,%esp
c01078c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01078cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01078d2:	75 10                	jne    c01078e4 <page_insert+0x72>
            page_ref_dec(page);
c01078d4:	83 ec 0c             	sub    $0xc,%esp
c01078d7:	ff 75 0c             	pushl  0xc(%ebp)
c01078da:	e8 09 f5 ff ff       	call   c0106de8 <page_ref_dec>
c01078df:	83 c4 10             	add    $0x10,%esp
c01078e2:	eb 14                	jmp    c01078f8 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01078e4:	83 ec 04             	sub    $0x4,%esp
c01078e7:	ff 75 f4             	pushl  -0xc(%ebp)
c01078ea:	ff 75 10             	pushl  0x10(%ebp)
c01078ed:	ff 75 08             	pushl  0x8(%ebp)
c01078f0:	e8 d8 fe ff ff       	call   c01077cd <page_remove_pte>
c01078f5:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01078f8:	83 ec 0c             	sub    $0xc,%esp
c01078fb:	ff 75 0c             	pushl  0xc(%ebp)
c01078fe:	e8 cb f3 ff ff       	call   c0106cce <page2pa>
c0107903:	83 c4 10             	add    $0x10,%esp
c0107906:	0b 45 14             	or     0x14(%ebp),%eax
c0107909:	83 c8 01             	or     $0x1,%eax
c010790c:	89 c2                	mov    %eax,%edx
c010790e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107911:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0107913:	83 ec 08             	sub    $0x8,%esp
c0107916:	ff 75 10             	pushl  0x10(%ebp)
c0107919:	ff 75 08             	pushl  0x8(%ebp)
c010791c:	e8 0a 00 00 00       	call   c010792b <tlb_invalidate>
c0107921:	83 c4 10             	add    $0x10,%esp
    return 0;
c0107924:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107929:	c9                   	leave  
c010792a:	c3                   	ret    

c010792b <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010792b:	55                   	push   %ebp
c010792c:	89 e5                	mov    %esp,%ebp
c010792e:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0107931:	0f 20 d8             	mov    %cr3,%eax
c0107934:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0107937:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010793a:	8b 45 08             	mov    0x8(%ebp),%eax
c010793d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107940:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107947:	77 17                	ja     c0107960 <tlb_invalidate+0x35>
c0107949:	ff 75 f0             	pushl  -0x10(%ebp)
c010794c:	68 bc b6 10 c0       	push   $0xc010b6bc
c0107951:	68 ff 01 00 00       	push   $0x1ff
c0107956:	68 e0 b6 10 c0       	push   $0xc010b6e0
c010795b:	e8 98 8a ff ff       	call   c01003f8 <__panic>
c0107960:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107963:	05 00 00 00 40       	add    $0x40000000,%eax
c0107968:	39 c2                	cmp    %eax,%edx
c010796a:	75 0c                	jne    c0107978 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c010796c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010796f:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0107972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107975:	0f 01 38             	invlpg (%eax)
    }
}
c0107978:	90                   	nop
c0107979:	c9                   	leave  
c010797a:	c3                   	ret    

c010797b <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010797b:	55                   	push   %ebp
c010797c:	89 e5                	mov    %esp,%ebp
c010797e:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_page();
c0107981:	83 ec 0c             	sub    $0xc,%esp
c0107984:	6a 01                	push   $0x1
c0107986:	e8 3c f6 ff ff       	call   c0106fc7 <alloc_pages>
c010798b:	83 c4 10             	add    $0x10,%esp
c010798e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0107991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107995:	0f 84 83 00 00 00    	je     c0107a1e <pgdir_alloc_page+0xa3>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010799b:	ff 75 10             	pushl  0x10(%ebp)
c010799e:	ff 75 0c             	pushl  0xc(%ebp)
c01079a1:	ff 75 f4             	pushl  -0xc(%ebp)
c01079a4:	ff 75 08             	pushl  0x8(%ebp)
c01079a7:	e8 c6 fe ff ff       	call   c0107872 <page_insert>
c01079ac:	83 c4 10             	add    $0x10,%esp
c01079af:	85 c0                	test   %eax,%eax
c01079b1:	74 17                	je     c01079ca <pgdir_alloc_page+0x4f>
            free_page(page);
c01079b3:	83 ec 08             	sub    $0x8,%esp
c01079b6:	6a 01                	push   $0x1
c01079b8:	ff 75 f4             	pushl  -0xc(%ebp)
c01079bb:	e8 73 f6 ff ff       	call   c0107033 <free_pages>
c01079c0:	83 c4 10             	add    $0x10,%esp
            return NULL;
c01079c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01079c8:	eb 57                	jmp    c0107a21 <pgdir_alloc_page+0xa6>
        }
        if (swap_init_ok){
c01079ca:	a1 6c 9f 12 c0       	mov    0xc0129f6c,%eax
c01079cf:	85 c0                	test   %eax,%eax
c01079d1:	74 4b                	je     c0107a1e <pgdir_alloc_page+0xa3>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01079d3:	a1 bc c0 12 c0       	mov    0xc012c0bc,%eax
c01079d8:	6a 00                	push   $0x0
c01079da:	ff 75 f4             	pushl  -0xc(%ebp)
c01079dd:	ff 75 0c             	pushl  0xc(%ebp)
c01079e0:	50                   	push   %eax
c01079e1:	e8 a2 d9 ff ff       	call   c0105388 <swap_map_swappable>
c01079e6:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr=la;
c01079e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01079ef:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01079f2:	83 ec 0c             	sub    $0xc,%esp
c01079f5:	ff 75 f4             	pushl  -0xc(%ebp)
c01079f8:	e8 bc f3 ff ff       	call   c0106db9 <page_ref>
c01079fd:	83 c4 10             	add    $0x10,%esp
c0107a00:	83 f8 01             	cmp    $0x1,%eax
c0107a03:	74 19                	je     c0107a1e <pgdir_alloc_page+0xa3>
c0107a05:	68 40 b7 10 c0       	push   $0xc010b740
c0107a0a:	68 05 b7 10 c0       	push   $0xc010b705
c0107a0f:	68 12 02 00 00       	push   $0x212
c0107a14:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107a19:	e8 da 89 ff ff       	call   c01003f8 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0107a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107a21:	c9                   	leave  
c0107a22:	c3                   	ret    

c0107a23 <check_alloc_page>:

static void
check_alloc_page(void) {
c0107a23:	55                   	push   %ebp
c0107a24:	89 e5                	mov    %esp,%ebp
c0107a26:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0107a29:	a1 90 c1 12 c0       	mov    0xc012c190,%eax
c0107a2e:	8b 40 18             	mov    0x18(%eax),%eax
c0107a31:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0107a33:	83 ec 0c             	sub    $0xc,%esp
c0107a36:	68 54 b7 10 c0       	push   $0xc010b754
c0107a3b:	e8 52 88 ff ff       	call   c0100292 <cprintf>
c0107a40:	83 c4 10             	add    $0x10,%esp
}
c0107a43:	90                   	nop
c0107a44:	c9                   	leave  
c0107a45:	c3                   	ret    

c0107a46 <check_pgdir>:

static void
check_pgdir(void) {
c0107a46:	55                   	push   %ebp
c0107a47:	89 e5                	mov    %esp,%ebp
c0107a49:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0107a4c:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107a51:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0107a56:	76 19                	jbe    c0107a71 <check_pgdir+0x2b>
c0107a58:	68 73 b7 10 c0       	push   $0xc010b773
c0107a5d:	68 05 b7 10 c0       	push   $0xc010b705
c0107a62:	68 23 02 00 00       	push   $0x223
c0107a67:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107a6c:	e8 87 89 ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0107a71:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107a76:	85 c0                	test   %eax,%eax
c0107a78:	74 0e                	je     c0107a88 <check_pgdir+0x42>
c0107a7a:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107a7f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107a84:	85 c0                	test   %eax,%eax
c0107a86:	74 19                	je     c0107aa1 <check_pgdir+0x5b>
c0107a88:	68 90 b7 10 c0       	push   $0xc010b790
c0107a8d:	68 05 b7 10 c0       	push   $0xc010b705
c0107a92:	68 24 02 00 00       	push   $0x224
c0107a97:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107a9c:	e8 57 89 ff ff       	call   c01003f8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0107aa1:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107aa6:	83 ec 04             	sub    $0x4,%esp
c0107aa9:	6a 00                	push   $0x0
c0107aab:	6a 00                	push   $0x0
c0107aad:	50                   	push   %eax
c0107aae:	e8 c4 fc ff ff       	call   c0107777 <get_page>
c0107ab3:	83 c4 10             	add    $0x10,%esp
c0107ab6:	85 c0                	test   %eax,%eax
c0107ab8:	74 19                	je     c0107ad3 <check_pgdir+0x8d>
c0107aba:	68 c8 b7 10 c0       	push   $0xc010b7c8
c0107abf:	68 05 b7 10 c0       	push   $0xc010b705
c0107ac4:	68 25 02 00 00       	push   $0x225
c0107ac9:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107ace:	e8 25 89 ff ff       	call   c01003f8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107ad3:	83 ec 0c             	sub    $0xc,%esp
c0107ad6:	6a 01                	push   $0x1
c0107ad8:	e8 ea f4 ff ff       	call   c0106fc7 <alloc_pages>
c0107add:	83 c4 10             	add    $0x10,%esp
c0107ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107ae3:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107ae8:	6a 00                	push   $0x0
c0107aea:	6a 00                	push   $0x0
c0107aec:	ff 75 f4             	pushl  -0xc(%ebp)
c0107aef:	50                   	push   %eax
c0107af0:	e8 7d fd ff ff       	call   c0107872 <page_insert>
c0107af5:	83 c4 10             	add    $0x10,%esp
c0107af8:	85 c0                	test   %eax,%eax
c0107afa:	74 19                	je     c0107b15 <check_pgdir+0xcf>
c0107afc:	68 f0 b7 10 c0       	push   $0xc010b7f0
c0107b01:	68 05 b7 10 c0       	push   $0xc010b705
c0107b06:	68 29 02 00 00       	push   $0x229
c0107b0b:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107b10:	e8 e3 88 ff ff       	call   c01003f8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0107b15:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107b1a:	83 ec 04             	sub    $0x4,%esp
c0107b1d:	6a 00                	push   $0x0
c0107b1f:	6a 00                	push   $0x0
c0107b21:	50                   	push   %eax
c0107b22:	e8 0c fb ff ff       	call   c0107633 <get_pte>
c0107b27:	83 c4 10             	add    $0x10,%esp
c0107b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107b31:	75 19                	jne    c0107b4c <check_pgdir+0x106>
c0107b33:	68 1c b8 10 c0       	push   $0xc010b81c
c0107b38:	68 05 b7 10 c0       	push   $0xc010b705
c0107b3d:	68 2c 02 00 00       	push   $0x22c
c0107b42:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107b47:	e8 ac 88 ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c0107b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b4f:	8b 00                	mov    (%eax),%eax
c0107b51:	83 ec 0c             	sub    $0xc,%esp
c0107b54:	50                   	push   %eax
c0107b55:	e8 09 f2 ff ff       	call   c0106d63 <pte2page>
c0107b5a:	83 c4 10             	add    $0x10,%esp
c0107b5d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107b60:	74 19                	je     c0107b7b <check_pgdir+0x135>
c0107b62:	68 49 b8 10 c0       	push   $0xc010b849
c0107b67:	68 05 b7 10 c0       	push   $0xc010b705
c0107b6c:	68 2d 02 00 00       	push   $0x22d
c0107b71:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107b76:	e8 7d 88 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 1);
c0107b7b:	83 ec 0c             	sub    $0xc,%esp
c0107b7e:	ff 75 f4             	pushl  -0xc(%ebp)
c0107b81:	e8 33 f2 ff ff       	call   c0106db9 <page_ref>
c0107b86:	83 c4 10             	add    $0x10,%esp
c0107b89:	83 f8 01             	cmp    $0x1,%eax
c0107b8c:	74 19                	je     c0107ba7 <check_pgdir+0x161>
c0107b8e:	68 5f b8 10 c0       	push   $0xc010b85f
c0107b93:	68 05 b7 10 c0       	push   $0xc010b705
c0107b98:	68 2e 02 00 00       	push   $0x22e
c0107b9d:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107ba2:	e8 51 88 ff ff       	call   c01003f8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0107ba7:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107bac:	8b 00                	mov    (%eax),%eax
c0107bae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bb9:	c1 e8 0c             	shr    $0xc,%eax
c0107bbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107bbf:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107bc4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107bc7:	72 17                	jb     c0107be0 <check_pgdir+0x19a>
c0107bc9:	ff 75 ec             	pushl  -0x14(%ebp)
c0107bcc:	68 18 b6 10 c0       	push   $0xc010b618
c0107bd1:	68 30 02 00 00       	push   $0x230
c0107bd6:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107bdb:	e8 18 88 ff ff       	call   c01003f8 <__panic>
c0107be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107be3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107be8:	83 c0 04             	add    $0x4,%eax
c0107beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0107bee:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107bf3:	83 ec 04             	sub    $0x4,%esp
c0107bf6:	6a 00                	push   $0x0
c0107bf8:	68 00 10 00 00       	push   $0x1000
c0107bfd:	50                   	push   %eax
c0107bfe:	e8 30 fa ff ff       	call   c0107633 <get_pte>
c0107c03:	83 c4 10             	add    $0x10,%esp
c0107c06:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107c09:	74 19                	je     c0107c24 <check_pgdir+0x1de>
c0107c0b:	68 74 b8 10 c0       	push   $0xc010b874
c0107c10:	68 05 b7 10 c0       	push   $0xc010b705
c0107c15:	68 31 02 00 00       	push   $0x231
c0107c1a:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107c1f:	e8 d4 87 ff ff       	call   c01003f8 <__panic>

    p2 = alloc_page();
c0107c24:	83 ec 0c             	sub    $0xc,%esp
c0107c27:	6a 01                	push   $0x1
c0107c29:	e8 99 f3 ff ff       	call   c0106fc7 <alloc_pages>
c0107c2e:	83 c4 10             	add    $0x10,%esp
c0107c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107c34:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107c39:	6a 06                	push   $0x6
c0107c3b:	68 00 10 00 00       	push   $0x1000
c0107c40:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107c43:	50                   	push   %eax
c0107c44:	e8 29 fc ff ff       	call   c0107872 <page_insert>
c0107c49:	83 c4 10             	add    $0x10,%esp
c0107c4c:	85 c0                	test   %eax,%eax
c0107c4e:	74 19                	je     c0107c69 <check_pgdir+0x223>
c0107c50:	68 9c b8 10 c0       	push   $0xc010b89c
c0107c55:	68 05 b7 10 c0       	push   $0xc010b705
c0107c5a:	68 34 02 00 00       	push   $0x234
c0107c5f:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107c64:	e8 8f 87 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107c69:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107c6e:	83 ec 04             	sub    $0x4,%esp
c0107c71:	6a 00                	push   $0x0
c0107c73:	68 00 10 00 00       	push   $0x1000
c0107c78:	50                   	push   %eax
c0107c79:	e8 b5 f9 ff ff       	call   c0107633 <get_pte>
c0107c7e:	83 c4 10             	add    $0x10,%esp
c0107c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107c84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107c88:	75 19                	jne    c0107ca3 <check_pgdir+0x25d>
c0107c8a:	68 d4 b8 10 c0       	push   $0xc010b8d4
c0107c8f:	68 05 b7 10 c0       	push   $0xc010b705
c0107c94:	68 35 02 00 00       	push   $0x235
c0107c99:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107c9e:	e8 55 87 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_U);
c0107ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ca6:	8b 00                	mov    (%eax),%eax
c0107ca8:	83 e0 04             	and    $0x4,%eax
c0107cab:	85 c0                	test   %eax,%eax
c0107cad:	75 19                	jne    c0107cc8 <check_pgdir+0x282>
c0107caf:	68 04 b9 10 c0       	push   $0xc010b904
c0107cb4:	68 05 b7 10 c0       	push   $0xc010b705
c0107cb9:	68 36 02 00 00       	push   $0x236
c0107cbe:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107cc3:	e8 30 87 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_W);
c0107cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ccb:	8b 00                	mov    (%eax),%eax
c0107ccd:	83 e0 02             	and    $0x2,%eax
c0107cd0:	85 c0                	test   %eax,%eax
c0107cd2:	75 19                	jne    c0107ced <check_pgdir+0x2a7>
c0107cd4:	68 12 b9 10 c0       	push   $0xc010b912
c0107cd9:	68 05 b7 10 c0       	push   $0xc010b705
c0107cde:	68 37 02 00 00       	push   $0x237
c0107ce3:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107ce8:	e8 0b 87 ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0107ced:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107cf2:	8b 00                	mov    (%eax),%eax
c0107cf4:	83 e0 04             	and    $0x4,%eax
c0107cf7:	85 c0                	test   %eax,%eax
c0107cf9:	75 19                	jne    c0107d14 <check_pgdir+0x2ce>
c0107cfb:	68 20 b9 10 c0       	push   $0xc010b920
c0107d00:	68 05 b7 10 c0       	push   $0xc010b705
c0107d05:	68 38 02 00 00       	push   $0x238
c0107d0a:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107d0f:	e8 e4 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 1);
c0107d14:	83 ec 0c             	sub    $0xc,%esp
c0107d17:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107d1a:	e8 9a f0 ff ff       	call   c0106db9 <page_ref>
c0107d1f:	83 c4 10             	add    $0x10,%esp
c0107d22:	83 f8 01             	cmp    $0x1,%eax
c0107d25:	74 19                	je     c0107d40 <check_pgdir+0x2fa>
c0107d27:	68 36 b9 10 c0       	push   $0xc010b936
c0107d2c:	68 05 b7 10 c0       	push   $0xc010b705
c0107d31:	68 39 02 00 00       	push   $0x239
c0107d36:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107d3b:	e8 b8 86 ff ff       	call   c01003f8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107d40:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107d45:	6a 00                	push   $0x0
c0107d47:	68 00 10 00 00       	push   $0x1000
c0107d4c:	ff 75 f4             	pushl  -0xc(%ebp)
c0107d4f:	50                   	push   %eax
c0107d50:	e8 1d fb ff ff       	call   c0107872 <page_insert>
c0107d55:	83 c4 10             	add    $0x10,%esp
c0107d58:	85 c0                	test   %eax,%eax
c0107d5a:	74 19                	je     c0107d75 <check_pgdir+0x32f>
c0107d5c:	68 48 b9 10 c0       	push   $0xc010b948
c0107d61:	68 05 b7 10 c0       	push   $0xc010b705
c0107d66:	68 3b 02 00 00       	push   $0x23b
c0107d6b:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107d70:	e8 83 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 2);
c0107d75:	83 ec 0c             	sub    $0xc,%esp
c0107d78:	ff 75 f4             	pushl  -0xc(%ebp)
c0107d7b:	e8 39 f0 ff ff       	call   c0106db9 <page_ref>
c0107d80:	83 c4 10             	add    $0x10,%esp
c0107d83:	83 f8 02             	cmp    $0x2,%eax
c0107d86:	74 19                	je     c0107da1 <check_pgdir+0x35b>
c0107d88:	68 74 b9 10 c0       	push   $0xc010b974
c0107d8d:	68 05 b7 10 c0       	push   $0xc010b705
c0107d92:	68 3c 02 00 00       	push   $0x23c
c0107d97:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107d9c:	e8 57 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107da1:	83 ec 0c             	sub    $0xc,%esp
c0107da4:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107da7:	e8 0d f0 ff ff       	call   c0106db9 <page_ref>
c0107dac:	83 c4 10             	add    $0x10,%esp
c0107daf:	85 c0                	test   %eax,%eax
c0107db1:	74 19                	je     c0107dcc <check_pgdir+0x386>
c0107db3:	68 86 b9 10 c0       	push   $0xc010b986
c0107db8:	68 05 b7 10 c0       	push   $0xc010b705
c0107dbd:	68 3d 02 00 00       	push   $0x23d
c0107dc2:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107dc7:	e8 2c 86 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107dcc:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107dd1:	83 ec 04             	sub    $0x4,%esp
c0107dd4:	6a 00                	push   $0x0
c0107dd6:	68 00 10 00 00       	push   $0x1000
c0107ddb:	50                   	push   %eax
c0107ddc:	e8 52 f8 ff ff       	call   c0107633 <get_pte>
c0107de1:	83 c4 10             	add    $0x10,%esp
c0107de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107deb:	75 19                	jne    c0107e06 <check_pgdir+0x3c0>
c0107ded:	68 d4 b8 10 c0       	push   $0xc010b8d4
c0107df2:	68 05 b7 10 c0       	push   $0xc010b705
c0107df7:	68 3e 02 00 00       	push   $0x23e
c0107dfc:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107e01:	e8 f2 85 ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c0107e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e09:	8b 00                	mov    (%eax),%eax
c0107e0b:	83 ec 0c             	sub    $0xc,%esp
c0107e0e:	50                   	push   %eax
c0107e0f:	e8 4f ef ff ff       	call   c0106d63 <pte2page>
c0107e14:	83 c4 10             	add    $0x10,%esp
c0107e17:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107e1a:	74 19                	je     c0107e35 <check_pgdir+0x3ef>
c0107e1c:	68 49 b8 10 c0       	push   $0xc010b849
c0107e21:	68 05 b7 10 c0       	push   $0xc010b705
c0107e26:	68 3f 02 00 00       	push   $0x23f
c0107e2b:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107e30:	e8 c3 85 ff ff       	call   c01003f8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e38:	8b 00                	mov    (%eax),%eax
c0107e3a:	83 e0 04             	and    $0x4,%eax
c0107e3d:	85 c0                	test   %eax,%eax
c0107e3f:	74 19                	je     c0107e5a <check_pgdir+0x414>
c0107e41:	68 98 b9 10 c0       	push   $0xc010b998
c0107e46:	68 05 b7 10 c0       	push   $0xc010b705
c0107e4b:	68 40 02 00 00       	push   $0x240
c0107e50:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107e55:	e8 9e 85 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0107e5a:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107e5f:	83 ec 08             	sub    $0x8,%esp
c0107e62:	6a 00                	push   $0x0
c0107e64:	50                   	push   %eax
c0107e65:	e8 cf f9 ff ff       	call   c0107839 <page_remove>
c0107e6a:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0107e6d:	83 ec 0c             	sub    $0xc,%esp
c0107e70:	ff 75 f4             	pushl  -0xc(%ebp)
c0107e73:	e8 41 ef ff ff       	call   c0106db9 <page_ref>
c0107e78:	83 c4 10             	add    $0x10,%esp
c0107e7b:	83 f8 01             	cmp    $0x1,%eax
c0107e7e:	74 19                	je     c0107e99 <check_pgdir+0x453>
c0107e80:	68 5f b8 10 c0       	push   $0xc010b85f
c0107e85:	68 05 b7 10 c0       	push   $0xc010b705
c0107e8a:	68 43 02 00 00       	push   $0x243
c0107e8f:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107e94:	e8 5f 85 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107e99:	83 ec 0c             	sub    $0xc,%esp
c0107e9c:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107e9f:	e8 15 ef ff ff       	call   c0106db9 <page_ref>
c0107ea4:	83 c4 10             	add    $0x10,%esp
c0107ea7:	85 c0                	test   %eax,%eax
c0107ea9:	74 19                	je     c0107ec4 <check_pgdir+0x47e>
c0107eab:	68 86 b9 10 c0       	push   $0xc010b986
c0107eb0:	68 05 b7 10 c0       	push   $0xc010b705
c0107eb5:	68 44 02 00 00       	push   $0x244
c0107eba:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107ebf:	e8 34 85 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107ec4:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107ec9:	83 ec 08             	sub    $0x8,%esp
c0107ecc:	68 00 10 00 00       	push   $0x1000
c0107ed1:	50                   	push   %eax
c0107ed2:	e8 62 f9 ff ff       	call   c0107839 <page_remove>
c0107ed7:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0107eda:	83 ec 0c             	sub    $0xc,%esp
c0107edd:	ff 75 f4             	pushl  -0xc(%ebp)
c0107ee0:	e8 d4 ee ff ff       	call   c0106db9 <page_ref>
c0107ee5:	83 c4 10             	add    $0x10,%esp
c0107ee8:	85 c0                	test   %eax,%eax
c0107eea:	74 19                	je     c0107f05 <check_pgdir+0x4bf>
c0107eec:	68 ad b9 10 c0       	push   $0xc010b9ad
c0107ef1:	68 05 b7 10 c0       	push   $0xc010b705
c0107ef6:	68 47 02 00 00       	push   $0x247
c0107efb:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107f00:	e8 f3 84 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107f05:	83 ec 0c             	sub    $0xc,%esp
c0107f08:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107f0b:	e8 a9 ee ff ff       	call   c0106db9 <page_ref>
c0107f10:	83 c4 10             	add    $0x10,%esp
c0107f13:	85 c0                	test   %eax,%eax
c0107f15:	74 19                	je     c0107f30 <check_pgdir+0x4ea>
c0107f17:	68 86 b9 10 c0       	push   $0xc010b986
c0107f1c:	68 05 b7 10 c0       	push   $0xc010b705
c0107f21:	68 48 02 00 00       	push   $0x248
c0107f26:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107f2b:	e8 c8 84 ff ff       	call   c01003f8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107f30:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107f35:	8b 00                	mov    (%eax),%eax
c0107f37:	83 ec 0c             	sub    $0xc,%esp
c0107f3a:	50                   	push   %eax
c0107f3b:	e8 5d ee ff ff       	call   c0106d9d <pde2page>
c0107f40:	83 c4 10             	add    $0x10,%esp
c0107f43:	83 ec 0c             	sub    $0xc,%esp
c0107f46:	50                   	push   %eax
c0107f47:	e8 6d ee ff ff       	call   c0106db9 <page_ref>
c0107f4c:	83 c4 10             	add    $0x10,%esp
c0107f4f:	83 f8 01             	cmp    $0x1,%eax
c0107f52:	74 19                	je     c0107f6d <check_pgdir+0x527>
c0107f54:	68 c0 b9 10 c0       	push   $0xc010b9c0
c0107f59:	68 05 b7 10 c0       	push   $0xc010b705
c0107f5e:	68 4a 02 00 00       	push   $0x24a
c0107f63:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107f68:	e8 8b 84 ff ff       	call   c01003f8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0107f6d:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107f72:	8b 00                	mov    (%eax),%eax
c0107f74:	83 ec 0c             	sub    $0xc,%esp
c0107f77:	50                   	push   %eax
c0107f78:	e8 20 ee ff ff       	call   c0106d9d <pde2page>
c0107f7d:	83 c4 10             	add    $0x10,%esp
c0107f80:	83 ec 08             	sub    $0x8,%esp
c0107f83:	6a 01                	push   $0x1
c0107f85:	50                   	push   %eax
c0107f86:	e8 a8 f0 ff ff       	call   c0107033 <free_pages>
c0107f8b:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0107f8e:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0107f99:	83 ec 0c             	sub    $0xc,%esp
c0107f9c:	68 e7 b9 10 c0       	push   $0xc010b9e7
c0107fa1:	e8 ec 82 ff ff       	call   c0100292 <cprintf>
c0107fa6:	83 c4 10             	add    $0x10,%esp
}
c0107fa9:	90                   	nop
c0107faa:	c9                   	leave  
c0107fab:	c3                   	ret    

c0107fac <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0107fac:	55                   	push   %ebp
c0107fad:	89 e5                	mov    %esp,%ebp
c0107faf:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107fb9:	e9 a3 00 00 00       	jmp    c0108061 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107fc7:	c1 e8 0c             	shr    $0xc,%eax
c0107fca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107fcd:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0107fd2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107fd5:	72 17                	jb     c0107fee <check_boot_pgdir+0x42>
c0107fd7:	ff 75 f0             	pushl  -0x10(%ebp)
c0107fda:	68 18 b6 10 c0       	push   $0xc010b618
c0107fdf:	68 56 02 00 00       	push   $0x256
c0107fe4:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0107fe9:	e8 0a 84 ff ff       	call   c01003f8 <__panic>
c0107fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ff1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107ff6:	89 c2                	mov    %eax,%edx
c0107ff8:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0107ffd:	83 ec 04             	sub    $0x4,%esp
c0108000:	6a 00                	push   $0x0
c0108002:	52                   	push   %edx
c0108003:	50                   	push   %eax
c0108004:	e8 2a f6 ff ff       	call   c0107633 <get_pte>
c0108009:	83 c4 10             	add    $0x10,%esp
c010800c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010800f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108013:	75 19                	jne    c010802e <check_boot_pgdir+0x82>
c0108015:	68 04 ba 10 c0       	push   $0xc010ba04
c010801a:	68 05 b7 10 c0       	push   $0xc010b705
c010801f:	68 56 02 00 00       	push   $0x256
c0108024:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0108029:	e8 ca 83 ff ff       	call   c01003f8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010802e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108031:	8b 00                	mov    (%eax),%eax
c0108033:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108038:	89 c2                	mov    %eax,%edx
c010803a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010803d:	39 c2                	cmp    %eax,%edx
c010803f:	74 19                	je     c010805a <check_boot_pgdir+0xae>
c0108041:	68 41 ba 10 c0       	push   $0xc010ba41
c0108046:	68 05 b7 10 c0       	push   $0xc010b705
c010804b:	68 57 02 00 00       	push   $0x257
c0108050:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0108055:	e8 9e 83 ff ff       	call   c01003f8 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010805a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0108061:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108064:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0108069:	39 c2                	cmp    %eax,%edx
c010806b:	0f 82 4d ff ff ff    	jb     c0107fbe <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0108071:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0108076:	05 ac 0f 00 00       	add    $0xfac,%eax
c010807b:	8b 00                	mov    (%eax),%eax
c010807d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108082:	89 c2                	mov    %eax,%edx
c0108084:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c0108089:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010808c:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0108093:	77 17                	ja     c01080ac <check_boot_pgdir+0x100>
c0108095:	ff 75 e4             	pushl  -0x1c(%ebp)
c0108098:	68 bc b6 10 c0       	push   $0xc010b6bc
c010809d:	68 5a 02 00 00       	push   $0x25a
c01080a2:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01080a7:	e8 4c 83 ff ff       	call   c01003f8 <__panic>
c01080ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080af:	05 00 00 00 40       	add    $0x40000000,%eax
c01080b4:	39 c2                	cmp    %eax,%edx
c01080b6:	74 19                	je     c01080d1 <check_boot_pgdir+0x125>
c01080b8:	68 58 ba 10 c0       	push   $0xc010ba58
c01080bd:	68 05 b7 10 c0       	push   $0xc010b705
c01080c2:	68 5a 02 00 00       	push   $0x25a
c01080c7:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01080cc:	e8 27 83 ff ff       	call   c01003f8 <__panic>

    assert(boot_pgdir[0] == 0);
c01080d1:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c01080d6:	8b 00                	mov    (%eax),%eax
c01080d8:	85 c0                	test   %eax,%eax
c01080da:	74 19                	je     c01080f5 <check_boot_pgdir+0x149>
c01080dc:	68 8c ba 10 c0       	push   $0xc010ba8c
c01080e1:	68 05 b7 10 c0       	push   $0xc010b705
c01080e6:	68 5c 02 00 00       	push   $0x25c
c01080eb:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01080f0:	e8 03 83 ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    p = alloc_page();
c01080f5:	83 ec 0c             	sub    $0xc,%esp
c01080f8:	6a 01                	push   $0x1
c01080fa:	e8 c8 ee ff ff       	call   c0106fc7 <alloc_pages>
c01080ff:	83 c4 10             	add    $0x10,%esp
c0108102:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0108105:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010810a:	6a 02                	push   $0x2
c010810c:	68 00 01 00 00       	push   $0x100
c0108111:	ff 75 e0             	pushl  -0x20(%ebp)
c0108114:	50                   	push   %eax
c0108115:	e8 58 f7 ff ff       	call   c0107872 <page_insert>
c010811a:	83 c4 10             	add    $0x10,%esp
c010811d:	85 c0                	test   %eax,%eax
c010811f:	74 19                	je     c010813a <check_boot_pgdir+0x18e>
c0108121:	68 a0 ba 10 c0       	push   $0xc010baa0
c0108126:	68 05 b7 10 c0       	push   $0xc010b705
c010812b:	68 60 02 00 00       	push   $0x260
c0108130:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0108135:	e8 be 82 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 1);
c010813a:	83 ec 0c             	sub    $0xc,%esp
c010813d:	ff 75 e0             	pushl  -0x20(%ebp)
c0108140:	e8 74 ec ff ff       	call   c0106db9 <page_ref>
c0108145:	83 c4 10             	add    $0x10,%esp
c0108148:	83 f8 01             	cmp    $0x1,%eax
c010814b:	74 19                	je     c0108166 <check_boot_pgdir+0x1ba>
c010814d:	68 ce ba 10 c0       	push   $0xc010bace
c0108152:	68 05 b7 10 c0       	push   $0xc010b705
c0108157:	68 61 02 00 00       	push   $0x261
c010815c:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0108161:	e8 92 82 ff ff       	call   c01003f8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0108166:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010816b:	6a 02                	push   $0x2
c010816d:	68 00 11 00 00       	push   $0x1100
c0108172:	ff 75 e0             	pushl  -0x20(%ebp)
c0108175:	50                   	push   %eax
c0108176:	e8 f7 f6 ff ff       	call   c0107872 <page_insert>
c010817b:	83 c4 10             	add    $0x10,%esp
c010817e:	85 c0                	test   %eax,%eax
c0108180:	74 19                	je     c010819b <check_boot_pgdir+0x1ef>
c0108182:	68 e0 ba 10 c0       	push   $0xc010bae0
c0108187:	68 05 b7 10 c0       	push   $0xc010b705
c010818c:	68 62 02 00 00       	push   $0x262
c0108191:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0108196:	e8 5d 82 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 2);
c010819b:	83 ec 0c             	sub    $0xc,%esp
c010819e:	ff 75 e0             	pushl  -0x20(%ebp)
c01081a1:	e8 13 ec ff ff       	call   c0106db9 <page_ref>
c01081a6:	83 c4 10             	add    $0x10,%esp
c01081a9:	83 f8 02             	cmp    $0x2,%eax
c01081ac:	74 19                	je     c01081c7 <check_boot_pgdir+0x21b>
c01081ae:	68 17 bb 10 c0       	push   $0xc010bb17
c01081b3:	68 05 b7 10 c0       	push   $0xc010b705
c01081b8:	68 63 02 00 00       	push   $0x263
c01081bd:	68 e0 b6 10 c0       	push   $0xc010b6e0
c01081c2:	e8 31 82 ff ff       	call   c01003f8 <__panic>

    const char *str = "ucore: Hello world!!";
c01081c7:	c7 45 dc 28 bb 10 c0 	movl   $0xc010bb28,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01081ce:	83 ec 08             	sub    $0x8,%esp
c01081d1:	ff 75 dc             	pushl  -0x24(%ebp)
c01081d4:	68 00 01 00 00       	push   $0x100
c01081d9:	e8 7b 0e 00 00       	call   c0109059 <strcpy>
c01081de:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01081e1:	83 ec 08             	sub    $0x8,%esp
c01081e4:	68 00 11 00 00       	push   $0x1100
c01081e9:	68 00 01 00 00       	push   $0x100
c01081ee:	e8 e0 0e 00 00       	call   c01090d3 <strcmp>
c01081f3:	83 c4 10             	add    $0x10,%esp
c01081f6:	85 c0                	test   %eax,%eax
c01081f8:	74 19                	je     c0108213 <check_boot_pgdir+0x267>
c01081fa:	68 40 bb 10 c0       	push   $0xc010bb40
c01081ff:	68 05 b7 10 c0       	push   $0xc010b705
c0108204:	68 67 02 00 00       	push   $0x267
c0108209:	68 e0 b6 10 c0       	push   $0xc010b6e0
c010820e:	e8 e5 81 ff ff       	call   c01003f8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0108213:	83 ec 0c             	sub    $0xc,%esp
c0108216:	ff 75 e0             	pushl  -0x20(%ebp)
c0108219:	e8 00 eb ff ff       	call   c0106d1e <page2kva>
c010821e:	83 c4 10             	add    $0x10,%esp
c0108221:	05 00 01 00 00       	add    $0x100,%eax
c0108226:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0108229:	83 ec 0c             	sub    $0xc,%esp
c010822c:	68 00 01 00 00       	push   $0x100
c0108231:	e8 cb 0d 00 00       	call   c0109001 <strlen>
c0108236:	83 c4 10             	add    $0x10,%esp
c0108239:	85 c0                	test   %eax,%eax
c010823b:	74 19                	je     c0108256 <check_boot_pgdir+0x2aa>
c010823d:	68 78 bb 10 c0       	push   $0xc010bb78
c0108242:	68 05 b7 10 c0       	push   $0xc010b705
c0108247:	68 6a 02 00 00       	push   $0x26a
c010824c:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0108251:	e8 a2 81 ff ff       	call   c01003f8 <__panic>

    free_page(p);
c0108256:	83 ec 08             	sub    $0x8,%esp
c0108259:	6a 01                	push   $0x1
c010825b:	ff 75 e0             	pushl  -0x20(%ebp)
c010825e:	e8 d0 ed ff ff       	call   c0107033 <free_pages>
c0108263:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0108266:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010826b:	8b 00                	mov    (%eax),%eax
c010826d:	83 ec 0c             	sub    $0xc,%esp
c0108270:	50                   	push   %eax
c0108271:	e8 27 eb ff ff       	call   c0106d9d <pde2page>
c0108276:	83 c4 10             	add    $0x10,%esp
c0108279:	83 ec 08             	sub    $0x8,%esp
c010827c:	6a 01                	push   $0x1
c010827e:	50                   	push   %eax
c010827f:	e8 af ed ff ff       	call   c0107033 <free_pages>
c0108284:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0108287:	a1 60 6a 12 c0       	mov    0xc0126a60,%eax
c010828c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0108292:	83 ec 0c             	sub    $0xc,%esp
c0108295:	68 9c bb 10 c0       	push   $0xc010bb9c
c010829a:	e8 f3 7f ff ff       	call   c0100292 <cprintf>
c010829f:	83 c4 10             	add    $0x10,%esp
}
c01082a2:	90                   	nop
c01082a3:	c9                   	leave  
c01082a4:	c3                   	ret    

c01082a5 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01082a5:	55                   	push   %ebp
c01082a6:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01082a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01082ab:	83 e0 04             	and    $0x4,%eax
c01082ae:	85 c0                	test   %eax,%eax
c01082b0:	74 07                	je     c01082b9 <perm2str+0x14>
c01082b2:	b8 75 00 00 00       	mov    $0x75,%eax
c01082b7:	eb 05                	jmp    c01082be <perm2str+0x19>
c01082b9:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01082be:	a2 08 a0 12 c0       	mov    %al,0xc012a008
    str[1] = 'r';
c01082c3:	c6 05 09 a0 12 c0 72 	movb   $0x72,0xc012a009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01082ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01082cd:	83 e0 02             	and    $0x2,%eax
c01082d0:	85 c0                	test   %eax,%eax
c01082d2:	74 07                	je     c01082db <perm2str+0x36>
c01082d4:	b8 77 00 00 00       	mov    $0x77,%eax
c01082d9:	eb 05                	jmp    c01082e0 <perm2str+0x3b>
c01082db:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01082e0:	a2 0a a0 12 c0       	mov    %al,0xc012a00a
    str[3] = '\0';
c01082e5:	c6 05 0b a0 12 c0 00 	movb   $0x0,0xc012a00b
    return str;
c01082ec:	b8 08 a0 12 c0       	mov    $0xc012a008,%eax
}
c01082f1:	5d                   	pop    %ebp
c01082f2:	c3                   	ret    

c01082f3 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01082f3:	55                   	push   %ebp
c01082f4:	89 e5                	mov    %esp,%ebp
c01082f6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01082f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01082fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01082ff:	72 0e                	jb     c010830f <get_pgtable_items+0x1c>
        return 0;
c0108301:	b8 00 00 00 00       	mov    $0x0,%eax
c0108306:	e9 9a 00 00 00       	jmp    c01083a5 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010830b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010830f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108312:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108315:	73 18                	jae    c010832f <get_pgtable_items+0x3c>
c0108317:	8b 45 10             	mov    0x10(%ebp),%eax
c010831a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108321:	8b 45 14             	mov    0x14(%ebp),%eax
c0108324:	01 d0                	add    %edx,%eax
c0108326:	8b 00                	mov    (%eax),%eax
c0108328:	83 e0 01             	and    $0x1,%eax
c010832b:	85 c0                	test   %eax,%eax
c010832d:	74 dc                	je     c010830b <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c010832f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108332:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108335:	73 69                	jae    c01083a0 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0108337:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010833b:	74 08                	je     c0108345 <get_pgtable_items+0x52>
            *left_store = start;
c010833d:	8b 45 18             	mov    0x18(%ebp),%eax
c0108340:	8b 55 10             	mov    0x10(%ebp),%edx
c0108343:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0108345:	8b 45 10             	mov    0x10(%ebp),%eax
c0108348:	8d 50 01             	lea    0x1(%eax),%edx
c010834b:	89 55 10             	mov    %edx,0x10(%ebp)
c010834e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108355:	8b 45 14             	mov    0x14(%ebp),%eax
c0108358:	01 d0                	add    %edx,%eax
c010835a:	8b 00                	mov    (%eax),%eax
c010835c:	83 e0 07             	and    $0x7,%eax
c010835f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108362:	eb 04                	jmp    c0108368 <get_pgtable_items+0x75>
            start ++;
c0108364:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108368:	8b 45 10             	mov    0x10(%ebp),%eax
c010836b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010836e:	73 1d                	jae    c010838d <get_pgtable_items+0x9a>
c0108370:	8b 45 10             	mov    0x10(%ebp),%eax
c0108373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010837a:	8b 45 14             	mov    0x14(%ebp),%eax
c010837d:	01 d0                	add    %edx,%eax
c010837f:	8b 00                	mov    (%eax),%eax
c0108381:	83 e0 07             	and    $0x7,%eax
c0108384:	89 c2                	mov    %eax,%edx
c0108386:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108389:	39 c2                	cmp    %eax,%edx
c010838b:	74 d7                	je     c0108364 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c010838d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108391:	74 08                	je     c010839b <get_pgtable_items+0xa8>
            *right_store = start;
c0108393:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108396:	8b 55 10             	mov    0x10(%ebp),%edx
c0108399:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010839b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010839e:	eb 05                	jmp    c01083a5 <get_pgtable_items+0xb2>
    }
    return 0;
c01083a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01083a5:	c9                   	leave  
c01083a6:	c3                   	ret    

c01083a7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01083a7:	55                   	push   %ebp
c01083a8:	89 e5                	mov    %esp,%ebp
c01083aa:	57                   	push   %edi
c01083ab:	56                   	push   %esi
c01083ac:	53                   	push   %ebx
c01083ad:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01083b0:	83 ec 0c             	sub    $0xc,%esp
c01083b3:	68 bc bb 10 c0       	push   $0xc010bbbc
c01083b8:	e8 d5 7e ff ff       	call   c0100292 <cprintf>
c01083bd:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c01083c0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01083c7:	e9 e5 00 00 00       	jmp    c01084b1 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01083cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083cf:	83 ec 0c             	sub    $0xc,%esp
c01083d2:	50                   	push   %eax
c01083d3:	e8 cd fe ff ff       	call   c01082a5 <perm2str>
c01083d8:	83 c4 10             	add    $0x10,%esp
c01083db:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01083dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01083e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083e3:	29 c2                	sub    %eax,%edx
c01083e5:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01083e7:	c1 e0 16             	shl    $0x16,%eax
c01083ea:	89 c3                	mov    %eax,%ebx
c01083ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01083ef:	c1 e0 16             	shl    $0x16,%eax
c01083f2:	89 c1                	mov    %eax,%ecx
c01083f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083f7:	c1 e0 16             	shl    $0x16,%eax
c01083fa:	89 c2                	mov    %eax,%edx
c01083fc:	8b 75 dc             	mov    -0x24(%ebp),%esi
c01083ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108402:	29 c6                	sub    %eax,%esi
c0108404:	89 f0                	mov    %esi,%eax
c0108406:	83 ec 08             	sub    $0x8,%esp
c0108409:	57                   	push   %edi
c010840a:	53                   	push   %ebx
c010840b:	51                   	push   %ecx
c010840c:	52                   	push   %edx
c010840d:	50                   	push   %eax
c010840e:	68 ed bb 10 c0       	push   $0xc010bbed
c0108413:	e8 7a 7e ff ff       	call   c0100292 <cprintf>
c0108418:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010841b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010841e:	c1 e0 0a             	shl    $0xa,%eax
c0108421:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108424:	eb 4f                	jmp    c0108475 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0108426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108429:	83 ec 0c             	sub    $0xc,%esp
c010842c:	50                   	push   %eax
c010842d:	e8 73 fe ff ff       	call   c01082a5 <perm2str>
c0108432:	83 c4 10             	add    $0x10,%esp
c0108435:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0108437:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010843a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010843d:	29 c2                	sub    %eax,%edx
c010843f:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0108441:	c1 e0 0c             	shl    $0xc,%eax
c0108444:	89 c3                	mov    %eax,%ebx
c0108446:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108449:	c1 e0 0c             	shl    $0xc,%eax
c010844c:	89 c1                	mov    %eax,%ecx
c010844e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108451:	c1 e0 0c             	shl    $0xc,%eax
c0108454:	89 c2                	mov    %eax,%edx
c0108456:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0108459:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010845c:	29 c6                	sub    %eax,%esi
c010845e:	89 f0                	mov    %esi,%eax
c0108460:	83 ec 08             	sub    $0x8,%esp
c0108463:	57                   	push   %edi
c0108464:	53                   	push   %ebx
c0108465:	51                   	push   %ecx
c0108466:	52                   	push   %edx
c0108467:	50                   	push   %eax
c0108468:	68 0c bc 10 c0       	push   $0xc010bc0c
c010846d:	e8 20 7e ff ff       	call   c0100292 <cprintf>
c0108472:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108475:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010847a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010847d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108480:	89 d3                	mov    %edx,%ebx
c0108482:	c1 e3 0a             	shl    $0xa,%ebx
c0108485:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108488:	89 d1                	mov    %edx,%ecx
c010848a:	c1 e1 0a             	shl    $0xa,%ecx
c010848d:	83 ec 08             	sub    $0x8,%esp
c0108490:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0108493:	52                   	push   %edx
c0108494:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0108497:	52                   	push   %edx
c0108498:	56                   	push   %esi
c0108499:	50                   	push   %eax
c010849a:	53                   	push   %ebx
c010849b:	51                   	push   %ecx
c010849c:	e8 52 fe ff ff       	call   c01082f3 <get_pgtable_items>
c01084a1:	83 c4 20             	add    $0x20,%esp
c01084a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01084a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084ab:	0f 85 75 ff ff ff    	jne    c0108426 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01084b1:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01084b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084b9:	83 ec 08             	sub    $0x8,%esp
c01084bc:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01084bf:	52                   	push   %edx
c01084c0:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01084c3:	52                   	push   %edx
c01084c4:	51                   	push   %ecx
c01084c5:	50                   	push   %eax
c01084c6:	68 00 04 00 00       	push   $0x400
c01084cb:	6a 00                	push   $0x0
c01084cd:	e8 21 fe ff ff       	call   c01082f3 <get_pgtable_items>
c01084d2:	83 c4 20             	add    $0x20,%esp
c01084d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01084d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01084dc:	0f 85 ea fe ff ff    	jne    c01083cc <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01084e2:	83 ec 0c             	sub    $0xc,%esp
c01084e5:	68 30 bc 10 c0       	push   $0xc010bc30
c01084ea:	e8 a3 7d ff ff       	call   c0100292 <cprintf>
c01084ef:	83 c4 10             	add    $0x10,%esp
}
c01084f2:	90                   	nop
c01084f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01084f6:	5b                   	pop    %ebx
c01084f7:	5e                   	pop    %esi
c01084f8:	5f                   	pop    %edi
c01084f9:	5d                   	pop    %ebp
c01084fa:	c3                   	ret    

c01084fb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01084fb:	55                   	push   %ebp
c01084fc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01084fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0108501:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c0108507:	29 d0                	sub    %edx,%eax
c0108509:	c1 f8 05             	sar    $0x5,%eax
}
c010850c:	5d                   	pop    %ebp
c010850d:	c3                   	ret    

c010850e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010850e:	55                   	push   %ebp
c010850f:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0108511:	ff 75 08             	pushl  0x8(%ebp)
c0108514:	e8 e2 ff ff ff       	call   c01084fb <page2ppn>
c0108519:	83 c4 04             	add    $0x4,%esp
c010851c:	c1 e0 0c             	shl    $0xc,%eax
}
c010851f:	c9                   	leave  
c0108520:	c3                   	ret    

c0108521 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108521:	55                   	push   %ebp
c0108522:	89 e5                	mov    %esp,%ebp
c0108524:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0108527:	ff 75 08             	pushl  0x8(%ebp)
c010852a:	e8 df ff ff ff       	call   c010850e <page2pa>
c010852f:	83 c4 04             	add    $0x4,%esp
c0108532:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108535:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108538:	c1 e8 0c             	shr    $0xc,%eax
c010853b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010853e:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0108543:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108546:	72 14                	jb     c010855c <page2kva+0x3b>
c0108548:	ff 75 f4             	pushl  -0xc(%ebp)
c010854b:	68 64 bc 10 c0       	push   $0xc010bc64
c0108550:	6a 66                	push   $0x66
c0108552:	68 87 bc 10 c0       	push   $0xc010bc87
c0108557:	e8 9c 7e ff ff       	call   c01003f8 <__panic>
c010855c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010855f:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108564:	c9                   	leave  
c0108565:	c3                   	ret    

c0108566 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108566:	55                   	push   %ebp
c0108567:	89 e5                	mov    %esp,%ebp
c0108569:	83 ec 08             	sub    $0x8,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010856c:	83 ec 0c             	sub    $0xc,%esp
c010856f:	6a 01                	push   $0x1
c0108571:	e8 87 8b ff ff       	call   c01010fd <ide_device_valid>
c0108576:	83 c4 10             	add    $0x10,%esp
c0108579:	85 c0                	test   %eax,%eax
c010857b:	75 14                	jne    c0108591 <swapfs_init+0x2b>
        panic("swap fs isn't available.\n");
c010857d:	83 ec 04             	sub    $0x4,%esp
c0108580:	68 95 bc 10 c0       	push   $0xc010bc95
c0108585:	6a 0d                	push   $0xd
c0108587:	68 af bc 10 c0       	push   $0xc010bcaf
c010858c:	e8 67 7e ff ff       	call   c01003f8 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108591:	83 ec 0c             	sub    $0xc,%esp
c0108594:	6a 01                	push   $0x1
c0108596:	e8 a2 8b ff ff       	call   c010113d <ide_device_size>
c010859b:	83 c4 10             	add    $0x10,%esp
c010859e:	c1 e8 03             	shr    $0x3,%eax
c01085a1:	a3 5c c1 12 c0       	mov    %eax,0xc012c15c
}
c01085a6:	90                   	nop
c01085a7:	c9                   	leave  
c01085a8:	c3                   	ret    

c01085a9 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01085a9:	55                   	push   %ebp
c01085aa:	89 e5                	mov    %esp,%ebp
c01085ac:	83 ec 18             	sub    $0x18,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01085af:	83 ec 0c             	sub    $0xc,%esp
c01085b2:	ff 75 0c             	pushl  0xc(%ebp)
c01085b5:	e8 67 ff ff ff       	call   c0108521 <page2kva>
c01085ba:	83 c4 10             	add    $0x10,%esp
c01085bd:	89 c2                	mov    %eax,%edx
c01085bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01085c2:	c1 e8 08             	shr    $0x8,%eax
c01085c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01085cc:	74 0a                	je     c01085d8 <swapfs_read+0x2f>
c01085ce:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c01085d3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01085d6:	72 14                	jb     c01085ec <swapfs_read+0x43>
c01085d8:	ff 75 08             	pushl  0x8(%ebp)
c01085db:	68 c0 bc 10 c0       	push   $0xc010bcc0
c01085e0:	6a 14                	push   $0x14
c01085e2:	68 af bc 10 c0       	push   $0xc010bcaf
c01085e7:	e8 0c 7e ff ff       	call   c01003f8 <__panic>
c01085ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085ef:	c1 e0 03             	shl    $0x3,%eax
c01085f2:	6a 08                	push   $0x8
c01085f4:	52                   	push   %edx
c01085f5:	50                   	push   %eax
c01085f6:	6a 01                	push   $0x1
c01085f8:	e8 80 8b ff ff       	call   c010117d <ide_read_secs>
c01085fd:	83 c4 10             	add    $0x10,%esp
}
c0108600:	c9                   	leave  
c0108601:	c3                   	ret    

c0108602 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108602:	55                   	push   %ebp
c0108603:	89 e5                	mov    %esp,%ebp
c0108605:	83 ec 18             	sub    $0x18,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108608:	83 ec 0c             	sub    $0xc,%esp
c010860b:	ff 75 0c             	pushl  0xc(%ebp)
c010860e:	e8 0e ff ff ff       	call   c0108521 <page2kva>
c0108613:	83 c4 10             	add    $0x10,%esp
c0108616:	89 c2                	mov    %eax,%edx
c0108618:	8b 45 08             	mov    0x8(%ebp),%eax
c010861b:	c1 e8 08             	shr    $0x8,%eax
c010861e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108625:	74 0a                	je     c0108631 <swapfs_write+0x2f>
c0108627:	a1 5c c1 12 c0       	mov    0xc012c15c,%eax
c010862c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010862f:	72 14                	jb     c0108645 <swapfs_write+0x43>
c0108631:	ff 75 08             	pushl  0x8(%ebp)
c0108634:	68 c0 bc 10 c0       	push   $0xc010bcc0
c0108639:	6a 19                	push   $0x19
c010863b:	68 af bc 10 c0       	push   $0xc010bcaf
c0108640:	e8 b3 7d ff ff       	call   c01003f8 <__panic>
c0108645:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108648:	c1 e0 03             	shl    $0x3,%eax
c010864b:	6a 08                	push   $0x8
c010864d:	52                   	push   %edx
c010864e:	50                   	push   %eax
c010864f:	6a 01                	push   $0x1
c0108651:	e8 51 8d ff ff       	call   c01013a7 <ide_write_secs>
c0108656:	83 c4 10             	add    $0x10,%esp
}
c0108659:	c9                   	leave  
c010865a:	c3                   	ret    

c010865b <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c010865b:	52                   	push   %edx
    call *%ebx              # call fn
c010865c:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c010865e:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c010865f:	e8 22 06 00 00       	call   c0108c86 <do_exit>

c0108664 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108664:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108668:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)          # save esp::context of from
c010866a:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)          # save ebx::context of from
c010866d:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)         # save ecx::context of from
c0108670:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)         # save edx::context of from
c0108673:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)         # save esi::context of from
c0108676:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)         # save edi::context of from
c0108679:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)         # save ebp::context of from
c010867c:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010867f:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp         # restore ebp::context of to
c0108683:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi         # restore edi::context of to
c0108686:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi         # restore esi::context of to
c0108689:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx         # restore edx::context of to
c010868c:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx         # restore ecx::context of to
c010868f:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx          # restore ebx::context of to
c0108692:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp          # restore esp::context of to
c0108695:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0108698:	ff 30                	pushl  (%eax)

    ret
c010869a:	c3                   	ret    

c010869b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010869b:	55                   	push   %ebp
c010869c:	89 e5                	mov    %esp,%ebp
c010869e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01086a1:	9c                   	pushf  
c01086a2:	58                   	pop    %eax
c01086a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01086a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01086a9:	25 00 02 00 00       	and    $0x200,%eax
c01086ae:	85 c0                	test   %eax,%eax
c01086b0:	74 0c                	je     c01086be <__intr_save+0x23>
        intr_disable();
c01086b2:	e8 29 9a ff ff       	call   c01020e0 <intr_disable>
        return 1;
c01086b7:	b8 01 00 00 00       	mov    $0x1,%eax
c01086bc:	eb 05                	jmp    c01086c3 <__intr_save+0x28>
    }
    return 0;
c01086be:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01086c3:	c9                   	leave  
c01086c4:	c3                   	ret    

c01086c5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01086c5:	55                   	push   %ebp
c01086c6:	89 e5                	mov    %esp,%ebp
c01086c8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01086cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01086cf:	74 05                	je     c01086d6 <__intr_restore+0x11>
        intr_enable();
c01086d1:	e8 03 9a ff ff       	call   c01020d9 <intr_enable>
    }
}
c01086d6:	90                   	nop
c01086d7:	c9                   	leave  
c01086d8:	c3                   	ret    

c01086d9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01086d9:	55                   	push   %ebp
c01086da:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01086dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01086df:	8b 15 98 c1 12 c0    	mov    0xc012c198,%edx
c01086e5:	29 d0                	sub    %edx,%eax
c01086e7:	c1 f8 05             	sar    $0x5,%eax
}
c01086ea:	5d                   	pop    %ebp
c01086eb:	c3                   	ret    

c01086ec <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01086ec:	55                   	push   %ebp
c01086ed:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01086ef:	ff 75 08             	pushl  0x8(%ebp)
c01086f2:	e8 e2 ff ff ff       	call   c01086d9 <page2ppn>
c01086f7:	83 c4 04             	add    $0x4,%esp
c01086fa:	c1 e0 0c             	shl    $0xc,%eax
}
c01086fd:	c9                   	leave  
c01086fe:	c3                   	ret    

c01086ff <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01086ff:	55                   	push   %ebp
c0108700:	89 e5                	mov    %esp,%ebp
c0108702:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0108705:	8b 45 08             	mov    0x8(%ebp),%eax
c0108708:	c1 e8 0c             	shr    $0xc,%eax
c010870b:	89 c2                	mov    %eax,%edx
c010870d:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c0108712:	39 c2                	cmp    %eax,%edx
c0108714:	72 14                	jb     c010872a <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0108716:	83 ec 04             	sub    $0x4,%esp
c0108719:	68 e0 bc 10 c0       	push   $0xc010bce0
c010871e:	6a 5f                	push   $0x5f
c0108720:	68 ff bc 10 c0       	push   $0xc010bcff
c0108725:	e8 ce 7c ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c010872a:	a1 98 c1 12 c0       	mov    0xc012c198,%eax
c010872f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108732:	c1 ea 0c             	shr    $0xc,%edx
c0108735:	c1 e2 05             	shl    $0x5,%edx
c0108738:	01 d0                	add    %edx,%eax
}
c010873a:	c9                   	leave  
c010873b:	c3                   	ret    

c010873c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010873c:	55                   	push   %ebp
c010873d:	89 e5                	mov    %esp,%ebp
c010873f:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0108742:	ff 75 08             	pushl  0x8(%ebp)
c0108745:	e8 a2 ff ff ff       	call   c01086ec <page2pa>
c010874a:	83 c4 04             	add    $0x4,%esp
c010874d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108753:	c1 e8 0c             	shr    $0xc,%eax
c0108756:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108759:	a1 80 9f 12 c0       	mov    0xc0129f80,%eax
c010875e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108761:	72 14                	jb     c0108777 <page2kva+0x3b>
c0108763:	ff 75 f4             	pushl  -0xc(%ebp)
c0108766:	68 10 bd 10 c0       	push   $0xc010bd10
c010876b:	6a 66                	push   $0x66
c010876d:	68 ff bc 10 c0       	push   $0xc010bcff
c0108772:	e8 81 7c ff ff       	call   c01003f8 <__panic>
c0108777:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010877a:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010877f:	c9                   	leave  
c0108780:	c3                   	ret    

c0108781 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0108781:	55                   	push   %ebp
c0108782:	89 e5                	mov    %esp,%ebp
c0108784:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c0108787:	8b 45 08             	mov    0x8(%ebp),%eax
c010878a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010878d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0108794:	77 14                	ja     c01087aa <kva2page+0x29>
c0108796:	ff 75 f4             	pushl  -0xc(%ebp)
c0108799:	68 34 bd 10 c0       	push   $0xc010bd34
c010879e:	6a 6b                	push   $0x6b
c01087a0:	68 ff bc 10 c0       	push   $0xc010bcff
c01087a5:	e8 4e 7c ff ff       	call   c01003f8 <__panic>
c01087aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087ad:	05 00 00 00 40       	add    $0x40000000,%eax
c01087b2:	83 ec 0c             	sub    $0xc,%esp
c01087b5:	50                   	push   %eax
c01087b6:	e8 44 ff ff ff       	call   c01086ff <pa2page>
c01087bb:	83 c4 10             	add    $0x10,%esp
}
c01087be:	c9                   	leave  
c01087bf:	c3                   	ret    

c01087c0 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01087c0:	55                   	push   %ebp
c01087c1:	89 e5                	mov    %esp,%ebp
c01087c3:	83 ec 18             	sub    $0x18,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01087c6:	83 ec 0c             	sub    $0xc,%esp
c01087c9:	6a 68                	push   $0x68
c01087cb:	e8 22 c9 ff ff       	call   c01050f2 <kmalloc>
c01087d0:	83 c4 10             	add    $0x10,%esp
c01087d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
    }
    return proc;
c01087d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01087d9:	c9                   	leave  
c01087da:	c3                   	ret    

c01087db <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01087db:	55                   	push   %ebp
c01087dc:	89 e5                	mov    %esp,%ebp
c01087de:	83 ec 08             	sub    $0x8,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01087e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e4:	83 c0 48             	add    $0x48,%eax
c01087e7:	83 ec 04             	sub    $0x4,%esp
c01087ea:	6a 10                	push   $0x10
c01087ec:	6a 00                	push   $0x0
c01087ee:	50                   	push   %eax
c01087ef:	e8 3e 0b 00 00       	call   c0109332 <memset>
c01087f4:	83 c4 10             	add    $0x10,%esp
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01087f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fa:	83 c0 48             	add    $0x48,%eax
c01087fd:	83 ec 04             	sub    $0x4,%esp
c0108800:	6a 0f                	push   $0xf
c0108802:	ff 75 0c             	pushl  0xc(%ebp)
c0108805:	50                   	push   %eax
c0108806:	e8 0a 0c 00 00       	call   c0109415 <memcpy>
c010880b:	83 c4 10             	add    $0x10,%esp
}
c010880e:	c9                   	leave  
c010880f:	c3                   	ret    

c0108810 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0108810:	55                   	push   %ebp
c0108811:	89 e5                	mov    %esp,%ebp
c0108813:	83 ec 08             	sub    $0x8,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0108816:	83 ec 04             	sub    $0x4,%esp
c0108819:	6a 10                	push   $0x10
c010881b:	6a 00                	push   $0x0
c010881d:	68 44 c0 12 c0       	push   $0xc012c044
c0108822:	e8 0b 0b 00 00       	call   c0109332 <memset>
c0108827:	83 c4 10             	add    $0x10,%esp
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010882a:	8b 45 08             	mov    0x8(%ebp),%eax
c010882d:	83 c0 48             	add    $0x48,%eax
c0108830:	83 ec 04             	sub    $0x4,%esp
c0108833:	6a 0f                	push   $0xf
c0108835:	50                   	push   %eax
c0108836:	68 44 c0 12 c0       	push   $0xc012c044
c010883b:	e8 d5 0b 00 00       	call   c0109415 <memcpy>
c0108840:	83 c4 10             	add    $0x10,%esp
}
c0108843:	c9                   	leave  
c0108844:	c3                   	ret    

c0108845 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0108845:	55                   	push   %ebp
c0108846:	89 e5                	mov    %esp,%ebp
c0108848:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c010884b:	c7 45 f8 9c c1 12 c0 	movl   $0xc012c19c,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0108852:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c0108857:	83 c0 01             	add    $0x1,%eax
c010885a:	a3 b8 6a 12 c0       	mov    %eax,0xc0126ab8
c010885f:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c0108864:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108869:	7e 0c                	jle    c0108877 <get_pid+0x32>
        last_pid = 1;
c010886b:	c7 05 b8 6a 12 c0 01 	movl   $0x1,0xc0126ab8
c0108872:	00 00 00 
        goto inside;
c0108875:	eb 13                	jmp    c010888a <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c0108877:	8b 15 b8 6a 12 c0    	mov    0xc0126ab8,%edx
c010887d:	a1 bc 6a 12 c0       	mov    0xc0126abc,%eax
c0108882:	39 c2                	cmp    %eax,%edx
c0108884:	0f 8c ac 00 00 00    	jl     c0108936 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c010888a:	c7 05 bc 6a 12 c0 00 	movl   $0x2000,0xc0126abc
c0108891:	20 00 00 
    repeat:
        le = list;
c0108894:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108897:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c010889a:	eb 7f                	jmp    c010891b <get_pid+0xd6>
            proc = le2proc(le, list_link);
c010889c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010889f:	83 e8 58             	sub    $0x58,%eax
c01088a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c01088a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088a8:	8b 50 04             	mov    0x4(%eax),%edx
c01088ab:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c01088b0:	39 c2                	cmp    %eax,%edx
c01088b2:	75 3e                	jne    c01088f2 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c01088b4:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c01088b9:	83 c0 01             	add    $0x1,%eax
c01088bc:	a3 b8 6a 12 c0       	mov    %eax,0xc0126ab8
c01088c1:	8b 15 b8 6a 12 c0    	mov    0xc0126ab8,%edx
c01088c7:	a1 bc 6a 12 c0       	mov    0xc0126abc,%eax
c01088cc:	39 c2                	cmp    %eax,%edx
c01088ce:	7c 4b                	jl     c010891b <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c01088d0:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c01088d5:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01088da:	7e 0a                	jle    c01088e6 <get_pid+0xa1>
                        last_pid = 1;
c01088dc:	c7 05 b8 6a 12 c0 01 	movl   $0x1,0xc0126ab8
c01088e3:	00 00 00 
                    }
                    next_safe = MAX_PID;
c01088e6:	c7 05 bc 6a 12 c0 00 	movl   $0x2000,0xc0126abc
c01088ed:	20 00 00 
                    goto repeat;
c01088f0:	eb a2                	jmp    c0108894 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c01088f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088f5:	8b 50 04             	mov    0x4(%eax),%edx
c01088f8:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
c01088fd:	39 c2                	cmp    %eax,%edx
c01088ff:	7e 1a                	jle    c010891b <get_pid+0xd6>
c0108901:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108904:	8b 50 04             	mov    0x4(%eax),%edx
c0108907:	a1 bc 6a 12 c0       	mov    0xc0126abc,%eax
c010890c:	39 c2                	cmp    %eax,%edx
c010890e:	7d 0b                	jge    c010891b <get_pid+0xd6>
                next_safe = proc->pid;
c0108910:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108913:	8b 40 04             	mov    0x4(%eax),%eax
c0108916:	a3 bc 6a 12 c0       	mov    %eax,0xc0126abc
c010891b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010891e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108921:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108924:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0108927:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010892a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010892d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108930:	0f 85 66 ff ff ff    	jne    c010889c <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0108936:	a1 b8 6a 12 c0       	mov    0xc0126ab8,%eax
}
c010893b:	c9                   	leave  
c010893c:	c3                   	ret    

c010893d <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c010893d:	55                   	push   %ebp
c010893e:	89 e5                	mov    %esp,%ebp
c0108940:	83 ec 18             	sub    $0x18,%esp
    if (proc != current) {
c0108943:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108948:	39 45 08             	cmp    %eax,0x8(%ebp)
c010894b:	74 6b                	je     c01089b8 <proc_run+0x7b>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c010894d:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108952:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108955:	8b 45 08             	mov    0x8(%ebp),%eax
c0108958:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c010895b:	e8 3b fd ff ff       	call   c010869b <__intr_save>
c0108960:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108963:	8b 45 08             	mov    0x8(%ebp),%eax
c0108966:	a3 28 a0 12 c0       	mov    %eax,0xc012a028
            load_esp0(next->kstack + KSTACKSIZE);
c010896b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010896e:	8b 40 0c             	mov    0xc(%eax),%eax
c0108971:	05 00 20 00 00       	add    $0x2000,%eax
c0108976:	83 ec 0c             	sub    $0xc,%esp
c0108979:	50                   	push   %eax
c010897a:	e8 f4 e4 ff ff       	call   c0106e73 <load_esp0>
c010897f:	83 c4 10             	add    $0x10,%esp
            lcr3(next->cr3);
c0108982:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108985:	8b 40 40             	mov    0x40(%eax),%eax
c0108988:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010898b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010898e:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108991:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108994:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108997:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010899a:	83 c0 1c             	add    $0x1c,%eax
c010899d:	83 ec 08             	sub    $0x8,%esp
c01089a0:	52                   	push   %edx
c01089a1:	50                   	push   %eax
c01089a2:	e8 bd fc ff ff       	call   c0108664 <switch_to>
c01089a7:	83 c4 10             	add    $0x10,%esp
        }
        local_intr_restore(intr_flag);
c01089aa:	83 ec 0c             	sub    $0xc,%esp
c01089ad:	ff 75 ec             	pushl  -0x14(%ebp)
c01089b0:	e8 10 fd ff ff       	call   c01086c5 <__intr_restore>
c01089b5:	83 c4 10             	add    $0x10,%esp
    }
}
c01089b8:	90                   	nop
c01089b9:	c9                   	leave  
c01089ba:	c3                   	ret    

c01089bb <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c01089bb:	55                   	push   %ebp
c01089bc:	89 e5                	mov    %esp,%ebp
c01089be:	83 ec 08             	sub    $0x8,%esp
    forkrets(current->tf);
c01089c1:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c01089c6:	8b 40 3c             	mov    0x3c(%eax),%eax
c01089c9:	83 ec 0c             	sub    $0xc,%esp
c01089cc:	50                   	push   %eax
c01089cd:	e8 13 a9 ff ff       	call   c01032e5 <forkrets>
c01089d2:	83 c4 10             	add    $0x10,%esp
}
c01089d5:	90                   	nop
c01089d6:	c9                   	leave  
c01089d7:	c3                   	ret    

c01089d8 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c01089d8:	55                   	push   %ebp
c01089d9:	89 e5                	mov    %esp,%ebp
c01089db:	53                   	push   %ebx
c01089dc:	83 ec 24             	sub    $0x24,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c01089df:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e2:	8d 58 60             	lea    0x60(%eax),%ebx
c01089e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e8:	8b 40 04             	mov    0x4(%eax),%eax
c01089eb:	83 ec 08             	sub    $0x8,%esp
c01089ee:	6a 0a                	push   $0xa
c01089f0:	50                   	push   %eax
c01089f1:	e8 d3 10 00 00       	call   c0109ac9 <hash32>
c01089f6:	83 c4 10             	add    $0x10,%esp
c01089f9:	c1 e0 03             	shl    $0x3,%eax
c01089fc:	05 40 a0 12 c0       	add    $0xc012a040,%eax
c0108a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a04:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a16:	8b 40 04             	mov    0x4(%eax),%eax
c0108a19:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108a1c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108a1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108a22:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108a25:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108a2e:	89 10                	mov    %edx,(%eax)
c0108a30:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a33:	8b 10                	mov    (%eax),%edx
c0108a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108a38:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a41:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a47:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108a4a:	89 10                	mov    %edx,(%eax)
}
c0108a4c:	90                   	nop
c0108a4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0108a50:	c9                   	leave  
c0108a51:	c3                   	ret    

c0108a52 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108a52:	55                   	push   %ebp
c0108a53:	89 e5                	mov    %esp,%ebp
c0108a55:	83 ec 18             	sub    $0x18,%esp
    if (0 < pid && pid < MAX_PID) {
c0108a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108a5c:	7e 5d                	jle    c0108abb <find_proc+0x69>
c0108a5e:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108a65:	7f 54                	jg     c0108abb <find_proc+0x69>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a6a:	83 ec 08             	sub    $0x8,%esp
c0108a6d:	6a 0a                	push   $0xa
c0108a6f:	50                   	push   %eax
c0108a70:	e8 54 10 00 00       	call   c0109ac9 <hash32>
c0108a75:	83 c4 10             	add    $0x10,%esp
c0108a78:	c1 e0 03             	shl    $0x3,%eax
c0108a7b:	05 40 a0 12 c0       	add    $0xc012a040,%eax
c0108a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108a89:	eb 19                	jmp    c0108aa4 <find_proc+0x52>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a8e:	83 e8 60             	sub    $0x60,%eax
c0108a91:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a97:	8b 40 04             	mov    0x4(%eax),%eax
c0108a9a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108a9d:	75 05                	jne    c0108aa4 <find_proc+0x52>
                return proc;
c0108a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108aa2:	eb 1c                	jmp    c0108ac0 <find_proc+0x6e>
c0108aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108aa7:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108aad:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0108ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108ab9:	75 d0                	jne    c0108a8b <find_proc+0x39>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ac0:	c9                   	leave  
c0108ac1:	c3                   	ret    

c0108ac2 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108ac2:	55                   	push   %ebp
c0108ac3:	89 e5                	mov    %esp,%ebp
c0108ac5:	83 ec 58             	sub    $0x58,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108ac8:	83 ec 04             	sub    $0x4,%esp
c0108acb:	6a 4c                	push   $0x4c
c0108acd:	6a 00                	push   $0x0
c0108acf:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108ad2:	50                   	push   %eax
c0108ad3:	e8 5a 08 00 00       	call   c0109332 <memset>
c0108ad8:	83 c4 10             	add    $0x10,%esp
    tf.tf_cs = KERNEL_CS;
c0108adb:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108ae1:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108ae7:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108aeb:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108aef:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108af3:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108afd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b00:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108b03:	b8 5b 86 10 c0       	mov    $0xc010865b,%eax
c0108b08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108b0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b0e:	80 cc 01             	or     $0x1,%ah
c0108b11:	89 c2                	mov    %eax,%edx
c0108b13:	83 ec 04             	sub    $0x4,%esp
c0108b16:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108b19:	50                   	push   %eax
c0108b1a:	6a 00                	push   $0x0
c0108b1c:	52                   	push   %edx
c0108b1d:	e8 3c 01 00 00       	call   c0108c5e <do_fork>
c0108b22:	83 c4 10             	add    $0x10,%esp
}
c0108b25:	c9                   	leave  
c0108b26:	c3                   	ret    

c0108b27 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108b27:	55                   	push   %ebp
c0108b28:	89 e5                	mov    %esp,%ebp
c0108b2a:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108b2d:	83 ec 0c             	sub    $0xc,%esp
c0108b30:	6a 02                	push   $0x2
c0108b32:	e8 90 e4 ff ff       	call   c0106fc7 <alloc_pages>
c0108b37:	83 c4 10             	add    $0x10,%esp
c0108b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108b41:	74 1d                	je     c0108b60 <setup_kstack+0x39>
        proc->kstack = (uintptr_t)page2kva(page);
c0108b43:	83 ec 0c             	sub    $0xc,%esp
c0108b46:	ff 75 f4             	pushl  -0xc(%ebp)
c0108b49:	e8 ee fb ff ff       	call   c010873c <page2kva>
c0108b4e:	83 c4 10             	add    $0x10,%esp
c0108b51:	89 c2                	mov    %eax,%edx
c0108b53:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b56:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108b59:	b8 00 00 00 00       	mov    $0x0,%eax
c0108b5e:	eb 05                	jmp    c0108b65 <setup_kstack+0x3e>
    }
    return -E_NO_MEM;
c0108b60:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108b65:	c9                   	leave  
c0108b66:	c3                   	ret    

c0108b67 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108b67:	55                   	push   %ebp
c0108b68:	89 e5                	mov    %esp,%ebp
c0108b6a:	83 ec 08             	sub    $0x8,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b70:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b73:	83 ec 0c             	sub    $0xc,%esp
c0108b76:	50                   	push   %eax
c0108b77:	e8 05 fc ff ff       	call   c0108781 <kva2page>
c0108b7c:	83 c4 10             	add    $0x10,%esp
c0108b7f:	83 ec 08             	sub    $0x8,%esp
c0108b82:	6a 02                	push   $0x2
c0108b84:	50                   	push   %eax
c0108b85:	e8 a9 e4 ff ff       	call   c0107033 <free_pages>
c0108b8a:	83 c4 10             	add    $0x10,%esp
}
c0108b8d:	90                   	nop
c0108b8e:	c9                   	leave  
c0108b8f:	c3                   	ret    

c0108b90 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108b90:	55                   	push   %ebp
c0108b91:	89 e5                	mov    %esp,%ebp
c0108b93:	83 ec 08             	sub    $0x8,%esp
    assert(current->mm == NULL);
c0108b96:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108b9b:	8b 40 18             	mov    0x18(%eax),%eax
c0108b9e:	85 c0                	test   %eax,%eax
c0108ba0:	74 19                	je     c0108bbb <copy_mm+0x2b>
c0108ba2:	68 58 bd 10 c0       	push   $0xc010bd58
c0108ba7:	68 6c bd 10 c0       	push   $0xc010bd6c
c0108bac:	68 f2 00 00 00       	push   $0xf2
c0108bb1:	68 81 bd 10 c0       	push   $0xc010bd81
c0108bb6:	e8 3d 78 ff ff       	call   c01003f8 <__panic>
    /* do nothing in this project */
    return 0;
c0108bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108bc0:	c9                   	leave  
c0108bc1:	c3                   	ret    

c0108bc2 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108bc2:	55                   	push   %ebp
c0108bc3:	89 e5                	mov    %esp,%ebp
c0108bc5:	57                   	push   %edi
c0108bc6:	56                   	push   %esi
c0108bc7:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bcb:	8b 40 0c             	mov    0xc(%eax),%eax
c0108bce:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108bd3:	89 c2                	mov    %eax,%edx
c0108bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bd8:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bde:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108be1:	8b 55 10             	mov    0x10(%ebp),%edx
c0108be4:	89 d3                	mov    %edx,%ebx
c0108be6:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0108beb:	8b 0b                	mov    (%ebx),%ecx
c0108bed:	89 08                	mov    %ecx,(%eax)
c0108bef:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c0108bf3:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0108bf7:	8d 78 04             	lea    0x4(%eax),%edi
c0108bfa:	83 e7 fc             	and    $0xfffffffc,%edi
c0108bfd:	29 f8                	sub    %edi,%eax
c0108bff:	29 c3                	sub    %eax,%ebx
c0108c01:	01 c2                	add    %eax,%edx
c0108c03:	83 e2 fc             	and    $0xfffffffc,%edx
c0108c06:	89 d0                	mov    %edx,%eax
c0108c08:	c1 e8 02             	shr    $0x2,%eax
c0108c0b:	89 de                	mov    %ebx,%esi
c0108c0d:	89 c1                	mov    %eax,%ecx
c0108c0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    proc->tf->tf_regs.reg_eax = 0;
c0108c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c14:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c17:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c21:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c24:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c27:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c2d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c30:	8b 55 08             	mov    0x8(%ebp),%edx
c0108c33:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108c36:	8b 52 40             	mov    0x40(%edx),%edx
c0108c39:	80 ce 02             	or     $0x2,%dh
c0108c3c:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108c3f:	ba bb 89 10 c0       	mov    $0xc01089bb,%edx
c0108c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c47:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c4d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c50:	89 c2                	mov    %eax,%edx
c0108c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c55:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108c58:	90                   	nop
c0108c59:	5b                   	pop    %ebx
c0108c5a:	5e                   	pop    %esi
c0108c5b:	5f                   	pop    %edi
c0108c5c:	5d                   	pop    %ebp
c0108c5d:	c3                   	ret    

c0108c5e <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108c5e:	55                   	push   %ebp
c0108c5f:	89 e5                	mov    %esp,%ebp
c0108c61:	83 ec 10             	sub    $0x10,%esp
    int ret = -E_NO_FREE_PROC;
c0108c64:	c7 45 fc fb ff ff ff 	movl   $0xfffffffb,-0x4(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108c6b:	a1 40 c0 12 c0       	mov    0xc012c040,%eax
c0108c70:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108c75:	7f 09                	jg     c0108c80 <do_fork+0x22>
        goto fork_out;
    }
    ret = -E_NO_MEM;
c0108c77:	c7 45 fc fc ff ff ff 	movl   $0xfffffffc,-0x4(%ebp)
c0108c7e:	eb 01                	jmp    c0108c81 <do_fork+0x23>
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
c0108c80:	90                   	nop
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
fork_out:
    return ret;
c0108c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
c0108c84:	c9                   	leave  
c0108c85:	c3                   	ret    

c0108c86 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108c86:	55                   	push   %ebp
c0108c87:	89 e5                	mov    %esp,%ebp
c0108c89:	83 ec 08             	sub    $0x8,%esp
    panic("process exit!!.\n");
c0108c8c:	83 ec 04             	sub    $0x4,%esp
c0108c8f:	68 95 bd 10 c0       	push   $0xc010bd95
c0108c94:	68 3b 01 00 00       	push   $0x13b
c0108c99:	68 81 bd 10 c0       	push   $0xc010bd81
c0108c9e:	e8 55 77 ff ff       	call   c01003f8 <__panic>

c0108ca3 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108ca3:	55                   	push   %ebp
c0108ca4:	89 e5                	mov    %esp,%ebp
c0108ca6:	83 ec 08             	sub    $0x8,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108ca9:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108cae:	83 ec 0c             	sub    $0xc,%esp
c0108cb1:	50                   	push   %eax
c0108cb2:	e8 59 fb ff ff       	call   c0108810 <get_proc_name>
c0108cb7:	83 c4 10             	add    $0x10,%esp
c0108cba:	89 c2                	mov    %eax,%edx
c0108cbc:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108cc1:	8b 40 04             	mov    0x4(%eax),%eax
c0108cc4:	83 ec 04             	sub    $0x4,%esp
c0108cc7:	52                   	push   %edx
c0108cc8:	50                   	push   %eax
c0108cc9:	68 a8 bd 10 c0       	push   $0xc010bda8
c0108cce:	e8 bf 75 ff ff       	call   c0100292 <cprintf>
c0108cd3:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108cd6:	83 ec 08             	sub    $0x8,%esp
c0108cd9:	ff 75 08             	pushl  0x8(%ebp)
c0108cdc:	68 ce bd 10 c0       	push   $0xc010bdce
c0108ce1:	e8 ac 75 ff ff       	call   c0100292 <cprintf>
c0108ce6:	83 c4 10             	add    $0x10,%esp
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108ce9:	83 ec 0c             	sub    $0xc,%esp
c0108cec:	68 db bd 10 c0       	push   $0xc010bddb
c0108cf1:	e8 9c 75 ff ff       	call   c0100292 <cprintf>
c0108cf6:	83 c4 10             	add    $0x10,%esp
    return 0;
c0108cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108cfe:	c9                   	leave  
c0108cff:	c3                   	ret    

c0108d00 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108d00:	55                   	push   %ebp
c0108d01:	89 e5                	mov    %esp,%ebp
c0108d03:	83 ec 18             	sub    $0x18,%esp
c0108d06:	c7 45 e8 9c c1 12 c0 	movl   $0xc012c19c,-0x18(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d10:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108d13:	89 50 04             	mov    %edx,0x4(%eax)
c0108d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d19:	8b 50 04             	mov    0x4(%eax),%edx
c0108d1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d1f:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d28:	eb 26                	jmp    c0108d50 <proc_init+0x50>
        list_init(hash_list + i);
c0108d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d2d:	c1 e0 03             	shl    $0x3,%eax
c0108d30:	05 40 a0 12 c0       	add    $0xc012a040,%eax
c0108d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108d3e:	89 50 04             	mov    %edx,0x4(%eax)
c0108d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d44:	8b 50 04             	mov    0x4(%eax),%edx
c0108d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d4a:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108d50:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108d57:	7e d1                	jle    c0108d2a <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108d59:	e8 62 fa ff ff       	call   c01087c0 <alloc_proc>
c0108d5e:	a3 20 a0 12 c0       	mov    %eax,0xc012a020
c0108d63:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108d68:	85 c0                	test   %eax,%eax
c0108d6a:	75 17                	jne    c0108d83 <proc_init+0x83>
        panic("cannot alloc idleproc.\n");
c0108d6c:	83 ec 04             	sub    $0x4,%esp
c0108d6f:	68 f7 bd 10 c0       	push   $0xc010bdf7
c0108d74:	68 53 01 00 00       	push   $0x153
c0108d79:	68 81 bd 10 c0       	push   $0xc010bd81
c0108d7e:	e8 75 76 ff ff       	call   c01003f8 <__panic>
    }

    idleproc->pid = 0;
c0108d83:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108d88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108d8f:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108d94:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108d9a:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108d9f:	ba 00 40 12 c0       	mov    $0xc0124000,%edx
c0108da4:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108da7:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108dac:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108db3:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108db8:	83 ec 08             	sub    $0x8,%esp
c0108dbb:	68 0f be 10 c0       	push   $0xc010be0f
c0108dc0:	50                   	push   %eax
c0108dc1:	e8 15 fa ff ff       	call   c01087db <set_proc_name>
c0108dc6:	83 c4 10             	add    $0x10,%esp
    nr_process ++;
c0108dc9:	a1 40 c0 12 c0       	mov    0xc012c040,%eax
c0108dce:	83 c0 01             	add    $0x1,%eax
c0108dd1:	a3 40 c0 12 c0       	mov    %eax,0xc012c040

    current = idleproc;
c0108dd6:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108ddb:	a3 28 a0 12 c0       	mov    %eax,0xc012a028

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108de0:	83 ec 04             	sub    $0x4,%esp
c0108de3:	6a 00                	push   $0x0
c0108de5:	68 14 be 10 c0       	push   $0xc010be14
c0108dea:	68 a3 8c 10 c0       	push   $0xc0108ca3
c0108def:	e8 ce fc ff ff       	call   c0108ac2 <kernel_thread>
c0108df4:	83 c4 10             	add    $0x10,%esp
c0108df7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c0108dfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108dfe:	7f 17                	jg     c0108e17 <proc_init+0x117>
        panic("create init_main failed.\n");
c0108e00:	83 ec 04             	sub    $0x4,%esp
c0108e03:	68 22 be 10 c0       	push   $0xc010be22
c0108e08:	68 61 01 00 00       	push   $0x161
c0108e0d:	68 81 bd 10 c0       	push   $0xc010bd81
c0108e12:	e8 e1 75 ff ff       	call   c01003f8 <__panic>
    }

    initproc = find_proc(pid);
c0108e17:	83 ec 0c             	sub    $0xc,%esp
c0108e1a:	ff 75 ec             	pushl  -0x14(%ebp)
c0108e1d:	e8 30 fc ff ff       	call   c0108a52 <find_proc>
c0108e22:	83 c4 10             	add    $0x10,%esp
c0108e25:	a3 24 a0 12 c0       	mov    %eax,0xc012a024
    set_proc_name(initproc, "init");
c0108e2a:	a1 24 a0 12 c0       	mov    0xc012a024,%eax
c0108e2f:	83 ec 08             	sub    $0x8,%esp
c0108e32:	68 3c be 10 c0       	push   $0xc010be3c
c0108e37:	50                   	push   %eax
c0108e38:	e8 9e f9 ff ff       	call   c01087db <set_proc_name>
c0108e3d:	83 c4 10             	add    $0x10,%esp

    assert(idleproc != NULL && idleproc->pid == 0);
c0108e40:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108e45:	85 c0                	test   %eax,%eax
c0108e47:	74 0c                	je     c0108e55 <proc_init+0x155>
c0108e49:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108e4e:	8b 40 04             	mov    0x4(%eax),%eax
c0108e51:	85 c0                	test   %eax,%eax
c0108e53:	74 19                	je     c0108e6e <proc_init+0x16e>
c0108e55:	68 44 be 10 c0       	push   $0xc010be44
c0108e5a:	68 6c bd 10 c0       	push   $0xc010bd6c
c0108e5f:	68 67 01 00 00       	push   $0x167
c0108e64:	68 81 bd 10 c0       	push   $0xc010bd81
c0108e69:	e8 8a 75 ff ff       	call   c01003f8 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108e6e:	a1 24 a0 12 c0       	mov    0xc012a024,%eax
c0108e73:	85 c0                	test   %eax,%eax
c0108e75:	74 0d                	je     c0108e84 <proc_init+0x184>
c0108e77:	a1 24 a0 12 c0       	mov    0xc012a024,%eax
c0108e7c:	8b 40 04             	mov    0x4(%eax),%eax
c0108e7f:	83 f8 01             	cmp    $0x1,%eax
c0108e82:	74 19                	je     c0108e9d <proc_init+0x19d>
c0108e84:	68 6c be 10 c0       	push   $0xc010be6c
c0108e89:	68 6c bd 10 c0       	push   $0xc010bd6c
c0108e8e:	68 68 01 00 00       	push   $0x168
c0108e93:	68 81 bd 10 c0       	push   $0xc010bd81
c0108e98:	e8 5b 75 ff ff       	call   c01003f8 <__panic>
}
c0108e9d:	90                   	nop
c0108e9e:	c9                   	leave  
c0108e9f:	c3                   	ret    

c0108ea0 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0108ea0:	55                   	push   %ebp
c0108ea1:	89 e5                	mov    %esp,%ebp
c0108ea3:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c0108ea6:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108eab:	8b 40 10             	mov    0x10(%eax),%eax
c0108eae:	85 c0                	test   %eax,%eax
c0108eb0:	74 f4                	je     c0108ea6 <cpu_idle+0x6>
            schedule();
c0108eb2:	e8 7c 00 00 00       	call   c0108f33 <schedule>
        }
    }
c0108eb7:	eb ed                	jmp    c0108ea6 <cpu_idle+0x6>

c0108eb9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108eb9:	55                   	push   %ebp
c0108eba:	89 e5                	mov    %esp,%ebp
c0108ebc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108ebf:	9c                   	pushf  
c0108ec0:	58                   	pop    %eax
c0108ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108ec7:	25 00 02 00 00       	and    $0x200,%eax
c0108ecc:	85 c0                	test   %eax,%eax
c0108ece:	74 0c                	je     c0108edc <__intr_save+0x23>
        intr_disable();
c0108ed0:	e8 0b 92 ff ff       	call   c01020e0 <intr_disable>
        return 1;
c0108ed5:	b8 01 00 00 00       	mov    $0x1,%eax
c0108eda:	eb 05                	jmp    c0108ee1 <__intr_save+0x28>
    }
    return 0;
c0108edc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ee1:	c9                   	leave  
c0108ee2:	c3                   	ret    

c0108ee3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108ee3:	55                   	push   %ebp
c0108ee4:	89 e5                	mov    %esp,%ebp
c0108ee6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108ee9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108eed:	74 05                	je     c0108ef4 <__intr_restore+0x11>
        intr_enable();
c0108eef:	e8 e5 91 ff ff       	call   c01020d9 <intr_enable>
    }
}
c0108ef4:	90                   	nop
c0108ef5:	c9                   	leave  
c0108ef6:	c3                   	ret    

c0108ef7 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0108ef7:	55                   	push   %ebp
c0108ef8:	89 e5                	mov    %esp,%ebp
c0108efa:	83 ec 08             	sub    $0x8,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0108efd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f00:	8b 00                	mov    (%eax),%eax
c0108f02:	83 f8 03             	cmp    $0x3,%eax
c0108f05:	74 0a                	je     c0108f11 <wakeup_proc+0x1a>
c0108f07:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f0a:	8b 00                	mov    (%eax),%eax
c0108f0c:	83 f8 02             	cmp    $0x2,%eax
c0108f0f:	75 16                	jne    c0108f27 <wakeup_proc+0x30>
c0108f11:	68 94 be 10 c0       	push   $0xc010be94
c0108f16:	68 cf be 10 c0       	push   $0xc010becf
c0108f1b:	6a 09                	push   $0x9
c0108f1d:	68 e4 be 10 c0       	push   $0xc010bee4
c0108f22:	e8 d1 74 ff ff       	call   c01003f8 <__panic>
    proc->state = PROC_RUNNABLE;
c0108f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f2a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c0108f30:	90                   	nop
c0108f31:	c9                   	leave  
c0108f32:	c3                   	ret    

c0108f33 <schedule>:

void
schedule(void) {
c0108f33:	55                   	push   %ebp
c0108f34:	89 e5                	mov    %esp,%ebp
c0108f36:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0108f39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0108f40:	e8 74 ff ff ff       	call   c0108eb9 <__intr_save>
c0108f45:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0108f48:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108f4d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0108f54:	8b 15 28 a0 12 c0    	mov    0xc012a028,%edx
c0108f5a:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108f5f:	39 c2                	cmp    %eax,%edx
c0108f61:	74 0a                	je     c0108f6d <schedule+0x3a>
c0108f63:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108f68:	83 c0 58             	add    $0x58,%eax
c0108f6b:	eb 05                	jmp    c0108f72 <schedule+0x3f>
c0108f6d:	b8 9c c1 12 c0       	mov    $0xc012c19c,%eax
c0108f72:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0108f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f84:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0108f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108f8a:	81 7d f4 9c c1 12 c0 	cmpl   $0xc012c19c,-0xc(%ebp)
c0108f91:	74 13                	je     c0108fa6 <schedule+0x73>
                next = le2proc(le, list_link);
c0108f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f96:	83 e8 58             	sub    $0x58,%eax
c0108f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c0108f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f9f:	8b 00                	mov    (%eax),%eax
c0108fa1:	83 f8 02             	cmp    $0x2,%eax
c0108fa4:	74 0a                	je     c0108fb0 <schedule+0x7d>
                    break;
                }
            }
        } while (le != last);
c0108fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108fa9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0108fac:	75 cd                	jne    c0108f7b <schedule+0x48>
c0108fae:	eb 01                	jmp    c0108fb1 <schedule+0x7e>
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
c0108fb0:	90                   	nop
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
c0108fb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108fb5:	74 0a                	je     c0108fc1 <schedule+0x8e>
c0108fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fba:	8b 00                	mov    (%eax),%eax
c0108fbc:	83 f8 02             	cmp    $0x2,%eax
c0108fbf:	74 08                	je     c0108fc9 <schedule+0x96>
            next = idleproc;
c0108fc1:	a1 20 a0 12 c0       	mov    0xc012a020,%eax
c0108fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0108fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fcc:	8b 40 08             	mov    0x8(%eax),%eax
c0108fcf:	8d 50 01             	lea    0x1(%eax),%edx
c0108fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fd5:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0108fd8:	a1 28 a0 12 c0       	mov    0xc012a028,%eax
c0108fdd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108fe0:	74 0e                	je     c0108ff0 <schedule+0xbd>
            proc_run(next);
c0108fe2:	83 ec 0c             	sub    $0xc,%esp
c0108fe5:	ff 75 f0             	pushl  -0x10(%ebp)
c0108fe8:	e8 50 f9 ff ff       	call   c010893d <proc_run>
c0108fed:	83 c4 10             	add    $0x10,%esp
        }
    }
    local_intr_restore(intr_flag);
c0108ff0:	83 ec 0c             	sub    $0xc,%esp
c0108ff3:	ff 75 ec             	pushl  -0x14(%ebp)
c0108ff6:	e8 e8 fe ff ff       	call   c0108ee3 <__intr_restore>
c0108ffb:	83 c4 10             	add    $0x10,%esp
}
c0108ffe:	90                   	nop
c0108fff:	c9                   	leave  
c0109000:	c3                   	ret    

c0109001 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109001:	55                   	push   %ebp
c0109002:	89 e5                	mov    %esp,%ebp
c0109004:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109007:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010900e:	eb 04                	jmp    c0109014 <strlen+0x13>
        cnt ++;
c0109010:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109014:	8b 45 08             	mov    0x8(%ebp),%eax
c0109017:	8d 50 01             	lea    0x1(%eax),%edx
c010901a:	89 55 08             	mov    %edx,0x8(%ebp)
c010901d:	0f b6 00             	movzbl (%eax),%eax
c0109020:	84 c0                	test   %al,%al
c0109022:	75 ec                	jne    c0109010 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0109024:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109027:	c9                   	leave  
c0109028:	c3                   	ret    

c0109029 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0109029:	55                   	push   %ebp
c010902a:	89 e5                	mov    %esp,%ebp
c010902c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010902f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109036:	eb 04                	jmp    c010903c <strnlen+0x13>
        cnt ++;
c0109038:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010903c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010903f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109042:	73 10                	jae    c0109054 <strnlen+0x2b>
c0109044:	8b 45 08             	mov    0x8(%ebp),%eax
c0109047:	8d 50 01             	lea    0x1(%eax),%edx
c010904a:	89 55 08             	mov    %edx,0x8(%ebp)
c010904d:	0f b6 00             	movzbl (%eax),%eax
c0109050:	84 c0                	test   %al,%al
c0109052:	75 e4                	jne    c0109038 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109054:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109057:	c9                   	leave  
c0109058:	c3                   	ret    

c0109059 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0109059:	55                   	push   %ebp
c010905a:	89 e5                	mov    %esp,%ebp
c010905c:	57                   	push   %edi
c010905d:	56                   	push   %esi
c010905e:	83 ec 20             	sub    $0x20,%esp
c0109061:	8b 45 08             	mov    0x8(%ebp),%eax
c0109064:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109067:	8b 45 0c             	mov    0xc(%ebp),%eax
c010906a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010906d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109070:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109073:	89 d1                	mov    %edx,%ecx
c0109075:	89 c2                	mov    %eax,%edx
c0109077:	89 ce                	mov    %ecx,%esi
c0109079:	89 d7                	mov    %edx,%edi
c010907b:	ac                   	lods   %ds:(%esi),%al
c010907c:	aa                   	stos   %al,%es:(%edi)
c010907d:	84 c0                	test   %al,%al
c010907f:	75 fa                	jne    c010907b <strcpy+0x22>
c0109081:	89 fa                	mov    %edi,%edx
c0109083:	89 f1                	mov    %esi,%ecx
c0109085:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109088:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010908b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010908e:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0109091:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109092:	83 c4 20             	add    $0x20,%esp
c0109095:	5e                   	pop    %esi
c0109096:	5f                   	pop    %edi
c0109097:	5d                   	pop    %ebp
c0109098:	c3                   	ret    

c0109099 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0109099:	55                   	push   %ebp
c010909a:	89 e5                	mov    %esp,%ebp
c010909c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010909f:	8b 45 08             	mov    0x8(%ebp),%eax
c01090a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01090a5:	eb 21                	jmp    c01090c8 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01090a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090aa:	0f b6 10             	movzbl (%eax),%edx
c01090ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01090b0:	88 10                	mov    %dl,(%eax)
c01090b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01090b5:	0f b6 00             	movzbl (%eax),%eax
c01090b8:	84 c0                	test   %al,%al
c01090ba:	74 04                	je     c01090c0 <strncpy+0x27>
            src ++;
c01090bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01090c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01090c4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01090c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01090cc:	75 d9                	jne    c01090a7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01090ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01090d1:	c9                   	leave  
c01090d2:	c3                   	ret    

c01090d3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01090d3:	55                   	push   %ebp
c01090d4:	89 e5                	mov    %esp,%ebp
c01090d6:	57                   	push   %edi
c01090d7:	56                   	push   %esi
c01090d8:	83 ec 20             	sub    $0x20,%esp
c01090db:	8b 45 08             	mov    0x8(%ebp),%eax
c01090de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01090e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090ed:	89 d1                	mov    %edx,%ecx
c01090ef:	89 c2                	mov    %eax,%edx
c01090f1:	89 ce                	mov    %ecx,%esi
c01090f3:	89 d7                	mov    %edx,%edi
c01090f5:	ac                   	lods   %ds:(%esi),%al
c01090f6:	ae                   	scas   %es:(%edi),%al
c01090f7:	75 08                	jne    c0109101 <strcmp+0x2e>
c01090f9:	84 c0                	test   %al,%al
c01090fb:	75 f8                	jne    c01090f5 <strcmp+0x22>
c01090fd:	31 c0                	xor    %eax,%eax
c01090ff:	eb 04                	jmp    c0109105 <strcmp+0x32>
c0109101:	19 c0                	sbb    %eax,%eax
c0109103:	0c 01                	or     $0x1,%al
c0109105:	89 fa                	mov    %edi,%edx
c0109107:	89 f1                	mov    %esi,%ecx
c0109109:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010910c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010910f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109112:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0109115:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109116:	83 c4 20             	add    $0x20,%esp
c0109119:	5e                   	pop    %esi
c010911a:	5f                   	pop    %edi
c010911b:	5d                   	pop    %ebp
c010911c:	c3                   	ret    

c010911d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010911d:	55                   	push   %ebp
c010911e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109120:	eb 0c                	jmp    c010912e <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109122:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109126:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010912a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010912e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109132:	74 1a                	je     c010914e <strncmp+0x31>
c0109134:	8b 45 08             	mov    0x8(%ebp),%eax
c0109137:	0f b6 00             	movzbl (%eax),%eax
c010913a:	84 c0                	test   %al,%al
c010913c:	74 10                	je     c010914e <strncmp+0x31>
c010913e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109141:	0f b6 10             	movzbl (%eax),%edx
c0109144:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109147:	0f b6 00             	movzbl (%eax),%eax
c010914a:	38 c2                	cmp    %al,%dl
c010914c:	74 d4                	je     c0109122 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010914e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109152:	74 18                	je     c010916c <strncmp+0x4f>
c0109154:	8b 45 08             	mov    0x8(%ebp),%eax
c0109157:	0f b6 00             	movzbl (%eax),%eax
c010915a:	0f b6 d0             	movzbl %al,%edx
c010915d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109160:	0f b6 00             	movzbl (%eax),%eax
c0109163:	0f b6 c0             	movzbl %al,%eax
c0109166:	29 c2                	sub    %eax,%edx
c0109168:	89 d0                	mov    %edx,%eax
c010916a:	eb 05                	jmp    c0109171 <strncmp+0x54>
c010916c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109171:	5d                   	pop    %ebp
c0109172:	c3                   	ret    

c0109173 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109173:	55                   	push   %ebp
c0109174:	89 e5                	mov    %esp,%ebp
c0109176:	83 ec 04             	sub    $0x4,%esp
c0109179:	8b 45 0c             	mov    0xc(%ebp),%eax
c010917c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010917f:	eb 14                	jmp    c0109195 <strchr+0x22>
        if (*s == c) {
c0109181:	8b 45 08             	mov    0x8(%ebp),%eax
c0109184:	0f b6 00             	movzbl (%eax),%eax
c0109187:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010918a:	75 05                	jne    c0109191 <strchr+0x1e>
            return (char *)s;
c010918c:	8b 45 08             	mov    0x8(%ebp),%eax
c010918f:	eb 13                	jmp    c01091a4 <strchr+0x31>
        }
        s ++;
c0109191:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109195:	8b 45 08             	mov    0x8(%ebp),%eax
c0109198:	0f b6 00             	movzbl (%eax),%eax
c010919b:	84 c0                	test   %al,%al
c010919d:	75 e2                	jne    c0109181 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010919f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01091a4:	c9                   	leave  
c01091a5:	c3                   	ret    

c01091a6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01091a6:	55                   	push   %ebp
c01091a7:	89 e5                	mov    %esp,%ebp
c01091a9:	83 ec 04             	sub    $0x4,%esp
c01091ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091af:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01091b2:	eb 0f                	jmp    c01091c3 <strfind+0x1d>
        if (*s == c) {
c01091b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01091b7:	0f b6 00             	movzbl (%eax),%eax
c01091ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01091bd:	74 10                	je     c01091cf <strfind+0x29>
            break;
        }
        s ++;
c01091bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01091c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01091c6:	0f b6 00             	movzbl (%eax),%eax
c01091c9:	84 c0                	test   %al,%al
c01091cb:	75 e7                	jne    c01091b4 <strfind+0xe>
c01091cd:	eb 01                	jmp    c01091d0 <strfind+0x2a>
        if (*s == c) {
            break;
c01091cf:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c01091d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01091d3:	c9                   	leave  
c01091d4:	c3                   	ret    

c01091d5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01091d5:	55                   	push   %ebp
c01091d6:	89 e5                	mov    %esp,%ebp
c01091d8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01091db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01091e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01091e9:	eb 04                	jmp    c01091ef <strtol+0x1a>
        s ++;
c01091eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01091ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01091f2:	0f b6 00             	movzbl (%eax),%eax
c01091f5:	3c 20                	cmp    $0x20,%al
c01091f7:	74 f2                	je     c01091eb <strtol+0x16>
c01091f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01091fc:	0f b6 00             	movzbl (%eax),%eax
c01091ff:	3c 09                	cmp    $0x9,%al
c0109201:	74 e8                	je     c01091eb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109203:	8b 45 08             	mov    0x8(%ebp),%eax
c0109206:	0f b6 00             	movzbl (%eax),%eax
c0109209:	3c 2b                	cmp    $0x2b,%al
c010920b:	75 06                	jne    c0109213 <strtol+0x3e>
        s ++;
c010920d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109211:	eb 15                	jmp    c0109228 <strtol+0x53>
    }
    else if (*s == '-') {
c0109213:	8b 45 08             	mov    0x8(%ebp),%eax
c0109216:	0f b6 00             	movzbl (%eax),%eax
c0109219:	3c 2d                	cmp    $0x2d,%al
c010921b:	75 0b                	jne    c0109228 <strtol+0x53>
        s ++, neg = 1;
c010921d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109221:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109228:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010922c:	74 06                	je     c0109234 <strtol+0x5f>
c010922e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109232:	75 24                	jne    c0109258 <strtol+0x83>
c0109234:	8b 45 08             	mov    0x8(%ebp),%eax
c0109237:	0f b6 00             	movzbl (%eax),%eax
c010923a:	3c 30                	cmp    $0x30,%al
c010923c:	75 1a                	jne    c0109258 <strtol+0x83>
c010923e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109241:	83 c0 01             	add    $0x1,%eax
c0109244:	0f b6 00             	movzbl (%eax),%eax
c0109247:	3c 78                	cmp    $0x78,%al
c0109249:	75 0d                	jne    c0109258 <strtol+0x83>
        s += 2, base = 16;
c010924b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010924f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109256:	eb 2a                	jmp    c0109282 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010925c:	75 17                	jne    c0109275 <strtol+0xa0>
c010925e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109261:	0f b6 00             	movzbl (%eax),%eax
c0109264:	3c 30                	cmp    $0x30,%al
c0109266:	75 0d                	jne    c0109275 <strtol+0xa0>
        s ++, base = 8;
c0109268:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010926c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109273:	eb 0d                	jmp    c0109282 <strtol+0xad>
    }
    else if (base == 0) {
c0109275:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109279:	75 07                	jne    c0109282 <strtol+0xad>
        base = 10;
c010927b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109282:	8b 45 08             	mov    0x8(%ebp),%eax
c0109285:	0f b6 00             	movzbl (%eax),%eax
c0109288:	3c 2f                	cmp    $0x2f,%al
c010928a:	7e 1b                	jle    c01092a7 <strtol+0xd2>
c010928c:	8b 45 08             	mov    0x8(%ebp),%eax
c010928f:	0f b6 00             	movzbl (%eax),%eax
c0109292:	3c 39                	cmp    $0x39,%al
c0109294:	7f 11                	jg     c01092a7 <strtol+0xd2>
            dig = *s - '0';
c0109296:	8b 45 08             	mov    0x8(%ebp),%eax
c0109299:	0f b6 00             	movzbl (%eax),%eax
c010929c:	0f be c0             	movsbl %al,%eax
c010929f:	83 e8 30             	sub    $0x30,%eax
c01092a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092a5:	eb 48                	jmp    c01092ef <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01092a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01092aa:	0f b6 00             	movzbl (%eax),%eax
c01092ad:	3c 60                	cmp    $0x60,%al
c01092af:	7e 1b                	jle    c01092cc <strtol+0xf7>
c01092b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01092b4:	0f b6 00             	movzbl (%eax),%eax
c01092b7:	3c 7a                	cmp    $0x7a,%al
c01092b9:	7f 11                	jg     c01092cc <strtol+0xf7>
            dig = *s - 'a' + 10;
c01092bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01092be:	0f b6 00             	movzbl (%eax),%eax
c01092c1:	0f be c0             	movsbl %al,%eax
c01092c4:	83 e8 57             	sub    $0x57,%eax
c01092c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092ca:	eb 23                	jmp    c01092ef <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01092cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01092cf:	0f b6 00             	movzbl (%eax),%eax
c01092d2:	3c 40                	cmp    $0x40,%al
c01092d4:	7e 3c                	jle    c0109312 <strtol+0x13d>
c01092d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01092d9:	0f b6 00             	movzbl (%eax),%eax
c01092dc:	3c 5a                	cmp    $0x5a,%al
c01092de:	7f 32                	jg     c0109312 <strtol+0x13d>
            dig = *s - 'A' + 10;
c01092e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01092e3:	0f b6 00             	movzbl (%eax),%eax
c01092e6:	0f be c0             	movsbl %al,%eax
c01092e9:	83 e8 37             	sub    $0x37,%eax
c01092ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01092ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092f2:	3b 45 10             	cmp    0x10(%ebp),%eax
c01092f5:	7d 1a                	jge    c0109311 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c01092f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01092fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01092fe:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109302:	89 c2                	mov    %eax,%edx
c0109304:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109307:	01 d0                	add    %edx,%eax
c0109309:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010930c:	e9 71 ff ff ff       	jmp    c0109282 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0109311:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0109312:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109316:	74 08                	je     c0109320 <strtol+0x14b>
        *endptr = (char *) s;
c0109318:	8b 45 0c             	mov    0xc(%ebp),%eax
c010931b:	8b 55 08             	mov    0x8(%ebp),%edx
c010931e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109320:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109324:	74 07                	je     c010932d <strtol+0x158>
c0109326:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109329:	f7 d8                	neg    %eax
c010932b:	eb 03                	jmp    c0109330 <strtol+0x15b>
c010932d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109330:	c9                   	leave  
c0109331:	c3                   	ret    

c0109332 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109332:	55                   	push   %ebp
c0109333:	89 e5                	mov    %esp,%ebp
c0109335:	57                   	push   %edi
c0109336:	83 ec 24             	sub    $0x24,%esp
c0109339:	8b 45 0c             	mov    0xc(%ebp),%eax
c010933c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010933f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109343:	8b 55 08             	mov    0x8(%ebp),%edx
c0109346:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109349:	88 45 f7             	mov    %al,-0x9(%ebp)
c010934c:	8b 45 10             	mov    0x10(%ebp),%eax
c010934f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109352:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109355:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109359:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010935c:	89 d7                	mov    %edx,%edi
c010935e:	f3 aa                	rep stos %al,%es:(%edi)
c0109360:	89 fa                	mov    %edi,%edx
c0109362:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109365:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109368:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010936b:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010936c:	83 c4 24             	add    $0x24,%esp
c010936f:	5f                   	pop    %edi
c0109370:	5d                   	pop    %ebp
c0109371:	c3                   	ret    

c0109372 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109372:	55                   	push   %ebp
c0109373:	89 e5                	mov    %esp,%ebp
c0109375:	57                   	push   %edi
c0109376:	56                   	push   %esi
c0109377:	53                   	push   %ebx
c0109378:	83 ec 30             	sub    $0x30,%esp
c010937b:	8b 45 08             	mov    0x8(%ebp),%eax
c010937e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109381:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109384:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109387:	8b 45 10             	mov    0x10(%ebp),%eax
c010938a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010938d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109390:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109393:	73 42                	jae    c01093d7 <memmove+0x65>
c0109395:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010939b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010939e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01093a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01093a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01093a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01093aa:	c1 e8 02             	shr    $0x2,%eax
c01093ad:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01093af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01093b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01093b5:	89 d7                	mov    %edx,%edi
c01093b7:	89 c6                	mov    %eax,%esi
c01093b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01093bb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01093be:	83 e1 03             	and    $0x3,%ecx
c01093c1:	74 02                	je     c01093c5 <memmove+0x53>
c01093c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01093c5:	89 f0                	mov    %esi,%eax
c01093c7:	89 fa                	mov    %edi,%edx
c01093c9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01093cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01093cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01093d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01093d5:	eb 36                	jmp    c010940d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01093d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01093da:	8d 50 ff             	lea    -0x1(%eax),%edx
c01093dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01093e0:	01 c2                	add    %eax,%edx
c01093e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01093e5:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01093e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01093eb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01093ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01093f1:	89 c1                	mov    %eax,%ecx
c01093f3:	89 d8                	mov    %ebx,%eax
c01093f5:	89 d6                	mov    %edx,%esi
c01093f7:	89 c7                	mov    %eax,%edi
c01093f9:	fd                   	std    
c01093fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01093fc:	fc                   	cld    
c01093fd:	89 f8                	mov    %edi,%eax
c01093ff:	89 f2                	mov    %esi,%edx
c0109401:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109404:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109407:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010940a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010940d:	83 c4 30             	add    $0x30,%esp
c0109410:	5b                   	pop    %ebx
c0109411:	5e                   	pop    %esi
c0109412:	5f                   	pop    %edi
c0109413:	5d                   	pop    %ebp
c0109414:	c3                   	ret    

c0109415 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109415:	55                   	push   %ebp
c0109416:	89 e5                	mov    %esp,%ebp
c0109418:	57                   	push   %edi
c0109419:	56                   	push   %esi
c010941a:	83 ec 20             	sub    $0x20,%esp
c010941d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109420:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109423:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109426:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109429:	8b 45 10             	mov    0x10(%ebp),%eax
c010942c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010942f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109432:	c1 e8 02             	shr    $0x2,%eax
c0109435:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109437:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010943a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010943d:	89 d7                	mov    %edx,%edi
c010943f:	89 c6                	mov    %eax,%esi
c0109441:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109443:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109446:	83 e1 03             	and    $0x3,%ecx
c0109449:	74 02                	je     c010944d <memcpy+0x38>
c010944b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010944d:	89 f0                	mov    %esi,%eax
c010944f:	89 fa                	mov    %edi,%edx
c0109451:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109454:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109457:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010945a:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010945d:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010945e:	83 c4 20             	add    $0x20,%esp
c0109461:	5e                   	pop    %esi
c0109462:	5f                   	pop    %edi
c0109463:	5d                   	pop    %ebp
c0109464:	c3                   	ret    

c0109465 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109465:	55                   	push   %ebp
c0109466:	89 e5                	mov    %esp,%ebp
c0109468:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010946b:	8b 45 08             	mov    0x8(%ebp),%eax
c010946e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109471:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109474:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109477:	eb 30                	jmp    c01094a9 <memcmp+0x44>
        if (*s1 != *s2) {
c0109479:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010947c:	0f b6 10             	movzbl (%eax),%edx
c010947f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109482:	0f b6 00             	movzbl (%eax),%eax
c0109485:	38 c2                	cmp    %al,%dl
c0109487:	74 18                	je     c01094a1 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109489:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010948c:	0f b6 00             	movzbl (%eax),%eax
c010948f:	0f b6 d0             	movzbl %al,%edx
c0109492:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109495:	0f b6 00             	movzbl (%eax),%eax
c0109498:	0f b6 c0             	movzbl %al,%eax
c010949b:	29 c2                	sub    %eax,%edx
c010949d:	89 d0                	mov    %edx,%eax
c010949f:	eb 1a                	jmp    c01094bb <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01094a1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01094a5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c01094a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01094ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01094af:	89 55 10             	mov    %edx,0x10(%ebp)
c01094b2:	85 c0                	test   %eax,%eax
c01094b4:	75 c3                	jne    c0109479 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01094b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01094bb:	c9                   	leave  
c01094bc:	c3                   	ret    

c01094bd <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01094bd:	55                   	push   %ebp
c01094be:	89 e5                	mov    %esp,%ebp
c01094c0:	83 ec 38             	sub    $0x38,%esp
c01094c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01094c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01094c9:	8b 45 14             	mov    0x14(%ebp),%eax
c01094cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01094cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01094d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01094d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01094d8:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01094db:	8b 45 18             	mov    0x18(%ebp),%eax
c01094de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01094e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01094e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01094e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01094ea:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01094ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01094f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01094f7:	74 1c                	je     c0109515 <printnum+0x58>
c01094f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094fc:	ba 00 00 00 00       	mov    $0x0,%edx
c0109501:	f7 75 e4             	divl   -0x1c(%ebp)
c0109504:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109507:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010950a:	ba 00 00 00 00       	mov    $0x0,%edx
c010950f:	f7 75 e4             	divl   -0x1c(%ebp)
c0109512:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109515:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109518:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010951b:	f7 75 e4             	divl   -0x1c(%ebp)
c010951e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109521:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109524:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109527:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010952a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010952d:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109530:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109533:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109536:	8b 45 18             	mov    0x18(%ebp),%eax
c0109539:	ba 00 00 00 00       	mov    $0x0,%edx
c010953e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109541:	77 41                	ja     c0109584 <printnum+0xc7>
c0109543:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109546:	72 05                	jb     c010954d <printnum+0x90>
c0109548:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010954b:	77 37                	ja     c0109584 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010954d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0109550:	83 e8 01             	sub    $0x1,%eax
c0109553:	83 ec 04             	sub    $0x4,%esp
c0109556:	ff 75 20             	pushl  0x20(%ebp)
c0109559:	50                   	push   %eax
c010955a:	ff 75 18             	pushl  0x18(%ebp)
c010955d:	ff 75 ec             	pushl  -0x14(%ebp)
c0109560:	ff 75 e8             	pushl  -0x18(%ebp)
c0109563:	ff 75 0c             	pushl  0xc(%ebp)
c0109566:	ff 75 08             	pushl  0x8(%ebp)
c0109569:	e8 4f ff ff ff       	call   c01094bd <printnum>
c010956e:	83 c4 20             	add    $0x20,%esp
c0109571:	eb 1b                	jmp    c010958e <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109573:	83 ec 08             	sub    $0x8,%esp
c0109576:	ff 75 0c             	pushl  0xc(%ebp)
c0109579:	ff 75 20             	pushl  0x20(%ebp)
c010957c:	8b 45 08             	mov    0x8(%ebp),%eax
c010957f:	ff d0                	call   *%eax
c0109581:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0109584:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0109588:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010958c:	7f e5                	jg     c0109573 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010958e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109591:	05 7c bf 10 c0       	add    $0xc010bf7c,%eax
c0109596:	0f b6 00             	movzbl (%eax),%eax
c0109599:	0f be c0             	movsbl %al,%eax
c010959c:	83 ec 08             	sub    $0x8,%esp
c010959f:	ff 75 0c             	pushl  0xc(%ebp)
c01095a2:	50                   	push   %eax
c01095a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a6:	ff d0                	call   *%eax
c01095a8:	83 c4 10             	add    $0x10,%esp
}
c01095ab:	90                   	nop
c01095ac:	c9                   	leave  
c01095ad:	c3                   	ret    

c01095ae <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01095ae:	55                   	push   %ebp
c01095af:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01095b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01095b5:	7e 14                	jle    c01095cb <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01095b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01095ba:	8b 00                	mov    (%eax),%eax
c01095bc:	8d 48 08             	lea    0x8(%eax),%ecx
c01095bf:	8b 55 08             	mov    0x8(%ebp),%edx
c01095c2:	89 0a                	mov    %ecx,(%edx)
c01095c4:	8b 50 04             	mov    0x4(%eax),%edx
c01095c7:	8b 00                	mov    (%eax),%eax
c01095c9:	eb 30                	jmp    c01095fb <getuint+0x4d>
    }
    else if (lflag) {
c01095cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01095cf:	74 16                	je     c01095e7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01095d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01095d4:	8b 00                	mov    (%eax),%eax
c01095d6:	8d 48 04             	lea    0x4(%eax),%ecx
c01095d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01095dc:	89 0a                	mov    %ecx,(%edx)
c01095de:	8b 00                	mov    (%eax),%eax
c01095e0:	ba 00 00 00 00       	mov    $0x0,%edx
c01095e5:	eb 14                	jmp    c01095fb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01095e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01095ea:	8b 00                	mov    (%eax),%eax
c01095ec:	8d 48 04             	lea    0x4(%eax),%ecx
c01095ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01095f2:	89 0a                	mov    %ecx,(%edx)
c01095f4:	8b 00                	mov    (%eax),%eax
c01095f6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01095fb:	5d                   	pop    %ebp
c01095fc:	c3                   	ret    

c01095fd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01095fd:	55                   	push   %ebp
c01095fe:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109600:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109604:	7e 14                	jle    c010961a <getint+0x1d>
        return va_arg(*ap, long long);
c0109606:	8b 45 08             	mov    0x8(%ebp),%eax
c0109609:	8b 00                	mov    (%eax),%eax
c010960b:	8d 48 08             	lea    0x8(%eax),%ecx
c010960e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109611:	89 0a                	mov    %ecx,(%edx)
c0109613:	8b 50 04             	mov    0x4(%eax),%edx
c0109616:	8b 00                	mov    (%eax),%eax
c0109618:	eb 28                	jmp    c0109642 <getint+0x45>
    }
    else if (lflag) {
c010961a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010961e:	74 12                	je     c0109632 <getint+0x35>
        return va_arg(*ap, long);
c0109620:	8b 45 08             	mov    0x8(%ebp),%eax
c0109623:	8b 00                	mov    (%eax),%eax
c0109625:	8d 48 04             	lea    0x4(%eax),%ecx
c0109628:	8b 55 08             	mov    0x8(%ebp),%edx
c010962b:	89 0a                	mov    %ecx,(%edx)
c010962d:	8b 00                	mov    (%eax),%eax
c010962f:	99                   	cltd   
c0109630:	eb 10                	jmp    c0109642 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109632:	8b 45 08             	mov    0x8(%ebp),%eax
c0109635:	8b 00                	mov    (%eax),%eax
c0109637:	8d 48 04             	lea    0x4(%eax),%ecx
c010963a:	8b 55 08             	mov    0x8(%ebp),%edx
c010963d:	89 0a                	mov    %ecx,(%edx)
c010963f:	8b 00                	mov    (%eax),%eax
c0109641:	99                   	cltd   
    }
}
c0109642:	5d                   	pop    %ebp
c0109643:	c3                   	ret    

c0109644 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109644:	55                   	push   %ebp
c0109645:	89 e5                	mov    %esp,%ebp
c0109647:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010964a:	8d 45 14             	lea    0x14(%ebp),%eax
c010964d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109650:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109653:	50                   	push   %eax
c0109654:	ff 75 10             	pushl  0x10(%ebp)
c0109657:	ff 75 0c             	pushl  0xc(%ebp)
c010965a:	ff 75 08             	pushl  0x8(%ebp)
c010965d:	e8 06 00 00 00       	call   c0109668 <vprintfmt>
c0109662:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0109665:	90                   	nop
c0109666:	c9                   	leave  
c0109667:	c3                   	ret    

c0109668 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109668:	55                   	push   %ebp
c0109669:	89 e5                	mov    %esp,%ebp
c010966b:	56                   	push   %esi
c010966c:	53                   	push   %ebx
c010966d:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109670:	eb 17                	jmp    c0109689 <vprintfmt+0x21>
            if (ch == '\0') {
c0109672:	85 db                	test   %ebx,%ebx
c0109674:	0f 84 8e 03 00 00    	je     c0109a08 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c010967a:	83 ec 08             	sub    $0x8,%esp
c010967d:	ff 75 0c             	pushl  0xc(%ebp)
c0109680:	53                   	push   %ebx
c0109681:	8b 45 08             	mov    0x8(%ebp),%eax
c0109684:	ff d0                	call   *%eax
c0109686:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109689:	8b 45 10             	mov    0x10(%ebp),%eax
c010968c:	8d 50 01             	lea    0x1(%eax),%edx
c010968f:	89 55 10             	mov    %edx,0x10(%ebp)
c0109692:	0f b6 00             	movzbl (%eax),%eax
c0109695:	0f b6 d8             	movzbl %al,%ebx
c0109698:	83 fb 25             	cmp    $0x25,%ebx
c010969b:	75 d5                	jne    c0109672 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010969d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01096a1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01096a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01096ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01096ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01096b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01096b8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01096bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01096be:	8d 50 01             	lea    0x1(%eax),%edx
c01096c1:	89 55 10             	mov    %edx,0x10(%ebp)
c01096c4:	0f b6 00             	movzbl (%eax),%eax
c01096c7:	0f b6 d8             	movzbl %al,%ebx
c01096ca:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01096cd:	83 f8 55             	cmp    $0x55,%eax
c01096d0:	0f 87 05 03 00 00    	ja     c01099db <vprintfmt+0x373>
c01096d6:	8b 04 85 a0 bf 10 c0 	mov    -0x3fef4060(,%eax,4),%eax
c01096dd:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01096df:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01096e3:	eb d6                	jmp    c01096bb <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01096e5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01096e9:	eb d0                	jmp    c01096bb <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01096eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01096f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01096f5:	89 d0                	mov    %edx,%eax
c01096f7:	c1 e0 02             	shl    $0x2,%eax
c01096fa:	01 d0                	add    %edx,%eax
c01096fc:	01 c0                	add    %eax,%eax
c01096fe:	01 d8                	add    %ebx,%eax
c0109700:	83 e8 30             	sub    $0x30,%eax
c0109703:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109706:	8b 45 10             	mov    0x10(%ebp),%eax
c0109709:	0f b6 00             	movzbl (%eax),%eax
c010970c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010970f:	83 fb 2f             	cmp    $0x2f,%ebx
c0109712:	7e 39                	jle    c010974d <vprintfmt+0xe5>
c0109714:	83 fb 39             	cmp    $0x39,%ebx
c0109717:	7f 34                	jg     c010974d <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109719:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010971d:	eb d3                	jmp    c01096f2 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010971f:	8b 45 14             	mov    0x14(%ebp),%eax
c0109722:	8d 50 04             	lea    0x4(%eax),%edx
c0109725:	89 55 14             	mov    %edx,0x14(%ebp)
c0109728:	8b 00                	mov    (%eax),%eax
c010972a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010972d:	eb 1f                	jmp    c010974e <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c010972f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109733:	79 86                	jns    c01096bb <vprintfmt+0x53>
                width = 0;
c0109735:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010973c:	e9 7a ff ff ff       	jmp    c01096bb <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0109741:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0109748:	e9 6e ff ff ff       	jmp    c01096bb <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c010974d:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c010974e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109752:	0f 89 63 ff ff ff    	jns    c01096bb <vprintfmt+0x53>
                width = precision, precision = -1;
c0109758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010975b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010975e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109765:	e9 51 ff ff ff       	jmp    c01096bb <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010976a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010976e:	e9 48 ff ff ff       	jmp    c01096bb <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109773:	8b 45 14             	mov    0x14(%ebp),%eax
c0109776:	8d 50 04             	lea    0x4(%eax),%edx
c0109779:	89 55 14             	mov    %edx,0x14(%ebp)
c010977c:	8b 00                	mov    (%eax),%eax
c010977e:	83 ec 08             	sub    $0x8,%esp
c0109781:	ff 75 0c             	pushl  0xc(%ebp)
c0109784:	50                   	push   %eax
c0109785:	8b 45 08             	mov    0x8(%ebp),%eax
c0109788:	ff d0                	call   *%eax
c010978a:	83 c4 10             	add    $0x10,%esp
            break;
c010978d:	e9 71 02 00 00       	jmp    c0109a03 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109792:	8b 45 14             	mov    0x14(%ebp),%eax
c0109795:	8d 50 04             	lea    0x4(%eax),%edx
c0109798:	89 55 14             	mov    %edx,0x14(%ebp)
c010979b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010979d:	85 db                	test   %ebx,%ebx
c010979f:	79 02                	jns    c01097a3 <vprintfmt+0x13b>
                err = -err;
c01097a1:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01097a3:	83 fb 06             	cmp    $0x6,%ebx
c01097a6:	7f 0b                	jg     c01097b3 <vprintfmt+0x14b>
c01097a8:	8b 34 9d 60 bf 10 c0 	mov    -0x3fef40a0(,%ebx,4),%esi
c01097af:	85 f6                	test   %esi,%esi
c01097b1:	75 19                	jne    c01097cc <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c01097b3:	53                   	push   %ebx
c01097b4:	68 8d bf 10 c0       	push   $0xc010bf8d
c01097b9:	ff 75 0c             	pushl  0xc(%ebp)
c01097bc:	ff 75 08             	pushl  0x8(%ebp)
c01097bf:	e8 80 fe ff ff       	call   c0109644 <printfmt>
c01097c4:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01097c7:	e9 37 02 00 00       	jmp    c0109a03 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01097cc:	56                   	push   %esi
c01097cd:	68 96 bf 10 c0       	push   $0xc010bf96
c01097d2:	ff 75 0c             	pushl  0xc(%ebp)
c01097d5:	ff 75 08             	pushl  0x8(%ebp)
c01097d8:	e8 67 fe ff ff       	call   c0109644 <printfmt>
c01097dd:	83 c4 10             	add    $0x10,%esp
            }
            break;
c01097e0:	e9 1e 02 00 00       	jmp    c0109a03 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01097e5:	8b 45 14             	mov    0x14(%ebp),%eax
c01097e8:	8d 50 04             	lea    0x4(%eax),%edx
c01097eb:	89 55 14             	mov    %edx,0x14(%ebp)
c01097ee:	8b 30                	mov    (%eax),%esi
c01097f0:	85 f6                	test   %esi,%esi
c01097f2:	75 05                	jne    c01097f9 <vprintfmt+0x191>
                p = "(null)";
c01097f4:	be 99 bf 10 c0       	mov    $0xc010bf99,%esi
            }
            if (width > 0 && padc != '-') {
c01097f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01097fd:	7e 76                	jle    c0109875 <vprintfmt+0x20d>
c01097ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109803:	74 70                	je     c0109875 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109808:	83 ec 08             	sub    $0x8,%esp
c010980b:	50                   	push   %eax
c010980c:	56                   	push   %esi
c010980d:	e8 17 f8 ff ff       	call   c0109029 <strnlen>
c0109812:	83 c4 10             	add    $0x10,%esp
c0109815:	89 c2                	mov    %eax,%edx
c0109817:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010981a:	29 d0                	sub    %edx,%eax
c010981c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010981f:	eb 17                	jmp    c0109838 <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0109821:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109825:	83 ec 08             	sub    $0x8,%esp
c0109828:	ff 75 0c             	pushl  0xc(%ebp)
c010982b:	50                   	push   %eax
c010982c:	8b 45 08             	mov    0x8(%ebp),%eax
c010982f:	ff d0                	call   *%eax
c0109831:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109834:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109838:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010983c:	7f e3                	jg     c0109821 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010983e:	eb 35                	jmp    c0109875 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109840:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109844:	74 1c                	je     c0109862 <vprintfmt+0x1fa>
c0109846:	83 fb 1f             	cmp    $0x1f,%ebx
c0109849:	7e 05                	jle    c0109850 <vprintfmt+0x1e8>
c010984b:	83 fb 7e             	cmp    $0x7e,%ebx
c010984e:	7e 12                	jle    c0109862 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0109850:	83 ec 08             	sub    $0x8,%esp
c0109853:	ff 75 0c             	pushl  0xc(%ebp)
c0109856:	6a 3f                	push   $0x3f
c0109858:	8b 45 08             	mov    0x8(%ebp),%eax
c010985b:	ff d0                	call   *%eax
c010985d:	83 c4 10             	add    $0x10,%esp
c0109860:	eb 0f                	jmp    c0109871 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0109862:	83 ec 08             	sub    $0x8,%esp
c0109865:	ff 75 0c             	pushl  0xc(%ebp)
c0109868:	53                   	push   %ebx
c0109869:	8b 45 08             	mov    0x8(%ebp),%eax
c010986c:	ff d0                	call   *%eax
c010986e:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109871:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109875:	89 f0                	mov    %esi,%eax
c0109877:	8d 70 01             	lea    0x1(%eax),%esi
c010987a:	0f b6 00             	movzbl (%eax),%eax
c010987d:	0f be d8             	movsbl %al,%ebx
c0109880:	85 db                	test   %ebx,%ebx
c0109882:	74 26                	je     c01098aa <vprintfmt+0x242>
c0109884:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109888:	78 b6                	js     c0109840 <vprintfmt+0x1d8>
c010988a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010988e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109892:	79 ac                	jns    c0109840 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109894:	eb 14                	jmp    c01098aa <vprintfmt+0x242>
                putch(' ', putdat);
c0109896:	83 ec 08             	sub    $0x8,%esp
c0109899:	ff 75 0c             	pushl  0xc(%ebp)
c010989c:	6a 20                	push   $0x20
c010989e:	8b 45 08             	mov    0x8(%ebp),%eax
c01098a1:	ff d0                	call   *%eax
c01098a3:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01098a6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01098aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01098ae:	7f e6                	jg     c0109896 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c01098b0:	e9 4e 01 00 00       	jmp    c0109a03 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01098b5:	83 ec 08             	sub    $0x8,%esp
c01098b8:	ff 75 e0             	pushl  -0x20(%ebp)
c01098bb:	8d 45 14             	lea    0x14(%ebp),%eax
c01098be:	50                   	push   %eax
c01098bf:	e8 39 fd ff ff       	call   c01095fd <getint>
c01098c4:	83 c4 10             	add    $0x10,%esp
c01098c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01098ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01098cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098d3:	85 d2                	test   %edx,%edx
c01098d5:	79 23                	jns    c01098fa <vprintfmt+0x292>
                putch('-', putdat);
c01098d7:	83 ec 08             	sub    $0x8,%esp
c01098da:	ff 75 0c             	pushl  0xc(%ebp)
c01098dd:	6a 2d                	push   $0x2d
c01098df:	8b 45 08             	mov    0x8(%ebp),%eax
c01098e2:	ff d0                	call   *%eax
c01098e4:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c01098e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098ed:	f7 d8                	neg    %eax
c01098ef:	83 d2 00             	adc    $0x0,%edx
c01098f2:	f7 da                	neg    %edx
c01098f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01098f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01098fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109901:	e9 9f 00 00 00       	jmp    c01099a5 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109906:	83 ec 08             	sub    $0x8,%esp
c0109909:	ff 75 e0             	pushl  -0x20(%ebp)
c010990c:	8d 45 14             	lea    0x14(%ebp),%eax
c010990f:	50                   	push   %eax
c0109910:	e8 99 fc ff ff       	call   c01095ae <getuint>
c0109915:	83 c4 10             	add    $0x10,%esp
c0109918:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010991b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010991e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109925:	eb 7e                	jmp    c01099a5 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109927:	83 ec 08             	sub    $0x8,%esp
c010992a:	ff 75 e0             	pushl  -0x20(%ebp)
c010992d:	8d 45 14             	lea    0x14(%ebp),%eax
c0109930:	50                   	push   %eax
c0109931:	e8 78 fc ff ff       	call   c01095ae <getuint>
c0109936:	83 c4 10             	add    $0x10,%esp
c0109939:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010993c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010993f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109946:	eb 5d                	jmp    c01099a5 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0109948:	83 ec 08             	sub    $0x8,%esp
c010994b:	ff 75 0c             	pushl  0xc(%ebp)
c010994e:	6a 30                	push   $0x30
c0109950:	8b 45 08             	mov    0x8(%ebp),%eax
c0109953:	ff d0                	call   *%eax
c0109955:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0109958:	83 ec 08             	sub    $0x8,%esp
c010995b:	ff 75 0c             	pushl  0xc(%ebp)
c010995e:	6a 78                	push   $0x78
c0109960:	8b 45 08             	mov    0x8(%ebp),%eax
c0109963:	ff d0                	call   *%eax
c0109965:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109968:	8b 45 14             	mov    0x14(%ebp),%eax
c010996b:	8d 50 04             	lea    0x4(%eax),%edx
c010996e:	89 55 14             	mov    %edx,0x14(%ebp)
c0109971:	8b 00                	mov    (%eax),%eax
c0109973:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109976:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010997d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109984:	eb 1f                	jmp    c01099a5 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109986:	83 ec 08             	sub    $0x8,%esp
c0109989:	ff 75 e0             	pushl  -0x20(%ebp)
c010998c:	8d 45 14             	lea    0x14(%ebp),%eax
c010998f:	50                   	push   %eax
c0109990:	e8 19 fc ff ff       	call   c01095ae <getuint>
c0109995:	83 c4 10             	add    $0x10,%esp
c0109998:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010999b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010999e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01099a5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01099a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01099ac:	83 ec 04             	sub    $0x4,%esp
c01099af:	52                   	push   %edx
c01099b0:	ff 75 e8             	pushl  -0x18(%ebp)
c01099b3:	50                   	push   %eax
c01099b4:	ff 75 f4             	pushl  -0xc(%ebp)
c01099b7:	ff 75 f0             	pushl  -0x10(%ebp)
c01099ba:	ff 75 0c             	pushl  0xc(%ebp)
c01099bd:	ff 75 08             	pushl  0x8(%ebp)
c01099c0:	e8 f8 fa ff ff       	call   c01094bd <printnum>
c01099c5:	83 c4 20             	add    $0x20,%esp
            break;
c01099c8:	eb 39                	jmp    c0109a03 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01099ca:	83 ec 08             	sub    $0x8,%esp
c01099cd:	ff 75 0c             	pushl  0xc(%ebp)
c01099d0:	53                   	push   %ebx
c01099d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01099d4:	ff d0                	call   *%eax
c01099d6:	83 c4 10             	add    $0x10,%esp
            break;
c01099d9:	eb 28                	jmp    c0109a03 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01099db:	83 ec 08             	sub    $0x8,%esp
c01099de:	ff 75 0c             	pushl  0xc(%ebp)
c01099e1:	6a 25                	push   $0x25
c01099e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01099e6:	ff d0                	call   *%eax
c01099e8:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c01099eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01099ef:	eb 04                	jmp    c01099f5 <vprintfmt+0x38d>
c01099f1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01099f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01099f8:	83 e8 01             	sub    $0x1,%eax
c01099fb:	0f b6 00             	movzbl (%eax),%eax
c01099fe:	3c 25                	cmp    $0x25,%al
c0109a00:	75 ef                	jne    c01099f1 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0109a02:	90                   	nop
        }
    }
c0109a03:	e9 68 fc ff ff       	jmp    c0109670 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0109a08:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109a09:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0109a0c:	5b                   	pop    %ebx
c0109a0d:	5e                   	pop    %esi
c0109a0e:	5d                   	pop    %ebp
c0109a0f:	c3                   	ret    

c0109a10 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109a10:	55                   	push   %ebp
c0109a11:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109a13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a16:	8b 40 08             	mov    0x8(%eax),%eax
c0109a19:	8d 50 01             	lea    0x1(%eax),%edx
c0109a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a1f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109a22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a25:	8b 10                	mov    (%eax),%edx
c0109a27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a2a:	8b 40 04             	mov    0x4(%eax),%eax
c0109a2d:	39 c2                	cmp    %eax,%edx
c0109a2f:	73 12                	jae    c0109a43 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109a31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a34:	8b 00                	mov    (%eax),%eax
c0109a36:	8d 48 01             	lea    0x1(%eax),%ecx
c0109a39:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109a3c:	89 0a                	mov    %ecx,(%edx)
c0109a3e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109a41:	88 10                	mov    %dl,(%eax)
    }
}
c0109a43:	90                   	nop
c0109a44:	5d                   	pop    %ebp
c0109a45:	c3                   	ret    

c0109a46 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109a46:	55                   	push   %ebp
c0109a47:	89 e5                	mov    %esp,%ebp
c0109a49:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109a4c:	8d 45 14             	lea    0x14(%ebp),%eax
c0109a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a55:	50                   	push   %eax
c0109a56:	ff 75 10             	pushl  0x10(%ebp)
c0109a59:	ff 75 0c             	pushl  0xc(%ebp)
c0109a5c:	ff 75 08             	pushl  0x8(%ebp)
c0109a5f:	e8 0b 00 00 00       	call   c0109a6f <vsnprintf>
c0109a64:	83 c4 10             	add    $0x10,%esp
c0109a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109a6d:	c9                   	leave  
c0109a6e:	c3                   	ret    

c0109a6f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109a6f:	55                   	push   %ebp
c0109a70:	89 e5                	mov    %esp,%ebp
c0109a72:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a78:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a7e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a84:	01 d0                	add    %edx,%eax
c0109a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109a90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109a94:	74 0a                	je     c0109aa0 <vsnprintf+0x31>
c0109a96:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a9c:	39 c2                	cmp    %eax,%edx
c0109a9e:	76 07                	jbe    c0109aa7 <vsnprintf+0x38>
        return -E_INVAL;
c0109aa0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109aa5:	eb 20                	jmp    c0109ac7 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109aa7:	ff 75 14             	pushl  0x14(%ebp)
c0109aaa:	ff 75 10             	pushl  0x10(%ebp)
c0109aad:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109ab0:	50                   	push   %eax
c0109ab1:	68 10 9a 10 c0       	push   $0xc0109a10
c0109ab6:	e8 ad fb ff ff       	call   c0109668 <vprintfmt>
c0109abb:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0109abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ac1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109ac7:	c9                   	leave  
c0109ac8:	c3                   	ret    

c0109ac9 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109ac9:	55                   	push   %ebp
c0109aca:	89 e5                	mov    %esp,%ebp
c0109acc:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c0109acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ad2:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109ad8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109adb:	b8 20 00 00 00       	mov    $0x20,%eax
c0109ae0:	2b 45 0c             	sub    0xc(%ebp),%eax
c0109ae3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109ae6:	89 c1                	mov    %eax,%ecx
c0109ae8:	d3 ea                	shr    %cl,%edx
c0109aea:	89 d0                	mov    %edx,%eax
}
c0109aec:	c9                   	leave  
c0109aed:	c3                   	ret    

c0109aee <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109aee:	55                   	push   %ebp
c0109aef:	89 e5                	mov    %esp,%ebp
c0109af1:	57                   	push   %edi
c0109af2:	56                   	push   %esi
c0109af3:	53                   	push   %ebx
c0109af4:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109af7:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c0109afc:	8b 15 c4 6a 12 c0    	mov    0xc0126ac4,%edx
c0109b02:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109b08:	6b f0 05             	imul   $0x5,%eax,%esi
c0109b0b:	01 fe                	add    %edi,%esi
c0109b0d:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0109b12:	f7 e7                	mul    %edi
c0109b14:	01 d6                	add    %edx,%esi
c0109b16:	89 f2                	mov    %esi,%edx
c0109b18:	83 c0 0b             	add    $0xb,%eax
c0109b1b:	83 d2 00             	adc    $0x0,%edx
c0109b1e:	89 c7                	mov    %eax,%edi
c0109b20:	83 e7 ff             	and    $0xffffffff,%edi
c0109b23:	89 f9                	mov    %edi,%ecx
c0109b25:	0f b7 da             	movzwl %dx,%ebx
c0109b28:	89 0d c0 6a 12 c0    	mov    %ecx,0xc0126ac0
c0109b2e:	89 1d c4 6a 12 c0    	mov    %ebx,0xc0126ac4
    unsigned long long result = (next >> 12);
c0109b34:	a1 c0 6a 12 c0       	mov    0xc0126ac0,%eax
c0109b39:	8b 15 c4 6a 12 c0    	mov    0xc0126ac4,%edx
c0109b3f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109b43:	c1 ea 0c             	shr    $0xc,%edx
c0109b46:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109b49:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109b4c:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109b56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109b59:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109b5c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b62:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109b65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109b69:	74 1c                	je     c0109b87 <rand+0x99>
c0109b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b6e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109b73:	f7 75 dc             	divl   -0x24(%ebp)
c0109b76:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b7c:	ba 00 00 00 00       	mov    $0x0,%edx
c0109b81:	f7 75 dc             	divl   -0x24(%ebp)
c0109b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109b87:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109b8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109b8d:	f7 75 dc             	divl   -0x24(%ebp)
c0109b90:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109b93:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109b96:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109b99:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109b9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109b9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109ba2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109ba5:	83 c4 24             	add    $0x24,%esp
c0109ba8:	5b                   	pop    %ebx
c0109ba9:	5e                   	pop    %esi
c0109baa:	5f                   	pop    %edi
c0109bab:	5d                   	pop    %ebp
c0109bac:	c3                   	ret    

c0109bad <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109bad:	55                   	push   %ebp
c0109bae:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bb3:	ba 00 00 00 00       	mov    $0x0,%edx
c0109bb8:	a3 c0 6a 12 c0       	mov    %eax,0xc0126ac0
c0109bbd:	89 15 c4 6a 12 c0    	mov    %edx,0xc0126ac4
}
c0109bc3:	90                   	nop
c0109bc4:	5d                   	pop    %ebp
c0109bc5:	c3                   	ret    
