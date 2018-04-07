
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
c0100055:	e8 7b 83 00 00       	call   c01083d5 <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 ab 1d 00 00       	call   c0101e0d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 60 8c 10 c0 	movl   $0xc0108c60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 7c 8c 10 c0       	push   $0xc0108c7c
c0100074:	e8 11 02 00 00       	call   c010028a <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 93 08 00 00       	call   c0100914 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 83 00 00 00       	call   c0100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 18 6e 00 00       	call   c0106ea3 <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 ef 1e 00 00       	call   c0101f7f <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 71 20 00 00       	call   c0102106 <idt_init>

    vmm_init();                 // init virtual memory management
c0100095:	e8 55 3d 00 00       	call   c0103def <vmm_init>

    ide_init();                 // init ide devices
c010009a:	e8 3d 0d 00 00       	call   c0100ddc <ide_init>
    swap_init();                // init swap
c010009f:	e8 24 4b 00 00       	call   c0104bc8 <swap_init>

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
c0100152:	68 81 8c 10 c0       	push   $0xc0108c81
c0100157:	e8 2e 01 00 00       	call   c010028a <cprintf>
c010015c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010015f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100163:	0f b7 d0             	movzwl %ax,%edx
c0100166:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c010016b:	83 ec 04             	sub    $0x4,%esp
c010016e:	52                   	push   %edx
c010016f:	50                   	push   %eax
c0100170:	68 8f 8c 10 c0       	push   $0xc0108c8f
c0100175:	e8 10 01 00 00       	call   c010028a <cprintf>
c010017a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010017d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100181:	0f b7 d0             	movzwl %ax,%edx
c0100184:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100189:	83 ec 04             	sub    $0x4,%esp
c010018c:	52                   	push   %edx
c010018d:	50                   	push   %eax
c010018e:	68 9d 8c 10 c0       	push   $0xc0108c9d
c0100193:	e8 f2 00 00 00       	call   c010028a <cprintf>
c0100198:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c010019b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010019f:	0f b7 d0             	movzwl %ax,%edx
c01001a2:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001a7:	83 ec 04             	sub    $0x4,%esp
c01001aa:	52                   	push   %edx
c01001ab:	50                   	push   %eax
c01001ac:	68 ab 8c 10 c0       	push   $0xc0108cab
c01001b1:	e8 d4 00 00 00       	call   c010028a <cprintf>
c01001b6:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001b9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001bd:	0f b7 d0             	movzwl %ax,%edx
c01001c0:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001c5:	83 ec 04             	sub    $0x4,%esp
c01001c8:	52                   	push   %edx
c01001c9:	50                   	push   %eax
c01001ca:	68 b9 8c 10 c0       	push   $0xc0108cb9
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
c0100209:	68 c8 8c 10 c0       	push   $0xc0108cc8
c010020e:	e8 77 00 00 00       	call   c010028a <cprintf>
c0100213:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100216:	e8 cc ff ff ff       	call   c01001e7 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021b:	e8 0a ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	68 e8 8c 10 c0       	push   $0xc0108ce8
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
c010027d:	e8 89 84 00 00       	call   c010870b <vprintfmt>
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
c0100340:	68 07 8d 10 c0       	push   $0xc0108d07
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
c0100418:	68 0a 8d 10 c0       	push   $0xc0108d0a
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
c010043a:	68 26 8d 10 c0       	push   $0xc0108d26
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
c0100473:	68 28 8d 10 c0       	push   $0xc0108d28
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
c0100495:	68 26 8d 10 c0       	push   $0xc0108d26
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
c010060f:	c7 00 48 8d 10 c0    	movl   $0xc0108d48,(%eax)
    info->eip_line = 0;
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100622:	c7 40 08 48 8d 10 c0 	movl   $0xc0108d48,0x8(%eax)
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
c0100646:	c7 45 f4 c0 ae 10 c0 	movl   $0xc010aec0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010064d:	c7 45 f0 88 af 11 c0 	movl   $0xc011af88,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100654:	c7 45 ec 89 af 11 c0 	movl   $0xc011af89,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010065b:	c7 45 e8 73 eb 11 c0 	movl   $0xc011eb73,-0x18(%ebp)

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
c0100795:	e8 af 7a 00 00       	call   c0108249 <strfind>
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
c010091d:	68 52 8d 10 c0       	push   $0xc0108d52
c0100922:	e8 63 f9 ff ff       	call   c010028a <cprintf>
c0100927:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010092a:	83 ec 08             	sub    $0x8,%esp
c010092d:	68 36 00 10 c0       	push   $0xc0100036
c0100932:	68 6b 8d 10 c0       	push   $0xc0108d6b
c0100937:	e8 4e f9 ff ff       	call   c010028a <cprintf>
c010093c:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010093f:	83 ec 08             	sub    $0x8,%esp
c0100942:	68 44 8c 10 c0       	push   $0xc0108c44
c0100947:	68 83 8d 10 c0       	push   $0xc0108d83
c010094c:	e8 39 f9 ff ff       	call   c010028a <cprintf>
c0100951:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100954:	83 ec 08             	sub    $0x8,%esp
c0100957:	68 00 40 12 c0       	push   $0xc0124000
c010095c:	68 9b 8d 10 c0       	push   $0xc0108d9b
c0100961:	e8 24 f9 ff ff       	call   c010028a <cprintf>
c0100966:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100969:	83 ec 08             	sub    $0x8,%esp
c010096c:	68 5c 51 12 c0       	push   $0xc012515c
c0100971:	68 b3 8d 10 c0       	push   $0xc0108db3
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
c01009a1:	68 cc 8d 10 c0       	push   $0xc0108dcc
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
c01009d6:	68 f6 8d 10 c0       	push   $0xc0108df6
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
c0100a3d:	68 12 8e 10 c0       	push   $0xc0108e12
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
c0100a8d:	68 24 8e 10 c0       	push   $0xc0108e24
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
c0100adb:	68 3c 8e 10 c0       	push   $0xc0108e3c
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
c0100b5c:	68 e0 8e 10 c0       	push   $0xc0108ee0
c0100b61:	e8 b0 76 00 00       	call   c0108216 <strchr>
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
c0100b82:	68 e5 8e 10 c0       	push   $0xc0108ee5
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
c0100bca:	68 e0 8e 10 c0       	push   $0xc0108ee0
c0100bcf:	e8 42 76 00 00       	call   c0108216 <strchr>
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
c0100c35:	e8 3c 75 00 00       	call   c0108176 <strcmp>
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
c0100c82:	68 03 8f 10 c0       	push   $0xc0108f03
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
c0100c9f:	68 1c 8f 10 c0       	push   $0xc0108f1c
c0100ca4:	e8 e1 f5 ff ff       	call   c010028a <cprintf>
c0100ca9:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100cac:	83 ec 0c             	sub    $0xc,%esp
c0100caf:	68 44 8f 10 c0       	push   $0xc0108f44
c0100cb4:	e8 d1 f5 ff ff       	call   c010028a <cprintf>
c0100cb9:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100cbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cc0:	74 0e                	je     c0100cd0 <kmonitor+0x3a>
        print_trapframe(tf);
c0100cc2:	83 ec 0c             	sub    $0xc,%esp
c0100cc5:	ff 75 08             	pushl  0x8(%ebp)
c0100cc8:	e8 f1 15 00 00       	call   c01022be <print_trapframe>
c0100ccd:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cd0:	83 ec 0c             	sub    $0xc,%esp
c0100cd3:	68 69 8f 10 c0       	push   $0xc0108f69
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
c0100d3e:	68 6d 8f 10 c0       	push   $0xc0108f6d
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
c0100e16:	0f b7 04 85 78 8f 10 	movzwl -0x3fef7088(,%eax,4),%eax
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
c0100fa3:	68 80 8f 10 c0       	push   $0xc0108f80
c0100fa8:	68 c3 8f 10 c0       	push   $0xc0108fc3
c0100fad:	6a 7d                	push   $0x7d
c0100faf:	68 d8 8f 10 c0       	push   $0xc0108fd8
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
c0101098:	68 ea 8f 10 c0       	push   $0xc0108fea
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
c010119d:	68 08 90 10 c0       	push   $0xc0109008
c01011a2:	68 c3 8f 10 c0       	push   $0xc0108fc3
c01011a7:	68 9f 00 00 00       	push   $0x9f
c01011ac:	68 d8 8f 10 c0       	push   $0xc0108fd8
c01011b1:	e8 3a f2 ff ff       	call   c01003f0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011b6:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01011bd:	77 0f                	ja     c01011ce <ide_read_secs+0x6e>
c01011bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01011c2:	8b 45 14             	mov    0x14(%ebp),%eax
c01011c5:	01 d0                	add    %edx,%eax
c01011c7:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01011cc:	76 19                	jbe    c01011e7 <ide_read_secs+0x87>
c01011ce:	68 30 90 10 c0       	push   $0xc0109030
c01011d3:	68 c3 8f 10 c0       	push   $0xc0108fc3
c01011d8:	68 a0 00 00 00       	push   $0xa0
c01011dd:	68 d8 8f 10 c0       	push   $0xc0108fd8
c01011e2:	e8 09 f2 ff ff       	call   c01003f0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c01011e7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011eb:	66 d1 e8             	shr    %ax
c01011ee:	0f b7 c0             	movzwl %ax,%eax
c01011f1:	0f b7 04 85 78 8f 10 	movzwl -0x3fef7088(,%eax,4),%eax
c01011f8:	c0 
c01011f9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01011fd:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101201:	66 d1 e8             	shr    %ax
c0101204:	0f b7 c0             	movzwl %ax,%eax
c0101207:	0f b7 04 85 7a 8f 10 	movzwl -0x3fef7086(,%eax,4),%eax
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
c01013c7:	68 08 90 10 c0       	push   $0xc0109008
c01013cc:	68 c3 8f 10 c0       	push   $0xc0108fc3
c01013d1:	68 bc 00 00 00       	push   $0xbc
c01013d6:	68 d8 8f 10 c0       	push   $0xc0108fd8
c01013db:	e8 10 f0 ff ff       	call   c01003f0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01013e0:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01013e7:	77 0f                	ja     c01013f8 <ide_write_secs+0x6e>
c01013e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01013ec:	8b 45 14             	mov    0x14(%ebp),%eax
c01013ef:	01 d0                	add    %edx,%eax
c01013f1:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01013f6:	76 19                	jbe    c0101411 <ide_write_secs+0x87>
c01013f8:	68 30 90 10 c0       	push   $0xc0109030
c01013fd:	68 c3 8f 10 c0       	push   $0xc0108fc3
c0101402:	68 bd 00 00 00       	push   $0xbd
c0101407:	68 d8 8f 10 c0       	push   $0xc0108fd8
c010140c:	e8 df ef ff ff       	call   c01003f0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101411:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101415:	66 d1 e8             	shr    %ax
c0101418:	0f b7 c0             	movzwl %ax,%eax
c010141b:	0f b7 04 85 78 8f 10 	movzwl -0x3fef7088(,%eax,4),%eax
c0101422:	c0 
c0101423:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101427:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010142b:	66 d1 e8             	shr    %ax
c010142e:	0f b7 c0             	movzwl %ax,%eax
c0101431:	0f b7 04 85 7a 8f 10 	movzwl -0x3fef7086(,%eax,4),%eax
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
c0101600:	68 6a 90 10 c0       	push   $0xc010906a
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
c0101a29:	e8 e7 69 00 00       	call   c0108415 <memmove>
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
c0101db4:	68 85 90 10 c0       	push   $0xc0109085
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
c0101e2e:	68 91 90 10 c0       	push   $0xc0109091
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
c01020d5:	68 c0 90 10 c0       	push   $0xc01090c0
c01020da:	e8 ab e1 ff ff       	call   c010028a <cprintf>
c01020df:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01020e2:	83 ec 0c             	sub    $0xc,%esp
c01020e5:	68 ca 90 10 c0       	push   $0xc01090ca
c01020ea:	e8 9b e1 ff ff       	call   c010028a <cprintf>
c01020ef:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01020f2:	83 ec 04             	sub    $0x4,%esp
c01020f5:	68 d8 90 10 c0       	push   $0xc01090d8
c01020fa:	6a 14                	push   $0x14
c01020fc:	68 ee 90 10 c0       	push   $0xc01090ee
c0102101:	e8 ea e2 ff ff       	call   c01003f0 <__panic>

c0102106 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102106:	55                   	push   %ebp
c0102107:	89 e5                	mov    %esp,%ebp
c0102109:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c010210c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102113:	e9 c3 00 00 00       	jmp    c01021db <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102118:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010211b:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c0102122:	89 c2                	mov    %eax,%edx
c0102124:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102127:	66 89 14 c5 60 47 12 	mov    %dx,-0x3fedb8a0(,%eax,8)
c010212e:	c0 
c010212f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102132:	66 c7 04 c5 62 47 12 	movw   $0x8,-0x3fedb89e(,%eax,8)
c0102139:	c0 08 00 
c010213c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213f:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c0102146:	c0 
c0102147:	83 e2 e0             	and    $0xffffffe0,%edx
c010214a:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c0102151:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102154:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c010215b:	c0 
c010215c:	83 e2 1f             	and    $0x1f,%edx
c010215f:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c0102166:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102169:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c0102170:	c0 
c0102171:	83 e2 f0             	and    $0xfffffff0,%edx
c0102174:	83 ca 0e             	or     $0xe,%edx
c0102177:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c010217e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102181:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c0102188:	c0 
c0102189:	83 e2 ef             	and    $0xffffffef,%edx
c010218c:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c0102193:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102196:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c010219d:	c0 
c010219e:	83 e2 9f             	and    $0xffffff9f,%edx
c01021a1:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ab:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021b2:	c0 
c01021b3:	83 ca 80             	or     $0xffffff80,%edx
c01021b6:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021c0:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c01021c7:	c1 e8 10             	shr    $0x10,%eax
c01021ca:	89 c2                	mov    %eax,%edx
c01021cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021cf:	66 89 14 c5 66 47 12 	mov    %dx,-0x3fedb89a(,%eax,8)
c01021d6:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // 1. get vectors
    extern uintptr_t __vectors[];
    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c01021d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021db:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01021e2:	0f 8e 30 ff ff ff    	jle    c0102118 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01021e8:	a1 c4 17 12 c0       	mov    0xc01217c4,%eax
c01021ed:	66 a3 28 4b 12 c0    	mov    %ax,0xc0124b28
c01021f3:	66 c7 05 2a 4b 12 c0 	movw   $0x8,0xc0124b2a
c01021fa:	08 00 
c01021fc:	0f b6 05 2c 4b 12 c0 	movzbl 0xc0124b2c,%eax
c0102203:	83 e0 e0             	and    $0xffffffe0,%eax
c0102206:	a2 2c 4b 12 c0       	mov    %al,0xc0124b2c
c010220b:	0f b6 05 2c 4b 12 c0 	movzbl 0xc0124b2c,%eax
c0102212:	83 e0 1f             	and    $0x1f,%eax
c0102215:	a2 2c 4b 12 c0       	mov    %al,0xc0124b2c
c010221a:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102221:	83 e0 f0             	and    $0xfffffff0,%eax
c0102224:	83 c8 0e             	or     $0xe,%eax
c0102227:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c010222c:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102233:	83 e0 ef             	and    $0xffffffef,%eax
c0102236:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c010223b:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102242:	83 c8 60             	or     $0x60,%eax
c0102245:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c010224a:	0f b6 05 2d 4b 12 c0 	movzbl 0xc0124b2d,%eax
c0102251:	83 c8 80             	or     $0xffffff80,%eax
c0102254:	a2 2d 4b 12 c0       	mov    %al,0xc0124b2d
c0102259:	a1 c4 17 12 c0       	mov    0xc01217c4,%eax
c010225e:	c1 e8 10             	shr    $0x10,%eax
c0102261:	66 a3 2e 4b 12 c0    	mov    %ax,0xc0124b2e
c0102267:	c7 45 f8 60 15 12 c0 	movl   $0xc0121560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010226e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102271:	0f 01 18             	lidtl  (%eax)
    // 3. LIDT
    lidt(&idt_pd);
}
c0102274:	90                   	nop
c0102275:	c9                   	leave  
c0102276:	c3                   	ret    

c0102277 <trapname>:

static const char *
trapname(int trapno) {
c0102277:	55                   	push   %ebp
c0102278:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010227a:	8b 45 08             	mov    0x8(%ebp),%eax
c010227d:	83 f8 13             	cmp    $0x13,%eax
c0102280:	77 0c                	ja     c010228e <trapname+0x17>
        return excnames[trapno];
c0102282:	8b 45 08             	mov    0x8(%ebp),%eax
c0102285:	8b 04 85 a0 94 10 c0 	mov    -0x3fef6b60(,%eax,4),%eax
c010228c:	eb 18                	jmp    c01022a6 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010228e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102292:	7e 0d                	jle    c01022a1 <trapname+0x2a>
c0102294:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102298:	7f 07                	jg     c01022a1 <trapname+0x2a>
        return "Hardware Interrupt";
c010229a:	b8 ff 90 10 c0       	mov    $0xc01090ff,%eax
c010229f:	eb 05                	jmp    c01022a6 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022a1:	b8 12 91 10 c0       	mov    $0xc0109112,%eax
}
c01022a6:	5d                   	pop    %ebp
c01022a7:	c3                   	ret    

c01022a8 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022a8:	55                   	push   %ebp
c01022a9:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ae:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022b2:	66 83 f8 08          	cmp    $0x8,%ax
c01022b6:	0f 94 c0             	sete   %al
c01022b9:	0f b6 c0             	movzbl %al,%eax
}
c01022bc:	5d                   	pop    %ebp
c01022bd:	c3                   	ret    

c01022be <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022be:	55                   	push   %ebp
c01022bf:	89 e5                	mov    %esp,%ebp
c01022c1:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c01022c4:	83 ec 08             	sub    $0x8,%esp
c01022c7:	ff 75 08             	pushl  0x8(%ebp)
c01022ca:	68 53 91 10 c0       	push   $0xc0109153
c01022cf:	e8 b6 df ff ff       	call   c010028a <cprintf>
c01022d4:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c01022d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01022da:	83 ec 0c             	sub    $0xc,%esp
c01022dd:	50                   	push   %eax
c01022de:	e8 b8 01 00 00       	call   c010249b <print_regs>
c01022e3:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022ed:	0f b7 c0             	movzwl %ax,%eax
c01022f0:	83 ec 08             	sub    $0x8,%esp
c01022f3:	50                   	push   %eax
c01022f4:	68 64 91 10 c0       	push   $0xc0109164
c01022f9:	e8 8c df ff ff       	call   c010028a <cprintf>
c01022fe:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102301:	8b 45 08             	mov    0x8(%ebp),%eax
c0102304:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102308:	0f b7 c0             	movzwl %ax,%eax
c010230b:	83 ec 08             	sub    $0x8,%esp
c010230e:	50                   	push   %eax
c010230f:	68 77 91 10 c0       	push   $0xc0109177
c0102314:	e8 71 df ff ff       	call   c010028a <cprintf>
c0102319:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010231c:	8b 45 08             	mov    0x8(%ebp),%eax
c010231f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102323:	0f b7 c0             	movzwl %ax,%eax
c0102326:	83 ec 08             	sub    $0x8,%esp
c0102329:	50                   	push   %eax
c010232a:	68 8a 91 10 c0       	push   $0xc010918a
c010232f:	e8 56 df ff ff       	call   c010028a <cprintf>
c0102334:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102337:	8b 45 08             	mov    0x8(%ebp),%eax
c010233a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010233e:	0f b7 c0             	movzwl %ax,%eax
c0102341:	83 ec 08             	sub    $0x8,%esp
c0102344:	50                   	push   %eax
c0102345:	68 9d 91 10 c0       	push   $0xc010919d
c010234a:	e8 3b df ff ff       	call   c010028a <cprintf>
c010234f:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102352:	8b 45 08             	mov    0x8(%ebp),%eax
c0102355:	8b 40 30             	mov    0x30(%eax),%eax
c0102358:	83 ec 0c             	sub    $0xc,%esp
c010235b:	50                   	push   %eax
c010235c:	e8 16 ff ff ff       	call   c0102277 <trapname>
c0102361:	83 c4 10             	add    $0x10,%esp
c0102364:	89 c2                	mov    %eax,%edx
c0102366:	8b 45 08             	mov    0x8(%ebp),%eax
c0102369:	8b 40 30             	mov    0x30(%eax),%eax
c010236c:	83 ec 04             	sub    $0x4,%esp
c010236f:	52                   	push   %edx
c0102370:	50                   	push   %eax
c0102371:	68 b0 91 10 c0       	push   $0xc01091b0
c0102376:	e8 0f df ff ff       	call   c010028a <cprintf>
c010237b:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c010237e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102381:	8b 40 34             	mov    0x34(%eax),%eax
c0102384:	83 ec 08             	sub    $0x8,%esp
c0102387:	50                   	push   %eax
c0102388:	68 c2 91 10 c0       	push   $0xc01091c2
c010238d:	e8 f8 de ff ff       	call   c010028a <cprintf>
c0102392:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102395:	8b 45 08             	mov    0x8(%ebp),%eax
c0102398:	8b 40 38             	mov    0x38(%eax),%eax
c010239b:	83 ec 08             	sub    $0x8,%esp
c010239e:	50                   	push   %eax
c010239f:	68 d1 91 10 c0       	push   $0xc01091d1
c01023a4:	e8 e1 de ff ff       	call   c010028a <cprintf>
c01023a9:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01023af:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023b3:	0f b7 c0             	movzwl %ax,%eax
c01023b6:	83 ec 08             	sub    $0x8,%esp
c01023b9:	50                   	push   %eax
c01023ba:	68 e0 91 10 c0       	push   $0xc01091e0
c01023bf:	e8 c6 de ff ff       	call   c010028a <cprintf>
c01023c4:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ca:	8b 40 40             	mov    0x40(%eax),%eax
c01023cd:	83 ec 08             	sub    $0x8,%esp
c01023d0:	50                   	push   %eax
c01023d1:	68 f3 91 10 c0       	push   $0xc01091f3
c01023d6:	e8 af de ff ff       	call   c010028a <cprintf>
c01023db:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023ec:	eb 3f                	jmp    c010242d <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f1:	8b 50 40             	mov    0x40(%eax),%edx
c01023f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023f7:	21 d0                	and    %edx,%eax
c01023f9:	85 c0                	test   %eax,%eax
c01023fb:	74 29                	je     c0102426 <print_trapframe+0x168>
c01023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102400:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c0102407:	85 c0                	test   %eax,%eax
c0102409:	74 1b                	je     c0102426 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c010240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010240e:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c0102415:	83 ec 08             	sub    $0x8,%esp
c0102418:	50                   	push   %eax
c0102419:	68 02 92 10 c0       	push   $0xc0109202
c010241e:	e8 67 de ff ff       	call   c010028a <cprintf>
c0102423:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010242a:	d1 65 f0             	shll   -0x10(%ebp)
c010242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102430:	83 f8 17             	cmp    $0x17,%eax
c0102433:	76 b9                	jbe    c01023ee <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102435:	8b 45 08             	mov    0x8(%ebp),%eax
c0102438:	8b 40 40             	mov    0x40(%eax),%eax
c010243b:	25 00 30 00 00       	and    $0x3000,%eax
c0102440:	c1 e8 0c             	shr    $0xc,%eax
c0102443:	83 ec 08             	sub    $0x8,%esp
c0102446:	50                   	push   %eax
c0102447:	68 06 92 10 c0       	push   $0xc0109206
c010244c:	e8 39 de ff ff       	call   c010028a <cprintf>
c0102451:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0102454:	83 ec 0c             	sub    $0xc,%esp
c0102457:	ff 75 08             	pushl  0x8(%ebp)
c010245a:	e8 49 fe ff ff       	call   c01022a8 <trap_in_kernel>
c010245f:	83 c4 10             	add    $0x10,%esp
c0102462:	85 c0                	test   %eax,%eax
c0102464:	75 32                	jne    c0102498 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102466:	8b 45 08             	mov    0x8(%ebp),%eax
c0102469:	8b 40 44             	mov    0x44(%eax),%eax
c010246c:	83 ec 08             	sub    $0x8,%esp
c010246f:	50                   	push   %eax
c0102470:	68 0f 92 10 c0       	push   $0xc010920f
c0102475:	e8 10 de ff ff       	call   c010028a <cprintf>
c010247a:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010247d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102480:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102484:	0f b7 c0             	movzwl %ax,%eax
c0102487:	83 ec 08             	sub    $0x8,%esp
c010248a:	50                   	push   %eax
c010248b:	68 1e 92 10 c0       	push   $0xc010921e
c0102490:	e8 f5 dd ff ff       	call   c010028a <cprintf>
c0102495:	83 c4 10             	add    $0x10,%esp
    }
}
c0102498:	90                   	nop
c0102499:	c9                   	leave  
c010249a:	c3                   	ret    

c010249b <print_regs>:

void
print_regs(struct pushregs *regs) {
c010249b:	55                   	push   %ebp
c010249c:	89 e5                	mov    %esp,%ebp
c010249e:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a4:	8b 00                	mov    (%eax),%eax
c01024a6:	83 ec 08             	sub    $0x8,%esp
c01024a9:	50                   	push   %eax
c01024aa:	68 31 92 10 c0       	push   $0xc0109231
c01024af:	e8 d6 dd ff ff       	call   c010028a <cprintf>
c01024b4:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ba:	8b 40 04             	mov    0x4(%eax),%eax
c01024bd:	83 ec 08             	sub    $0x8,%esp
c01024c0:	50                   	push   %eax
c01024c1:	68 40 92 10 c0       	push   $0xc0109240
c01024c6:	e8 bf dd ff ff       	call   c010028a <cprintf>
c01024cb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d1:	8b 40 08             	mov    0x8(%eax),%eax
c01024d4:	83 ec 08             	sub    $0x8,%esp
c01024d7:	50                   	push   %eax
c01024d8:	68 4f 92 10 c0       	push   $0xc010924f
c01024dd:	e8 a8 dd ff ff       	call   c010028a <cprintf>
c01024e2:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e8:	8b 40 0c             	mov    0xc(%eax),%eax
c01024eb:	83 ec 08             	sub    $0x8,%esp
c01024ee:	50                   	push   %eax
c01024ef:	68 5e 92 10 c0       	push   $0xc010925e
c01024f4:	e8 91 dd ff ff       	call   c010028a <cprintf>
c01024f9:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ff:	8b 40 10             	mov    0x10(%eax),%eax
c0102502:	83 ec 08             	sub    $0x8,%esp
c0102505:	50                   	push   %eax
c0102506:	68 6d 92 10 c0       	push   $0xc010926d
c010250b:	e8 7a dd ff ff       	call   c010028a <cprintf>
c0102510:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102513:	8b 45 08             	mov    0x8(%ebp),%eax
c0102516:	8b 40 14             	mov    0x14(%eax),%eax
c0102519:	83 ec 08             	sub    $0x8,%esp
c010251c:	50                   	push   %eax
c010251d:	68 7c 92 10 c0       	push   $0xc010927c
c0102522:	e8 63 dd ff ff       	call   c010028a <cprintf>
c0102527:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010252a:	8b 45 08             	mov    0x8(%ebp),%eax
c010252d:	8b 40 18             	mov    0x18(%eax),%eax
c0102530:	83 ec 08             	sub    $0x8,%esp
c0102533:	50                   	push   %eax
c0102534:	68 8b 92 10 c0       	push   $0xc010928b
c0102539:	e8 4c dd ff ff       	call   c010028a <cprintf>
c010253e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102541:	8b 45 08             	mov    0x8(%ebp),%eax
c0102544:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102547:	83 ec 08             	sub    $0x8,%esp
c010254a:	50                   	push   %eax
c010254b:	68 9a 92 10 c0       	push   $0xc010929a
c0102550:	e8 35 dd ff ff       	call   c010028a <cprintf>
c0102555:	83 c4 10             	add    $0x10,%esp
}
c0102558:	90                   	nop
c0102559:	c9                   	leave  
c010255a:	c3                   	ret    

c010255b <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010255b:	55                   	push   %ebp
c010255c:	89 e5                	mov    %esp,%ebp
c010255e:	53                   	push   %ebx
c010255f:	83 ec 14             	sub    $0x14,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102562:	8b 45 08             	mov    0x8(%ebp),%eax
c0102565:	8b 40 34             	mov    0x34(%eax),%eax
c0102568:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010256b:	85 c0                	test   %eax,%eax
c010256d:	74 07                	je     c0102576 <print_pgfault+0x1b>
c010256f:	bb a9 92 10 c0       	mov    $0xc01092a9,%ebx
c0102574:	eb 05                	jmp    c010257b <print_pgfault+0x20>
c0102576:	bb ba 92 10 c0       	mov    $0xc01092ba,%ebx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010257b:	8b 45 08             	mov    0x8(%ebp),%eax
c010257e:	8b 40 34             	mov    0x34(%eax),%eax
c0102581:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102584:	85 c0                	test   %eax,%eax
c0102586:	74 07                	je     c010258f <print_pgfault+0x34>
c0102588:	b9 57 00 00 00       	mov    $0x57,%ecx
c010258d:	eb 05                	jmp    c0102594 <print_pgfault+0x39>
c010258f:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102594:	8b 45 08             	mov    0x8(%ebp),%eax
c0102597:	8b 40 34             	mov    0x34(%eax),%eax
c010259a:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010259d:	85 c0                	test   %eax,%eax
c010259f:	74 07                	je     c01025a8 <print_pgfault+0x4d>
c01025a1:	ba 55 00 00 00       	mov    $0x55,%edx
c01025a6:	eb 05                	jmp    c01025ad <print_pgfault+0x52>
c01025a8:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025ad:	0f 20 d0             	mov    %cr2,%eax
c01025b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025b6:	83 ec 0c             	sub    $0xc,%esp
c01025b9:	53                   	push   %ebx
c01025ba:	51                   	push   %ecx
c01025bb:	52                   	push   %edx
c01025bc:	50                   	push   %eax
c01025bd:	68 c8 92 10 c0       	push   $0xc01092c8
c01025c2:	e8 c3 dc ff ff       	call   c010028a <cprintf>
c01025c7:	83 c4 20             	add    $0x20,%esp
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025ca:	90                   	nop
c01025cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01025ce:	c9                   	leave  
c01025cf:	c3                   	ret    

c01025d0 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025d0:	55                   	push   %ebp
c01025d1:	89 e5                	mov    %esp,%ebp
c01025d3:	83 ec 18             	sub    $0x18,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025d6:	83 ec 0c             	sub    $0xc,%esp
c01025d9:	ff 75 08             	pushl  0x8(%ebp)
c01025dc:	e8 7a ff ff ff       	call   c010255b <print_pgfault>
c01025e1:	83 c4 10             	add    $0x10,%esp
    if (check_mm_struct != NULL) {
c01025e4:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c01025e9:	85 c0                	test   %eax,%eax
c01025eb:	74 24                	je     c0102611 <pgfault_handler+0x41>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025ed:	0f 20 d0             	mov    %cr2,%eax
c01025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f9:	8b 50 34             	mov    0x34(%eax),%edx
c01025fc:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c0102601:	83 ec 04             	sub    $0x4,%esp
c0102604:	51                   	push   %ecx
c0102605:	52                   	push   %edx
c0102606:	50                   	push   %eax
c0102607:	e8 64 1e 00 00       	call   c0104470 <do_pgfault>
c010260c:	83 c4 10             	add    $0x10,%esp
c010260f:	eb 17                	jmp    c0102628 <pgfault_handler+0x58>
    }
    panic("unhandled page fault.\n");
c0102611:	83 ec 04             	sub    $0x4,%esp
c0102614:	68 eb 92 10 c0       	push   $0xc01092eb
c0102619:	68 a9 00 00 00       	push   $0xa9
c010261e:	68 ee 90 10 c0       	push   $0xc01090ee
c0102623:	e8 c8 dd ff ff       	call   c01003f0 <__panic>
}
c0102628:	c9                   	leave  
c0102629:	c3                   	ret    

c010262a <trap_dispatch>:
// LAB1 YOU SHOULD ALSO COPY THIS
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

static void
trap_dispatch(struct trapframe *tf) {
c010262a:	55                   	push   %ebp
c010262b:	89 e5                	mov    %esp,%ebp
c010262d:	57                   	push   %edi
c010262e:	56                   	push   %esi
c010262f:	53                   	push   %ebx
c0102630:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102633:	8b 45 08             	mov    0x8(%ebp),%eax
c0102636:	8b 40 30             	mov    0x30(%eax),%eax
c0102639:	83 f8 24             	cmp    $0x24,%eax
c010263c:	0f 84 c8 00 00 00    	je     c010270a <trap_dispatch+0xe0>
c0102642:	83 f8 24             	cmp    $0x24,%eax
c0102645:	77 1c                	ja     c0102663 <trap_dispatch+0x39>
c0102647:	83 f8 20             	cmp    $0x20,%eax
c010264a:	0f 84 80 00 00 00    	je     c01026d0 <trap_dispatch+0xa6>
c0102650:	83 f8 21             	cmp    $0x21,%eax
c0102653:	0f 84 d8 00 00 00    	je     c0102731 <trap_dispatch+0x107>
c0102659:	83 f8 0e             	cmp    $0xe,%eax
c010265c:	74 32                	je     c0102690 <trap_dispatch+0x66>
c010265e:	e9 98 01 00 00       	jmp    c01027fb <trap_dispatch+0x1d1>
c0102663:	83 f8 78             	cmp    $0x78,%eax
c0102666:	0f 84 ec 00 00 00    	je     c0102758 <trap_dispatch+0x12e>
c010266c:	83 f8 78             	cmp    $0x78,%eax
c010266f:	77 11                	ja     c0102682 <trap_dispatch+0x58>
c0102671:	83 e8 2e             	sub    $0x2e,%eax
c0102674:	83 f8 01             	cmp    $0x1,%eax
c0102677:	0f 87 7e 01 00 00    	ja     c01027fb <trap_dispatch+0x1d1>
    // end of copy

    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010267d:	e9 b3 01 00 00       	jmp    c0102835 <trap_dispatch+0x20b>
trap_dispatch(struct trapframe *tf) {
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102682:	83 f8 79             	cmp    $0x79,%eax
c0102685:	0f 84 42 01 00 00    	je     c01027cd <trap_dispatch+0x1a3>
c010268b:	e9 6b 01 00 00       	jmp    c01027fb <trap_dispatch+0x1d1>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102690:	83 ec 0c             	sub    $0xc,%esp
c0102693:	ff 75 08             	pushl  0x8(%ebp)
c0102696:	e8 35 ff ff ff       	call   c01025d0 <pgfault_handler>
c010269b:	83 c4 10             	add    $0x10,%esp
c010269e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01026a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01026a5:	0f 84 86 01 00 00    	je     c0102831 <trap_dispatch+0x207>
            print_trapframe(tf);
c01026ab:	83 ec 0c             	sub    $0xc,%esp
c01026ae:	ff 75 08             	pushl  0x8(%ebp)
c01026b1:	e8 08 fc ff ff       	call   c01022be <print_trapframe>
c01026b6:	83 c4 10             	add    $0x10,%esp
            panic("handle pgfault failed. %e\n", ret);
c01026b9:	ff 75 e4             	pushl  -0x1c(%ebp)
c01026bc:	68 02 93 10 c0       	push   $0xc0109302
c01026c1:	68 bd 00 00 00       	push   $0xbd
c01026c6:	68 ee 90 10 c0       	push   $0xc01090ee
c01026cb:	e8 20 dd ff ff       	call   c01003f0 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c01026d0:	a1 0c 50 12 c0       	mov    0xc012500c,%eax
c01026d5:	83 c0 01             	add    $0x1,%eax
c01026d8:	a3 0c 50 12 c0       	mov    %eax,0xc012500c
        if (ticks % TICK_NUM == 0) {
c01026dd:	8b 0d 0c 50 12 c0    	mov    0xc012500c,%ecx
c01026e3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01026e8:	89 c8                	mov    %ecx,%eax
c01026ea:	f7 e2                	mul    %edx
c01026ec:	89 d0                	mov    %edx,%eax
c01026ee:	c1 e8 05             	shr    $0x5,%eax
c01026f1:	6b c0 64             	imul   $0x64,%eax,%eax
c01026f4:	29 c1                	sub    %eax,%ecx
c01026f6:	89 c8                	mov    %ecx,%eax
c01026f8:	85 c0                	test   %eax,%eax
c01026fa:	0f 85 34 01 00 00    	jne    c0102834 <trap_dispatch+0x20a>
            print_ticks();
c0102700:	e8 c5 f9 ff ff       	call   c01020ca <print_ticks>
        }
        break;
c0102705:	e9 2a 01 00 00       	jmp    c0102834 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c010270a:	e8 78 f7 ff ff       	call   c0101e87 <cons_getc>
c010270f:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102712:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c0102716:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c010271a:	83 ec 04             	sub    $0x4,%esp
c010271d:	52                   	push   %edx
c010271e:	50                   	push   %eax
c010271f:	68 1d 93 10 c0       	push   $0xc010931d
c0102724:	e8 61 db ff ff       	call   c010028a <cprintf>
c0102729:	83 c4 10             	add    $0x10,%esp
        break;
c010272c:	e9 04 01 00 00       	jmp    c0102835 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102731:	e8 51 f7 ff ff       	call   c0101e87 <cons_getc>
c0102736:	88 45 e3             	mov    %al,-0x1d(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102739:	0f be 55 e3          	movsbl -0x1d(%ebp),%edx
c010273d:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
c0102741:	83 ec 04             	sub    $0x4,%esp
c0102744:	52                   	push   %edx
c0102745:	50                   	push   %eax
c0102746:	68 2f 93 10 c0       	push   $0xc010932f
c010274b:	e8 3a db ff ff       	call   c010028a <cprintf>
c0102750:	83 c4 10             	add    $0x10,%esp
        break;
c0102753:	e9 dd 00 00 00       	jmp    c0102835 <trap_dispatch+0x20b>
        
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
c0102758:	8b 55 08             	mov    0x8(%ebp),%edx
c010275b:	b8 20 50 12 c0       	mov    $0xc0125020,%eax
c0102760:	89 d3                	mov    %edx,%ebx
c0102762:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0102767:	8b 0b                	mov    (%ebx),%ecx
c0102769:	89 08                	mov    %ecx,(%eax)
c010276b:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c010276f:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0102773:	8d 78 04             	lea    0x4(%eax),%edi
c0102776:	83 e7 fc             	and    $0xfffffffc,%edi
c0102779:	29 f8                	sub    %edi,%eax
c010277b:	29 c3                	sub    %eax,%ebx
c010277d:	01 c2                	add    %eax,%edx
c010277f:	83 e2 fc             	and    $0xfffffffc,%edx
c0102782:	89 d0                	mov    %edx,%eax
c0102784:	c1 e8 02             	shr    $0x2,%eax
c0102787:	89 de                	mov    %ebx,%esi
c0102789:	89 c1                	mov    %eax,%ecx
c010278b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
c010278d:	66 c7 05 5c 50 12 c0 	movw   $0x1b,0xc012505c
c0102794:	1b 00 
        switchk2u.tf_ds = USER_DS;
c0102796:	66 c7 05 4c 50 12 c0 	movw   $0x23,0xc012504c
c010279d:	23 00 
        switchk2u.tf_es = USER_DS;
c010279f:	66 c7 05 48 50 12 c0 	movw   $0x23,0xc0125048
c01027a6:	23 00 
        switchk2u.tf_ss = USER_DS;
c01027a8:	66 c7 05 68 50 12 c0 	movw   $0x23,0xc0125068
c01027af:	23 00 
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c01027b1:	a1 60 50 12 c0       	mov    0xc0125060,%eax
c01027b6:	80 cc 30             	or     $0x30,%ah
c01027b9:	a3 60 50 12 c0       	mov    %eax,0xc0125060
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c01027be:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c1:	83 e8 04             	sub    $0x4,%eax
c01027c4:	ba 20 50 12 c0       	mov    $0xc0125020,%edx
c01027c9:	89 10                	mov    %edx,(%eax)
        break;
c01027cb:	eb 68                	jmp    c0102835 <trap_dispatch+0x20b>
    case T_SWITCH_TOK:
        tf->tf_cs = KERNEL_CS;
c01027cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d0:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c01027d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d9:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c01027df:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e2:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c01027e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01027eb:	8b 40 40             	mov    0x40(%eax),%eax
c01027ee:	80 e4 cf             	and    $0xcf,%ah
c01027f1:	89 c2                	mov    %eax,%edx
c01027f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01027f6:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c01027f9:	eb 3a                	jmp    c0102835 <trap_dispatch+0x20b>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01027fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01027fe:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102802:	0f b7 c0             	movzwl %ax,%eax
c0102805:	83 e0 03             	and    $0x3,%eax
c0102808:	85 c0                	test   %eax,%eax
c010280a:	75 29                	jne    c0102835 <trap_dispatch+0x20b>
            print_trapframe(tf);
c010280c:	83 ec 0c             	sub    $0xc,%esp
c010280f:	ff 75 08             	pushl  0x8(%ebp)
c0102812:	e8 a7 fa ff ff       	call   c01022be <print_trapframe>
c0102817:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c010281a:	83 ec 04             	sub    $0x4,%esp
c010281d:	68 3e 93 10 c0       	push   $0xc010933e
c0102822:	68 f3 00 00 00       	push   $0xf3
c0102827:	68 ee 90 10 c0       	push   $0xc01090ee
c010282c:	e8 bf db ff ff       	call   c01003f0 <__panic>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c0102831:	90                   	nop
c0102832:	eb 01                	jmp    c0102835 <trap_dispatch+0x20b>
         */
        ticks++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
c0102834:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102835:	90                   	nop
c0102836:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102839:	5b                   	pop    %ebx
c010283a:	5e                   	pop    %esi
c010283b:	5f                   	pop    %edi
c010283c:	5d                   	pop    %ebp
c010283d:	c3                   	ret    

c010283e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010283e:	55                   	push   %ebp
c010283f:	89 e5                	mov    %esp,%ebp
c0102841:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102844:	83 ec 0c             	sub    $0xc,%esp
c0102847:	ff 75 08             	pushl  0x8(%ebp)
c010284a:	e8 db fd ff ff       	call   c010262a <trap_dispatch>
c010284f:	83 c4 10             	add    $0x10,%esp
}
c0102852:	90                   	nop
c0102853:	c9                   	leave  
c0102854:	c3                   	ret    

c0102855 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $0
c0102857:	6a 00                	push   $0x0
  jmp __alltraps
c0102859:	e9 69 0a 00 00       	jmp    c01032c7 <__alltraps>

c010285e <vector1>:
.globl vector1
vector1:
  pushl $0
c010285e:	6a 00                	push   $0x0
  pushl $1
c0102860:	6a 01                	push   $0x1
  jmp __alltraps
c0102862:	e9 60 0a 00 00       	jmp    c01032c7 <__alltraps>

c0102867 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $2
c0102869:	6a 02                	push   $0x2
  jmp __alltraps
c010286b:	e9 57 0a 00 00       	jmp    c01032c7 <__alltraps>

c0102870 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $3
c0102872:	6a 03                	push   $0x3
  jmp __alltraps
c0102874:	e9 4e 0a 00 00       	jmp    c01032c7 <__alltraps>

c0102879 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $4
c010287b:	6a 04                	push   $0x4
  jmp __alltraps
c010287d:	e9 45 0a 00 00       	jmp    c01032c7 <__alltraps>

c0102882 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102882:	6a 00                	push   $0x0
  pushl $5
c0102884:	6a 05                	push   $0x5
  jmp __alltraps
c0102886:	e9 3c 0a 00 00       	jmp    c01032c7 <__alltraps>

c010288b <vector6>:
.globl vector6
vector6:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $6
c010288d:	6a 06                	push   $0x6
  jmp __alltraps
c010288f:	e9 33 0a 00 00       	jmp    c01032c7 <__alltraps>

c0102894 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $7
c0102896:	6a 07                	push   $0x7
  jmp __alltraps
c0102898:	e9 2a 0a 00 00       	jmp    c01032c7 <__alltraps>

c010289d <vector8>:
.globl vector8
vector8:
  pushl $8
c010289d:	6a 08                	push   $0x8
  jmp __alltraps
c010289f:	e9 23 0a 00 00       	jmp    c01032c7 <__alltraps>

c01028a4 <vector9>:
.globl vector9
vector9:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $9
c01028a6:	6a 09                	push   $0x9
  jmp __alltraps
c01028a8:	e9 1a 0a 00 00       	jmp    c01032c7 <__alltraps>

c01028ad <vector10>:
.globl vector10
vector10:
  pushl $10
c01028ad:	6a 0a                	push   $0xa
  jmp __alltraps
c01028af:	e9 13 0a 00 00       	jmp    c01032c7 <__alltraps>

c01028b4 <vector11>:
.globl vector11
vector11:
  pushl $11
c01028b4:	6a 0b                	push   $0xb
  jmp __alltraps
c01028b6:	e9 0c 0a 00 00       	jmp    c01032c7 <__alltraps>

c01028bb <vector12>:
.globl vector12
vector12:
  pushl $12
c01028bb:	6a 0c                	push   $0xc
  jmp __alltraps
c01028bd:	e9 05 0a 00 00       	jmp    c01032c7 <__alltraps>

c01028c2 <vector13>:
.globl vector13
vector13:
  pushl $13
c01028c2:	6a 0d                	push   $0xd
  jmp __alltraps
c01028c4:	e9 fe 09 00 00       	jmp    c01032c7 <__alltraps>

c01028c9 <vector14>:
.globl vector14
vector14:
  pushl $14
c01028c9:	6a 0e                	push   $0xe
  jmp __alltraps
c01028cb:	e9 f7 09 00 00       	jmp    c01032c7 <__alltraps>

c01028d0 <vector15>:
.globl vector15
vector15:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $15
c01028d2:	6a 0f                	push   $0xf
  jmp __alltraps
c01028d4:	e9 ee 09 00 00       	jmp    c01032c7 <__alltraps>

c01028d9 <vector16>:
.globl vector16
vector16:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $16
c01028db:	6a 10                	push   $0x10
  jmp __alltraps
c01028dd:	e9 e5 09 00 00       	jmp    c01032c7 <__alltraps>

c01028e2 <vector17>:
.globl vector17
vector17:
  pushl $17
c01028e2:	6a 11                	push   $0x11
  jmp __alltraps
c01028e4:	e9 de 09 00 00       	jmp    c01032c7 <__alltraps>

c01028e9 <vector18>:
.globl vector18
vector18:
  pushl $0
c01028e9:	6a 00                	push   $0x0
  pushl $18
c01028eb:	6a 12                	push   $0x12
  jmp __alltraps
c01028ed:	e9 d5 09 00 00       	jmp    c01032c7 <__alltraps>

c01028f2 <vector19>:
.globl vector19
vector19:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $19
c01028f4:	6a 13                	push   $0x13
  jmp __alltraps
c01028f6:	e9 cc 09 00 00       	jmp    c01032c7 <__alltraps>

c01028fb <vector20>:
.globl vector20
vector20:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $20
c01028fd:	6a 14                	push   $0x14
  jmp __alltraps
c01028ff:	e9 c3 09 00 00       	jmp    c01032c7 <__alltraps>

c0102904 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102904:	6a 00                	push   $0x0
  pushl $21
c0102906:	6a 15                	push   $0x15
  jmp __alltraps
c0102908:	e9 ba 09 00 00       	jmp    c01032c7 <__alltraps>

c010290d <vector22>:
.globl vector22
vector22:
  pushl $0
c010290d:	6a 00                	push   $0x0
  pushl $22
c010290f:	6a 16                	push   $0x16
  jmp __alltraps
c0102911:	e9 b1 09 00 00       	jmp    c01032c7 <__alltraps>

c0102916 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $23
c0102918:	6a 17                	push   $0x17
  jmp __alltraps
c010291a:	e9 a8 09 00 00       	jmp    c01032c7 <__alltraps>

c010291f <vector24>:
.globl vector24
vector24:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $24
c0102921:	6a 18                	push   $0x18
  jmp __alltraps
c0102923:	e9 9f 09 00 00       	jmp    c01032c7 <__alltraps>

c0102928 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102928:	6a 00                	push   $0x0
  pushl $25
c010292a:	6a 19                	push   $0x19
  jmp __alltraps
c010292c:	e9 96 09 00 00       	jmp    c01032c7 <__alltraps>

c0102931 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102931:	6a 00                	push   $0x0
  pushl $26
c0102933:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102935:	e9 8d 09 00 00       	jmp    c01032c7 <__alltraps>

c010293a <vector27>:
.globl vector27
vector27:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $27
c010293c:	6a 1b                	push   $0x1b
  jmp __alltraps
c010293e:	e9 84 09 00 00       	jmp    c01032c7 <__alltraps>

c0102943 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $28
c0102945:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102947:	e9 7b 09 00 00       	jmp    c01032c7 <__alltraps>

c010294c <vector29>:
.globl vector29
vector29:
  pushl $0
c010294c:	6a 00                	push   $0x0
  pushl $29
c010294e:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102950:	e9 72 09 00 00       	jmp    c01032c7 <__alltraps>

c0102955 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102955:	6a 00                	push   $0x0
  pushl $30
c0102957:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102959:	e9 69 09 00 00       	jmp    c01032c7 <__alltraps>

c010295e <vector31>:
.globl vector31
vector31:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $31
c0102960:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102962:	e9 60 09 00 00       	jmp    c01032c7 <__alltraps>

c0102967 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $32
c0102969:	6a 20                	push   $0x20
  jmp __alltraps
c010296b:	e9 57 09 00 00       	jmp    c01032c7 <__alltraps>

c0102970 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102970:	6a 00                	push   $0x0
  pushl $33
c0102972:	6a 21                	push   $0x21
  jmp __alltraps
c0102974:	e9 4e 09 00 00       	jmp    c01032c7 <__alltraps>

c0102979 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102979:	6a 00                	push   $0x0
  pushl $34
c010297b:	6a 22                	push   $0x22
  jmp __alltraps
c010297d:	e9 45 09 00 00       	jmp    c01032c7 <__alltraps>

c0102982 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $35
c0102984:	6a 23                	push   $0x23
  jmp __alltraps
c0102986:	e9 3c 09 00 00       	jmp    c01032c7 <__alltraps>

c010298b <vector36>:
.globl vector36
vector36:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $36
c010298d:	6a 24                	push   $0x24
  jmp __alltraps
c010298f:	e9 33 09 00 00       	jmp    c01032c7 <__alltraps>

c0102994 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102994:	6a 00                	push   $0x0
  pushl $37
c0102996:	6a 25                	push   $0x25
  jmp __alltraps
c0102998:	e9 2a 09 00 00       	jmp    c01032c7 <__alltraps>

c010299d <vector38>:
.globl vector38
vector38:
  pushl $0
c010299d:	6a 00                	push   $0x0
  pushl $38
c010299f:	6a 26                	push   $0x26
  jmp __alltraps
c01029a1:	e9 21 09 00 00       	jmp    c01032c7 <__alltraps>

c01029a6 <vector39>:
.globl vector39
vector39:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $39
c01029a8:	6a 27                	push   $0x27
  jmp __alltraps
c01029aa:	e9 18 09 00 00       	jmp    c01032c7 <__alltraps>

c01029af <vector40>:
.globl vector40
vector40:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $40
c01029b1:	6a 28                	push   $0x28
  jmp __alltraps
c01029b3:	e9 0f 09 00 00       	jmp    c01032c7 <__alltraps>

c01029b8 <vector41>:
.globl vector41
vector41:
  pushl $0
c01029b8:	6a 00                	push   $0x0
  pushl $41
c01029ba:	6a 29                	push   $0x29
  jmp __alltraps
c01029bc:	e9 06 09 00 00       	jmp    c01032c7 <__alltraps>

c01029c1 <vector42>:
.globl vector42
vector42:
  pushl $0
c01029c1:	6a 00                	push   $0x0
  pushl $42
c01029c3:	6a 2a                	push   $0x2a
  jmp __alltraps
c01029c5:	e9 fd 08 00 00       	jmp    c01032c7 <__alltraps>

c01029ca <vector43>:
.globl vector43
vector43:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $43
c01029cc:	6a 2b                	push   $0x2b
  jmp __alltraps
c01029ce:	e9 f4 08 00 00       	jmp    c01032c7 <__alltraps>

c01029d3 <vector44>:
.globl vector44
vector44:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $44
c01029d5:	6a 2c                	push   $0x2c
  jmp __alltraps
c01029d7:	e9 eb 08 00 00       	jmp    c01032c7 <__alltraps>

c01029dc <vector45>:
.globl vector45
vector45:
  pushl $0
c01029dc:	6a 00                	push   $0x0
  pushl $45
c01029de:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029e0:	e9 e2 08 00 00       	jmp    c01032c7 <__alltraps>

c01029e5 <vector46>:
.globl vector46
vector46:
  pushl $0
c01029e5:	6a 00                	push   $0x0
  pushl $46
c01029e7:	6a 2e                	push   $0x2e
  jmp __alltraps
c01029e9:	e9 d9 08 00 00       	jmp    c01032c7 <__alltraps>

c01029ee <vector47>:
.globl vector47
vector47:
  pushl $0
c01029ee:	6a 00                	push   $0x0
  pushl $47
c01029f0:	6a 2f                	push   $0x2f
  jmp __alltraps
c01029f2:	e9 d0 08 00 00       	jmp    c01032c7 <__alltraps>

c01029f7 <vector48>:
.globl vector48
vector48:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $48
c01029f9:	6a 30                	push   $0x30
  jmp __alltraps
c01029fb:	e9 c7 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a00 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102a00:	6a 00                	push   $0x0
  pushl $49
c0102a02:	6a 31                	push   $0x31
  jmp __alltraps
c0102a04:	e9 be 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a09 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102a09:	6a 00                	push   $0x0
  pushl $50
c0102a0b:	6a 32                	push   $0x32
  jmp __alltraps
c0102a0d:	e9 b5 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a12 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102a12:	6a 00                	push   $0x0
  pushl $51
c0102a14:	6a 33                	push   $0x33
  jmp __alltraps
c0102a16:	e9 ac 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a1b <vector52>:
.globl vector52
vector52:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $52
c0102a1d:	6a 34                	push   $0x34
  jmp __alltraps
c0102a1f:	e9 a3 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a24 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102a24:	6a 00                	push   $0x0
  pushl $53
c0102a26:	6a 35                	push   $0x35
  jmp __alltraps
c0102a28:	e9 9a 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a2d <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a2d:	6a 00                	push   $0x0
  pushl $54
c0102a2f:	6a 36                	push   $0x36
  jmp __alltraps
c0102a31:	e9 91 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a36 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $55
c0102a38:	6a 37                	push   $0x37
  jmp __alltraps
c0102a3a:	e9 88 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a3f <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $56
c0102a41:	6a 38                	push   $0x38
  jmp __alltraps
c0102a43:	e9 7f 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a48 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a48:	6a 00                	push   $0x0
  pushl $57
c0102a4a:	6a 39                	push   $0x39
  jmp __alltraps
c0102a4c:	e9 76 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a51 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a51:	6a 00                	push   $0x0
  pushl $58
c0102a53:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a55:	e9 6d 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a5a <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $59
c0102a5c:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a5e:	e9 64 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a63 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $60
c0102a65:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a67:	e9 5b 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a6c <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a6c:	6a 00                	push   $0x0
  pushl $61
c0102a6e:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a70:	e9 52 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a75 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a75:	6a 00                	push   $0x0
  pushl $62
c0102a77:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a79:	e9 49 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a7e <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $63
c0102a80:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a82:	e9 40 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a87 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $64
c0102a89:	6a 40                	push   $0x40
  jmp __alltraps
c0102a8b:	e9 37 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a90 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a90:	6a 00                	push   $0x0
  pushl $65
c0102a92:	6a 41                	push   $0x41
  jmp __alltraps
c0102a94:	e9 2e 08 00 00       	jmp    c01032c7 <__alltraps>

c0102a99 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a99:	6a 00                	push   $0x0
  pushl $66
c0102a9b:	6a 42                	push   $0x42
  jmp __alltraps
c0102a9d:	e9 25 08 00 00       	jmp    c01032c7 <__alltraps>

c0102aa2 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $67
c0102aa4:	6a 43                	push   $0x43
  jmp __alltraps
c0102aa6:	e9 1c 08 00 00       	jmp    c01032c7 <__alltraps>

c0102aab <vector68>:
.globl vector68
vector68:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $68
c0102aad:	6a 44                	push   $0x44
  jmp __alltraps
c0102aaf:	e9 13 08 00 00       	jmp    c01032c7 <__alltraps>

c0102ab4 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102ab4:	6a 00                	push   $0x0
  pushl $69
c0102ab6:	6a 45                	push   $0x45
  jmp __alltraps
c0102ab8:	e9 0a 08 00 00       	jmp    c01032c7 <__alltraps>

c0102abd <vector70>:
.globl vector70
vector70:
  pushl $0
c0102abd:	6a 00                	push   $0x0
  pushl $70
c0102abf:	6a 46                	push   $0x46
  jmp __alltraps
c0102ac1:	e9 01 08 00 00       	jmp    c01032c7 <__alltraps>

c0102ac6 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $71
c0102ac8:	6a 47                	push   $0x47
  jmp __alltraps
c0102aca:	e9 f8 07 00 00       	jmp    c01032c7 <__alltraps>

c0102acf <vector72>:
.globl vector72
vector72:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $72
c0102ad1:	6a 48                	push   $0x48
  jmp __alltraps
c0102ad3:	e9 ef 07 00 00       	jmp    c01032c7 <__alltraps>

c0102ad8 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102ad8:	6a 00                	push   $0x0
  pushl $73
c0102ada:	6a 49                	push   $0x49
  jmp __alltraps
c0102adc:	e9 e6 07 00 00       	jmp    c01032c7 <__alltraps>

c0102ae1 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $74
c0102ae3:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102ae5:	e9 dd 07 00 00       	jmp    c01032c7 <__alltraps>

c0102aea <vector75>:
.globl vector75
vector75:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $75
c0102aec:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102aee:	e9 d4 07 00 00       	jmp    c01032c7 <__alltraps>

c0102af3 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $76
c0102af5:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102af7:	e9 cb 07 00 00       	jmp    c01032c7 <__alltraps>

c0102afc <vector77>:
.globl vector77
vector77:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $77
c0102afe:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102b00:	e9 c2 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b05 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $78
c0102b07:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102b09:	e9 b9 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b0e <vector79>:
.globl vector79
vector79:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $79
c0102b10:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102b12:	e9 b0 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b17 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $80
c0102b19:	6a 50                	push   $0x50
  jmp __alltraps
c0102b1b:	e9 a7 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b20 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102b20:	6a 00                	push   $0x0
  pushl $81
c0102b22:	6a 51                	push   $0x51
  jmp __alltraps
c0102b24:	e9 9e 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b29 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $82
c0102b2b:	6a 52                	push   $0x52
  jmp __alltraps
c0102b2d:	e9 95 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b32 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $83
c0102b34:	6a 53                	push   $0x53
  jmp __alltraps
c0102b36:	e9 8c 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b3b <vector84>:
.globl vector84
vector84:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $84
c0102b3d:	6a 54                	push   $0x54
  jmp __alltraps
c0102b3f:	e9 83 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b44 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b44:	6a 00                	push   $0x0
  pushl $85
c0102b46:	6a 55                	push   $0x55
  jmp __alltraps
c0102b48:	e9 7a 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b4d <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b4d:	6a 00                	push   $0x0
  pushl $86
c0102b4f:	6a 56                	push   $0x56
  jmp __alltraps
c0102b51:	e9 71 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b56 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $87
c0102b58:	6a 57                	push   $0x57
  jmp __alltraps
c0102b5a:	e9 68 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b5f <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $88
c0102b61:	6a 58                	push   $0x58
  jmp __alltraps
c0102b63:	e9 5f 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b68 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b68:	6a 00                	push   $0x0
  pushl $89
c0102b6a:	6a 59                	push   $0x59
  jmp __alltraps
c0102b6c:	e9 56 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b71 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b71:	6a 00                	push   $0x0
  pushl $90
c0102b73:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b75:	e9 4d 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b7a <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $91
c0102b7c:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b7e:	e9 44 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b83 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $92
c0102b85:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b87:	e9 3b 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b8c <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b8c:	6a 00                	push   $0x0
  pushl $93
c0102b8e:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b90:	e9 32 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b95 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b95:	6a 00                	push   $0x0
  pushl $94
c0102b97:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b99:	e9 29 07 00 00       	jmp    c01032c7 <__alltraps>

c0102b9e <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $95
c0102ba0:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102ba2:	e9 20 07 00 00       	jmp    c01032c7 <__alltraps>

c0102ba7 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $96
c0102ba9:	6a 60                	push   $0x60
  jmp __alltraps
c0102bab:	e9 17 07 00 00       	jmp    c01032c7 <__alltraps>

c0102bb0 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102bb0:	6a 00                	push   $0x0
  pushl $97
c0102bb2:	6a 61                	push   $0x61
  jmp __alltraps
c0102bb4:	e9 0e 07 00 00       	jmp    c01032c7 <__alltraps>

c0102bb9 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102bb9:	6a 00                	push   $0x0
  pushl $98
c0102bbb:	6a 62                	push   $0x62
  jmp __alltraps
c0102bbd:	e9 05 07 00 00       	jmp    c01032c7 <__alltraps>

c0102bc2 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102bc2:	6a 00                	push   $0x0
  pushl $99
c0102bc4:	6a 63                	push   $0x63
  jmp __alltraps
c0102bc6:	e9 fc 06 00 00       	jmp    c01032c7 <__alltraps>

c0102bcb <vector100>:
.globl vector100
vector100:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $100
c0102bcd:	6a 64                	push   $0x64
  jmp __alltraps
c0102bcf:	e9 f3 06 00 00       	jmp    c01032c7 <__alltraps>

c0102bd4 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $101
c0102bd6:	6a 65                	push   $0x65
  jmp __alltraps
c0102bd8:	e9 ea 06 00 00       	jmp    c01032c7 <__alltraps>

c0102bdd <vector102>:
.globl vector102
vector102:
  pushl $0
c0102bdd:	6a 00                	push   $0x0
  pushl $102
c0102bdf:	6a 66                	push   $0x66
  jmp __alltraps
c0102be1:	e9 e1 06 00 00       	jmp    c01032c7 <__alltraps>

c0102be6 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $103
c0102be8:	6a 67                	push   $0x67
  jmp __alltraps
c0102bea:	e9 d8 06 00 00       	jmp    c01032c7 <__alltraps>

c0102bef <vector104>:
.globl vector104
vector104:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $104
c0102bf1:	6a 68                	push   $0x68
  jmp __alltraps
c0102bf3:	e9 cf 06 00 00       	jmp    c01032c7 <__alltraps>

c0102bf8 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $105
c0102bfa:	6a 69                	push   $0x69
  jmp __alltraps
c0102bfc:	e9 c6 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c01 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102c01:	6a 00                	push   $0x0
  pushl $106
c0102c03:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102c05:	e9 bd 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c0a <vector107>:
.globl vector107
vector107:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $107
c0102c0c:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102c0e:	e9 b4 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c13 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $108
c0102c15:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102c17:	e9 ab 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c1c <vector109>:
.globl vector109
vector109:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $109
c0102c1e:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102c20:	e9 a2 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c25 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102c25:	6a 00                	push   $0x0
  pushl $110
c0102c27:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c29:	e9 99 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c2e <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c2e:	6a 00                	push   $0x0
  pushl $111
c0102c30:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c32:	e9 90 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c37 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102c37:	6a 00                	push   $0x0
  pushl $112
c0102c39:	6a 70                	push   $0x70
  jmp __alltraps
c0102c3b:	e9 87 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c40 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $113
c0102c42:	6a 71                	push   $0x71
  jmp __alltraps
c0102c44:	e9 7e 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c49 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c49:	6a 00                	push   $0x0
  pushl $114
c0102c4b:	6a 72                	push   $0x72
  jmp __alltraps
c0102c4d:	e9 75 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c52 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c52:	6a 00                	push   $0x0
  pushl $115
c0102c54:	6a 73                	push   $0x73
  jmp __alltraps
c0102c56:	e9 6c 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c5b <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c5b:	6a 00                	push   $0x0
  pushl $116
c0102c5d:	6a 74                	push   $0x74
  jmp __alltraps
c0102c5f:	e9 63 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c64 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $117
c0102c66:	6a 75                	push   $0x75
  jmp __alltraps
c0102c68:	e9 5a 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c6d <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c6d:	6a 00                	push   $0x0
  pushl $118
c0102c6f:	6a 76                	push   $0x76
  jmp __alltraps
c0102c71:	e9 51 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c76 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c76:	6a 00                	push   $0x0
  pushl $119
c0102c78:	6a 77                	push   $0x77
  jmp __alltraps
c0102c7a:	e9 48 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c7f <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c7f:	6a 00                	push   $0x0
  pushl $120
c0102c81:	6a 78                	push   $0x78
  jmp __alltraps
c0102c83:	e9 3f 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c88 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $121
c0102c8a:	6a 79                	push   $0x79
  jmp __alltraps
c0102c8c:	e9 36 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c91 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c91:	6a 00                	push   $0x0
  pushl $122
c0102c93:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c95:	e9 2d 06 00 00       	jmp    c01032c7 <__alltraps>

c0102c9a <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c9a:	6a 00                	push   $0x0
  pushl $123
c0102c9c:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c9e:	e9 24 06 00 00       	jmp    c01032c7 <__alltraps>

c0102ca3 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102ca3:	6a 00                	push   $0x0
  pushl $124
c0102ca5:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102ca7:	e9 1b 06 00 00       	jmp    c01032c7 <__alltraps>

c0102cac <vector125>:
.globl vector125
vector125:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $125
c0102cae:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102cb0:	e9 12 06 00 00       	jmp    c01032c7 <__alltraps>

c0102cb5 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102cb5:	6a 00                	push   $0x0
  pushl $126
c0102cb7:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102cb9:	e9 09 06 00 00       	jmp    c01032c7 <__alltraps>

c0102cbe <vector127>:
.globl vector127
vector127:
  pushl $0
c0102cbe:	6a 00                	push   $0x0
  pushl $127
c0102cc0:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102cc2:	e9 00 06 00 00       	jmp    c01032c7 <__alltraps>

c0102cc7 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102cc7:	6a 00                	push   $0x0
  pushl $128
c0102cc9:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102cce:	e9 f4 05 00 00       	jmp    c01032c7 <__alltraps>

c0102cd3 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102cd3:	6a 00                	push   $0x0
  pushl $129
c0102cd5:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102cda:	e9 e8 05 00 00       	jmp    c01032c7 <__alltraps>

c0102cdf <vector130>:
.globl vector130
vector130:
  pushl $0
c0102cdf:	6a 00                	push   $0x0
  pushl $130
c0102ce1:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102ce6:	e9 dc 05 00 00       	jmp    c01032c7 <__alltraps>

c0102ceb <vector131>:
.globl vector131
vector131:
  pushl $0
c0102ceb:	6a 00                	push   $0x0
  pushl $131
c0102ced:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102cf2:	e9 d0 05 00 00       	jmp    c01032c7 <__alltraps>

c0102cf7 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102cf7:	6a 00                	push   $0x0
  pushl $132
c0102cf9:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102cfe:	e9 c4 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d03 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102d03:	6a 00                	push   $0x0
  pushl $133
c0102d05:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102d0a:	e9 b8 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d0f <vector134>:
.globl vector134
vector134:
  pushl $0
c0102d0f:	6a 00                	push   $0x0
  pushl $134
c0102d11:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102d16:	e9 ac 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d1b <vector135>:
.globl vector135
vector135:
  pushl $0
c0102d1b:	6a 00                	push   $0x0
  pushl $135
c0102d1d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102d22:	e9 a0 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d27 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102d27:	6a 00                	push   $0x0
  pushl $136
c0102d29:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d2e:	e9 94 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d33 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102d33:	6a 00                	push   $0x0
  pushl $137
c0102d35:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102d3a:	e9 88 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d3f <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d3f:	6a 00                	push   $0x0
  pushl $138
c0102d41:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d46:	e9 7c 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d4b <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d4b:	6a 00                	push   $0x0
  pushl $139
c0102d4d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d52:	e9 70 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d57 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d57:	6a 00                	push   $0x0
  pushl $140
c0102d59:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d5e:	e9 64 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d63 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d63:	6a 00                	push   $0x0
  pushl $141
c0102d65:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d6a:	e9 58 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d6f <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d6f:	6a 00                	push   $0x0
  pushl $142
c0102d71:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d76:	e9 4c 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d7b <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d7b:	6a 00                	push   $0x0
  pushl $143
c0102d7d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d82:	e9 40 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d87 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d87:	6a 00                	push   $0x0
  pushl $144
c0102d89:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d8e:	e9 34 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d93 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d93:	6a 00                	push   $0x0
  pushl $145
c0102d95:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d9a:	e9 28 05 00 00       	jmp    c01032c7 <__alltraps>

c0102d9f <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d9f:	6a 00                	push   $0x0
  pushl $146
c0102da1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102da6:	e9 1c 05 00 00       	jmp    c01032c7 <__alltraps>

c0102dab <vector147>:
.globl vector147
vector147:
  pushl $0
c0102dab:	6a 00                	push   $0x0
  pushl $147
c0102dad:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102db2:	e9 10 05 00 00       	jmp    c01032c7 <__alltraps>

c0102db7 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102db7:	6a 00                	push   $0x0
  pushl $148
c0102db9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102dbe:	e9 04 05 00 00       	jmp    c01032c7 <__alltraps>

c0102dc3 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102dc3:	6a 00                	push   $0x0
  pushl $149
c0102dc5:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102dca:	e9 f8 04 00 00       	jmp    c01032c7 <__alltraps>

c0102dcf <vector150>:
.globl vector150
vector150:
  pushl $0
c0102dcf:	6a 00                	push   $0x0
  pushl $150
c0102dd1:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102dd6:	e9 ec 04 00 00       	jmp    c01032c7 <__alltraps>

c0102ddb <vector151>:
.globl vector151
vector151:
  pushl $0
c0102ddb:	6a 00                	push   $0x0
  pushl $151
c0102ddd:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102de2:	e9 e0 04 00 00       	jmp    c01032c7 <__alltraps>

c0102de7 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102de7:	6a 00                	push   $0x0
  pushl $152
c0102de9:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102dee:	e9 d4 04 00 00       	jmp    c01032c7 <__alltraps>

c0102df3 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102df3:	6a 00                	push   $0x0
  pushl $153
c0102df5:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102dfa:	e9 c8 04 00 00       	jmp    c01032c7 <__alltraps>

c0102dff <vector154>:
.globl vector154
vector154:
  pushl $0
c0102dff:	6a 00                	push   $0x0
  pushl $154
c0102e01:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102e06:	e9 bc 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e0b <vector155>:
.globl vector155
vector155:
  pushl $0
c0102e0b:	6a 00                	push   $0x0
  pushl $155
c0102e0d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102e12:	e9 b0 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e17 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102e17:	6a 00                	push   $0x0
  pushl $156
c0102e19:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102e1e:	e9 a4 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e23 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102e23:	6a 00                	push   $0x0
  pushl $157
c0102e25:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e2a:	e9 98 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e2f <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e2f:	6a 00                	push   $0x0
  pushl $158
c0102e31:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102e36:	e9 8c 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e3b <vector159>:
.globl vector159
vector159:
  pushl $0
c0102e3b:	6a 00                	push   $0x0
  pushl $159
c0102e3d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e42:	e9 80 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e47 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e47:	6a 00                	push   $0x0
  pushl $160
c0102e49:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e4e:	e9 74 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e53 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e53:	6a 00                	push   $0x0
  pushl $161
c0102e55:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e5a:	e9 68 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e5f <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e5f:	6a 00                	push   $0x0
  pushl $162
c0102e61:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e66:	e9 5c 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e6b <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e6b:	6a 00                	push   $0x0
  pushl $163
c0102e6d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e72:	e9 50 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e77 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e77:	6a 00                	push   $0x0
  pushl $164
c0102e79:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e7e:	e9 44 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e83 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e83:	6a 00                	push   $0x0
  pushl $165
c0102e85:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e8a:	e9 38 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e8f <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e8f:	6a 00                	push   $0x0
  pushl $166
c0102e91:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e96:	e9 2c 04 00 00       	jmp    c01032c7 <__alltraps>

c0102e9b <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e9b:	6a 00                	push   $0x0
  pushl $167
c0102e9d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102ea2:	e9 20 04 00 00       	jmp    c01032c7 <__alltraps>

c0102ea7 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102ea7:	6a 00                	push   $0x0
  pushl $168
c0102ea9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102eae:	e9 14 04 00 00       	jmp    c01032c7 <__alltraps>

c0102eb3 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102eb3:	6a 00                	push   $0x0
  pushl $169
c0102eb5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102eba:	e9 08 04 00 00       	jmp    c01032c7 <__alltraps>

c0102ebf <vector170>:
.globl vector170
vector170:
  pushl $0
c0102ebf:	6a 00                	push   $0x0
  pushl $170
c0102ec1:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102ec6:	e9 fc 03 00 00       	jmp    c01032c7 <__alltraps>

c0102ecb <vector171>:
.globl vector171
vector171:
  pushl $0
c0102ecb:	6a 00                	push   $0x0
  pushl $171
c0102ecd:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102ed2:	e9 f0 03 00 00       	jmp    c01032c7 <__alltraps>

c0102ed7 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102ed7:	6a 00                	push   $0x0
  pushl $172
c0102ed9:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102ede:	e9 e4 03 00 00       	jmp    c01032c7 <__alltraps>

c0102ee3 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102ee3:	6a 00                	push   $0x0
  pushl $173
c0102ee5:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102eea:	e9 d8 03 00 00       	jmp    c01032c7 <__alltraps>

c0102eef <vector174>:
.globl vector174
vector174:
  pushl $0
c0102eef:	6a 00                	push   $0x0
  pushl $174
c0102ef1:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102ef6:	e9 cc 03 00 00       	jmp    c01032c7 <__alltraps>

c0102efb <vector175>:
.globl vector175
vector175:
  pushl $0
c0102efb:	6a 00                	push   $0x0
  pushl $175
c0102efd:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102f02:	e9 c0 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f07 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102f07:	6a 00                	push   $0x0
  pushl $176
c0102f09:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102f0e:	e9 b4 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f13 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102f13:	6a 00                	push   $0x0
  pushl $177
c0102f15:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102f1a:	e9 a8 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f1f <vector178>:
.globl vector178
vector178:
  pushl $0
c0102f1f:	6a 00                	push   $0x0
  pushl $178
c0102f21:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102f26:	e9 9c 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f2b <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f2b:	6a 00                	push   $0x0
  pushl $179
c0102f2d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f32:	e9 90 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f37 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102f37:	6a 00                	push   $0x0
  pushl $180
c0102f39:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f3e:	e9 84 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f43 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f43:	6a 00                	push   $0x0
  pushl $181
c0102f45:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f4a:	e9 78 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f4f <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f4f:	6a 00                	push   $0x0
  pushl $182
c0102f51:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f56:	e9 6c 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f5b <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f5b:	6a 00                	push   $0x0
  pushl $183
c0102f5d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f62:	e9 60 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f67 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f67:	6a 00                	push   $0x0
  pushl $184
c0102f69:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f6e:	e9 54 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f73 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f73:	6a 00                	push   $0x0
  pushl $185
c0102f75:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f7a:	e9 48 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f7f <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f7f:	6a 00                	push   $0x0
  pushl $186
c0102f81:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f86:	e9 3c 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f8b <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f8b:	6a 00                	push   $0x0
  pushl $187
c0102f8d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f92:	e9 30 03 00 00       	jmp    c01032c7 <__alltraps>

c0102f97 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f97:	6a 00                	push   $0x0
  pushl $188
c0102f99:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f9e:	e9 24 03 00 00       	jmp    c01032c7 <__alltraps>

c0102fa3 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102fa3:	6a 00                	push   $0x0
  pushl $189
c0102fa5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102faa:	e9 18 03 00 00       	jmp    c01032c7 <__alltraps>

c0102faf <vector190>:
.globl vector190
vector190:
  pushl $0
c0102faf:	6a 00                	push   $0x0
  pushl $190
c0102fb1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102fb6:	e9 0c 03 00 00       	jmp    c01032c7 <__alltraps>

c0102fbb <vector191>:
.globl vector191
vector191:
  pushl $0
c0102fbb:	6a 00                	push   $0x0
  pushl $191
c0102fbd:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102fc2:	e9 00 03 00 00       	jmp    c01032c7 <__alltraps>

c0102fc7 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102fc7:	6a 00                	push   $0x0
  pushl $192
c0102fc9:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102fce:	e9 f4 02 00 00       	jmp    c01032c7 <__alltraps>

c0102fd3 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102fd3:	6a 00                	push   $0x0
  pushl $193
c0102fd5:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102fda:	e9 e8 02 00 00       	jmp    c01032c7 <__alltraps>

c0102fdf <vector194>:
.globl vector194
vector194:
  pushl $0
c0102fdf:	6a 00                	push   $0x0
  pushl $194
c0102fe1:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102fe6:	e9 dc 02 00 00       	jmp    c01032c7 <__alltraps>

c0102feb <vector195>:
.globl vector195
vector195:
  pushl $0
c0102feb:	6a 00                	push   $0x0
  pushl $195
c0102fed:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102ff2:	e9 d0 02 00 00       	jmp    c01032c7 <__alltraps>

c0102ff7 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102ff7:	6a 00                	push   $0x0
  pushl $196
c0102ff9:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102ffe:	e9 c4 02 00 00       	jmp    c01032c7 <__alltraps>

c0103003 <vector197>:
.globl vector197
vector197:
  pushl $0
c0103003:	6a 00                	push   $0x0
  pushl $197
c0103005:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010300a:	e9 b8 02 00 00       	jmp    c01032c7 <__alltraps>

c010300f <vector198>:
.globl vector198
vector198:
  pushl $0
c010300f:	6a 00                	push   $0x0
  pushl $198
c0103011:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103016:	e9 ac 02 00 00       	jmp    c01032c7 <__alltraps>

c010301b <vector199>:
.globl vector199
vector199:
  pushl $0
c010301b:	6a 00                	push   $0x0
  pushl $199
c010301d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0103022:	e9 a0 02 00 00       	jmp    c01032c7 <__alltraps>

c0103027 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103027:	6a 00                	push   $0x0
  pushl $200
c0103029:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010302e:	e9 94 02 00 00       	jmp    c01032c7 <__alltraps>

c0103033 <vector201>:
.globl vector201
vector201:
  pushl $0
c0103033:	6a 00                	push   $0x0
  pushl $201
c0103035:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010303a:	e9 88 02 00 00       	jmp    c01032c7 <__alltraps>

c010303f <vector202>:
.globl vector202
vector202:
  pushl $0
c010303f:	6a 00                	push   $0x0
  pushl $202
c0103041:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103046:	e9 7c 02 00 00       	jmp    c01032c7 <__alltraps>

c010304b <vector203>:
.globl vector203
vector203:
  pushl $0
c010304b:	6a 00                	push   $0x0
  pushl $203
c010304d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103052:	e9 70 02 00 00       	jmp    c01032c7 <__alltraps>

c0103057 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103057:	6a 00                	push   $0x0
  pushl $204
c0103059:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010305e:	e9 64 02 00 00       	jmp    c01032c7 <__alltraps>

c0103063 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103063:	6a 00                	push   $0x0
  pushl $205
c0103065:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010306a:	e9 58 02 00 00       	jmp    c01032c7 <__alltraps>

c010306f <vector206>:
.globl vector206
vector206:
  pushl $0
c010306f:	6a 00                	push   $0x0
  pushl $206
c0103071:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103076:	e9 4c 02 00 00       	jmp    c01032c7 <__alltraps>

c010307b <vector207>:
.globl vector207
vector207:
  pushl $0
c010307b:	6a 00                	push   $0x0
  pushl $207
c010307d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103082:	e9 40 02 00 00       	jmp    c01032c7 <__alltraps>

c0103087 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103087:	6a 00                	push   $0x0
  pushl $208
c0103089:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010308e:	e9 34 02 00 00       	jmp    c01032c7 <__alltraps>

c0103093 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103093:	6a 00                	push   $0x0
  pushl $209
c0103095:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010309a:	e9 28 02 00 00       	jmp    c01032c7 <__alltraps>

c010309f <vector210>:
.globl vector210
vector210:
  pushl $0
c010309f:	6a 00                	push   $0x0
  pushl $210
c01030a1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01030a6:	e9 1c 02 00 00       	jmp    c01032c7 <__alltraps>

c01030ab <vector211>:
.globl vector211
vector211:
  pushl $0
c01030ab:	6a 00                	push   $0x0
  pushl $211
c01030ad:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01030b2:	e9 10 02 00 00       	jmp    c01032c7 <__alltraps>

c01030b7 <vector212>:
.globl vector212
vector212:
  pushl $0
c01030b7:	6a 00                	push   $0x0
  pushl $212
c01030b9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01030be:	e9 04 02 00 00       	jmp    c01032c7 <__alltraps>

c01030c3 <vector213>:
.globl vector213
vector213:
  pushl $0
c01030c3:	6a 00                	push   $0x0
  pushl $213
c01030c5:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01030ca:	e9 f8 01 00 00       	jmp    c01032c7 <__alltraps>

c01030cf <vector214>:
.globl vector214
vector214:
  pushl $0
c01030cf:	6a 00                	push   $0x0
  pushl $214
c01030d1:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01030d6:	e9 ec 01 00 00       	jmp    c01032c7 <__alltraps>

c01030db <vector215>:
.globl vector215
vector215:
  pushl $0
c01030db:	6a 00                	push   $0x0
  pushl $215
c01030dd:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030e2:	e9 e0 01 00 00       	jmp    c01032c7 <__alltraps>

c01030e7 <vector216>:
.globl vector216
vector216:
  pushl $0
c01030e7:	6a 00                	push   $0x0
  pushl $216
c01030e9:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01030ee:	e9 d4 01 00 00       	jmp    c01032c7 <__alltraps>

c01030f3 <vector217>:
.globl vector217
vector217:
  pushl $0
c01030f3:	6a 00                	push   $0x0
  pushl $217
c01030f5:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030fa:	e9 c8 01 00 00       	jmp    c01032c7 <__alltraps>

c01030ff <vector218>:
.globl vector218
vector218:
  pushl $0
c01030ff:	6a 00                	push   $0x0
  pushl $218
c0103101:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103106:	e9 bc 01 00 00       	jmp    c01032c7 <__alltraps>

c010310b <vector219>:
.globl vector219
vector219:
  pushl $0
c010310b:	6a 00                	push   $0x0
  pushl $219
c010310d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103112:	e9 b0 01 00 00       	jmp    c01032c7 <__alltraps>

c0103117 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103117:	6a 00                	push   $0x0
  pushl $220
c0103119:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010311e:	e9 a4 01 00 00       	jmp    c01032c7 <__alltraps>

c0103123 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103123:	6a 00                	push   $0x0
  pushl $221
c0103125:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010312a:	e9 98 01 00 00       	jmp    c01032c7 <__alltraps>

c010312f <vector222>:
.globl vector222
vector222:
  pushl $0
c010312f:	6a 00                	push   $0x0
  pushl $222
c0103131:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103136:	e9 8c 01 00 00       	jmp    c01032c7 <__alltraps>

c010313b <vector223>:
.globl vector223
vector223:
  pushl $0
c010313b:	6a 00                	push   $0x0
  pushl $223
c010313d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103142:	e9 80 01 00 00       	jmp    c01032c7 <__alltraps>

c0103147 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103147:	6a 00                	push   $0x0
  pushl $224
c0103149:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010314e:	e9 74 01 00 00       	jmp    c01032c7 <__alltraps>

c0103153 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103153:	6a 00                	push   $0x0
  pushl $225
c0103155:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010315a:	e9 68 01 00 00       	jmp    c01032c7 <__alltraps>

c010315f <vector226>:
.globl vector226
vector226:
  pushl $0
c010315f:	6a 00                	push   $0x0
  pushl $226
c0103161:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103166:	e9 5c 01 00 00       	jmp    c01032c7 <__alltraps>

c010316b <vector227>:
.globl vector227
vector227:
  pushl $0
c010316b:	6a 00                	push   $0x0
  pushl $227
c010316d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103172:	e9 50 01 00 00       	jmp    c01032c7 <__alltraps>

c0103177 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103177:	6a 00                	push   $0x0
  pushl $228
c0103179:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010317e:	e9 44 01 00 00       	jmp    c01032c7 <__alltraps>

c0103183 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103183:	6a 00                	push   $0x0
  pushl $229
c0103185:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010318a:	e9 38 01 00 00       	jmp    c01032c7 <__alltraps>

c010318f <vector230>:
.globl vector230
vector230:
  pushl $0
c010318f:	6a 00                	push   $0x0
  pushl $230
c0103191:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103196:	e9 2c 01 00 00       	jmp    c01032c7 <__alltraps>

c010319b <vector231>:
.globl vector231
vector231:
  pushl $0
c010319b:	6a 00                	push   $0x0
  pushl $231
c010319d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01031a2:	e9 20 01 00 00       	jmp    c01032c7 <__alltraps>

c01031a7 <vector232>:
.globl vector232
vector232:
  pushl $0
c01031a7:	6a 00                	push   $0x0
  pushl $232
c01031a9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01031ae:	e9 14 01 00 00       	jmp    c01032c7 <__alltraps>

c01031b3 <vector233>:
.globl vector233
vector233:
  pushl $0
c01031b3:	6a 00                	push   $0x0
  pushl $233
c01031b5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01031ba:	e9 08 01 00 00       	jmp    c01032c7 <__alltraps>

c01031bf <vector234>:
.globl vector234
vector234:
  pushl $0
c01031bf:	6a 00                	push   $0x0
  pushl $234
c01031c1:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01031c6:	e9 fc 00 00 00       	jmp    c01032c7 <__alltraps>

c01031cb <vector235>:
.globl vector235
vector235:
  pushl $0
c01031cb:	6a 00                	push   $0x0
  pushl $235
c01031cd:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01031d2:	e9 f0 00 00 00       	jmp    c01032c7 <__alltraps>

c01031d7 <vector236>:
.globl vector236
vector236:
  pushl $0
c01031d7:	6a 00                	push   $0x0
  pushl $236
c01031d9:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031de:	e9 e4 00 00 00       	jmp    c01032c7 <__alltraps>

c01031e3 <vector237>:
.globl vector237
vector237:
  pushl $0
c01031e3:	6a 00                	push   $0x0
  pushl $237
c01031e5:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01031ea:	e9 d8 00 00 00       	jmp    c01032c7 <__alltraps>

c01031ef <vector238>:
.globl vector238
vector238:
  pushl $0
c01031ef:	6a 00                	push   $0x0
  pushl $238
c01031f1:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01031f6:	e9 cc 00 00 00       	jmp    c01032c7 <__alltraps>

c01031fb <vector239>:
.globl vector239
vector239:
  pushl $0
c01031fb:	6a 00                	push   $0x0
  pushl $239
c01031fd:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103202:	e9 c0 00 00 00       	jmp    c01032c7 <__alltraps>

c0103207 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103207:	6a 00                	push   $0x0
  pushl $240
c0103209:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010320e:	e9 b4 00 00 00       	jmp    c01032c7 <__alltraps>

c0103213 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103213:	6a 00                	push   $0x0
  pushl $241
c0103215:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010321a:	e9 a8 00 00 00       	jmp    c01032c7 <__alltraps>

c010321f <vector242>:
.globl vector242
vector242:
  pushl $0
c010321f:	6a 00                	push   $0x0
  pushl $242
c0103221:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103226:	e9 9c 00 00 00       	jmp    c01032c7 <__alltraps>

c010322b <vector243>:
.globl vector243
vector243:
  pushl $0
c010322b:	6a 00                	push   $0x0
  pushl $243
c010322d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103232:	e9 90 00 00 00       	jmp    c01032c7 <__alltraps>

c0103237 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103237:	6a 00                	push   $0x0
  pushl $244
c0103239:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010323e:	e9 84 00 00 00       	jmp    c01032c7 <__alltraps>

c0103243 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103243:	6a 00                	push   $0x0
  pushl $245
c0103245:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010324a:	e9 78 00 00 00       	jmp    c01032c7 <__alltraps>

c010324f <vector246>:
.globl vector246
vector246:
  pushl $0
c010324f:	6a 00                	push   $0x0
  pushl $246
c0103251:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103256:	e9 6c 00 00 00       	jmp    c01032c7 <__alltraps>

c010325b <vector247>:
.globl vector247
vector247:
  pushl $0
c010325b:	6a 00                	push   $0x0
  pushl $247
c010325d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103262:	e9 60 00 00 00       	jmp    c01032c7 <__alltraps>

c0103267 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103267:	6a 00                	push   $0x0
  pushl $248
c0103269:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010326e:	e9 54 00 00 00       	jmp    c01032c7 <__alltraps>

c0103273 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103273:	6a 00                	push   $0x0
  pushl $249
c0103275:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010327a:	e9 48 00 00 00       	jmp    c01032c7 <__alltraps>

c010327f <vector250>:
.globl vector250
vector250:
  pushl $0
c010327f:	6a 00                	push   $0x0
  pushl $250
c0103281:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103286:	e9 3c 00 00 00       	jmp    c01032c7 <__alltraps>

c010328b <vector251>:
.globl vector251
vector251:
  pushl $0
c010328b:	6a 00                	push   $0x0
  pushl $251
c010328d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103292:	e9 30 00 00 00       	jmp    c01032c7 <__alltraps>

c0103297 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103297:	6a 00                	push   $0x0
  pushl $252
c0103299:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010329e:	e9 24 00 00 00       	jmp    c01032c7 <__alltraps>

c01032a3 <vector253>:
.globl vector253
vector253:
  pushl $0
c01032a3:	6a 00                	push   $0x0
  pushl $253
c01032a5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01032aa:	e9 18 00 00 00       	jmp    c01032c7 <__alltraps>

c01032af <vector254>:
.globl vector254
vector254:
  pushl $0
c01032af:	6a 00                	push   $0x0
  pushl $254
c01032b1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01032b6:	e9 0c 00 00 00       	jmp    c01032c7 <__alltraps>

c01032bb <vector255>:
.globl vector255
vector255:
  pushl $0
c01032bb:	6a 00                	push   $0x0
  pushl $255
c01032bd:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01032c2:	e9 00 00 00 00       	jmp    c01032c7 <__alltraps>

c01032c7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01032c7:	1e                   	push   %ds
    pushl %es
c01032c8:	06                   	push   %es
    pushl %fs
c01032c9:	0f a0                	push   %fs
    pushl %gs
c01032cb:	0f a8                	push   %gs
    pushal
c01032cd:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01032ce:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01032d3:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01032d5:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01032d7:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01032d8:	e8 61 f5 ff ff       	call   c010283e <trap>

    # pop the pushed stack pointer
    popl %esp
c01032dd:	5c                   	pop    %esp

c01032de <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01032de:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01032df:	0f a9                	pop    %gs
    popl %fs
c01032e1:	0f a1                	pop    %fs
    popl %es
c01032e3:	07                   	pop    %es
    popl %ds
c01032e4:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01032e5:	83 c4 08             	add    $0x8,%esp
    iret
c01032e8:	cf                   	iret   

c01032e9 <_enclock_init_mm>:
 * (2) _enclock_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_enclock_init_mm(struct mm_struct *mm)
{     
c01032e9:	55                   	push   %ebp
c01032ea:	89 e5                	mov    %esp,%ebp
c01032ec:	83 ec 18             	sub    $0x18,%esp
c01032ef:	c7 45 f4 70 50 12 c0 	movl   $0xc0125070,-0xc(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01032fc:	89 50 04             	mov    %edx,0x4(%eax)
c01032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103302:	8b 50 04             	mov    0x4(%eax),%edx
c0103305:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103308:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     clock_ptr = &pra_list_head;
c010330a:	c7 05 78 50 12 c0 70 	movl   $0xc0125070,0xc0125078
c0103311:	50 12 c0 
     assert(clock_ptr != NULL);
c0103314:	a1 78 50 12 c0       	mov    0xc0125078,%eax
c0103319:	85 c0                	test   %eax,%eax
c010331b:	75 16                	jne    c0103333 <_enclock_init_mm+0x4a>
c010331d:	68 f0 94 10 c0       	push   $0xc01094f0
c0103322:	68 02 95 10 c0       	push   $0xc0109502
c0103327:	6a 20                	push   $0x20
c0103329:	68 17 95 10 c0       	push   $0xc0109517
c010332e:	e8 bd d0 ff ff       	call   c01003f0 <__panic>
     mm->sm_priv = &sm_priv_enclock;
c0103333:	8b 45 08             	mov    0x8(%ebp),%eax
c0103336:	c7 40 14 e0 19 12 c0 	movl   $0xc01219e0,0x14(%eax)
     //cprintf(" mm->sm_priv %x in enclock_init_mm\n",mm->sm_priv);
     return 0;
c010333d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103342:	c9                   	leave  
c0103343:	c3                   	ret    

c0103344 <_enclock_map_swappable>:
/*
 * (3)_enclock_map_swappable: According enclock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_enclock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0103344:	55                   	push   %ebp
c0103345:	89 e5                	mov    %esp,%ebp
c0103347:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c010334a:	8b 45 08             	mov    0x8(%ebp),%eax
c010334d:	8b 40 14             	mov    0x14(%eax),%eax
c0103350:	8b 00                	mov    (%eax),%eax
c0103352:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c0103355:	8b 45 08             	mov    0x8(%ebp),%eax
c0103358:	8b 40 14             	mov    0x14(%eax),%eax
c010335b:	8b 40 04             	mov    0x4(%eax),%eax
c010335e:	8b 00                	mov    (%eax),%eax
c0103360:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in swappable\n");
    // }
    list_entry_t *entry=&(page->pra_page_link);
c0103363:	8b 45 10             	mov    0x10(%ebp),%eax
c0103366:	83 c0 14             	add    $0x14,%eax
c0103369:	89 45 e8             	mov    %eax,-0x18(%ebp)
    
    assert(entry != NULL && head != NULL);
c010336c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103370:	74 06                	je     c0103378 <_enclock_map_swappable+0x34>
c0103372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103376:	75 16                	jne    c010338e <_enclock_map_swappable+0x4a>
c0103378:	68 2e 95 10 c0       	push   $0xc010952e
c010337d:	68 02 95 10 c0       	push   $0xc0109502
c0103382:	6a 32                	push   $0x32
c0103384:	68 17 95 10 c0       	push   $0xc0109517
c0103389:	e8 62 d0 ff ff       	call   c01003f0 <__panic>
    //record the page access situlation
    /*LAB3 CHALLENGE: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c010338e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0103392:	75 57                	jne    c01033eb <_enclock_map_swappable+0xa7>
        list_entry_t *le_prev = head, *le;
c0103394:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103397:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c010339a:	eb 38                	jmp    c01033d4 <_enclock_map_swappable+0x90>
            if (le == entry) {
c010339c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010339f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01033a2:	75 2a                	jne    c01033ce <_enclock_map_swappable+0x8a>
c01033a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01033aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033ad:	8b 40 04             	mov    0x4(%eax),%eax
c01033b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01033b3:	8b 12                	mov    (%edx),%edx
c01033b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01033bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033be:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033c1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01033c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033ca:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c01033cc:	eb 1d                	jmp    c01033eb <_enclock_map_swappable+0xa7>
            }
            le_prev = le;        
c01033ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033da:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033dd:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 CHALLENGE: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c01033e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01033e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01033e9:	75 b1                	jne    c010339c <_enclock_map_swappable+0x58>
c01033eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01033f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033fa:	8b 00                	mov    (%eax),%eax
c01033fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01033ff:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103402:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0103405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103408:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010340b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010340e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103411:	89 10                	mov    %edx,(%eax)
c0103413:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103416:	8b 10                	mov    (%eax),%edx
c0103418:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010341b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010341e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103421:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103424:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103427:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010342a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010342d:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c010342f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103434:	c9                   	leave  
c0103435:	c3                   	ret    

c0103436 <_enclock_swap_out_victim>:
 *  (4)_enclock_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_enclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0103436:	55                   	push   %ebp
c0103437:	89 e5                	mov    %esp,%ebp
c0103439:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = ((struct enclock_struct*) mm->sm_priv)->head;
c010343c:	8b 45 08             	mov    0x8(%ebp),%eax
c010343f:	8b 40 14             	mov    0x14(%eax),%eax
c0103442:	8b 00                	mov    (%eax),%eax
c0103444:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *clock_ptr = *(((struct enclock_struct*) mm->sm_priv)->clock);
c0103447:	8b 45 08             	mov    0x8(%ebp),%eax
c010344a:	8b 40 14             	mov    0x14(%eax),%eax
c010344d:	8b 40 04             	mov    0x4(%eax),%eax
c0103450:	8b 00                	mov    (%eax),%eax
c0103452:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // if (head == clock_ptr) {
    //     cprintf("Got head == clock ptr in victim\n");
    // }
    assert(head != NULL);
c0103455:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103459:	75 16                	jne    c0103471 <_enclock_swap_out_victim+0x3b>
c010345b:	68 4c 95 10 c0       	push   $0xc010954c
c0103460:	68 02 95 10 c0       	push   $0xc0109502
c0103465:	6a 50                	push   $0x50
c0103467:	68 17 95 10 c0       	push   $0xc0109517
c010346c:	e8 7f cf ff ff       	call   c01003f0 <__panic>
    assert(in_tick==0);
c0103471:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103475:	74 16                	je     c010348d <_enclock_swap_out_victim+0x57>
c0103477:	68 59 95 10 c0       	push   $0xc0109559
c010347c:	68 02 95 10 c0       	push   $0xc0109502
c0103481:	6a 51                	push   $0x51
c0103483:	68 17 95 10 c0       	push   $0xc0109517
c0103488:	e8 63 cf ff ff       	call   c01003f0 <__panic>
    /* Select the victim */
    /*LAB3 CHALLENGE 2: 2015010062*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
c010348d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103490:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int cnt = 0;
c0103493:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (le = list_next(le_prev)) {
c010349a:	e9 36 01 00 00       	jmp    c01035d5 <_enclock_swap_out_victim+0x19f>
        assert(cnt < 3);
c010349f:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
c01034a3:	7e 16                	jle    c01034bb <_enclock_swap_out_victim+0x85>
c01034a5:	68 64 95 10 c0       	push   $0xc0109564
c01034aa:	68 02 95 10 c0       	push   $0xc0109502
c01034af:	6a 58                	push   $0x58
c01034b1:	68 17 95 10 c0       	push   $0xc0109517
c01034b6:	e8 35 cf ff ff       	call   c01003f0 <__panic>
        if (le == head) {
c01034bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034c1:	75 0f                	jne    c01034d2 <_enclock_swap_out_victim+0x9c>
            cnt ++;
c01034c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
            le_prev = le;
c01034c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
            continue;
c01034cd:	e9 03 01 00 00       	jmp    c01035d5 <_enclock_swap_out_victim+0x19f>
        }
        struct Page *page = le2page(le, pra_page_link);
c01034d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034d5:	83 e8 14             	sub    $0x14,%eax
c01034d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        pte_t* ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
c01034db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034de:	8b 50 1c             	mov    0x1c(%eax),%edx
c01034e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01034e4:	8b 40 0c             	mov    0xc(%eax),%eax
c01034e7:	83 ec 04             	sub    $0x4,%esp
c01034ea:	6a 00                	push   $0x0
c01034ec:	52                   	push   %edx
c01034ed:	50                   	push   %eax
c01034ee:	e8 70 3a 00 00       	call   c0106f63 <get_pte>
c01034f3:	83 c4 10             	add    $0x10,%esp
c01034f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
        _enclock_print_pte(ptep, page->pra_vaddr);
c01034f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034fc:	8b 40 1c             	mov    0x1c(%eax),%eax
c01034ff:	83 ec 08             	sub    $0x8,%esp
c0103502:	50                   	push   %eax
c0103503:	ff 75 d8             	pushl  -0x28(%ebp)
c0103506:	e8 fb 01 00 00       	call   c0103706 <_enclock_print_pte>
c010350b:	83 c4 10             	add    $0x10,%esp
        // cprintf("BEFORE: va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", page->pra_vaddr, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        if (*ptep & PTE_A) {
c010350e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103511:	8b 00                	mov    (%eax),%eax
c0103513:	83 e0 20             	and    $0x20,%eax
c0103516:	85 c0                	test   %eax,%eax
c0103518:	74 2d                	je     c0103547 <_enclock_swap_out_victim+0x111>
            // set access to 0
            *ptep &= ~PTE_A;
c010351a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010351d:	8b 00                	mov    (%eax),%eax
c010351f:	83 e0 df             	and    $0xffffffdf,%eax
c0103522:	89 c2                	mov    %eax,%edx
c0103524:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103527:	89 10                	mov    %edx,(%eax)
            tlb_invalidate(mm->pgdir, page->pra_vaddr);
c0103529:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010352c:	8b 50 1c             	mov    0x1c(%eax),%edx
c010352f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103532:	8b 40 0c             	mov    0xc(%eax),%eax
c0103535:	83 ec 08             	sub    $0x8,%esp
c0103538:	52                   	push   %edx
c0103539:	50                   	push   %eax
c010353a:	e8 1c 3d 00 00       	call   c010725b <tlb_invalidate>
c010353f:	83 c4 10             	add    $0x10,%esp
c0103542:	e9 88 00 00 00       	jmp    c01035cf <_enclock_swap_out_victim+0x199>
        } else {
            // cprintf("now a == 0\n");
            if (*ptep & PTE_D) {
c0103547:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010354a:	8b 00                	mov    (%eax),%eax
c010354c:	83 e0 40             	and    $0x40,%eax
c010354f:	85 c0                	test   %eax,%eax
c0103551:	74 63                	je     c01035b6 <_enclock_swap_out_victim+0x180>
                if (swapfs_write((page->pra_vaddr / PGSIZE + 1) << 8, page) == 0) {
c0103553:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103556:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103559:	c1 e8 0c             	shr    $0xc,%eax
c010355c:	83 c0 01             	add    $0x1,%eax
c010355f:	c1 e0 08             	shl    $0x8,%eax
c0103562:	83 ec 08             	sub    $0x8,%esp
c0103565:	ff 75 dc             	pushl  -0x24(%ebp)
c0103568:	50                   	push   %eax
c0103569:	e8 dd 4a 00 00       	call   c010804b <swapfs_write>
c010356e:	83 c4 10             	add    $0x10,%esp
c0103571:	85 c0                	test   %eax,%eax
c0103573:	75 17                	jne    c010358c <_enclock_swap_out_victim+0x156>
                    cprintf("write 0x%x to disk\n", page->pra_vaddr);
c0103575:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103578:	8b 40 1c             	mov    0x1c(%eax),%eax
c010357b:	83 ec 08             	sub    $0x8,%esp
c010357e:	50                   	push   %eax
c010357f:	68 6c 95 10 c0       	push   $0xc010956c
c0103584:	e8 01 cd ff ff       	call   c010028a <cprintf>
c0103589:	83 c4 10             	add    $0x10,%esp
                }
                // set dirty to 0
                *ptep = *ptep & ~PTE_D;
c010358c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010358f:	8b 00                	mov    (%eax),%eax
c0103591:	83 e0 bf             	and    $0xffffffbf,%eax
c0103594:	89 c2                	mov    %eax,%edx
c0103596:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103599:	89 10                	mov    %edx,(%eax)
                tlb_invalidate(mm->pgdir, page->pra_vaddr);
c010359b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010359e:	8b 50 1c             	mov    0x1c(%eax),%edx
c01035a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01035a4:	8b 40 0c             	mov    0xc(%eax),%eax
c01035a7:	83 ec 08             	sub    $0x8,%esp
c01035aa:	52                   	push   %edx
c01035ab:	50                   	push   %eax
c01035ac:	e8 aa 3c 00 00       	call   c010725b <tlb_invalidate>
c01035b1:	83 c4 10             	add    $0x10,%esp
c01035b4:	eb 19                	jmp    c01035cf <_enclock_swap_out_victim+0x199>
            } else {
                // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
                cprintf("victim is 0x%x\n", page->pra_vaddr);
c01035b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035b9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01035bc:	83 ec 08             	sub    $0x8,%esp
c01035bf:	50                   	push   %eax
c01035c0:	68 80 95 10 c0       	push   $0xc0109580
c01035c5:	e8 c0 cc ff ff       	call   c010028a <cprintf>
c01035ca:	83 c4 10             	add    $0x10,%esp
                break;
c01035cd:	eb 1f                	jmp    c01035ee <_enclock_swap_out_victim+0x1b8>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
c01035cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035db:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035de:	8b 40 04             	mov    0x4(%eax),%eax
    /* Select the victim */
    /*LAB3 CHALLENGE 2: 2015010062*/ 
    //(1)  iterate list searching for victim
    list_entry_t *le_prev = clock_ptr, *le;
    int cnt = 0;
    while (le = list_next(le_prev)) {
c01035e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01035e8:	0f 85 b1 fe ff ff    	jne    c010349f <_enclock_swap_out_victim+0x69>
            }
        }
        // cprintf("AFTER: le: %p, pte: 0x%x A: 0x%x, D: 0x%x\n", le, *ptep, *ptep & PTE_A, *ptep & PTE_D);
        le_prev = le;        
    }
    assert(le != head);
c01035ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01035f4:	75 16                	jne    c010360c <_enclock_swap_out_victim+0x1d6>
c01035f6:	68 90 95 10 c0       	push   $0xc0109590
c01035fb:	68 02 95 10 c0       	push   $0xc0109502
c0103600:	6a 78                	push   $0x78
c0103602:	68 17 95 10 c0       	push   $0xc0109517
c0103607:	e8 e4 cd ff ff       	call   c01003f0 <__panic>
c010360c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103615:	8b 40 04             	mov    0x4(%eax),%eax
c0103618:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010361b:	8b 12                	mov    (%edx),%edx
c010361d:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103620:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103623:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103626:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103629:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010362c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010362f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103632:	89 10                	mov    %edx,(%eax)
    list_del(le);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(le, pra_page_link);
c0103634:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103637:	83 e8 14             	sub    $0x14,%eax
c010363a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    assert(page != NULL);
c010363d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103641:	75 16                	jne    c0103659 <_enclock_swap_out_victim+0x223>
c0103643:	68 9b 95 10 c0       	push   $0xc010959b
c0103648:	68 02 95 10 c0       	push   $0xc0109502
c010364d:	6a 7c                	push   $0x7c
c010364f:	68 17 95 10 c0       	push   $0xc0109517
c0103654:	e8 97 cd ff ff       	call   c01003f0 <__panic>
    *ptr_page = page;
c0103659:	8b 45 0c             	mov    0xc(%ebp),%eax
c010365c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010365f:	89 10                	mov    %edx,(%eax)
    //(2)update clock
    *(((struct enclock_struct*) mm->sm_priv)->clock) = list_next(le_prev);
c0103661:	8b 45 08             	mov    0x8(%ebp),%eax
c0103664:	8b 40 14             	mov    0x14(%eax),%eax
c0103667:	8b 40 04             	mov    0x4(%eax),%eax
c010366a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010366d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103670:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103673:	8b 52 04             	mov    0x4(%edx),%edx
c0103676:	89 10                	mov    %edx,(%eax)
    return 0;
c0103678:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010367d:	c9                   	leave  
c010367e:	c3                   	ret    

c010367f <_enclock_reset_pte>:

void
_enclock_reset_pte(pde_t* pgdir) {
c010367f:	55                   	push   %ebp
c0103680:	89 e5                	mov    %esp,%ebp
c0103682:	83 ec 18             	sub    $0x18,%esp
    cprintf("PTEs resetting...\n");
c0103685:	83 ec 0c             	sub    $0xc,%esp
c0103688:	68 a8 95 10 c0       	push   $0xc01095a8
c010368d:	e8 f8 cb ff ff       	call   c010028a <cprintf>
c0103692:	83 c4 10             	add    $0x10,%esp
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c0103695:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
c010369c:	eb 4c                	jmp    c01036ea <_enclock_reset_pte+0x6b>
        pte_t* ptep = get_pte(pgdir, va, 0);
c010369e:	83 ec 04             	sub    $0x4,%esp
c01036a1:	6a 00                	push   $0x0
c01036a3:	ff 75 f4             	pushl  -0xc(%ebp)
c01036a6:	ff 75 08             	pushl  0x8(%ebp)
c01036a9:	e8 b5 38 00 00       	call   c0106f63 <get_pte>
c01036ae:	83 c4 10             	add    $0x10,%esp
c01036b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        *ptep = *ptep & ~PTE_A;
c01036b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b7:	8b 00                	mov    (%eax),%eax
c01036b9:	83 e0 df             	and    $0xffffffdf,%eax
c01036bc:	89 c2                	mov    %eax,%edx
c01036be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c1:	89 10                	mov    %edx,(%eax)
        *ptep = *ptep & ~PTE_D;
c01036c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c6:	8b 00                	mov    (%eax),%eax
c01036c8:	83 e0 bf             	and    $0xffffffbf,%eax
c01036cb:	89 c2                	mov    %eax,%edx
c01036cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036d0:	89 10                	mov    %edx,(%eax)
        tlb_invalidate(pgdir, va);
c01036d2:	83 ec 08             	sub    $0x8,%esp
c01036d5:	ff 75 f4             	pushl  -0xc(%ebp)
c01036d8:	ff 75 08             	pushl  0x8(%ebp)
c01036db:	e8 7b 3b 00 00       	call   c010725b <tlb_invalidate>
c01036e0:	83 c4 10             	add    $0x10,%esp
}

void
_enclock_reset_pte(pde_t* pgdir) {
    cprintf("PTEs resetting...\n");
    for(unsigned int va = 0x1000; va <= 0x4000; va += 0x1000) {
c01036e3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01036ea:	81 7d f4 00 40 00 00 	cmpl   $0x4000,-0xc(%ebp)
c01036f1:	76 ab                	jbe    c010369e <_enclock_reset_pte+0x1f>
        pte_t* ptep = get_pte(pgdir, va, 0);
        *ptep = *ptep & ~PTE_A;
        *ptep = *ptep & ~PTE_D;
        tlb_invalidate(pgdir, va);
    }
    cprintf("PTEs reseted!\n");
c01036f3:	83 ec 0c             	sub    $0xc,%esp
c01036f6:	68 bb 95 10 c0       	push   $0xc01095bb
c01036fb:	e8 8a cb ff ff       	call   c010028a <cprintf>
c0103700:	83 c4 10             	add    $0x10,%esp
}
c0103703:	90                   	nop
c0103704:	c9                   	leave  
c0103705:	c3                   	ret    

c0103706 <_enclock_print_pte>:

void
_enclock_print_pte(pte_t* ptep, unsigned int va) {
c0103706:	55                   	push   %ebp
c0103707:	89 e5                	mov    %esp,%ebp
c0103709:	83 ec 08             	sub    $0x8,%esp
    cprintf("va: 0x%x, pte: 0x%x A: 0x%x, D: 0x%x\n", va, *ptep, *ptep & PTE_A, *ptep & PTE_D);
c010370c:	8b 45 08             	mov    0x8(%ebp),%eax
c010370f:	8b 00                	mov    (%eax),%eax
c0103711:	83 e0 40             	and    $0x40,%eax
c0103714:	89 c1                	mov    %eax,%ecx
c0103716:	8b 45 08             	mov    0x8(%ebp),%eax
c0103719:	8b 00                	mov    (%eax),%eax
c010371b:	83 e0 20             	and    $0x20,%eax
c010371e:	89 c2                	mov    %eax,%edx
c0103720:	8b 45 08             	mov    0x8(%ebp),%eax
c0103723:	8b 00                	mov    (%eax),%eax
c0103725:	83 ec 0c             	sub    $0xc,%esp
c0103728:	51                   	push   %ecx
c0103729:	52                   	push   %edx
c010372a:	50                   	push   %eax
c010372b:	ff 75 0c             	pushl  0xc(%ebp)
c010372e:	68 cc 95 10 c0       	push   $0xc01095cc
c0103733:	e8 52 cb ff ff       	call   c010028a <cprintf>
c0103738:	83 c4 20             	add    $0x20,%esp
}
c010373b:	90                   	nop
c010373c:	c9                   	leave  
c010373d:	c3                   	ret    

c010373e <_enclock_check_swap>:

static int
_enclock_check_swap(void) {
c010373e:	55                   	push   %ebp
c010373f:	89 e5                	mov    %esp,%ebp
c0103741:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103744:	0f 20 d8             	mov    %cr3,%eax
c0103747:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return cr3;
c010374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    _enclock_reset_pte(KADDR(((pde_t *)rcr3())));
c010374d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103753:	c1 e8 0c             	shr    $0xc,%eax
c0103756:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103759:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c010375e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103761:	72 17                	jb     c010377a <_enclock_check_swap+0x3c>
c0103763:	ff 75 f4             	pushl  -0xc(%ebp)
c0103766:	68 f4 95 10 c0       	push   $0xc01095f4
c010376b:	68 96 00 00 00       	push   $0x96
c0103770:	68 17 95 10 c0       	push   $0xc0109517
c0103775:	e8 76 cc ff ff       	call   c01003f0 <__panic>
c010377a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103782:	83 ec 0c             	sub    $0xc,%esp
c0103785:	50                   	push   %eax
c0103786:	e8 f4 fe ff ff       	call   c010367f <_enclock_reset_pte>
c010378b:	83 c4 10             	add    $0x10,%esp
    cprintf("read Virt Page c in enclock_check_swap\n");
c010378e:	83 ec 0c             	sub    $0xc,%esp
c0103791:	68 18 96 10 c0       	push   $0xc0109618
c0103796:	e8 ef ca ff ff       	call   c010028a <cprintf>
c010379b:	83 c4 10             	add    $0x10,%esp
    unsigned char tmp = *(unsigned char *)0x3000;
c010379e:	b8 00 30 00 00       	mov    $0x3000,%eax
c01037a3:	0f b6 00             	movzbl (%eax),%eax
c01037a6:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c01037a9:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01037ae:	83 f8 04             	cmp    $0x4,%eax
c01037b1:	74 19                	je     c01037cc <_enclock_check_swap+0x8e>
c01037b3:	68 40 96 10 c0       	push   $0xc0109640
c01037b8:	68 02 95 10 c0       	push   $0xc0109502
c01037bd:	68 99 00 00 00       	push   $0x99
c01037c2:	68 17 95 10 c0       	push   $0xc0109517
c01037c7:	e8 24 cc ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c01037cc:	83 ec 0c             	sub    $0xc,%esp
c01037cf:	68 50 96 10 c0       	push   $0xc0109650
c01037d4:	e8 b1 ca ff ff       	call   c010028a <cprintf>
c01037d9:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01037dc:	b8 00 10 00 00       	mov    $0x1000,%eax
c01037e1:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01037e4:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01037e9:	83 f8 04             	cmp    $0x4,%eax
c01037ec:	74 19                	je     c0103807 <_enclock_check_swap+0xc9>
c01037ee:	68 40 96 10 c0       	push   $0xc0109640
c01037f3:	68 02 95 10 c0       	push   $0xc0109502
c01037f8:	68 9c 00 00 00       	push   $0x9c
c01037fd:	68 17 95 10 c0       	push   $0xc0109517
c0103802:	e8 e9 cb ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c0103807:	83 ec 0c             	sub    $0xc,%esp
c010380a:	68 7c 96 10 c0       	push   $0xc010967c
c010380f:	e8 76 ca ff ff       	call   c010028a <cprintf>
c0103814:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c0103817:	b8 00 40 00 00       	mov    $0x4000,%eax
c010381c:	0f b6 00             	movzbl (%eax),%eax
c010381f:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==4);
c0103822:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103827:	83 f8 04             	cmp    $0x4,%eax
c010382a:	74 19                	je     c0103845 <_enclock_check_swap+0x107>
c010382c:	68 40 96 10 c0       	push   $0xc0109640
c0103831:	68 02 95 10 c0       	push   $0xc0109502
c0103836:	68 9f 00 00 00       	push   $0x9f
c010383b:	68 17 95 10 c0       	push   $0xc0109517
c0103840:	e8 ab cb ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in enclock_check_swap\n");
c0103845:	83 ec 0c             	sub    $0xc,%esp
c0103848:	68 a4 96 10 c0       	push   $0xc01096a4
c010384d:	e8 38 ca ff ff       	call   c010028a <cprintf>
c0103852:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0103855:	b8 00 20 00 00       	mov    $0x2000,%eax
c010385a:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010385d:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103862:	83 f8 04             	cmp    $0x4,%eax
c0103865:	74 19                	je     c0103880 <_enclock_check_swap+0x142>
c0103867:	68 40 96 10 c0       	push   $0xc0109640
c010386c:	68 02 95 10 c0       	push   $0xc0109502
c0103871:	68 a2 00 00 00       	push   $0xa2
c0103876:	68 17 95 10 c0       	push   $0xc0109517
c010387b:	e8 70 cb ff ff       	call   c01003f0 <__panic>

    cprintf("write Virt Page e in enclock_check_swap\n");
c0103880:	83 ec 0c             	sub    $0xc,%esp
c0103883:	68 d0 96 10 c0       	push   $0xc01096d0
c0103888:	e8 fd c9 ff ff       	call   c010028a <cprintf>
c010388d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0103890:	b8 00 50 00 00       	mov    $0x5000,%eax
c0103895:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0103898:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010389d:	83 f8 05             	cmp    $0x5,%eax
c01038a0:	74 19                	je     c01038bb <_enclock_check_swap+0x17d>
c01038a2:	68 f9 96 10 c0       	push   $0xc01096f9
c01038a7:	68 02 95 10 c0       	push   $0xc0109502
c01038ac:	68 a6 00 00 00       	push   $0xa6
c01038b1:	68 17 95 10 c0       	push   $0xc0109517
c01038b6:	e8 35 cb ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c01038bb:	83 ec 0c             	sub    $0xc,%esp
c01038be:	68 08 97 10 c0       	push   $0xc0109708
c01038c3:	e8 c2 c9 ff ff       	call   c010028a <cprintf>
c01038c8:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c01038cb:	b8 00 20 00 00       	mov    $0x2000,%eax
c01038d0:	0f b6 00             	movzbl (%eax),%eax
c01038d3:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c01038d6:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01038db:	83 f8 05             	cmp    $0x5,%eax
c01038de:	74 19                	je     c01038f9 <_enclock_check_swap+0x1bb>
c01038e0:	68 f9 96 10 c0       	push   $0xc01096f9
c01038e5:	68 02 95 10 c0       	push   $0xc0109502
c01038ea:	68 a9 00 00 00       	push   $0xa9
c01038ef:	68 17 95 10 c0       	push   $0xc0109517
c01038f4:	e8 f7 ca ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in enclock_check_swap\n");
c01038f9:	83 ec 0c             	sub    $0xc,%esp
c01038fc:	68 50 96 10 c0       	push   $0xc0109650
c0103901:	e8 84 c9 ff ff       	call   c010028a <cprintf>
c0103906:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0103909:	b8 00 10 00 00       	mov    $0x1000,%eax
c010390e:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==5);
c0103911:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103916:	83 f8 05             	cmp    $0x5,%eax
c0103919:	74 19                	je     c0103934 <_enclock_check_swap+0x1f6>
c010391b:	68 f9 96 10 c0       	push   $0xc01096f9
c0103920:	68 02 95 10 c0       	push   $0xc0109502
c0103925:	68 ac 00 00 00       	push   $0xac
c010392a:	68 17 95 10 c0       	push   $0xc0109517
c010392f:	e8 bc ca ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page b in enclock_check_swap\n");
c0103934:	83 ec 0c             	sub    $0xc,%esp
c0103937:	68 08 97 10 c0       	push   $0xc0109708
c010393c:	e8 49 c9 ff ff       	call   c010028a <cprintf>
c0103941:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x2000;
c0103944:	b8 00 20 00 00       	mov    $0x2000,%eax
c0103949:	0f b6 00             	movzbl (%eax),%eax
c010394c:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==5);
c010394f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103954:	83 f8 05             	cmp    $0x5,%eax
c0103957:	74 19                	je     c0103972 <_enclock_check_swap+0x234>
c0103959:	68 f9 96 10 c0       	push   $0xc01096f9
c010395e:	68 02 95 10 c0       	push   $0xc0109502
c0103963:	68 af 00 00 00       	push   $0xaf
c0103968:	68 17 95 10 c0       	push   $0xc0109517
c010396d:	e8 7e ca ff ff       	call   c01003f0 <__panic>

    cprintf("read Virt Page c in enclock_check_swap\n");
c0103972:	83 ec 0c             	sub    $0xc,%esp
c0103975:	68 18 96 10 c0       	push   $0xc0109618
c010397a:	e8 0b c9 ff ff       	call   c010028a <cprintf>
c010397f:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x3000;
c0103982:	b8 00 30 00 00       	mov    $0x3000,%eax
c0103987:	0f b6 00             	movzbl (%eax),%eax
c010398a:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==6);
c010398d:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0103992:	83 f8 06             	cmp    $0x6,%eax
c0103995:	74 19                	je     c01039b0 <_enclock_check_swap+0x272>
c0103997:	68 30 97 10 c0       	push   $0xc0109730
c010399c:	68 02 95 10 c0       	push   $0xc0109502
c01039a1:	68 b3 00 00 00       	push   $0xb3
c01039a6:	68 17 95 10 c0       	push   $0xc0109517
c01039ab:	e8 40 ca ff ff       	call   c01003f0 <__panic>
    cprintf("read Virt Page d in enclock_check_swap\n");
c01039b0:	83 ec 0c             	sub    $0xc,%esp
c01039b3:	68 7c 96 10 c0       	push   $0xc010967c
c01039b8:	e8 cd c8 ff ff       	call   c010028a <cprintf>
c01039bd:	83 c4 10             	add    $0x10,%esp
    tmp = *(unsigned char *)0x4000;
c01039c0:	b8 00 40 00 00       	mov    $0x4000,%eax
c01039c5:	0f b6 00             	movzbl (%eax),%eax
c01039c8:	88 45 ef             	mov    %al,-0x11(%ebp)
    assert(pgfault_num==7);
c01039cb:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01039d0:	83 f8 07             	cmp    $0x7,%eax
c01039d3:	74 19                	je     c01039ee <_enclock_check_swap+0x2b0>
c01039d5:	68 3f 97 10 c0       	push   $0xc010973f
c01039da:	68 02 95 10 c0       	push   $0xc0109502
c01039df:	68 b6 00 00 00       	push   $0xb6
c01039e4:	68 17 95 10 c0       	push   $0xc0109517
c01039e9:	e8 02 ca ff ff       	call   c01003f0 <__panic>
    return 0;
c01039ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01039f3:	c9                   	leave  
c01039f4:	c3                   	ret    

c01039f5 <_enclock_init>:


static int
_enclock_init(void)
{
c01039f5:	55                   	push   %ebp
c01039f6:	89 e5                	mov    %esp,%ebp
    return 0;
c01039f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01039fd:	5d                   	pop    %ebp
c01039fe:	c3                   	ret    

c01039ff <_enclock_set_unswappable>:

static int
_enclock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01039ff:	55                   	push   %ebp
c0103a00:	89 e5                	mov    %esp,%ebp
    return 0;
c0103a02:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a07:	5d                   	pop    %ebp
c0103a08:	c3                   	ret    

c0103a09 <_enclock_tick_event>:

static int
_enclock_tick_event(struct mm_struct *mm)
{ return 0; }
c0103a09:	55                   	push   %ebp
c0103a0a:	89 e5                	mov    %esp,%ebp
c0103a0c:	b8 00 00 00 00       	mov    $0x0,%eax
c0103a11:	5d                   	pop    %ebp
c0103a12:	c3                   	ret    

c0103a13 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a13:	55                   	push   %ebp
c0103a14:	89 e5                	mov    %esp,%ebp
c0103a16:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0103a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1c:	c1 e8 0c             	shr    $0xc,%eax
c0103a1f:	89 c2                	mov    %eax,%edx
c0103a21:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0103a26:	39 c2                	cmp    %eax,%edx
c0103a28:	72 14                	jb     c0103a3e <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0103a2a:	83 ec 04             	sub    $0x4,%esp
c0103a2d:	68 6c 97 10 c0       	push   $0xc010976c
c0103a32:	6a 5b                	push   $0x5b
c0103a34:	68 8b 97 10 c0       	push   $0xc010978b
c0103a39:	e8 b2 c9 ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0103a3e:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0103a43:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a46:	c1 ea 0c             	shr    $0xc,%edx
c0103a49:	c1 e2 05             	shl    $0x5,%edx
c0103a4c:	01 d0                	add    %edx,%eax
}
c0103a4e:	c9                   	leave  
c0103a4f:	c3                   	ret    

c0103a50 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0103a50:	55                   	push   %ebp
c0103a51:	89 e5                	mov    %esp,%ebp
c0103a53:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0103a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a5e:	83 ec 0c             	sub    $0xc,%esp
c0103a61:	50                   	push   %eax
c0103a62:	e8 ac ff ff ff       	call   c0103a13 <pa2page>
c0103a67:	83 c4 10             	add    $0x10,%esp
}
c0103a6a:	c9                   	leave  
c0103a6b:	c3                   	ret    

c0103a6c <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0103a6c:	55                   	push   %ebp
c0103a6d:	89 e5                	mov    %esp,%ebp
c0103a6f:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0103a72:	83 ec 0c             	sub    $0xc,%esp
c0103a75:	6a 18                	push   $0x18
c0103a77:	e8 af 43 00 00       	call   c0107e2b <kmalloc>
c0103a7c:	83 c4 10             	add    $0x10,%esp
c0103a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0103a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a86:	74 5b                	je     c0103ae3 <mm_create+0x77>
        list_init(&(mm->mmap_list));
c0103a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103a94:	89 50 04             	mov    %edx,0x4(%eax)
c0103a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a9a:	8b 50 04             	mov    0x4(%eax),%edx
c0103a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aa0:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0103aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aaf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0103ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0103ac0:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0103ac5:	85 c0                	test   %eax,%eax
c0103ac7:	74 10                	je     c0103ad9 <mm_create+0x6d>
c0103ac9:	83 ec 0c             	sub    $0xc,%esp
c0103acc:	ff 75 f4             	pushl  -0xc(%ebp)
c0103acf:	e8 77 11 00 00       	call   c0104c4b <swap_init_mm>
c0103ad4:	83 c4 10             	add    $0x10,%esp
c0103ad7:	eb 0a                	jmp    c0103ae3 <mm_create+0x77>
        else mm->sm_priv = NULL;
c0103ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103adc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0103ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103ae6:	c9                   	leave  
c0103ae7:	c3                   	ret    

c0103ae8 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0103ae8:	55                   	push   %ebp
c0103ae9:	89 e5                	mov    %esp,%ebp
c0103aeb:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103aee:	83 ec 0c             	sub    $0xc,%esp
c0103af1:	6a 18                	push   $0x18
c0103af3:	e8 33 43 00 00       	call   c0107e2b <kmalloc>
c0103af8:	83 c4 10             	add    $0x10,%esp
c0103afb:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0103afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b02:	74 1b                	je     c0103b1f <vma_create+0x37>
        vma->vm_start = vm_start;
c0103b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b07:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b0a:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0103b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b10:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b13:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0103b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b19:	8b 55 10             	mov    0x10(%ebp),%edx
c0103b1c:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0103b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103b22:	c9                   	leave  
c0103b23:	c3                   	ret    

c0103b24 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0103b24:	55                   	push   %ebp
c0103b25:	89 e5                	mov    %esp,%ebp
c0103b27:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0103b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0103b31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b35:	0f 84 95 00 00 00    	je     c0103bd0 <find_vma+0xac>
        vma = mm->mmap_cache;
c0103b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3e:	8b 40 08             	mov    0x8(%eax),%eax
c0103b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0103b44:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103b48:	74 16                	je     c0103b60 <find_vma+0x3c>
c0103b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b4d:	8b 40 04             	mov    0x4(%eax),%eax
c0103b50:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b53:	77 0b                	ja     c0103b60 <find_vma+0x3c>
c0103b55:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b58:	8b 40 08             	mov    0x8(%eax),%eax
c0103b5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b5e:	77 61                	ja     c0103bc1 <find_vma+0x9d>
                bool found = 0;
c0103b60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0103b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103b73:	eb 28                	jmp    c0103b9d <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0103b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b78:	83 e8 10             	sub    $0x10,%eax
c0103b7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103b7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b81:	8b 40 04             	mov    0x4(%eax),%eax
c0103b84:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b87:	77 14                	ja     c0103b9d <find_vma+0x79>
c0103b89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b8c:	8b 40 08             	mov    0x8(%eax),%eax
c0103b8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b92:	76 09                	jbe    c0103b9d <find_vma+0x79>
                        found = 1;
c0103b94:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103b9b:	eb 17                	jmp    c0103bb4 <find_vma+0x90>
c0103b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ba6:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0103ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103baf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103bb2:	75 c1                	jne    c0103b75 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0103bb4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103bb8:	75 07                	jne    c0103bc1 <find_vma+0x9d>
                    vma = NULL;
c0103bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103bc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103bc5:	74 09                	je     c0103bd0 <find_vma+0xac>
            mm->mmap_cache = vma;
c0103bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bca:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103bcd:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103bd3:	c9                   	leave  
c0103bd4:	c3                   	ret    

c0103bd5 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0103bd5:	55                   	push   %ebp
c0103bd6:	89 e5                	mov    %esp,%ebp
c0103bd8:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
c0103bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bde:	8b 50 04             	mov    0x4(%eax),%edx
c0103be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be4:	8b 40 08             	mov    0x8(%eax),%eax
c0103be7:	39 c2                	cmp    %eax,%edx
c0103be9:	72 16                	jb     c0103c01 <check_vma_overlap+0x2c>
c0103beb:	68 99 97 10 c0       	push   $0xc0109799
c0103bf0:	68 b7 97 10 c0       	push   $0xc01097b7
c0103bf5:	6a 67                	push   $0x67
c0103bf7:	68 cc 97 10 c0       	push   $0xc01097cc
c0103bfc:	e8 ef c7 ff ff       	call   c01003f0 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c04:	8b 50 08             	mov    0x8(%eax),%edx
c0103c07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c0a:	8b 40 04             	mov    0x4(%eax),%eax
c0103c0d:	39 c2                	cmp    %eax,%edx
c0103c0f:	76 16                	jbe    c0103c27 <check_vma_overlap+0x52>
c0103c11:	68 dc 97 10 c0       	push   $0xc01097dc
c0103c16:	68 b7 97 10 c0       	push   $0xc01097b7
c0103c1b:	6a 68                	push   $0x68
c0103c1d:	68 cc 97 10 c0       	push   $0xc01097cc
c0103c22:	e8 c9 c7 ff ff       	call   c01003f0 <__panic>
    assert(next->vm_start < next->vm_end);
c0103c27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c2a:	8b 50 04             	mov    0x4(%eax),%edx
c0103c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c30:	8b 40 08             	mov    0x8(%eax),%eax
c0103c33:	39 c2                	cmp    %eax,%edx
c0103c35:	72 16                	jb     c0103c4d <check_vma_overlap+0x78>
c0103c37:	68 fb 97 10 c0       	push   $0xc01097fb
c0103c3c:	68 b7 97 10 c0       	push   $0xc01097b7
c0103c41:	6a 69                	push   $0x69
c0103c43:	68 cc 97 10 c0       	push   $0xc01097cc
c0103c48:	e8 a3 c7 ff ff       	call   c01003f0 <__panic>
}
c0103c4d:	90                   	nop
c0103c4e:	c9                   	leave  
c0103c4f:	c3                   	ret    

c0103c50 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103c50:	55                   	push   %ebp
c0103c51:	89 e5                	mov    %esp,%ebp
c0103c53:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
c0103c56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c59:	8b 50 04             	mov    0x4(%eax),%edx
c0103c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c5f:	8b 40 08             	mov    0x8(%eax),%eax
c0103c62:	39 c2                	cmp    %eax,%edx
c0103c64:	72 16                	jb     c0103c7c <insert_vma_struct+0x2c>
c0103c66:	68 19 98 10 c0       	push   $0xc0109819
c0103c6b:	68 b7 97 10 c0       	push   $0xc01097b7
c0103c70:	6a 70                	push   $0x70
c0103c72:	68 cc 97 10 c0       	push   $0xc01097cc
c0103c77:	e8 74 c7 ff ff       	call   c01003f0 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c85:	89 45 f4             	mov    %eax,-0xc(%ebp)

    list_entry_t *le = list;
c0103c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((le = list_next(le)) != list) {
c0103c8e:	eb 1f                	jmp    c0103caf <insert_vma_struct+0x5f>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c93:	83 e8 10             	sub    $0x10,%eax
c0103c96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (mmap_prev->vm_start > vma->vm_start) {
c0103c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c9c:	8b 50 04             	mov    0x4(%eax),%edx
c0103c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ca2:	8b 40 04             	mov    0x4(%eax),%eax
c0103ca5:	39 c2                	cmp    %eax,%edx
c0103ca7:	77 1f                	ja     c0103cc8 <insert_vma_struct+0x78>
            break;
        }
        le_prev = le;
c0103ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103cb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cb8:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

    list_entry_t *le = list;
    while ((le = list_next(le)) != list) {
c0103cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cc1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cc4:	75 ca                	jne    c0103c90 <insert_vma_struct+0x40>
c0103cc6:	eb 01                	jmp    c0103cc9 <insert_vma_struct+0x79>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start) {
            break;
c0103cc8:	90                   	nop
c0103cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ccc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cd2:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le_prev = le;
    }

    le_next = list_next(le_prev);
c0103cd5:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0103cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cdb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cde:	74 15                	je     c0103cf5 <insert_vma_struct+0xa5>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce3:	83 e8 10             	sub    $0x10,%eax
c0103ce6:	83 ec 08             	sub    $0x8,%esp
c0103ce9:	ff 75 0c             	pushl  0xc(%ebp)
c0103cec:	50                   	push   %eax
c0103ced:	e8 e3 fe ff ff       	call   c0103bd5 <check_vma_overlap>
c0103cf2:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
c0103cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103cf8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cfb:	74 15                	je     c0103d12 <insert_vma_struct+0xc2>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103cfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d00:	83 e8 10             	sub    $0x10,%eax
c0103d03:	83 ec 08             	sub    $0x8,%esp
c0103d06:	50                   	push   %eax
c0103d07:	ff 75 0c             	pushl  0xc(%ebp)
c0103d0a:	e8 c6 fe ff ff       	call   c0103bd5 <check_vma_overlap>
c0103d0f:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
c0103d12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d15:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d18:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d1d:	8d 50 10             	lea    0x10(%eax),%edx
c0103d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d23:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d26:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d2c:	8b 40 04             	mov    0x4(%eax),%eax
c0103d2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d32:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103d35:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103d38:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103d3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103d3e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d41:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d44:	89 10                	mov    %edx,(%eax)
c0103d46:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103d49:	8b 10                	mov    (%eax),%edx
c0103d4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d4e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103d51:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d54:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103d57:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103d5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d5d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103d60:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103d62:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d65:	8b 40 10             	mov    0x10(%eax),%eax
c0103d68:	8d 50 01             	lea    0x1(%eax),%edx
c0103d6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d6e:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103d71:	90                   	nop
c0103d72:	c9                   	leave  
c0103d73:	c3                   	ret    

c0103d74 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0103d74:	55                   	push   %ebp
c0103d75:	89 e5                	mov    %esp,%ebp
c0103d77:	83 ec 28             	sub    $0x28,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103d7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103d80:	eb 3c                	jmp    c0103dbe <mm_destroy+0x4a>
c0103d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d85:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d8b:	8b 40 04             	mov    0x4(%eax),%eax
c0103d8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103d91:	8b 12                	mov    (%edx),%edx
c0103d93:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0103d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103d9f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103da5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103da8:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0103daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dad:	83 e8 10             	sub    $0x10,%eax
c0103db0:	83 ec 08             	sub    $0x8,%esp
c0103db3:	6a 18                	push   $0x18
c0103db5:	50                   	push   %eax
c0103db6:	e8 01 41 00 00       	call   c0107ebc <kfree>
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
c0103dd3:	75 ad                	jne    c0103d82 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0103dd5:	83 ec 08             	sub    $0x8,%esp
c0103dd8:	6a 18                	push   $0x18
c0103dda:	ff 75 08             	pushl  0x8(%ebp)
c0103ddd:	e8 da 40 00 00       	call   c0107ebc <kfree>
c0103de2:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
c0103de5:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0103dec:	90                   	nop
c0103ded:	c9                   	leave  
c0103dee:	c3                   	ret    

c0103def <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0103def:	55                   	push   %ebp
c0103df0:	89 e5                	mov    %esp,%ebp
c0103df2:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103df5:	e8 03 00 00 00       	call   c0103dfd <check_vmm>
}
c0103dfa:	90                   	nop
c0103dfb:	c9                   	leave  
c0103dfc:	c3                   	ret    

c0103dfd <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0103dfd:	55                   	push   %ebp
c0103dfe:	89 e5                	mov    %esp,%ebp
c0103e00:	83 ec 18             	sub    $0x18,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e03:	e8 95 2b 00 00       	call   c010699d <nr_free_pages>
c0103e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103e0b:	e8 3b 00 00 00       	call   c0103e4b <check_vma_struct>
    check_pgfault();
c0103e10:	e8 56 04 00 00       	call   c010426b <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0103e15:	e8 83 2b 00 00       	call   c010699d <nr_free_pages>
c0103e1a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103e1d:	74 19                	je     c0103e38 <check_vmm+0x3b>
c0103e1f:	68 38 98 10 c0       	push   $0xc0109838
c0103e24:	68 b7 97 10 c0       	push   $0xc01097b7
c0103e29:	68 a9 00 00 00       	push   $0xa9
c0103e2e:	68 cc 97 10 c0       	push   $0xc01097cc
c0103e33:	e8 b8 c5 ff ff       	call   c01003f0 <__panic>

    cprintf("check_vmm() succeeded.\n");
c0103e38:	83 ec 0c             	sub    $0xc,%esp
c0103e3b:	68 5f 98 10 c0       	push   $0xc010985f
c0103e40:	e8 45 c4 ff ff       	call   c010028a <cprintf>
c0103e45:	83 c4 10             	add    $0x10,%esp
}
c0103e48:	90                   	nop
c0103e49:	c9                   	leave  
c0103e4a:	c3                   	ret    

c0103e4b <check_vma_struct>:

static void
check_vma_struct(void) {
c0103e4b:	55                   	push   %ebp
c0103e4c:	89 e5                	mov    %esp,%ebp
c0103e4e:	83 ec 58             	sub    $0x58,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103e51:	e8 47 2b 00 00       	call   c010699d <nr_free_pages>
c0103e56:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0103e59:	e8 0e fc ff ff       	call   c0103a6c <mm_create>
c0103e5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103e61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103e65:	75 19                	jne    c0103e80 <check_vma_struct+0x35>
c0103e67:	68 77 98 10 c0       	push   $0xc0109877
c0103e6c:	68 b7 97 10 c0       	push   $0xc01097b7
c0103e71:	68 b3 00 00 00       	push   $0xb3
c0103e76:	68 cc 97 10 c0       	push   $0xc01097cc
c0103e7b:	e8 70 c5 ff ff       	call   c01003f0 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103e80:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0103e87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e8a:	89 d0                	mov    %edx,%eax
c0103e8c:	c1 e0 02             	shl    $0x2,%eax
c0103e8f:	01 d0                	add    %edx,%eax
c0103e91:	01 c0                	add    %eax,%eax
c0103e93:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0103e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103e9c:	eb 5f                	jmp    c0103efd <check_vma_struct+0xb2>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ea1:	89 d0                	mov    %edx,%eax
c0103ea3:	c1 e0 02             	shl    $0x2,%eax
c0103ea6:	01 d0                	add    %edx,%eax
c0103ea8:	83 c0 02             	add    $0x2,%eax
c0103eab:	89 c1                	mov    %eax,%ecx
c0103ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103eb0:	89 d0                	mov    %edx,%eax
c0103eb2:	c1 e0 02             	shl    $0x2,%eax
c0103eb5:	01 d0                	add    %edx,%eax
c0103eb7:	83 ec 04             	sub    $0x4,%esp
c0103eba:	6a 00                	push   $0x0
c0103ebc:	51                   	push   %ecx
c0103ebd:	50                   	push   %eax
c0103ebe:	e8 25 fc ff ff       	call   c0103ae8 <vma_create>
c0103ec3:	83 c4 10             	add    $0x10,%esp
c0103ec6:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0103ec9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103ecd:	75 19                	jne    c0103ee8 <check_vma_struct+0x9d>
c0103ecf:	68 82 98 10 c0       	push   $0xc0109882
c0103ed4:	68 b7 97 10 c0       	push   $0xc01097b7
c0103ed9:	68 ba 00 00 00       	push   $0xba
c0103ede:	68 cc 97 10 c0       	push   $0xc01097cc
c0103ee3:	e8 08 c5 ff ff       	call   c01003f0 <__panic>
        insert_vma_struct(mm, vma);
c0103ee8:	83 ec 08             	sub    $0x8,%esp
c0103eeb:	ff 75 dc             	pushl  -0x24(%ebp)
c0103eee:	ff 75 e8             	pushl  -0x18(%ebp)
c0103ef1:	e8 5a fd ff ff       	call   c0103c50 <insert_vma_struct>
c0103ef6:	83 c4 10             	add    $0x10,%esp
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0103ef9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103f01:	7f 9b                	jg     c0103e9e <check_vma_struct+0x53>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f06:	83 c0 01             	add    $0x1,%eax
c0103f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103f0c:	eb 5f                	jmp    c0103f6d <check_vma_struct+0x122>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f11:	89 d0                	mov    %edx,%eax
c0103f13:	c1 e0 02             	shl    $0x2,%eax
c0103f16:	01 d0                	add    %edx,%eax
c0103f18:	83 c0 02             	add    $0x2,%eax
c0103f1b:	89 c1                	mov    %eax,%ecx
c0103f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f20:	89 d0                	mov    %edx,%eax
c0103f22:	c1 e0 02             	shl    $0x2,%eax
c0103f25:	01 d0                	add    %edx,%eax
c0103f27:	83 ec 04             	sub    $0x4,%esp
c0103f2a:	6a 00                	push   $0x0
c0103f2c:	51                   	push   %ecx
c0103f2d:	50                   	push   %eax
c0103f2e:	e8 b5 fb ff ff       	call   c0103ae8 <vma_create>
c0103f33:	83 c4 10             	add    $0x10,%esp
c0103f36:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0103f39:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103f3d:	75 19                	jne    c0103f58 <check_vma_struct+0x10d>
c0103f3f:	68 82 98 10 c0       	push   $0xc0109882
c0103f44:	68 b7 97 10 c0       	push   $0xc01097b7
c0103f49:	68 c0 00 00 00       	push   $0xc0
c0103f4e:	68 cc 97 10 c0       	push   $0xc01097cc
c0103f53:	e8 98 c4 ff ff       	call   c01003f0 <__panic>
        insert_vma_struct(mm, vma);
c0103f58:	83 ec 08             	sub    $0x8,%esp
c0103f5b:	ff 75 d8             	pushl  -0x28(%ebp)
c0103f5e:	ff 75 e8             	pushl  -0x18(%ebp)
c0103f61:	e8 ea fc ff ff       	call   c0103c50 <insert_vma_struct>
c0103f66:	83 c4 10             	add    $0x10,%esp
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103f69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f70:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103f73:	7e 99                	jle    c0103f0e <check_vma_struct+0xc3>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0103f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f78:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103f7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f7e:	8b 40 04             	mov    0x4(%eax),%eax
c0103f81:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103f84:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103f8b:	e9 81 00 00 00       	jmp    c0104011 <check_vma_struct+0x1c6>
        assert(le != &(mm->mmap_list));
c0103f90:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f93:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103f96:	75 19                	jne    c0103fb1 <check_vma_struct+0x166>
c0103f98:	68 8e 98 10 c0       	push   $0xc010988e
c0103f9d:	68 b7 97 10 c0       	push   $0xc01097b7
c0103fa2:	68 c7 00 00 00       	push   $0xc7
c0103fa7:	68 cc 97 10 c0       	push   $0xc01097cc
c0103fac:	e8 3f c4 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fb4:	83 e8 10             	sub    $0x10,%eax
c0103fb7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103fba:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fbd:	8b 48 04             	mov    0x4(%eax),%ecx
c0103fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103fc3:	89 d0                	mov    %edx,%eax
c0103fc5:	c1 e0 02             	shl    $0x2,%eax
c0103fc8:	01 d0                	add    %edx,%eax
c0103fca:	39 c1                	cmp    %eax,%ecx
c0103fcc:	75 17                	jne    c0103fe5 <check_vma_struct+0x19a>
c0103fce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fd1:	8b 48 08             	mov    0x8(%eax),%ecx
c0103fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103fd7:	89 d0                	mov    %edx,%eax
c0103fd9:	c1 e0 02             	shl    $0x2,%eax
c0103fdc:	01 d0                	add    %edx,%eax
c0103fde:	83 c0 02             	add    $0x2,%eax
c0103fe1:	39 c1                	cmp    %eax,%ecx
c0103fe3:	74 19                	je     c0103ffe <check_vma_struct+0x1b3>
c0103fe5:	68 a8 98 10 c0       	push   $0xc01098a8
c0103fea:	68 b7 97 10 c0       	push   $0xc01097b7
c0103fef:	68 c9 00 00 00       	push   $0xc9
c0103ff4:	68 cc 97 10 c0       	push   $0xc01097cc
c0103ff9:	e8 f2 c3 ff ff       	call   c01003f0 <__panic>
c0103ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104001:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104004:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104007:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010400a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c010400d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104011:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104014:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104017:	0f 8e 73 ff ff ff    	jle    c0103f90 <check_vma_struct+0x145>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010401d:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0104024:	e9 80 01 00 00       	jmp    c01041a9 <check_vma_struct+0x35e>
        struct vma_struct *vma1 = find_vma(mm, i);
c0104029:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010402c:	83 ec 08             	sub    $0x8,%esp
c010402f:	50                   	push   %eax
c0104030:	ff 75 e8             	pushl  -0x18(%ebp)
c0104033:	e8 ec fa ff ff       	call   c0103b24 <find_vma>
c0104038:	83 c4 10             	add    $0x10,%esp
c010403b:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c010403e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104042:	75 19                	jne    c010405d <check_vma_struct+0x212>
c0104044:	68 dd 98 10 c0       	push   $0xc01098dd
c0104049:	68 b7 97 10 c0       	push   $0xc01097b7
c010404e:	68 cf 00 00 00       	push   $0xcf
c0104053:	68 cc 97 10 c0       	push   $0xc01097cc
c0104058:	e8 93 c3 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c010405d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104060:	83 c0 01             	add    $0x1,%eax
c0104063:	83 ec 08             	sub    $0x8,%esp
c0104066:	50                   	push   %eax
c0104067:	ff 75 e8             	pushl  -0x18(%ebp)
c010406a:	e8 b5 fa ff ff       	call   c0103b24 <find_vma>
c010406f:	83 c4 10             	add    $0x10,%esp
c0104072:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c0104075:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104079:	75 19                	jne    c0104094 <check_vma_struct+0x249>
c010407b:	68 ea 98 10 c0       	push   $0xc01098ea
c0104080:	68 b7 97 10 c0       	push   $0xc01097b7
c0104085:	68 d1 00 00 00       	push   $0xd1
c010408a:	68 cc 97 10 c0       	push   $0xc01097cc
c010408f:	e8 5c c3 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0104094:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104097:	83 c0 02             	add    $0x2,%eax
c010409a:	83 ec 08             	sub    $0x8,%esp
c010409d:	50                   	push   %eax
c010409e:	ff 75 e8             	pushl  -0x18(%ebp)
c01040a1:	e8 7e fa ff ff       	call   c0103b24 <find_vma>
c01040a6:	83 c4 10             	add    $0x10,%esp
c01040a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c01040ac:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01040b0:	74 19                	je     c01040cb <check_vma_struct+0x280>
c01040b2:	68 f7 98 10 c0       	push   $0xc01098f7
c01040b7:	68 b7 97 10 c0       	push   $0xc01097b7
c01040bc:	68 d3 00 00 00       	push   $0xd3
c01040c1:	68 cc 97 10 c0       	push   $0xc01097cc
c01040c6:	e8 25 c3 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01040cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040ce:	83 c0 03             	add    $0x3,%eax
c01040d1:	83 ec 08             	sub    $0x8,%esp
c01040d4:	50                   	push   %eax
c01040d5:	ff 75 e8             	pushl  -0x18(%ebp)
c01040d8:	e8 47 fa ff ff       	call   c0103b24 <find_vma>
c01040dd:	83 c4 10             	add    $0x10,%esp
c01040e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c01040e3:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01040e7:	74 19                	je     c0104102 <check_vma_struct+0x2b7>
c01040e9:	68 04 99 10 c0       	push   $0xc0109904
c01040ee:	68 b7 97 10 c0       	push   $0xc01097b7
c01040f3:	68 d5 00 00 00       	push   $0xd5
c01040f8:	68 cc 97 10 c0       	push   $0xc01097cc
c01040fd:	e8 ee c2 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0104102:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104105:	83 c0 04             	add    $0x4,%eax
c0104108:	83 ec 08             	sub    $0x8,%esp
c010410b:	50                   	push   %eax
c010410c:	ff 75 e8             	pushl  -0x18(%ebp)
c010410f:	e8 10 fa ff ff       	call   c0103b24 <find_vma>
c0104114:	83 c4 10             	add    $0x10,%esp
c0104117:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c010411a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010411e:	74 19                	je     c0104139 <check_vma_struct+0x2ee>
c0104120:	68 11 99 10 c0       	push   $0xc0109911
c0104125:	68 b7 97 10 c0       	push   $0xc01097b7
c010412a:	68 d7 00 00 00       	push   $0xd7
c010412f:	68 cc 97 10 c0       	push   $0xc01097cc
c0104134:	e8 b7 c2 ff ff       	call   c01003f0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0104139:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010413c:	8b 50 04             	mov    0x4(%eax),%edx
c010413f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104142:	39 c2                	cmp    %eax,%edx
c0104144:	75 10                	jne    c0104156 <check_vma_struct+0x30b>
c0104146:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104149:	8b 40 08             	mov    0x8(%eax),%eax
c010414c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010414f:	83 c2 02             	add    $0x2,%edx
c0104152:	39 d0                	cmp    %edx,%eax
c0104154:	74 19                	je     c010416f <check_vma_struct+0x324>
c0104156:	68 20 99 10 c0       	push   $0xc0109920
c010415b:	68 b7 97 10 c0       	push   $0xc01097b7
c0104160:	68 d9 00 00 00       	push   $0xd9
c0104165:	68 cc 97 10 c0       	push   $0xc01097cc
c010416a:	e8 81 c2 ff ff       	call   c01003f0 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010416f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104172:	8b 50 04             	mov    0x4(%eax),%edx
c0104175:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104178:	39 c2                	cmp    %eax,%edx
c010417a:	75 10                	jne    c010418c <check_vma_struct+0x341>
c010417c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010417f:	8b 40 08             	mov    0x8(%eax),%eax
c0104182:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104185:	83 c2 02             	add    $0x2,%edx
c0104188:	39 d0                	cmp    %edx,%eax
c010418a:	74 19                	je     c01041a5 <check_vma_struct+0x35a>
c010418c:	68 50 99 10 c0       	push   $0xc0109950
c0104191:	68 b7 97 10 c0       	push   $0xc01097b7
c0104196:	68 da 00 00 00       	push   $0xda
c010419b:	68 cc 97 10 c0       	push   $0xc01097cc
c01041a0:	e8 4b c2 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01041a5:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01041a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041ac:	89 d0                	mov    %edx,%eax
c01041ae:	c1 e0 02             	shl    $0x2,%eax
c01041b1:	01 d0                	add    %edx,%eax
c01041b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01041b6:	0f 8d 6d fe ff ff    	jge    c0104029 <check_vma_struct+0x1de>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01041bc:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01041c3:	eb 5c                	jmp    c0104221 <check_vma_struct+0x3d6>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01041c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041c8:	83 ec 08             	sub    $0x8,%esp
c01041cb:	50                   	push   %eax
c01041cc:	ff 75 e8             	pushl  -0x18(%ebp)
c01041cf:	e8 50 f9 ff ff       	call   c0103b24 <find_vma>
c01041d4:	83 c4 10             	add    $0x10,%esp
c01041d7:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL ) {
c01041da:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01041de:	74 1e                	je     c01041fe <check_vma_struct+0x3b3>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01041e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041e3:	8b 50 08             	mov    0x8(%eax),%edx
c01041e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041e9:	8b 40 04             	mov    0x4(%eax),%eax
c01041ec:	52                   	push   %edx
c01041ed:	50                   	push   %eax
c01041ee:	ff 75 f4             	pushl  -0xc(%ebp)
c01041f1:	68 80 99 10 c0       	push   $0xc0109980
c01041f6:	e8 8f c0 ff ff       	call   c010028a <cprintf>
c01041fb:	83 c4 10             	add    $0x10,%esp
        }
        assert(vma_below_5 == NULL);
c01041fe:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104202:	74 19                	je     c010421d <check_vma_struct+0x3d2>
c0104204:	68 a5 99 10 c0       	push   $0xc01099a5
c0104209:	68 b7 97 10 c0       	push   $0xc01097b7
c010420e:	68 e2 00 00 00       	push   $0xe2
c0104213:	68 cc 97 10 c0       	push   $0xc01097cc
c0104218:	e8 d3 c1 ff ff       	call   c01003f0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010421d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104225:	79 9e                	jns    c01041c5 <check_vma_struct+0x37a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0104227:	83 ec 0c             	sub    $0xc,%esp
c010422a:	ff 75 e8             	pushl  -0x18(%ebp)
c010422d:	e8 42 fb ff ff       	call   c0103d74 <mm_destroy>
c0104232:	83 c4 10             	add    $0x10,%esp

    assert(nr_free_pages_store == nr_free_pages());
c0104235:	e8 63 27 00 00       	call   c010699d <nr_free_pages>
c010423a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010423d:	74 19                	je     c0104258 <check_vma_struct+0x40d>
c010423f:	68 38 98 10 c0       	push   $0xc0109838
c0104244:	68 b7 97 10 c0       	push   $0xc01097b7
c0104249:	68 e7 00 00 00       	push   $0xe7
c010424e:	68 cc 97 10 c0       	push   $0xc01097cc
c0104253:	e8 98 c1 ff ff       	call   c01003f0 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0104258:	83 ec 0c             	sub    $0xc,%esp
c010425b:	68 bc 99 10 c0       	push   $0xc01099bc
c0104260:	e8 25 c0 ff ff       	call   c010028a <cprintf>
c0104265:	83 c4 10             	add    $0x10,%esp
}
c0104268:	90                   	nop
c0104269:	c9                   	leave  
c010426a:	c3                   	ret    

c010426b <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c010426b:	55                   	push   %ebp
c010426c:	89 e5                	mov    %esp,%ebp
c010426e:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0104271:	e8 27 27 00 00       	call   c010699d <nr_free_pages>
c0104276:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0104279:	e8 ee f7 ff ff       	call   c0103a6c <mm_create>
c010427e:	a3 7c 50 12 c0       	mov    %eax,0xc012507c
    assert(check_mm_struct != NULL);
c0104283:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c0104288:	85 c0                	test   %eax,%eax
c010428a:	75 19                	jne    c01042a5 <check_pgfault+0x3a>
c010428c:	68 db 99 10 c0       	push   $0xc01099db
c0104291:	68 b7 97 10 c0       	push   $0xc01097b7
c0104296:	68 f4 00 00 00       	push   $0xf4
c010429b:	68 cc 97 10 c0       	push   $0xc01097cc
c01042a0:	e8 4b c1 ff ff       	call   c01003f0 <__panic>

    struct mm_struct *mm = check_mm_struct;
c01042a5:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c01042aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c01042ad:	8b 15 40 1a 12 c0    	mov    0xc0121a40,%edx
c01042b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042b6:	89 50 0c             	mov    %edx,0xc(%eax)
c01042b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042bc:	8b 40 0c             	mov    0xc(%eax),%eax
c01042bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c01042c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042c5:	8b 00                	mov    (%eax),%eax
c01042c7:	85 c0                	test   %eax,%eax
c01042c9:	74 19                	je     c01042e4 <check_pgfault+0x79>
c01042cb:	68 f3 99 10 c0       	push   $0xc01099f3
c01042d0:	68 b7 97 10 c0       	push   $0xc01097b7
c01042d5:	68 f8 00 00 00       	push   $0xf8
c01042da:	68 cc 97 10 c0       	push   $0xc01097cc
c01042df:	e8 0c c1 ff ff       	call   c01003f0 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01042e4:	83 ec 04             	sub    $0x4,%esp
c01042e7:	6a 02                	push   $0x2
c01042e9:	68 00 00 40 00       	push   $0x400000
c01042ee:	6a 00                	push   $0x0
c01042f0:	e8 f3 f7 ff ff       	call   c0103ae8 <vma_create>
c01042f5:	83 c4 10             	add    $0x10,%esp
c01042f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01042fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042ff:	75 19                	jne    c010431a <check_pgfault+0xaf>
c0104301:	68 82 98 10 c0       	push   $0xc0109882
c0104306:	68 b7 97 10 c0       	push   $0xc01097b7
c010430b:	68 fb 00 00 00       	push   $0xfb
c0104310:	68 cc 97 10 c0       	push   $0xc01097cc
c0104315:	e8 d6 c0 ff ff       	call   c01003f0 <__panic>

    insert_vma_struct(mm, vma);
c010431a:	83 ec 08             	sub    $0x8,%esp
c010431d:	ff 75 e0             	pushl  -0x20(%ebp)
c0104320:	ff 75 e8             	pushl  -0x18(%ebp)
c0104323:	e8 28 f9 ff ff       	call   c0103c50 <insert_vma_struct>
c0104328:	83 c4 10             	add    $0x10,%esp

    uintptr_t addr = 0x100;
c010432b:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0104332:	83 ec 08             	sub    $0x8,%esp
c0104335:	ff 75 dc             	pushl  -0x24(%ebp)
c0104338:	ff 75 e8             	pushl  -0x18(%ebp)
c010433b:	e8 e4 f7 ff ff       	call   c0103b24 <find_vma>
c0104340:	83 c4 10             	add    $0x10,%esp
c0104343:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104346:	74 19                	je     c0104361 <check_pgfault+0xf6>
c0104348:	68 01 9a 10 c0       	push   $0xc0109a01
c010434d:	68 b7 97 10 c0       	push   $0xc01097b7
c0104352:	68 00 01 00 00       	push   $0x100
c0104357:	68 cc 97 10 c0       	push   $0xc01097cc
c010435c:	e8 8f c0 ff ff       	call   c01003f0 <__panic>

    int i, sum = 0;
c0104361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0104368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010436f:	eb 19                	jmp    c010438a <check_pgfault+0x11f>
        *(char *)(addr + i) = i;
c0104371:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104374:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104377:	01 d0                	add    %edx,%eax
c0104379:	89 c2                	mov    %eax,%edx
c010437b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437e:	88 02                	mov    %al,(%edx)
        sum += i;
c0104380:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104383:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0104386:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010438a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010438e:	7e e1                	jle    c0104371 <check_pgfault+0x106>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0104390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104397:	eb 15                	jmp    c01043ae <check_pgfault+0x143>
        sum -= *(char *)(addr + i);
c0104399:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010439c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010439f:	01 d0                	add    %edx,%eax
c01043a1:	0f b6 00             	movzbl (%eax),%eax
c01043a4:	0f be c0             	movsbl %al,%eax
c01043a7:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c01043aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01043ae:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01043b2:	7e e5                	jle    c0104399 <check_pgfault+0x12e>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c01043b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043b8:	74 19                	je     c01043d3 <check_pgfault+0x168>
c01043ba:	68 1b 9a 10 c0       	push   $0xc0109a1b
c01043bf:	68 b7 97 10 c0       	push   $0xc01097b7
c01043c4:	68 0a 01 00 00       	push   $0x10a
c01043c9:	68 cc 97 10 c0       	push   $0xc01097cc
c01043ce:	e8 1d c0 ff ff       	call   c01003f0 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01043d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01043d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043e1:	83 ec 08             	sub    $0x8,%esp
c01043e4:	50                   	push   %eax
c01043e5:	ff 75 e4             	pushl  -0x1c(%ebp)
c01043e8:	e8 7c 2d 00 00       	call   c0107169 <page_remove>
c01043ed:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(pgdir[0]));
c01043f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043f3:	8b 00                	mov    (%eax),%eax
c01043f5:	83 ec 0c             	sub    $0xc,%esp
c01043f8:	50                   	push   %eax
c01043f9:	e8 52 f6 ff ff       	call   c0103a50 <pde2page>
c01043fe:	83 c4 10             	add    $0x10,%esp
c0104401:	83 ec 08             	sub    $0x8,%esp
c0104404:	6a 01                	push   $0x1
c0104406:	50                   	push   %eax
c0104407:	e8 5c 25 00 00       	call   c0106968 <free_pages>
c010440c:	83 c4 10             	add    $0x10,%esp
    pgdir[0] = 0;
c010440f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0104418:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010441b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0104422:	83 ec 0c             	sub    $0xc,%esp
c0104425:	ff 75 e8             	pushl  -0x18(%ebp)
c0104428:	e8 47 f9 ff ff       	call   c0103d74 <mm_destroy>
c010442d:	83 c4 10             	add    $0x10,%esp
    check_mm_struct = NULL;
c0104430:	c7 05 7c 50 12 c0 00 	movl   $0x0,0xc012507c
c0104437:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c010443a:	e8 5e 25 00 00       	call   c010699d <nr_free_pages>
c010443f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104442:	74 19                	je     c010445d <check_pgfault+0x1f2>
c0104444:	68 38 98 10 c0       	push   $0xc0109838
c0104449:	68 b7 97 10 c0       	push   $0xc01097b7
c010444e:	68 14 01 00 00       	push   $0x114
c0104453:	68 cc 97 10 c0       	push   $0xc01097cc
c0104458:	e8 93 bf ff ff       	call   c01003f0 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c010445d:	83 ec 0c             	sub    $0xc,%esp
c0104460:	68 24 9a 10 c0       	push   $0xc0109a24
c0104465:	e8 20 be ff ff       	call   c010028a <cprintf>
c010446a:	83 c4 10             	add    $0x10,%esp
}
c010446d:	90                   	nop
c010446e:	c9                   	leave  
c010446f:	c3                   	ret    

c0104470 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0104470:	55                   	push   %ebp
c0104471:	89 e5                	mov    %esp,%ebp
c0104473:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_INVAL;
c0104476:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c010447d:	ff 75 10             	pushl  0x10(%ebp)
c0104480:	ff 75 08             	pushl  0x8(%ebp)
c0104483:	e8 9c f6 ff ff       	call   c0103b24 <find_vma>
c0104488:	83 c4 08             	add    $0x8,%esp
c010448b:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c010448e:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104493:	83 c0 01             	add    $0x1,%eax
c0104496:	a3 64 4f 12 c0       	mov    %eax,0xc0124f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c010449b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010449f:	74 0b                	je     c01044ac <do_pgfault+0x3c>
c01044a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044a4:	8b 40 04             	mov    0x4(%eax),%eax
c01044a7:	3b 45 10             	cmp    0x10(%ebp),%eax
c01044aa:	76 18                	jbe    c01044c4 <do_pgfault+0x54>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c01044ac:	83 ec 08             	sub    $0x8,%esp
c01044af:	ff 75 10             	pushl  0x10(%ebp)
c01044b2:	68 40 9a 10 c0       	push   $0xc0109a40
c01044b7:	e8 ce bd ff ff       	call   c010028a <cprintf>
c01044bc:	83 c4 10             	add    $0x10,%esp
        goto failed;
c01044bf:	e9 b4 01 00 00       	jmp    c0104678 <do_pgfault+0x208>
    }
    //check the error_code
    switch (error_code & 3) {
c01044c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044c7:	83 e0 03             	and    $0x3,%eax
c01044ca:	85 c0                	test   %eax,%eax
c01044cc:	74 3c                	je     c010450a <do_pgfault+0x9a>
c01044ce:	83 f8 01             	cmp    $0x1,%eax
c01044d1:	74 22                	je     c01044f5 <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
            // this happens when privilege conflict
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01044d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044d6:	8b 40 0c             	mov    0xc(%eax),%eax
c01044d9:	83 e0 02             	and    $0x2,%eax
c01044dc:	85 c0                	test   %eax,%eax
c01044de:	75 4c                	jne    c010452c <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01044e0:	83 ec 0c             	sub    $0xc,%esp
c01044e3:	68 70 9a 10 c0       	push   $0xc0109a70
c01044e8:	e8 9d bd ff ff       	call   c010028a <cprintf>
c01044ed:	83 c4 10             	add    $0x10,%esp
            goto failed;
c01044f0:	e9 83 01 00 00       	jmp    c0104678 <do_pgfault+0x208>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        // this should not happen!
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01044f5:	83 ec 0c             	sub    $0xc,%esp
c01044f8:	68 d0 9a 10 c0       	push   $0xc0109ad0
c01044fd:	e8 88 bd ff ff       	call   c010028a <cprintf>
c0104502:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0104505:	e9 6e 01 00 00       	jmp    c0104678 <do_pgfault+0x208>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c010450a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010450d:	8b 40 0c             	mov    0xc(%eax),%eax
c0104510:	83 e0 05             	and    $0x5,%eax
c0104513:	85 c0                	test   %eax,%eax
c0104515:	75 16                	jne    c010452d <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0104517:	83 ec 0c             	sub    $0xc,%esp
c010451a:	68 08 9b 10 c0       	push   $0xc0109b08
c010451f:	e8 66 bd ff ff       	call   c010028a <cprintf>
c0104524:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0104527:	e9 4c 01 00 00       	jmp    c0104678 <do_pgfault+0x208>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c010452c:	90                   	nop
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    // constitute permission
    uint32_t perm = PTE_U;
c010452d:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0104534:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104537:	8b 40 0c             	mov    0xc(%eax),%eax
c010453a:	83 e0 02             	and    $0x2,%eax
c010453d:	85 c0                	test   %eax,%eax
c010453f:	74 04                	je     c0104545 <do_pgfault+0xd5>
        perm |= PTE_W;
c0104541:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0104545:	8b 45 10             	mov    0x10(%ebp),%eax
c0104548:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010454b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010454e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104553:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0104556:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c010455d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: 2015010062*/
    ptep = get_pte(mm->pgdir, addr, 1);              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0104564:	8b 45 08             	mov    0x8(%ebp),%eax
c0104567:	8b 40 0c             	mov    0xc(%eax),%eax
c010456a:	83 ec 04             	sub    $0x4,%esp
c010456d:	6a 01                	push   $0x1
c010456f:	ff 75 10             	pushl  0x10(%ebp)
c0104572:	50                   	push   %eax
c0104573:	e8 eb 29 00 00       	call   c0106f63 <get_pte>
c0104578:	83 c4 10             	add    $0x10,%esp
c010457b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(ptep != NULL);
c010457e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104582:	75 19                	jne    c010459d <do_pgfault+0x12d>
c0104584:	68 6b 9b 10 c0       	push   $0xc0109b6b
c0104589:	68 b7 97 10 c0       	push   $0xc01097b7
c010458e:	68 74 01 00 00       	push   $0x174
c0104593:	68 cc 97 10 c0       	push   $0xc01097cc
c0104598:	e8 53 be ff ff       	call   c01003f0 <__panic>
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0) {
c010459d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045a0:	8b 00                	mov    (%eax),%eax
c01045a2:	85 c0                	test   %eax,%eax
c01045a4:	75 39                	jne    c01045df <do_pgfault+0x16f>
        assert(pgdir_alloc_page(mm->pgdir, addr, perm) != NULL);
c01045a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a9:	8b 40 0c             	mov    0xc(%eax),%eax
c01045ac:	83 ec 04             	sub    $0x4,%esp
c01045af:	ff 75 f0             	pushl  -0x10(%ebp)
c01045b2:	ff 75 10             	pushl  0x10(%ebp)
c01045b5:	50                   	push   %eax
c01045b6:	e8 f0 2c 00 00       	call   c01072ab <pgdir_alloc_page>
c01045bb:	83 c4 10             	add    $0x10,%esp
c01045be:	85 c0                	test   %eax,%eax
c01045c0:	0f 85 ab 00 00 00    	jne    c0104671 <do_pgfault+0x201>
c01045c6:	68 78 9b 10 c0       	push   $0xc0109b78
c01045cb:	68 b7 97 10 c0       	push   $0xc01097b7
c01045d0:	68 77 01 00 00       	push   $0x177
c01045d5:	68 cc 97 10 c0       	push   $0xc01097cc
c01045da:	e8 11 be ff ff       	call   c01003f0 <__panic>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c01045df:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c01045e4:	85 c0                	test   %eax,%eax
c01045e6:	74 71                	je     c0104659 <do_pgfault+0x1e9>
            struct Page *page=NULL;
c01045e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page
            //    into the memory which page managed.
            assert(swap_in(mm, addr, &page) == 0);
c01045ef:	83 ec 04             	sub    $0x4,%esp
c01045f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01045f5:	50                   	push   %eax
c01045f6:	ff 75 10             	pushl  0x10(%ebp)
c01045f9:	ff 75 08             	pushl  0x8(%ebp)
c01045fc:	e8 10 08 00 00       	call   c0104e11 <swap_in>
c0104601:	83 c4 10             	add    $0x10,%esp
c0104604:	85 c0                	test   %eax,%eax
c0104606:	74 19                	je     c0104621 <do_pgfault+0x1b1>
c0104608:	68 a8 9b 10 c0       	push   $0xc0109ba8
c010460d:	68 b7 97 10 c0       	push   $0xc01097b7
c0104612:	68 89 01 00 00       	push   $0x189
c0104617:	68 cc 97 10 c0       	push   $0xc01097cc
c010461c:	e8 cf bd ff ff       	call   c01003f0 <__panic>
            page->pra_vaddr = addr;
c0104621:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104624:	8b 55 10             	mov    0x10(%ebp),%edx
c0104627:	89 50 1c             	mov    %edx,0x1c(%eax)
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            page_insert(mm->pgdir, page, addr, perm);
c010462a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010462d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104630:	8b 40 0c             	mov    0xc(%eax),%eax
c0104633:	ff 75 f0             	pushl  -0x10(%ebp)
c0104636:	ff 75 10             	pushl  0x10(%ebp)
c0104639:	52                   	push   %edx
c010463a:	50                   	push   %eax
c010463b:	e8 62 2b 00 00       	call   c01071a2 <page_insert>
c0104640:	83 c4 10             	add    $0x10,%esp
            //(3) make the page swappable.
            swap_map_swappable(mm, addr, page, 1);
c0104643:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104646:	6a 01                	push   $0x1
c0104648:	50                   	push   %eax
c0104649:	ff 75 10             	pushl  0x10(%ebp)
c010464c:	ff 75 08             	pushl  0x8(%ebp)
c010464f:	e8 2d 06 00 00       	call   c0104c81 <swap_map_swappable>
c0104654:	83 c4 10             	add    $0x10,%esp
c0104657:	eb 18                	jmp    c0104671 <do_pgfault+0x201>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0104659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010465c:	8b 00                	mov    (%eax),%eax
c010465e:	83 ec 08             	sub    $0x8,%esp
c0104661:	50                   	push   %eax
c0104662:	68 c8 9b 10 c0       	push   $0xc0109bc8
c0104667:	e8 1e bc ff ff       	call   c010028a <cprintf>
c010466c:	83 c4 10             	add    $0x10,%esp
            goto failed;
c010466f:	eb 07                	jmp    c0104678 <do_pgfault+0x208>
        }
   }
   ret = 0;
c0104671:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010467b:	c9                   	leave  
c010467c:	c3                   	ret    

c010467d <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010467d:	55                   	push   %ebp
c010467e:	89 e5                	mov    %esp,%ebp
c0104680:	83 ec 10             	sub    $0x10,%esp
c0104683:	c7 45 fc 70 50 12 c0 	movl   $0xc0125070,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010468a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010468d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104690:	89 50 04             	mov    %edx,0x4(%eax)
c0104693:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104696:	8b 50 04             	mov    0x4(%eax),%edx
c0104699:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010469c:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c010469e:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a1:	c7 40 14 70 50 12 c0 	movl   $0xc0125070,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01046a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046ad:	c9                   	leave  
c01046ae:	c3                   	ret    

c01046af <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01046af:	55                   	push   %ebp
c01046b0:	89 e5                	mov    %esp,%ebp
c01046b2:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01046b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b8:	8b 40 14             	mov    0x14(%eax),%eax
c01046bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01046be:	8b 45 10             	mov    0x10(%ebp),%eax
c01046c1:	83 c0 14             	add    $0x14,%eax
c01046c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    
    assert(entry != NULL && head != NULL);
c01046c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01046cb:	74 06                	je     c01046d3 <_fifo_map_swappable+0x24>
c01046cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046d1:	75 16                	jne    c01046e9 <_fifo_map_swappable+0x3a>
c01046d3:	68 f0 9b 10 c0       	push   $0xc0109bf0
c01046d8:	68 0e 9c 10 c0       	push   $0xc0109c0e
c01046dd:	6a 32                	push   $0x32
c01046df:	68 23 9c 10 c0       	push   $0xc0109c23
c01046e4:	e8 07 bd ff ff       	call   c01003f0 <__panic>
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
c01046e9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01046ed:	75 57                	jne    c0104746 <_fifo_map_swappable+0x97>
        list_entry_t *le_prev = head, *le;
c01046ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le_prev)) != head) {
c01046f5:	eb 38                	jmp    c010472f <_fifo_map_swappable+0x80>
            if (le == entry) {
c01046f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01046fd:	75 2a                	jne    c0104729 <_fifo_map_swappable+0x7a>
c01046ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104702:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104705:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104708:	8b 40 04             	mov    0x4(%eax),%eax
c010470b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010470e:	8b 12                	mov    (%edx),%edx
c0104710:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104713:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104716:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104719:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010471c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010471f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104722:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104725:	89 10                	mov    %edx,(%eax)
                list_del(le);
                break;
c0104727:	eb 1d                	jmp    c0104746 <_fifo_map_swappable+0x97>
            }
            le_prev = le;        
c0104729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010472c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104732:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104735:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104738:	8b 40 04             	mov    0x4(%eax),%eax
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2015010062*/ 
    // not swap in but call this func, means failed to swap out 
    if (swap_in == 0) {
        list_entry_t *le_prev = head, *le;
        while ((le = list_next(le_prev)) != head) {
c010473b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010473e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104741:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104744:	75 b1                	jne    c01046f7 <_fifo_map_swappable+0x48>
c0104746:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104749:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010474c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010474f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104752:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104755:	8b 00                	mov    (%eax),%eax
c0104757:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010475a:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010475d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104760:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104763:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104766:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104769:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010476c:	89 10                	mov    %edx,(%eax)
c010476e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104771:	8b 10                	mov    (%eax),%edx
c0104773:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104776:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104779:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010477c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010477f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104782:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104785:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104788:	89 10                	mov    %edx,(%eax)
            le_prev = le;        
        }
    }
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c010478a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010478f:	c9                   	leave  
c0104790:	c3                   	ret    

c0104791 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0104791:	55                   	push   %ebp
c0104792:	89 e5                	mov    %esp,%ebp
c0104794:	83 ec 28             	sub    $0x28,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0104797:	8b 45 08             	mov    0x8(%ebp),%eax
c010479a:	8b 40 14             	mov    0x14(%eax),%eax
c010479d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != NULL);
c01047a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047a4:	75 16                	jne    c01047bc <_fifo_swap_out_victim+0x2b>
c01047a6:	68 37 9c 10 c0       	push   $0xc0109c37
c01047ab:	68 0e 9c 10 c0       	push   $0xc0109c0e
c01047b0:	6a 4c                	push   $0x4c
c01047b2:	68 23 9c 10 c0       	push   $0xc0109c23
c01047b7:	e8 34 bc ff ff       	call   c01003f0 <__panic>
    assert(in_tick==0);
c01047bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01047c0:	74 16                	je     c01047d8 <_fifo_swap_out_victim+0x47>
c01047c2:	68 44 9c 10 c0       	push   $0xc0109c44
c01047c7:	68 0e 9c 10 c0       	push   $0xc0109c0e
c01047cc:	6a 4d                	push   $0x4d
c01047ce:	68 23 9c 10 c0       	push   $0xc0109c23
c01047d3:	e8 18 bc ff ff       	call   c01003f0 <__panic>
c01047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01047de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047e1:	8b 40 04             	mov    0x4(%eax),%eax
    /* Select the victim */
    /*LAB3 EXERCISE 2: 2015010062*/ 
    //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
    list_entry_t *front = list_next(head);
c01047e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(front != head);
c01047e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047ed:	75 16                	jne    c0104805 <_fifo_swap_out_victim+0x74>
c01047ef:	68 4f 9c 10 c0       	push   $0xc0109c4f
c01047f4:	68 0e 9c 10 c0       	push   $0xc0109c0e
c01047f9:	6a 52                	push   $0x52
c01047fb:	68 23 9c 10 c0       	push   $0xc0109c23
c0104800:	e8 eb bb ff ff       	call   c01003f0 <__panic>
c0104805:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104808:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010480b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010480e:	8b 40 04             	mov    0x4(%eax),%eax
c0104811:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104814:	8b 12                	mov    (%edx),%edx
c0104816:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0104819:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010481c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010481f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104822:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104825:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104828:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010482b:	89 10                	mov    %edx,(%eax)
    list_del(front);
    //(2)  assign the value of *ptr_page to the addr of this page
    struct Page *page = le2page(front, pra_page_link);
c010482d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104830:	83 e8 14             	sub    $0x14,%eax
c0104833:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(page != NULL);
c0104836:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010483a:	75 16                	jne    c0104852 <_fifo_swap_out_victim+0xc1>
c010483c:	68 5d 9c 10 c0       	push   $0xc0109c5d
c0104841:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104846:	6a 56                	push   $0x56
c0104848:	68 23 9c 10 c0       	push   $0xc0109c23
c010484d:	e8 9e bb ff ff       	call   c01003f0 <__panic>
    *ptr_page = page;
c0104852:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104855:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104858:	89 10                	mov    %edx,(%eax)
    return 0;
c010485a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010485f:	c9                   	leave  
c0104860:	c3                   	ret    

c0104861 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0104861:	55                   	push   %ebp
c0104862:	89 e5                	mov    %esp,%ebp
c0104864:	83 ec 08             	sub    $0x8,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104867:	83 ec 0c             	sub    $0xc,%esp
c010486a:	68 6c 9c 10 c0       	push   $0xc0109c6c
c010486f:	e8 16 ba ff ff       	call   c010028a <cprintf>
c0104874:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0104877:	b8 00 30 00 00       	mov    $0x3000,%eax
c010487c:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c010487f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104884:	83 f8 04             	cmp    $0x4,%eax
c0104887:	74 16                	je     c010489f <_fifo_check_swap+0x3e>
c0104889:	68 92 9c 10 c0       	push   $0xc0109c92
c010488e:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104893:	6a 5f                	push   $0x5f
c0104895:	68 23 9c 10 c0       	push   $0xc0109c23
c010489a:	e8 51 bb ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010489f:	83 ec 0c             	sub    $0xc,%esp
c01048a2:	68 a4 9c 10 c0       	push   $0xc0109ca4
c01048a7:	e8 de b9 ff ff       	call   c010028a <cprintf>
c01048ac:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01048af:	b8 00 10 00 00       	mov    $0x1000,%eax
c01048b4:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01048b7:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01048bc:	83 f8 04             	cmp    $0x4,%eax
c01048bf:	74 16                	je     c01048d7 <_fifo_check_swap+0x76>
c01048c1:	68 92 9c 10 c0       	push   $0xc0109c92
c01048c6:	68 0e 9c 10 c0       	push   $0xc0109c0e
c01048cb:	6a 62                	push   $0x62
c01048cd:	68 23 9c 10 c0       	push   $0xc0109c23
c01048d2:	e8 19 bb ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01048d7:	83 ec 0c             	sub    $0xc,%esp
c01048da:	68 cc 9c 10 c0       	push   $0xc0109ccc
c01048df:	e8 a6 b9 ff ff       	call   c010028a <cprintf>
c01048e4:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c01048e7:	b8 00 40 00 00       	mov    $0x4000,%eax
c01048ec:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01048ef:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01048f4:	83 f8 04             	cmp    $0x4,%eax
c01048f7:	74 16                	je     c010490f <_fifo_check_swap+0xae>
c01048f9:	68 92 9c 10 c0       	push   $0xc0109c92
c01048fe:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104903:	6a 65                	push   $0x65
c0104905:	68 23 9c 10 c0       	push   $0xc0109c23
c010490a:	e8 e1 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010490f:	83 ec 0c             	sub    $0xc,%esp
c0104912:	68 f4 9c 10 c0       	push   $0xc0109cf4
c0104917:	e8 6e b9 ff ff       	call   c010028a <cprintf>
c010491c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c010491f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104924:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0104927:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010492c:	83 f8 04             	cmp    $0x4,%eax
c010492f:	74 16                	je     c0104947 <_fifo_check_swap+0xe6>
c0104931:	68 92 9c 10 c0       	push   $0xc0109c92
c0104936:	68 0e 9c 10 c0       	push   $0xc0109c0e
c010493b:	6a 68                	push   $0x68
c010493d:	68 23 9c 10 c0       	push   $0xc0109c23
c0104942:	e8 a9 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104947:	83 ec 0c             	sub    $0xc,%esp
c010494a:	68 1c 9d 10 c0       	push   $0xc0109d1c
c010494f:	e8 36 b9 ff ff       	call   c010028a <cprintf>
c0104954:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104957:	b8 00 50 00 00       	mov    $0x5000,%eax
c010495c:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c010495f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104964:	83 f8 05             	cmp    $0x5,%eax
c0104967:	74 16                	je     c010497f <_fifo_check_swap+0x11e>
c0104969:	68 42 9d 10 c0       	push   $0xc0109d42
c010496e:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104973:	6a 6b                	push   $0x6b
c0104975:	68 23 9c 10 c0       	push   $0xc0109c23
c010497a:	e8 71 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010497f:	83 ec 0c             	sub    $0xc,%esp
c0104982:	68 f4 9c 10 c0       	push   $0xc0109cf4
c0104987:	e8 fe b8 ff ff       	call   c010028a <cprintf>
c010498c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c010498f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104994:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0104997:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010499c:	83 f8 05             	cmp    $0x5,%eax
c010499f:	74 16                	je     c01049b7 <_fifo_check_swap+0x156>
c01049a1:	68 42 9d 10 c0       	push   $0xc0109d42
c01049a6:	68 0e 9c 10 c0       	push   $0xc0109c0e
c01049ab:	6a 6e                	push   $0x6e
c01049ad:	68 23 9c 10 c0       	push   $0xc0109c23
c01049b2:	e8 39 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01049b7:	83 ec 0c             	sub    $0xc,%esp
c01049ba:	68 a4 9c 10 c0       	push   $0xc0109ca4
c01049bf:	e8 c6 b8 ff ff       	call   c010028a <cprintf>
c01049c4:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01049c7:	b8 00 10 00 00       	mov    $0x1000,%eax
c01049cc:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01049cf:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01049d4:	83 f8 06             	cmp    $0x6,%eax
c01049d7:	74 16                	je     c01049ef <_fifo_check_swap+0x18e>
c01049d9:	68 51 9d 10 c0       	push   $0xc0109d51
c01049de:	68 0e 9c 10 c0       	push   $0xc0109c0e
c01049e3:	6a 71                	push   $0x71
c01049e5:	68 23 9c 10 c0       	push   $0xc0109c23
c01049ea:	e8 01 ba ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01049ef:	83 ec 0c             	sub    $0xc,%esp
c01049f2:	68 f4 9c 10 c0       	push   $0xc0109cf4
c01049f7:	e8 8e b8 ff ff       	call   c010028a <cprintf>
c01049fc:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c01049ff:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104a04:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0104a07:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a0c:	83 f8 07             	cmp    $0x7,%eax
c0104a0f:	74 16                	je     c0104a27 <_fifo_check_swap+0x1c6>
c0104a11:	68 60 9d 10 c0       	push   $0xc0109d60
c0104a16:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104a1b:	6a 74                	push   $0x74
c0104a1d:	68 23 9c 10 c0       	push   $0xc0109c23
c0104a22:	e8 c9 b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104a27:	83 ec 0c             	sub    $0xc,%esp
c0104a2a:	68 6c 9c 10 c0       	push   $0xc0109c6c
c0104a2f:	e8 56 b8 ff ff       	call   c010028a <cprintf>
c0104a34:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0104a37:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104a3c:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0104a3f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a44:	83 f8 08             	cmp    $0x8,%eax
c0104a47:	74 16                	je     c0104a5f <_fifo_check_swap+0x1fe>
c0104a49:	68 6f 9d 10 c0       	push   $0xc0109d6f
c0104a4e:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104a53:	6a 77                	push   $0x77
c0104a55:	68 23 9c 10 c0       	push   $0xc0109c23
c0104a5a:	e8 91 b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0104a5f:	83 ec 0c             	sub    $0xc,%esp
c0104a62:	68 cc 9c 10 c0       	push   $0xc0109ccc
c0104a67:	e8 1e b8 ff ff       	call   c010028a <cprintf>
c0104a6c:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0104a6f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104a74:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0104a77:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a7c:	83 f8 09             	cmp    $0x9,%eax
c0104a7f:	74 16                	je     c0104a97 <_fifo_check_swap+0x236>
c0104a81:	68 7e 9d 10 c0       	push   $0xc0109d7e
c0104a86:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104a8b:	6a 7a                	push   $0x7a
c0104a8d:	68 23 9c 10 c0       	push   $0xc0109c23
c0104a92:	e8 59 b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104a97:	83 ec 0c             	sub    $0xc,%esp
c0104a9a:	68 1c 9d 10 c0       	push   $0xc0109d1c
c0104a9f:	e8 e6 b7 ff ff       	call   c010028a <cprintf>
c0104aa4:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104aa7:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104aac:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0104aaf:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104ab4:	83 f8 0a             	cmp    $0xa,%eax
c0104ab7:	74 16                	je     c0104acf <_fifo_check_swap+0x26e>
c0104ab9:	68 8d 9d 10 c0       	push   $0xc0109d8d
c0104abe:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104ac3:	6a 7d                	push   $0x7d
c0104ac5:	68 23 9c 10 c0       	push   $0xc0109c23
c0104aca:	e8 21 b9 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104acf:	83 ec 0c             	sub    $0xc,%esp
c0104ad2:	68 a4 9c 10 c0       	push   $0xc0109ca4
c0104ad7:	e8 ae b7 ff ff       	call   c010028a <cprintf>
c0104adc:	83 c4 10             	add    $0x10,%esp
    assert(*(unsigned char *)0x1000 == 0x0a);
c0104adf:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104ae4:	0f b6 00             	movzbl (%eax),%eax
c0104ae7:	3c 0a                	cmp    $0xa,%al
c0104ae9:	74 16                	je     c0104b01 <_fifo_check_swap+0x2a0>
c0104aeb:	68 a0 9d 10 c0       	push   $0xc0109da0
c0104af0:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104af5:	6a 7f                	push   $0x7f
c0104af7:	68 23 9c 10 c0       	push   $0xc0109c23
c0104afc:	e8 ef b8 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0104b01:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104b06:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0104b09:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b0e:	83 f8 0b             	cmp    $0xb,%eax
c0104b11:	74 19                	je     c0104b2c <_fifo_check_swap+0x2cb>
c0104b13:	68 c1 9d 10 c0       	push   $0xc0109dc1
c0104b18:	68 0e 9c 10 c0       	push   $0xc0109c0e
c0104b1d:	68 81 00 00 00       	push   $0x81
c0104b22:	68 23 9c 10 c0       	push   $0xc0109c23
c0104b27:	e8 c4 b8 ff ff       	call   c01003f0 <__panic>
    return 0;
c0104b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b31:	c9                   	leave  
c0104b32:	c3                   	ret    

c0104b33 <_fifo_init>:


static int
_fifo_init(void)
{
c0104b33:	55                   	push   %ebp
c0104b34:	89 e5                	mov    %esp,%ebp
    return 0;
c0104b36:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b3b:	5d                   	pop    %ebp
c0104b3c:	c3                   	ret    

c0104b3d <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104b3d:	55                   	push   %ebp
c0104b3e:	89 e5                	mov    %esp,%ebp
    return 0;
c0104b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b45:	5d                   	pop    %ebp
c0104b46:	c3                   	ret    

c0104b47 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0104b47:	55                   	push   %ebp
c0104b48:	89 e5                	mov    %esp,%ebp
c0104b4a:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b4f:	5d                   	pop    %ebp
c0104b50:	c3                   	ret    

c0104b51 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b51:	55                   	push   %ebp
c0104b52:	89 e5                	mov    %esp,%ebp
c0104b54:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0104b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b5a:	c1 e8 0c             	shr    $0xc,%eax
c0104b5d:	89 c2                	mov    %eax,%edx
c0104b5f:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0104b64:	39 c2                	cmp    %eax,%edx
c0104b66:	72 14                	jb     c0104b7c <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0104b68:	83 ec 04             	sub    $0x4,%esp
c0104b6b:	68 e4 9d 10 c0       	push   $0xc0109de4
c0104b70:	6a 5b                	push   $0x5b
c0104b72:	68 03 9e 10 c0       	push   $0xc0109e03
c0104b77:	e8 74 b8 ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0104b7c:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0104b81:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b84:	c1 ea 0c             	shr    $0xc,%edx
c0104b87:	c1 e2 05             	shl    $0x5,%edx
c0104b8a:	01 d0                	add    %edx,%eax
}
c0104b8c:	c9                   	leave  
c0104b8d:	c3                   	ret    

c0104b8e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104b8e:	55                   	push   %ebp
c0104b8f:	89 e5                	mov    %esp,%ebp
c0104b91:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0104b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b97:	83 e0 01             	and    $0x1,%eax
c0104b9a:	85 c0                	test   %eax,%eax
c0104b9c:	75 14                	jne    c0104bb2 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0104b9e:	83 ec 04             	sub    $0x4,%esp
c0104ba1:	68 14 9e 10 c0       	push   $0xc0109e14
c0104ba6:	6a 6d                	push   $0x6d
c0104ba8:	68 03 9e 10 c0       	push   $0xc0109e03
c0104bad:	e8 3e b8 ff ff       	call   c01003f0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bb5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bba:	83 ec 0c             	sub    $0xc,%esp
c0104bbd:	50                   	push   %eax
c0104bbe:	e8 8e ff ff ff       	call   c0104b51 <pa2page>
c0104bc3:	83 c4 10             	add    $0x10,%esp
}
c0104bc6:	c9                   	leave  
c0104bc7:	c3                   	ret    

c0104bc8 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0104bc8:	55                   	push   %ebp
c0104bc9:	89 e5                	mov    %esp,%ebp
c0104bcb:	83 ec 18             	sub    $0x18,%esp
    swapfs_init();
c0104bce:	e8 dc 33 00 00       	call   c0107faf <swapfs_init>

    if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0104bd3:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0104bd8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0104bdd:	76 0c                	jbe    c0104beb <swap_init+0x23>
c0104bdf:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0104be4:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0104be9:	76 17                	jbe    c0104c02 <swap_init+0x3a>
    {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0104beb:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0104bf0:	50                   	push   %eax
c0104bf1:	68 35 9e 10 c0       	push   $0xc0109e35
c0104bf6:	6a 26                	push   $0x26
c0104bf8:	68 50 9e 10 c0       	push   $0xc0109e50
c0104bfd:	e8 ee b7 ff ff       	call   c01003f0 <__panic>
    }
     
    // LAB3: set sm as FIFO/ENHANCED CLOCK
    sm = &swap_manager_fifo;
c0104c02:	c7 05 70 4f 12 c0 20 	movl   $0xc0121a20,0xc0124f70
c0104c09:	1a 12 c0 
    // sm = &swap_manager_enclock;
    int r = sm->init();
c0104c0c:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c11:	8b 40 04             	mov    0x4(%eax),%eax
c0104c14:	ff d0                	call   *%eax
c0104c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    if (r == 0)
c0104c19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c1d:	75 27                	jne    c0104c46 <swap_init+0x7e>
    {
        swap_init_ok = 1;
c0104c1f:	c7 05 68 4f 12 c0 01 	movl   $0x1,0xc0124f68
c0104c26:	00 00 00 
        cprintf("SWAP: manager = %s\n", sm->name);
c0104c29:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c2e:	8b 00                	mov    (%eax),%eax
c0104c30:	83 ec 08             	sub    $0x8,%esp
c0104c33:	50                   	push   %eax
c0104c34:	68 5f 9e 10 c0       	push   $0xc0109e5f
c0104c39:	e8 4c b6 ff ff       	call   c010028a <cprintf>
c0104c3e:	83 c4 10             	add    $0x10,%esp
        check_swap();
c0104c41:	e8 f7 03 00 00       	call   c010503d <check_swap>
    }

    return r;
c0104c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104c49:	c9                   	leave  
c0104c4a:	c3                   	ret    

c0104c4b <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0104c4b:	55                   	push   %ebp
c0104c4c:	89 e5                	mov    %esp,%ebp
c0104c4e:	83 ec 08             	sub    $0x8,%esp
    return sm->init_mm(mm);
c0104c51:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c56:	8b 40 08             	mov    0x8(%eax),%eax
c0104c59:	83 ec 0c             	sub    $0xc,%esp
c0104c5c:	ff 75 08             	pushl  0x8(%ebp)
c0104c5f:	ff d0                	call   *%eax
c0104c61:	83 c4 10             	add    $0x10,%esp
}
c0104c64:	c9                   	leave  
c0104c65:	c3                   	ret    

c0104c66 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0104c66:	55                   	push   %ebp
c0104c67:	89 e5                	mov    %esp,%ebp
c0104c69:	83 ec 08             	sub    $0x8,%esp
    return sm->tick_event(mm);
c0104c6c:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c71:	8b 40 0c             	mov    0xc(%eax),%eax
c0104c74:	83 ec 0c             	sub    $0xc,%esp
c0104c77:	ff 75 08             	pushl  0x8(%ebp)
c0104c7a:	ff d0                	call   *%eax
c0104c7c:	83 c4 10             	add    $0x10,%esp
}
c0104c7f:	c9                   	leave  
c0104c80:	c3                   	ret    

c0104c81 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104c81:	55                   	push   %ebp
c0104c82:	89 e5                	mov    %esp,%ebp
c0104c84:	83 ec 08             	sub    $0x8,%esp
    return sm->map_swappable(mm, addr, page, swap_in);
c0104c87:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104c8c:	8b 40 10             	mov    0x10(%eax),%eax
c0104c8f:	ff 75 14             	pushl  0x14(%ebp)
c0104c92:	ff 75 10             	pushl  0x10(%ebp)
c0104c95:	ff 75 0c             	pushl  0xc(%ebp)
c0104c98:	ff 75 08             	pushl  0x8(%ebp)
c0104c9b:	ff d0                	call   *%eax
c0104c9d:	83 c4 10             	add    $0x10,%esp
}
c0104ca0:	c9                   	leave  
c0104ca1:	c3                   	ret    

c0104ca2 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104ca2:	55                   	push   %ebp
c0104ca3:	89 e5                	mov    %esp,%ebp
c0104ca5:	83 ec 08             	sub    $0x8,%esp
    return sm->set_unswappable(mm, addr);
c0104ca8:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104cad:	8b 40 14             	mov    0x14(%eax),%eax
c0104cb0:	83 ec 08             	sub    $0x8,%esp
c0104cb3:	ff 75 0c             	pushl  0xc(%ebp)
c0104cb6:	ff 75 08             	pushl  0x8(%ebp)
c0104cb9:	ff d0                	call   *%eax
c0104cbb:	83 c4 10             	add    $0x10,%esp
}
c0104cbe:	c9                   	leave  
c0104cbf:	c3                   	ret    

c0104cc0 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0104cc0:	55                   	push   %ebp
c0104cc1:	89 e5                	mov    %esp,%ebp
c0104cc3:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i != n; ++ i)
c0104cc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ccd:	e9 2e 01 00 00       	jmp    c0104e00 <swap_out+0x140>
    {
        uintptr_t v;
        //struct Page **ptr_page=NULL;
        struct Page *page;
        // cprintf("i %d, SWAP: call swap_out_victim\n",i);
        int r = sm->swap_out_victim(mm, &page, in_tick);
c0104cd2:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104cd7:	8b 40 18             	mov    0x18(%eax),%eax
c0104cda:	83 ec 04             	sub    $0x4,%esp
c0104cdd:	ff 75 10             	pushl  0x10(%ebp)
c0104ce0:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0104ce3:	52                   	push   %edx
c0104ce4:	ff 75 08             	pushl  0x8(%ebp)
c0104ce7:	ff d0                	call   *%eax
c0104ce9:	83 c4 10             	add    $0x10,%esp
c0104cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (r != 0) {
c0104cef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cf3:	74 18                	je     c0104d0d <swap_out+0x4d>
            cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0104cf5:	83 ec 08             	sub    $0x8,%esp
c0104cf8:	ff 75 f4             	pushl  -0xc(%ebp)
c0104cfb:	68 74 9e 10 c0       	push   $0xc0109e74
c0104d00:	e8 85 b5 ff ff       	call   c010028a <cprintf>
c0104d05:	83 c4 10             	add    $0x10,%esp
c0104d08:	e9 ff 00 00 00       	jmp    c0104e0c <swap_out+0x14c>
        }          
        //assert(!PageReserved(page));

        //cprintf("SWAP: choose victim page 0x%08x\n", page);
        
        v=page->pra_vaddr; 
c0104d0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d10:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
        pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0104d16:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d19:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d1c:	83 ec 04             	sub    $0x4,%esp
c0104d1f:	6a 00                	push   $0x0
c0104d21:	ff 75 ec             	pushl  -0x14(%ebp)
c0104d24:	50                   	push   %eax
c0104d25:	e8 39 22 00 00       	call   c0106f63 <get_pte>
c0104d2a:	83 c4 10             	add    $0x10,%esp
c0104d2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert((*ptep & PTE_P) != 0);
c0104d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d33:	8b 00                	mov    (%eax),%eax
c0104d35:	83 e0 01             	and    $0x1,%eax
c0104d38:	85 c0                	test   %eax,%eax
c0104d3a:	75 16                	jne    c0104d52 <swap_out+0x92>
c0104d3c:	68 a1 9e 10 c0       	push   $0xc0109ea1
c0104d41:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104d46:	6a 67                	push   $0x67
c0104d48:	68 50 9e 10 c0       	push   $0xc0109e50
c0104d4d:	e8 9e b6 ff ff       	call   c01003f0 <__panic>

        if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0104d52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d58:	8b 52 1c             	mov    0x1c(%edx),%edx
c0104d5b:	c1 ea 0c             	shr    $0xc,%edx
c0104d5e:	83 c2 01             	add    $0x1,%edx
c0104d61:	c1 e2 08             	shl    $0x8,%edx
c0104d64:	83 ec 08             	sub    $0x8,%esp
c0104d67:	50                   	push   %eax
c0104d68:	52                   	push   %edx
c0104d69:	e8 dd 32 00 00       	call   c010804b <swapfs_write>
c0104d6e:	83 c4 10             	add    $0x10,%esp
c0104d71:	85 c0                	test   %eax,%eax
c0104d73:	74 2b                	je     c0104da0 <swap_out+0xe0>
            cprintf("SWAP: failed to save\n");
c0104d75:	83 ec 0c             	sub    $0xc,%esp
c0104d78:	68 cb 9e 10 c0       	push   $0xc0109ecb
c0104d7d:	e8 08 b5 ff ff       	call   c010028a <cprintf>
c0104d82:	83 c4 10             	add    $0x10,%esp
            sm->map_swappable(mm, v, page, 0);
c0104d85:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104d8a:	8b 40 10             	mov    0x10(%eax),%eax
c0104d8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d90:	6a 00                	push   $0x0
c0104d92:	52                   	push   %edx
c0104d93:	ff 75 ec             	pushl  -0x14(%ebp)
c0104d96:	ff 75 08             	pushl  0x8(%ebp)
c0104d99:	ff d0                	call   *%eax
c0104d9b:	83 c4 10             	add    $0x10,%esp
c0104d9e:	eb 5c                	jmp    c0104dfc <swap_out+0x13c>
            continue;
        }
        else {
            cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0104da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104da3:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104da6:	c1 e8 0c             	shr    $0xc,%eax
c0104da9:	83 c0 01             	add    $0x1,%eax
c0104dac:	50                   	push   %eax
c0104dad:	ff 75 ec             	pushl  -0x14(%ebp)
c0104db0:	ff 75 f4             	pushl  -0xc(%ebp)
c0104db3:	68 e4 9e 10 c0       	push   $0xc0109ee4
c0104db8:	e8 cd b4 ff ff       	call   c010028a <cprintf>
c0104dbd:	83 c4 10             	add    $0x10,%esp
            *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0104dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dc3:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104dc6:	c1 e8 0c             	shr    $0xc,%eax
c0104dc9:	83 c0 01             	add    $0x1,%eax
c0104dcc:	c1 e0 08             	shl    $0x8,%eax
c0104dcf:	89 c2                	mov    %eax,%edx
c0104dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dd4:	89 10                	mov    %edx,(%eax)
            free_page(page);
c0104dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dd9:	83 ec 08             	sub    $0x8,%esp
c0104ddc:	6a 01                	push   $0x1
c0104dde:	50                   	push   %eax
c0104ddf:	e8 84 1b 00 00       	call   c0106968 <free_pages>
c0104de4:	83 c4 10             	add    $0x10,%esp
        }
        
        tlb_invalidate(mm->pgdir, v);
c0104de7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dea:	8b 40 0c             	mov    0xc(%eax),%eax
c0104ded:	83 ec 08             	sub    $0x8,%esp
c0104df0:	ff 75 ec             	pushl  -0x14(%ebp)
c0104df3:	50                   	push   %eax
c0104df4:	e8 62 24 00 00       	call   c010725b <tlb_invalidate>
c0104df9:	83 c4 10             	add    $0x10,%esp

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
    int i;
    for (i = 0; i != n; ++ i)
c0104dfc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e03:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e06:	0f 85 c6 fe ff ff    	jne    c0104cd2 <swap_out+0x12>
            free_page(page);
        }
        
        tlb_invalidate(mm->pgdir, v);
    }
    return i;
c0104e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104e0f:	c9                   	leave  
c0104e10:	c3                   	ret    

c0104e11 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0104e11:	55                   	push   %ebp
c0104e12:	89 e5                	mov    %esp,%ebp
c0104e14:	83 ec 18             	sub    $0x18,%esp
    struct Page *result = alloc_page();
c0104e17:	83 ec 0c             	sub    $0xc,%esp
c0104e1a:	6a 01                	push   $0x1
c0104e1c:	e8 db 1a 00 00       	call   c01068fc <alloc_pages>
c0104e21:	83 c4 10             	add    $0x10,%esp
c0104e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(result!=NULL);
c0104e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e2b:	75 16                	jne    c0104e43 <swap_in+0x32>
c0104e2d:	68 24 9f 10 c0       	push   $0xc0109f24
c0104e32:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104e37:	6a 7d                	push   $0x7d
c0104e39:	68 50 9e 10 c0       	push   $0xc0109e50
c0104e3e:	e8 ad b5 ff ff       	call   c01003f0 <__panic>

    pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0104e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e46:	8b 40 0c             	mov    0xc(%eax),%eax
c0104e49:	83 ec 04             	sub    $0x4,%esp
c0104e4c:	6a 00                	push   $0x0
c0104e4e:	ff 75 0c             	pushl  0xc(%ebp)
c0104e51:	50                   	push   %eax
c0104e52:	e8 0c 21 00 00       	call   c0106f63 <get_pte>
c0104e57:	83 c4 10             	add    $0x10,%esp
c0104e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));

    int r;
    if ((r = swapfs_read((*ptep), result)) != 0)
c0104e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e60:	8b 00                	mov    (%eax),%eax
c0104e62:	83 ec 08             	sub    $0x8,%esp
c0104e65:	ff 75 f4             	pushl  -0xc(%ebp)
c0104e68:	50                   	push   %eax
c0104e69:	e8 84 31 00 00       	call   c0107ff2 <swapfs_read>
c0104e6e:	83 c4 10             	add    $0x10,%esp
c0104e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e78:	74 1f                	je     c0104e99 <swap_in+0x88>
    {
        assert(r!=0);
c0104e7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e7e:	75 19                	jne    c0104e99 <swap_in+0x88>
c0104e80:	68 31 9f 10 c0       	push   $0xc0109f31
c0104e85:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104e8a:	68 85 00 00 00       	push   $0x85
c0104e8f:	68 50 9e 10 c0       	push   $0xc0109e50
c0104e94:	e8 57 b5 ff ff       	call   c01003f0 <__panic>
    }
    cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0104e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e9c:	8b 00                	mov    (%eax),%eax
c0104e9e:	c1 e8 08             	shr    $0x8,%eax
c0104ea1:	83 ec 04             	sub    $0x4,%esp
c0104ea4:	ff 75 0c             	pushl  0xc(%ebp)
c0104ea7:	50                   	push   %eax
c0104ea8:	68 38 9f 10 c0       	push   $0xc0109f38
c0104ead:	e8 d8 b3 ff ff       	call   c010028a <cprintf>
c0104eb2:	83 c4 10             	add    $0x10,%esp
    *ptr_result=result;
c0104eb5:	8b 45 10             	mov    0x10(%ebp),%eax
c0104eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ebb:	89 10                	mov    %edx,(%eax)
    return 0;
c0104ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ec2:	c9                   	leave  
c0104ec3:	c3                   	ret    

c0104ec4 <check_content_set>:



static inline void
check_content_set(void)
{
c0104ec4:	55                   	push   %ebp
c0104ec5:	89 e5                	mov    %esp,%ebp
c0104ec7:	83 ec 08             	sub    $0x8,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0104eca:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104ecf:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==1);
c0104ed2:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104ed7:	83 f8 01             	cmp    $0x1,%eax
c0104eda:	74 19                	je     c0104ef5 <check_content_set+0x31>
c0104edc:	68 76 9f 10 c0       	push   $0xc0109f76
c0104ee1:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104ee6:	68 92 00 00 00       	push   $0x92
c0104eeb:	68 50 9e 10 c0       	push   $0xc0109e50
c0104ef0:	e8 fb b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x1010 = 0x0a;
c0104ef5:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104efa:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==1);
c0104efd:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104f02:	83 f8 01             	cmp    $0x1,%eax
c0104f05:	74 19                	je     c0104f20 <check_content_set+0x5c>
c0104f07:	68 76 9f 10 c0       	push   $0xc0109f76
c0104f0c:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104f11:	68 94 00 00 00       	push   $0x94
c0104f16:	68 50 9e 10 c0       	push   $0xc0109e50
c0104f1b:	e8 d0 b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x2000 = 0x0b;
c0104f20:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104f25:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==2);
c0104f28:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104f2d:	83 f8 02             	cmp    $0x2,%eax
c0104f30:	74 19                	je     c0104f4b <check_content_set+0x87>
c0104f32:	68 85 9f 10 c0       	push   $0xc0109f85
c0104f37:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104f3c:	68 96 00 00 00       	push   $0x96
c0104f41:	68 50 9e 10 c0       	push   $0xc0109e50
c0104f46:	e8 a5 b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x2010 = 0x0b;
c0104f4b:	b8 10 20 00 00       	mov    $0x2010,%eax
c0104f50:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==2);
c0104f53:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104f58:	83 f8 02             	cmp    $0x2,%eax
c0104f5b:	74 19                	je     c0104f76 <check_content_set+0xb2>
c0104f5d:	68 85 9f 10 c0       	push   $0xc0109f85
c0104f62:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104f67:	68 98 00 00 00       	push   $0x98
c0104f6c:	68 50 9e 10 c0       	push   $0xc0109e50
c0104f71:	e8 7a b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x3000 = 0x0c;
c0104f76:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104f7b:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==3);
c0104f7e:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104f83:	83 f8 03             	cmp    $0x3,%eax
c0104f86:	74 19                	je     c0104fa1 <check_content_set+0xdd>
c0104f88:	68 94 9f 10 c0       	push   $0xc0109f94
c0104f8d:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104f92:	68 9a 00 00 00       	push   $0x9a
c0104f97:	68 50 9e 10 c0       	push   $0xc0109e50
c0104f9c:	e8 4f b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x3010 = 0x0c;
c0104fa1:	b8 10 30 00 00       	mov    $0x3010,%eax
c0104fa6:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==3);
c0104fa9:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104fae:	83 f8 03             	cmp    $0x3,%eax
c0104fb1:	74 19                	je     c0104fcc <check_content_set+0x108>
c0104fb3:	68 94 9f 10 c0       	push   $0xc0109f94
c0104fb8:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104fbd:	68 9c 00 00 00       	push   $0x9c
c0104fc2:	68 50 9e 10 c0       	push   $0xc0109e50
c0104fc7:	e8 24 b4 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x4000 = 0x0d;
c0104fcc:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104fd1:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0104fd4:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104fd9:	83 f8 04             	cmp    $0x4,%eax
c0104fdc:	74 19                	je     c0104ff7 <check_content_set+0x133>
c0104fde:	68 a3 9f 10 c0       	push   $0xc0109fa3
c0104fe3:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0104fe8:	68 9e 00 00 00       	push   $0x9e
c0104fed:	68 50 9e 10 c0       	push   $0xc0109e50
c0104ff2:	e8 f9 b3 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x4010 = 0x0d;
c0104ff7:	b8 10 40 00 00       	mov    $0x4010,%eax
c0104ffc:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0104fff:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105004:	83 f8 04             	cmp    $0x4,%eax
c0105007:	74 19                	je     c0105022 <check_content_set+0x15e>
c0105009:	68 a3 9f 10 c0       	push   $0xc0109fa3
c010500e:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105013:	68 a0 00 00 00       	push   $0xa0
c0105018:	68 50 9e 10 c0       	push   $0xc0109e50
c010501d:	e8 ce b3 ff ff       	call   c01003f0 <__panic>
}
c0105022:	90                   	nop
c0105023:	c9                   	leave  
c0105024:	c3                   	ret    

c0105025 <check_content_access>:

static inline int
check_content_access(void)
{
c0105025:	55                   	push   %ebp
c0105026:	89 e5                	mov    %esp,%ebp
c0105028:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010502b:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0105030:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105033:	ff d0                	call   *%eax
c0105035:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0105038:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010503b:	c9                   	leave  
c010503c:	c3                   	ret    

c010503d <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c010503d:	55                   	push   %ebp
c010503e:	89 e5                	mov    %esp,%ebp
c0105040:	83 ec 68             	sub    $0x68,%esp
    //backup mem env
    int ret, count = 0, total = 0, i;
c0105043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010504a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105051:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105058:	eb 60                	jmp    c01050ba <check_swap+0x7d>
    struct Page *p = le2page(le, page_link);
c010505a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010505d:	83 e8 0c             	sub    $0xc,%eax
c0105060:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(PageProperty(p));
c0105063:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105066:	83 c0 04             	add    $0x4,%eax
c0105069:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105070:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105073:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105076:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105079:	0f a3 10             	bt     %edx,(%eax)
c010507c:	19 c0                	sbb    %eax,%eax
c010507e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0105081:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0105085:	0f 95 c0             	setne  %al
c0105088:	0f b6 c0             	movzbl %al,%eax
c010508b:	85 c0                	test   %eax,%eax
c010508d:	75 19                	jne    c01050a8 <check_swap+0x6b>
c010508f:	68 b2 9f 10 c0       	push   $0xc0109fb2
c0105094:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105099:	68 bb 00 00 00       	push   $0xbb
c010509e:	68 50 9e 10 c0       	push   $0xc0109e50
c01050a3:	e8 48 b3 ff ff       	call   c01003f0 <__panic>
    count ++, total += p->property;
c01050a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01050ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050af:	8b 50 08             	mov    0x8(%eax),%edx
c01050b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050b5:	01 d0                	add    %edx,%eax
c01050b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01050c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050c3:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
    int ret, count = 0, total = 0, i;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01050c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050c9:	81 7d e8 44 51 12 c0 	cmpl   $0xc0125144,-0x18(%ebp)
c01050d0:	75 88                	jne    c010505a <check_swap+0x1d>
    struct Page *p = le2page(le, page_link);
    assert(PageProperty(p));
    count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01050d2:	e8 c6 18 00 00       	call   c010699d <nr_free_pages>
c01050d7:	89 c2                	mov    %eax,%edx
c01050d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050dc:	39 c2                	cmp    %eax,%edx
c01050de:	74 19                	je     c01050f9 <check_swap+0xbc>
c01050e0:	68 c2 9f 10 c0       	push   $0xc0109fc2
c01050e5:	68 b6 9e 10 c0       	push   $0xc0109eb6
c01050ea:	68 be 00 00 00       	push   $0xbe
c01050ef:	68 50 9e 10 c0       	push   $0xc0109e50
c01050f4:	e8 f7 b2 ff ff       	call   c01003f0 <__panic>
    cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c01050f9:	83 ec 04             	sub    $0x4,%esp
c01050fc:	ff 75 f0             	pushl  -0x10(%ebp)
c01050ff:	ff 75 f4             	pushl  -0xc(%ebp)
c0105102:	68 dc 9f 10 c0       	push   $0xc0109fdc
c0105107:	e8 7e b1 ff ff       	call   c010028a <cprintf>
c010510c:	83 c4 10             	add    $0x10,%esp
    
    //now we set the phy pages env     
    struct mm_struct *mm = mm_create();
c010510f:	e8 58 e9 ff ff       	call   c0103a6c <mm_create>
c0105114:	89 45 d8             	mov    %eax,-0x28(%ebp)
    assert(mm != NULL);
c0105117:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010511b:	75 19                	jne    c0105136 <check_swap+0xf9>
c010511d:	68 02 a0 10 c0       	push   $0xc010a002
c0105122:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105127:	68 c3 00 00 00       	push   $0xc3
c010512c:	68 50 9e 10 c0       	push   $0xc0109e50
c0105131:	e8 ba b2 ff ff       	call   c01003f0 <__panic>

    extern struct mm_struct *check_mm_struct;
    assert(check_mm_struct == NULL);
c0105136:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c010513b:	85 c0                	test   %eax,%eax
c010513d:	74 19                	je     c0105158 <check_swap+0x11b>
c010513f:	68 0d a0 10 c0       	push   $0xc010a00d
c0105144:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105149:	68 c6 00 00 00       	push   $0xc6
c010514e:	68 50 9e 10 c0       	push   $0xc0109e50
c0105153:	e8 98 b2 ff ff       	call   c01003f0 <__panic>

    check_mm_struct = mm;
c0105158:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010515b:	a3 7c 50 12 c0       	mov    %eax,0xc012507c

    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0105160:	8b 15 40 1a 12 c0    	mov    0xc0121a40,%edx
c0105166:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105169:	89 50 0c             	mov    %edx,0xc(%eax)
c010516c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010516f:	8b 40 0c             	mov    0xc(%eax),%eax
c0105172:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    assert(pgdir[0] == 0);
c0105175:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105178:	8b 00                	mov    (%eax),%eax
c010517a:	85 c0                	test   %eax,%eax
c010517c:	74 19                	je     c0105197 <check_swap+0x15a>
c010517e:	68 25 a0 10 c0       	push   $0xc010a025
c0105183:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105188:	68 cb 00 00 00       	push   $0xcb
c010518d:	68 50 9e 10 c0       	push   $0xc0109e50
c0105192:	e8 59 b2 ff ff       	call   c01003f0 <__panic>

    struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0105197:	83 ec 04             	sub    $0x4,%esp
c010519a:	6a 03                	push   $0x3
c010519c:	68 00 60 00 00       	push   $0x6000
c01051a1:	68 00 10 00 00       	push   $0x1000
c01051a6:	e8 3d e9 ff ff       	call   c0103ae8 <vma_create>
c01051ab:	83 c4 10             	add    $0x10,%esp
c01051ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
    assert(vma != NULL);
c01051b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01051b5:	75 19                	jne    c01051d0 <check_swap+0x193>
c01051b7:	68 33 a0 10 c0       	push   $0xc010a033
c01051bc:	68 b6 9e 10 c0       	push   $0xc0109eb6
c01051c1:	68 ce 00 00 00       	push   $0xce
c01051c6:	68 50 9e 10 c0       	push   $0xc0109e50
c01051cb:	e8 20 b2 ff ff       	call   c01003f0 <__panic>

    insert_vma_struct(mm, vma);
c01051d0:	83 ec 08             	sub    $0x8,%esp
c01051d3:	ff 75 d0             	pushl  -0x30(%ebp)
c01051d6:	ff 75 d8             	pushl  -0x28(%ebp)
c01051d9:	e8 72 ea ff ff       	call   c0103c50 <insert_vma_struct>
c01051de:	83 c4 10             	add    $0x10,%esp

    //setup the temp Page Table vaddr 0~4MB
    cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01051e1:	83 ec 0c             	sub    $0xc,%esp
c01051e4:	68 40 a0 10 c0       	push   $0xc010a040
c01051e9:	e8 9c b0 ff ff       	call   c010028a <cprintf>
c01051ee:	83 c4 10             	add    $0x10,%esp
    pte_t *temp_ptep=NULL;
c01051f1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
    temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01051f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01051fb:	8b 40 0c             	mov    0xc(%eax),%eax
c01051fe:	83 ec 04             	sub    $0x4,%esp
c0105201:	6a 01                	push   $0x1
c0105203:	68 00 10 00 00       	push   $0x1000
c0105208:	50                   	push   %eax
c0105209:	e8 55 1d 00 00       	call   c0106f63 <get_pte>
c010520e:	83 c4 10             	add    $0x10,%esp
c0105211:	89 45 cc             	mov    %eax,-0x34(%ebp)
    assert(temp_ptep!= NULL);
c0105214:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105218:	75 19                	jne    c0105233 <check_swap+0x1f6>
c010521a:	68 74 a0 10 c0       	push   $0xc010a074
c010521f:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105224:	68 d6 00 00 00       	push   $0xd6
c0105229:	68 50 9e 10 c0       	push   $0xc0109e50
c010522e:	e8 bd b1 ff ff       	call   c01003f0 <__panic>
    cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0105233:	83 ec 0c             	sub    $0xc,%esp
c0105236:	68 88 a0 10 c0       	push   $0xc010a088
c010523b:	e8 4a b0 ff ff       	call   c010028a <cprintf>
c0105240:	83 c4 10             	add    $0x10,%esp
    
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105243:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010524a:	e9 90 00 00 00       	jmp    c01052df <check_swap+0x2a2>
        check_rp[i] = alloc_page();
c010524f:	83 ec 0c             	sub    $0xc,%esp
c0105252:	6a 01                	push   $0x1
c0105254:	e8 a3 16 00 00       	call   c01068fc <alloc_pages>
c0105259:	83 c4 10             	add    $0x10,%esp
c010525c:	89 c2                	mov    %eax,%edx
c010525e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105261:	89 14 85 80 50 12 c0 	mov    %edx,-0x3fedaf80(,%eax,4)
        assert(check_rp[i] != NULL );
c0105268:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010526b:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c0105272:	85 c0                	test   %eax,%eax
c0105274:	75 19                	jne    c010528f <check_swap+0x252>
c0105276:	68 ac a0 10 c0       	push   $0xc010a0ac
c010527b:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105280:	68 db 00 00 00       	push   $0xdb
c0105285:	68 50 9e 10 c0       	push   $0xc0109e50
c010528a:	e8 61 b1 ff ff       	call   c01003f0 <__panic>
        assert(!PageProperty(check_rp[i]));
c010528f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105292:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c0105299:	83 c0 04             	add    $0x4,%eax
c010529c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01052a3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052a6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01052a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052ac:	0f a3 10             	bt     %edx,(%eax)
c01052af:	19 c0                	sbb    %eax,%eax
c01052b1:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c01052b4:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c01052b8:	0f 95 c0             	setne  %al
c01052bb:	0f b6 c0             	movzbl %al,%eax
c01052be:	85 c0                	test   %eax,%eax
c01052c0:	74 19                	je     c01052db <check_swap+0x29e>
c01052c2:	68 c0 a0 10 c0       	push   $0xc010a0c0
c01052c7:	68 b6 9e 10 c0       	push   $0xc0109eb6
c01052cc:	68 dc 00 00 00       	push   $0xdc
c01052d1:	68 50 9e 10 c0       	push   $0xc0109e50
c01052d6:	e8 15 b1 ff ff       	call   c01003f0 <__panic>
    pte_t *temp_ptep=NULL;
    temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
    assert(temp_ptep!= NULL);
    cprintf("setup Page Table vaddr 0~4MB OVER!\n");
    
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01052db:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01052df:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01052e3:	0f 8e 66 ff ff ff    	jle    c010524f <check_swap+0x212>
        check_rp[i] = alloc_page();
        assert(check_rp[i] != NULL );
        assert(!PageProperty(check_rp[i]));
    }
    list_entry_t free_list_store = free_list;
c01052e9:	a1 44 51 12 c0       	mov    0xc0125144,%eax
c01052ee:	8b 15 48 51 12 c0    	mov    0xc0125148,%edx
c01052f4:	89 45 98             	mov    %eax,-0x68(%ebp)
c01052f7:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01052fa:	c7 45 c0 44 51 12 c0 	movl   $0xc0125144,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105301:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105304:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105307:	89 50 04             	mov    %edx,0x4(%eax)
c010530a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010530d:	8b 50 04             	mov    0x4(%eax),%edx
c0105310:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105313:	89 10                	mov    %edx,(%eax)
c0105315:	c7 45 c8 44 51 12 c0 	movl   $0xc0125144,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010531c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010531f:	8b 40 04             	mov    0x4(%eax),%eax
c0105322:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c0105325:	0f 94 c0             	sete   %al
c0105328:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010532b:	85 c0                	test   %eax,%eax
c010532d:	75 19                	jne    c0105348 <check_swap+0x30b>
c010532f:	68 db a0 10 c0       	push   $0xc010a0db
c0105334:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105339:	68 e0 00 00 00       	push   $0xe0
c010533e:	68 50 9e 10 c0       	push   $0xc0109e50
c0105343:	e8 a8 b0 ff ff       	call   c01003f0 <__panic>
    
    //assert(alloc_page() == NULL);
    
    unsigned int nr_free_store = nr_free;
c0105348:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c010534d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    nr_free = 0;
c0105350:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c0105357:	00 00 00 
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010535a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105361:	eb 1c                	jmp    c010537f <check_swap+0x342>
    free_pages(check_rp[i],1);
c0105363:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105366:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c010536d:	83 ec 08             	sub    $0x8,%esp
c0105370:	6a 01                	push   $0x1
c0105372:	50                   	push   %eax
c0105373:	e8 f0 15 00 00       	call   c0106968 <free_pages>
c0105378:	83 c4 10             	add    $0x10,%esp
    
    //assert(alloc_page() == NULL);
    
    unsigned int nr_free_store = nr_free;
    nr_free = 0;
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010537b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010537f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105383:	7e de                	jle    c0105363 <check_swap+0x326>
    free_pages(check_rp[i],1);
    }
    assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0105385:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c010538a:	83 f8 04             	cmp    $0x4,%eax
c010538d:	74 19                	je     c01053a8 <check_swap+0x36b>
c010538f:	68 f4 a0 10 c0       	push   $0xc010a0f4
c0105394:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105399:	68 e9 00 00 00       	push   $0xe9
c010539e:	68 50 9e 10 c0       	push   $0xc0109e50
c01053a3:	e8 48 b0 ff ff       	call   c01003f0 <__panic>
    
    cprintf("set up init env for check_swap begin!\n");
c01053a8:	83 ec 0c             	sub    $0xc,%esp
c01053ab:	68 18 a1 10 c0       	push   $0xc010a118
c01053b0:	e8 d5 ae ff ff       	call   c010028a <cprintf>
c01053b5:	83 c4 10             	add    $0x10,%esp
    //setup initial vir_page<->phy_page environment for page relpacement algorithm 

    
    pgfault_num=0;
c01053b8:	c7 05 64 4f 12 c0 00 	movl   $0x0,0xc0124f64
c01053bf:	00 00 00 
    
    check_content_set();
c01053c2:	e8 fd fa ff ff       	call   c0104ec4 <check_content_set>
    assert( nr_free == 0);         
c01053c7:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c01053cc:	85 c0                	test   %eax,%eax
c01053ce:	74 19                	je     c01053e9 <check_swap+0x3ac>
c01053d0:	68 3f a1 10 c0       	push   $0xc010a13f
c01053d5:	68 b6 9e 10 c0       	push   $0xc0109eb6
c01053da:	68 f2 00 00 00       	push   $0xf2
c01053df:	68 50 9e 10 c0       	push   $0xc0109e50
c01053e4:	e8 07 b0 ff ff       	call   c01003f0 <__panic>
    for(i = 0; i<MAX_SEQ_NO ; i++) 
c01053e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01053f0:	eb 26                	jmp    c0105418 <check_swap+0x3db>
        swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01053f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053f5:	c7 04 85 a0 50 12 c0 	movl   $0xffffffff,-0x3fedaf60(,%eax,4)
c01053fc:	ff ff ff ff 
c0105400:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105403:	8b 14 85 a0 50 12 c0 	mov    -0x3fedaf60(,%eax,4),%edx
c010540a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010540d:	89 14 85 e0 50 12 c0 	mov    %edx,-0x3fedaf20(,%eax,4)
    
    pgfault_num=0;
    
    check_content_set();
    assert( nr_free == 0);         
    for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105414:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105418:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c010541c:	7e d4                	jle    c01053f2 <check_swap+0x3b5>
        swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
    
    for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010541e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105425:	e9 cc 00 00 00       	jmp    c01054f6 <check_swap+0x4b9>
        check_ptep[i]=0;
c010542a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010542d:	c7 04 85 34 51 12 c0 	movl   $0x0,-0x3fedaecc(,%eax,4)
c0105434:	00 00 00 00 
        check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0105438:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010543b:	83 c0 01             	add    $0x1,%eax
c010543e:	c1 e0 0c             	shl    $0xc,%eax
c0105441:	83 ec 04             	sub    $0x4,%esp
c0105444:	6a 00                	push   $0x0
c0105446:	50                   	push   %eax
c0105447:	ff 75 d4             	pushl  -0x2c(%ebp)
c010544a:	e8 14 1b 00 00       	call   c0106f63 <get_pte>
c010544f:	83 c4 10             	add    $0x10,%esp
c0105452:	89 c2                	mov    %eax,%edx
c0105454:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105457:	89 14 85 34 51 12 c0 	mov    %edx,-0x3fedaecc(,%eax,4)
        //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
        assert(check_ptep[i] != NULL);
c010545e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105461:	8b 04 85 34 51 12 c0 	mov    -0x3fedaecc(,%eax,4),%eax
c0105468:	85 c0                	test   %eax,%eax
c010546a:	75 19                	jne    c0105485 <check_swap+0x448>
c010546c:	68 4c a1 10 c0       	push   $0xc010a14c
c0105471:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105476:	68 fa 00 00 00       	push   $0xfa
c010547b:	68 50 9e 10 c0       	push   $0xc0109e50
c0105480:	e8 6b af ff ff       	call   c01003f0 <__panic>
        assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0105485:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105488:	8b 04 85 34 51 12 c0 	mov    -0x3fedaecc(,%eax,4),%eax
c010548f:	8b 00                	mov    (%eax),%eax
c0105491:	83 ec 0c             	sub    $0xc,%esp
c0105494:	50                   	push   %eax
c0105495:	e8 f4 f6 ff ff       	call   c0104b8e <pte2page>
c010549a:	83 c4 10             	add    $0x10,%esp
c010549d:	89 c2                	mov    %eax,%edx
c010549f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054a2:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c01054a9:	39 c2                	cmp    %eax,%edx
c01054ab:	74 19                	je     c01054c6 <check_swap+0x489>
c01054ad:	68 64 a1 10 c0       	push   $0xc010a164
c01054b2:	68 b6 9e 10 c0       	push   $0xc0109eb6
c01054b7:	68 fb 00 00 00       	push   $0xfb
c01054bc:	68 50 9e 10 c0       	push   $0xc0109e50
c01054c1:	e8 2a af ff ff       	call   c01003f0 <__panic>
        assert((*check_ptep[i] & PTE_P));          
c01054c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054c9:	8b 04 85 34 51 12 c0 	mov    -0x3fedaecc(,%eax,4),%eax
c01054d0:	8b 00                	mov    (%eax),%eax
c01054d2:	83 e0 01             	and    $0x1,%eax
c01054d5:	85 c0                	test   %eax,%eax
c01054d7:	75 19                	jne    c01054f2 <check_swap+0x4b5>
c01054d9:	68 8c a1 10 c0       	push   $0xc010a18c
c01054de:	68 b6 9e 10 c0       	push   $0xc0109eb6
c01054e3:	68 fc 00 00 00       	push   $0xfc
c01054e8:	68 50 9e 10 c0       	push   $0xc0109e50
c01054ed:	e8 fe ae ff ff       	call   c01003f0 <__panic>
    check_content_set();
    assert( nr_free == 0);         
    for(i = 0; i<MAX_SEQ_NO ; i++) 
        swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
    
    for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01054f2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01054f6:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01054fa:	0f 8e 2a ff ff ff    	jle    c010542a <check_swap+0x3ed>
        //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
        assert(check_ptep[i] != NULL);
        assert(pte2page(*check_ptep[i]) == check_rp[i]);
        assert((*check_ptep[i] & PTE_P));          
    }
    cprintf("set up init env for check_swap over!\n");
c0105500:	83 ec 0c             	sub    $0xc,%esp
c0105503:	68 a8 a1 10 c0       	push   $0xc010a1a8
c0105508:	e8 7d ad ff ff       	call   c010028a <cprintf>
c010550d:	83 c4 10             	add    $0x10,%esp
    // now access the virt pages to test  page relpacement algorithm 
    ret=check_content_access();
c0105510:	e8 10 fb ff ff       	call   c0105025 <check_content_access>
c0105515:	89 45 b8             	mov    %eax,-0x48(%ebp)
    assert(ret==0);
c0105518:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010551c:	74 19                	je     c0105537 <check_swap+0x4fa>
c010551e:	68 ce a1 10 c0       	push   $0xc010a1ce
c0105523:	68 b6 9e 10 c0       	push   $0xc0109eb6
c0105528:	68 01 01 00 00       	push   $0x101
c010552d:	68 50 9e 10 c0       	push   $0xc0109e50
c0105532:	e8 b9 ae ff ff       	call   c01003f0 <__panic>
    
    //restore kernel mem env
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105537:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010553e:	eb 1c                	jmp    c010555c <check_swap+0x51f>
        free_pages(check_rp[i],1);
c0105540:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105543:	8b 04 85 80 50 12 c0 	mov    -0x3fedaf80(,%eax,4),%eax
c010554a:	83 ec 08             	sub    $0x8,%esp
c010554d:	6a 01                	push   $0x1
c010554f:	50                   	push   %eax
c0105550:	e8 13 14 00 00       	call   c0106968 <free_pages>
c0105555:	83 c4 10             	add    $0x10,%esp
    // now access the virt pages to test  page relpacement algorithm 
    ret=check_content_access();
    assert(ret==0);
    
    //restore kernel mem env
    for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105558:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010555c:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0105560:	7e de                	jle    c0105540 <check_swap+0x503>
        free_pages(check_rp[i],1);
    } 

    //free_page(pte2page(*temp_ptep));
    
    mm_destroy(mm);
c0105562:	83 ec 0c             	sub    $0xc,%esp
c0105565:	ff 75 d8             	pushl  -0x28(%ebp)
c0105568:	e8 07 e8 ff ff       	call   c0103d74 <mm_destroy>
c010556d:	83 c4 10             	add    $0x10,%esp
        
    nr_free = nr_free_store;
c0105570:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105573:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
    free_list = free_list_store;
c0105578:	8b 45 98             	mov    -0x68(%ebp),%eax
c010557b:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010557e:	a3 44 51 12 c0       	mov    %eax,0xc0125144
c0105583:	89 15 48 51 12 c0    	mov    %edx,0xc0125148

    
    le = &free_list;
c0105589:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105590:	eb 1d                	jmp    c01055af <check_swap+0x572>
        struct Page *p = le2page(le, page_link);
c0105592:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105595:	83 e8 0c             	sub    $0xc,%eax
c0105598:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c010559b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010559f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01055a2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01055a5:	8b 40 08             	mov    0x8(%eax),%eax
c01055a8:	29 c2                	sub    %eax,%edx
c01055aa:	89 d0                	mov    %edx,%eax
c01055ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01055b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01055b8:	8b 40 04             	mov    0x4(%eax),%eax
    nr_free = nr_free_store;
    free_list = free_list_store;

    
    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01055bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055be:	81 7d e8 44 51 12 c0 	cmpl   $0xc0125144,-0x18(%ebp)
c01055c5:	75 cb                	jne    c0105592 <check_swap+0x555>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    cprintf("count is %d, total is %d\n",count,total);
c01055c7:	83 ec 04             	sub    $0x4,%esp
c01055ca:	ff 75 f0             	pushl  -0x10(%ebp)
c01055cd:	ff 75 f4             	pushl  -0xc(%ebp)
c01055d0:	68 d5 a1 10 c0       	push   $0xc010a1d5
c01055d5:	e8 b0 ac ff ff       	call   c010028a <cprintf>
c01055da:	83 c4 10             	add    $0x10,%esp
    //assert(count == 0);
    
    cprintf("check_swap() succeeded!\n");
c01055dd:	83 ec 0c             	sub    $0xc,%esp
c01055e0:	68 ef a1 10 c0       	push   $0xc010a1ef
c01055e5:	e8 a0 ac ff ff       	call   c010028a <cprintf>
c01055ea:	83 c4 10             	add    $0x10,%esp
}
c01055ed:	90                   	nop
c01055ee:	c9                   	leave  
c01055ef:	c3                   	ret    

c01055f0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01055f0:	55                   	push   %ebp
c01055f1:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01055f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f6:	8b 15 58 51 12 c0    	mov    0xc0125158,%edx
c01055fc:	29 d0                	sub    %edx,%eax
c01055fe:	c1 f8 05             	sar    $0x5,%eax
}
c0105601:	5d                   	pop    %ebp
c0105602:	c3                   	ret    

c0105603 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0105603:	55                   	push   %ebp
c0105604:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0105606:	ff 75 08             	pushl  0x8(%ebp)
c0105609:	e8 e2 ff ff ff       	call   c01055f0 <page2ppn>
c010560e:	83 c4 04             	add    $0x4,%esp
c0105611:	c1 e0 0c             	shl    $0xc,%eax
}
c0105614:	c9                   	leave  
c0105615:	c3                   	ret    

c0105616 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0105616:	55                   	push   %ebp
c0105617:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105619:	8b 45 08             	mov    0x8(%ebp),%eax
c010561c:	8b 00                	mov    (%eax),%eax
}
c010561e:	5d                   	pop    %ebp
c010561f:	c3                   	ret    

c0105620 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0105620:	55                   	push   %ebp
c0105621:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105623:	8b 45 08             	mov    0x8(%ebp),%eax
c0105626:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105629:	89 10                	mov    %edx,(%eax)
}
c010562b:	90                   	nop
c010562c:	5d                   	pop    %ebp
c010562d:	c3                   	ret    

c010562e <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010562e:	55                   	push   %ebp
c010562f:	89 e5                	mov    %esp,%ebp
c0105631:	83 ec 10             	sub    $0x10,%esp
c0105634:	c7 45 fc 44 51 12 c0 	movl   $0xc0125144,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010563b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010563e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0105641:	89 50 04             	mov    %edx,0x4(%eax)
c0105644:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105647:	8b 50 04             	mov    0x4(%eax),%edx
c010564a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010564d:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010564f:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c0105656:	00 00 00 
}
c0105659:	90                   	nop
c010565a:	c9                   	leave  
c010565b:	c3                   	ret    

c010565c <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010565c:	55                   	push   %ebp
c010565d:	89 e5                	mov    %esp,%ebp
c010565f:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0105662:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105666:	75 16                	jne    c010567e <default_init_memmap+0x22>
c0105668:	68 08 a2 10 c0       	push   $0xc010a208
c010566d:	68 0e a2 10 c0       	push   $0xc010a20e
c0105672:	6a 6d                	push   $0x6d
c0105674:	68 23 a2 10 c0       	push   $0xc010a223
c0105679:	e8 72 ad ff ff       	call   c01003f0 <__panic>
    struct Page *p = base;
c010567e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105681:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105684:	eb 6c                	jmp    c01056f2 <default_init_memmap+0x96>
        assert(PageReserved(p));
c0105686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105689:	83 c0 04             	add    $0x4,%eax
c010568c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0105693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105699:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010569c:	0f a3 10             	bt     %edx,(%eax)
c010569f:	19 c0                	sbb    %eax,%eax
c01056a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c01056a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01056a8:	0f 95 c0             	setne  %al
c01056ab:	0f b6 c0             	movzbl %al,%eax
c01056ae:	85 c0                	test   %eax,%eax
c01056b0:	75 16                	jne    c01056c8 <default_init_memmap+0x6c>
c01056b2:	68 39 a2 10 c0       	push   $0xc010a239
c01056b7:	68 0e a2 10 c0       	push   $0xc010a20e
c01056bc:	6a 70                	push   $0x70
c01056be:	68 23 a2 10 c0       	push   $0xc010a223
c01056c3:	e8 28 ad ff ff       	call   c01003f0 <__panic>
        p->flags = p->property = 0;
c01056c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01056d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056d5:	8b 50 08             	mov    0x8(%eax),%edx
c01056d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056db:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01056de:	83 ec 08             	sub    $0x8,%esp
c01056e1:	6a 00                	push   $0x0
c01056e3:	ff 75 f4             	pushl  -0xc(%ebp)
c01056e6:	e8 35 ff ff ff       	call   c0105620 <set_page_ref>
c01056eb:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01056ee:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01056f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056f5:	c1 e0 05             	shl    $0x5,%eax
c01056f8:	89 c2                	mov    %eax,%edx
c01056fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fd:	01 d0                	add    %edx,%eax
c01056ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105702:	75 82                	jne    c0105686 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0105704:	8b 45 08             	mov    0x8(%ebp),%eax
c0105707:	8b 55 0c             	mov    0xc(%ebp),%edx
c010570a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010570d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105710:	83 c0 04             	add    $0x4,%eax
c0105713:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c010571a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010571d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105720:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105723:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105726:	8b 15 4c 51 12 c0    	mov    0xc012514c,%edx
c010572c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010572f:	01 d0                	add    %edx,%eax
c0105731:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
    list_add(&free_list, &(base->page_link));
c0105736:	8b 45 08             	mov    0x8(%ebp),%eax
c0105739:	83 c0 0c             	add    $0xc,%eax
c010573c:	c7 45 f0 44 51 12 c0 	movl   $0xc0125144,-0x10(%ebp)
c0105743:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105746:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105749:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010574c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010574f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0105752:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105755:	8b 40 04             	mov    0x4(%eax),%eax
c0105758:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010575b:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010575e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105761:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105764:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105767:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010576a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010576d:	89 10                	mov    %edx,(%eax)
c010576f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105772:	8b 10                	mov    (%eax),%edx
c0105774:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105777:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010577a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010577d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105780:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105783:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105786:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105789:	89 10                	mov    %edx,(%eax)
}
c010578b:	90                   	nop
c010578c:	c9                   	leave  
c010578d:	c3                   	ret    

c010578e <default_alloc_pages>:

// LAB2 MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
c010578e:	55                   	push   %ebp
c010578f:	89 e5                	mov    %esp,%ebp
c0105791:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0105794:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105798:	75 16                	jne    c01057b0 <default_alloc_pages+0x22>
c010579a:	68 08 a2 10 c0       	push   $0xc010a208
c010579f:	68 0e a2 10 c0       	push   $0xc010a20e
c01057a4:	6a 7d                	push   $0x7d
c01057a6:	68 23 a2 10 c0       	push   $0xc010a223
c01057ab:	e8 40 ac ff ff       	call   c01003f0 <__panic>
    if (n > nr_free) {
c01057b0:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c01057b5:	3b 45 08             	cmp    0x8(%ebp),%eax
c01057b8:	73 0a                	jae    c01057c4 <default_alloc_pages+0x36>
        return NULL;
c01057ba:	b8 00 00 00 00       	mov    $0x0,%eax
c01057bf:	e9 41 01 00 00       	jmp    c0105905 <default_alloc_pages+0x177>
    }
    struct Page *page = NULL;
c01057c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01057cb:	c7 45 f0 44 51 12 c0 	movl   $0xc0125144,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01057d2:	eb 1c                	jmp    c01057f0 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c01057d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057d7:	83 e8 0c             	sub    $0xc,%eax
c01057da:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c01057dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057e0:	8b 40 08             	mov    0x8(%eax),%eax
c01057e3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01057e6:	72 08                	jb     c01057f0 <default_alloc_pages+0x62>
            page = p;
c01057e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01057ee:	eb 18                	jmp    c0105808 <default_alloc_pages+0x7a>
c01057f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01057f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01057f9:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01057fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057ff:	81 7d f0 44 51 12 c0 	cmpl   $0xc0125144,-0x10(%ebp)
c0105806:	75 cc                	jne    c01057d4 <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0105808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010580c:	0f 84 f0 00 00 00    	je     c0105902 <default_alloc_pages+0x174>
c0105812:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105815:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105818:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010581b:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
c010581e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
c0105821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105824:	83 c0 0c             	add    $0xc,%eax
c0105827:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010582a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010582d:	8b 40 04             	mov    0x4(%eax),%eax
c0105830:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105833:	8b 12                	mov    (%edx),%edx
c0105835:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105838:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010583b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010583e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105841:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105844:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105847:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010584a:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c010584c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010584f:	8b 40 08             	mov    0x8(%eax),%eax
c0105852:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105855:	0f 86 81 00 00 00    	jbe    c01058dc <default_alloc_pages+0x14e>
            struct Page *p = page + n;                      // split the allocated page
c010585b:	8b 45 08             	mov    0x8(%ebp),%eax
c010585e:	c1 e0 05             	shl    $0x5,%eax
c0105861:	89 c2                	mov    %eax,%edx
c0105863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105866:	01 d0                	add    %edx,%eax
c0105868:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
c010586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010586e:	8b 40 08             	mov    0x8(%eax),%eax
c0105871:	2b 45 08             	sub    0x8(%ebp),%eax
c0105874:	89 c2                	mov    %eax,%edx
c0105876:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105879:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
c010587c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010587f:	83 c0 04             	add    $0x4,%eax
c0105882:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105889:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010588c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010588f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105892:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
c0105895:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105898:	8d 50 0c             	lea    0xc(%eax),%edx
c010589b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010589e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058a1:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01058a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058a7:	8b 00                	mov    (%eax),%eax
c01058a9:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01058ac:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01058af:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01058b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058b5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01058b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01058bb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01058be:	89 10                	mov    %edx,(%eax)
c01058c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01058c3:	8b 10                	mov    (%eax),%edx
c01058c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01058c8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01058cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01058ce:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01058d1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01058d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01058d7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01058da:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c01058dc:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c01058e1:	2b 45 08             	sub    0x8(%ebp),%eax
c01058e4:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
        ClearPageProperty(page);    // mark as "not head page"
c01058e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ec:	83 c0 04             	add    $0x4,%eax
c01058ef:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01058f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01058f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01058fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058ff:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0105902:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105905:	c9                   	leave  
c0105906:	c3                   	ret    

c0105907 <default_free_pages>:

// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
c0105907:	55                   	push   %ebp
c0105908:	89 e5                	mov    %esp,%ebp
c010590a:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0105910:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105914:	75 19                	jne    c010592f <default_free_pages+0x28>
c0105916:	68 08 a2 10 c0       	push   $0xc010a208
c010591b:	68 0e a2 10 c0       	push   $0xc010a20e
c0105920:	68 9c 00 00 00       	push   $0x9c
c0105925:	68 23 a2 10 c0       	push   $0xc010a223
c010592a:	e8 c1 aa ff ff       	call   c01003f0 <__panic>
    struct Page *p = base;
c010592f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105932:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105935:	e9 8f 00 00 00       	jmp    c01059c9 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c010593a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010593d:	83 c0 04             	add    $0x4,%eax
c0105940:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0105947:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010594a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010594d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105950:	0f a3 10             	bt     %edx,(%eax)
c0105953:	19 c0                	sbb    %eax,%eax
c0105955:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105958:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010595c:	0f 95 c0             	setne  %al
c010595f:	0f b6 c0             	movzbl %al,%eax
c0105962:	85 c0                	test   %eax,%eax
c0105964:	75 2c                	jne    c0105992 <default_free_pages+0x8b>
c0105966:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105969:	83 c0 04             	add    $0x4,%eax
c010596c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0105973:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105976:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105979:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010597c:	0f a3 10             	bt     %edx,(%eax)
c010597f:	19 c0                	sbb    %eax,%eax
c0105981:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
c0105984:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
c0105988:	0f 95 c0             	setne  %al
c010598b:	0f b6 c0             	movzbl %al,%eax
c010598e:	85 c0                	test   %eax,%eax
c0105990:	74 19                	je     c01059ab <default_free_pages+0xa4>
c0105992:	68 4c a2 10 c0       	push   $0xc010a24c
c0105997:	68 0e a2 10 c0       	push   $0xc010a20e
c010599c:	68 9f 00 00 00       	push   $0x9f
c01059a1:	68 23 a2 10 c0       	push   $0xc010a223
c01059a6:	e8 45 aa ff ff       	call   c01003f0 <__panic>
        p->flags = 0;
c01059ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
c01059b5:	83 ec 08             	sub    $0x8,%esp
c01059b8:	6a 00                	push   $0x0
c01059ba:	ff 75 f4             	pushl  -0xc(%ebp)
c01059bd:	e8 5e fc ff ff       	call   c0105620 <set_page_ref>
c01059c2:	83 c4 10             	add    $0x10,%esp
// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01059c5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01059c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059cc:	c1 e0 05             	shl    $0x5,%eax
c01059cf:	89 c2                	mov    %eax,%edx
c01059d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d4:	01 d0                	add    %edx,%eax
c01059d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01059d9:	0f 85 5b ff ff ff    	jne    c010593a <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
c01059df:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059e5:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01059e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059eb:	83 c0 04             	add    $0x4,%eax
c01059ee:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01059f5:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01059f8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01059fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01059fe:	0f ab 10             	bts    %edx,(%eax)
c0105a01:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a0b:	8b 40 04             	mov    0x4(%eax),%eax
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
c0105a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105a11:	e9 0e 01 00 00       	jmp    c0105b24 <default_free_pages+0x21d>
        p = le2page(le, page_link);
c0105a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a19:	83 e8 0c             	sub    $0xc,%eax
c0105a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a28:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
c0105a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a31:	8b 40 08             	mov    0x8(%eax),%eax
c0105a34:	c1 e0 05             	shl    $0x5,%eax
c0105a37:	89 c2                	mov    %eax,%edx
c0105a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3c:	01 d0                	add    %edx,%eax
c0105a3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105a41:	75 64                	jne    c0105aa7 <default_free_pages+0x1a0>
            base->property += p->property;
c0105a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a46:	8b 50 08             	mov    0x8(%eax),%edx
c0105a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a4c:	8b 40 08             	mov    0x8(%eax),%eax
c0105a4f:	01 c2                	add    %eax,%edx
c0105a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a54:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
c0105a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c0105a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a64:	83 c0 04             	add    $0x4,%eax
c0105a67:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105a6e:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105a71:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105a74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105a77:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0105a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a7d:	83 c0 0c             	add    $0xc,%eax
c0105a80:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105a83:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a86:	8b 40 04             	mov    0x4(%eax),%eax
c0105a89:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105a8c:	8b 12                	mov    (%edx),%edx
c0105a8e:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0105a91:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105a94:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105a97:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105a9a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105a9d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105aa0:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105aa3:	89 10                	mov    %edx,(%eax)
c0105aa5:	eb 7d                	jmp    c0105b24 <default_free_pages+0x21d>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
c0105aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105aaa:	8b 40 08             	mov    0x8(%eax),%eax
c0105aad:	c1 e0 05             	shl    $0x5,%eax
c0105ab0:	89 c2                	mov    %eax,%edx
c0105ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ab5:	01 d0                	add    %edx,%eax
c0105ab7:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105aba:	75 68                	jne    c0105b24 <default_free_pages+0x21d>
            p->property += base->property;
c0105abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105abf:	8b 50 08             	mov    0x8(%eax),%edx
c0105ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac5:	8b 40 08             	mov    0x8(%eax),%eax
c0105ac8:	01 c2                	add    %eax,%edx
c0105aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105acd:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
c0105ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
c0105ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0105add:	83 c0 04             	add    $0x4,%eax
c0105ae0:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0105ae7:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105aea:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105aed:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105af0:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0105af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af6:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0105af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105afc:	83 c0 0c             	add    $0xc,%eax
c0105aff:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0105b02:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105b05:	8b 40 04             	mov    0x4(%eax),%eax
c0105b08:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105b0b:	8b 12                	mov    (%edx),%edx
c0105b0d:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0105b10:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0105b13:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105b16:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105b19:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105b1c:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105b1f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0105b22:	89 10                	mov    %edx,(%eax)
    }
    base->property = n;
    SetPageProperty(base);
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0105b24:	81 7d f0 44 51 12 c0 	cmpl   $0xc0125144,-0x10(%ebp)
c0105b2b:	0f 85 e5 fe ff ff    	jne    c0105a16 <default_free_pages+0x10f>
c0105b31:	c7 45 d0 44 51 12 c0 	movl   $0xc0125144,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105b38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105b3b:	8b 40 04             	mov    0x4(%eax),%eax
            base = p;
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
c0105b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105b41:	eb 20                	jmp    c0105b63 <default_free_pages+0x25c>
        p = le2page(le, page_link);
c0105b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b46:	83 e8 0c             	sub    $0xc,%eax
c0105b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
c0105b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b4f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105b52:	77 1a                	ja     c0105b6e <default_free_pages+0x267>
c0105b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b57:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105b5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105b5d:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0105b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
c0105b63:	81 7d f0 44 51 12 c0 	cmpl   $0xc0125144,-0x10(%ebp)
c0105b6a:	75 d7                	jne    c0105b43 <default_free_pages+0x23c>
c0105b6c:	eb 01                	jmp    c0105b6f <default_free_pages+0x268>
        p = le2page(le, page_link);
        if (p > base) {
            break;
c0105b6e:	90                   	nop
        }
        le = list_next(le);
    }
    nr_free += n;
c0105b6f:	8b 15 4c 51 12 c0    	mov    0xc012514c,%edx
c0105b75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b78:	01 d0                	add    %edx,%eax
c0105b7a:	a3 4c 51 12 c0       	mov    %eax,0xc012514c
    list_add_before(le, &(base->page_link)); 
c0105b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b82:	8d 50 0c             	lea    0xc(%eax),%edx
c0105b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b88:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0105b8b:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105b8e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105b91:	8b 00                	mov    (%eax),%eax
c0105b93:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105b96:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105b99:	89 45 88             	mov    %eax,-0x78(%ebp)
c0105b9c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105b9f:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0105ba2:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105ba5:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105ba8:	89 10                	mov    %edx,(%eax)
c0105baa:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105bad:	8b 10                	mov    (%eax),%edx
c0105baf:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105bb2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105bb5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105bb8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105bbb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105bbe:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105bc1:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105bc4:	89 10                	mov    %edx,(%eax)
}
c0105bc6:	90                   	nop
c0105bc7:	c9                   	leave  
c0105bc8:	c3                   	ret    

c0105bc9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105bc9:	55                   	push   %ebp
c0105bca:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105bcc:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
}
c0105bd1:	5d                   	pop    %ebp
c0105bd2:	c3                   	ret    

c0105bd3 <basic_check>:

static void
basic_check(void) {
c0105bd3:	55                   	push   %ebp
c0105bd4:	89 e5                	mov    %esp,%ebp
c0105bd6:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105bd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105bec:	83 ec 0c             	sub    $0xc,%esp
c0105bef:	6a 01                	push   $0x1
c0105bf1:	e8 06 0d 00 00       	call   c01068fc <alloc_pages>
c0105bf6:	83 c4 10             	add    $0x10,%esp
c0105bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105c00:	75 19                	jne    c0105c1b <basic_check+0x48>
c0105c02:	68 71 a2 10 c0       	push   $0xc010a271
c0105c07:	68 0e a2 10 c0       	push   $0xc010a20e
c0105c0c:	68 d0 00 00 00       	push   $0xd0
c0105c11:	68 23 a2 10 c0       	push   $0xc010a223
c0105c16:	e8 d5 a7 ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105c1b:	83 ec 0c             	sub    $0xc,%esp
c0105c1e:	6a 01                	push   $0x1
c0105c20:	e8 d7 0c 00 00       	call   c01068fc <alloc_pages>
c0105c25:	83 c4 10             	add    $0x10,%esp
c0105c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105c2f:	75 19                	jne    c0105c4a <basic_check+0x77>
c0105c31:	68 8d a2 10 c0       	push   $0xc010a28d
c0105c36:	68 0e a2 10 c0       	push   $0xc010a20e
c0105c3b:	68 d1 00 00 00       	push   $0xd1
c0105c40:	68 23 a2 10 c0       	push   $0xc010a223
c0105c45:	e8 a6 a7 ff ff       	call   c01003f0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105c4a:	83 ec 0c             	sub    $0xc,%esp
c0105c4d:	6a 01                	push   $0x1
c0105c4f:	e8 a8 0c 00 00       	call   c01068fc <alloc_pages>
c0105c54:	83 c4 10             	add    $0x10,%esp
c0105c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c5e:	75 19                	jne    c0105c79 <basic_check+0xa6>
c0105c60:	68 a9 a2 10 c0       	push   $0xc010a2a9
c0105c65:	68 0e a2 10 c0       	push   $0xc010a20e
c0105c6a:	68 d2 00 00 00       	push   $0xd2
c0105c6f:	68 23 a2 10 c0       	push   $0xc010a223
c0105c74:	e8 77 a7 ff ff       	call   c01003f0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105c7f:	74 10                	je     c0105c91 <basic_check+0xbe>
c0105c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c84:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105c87:	74 08                	je     c0105c91 <basic_check+0xbe>
c0105c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105c8f:	75 19                	jne    c0105caa <basic_check+0xd7>
c0105c91:	68 c8 a2 10 c0       	push   $0xc010a2c8
c0105c96:	68 0e a2 10 c0       	push   $0xc010a20e
c0105c9b:	68 d4 00 00 00       	push   $0xd4
c0105ca0:	68 23 a2 10 c0       	push   $0xc010a223
c0105ca5:	e8 46 a7 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105caa:	83 ec 0c             	sub    $0xc,%esp
c0105cad:	ff 75 ec             	pushl  -0x14(%ebp)
c0105cb0:	e8 61 f9 ff ff       	call   c0105616 <page_ref>
c0105cb5:	83 c4 10             	add    $0x10,%esp
c0105cb8:	85 c0                	test   %eax,%eax
c0105cba:	75 24                	jne    c0105ce0 <basic_check+0x10d>
c0105cbc:	83 ec 0c             	sub    $0xc,%esp
c0105cbf:	ff 75 f0             	pushl  -0x10(%ebp)
c0105cc2:	e8 4f f9 ff ff       	call   c0105616 <page_ref>
c0105cc7:	83 c4 10             	add    $0x10,%esp
c0105cca:	85 c0                	test   %eax,%eax
c0105ccc:	75 12                	jne    c0105ce0 <basic_check+0x10d>
c0105cce:	83 ec 0c             	sub    $0xc,%esp
c0105cd1:	ff 75 f4             	pushl  -0xc(%ebp)
c0105cd4:	e8 3d f9 ff ff       	call   c0105616 <page_ref>
c0105cd9:	83 c4 10             	add    $0x10,%esp
c0105cdc:	85 c0                	test   %eax,%eax
c0105cde:	74 19                	je     c0105cf9 <basic_check+0x126>
c0105ce0:	68 ec a2 10 c0       	push   $0xc010a2ec
c0105ce5:	68 0e a2 10 c0       	push   $0xc010a20e
c0105cea:	68 d5 00 00 00       	push   $0xd5
c0105cef:	68 23 a2 10 c0       	push   $0xc010a223
c0105cf4:	e8 f7 a6 ff ff       	call   c01003f0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105cf9:	83 ec 0c             	sub    $0xc,%esp
c0105cfc:	ff 75 ec             	pushl  -0x14(%ebp)
c0105cff:	e8 ff f8 ff ff       	call   c0105603 <page2pa>
c0105d04:	83 c4 10             	add    $0x10,%esp
c0105d07:	89 c2                	mov    %eax,%edx
c0105d09:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0105d0e:	c1 e0 0c             	shl    $0xc,%eax
c0105d11:	39 c2                	cmp    %eax,%edx
c0105d13:	72 19                	jb     c0105d2e <basic_check+0x15b>
c0105d15:	68 28 a3 10 c0       	push   $0xc010a328
c0105d1a:	68 0e a2 10 c0       	push   $0xc010a20e
c0105d1f:	68 d7 00 00 00       	push   $0xd7
c0105d24:	68 23 a2 10 c0       	push   $0xc010a223
c0105d29:	e8 c2 a6 ff ff       	call   c01003f0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105d2e:	83 ec 0c             	sub    $0xc,%esp
c0105d31:	ff 75 f0             	pushl  -0x10(%ebp)
c0105d34:	e8 ca f8 ff ff       	call   c0105603 <page2pa>
c0105d39:	83 c4 10             	add    $0x10,%esp
c0105d3c:	89 c2                	mov    %eax,%edx
c0105d3e:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0105d43:	c1 e0 0c             	shl    $0xc,%eax
c0105d46:	39 c2                	cmp    %eax,%edx
c0105d48:	72 19                	jb     c0105d63 <basic_check+0x190>
c0105d4a:	68 45 a3 10 c0       	push   $0xc010a345
c0105d4f:	68 0e a2 10 c0       	push   $0xc010a20e
c0105d54:	68 d8 00 00 00       	push   $0xd8
c0105d59:	68 23 a2 10 c0       	push   $0xc010a223
c0105d5e:	e8 8d a6 ff ff       	call   c01003f0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105d63:	83 ec 0c             	sub    $0xc,%esp
c0105d66:	ff 75 f4             	pushl  -0xc(%ebp)
c0105d69:	e8 95 f8 ff ff       	call   c0105603 <page2pa>
c0105d6e:	83 c4 10             	add    $0x10,%esp
c0105d71:	89 c2                	mov    %eax,%edx
c0105d73:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0105d78:	c1 e0 0c             	shl    $0xc,%eax
c0105d7b:	39 c2                	cmp    %eax,%edx
c0105d7d:	72 19                	jb     c0105d98 <basic_check+0x1c5>
c0105d7f:	68 62 a3 10 c0       	push   $0xc010a362
c0105d84:	68 0e a2 10 c0       	push   $0xc010a20e
c0105d89:	68 d9 00 00 00       	push   $0xd9
c0105d8e:	68 23 a2 10 c0       	push   $0xc010a223
c0105d93:	e8 58 a6 ff ff       	call   c01003f0 <__panic>

    list_entry_t free_list_store = free_list;
c0105d98:	a1 44 51 12 c0       	mov    0xc0125144,%eax
c0105d9d:	8b 15 48 51 12 c0    	mov    0xc0125148,%edx
c0105da3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105da6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105da9:	c7 45 e4 44 51 12 c0 	movl   $0xc0125144,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0105db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105db3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105db6:	89 50 04             	mov    %edx,0x4(%eax)
c0105db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dbc:	8b 50 04             	mov    0x4(%eax),%edx
c0105dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dc2:	89 10                	mov    %edx,(%eax)
c0105dc4:	c7 45 d8 44 51 12 c0 	movl   $0xc0125144,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0105dcb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105dce:	8b 40 04             	mov    0x4(%eax),%eax
c0105dd1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105dd4:	0f 94 c0             	sete   %al
c0105dd7:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105dda:	85 c0                	test   %eax,%eax
c0105ddc:	75 19                	jne    c0105df7 <basic_check+0x224>
c0105dde:	68 7f a3 10 c0       	push   $0xc010a37f
c0105de3:	68 0e a2 10 c0       	push   $0xc010a20e
c0105de8:	68 dd 00 00 00       	push   $0xdd
c0105ded:	68 23 a2 10 c0       	push   $0xc010a223
c0105df2:	e8 f9 a5 ff ff       	call   c01003f0 <__panic>

    unsigned int nr_free_store = nr_free;
c0105df7:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0105dfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0105dff:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c0105e06:	00 00 00 

    assert(alloc_page() == NULL);
c0105e09:	83 ec 0c             	sub    $0xc,%esp
c0105e0c:	6a 01                	push   $0x1
c0105e0e:	e8 e9 0a 00 00       	call   c01068fc <alloc_pages>
c0105e13:	83 c4 10             	add    $0x10,%esp
c0105e16:	85 c0                	test   %eax,%eax
c0105e18:	74 19                	je     c0105e33 <basic_check+0x260>
c0105e1a:	68 96 a3 10 c0       	push   $0xc010a396
c0105e1f:	68 0e a2 10 c0       	push   $0xc010a20e
c0105e24:	68 e2 00 00 00       	push   $0xe2
c0105e29:	68 23 a2 10 c0       	push   $0xc010a223
c0105e2e:	e8 bd a5 ff ff       	call   c01003f0 <__panic>

    free_page(p0);
c0105e33:	83 ec 08             	sub    $0x8,%esp
c0105e36:	6a 01                	push   $0x1
c0105e38:	ff 75 ec             	pushl  -0x14(%ebp)
c0105e3b:	e8 28 0b 00 00       	call   c0106968 <free_pages>
c0105e40:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0105e43:	83 ec 08             	sub    $0x8,%esp
c0105e46:	6a 01                	push   $0x1
c0105e48:	ff 75 f0             	pushl  -0x10(%ebp)
c0105e4b:	e8 18 0b 00 00       	call   c0106968 <free_pages>
c0105e50:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105e53:	83 ec 08             	sub    $0x8,%esp
c0105e56:	6a 01                	push   $0x1
c0105e58:	ff 75 f4             	pushl  -0xc(%ebp)
c0105e5b:	e8 08 0b 00 00       	call   c0106968 <free_pages>
c0105e60:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0105e63:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0105e68:	83 f8 03             	cmp    $0x3,%eax
c0105e6b:	74 19                	je     c0105e86 <basic_check+0x2b3>
c0105e6d:	68 ab a3 10 c0       	push   $0xc010a3ab
c0105e72:	68 0e a2 10 c0       	push   $0xc010a20e
c0105e77:	68 e7 00 00 00       	push   $0xe7
c0105e7c:	68 23 a2 10 c0       	push   $0xc010a223
c0105e81:	e8 6a a5 ff ff       	call   c01003f0 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105e86:	83 ec 0c             	sub    $0xc,%esp
c0105e89:	6a 01                	push   $0x1
c0105e8b:	e8 6c 0a 00 00       	call   c01068fc <alloc_pages>
c0105e90:	83 c4 10             	add    $0x10,%esp
c0105e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105e9a:	75 19                	jne    c0105eb5 <basic_check+0x2e2>
c0105e9c:	68 71 a2 10 c0       	push   $0xc010a271
c0105ea1:	68 0e a2 10 c0       	push   $0xc010a20e
c0105ea6:	68 e9 00 00 00       	push   $0xe9
c0105eab:	68 23 a2 10 c0       	push   $0xc010a223
c0105eb0:	e8 3b a5 ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105eb5:	83 ec 0c             	sub    $0xc,%esp
c0105eb8:	6a 01                	push   $0x1
c0105eba:	e8 3d 0a 00 00       	call   c01068fc <alloc_pages>
c0105ebf:	83 c4 10             	add    $0x10,%esp
c0105ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ec5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ec9:	75 19                	jne    c0105ee4 <basic_check+0x311>
c0105ecb:	68 8d a2 10 c0       	push   $0xc010a28d
c0105ed0:	68 0e a2 10 c0       	push   $0xc010a20e
c0105ed5:	68 ea 00 00 00       	push   $0xea
c0105eda:	68 23 a2 10 c0       	push   $0xc010a223
c0105edf:	e8 0c a5 ff ff       	call   c01003f0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105ee4:	83 ec 0c             	sub    $0xc,%esp
c0105ee7:	6a 01                	push   $0x1
c0105ee9:	e8 0e 0a 00 00       	call   c01068fc <alloc_pages>
c0105eee:	83 c4 10             	add    $0x10,%esp
c0105ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ef4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105ef8:	75 19                	jne    c0105f13 <basic_check+0x340>
c0105efa:	68 a9 a2 10 c0       	push   $0xc010a2a9
c0105eff:	68 0e a2 10 c0       	push   $0xc010a20e
c0105f04:	68 eb 00 00 00       	push   $0xeb
c0105f09:	68 23 a2 10 c0       	push   $0xc010a223
c0105f0e:	e8 dd a4 ff ff       	call   c01003f0 <__panic>

    assert(alloc_page() == NULL);
c0105f13:	83 ec 0c             	sub    $0xc,%esp
c0105f16:	6a 01                	push   $0x1
c0105f18:	e8 df 09 00 00       	call   c01068fc <alloc_pages>
c0105f1d:	83 c4 10             	add    $0x10,%esp
c0105f20:	85 c0                	test   %eax,%eax
c0105f22:	74 19                	je     c0105f3d <basic_check+0x36a>
c0105f24:	68 96 a3 10 c0       	push   $0xc010a396
c0105f29:	68 0e a2 10 c0       	push   $0xc010a20e
c0105f2e:	68 ed 00 00 00       	push   $0xed
c0105f33:	68 23 a2 10 c0       	push   $0xc010a223
c0105f38:	e8 b3 a4 ff ff       	call   c01003f0 <__panic>

    free_page(p0);
c0105f3d:	83 ec 08             	sub    $0x8,%esp
c0105f40:	6a 01                	push   $0x1
c0105f42:	ff 75 ec             	pushl  -0x14(%ebp)
c0105f45:	e8 1e 0a 00 00       	call   c0106968 <free_pages>
c0105f4a:	83 c4 10             	add    $0x10,%esp
c0105f4d:	c7 45 e8 44 51 12 c0 	movl   $0xc0125144,-0x18(%ebp)
c0105f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f57:	8b 40 04             	mov    0x4(%eax),%eax
c0105f5a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105f5d:	0f 94 c0             	sete   %al
c0105f60:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105f63:	85 c0                	test   %eax,%eax
c0105f65:	74 19                	je     c0105f80 <basic_check+0x3ad>
c0105f67:	68 b8 a3 10 c0       	push   $0xc010a3b8
c0105f6c:	68 0e a2 10 c0       	push   $0xc010a20e
c0105f71:	68 f0 00 00 00       	push   $0xf0
c0105f76:	68 23 a2 10 c0       	push   $0xc010a223
c0105f7b:	e8 70 a4 ff ff       	call   c01003f0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105f80:	83 ec 0c             	sub    $0xc,%esp
c0105f83:	6a 01                	push   $0x1
c0105f85:	e8 72 09 00 00       	call   c01068fc <alloc_pages>
c0105f8a:	83 c4 10             	add    $0x10,%esp
c0105f8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105f90:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105f96:	74 19                	je     c0105fb1 <basic_check+0x3de>
c0105f98:	68 d0 a3 10 c0       	push   $0xc010a3d0
c0105f9d:	68 0e a2 10 c0       	push   $0xc010a20e
c0105fa2:	68 f3 00 00 00       	push   $0xf3
c0105fa7:	68 23 a2 10 c0       	push   $0xc010a223
c0105fac:	e8 3f a4 ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c0105fb1:	83 ec 0c             	sub    $0xc,%esp
c0105fb4:	6a 01                	push   $0x1
c0105fb6:	e8 41 09 00 00       	call   c01068fc <alloc_pages>
c0105fbb:	83 c4 10             	add    $0x10,%esp
c0105fbe:	85 c0                	test   %eax,%eax
c0105fc0:	74 19                	je     c0105fdb <basic_check+0x408>
c0105fc2:	68 96 a3 10 c0       	push   $0xc010a396
c0105fc7:	68 0e a2 10 c0       	push   $0xc010a20e
c0105fcc:	68 f4 00 00 00       	push   $0xf4
c0105fd1:	68 23 a2 10 c0       	push   $0xc010a223
c0105fd6:	e8 15 a4 ff ff       	call   c01003f0 <__panic>

    assert(nr_free == 0);
c0105fdb:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c0105fe0:	85 c0                	test   %eax,%eax
c0105fe2:	74 19                	je     c0105ffd <basic_check+0x42a>
c0105fe4:	68 e9 a3 10 c0       	push   $0xc010a3e9
c0105fe9:	68 0e a2 10 c0       	push   $0xc010a20e
c0105fee:	68 f6 00 00 00       	push   $0xf6
c0105ff3:	68 23 a2 10 c0       	push   $0xc010a223
c0105ff8:	e8 f3 a3 ff ff       	call   c01003f0 <__panic>
    free_list = free_list_store;
c0105ffd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106000:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106003:	a3 44 51 12 c0       	mov    %eax,0xc0125144
c0106008:	89 15 48 51 12 c0    	mov    %edx,0xc0125148
    nr_free = nr_free_store;
c010600e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106011:	a3 4c 51 12 c0       	mov    %eax,0xc012514c

    free_page(p);
c0106016:	83 ec 08             	sub    $0x8,%esp
c0106019:	6a 01                	push   $0x1
c010601b:	ff 75 dc             	pushl  -0x24(%ebp)
c010601e:	e8 45 09 00 00       	call   c0106968 <free_pages>
c0106023:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0106026:	83 ec 08             	sub    $0x8,%esp
c0106029:	6a 01                	push   $0x1
c010602b:	ff 75 f0             	pushl  -0x10(%ebp)
c010602e:	e8 35 09 00 00       	call   c0106968 <free_pages>
c0106033:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0106036:	83 ec 08             	sub    $0x8,%esp
c0106039:	6a 01                	push   $0x1
c010603b:	ff 75 f4             	pushl  -0xc(%ebp)
c010603e:	e8 25 09 00 00       	call   c0106968 <free_pages>
c0106043:	83 c4 10             	add    $0x10,%esp
}
c0106046:	90                   	nop
c0106047:	c9                   	leave  
c0106048:	c3                   	ret    

c0106049 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0106049:	55                   	push   %ebp
c010604a:	89 e5                	mov    %esp,%ebp
c010604c:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0106052:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106059:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0106060:	c7 45 ec 44 51 12 c0 	movl   $0xc0125144,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106067:	eb 60                	jmp    c01060c9 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0106069:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010606c:	83 e8 0c             	sub    $0xc,%eax
c010606f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106075:	83 c0 04             	add    $0x4,%eax
c0106078:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010607f:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106082:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106085:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0106088:	0f a3 10             	bt     %edx,(%eax)
c010608b:	19 c0                	sbb    %eax,%eax
c010608d:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0106090:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0106094:	0f 95 c0             	setne  %al
c0106097:	0f b6 c0             	movzbl %al,%eax
c010609a:	85 c0                	test   %eax,%eax
c010609c:	75 19                	jne    c01060b7 <default_check+0x6e>
c010609e:	68 f6 a3 10 c0       	push   $0xc010a3f6
c01060a3:	68 0e a2 10 c0       	push   $0xc010a20e
c01060a8:	68 07 01 00 00       	push   $0x107
c01060ad:	68 23 a2 10 c0       	push   $0xc010a223
c01060b2:	e8 39 a3 ff ff       	call   c01003f0 <__panic>
        count ++, total += p->property;
c01060b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01060bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060be:	8b 50 08             	mov    0x8(%eax),%edx
c01060c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060c4:	01 d0                	add    %edx,%eax
c01060c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01060cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01060d2:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01060d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060d8:	81 7d ec 44 51 12 c0 	cmpl   $0xc0125144,-0x14(%ebp)
c01060df:	75 88                	jne    c0106069 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01060e1:	e8 b7 08 00 00       	call   c010699d <nr_free_pages>
c01060e6:	89 c2                	mov    %eax,%edx
c01060e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060eb:	39 c2                	cmp    %eax,%edx
c01060ed:	74 19                	je     c0106108 <default_check+0xbf>
c01060ef:	68 06 a4 10 c0       	push   $0xc010a406
c01060f4:	68 0e a2 10 c0       	push   $0xc010a20e
c01060f9:	68 0a 01 00 00       	push   $0x10a
c01060fe:	68 23 a2 10 c0       	push   $0xc010a223
c0106103:	e8 e8 a2 ff ff       	call   c01003f0 <__panic>

    basic_check();
c0106108:	e8 c6 fa ff ff       	call   c0105bd3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010610d:	83 ec 0c             	sub    $0xc,%esp
c0106110:	6a 05                	push   $0x5
c0106112:	e8 e5 07 00 00       	call   c01068fc <alloc_pages>
c0106117:	83 c4 10             	add    $0x10,%esp
c010611a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c010611d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106121:	75 19                	jne    c010613c <default_check+0xf3>
c0106123:	68 1f a4 10 c0       	push   $0xc010a41f
c0106128:	68 0e a2 10 c0       	push   $0xc010a20e
c010612d:	68 0f 01 00 00       	push   $0x10f
c0106132:	68 23 a2 10 c0       	push   $0xc010a223
c0106137:	e8 b4 a2 ff ff       	call   c01003f0 <__panic>
    assert(!PageProperty(p0));
c010613c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010613f:	83 c0 04             	add    $0x4,%eax
c0106142:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0106149:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010614c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010614f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106152:	0f a3 10             	bt     %edx,(%eax)
c0106155:	19 c0                	sbb    %eax,%eax
c0106157:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c010615a:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c010615e:	0f 95 c0             	setne  %al
c0106161:	0f b6 c0             	movzbl %al,%eax
c0106164:	85 c0                	test   %eax,%eax
c0106166:	74 19                	je     c0106181 <default_check+0x138>
c0106168:	68 2a a4 10 c0       	push   $0xc010a42a
c010616d:	68 0e a2 10 c0       	push   $0xc010a20e
c0106172:	68 10 01 00 00       	push   $0x110
c0106177:	68 23 a2 10 c0       	push   $0xc010a223
c010617c:	e8 6f a2 ff ff       	call   c01003f0 <__panic>

    list_entry_t free_list_store = free_list;
c0106181:	a1 44 51 12 c0       	mov    0xc0125144,%eax
c0106186:	8b 15 48 51 12 c0    	mov    0xc0125148,%edx
c010618c:	89 45 80             	mov    %eax,-0x80(%ebp)
c010618f:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0106192:	c7 45 d0 44 51 12 c0 	movl   $0xc0125144,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106199:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010619c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010619f:	89 50 04             	mov    %edx,0x4(%eax)
c01061a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01061a5:	8b 50 04             	mov    0x4(%eax),%edx
c01061a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01061ab:	89 10                	mov    %edx,(%eax)
c01061ad:	c7 45 d8 44 51 12 c0 	movl   $0xc0125144,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01061b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01061b7:	8b 40 04             	mov    0x4(%eax),%eax
c01061ba:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01061bd:	0f 94 c0             	sete   %al
c01061c0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01061c3:	85 c0                	test   %eax,%eax
c01061c5:	75 19                	jne    c01061e0 <default_check+0x197>
c01061c7:	68 7f a3 10 c0       	push   $0xc010a37f
c01061cc:	68 0e a2 10 c0       	push   $0xc010a20e
c01061d1:	68 14 01 00 00       	push   $0x114
c01061d6:	68 23 a2 10 c0       	push   $0xc010a223
c01061db:	e8 10 a2 ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c01061e0:	83 ec 0c             	sub    $0xc,%esp
c01061e3:	6a 01                	push   $0x1
c01061e5:	e8 12 07 00 00       	call   c01068fc <alloc_pages>
c01061ea:	83 c4 10             	add    $0x10,%esp
c01061ed:	85 c0                	test   %eax,%eax
c01061ef:	74 19                	je     c010620a <default_check+0x1c1>
c01061f1:	68 96 a3 10 c0       	push   $0xc010a396
c01061f6:	68 0e a2 10 c0       	push   $0xc010a20e
c01061fb:	68 15 01 00 00       	push   $0x115
c0106200:	68 23 a2 10 c0       	push   $0xc010a223
c0106205:	e8 e6 a1 ff ff       	call   c01003f0 <__panic>

    unsigned int nr_free_store = nr_free;
c010620a:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c010620f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0106212:	c7 05 4c 51 12 c0 00 	movl   $0x0,0xc012514c
c0106219:	00 00 00 

    free_pages(p0 + 2, 3);
c010621c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010621f:	83 c0 40             	add    $0x40,%eax
c0106222:	83 ec 08             	sub    $0x8,%esp
c0106225:	6a 03                	push   $0x3
c0106227:	50                   	push   %eax
c0106228:	e8 3b 07 00 00       	call   c0106968 <free_pages>
c010622d:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0106230:	83 ec 0c             	sub    $0xc,%esp
c0106233:	6a 04                	push   $0x4
c0106235:	e8 c2 06 00 00       	call   c01068fc <alloc_pages>
c010623a:	83 c4 10             	add    $0x10,%esp
c010623d:	85 c0                	test   %eax,%eax
c010623f:	74 19                	je     c010625a <default_check+0x211>
c0106241:	68 3c a4 10 c0       	push   $0xc010a43c
c0106246:	68 0e a2 10 c0       	push   $0xc010a20e
c010624b:	68 1b 01 00 00       	push   $0x11b
c0106250:	68 23 a2 10 c0       	push   $0xc010a223
c0106255:	e8 96 a1 ff ff       	call   c01003f0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010625a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010625d:	83 c0 40             	add    $0x40,%eax
c0106260:	83 c0 04             	add    $0x4,%eax
c0106263:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010626a:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010626d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106270:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106273:	0f a3 10             	bt     %edx,(%eax)
c0106276:	19 c0                	sbb    %eax,%eax
c0106278:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010627b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010627f:	0f 95 c0             	setne  %al
c0106282:	0f b6 c0             	movzbl %al,%eax
c0106285:	85 c0                	test   %eax,%eax
c0106287:	74 0e                	je     c0106297 <default_check+0x24e>
c0106289:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010628c:	83 c0 40             	add    $0x40,%eax
c010628f:	8b 40 08             	mov    0x8(%eax),%eax
c0106292:	83 f8 03             	cmp    $0x3,%eax
c0106295:	74 19                	je     c01062b0 <default_check+0x267>
c0106297:	68 54 a4 10 c0       	push   $0xc010a454
c010629c:	68 0e a2 10 c0       	push   $0xc010a20e
c01062a1:	68 1c 01 00 00       	push   $0x11c
c01062a6:	68 23 a2 10 c0       	push   $0xc010a223
c01062ab:	e8 40 a1 ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01062b0:	83 ec 0c             	sub    $0xc,%esp
c01062b3:	6a 03                	push   $0x3
c01062b5:	e8 42 06 00 00       	call   c01068fc <alloc_pages>
c01062ba:	83 c4 10             	add    $0x10,%esp
c01062bd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01062c0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01062c4:	75 19                	jne    c01062df <default_check+0x296>
c01062c6:	68 80 a4 10 c0       	push   $0xc010a480
c01062cb:	68 0e a2 10 c0       	push   $0xc010a20e
c01062d0:	68 1d 01 00 00       	push   $0x11d
c01062d5:	68 23 a2 10 c0       	push   $0xc010a223
c01062da:	e8 11 a1 ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c01062df:	83 ec 0c             	sub    $0xc,%esp
c01062e2:	6a 01                	push   $0x1
c01062e4:	e8 13 06 00 00       	call   c01068fc <alloc_pages>
c01062e9:	83 c4 10             	add    $0x10,%esp
c01062ec:	85 c0                	test   %eax,%eax
c01062ee:	74 19                	je     c0106309 <default_check+0x2c0>
c01062f0:	68 96 a3 10 c0       	push   $0xc010a396
c01062f5:	68 0e a2 10 c0       	push   $0xc010a20e
c01062fa:	68 1e 01 00 00       	push   $0x11e
c01062ff:	68 23 a2 10 c0       	push   $0xc010a223
c0106304:	e8 e7 a0 ff ff       	call   c01003f0 <__panic>
    assert(p0 + 2 == p1);
c0106309:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010630c:	83 c0 40             	add    $0x40,%eax
c010630f:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0106312:	74 19                	je     c010632d <default_check+0x2e4>
c0106314:	68 9e a4 10 c0       	push   $0xc010a49e
c0106319:	68 0e a2 10 c0       	push   $0xc010a20e
c010631e:	68 1f 01 00 00       	push   $0x11f
c0106323:	68 23 a2 10 c0       	push   $0xc010a223
c0106328:	e8 c3 a0 ff ff       	call   c01003f0 <__panic>

    p2 = p0 + 1;
c010632d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106330:	83 c0 20             	add    $0x20,%eax
c0106333:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0106336:	83 ec 08             	sub    $0x8,%esp
c0106339:	6a 01                	push   $0x1
c010633b:	ff 75 dc             	pushl  -0x24(%ebp)
c010633e:	e8 25 06 00 00       	call   c0106968 <free_pages>
c0106343:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0106346:	83 ec 08             	sub    $0x8,%esp
c0106349:	6a 03                	push   $0x3
c010634b:	ff 75 c4             	pushl  -0x3c(%ebp)
c010634e:	e8 15 06 00 00       	call   c0106968 <free_pages>
c0106353:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0106356:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106359:	83 c0 04             	add    $0x4,%eax
c010635c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0106363:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106366:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106369:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010636c:	0f a3 10             	bt     %edx,(%eax)
c010636f:	19 c0                	sbb    %eax,%eax
c0106371:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0106374:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0106378:	0f 95 c0             	setne  %al
c010637b:	0f b6 c0             	movzbl %al,%eax
c010637e:	85 c0                	test   %eax,%eax
c0106380:	74 0b                	je     c010638d <default_check+0x344>
c0106382:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106385:	8b 40 08             	mov    0x8(%eax),%eax
c0106388:	83 f8 01             	cmp    $0x1,%eax
c010638b:	74 19                	je     c01063a6 <default_check+0x35d>
c010638d:	68 ac a4 10 c0       	push   $0xc010a4ac
c0106392:	68 0e a2 10 c0       	push   $0xc010a20e
c0106397:	68 24 01 00 00       	push   $0x124
c010639c:	68 23 a2 10 c0       	push   $0xc010a223
c01063a1:	e8 4a a0 ff ff       	call   c01003f0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01063a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01063a9:	83 c0 04             	add    $0x4,%eax
c01063ac:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c01063b3:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01063b6:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01063b9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01063bc:	0f a3 10             	bt     %edx,(%eax)
c01063bf:	19 c0                	sbb    %eax,%eax
c01063c1:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c01063c4:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c01063c8:	0f 95 c0             	setne  %al
c01063cb:	0f b6 c0             	movzbl %al,%eax
c01063ce:	85 c0                	test   %eax,%eax
c01063d0:	74 0b                	je     c01063dd <default_check+0x394>
c01063d2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01063d5:	8b 40 08             	mov    0x8(%eax),%eax
c01063d8:	83 f8 03             	cmp    $0x3,%eax
c01063db:	74 19                	je     c01063f6 <default_check+0x3ad>
c01063dd:	68 d4 a4 10 c0       	push   $0xc010a4d4
c01063e2:	68 0e a2 10 c0       	push   $0xc010a20e
c01063e7:	68 25 01 00 00       	push   $0x125
c01063ec:	68 23 a2 10 c0       	push   $0xc010a223
c01063f1:	e8 fa 9f ff ff       	call   c01003f0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01063f6:	83 ec 0c             	sub    $0xc,%esp
c01063f9:	6a 01                	push   $0x1
c01063fb:	e8 fc 04 00 00       	call   c01068fc <alloc_pages>
c0106400:	83 c4 10             	add    $0x10,%esp
c0106403:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106406:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106409:	83 e8 20             	sub    $0x20,%eax
c010640c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010640f:	74 19                	je     c010642a <default_check+0x3e1>
c0106411:	68 fa a4 10 c0       	push   $0xc010a4fa
c0106416:	68 0e a2 10 c0       	push   $0xc010a20e
c010641b:	68 27 01 00 00       	push   $0x127
c0106420:	68 23 a2 10 c0       	push   $0xc010a223
c0106425:	e8 c6 9f ff ff       	call   c01003f0 <__panic>
    free_page(p0);
c010642a:	83 ec 08             	sub    $0x8,%esp
c010642d:	6a 01                	push   $0x1
c010642f:	ff 75 dc             	pushl  -0x24(%ebp)
c0106432:	e8 31 05 00 00       	call   c0106968 <free_pages>
c0106437:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010643a:	83 ec 0c             	sub    $0xc,%esp
c010643d:	6a 02                	push   $0x2
c010643f:	e8 b8 04 00 00       	call   c01068fc <alloc_pages>
c0106444:	83 c4 10             	add    $0x10,%esp
c0106447:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010644a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010644d:	83 c0 20             	add    $0x20,%eax
c0106450:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106453:	74 19                	je     c010646e <default_check+0x425>
c0106455:	68 18 a5 10 c0       	push   $0xc010a518
c010645a:	68 0e a2 10 c0       	push   $0xc010a20e
c010645f:	68 29 01 00 00       	push   $0x129
c0106464:	68 23 a2 10 c0       	push   $0xc010a223
c0106469:	e8 82 9f ff ff       	call   c01003f0 <__panic>

    free_pages(p0, 2);
c010646e:	83 ec 08             	sub    $0x8,%esp
c0106471:	6a 02                	push   $0x2
c0106473:	ff 75 dc             	pushl  -0x24(%ebp)
c0106476:	e8 ed 04 00 00       	call   c0106968 <free_pages>
c010647b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010647e:	83 ec 08             	sub    $0x8,%esp
c0106481:	6a 01                	push   $0x1
c0106483:	ff 75 c0             	pushl  -0x40(%ebp)
c0106486:	e8 dd 04 00 00       	call   c0106968 <free_pages>
c010648b:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c010648e:	83 ec 0c             	sub    $0xc,%esp
c0106491:	6a 05                	push   $0x5
c0106493:	e8 64 04 00 00       	call   c01068fc <alloc_pages>
c0106498:	83 c4 10             	add    $0x10,%esp
c010649b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010649e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01064a2:	75 19                	jne    c01064bd <default_check+0x474>
c01064a4:	68 38 a5 10 c0       	push   $0xc010a538
c01064a9:	68 0e a2 10 c0       	push   $0xc010a20e
c01064ae:	68 2e 01 00 00       	push   $0x12e
c01064b3:	68 23 a2 10 c0       	push   $0xc010a223
c01064b8:	e8 33 9f ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c01064bd:	83 ec 0c             	sub    $0xc,%esp
c01064c0:	6a 01                	push   $0x1
c01064c2:	e8 35 04 00 00       	call   c01068fc <alloc_pages>
c01064c7:	83 c4 10             	add    $0x10,%esp
c01064ca:	85 c0                	test   %eax,%eax
c01064cc:	74 19                	je     c01064e7 <default_check+0x49e>
c01064ce:	68 96 a3 10 c0       	push   $0xc010a396
c01064d3:	68 0e a2 10 c0       	push   $0xc010a20e
c01064d8:	68 2f 01 00 00       	push   $0x12f
c01064dd:	68 23 a2 10 c0       	push   $0xc010a223
c01064e2:	e8 09 9f ff ff       	call   c01003f0 <__panic>

    assert(nr_free == 0);
c01064e7:	a1 4c 51 12 c0       	mov    0xc012514c,%eax
c01064ec:	85 c0                	test   %eax,%eax
c01064ee:	74 19                	je     c0106509 <default_check+0x4c0>
c01064f0:	68 e9 a3 10 c0       	push   $0xc010a3e9
c01064f5:	68 0e a2 10 c0       	push   $0xc010a20e
c01064fa:	68 31 01 00 00       	push   $0x131
c01064ff:	68 23 a2 10 c0       	push   $0xc010a223
c0106504:	e8 e7 9e ff ff       	call   c01003f0 <__panic>
    nr_free = nr_free_store;
c0106509:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010650c:	a3 4c 51 12 c0       	mov    %eax,0xc012514c

    free_list = free_list_store;
c0106511:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106514:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106517:	a3 44 51 12 c0       	mov    %eax,0xc0125144
c010651c:	89 15 48 51 12 c0    	mov    %edx,0xc0125148
    free_pages(p0, 5);
c0106522:	83 ec 08             	sub    $0x8,%esp
c0106525:	6a 05                	push   $0x5
c0106527:	ff 75 dc             	pushl  -0x24(%ebp)
c010652a:	e8 39 04 00 00       	call   c0106968 <free_pages>
c010652f:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0106532:	c7 45 ec 44 51 12 c0 	movl   $0xc0125144,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106539:	eb 1d                	jmp    c0106558 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c010653b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010653e:	83 e8 0c             	sub    $0xc,%eax
c0106541:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0106544:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106548:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010654b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010654e:	8b 40 08             	mov    0x8(%eax),%eax
c0106551:	29 c2                	sub    %eax,%edx
c0106553:	89 d0                	mov    %edx,%eax
c0106555:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106558:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010655b:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010655e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106561:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0106564:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106567:	81 7d ec 44 51 12 c0 	cmpl   $0xc0125144,-0x14(%ebp)
c010656e:	75 cb                	jne    c010653b <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0106570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106574:	74 19                	je     c010658f <default_check+0x546>
c0106576:	68 56 a5 10 c0       	push   $0xc010a556
c010657b:	68 0e a2 10 c0       	push   $0xc010a20e
c0106580:	68 3c 01 00 00       	push   $0x13c
c0106585:	68 23 a2 10 c0       	push   $0xc010a223
c010658a:	e8 61 9e ff ff       	call   c01003f0 <__panic>
    assert(total == 0);
c010658f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106593:	74 19                	je     c01065ae <default_check+0x565>
c0106595:	68 61 a5 10 c0       	push   $0xc010a561
c010659a:	68 0e a2 10 c0       	push   $0xc010a20e
c010659f:	68 3d 01 00 00       	push   $0x13d
c01065a4:	68 23 a2 10 c0       	push   $0xc010a223
c01065a9:	e8 42 9e ff ff       	call   c01003f0 <__panic>
}
c01065ae:	90                   	nop
c01065af:	c9                   	leave  
c01065b0:	c3                   	ret    

c01065b1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01065b1:	55                   	push   %ebp
c01065b2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01065b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01065b7:	8b 15 58 51 12 c0    	mov    0xc0125158,%edx
c01065bd:	29 d0                	sub    %edx,%eax
c01065bf:	c1 f8 05             	sar    $0x5,%eax
}
c01065c2:	5d                   	pop    %ebp
c01065c3:	c3                   	ret    

c01065c4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01065c4:	55                   	push   %ebp
c01065c5:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01065c7:	ff 75 08             	pushl  0x8(%ebp)
c01065ca:	e8 e2 ff ff ff       	call   c01065b1 <page2ppn>
c01065cf:	83 c4 04             	add    $0x4,%esp
c01065d2:	c1 e0 0c             	shl    $0xc,%eax
}
c01065d5:	c9                   	leave  
c01065d6:	c3                   	ret    

c01065d7 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01065d7:	55                   	push   %ebp
c01065d8:	89 e5                	mov    %esp,%ebp
c01065da:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01065dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01065e0:	c1 e8 0c             	shr    $0xc,%eax
c01065e3:	89 c2                	mov    %eax,%edx
c01065e5:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01065ea:	39 c2                	cmp    %eax,%edx
c01065ec:	72 14                	jb     c0106602 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01065ee:	83 ec 04             	sub    $0x4,%esp
c01065f1:	68 9c a5 10 c0       	push   $0xc010a59c
c01065f6:	6a 5b                	push   $0x5b
c01065f8:	68 bb a5 10 c0       	push   $0xc010a5bb
c01065fd:	e8 ee 9d ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0106602:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0106607:	8b 55 08             	mov    0x8(%ebp),%edx
c010660a:	c1 ea 0c             	shr    $0xc,%edx
c010660d:	c1 e2 05             	shl    $0x5,%edx
c0106610:	01 d0                	add    %edx,%eax
}
c0106612:	c9                   	leave  
c0106613:	c3                   	ret    

c0106614 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0106614:	55                   	push   %ebp
c0106615:	89 e5                	mov    %esp,%ebp
c0106617:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c010661a:	ff 75 08             	pushl  0x8(%ebp)
c010661d:	e8 a2 ff ff ff       	call   c01065c4 <page2pa>
c0106622:	83 c4 04             	add    $0x4,%esp
c0106625:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106628:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010662b:	c1 e8 0c             	shr    $0xc,%eax
c010662e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106631:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106636:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106639:	72 14                	jb     c010664f <page2kva+0x3b>
c010663b:	ff 75 f4             	pushl  -0xc(%ebp)
c010663e:	68 cc a5 10 c0       	push   $0xc010a5cc
c0106643:	6a 62                	push   $0x62
c0106645:	68 bb a5 10 c0       	push   $0xc010a5bb
c010664a:	e8 a1 9d ff ff       	call   c01003f0 <__panic>
c010664f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106652:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0106657:	c9                   	leave  
c0106658:	c3                   	ret    

c0106659 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0106659:	55                   	push   %ebp
c010665a:	89 e5                	mov    %esp,%ebp
c010665c:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c010665f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106662:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106665:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010666c:	77 14                	ja     c0106682 <kva2page+0x29>
c010666e:	ff 75 f4             	pushl  -0xc(%ebp)
c0106671:	68 f0 a5 10 c0       	push   $0xc010a5f0
c0106676:	6a 67                	push   $0x67
c0106678:	68 bb a5 10 c0       	push   $0xc010a5bb
c010667d:	e8 6e 9d ff ff       	call   c01003f0 <__panic>
c0106682:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106685:	05 00 00 00 40       	add    $0x40000000,%eax
c010668a:	83 ec 0c             	sub    $0xc,%esp
c010668d:	50                   	push   %eax
c010668e:	e8 44 ff ff ff       	call   c01065d7 <pa2page>
c0106693:	83 c4 10             	add    $0x10,%esp
}
c0106696:	c9                   	leave  
c0106697:	c3                   	ret    

c0106698 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c0106698:	55                   	push   %ebp
c0106699:	89 e5                	mov    %esp,%ebp
c010669b:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c010669e:	8b 45 08             	mov    0x8(%ebp),%eax
c01066a1:	83 e0 01             	and    $0x1,%eax
c01066a4:	85 c0                	test   %eax,%eax
c01066a6:	75 14                	jne    c01066bc <pte2page+0x24>
        panic("pte2page called with invalid pte");
c01066a8:	83 ec 04             	sub    $0x4,%esp
c01066ab:	68 14 a6 10 c0       	push   $0xc010a614
c01066b0:	6a 6d                	push   $0x6d
c01066b2:	68 bb a5 10 c0       	push   $0xc010a5bb
c01066b7:	e8 34 9d ff ff       	call   c01003f0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01066bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01066bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01066c4:	83 ec 0c             	sub    $0xc,%esp
c01066c7:	50                   	push   %eax
c01066c8:	e8 0a ff ff ff       	call   c01065d7 <pa2page>
c01066cd:	83 c4 10             	add    $0x10,%esp
}
c01066d0:	c9                   	leave  
c01066d1:	c3                   	ret    

c01066d2 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c01066d2:	55                   	push   %ebp
c01066d3:	89 e5                	mov    %esp,%ebp
c01066d5:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c01066d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01066db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01066e0:	83 ec 0c             	sub    $0xc,%esp
c01066e3:	50                   	push   %eax
c01066e4:	e8 ee fe ff ff       	call   c01065d7 <pa2page>
c01066e9:	83 c4 10             	add    $0x10,%esp
}
c01066ec:	c9                   	leave  
c01066ed:	c3                   	ret    

c01066ee <page_ref>:

static inline int
page_ref(struct Page *page) {
c01066ee:	55                   	push   %ebp
c01066ef:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01066f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01066f4:	8b 00                	mov    (%eax),%eax
}
c01066f6:	5d                   	pop    %ebp
c01066f7:	c3                   	ret    

c01066f8 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01066f8:	55                   	push   %ebp
c01066f9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01066fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01066fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106701:	89 10                	mov    %edx,(%eax)
}
c0106703:	90                   	nop
c0106704:	5d                   	pop    %ebp
c0106705:	c3                   	ret    

c0106706 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106706:	55                   	push   %ebp
c0106707:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106709:	8b 45 08             	mov    0x8(%ebp),%eax
c010670c:	8b 00                	mov    (%eax),%eax
c010670e:	8d 50 01             	lea    0x1(%eax),%edx
c0106711:	8b 45 08             	mov    0x8(%ebp),%eax
c0106714:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106716:	8b 45 08             	mov    0x8(%ebp),%eax
c0106719:	8b 00                	mov    (%eax),%eax
}
c010671b:	5d                   	pop    %ebp
c010671c:	c3                   	ret    

c010671d <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010671d:	55                   	push   %ebp
c010671e:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106720:	8b 45 08             	mov    0x8(%ebp),%eax
c0106723:	8b 00                	mov    (%eax),%eax
c0106725:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106728:	8b 45 08             	mov    0x8(%ebp),%eax
c010672b:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010672d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106730:	8b 00                	mov    (%eax),%eax
}
c0106732:	5d                   	pop    %ebp
c0106733:	c3                   	ret    

c0106734 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0106734:	55                   	push   %ebp
c0106735:	89 e5                	mov    %esp,%ebp
c0106737:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010673a:	9c                   	pushf  
c010673b:	58                   	pop    %eax
c010673c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010673f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106742:	25 00 02 00 00       	and    $0x200,%eax
c0106747:	85 c0                	test   %eax,%eax
c0106749:	74 0c                	je     c0106757 <__intr_save+0x23>
        intr_disable();
c010674b:	e8 73 b9 ff ff       	call   c01020c3 <intr_disable>
        return 1;
c0106750:	b8 01 00 00 00       	mov    $0x1,%eax
c0106755:	eb 05                	jmp    c010675c <__intr_save+0x28>
    }
    return 0;
c0106757:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010675c:	c9                   	leave  
c010675d:	c3                   	ret    

c010675e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010675e:	55                   	push   %ebp
c010675f:	89 e5                	mov    %esp,%ebp
c0106761:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106764:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106768:	74 05                	je     c010676f <__intr_restore+0x11>
        intr_enable();
c010676a:	e8 4d b9 ff ff       	call   c01020bc <intr_enable>
    }
}
c010676f:	90                   	nop
c0106770:	c9                   	leave  
c0106771:	c3                   	ret    

c0106772 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106772:	55                   	push   %ebp
c0106773:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106775:	8b 45 08             	mov    0x8(%ebp),%eax
c0106778:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010677b:	b8 23 00 00 00       	mov    $0x23,%eax
c0106780:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106782:	b8 23 00 00 00       	mov    $0x23,%eax
c0106787:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106789:	b8 10 00 00 00       	mov    $0x10,%eax
c010678e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106790:	b8 10 00 00 00       	mov    $0x10,%eax
c0106795:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106797:	b8 10 00 00 00       	mov    $0x10,%eax
c010679c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c010679e:	ea a5 67 10 c0 08 00 	ljmp   $0x8,$0xc01067a5
}
c01067a5:	90                   	nop
c01067a6:	5d                   	pop    %ebp
c01067a7:	c3                   	ret    

c01067a8 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01067a8:	55                   	push   %ebp
c01067a9:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01067ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01067ae:	a3 a4 4f 12 c0       	mov    %eax,0xc0124fa4
}
c01067b3:	90                   	nop
c01067b4:	5d                   	pop    %ebp
c01067b5:	c3                   	ret    

c01067b6 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01067b6:	55                   	push   %ebp
c01067b7:	89 e5                	mov    %esp,%ebp
c01067b9:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01067bc:	b8 00 10 12 c0       	mov    $0xc0121000,%eax
c01067c1:	50                   	push   %eax
c01067c2:	e8 e1 ff ff ff       	call   c01067a8 <load_esp0>
c01067c7:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c01067ca:	66 c7 05 a8 4f 12 c0 	movw   $0x10,0xc0124fa8
c01067d1:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01067d3:	66 c7 05 88 1a 12 c0 	movw   $0x68,0xc0121a88
c01067da:	68 00 
c01067dc:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c01067e1:	66 a3 8a 1a 12 c0    	mov    %ax,0xc0121a8a
c01067e7:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c01067ec:	c1 e8 10             	shr    $0x10,%eax
c01067ef:	a2 8c 1a 12 c0       	mov    %al,0xc0121a8c
c01067f4:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c01067fb:	83 e0 f0             	and    $0xfffffff0,%eax
c01067fe:	83 c8 09             	or     $0x9,%eax
c0106801:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106806:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c010680d:	83 e0 ef             	and    $0xffffffef,%eax
c0106810:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106815:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c010681c:	83 e0 9f             	and    $0xffffff9f,%eax
c010681f:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106824:	0f b6 05 8d 1a 12 c0 	movzbl 0xc0121a8d,%eax
c010682b:	83 c8 80             	or     $0xffffff80,%eax
c010682e:	a2 8d 1a 12 c0       	mov    %al,0xc0121a8d
c0106833:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c010683a:	83 e0 f0             	and    $0xfffffff0,%eax
c010683d:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c0106842:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c0106849:	83 e0 ef             	and    $0xffffffef,%eax
c010684c:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c0106851:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c0106858:	83 e0 df             	and    $0xffffffdf,%eax
c010685b:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c0106860:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c0106867:	83 c8 40             	or     $0x40,%eax
c010686a:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c010686f:	0f b6 05 8e 1a 12 c0 	movzbl 0xc0121a8e,%eax
c0106876:	83 e0 7f             	and    $0x7f,%eax
c0106879:	a2 8e 1a 12 c0       	mov    %al,0xc0121a8e
c010687e:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106883:	c1 e8 18             	shr    $0x18,%eax
c0106886:	a2 8f 1a 12 c0       	mov    %al,0xc0121a8f

    // reload all segment registers
    lgdt(&gdt_pd);
c010688b:	68 90 1a 12 c0       	push   $0xc0121a90
c0106890:	e8 dd fe ff ff       	call   c0106772 <lgdt>
c0106895:	83 c4 04             	add    $0x4,%esp
c0106898:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c010689e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01068a2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01068a5:	90                   	nop
c01068a6:	c9                   	leave  
c01068a7:	c3                   	ret    

c01068a8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01068a8:	55                   	push   %ebp
c01068a9:	89 e5                	mov    %esp,%ebp
c01068ab:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c01068ae:	c7 05 50 51 12 c0 80 	movl   $0xc010a580,0xc0125150
c01068b5:	a5 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01068b8:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c01068bd:	8b 00                	mov    (%eax),%eax
c01068bf:	83 ec 08             	sub    $0x8,%esp
c01068c2:	50                   	push   %eax
c01068c3:	68 40 a6 10 c0       	push   $0xc010a640
c01068c8:	e8 bd 99 ff ff       	call   c010028a <cprintf>
c01068cd:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c01068d0:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c01068d5:	8b 40 04             	mov    0x4(%eax),%eax
c01068d8:	ff d0                	call   *%eax
}
c01068da:	90                   	nop
c01068db:	c9                   	leave  
c01068dc:	c3                   	ret    

c01068dd <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01068dd:	55                   	push   %ebp
c01068de:	89 e5                	mov    %esp,%ebp
c01068e0:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c01068e3:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c01068e8:	8b 40 08             	mov    0x8(%eax),%eax
c01068eb:	83 ec 08             	sub    $0x8,%esp
c01068ee:	ff 75 0c             	pushl  0xc(%ebp)
c01068f1:	ff 75 08             	pushl  0x8(%ebp)
c01068f4:	ff d0                	call   *%eax
c01068f6:	83 c4 10             	add    $0x10,%esp
}
c01068f9:	90                   	nop
c01068fa:	c9                   	leave  
c01068fb:	c3                   	ret    

c01068fc <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01068fc:	55                   	push   %ebp
c01068fd:	89 e5                	mov    %esp,%ebp
c01068ff:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0106902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106909:	e8 26 fe ff ff       	call   c0106734 <__intr_save>
c010690e:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106911:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c0106916:	8b 40 0c             	mov    0xc(%eax),%eax
c0106919:	83 ec 0c             	sub    $0xc,%esp
c010691c:	ff 75 08             	pushl  0x8(%ebp)
c010691f:	ff d0                	call   *%eax
c0106921:	83 c4 10             	add    $0x10,%esp
c0106924:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106927:	83 ec 0c             	sub    $0xc,%esp
c010692a:	ff 75 f0             	pushl  -0x10(%ebp)
c010692d:	e8 2c fe ff ff       	call   c010675e <__intr_restore>
c0106932:	83 c4 10             	add    $0x10,%esp

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106939:	75 28                	jne    c0106963 <alloc_pages+0x67>
c010693b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010693f:	77 22                	ja     c0106963 <alloc_pages+0x67>
c0106941:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0106946:	85 c0                	test   %eax,%eax
c0106948:	74 19                	je     c0106963 <alloc_pages+0x67>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c010694a:	8b 55 08             	mov    0x8(%ebp),%edx
c010694d:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c0106952:	83 ec 04             	sub    $0x4,%esp
c0106955:	6a 00                	push   $0x0
c0106957:	52                   	push   %edx
c0106958:	50                   	push   %eax
c0106959:	e8 62 e3 ff ff       	call   c0104cc0 <swap_out>
c010695e:	83 c4 10             	add    $0x10,%esp
    }
c0106961:	eb a6                	jmp    c0106909 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0106963:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106966:	c9                   	leave  
c0106967:	c3                   	ret    

c0106968 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0106968:	55                   	push   %ebp
c0106969:	89 e5                	mov    %esp,%ebp
c010696b:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010696e:	e8 c1 fd ff ff       	call   c0106734 <__intr_save>
c0106973:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106976:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c010697b:	8b 40 10             	mov    0x10(%eax),%eax
c010697e:	83 ec 08             	sub    $0x8,%esp
c0106981:	ff 75 0c             	pushl  0xc(%ebp)
c0106984:	ff 75 08             	pushl  0x8(%ebp)
c0106987:	ff d0                	call   *%eax
c0106989:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010698c:	83 ec 0c             	sub    $0xc,%esp
c010698f:	ff 75 f4             	pushl  -0xc(%ebp)
c0106992:	e8 c7 fd ff ff       	call   c010675e <__intr_restore>
c0106997:	83 c4 10             	add    $0x10,%esp
}
c010699a:	90                   	nop
c010699b:	c9                   	leave  
c010699c:	c3                   	ret    

c010699d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010699d:	55                   	push   %ebp
c010699e:	89 e5                	mov    %esp,%ebp
c01069a0:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01069a3:	e8 8c fd ff ff       	call   c0106734 <__intr_save>
c01069a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01069ab:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c01069b0:	8b 40 14             	mov    0x14(%eax),%eax
c01069b3:	ff d0                	call   *%eax
c01069b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01069b8:	83 ec 0c             	sub    $0xc,%esp
c01069bb:	ff 75 f4             	pushl  -0xc(%ebp)
c01069be:	e8 9b fd ff ff       	call   c010675e <__intr_restore>
c01069c3:	83 c4 10             	add    $0x10,%esp
    return ret;
c01069c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01069c9:	c9                   	leave  
c01069ca:	c3                   	ret    

c01069cb <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01069cb:	55                   	push   %ebp
c01069cc:	89 e5                	mov    %esp,%ebp
c01069ce:	57                   	push   %edi
c01069cf:	56                   	push   %esi
c01069d0:	53                   	push   %ebx
c01069d1:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01069d4:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01069db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01069e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01069e9:	83 ec 0c             	sub    $0xc,%esp
c01069ec:	68 57 a6 10 c0       	push   $0xc010a657
c01069f1:	e8 94 98 ff ff       	call   c010028a <cprintf>
c01069f6:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01069f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106a00:	e9 fc 00 00 00       	jmp    c0106b01 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106a05:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a08:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a0b:	89 d0                	mov    %edx,%eax
c0106a0d:	c1 e0 02             	shl    $0x2,%eax
c0106a10:	01 d0                	add    %edx,%eax
c0106a12:	c1 e0 02             	shl    $0x2,%eax
c0106a15:	01 c8                	add    %ecx,%eax
c0106a17:	8b 50 08             	mov    0x8(%eax),%edx
c0106a1a:	8b 40 04             	mov    0x4(%eax),%eax
c0106a1d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106a20:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0106a23:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a26:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a29:	89 d0                	mov    %edx,%eax
c0106a2b:	c1 e0 02             	shl    $0x2,%eax
c0106a2e:	01 d0                	add    %edx,%eax
c0106a30:	c1 e0 02             	shl    $0x2,%eax
c0106a33:	01 c8                	add    %ecx,%eax
c0106a35:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106a38:	8b 58 10             	mov    0x10(%eax),%ebx
c0106a3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106a3e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106a41:	01 c8                	add    %ecx,%eax
c0106a43:	11 da                	adc    %ebx,%edx
c0106a45:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106a48:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106a4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a51:	89 d0                	mov    %edx,%eax
c0106a53:	c1 e0 02             	shl    $0x2,%eax
c0106a56:	01 d0                	add    %edx,%eax
c0106a58:	c1 e0 02             	shl    $0x2,%eax
c0106a5b:	01 c8                	add    %ecx,%eax
c0106a5d:	83 c0 14             	add    $0x14,%eax
c0106a60:	8b 00                	mov    (%eax),%eax
c0106a62:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0106a65:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106a68:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106a6b:	83 c0 ff             	add    $0xffffffff,%eax
c0106a6e:	83 d2 ff             	adc    $0xffffffff,%edx
c0106a71:	89 c1                	mov    %eax,%ecx
c0106a73:	89 d3                	mov    %edx,%ebx
c0106a75:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106a78:	89 55 80             	mov    %edx,-0x80(%ebp)
c0106a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a7e:	89 d0                	mov    %edx,%eax
c0106a80:	c1 e0 02             	shl    $0x2,%eax
c0106a83:	01 d0                	add    %edx,%eax
c0106a85:	c1 e0 02             	shl    $0x2,%eax
c0106a88:	03 45 80             	add    -0x80(%ebp),%eax
c0106a8b:	8b 50 10             	mov    0x10(%eax),%edx
c0106a8e:	8b 40 0c             	mov    0xc(%eax),%eax
c0106a91:	ff 75 84             	pushl  -0x7c(%ebp)
c0106a94:	53                   	push   %ebx
c0106a95:	51                   	push   %ecx
c0106a96:	ff 75 bc             	pushl  -0x44(%ebp)
c0106a99:	ff 75 b8             	pushl  -0x48(%ebp)
c0106a9c:	52                   	push   %edx
c0106a9d:	50                   	push   %eax
c0106a9e:	68 64 a6 10 c0       	push   $0xc010a664
c0106aa3:	e8 e2 97 ff ff       	call   c010028a <cprintf>
c0106aa8:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0106aab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106aae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ab1:	89 d0                	mov    %edx,%eax
c0106ab3:	c1 e0 02             	shl    $0x2,%eax
c0106ab6:	01 d0                	add    %edx,%eax
c0106ab8:	c1 e0 02             	shl    $0x2,%eax
c0106abb:	01 c8                	add    %ecx,%eax
c0106abd:	83 c0 14             	add    $0x14,%eax
c0106ac0:	8b 00                	mov    (%eax),%eax
c0106ac2:	83 f8 01             	cmp    $0x1,%eax
c0106ac5:	75 36                	jne    c0106afd <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0106ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106aca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106acd:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106ad0:	77 2b                	ja     c0106afd <page_init+0x132>
c0106ad2:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106ad5:	72 05                	jb     c0106adc <page_init+0x111>
c0106ad7:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0106ada:	73 21                	jae    c0106afd <page_init+0x132>
c0106adc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106ae0:	77 1b                	ja     c0106afd <page_init+0x132>
c0106ae2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106ae6:	72 09                	jb     c0106af1 <page_init+0x126>
c0106ae8:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0106aef:	77 0c                	ja     c0106afd <page_init+0x132>
                maxpa = end;
c0106af1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106af4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106afa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106afd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106b01:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106b04:	8b 00                	mov    (%eax),%eax
c0106b06:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106b09:	0f 8f f6 fe ff ff    	jg     c0106a05 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106b0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106b13:	72 1d                	jb     c0106b32 <page_init+0x167>
c0106b15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106b19:	77 09                	ja     c0106b24 <page_init+0x159>
c0106b1b:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0106b22:	76 0e                	jbe    c0106b32 <page_init+0x167>
        maxpa = KMEMSIZE;
c0106b24:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106b2b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0106b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b38:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106b3c:	c1 ea 0c             	shr    $0xc,%edx
c0106b3f:	a3 80 4f 12 c0       	mov    %eax,0xc0124f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0106b44:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0106b4b:	b8 5c 51 12 c0       	mov    $0xc012515c,%eax
c0106b50:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106b53:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106b56:	01 d0                	add    %edx,%eax
c0106b58:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106b5b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106b5e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106b63:	f7 75 ac             	divl   -0x54(%ebp)
c0106b66:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106b69:	29 d0                	sub    %edx,%eax
c0106b6b:	a3 58 51 12 c0       	mov    %eax,0xc0125158

    for (i = 0; i < npage; i ++) {
c0106b70:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106b77:	eb 27                	jmp    c0106ba0 <page_init+0x1d5>
        SetPageReserved(pages + i);
c0106b79:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0106b7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106b81:	c1 e2 05             	shl    $0x5,%edx
c0106b84:	01 d0                	add    %edx,%eax
c0106b86:	83 c0 04             	add    $0x4,%eax
c0106b89:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0106b90:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106b93:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106b96:	8b 55 90             	mov    -0x70(%ebp),%edx
c0106b99:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0106b9c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106ba0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ba3:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106ba8:	39 c2                	cmp    %eax,%edx
c0106baa:	72 cd                	jb     c0106b79 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0106bac:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106bb1:	c1 e0 05             	shl    $0x5,%eax
c0106bb4:	89 c2                	mov    %eax,%edx
c0106bb6:	a1 58 51 12 c0       	mov    0xc0125158,%eax
c0106bbb:	01 d0                	add    %edx,%eax
c0106bbd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0106bc0:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0106bc7:	77 17                	ja     c0106be0 <page_init+0x215>
c0106bc9:	ff 75 a4             	pushl  -0x5c(%ebp)
c0106bcc:	68 f0 a5 10 c0       	push   $0xc010a5f0
c0106bd1:	68 e9 00 00 00       	push   $0xe9
c0106bd6:	68 94 a6 10 c0       	push   $0xc010a694
c0106bdb:	e8 10 98 ff ff       	call   c01003f0 <__panic>
c0106be0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106be3:	05 00 00 00 40       	add    $0x40000000,%eax
c0106be8:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0106beb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106bf2:	e9 69 01 00 00       	jmp    c0106d60 <page_init+0x395>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106bf7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106bfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106bfd:	89 d0                	mov    %edx,%eax
c0106bff:	c1 e0 02             	shl    $0x2,%eax
c0106c02:	01 d0                	add    %edx,%eax
c0106c04:	c1 e0 02             	shl    $0x2,%eax
c0106c07:	01 c8                	add    %ecx,%eax
c0106c09:	8b 50 08             	mov    0x8(%eax),%edx
c0106c0c:	8b 40 04             	mov    0x4(%eax),%eax
c0106c0f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106c12:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106c15:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106c18:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c1b:	89 d0                	mov    %edx,%eax
c0106c1d:	c1 e0 02             	shl    $0x2,%eax
c0106c20:	01 d0                	add    %edx,%eax
c0106c22:	c1 e0 02             	shl    $0x2,%eax
c0106c25:	01 c8                	add    %ecx,%eax
c0106c27:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106c2a:	8b 58 10             	mov    0x10(%eax),%ebx
c0106c2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106c33:	01 c8                	add    %ecx,%eax
c0106c35:	11 da                	adc    %ebx,%edx
c0106c37:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106c3a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0106c3d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106c40:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c43:	89 d0                	mov    %edx,%eax
c0106c45:	c1 e0 02             	shl    $0x2,%eax
c0106c48:	01 d0                	add    %edx,%eax
c0106c4a:	c1 e0 02             	shl    $0x2,%eax
c0106c4d:	01 c8                	add    %ecx,%eax
c0106c4f:	83 c0 14             	add    $0x14,%eax
c0106c52:	8b 00                	mov    (%eax),%eax
c0106c54:	83 f8 01             	cmp    $0x1,%eax
c0106c57:	0f 85 ff 00 00 00    	jne    c0106d5c <page_init+0x391>
            if (begin < freemem) {
c0106c5d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106c60:	ba 00 00 00 00       	mov    $0x0,%edx
c0106c65:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106c68:	72 17                	jb     c0106c81 <page_init+0x2b6>
c0106c6a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106c6d:	77 05                	ja     c0106c74 <page_init+0x2a9>
c0106c6f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0106c72:	76 0d                	jbe    c0106c81 <page_init+0x2b6>
                begin = freemem;
c0106c74:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106c77:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106c7a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0106c81:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106c85:	72 1d                	jb     c0106ca4 <page_init+0x2d9>
c0106c87:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106c8b:	77 09                	ja     c0106c96 <page_init+0x2cb>
c0106c8d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0106c94:	76 0e                	jbe    c0106ca4 <page_init+0x2d9>
                end = KMEMSIZE;
c0106c96:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0106c9d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0106ca4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106ca7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106caa:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106cad:	0f 87 a9 00 00 00    	ja     c0106d5c <page_init+0x391>
c0106cb3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106cb6:	72 09                	jb     c0106cc1 <page_init+0x2f6>
c0106cb8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106cbb:	0f 83 9b 00 00 00    	jae    c0106d5c <page_init+0x391>
                begin = ROUNDUP(begin, PGSIZE);
c0106cc1:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0106cc8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106ccb:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106cce:	01 d0                	add    %edx,%eax
c0106cd0:	83 e8 01             	sub    $0x1,%eax
c0106cd3:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106cd6:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106cd9:	ba 00 00 00 00       	mov    $0x0,%edx
c0106cde:	f7 75 9c             	divl   -0x64(%ebp)
c0106ce1:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106ce4:	29 d0                	sub    %edx,%eax
c0106ce6:	ba 00 00 00 00       	mov    $0x0,%edx
c0106ceb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106cee:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0106cf1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106cf4:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0106cf7:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106cfa:	ba 00 00 00 00       	mov    $0x0,%edx
c0106cff:	89 c3                	mov    %eax,%ebx
c0106d01:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0106d07:	89 de                	mov    %ebx,%esi
c0106d09:	89 d0                	mov    %edx,%eax
c0106d0b:	83 e0 00             	and    $0x0,%eax
c0106d0e:	89 c7                	mov    %eax,%edi
c0106d10:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0106d13:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0106d16:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d19:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106d1c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106d1f:	77 3b                	ja     c0106d5c <page_init+0x391>
c0106d21:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106d24:	72 05                	jb     c0106d2b <page_init+0x360>
c0106d26:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106d29:	73 31                	jae    c0106d5c <page_init+0x391>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0106d2b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106d2e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106d31:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0106d34:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0106d37:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106d3b:	c1 ea 0c             	shr    $0xc,%edx
c0106d3e:	89 c3                	mov    %eax,%ebx
c0106d40:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106d43:	83 ec 0c             	sub    $0xc,%esp
c0106d46:	50                   	push   %eax
c0106d47:	e8 8b f8 ff ff       	call   c01065d7 <pa2page>
c0106d4c:	83 c4 10             	add    $0x10,%esp
c0106d4f:	83 ec 08             	sub    $0x8,%esp
c0106d52:	53                   	push   %ebx
c0106d53:	50                   	push   %eax
c0106d54:	e8 84 fb ff ff       	call   c01068dd <init_memmap>
c0106d59:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0106d5c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106d60:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106d63:	8b 00                	mov    (%eax),%eax
c0106d65:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106d68:	0f 8f 89 fe ff ff    	jg     c0106bf7 <page_init+0x22c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0106d6e:	90                   	nop
c0106d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106d72:	5b                   	pop    %ebx
c0106d73:	5e                   	pop    %esi
c0106d74:	5f                   	pop    %edi
c0106d75:	5d                   	pop    %ebp
c0106d76:	c3                   	ret    

c0106d77 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0106d77:	55                   	push   %ebp
c0106d78:	89 e5                	mov    %esp,%ebp
c0106d7a:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0106d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d80:	33 45 14             	xor    0x14(%ebp),%eax
c0106d83:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106d88:	85 c0                	test   %eax,%eax
c0106d8a:	74 19                	je     c0106da5 <boot_map_segment+0x2e>
c0106d8c:	68 a2 a6 10 c0       	push   $0xc010a6a2
c0106d91:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0106d96:	68 07 01 00 00       	push   $0x107
c0106d9b:	68 94 a6 10 c0       	push   $0xc010a694
c0106da0:	e8 4b 96 ff ff       	call   c01003f0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0106da5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0106dac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106daf:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106db4:	89 c2                	mov    %eax,%edx
c0106db6:	8b 45 10             	mov    0x10(%ebp),%eax
c0106db9:	01 c2                	add    %eax,%edx
c0106dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106dbe:	01 d0                	add    %edx,%eax
c0106dc0:	83 e8 01             	sub    $0x1,%eax
c0106dc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dc9:	ba 00 00 00 00       	mov    $0x0,%edx
c0106dce:	f7 75 f0             	divl   -0x10(%ebp)
c0106dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dd4:	29 d0                	sub    %edx,%eax
c0106dd6:	c1 e8 0c             	shr    $0xc,%eax
c0106dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0106ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ddf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106de5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106dea:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0106ded:	8b 45 14             	mov    0x14(%ebp),%eax
c0106df0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106df6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106dfb:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0106dfe:	eb 57                	jmp    c0106e57 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0106e00:	83 ec 04             	sub    $0x4,%esp
c0106e03:	6a 01                	push   $0x1
c0106e05:	ff 75 0c             	pushl  0xc(%ebp)
c0106e08:	ff 75 08             	pushl  0x8(%ebp)
c0106e0b:	e8 53 01 00 00       	call   c0106f63 <get_pte>
c0106e10:	83 c4 10             	add    $0x10,%esp
c0106e13:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0106e16:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106e1a:	75 19                	jne    c0106e35 <boot_map_segment+0xbe>
c0106e1c:	68 ce a6 10 c0       	push   $0xc010a6ce
c0106e21:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0106e26:	68 0d 01 00 00       	push   $0x10d
c0106e2b:	68 94 a6 10 c0       	push   $0xc010a694
c0106e30:	e8 bb 95 ff ff       	call   c01003f0 <__panic>
        *ptep = pa | PTE_P | perm;
c0106e35:	8b 45 14             	mov    0x14(%ebp),%eax
c0106e38:	0b 45 18             	or     0x18(%ebp),%eax
c0106e3b:	83 c8 01             	or     $0x1,%eax
c0106e3e:	89 c2                	mov    %eax,%edx
c0106e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e43:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0106e45:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106e49:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0106e50:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0106e57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e5b:	75 a3                	jne    c0106e00 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0106e5d:	90                   	nop
c0106e5e:	c9                   	leave  
c0106e5f:	c3                   	ret    

c0106e60 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0106e60:	55                   	push   %ebp
c0106e61:	89 e5                	mov    %esp,%ebp
c0106e63:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0106e66:	83 ec 0c             	sub    $0xc,%esp
c0106e69:	6a 01                	push   $0x1
c0106e6b:	e8 8c fa ff ff       	call   c01068fc <alloc_pages>
c0106e70:	83 c4 10             	add    $0x10,%esp
c0106e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0106e76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e7a:	75 17                	jne    c0106e93 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0106e7c:	83 ec 04             	sub    $0x4,%esp
c0106e7f:	68 db a6 10 c0       	push   $0xc010a6db
c0106e84:	68 19 01 00 00       	push   $0x119
c0106e89:	68 94 a6 10 c0       	push   $0xc010a694
c0106e8e:	e8 5d 95 ff ff       	call   c01003f0 <__panic>
    }
    return page2kva(p);
c0106e93:	83 ec 0c             	sub    $0xc,%esp
c0106e96:	ff 75 f4             	pushl  -0xc(%ebp)
c0106e99:	e8 76 f7 ff ff       	call   c0106614 <page2kva>
c0106e9e:	83 c4 10             	add    $0x10,%esp
}
c0106ea1:	c9                   	leave  
c0106ea2:	c3                   	ret    

c0106ea3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0106ea3:	55                   	push   %ebp
c0106ea4:	89 e5                	mov    %esp,%ebp
c0106ea6:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0106ea9:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106eb1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0106eb8:	77 17                	ja     c0106ed1 <pmm_init+0x2e>
c0106eba:	ff 75 f4             	pushl  -0xc(%ebp)
c0106ebd:	68 f0 a5 10 c0       	push   $0xc010a5f0
c0106ec2:	68 23 01 00 00       	push   $0x123
c0106ec7:	68 94 a6 10 c0       	push   $0xc010a694
c0106ecc:	e8 1f 95 ff ff       	call   c01003f0 <__panic>
c0106ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ed4:	05 00 00 00 40       	add    $0x40000000,%eax
c0106ed9:	a3 54 51 12 c0       	mov    %eax,0xc0125154
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0106ede:	e8 c5 f9 ff ff       	call   c01068a8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0106ee3:	e8 e3 fa ff ff       	call   c01069cb <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0106ee8:	e8 66 04 00 00       	call   c0107353 <check_alloc_page>

    check_pgdir();
c0106eed:	e8 84 04 00 00       	call   c0107376 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0106ef2:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106ef7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0106efd:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106f05:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0106f0c:	77 17                	ja     c0106f25 <pmm_init+0x82>
c0106f0e:	ff 75 f0             	pushl  -0x10(%ebp)
c0106f11:	68 f0 a5 10 c0       	push   $0xc010a5f0
c0106f16:	68 39 01 00 00       	push   $0x139
c0106f1b:	68 94 a6 10 c0       	push   $0xc010a694
c0106f20:	e8 cb 94 ff ff       	call   c01003f0 <__panic>
c0106f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f28:	05 00 00 00 40       	add    $0x40000000,%eax
c0106f2d:	83 c8 03             	or     $0x3,%eax
c0106f30:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0106f32:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0106f37:	83 ec 0c             	sub    $0xc,%esp
c0106f3a:	6a 02                	push   $0x2
c0106f3c:	6a 00                	push   $0x0
c0106f3e:	68 00 00 00 38       	push   $0x38000000
c0106f43:	68 00 00 00 c0       	push   $0xc0000000
c0106f48:	50                   	push   %eax
c0106f49:	e8 29 fe ff ff       	call   c0106d77 <boot_map_segment>
c0106f4e:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0106f51:	e8 60 f8 ff ff       	call   c01067b6 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0106f56:	e8 81 09 00 00       	call   c01078dc <check_boot_pgdir>

    print_pgdir();
c0106f5b:	e8 77 0d 00 00       	call   c0107cd7 <print_pgdir>

}
c0106f60:	90                   	nop
c0106f61:	c9                   	leave  
c0106f62:	c3                   	ret    

c0106f63 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0106f63:	55                   	push   %ebp
c0106f64:	89 e5                	mov    %esp,%ebp
c0106f66:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
c0106f69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f6c:	c1 e8 16             	shr    $0x16,%eax
c0106f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
c0106f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106f7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f7f:	01 d0                	add    %edx,%eax
c0106f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
c0106f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f87:	8b 00                	mov    (%eax),%eax
c0106f89:	83 e0 01             	and    $0x1,%eax
c0106f8c:	85 c0                	test   %eax,%eax
c0106f8e:	0f 85 ae 00 00 00    	jne    c0107042 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
c0106f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106f98:	75 0a                	jne    c0106fa4 <get_pte+0x41>
            return NULL;
c0106f9a:	b8 00 00 00 00       	mov    $0x0,%eax
c0106f9f:	e9 01 01 00 00       	jmp    c01070a5 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
c0106fa4:	83 ec 0c             	sub    $0xc,%esp
c0106fa7:	6a 01                	push   $0x1
c0106fa9:	e8 4e f9 ff ff       	call   c01068fc <alloc_pages>
c0106fae:	83 c4 10             	add    $0x10,%esp
c0106fb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
c0106fb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106fb8:	75 0a                	jne    c0106fc4 <get_pte+0x61>
            return NULL;
c0106fba:	b8 00 00 00 00       	mov    $0x0,%eax
c0106fbf:	e9 e1 00 00 00       	jmp    c01070a5 <get_pte+0x142>
        }
        // (4) set page reference
        set_page_ref(pt_page, 1);
c0106fc4:	83 ec 08             	sub    $0x8,%esp
c0106fc7:	6a 01                	push   $0x1
c0106fc9:	ff 75 ec             	pushl  -0x14(%ebp)
c0106fcc:	e8 27 f7 ff ff       	call   c01066f8 <set_page_ref>
c0106fd1:	83 c4 10             	add    $0x10,%esp
        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
c0106fd4:	83 ec 0c             	sub    $0xc,%esp
c0106fd7:	ff 75 ec             	pushl  -0x14(%ebp)
c0106fda:	e8 e5 f5 ff ff       	call   c01065c4 <page2pa>
c0106fdf:	83 c4 10             	add    $0x10,%esp
c0106fe2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
c0106fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106fe8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106feb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106fee:	c1 e8 0c             	shr    $0xc,%eax
c0106ff1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106ff4:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106ff9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0106ffc:	72 17                	jb     c0107015 <get_pte+0xb2>
c0106ffe:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107001:	68 cc a5 10 c0       	push   $0xc010a5cc
c0107006:	68 8a 01 00 00       	push   $0x18a
c010700b:	68 94 a6 10 c0       	push   $0xc010a694
c0107010:	e8 db 93 ff ff       	call   c01003f0 <__panic>
c0107015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107018:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010701d:	83 ec 04             	sub    $0x4,%esp
c0107020:	68 00 10 00 00       	push   $0x1000
c0107025:	6a 00                	push   $0x0
c0107027:	50                   	push   %eax
c0107028:	e8 a8 13 00 00       	call   c01083d5 <memset>
c010702d:	83 c4 10             	add    $0x10,%esp
        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
c0107030:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107033:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107038:	83 c8 07             	or     $0x7,%eax
c010703b:	89 c2                	mov    %eax,%edx
c010703d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107040:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
c0107042:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107045:	c1 e8 0c             	shr    $0xc,%eax
c0107048:	25 ff 03 00 00       	and    $0x3ff,%eax
c010704d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
c0107050:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107053:	8b 00                	mov    (%eax),%eax
c0107055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010705a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
c010705d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107060:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0107063:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107066:	c1 e8 0c             	shr    $0xc,%eax
c0107069:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010706c:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107071:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0107074:	72 17                	jb     c010708d <get_pte+0x12a>
c0107076:	ff 75 d4             	pushl  -0x2c(%ebp)
c0107079:	68 cc a5 10 c0       	push   $0xc010a5cc
c010707e:	68 91 01 00 00       	push   $0x191
c0107083:	68 94 a6 10 c0       	push   $0xc010a694
c0107088:	e8 63 93 ff ff       	call   c01003f0 <__panic>
c010708d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107090:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107095:	89 c2                	mov    %eax,%edx
c0107097:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010709a:	c1 e0 02             	shl    $0x2,%eax
c010709d:	01 d0                	add    %edx,%eax
c010709f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
c01070a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
c01070a5:	c9                   	leave  
c01070a6:	c3                   	ret    

c01070a7 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01070a7:	55                   	push   %ebp
c01070a8:	89 e5                	mov    %esp,%ebp
c01070aa:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01070ad:	83 ec 04             	sub    $0x4,%esp
c01070b0:	6a 00                	push   $0x0
c01070b2:	ff 75 0c             	pushl  0xc(%ebp)
c01070b5:	ff 75 08             	pushl  0x8(%ebp)
c01070b8:	e8 a6 fe ff ff       	call   c0106f63 <get_pte>
c01070bd:	83 c4 10             	add    $0x10,%esp
c01070c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01070c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01070c7:	74 08                	je     c01070d1 <get_page+0x2a>
        *ptep_store = ptep;
c01070c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01070cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01070cf:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01070d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01070d5:	74 1f                	je     c01070f6 <get_page+0x4f>
c01070d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070da:	8b 00                	mov    (%eax),%eax
c01070dc:	83 e0 01             	and    $0x1,%eax
c01070df:	85 c0                	test   %eax,%eax
c01070e1:	74 13                	je     c01070f6 <get_page+0x4f>
        return pte2page(*ptep);
c01070e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070e6:	8b 00                	mov    (%eax),%eax
c01070e8:	83 ec 0c             	sub    $0xc,%esp
c01070eb:	50                   	push   %eax
c01070ec:	e8 a7 f5 ff ff       	call   c0106698 <pte2page>
c01070f1:	83 c4 10             	add    $0x10,%esp
c01070f4:	eb 05                	jmp    c01070fb <get_page+0x54>
    }
    return NULL;
c01070f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070fb:	c9                   	leave  
c01070fc:	c3                   	ret    

c01070fd <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01070fd:	55                   	push   %ebp
c01070fe:	89 e5                	mov    %esp,%ebp
c0107100:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
c0107103:	8b 45 10             	mov    0x10(%ebp),%eax
c0107106:	8b 00                	mov    (%eax),%eax
c0107108:	83 e0 01             	and    $0x1,%eax
c010710b:	85 c0                	test   %eax,%eax
c010710d:	74 57                	je     c0107166 <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
c010710f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107112:	8b 00                	mov    (%eax),%eax
c0107114:	83 ec 0c             	sub    $0xc,%esp
c0107117:	50                   	push   %eax
c0107118:	e8 7b f5 ff ff       	call   c0106698 <pte2page>
c010711d:	83 c4 10             	add    $0x10,%esp
c0107120:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //(3) decrease page reference
    page_ref_dec(page);
c0107123:	83 ec 0c             	sub    $0xc,%esp
c0107126:	ff 75 f4             	pushl  -0xc(%ebp)
c0107129:	e8 ef f5 ff ff       	call   c010671d <page_ref_dec>
c010712e:	83 c4 10             	add    $0x10,%esp
    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
c0107131:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107134:	8b 00                	mov    (%eax),%eax
c0107136:	85 c0                	test   %eax,%eax
c0107138:	75 10                	jne    c010714a <page_remove_pte+0x4d>
        free_page(page);
c010713a:	83 ec 08             	sub    $0x8,%esp
c010713d:	6a 01                	push   $0x1
c010713f:	ff 75 f4             	pushl  -0xc(%ebp)
c0107142:	e8 21 f8 ff ff       	call   c0106968 <free_pages>
c0107147:	83 c4 10             	add    $0x10,%esp
    }
    //(5) clear second page table entry
    *ptep = 0;
c010714a:	8b 45 10             	mov    0x10(%ebp),%eax
c010714d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
c0107153:	83 ec 08             	sub    $0x8,%esp
c0107156:	ff 75 0c             	pushl  0xc(%ebp)
c0107159:	ff 75 08             	pushl  0x8(%ebp)
c010715c:	e8 fa 00 00 00       	call   c010725b <tlb_invalidate>
c0107161:	83 c4 10             	add    $0x10,%esp
c0107164:	eb 01                	jmp    c0107167 <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
c0107166:	90                   	nop
    }
    //(5) clear second page table entry
    *ptep = 0;
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
c0107167:	c9                   	leave  
c0107168:	c3                   	ret    

c0107169 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0107169:	55                   	push   %ebp
c010716a:	89 e5                	mov    %esp,%ebp
c010716c:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010716f:	83 ec 04             	sub    $0x4,%esp
c0107172:	6a 00                	push   $0x0
c0107174:	ff 75 0c             	pushl  0xc(%ebp)
c0107177:	ff 75 08             	pushl  0x8(%ebp)
c010717a:	e8 e4 fd ff ff       	call   c0106f63 <get_pte>
c010717f:	83 c4 10             	add    $0x10,%esp
c0107182:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0107185:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107189:	74 14                	je     c010719f <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010718b:	83 ec 04             	sub    $0x4,%esp
c010718e:	ff 75 f4             	pushl  -0xc(%ebp)
c0107191:	ff 75 0c             	pushl  0xc(%ebp)
c0107194:	ff 75 08             	pushl  0x8(%ebp)
c0107197:	e8 61 ff ff ff       	call   c01070fd <page_remove_pte>
c010719c:	83 c4 10             	add    $0x10,%esp
    }
}
c010719f:	90                   	nop
c01071a0:	c9                   	leave  
c01071a1:	c3                   	ret    

c01071a2 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01071a2:	55                   	push   %ebp
c01071a3:	89 e5                	mov    %esp,%ebp
c01071a5:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01071a8:	83 ec 04             	sub    $0x4,%esp
c01071ab:	6a 01                	push   $0x1
c01071ad:	ff 75 10             	pushl  0x10(%ebp)
c01071b0:	ff 75 08             	pushl  0x8(%ebp)
c01071b3:	e8 ab fd ff ff       	call   c0106f63 <get_pte>
c01071b8:	83 c4 10             	add    $0x10,%esp
c01071bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01071be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071c2:	75 0a                	jne    c01071ce <page_insert+0x2c>
        return -E_NO_MEM;
c01071c4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01071c9:	e9 8b 00 00 00       	jmp    c0107259 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01071ce:	83 ec 0c             	sub    $0xc,%esp
c01071d1:	ff 75 0c             	pushl  0xc(%ebp)
c01071d4:	e8 2d f5 ff ff       	call   c0106706 <page_ref_inc>
c01071d9:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01071dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071df:	8b 00                	mov    (%eax),%eax
c01071e1:	83 e0 01             	and    $0x1,%eax
c01071e4:	85 c0                	test   %eax,%eax
c01071e6:	74 40                	je     c0107228 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01071e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071eb:	8b 00                	mov    (%eax),%eax
c01071ed:	83 ec 0c             	sub    $0xc,%esp
c01071f0:	50                   	push   %eax
c01071f1:	e8 a2 f4 ff ff       	call   c0106698 <pte2page>
c01071f6:	83 c4 10             	add    $0x10,%esp
c01071f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01071fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107202:	75 10                	jne    c0107214 <page_insert+0x72>
            page_ref_dec(page);
c0107204:	83 ec 0c             	sub    $0xc,%esp
c0107207:	ff 75 0c             	pushl  0xc(%ebp)
c010720a:	e8 0e f5 ff ff       	call   c010671d <page_ref_dec>
c010720f:	83 c4 10             	add    $0x10,%esp
c0107212:	eb 14                	jmp    c0107228 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0107214:	83 ec 04             	sub    $0x4,%esp
c0107217:	ff 75 f4             	pushl  -0xc(%ebp)
c010721a:	ff 75 10             	pushl  0x10(%ebp)
c010721d:	ff 75 08             	pushl  0x8(%ebp)
c0107220:	e8 d8 fe ff ff       	call   c01070fd <page_remove_pte>
c0107225:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0107228:	83 ec 0c             	sub    $0xc,%esp
c010722b:	ff 75 0c             	pushl  0xc(%ebp)
c010722e:	e8 91 f3 ff ff       	call   c01065c4 <page2pa>
c0107233:	83 c4 10             	add    $0x10,%esp
c0107236:	0b 45 14             	or     0x14(%ebp),%eax
c0107239:	83 c8 01             	or     $0x1,%eax
c010723c:	89 c2                	mov    %eax,%edx
c010723e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107241:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0107243:	83 ec 08             	sub    $0x8,%esp
c0107246:	ff 75 10             	pushl  0x10(%ebp)
c0107249:	ff 75 08             	pushl  0x8(%ebp)
c010724c:	e8 0a 00 00 00       	call   c010725b <tlb_invalidate>
c0107251:	83 c4 10             	add    $0x10,%esp
    return 0;
c0107254:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107259:	c9                   	leave  
c010725a:	c3                   	ret    

c010725b <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010725b:	55                   	push   %ebp
c010725c:	89 e5                	mov    %esp,%ebp
c010725e:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0107261:	0f 20 d8             	mov    %cr3,%eax
c0107264:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0107267:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010726a:	8b 45 08             	mov    0x8(%ebp),%eax
c010726d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107270:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107277:	77 17                	ja     c0107290 <tlb_invalidate+0x35>
c0107279:	ff 75 f0             	pushl  -0x10(%ebp)
c010727c:	68 f0 a5 10 c0       	push   $0xc010a5f0
c0107281:	68 fc 01 00 00       	push   $0x1fc
c0107286:	68 94 a6 10 c0       	push   $0xc010a694
c010728b:	e8 60 91 ff ff       	call   c01003f0 <__panic>
c0107290:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107293:	05 00 00 00 40       	add    $0x40000000,%eax
c0107298:	39 c2                	cmp    %eax,%edx
c010729a:	75 0c                	jne    c01072a8 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c010729c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010729f:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01072a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072a5:	0f 01 38             	invlpg (%eax)
    }
}
c01072a8:	90                   	nop
c01072a9:	c9                   	leave  
c01072aa:	c3                   	ret    

c01072ab <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01072ab:	55                   	push   %ebp
c01072ac:	89 e5                	mov    %esp,%ebp
c01072ae:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_page();
c01072b1:	83 ec 0c             	sub    $0xc,%esp
c01072b4:	6a 01                	push   $0x1
c01072b6:	e8 41 f6 ff ff       	call   c01068fc <alloc_pages>
c01072bb:	83 c4 10             	add    $0x10,%esp
c01072be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01072c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01072c5:	0f 84 83 00 00 00    	je     c010734e <pgdir_alloc_page+0xa3>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01072cb:	ff 75 10             	pushl  0x10(%ebp)
c01072ce:	ff 75 0c             	pushl  0xc(%ebp)
c01072d1:	ff 75 f4             	pushl  -0xc(%ebp)
c01072d4:	ff 75 08             	pushl  0x8(%ebp)
c01072d7:	e8 c6 fe ff ff       	call   c01071a2 <page_insert>
c01072dc:	83 c4 10             	add    $0x10,%esp
c01072df:	85 c0                	test   %eax,%eax
c01072e1:	74 17                	je     c01072fa <pgdir_alloc_page+0x4f>
            free_page(page);
c01072e3:	83 ec 08             	sub    $0x8,%esp
c01072e6:	6a 01                	push   $0x1
c01072e8:	ff 75 f4             	pushl  -0xc(%ebp)
c01072eb:	e8 78 f6 ff ff       	call   c0106968 <free_pages>
c01072f0:	83 c4 10             	add    $0x10,%esp
            return NULL;
c01072f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01072f8:	eb 57                	jmp    c0107351 <pgdir_alloc_page+0xa6>
        }
        if (swap_init_ok){
c01072fa:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c01072ff:	85 c0                	test   %eax,%eax
c0107301:	74 4b                	je     c010734e <pgdir_alloc_page+0xa3>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0107303:	a1 7c 50 12 c0       	mov    0xc012507c,%eax
c0107308:	6a 00                	push   $0x0
c010730a:	ff 75 f4             	pushl  -0xc(%ebp)
c010730d:	ff 75 0c             	pushl  0xc(%ebp)
c0107310:	50                   	push   %eax
c0107311:	e8 6b d9 ff ff       	call   c0104c81 <swap_map_swappable>
c0107316:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr=la;
c0107319:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010731c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010731f:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0107322:	83 ec 0c             	sub    $0xc,%esp
c0107325:	ff 75 f4             	pushl  -0xc(%ebp)
c0107328:	e8 c1 f3 ff ff       	call   c01066ee <page_ref>
c010732d:	83 c4 10             	add    $0x10,%esp
c0107330:	83 f8 01             	cmp    $0x1,%eax
c0107333:	74 19                	je     c010734e <pgdir_alloc_page+0xa3>
c0107335:	68 f4 a6 10 c0       	push   $0xc010a6f4
c010733a:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010733f:	68 0f 02 00 00       	push   $0x20f
c0107344:	68 94 a6 10 c0       	push   $0xc010a694
c0107349:	e8 a2 90 ff ff       	call   c01003f0 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c010734e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107351:	c9                   	leave  
c0107352:	c3                   	ret    

c0107353 <check_alloc_page>:

static void
check_alloc_page(void) {
c0107353:	55                   	push   %ebp
c0107354:	89 e5                	mov    %esp,%ebp
c0107356:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0107359:	a1 50 51 12 c0       	mov    0xc0125150,%eax
c010735e:	8b 40 18             	mov    0x18(%eax),%eax
c0107361:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0107363:	83 ec 0c             	sub    $0xc,%esp
c0107366:	68 08 a7 10 c0       	push   $0xc010a708
c010736b:	e8 1a 8f ff ff       	call   c010028a <cprintf>
c0107370:	83 c4 10             	add    $0x10,%esp
}
c0107373:	90                   	nop
c0107374:	c9                   	leave  
c0107375:	c3                   	ret    

c0107376 <check_pgdir>:

static void
check_pgdir(void) {
c0107376:	55                   	push   %ebp
c0107377:	89 e5                	mov    %esp,%ebp
c0107379:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010737c:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107381:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0107386:	76 19                	jbe    c01073a1 <check_pgdir+0x2b>
c0107388:	68 27 a7 10 c0       	push   $0xc010a727
c010738d:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107392:	68 20 02 00 00       	push   $0x220
c0107397:	68 94 a6 10 c0       	push   $0xc010a694
c010739c:	e8 4f 90 ff ff       	call   c01003f0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01073a1:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01073a6:	85 c0                	test   %eax,%eax
c01073a8:	74 0e                	je     c01073b8 <check_pgdir+0x42>
c01073aa:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01073af:	25 ff 0f 00 00       	and    $0xfff,%eax
c01073b4:	85 c0                	test   %eax,%eax
c01073b6:	74 19                	je     c01073d1 <check_pgdir+0x5b>
c01073b8:	68 44 a7 10 c0       	push   $0xc010a744
c01073bd:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01073c2:	68 21 02 00 00       	push   $0x221
c01073c7:	68 94 a6 10 c0       	push   $0xc010a694
c01073cc:	e8 1f 90 ff ff       	call   c01003f0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01073d1:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01073d6:	83 ec 04             	sub    $0x4,%esp
c01073d9:	6a 00                	push   $0x0
c01073db:	6a 00                	push   $0x0
c01073dd:	50                   	push   %eax
c01073de:	e8 c4 fc ff ff       	call   c01070a7 <get_page>
c01073e3:	83 c4 10             	add    $0x10,%esp
c01073e6:	85 c0                	test   %eax,%eax
c01073e8:	74 19                	je     c0107403 <check_pgdir+0x8d>
c01073ea:	68 7c a7 10 c0       	push   $0xc010a77c
c01073ef:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01073f4:	68 22 02 00 00       	push   $0x222
c01073f9:	68 94 a6 10 c0       	push   $0xc010a694
c01073fe:	e8 ed 8f ff ff       	call   c01003f0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107403:	83 ec 0c             	sub    $0xc,%esp
c0107406:	6a 01                	push   $0x1
c0107408:	e8 ef f4 ff ff       	call   c01068fc <alloc_pages>
c010740d:	83 c4 10             	add    $0x10,%esp
c0107410:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107413:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107418:	6a 00                	push   $0x0
c010741a:	6a 00                	push   $0x0
c010741c:	ff 75 f4             	pushl  -0xc(%ebp)
c010741f:	50                   	push   %eax
c0107420:	e8 7d fd ff ff       	call   c01071a2 <page_insert>
c0107425:	83 c4 10             	add    $0x10,%esp
c0107428:	85 c0                	test   %eax,%eax
c010742a:	74 19                	je     c0107445 <check_pgdir+0xcf>
c010742c:	68 a4 a7 10 c0       	push   $0xc010a7a4
c0107431:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107436:	68 26 02 00 00       	push   $0x226
c010743b:	68 94 a6 10 c0       	push   $0xc010a694
c0107440:	e8 ab 8f ff ff       	call   c01003f0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0107445:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010744a:	83 ec 04             	sub    $0x4,%esp
c010744d:	6a 00                	push   $0x0
c010744f:	6a 00                	push   $0x0
c0107451:	50                   	push   %eax
c0107452:	e8 0c fb ff ff       	call   c0106f63 <get_pte>
c0107457:	83 c4 10             	add    $0x10,%esp
c010745a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010745d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107461:	75 19                	jne    c010747c <check_pgdir+0x106>
c0107463:	68 d0 a7 10 c0       	push   $0xc010a7d0
c0107468:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010746d:	68 29 02 00 00       	push   $0x229
c0107472:	68 94 a6 10 c0       	push   $0xc010a694
c0107477:	e8 74 8f ff ff       	call   c01003f0 <__panic>
    assert(pte2page(*ptep) == p1);
c010747c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010747f:	8b 00                	mov    (%eax),%eax
c0107481:	83 ec 0c             	sub    $0xc,%esp
c0107484:	50                   	push   %eax
c0107485:	e8 0e f2 ff ff       	call   c0106698 <pte2page>
c010748a:	83 c4 10             	add    $0x10,%esp
c010748d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107490:	74 19                	je     c01074ab <check_pgdir+0x135>
c0107492:	68 fd a7 10 c0       	push   $0xc010a7fd
c0107497:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010749c:	68 2a 02 00 00       	push   $0x22a
c01074a1:	68 94 a6 10 c0       	push   $0xc010a694
c01074a6:	e8 45 8f ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p1) == 1);
c01074ab:	83 ec 0c             	sub    $0xc,%esp
c01074ae:	ff 75 f4             	pushl  -0xc(%ebp)
c01074b1:	e8 38 f2 ff ff       	call   c01066ee <page_ref>
c01074b6:	83 c4 10             	add    $0x10,%esp
c01074b9:	83 f8 01             	cmp    $0x1,%eax
c01074bc:	74 19                	je     c01074d7 <check_pgdir+0x161>
c01074be:	68 13 a8 10 c0       	push   $0xc010a813
c01074c3:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01074c8:	68 2b 02 00 00       	push   $0x22b
c01074cd:	68 94 a6 10 c0       	push   $0xc010a694
c01074d2:	e8 19 8f ff ff       	call   c01003f0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01074d7:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01074dc:	8b 00                	mov    (%eax),%eax
c01074de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01074e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01074e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074e9:	c1 e8 0c             	shr    $0xc,%eax
c01074ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01074ef:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01074f4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01074f7:	72 17                	jb     c0107510 <check_pgdir+0x19a>
c01074f9:	ff 75 ec             	pushl  -0x14(%ebp)
c01074fc:	68 cc a5 10 c0       	push   $0xc010a5cc
c0107501:	68 2d 02 00 00       	push   $0x22d
c0107506:	68 94 a6 10 c0       	push   $0xc010a694
c010750b:	e8 e0 8e ff ff       	call   c01003f0 <__panic>
c0107510:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107513:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107518:	83 c0 04             	add    $0x4,%eax
c010751b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010751e:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107523:	83 ec 04             	sub    $0x4,%esp
c0107526:	6a 00                	push   $0x0
c0107528:	68 00 10 00 00       	push   $0x1000
c010752d:	50                   	push   %eax
c010752e:	e8 30 fa ff ff       	call   c0106f63 <get_pte>
c0107533:	83 c4 10             	add    $0x10,%esp
c0107536:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107539:	74 19                	je     c0107554 <check_pgdir+0x1de>
c010753b:	68 28 a8 10 c0       	push   $0xc010a828
c0107540:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107545:	68 2e 02 00 00       	push   $0x22e
c010754a:	68 94 a6 10 c0       	push   $0xc010a694
c010754f:	e8 9c 8e ff ff       	call   c01003f0 <__panic>

    p2 = alloc_page();
c0107554:	83 ec 0c             	sub    $0xc,%esp
c0107557:	6a 01                	push   $0x1
c0107559:	e8 9e f3 ff ff       	call   c01068fc <alloc_pages>
c010755e:	83 c4 10             	add    $0x10,%esp
c0107561:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107564:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107569:	6a 06                	push   $0x6
c010756b:	68 00 10 00 00       	push   $0x1000
c0107570:	ff 75 e4             	pushl  -0x1c(%ebp)
c0107573:	50                   	push   %eax
c0107574:	e8 29 fc ff ff       	call   c01071a2 <page_insert>
c0107579:	83 c4 10             	add    $0x10,%esp
c010757c:	85 c0                	test   %eax,%eax
c010757e:	74 19                	je     c0107599 <check_pgdir+0x223>
c0107580:	68 50 a8 10 c0       	push   $0xc010a850
c0107585:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010758a:	68 31 02 00 00       	push   $0x231
c010758f:	68 94 a6 10 c0       	push   $0xc010a694
c0107594:	e8 57 8e ff ff       	call   c01003f0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107599:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010759e:	83 ec 04             	sub    $0x4,%esp
c01075a1:	6a 00                	push   $0x0
c01075a3:	68 00 10 00 00       	push   $0x1000
c01075a8:	50                   	push   %eax
c01075a9:	e8 b5 f9 ff ff       	call   c0106f63 <get_pte>
c01075ae:	83 c4 10             	add    $0x10,%esp
c01075b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01075b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01075b8:	75 19                	jne    c01075d3 <check_pgdir+0x25d>
c01075ba:	68 88 a8 10 c0       	push   $0xc010a888
c01075bf:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01075c4:	68 32 02 00 00       	push   $0x232
c01075c9:	68 94 a6 10 c0       	push   $0xc010a694
c01075ce:	e8 1d 8e ff ff       	call   c01003f0 <__panic>
    assert(*ptep & PTE_U);
c01075d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075d6:	8b 00                	mov    (%eax),%eax
c01075d8:	83 e0 04             	and    $0x4,%eax
c01075db:	85 c0                	test   %eax,%eax
c01075dd:	75 19                	jne    c01075f8 <check_pgdir+0x282>
c01075df:	68 b8 a8 10 c0       	push   $0xc010a8b8
c01075e4:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01075e9:	68 33 02 00 00       	push   $0x233
c01075ee:	68 94 a6 10 c0       	push   $0xc010a694
c01075f3:	e8 f8 8d ff ff       	call   c01003f0 <__panic>
    assert(*ptep & PTE_W);
c01075f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075fb:	8b 00                	mov    (%eax),%eax
c01075fd:	83 e0 02             	and    $0x2,%eax
c0107600:	85 c0                	test   %eax,%eax
c0107602:	75 19                	jne    c010761d <check_pgdir+0x2a7>
c0107604:	68 c6 a8 10 c0       	push   $0xc010a8c6
c0107609:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010760e:	68 34 02 00 00       	push   $0x234
c0107613:	68 94 a6 10 c0       	push   $0xc010a694
c0107618:	e8 d3 8d ff ff       	call   c01003f0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010761d:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107622:	8b 00                	mov    (%eax),%eax
c0107624:	83 e0 04             	and    $0x4,%eax
c0107627:	85 c0                	test   %eax,%eax
c0107629:	75 19                	jne    c0107644 <check_pgdir+0x2ce>
c010762b:	68 d4 a8 10 c0       	push   $0xc010a8d4
c0107630:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107635:	68 35 02 00 00       	push   $0x235
c010763a:	68 94 a6 10 c0       	push   $0xc010a694
c010763f:	e8 ac 8d ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 1);
c0107644:	83 ec 0c             	sub    $0xc,%esp
c0107647:	ff 75 e4             	pushl  -0x1c(%ebp)
c010764a:	e8 9f f0 ff ff       	call   c01066ee <page_ref>
c010764f:	83 c4 10             	add    $0x10,%esp
c0107652:	83 f8 01             	cmp    $0x1,%eax
c0107655:	74 19                	je     c0107670 <check_pgdir+0x2fa>
c0107657:	68 ea a8 10 c0       	push   $0xc010a8ea
c010765c:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107661:	68 36 02 00 00       	push   $0x236
c0107666:	68 94 a6 10 c0       	push   $0xc010a694
c010766b:	e8 80 8d ff ff       	call   c01003f0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107670:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107675:	6a 00                	push   $0x0
c0107677:	68 00 10 00 00       	push   $0x1000
c010767c:	ff 75 f4             	pushl  -0xc(%ebp)
c010767f:	50                   	push   %eax
c0107680:	e8 1d fb ff ff       	call   c01071a2 <page_insert>
c0107685:	83 c4 10             	add    $0x10,%esp
c0107688:	85 c0                	test   %eax,%eax
c010768a:	74 19                	je     c01076a5 <check_pgdir+0x32f>
c010768c:	68 fc a8 10 c0       	push   $0xc010a8fc
c0107691:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107696:	68 38 02 00 00       	push   $0x238
c010769b:	68 94 a6 10 c0       	push   $0xc010a694
c01076a0:	e8 4b 8d ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p1) == 2);
c01076a5:	83 ec 0c             	sub    $0xc,%esp
c01076a8:	ff 75 f4             	pushl  -0xc(%ebp)
c01076ab:	e8 3e f0 ff ff       	call   c01066ee <page_ref>
c01076b0:	83 c4 10             	add    $0x10,%esp
c01076b3:	83 f8 02             	cmp    $0x2,%eax
c01076b6:	74 19                	je     c01076d1 <check_pgdir+0x35b>
c01076b8:	68 28 a9 10 c0       	push   $0xc010a928
c01076bd:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01076c2:	68 39 02 00 00       	push   $0x239
c01076c7:	68 94 a6 10 c0       	push   $0xc010a694
c01076cc:	e8 1f 8d ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c01076d1:	83 ec 0c             	sub    $0xc,%esp
c01076d4:	ff 75 e4             	pushl  -0x1c(%ebp)
c01076d7:	e8 12 f0 ff ff       	call   c01066ee <page_ref>
c01076dc:	83 c4 10             	add    $0x10,%esp
c01076df:	85 c0                	test   %eax,%eax
c01076e1:	74 19                	je     c01076fc <check_pgdir+0x386>
c01076e3:	68 3a a9 10 c0       	push   $0xc010a93a
c01076e8:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01076ed:	68 3a 02 00 00       	push   $0x23a
c01076f2:	68 94 a6 10 c0       	push   $0xc010a694
c01076f7:	e8 f4 8c ff ff       	call   c01003f0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01076fc:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107701:	83 ec 04             	sub    $0x4,%esp
c0107704:	6a 00                	push   $0x0
c0107706:	68 00 10 00 00       	push   $0x1000
c010770b:	50                   	push   %eax
c010770c:	e8 52 f8 ff ff       	call   c0106f63 <get_pte>
c0107711:	83 c4 10             	add    $0x10,%esp
c0107714:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107717:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010771b:	75 19                	jne    c0107736 <check_pgdir+0x3c0>
c010771d:	68 88 a8 10 c0       	push   $0xc010a888
c0107722:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107727:	68 3b 02 00 00       	push   $0x23b
c010772c:	68 94 a6 10 c0       	push   $0xc010a694
c0107731:	e8 ba 8c ff ff       	call   c01003f0 <__panic>
    assert(pte2page(*ptep) == p1);
c0107736:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107739:	8b 00                	mov    (%eax),%eax
c010773b:	83 ec 0c             	sub    $0xc,%esp
c010773e:	50                   	push   %eax
c010773f:	e8 54 ef ff ff       	call   c0106698 <pte2page>
c0107744:	83 c4 10             	add    $0x10,%esp
c0107747:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010774a:	74 19                	je     c0107765 <check_pgdir+0x3ef>
c010774c:	68 fd a7 10 c0       	push   $0xc010a7fd
c0107751:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107756:	68 3c 02 00 00       	push   $0x23c
c010775b:	68 94 a6 10 c0       	push   $0xc010a694
c0107760:	e8 8b 8c ff ff       	call   c01003f0 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107765:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107768:	8b 00                	mov    (%eax),%eax
c010776a:	83 e0 04             	and    $0x4,%eax
c010776d:	85 c0                	test   %eax,%eax
c010776f:	74 19                	je     c010778a <check_pgdir+0x414>
c0107771:	68 4c a9 10 c0       	push   $0xc010a94c
c0107776:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010777b:	68 3d 02 00 00       	push   $0x23d
c0107780:	68 94 a6 10 c0       	push   $0xc010a694
c0107785:	e8 66 8c ff ff       	call   c01003f0 <__panic>

    page_remove(boot_pgdir, 0x0);
c010778a:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010778f:	83 ec 08             	sub    $0x8,%esp
c0107792:	6a 00                	push   $0x0
c0107794:	50                   	push   %eax
c0107795:	e8 cf f9 ff ff       	call   c0107169 <page_remove>
c010779a:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c010779d:	83 ec 0c             	sub    $0xc,%esp
c01077a0:	ff 75 f4             	pushl  -0xc(%ebp)
c01077a3:	e8 46 ef ff ff       	call   c01066ee <page_ref>
c01077a8:	83 c4 10             	add    $0x10,%esp
c01077ab:	83 f8 01             	cmp    $0x1,%eax
c01077ae:	74 19                	je     c01077c9 <check_pgdir+0x453>
c01077b0:	68 13 a8 10 c0       	push   $0xc010a813
c01077b5:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01077ba:	68 40 02 00 00       	push   $0x240
c01077bf:	68 94 a6 10 c0       	push   $0xc010a694
c01077c4:	e8 27 8c ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c01077c9:	83 ec 0c             	sub    $0xc,%esp
c01077cc:	ff 75 e4             	pushl  -0x1c(%ebp)
c01077cf:	e8 1a ef ff ff       	call   c01066ee <page_ref>
c01077d4:	83 c4 10             	add    $0x10,%esp
c01077d7:	85 c0                	test   %eax,%eax
c01077d9:	74 19                	je     c01077f4 <check_pgdir+0x47e>
c01077db:	68 3a a9 10 c0       	push   $0xc010a93a
c01077e0:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01077e5:	68 41 02 00 00       	push   $0x241
c01077ea:	68 94 a6 10 c0       	push   $0xc010a694
c01077ef:	e8 fc 8b ff ff       	call   c01003f0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01077f4:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01077f9:	83 ec 08             	sub    $0x8,%esp
c01077fc:	68 00 10 00 00       	push   $0x1000
c0107801:	50                   	push   %eax
c0107802:	e8 62 f9 ff ff       	call   c0107169 <page_remove>
c0107807:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c010780a:	83 ec 0c             	sub    $0xc,%esp
c010780d:	ff 75 f4             	pushl  -0xc(%ebp)
c0107810:	e8 d9 ee ff ff       	call   c01066ee <page_ref>
c0107815:	83 c4 10             	add    $0x10,%esp
c0107818:	85 c0                	test   %eax,%eax
c010781a:	74 19                	je     c0107835 <check_pgdir+0x4bf>
c010781c:	68 61 a9 10 c0       	push   $0xc010a961
c0107821:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107826:	68 44 02 00 00       	push   $0x244
c010782b:	68 94 a6 10 c0       	push   $0xc010a694
c0107830:	e8 bb 8b ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c0107835:	83 ec 0c             	sub    $0xc,%esp
c0107838:	ff 75 e4             	pushl  -0x1c(%ebp)
c010783b:	e8 ae ee ff ff       	call   c01066ee <page_ref>
c0107840:	83 c4 10             	add    $0x10,%esp
c0107843:	85 c0                	test   %eax,%eax
c0107845:	74 19                	je     c0107860 <check_pgdir+0x4ea>
c0107847:	68 3a a9 10 c0       	push   $0xc010a93a
c010784c:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107851:	68 45 02 00 00       	push   $0x245
c0107856:	68 94 a6 10 c0       	push   $0xc010a694
c010785b:	e8 90 8b ff ff       	call   c01003f0 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107860:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107865:	8b 00                	mov    (%eax),%eax
c0107867:	83 ec 0c             	sub    $0xc,%esp
c010786a:	50                   	push   %eax
c010786b:	e8 62 ee ff ff       	call   c01066d2 <pde2page>
c0107870:	83 c4 10             	add    $0x10,%esp
c0107873:	83 ec 0c             	sub    $0xc,%esp
c0107876:	50                   	push   %eax
c0107877:	e8 72 ee ff ff       	call   c01066ee <page_ref>
c010787c:	83 c4 10             	add    $0x10,%esp
c010787f:	83 f8 01             	cmp    $0x1,%eax
c0107882:	74 19                	je     c010789d <check_pgdir+0x527>
c0107884:	68 74 a9 10 c0       	push   $0xc010a974
c0107889:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010788e:	68 47 02 00 00       	push   $0x247
c0107893:	68 94 a6 10 c0       	push   $0xc010a694
c0107898:	e8 53 8b ff ff       	call   c01003f0 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c010789d:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01078a2:	8b 00                	mov    (%eax),%eax
c01078a4:	83 ec 0c             	sub    $0xc,%esp
c01078a7:	50                   	push   %eax
c01078a8:	e8 25 ee ff ff       	call   c01066d2 <pde2page>
c01078ad:	83 c4 10             	add    $0x10,%esp
c01078b0:	83 ec 08             	sub    $0x8,%esp
c01078b3:	6a 01                	push   $0x1
c01078b5:	50                   	push   %eax
c01078b6:	e8 ad f0 ff ff       	call   c0106968 <free_pages>
c01078bb:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01078be:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01078c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01078c9:	83 ec 0c             	sub    $0xc,%esp
c01078cc:	68 9b a9 10 c0       	push   $0xc010a99b
c01078d1:	e8 b4 89 ff ff       	call   c010028a <cprintf>
c01078d6:	83 c4 10             	add    $0x10,%esp
}
c01078d9:	90                   	nop
c01078da:	c9                   	leave  
c01078db:	c3                   	ret    

c01078dc <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01078dc:	55                   	push   %ebp
c01078dd:	89 e5                	mov    %esp,%ebp
c01078df:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01078e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01078e9:	e9 a3 00 00 00       	jmp    c0107991 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01078ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078f7:	c1 e8 0c             	shr    $0xc,%eax
c01078fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01078fd:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107902:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107905:	72 17                	jb     c010791e <check_boot_pgdir+0x42>
c0107907:	ff 75 f0             	pushl  -0x10(%ebp)
c010790a:	68 cc a5 10 c0       	push   $0xc010a5cc
c010790f:	68 53 02 00 00       	push   $0x253
c0107914:	68 94 a6 10 c0       	push   $0xc010a694
c0107919:	e8 d2 8a ff ff       	call   c01003f0 <__panic>
c010791e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107921:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107926:	89 c2                	mov    %eax,%edx
c0107928:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c010792d:	83 ec 04             	sub    $0x4,%esp
c0107930:	6a 00                	push   $0x0
c0107932:	52                   	push   %edx
c0107933:	50                   	push   %eax
c0107934:	e8 2a f6 ff ff       	call   c0106f63 <get_pte>
c0107939:	83 c4 10             	add    $0x10,%esp
c010793c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010793f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107943:	75 19                	jne    c010795e <check_boot_pgdir+0x82>
c0107945:	68 b8 a9 10 c0       	push   $0xc010a9b8
c010794a:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010794f:	68 53 02 00 00       	push   $0x253
c0107954:	68 94 a6 10 c0       	push   $0xc010a694
c0107959:	e8 92 8a ff ff       	call   c01003f0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010795e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107961:	8b 00                	mov    (%eax),%eax
c0107963:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107968:	89 c2                	mov    %eax,%edx
c010796a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010796d:	39 c2                	cmp    %eax,%edx
c010796f:	74 19                	je     c010798a <check_boot_pgdir+0xae>
c0107971:	68 f5 a9 10 c0       	push   $0xc010a9f5
c0107976:	68 b9 a6 10 c0       	push   $0xc010a6b9
c010797b:	68 54 02 00 00       	push   $0x254
c0107980:	68 94 a6 10 c0       	push   $0xc010a694
c0107985:	e8 66 8a ff ff       	call   c01003f0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010798a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0107991:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107994:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107999:	39 c2                	cmp    %eax,%edx
c010799b:	0f 82 4d ff ff ff    	jb     c01078ee <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01079a1:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01079a6:	05 ac 0f 00 00       	add    $0xfac,%eax
c01079ab:	8b 00                	mov    (%eax),%eax
c01079ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01079b2:	89 c2                	mov    %eax,%edx
c01079b4:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c01079b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01079bc:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01079c3:	77 17                	ja     c01079dc <check_boot_pgdir+0x100>
c01079c5:	ff 75 e4             	pushl  -0x1c(%ebp)
c01079c8:	68 f0 a5 10 c0       	push   $0xc010a5f0
c01079cd:	68 57 02 00 00       	push   $0x257
c01079d2:	68 94 a6 10 c0       	push   $0xc010a694
c01079d7:	e8 14 8a ff ff       	call   c01003f0 <__panic>
c01079dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01079df:	05 00 00 00 40       	add    $0x40000000,%eax
c01079e4:	39 c2                	cmp    %eax,%edx
c01079e6:	74 19                	je     c0107a01 <check_boot_pgdir+0x125>
c01079e8:	68 0c aa 10 c0       	push   $0xc010aa0c
c01079ed:	68 b9 a6 10 c0       	push   $0xc010a6b9
c01079f2:	68 57 02 00 00       	push   $0x257
c01079f7:	68 94 a6 10 c0       	push   $0xc010a694
c01079fc:	e8 ef 89 ff ff       	call   c01003f0 <__panic>

    assert(boot_pgdir[0] == 0);
c0107a01:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107a06:	8b 00                	mov    (%eax),%eax
c0107a08:	85 c0                	test   %eax,%eax
c0107a0a:	74 19                	je     c0107a25 <check_boot_pgdir+0x149>
c0107a0c:	68 40 aa 10 c0       	push   $0xc010aa40
c0107a11:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107a16:	68 59 02 00 00       	push   $0x259
c0107a1b:	68 94 a6 10 c0       	push   $0xc010a694
c0107a20:	e8 cb 89 ff ff       	call   c01003f0 <__panic>

    struct Page *p;
    p = alloc_page();
c0107a25:	83 ec 0c             	sub    $0xc,%esp
c0107a28:	6a 01                	push   $0x1
c0107a2a:	e8 cd ee ff ff       	call   c01068fc <alloc_pages>
c0107a2f:	83 c4 10             	add    $0x10,%esp
c0107a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0107a35:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107a3a:	6a 02                	push   $0x2
c0107a3c:	68 00 01 00 00       	push   $0x100
c0107a41:	ff 75 e0             	pushl  -0x20(%ebp)
c0107a44:	50                   	push   %eax
c0107a45:	e8 58 f7 ff ff       	call   c01071a2 <page_insert>
c0107a4a:	83 c4 10             	add    $0x10,%esp
c0107a4d:	85 c0                	test   %eax,%eax
c0107a4f:	74 19                	je     c0107a6a <check_boot_pgdir+0x18e>
c0107a51:	68 54 aa 10 c0       	push   $0xc010aa54
c0107a56:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107a5b:	68 5d 02 00 00       	push   $0x25d
c0107a60:	68 94 a6 10 c0       	push   $0xc010a694
c0107a65:	e8 86 89 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p) == 1);
c0107a6a:	83 ec 0c             	sub    $0xc,%esp
c0107a6d:	ff 75 e0             	pushl  -0x20(%ebp)
c0107a70:	e8 79 ec ff ff       	call   c01066ee <page_ref>
c0107a75:	83 c4 10             	add    $0x10,%esp
c0107a78:	83 f8 01             	cmp    $0x1,%eax
c0107a7b:	74 19                	je     c0107a96 <check_boot_pgdir+0x1ba>
c0107a7d:	68 82 aa 10 c0       	push   $0xc010aa82
c0107a82:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107a87:	68 5e 02 00 00       	push   $0x25e
c0107a8c:	68 94 a6 10 c0       	push   $0xc010a694
c0107a91:	e8 5a 89 ff ff       	call   c01003f0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0107a96:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107a9b:	6a 02                	push   $0x2
c0107a9d:	68 00 11 00 00       	push   $0x1100
c0107aa2:	ff 75 e0             	pushl  -0x20(%ebp)
c0107aa5:	50                   	push   %eax
c0107aa6:	e8 f7 f6 ff ff       	call   c01071a2 <page_insert>
c0107aab:	83 c4 10             	add    $0x10,%esp
c0107aae:	85 c0                	test   %eax,%eax
c0107ab0:	74 19                	je     c0107acb <check_boot_pgdir+0x1ef>
c0107ab2:	68 94 aa 10 c0       	push   $0xc010aa94
c0107ab7:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107abc:	68 5f 02 00 00       	push   $0x25f
c0107ac1:	68 94 a6 10 c0       	push   $0xc010a694
c0107ac6:	e8 25 89 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p) == 2);
c0107acb:	83 ec 0c             	sub    $0xc,%esp
c0107ace:	ff 75 e0             	pushl  -0x20(%ebp)
c0107ad1:	e8 18 ec ff ff       	call   c01066ee <page_ref>
c0107ad6:	83 c4 10             	add    $0x10,%esp
c0107ad9:	83 f8 02             	cmp    $0x2,%eax
c0107adc:	74 19                	je     c0107af7 <check_boot_pgdir+0x21b>
c0107ade:	68 cb aa 10 c0       	push   $0xc010aacb
c0107ae3:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107ae8:	68 60 02 00 00       	push   $0x260
c0107aed:	68 94 a6 10 c0       	push   $0xc010a694
c0107af2:	e8 f9 88 ff ff       	call   c01003f0 <__panic>

    const char *str = "ucore: Hello world!!";
c0107af7:	c7 45 dc dc aa 10 c0 	movl   $0xc010aadc,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0107afe:	83 ec 08             	sub    $0x8,%esp
c0107b01:	ff 75 dc             	pushl  -0x24(%ebp)
c0107b04:	68 00 01 00 00       	push   $0x100
c0107b09:	e8 ee 05 00 00       	call   c01080fc <strcpy>
c0107b0e:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0107b11:	83 ec 08             	sub    $0x8,%esp
c0107b14:	68 00 11 00 00       	push   $0x1100
c0107b19:	68 00 01 00 00       	push   $0x100
c0107b1e:	e8 53 06 00 00       	call   c0108176 <strcmp>
c0107b23:	83 c4 10             	add    $0x10,%esp
c0107b26:	85 c0                	test   %eax,%eax
c0107b28:	74 19                	je     c0107b43 <check_boot_pgdir+0x267>
c0107b2a:	68 f4 aa 10 c0       	push   $0xc010aaf4
c0107b2f:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107b34:	68 64 02 00 00       	push   $0x264
c0107b39:	68 94 a6 10 c0       	push   $0xc010a694
c0107b3e:	e8 ad 88 ff ff       	call   c01003f0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0107b43:	83 ec 0c             	sub    $0xc,%esp
c0107b46:	ff 75 e0             	pushl  -0x20(%ebp)
c0107b49:	e8 c6 ea ff ff       	call   c0106614 <page2kva>
c0107b4e:	83 c4 10             	add    $0x10,%esp
c0107b51:	05 00 01 00 00       	add    $0x100,%eax
c0107b56:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0107b59:	83 ec 0c             	sub    $0xc,%esp
c0107b5c:	68 00 01 00 00       	push   $0x100
c0107b61:	e8 3e 05 00 00       	call   c01080a4 <strlen>
c0107b66:	83 c4 10             	add    $0x10,%esp
c0107b69:	85 c0                	test   %eax,%eax
c0107b6b:	74 19                	je     c0107b86 <check_boot_pgdir+0x2aa>
c0107b6d:	68 2c ab 10 c0       	push   $0xc010ab2c
c0107b72:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107b77:	68 67 02 00 00       	push   $0x267
c0107b7c:	68 94 a6 10 c0       	push   $0xc010a694
c0107b81:	e8 6a 88 ff ff       	call   c01003f0 <__panic>

    free_page(p);
c0107b86:	83 ec 08             	sub    $0x8,%esp
c0107b89:	6a 01                	push   $0x1
c0107b8b:	ff 75 e0             	pushl  -0x20(%ebp)
c0107b8e:	e8 d5 ed ff ff       	call   c0106968 <free_pages>
c0107b93:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0107b96:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107b9b:	8b 00                	mov    (%eax),%eax
c0107b9d:	83 ec 0c             	sub    $0xc,%esp
c0107ba0:	50                   	push   %eax
c0107ba1:	e8 2c eb ff ff       	call   c01066d2 <pde2page>
c0107ba6:	83 c4 10             	add    $0x10,%esp
c0107ba9:	83 ec 08             	sub    $0x8,%esp
c0107bac:	6a 01                	push   $0x1
c0107bae:	50                   	push   %eax
c0107baf:	e8 b4 ed ff ff       	call   c0106968 <free_pages>
c0107bb4:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0107bb7:	a1 40 1a 12 c0       	mov    0xc0121a40,%eax
c0107bbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0107bc2:	83 ec 0c             	sub    $0xc,%esp
c0107bc5:	68 50 ab 10 c0       	push   $0xc010ab50
c0107bca:	e8 bb 86 ff ff       	call   c010028a <cprintf>
c0107bcf:	83 c4 10             	add    $0x10,%esp
}
c0107bd2:	90                   	nop
c0107bd3:	c9                   	leave  
c0107bd4:	c3                   	ret    

c0107bd5 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0107bd5:	55                   	push   %ebp
c0107bd6:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0107bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bdb:	83 e0 04             	and    $0x4,%eax
c0107bde:	85 c0                	test   %eax,%eax
c0107be0:	74 07                	je     c0107be9 <perm2str+0x14>
c0107be2:	b8 75 00 00 00       	mov    $0x75,%eax
c0107be7:	eb 05                	jmp    c0107bee <perm2str+0x19>
c0107be9:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0107bee:	a2 08 50 12 c0       	mov    %al,0xc0125008
    str[1] = 'r';
c0107bf3:	c6 05 09 50 12 c0 72 	movb   $0x72,0xc0125009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0107bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bfd:	83 e0 02             	and    $0x2,%eax
c0107c00:	85 c0                	test   %eax,%eax
c0107c02:	74 07                	je     c0107c0b <perm2str+0x36>
c0107c04:	b8 77 00 00 00       	mov    $0x77,%eax
c0107c09:	eb 05                	jmp    c0107c10 <perm2str+0x3b>
c0107c0b:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0107c10:	a2 0a 50 12 c0       	mov    %al,0xc012500a
    str[3] = '\0';
c0107c15:	c6 05 0b 50 12 c0 00 	movb   $0x0,0xc012500b
    return str;
c0107c1c:	b8 08 50 12 c0       	mov    $0xc0125008,%eax
}
c0107c21:	5d                   	pop    %ebp
c0107c22:	c3                   	ret    

c0107c23 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0107c23:	55                   	push   %ebp
c0107c24:	89 e5                	mov    %esp,%ebp
c0107c26:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0107c29:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c2f:	72 0e                	jb     c0107c3f <get_pgtable_items+0x1c>
        return 0;
c0107c31:	b8 00 00 00 00       	mov    $0x0,%eax
c0107c36:	e9 9a 00 00 00       	jmp    c0107cd5 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0107c3b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0107c3f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c42:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c45:	73 18                	jae    c0107c5f <get_pgtable_items+0x3c>
c0107c47:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107c51:	8b 45 14             	mov    0x14(%ebp),%eax
c0107c54:	01 d0                	add    %edx,%eax
c0107c56:	8b 00                	mov    (%eax),%eax
c0107c58:	83 e0 01             	and    $0x1,%eax
c0107c5b:	85 c0                	test   %eax,%eax
c0107c5d:	74 dc                	je     c0107c3b <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0107c5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c62:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c65:	73 69                	jae    c0107cd0 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0107c67:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0107c6b:	74 08                	je     c0107c75 <get_pgtable_items+0x52>
            *left_store = start;
c0107c6d:	8b 45 18             	mov    0x18(%ebp),%eax
c0107c70:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c73:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0107c75:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c78:	8d 50 01             	lea    0x1(%eax),%edx
c0107c7b:	89 55 10             	mov    %edx,0x10(%ebp)
c0107c7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107c85:	8b 45 14             	mov    0x14(%ebp),%eax
c0107c88:	01 d0                	add    %edx,%eax
c0107c8a:	8b 00                	mov    (%eax),%eax
c0107c8c:	83 e0 07             	and    $0x7,%eax
c0107c8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0107c92:	eb 04                	jmp    c0107c98 <get_pgtable_items+0x75>
            start ++;
c0107c94:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0107c98:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c9e:	73 1d                	jae    c0107cbd <get_pgtable_items+0x9a>
c0107ca0:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107caa:	8b 45 14             	mov    0x14(%ebp),%eax
c0107cad:	01 d0                	add    %edx,%eax
c0107caf:	8b 00                	mov    (%eax),%eax
c0107cb1:	83 e0 07             	and    $0x7,%eax
c0107cb4:	89 c2                	mov    %eax,%edx
c0107cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107cb9:	39 c2                	cmp    %eax,%edx
c0107cbb:	74 d7                	je     c0107c94 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0107cbd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107cc1:	74 08                	je     c0107ccb <get_pgtable_items+0xa8>
            *right_store = start;
c0107cc3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107cc6:	8b 55 10             	mov    0x10(%ebp),%edx
c0107cc9:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0107ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107cce:	eb 05                	jmp    c0107cd5 <get_pgtable_items+0xb2>
    }
    return 0;
c0107cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107cd5:	c9                   	leave  
c0107cd6:	c3                   	ret    

c0107cd7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0107cd7:	55                   	push   %ebp
c0107cd8:	89 e5                	mov    %esp,%ebp
c0107cda:	57                   	push   %edi
c0107cdb:	56                   	push   %esi
c0107cdc:	53                   	push   %ebx
c0107cdd:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0107ce0:	83 ec 0c             	sub    $0xc,%esp
c0107ce3:	68 70 ab 10 c0       	push   $0xc010ab70
c0107ce8:	e8 9d 85 ff ff       	call   c010028a <cprintf>
c0107ced:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0107cf0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0107cf7:	e9 e5 00 00 00       	jmp    c0107de1 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107cff:	83 ec 0c             	sub    $0xc,%esp
c0107d02:	50                   	push   %eax
c0107d03:	e8 cd fe ff ff       	call   c0107bd5 <perm2str>
c0107d08:	83 c4 10             	add    $0x10,%esp
c0107d0b:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0107d0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107d10:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d13:	29 c2                	sub    %eax,%edx
c0107d15:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107d17:	c1 e0 16             	shl    $0x16,%eax
c0107d1a:	89 c3                	mov    %eax,%ebx
c0107d1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d1f:	c1 e0 16             	shl    $0x16,%eax
c0107d22:	89 c1                	mov    %eax,%ecx
c0107d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d27:	c1 e0 16             	shl    $0x16,%eax
c0107d2a:	89 c2                	mov    %eax,%edx
c0107d2c:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0107d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d32:	29 c6                	sub    %eax,%esi
c0107d34:	89 f0                	mov    %esi,%eax
c0107d36:	83 ec 08             	sub    $0x8,%esp
c0107d39:	57                   	push   %edi
c0107d3a:	53                   	push   %ebx
c0107d3b:	51                   	push   %ecx
c0107d3c:	52                   	push   %edx
c0107d3d:	50                   	push   %eax
c0107d3e:	68 a1 ab 10 c0       	push   $0xc010aba1
c0107d43:	e8 42 85 ff ff       	call   c010028a <cprintf>
c0107d48:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0107d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d4e:	c1 e0 0a             	shl    $0xa,%eax
c0107d51:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0107d54:	eb 4f                	jmp    c0107da5 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0107d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d59:	83 ec 0c             	sub    $0xc,%esp
c0107d5c:	50                   	push   %eax
c0107d5d:	e8 73 fe ff ff       	call   c0107bd5 <perm2str>
c0107d62:	83 c4 10             	add    $0x10,%esp
c0107d65:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0107d67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107d6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d6d:	29 c2                	sub    %eax,%edx
c0107d6f:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0107d71:	c1 e0 0c             	shl    $0xc,%eax
c0107d74:	89 c3                	mov    %eax,%ebx
c0107d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107d79:	c1 e0 0c             	shl    $0xc,%eax
c0107d7c:	89 c1                	mov    %eax,%ecx
c0107d7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d81:	c1 e0 0c             	shl    $0xc,%eax
c0107d84:	89 c2                	mov    %eax,%edx
c0107d86:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0107d89:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d8c:	29 c6                	sub    %eax,%esi
c0107d8e:	89 f0                	mov    %esi,%eax
c0107d90:	83 ec 08             	sub    $0x8,%esp
c0107d93:	57                   	push   %edi
c0107d94:	53                   	push   %ebx
c0107d95:	51                   	push   %ecx
c0107d96:	52                   	push   %edx
c0107d97:	50                   	push   %eax
c0107d98:	68 c0 ab 10 c0       	push   $0xc010abc0
c0107d9d:	e8 e8 84 ff ff       	call   c010028a <cprintf>
c0107da2:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0107da5:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0107daa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107db0:	89 d3                	mov    %edx,%ebx
c0107db2:	c1 e3 0a             	shl    $0xa,%ebx
c0107db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107db8:	89 d1                	mov    %edx,%ecx
c0107dba:	c1 e1 0a             	shl    $0xa,%ecx
c0107dbd:	83 ec 08             	sub    $0x8,%esp
c0107dc0:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0107dc3:	52                   	push   %edx
c0107dc4:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0107dc7:	52                   	push   %edx
c0107dc8:	56                   	push   %esi
c0107dc9:	50                   	push   %eax
c0107dca:	53                   	push   %ebx
c0107dcb:	51                   	push   %ecx
c0107dcc:	e8 52 fe ff ff       	call   c0107c23 <get_pgtable_items>
c0107dd1:	83 c4 20             	add    $0x20,%esp
c0107dd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107dd7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107ddb:	0f 85 75 ff ff ff    	jne    c0107d56 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0107de1:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0107de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107de9:	83 ec 08             	sub    $0x8,%esp
c0107dec:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0107def:	52                   	push   %edx
c0107df0:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0107df3:	52                   	push   %edx
c0107df4:	51                   	push   %ecx
c0107df5:	50                   	push   %eax
c0107df6:	68 00 04 00 00       	push   $0x400
c0107dfb:	6a 00                	push   $0x0
c0107dfd:	e8 21 fe ff ff       	call   c0107c23 <get_pgtable_items>
c0107e02:	83 c4 20             	add    $0x20,%esp
c0107e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107e08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107e0c:	0f 85 ea fe ff ff    	jne    c0107cfc <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0107e12:	83 ec 0c             	sub    $0xc,%esp
c0107e15:	68 e4 ab 10 c0       	push   $0xc010abe4
c0107e1a:	e8 6b 84 ff ff       	call   c010028a <cprintf>
c0107e1f:	83 c4 10             	add    $0x10,%esp
}
c0107e22:	90                   	nop
c0107e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0107e26:	5b                   	pop    %ebx
c0107e27:	5e                   	pop    %esi
c0107e28:	5f                   	pop    %edi
c0107e29:	5d                   	pop    %ebp
c0107e2a:	c3                   	ret    

c0107e2b <kmalloc>:

void *
kmalloc(size_t n) {
c0107e2b:	55                   	push   %ebp
c0107e2c:	89 e5                	mov    %esp,%ebp
c0107e2e:	83 ec 18             	sub    $0x18,%esp
    void * ptr=NULL;
c0107e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0107e38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0107e3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107e43:	74 09                	je     c0107e4e <kmalloc+0x23>
c0107e45:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0107e4c:	76 19                	jbe    c0107e67 <kmalloc+0x3c>
c0107e4e:	68 15 ac 10 c0       	push   $0xc010ac15
c0107e53:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107e58:	68 b3 02 00 00       	push   $0x2b3
c0107e5d:	68 94 a6 10 c0       	push   $0xc010a694
c0107e62:	e8 89 85 ff ff       	call   c01003f0 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0107e67:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e6a:	05 ff 0f 00 00       	add    $0xfff,%eax
c0107e6f:	c1 e8 0c             	shr    $0xc,%eax
c0107e72:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0107e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e78:	83 ec 0c             	sub    $0xc,%esp
c0107e7b:	50                   	push   %eax
c0107e7c:	e8 7b ea ff ff       	call   c01068fc <alloc_pages>
c0107e81:	83 c4 10             	add    $0x10,%esp
c0107e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0107e87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107e8b:	75 19                	jne    c0107ea6 <kmalloc+0x7b>
c0107e8d:	68 2c ac 10 c0       	push   $0xc010ac2c
c0107e92:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107e97:	68 b6 02 00 00       	push   $0x2b6
c0107e9c:	68 94 a6 10 c0       	push   $0xc010a694
c0107ea1:	e8 4a 85 ff ff       	call   c01003f0 <__panic>
    ptr=page2kva(base);
c0107ea6:	83 ec 0c             	sub    $0xc,%esp
c0107ea9:	ff 75 f0             	pushl  -0x10(%ebp)
c0107eac:	e8 63 e7 ff ff       	call   c0106614 <page2kva>
c0107eb1:	83 c4 10             	add    $0x10,%esp
c0107eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0107eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107eba:	c9                   	leave  
c0107ebb:	c3                   	ret    

c0107ebc <kfree>:

void 
kfree(void *ptr, size_t n) {
c0107ebc:	55                   	push   %ebp
c0107ebd:	89 e5                	mov    %esp,%ebp
c0107ebf:	83 ec 18             	sub    $0x18,%esp
    assert(n > 0 && n < 1024*0124);
c0107ec2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107ec6:	74 09                	je     c0107ed1 <kfree+0x15>
c0107ec8:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0107ecf:	76 19                	jbe    c0107eea <kfree+0x2e>
c0107ed1:	68 15 ac 10 c0       	push   $0xc010ac15
c0107ed6:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107edb:	68 bd 02 00 00       	push   $0x2bd
c0107ee0:	68 94 a6 10 c0       	push   $0xc010a694
c0107ee5:	e8 06 85 ff ff       	call   c01003f0 <__panic>
    assert(ptr != NULL);
c0107eea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107eee:	75 19                	jne    c0107f09 <kfree+0x4d>
c0107ef0:	68 39 ac 10 c0       	push   $0xc010ac39
c0107ef5:	68 b9 a6 10 c0       	push   $0xc010a6b9
c0107efa:	68 be 02 00 00       	push   $0x2be
c0107eff:	68 94 a6 10 c0       	push   $0xc010a694
c0107f04:	e8 e7 84 ff ff       	call   c01003f0 <__panic>
    struct Page *base=NULL;
c0107f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0107f10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f13:	05 ff 0f 00 00       	add    $0xfff,%eax
c0107f18:	c1 e8 0c             	shr    $0xc,%eax
c0107f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0107f1e:	83 ec 0c             	sub    $0xc,%esp
c0107f21:	ff 75 08             	pushl  0x8(%ebp)
c0107f24:	e8 30 e7 ff ff       	call   c0106659 <kva2page>
c0107f29:	83 c4 10             	add    $0x10,%esp
c0107f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0107f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f32:	83 ec 08             	sub    $0x8,%esp
c0107f35:	50                   	push   %eax
c0107f36:	ff 75 f4             	pushl  -0xc(%ebp)
c0107f39:	e8 2a ea ff ff       	call   c0106968 <free_pages>
c0107f3e:	83 c4 10             	add    $0x10,%esp
}
c0107f41:	90                   	nop
c0107f42:	c9                   	leave  
c0107f43:	c3                   	ret    

c0107f44 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107f44:	55                   	push   %ebp
c0107f45:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107f47:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f4a:	8b 15 58 51 12 c0    	mov    0xc0125158,%edx
c0107f50:	29 d0                	sub    %edx,%eax
c0107f52:	c1 f8 05             	sar    $0x5,%eax
}
c0107f55:	5d                   	pop    %ebp
c0107f56:	c3                   	ret    

c0107f57 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107f57:	55                   	push   %ebp
c0107f58:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0107f5a:	ff 75 08             	pushl  0x8(%ebp)
c0107f5d:	e8 e2 ff ff ff       	call   c0107f44 <page2ppn>
c0107f62:	83 c4 04             	add    $0x4,%esp
c0107f65:	c1 e0 0c             	shl    $0xc,%eax
}
c0107f68:	c9                   	leave  
c0107f69:	c3                   	ret    

c0107f6a <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107f6a:	55                   	push   %ebp
c0107f6b:	89 e5                	mov    %esp,%ebp
c0107f6d:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0107f70:	ff 75 08             	pushl  0x8(%ebp)
c0107f73:	e8 df ff ff ff       	call   c0107f57 <page2pa>
c0107f78:	83 c4 04             	add    $0x4,%esp
c0107f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f81:	c1 e8 0c             	shr    $0xc,%eax
c0107f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f87:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107f8c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107f8f:	72 14                	jb     c0107fa5 <page2kva+0x3b>
c0107f91:	ff 75 f4             	pushl  -0xc(%ebp)
c0107f94:	68 48 ac 10 c0       	push   $0xc010ac48
c0107f99:	6a 62                	push   $0x62
c0107f9b:	68 6b ac 10 c0       	push   $0xc010ac6b
c0107fa0:	e8 4b 84 ff ff       	call   c01003f0 <__panic>
c0107fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fa8:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107fad:	c9                   	leave  
c0107fae:	c3                   	ret    

c0107faf <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107faf:	55                   	push   %ebp
c0107fb0:	89 e5                	mov    %esp,%ebp
c0107fb2:	83 ec 08             	sub    $0x8,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107fb5:	83 ec 0c             	sub    $0xc,%esp
c0107fb8:	6a 01                	push   $0x1
c0107fba:	e8 21 91 ff ff       	call   c01010e0 <ide_device_valid>
c0107fbf:	83 c4 10             	add    $0x10,%esp
c0107fc2:	85 c0                	test   %eax,%eax
c0107fc4:	75 14                	jne    c0107fda <swapfs_init+0x2b>
        panic("swap fs isn't available.\n");
c0107fc6:	83 ec 04             	sub    $0x4,%esp
c0107fc9:	68 79 ac 10 c0       	push   $0xc010ac79
c0107fce:	6a 0d                	push   $0xd
c0107fd0:	68 93 ac 10 c0       	push   $0xc010ac93
c0107fd5:	e8 16 84 ff ff       	call   c01003f0 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107fda:	83 ec 0c             	sub    $0xc,%esp
c0107fdd:	6a 01                	push   $0x1
c0107fdf:	e8 3c 91 ff ff       	call   c0101120 <ide_device_size>
c0107fe4:	83 c4 10             	add    $0x10,%esp
c0107fe7:	c1 e8 03             	shr    $0x3,%eax
c0107fea:	a3 1c 51 12 c0       	mov    %eax,0xc012511c
}
c0107fef:	90                   	nop
c0107ff0:	c9                   	leave  
c0107ff1:	c3                   	ret    

c0107ff2 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107ff2:	55                   	push   %ebp
c0107ff3:	89 e5                	mov    %esp,%ebp
c0107ff5:	83 ec 18             	sub    $0x18,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107ff8:	83 ec 0c             	sub    $0xc,%esp
c0107ffb:	ff 75 0c             	pushl  0xc(%ebp)
c0107ffe:	e8 67 ff ff ff       	call   c0107f6a <page2kva>
c0108003:	83 c4 10             	add    $0x10,%esp
c0108006:	89 c2                	mov    %eax,%edx
c0108008:	8b 45 08             	mov    0x8(%ebp),%eax
c010800b:	c1 e8 08             	shr    $0x8,%eax
c010800e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108015:	74 0a                	je     c0108021 <swapfs_read+0x2f>
c0108017:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c010801c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010801f:	72 14                	jb     c0108035 <swapfs_read+0x43>
c0108021:	ff 75 08             	pushl  0x8(%ebp)
c0108024:	68 a4 ac 10 c0       	push   $0xc010aca4
c0108029:	6a 14                	push   $0x14
c010802b:	68 93 ac 10 c0       	push   $0xc010ac93
c0108030:	e8 bb 83 ff ff       	call   c01003f0 <__panic>
c0108035:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108038:	c1 e0 03             	shl    $0x3,%eax
c010803b:	6a 08                	push   $0x8
c010803d:	52                   	push   %edx
c010803e:	50                   	push   %eax
c010803f:	6a 01                	push   $0x1
c0108041:	e8 1a 91 ff ff       	call   c0101160 <ide_read_secs>
c0108046:	83 c4 10             	add    $0x10,%esp
}
c0108049:	c9                   	leave  
c010804a:	c3                   	ret    

c010804b <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010804b:	55                   	push   %ebp
c010804c:	89 e5                	mov    %esp,%ebp
c010804e:	83 ec 18             	sub    $0x18,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108051:	83 ec 0c             	sub    $0xc,%esp
c0108054:	ff 75 0c             	pushl  0xc(%ebp)
c0108057:	e8 0e ff ff ff       	call   c0107f6a <page2kva>
c010805c:	83 c4 10             	add    $0x10,%esp
c010805f:	89 c2                	mov    %eax,%edx
c0108061:	8b 45 08             	mov    0x8(%ebp),%eax
c0108064:	c1 e8 08             	shr    $0x8,%eax
c0108067:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010806a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010806e:	74 0a                	je     c010807a <swapfs_write+0x2f>
c0108070:	a1 1c 51 12 c0       	mov    0xc012511c,%eax
c0108075:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0108078:	72 14                	jb     c010808e <swapfs_write+0x43>
c010807a:	ff 75 08             	pushl  0x8(%ebp)
c010807d:	68 a4 ac 10 c0       	push   $0xc010aca4
c0108082:	6a 19                	push   $0x19
c0108084:	68 93 ac 10 c0       	push   $0xc010ac93
c0108089:	e8 62 83 ff ff       	call   c01003f0 <__panic>
c010808e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108091:	c1 e0 03             	shl    $0x3,%eax
c0108094:	6a 08                	push   $0x8
c0108096:	52                   	push   %edx
c0108097:	50                   	push   %eax
c0108098:	6a 01                	push   $0x1
c010809a:	e8 eb 92 ff ff       	call   c010138a <ide_write_secs>
c010809f:	83 c4 10             	add    $0x10,%esp
}
c01080a2:	c9                   	leave  
c01080a3:	c3                   	ret    

c01080a4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01080a4:	55                   	push   %ebp
c01080a5:	89 e5                	mov    %esp,%ebp
c01080a7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01080aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01080b1:	eb 04                	jmp    c01080b7 <strlen+0x13>
        cnt ++;
c01080b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01080b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01080ba:	8d 50 01             	lea    0x1(%eax),%edx
c01080bd:	89 55 08             	mov    %edx,0x8(%ebp)
c01080c0:	0f b6 00             	movzbl (%eax),%eax
c01080c3:	84 c0                	test   %al,%al
c01080c5:	75 ec                	jne    c01080b3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01080c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01080ca:	c9                   	leave  
c01080cb:	c3                   	ret    

c01080cc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01080cc:	55                   	push   %ebp
c01080cd:	89 e5                	mov    %esp,%ebp
c01080cf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01080d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01080d9:	eb 04                	jmp    c01080df <strnlen+0x13>
        cnt ++;
c01080db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01080df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01080e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01080e5:	73 10                	jae    c01080f7 <strnlen+0x2b>
c01080e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01080ea:	8d 50 01             	lea    0x1(%eax),%edx
c01080ed:	89 55 08             	mov    %edx,0x8(%ebp)
c01080f0:	0f b6 00             	movzbl (%eax),%eax
c01080f3:	84 c0                	test   %al,%al
c01080f5:	75 e4                	jne    c01080db <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01080f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01080fa:	c9                   	leave  
c01080fb:	c3                   	ret    

c01080fc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01080fc:	55                   	push   %ebp
c01080fd:	89 e5                	mov    %esp,%ebp
c01080ff:	57                   	push   %edi
c0108100:	56                   	push   %esi
c0108101:	83 ec 20             	sub    $0x20,%esp
c0108104:	8b 45 08             	mov    0x8(%ebp),%eax
c0108107:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010810a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010810d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108110:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108113:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108116:	89 d1                	mov    %edx,%ecx
c0108118:	89 c2                	mov    %eax,%edx
c010811a:	89 ce                	mov    %ecx,%esi
c010811c:	89 d7                	mov    %edx,%edi
c010811e:	ac                   	lods   %ds:(%esi),%al
c010811f:	aa                   	stos   %al,%es:(%edi)
c0108120:	84 c0                	test   %al,%al
c0108122:	75 fa                	jne    c010811e <strcpy+0x22>
c0108124:	89 fa                	mov    %edi,%edx
c0108126:	89 f1                	mov    %esi,%ecx
c0108128:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010812b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010812e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0108131:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0108134:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108135:	83 c4 20             	add    $0x20,%esp
c0108138:	5e                   	pop    %esi
c0108139:	5f                   	pop    %edi
c010813a:	5d                   	pop    %ebp
c010813b:	c3                   	ret    

c010813c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010813c:	55                   	push   %ebp
c010813d:	89 e5                	mov    %esp,%ebp
c010813f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108142:	8b 45 08             	mov    0x8(%ebp),%eax
c0108145:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108148:	eb 21                	jmp    c010816b <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010814a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010814d:	0f b6 10             	movzbl (%eax),%edx
c0108150:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108153:	88 10                	mov    %dl,(%eax)
c0108155:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108158:	0f b6 00             	movzbl (%eax),%eax
c010815b:	84 c0                	test   %al,%al
c010815d:	74 04                	je     c0108163 <strncpy+0x27>
            src ++;
c010815f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0108163:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108167:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010816b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010816f:	75 d9                	jne    c010814a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0108171:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108174:	c9                   	leave  
c0108175:	c3                   	ret    

c0108176 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108176:	55                   	push   %ebp
c0108177:	89 e5                	mov    %esp,%ebp
c0108179:	57                   	push   %edi
c010817a:	56                   	push   %esi
c010817b:	83 ec 20             	sub    $0x20,%esp
c010817e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108181:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108184:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108187:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010818a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010818d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108190:	89 d1                	mov    %edx,%ecx
c0108192:	89 c2                	mov    %eax,%edx
c0108194:	89 ce                	mov    %ecx,%esi
c0108196:	89 d7                	mov    %edx,%edi
c0108198:	ac                   	lods   %ds:(%esi),%al
c0108199:	ae                   	scas   %es:(%edi),%al
c010819a:	75 08                	jne    c01081a4 <strcmp+0x2e>
c010819c:	84 c0                	test   %al,%al
c010819e:	75 f8                	jne    c0108198 <strcmp+0x22>
c01081a0:	31 c0                	xor    %eax,%eax
c01081a2:	eb 04                	jmp    c01081a8 <strcmp+0x32>
c01081a4:	19 c0                	sbb    %eax,%eax
c01081a6:	0c 01                	or     $0x1,%al
c01081a8:	89 fa                	mov    %edi,%edx
c01081aa:	89 f1                	mov    %esi,%ecx
c01081ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01081af:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01081b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01081b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01081b8:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01081b9:	83 c4 20             	add    $0x20,%esp
c01081bc:	5e                   	pop    %esi
c01081bd:	5f                   	pop    %edi
c01081be:	5d                   	pop    %ebp
c01081bf:	c3                   	ret    

c01081c0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01081c0:	55                   	push   %ebp
c01081c1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01081c3:	eb 0c                	jmp    c01081d1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01081c5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01081c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01081cd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01081d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01081d5:	74 1a                	je     c01081f1 <strncmp+0x31>
c01081d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01081da:	0f b6 00             	movzbl (%eax),%eax
c01081dd:	84 c0                	test   %al,%al
c01081df:	74 10                	je     c01081f1 <strncmp+0x31>
c01081e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01081e4:	0f b6 10             	movzbl (%eax),%edx
c01081e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081ea:	0f b6 00             	movzbl (%eax),%eax
c01081ed:	38 c2                	cmp    %al,%dl
c01081ef:	74 d4                	je     c01081c5 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01081f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01081f5:	74 18                	je     c010820f <strncmp+0x4f>
c01081f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01081fa:	0f b6 00             	movzbl (%eax),%eax
c01081fd:	0f b6 d0             	movzbl %al,%edx
c0108200:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108203:	0f b6 00             	movzbl (%eax),%eax
c0108206:	0f b6 c0             	movzbl %al,%eax
c0108209:	29 c2                	sub    %eax,%edx
c010820b:	89 d0                	mov    %edx,%eax
c010820d:	eb 05                	jmp    c0108214 <strncmp+0x54>
c010820f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108214:	5d                   	pop    %ebp
c0108215:	c3                   	ret    

c0108216 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108216:	55                   	push   %ebp
c0108217:	89 e5                	mov    %esp,%ebp
c0108219:	83 ec 04             	sub    $0x4,%esp
c010821c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010821f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108222:	eb 14                	jmp    c0108238 <strchr+0x22>
        if (*s == c) {
c0108224:	8b 45 08             	mov    0x8(%ebp),%eax
c0108227:	0f b6 00             	movzbl (%eax),%eax
c010822a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010822d:	75 05                	jne    c0108234 <strchr+0x1e>
            return (char *)s;
c010822f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108232:	eb 13                	jmp    c0108247 <strchr+0x31>
        }
        s ++;
c0108234:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108238:	8b 45 08             	mov    0x8(%ebp),%eax
c010823b:	0f b6 00             	movzbl (%eax),%eax
c010823e:	84 c0                	test   %al,%al
c0108240:	75 e2                	jne    c0108224 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0108242:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108247:	c9                   	leave  
c0108248:	c3                   	ret    

c0108249 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108249:	55                   	push   %ebp
c010824a:	89 e5                	mov    %esp,%ebp
c010824c:	83 ec 04             	sub    $0x4,%esp
c010824f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108252:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108255:	eb 0f                	jmp    c0108266 <strfind+0x1d>
        if (*s == c) {
c0108257:	8b 45 08             	mov    0x8(%ebp),%eax
c010825a:	0f b6 00             	movzbl (%eax),%eax
c010825d:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108260:	74 10                	je     c0108272 <strfind+0x29>
            break;
        }
        s ++;
c0108262:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108266:	8b 45 08             	mov    0x8(%ebp),%eax
c0108269:	0f b6 00             	movzbl (%eax),%eax
c010826c:	84 c0                	test   %al,%al
c010826e:	75 e7                	jne    c0108257 <strfind+0xe>
c0108270:	eb 01                	jmp    c0108273 <strfind+0x2a>
        if (*s == c) {
            break;
c0108272:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0108273:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108276:	c9                   	leave  
c0108277:	c3                   	ret    

c0108278 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108278:	55                   	push   %ebp
c0108279:	89 e5                	mov    %esp,%ebp
c010827b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010827e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0108285:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010828c:	eb 04                	jmp    c0108292 <strtol+0x1a>
        s ++;
c010828e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108292:	8b 45 08             	mov    0x8(%ebp),%eax
c0108295:	0f b6 00             	movzbl (%eax),%eax
c0108298:	3c 20                	cmp    $0x20,%al
c010829a:	74 f2                	je     c010828e <strtol+0x16>
c010829c:	8b 45 08             	mov    0x8(%ebp),%eax
c010829f:	0f b6 00             	movzbl (%eax),%eax
c01082a2:	3c 09                	cmp    $0x9,%al
c01082a4:	74 e8                	je     c010828e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01082a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01082a9:	0f b6 00             	movzbl (%eax),%eax
c01082ac:	3c 2b                	cmp    $0x2b,%al
c01082ae:	75 06                	jne    c01082b6 <strtol+0x3e>
        s ++;
c01082b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01082b4:	eb 15                	jmp    c01082cb <strtol+0x53>
    }
    else if (*s == '-') {
c01082b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01082b9:	0f b6 00             	movzbl (%eax),%eax
c01082bc:	3c 2d                	cmp    $0x2d,%al
c01082be:	75 0b                	jne    c01082cb <strtol+0x53>
        s ++, neg = 1;
c01082c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01082c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01082cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01082cf:	74 06                	je     c01082d7 <strtol+0x5f>
c01082d1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01082d5:	75 24                	jne    c01082fb <strtol+0x83>
c01082d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01082da:	0f b6 00             	movzbl (%eax),%eax
c01082dd:	3c 30                	cmp    $0x30,%al
c01082df:	75 1a                	jne    c01082fb <strtol+0x83>
c01082e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01082e4:	83 c0 01             	add    $0x1,%eax
c01082e7:	0f b6 00             	movzbl (%eax),%eax
c01082ea:	3c 78                	cmp    $0x78,%al
c01082ec:	75 0d                	jne    c01082fb <strtol+0x83>
        s += 2, base = 16;
c01082ee:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01082f2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01082f9:	eb 2a                	jmp    c0108325 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01082fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01082ff:	75 17                	jne    c0108318 <strtol+0xa0>
c0108301:	8b 45 08             	mov    0x8(%ebp),%eax
c0108304:	0f b6 00             	movzbl (%eax),%eax
c0108307:	3c 30                	cmp    $0x30,%al
c0108309:	75 0d                	jne    c0108318 <strtol+0xa0>
        s ++, base = 8;
c010830b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010830f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108316:	eb 0d                	jmp    c0108325 <strtol+0xad>
    }
    else if (base == 0) {
c0108318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010831c:	75 07                	jne    c0108325 <strtol+0xad>
        base = 10;
c010831e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108325:	8b 45 08             	mov    0x8(%ebp),%eax
c0108328:	0f b6 00             	movzbl (%eax),%eax
c010832b:	3c 2f                	cmp    $0x2f,%al
c010832d:	7e 1b                	jle    c010834a <strtol+0xd2>
c010832f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108332:	0f b6 00             	movzbl (%eax),%eax
c0108335:	3c 39                	cmp    $0x39,%al
c0108337:	7f 11                	jg     c010834a <strtol+0xd2>
            dig = *s - '0';
c0108339:	8b 45 08             	mov    0x8(%ebp),%eax
c010833c:	0f b6 00             	movzbl (%eax),%eax
c010833f:	0f be c0             	movsbl %al,%eax
c0108342:	83 e8 30             	sub    $0x30,%eax
c0108345:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108348:	eb 48                	jmp    c0108392 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010834a:	8b 45 08             	mov    0x8(%ebp),%eax
c010834d:	0f b6 00             	movzbl (%eax),%eax
c0108350:	3c 60                	cmp    $0x60,%al
c0108352:	7e 1b                	jle    c010836f <strtol+0xf7>
c0108354:	8b 45 08             	mov    0x8(%ebp),%eax
c0108357:	0f b6 00             	movzbl (%eax),%eax
c010835a:	3c 7a                	cmp    $0x7a,%al
c010835c:	7f 11                	jg     c010836f <strtol+0xf7>
            dig = *s - 'a' + 10;
c010835e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108361:	0f b6 00             	movzbl (%eax),%eax
c0108364:	0f be c0             	movsbl %al,%eax
c0108367:	83 e8 57             	sub    $0x57,%eax
c010836a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010836d:	eb 23                	jmp    c0108392 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010836f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108372:	0f b6 00             	movzbl (%eax),%eax
c0108375:	3c 40                	cmp    $0x40,%al
c0108377:	7e 3c                	jle    c01083b5 <strtol+0x13d>
c0108379:	8b 45 08             	mov    0x8(%ebp),%eax
c010837c:	0f b6 00             	movzbl (%eax),%eax
c010837f:	3c 5a                	cmp    $0x5a,%al
c0108381:	7f 32                	jg     c01083b5 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0108383:	8b 45 08             	mov    0x8(%ebp),%eax
c0108386:	0f b6 00             	movzbl (%eax),%eax
c0108389:	0f be c0             	movsbl %al,%eax
c010838c:	83 e8 37             	sub    $0x37,%eax
c010838f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108392:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108395:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108398:	7d 1a                	jge    c01083b4 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010839a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010839e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01083a1:	0f af 45 10          	imul   0x10(%ebp),%eax
c01083a5:	89 c2                	mov    %eax,%edx
c01083a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083aa:	01 d0                	add    %edx,%eax
c01083ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01083af:	e9 71 ff ff ff       	jmp    c0108325 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c01083b4:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c01083b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01083b9:	74 08                	je     c01083c3 <strtol+0x14b>
        *endptr = (char *) s;
c01083bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083be:	8b 55 08             	mov    0x8(%ebp),%edx
c01083c1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01083c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01083c7:	74 07                	je     c01083d0 <strtol+0x158>
c01083c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01083cc:	f7 d8                	neg    %eax
c01083ce:	eb 03                	jmp    c01083d3 <strtol+0x15b>
c01083d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01083d3:	c9                   	leave  
c01083d4:	c3                   	ret    

c01083d5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01083d5:	55                   	push   %ebp
c01083d6:	89 e5                	mov    %esp,%ebp
c01083d8:	57                   	push   %edi
c01083d9:	83 ec 24             	sub    $0x24,%esp
c01083dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083df:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01083e2:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01083e6:	8b 55 08             	mov    0x8(%ebp),%edx
c01083e9:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01083ec:	88 45 f7             	mov    %al,-0x9(%ebp)
c01083ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01083f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01083f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01083f8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01083fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01083ff:	89 d7                	mov    %edx,%edi
c0108401:	f3 aa                	rep stos %al,%es:(%edi)
c0108403:	89 fa                	mov    %edi,%edx
c0108405:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108408:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010840b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010840e:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010840f:	83 c4 24             	add    $0x24,%esp
c0108412:	5f                   	pop    %edi
c0108413:	5d                   	pop    %ebp
c0108414:	c3                   	ret    

c0108415 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108415:	55                   	push   %ebp
c0108416:	89 e5                	mov    %esp,%ebp
c0108418:	57                   	push   %edi
c0108419:	56                   	push   %esi
c010841a:	53                   	push   %ebx
c010841b:	83 ec 30             	sub    $0x30,%esp
c010841e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108421:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108424:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010842a:	8b 45 10             	mov    0x10(%ebp),%eax
c010842d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108430:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108433:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108436:	73 42                	jae    c010847a <memmove+0x65>
c0108438:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010843b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010843e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108441:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108444:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108447:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010844a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010844d:	c1 e8 02             	shr    $0x2,%eax
c0108450:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108452:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108455:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108458:	89 d7                	mov    %edx,%edi
c010845a:	89 c6                	mov    %eax,%esi
c010845c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010845e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108461:	83 e1 03             	and    $0x3,%ecx
c0108464:	74 02                	je     c0108468 <memmove+0x53>
c0108466:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108468:	89 f0                	mov    %esi,%eax
c010846a:	89 fa                	mov    %edi,%edx
c010846c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010846f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108472:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0108478:	eb 36                	jmp    c01084b0 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010847a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010847d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108480:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108483:	01 c2                	add    %eax,%edx
c0108485:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108488:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010848b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010848e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108491:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108494:	89 c1                	mov    %eax,%ecx
c0108496:	89 d8                	mov    %ebx,%eax
c0108498:	89 d6                	mov    %edx,%esi
c010849a:	89 c7                	mov    %eax,%edi
c010849c:	fd                   	std    
c010849d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010849f:	fc                   	cld    
c01084a0:	89 f8                	mov    %edi,%eax
c01084a2:	89 f2                	mov    %esi,%edx
c01084a4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01084a7:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01084aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01084ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01084b0:	83 c4 30             	add    $0x30,%esp
c01084b3:	5b                   	pop    %ebx
c01084b4:	5e                   	pop    %esi
c01084b5:	5f                   	pop    %edi
c01084b6:	5d                   	pop    %ebp
c01084b7:	c3                   	ret    

c01084b8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01084b8:	55                   	push   %ebp
c01084b9:	89 e5                	mov    %esp,%ebp
c01084bb:	57                   	push   %edi
c01084bc:	56                   	push   %esi
c01084bd:	83 ec 20             	sub    $0x20,%esp
c01084c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01084c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01084c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01084cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01084d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01084d5:	c1 e8 02             	shr    $0x2,%eax
c01084d8:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01084da:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084e0:	89 d7                	mov    %edx,%edi
c01084e2:	89 c6                	mov    %eax,%esi
c01084e4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01084e6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01084e9:	83 e1 03             	and    $0x3,%ecx
c01084ec:	74 02                	je     c01084f0 <memcpy+0x38>
c01084ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01084f0:	89 f0                	mov    %esi,%eax
c01084f2:	89 fa                	mov    %edi,%edx
c01084f4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01084f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01084fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01084fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0108500:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108501:	83 c4 20             	add    $0x20,%esp
c0108504:	5e                   	pop    %esi
c0108505:	5f                   	pop    %edi
c0108506:	5d                   	pop    %ebp
c0108507:	c3                   	ret    

c0108508 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108508:	55                   	push   %ebp
c0108509:	89 e5                	mov    %esp,%ebp
c010850b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010850e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108511:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108514:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108517:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010851a:	eb 30                	jmp    c010854c <memcmp+0x44>
        if (*s1 != *s2) {
c010851c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010851f:	0f b6 10             	movzbl (%eax),%edx
c0108522:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108525:	0f b6 00             	movzbl (%eax),%eax
c0108528:	38 c2                	cmp    %al,%dl
c010852a:	74 18                	je     c0108544 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010852c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010852f:	0f b6 00             	movzbl (%eax),%eax
c0108532:	0f b6 d0             	movzbl %al,%edx
c0108535:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108538:	0f b6 00             	movzbl (%eax),%eax
c010853b:	0f b6 c0             	movzbl %al,%eax
c010853e:	29 c2                	sub    %eax,%edx
c0108540:	89 d0                	mov    %edx,%eax
c0108542:	eb 1a                	jmp    c010855e <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108544:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108548:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010854c:	8b 45 10             	mov    0x10(%ebp),%eax
c010854f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108552:	89 55 10             	mov    %edx,0x10(%ebp)
c0108555:	85 c0                	test   %eax,%eax
c0108557:	75 c3                	jne    c010851c <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108559:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010855e:	c9                   	leave  
c010855f:	c3                   	ret    

c0108560 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0108560:	55                   	push   %ebp
c0108561:	89 e5                	mov    %esp,%ebp
c0108563:	83 ec 38             	sub    $0x38,%esp
c0108566:	8b 45 10             	mov    0x10(%ebp),%eax
c0108569:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010856c:	8b 45 14             	mov    0x14(%ebp),%eax
c010856f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108572:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108575:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108578:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010857b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010857e:	8b 45 18             	mov    0x18(%ebp),%eax
c0108581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108584:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108587:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010858a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010858d:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108590:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108593:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108596:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010859a:	74 1c                	je     c01085b8 <printnum+0x58>
c010859c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010859f:	ba 00 00 00 00       	mov    $0x0,%edx
c01085a4:	f7 75 e4             	divl   -0x1c(%ebp)
c01085a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01085aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085ad:	ba 00 00 00 00       	mov    $0x0,%edx
c01085b2:	f7 75 e4             	divl   -0x1c(%ebp)
c01085b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01085be:	f7 75 e4             	divl   -0x1c(%ebp)
c01085c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01085c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01085c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01085cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01085d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01085d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01085d6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01085d9:	8b 45 18             	mov    0x18(%ebp),%eax
c01085dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01085e1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01085e4:	77 41                	ja     c0108627 <printnum+0xc7>
c01085e6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01085e9:	72 05                	jb     c01085f0 <printnum+0x90>
c01085eb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01085ee:	77 37                	ja     c0108627 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01085f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01085f3:	83 e8 01             	sub    $0x1,%eax
c01085f6:	83 ec 04             	sub    $0x4,%esp
c01085f9:	ff 75 20             	pushl  0x20(%ebp)
c01085fc:	50                   	push   %eax
c01085fd:	ff 75 18             	pushl  0x18(%ebp)
c0108600:	ff 75 ec             	pushl  -0x14(%ebp)
c0108603:	ff 75 e8             	pushl  -0x18(%ebp)
c0108606:	ff 75 0c             	pushl  0xc(%ebp)
c0108609:	ff 75 08             	pushl  0x8(%ebp)
c010860c:	e8 4f ff ff ff       	call   c0108560 <printnum>
c0108611:	83 c4 20             	add    $0x20,%esp
c0108614:	eb 1b                	jmp    c0108631 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108616:	83 ec 08             	sub    $0x8,%esp
c0108619:	ff 75 0c             	pushl  0xc(%ebp)
c010861c:	ff 75 20             	pushl  0x20(%ebp)
c010861f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108622:	ff d0                	call   *%eax
c0108624:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0108627:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010862b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010862f:	7f e5                	jg     c0108616 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0108631:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108634:	05 44 ad 10 c0       	add    $0xc010ad44,%eax
c0108639:	0f b6 00             	movzbl (%eax),%eax
c010863c:	0f be c0             	movsbl %al,%eax
c010863f:	83 ec 08             	sub    $0x8,%esp
c0108642:	ff 75 0c             	pushl  0xc(%ebp)
c0108645:	50                   	push   %eax
c0108646:	8b 45 08             	mov    0x8(%ebp),%eax
c0108649:	ff d0                	call   *%eax
c010864b:	83 c4 10             	add    $0x10,%esp
}
c010864e:	90                   	nop
c010864f:	c9                   	leave  
c0108650:	c3                   	ret    

c0108651 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108651:	55                   	push   %ebp
c0108652:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108654:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108658:	7e 14                	jle    c010866e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010865a:	8b 45 08             	mov    0x8(%ebp),%eax
c010865d:	8b 00                	mov    (%eax),%eax
c010865f:	8d 48 08             	lea    0x8(%eax),%ecx
c0108662:	8b 55 08             	mov    0x8(%ebp),%edx
c0108665:	89 0a                	mov    %ecx,(%edx)
c0108667:	8b 50 04             	mov    0x4(%eax),%edx
c010866a:	8b 00                	mov    (%eax),%eax
c010866c:	eb 30                	jmp    c010869e <getuint+0x4d>
    }
    else if (lflag) {
c010866e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108672:	74 16                	je     c010868a <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108674:	8b 45 08             	mov    0x8(%ebp),%eax
c0108677:	8b 00                	mov    (%eax),%eax
c0108679:	8d 48 04             	lea    0x4(%eax),%ecx
c010867c:	8b 55 08             	mov    0x8(%ebp),%edx
c010867f:	89 0a                	mov    %ecx,(%edx)
c0108681:	8b 00                	mov    (%eax),%eax
c0108683:	ba 00 00 00 00       	mov    $0x0,%edx
c0108688:	eb 14                	jmp    c010869e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010868a:	8b 45 08             	mov    0x8(%ebp),%eax
c010868d:	8b 00                	mov    (%eax),%eax
c010868f:	8d 48 04             	lea    0x4(%eax),%ecx
c0108692:	8b 55 08             	mov    0x8(%ebp),%edx
c0108695:	89 0a                	mov    %ecx,(%edx)
c0108697:	8b 00                	mov    (%eax),%eax
c0108699:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010869e:	5d                   	pop    %ebp
c010869f:	c3                   	ret    

c01086a0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01086a0:	55                   	push   %ebp
c01086a1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01086a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01086a7:	7e 14                	jle    c01086bd <getint+0x1d>
        return va_arg(*ap, long long);
c01086a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ac:	8b 00                	mov    (%eax),%eax
c01086ae:	8d 48 08             	lea    0x8(%eax),%ecx
c01086b1:	8b 55 08             	mov    0x8(%ebp),%edx
c01086b4:	89 0a                	mov    %ecx,(%edx)
c01086b6:	8b 50 04             	mov    0x4(%eax),%edx
c01086b9:	8b 00                	mov    (%eax),%eax
c01086bb:	eb 28                	jmp    c01086e5 <getint+0x45>
    }
    else if (lflag) {
c01086bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01086c1:	74 12                	je     c01086d5 <getint+0x35>
        return va_arg(*ap, long);
c01086c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01086c6:	8b 00                	mov    (%eax),%eax
c01086c8:	8d 48 04             	lea    0x4(%eax),%ecx
c01086cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01086ce:	89 0a                	mov    %ecx,(%edx)
c01086d0:	8b 00                	mov    (%eax),%eax
c01086d2:	99                   	cltd   
c01086d3:	eb 10                	jmp    c01086e5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01086d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01086d8:	8b 00                	mov    (%eax),%eax
c01086da:	8d 48 04             	lea    0x4(%eax),%ecx
c01086dd:	8b 55 08             	mov    0x8(%ebp),%edx
c01086e0:	89 0a                	mov    %ecx,(%edx)
c01086e2:	8b 00                	mov    (%eax),%eax
c01086e4:	99                   	cltd   
    }
}
c01086e5:	5d                   	pop    %ebp
c01086e6:	c3                   	ret    

c01086e7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01086e7:	55                   	push   %ebp
c01086e8:	89 e5                	mov    %esp,%ebp
c01086ea:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01086ed:	8d 45 14             	lea    0x14(%ebp),%eax
c01086f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01086f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086f6:	50                   	push   %eax
c01086f7:	ff 75 10             	pushl  0x10(%ebp)
c01086fa:	ff 75 0c             	pushl  0xc(%ebp)
c01086fd:	ff 75 08             	pushl  0x8(%ebp)
c0108700:	e8 06 00 00 00       	call   c010870b <vprintfmt>
c0108705:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0108708:	90                   	nop
c0108709:	c9                   	leave  
c010870a:	c3                   	ret    

c010870b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010870b:	55                   	push   %ebp
c010870c:	89 e5                	mov    %esp,%ebp
c010870e:	56                   	push   %esi
c010870f:	53                   	push   %ebx
c0108710:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108713:	eb 17                	jmp    c010872c <vprintfmt+0x21>
            if (ch == '\0') {
c0108715:	85 db                	test   %ebx,%ebx
c0108717:	0f 84 8e 03 00 00    	je     c0108aab <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c010871d:	83 ec 08             	sub    $0x8,%esp
c0108720:	ff 75 0c             	pushl  0xc(%ebp)
c0108723:	53                   	push   %ebx
c0108724:	8b 45 08             	mov    0x8(%ebp),%eax
c0108727:	ff d0                	call   *%eax
c0108729:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010872c:	8b 45 10             	mov    0x10(%ebp),%eax
c010872f:	8d 50 01             	lea    0x1(%eax),%edx
c0108732:	89 55 10             	mov    %edx,0x10(%ebp)
c0108735:	0f b6 00             	movzbl (%eax),%eax
c0108738:	0f b6 d8             	movzbl %al,%ebx
c010873b:	83 fb 25             	cmp    $0x25,%ebx
c010873e:	75 d5                	jne    c0108715 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108740:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108744:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010874b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010874e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108751:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108758:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010875b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010875e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108761:	8d 50 01             	lea    0x1(%eax),%edx
c0108764:	89 55 10             	mov    %edx,0x10(%ebp)
c0108767:	0f b6 00             	movzbl (%eax),%eax
c010876a:	0f b6 d8             	movzbl %al,%ebx
c010876d:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108770:	83 f8 55             	cmp    $0x55,%eax
c0108773:	0f 87 05 03 00 00    	ja     c0108a7e <vprintfmt+0x373>
c0108779:	8b 04 85 68 ad 10 c0 	mov    -0x3fef5298(,%eax,4),%eax
c0108780:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108782:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108786:	eb d6                	jmp    c010875e <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108788:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010878c:	eb d0                	jmp    c010875e <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010878e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108795:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108798:	89 d0                	mov    %edx,%eax
c010879a:	c1 e0 02             	shl    $0x2,%eax
c010879d:	01 d0                	add    %edx,%eax
c010879f:	01 c0                	add    %eax,%eax
c01087a1:	01 d8                	add    %ebx,%eax
c01087a3:	83 e8 30             	sub    $0x30,%eax
c01087a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01087a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01087ac:	0f b6 00             	movzbl (%eax),%eax
c01087af:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01087b2:	83 fb 2f             	cmp    $0x2f,%ebx
c01087b5:	7e 39                	jle    c01087f0 <vprintfmt+0xe5>
c01087b7:	83 fb 39             	cmp    $0x39,%ebx
c01087ba:	7f 34                	jg     c01087f0 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01087bc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01087c0:	eb d3                	jmp    c0108795 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01087c2:	8b 45 14             	mov    0x14(%ebp),%eax
c01087c5:	8d 50 04             	lea    0x4(%eax),%edx
c01087c8:	89 55 14             	mov    %edx,0x14(%ebp)
c01087cb:	8b 00                	mov    (%eax),%eax
c01087cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01087d0:	eb 1f                	jmp    c01087f1 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01087d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01087d6:	79 86                	jns    c010875e <vprintfmt+0x53>
                width = 0;
c01087d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01087df:	e9 7a ff ff ff       	jmp    c010875e <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01087e4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01087eb:	e9 6e ff ff ff       	jmp    c010875e <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01087f0:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01087f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01087f5:	0f 89 63 ff ff ff    	jns    c010875e <vprintfmt+0x53>
                width = precision, precision = -1;
c01087fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01087fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108801:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108808:	e9 51 ff ff ff       	jmp    c010875e <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010880d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0108811:	e9 48 ff ff ff       	jmp    c010875e <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108816:	8b 45 14             	mov    0x14(%ebp),%eax
c0108819:	8d 50 04             	lea    0x4(%eax),%edx
c010881c:	89 55 14             	mov    %edx,0x14(%ebp)
c010881f:	8b 00                	mov    (%eax),%eax
c0108821:	83 ec 08             	sub    $0x8,%esp
c0108824:	ff 75 0c             	pushl  0xc(%ebp)
c0108827:	50                   	push   %eax
c0108828:	8b 45 08             	mov    0x8(%ebp),%eax
c010882b:	ff d0                	call   *%eax
c010882d:	83 c4 10             	add    $0x10,%esp
            break;
c0108830:	e9 71 02 00 00       	jmp    c0108aa6 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108835:	8b 45 14             	mov    0x14(%ebp),%eax
c0108838:	8d 50 04             	lea    0x4(%eax),%edx
c010883b:	89 55 14             	mov    %edx,0x14(%ebp)
c010883e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108840:	85 db                	test   %ebx,%ebx
c0108842:	79 02                	jns    c0108846 <vprintfmt+0x13b>
                err = -err;
c0108844:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108846:	83 fb 06             	cmp    $0x6,%ebx
c0108849:	7f 0b                	jg     c0108856 <vprintfmt+0x14b>
c010884b:	8b 34 9d 28 ad 10 c0 	mov    -0x3fef52d8(,%ebx,4),%esi
c0108852:	85 f6                	test   %esi,%esi
c0108854:	75 19                	jne    c010886f <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0108856:	53                   	push   %ebx
c0108857:	68 55 ad 10 c0       	push   $0xc010ad55
c010885c:	ff 75 0c             	pushl  0xc(%ebp)
c010885f:	ff 75 08             	pushl  0x8(%ebp)
c0108862:	e8 80 fe ff ff       	call   c01086e7 <printfmt>
c0108867:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010886a:	e9 37 02 00 00       	jmp    c0108aa6 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010886f:	56                   	push   %esi
c0108870:	68 5e ad 10 c0       	push   $0xc010ad5e
c0108875:	ff 75 0c             	pushl  0xc(%ebp)
c0108878:	ff 75 08             	pushl  0x8(%ebp)
c010887b:	e8 67 fe ff ff       	call   c01086e7 <printfmt>
c0108880:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0108883:	e9 1e 02 00 00       	jmp    c0108aa6 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108888:	8b 45 14             	mov    0x14(%ebp),%eax
c010888b:	8d 50 04             	lea    0x4(%eax),%edx
c010888e:	89 55 14             	mov    %edx,0x14(%ebp)
c0108891:	8b 30                	mov    (%eax),%esi
c0108893:	85 f6                	test   %esi,%esi
c0108895:	75 05                	jne    c010889c <vprintfmt+0x191>
                p = "(null)";
c0108897:	be 61 ad 10 c0       	mov    $0xc010ad61,%esi
            }
            if (width > 0 && padc != '-') {
c010889c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01088a0:	7e 76                	jle    c0108918 <vprintfmt+0x20d>
c01088a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01088a6:	74 70                	je     c0108918 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01088a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088ab:	83 ec 08             	sub    $0x8,%esp
c01088ae:	50                   	push   %eax
c01088af:	56                   	push   %esi
c01088b0:	e8 17 f8 ff ff       	call   c01080cc <strnlen>
c01088b5:	83 c4 10             	add    $0x10,%esp
c01088b8:	89 c2                	mov    %eax,%edx
c01088ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088bd:	29 d0                	sub    %edx,%eax
c01088bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01088c2:	eb 17                	jmp    c01088db <vprintfmt+0x1d0>
                    putch(padc, putdat);
c01088c4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01088c8:	83 ec 08             	sub    $0x8,%esp
c01088cb:	ff 75 0c             	pushl  0xc(%ebp)
c01088ce:	50                   	push   %eax
c01088cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d2:	ff d0                	call   *%eax
c01088d4:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01088d7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01088db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01088df:	7f e3                	jg     c01088c4 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01088e1:	eb 35                	jmp    c0108918 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c01088e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01088e7:	74 1c                	je     c0108905 <vprintfmt+0x1fa>
c01088e9:	83 fb 1f             	cmp    $0x1f,%ebx
c01088ec:	7e 05                	jle    c01088f3 <vprintfmt+0x1e8>
c01088ee:	83 fb 7e             	cmp    $0x7e,%ebx
c01088f1:	7e 12                	jle    c0108905 <vprintfmt+0x1fa>
                    putch('?', putdat);
c01088f3:	83 ec 08             	sub    $0x8,%esp
c01088f6:	ff 75 0c             	pushl  0xc(%ebp)
c01088f9:	6a 3f                	push   $0x3f
c01088fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01088fe:	ff d0                	call   *%eax
c0108900:	83 c4 10             	add    $0x10,%esp
c0108903:	eb 0f                	jmp    c0108914 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0108905:	83 ec 08             	sub    $0x8,%esp
c0108908:	ff 75 0c             	pushl  0xc(%ebp)
c010890b:	53                   	push   %ebx
c010890c:	8b 45 08             	mov    0x8(%ebp),%eax
c010890f:	ff d0                	call   *%eax
c0108911:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108914:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108918:	89 f0                	mov    %esi,%eax
c010891a:	8d 70 01             	lea    0x1(%eax),%esi
c010891d:	0f b6 00             	movzbl (%eax),%eax
c0108920:	0f be d8             	movsbl %al,%ebx
c0108923:	85 db                	test   %ebx,%ebx
c0108925:	74 26                	je     c010894d <vprintfmt+0x242>
c0108927:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010892b:	78 b6                	js     c01088e3 <vprintfmt+0x1d8>
c010892d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108931:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108935:	79 ac                	jns    c01088e3 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108937:	eb 14                	jmp    c010894d <vprintfmt+0x242>
                putch(' ', putdat);
c0108939:	83 ec 08             	sub    $0x8,%esp
c010893c:	ff 75 0c             	pushl  0xc(%ebp)
c010893f:	6a 20                	push   $0x20
c0108941:	8b 45 08             	mov    0x8(%ebp),%eax
c0108944:	ff d0                	call   *%eax
c0108946:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108949:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010894d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108951:	7f e6                	jg     c0108939 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0108953:	e9 4e 01 00 00       	jmp    c0108aa6 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108958:	83 ec 08             	sub    $0x8,%esp
c010895b:	ff 75 e0             	pushl  -0x20(%ebp)
c010895e:	8d 45 14             	lea    0x14(%ebp),%eax
c0108961:	50                   	push   %eax
c0108962:	e8 39 fd ff ff       	call   c01086a0 <getint>
c0108967:	83 c4 10             	add    $0x10,%esp
c010896a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010896d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108970:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108973:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108976:	85 d2                	test   %edx,%edx
c0108978:	79 23                	jns    c010899d <vprintfmt+0x292>
                putch('-', putdat);
c010897a:	83 ec 08             	sub    $0x8,%esp
c010897d:	ff 75 0c             	pushl  0xc(%ebp)
c0108980:	6a 2d                	push   $0x2d
c0108982:	8b 45 08             	mov    0x8(%ebp),%eax
c0108985:	ff d0                	call   *%eax
c0108987:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c010898a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010898d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108990:	f7 d8                	neg    %eax
c0108992:	83 d2 00             	adc    $0x0,%edx
c0108995:	f7 da                	neg    %edx
c0108997:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010899a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010899d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01089a4:	e9 9f 00 00 00       	jmp    c0108a48 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01089a9:	83 ec 08             	sub    $0x8,%esp
c01089ac:	ff 75 e0             	pushl  -0x20(%ebp)
c01089af:	8d 45 14             	lea    0x14(%ebp),%eax
c01089b2:	50                   	push   %eax
c01089b3:	e8 99 fc ff ff       	call   c0108651 <getuint>
c01089b8:	83 c4 10             	add    $0x10,%esp
c01089bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089be:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01089c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01089c8:	eb 7e                	jmp    c0108a48 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01089ca:	83 ec 08             	sub    $0x8,%esp
c01089cd:	ff 75 e0             	pushl  -0x20(%ebp)
c01089d0:	8d 45 14             	lea    0x14(%ebp),%eax
c01089d3:	50                   	push   %eax
c01089d4:	e8 78 fc ff ff       	call   c0108651 <getuint>
c01089d9:	83 c4 10             	add    $0x10,%esp
c01089dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089df:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01089e2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01089e9:	eb 5d                	jmp    c0108a48 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c01089eb:	83 ec 08             	sub    $0x8,%esp
c01089ee:	ff 75 0c             	pushl  0xc(%ebp)
c01089f1:	6a 30                	push   $0x30
c01089f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f6:	ff d0                	call   *%eax
c01089f8:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c01089fb:	83 ec 08             	sub    $0x8,%esp
c01089fe:	ff 75 0c             	pushl  0xc(%ebp)
c0108a01:	6a 78                	push   $0x78
c0108a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a06:	ff d0                	call   *%eax
c0108a08:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108a0b:	8b 45 14             	mov    0x14(%ebp),%eax
c0108a0e:	8d 50 04             	lea    0x4(%eax),%edx
c0108a11:	89 55 14             	mov    %edx,0x14(%ebp)
c0108a14:	8b 00                	mov    (%eax),%eax
c0108a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108a20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108a27:	eb 1f                	jmp    c0108a48 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108a29:	83 ec 08             	sub    $0x8,%esp
c0108a2c:	ff 75 e0             	pushl  -0x20(%ebp)
c0108a2f:	8d 45 14             	lea    0x14(%ebp),%eax
c0108a32:	50                   	push   %eax
c0108a33:	e8 19 fc ff ff       	call   c0108651 <getuint>
c0108a38:	83 c4 10             	add    $0x10,%esp
c0108a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108a41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108a48:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a4f:	83 ec 04             	sub    $0x4,%esp
c0108a52:	52                   	push   %edx
c0108a53:	ff 75 e8             	pushl  -0x18(%ebp)
c0108a56:	50                   	push   %eax
c0108a57:	ff 75 f4             	pushl  -0xc(%ebp)
c0108a5a:	ff 75 f0             	pushl  -0x10(%ebp)
c0108a5d:	ff 75 0c             	pushl  0xc(%ebp)
c0108a60:	ff 75 08             	pushl  0x8(%ebp)
c0108a63:	e8 f8 fa ff ff       	call   c0108560 <printnum>
c0108a68:	83 c4 20             	add    $0x20,%esp
            break;
c0108a6b:	eb 39                	jmp    c0108aa6 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108a6d:	83 ec 08             	sub    $0x8,%esp
c0108a70:	ff 75 0c             	pushl  0xc(%ebp)
c0108a73:	53                   	push   %ebx
c0108a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a77:	ff d0                	call   *%eax
c0108a79:	83 c4 10             	add    $0x10,%esp
            break;
c0108a7c:	eb 28                	jmp    c0108aa6 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108a7e:	83 ec 08             	sub    $0x8,%esp
c0108a81:	ff 75 0c             	pushl  0xc(%ebp)
c0108a84:	6a 25                	push   $0x25
c0108a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a89:	ff d0                	call   *%eax
c0108a8b:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108a8e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108a92:	eb 04                	jmp    c0108a98 <vprintfmt+0x38d>
c0108a94:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108a98:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a9b:	83 e8 01             	sub    $0x1,%eax
c0108a9e:	0f b6 00             	movzbl (%eax),%eax
c0108aa1:	3c 25                	cmp    $0x25,%al
c0108aa3:	75 ef                	jne    c0108a94 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0108aa5:	90                   	nop
        }
    }
c0108aa6:	e9 68 fc ff ff       	jmp    c0108713 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0108aab:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0108aaf:	5b                   	pop    %ebx
c0108ab0:	5e                   	pop    %esi
c0108ab1:	5d                   	pop    %ebp
c0108ab2:	c3                   	ret    

c0108ab3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108ab3:	55                   	push   %ebp
c0108ab4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0108ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ab9:	8b 40 08             	mov    0x8(%eax),%eax
c0108abc:	8d 50 01             	lea    0x1(%eax),%edx
c0108abf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ac2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0108ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ac8:	8b 10                	mov    (%eax),%edx
c0108aca:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108acd:	8b 40 04             	mov    0x4(%eax),%eax
c0108ad0:	39 c2                	cmp    %eax,%edx
c0108ad2:	73 12                	jae    c0108ae6 <sprintputch+0x33>
        *b->buf ++ = ch;
c0108ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ad7:	8b 00                	mov    (%eax),%eax
c0108ad9:	8d 48 01             	lea    0x1(%eax),%ecx
c0108adc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108adf:	89 0a                	mov    %ecx,(%edx)
c0108ae1:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ae4:	88 10                	mov    %dl,(%eax)
    }
}
c0108ae6:	90                   	nop
c0108ae7:	5d                   	pop    %ebp
c0108ae8:	c3                   	ret    

c0108ae9 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108ae9:	55                   	push   %ebp
c0108aea:	89 e5                	mov    %esp,%ebp
c0108aec:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108aef:	8d 45 14             	lea    0x14(%ebp),%eax
c0108af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0108af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108af8:	50                   	push   %eax
c0108af9:	ff 75 10             	pushl  0x10(%ebp)
c0108afc:	ff 75 0c             	pushl  0xc(%ebp)
c0108aff:	ff 75 08             	pushl  0x8(%ebp)
c0108b02:	e8 0b 00 00 00       	call   c0108b12 <vsnprintf>
c0108b07:	83 c4 10             	add    $0x10,%esp
c0108b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108b10:	c9                   	leave  
c0108b11:	c3                   	ret    

c0108b12 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108b12:	55                   	push   %ebp
c0108b13:	89 e5                	mov    %esp,%ebp
c0108b15:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b21:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b27:	01 d0                	add    %edx,%eax
c0108b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108b33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108b37:	74 0a                	je     c0108b43 <vsnprintf+0x31>
c0108b39:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b3f:	39 c2                	cmp    %eax,%edx
c0108b41:	76 07                	jbe    c0108b4a <vsnprintf+0x38>
        return -E_INVAL;
c0108b43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108b48:	eb 20                	jmp    c0108b6a <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108b4a:	ff 75 14             	pushl  0x14(%ebp)
c0108b4d:	ff 75 10             	pushl  0x10(%ebp)
c0108b50:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0108b53:	50                   	push   %eax
c0108b54:	68 b3 8a 10 c0       	push   $0xc0108ab3
c0108b59:	e8 ad fb ff ff       	call   c010870b <vprintfmt>
c0108b5e:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0108b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b64:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108b6a:	c9                   	leave  
c0108b6b:	c3                   	ret    

c0108b6c <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108b6c:	55                   	push   %ebp
c0108b6d:	89 e5                	mov    %esp,%ebp
c0108b6f:	57                   	push   %edi
c0108b70:	56                   	push   %esi
c0108b71:	53                   	push   %ebx
c0108b72:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108b75:	a1 98 1a 12 c0       	mov    0xc0121a98,%eax
c0108b7a:	8b 15 9c 1a 12 c0    	mov    0xc0121a9c,%edx
c0108b80:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108b86:	6b f0 05             	imul   $0x5,%eax,%esi
c0108b89:	01 fe                	add    %edi,%esi
c0108b8b:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0108b90:	f7 e7                	mul    %edi
c0108b92:	01 d6                	add    %edx,%esi
c0108b94:	89 f2                	mov    %esi,%edx
c0108b96:	83 c0 0b             	add    $0xb,%eax
c0108b99:	83 d2 00             	adc    $0x0,%edx
c0108b9c:	89 c7                	mov    %eax,%edi
c0108b9e:	83 e7 ff             	and    $0xffffffff,%edi
c0108ba1:	89 f9                	mov    %edi,%ecx
c0108ba3:	0f b7 da             	movzwl %dx,%ebx
c0108ba6:	89 0d 98 1a 12 c0    	mov    %ecx,0xc0121a98
c0108bac:	89 1d 9c 1a 12 c0    	mov    %ebx,0xc0121a9c
    unsigned long long result = (next >> 12);
c0108bb2:	a1 98 1a 12 c0       	mov    0xc0121a98,%eax
c0108bb7:	8b 15 9c 1a 12 c0    	mov    0xc0121a9c,%edx
c0108bbd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0108bc1:	c1 ea 0c             	shr    $0xc,%edx
c0108bc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108bc7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108bca:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0108bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108bd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108bda:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108be3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108be7:	74 1c                	je     c0108c05 <rand+0x99>
c0108be9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bec:	ba 00 00 00 00       	mov    $0x0,%edx
c0108bf1:	f7 75 dc             	divl   -0x24(%ebp)
c0108bf4:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bfa:	ba 00 00 00 00       	mov    $0x0,%edx
c0108bff:	f7 75 dc             	divl   -0x24(%ebp)
c0108c02:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108c05:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108c0b:	f7 75 dc             	divl   -0x24(%ebp)
c0108c0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108c11:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108c14:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c17:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108c1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108c1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108c20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108c23:	83 c4 24             	add    $0x24,%esp
c0108c26:	5b                   	pop    %ebx
c0108c27:	5e                   	pop    %esi
c0108c28:	5f                   	pop    %edi
c0108c29:	5d                   	pop    %ebp
c0108c2a:	c3                   	ret    

c0108c2b <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108c2b:	55                   	push   %ebp
c0108c2c:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c31:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c36:	a3 98 1a 12 c0       	mov    %eax,0xc0121a98
c0108c3b:	89 15 9c 1a 12 c0    	mov    %edx,0xc0121a9c
}
c0108c41:	90                   	nop
c0108c42:	5d                   	pop    %ebp
c0108c43:	c3                   	ret    
