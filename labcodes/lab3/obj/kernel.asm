
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 00 12 00       	mov    $0x120000,%eax
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
c0100020:	a3 00 00 12 c0       	mov    %eax,0xc0120000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 f0 11 c0       	mov    $0xc011f000,%esp
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
c010003c:	ba 5c 31 12 c0       	mov    $0xc012315c,%edx
c0100041:	b8 00 20 12 c0       	mov    $0xc0122000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	83 ec 04             	sub    $0x4,%esp
c010004d:	50                   	push   %eax
c010004e:	6a 00                	push   $0x0
c0100050:	68 00 20 12 c0       	push   $0xc0122000
c0100055:	e8 85 7a 00 00       	call   c0107adf <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 ab 1d 00 00       	call   c0101e0d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 60 83 10 c0 	movl   $0xc0108360,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 7c 83 10 c0       	push   $0xc010837c
c0100074:	e8 11 02 00 00       	call   c010028a <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 93 08 00 00       	call   c0100914 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 83 00 00 00       	call   c0100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 22 65 00 00       	call   c01065ad <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 ef 1e 00 00       	call   c0101f7f <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 71 20 00 00       	call   c0102106 <idt_init>

    vmm_init();                 // init virtual memory management
c0100095:	e8 2b 36 00 00       	call   c01036c5 <vmm_init>

    ide_init();                 // init ide devices
c010009a:	e8 3d 0d 00 00       	call   c0100ddc <ide_init>
    swap_init();                // init swap
c010009f:	e8 2e 42 00 00       	call   c01042d2 <swap_init>

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
c0100148:	a1 00 20 12 c0       	mov    0xc0122000,%eax
c010014d:	83 ec 04             	sub    $0x4,%esp
c0100150:	52                   	push   %edx
c0100151:	50                   	push   %eax
c0100152:	68 81 83 10 c0       	push   $0xc0108381
c0100157:	e8 2e 01 00 00       	call   c010028a <cprintf>
c010015c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010015f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100163:	0f b7 d0             	movzwl %ax,%edx
c0100166:	a1 00 20 12 c0       	mov    0xc0122000,%eax
c010016b:	83 ec 04             	sub    $0x4,%esp
c010016e:	52                   	push   %edx
c010016f:	50                   	push   %eax
c0100170:	68 8f 83 10 c0       	push   $0xc010838f
c0100175:	e8 10 01 00 00       	call   c010028a <cprintf>
c010017a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010017d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100181:	0f b7 d0             	movzwl %ax,%edx
c0100184:	a1 00 20 12 c0       	mov    0xc0122000,%eax
c0100189:	83 ec 04             	sub    $0x4,%esp
c010018c:	52                   	push   %edx
c010018d:	50                   	push   %eax
c010018e:	68 9d 83 10 c0       	push   $0xc010839d
c0100193:	e8 f2 00 00 00       	call   c010028a <cprintf>
c0100198:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c010019b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010019f:	0f b7 d0             	movzwl %ax,%edx
c01001a2:	a1 00 20 12 c0       	mov    0xc0122000,%eax
c01001a7:	83 ec 04             	sub    $0x4,%esp
c01001aa:	52                   	push   %edx
c01001ab:	50                   	push   %eax
c01001ac:	68 ab 83 10 c0       	push   $0xc01083ab
c01001b1:	e8 d4 00 00 00       	call   c010028a <cprintf>
c01001b6:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001b9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001bd:	0f b7 d0             	movzwl %ax,%edx
c01001c0:	a1 00 20 12 c0       	mov    0xc0122000,%eax
c01001c5:	83 ec 04             	sub    $0x4,%esp
c01001c8:	52                   	push   %edx
c01001c9:	50                   	push   %eax
c01001ca:	68 b9 83 10 c0       	push   $0xc01083b9
c01001cf:	e8 b6 00 00 00       	call   c010028a <cprintf>
c01001d4:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001d7:	a1 00 20 12 c0       	mov    0xc0122000,%eax
c01001dc:	83 c0 01             	add    $0x1,%eax
c01001df:	a3 00 20 12 c0       	mov    %eax,0xc0122000
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
c0100209:	68 c8 83 10 c0       	push   $0xc01083c8
c010020e:	e8 77 00 00 00       	call   c010028a <cprintf>
c0100213:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c0100216:	e8 cc ff ff ff       	call   c01001e7 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021b:	e8 0a ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	68 e8 83 10 c0       	push   $0xc01083e8
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
c010027d:	e8 93 7b 00 00       	call   c0107e15 <vprintfmt>
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
c0100340:	68 07 84 10 c0       	push   $0xc0108407
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
c0100395:	88 90 20 20 12 c0    	mov    %dl,-0x3feddfe0(%eax)
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
c01003da:	05 20 20 12 c0       	add    $0xc0122020,%eax
c01003df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003e2:	b8 20 20 12 c0       	mov    $0xc0122020,%eax
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
c01003f6:	a1 20 24 12 c0       	mov    0xc0122420,%eax
c01003fb:	85 c0                	test   %eax,%eax
c01003fd:	75 4a                	jne    c0100449 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003ff:	c7 05 20 24 12 c0 01 	movl   $0x1,0xc0122420
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
c0100418:	68 0a 84 10 c0       	push   $0xc010840a
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
c010043a:	68 26 84 10 c0       	push   $0xc0108426
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
c0100473:	68 28 84 10 c0       	push   $0xc0108428
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
c0100495:	68 26 84 10 c0       	push   $0xc0108426
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
c01004a8:	a1 20 24 12 c0       	mov    0xc0122420,%eax
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
c010060f:	c7 00 48 84 10 c0    	movl   $0xc0108448,(%eax)
    info->eip_line = 0;
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100622:	c7 40 08 48 84 10 c0 	movl   $0xc0108448,0x8(%eax)
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
c0100646:	c7 45 f4 cc a2 10 c0 	movl   $0xc010a2cc,-0xc(%ebp)
    stab_end = __STAB_END__;
c010064d:	c7 45 f0 f4 94 11 c0 	movl   $0xc01194f4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100654:	c7 45 ec f5 94 11 c0 	movl   $0xc01194f5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010065b:	c7 45 e8 7b ce 11 c0 	movl   $0xc011ce7b,-0x18(%ebp)

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
c0100795:	e8 b9 71 00 00       	call   c0107953 <strfind>
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
c010091d:	68 52 84 10 c0       	push   $0xc0108452
c0100922:	e8 63 f9 ff ff       	call   c010028a <cprintf>
c0100927:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010092a:	83 ec 08             	sub    $0x8,%esp
c010092d:	68 36 00 10 c0       	push   $0xc0100036
c0100932:	68 6b 84 10 c0       	push   $0xc010846b
c0100937:	e8 4e f9 ff ff       	call   c010028a <cprintf>
c010093c:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010093f:	83 ec 08             	sub    $0x8,%esp
c0100942:	68 4e 83 10 c0       	push   $0xc010834e
c0100947:	68 83 84 10 c0       	push   $0xc0108483
c010094c:	e8 39 f9 ff ff       	call   c010028a <cprintf>
c0100951:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100954:	83 ec 08             	sub    $0x8,%esp
c0100957:	68 00 20 12 c0       	push   $0xc0122000
c010095c:	68 9b 84 10 c0       	push   $0xc010849b
c0100961:	e8 24 f9 ff ff       	call   c010028a <cprintf>
c0100966:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100969:	83 ec 08             	sub    $0x8,%esp
c010096c:	68 5c 31 12 c0       	push   $0xc012315c
c0100971:	68 b3 84 10 c0       	push   $0xc01084b3
c0100976:	e8 0f f9 ff ff       	call   c010028a <cprintf>
c010097b:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010097e:	b8 5c 31 12 c0       	mov    $0xc012315c,%eax
c0100983:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100988:	ba 36 00 10 c0       	mov    $0xc0100036,%edx
c010098d:	29 d0                	sub    %edx,%eax
c010098f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100995:	85 c0                	test   %eax,%eax
c0100997:	0f 48 c2             	cmovs  %edx,%eax
c010099a:	c1 f8 0a             	sar    $0xa,%eax
c010099d:	83 ec 08             	sub    $0x8,%esp
c01009a0:	50                   	push   %eax
c01009a1:	68 cc 84 10 c0       	push   $0xc01084cc
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
c01009d6:	68 f6 84 10 c0       	push   $0xc01084f6
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
c0100a3d:	68 12 85 10 c0       	push   $0xc0108512
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
c0100a8d:	68 24 85 10 c0       	push   $0xc0108524
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
c0100adb:	68 3c 85 10 c0       	push   $0xc010853c
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
c0100b5c:	68 e0 85 10 c0       	push   $0xc01085e0
c0100b61:	e8 ba 6d 00 00       	call   c0107920 <strchr>
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
c0100b82:	68 e5 85 10 c0       	push   $0xc01085e5
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
c0100bca:	68 e0 85 10 c0       	push   $0xc01085e0
c0100bcf:	e8 4c 6d 00 00       	call   c0107920 <strchr>
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
c0100c29:	05 00 f0 11 c0       	add    $0xc011f000,%eax
c0100c2e:	8b 00                	mov    (%eax),%eax
c0100c30:	83 ec 08             	sub    $0x8,%esp
c0100c33:	51                   	push   %ecx
c0100c34:	50                   	push   %eax
c0100c35:	e8 46 6c 00 00       	call   c0107880 <strcmp>
c0100c3a:	83 c4 10             	add    $0x10,%esp
c0100c3d:	85 c0                	test   %eax,%eax
c0100c3f:	75 2e                	jne    c0100c6f <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c44:	89 d0                	mov    %edx,%eax
c0100c46:	01 c0                	add    %eax,%eax
c0100c48:	01 d0                	add    %edx,%eax
c0100c4a:	c1 e0 02             	shl    $0x2,%eax
c0100c4d:	05 08 f0 11 c0       	add    $0xc011f008,%eax
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
c0100c82:	68 03 86 10 c0       	push   $0xc0108603
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
c0100c9f:	68 1c 86 10 c0       	push   $0xc010861c
c0100ca4:	e8 e1 f5 ff ff       	call   c010028a <cprintf>
c0100ca9:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100cac:	83 ec 0c             	sub    $0xc,%esp
c0100caf:	68 44 86 10 c0       	push   $0xc0108644
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
c0100cd3:	68 69 86 10 c0       	push   $0xc0108669
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
c0100d1f:	05 04 f0 11 c0       	add    $0xc011f004,%eax
c0100d24:	8b 08                	mov    (%eax),%ecx
c0100d26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d29:	89 d0                	mov    %edx,%eax
c0100d2b:	01 c0                	add    %eax,%eax
c0100d2d:	01 d0                	add    %edx,%eax
c0100d2f:	c1 e0 02             	shl    $0x2,%eax
c0100d32:	05 00 f0 11 c0       	add    $0xc011f000,%eax
c0100d37:	8b 00                	mov    (%eax),%eax
c0100d39:	83 ec 04             	sub    $0x4,%esp
c0100d3c:	51                   	push   %ecx
c0100d3d:	50                   	push   %eax
c0100d3e:	68 6d 86 10 c0       	push   $0xc010866d
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
c0100e04:	05 40 24 12 c0       	add    $0xc0122440,%eax
c0100e09:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e0c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e10:	66 d1 e8             	shr    %ax
c0100e13:	0f b7 c0             	movzwl %ax,%eax
c0100e16:	0f b7 04 85 78 86 10 	movzwl -0x3fef7988(,%eax,4),%eax
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
c0100ee1:	05 40 24 12 c0       	add    $0xc0122440,%eax
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
c0100f66:	8d 90 44 24 12 c0    	lea    -0x3feddbbc(%eax),%edx
c0100f6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f6f:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100f71:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f75:	c1 e0 03             	shl    $0x3,%eax
c0100f78:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f7f:	29 c2                	sub    %eax,%edx
c0100f81:	89 d0                	mov    %edx,%eax
c0100f83:	8d 90 48 24 12 c0    	lea    -0x3feddbb8(%eax),%edx
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
c0100fa3:	68 80 86 10 c0       	push   $0xc0108680
c0100fa8:	68 c3 86 10 c0       	push   $0xc01086c3
c0100fad:	6a 7d                	push   $0x7d
c0100faf:	68 d8 86 10 c0       	push   $0xc01086d8
c0100fb4:	e8 37 f4 ff ff       	call   c01003f0 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0100fb9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fbd:	89 c2                	mov    %eax,%edx
c0100fbf:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fc6:	89 c2                	mov    %eax,%edx
c0100fc8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
c0100fcf:	29 d0                	sub    %edx,%eax
c0100fd1:	05 40 24 12 c0       	add    $0xc0122440,%eax
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
c0101070:	05 40 24 12 c0       	add    $0xc0122440,%eax
c0101075:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101078:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010107c:	c1 e0 03             	shl    $0x3,%eax
c010107f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101086:	29 c2                	sub    %eax,%edx
c0101088:	89 d0                	mov    %edx,%eax
c010108a:	05 48 24 12 c0       	add    $0xc0122448,%eax
c010108f:	8b 10                	mov    (%eax),%edx
c0101091:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101095:	51                   	push   %ecx
c0101096:	52                   	push   %edx
c0101097:	50                   	push   %eax
c0101098:	68 ea 86 10 c0       	push   $0xc01086ea
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
c0101106:	05 40 24 12 c0       	add    $0xc0122440,%eax
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
c0101150:	05 48 24 12 c0       	add    $0xc0122448,%eax
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
c0101191:	05 40 24 12 c0       	add    $0xc0122440,%eax
c0101196:	0f b6 00             	movzbl (%eax),%eax
c0101199:	84 c0                	test   %al,%al
c010119b:	75 19                	jne    c01011b6 <ide_read_secs+0x56>
c010119d:	68 08 87 10 c0       	push   $0xc0108708
c01011a2:	68 c3 86 10 c0       	push   $0xc01086c3
c01011a7:	68 9f 00 00 00       	push   $0x9f
c01011ac:	68 d8 86 10 c0       	push   $0xc01086d8
c01011b1:	e8 3a f2 ff ff       	call   c01003f0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011b6:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01011bd:	77 0f                	ja     c01011ce <ide_read_secs+0x6e>
c01011bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01011c2:	8b 45 14             	mov    0x14(%ebp),%eax
c01011c5:	01 d0                	add    %edx,%eax
c01011c7:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01011cc:	76 19                	jbe    c01011e7 <ide_read_secs+0x87>
c01011ce:	68 30 87 10 c0       	push   $0xc0108730
c01011d3:	68 c3 86 10 c0       	push   $0xc01086c3
c01011d8:	68 a0 00 00 00       	push   $0xa0
c01011dd:	68 d8 86 10 c0       	push   $0xc01086d8
c01011e2:	e8 09 f2 ff ff       	call   c01003f0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c01011e7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011eb:	66 d1 e8             	shr    %ax
c01011ee:	0f b7 c0             	movzwl %ax,%eax
c01011f1:	0f b7 04 85 78 86 10 	movzwl -0x3fef7988(,%eax,4),%eax
c01011f8:	c0 
c01011f9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01011fd:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101201:	66 d1 e8             	shr    %ax
c0101204:	0f b7 c0             	movzwl %ax,%eax
c0101207:	0f b7 04 85 7a 86 10 	movzwl -0x3fef7986(,%eax,4),%eax
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
c01013bb:	05 40 24 12 c0       	add    $0xc0122440,%eax
c01013c0:	0f b6 00             	movzbl (%eax),%eax
c01013c3:	84 c0                	test   %al,%al
c01013c5:	75 19                	jne    c01013e0 <ide_write_secs+0x56>
c01013c7:	68 08 87 10 c0       	push   $0xc0108708
c01013cc:	68 c3 86 10 c0       	push   $0xc01086c3
c01013d1:	68 bc 00 00 00       	push   $0xbc
c01013d6:	68 d8 86 10 c0       	push   $0xc01086d8
c01013db:	e8 10 f0 ff ff       	call   c01003f0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01013e0:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01013e7:	77 0f                	ja     c01013f8 <ide_write_secs+0x6e>
c01013e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01013ec:	8b 45 14             	mov    0x14(%ebp),%eax
c01013ef:	01 d0                	add    %edx,%eax
c01013f1:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01013f6:	76 19                	jbe    c0101411 <ide_write_secs+0x87>
c01013f8:	68 30 87 10 c0       	push   $0xc0108730
c01013fd:	68 c3 86 10 c0       	push   $0xc01086c3
c0101402:	68 bd 00 00 00       	push   $0xbd
c0101407:	68 d8 86 10 c0       	push   $0xc01086d8
c010140c:	e8 df ef ff ff       	call   c01003f0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101411:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101415:	66 d1 e8             	shr    %ax
c0101418:	0f b7 c0             	movzwl %ax,%eax
c010141b:	0f b7 04 85 78 86 10 	movzwl -0x3fef7988(,%eax,4),%eax
c0101422:	c0 
c0101423:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101427:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010142b:	66 d1 e8             	shr    %ax
c010142e:	0f b7 c0             	movzwl %ax,%eax
c0101431:	0f b7 04 85 7a 86 10 	movzwl -0x3fef7986(,%eax,4),%eax
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
c01015f3:	c7 05 0c 30 12 c0 00 	movl   $0x0,0xc012300c
c01015fa:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c01015fd:	83 ec 0c             	sub    $0xc,%esp
c0101600:	68 6a 87 10 c0       	push   $0xc010876a
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
c01016d6:	66 c7 05 26 25 12 c0 	movw   $0x3b4,0xc0122526
c01016dd:	b4 03 
c01016df:	eb 13                	jmp    c01016f4 <cga_init+0x50>
    } else {
        *cp = was;
c01016e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016e8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c01016eb:	66 c7 05 26 25 12 c0 	movw   $0x3d4,0xc0122526
c01016f2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c01016f4:	0f b7 05 26 25 12 c0 	movzwl 0xc0122526,%eax
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
c010170f:	0f b7 05 26 25 12 c0 	movzwl 0xc0122526,%eax
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
c0101737:	0f b7 05 26 25 12 c0 	movzwl 0xc0122526,%eax
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
c0101752:	0f b7 05 26 25 12 c0 	movzwl 0xc0122526,%eax
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
c010177a:	a3 20 25 12 c0       	mov    %eax,0xc0122520
    crt_pos = pos;
c010177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101782:	66 a3 24 25 12 c0    	mov    %ax,0xc0122524
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
c0101832:	a3 28 25 12 c0       	mov    %eax,0xc0122528
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
c0101857:	a1 28 25 12 c0       	mov    0xc0122528,%eax
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
c0101951:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c0101958:	66 85 c0             	test   %ax,%ax
c010195b:	0f 84 a0 00 00 00    	je     c0101a01 <cga_putc+0xe0>
            crt_pos --;
c0101961:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c0101968:	83 e8 01             	sub    $0x1,%eax
c010196b:	66 a3 24 25 12 c0    	mov    %ax,0xc0122524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101971:	a1 20 25 12 c0       	mov    0xc0122520,%eax
c0101976:	0f b7 15 24 25 12 c0 	movzwl 0xc0122524,%edx
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
c0101991:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c0101998:	83 c0 50             	add    $0x50,%eax
c010199b:	66 a3 24 25 12 c0    	mov    %ax,0xc0122524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01019a1:	0f b7 1d 24 25 12 c0 	movzwl 0xc0122524,%ebx
c01019a8:	0f b7 0d 24 25 12 c0 	movzwl 0xc0122524,%ecx
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
c01019d3:	66 a3 24 25 12 c0    	mov    %ax,0xc0122524
        break;
c01019d9:	eb 27                	jmp    c0101a02 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01019db:	8b 0d 20 25 12 c0    	mov    0xc0122520,%ecx
c01019e1:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c01019e8:	8d 50 01             	lea    0x1(%eax),%edx
c01019eb:	66 89 15 24 25 12 c0 	mov    %dx,0xc0122524
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
c0101a02:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c0101a09:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101a0d:	76 59                	jbe    c0101a68 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a0f:	a1 20 25 12 c0       	mov    0xc0122520,%eax
c0101a14:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101a1a:	a1 20 25 12 c0       	mov    0xc0122520,%eax
c0101a1f:	83 ec 04             	sub    $0x4,%esp
c0101a22:	68 00 0f 00 00       	push   $0xf00
c0101a27:	52                   	push   %edx
c0101a28:	50                   	push   %eax
c0101a29:	e8 f1 60 00 00       	call   c0107b1f <memmove>
c0101a2e:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a31:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101a38:	eb 15                	jmp    c0101a4f <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c0101a3a:	a1 20 25 12 c0       	mov    0xc0122520,%eax
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
c0101a58:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c0101a5f:	83 e8 50             	sub    $0x50,%eax
c0101a62:	66 a3 24 25 12 c0    	mov    %ax,0xc0122524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101a68:	0f b7 05 26 25 12 c0 	movzwl 0xc0122526,%eax
c0101a6f:	0f b7 c0             	movzwl %ax,%eax
c0101a72:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101a76:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101a7a:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101a7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101a82:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101a83:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c0101a8a:	66 c1 e8 08          	shr    $0x8,%ax
c0101a8e:	0f b6 c0             	movzbl %al,%eax
c0101a91:	0f b7 15 26 25 12 c0 	movzwl 0xc0122526,%edx
c0101a98:	83 c2 01             	add    $0x1,%edx
c0101a9b:	0f b7 d2             	movzwl %dx,%edx
c0101a9e:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101aa2:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101aa5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101aa9:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101aad:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101aae:	0f b7 05 26 25 12 c0 	movzwl 0xc0122526,%eax
c0101ab5:	0f b7 c0             	movzwl %ax,%eax
c0101ab8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101abc:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101ac0:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101ac4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ac8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101ac9:	0f b7 05 24 25 12 c0 	movzwl 0xc0122524,%eax
c0101ad0:	0f b6 c0             	movzbl %al,%eax
c0101ad3:	0f b7 15 26 25 12 c0 	movzwl 0xc0122526,%edx
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
c0101b95:	a1 44 27 12 c0       	mov    0xc0122744,%eax
c0101b9a:	8d 50 01             	lea    0x1(%eax),%edx
c0101b9d:	89 15 44 27 12 c0    	mov    %edx,0xc0122744
c0101ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101ba6:	88 90 40 25 12 c0    	mov    %dl,-0x3feddac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101bac:	a1 44 27 12 c0       	mov    0xc0122744,%eax
c0101bb1:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101bb6:	75 0a                	jne    c0101bc2 <cons_intr+0x3b>
                cons.wpos = 0;
c0101bb8:	c7 05 44 27 12 c0 00 	movl   $0x0,0xc0122744
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
c0101c30:	a1 28 25 12 c0       	mov    0xc0122528,%eax
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
c0101c97:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101c9c:	83 c8 40             	or     $0x40,%eax
c0101c9f:	a3 48 27 12 c0       	mov    %eax,0xc0122748
        return 0;
c0101ca4:	b8 00 00 00 00       	mov    $0x0,%eax
c0101ca9:	e9 29 01 00 00       	jmp    c0101dd7 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101cae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cb2:	84 c0                	test   %al,%al
c0101cb4:	79 47                	jns    c0101cfd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101cb6:	a1 48 27 12 c0       	mov    0xc0122748,%eax
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
c0101cd6:	0f b6 80 40 f0 11 c0 	movzbl -0x3fee0fc0(%eax),%eax
c0101cdd:	83 c8 40             	or     $0x40,%eax
c0101ce0:	0f b6 c0             	movzbl %al,%eax
c0101ce3:	f7 d0                	not    %eax
c0101ce5:	89 c2                	mov    %eax,%edx
c0101ce7:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101cec:	21 d0                	and    %edx,%eax
c0101cee:	a3 48 27 12 c0       	mov    %eax,0xc0122748
        return 0;
c0101cf3:	b8 00 00 00 00       	mov    $0x0,%eax
c0101cf8:	e9 da 00 00 00       	jmp    c0101dd7 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c0101cfd:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101d02:	83 e0 40             	and    $0x40,%eax
c0101d05:	85 c0                	test   %eax,%eax
c0101d07:	74 11                	je     c0101d1a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d09:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d0d:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101d12:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d15:	a3 48 27 12 c0       	mov    %eax,0xc0122748
    }

    shift |= shiftcode[data];
c0101d1a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d1e:	0f b6 80 40 f0 11 c0 	movzbl -0x3fee0fc0(%eax),%eax
c0101d25:	0f b6 d0             	movzbl %al,%edx
c0101d28:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101d2d:	09 d0                	or     %edx,%eax
c0101d2f:	a3 48 27 12 c0       	mov    %eax,0xc0122748
    shift ^= togglecode[data];
c0101d34:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d38:	0f b6 80 40 f1 11 c0 	movzbl -0x3fee0ec0(%eax),%eax
c0101d3f:	0f b6 d0             	movzbl %al,%edx
c0101d42:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101d47:	31 d0                	xor    %edx,%eax
c0101d49:	a3 48 27 12 c0       	mov    %eax,0xc0122748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101d4e:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101d53:	83 e0 03             	and    $0x3,%eax
c0101d56:	8b 14 85 40 f5 11 c0 	mov    -0x3fee0ac0(,%eax,4),%edx
c0101d5d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d61:	01 d0                	add    %edx,%eax
c0101d63:	0f b6 00             	movzbl (%eax),%eax
c0101d66:	0f b6 c0             	movzbl %al,%eax
c0101d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101d6c:	a1 48 27 12 c0       	mov    0xc0122748,%eax
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
c0101d9a:	a1 48 27 12 c0       	mov    0xc0122748,%eax
c0101d9f:	f7 d0                	not    %eax
c0101da1:	83 e0 06             	and    $0x6,%eax
c0101da4:	85 c0                	test   %eax,%eax
c0101da6:	75 2c                	jne    c0101dd4 <kbd_proc_data+0x188>
c0101da8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101daf:	75 23                	jne    c0101dd4 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101db1:	83 ec 0c             	sub    $0xc,%esp
c0101db4:	68 85 87 10 c0       	push   $0xc0108785
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
c0101e22:	a1 28 25 12 c0       	mov    0xc0122528,%eax
c0101e27:	85 c0                	test   %eax,%eax
c0101e29:	75 10                	jne    c0101e3b <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c0101e2b:	83 ec 0c             	sub    $0xc,%esp
c0101e2e:	68 91 87 10 c0       	push   $0xc0108791
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
c0101ea6:	8b 15 40 27 12 c0    	mov    0xc0122740,%edx
c0101eac:	a1 44 27 12 c0       	mov    0xc0122744,%eax
c0101eb1:	39 c2                	cmp    %eax,%edx
c0101eb3:	74 31                	je     c0101ee6 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101eb5:	a1 40 27 12 c0       	mov    0xc0122740,%eax
c0101eba:	8d 50 01             	lea    0x1(%eax),%edx
c0101ebd:	89 15 40 27 12 c0    	mov    %edx,0xc0122740
c0101ec3:	0f b6 80 40 25 12 c0 	movzbl -0x3feddac0(%eax),%eax
c0101eca:	0f b6 c0             	movzbl %al,%eax
c0101ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101ed0:	a1 40 27 12 c0       	mov    0xc0122740,%eax
c0101ed5:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101eda:	75 0a                	jne    c0101ee6 <cons_getc+0x5f>
                cons.rpos = 0;
c0101edc:	c7 05 40 27 12 c0 00 	movl   $0x0,0xc0122740
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
c0101f0a:	66 a3 50 f5 11 c0    	mov    %ax,0xc011f550
    if (did_init) {
c0101f10:	a1 4c 27 12 c0       	mov    0xc012274c,%eax
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
c0101f67:	0f b7 05 50 f5 11 c0 	movzwl 0xc011f550,%eax
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
c0101f85:	c7 05 4c 27 12 c0 01 	movl   $0x1,0xc012274c
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
c0102099:	0f b7 05 50 f5 11 c0 	movzwl 0xc011f550,%eax
c01020a0:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020a4:	74 13                	je     c01020b9 <pic_init+0x13a>
        pic_setmask(irq_mask);
c01020a6:	0f b7 05 50 f5 11 c0 	movzwl 0xc011f550,%eax
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
c01020d5:	68 c0 87 10 c0       	push   $0xc01087c0
c01020da:	e8 ab e1 ff ff       	call   c010028a <cprintf>
c01020df:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01020e2:	83 ec 0c             	sub    $0xc,%esp
c01020e5:	68 ca 87 10 c0       	push   $0xc01087ca
c01020ea:	e8 9b e1 ff ff       	call   c010028a <cprintf>
c01020ef:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01020f2:	83 ec 04             	sub    $0x4,%esp
c01020f5:	68 d8 87 10 c0       	push   $0xc01087d8
c01020fa:	6a 14                	push   $0x14
c01020fc:	68 ee 87 10 c0       	push   $0xc01087ee
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
c010211b:	8b 04 85 e0 f5 11 c0 	mov    -0x3fee0a20(,%eax,4),%eax
c0102122:	89 c2                	mov    %eax,%edx
c0102124:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102127:	66 89 14 c5 60 27 12 	mov    %dx,-0x3fedd8a0(,%eax,8)
c010212e:	c0 
c010212f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102132:	66 c7 04 c5 62 27 12 	movw   $0x8,-0x3fedd89e(,%eax,8)
c0102139:	c0 08 00 
c010213c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213f:	0f b6 14 c5 64 27 12 	movzbl -0x3fedd89c(,%eax,8),%edx
c0102146:	c0 
c0102147:	83 e2 e0             	and    $0xffffffe0,%edx
c010214a:	88 14 c5 64 27 12 c0 	mov    %dl,-0x3fedd89c(,%eax,8)
c0102151:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102154:	0f b6 14 c5 64 27 12 	movzbl -0x3fedd89c(,%eax,8),%edx
c010215b:	c0 
c010215c:	83 e2 1f             	and    $0x1f,%edx
c010215f:	88 14 c5 64 27 12 c0 	mov    %dl,-0x3fedd89c(,%eax,8)
c0102166:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102169:	0f b6 14 c5 65 27 12 	movzbl -0x3fedd89b(,%eax,8),%edx
c0102170:	c0 
c0102171:	83 e2 f0             	and    $0xfffffff0,%edx
c0102174:	83 ca 0e             	or     $0xe,%edx
c0102177:	88 14 c5 65 27 12 c0 	mov    %dl,-0x3fedd89b(,%eax,8)
c010217e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102181:	0f b6 14 c5 65 27 12 	movzbl -0x3fedd89b(,%eax,8),%edx
c0102188:	c0 
c0102189:	83 e2 ef             	and    $0xffffffef,%edx
c010218c:	88 14 c5 65 27 12 c0 	mov    %dl,-0x3fedd89b(,%eax,8)
c0102193:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102196:	0f b6 14 c5 65 27 12 	movzbl -0x3fedd89b(,%eax,8),%edx
c010219d:	c0 
c010219e:	83 e2 9f             	and    $0xffffff9f,%edx
c01021a1:	88 14 c5 65 27 12 c0 	mov    %dl,-0x3fedd89b(,%eax,8)
c01021a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ab:	0f b6 14 c5 65 27 12 	movzbl -0x3fedd89b(,%eax,8),%edx
c01021b2:	c0 
c01021b3:	83 ca 80             	or     $0xffffff80,%edx
c01021b6:	88 14 c5 65 27 12 c0 	mov    %dl,-0x3fedd89b(,%eax,8)
c01021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021c0:	8b 04 85 e0 f5 11 c0 	mov    -0x3fee0a20(,%eax,4),%eax
c01021c7:	c1 e8 10             	shr    $0x10,%eax
c01021ca:	89 c2                	mov    %eax,%edx
c01021cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021cf:	66 89 14 c5 66 27 12 	mov    %dx,-0x3fedd89a(,%eax,8)
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
c01021e8:	a1 c4 f7 11 c0       	mov    0xc011f7c4,%eax
c01021ed:	66 a3 28 2b 12 c0    	mov    %ax,0xc0122b28
c01021f3:	66 c7 05 2a 2b 12 c0 	movw   $0x8,0xc0122b2a
c01021fa:	08 00 
c01021fc:	0f b6 05 2c 2b 12 c0 	movzbl 0xc0122b2c,%eax
c0102203:	83 e0 e0             	and    $0xffffffe0,%eax
c0102206:	a2 2c 2b 12 c0       	mov    %al,0xc0122b2c
c010220b:	0f b6 05 2c 2b 12 c0 	movzbl 0xc0122b2c,%eax
c0102212:	83 e0 1f             	and    $0x1f,%eax
c0102215:	a2 2c 2b 12 c0       	mov    %al,0xc0122b2c
c010221a:	0f b6 05 2d 2b 12 c0 	movzbl 0xc0122b2d,%eax
c0102221:	83 e0 f0             	and    $0xfffffff0,%eax
c0102224:	83 c8 0e             	or     $0xe,%eax
c0102227:	a2 2d 2b 12 c0       	mov    %al,0xc0122b2d
c010222c:	0f b6 05 2d 2b 12 c0 	movzbl 0xc0122b2d,%eax
c0102233:	83 e0 ef             	and    $0xffffffef,%eax
c0102236:	a2 2d 2b 12 c0       	mov    %al,0xc0122b2d
c010223b:	0f b6 05 2d 2b 12 c0 	movzbl 0xc0122b2d,%eax
c0102242:	83 c8 60             	or     $0x60,%eax
c0102245:	a2 2d 2b 12 c0       	mov    %al,0xc0122b2d
c010224a:	0f b6 05 2d 2b 12 c0 	movzbl 0xc0122b2d,%eax
c0102251:	83 c8 80             	or     $0xffffff80,%eax
c0102254:	a2 2d 2b 12 c0       	mov    %al,0xc0122b2d
c0102259:	a1 c4 f7 11 c0       	mov    0xc011f7c4,%eax
c010225e:	c1 e8 10             	shr    $0x10,%eax
c0102261:	66 a3 2e 2b 12 c0    	mov    %ax,0xc0122b2e
c0102267:	c7 45 f8 60 f5 11 c0 	movl   $0xc011f560,-0x8(%ebp)
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
c0102285:	8b 04 85 a0 8b 10 c0 	mov    -0x3fef7460(,%eax,4),%eax
c010228c:	eb 18                	jmp    c01022a6 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010228e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102292:	7e 0d                	jle    c01022a1 <trapname+0x2a>
c0102294:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102298:	7f 07                	jg     c01022a1 <trapname+0x2a>
        return "Hardware Interrupt";
c010229a:	b8 ff 87 10 c0       	mov    $0xc01087ff,%eax
c010229f:	eb 05                	jmp    c01022a6 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022a1:	b8 12 88 10 c0       	mov    $0xc0108812,%eax
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
c01022ca:	68 53 88 10 c0       	push   $0xc0108853
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
c01022f4:	68 64 88 10 c0       	push   $0xc0108864
c01022f9:	e8 8c df ff ff       	call   c010028a <cprintf>
c01022fe:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102301:	8b 45 08             	mov    0x8(%ebp),%eax
c0102304:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102308:	0f b7 c0             	movzwl %ax,%eax
c010230b:	83 ec 08             	sub    $0x8,%esp
c010230e:	50                   	push   %eax
c010230f:	68 77 88 10 c0       	push   $0xc0108877
c0102314:	e8 71 df ff ff       	call   c010028a <cprintf>
c0102319:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010231c:	8b 45 08             	mov    0x8(%ebp),%eax
c010231f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102323:	0f b7 c0             	movzwl %ax,%eax
c0102326:	83 ec 08             	sub    $0x8,%esp
c0102329:	50                   	push   %eax
c010232a:	68 8a 88 10 c0       	push   $0xc010888a
c010232f:	e8 56 df ff ff       	call   c010028a <cprintf>
c0102334:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102337:	8b 45 08             	mov    0x8(%ebp),%eax
c010233a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010233e:	0f b7 c0             	movzwl %ax,%eax
c0102341:	83 ec 08             	sub    $0x8,%esp
c0102344:	50                   	push   %eax
c0102345:	68 9d 88 10 c0       	push   $0xc010889d
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
c0102371:	68 b0 88 10 c0       	push   $0xc01088b0
c0102376:	e8 0f df ff ff       	call   c010028a <cprintf>
c010237b:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c010237e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102381:	8b 40 34             	mov    0x34(%eax),%eax
c0102384:	83 ec 08             	sub    $0x8,%esp
c0102387:	50                   	push   %eax
c0102388:	68 c2 88 10 c0       	push   $0xc01088c2
c010238d:	e8 f8 de ff ff       	call   c010028a <cprintf>
c0102392:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102395:	8b 45 08             	mov    0x8(%ebp),%eax
c0102398:	8b 40 38             	mov    0x38(%eax),%eax
c010239b:	83 ec 08             	sub    $0x8,%esp
c010239e:	50                   	push   %eax
c010239f:	68 d1 88 10 c0       	push   $0xc01088d1
c01023a4:	e8 e1 de ff ff       	call   c010028a <cprintf>
c01023a9:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01023af:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023b3:	0f b7 c0             	movzwl %ax,%eax
c01023b6:	83 ec 08             	sub    $0x8,%esp
c01023b9:	50                   	push   %eax
c01023ba:	68 e0 88 10 c0       	push   $0xc01088e0
c01023bf:	e8 c6 de ff ff       	call   c010028a <cprintf>
c01023c4:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ca:	8b 40 40             	mov    0x40(%eax),%eax
c01023cd:	83 ec 08             	sub    $0x8,%esp
c01023d0:	50                   	push   %eax
c01023d1:	68 f3 88 10 c0       	push   $0xc01088f3
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
c0102400:	8b 04 85 80 f5 11 c0 	mov    -0x3fee0a80(,%eax,4),%eax
c0102407:	85 c0                	test   %eax,%eax
c0102409:	74 1b                	je     c0102426 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c010240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010240e:	8b 04 85 80 f5 11 c0 	mov    -0x3fee0a80(,%eax,4),%eax
c0102415:	83 ec 08             	sub    $0x8,%esp
c0102418:	50                   	push   %eax
c0102419:	68 02 89 10 c0       	push   $0xc0108902
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
c0102447:	68 06 89 10 c0       	push   $0xc0108906
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
c0102470:	68 0f 89 10 c0       	push   $0xc010890f
c0102475:	e8 10 de ff ff       	call   c010028a <cprintf>
c010247a:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010247d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102480:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102484:	0f b7 c0             	movzwl %ax,%eax
c0102487:	83 ec 08             	sub    $0x8,%esp
c010248a:	50                   	push   %eax
c010248b:	68 1e 89 10 c0       	push   $0xc010891e
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
c01024aa:	68 31 89 10 c0       	push   $0xc0108931
c01024af:	e8 d6 dd ff ff       	call   c010028a <cprintf>
c01024b4:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ba:	8b 40 04             	mov    0x4(%eax),%eax
c01024bd:	83 ec 08             	sub    $0x8,%esp
c01024c0:	50                   	push   %eax
c01024c1:	68 40 89 10 c0       	push   $0xc0108940
c01024c6:	e8 bf dd ff ff       	call   c010028a <cprintf>
c01024cb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d1:	8b 40 08             	mov    0x8(%eax),%eax
c01024d4:	83 ec 08             	sub    $0x8,%esp
c01024d7:	50                   	push   %eax
c01024d8:	68 4f 89 10 c0       	push   $0xc010894f
c01024dd:	e8 a8 dd ff ff       	call   c010028a <cprintf>
c01024e2:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e8:	8b 40 0c             	mov    0xc(%eax),%eax
c01024eb:	83 ec 08             	sub    $0x8,%esp
c01024ee:	50                   	push   %eax
c01024ef:	68 5e 89 10 c0       	push   $0xc010895e
c01024f4:	e8 91 dd ff ff       	call   c010028a <cprintf>
c01024f9:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ff:	8b 40 10             	mov    0x10(%eax),%eax
c0102502:	83 ec 08             	sub    $0x8,%esp
c0102505:	50                   	push   %eax
c0102506:	68 6d 89 10 c0       	push   $0xc010896d
c010250b:	e8 7a dd ff ff       	call   c010028a <cprintf>
c0102510:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102513:	8b 45 08             	mov    0x8(%ebp),%eax
c0102516:	8b 40 14             	mov    0x14(%eax),%eax
c0102519:	83 ec 08             	sub    $0x8,%esp
c010251c:	50                   	push   %eax
c010251d:	68 7c 89 10 c0       	push   $0xc010897c
c0102522:	e8 63 dd ff ff       	call   c010028a <cprintf>
c0102527:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010252a:	8b 45 08             	mov    0x8(%ebp),%eax
c010252d:	8b 40 18             	mov    0x18(%eax),%eax
c0102530:	83 ec 08             	sub    $0x8,%esp
c0102533:	50                   	push   %eax
c0102534:	68 8b 89 10 c0       	push   $0xc010898b
c0102539:	e8 4c dd ff ff       	call   c010028a <cprintf>
c010253e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102541:	8b 45 08             	mov    0x8(%ebp),%eax
c0102544:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102547:	83 ec 08             	sub    $0x8,%esp
c010254a:	50                   	push   %eax
c010254b:	68 9a 89 10 c0       	push   $0xc010899a
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
c010256f:	bb a9 89 10 c0       	mov    $0xc01089a9,%ebx
c0102574:	eb 05                	jmp    c010257b <print_pgfault+0x20>
c0102576:	bb ba 89 10 c0       	mov    $0xc01089ba,%ebx
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
c01025bd:	68 c8 89 10 c0       	push   $0xc01089c8
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
c01025e4:	a1 70 30 12 c0       	mov    0xc0123070,%eax
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
c01025fc:	a1 70 30 12 c0       	mov    0xc0123070,%eax
c0102601:	83 ec 04             	sub    $0x4,%esp
c0102604:	51                   	push   %ecx
c0102605:	52                   	push   %edx
c0102606:	50                   	push   %eax
c0102607:	e8 3a 17 00 00       	call   c0103d46 <do_pgfault>
c010260c:	83 c4 10             	add    $0x10,%esp
c010260f:	eb 17                	jmp    c0102628 <pgfault_handler+0x58>
    }
    panic("unhandled page fault.\n");
c0102611:	83 ec 04             	sub    $0x4,%esp
c0102614:	68 eb 89 10 c0       	push   $0xc01089eb
c0102619:	68 a9 00 00 00       	push   $0xa9
c010261e:	68 ee 87 10 c0       	push   $0xc01087ee
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
c01026bc:	68 02 8a 10 c0       	push   $0xc0108a02
c01026c1:	68 bd 00 00 00       	push   $0xbd
c01026c6:	68 ee 87 10 c0       	push   $0xc01087ee
c01026cb:	e8 20 dd ff ff       	call   c01003f0 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c01026d0:	a1 0c 30 12 c0       	mov    0xc012300c,%eax
c01026d5:	83 c0 01             	add    $0x1,%eax
c01026d8:	a3 0c 30 12 c0       	mov    %eax,0xc012300c
        if (ticks % TICK_NUM == 0) {
c01026dd:	8b 0d 0c 30 12 c0    	mov    0xc012300c,%ecx
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
c010271f:	68 1d 8a 10 c0       	push   $0xc0108a1d
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
c0102746:	68 2f 8a 10 c0       	push   $0xc0108a2f
c010274b:	e8 3a db ff ff       	call   c010028a <cprintf>
c0102750:	83 c4 10             	add    $0x10,%esp
        break;
c0102753:	e9 dd 00 00 00       	jmp    c0102835 <trap_dispatch+0x20b>
        
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
c0102758:	8b 55 08             	mov    0x8(%ebp),%edx
c010275b:	b8 20 30 12 c0       	mov    $0xc0123020,%eax
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
c010278d:	66 c7 05 5c 30 12 c0 	movw   $0x1b,0xc012305c
c0102794:	1b 00 
        switchk2u.tf_ds = USER_DS;
c0102796:	66 c7 05 4c 30 12 c0 	movw   $0x23,0xc012304c
c010279d:	23 00 
        switchk2u.tf_es = USER_DS;
c010279f:	66 c7 05 48 30 12 c0 	movw   $0x23,0xc0123048
c01027a6:	23 00 
        switchk2u.tf_ss = USER_DS;
c01027a8:	66 c7 05 68 30 12 c0 	movw   $0x23,0xc0123068
c01027af:	23 00 
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c01027b1:	a1 60 30 12 c0       	mov    0xc0123060,%eax
c01027b6:	80 cc 30             	or     $0x30,%ah
c01027b9:	a3 60 30 12 c0       	mov    %eax,0xc0123060
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c01027be:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c1:	83 e8 04             	sub    $0x4,%eax
c01027c4:	ba 20 30 12 c0       	mov    $0xc0123020,%edx
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
c010281d:	68 3e 8a 10 c0       	push   $0xc0108a3e
c0102822:	68 f3 00 00 00       	push   $0xf3
c0102827:	68 ee 87 10 c0       	push   $0xc01087ee
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

c01032e9 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01032e9:	55                   	push   %ebp
c01032ea:	89 e5                	mov    %esp,%ebp
c01032ec:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01032ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01032f2:	c1 e8 0c             	shr    $0xc,%eax
c01032f5:	89 c2                	mov    %eax,%edx
c01032f7:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c01032fc:	39 c2                	cmp    %eax,%edx
c01032fe:	72 14                	jb     c0103314 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0103300:	83 ec 04             	sub    $0x4,%esp
c0103303:	68 f0 8b 10 c0       	push   $0xc0108bf0
c0103308:	6a 5b                	push   $0x5b
c010330a:	68 0f 8c 10 c0       	push   $0xc0108c0f
c010330f:	e8 dc d0 ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0103314:	a1 58 31 12 c0       	mov    0xc0123158,%eax
c0103319:	8b 55 08             	mov    0x8(%ebp),%edx
c010331c:	c1 ea 0c             	shr    $0xc,%edx
c010331f:	c1 e2 05             	shl    $0x5,%edx
c0103322:	01 d0                	add    %edx,%eax
}
c0103324:	c9                   	leave  
c0103325:	c3                   	ret    

c0103326 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0103326:	55                   	push   %ebp
c0103327:	89 e5                	mov    %esp,%ebp
c0103329:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c010332c:	8b 45 08             	mov    0x8(%ebp),%eax
c010332f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103334:	83 ec 0c             	sub    $0xc,%esp
c0103337:	50                   	push   %eax
c0103338:	e8 ac ff ff ff       	call   c01032e9 <pa2page>
c010333d:	83 c4 10             	add    $0x10,%esp
}
c0103340:	c9                   	leave  
c0103341:	c3                   	ret    

c0103342 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0103342:	55                   	push   %ebp
c0103343:	89 e5                	mov    %esp,%ebp
c0103345:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0103348:	83 ec 0c             	sub    $0xc,%esp
c010334b:	6a 18                	push   $0x18
c010334d:	e8 e3 41 00 00       	call   c0107535 <kmalloc>
c0103352:	83 c4 10             	add    $0x10,%esp
c0103355:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0103358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010335c:	74 5b                	je     c01033b9 <mm_create+0x77>
        list_init(&(mm->mmap_list));
c010335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103361:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103364:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103367:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010336a:	89 50 04             	mov    %edx,0x4(%eax)
c010336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103370:	8b 50 04             	mov    0x4(%eax),%edx
c0103373:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103376:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0103378:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010337b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0103382:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103385:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010338f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0103396:	a1 68 2f 12 c0       	mov    0xc0122f68,%eax
c010339b:	85 c0                	test   %eax,%eax
c010339d:	74 10                	je     c01033af <mm_create+0x6d>
c010339f:	83 ec 0c             	sub    $0xc,%esp
c01033a2:	ff 75 f4             	pushl  -0xc(%ebp)
c01033a5:	e8 ab 0f 00 00       	call   c0104355 <swap_init_mm>
c01033aa:	83 c4 10             	add    $0x10,%esp
c01033ad:	eb 0a                	jmp    c01033b9 <mm_create+0x77>
        else mm->sm_priv = NULL;
c01033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c01033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01033bc:	c9                   	leave  
c01033bd:	c3                   	ret    

c01033be <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c01033be:	55                   	push   %ebp
c01033bf:	89 e5                	mov    %esp,%ebp
c01033c1:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01033c4:	83 ec 0c             	sub    $0xc,%esp
c01033c7:	6a 18                	push   $0x18
c01033c9:	e8 67 41 00 00       	call   c0107535 <kmalloc>
c01033ce:	83 c4 10             	add    $0x10,%esp
c01033d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01033d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033d8:	74 1b                	je     c01033f5 <vma_create+0x37>
        vma->vm_start = vm_start;
c01033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033dd:	8b 55 08             	mov    0x8(%ebp),%edx
c01033e0:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033e9:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ef:	8b 55 10             	mov    0x10(%ebp),%edx
c01033f2:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01033f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01033f8:	c9                   	leave  
c01033f9:	c3                   	ret    

c01033fa <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01033fa:	55                   	push   %ebp
c01033fb:	89 e5                	mov    %esp,%ebp
c01033fd:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0103400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0103407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010340b:	0f 84 95 00 00 00    	je     c01034a6 <find_vma+0xac>
        vma = mm->mmap_cache;
c0103411:	8b 45 08             	mov    0x8(%ebp),%eax
c0103414:	8b 40 08             	mov    0x8(%eax),%eax
c0103417:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c010341a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010341e:	74 16                	je     c0103436 <find_vma+0x3c>
c0103420:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103423:	8b 40 04             	mov    0x4(%eax),%eax
c0103426:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103429:	77 0b                	ja     c0103436 <find_vma+0x3c>
c010342b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010342e:	8b 40 08             	mov    0x8(%eax),%eax
c0103431:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103434:	77 61                	ja     c0103497 <find_vma+0x9d>
                bool found = 0;
c0103436:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c010343d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103440:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103443:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103446:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103449:	eb 28                	jmp    c0103473 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c010344b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010344e:	83 e8 10             	sub    $0x10,%eax
c0103451:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103454:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103457:	8b 40 04             	mov    0x4(%eax),%eax
c010345a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010345d:	77 14                	ja     c0103473 <find_vma+0x79>
c010345f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103462:	8b 40 08             	mov    0x8(%eax),%eax
c0103465:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103468:	76 09                	jbe    c0103473 <find_vma+0x79>
                        found = 1;
c010346a:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103471:	eb 17                	jmp    c010348a <find_vma+0x90>
c0103473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103476:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103479:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010347c:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010347f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103482:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103485:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103488:	75 c1                	jne    c010344b <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c010348a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010348e:	75 07                	jne    c0103497 <find_vma+0x9d>
                    vma = NULL;
c0103490:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103497:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010349b:	74 09                	je     c01034a6 <find_vma+0xac>
            mm->mmap_cache = vma;
c010349d:	8b 45 08             	mov    0x8(%ebp),%eax
c01034a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01034a3:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01034a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01034a9:	c9                   	leave  
c01034aa:	c3                   	ret    

c01034ab <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c01034ab:	55                   	push   %ebp
c01034ac:	89 e5                	mov    %esp,%ebp
c01034ae:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
c01034b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01034b4:	8b 50 04             	mov    0x4(%eax),%edx
c01034b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ba:	8b 40 08             	mov    0x8(%eax),%eax
c01034bd:	39 c2                	cmp    %eax,%edx
c01034bf:	72 16                	jb     c01034d7 <check_vma_overlap+0x2c>
c01034c1:	68 1d 8c 10 c0       	push   $0xc0108c1d
c01034c6:	68 3b 8c 10 c0       	push   $0xc0108c3b
c01034cb:	6a 67                	push   $0x67
c01034cd:	68 50 8c 10 c0       	push   $0xc0108c50
c01034d2:	e8 19 cf ff ff       	call   c01003f0 <__panic>
    assert(prev->vm_end <= next->vm_start);
c01034d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01034da:	8b 50 08             	mov    0x8(%eax),%edx
c01034dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034e0:	8b 40 04             	mov    0x4(%eax),%eax
c01034e3:	39 c2                	cmp    %eax,%edx
c01034e5:	76 16                	jbe    c01034fd <check_vma_overlap+0x52>
c01034e7:	68 60 8c 10 c0       	push   $0xc0108c60
c01034ec:	68 3b 8c 10 c0       	push   $0xc0108c3b
c01034f1:	6a 68                	push   $0x68
c01034f3:	68 50 8c 10 c0       	push   $0xc0108c50
c01034f8:	e8 f3 ce ff ff       	call   c01003f0 <__panic>
    assert(next->vm_start < next->vm_end);
c01034fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103500:	8b 50 04             	mov    0x4(%eax),%edx
c0103503:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103506:	8b 40 08             	mov    0x8(%eax),%eax
c0103509:	39 c2                	cmp    %eax,%edx
c010350b:	72 16                	jb     c0103523 <check_vma_overlap+0x78>
c010350d:	68 7f 8c 10 c0       	push   $0xc0108c7f
c0103512:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103517:	6a 69                	push   $0x69
c0103519:	68 50 8c 10 c0       	push   $0xc0108c50
c010351e:	e8 cd ce ff ff       	call   c01003f0 <__panic>
}
c0103523:	90                   	nop
c0103524:	c9                   	leave  
c0103525:	c3                   	ret    

c0103526 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103526:	55                   	push   %ebp
c0103527:	89 e5                	mov    %esp,%ebp
c0103529:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
c010352c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010352f:	8b 50 04             	mov    0x4(%eax),%edx
c0103532:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103535:	8b 40 08             	mov    0x8(%eax),%eax
c0103538:	39 c2                	cmp    %eax,%edx
c010353a:	72 16                	jb     c0103552 <insert_vma_struct+0x2c>
c010353c:	68 9d 8c 10 c0       	push   $0xc0108c9d
c0103541:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103546:	6a 70                	push   $0x70
c0103548:	68 50 8c 10 c0       	push   $0xc0108c50
c010354d:	e8 9e ce ff ff       	call   c01003f0 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103552:	8b 45 08             	mov    0x8(%ebp),%eax
c0103555:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103558:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010355b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    list_entry_t *le = list;
c010355e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103561:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((le = list_next(le)) != list) {
c0103564:	eb 1f                	jmp    c0103585 <insert_vma_struct+0x5f>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103566:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103569:	83 e8 10             	sub    $0x10,%eax
c010356c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (mmap_prev->vm_start > vma->vm_start) {
c010356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103572:	8b 50 04             	mov    0x4(%eax),%edx
c0103575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103578:	8b 40 04             	mov    0x4(%eax),%eax
c010357b:	39 c2                	cmp    %eax,%edx
c010357d:	77 1f                	ja     c010359e <insert_vma_struct+0x78>
            break;
        }
        le_prev = le;
c010357f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103582:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103585:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103588:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010358b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010358e:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

    list_entry_t *le = list;
    while ((le = list_next(le)) != list) {
c0103591:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103594:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103597:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010359a:	75 ca                	jne    c0103566 <insert_vma_struct+0x40>
c010359c:	eb 01                	jmp    c010359f <insert_vma_struct+0x79>
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start) {
            break;
c010359e:	90                   	nop
c010359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01035a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035a8:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le_prev = le;
    }

    le_next = list_next(le_prev);
c01035ab:	89 45 dc             	mov    %eax,-0x24(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01035b4:	74 15                	je     c01035cb <insert_vma_struct+0xa5>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b9:	83 e8 10             	sub    $0x10,%eax
c01035bc:	83 ec 08             	sub    $0x8,%esp
c01035bf:	ff 75 0c             	pushl  0xc(%ebp)
c01035c2:	50                   	push   %eax
c01035c3:	e8 e3 fe ff ff       	call   c01034ab <check_vma_overlap>
c01035c8:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
c01035cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01035d1:	74 15                	je     c01035e8 <insert_vma_struct+0xc2>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01035d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035d6:	83 e8 10             	sub    $0x10,%eax
c01035d9:	83 ec 08             	sub    $0x8,%esp
c01035dc:	50                   	push   %eax
c01035dd:	ff 75 0c             	pushl  0xc(%ebp)
c01035e0:	e8 c6 fe ff ff       	call   c01034ab <check_vma_overlap>
c01035e5:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
c01035e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01035ee:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035f3:	8d 50 10             	lea    0x10(%eax),%edx
c01035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035fc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01035ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103602:	8b 40 04             	mov    0x4(%eax),%eax
c0103605:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103608:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010360b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010360e:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103611:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103614:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103617:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010361a:	89 10                	mov    %edx,(%eax)
c010361c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010361f:	8b 10                	mov    (%eax),%edx
c0103621:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103624:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103627:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010362a:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010362d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103630:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103633:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103636:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103638:	8b 45 08             	mov    0x8(%ebp),%eax
c010363b:	8b 40 10             	mov    0x10(%eax),%eax
c010363e:	8d 50 01             	lea    0x1(%eax),%edx
c0103641:	8b 45 08             	mov    0x8(%ebp),%eax
c0103644:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103647:	90                   	nop
c0103648:	c9                   	leave  
c0103649:	c3                   	ret    

c010364a <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010364a:	55                   	push   %ebp
c010364b:	89 e5                	mov    %esp,%ebp
c010364d:	83 ec 28             	sub    $0x28,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103650:	8b 45 08             	mov    0x8(%ebp),%eax
c0103653:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103656:	eb 3c                	jmp    c0103694 <mm_destroy+0x4a>
c0103658:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010365b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010365e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103661:	8b 40 04             	mov    0x4(%eax),%eax
c0103664:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103667:	8b 12                	mov    (%edx),%edx
c0103669:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010366c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103672:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103675:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103678:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010367b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010367e:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0103680:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103683:	83 e8 10             	sub    $0x10,%eax
c0103686:	83 ec 08             	sub    $0x8,%esp
c0103689:	6a 18                	push   $0x18
c010368b:	50                   	push   %eax
c010368c:	e8 35 3f 00 00       	call   c01075c6 <kfree>
c0103691:	83 c4 10             	add    $0x10,%esp
c0103694:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103697:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010369a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010369d:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01036a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036a9:	75 ad                	jne    c0103658 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01036ab:	83 ec 08             	sub    $0x8,%esp
c01036ae:	6a 18                	push   $0x18
c01036b0:	ff 75 08             	pushl  0x8(%ebp)
c01036b3:	e8 0e 3f 00 00       	call   c01075c6 <kfree>
c01036b8:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
c01036bb:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01036c2:	90                   	nop
c01036c3:	c9                   	leave  
c01036c4:	c3                   	ret    

c01036c5 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01036c5:	55                   	push   %ebp
c01036c6:	89 e5                	mov    %esp,%ebp
c01036c8:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01036cb:	e8 03 00 00 00       	call   c01036d3 <check_vmm>
}
c01036d0:	90                   	nop
c01036d1:	c9                   	leave  
c01036d2:	c3                   	ret    

c01036d3 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01036d3:	55                   	push   %ebp
c01036d4:	89 e5                	mov    %esp,%ebp
c01036d6:	83 ec 18             	sub    $0x18,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01036d9:	e8 c9 29 00 00       	call   c01060a7 <nr_free_pages>
c01036de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01036e1:	e8 3b 00 00 00       	call   c0103721 <check_vma_struct>
    check_pgfault();
c01036e6:	e8 56 04 00 00       	call   c0103b41 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c01036eb:	e8 b7 29 00 00       	call   c01060a7 <nr_free_pages>
c01036f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036f3:	74 19                	je     c010370e <check_vmm+0x3b>
c01036f5:	68 bc 8c 10 c0       	push   $0xc0108cbc
c01036fa:	68 3b 8c 10 c0       	push   $0xc0108c3b
c01036ff:	68 a9 00 00 00       	push   $0xa9
c0103704:	68 50 8c 10 c0       	push   $0xc0108c50
c0103709:	e8 e2 cc ff ff       	call   c01003f0 <__panic>

    cprintf("check_vmm() succeeded.\n");
c010370e:	83 ec 0c             	sub    $0xc,%esp
c0103711:	68 e3 8c 10 c0       	push   $0xc0108ce3
c0103716:	e8 6f cb ff ff       	call   c010028a <cprintf>
c010371b:	83 c4 10             	add    $0x10,%esp
}
c010371e:	90                   	nop
c010371f:	c9                   	leave  
c0103720:	c3                   	ret    

c0103721 <check_vma_struct>:

static void
check_vma_struct(void) {
c0103721:	55                   	push   %ebp
c0103722:	89 e5                	mov    %esp,%ebp
c0103724:	83 ec 58             	sub    $0x58,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103727:	e8 7b 29 00 00       	call   c01060a7 <nr_free_pages>
c010372c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c010372f:	e8 0e fc ff ff       	call   c0103342 <mm_create>
c0103734:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103737:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010373b:	75 19                	jne    c0103756 <check_vma_struct+0x35>
c010373d:	68 fb 8c 10 c0       	push   $0xc0108cfb
c0103742:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103747:	68 b3 00 00 00       	push   $0xb3
c010374c:	68 50 8c 10 c0       	push   $0xc0108c50
c0103751:	e8 9a cc ff ff       	call   c01003f0 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103756:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010375d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103760:	89 d0                	mov    %edx,%eax
c0103762:	c1 e0 02             	shl    $0x2,%eax
c0103765:	01 d0                	add    %edx,%eax
c0103767:	01 c0                	add    %eax,%eax
c0103769:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c010376c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010376f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103772:	eb 5f                	jmp    c01037d3 <check_vma_struct+0xb2>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103774:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103777:	89 d0                	mov    %edx,%eax
c0103779:	c1 e0 02             	shl    $0x2,%eax
c010377c:	01 d0                	add    %edx,%eax
c010377e:	83 c0 02             	add    $0x2,%eax
c0103781:	89 c1                	mov    %eax,%ecx
c0103783:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103786:	89 d0                	mov    %edx,%eax
c0103788:	c1 e0 02             	shl    $0x2,%eax
c010378b:	01 d0                	add    %edx,%eax
c010378d:	83 ec 04             	sub    $0x4,%esp
c0103790:	6a 00                	push   $0x0
c0103792:	51                   	push   %ecx
c0103793:	50                   	push   %eax
c0103794:	e8 25 fc ff ff       	call   c01033be <vma_create>
c0103799:	83 c4 10             	add    $0x10,%esp
c010379c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c010379f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01037a3:	75 19                	jne    c01037be <check_vma_struct+0x9d>
c01037a5:	68 06 8d 10 c0       	push   $0xc0108d06
c01037aa:	68 3b 8c 10 c0       	push   $0xc0108c3b
c01037af:	68 ba 00 00 00       	push   $0xba
c01037b4:	68 50 8c 10 c0       	push   $0xc0108c50
c01037b9:	e8 32 cc ff ff       	call   c01003f0 <__panic>
        insert_vma_struct(mm, vma);
c01037be:	83 ec 08             	sub    $0x8,%esp
c01037c1:	ff 75 dc             	pushl  -0x24(%ebp)
c01037c4:	ff 75 e8             	pushl  -0x18(%ebp)
c01037c7:	e8 5a fd ff ff       	call   c0103526 <insert_vma_struct>
c01037cc:	83 c4 10             	add    $0x10,%esp
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01037cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01037d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037d7:	7f 9b                	jg     c0103774 <check_vma_struct+0x53>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037dc:	83 c0 01             	add    $0x1,%eax
c01037df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037e2:	eb 5f                	jmp    c0103843 <check_vma_struct+0x122>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01037e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01037e7:	89 d0                	mov    %edx,%eax
c01037e9:	c1 e0 02             	shl    $0x2,%eax
c01037ec:	01 d0                	add    %edx,%eax
c01037ee:	83 c0 02             	add    $0x2,%eax
c01037f1:	89 c1                	mov    %eax,%ecx
c01037f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01037f6:	89 d0                	mov    %edx,%eax
c01037f8:	c1 e0 02             	shl    $0x2,%eax
c01037fb:	01 d0                	add    %edx,%eax
c01037fd:	83 ec 04             	sub    $0x4,%esp
c0103800:	6a 00                	push   $0x0
c0103802:	51                   	push   %ecx
c0103803:	50                   	push   %eax
c0103804:	e8 b5 fb ff ff       	call   c01033be <vma_create>
c0103809:	83 c4 10             	add    $0x10,%esp
c010380c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c010380f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103813:	75 19                	jne    c010382e <check_vma_struct+0x10d>
c0103815:	68 06 8d 10 c0       	push   $0xc0108d06
c010381a:	68 3b 8c 10 c0       	push   $0xc0108c3b
c010381f:	68 c0 00 00 00       	push   $0xc0
c0103824:	68 50 8c 10 c0       	push   $0xc0108c50
c0103829:	e8 c2 cb ff ff       	call   c01003f0 <__panic>
        insert_vma_struct(mm, vma);
c010382e:	83 ec 08             	sub    $0x8,%esp
c0103831:	ff 75 d8             	pushl  -0x28(%ebp)
c0103834:	ff 75 e8             	pushl  -0x18(%ebp)
c0103837:	e8 ea fc ff ff       	call   c0103526 <insert_vma_struct>
c010383c:	83 c4 10             	add    $0x10,%esp
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c010383f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103843:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103846:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103849:	7e 99                	jle    c01037e4 <check_vma_struct+0xc3>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010384b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010384e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103851:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103854:	8b 40 04             	mov    0x4(%eax),%eax
c0103857:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c010385a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103861:	e9 81 00 00 00       	jmp    c01038e7 <check_vma_struct+0x1c6>
        assert(le != &(mm->mmap_list));
c0103866:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103869:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010386c:	75 19                	jne    c0103887 <check_vma_struct+0x166>
c010386e:	68 12 8d 10 c0       	push   $0xc0108d12
c0103873:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103878:	68 c7 00 00 00       	push   $0xc7
c010387d:	68 50 8c 10 c0       	push   $0xc0108c50
c0103882:	e8 69 cb ff ff       	call   c01003f0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103887:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010388a:	83 e8 10             	sub    $0x10,%eax
c010388d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103890:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103893:	8b 48 04             	mov    0x4(%eax),%ecx
c0103896:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103899:	89 d0                	mov    %edx,%eax
c010389b:	c1 e0 02             	shl    $0x2,%eax
c010389e:	01 d0                	add    %edx,%eax
c01038a0:	39 c1                	cmp    %eax,%ecx
c01038a2:	75 17                	jne    c01038bb <check_vma_struct+0x19a>
c01038a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038a7:	8b 48 08             	mov    0x8(%eax),%ecx
c01038aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038ad:	89 d0                	mov    %edx,%eax
c01038af:	c1 e0 02             	shl    $0x2,%eax
c01038b2:	01 d0                	add    %edx,%eax
c01038b4:	83 c0 02             	add    $0x2,%eax
c01038b7:	39 c1                	cmp    %eax,%ecx
c01038b9:	74 19                	je     c01038d4 <check_vma_struct+0x1b3>
c01038bb:	68 2c 8d 10 c0       	push   $0xc0108d2c
c01038c0:	68 3b 8c 10 c0       	push   $0xc0108c3b
c01038c5:	68 c9 00 00 00       	push   $0xc9
c01038ca:	68 50 8c 10 c0       	push   $0xc0108c50
c01038cf:	e8 1c cb ff ff       	call   c01003f0 <__panic>
c01038d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01038da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01038dd:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01038e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01038e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01038e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038ea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01038ed:	0f 8e 73 ff ff ff    	jle    c0103866 <check_vma_struct+0x145>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01038f3:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01038fa:	e9 80 01 00 00       	jmp    c0103a7f <check_vma_struct+0x35e>
        struct vma_struct *vma1 = find_vma(mm, i);
c01038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103902:	83 ec 08             	sub    $0x8,%esp
c0103905:	50                   	push   %eax
c0103906:	ff 75 e8             	pushl  -0x18(%ebp)
c0103909:	e8 ec fa ff ff       	call   c01033fa <find_vma>
c010390e:	83 c4 10             	add    $0x10,%esp
c0103911:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma1 != NULL);
c0103914:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103918:	75 19                	jne    c0103933 <check_vma_struct+0x212>
c010391a:	68 61 8d 10 c0       	push   $0xc0108d61
c010391f:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103924:	68 cf 00 00 00       	push   $0xcf
c0103929:	68 50 8c 10 c0       	push   $0xc0108c50
c010392e:	e8 bd ca ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0103933:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103936:	83 c0 01             	add    $0x1,%eax
c0103939:	83 ec 08             	sub    $0x8,%esp
c010393c:	50                   	push   %eax
c010393d:	ff 75 e8             	pushl  -0x18(%ebp)
c0103940:	e8 b5 fa ff ff       	call   c01033fa <find_vma>
c0103945:	83 c4 10             	add    $0x10,%esp
c0103948:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma2 != NULL);
c010394b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010394f:	75 19                	jne    c010396a <check_vma_struct+0x249>
c0103951:	68 6e 8d 10 c0       	push   $0xc0108d6e
c0103956:	68 3b 8c 10 c0       	push   $0xc0108c3b
c010395b:	68 d1 00 00 00       	push   $0xd1
c0103960:	68 50 8c 10 c0       	push   $0xc0108c50
c0103965:	e8 86 ca ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c010396a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010396d:	83 c0 02             	add    $0x2,%eax
c0103970:	83 ec 08             	sub    $0x8,%esp
c0103973:	50                   	push   %eax
c0103974:	ff 75 e8             	pushl  -0x18(%ebp)
c0103977:	e8 7e fa ff ff       	call   c01033fa <find_vma>
c010397c:	83 c4 10             	add    $0x10,%esp
c010397f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma3 == NULL);
c0103982:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0103986:	74 19                	je     c01039a1 <check_vma_struct+0x280>
c0103988:	68 7b 8d 10 c0       	push   $0xc0108d7b
c010398d:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103992:	68 d3 00 00 00       	push   $0xd3
c0103997:	68 50 8c 10 c0       	push   $0xc0108c50
c010399c:	e8 4f ca ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039a4:	83 c0 03             	add    $0x3,%eax
c01039a7:	83 ec 08             	sub    $0x8,%esp
c01039aa:	50                   	push   %eax
c01039ab:	ff 75 e8             	pushl  -0x18(%ebp)
c01039ae:	e8 47 fa ff ff       	call   c01033fa <find_vma>
c01039b3:	83 c4 10             	add    $0x10,%esp
c01039b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma4 == NULL);
c01039b9:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01039bd:	74 19                	je     c01039d8 <check_vma_struct+0x2b7>
c01039bf:	68 88 8d 10 c0       	push   $0xc0108d88
c01039c4:	68 3b 8c 10 c0       	push   $0xc0108c3b
c01039c9:	68 d5 00 00 00       	push   $0xd5
c01039ce:	68 50 8c 10 c0       	push   $0xc0108c50
c01039d3:	e8 18 ca ff ff       	call   c01003f0 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01039d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039db:	83 c0 04             	add    $0x4,%eax
c01039de:	83 ec 08             	sub    $0x8,%esp
c01039e1:	50                   	push   %eax
c01039e2:	ff 75 e8             	pushl  -0x18(%ebp)
c01039e5:	e8 10 fa ff ff       	call   c01033fa <find_vma>
c01039ea:	83 c4 10             	add    $0x10,%esp
c01039ed:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma5 == NULL);
c01039f0:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01039f4:	74 19                	je     c0103a0f <check_vma_struct+0x2ee>
c01039f6:	68 95 8d 10 c0       	push   $0xc0108d95
c01039fb:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103a00:	68 d7 00 00 00       	push   $0xd7
c0103a05:	68 50 8c 10 c0       	push   $0xc0108c50
c0103a0a:	e8 e1 c9 ff ff       	call   c01003f0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0103a0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a12:	8b 50 04             	mov    0x4(%eax),%edx
c0103a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a18:	39 c2                	cmp    %eax,%edx
c0103a1a:	75 10                	jne    c0103a2c <check_vma_struct+0x30b>
c0103a1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a1f:	8b 40 08             	mov    0x8(%eax),%eax
c0103a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a25:	83 c2 02             	add    $0x2,%edx
c0103a28:	39 d0                	cmp    %edx,%eax
c0103a2a:	74 19                	je     c0103a45 <check_vma_struct+0x324>
c0103a2c:	68 a4 8d 10 c0       	push   $0xc0108da4
c0103a31:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103a36:	68 d9 00 00 00       	push   $0xd9
c0103a3b:	68 50 8c 10 c0       	push   $0xc0108c50
c0103a40:	e8 ab c9 ff ff       	call   c01003f0 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0103a45:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103a48:	8b 50 04             	mov    0x4(%eax),%edx
c0103a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a4e:	39 c2                	cmp    %eax,%edx
c0103a50:	75 10                	jne    c0103a62 <check_vma_struct+0x341>
c0103a52:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103a55:	8b 40 08             	mov    0x8(%eax),%eax
c0103a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a5b:	83 c2 02             	add    $0x2,%edx
c0103a5e:	39 d0                	cmp    %edx,%eax
c0103a60:	74 19                	je     c0103a7b <check_vma_struct+0x35a>
c0103a62:	68 d4 8d 10 c0       	push   $0xc0108dd4
c0103a67:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103a6c:	68 da 00 00 00       	push   $0xda
c0103a71:	68 50 8c 10 c0       	push   $0xc0108c50
c0103a76:	e8 75 c9 ff ff       	call   c01003f0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0103a7b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0103a7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a82:	89 d0                	mov    %edx,%eax
c0103a84:	c1 e0 02             	shl    $0x2,%eax
c0103a87:	01 d0                	add    %edx,%eax
c0103a89:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a8c:	0f 8d 6d fe ff ff    	jge    c01038ff <check_vma_struct+0x1de>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0103a92:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0103a99:	eb 5c                	jmp    c0103af7 <check_vma_struct+0x3d6>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0103a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a9e:	83 ec 08             	sub    $0x8,%esp
c0103aa1:	50                   	push   %eax
c0103aa2:	ff 75 e8             	pushl  -0x18(%ebp)
c0103aa5:	e8 50 f9 ff ff       	call   c01033fa <find_vma>
c0103aaa:	83 c4 10             	add    $0x10,%esp
c0103aad:	89 45 b8             	mov    %eax,-0x48(%ebp)
        if (vma_below_5 != NULL ) {
c0103ab0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103ab4:	74 1e                	je     c0103ad4 <check_vma_struct+0x3b3>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0103ab6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ab9:	8b 50 08             	mov    0x8(%eax),%edx
c0103abc:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103abf:	8b 40 04             	mov    0x4(%eax),%eax
c0103ac2:	52                   	push   %edx
c0103ac3:	50                   	push   %eax
c0103ac4:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ac7:	68 04 8e 10 c0       	push   $0xc0108e04
c0103acc:	e8 b9 c7 ff ff       	call   c010028a <cprintf>
c0103ad1:	83 c4 10             	add    $0x10,%esp
        }
        assert(vma_below_5 == NULL);
c0103ad4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103ad8:	74 19                	je     c0103af3 <check_vma_struct+0x3d2>
c0103ada:	68 29 8e 10 c0       	push   $0xc0108e29
c0103adf:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103ae4:	68 e2 00 00 00       	push   $0xe2
c0103ae9:	68 50 8c 10 c0       	push   $0xc0108c50
c0103aee:	e8 fd c8 ff ff       	call   c01003f0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0103af3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103afb:	79 9e                	jns    c0103a9b <check_vma_struct+0x37a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0103afd:	83 ec 0c             	sub    $0xc,%esp
c0103b00:	ff 75 e8             	pushl  -0x18(%ebp)
c0103b03:	e8 42 fb ff ff       	call   c010364a <mm_destroy>
c0103b08:	83 c4 10             	add    $0x10,%esp

    assert(nr_free_pages_store == nr_free_pages());
c0103b0b:	e8 97 25 00 00       	call   c01060a7 <nr_free_pages>
c0103b10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103b13:	74 19                	je     c0103b2e <check_vma_struct+0x40d>
c0103b15:	68 bc 8c 10 c0       	push   $0xc0108cbc
c0103b1a:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103b1f:	68 e7 00 00 00       	push   $0xe7
c0103b24:	68 50 8c 10 c0       	push   $0xc0108c50
c0103b29:	e8 c2 c8 ff ff       	call   c01003f0 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0103b2e:	83 ec 0c             	sub    $0xc,%esp
c0103b31:	68 40 8e 10 c0       	push   $0xc0108e40
c0103b36:	e8 4f c7 ff ff       	call   c010028a <cprintf>
c0103b3b:	83 c4 10             	add    $0x10,%esp
}
c0103b3e:	90                   	nop
c0103b3f:	c9                   	leave  
c0103b40:	c3                   	ret    

c0103b41 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0103b41:	55                   	push   %ebp
c0103b42:	89 e5                	mov    %esp,%ebp
c0103b44:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103b47:	e8 5b 25 00 00       	call   c01060a7 <nr_free_pages>
c0103b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0103b4f:	e8 ee f7 ff ff       	call   c0103342 <mm_create>
c0103b54:	a3 70 30 12 c0       	mov    %eax,0xc0123070
    assert(check_mm_struct != NULL);
c0103b59:	a1 70 30 12 c0       	mov    0xc0123070,%eax
c0103b5e:	85 c0                	test   %eax,%eax
c0103b60:	75 19                	jne    c0103b7b <check_pgfault+0x3a>
c0103b62:	68 5f 8e 10 c0       	push   $0xc0108e5f
c0103b67:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103b6c:	68 f4 00 00 00       	push   $0xf4
c0103b71:	68 50 8c 10 c0       	push   $0xc0108c50
c0103b76:	e8 75 c8 ff ff       	call   c01003f0 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0103b7b:	a1 70 30 12 c0       	mov    0xc0123070,%eax
c0103b80:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0103b83:	8b 15 00 fa 11 c0    	mov    0xc011fa00,%edx
c0103b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b8c:	89 50 0c             	mov    %edx,0xc(%eax)
c0103b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b92:	8b 40 0c             	mov    0xc(%eax),%eax
c0103b95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0103b98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b9b:	8b 00                	mov    (%eax),%eax
c0103b9d:	85 c0                	test   %eax,%eax
c0103b9f:	74 19                	je     c0103bba <check_pgfault+0x79>
c0103ba1:	68 77 8e 10 c0       	push   $0xc0108e77
c0103ba6:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103bab:	68 f8 00 00 00       	push   $0xf8
c0103bb0:	68 50 8c 10 c0       	push   $0xc0108c50
c0103bb5:	e8 36 c8 ff ff       	call   c01003f0 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0103bba:	83 ec 04             	sub    $0x4,%esp
c0103bbd:	6a 02                	push   $0x2
c0103bbf:	68 00 00 40 00       	push   $0x400000
c0103bc4:	6a 00                	push   $0x0
c0103bc6:	e8 f3 f7 ff ff       	call   c01033be <vma_create>
c0103bcb:	83 c4 10             	add    $0x10,%esp
c0103bce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0103bd1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103bd5:	75 19                	jne    c0103bf0 <check_pgfault+0xaf>
c0103bd7:	68 06 8d 10 c0       	push   $0xc0108d06
c0103bdc:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103be1:	68 fb 00 00 00       	push   $0xfb
c0103be6:	68 50 8c 10 c0       	push   $0xc0108c50
c0103beb:	e8 00 c8 ff ff       	call   c01003f0 <__panic>

    insert_vma_struct(mm, vma);
c0103bf0:	83 ec 08             	sub    $0x8,%esp
c0103bf3:	ff 75 e0             	pushl  -0x20(%ebp)
c0103bf6:	ff 75 e8             	pushl  -0x18(%ebp)
c0103bf9:	e8 28 f9 ff ff       	call   c0103526 <insert_vma_struct>
c0103bfe:	83 c4 10             	add    $0x10,%esp

    uintptr_t addr = 0x100;
c0103c01:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0103c08:	83 ec 08             	sub    $0x8,%esp
c0103c0b:	ff 75 dc             	pushl  -0x24(%ebp)
c0103c0e:	ff 75 e8             	pushl  -0x18(%ebp)
c0103c11:	e8 e4 f7 ff ff       	call   c01033fa <find_vma>
c0103c16:	83 c4 10             	add    $0x10,%esp
c0103c19:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103c1c:	74 19                	je     c0103c37 <check_pgfault+0xf6>
c0103c1e:	68 85 8e 10 c0       	push   $0xc0108e85
c0103c23:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103c28:	68 00 01 00 00       	push   $0x100
c0103c2d:	68 50 8c 10 c0       	push   $0xc0108c50
c0103c32:	e8 b9 c7 ff ff       	call   c01003f0 <__panic>

    int i, sum = 0;
c0103c37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c45:	eb 19                	jmp    c0103c60 <check_pgfault+0x11f>
        *(char *)(addr + i) = i;
c0103c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c4d:	01 d0                	add    %edx,%eax
c0103c4f:	89 c2                	mov    %eax,%edx
c0103c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c54:	88 02                	mov    %al,(%edx)
        sum += i;
c0103c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c59:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0103c5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103c60:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103c64:	7e e1                	jle    c0103c47 <check_pgfault+0x106>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0103c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c6d:	eb 15                	jmp    c0103c84 <check_pgfault+0x143>
        sum -= *(char *)(addr + i);
c0103c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c72:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c75:	01 d0                	add    %edx,%eax
c0103c77:	0f b6 00             	movzbl (%eax),%eax
c0103c7a:	0f be c0             	movsbl %al,%eax
c0103c7d:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0103c80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103c84:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103c88:	7e e5                	jle    c0103c6f <check_pgfault+0x12e>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0103c8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c8e:	74 19                	je     c0103ca9 <check_pgfault+0x168>
c0103c90:	68 9f 8e 10 c0       	push   $0xc0108e9f
c0103c95:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103c9a:	68 0a 01 00 00       	push   $0x10a
c0103c9f:	68 50 8c 10 c0       	push   $0xc0108c50
c0103ca4:	e8 47 c7 ff ff       	call   c01003f0 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0103ca9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103cac:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103caf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cb7:	83 ec 08             	sub    $0x8,%esp
c0103cba:	50                   	push   %eax
c0103cbb:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103cbe:	e8 b0 2b 00 00       	call   c0106873 <page_remove>
c0103cc3:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(pgdir[0]));
c0103cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cc9:	8b 00                	mov    (%eax),%eax
c0103ccb:	83 ec 0c             	sub    $0xc,%esp
c0103cce:	50                   	push   %eax
c0103ccf:	e8 52 f6 ff ff       	call   c0103326 <pde2page>
c0103cd4:	83 c4 10             	add    $0x10,%esp
c0103cd7:	83 ec 08             	sub    $0x8,%esp
c0103cda:	6a 01                	push   $0x1
c0103cdc:	50                   	push   %eax
c0103cdd:	e8 90 23 00 00       	call   c0106072 <free_pages>
c0103ce2:	83 c4 10             	add    $0x10,%esp
    pgdir[0] = 0;
c0103ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ce8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0103cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cf1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0103cf8:	83 ec 0c             	sub    $0xc,%esp
c0103cfb:	ff 75 e8             	pushl  -0x18(%ebp)
c0103cfe:	e8 47 f9 ff ff       	call   c010364a <mm_destroy>
c0103d03:	83 c4 10             	add    $0x10,%esp
    check_mm_struct = NULL;
c0103d06:	c7 05 70 30 12 c0 00 	movl   $0x0,0xc0123070
c0103d0d:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0103d10:	e8 92 23 00 00       	call   c01060a7 <nr_free_pages>
c0103d15:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d18:	74 19                	je     c0103d33 <check_pgfault+0x1f2>
c0103d1a:	68 bc 8c 10 c0       	push   $0xc0108cbc
c0103d1f:	68 3b 8c 10 c0       	push   $0xc0108c3b
c0103d24:	68 14 01 00 00       	push   $0x114
c0103d29:	68 50 8c 10 c0       	push   $0xc0108c50
c0103d2e:	e8 bd c6 ff ff       	call   c01003f0 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0103d33:	83 ec 0c             	sub    $0xc,%esp
c0103d36:	68 a8 8e 10 c0       	push   $0xc0108ea8
c0103d3b:	e8 4a c5 ff ff       	call   c010028a <cprintf>
c0103d40:	83 c4 10             	add    $0x10,%esp
}
c0103d43:	90                   	nop
c0103d44:	c9                   	leave  
c0103d45:	c3                   	ret    

c0103d46 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0103d46:	55                   	push   %ebp
c0103d47:	89 e5                	mov    %esp,%ebp
c0103d49:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_INVAL;
c0103d4c:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0103d53:	ff 75 10             	pushl  0x10(%ebp)
c0103d56:	ff 75 08             	pushl  0x8(%ebp)
c0103d59:	e8 9c f6 ff ff       	call   c01033fa <find_vma>
c0103d5e:	83 c4 08             	add    $0x8,%esp
c0103d61:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0103d64:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0103d69:	83 c0 01             	add    $0x1,%eax
c0103d6c:	a3 64 2f 12 c0       	mov    %eax,0xc0122f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0103d71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103d75:	74 0b                	je     c0103d82 <do_pgfault+0x3c>
c0103d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d7a:	8b 40 04             	mov    0x4(%eax),%eax
c0103d7d:	3b 45 10             	cmp    0x10(%ebp),%eax
c0103d80:	76 18                	jbe    c0103d9a <do_pgfault+0x54>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0103d82:	83 ec 08             	sub    $0x8,%esp
c0103d85:	ff 75 10             	pushl  0x10(%ebp)
c0103d88:	68 c4 8e 10 c0       	push   $0xc0108ec4
c0103d8d:	e8 f8 c4 ff ff       	call   c010028a <cprintf>
c0103d92:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0103d95:	e9 0e 01 00 00       	jmp    c0103ea8 <do_pgfault+0x162>
    }
    //check the error_code
    switch (error_code & 3) {
c0103d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d9d:	83 e0 03             	and    $0x3,%eax
c0103da0:	85 c0                	test   %eax,%eax
c0103da2:	74 3c                	je     c0103de0 <do_pgfault+0x9a>
c0103da4:	83 f8 01             	cmp    $0x1,%eax
c0103da7:	74 22                	je     c0103dcb <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
            // since &= 3, empty default is safe here
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0103da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dac:	8b 40 0c             	mov    0xc(%eax),%eax
c0103daf:	83 e0 02             	and    $0x2,%eax
c0103db2:	85 c0                	test   %eax,%eax
c0103db4:	75 4c                	jne    c0103e02 <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0103db6:	83 ec 0c             	sub    $0xc,%esp
c0103db9:	68 f4 8e 10 c0       	push   $0xc0108ef4
c0103dbe:	e8 c7 c4 ff ff       	call   c010028a <cprintf>
c0103dc3:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0103dc6:	e9 dd 00 00 00       	jmp    c0103ea8 <do_pgfault+0x162>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        // this should not happen!
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0103dcb:	83 ec 0c             	sub    $0xc,%esp
c0103dce:	68 54 8f 10 c0       	push   $0xc0108f54
c0103dd3:	e8 b2 c4 ff ff       	call   c010028a <cprintf>
c0103dd8:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0103ddb:	e9 c8 00 00 00       	jmp    c0103ea8 <do_pgfault+0x162>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0103de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103de3:	8b 40 0c             	mov    0xc(%eax),%eax
c0103de6:	83 e0 05             	and    $0x5,%eax
c0103de9:	85 c0                	test   %eax,%eax
c0103deb:	75 16                	jne    c0103e03 <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0103ded:	83 ec 0c             	sub    $0xc,%esp
c0103df0:	68 8c 8f 10 c0       	push   $0xc0108f8c
c0103df5:	e8 90 c4 ff ff       	call   c010028a <cprintf>
c0103dfa:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0103dfd:	e9 a6 00 00 00       	jmp    c0103ea8 <do_pgfault+0x162>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0103e02:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0103e03:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0103e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e0d:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e10:	83 e0 02             	and    $0x2,%eax
c0103e13:	85 c0                	test   %eax,%eax
c0103e15:	74 04                	je     c0103e1b <do_pgfault+0xd5>
        perm |= PTE_W;
c0103e17:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0103e1b:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e29:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0103e2c:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0103e33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: YOUR CODE*/
    ptep = get_pte(mm->pgdir, addr, 1);              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0103e3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e3d:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e40:	83 ec 04             	sub    $0x4,%esp
c0103e43:	6a 01                	push   $0x1
c0103e45:	ff 75 10             	pushl  0x10(%ebp)
c0103e48:	50                   	push   %eax
c0103e49:	e8 1f 28 00 00       	call   c010666d <get_pte>
c0103e4e:	83 c4 10             	add    $0x10,%esp
c0103e51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0) {
c0103e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e57:	8b 00                	mov    (%eax),%eax
c0103e59:	85 c0                	test   %eax,%eax
c0103e5b:	75 1a                	jne    c0103e77 <do_pgfault+0x131>
        pgdir_alloc_page(mm->pgdir, addr, perm);
c0103e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e60:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e63:	83 ec 04             	sub    $0x4,%esp
c0103e66:	ff 75 f0             	pushl  -0x10(%ebp)
c0103e69:	ff 75 10             	pushl  0x10(%ebp)
c0103e6c:	50                   	push   %eax
c0103e6d:	e8 43 2b 00 00       	call   c01069b5 <pgdir_alloc_page>
c0103e72:	83 c4 10             	add    $0x10,%esp
c0103e75:	eb 2a                	jmp    c0103ea1 <do_pgfault+0x15b>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0103e77:	a1 68 2f 12 c0       	mov    0xc0122f68,%eax
c0103e7c:	85 c0                	test   %eax,%eax
c0103e7e:	74 09                	je     c0103e89 <do_pgfault+0x143>
            struct Page *page=NULL;
c0103e80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103e87:	eb 18                	jmp    c0103ea1 <do_pgfault+0x15b>
                                    //    into the memory which page managed.
                                    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
                                    //(3) make the page swappable.
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0103e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e8c:	8b 00                	mov    (%eax),%eax
c0103e8e:	83 ec 08             	sub    $0x8,%esp
c0103e91:	50                   	push   %eax
c0103e92:	68 f0 8f 10 c0       	push   $0xc0108ff0
c0103e97:	e8 ee c3 ff ff       	call   c010028a <cprintf>
c0103e9c:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0103e9f:	eb 07                	jmp    c0103ea8 <do_pgfault+0x162>
        }
   }
   ret = 0;
c0103ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0103ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103eab:	c9                   	leave  
c0103eac:	c3                   	ret    

c0103ead <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0103ead:	55                   	push   %ebp
c0103eae:	89 e5                	mov    %esp,%ebp
c0103eb0:	83 ec 10             	sub    $0x10,%esp
c0103eb3:	c7 45 fc 74 30 12 c0 	movl   $0xc0123074,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ebd:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103ec0:	89 50 04             	mov    %edx,0x4(%eax)
c0103ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ec6:	8b 50 04             	mov    0x4(%eax),%edx
c0103ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ecc:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0103ece:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ed1:	c7 40 14 74 30 12 c0 	movl   $0xc0123074,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0103ed8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103edd:	c9                   	leave  
c0103ede:	c3                   	ret    

c0103edf <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0103edf:	55                   	push   %ebp
c0103ee0:	89 e5                	mov    %esp,%ebp
c0103ee2:	83 ec 18             	sub    $0x18,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0103ee5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ee8:	8b 40 14             	mov    0x14(%eax),%eax
c0103eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0103eee:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ef1:	83 c0 14             	add    $0x14,%eax
c0103ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0103ef7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103efb:	74 06                	je     c0103f03 <_fifo_map_swappable+0x24>
c0103efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103f01:	75 16                	jne    c0103f19 <_fifo_map_swappable+0x3a>
c0103f03:	68 18 90 10 c0       	push   $0xc0109018
c0103f08:	68 36 90 10 c0       	push   $0xc0109036
c0103f0d:	6a 32                	push   $0x32
c0103f0f:	68 4b 90 10 c0       	push   $0xc010904b
c0103f14:	e8 d7 c4 ff ff       	call   c01003f0 <__panic>
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    return 0;
c0103f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f1e:	c9                   	leave  
c0103f1f:	c3                   	ret    

c0103f20 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0103f20:	55                   	push   %ebp
c0103f21:	89 e5                	mov    %esp,%ebp
c0103f23:	83 ec 18             	sub    $0x18,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0103f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f29:	8b 40 14             	mov    0x14(%eax),%eax
c0103f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0103f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103f33:	75 16                	jne    c0103f4b <_fifo_swap_out_victim+0x2b>
c0103f35:	68 5f 90 10 c0       	push   $0xc010905f
c0103f3a:	68 36 90 10 c0       	push   $0xc0109036
c0103f3f:	6a 40                	push   $0x40
c0103f41:	68 4b 90 10 c0       	push   $0xc010904b
c0103f46:	e8 a5 c4 ff ff       	call   c01003f0 <__panic>
     assert(in_tick==0);
c0103f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103f4f:	74 16                	je     c0103f67 <_fifo_swap_out_victim+0x47>
c0103f51:	68 6c 90 10 c0       	push   $0xc010906c
c0103f56:	68 36 90 10 c0       	push   $0xc0109036
c0103f5b:	6a 41                	push   $0x41
c0103f5d:	68 4b 90 10 c0       	push   $0xc010904b
c0103f62:	e8 89 c4 ff ff       	call   c01003f0 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     return 0;
c0103f67:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f6c:	c9                   	leave  
c0103f6d:	c3                   	ret    

c0103f6e <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0103f6e:	55                   	push   %ebp
c0103f6f:	89 e5                	mov    %esp,%ebp
c0103f71:	83 ec 08             	sub    $0x8,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0103f74:	83 ec 0c             	sub    $0xc,%esp
c0103f77:	68 78 90 10 c0       	push   $0xc0109078
c0103f7c:	e8 09 c3 ff ff       	call   c010028a <cprintf>
c0103f81:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0103f84:	b8 00 30 00 00       	mov    $0x3000,%eax
c0103f89:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0103f8c:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0103f91:	83 f8 04             	cmp    $0x4,%eax
c0103f94:	74 16                	je     c0103fac <_fifo_check_swap+0x3e>
c0103f96:	68 9e 90 10 c0       	push   $0xc010909e
c0103f9b:	68 36 90 10 c0       	push   $0xc0109036
c0103fa0:	6a 4d                	push   $0x4d
c0103fa2:	68 4b 90 10 c0       	push   $0xc010904b
c0103fa7:	e8 44 c4 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0103fac:	83 ec 0c             	sub    $0xc,%esp
c0103faf:	68 b0 90 10 c0       	push   $0xc01090b0
c0103fb4:	e8 d1 c2 ff ff       	call   c010028a <cprintf>
c0103fb9:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c0103fbc:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103fc1:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0103fc4:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0103fc9:	83 f8 04             	cmp    $0x4,%eax
c0103fcc:	74 16                	je     c0103fe4 <_fifo_check_swap+0x76>
c0103fce:	68 9e 90 10 c0       	push   $0xc010909e
c0103fd3:	68 36 90 10 c0       	push   $0xc0109036
c0103fd8:	6a 50                	push   $0x50
c0103fda:	68 4b 90 10 c0       	push   $0xc010904b
c0103fdf:	e8 0c c4 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0103fe4:	83 ec 0c             	sub    $0xc,%esp
c0103fe7:	68 d8 90 10 c0       	push   $0xc01090d8
c0103fec:	e8 99 c2 ff ff       	call   c010028a <cprintf>
c0103ff1:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0103ff4:	b8 00 40 00 00       	mov    $0x4000,%eax
c0103ff9:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0103ffc:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104001:	83 f8 04             	cmp    $0x4,%eax
c0104004:	74 16                	je     c010401c <_fifo_check_swap+0xae>
c0104006:	68 9e 90 10 c0       	push   $0xc010909e
c010400b:	68 36 90 10 c0       	push   $0xc0109036
c0104010:	6a 53                	push   $0x53
c0104012:	68 4b 90 10 c0       	push   $0xc010904b
c0104017:	e8 d4 c3 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010401c:	83 ec 0c             	sub    $0xc,%esp
c010401f:	68 00 91 10 c0       	push   $0xc0109100
c0104024:	e8 61 c2 ff ff       	call   c010028a <cprintf>
c0104029:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c010402c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104031:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0104034:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104039:	83 f8 04             	cmp    $0x4,%eax
c010403c:	74 16                	je     c0104054 <_fifo_check_swap+0xe6>
c010403e:	68 9e 90 10 c0       	push   $0xc010909e
c0104043:	68 36 90 10 c0       	push   $0xc0109036
c0104048:	6a 56                	push   $0x56
c010404a:	68 4b 90 10 c0       	push   $0xc010904b
c010404f:	e8 9c c3 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104054:	83 ec 0c             	sub    $0xc,%esp
c0104057:	68 28 91 10 c0       	push   $0xc0109128
c010405c:	e8 29 c2 ff ff       	call   c010028a <cprintf>
c0104061:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0104064:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104069:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c010406c:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104071:	83 f8 05             	cmp    $0x5,%eax
c0104074:	74 16                	je     c010408c <_fifo_check_swap+0x11e>
c0104076:	68 4e 91 10 c0       	push   $0xc010914e
c010407b:	68 36 90 10 c0       	push   $0xc0109036
c0104080:	6a 59                	push   $0x59
c0104082:	68 4b 90 10 c0       	push   $0xc010904b
c0104087:	e8 64 c3 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010408c:	83 ec 0c             	sub    $0xc,%esp
c010408f:	68 00 91 10 c0       	push   $0xc0109100
c0104094:	e8 f1 c1 ff ff       	call   c010028a <cprintf>
c0104099:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c010409c:	b8 00 20 00 00       	mov    $0x2000,%eax
c01040a1:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01040a4:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c01040a9:	83 f8 05             	cmp    $0x5,%eax
c01040ac:	74 16                	je     c01040c4 <_fifo_check_swap+0x156>
c01040ae:	68 4e 91 10 c0       	push   $0xc010914e
c01040b3:	68 36 90 10 c0       	push   $0xc0109036
c01040b8:	6a 5c                	push   $0x5c
c01040ba:	68 4b 90 10 c0       	push   $0xc010904b
c01040bf:	e8 2c c3 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01040c4:	83 ec 0c             	sub    $0xc,%esp
c01040c7:	68 b0 90 10 c0       	push   $0xc01090b0
c01040cc:	e8 b9 c1 ff ff       	call   c010028a <cprintf>
c01040d1:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01040d4:	b8 00 10 00 00       	mov    $0x1000,%eax
c01040d9:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01040dc:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c01040e1:	83 f8 06             	cmp    $0x6,%eax
c01040e4:	74 16                	je     c01040fc <_fifo_check_swap+0x18e>
c01040e6:	68 5d 91 10 c0       	push   $0xc010915d
c01040eb:	68 36 90 10 c0       	push   $0xc0109036
c01040f0:	6a 5f                	push   $0x5f
c01040f2:	68 4b 90 10 c0       	push   $0xc010904b
c01040f7:	e8 f4 c2 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01040fc:	83 ec 0c             	sub    $0xc,%esp
c01040ff:	68 00 91 10 c0       	push   $0xc0109100
c0104104:	e8 81 c1 ff ff       	call   c010028a <cprintf>
c0104109:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c010410c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104111:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0104114:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104119:	83 f8 07             	cmp    $0x7,%eax
c010411c:	74 16                	je     c0104134 <_fifo_check_swap+0x1c6>
c010411e:	68 6c 91 10 c0       	push   $0xc010916c
c0104123:	68 36 90 10 c0       	push   $0xc0109036
c0104128:	6a 62                	push   $0x62
c010412a:	68 4b 90 10 c0       	push   $0xc010904b
c010412f:	e8 bc c2 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104134:	83 ec 0c             	sub    $0xc,%esp
c0104137:	68 78 90 10 c0       	push   $0xc0109078
c010413c:	e8 49 c1 ff ff       	call   c010028a <cprintf>
c0104141:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0104144:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104149:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c010414c:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104151:	83 f8 08             	cmp    $0x8,%eax
c0104154:	74 16                	je     c010416c <_fifo_check_swap+0x1fe>
c0104156:	68 7b 91 10 c0       	push   $0xc010917b
c010415b:	68 36 90 10 c0       	push   $0xc0109036
c0104160:	6a 65                	push   $0x65
c0104162:	68 4b 90 10 c0       	push   $0xc010904b
c0104167:	e8 84 c2 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010416c:	83 ec 0c             	sub    $0xc,%esp
c010416f:	68 d8 90 10 c0       	push   $0xc01090d8
c0104174:	e8 11 c1 ff ff       	call   c010028a <cprintf>
c0104179:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c010417c:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104181:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0104184:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104189:	83 f8 09             	cmp    $0x9,%eax
c010418c:	74 16                	je     c01041a4 <_fifo_check_swap+0x236>
c010418e:	68 8a 91 10 c0       	push   $0xc010918a
c0104193:	68 36 90 10 c0       	push   $0xc0109036
c0104198:	6a 68                	push   $0x68
c010419a:	68 4b 90 10 c0       	push   $0xc010904b
c010419f:	e8 4c c2 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01041a4:	83 ec 0c             	sub    $0xc,%esp
c01041a7:	68 28 91 10 c0       	push   $0xc0109128
c01041ac:	e8 d9 c0 ff ff       	call   c010028a <cprintf>
c01041b1:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c01041b4:	b8 00 50 00 00       	mov    $0x5000,%eax
c01041b9:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c01041bc:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c01041c1:	83 f8 0a             	cmp    $0xa,%eax
c01041c4:	74 16                	je     c01041dc <_fifo_check_swap+0x26e>
c01041c6:	68 99 91 10 c0       	push   $0xc0109199
c01041cb:	68 36 90 10 c0       	push   $0xc0109036
c01041d0:	6a 6b                	push   $0x6b
c01041d2:	68 4b 90 10 c0       	push   $0xc010904b
c01041d7:	e8 14 c2 ff ff       	call   c01003f0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01041dc:	83 ec 0c             	sub    $0xc,%esp
c01041df:	68 b0 90 10 c0       	push   $0xc01090b0
c01041e4:	e8 a1 c0 ff ff       	call   c010028a <cprintf>
c01041e9:	83 c4 10             	add    $0x10,%esp
    assert(*(unsigned char *)0x1000 == 0x0a);
c01041ec:	b8 00 10 00 00       	mov    $0x1000,%eax
c01041f1:	0f b6 00             	movzbl (%eax),%eax
c01041f4:	3c 0a                	cmp    $0xa,%al
c01041f6:	74 16                	je     c010420e <_fifo_check_swap+0x2a0>
c01041f8:	68 ac 91 10 c0       	push   $0xc01091ac
c01041fd:	68 36 90 10 c0       	push   $0xc0109036
c0104202:	6a 6d                	push   $0x6d
c0104204:	68 4b 90 10 c0       	push   $0xc010904b
c0104209:	e8 e2 c1 ff ff       	call   c01003f0 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c010420e:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104213:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0104216:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c010421b:	83 f8 0b             	cmp    $0xb,%eax
c010421e:	74 16                	je     c0104236 <_fifo_check_swap+0x2c8>
c0104220:	68 cd 91 10 c0       	push   $0xc01091cd
c0104225:	68 36 90 10 c0       	push   $0xc0109036
c010422a:	6a 6f                	push   $0x6f
c010422c:	68 4b 90 10 c0       	push   $0xc010904b
c0104231:	e8 ba c1 ff ff       	call   c01003f0 <__panic>
    return 0;
c0104236:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010423b:	c9                   	leave  
c010423c:	c3                   	ret    

c010423d <_fifo_init>:


static int
_fifo_init(void)
{
c010423d:	55                   	push   %ebp
c010423e:	89 e5                	mov    %esp,%ebp
    return 0;
c0104240:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104245:	5d                   	pop    %ebp
c0104246:	c3                   	ret    

c0104247 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104247:	55                   	push   %ebp
c0104248:	89 e5                	mov    %esp,%ebp
    return 0;
c010424a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010424f:	5d                   	pop    %ebp
c0104250:	c3                   	ret    

c0104251 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0104251:	55                   	push   %ebp
c0104252:	89 e5                	mov    %esp,%ebp
c0104254:	b8 00 00 00 00       	mov    $0x0,%eax
c0104259:	5d                   	pop    %ebp
c010425a:	c3                   	ret    

c010425b <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c010425b:	55                   	push   %ebp
c010425c:	89 e5                	mov    %esp,%ebp
c010425e:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0104261:	8b 45 08             	mov    0x8(%ebp),%eax
c0104264:	c1 e8 0c             	shr    $0xc,%eax
c0104267:	89 c2                	mov    %eax,%edx
c0104269:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c010426e:	39 c2                	cmp    %eax,%edx
c0104270:	72 14                	jb     c0104286 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0104272:	83 ec 04             	sub    $0x4,%esp
c0104275:	68 f0 91 10 c0       	push   $0xc01091f0
c010427a:	6a 5b                	push   $0x5b
c010427c:	68 0f 92 10 c0       	push   $0xc010920f
c0104281:	e8 6a c1 ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0104286:	a1 58 31 12 c0       	mov    0xc0123158,%eax
c010428b:	8b 55 08             	mov    0x8(%ebp),%edx
c010428e:	c1 ea 0c             	shr    $0xc,%edx
c0104291:	c1 e2 05             	shl    $0x5,%edx
c0104294:	01 d0                	add    %edx,%eax
}
c0104296:	c9                   	leave  
c0104297:	c3                   	ret    

c0104298 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104298:	55                   	push   %ebp
c0104299:	89 e5                	mov    %esp,%ebp
c010429b:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c010429e:	8b 45 08             	mov    0x8(%ebp),%eax
c01042a1:	83 e0 01             	and    $0x1,%eax
c01042a4:	85 c0                	test   %eax,%eax
c01042a6:	75 14                	jne    c01042bc <pte2page+0x24>
        panic("pte2page called with invalid pte");
c01042a8:	83 ec 04             	sub    $0x4,%esp
c01042ab:	68 20 92 10 c0       	push   $0xc0109220
c01042b0:	6a 6d                	push   $0x6d
c01042b2:	68 0f 92 10 c0       	push   $0xc010920f
c01042b7:	e8 34 c1 ff ff       	call   c01003f0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01042bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01042bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042c4:	83 ec 0c             	sub    $0xc,%esp
c01042c7:	50                   	push   %eax
c01042c8:	e8 8e ff ff ff       	call   c010425b <pa2page>
c01042cd:	83 c4 10             	add    $0x10,%esp
}
c01042d0:	c9                   	leave  
c01042d1:	c3                   	ret    

c01042d2 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01042d2:	55                   	push   %ebp
c01042d3:	89 e5                	mov    %esp,%ebp
c01042d5:	83 ec 18             	sub    $0x18,%esp
     swapfs_init();
c01042d8:	e8 dc 33 00 00       	call   c01076b9 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01042dd:	a1 1c 31 12 c0       	mov    0xc012311c,%eax
c01042e2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01042e7:	76 0c                	jbe    c01042f5 <swap_init+0x23>
c01042e9:	a1 1c 31 12 c0       	mov    0xc012311c,%eax
c01042ee:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01042f3:	76 17                	jbe    c010430c <swap_init+0x3a>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01042f5:	a1 1c 31 12 c0       	mov    0xc012311c,%eax
c01042fa:	50                   	push   %eax
c01042fb:	68 41 92 10 c0       	push   $0xc0109241
c0104300:	6a 25                	push   $0x25
c0104302:	68 5c 92 10 c0       	push   $0xc010925c
c0104307:	e8 e4 c0 ff ff       	call   c01003f0 <__panic>
     }
     

     sm = &swap_manager_fifo;
c010430c:	c7 05 70 2f 12 c0 e0 	movl   $0xc011f9e0,0xc0122f70
c0104313:	f9 11 c0 
     int r = sm->init();
c0104316:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c010431b:	8b 40 04             	mov    0x4(%eax),%eax
c010431e:	ff d0                	call   *%eax
c0104320:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0104323:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104327:	75 27                	jne    c0104350 <swap_init+0x7e>
     {
          swap_init_ok = 1;
c0104329:	c7 05 68 2f 12 c0 01 	movl   $0x1,0xc0122f68
c0104330:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0104333:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c0104338:	8b 00                	mov    (%eax),%eax
c010433a:	83 ec 08             	sub    $0x8,%esp
c010433d:	50                   	push   %eax
c010433e:	68 6b 92 10 c0       	push   $0xc010926b
c0104343:	e8 42 bf ff ff       	call   c010028a <cprintf>
c0104348:	83 c4 10             	add    $0x10,%esp
          check_swap();
c010434b:	e8 f7 03 00 00       	call   c0104747 <check_swap>
     }

     return r;
c0104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104353:	c9                   	leave  
c0104354:	c3                   	ret    

c0104355 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0104355:	55                   	push   %ebp
c0104356:	89 e5                	mov    %esp,%ebp
c0104358:	83 ec 08             	sub    $0x8,%esp
     return sm->init_mm(mm);
c010435b:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c0104360:	8b 40 08             	mov    0x8(%eax),%eax
c0104363:	83 ec 0c             	sub    $0xc,%esp
c0104366:	ff 75 08             	pushl  0x8(%ebp)
c0104369:	ff d0                	call   *%eax
c010436b:	83 c4 10             	add    $0x10,%esp
}
c010436e:	c9                   	leave  
c010436f:	c3                   	ret    

c0104370 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0104370:	55                   	push   %ebp
c0104371:	89 e5                	mov    %esp,%ebp
c0104373:	83 ec 08             	sub    $0x8,%esp
     return sm->tick_event(mm);
c0104376:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c010437b:	8b 40 0c             	mov    0xc(%eax),%eax
c010437e:	83 ec 0c             	sub    $0xc,%esp
c0104381:	ff 75 08             	pushl  0x8(%ebp)
c0104384:	ff d0                	call   *%eax
c0104386:	83 c4 10             	add    $0x10,%esp
}
c0104389:	c9                   	leave  
c010438a:	c3                   	ret    

c010438b <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010438b:	55                   	push   %ebp
c010438c:	89 e5                	mov    %esp,%ebp
c010438e:	83 ec 08             	sub    $0x8,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0104391:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c0104396:	8b 40 10             	mov    0x10(%eax),%eax
c0104399:	ff 75 14             	pushl  0x14(%ebp)
c010439c:	ff 75 10             	pushl  0x10(%ebp)
c010439f:	ff 75 0c             	pushl  0xc(%ebp)
c01043a2:	ff 75 08             	pushl  0x8(%ebp)
c01043a5:	ff d0                	call   *%eax
c01043a7:	83 c4 10             	add    $0x10,%esp
}
c01043aa:	c9                   	leave  
c01043ab:	c3                   	ret    

c01043ac <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01043ac:	55                   	push   %ebp
c01043ad:	89 e5                	mov    %esp,%ebp
c01043af:	83 ec 08             	sub    $0x8,%esp
     return sm->set_unswappable(mm, addr);
c01043b2:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c01043b7:	8b 40 14             	mov    0x14(%eax),%eax
c01043ba:	83 ec 08             	sub    $0x8,%esp
c01043bd:	ff 75 0c             	pushl  0xc(%ebp)
c01043c0:	ff 75 08             	pushl  0x8(%ebp)
c01043c3:	ff d0                	call   *%eax
c01043c5:	83 c4 10             	add    $0x10,%esp
}
c01043c8:	c9                   	leave  
c01043c9:	c3                   	ret    

c01043ca <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01043ca:	55                   	push   %ebp
c01043cb:	89 e5                	mov    %esp,%ebp
c01043cd:	83 ec 28             	sub    $0x28,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01043d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01043d7:	e9 2e 01 00 00       	jmp    c010450a <swap_out+0x140>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01043dc:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c01043e1:	8b 40 18             	mov    0x18(%eax),%eax
c01043e4:	83 ec 04             	sub    $0x4,%esp
c01043e7:	ff 75 10             	pushl  0x10(%ebp)
c01043ea:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01043ed:	52                   	push   %edx
c01043ee:	ff 75 08             	pushl  0x8(%ebp)
c01043f1:	ff d0                	call   *%eax
c01043f3:	83 c4 10             	add    $0x10,%esp
c01043f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01043f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043fd:	74 18                	je     c0104417 <swap_out+0x4d>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01043ff:	83 ec 08             	sub    $0x8,%esp
c0104402:	ff 75 f4             	pushl  -0xc(%ebp)
c0104405:	68 80 92 10 c0       	push   $0xc0109280
c010440a:	e8 7b be ff ff       	call   c010028a <cprintf>
c010440f:	83 c4 10             	add    $0x10,%esp
c0104412:	e9 ff 00 00 00       	jmp    c0104516 <swap_out+0x14c>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0104417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010441a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010441d:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0104420:	8b 45 08             	mov    0x8(%ebp),%eax
c0104423:	8b 40 0c             	mov    0xc(%eax),%eax
c0104426:	83 ec 04             	sub    $0x4,%esp
c0104429:	6a 00                	push   $0x0
c010442b:	ff 75 ec             	pushl  -0x14(%ebp)
c010442e:	50                   	push   %eax
c010442f:	e8 39 22 00 00       	call   c010666d <get_pte>
c0104434:	83 c4 10             	add    $0x10,%esp
c0104437:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010443a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010443d:	8b 00                	mov    (%eax),%eax
c010443f:	83 e0 01             	and    $0x1,%eax
c0104442:	85 c0                	test   %eax,%eax
c0104444:	75 16                	jne    c010445c <swap_out+0x92>
c0104446:	68 ad 92 10 c0       	push   $0xc01092ad
c010444b:	68 c2 92 10 c0       	push   $0xc01092c2
c0104450:	6a 65                	push   $0x65
c0104452:	68 5c 92 10 c0       	push   $0xc010925c
c0104457:	e8 94 bf ff ff       	call   c01003f0 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010445c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010445f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104462:	8b 52 1c             	mov    0x1c(%edx),%edx
c0104465:	c1 ea 0c             	shr    $0xc,%edx
c0104468:	83 c2 01             	add    $0x1,%edx
c010446b:	c1 e2 08             	shl    $0x8,%edx
c010446e:	83 ec 08             	sub    $0x8,%esp
c0104471:	50                   	push   %eax
c0104472:	52                   	push   %edx
c0104473:	e8 dd 32 00 00       	call   c0107755 <swapfs_write>
c0104478:	83 c4 10             	add    $0x10,%esp
c010447b:	85 c0                	test   %eax,%eax
c010447d:	74 2b                	je     c01044aa <swap_out+0xe0>
                    cprintf("SWAP: failed to save\n");
c010447f:	83 ec 0c             	sub    $0xc,%esp
c0104482:	68 d7 92 10 c0       	push   $0xc01092d7
c0104487:	e8 fe bd ff ff       	call   c010028a <cprintf>
c010448c:	83 c4 10             	add    $0x10,%esp
                    sm->map_swappable(mm, v, page, 0);
c010448f:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c0104494:	8b 40 10             	mov    0x10(%eax),%eax
c0104497:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010449a:	6a 00                	push   $0x0
c010449c:	52                   	push   %edx
c010449d:	ff 75 ec             	pushl  -0x14(%ebp)
c01044a0:	ff 75 08             	pushl  0x8(%ebp)
c01044a3:	ff d0                	call   *%eax
c01044a5:	83 c4 10             	add    $0x10,%esp
c01044a8:	eb 5c                	jmp    c0104506 <swap_out+0x13c>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01044aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044ad:	8b 40 1c             	mov    0x1c(%eax),%eax
c01044b0:	c1 e8 0c             	shr    $0xc,%eax
c01044b3:	83 c0 01             	add    $0x1,%eax
c01044b6:	50                   	push   %eax
c01044b7:	ff 75 ec             	pushl  -0x14(%ebp)
c01044ba:	ff 75 f4             	pushl  -0xc(%ebp)
c01044bd:	68 f0 92 10 c0       	push   $0xc01092f0
c01044c2:	e8 c3 bd ff ff       	call   c010028a <cprintf>
c01044c7:	83 c4 10             	add    $0x10,%esp
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01044ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044cd:	8b 40 1c             	mov    0x1c(%eax),%eax
c01044d0:	c1 e8 0c             	shr    $0xc,%eax
c01044d3:	83 c0 01             	add    $0x1,%eax
c01044d6:	c1 e0 08             	shl    $0x8,%eax
c01044d9:	89 c2                	mov    %eax,%edx
c01044db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044de:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01044e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044e3:	83 ec 08             	sub    $0x8,%esp
c01044e6:	6a 01                	push   $0x1
c01044e8:	50                   	push   %eax
c01044e9:	e8 84 1b 00 00       	call   c0106072 <free_pages>
c01044ee:	83 c4 10             	add    $0x10,%esp
          }
          
          tlb_invalidate(mm->pgdir, v);
c01044f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f4:	8b 40 0c             	mov    0xc(%eax),%eax
c01044f7:	83 ec 08             	sub    $0x8,%esp
c01044fa:	ff 75 ec             	pushl  -0x14(%ebp)
c01044fd:	50                   	push   %eax
c01044fe:	e8 62 24 00 00       	call   c0106965 <tlb_invalidate>
c0104503:	83 c4 10             	add    $0x10,%esp

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0104506:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010450a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010450d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104510:	0f 85 c6 fe ff ff    	jne    c01043dc <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0104516:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104519:	c9                   	leave  
c010451a:	c3                   	ret    

c010451b <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c010451b:	55                   	push   %ebp
c010451c:	89 e5                	mov    %esp,%ebp
c010451e:	83 ec 18             	sub    $0x18,%esp
     struct Page *result = alloc_page();
c0104521:	83 ec 0c             	sub    $0xc,%esp
c0104524:	6a 01                	push   $0x1
c0104526:	e8 db 1a 00 00       	call   c0106006 <alloc_pages>
c010452b:	83 c4 10             	add    $0x10,%esp
c010452e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0104531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104535:	75 16                	jne    c010454d <swap_in+0x32>
c0104537:	68 30 93 10 c0       	push   $0xc0109330
c010453c:	68 c2 92 10 c0       	push   $0xc01092c2
c0104541:	6a 7b                	push   $0x7b
c0104543:	68 5c 92 10 c0       	push   $0xc010925c
c0104548:	e8 a3 be ff ff       	call   c01003f0 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010454d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104550:	8b 40 0c             	mov    0xc(%eax),%eax
c0104553:	83 ec 04             	sub    $0x4,%esp
c0104556:	6a 00                	push   $0x0
c0104558:	ff 75 0c             	pushl  0xc(%ebp)
c010455b:	50                   	push   %eax
c010455c:	e8 0c 21 00 00       	call   c010666d <get_pte>
c0104561:	83 c4 10             	add    $0x10,%esp
c0104564:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0104567:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010456a:	8b 00                	mov    (%eax),%eax
c010456c:	83 ec 08             	sub    $0x8,%esp
c010456f:	ff 75 f4             	pushl  -0xc(%ebp)
c0104572:	50                   	push   %eax
c0104573:	e8 84 31 00 00       	call   c01076fc <swapfs_read>
c0104578:	83 c4 10             	add    $0x10,%esp
c010457b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010457e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104582:	74 1f                	je     c01045a3 <swap_in+0x88>
     {
        assert(r!=0);
c0104584:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104588:	75 19                	jne    c01045a3 <swap_in+0x88>
c010458a:	68 3d 93 10 c0       	push   $0xc010933d
c010458f:	68 c2 92 10 c0       	push   $0xc01092c2
c0104594:	68 83 00 00 00       	push   $0x83
c0104599:	68 5c 92 10 c0       	push   $0xc010925c
c010459e:	e8 4d be ff ff       	call   c01003f0 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01045a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a6:	8b 00                	mov    (%eax),%eax
c01045a8:	c1 e8 08             	shr    $0x8,%eax
c01045ab:	83 ec 04             	sub    $0x4,%esp
c01045ae:	ff 75 0c             	pushl  0xc(%ebp)
c01045b1:	50                   	push   %eax
c01045b2:	68 44 93 10 c0       	push   $0xc0109344
c01045b7:	e8 ce bc ff ff       	call   c010028a <cprintf>
c01045bc:	83 c4 10             	add    $0x10,%esp
     *ptr_result=result;
c01045bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01045c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01045c5:	89 10                	mov    %edx,(%eax)
     return 0;
c01045c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045cc:	c9                   	leave  
c01045cd:	c3                   	ret    

c01045ce <check_content_set>:



static inline void
check_content_set(void)
{
c01045ce:	55                   	push   %ebp
c01045cf:	89 e5                	mov    %esp,%ebp
c01045d1:	83 ec 08             	sub    $0x8,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01045d4:	b8 00 10 00 00       	mov    $0x1000,%eax
c01045d9:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01045dc:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c01045e1:	83 f8 01             	cmp    $0x1,%eax
c01045e4:	74 19                	je     c01045ff <check_content_set+0x31>
c01045e6:	68 82 93 10 c0       	push   $0xc0109382
c01045eb:	68 c2 92 10 c0       	push   $0xc01092c2
c01045f0:	68 90 00 00 00       	push   $0x90
c01045f5:	68 5c 92 10 c0       	push   $0xc010925c
c01045fa:	e8 f1 bd ff ff       	call   c01003f0 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01045ff:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104604:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104607:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c010460c:	83 f8 01             	cmp    $0x1,%eax
c010460f:	74 19                	je     c010462a <check_content_set+0x5c>
c0104611:	68 82 93 10 c0       	push   $0xc0109382
c0104616:	68 c2 92 10 c0       	push   $0xc01092c2
c010461b:	68 92 00 00 00       	push   $0x92
c0104620:	68 5c 92 10 c0       	push   $0xc010925c
c0104625:	e8 c6 bd ff ff       	call   c01003f0 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010462a:	b8 00 20 00 00       	mov    $0x2000,%eax
c010462f:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104632:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104637:	83 f8 02             	cmp    $0x2,%eax
c010463a:	74 19                	je     c0104655 <check_content_set+0x87>
c010463c:	68 91 93 10 c0       	push   $0xc0109391
c0104641:	68 c2 92 10 c0       	push   $0xc01092c2
c0104646:	68 94 00 00 00       	push   $0x94
c010464b:	68 5c 92 10 c0       	push   $0xc010925c
c0104650:	e8 9b bd ff ff       	call   c01003f0 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0104655:	b8 10 20 00 00       	mov    $0x2010,%eax
c010465a:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010465d:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c0104662:	83 f8 02             	cmp    $0x2,%eax
c0104665:	74 19                	je     c0104680 <check_content_set+0xb2>
c0104667:	68 91 93 10 c0       	push   $0xc0109391
c010466c:	68 c2 92 10 c0       	push   $0xc01092c2
c0104671:	68 96 00 00 00       	push   $0x96
c0104676:	68 5c 92 10 c0       	push   $0xc010925c
c010467b:	e8 70 bd ff ff       	call   c01003f0 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0104680:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104685:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0104688:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c010468d:	83 f8 03             	cmp    $0x3,%eax
c0104690:	74 19                	je     c01046ab <check_content_set+0xdd>
c0104692:	68 a0 93 10 c0       	push   $0xc01093a0
c0104697:	68 c2 92 10 c0       	push   $0xc01092c2
c010469c:	68 98 00 00 00       	push   $0x98
c01046a1:	68 5c 92 10 c0       	push   $0xc010925c
c01046a6:	e8 45 bd ff ff       	call   c01003f0 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01046ab:	b8 10 30 00 00       	mov    $0x3010,%eax
c01046b0:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01046b3:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c01046b8:	83 f8 03             	cmp    $0x3,%eax
c01046bb:	74 19                	je     c01046d6 <check_content_set+0x108>
c01046bd:	68 a0 93 10 c0       	push   $0xc01093a0
c01046c2:	68 c2 92 10 c0       	push   $0xc01092c2
c01046c7:	68 9a 00 00 00       	push   $0x9a
c01046cc:	68 5c 92 10 c0       	push   $0xc010925c
c01046d1:	e8 1a bd ff ff       	call   c01003f0 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01046d6:	b8 00 40 00 00       	mov    $0x4000,%eax
c01046db:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01046de:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c01046e3:	83 f8 04             	cmp    $0x4,%eax
c01046e6:	74 19                	je     c0104701 <check_content_set+0x133>
c01046e8:	68 af 93 10 c0       	push   $0xc01093af
c01046ed:	68 c2 92 10 c0       	push   $0xc01092c2
c01046f2:	68 9c 00 00 00       	push   $0x9c
c01046f7:	68 5c 92 10 c0       	push   $0xc010925c
c01046fc:	e8 ef bc ff ff       	call   c01003f0 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0104701:	b8 10 40 00 00       	mov    $0x4010,%eax
c0104706:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104709:	a1 64 2f 12 c0       	mov    0xc0122f64,%eax
c010470e:	83 f8 04             	cmp    $0x4,%eax
c0104711:	74 19                	je     c010472c <check_content_set+0x15e>
c0104713:	68 af 93 10 c0       	push   $0xc01093af
c0104718:	68 c2 92 10 c0       	push   $0xc01092c2
c010471d:	68 9e 00 00 00       	push   $0x9e
c0104722:	68 5c 92 10 c0       	push   $0xc010925c
c0104727:	e8 c4 bc ff ff       	call   c01003f0 <__panic>
}
c010472c:	90                   	nop
c010472d:	c9                   	leave  
c010472e:	c3                   	ret    

c010472f <check_content_access>:

static inline int
check_content_access(void)
{
c010472f:	55                   	push   %ebp
c0104730:	89 e5                	mov    %esp,%ebp
c0104732:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0104735:	a1 70 2f 12 c0       	mov    0xc0122f70,%eax
c010473a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010473d:	ff d0                	call   *%eax
c010473f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0104742:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104745:	c9                   	leave  
c0104746:	c3                   	ret    

c0104747 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0104747:	55                   	push   %ebp
c0104748:	89 e5                	mov    %esp,%ebp
c010474a:	83 ec 68             	sub    $0x68,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010474d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104754:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010475b:	c7 45 e8 44 31 12 c0 	movl   $0xc0123144,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104762:	eb 60                	jmp    c01047c4 <check_swap+0x7d>
        struct Page *p = le2page(le, page_link);
c0104764:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104767:	83 e8 0c             	sub    $0xc,%eax
c010476a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(PageProperty(p));
c010476d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104770:	83 c0 04             	add    $0x4,%eax
c0104773:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010477a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010477d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104780:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104783:	0f a3 10             	bt     %edx,(%eax)
c0104786:	19 c0                	sbb    %eax,%eax
c0104788:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c010478b:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c010478f:	0f 95 c0             	setne  %al
c0104792:	0f b6 c0             	movzbl %al,%eax
c0104795:	85 c0                	test   %eax,%eax
c0104797:	75 19                	jne    c01047b2 <check_swap+0x6b>
c0104799:	68 be 93 10 c0       	push   $0xc01093be
c010479e:	68 c2 92 10 c0       	push   $0xc01092c2
c01047a3:	68 b9 00 00 00       	push   $0xb9
c01047a8:	68 5c 92 10 c0       	push   $0xc010925c
c01047ad:	e8 3e bc ff ff       	call   c01003f0 <__panic>
        count ++, total += p->property;
c01047b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01047b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047b9:	8b 50 08             	mov    0x8(%eax),%edx
c01047bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047bf:	01 d0                	add    %edx,%eax
c01047c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01047c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01047ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047cd:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01047d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01047d3:	81 7d e8 44 31 12 c0 	cmpl   $0xc0123144,-0x18(%ebp)
c01047da:	75 88                	jne    c0104764 <check_swap+0x1d>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01047dc:	e8 c6 18 00 00       	call   c01060a7 <nr_free_pages>
c01047e1:	89 c2                	mov    %eax,%edx
c01047e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047e6:	39 c2                	cmp    %eax,%edx
c01047e8:	74 19                	je     c0104803 <check_swap+0xbc>
c01047ea:	68 ce 93 10 c0       	push   $0xc01093ce
c01047ef:	68 c2 92 10 c0       	push   $0xc01092c2
c01047f4:	68 bc 00 00 00       	push   $0xbc
c01047f9:	68 5c 92 10 c0       	push   $0xc010925c
c01047fe:	e8 ed bb ff ff       	call   c01003f0 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0104803:	83 ec 04             	sub    $0x4,%esp
c0104806:	ff 75 f0             	pushl  -0x10(%ebp)
c0104809:	ff 75 f4             	pushl  -0xc(%ebp)
c010480c:	68 e8 93 10 c0       	push   $0xc01093e8
c0104811:	e8 74 ba ff ff       	call   c010028a <cprintf>
c0104816:	83 c4 10             	add    $0x10,%esp
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0104819:	e8 24 eb ff ff       	call   c0103342 <mm_create>
c010481e:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(mm != NULL);
c0104821:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104825:	75 19                	jne    c0104840 <check_swap+0xf9>
c0104827:	68 0e 94 10 c0       	push   $0xc010940e
c010482c:	68 c2 92 10 c0       	push   $0xc01092c2
c0104831:	68 c1 00 00 00       	push   $0xc1
c0104836:	68 5c 92 10 c0       	push   $0xc010925c
c010483b:	e8 b0 bb ff ff       	call   c01003f0 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0104840:	a1 70 30 12 c0       	mov    0xc0123070,%eax
c0104845:	85 c0                	test   %eax,%eax
c0104847:	74 19                	je     c0104862 <check_swap+0x11b>
c0104849:	68 19 94 10 c0       	push   $0xc0109419
c010484e:	68 c2 92 10 c0       	push   $0xc01092c2
c0104853:	68 c4 00 00 00       	push   $0xc4
c0104858:	68 5c 92 10 c0       	push   $0xc010925c
c010485d:	e8 8e bb ff ff       	call   c01003f0 <__panic>

     check_mm_struct = mm;
c0104862:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104865:	a3 70 30 12 c0       	mov    %eax,0xc0123070

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010486a:	8b 15 00 fa 11 c0    	mov    0xc011fa00,%edx
c0104870:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104873:	89 50 0c             	mov    %edx,0xc(%eax)
c0104876:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104879:	8b 40 0c             	mov    0xc(%eax),%eax
c010487c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(pgdir[0] == 0);
c010487f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104882:	8b 00                	mov    (%eax),%eax
c0104884:	85 c0                	test   %eax,%eax
c0104886:	74 19                	je     c01048a1 <check_swap+0x15a>
c0104888:	68 31 94 10 c0       	push   $0xc0109431
c010488d:	68 c2 92 10 c0       	push   $0xc01092c2
c0104892:	68 c9 00 00 00       	push   $0xc9
c0104897:	68 5c 92 10 c0       	push   $0xc010925c
c010489c:	e8 4f bb ff ff       	call   c01003f0 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01048a1:	83 ec 04             	sub    $0x4,%esp
c01048a4:	6a 03                	push   $0x3
c01048a6:	68 00 60 00 00       	push   $0x6000
c01048ab:	68 00 10 00 00       	push   $0x1000
c01048b0:	e8 09 eb ff ff       	call   c01033be <vma_create>
c01048b5:	83 c4 10             	add    $0x10,%esp
c01048b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(vma != NULL);
c01048bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01048bf:	75 19                	jne    c01048da <check_swap+0x193>
c01048c1:	68 3f 94 10 c0       	push   $0xc010943f
c01048c6:	68 c2 92 10 c0       	push   $0xc01092c2
c01048cb:	68 cc 00 00 00       	push   $0xcc
c01048d0:	68 5c 92 10 c0       	push   $0xc010925c
c01048d5:	e8 16 bb ff ff       	call   c01003f0 <__panic>

     insert_vma_struct(mm, vma);
c01048da:	83 ec 08             	sub    $0x8,%esp
c01048dd:	ff 75 d0             	pushl  -0x30(%ebp)
c01048e0:	ff 75 d8             	pushl  -0x28(%ebp)
c01048e3:	e8 3e ec ff ff       	call   c0103526 <insert_vma_struct>
c01048e8:	83 c4 10             	add    $0x10,%esp

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01048eb:	83 ec 0c             	sub    $0xc,%esp
c01048ee:	68 4c 94 10 c0       	push   $0xc010944c
c01048f3:	e8 92 b9 ff ff       	call   c010028a <cprintf>
c01048f8:	83 c4 10             	add    $0x10,%esp
     pte_t *temp_ptep=NULL;
c01048fb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0104902:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104905:	8b 40 0c             	mov    0xc(%eax),%eax
c0104908:	83 ec 04             	sub    $0x4,%esp
c010490b:	6a 01                	push   $0x1
c010490d:	68 00 10 00 00       	push   $0x1000
c0104912:	50                   	push   %eax
c0104913:	e8 55 1d 00 00       	call   c010666d <get_pte>
c0104918:	83 c4 10             	add    $0x10,%esp
c010491b:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(temp_ptep!= NULL);
c010491e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104922:	75 19                	jne    c010493d <check_swap+0x1f6>
c0104924:	68 80 94 10 c0       	push   $0xc0109480
c0104929:	68 c2 92 10 c0       	push   $0xc01092c2
c010492e:	68 d4 00 00 00       	push   $0xd4
c0104933:	68 5c 92 10 c0       	push   $0xc010925c
c0104938:	e8 b3 ba ff ff       	call   c01003f0 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c010493d:	83 ec 0c             	sub    $0xc,%esp
c0104940:	68 94 94 10 c0       	push   $0xc0109494
c0104945:	e8 40 b9 ff ff       	call   c010028a <cprintf>
c010494a:	83 c4 10             	add    $0x10,%esp
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010494d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104954:	e9 90 00 00 00       	jmp    c01049e9 <check_swap+0x2a2>
          check_rp[i] = alloc_page();
c0104959:	83 ec 0c             	sub    $0xc,%esp
c010495c:	6a 01                	push   $0x1
c010495e:	e8 a3 16 00 00       	call   c0106006 <alloc_pages>
c0104963:	83 c4 10             	add    $0x10,%esp
c0104966:	89 c2                	mov    %eax,%edx
c0104968:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010496b:	89 14 85 80 30 12 c0 	mov    %edx,-0x3fedcf80(,%eax,4)
          assert(check_rp[i] != NULL );
c0104972:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104975:	8b 04 85 80 30 12 c0 	mov    -0x3fedcf80(,%eax,4),%eax
c010497c:	85 c0                	test   %eax,%eax
c010497e:	75 19                	jne    c0104999 <check_swap+0x252>
c0104980:	68 b8 94 10 c0       	push   $0xc01094b8
c0104985:	68 c2 92 10 c0       	push   $0xc01092c2
c010498a:	68 d9 00 00 00       	push   $0xd9
c010498f:	68 5c 92 10 c0       	push   $0xc010925c
c0104994:	e8 57 ba ff ff       	call   c01003f0 <__panic>
          assert(!PageProperty(check_rp[i]));
c0104999:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010499c:	8b 04 85 80 30 12 c0 	mov    -0x3fedcf80(,%eax,4),%eax
c01049a3:	83 c0 04             	add    $0x4,%eax
c01049a6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01049ad:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01049b0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01049b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01049b6:	0f a3 10             	bt     %edx,(%eax)
c01049b9:	19 c0                	sbb    %eax,%eax
c01049bb:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c01049be:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c01049c2:	0f 95 c0             	setne  %al
c01049c5:	0f b6 c0             	movzbl %al,%eax
c01049c8:	85 c0                	test   %eax,%eax
c01049ca:	74 19                	je     c01049e5 <check_swap+0x29e>
c01049cc:	68 cc 94 10 c0       	push   $0xc01094cc
c01049d1:	68 c2 92 10 c0       	push   $0xc01092c2
c01049d6:	68 da 00 00 00       	push   $0xda
c01049db:	68 5c 92 10 c0       	push   $0xc010925c
c01049e0:	e8 0b ba ff ff       	call   c01003f0 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01049e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01049e9:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01049ed:	0f 8e 66 ff ff ff    	jle    c0104959 <check_swap+0x212>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01049f3:	a1 44 31 12 c0       	mov    0xc0123144,%eax
c01049f8:	8b 15 48 31 12 c0    	mov    0xc0123148,%edx
c01049fe:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a01:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0104a04:	c7 45 c0 44 31 12 c0 	movl   $0xc0123144,-0x40(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104a0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104a0e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104a11:	89 50 04             	mov    %edx,0x4(%eax)
c0104a14:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104a17:	8b 50 04             	mov    0x4(%eax),%edx
c0104a1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104a1d:	89 10                	mov    %edx,(%eax)
c0104a1f:	c7 45 c8 44 31 12 c0 	movl   $0xc0123144,-0x38(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104a26:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a29:	8b 40 04             	mov    0x4(%eax),%eax
c0104a2c:	39 45 c8             	cmp    %eax,-0x38(%ebp)
c0104a2f:	0f 94 c0             	sete   %al
c0104a32:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0104a35:	85 c0                	test   %eax,%eax
c0104a37:	75 19                	jne    c0104a52 <check_swap+0x30b>
c0104a39:	68 e7 94 10 c0       	push   $0xc01094e7
c0104a3e:	68 c2 92 10 c0       	push   $0xc01092c2
c0104a43:	68 de 00 00 00       	push   $0xde
c0104a48:	68 5c 92 10 c0       	push   $0xc010925c
c0104a4d:	e8 9e b9 ff ff       	call   c01003f0 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0104a52:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0104a57:	89 45 bc             	mov    %eax,-0x44(%ebp)
     nr_free = 0;
c0104a5a:	c7 05 4c 31 12 c0 00 	movl   $0x0,0xc012314c
c0104a61:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104a64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104a6b:	eb 1c                	jmp    c0104a89 <check_swap+0x342>
        free_pages(check_rp[i],1);
c0104a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a70:	8b 04 85 80 30 12 c0 	mov    -0x3fedcf80(,%eax,4),%eax
c0104a77:	83 ec 08             	sub    $0x8,%esp
c0104a7a:	6a 01                	push   $0x1
c0104a7c:	50                   	push   %eax
c0104a7d:	e8 f0 15 00 00       	call   c0106072 <free_pages>
c0104a82:	83 c4 10             	add    $0x10,%esp
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104a85:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104a89:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104a8d:	7e de                	jle    c0104a6d <check_swap+0x326>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0104a8f:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0104a94:	83 f8 04             	cmp    $0x4,%eax
c0104a97:	74 19                	je     c0104ab2 <check_swap+0x36b>
c0104a99:	68 00 95 10 c0       	push   $0xc0109500
c0104a9e:	68 c2 92 10 c0       	push   $0xc01092c2
c0104aa3:	68 e7 00 00 00       	push   $0xe7
c0104aa8:	68 5c 92 10 c0       	push   $0xc010925c
c0104aad:	e8 3e b9 ff ff       	call   c01003f0 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0104ab2:	83 ec 0c             	sub    $0xc,%esp
c0104ab5:	68 24 95 10 c0       	push   $0xc0109524
c0104aba:	e8 cb b7 ff ff       	call   c010028a <cprintf>
c0104abf:	83 c4 10             	add    $0x10,%esp
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0104ac2:	c7 05 64 2f 12 c0 00 	movl   $0x0,0xc0122f64
c0104ac9:	00 00 00 
     
     check_content_set();
c0104acc:	e8 fd fa ff ff       	call   c01045ce <check_content_set>
     assert( nr_free == 0);         
c0104ad1:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0104ad6:	85 c0                	test   %eax,%eax
c0104ad8:	74 19                	je     c0104af3 <check_swap+0x3ac>
c0104ada:	68 4b 95 10 c0       	push   $0xc010954b
c0104adf:	68 c2 92 10 c0       	push   $0xc01092c2
c0104ae4:	68 f0 00 00 00       	push   $0xf0
c0104ae9:	68 5c 92 10 c0       	push   $0xc010925c
c0104aee:	e8 fd b8 ff ff       	call   c01003f0 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104af3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104afa:	eb 26                	jmp    c0104b22 <check_swap+0x3db>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0104afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aff:	c7 04 85 a0 30 12 c0 	movl   $0xffffffff,-0x3fedcf60(,%eax,4)
c0104b06:	ff ff ff ff 
c0104b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b0d:	8b 14 85 a0 30 12 c0 	mov    -0x3fedcf60(,%eax,4),%edx
c0104b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b17:	89 14 85 e0 30 12 c0 	mov    %edx,-0x3fedcf20(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104b1e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104b22:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0104b26:	7e d4                	jle    c0104afc <check_swap+0x3b5>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104b28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b2f:	e9 cc 00 00 00       	jmp    c0104c00 <check_swap+0x4b9>
         check_ptep[i]=0;
c0104b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b37:	c7 04 85 34 31 12 c0 	movl   $0x0,-0x3fedcecc(,%eax,4)
c0104b3e:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0104b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b45:	83 c0 01             	add    $0x1,%eax
c0104b48:	c1 e0 0c             	shl    $0xc,%eax
c0104b4b:	83 ec 04             	sub    $0x4,%esp
c0104b4e:	6a 00                	push   $0x0
c0104b50:	50                   	push   %eax
c0104b51:	ff 75 d4             	pushl  -0x2c(%ebp)
c0104b54:	e8 14 1b 00 00       	call   c010666d <get_pte>
c0104b59:	83 c4 10             	add    $0x10,%esp
c0104b5c:	89 c2                	mov    %eax,%edx
c0104b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b61:	89 14 85 34 31 12 c0 	mov    %edx,-0x3fedcecc(,%eax,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0104b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b6b:	8b 04 85 34 31 12 c0 	mov    -0x3fedcecc(,%eax,4),%eax
c0104b72:	85 c0                	test   %eax,%eax
c0104b74:	75 19                	jne    c0104b8f <check_swap+0x448>
c0104b76:	68 58 95 10 c0       	push   $0xc0109558
c0104b7b:	68 c2 92 10 c0       	push   $0xc01092c2
c0104b80:	68 f8 00 00 00       	push   $0xf8
c0104b85:	68 5c 92 10 c0       	push   $0xc010925c
c0104b8a:	e8 61 b8 ff ff       	call   c01003f0 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0104b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b92:	8b 04 85 34 31 12 c0 	mov    -0x3fedcecc(,%eax,4),%eax
c0104b99:	8b 00                	mov    (%eax),%eax
c0104b9b:	83 ec 0c             	sub    $0xc,%esp
c0104b9e:	50                   	push   %eax
c0104b9f:	e8 f4 f6 ff ff       	call   c0104298 <pte2page>
c0104ba4:	83 c4 10             	add    $0x10,%esp
c0104ba7:	89 c2                	mov    %eax,%edx
c0104ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bac:	8b 04 85 80 30 12 c0 	mov    -0x3fedcf80(,%eax,4),%eax
c0104bb3:	39 c2                	cmp    %eax,%edx
c0104bb5:	74 19                	je     c0104bd0 <check_swap+0x489>
c0104bb7:	68 70 95 10 c0       	push   $0xc0109570
c0104bbc:	68 c2 92 10 c0       	push   $0xc01092c2
c0104bc1:	68 f9 00 00 00       	push   $0xf9
c0104bc6:	68 5c 92 10 c0       	push   $0xc010925c
c0104bcb:	e8 20 b8 ff ff       	call   c01003f0 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0104bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bd3:	8b 04 85 34 31 12 c0 	mov    -0x3fedcecc(,%eax,4),%eax
c0104bda:	8b 00                	mov    (%eax),%eax
c0104bdc:	83 e0 01             	and    $0x1,%eax
c0104bdf:	85 c0                	test   %eax,%eax
c0104be1:	75 19                	jne    c0104bfc <check_swap+0x4b5>
c0104be3:	68 98 95 10 c0       	push   $0xc0109598
c0104be8:	68 c2 92 10 c0       	push   $0xc01092c2
c0104bed:	68 fa 00 00 00       	push   $0xfa
c0104bf2:	68 5c 92 10 c0       	push   $0xc010925c
c0104bf7:	e8 f4 b7 ff ff       	call   c01003f0 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104bfc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104c00:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104c04:	0f 8e 2a ff ff ff    	jle    c0104b34 <check_swap+0x3ed>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0104c0a:	83 ec 0c             	sub    $0xc,%esp
c0104c0d:	68 b4 95 10 c0       	push   $0xc01095b4
c0104c12:	e8 73 b6 ff ff       	call   c010028a <cprintf>
c0104c17:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0104c1a:	e8 10 fb ff ff       	call   c010472f <check_content_access>
c0104c1f:	89 45 b8             	mov    %eax,-0x48(%ebp)
     assert(ret==0);
c0104c22:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104c26:	74 19                	je     c0104c41 <check_swap+0x4fa>
c0104c28:	68 da 95 10 c0       	push   $0xc01095da
c0104c2d:	68 c2 92 10 c0       	push   $0xc01092c2
c0104c32:	68 ff 00 00 00       	push   $0xff
c0104c37:	68 5c 92 10 c0       	push   $0xc010925c
c0104c3c:	e8 af b7 ff ff       	call   c01003f0 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104c41:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104c48:	eb 1c                	jmp    c0104c66 <check_swap+0x51f>
         free_pages(check_rp[i],1);
c0104c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c4d:	8b 04 85 80 30 12 c0 	mov    -0x3fedcf80(,%eax,4),%eax
c0104c54:	83 ec 08             	sub    $0x8,%esp
c0104c57:	6a 01                	push   $0x1
c0104c59:	50                   	push   %eax
c0104c5a:	e8 13 14 00 00       	call   c0106072 <free_pages>
c0104c5f:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104c62:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104c66:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104c6a:	7e de                	jle    c0104c4a <check_swap+0x503>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0104c6c:	83 ec 0c             	sub    $0xc,%esp
c0104c6f:	ff 75 d8             	pushl  -0x28(%ebp)
c0104c72:	e8 d3 e9 ff ff       	call   c010364a <mm_destroy>
c0104c77:	83 c4 10             	add    $0x10,%esp
         
     nr_free = nr_free_store;
c0104c7a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104c7d:	a3 4c 31 12 c0       	mov    %eax,0xc012314c
     free_list = free_list_store;
c0104c82:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104c85:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104c88:	a3 44 31 12 c0       	mov    %eax,0xc0123144
c0104c8d:	89 15 48 31 12 c0    	mov    %edx,0xc0123148

     
     le = &free_list;
c0104c93:	c7 45 e8 44 31 12 c0 	movl   $0xc0123144,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104c9a:	eb 1d                	jmp    c0104cb9 <check_swap+0x572>
         struct Page *p = le2page(le, page_link);
c0104c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c9f:	83 e8 0c             	sub    $0xc,%eax
c0104ca2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
         count --, total -= p->property;
c0104ca5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104ca9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104cac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104caf:	8b 40 08             	mov    0x8(%eax),%eax
c0104cb2:	29 c2                	sub    %eax,%edx
c0104cb4:	89 d0                	mov    %edx,%eax
c0104cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cbc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104cbf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104cc2:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0104cc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104cc8:	81 7d e8 44 31 12 c0 	cmpl   $0xc0123144,-0x18(%ebp)
c0104ccf:	75 cb                	jne    c0104c9c <check_swap+0x555>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0104cd1:	83 ec 04             	sub    $0x4,%esp
c0104cd4:	ff 75 f0             	pushl  -0x10(%ebp)
c0104cd7:	ff 75 f4             	pushl  -0xc(%ebp)
c0104cda:	68 e1 95 10 c0       	push   $0xc01095e1
c0104cdf:	e8 a6 b5 ff ff       	call   c010028a <cprintf>
c0104ce4:	83 c4 10             	add    $0x10,%esp
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0104ce7:	83 ec 0c             	sub    $0xc,%esp
c0104cea:	68 fb 95 10 c0       	push   $0xc01095fb
c0104cef:	e8 96 b5 ff ff       	call   c010028a <cprintf>
c0104cf4:	83 c4 10             	add    $0x10,%esp
}
c0104cf7:	90                   	nop
c0104cf8:	c9                   	leave  
c0104cf9:	c3                   	ret    

c0104cfa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104cfa:	55                   	push   %ebp
c0104cfb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d00:	8b 15 58 31 12 c0    	mov    0xc0123158,%edx
c0104d06:	29 d0                	sub    %edx,%eax
c0104d08:	c1 f8 05             	sar    $0x5,%eax
}
c0104d0b:	5d                   	pop    %ebp
c0104d0c:	c3                   	ret    

c0104d0d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104d0d:	55                   	push   %ebp
c0104d0e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104d10:	ff 75 08             	pushl  0x8(%ebp)
c0104d13:	e8 e2 ff ff ff       	call   c0104cfa <page2ppn>
c0104d18:	83 c4 04             	add    $0x4,%esp
c0104d1b:	c1 e0 0c             	shl    $0xc,%eax
}
c0104d1e:	c9                   	leave  
c0104d1f:	c3                   	ret    

c0104d20 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104d20:	55                   	push   %ebp
c0104d21:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d26:	8b 00                	mov    (%eax),%eax
}
c0104d28:	5d                   	pop    %ebp
c0104d29:	c3                   	ret    

c0104d2a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104d2a:	55                   	push   %ebp
c0104d2b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d30:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104d33:	89 10                	mov    %edx,(%eax)
}
c0104d35:	90                   	nop
c0104d36:	5d                   	pop    %ebp
c0104d37:	c3                   	ret    

c0104d38 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104d38:	55                   	push   %ebp
c0104d39:	89 e5                	mov    %esp,%ebp
c0104d3b:	83 ec 10             	sub    $0x10,%esp
c0104d3e:	c7 45 fc 44 31 12 c0 	movl   $0xc0123144,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104d48:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104d4b:	89 50 04             	mov    %edx,0x4(%eax)
c0104d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104d51:	8b 50 04             	mov    0x4(%eax),%edx
c0104d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104d57:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104d59:	c7 05 4c 31 12 c0 00 	movl   $0x0,0xc012314c
c0104d60:	00 00 00 
}
c0104d63:	90                   	nop
c0104d64:	c9                   	leave  
c0104d65:	c3                   	ret    

c0104d66 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104d66:	55                   	push   %ebp
c0104d67:	89 e5                	mov    %esp,%ebp
c0104d69:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0104d6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104d70:	75 16                	jne    c0104d88 <default_init_memmap+0x22>
c0104d72:	68 14 96 10 c0       	push   $0xc0109614
c0104d77:	68 1a 96 10 c0       	push   $0xc010961a
c0104d7c:	6a 6d                	push   $0x6d
c0104d7e:	68 2f 96 10 c0       	push   $0xc010962f
c0104d83:	e8 68 b6 ff ff       	call   c01003f0 <__panic>
    struct Page *p = base;
c0104d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104d8e:	eb 6c                	jmp    c0104dfc <default_init_memmap+0x96>
        assert(PageReserved(p));
c0104d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d93:	83 c0 04             	add    $0x4,%eax
c0104d96:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104d9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104da3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104da6:	0f a3 10             	bt     %edx,(%eax)
c0104da9:	19 c0                	sbb    %eax,%eax
c0104dab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104dae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104db2:	0f 95 c0             	setne  %al
c0104db5:	0f b6 c0             	movzbl %al,%eax
c0104db8:	85 c0                	test   %eax,%eax
c0104dba:	75 16                	jne    c0104dd2 <default_init_memmap+0x6c>
c0104dbc:	68 45 96 10 c0       	push   $0xc0109645
c0104dc1:	68 1a 96 10 c0       	push   $0xc010961a
c0104dc6:	6a 70                	push   $0x70
c0104dc8:	68 2f 96 10 c0       	push   $0xc010962f
c0104dcd:	e8 1e b6 ff ff       	call   c01003f0 <__panic>
        p->flags = p->property = 0;
c0104dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ddf:	8b 50 08             	mov    0x8(%eax),%edx
c0104de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104de5:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104de8:	83 ec 08             	sub    $0x8,%esp
c0104deb:	6a 00                	push   $0x0
c0104ded:	ff 75 f4             	pushl  -0xc(%ebp)
c0104df0:	e8 35 ff ff ff       	call   c0104d2a <set_page_ref>
c0104df5:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104df8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0104dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104dff:	c1 e0 05             	shl    $0x5,%eax
c0104e02:	89 c2                	mov    %eax,%edx
c0104e04:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e07:	01 d0                	add    %edx,%eax
c0104e09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e0c:	75 82                	jne    c0104d90 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0104e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e11:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e14:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e1a:	83 c0 04             	add    $0x4,%eax
c0104e1d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104e24:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104e27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104e2d:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0104e30:	8b 15 4c 31 12 c0    	mov    0xc012314c,%edx
c0104e36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e39:	01 d0                	add    %edx,%eax
c0104e3b:	a3 4c 31 12 c0       	mov    %eax,0xc012314c
    list_add(&free_list, &(base->page_link));
c0104e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e43:	83 c0 0c             	add    $0xc,%eax
c0104e46:	c7 45 f0 44 31 12 c0 	movl   $0xc0123144,-0x10(%ebp)
c0104e4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e53:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104e56:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e59:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104e5c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104e5f:	8b 40 04             	mov    0x4(%eax),%eax
c0104e62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e65:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104e68:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104e6b:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104e6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104e71:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104e74:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104e77:	89 10                	mov    %edx,(%eax)
c0104e79:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104e7c:	8b 10                	mov    (%eax),%edx
c0104e7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104e81:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104e84:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e87:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104e8a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104e8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e90:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104e93:	89 10                	mov    %edx,(%eax)
}
c0104e95:	90                   	nop
c0104e96:	c9                   	leave  
c0104e97:	c3                   	ret    

c0104e98 <default_alloc_pages>:

// LAB2 MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
c0104e98:	55                   	push   %ebp
c0104e99:	89 e5                	mov    %esp,%ebp
c0104e9b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0104e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ea2:	75 16                	jne    c0104eba <default_alloc_pages+0x22>
c0104ea4:	68 14 96 10 c0       	push   $0xc0109614
c0104ea9:	68 1a 96 10 c0       	push   $0xc010961a
c0104eae:	6a 7d                	push   $0x7d
c0104eb0:	68 2f 96 10 c0       	push   $0xc010962f
c0104eb5:	e8 36 b5 ff ff       	call   c01003f0 <__panic>
    if (n > nr_free) {
c0104eba:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0104ebf:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104ec2:	73 0a                	jae    c0104ece <default_alloc_pages+0x36>
        return NULL;
c0104ec4:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ec9:	e9 41 01 00 00       	jmp    c010500f <default_alloc_pages+0x177>
    }
    struct Page *page = NULL;
c0104ece:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104ed5:	c7 45 f0 44 31 12 c0 	movl   $0xc0123144,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104edc:	eb 1c                	jmp    c0104efa <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c0104ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee1:	83 e8 0c             	sub    $0xc,%eax
c0104ee4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0104ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104eea:	8b 40 08             	mov    0x8(%eax),%eax
c0104eed:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104ef0:	72 08                	jb     c0104efa <default_alloc_pages+0x62>
            page = p;
c0104ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104ef8:	eb 18                	jmp    c0104f12 <default_alloc_pages+0x7a>
c0104efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104efd:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104f00:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104f03:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f09:	81 7d f0 44 31 12 c0 	cmpl   $0xc0123144,-0x10(%ebp)
c0104f10:	75 cc                	jne    c0104ede <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0104f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f16:	0f 84 f0 00 00 00    	je     c010500c <default_alloc_pages+0x174>
c0104f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f22:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f25:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
c0104f28:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
c0104f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f2e:	83 c0 0c             	add    $0xc,%eax
c0104f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f37:	8b 40 04             	mov    0x4(%eax),%eax
c0104f3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104f3d:	8b 12                	mov    (%edx),%edx
c0104f3f:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0104f42:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104f45:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104f48:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104f4b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104f4e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f51:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104f54:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0104f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f59:	8b 40 08             	mov    0x8(%eax),%eax
c0104f5c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104f5f:	0f 86 81 00 00 00    	jbe    c0104fe6 <default_alloc_pages+0x14e>
            struct Page *p = page + n;                      // split the allocated page
c0104f65:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f68:	c1 e0 05             	shl    $0x5,%eax
c0104f6b:	89 c2                	mov    %eax,%edx
c0104f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f70:	01 d0                	add    %edx,%eax
c0104f72:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
c0104f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f78:	8b 40 08             	mov    0x8(%eax),%eax
c0104f7b:	2b 45 08             	sub    0x8(%ebp),%eax
c0104f7e:	89 c2                	mov    %eax,%edx
c0104f80:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104f83:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
c0104f86:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104f89:	83 c0 04             	add    $0x4,%eax
c0104f8c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104f93:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104f96:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f99:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104f9c:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
c0104f9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104fa2:	8d 50 0c             	lea    0xc(%eax),%edx
c0104fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fab:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104fae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fb1:	8b 00                	mov    (%eax),%eax
c0104fb3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104fb6:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104fb9:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fbf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104fc2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104fc5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104fc8:	89 10                	mov    %edx,(%eax)
c0104fca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104fcd:	8b 10                	mov    (%eax),%edx
c0104fcf:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104fd2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104fd5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104fd8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104fdb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104fde:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104fe1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104fe4:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c0104fe6:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0104feb:	2b 45 08             	sub    0x8(%ebp),%eax
c0104fee:	a3 4c 31 12 c0       	mov    %eax,0xc012314c
        ClearPageProperty(page);    // mark as "not head page"
c0104ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff6:	83 c0 04             	add    $0x4,%eax
c0104ff9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105000:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105003:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105006:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105009:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010500c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010500f:	c9                   	leave  
c0105010:	c3                   	ret    

c0105011 <default_free_pages>:

// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
c0105011:	55                   	push   %ebp
c0105012:	89 e5                	mov    %esp,%ebp
c0105014:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010501a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010501e:	75 19                	jne    c0105039 <default_free_pages+0x28>
c0105020:	68 14 96 10 c0       	push   $0xc0109614
c0105025:	68 1a 96 10 c0       	push   $0xc010961a
c010502a:	68 9c 00 00 00       	push   $0x9c
c010502f:	68 2f 96 10 c0       	push   $0xc010962f
c0105034:	e8 b7 b3 ff ff       	call   c01003f0 <__panic>
    struct Page *p = base;
c0105039:	8b 45 08             	mov    0x8(%ebp),%eax
c010503c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010503f:	e9 8f 00 00 00       	jmp    c01050d3 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c0105044:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105047:	83 c0 04             	add    $0x4,%eax
c010504a:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0105051:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105054:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105057:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010505a:	0f a3 10             	bt     %edx,(%eax)
c010505d:	19 c0                	sbb    %eax,%eax
c010505f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105062:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105066:	0f 95 c0             	setne  %al
c0105069:	0f b6 c0             	movzbl %al,%eax
c010506c:	85 c0                	test   %eax,%eax
c010506e:	75 2c                	jne    c010509c <default_free_pages+0x8b>
c0105070:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105073:	83 c0 04             	add    $0x4,%eax
c0105076:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c010507d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105080:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105083:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105086:	0f a3 10             	bt     %edx,(%eax)
c0105089:	19 c0                	sbb    %eax,%eax
c010508b:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
c010508e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
c0105092:	0f 95 c0             	setne  %al
c0105095:	0f b6 c0             	movzbl %al,%eax
c0105098:	85 c0                	test   %eax,%eax
c010509a:	74 19                	je     c01050b5 <default_free_pages+0xa4>
c010509c:	68 58 96 10 c0       	push   $0xc0109658
c01050a1:	68 1a 96 10 c0       	push   $0xc010961a
c01050a6:	68 9f 00 00 00       	push   $0x9f
c01050ab:	68 2f 96 10 c0       	push   $0xc010962f
c01050b0:	e8 3b b3 ff ff       	call   c01003f0 <__panic>
        p->flags = 0;
c01050b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
c01050bf:	83 ec 08             	sub    $0x8,%esp
c01050c2:	6a 00                	push   $0x0
c01050c4:	ff 75 f4             	pushl  -0xc(%ebp)
c01050c7:	e8 5e fc ff ff       	call   c0104d2a <set_page_ref>
c01050cc:	83 c4 10             	add    $0x10,%esp
// LAB2 MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01050cf:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01050d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050d6:	c1 e0 05             	shl    $0x5,%eax
c01050d9:	89 c2                	mov    %eax,%edx
c01050db:	8b 45 08             	mov    0x8(%ebp),%eax
c01050de:	01 d0                	add    %edx,%eax
c01050e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01050e3:	0f 85 5b ff ff ff    	jne    c0105044 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
c01050e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050ef:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01050f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f5:	83 c0 04             	add    $0x4,%eax
c01050f8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01050ff:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105102:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105105:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105108:	0f ab 10             	bts    %edx,(%eax)
c010510b:	c7 45 e8 44 31 12 c0 	movl   $0xc0123144,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105112:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105115:	8b 40 04             	mov    0x4(%eax),%eax
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
c0105118:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010511b:	e9 0e 01 00 00       	jmp    c010522e <default_free_pages+0x21d>
        p = le2page(le, page_link);
c0105120:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105123:	83 e8 0c             	sub    $0xc,%eax
c0105126:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105129:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010512c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010512f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105132:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105135:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
c0105138:	8b 45 08             	mov    0x8(%ebp),%eax
c010513b:	8b 40 08             	mov    0x8(%eax),%eax
c010513e:	c1 e0 05             	shl    $0x5,%eax
c0105141:	89 c2                	mov    %eax,%edx
c0105143:	8b 45 08             	mov    0x8(%ebp),%eax
c0105146:	01 d0                	add    %edx,%eax
c0105148:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010514b:	75 64                	jne    c01051b1 <default_free_pages+0x1a0>
            base->property += p->property;
c010514d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105150:	8b 50 08             	mov    0x8(%eax),%edx
c0105153:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105156:	8b 40 08             	mov    0x8(%eax),%eax
c0105159:	01 c2                	add    %eax,%edx
c010515b:	8b 45 08             	mov    0x8(%ebp),%eax
c010515e:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
c0105161:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105164:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c010516b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010516e:	83 c0 04             	add    $0x4,%eax
c0105171:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105178:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010517b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010517e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105181:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0105184:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105187:	83 c0 0c             	add    $0xc,%eax
c010518a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010518d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105190:	8b 40 04             	mov    0x4(%eax),%eax
c0105193:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105196:	8b 12                	mov    (%edx),%edx
c0105198:	89 55 a8             	mov    %edx,-0x58(%ebp)
c010519b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010519e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01051a1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01051a4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01051a7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01051aa:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01051ad:	89 10                	mov    %edx,(%eax)
c01051af:	eb 7d                	jmp    c010522e <default_free_pages+0x21d>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
c01051b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051b4:	8b 40 08             	mov    0x8(%eax),%eax
c01051b7:	c1 e0 05             	shl    $0x5,%eax
c01051ba:	89 c2                	mov    %eax,%edx
c01051bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051bf:	01 d0                	add    %edx,%eax
c01051c1:	3b 45 08             	cmp    0x8(%ebp),%eax
c01051c4:	75 68                	jne    c010522e <default_free_pages+0x21d>
            p->property += base->property;
c01051c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051c9:	8b 50 08             	mov    0x8(%eax),%edx
c01051cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01051cf:	8b 40 08             	mov    0x8(%eax),%eax
c01051d2:	01 c2                	add    %eax,%edx
c01051d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051d7:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
c01051da:	8b 45 08             	mov    0x8(%ebp),%eax
c01051dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
c01051e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e7:	83 c0 04             	add    $0x4,%eax
c01051ea:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c01051f1:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01051f4:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01051f7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01051fa:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01051fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105200:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0105203:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105206:	83 c0 0c             	add    $0xc,%eax
c0105209:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010520c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010520f:	8b 40 04             	mov    0x4(%eax),%eax
c0105212:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105215:	8b 12                	mov    (%edx),%edx
c0105217:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010521a:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010521d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105220:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105223:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105226:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105229:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010522c:	89 10                	mov    %edx,(%eax)
    }
    base->property = n;
    SetPageProperty(base);
    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c010522e:	81 7d f0 44 31 12 c0 	cmpl   $0xc0123144,-0x10(%ebp)
c0105235:	0f 85 e5 fe ff ff    	jne    c0105120 <default_free_pages+0x10f>
c010523b:	c7 45 d0 44 31 12 c0 	movl   $0xc0123144,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105242:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105245:	8b 40 04             	mov    0x4(%eax),%eax
            base = p;
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
c0105248:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010524b:	eb 20                	jmp    c010526d <default_free_pages+0x25c>
        p = le2page(le, page_link);
c010524d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105250:	83 e8 0c             	sub    $0xc,%eax
c0105253:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
c0105256:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105259:	3b 45 08             	cmp    0x8(%ebp),%eax
c010525c:	77 1a                	ja     c0105278 <default_free_pages+0x267>
c010525e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105261:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105264:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105267:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c010526a:	89 45 f0             	mov    %eax,-0x10(%ebp)
            list_del(&(p->page_link));
        }
    }
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
c010526d:	81 7d f0 44 31 12 c0 	cmpl   $0xc0123144,-0x10(%ebp)
c0105274:	75 d7                	jne    c010524d <default_free_pages+0x23c>
c0105276:	eb 01                	jmp    c0105279 <default_free_pages+0x268>
        p = le2page(le, page_link);
        if (p > base) {
            break;
c0105278:	90                   	nop
        }
        le = list_next(le);
    }
    nr_free += n;
c0105279:	8b 15 4c 31 12 c0    	mov    0xc012314c,%edx
c010527f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105282:	01 d0                	add    %edx,%eax
c0105284:	a3 4c 31 12 c0       	mov    %eax,0xc012314c
    list_add_before(le, &(base->page_link)); 
c0105289:	8b 45 08             	mov    0x8(%ebp),%eax
c010528c:	8d 50 0c             	lea    0xc(%eax),%edx
c010528f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105292:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0105295:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0105298:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010529b:	8b 00                	mov    (%eax),%eax
c010529d:	8b 55 90             	mov    -0x70(%ebp),%edx
c01052a0:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01052a3:	89 45 88             	mov    %eax,-0x78(%ebp)
c01052a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01052a9:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01052ac:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01052af:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01052b2:	89 10                	mov    %edx,(%eax)
c01052b4:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01052b7:	8b 10                	mov    (%eax),%edx
c01052b9:	8b 45 88             	mov    -0x78(%ebp),%eax
c01052bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01052bf:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01052c2:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01052c5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01052c8:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01052cb:	8b 55 88             	mov    -0x78(%ebp),%edx
c01052ce:	89 10                	mov    %edx,(%eax)
}
c01052d0:	90                   	nop
c01052d1:	c9                   	leave  
c01052d2:	c3                   	ret    

c01052d3 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01052d3:	55                   	push   %ebp
c01052d4:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01052d6:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
}
c01052db:	5d                   	pop    %ebp
c01052dc:	c3                   	ret    

c01052dd <basic_check>:

static void
basic_check(void) {
c01052dd:	55                   	push   %ebp
c01052de:	89 e5                	mov    %esp,%ebp
c01052e0:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01052e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01052ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01052f6:	83 ec 0c             	sub    $0xc,%esp
c01052f9:	6a 01                	push   $0x1
c01052fb:	e8 06 0d 00 00       	call   c0106006 <alloc_pages>
c0105300:	83 c4 10             	add    $0x10,%esp
c0105303:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105306:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010530a:	75 19                	jne    c0105325 <basic_check+0x48>
c010530c:	68 7d 96 10 c0       	push   $0xc010967d
c0105311:	68 1a 96 10 c0       	push   $0xc010961a
c0105316:	68 d0 00 00 00       	push   $0xd0
c010531b:	68 2f 96 10 c0       	push   $0xc010962f
c0105320:	e8 cb b0 ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105325:	83 ec 0c             	sub    $0xc,%esp
c0105328:	6a 01                	push   $0x1
c010532a:	e8 d7 0c 00 00       	call   c0106006 <alloc_pages>
c010532f:	83 c4 10             	add    $0x10,%esp
c0105332:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105335:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105339:	75 19                	jne    c0105354 <basic_check+0x77>
c010533b:	68 99 96 10 c0       	push   $0xc0109699
c0105340:	68 1a 96 10 c0       	push   $0xc010961a
c0105345:	68 d1 00 00 00       	push   $0xd1
c010534a:	68 2f 96 10 c0       	push   $0xc010962f
c010534f:	e8 9c b0 ff ff       	call   c01003f0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105354:	83 ec 0c             	sub    $0xc,%esp
c0105357:	6a 01                	push   $0x1
c0105359:	e8 a8 0c 00 00       	call   c0106006 <alloc_pages>
c010535e:	83 c4 10             	add    $0x10,%esp
c0105361:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105368:	75 19                	jne    c0105383 <basic_check+0xa6>
c010536a:	68 b5 96 10 c0       	push   $0xc01096b5
c010536f:	68 1a 96 10 c0       	push   $0xc010961a
c0105374:	68 d2 00 00 00       	push   $0xd2
c0105379:	68 2f 96 10 c0       	push   $0xc010962f
c010537e:	e8 6d b0 ff ff       	call   c01003f0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105383:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105386:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105389:	74 10                	je     c010539b <basic_check+0xbe>
c010538b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010538e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105391:	74 08                	je     c010539b <basic_check+0xbe>
c0105393:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105396:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105399:	75 19                	jne    c01053b4 <basic_check+0xd7>
c010539b:	68 d4 96 10 c0       	push   $0xc01096d4
c01053a0:	68 1a 96 10 c0       	push   $0xc010961a
c01053a5:	68 d4 00 00 00       	push   $0xd4
c01053aa:	68 2f 96 10 c0       	push   $0xc010962f
c01053af:	e8 3c b0 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01053b4:	83 ec 0c             	sub    $0xc,%esp
c01053b7:	ff 75 ec             	pushl  -0x14(%ebp)
c01053ba:	e8 61 f9 ff ff       	call   c0104d20 <page_ref>
c01053bf:	83 c4 10             	add    $0x10,%esp
c01053c2:	85 c0                	test   %eax,%eax
c01053c4:	75 24                	jne    c01053ea <basic_check+0x10d>
c01053c6:	83 ec 0c             	sub    $0xc,%esp
c01053c9:	ff 75 f0             	pushl  -0x10(%ebp)
c01053cc:	e8 4f f9 ff ff       	call   c0104d20 <page_ref>
c01053d1:	83 c4 10             	add    $0x10,%esp
c01053d4:	85 c0                	test   %eax,%eax
c01053d6:	75 12                	jne    c01053ea <basic_check+0x10d>
c01053d8:	83 ec 0c             	sub    $0xc,%esp
c01053db:	ff 75 f4             	pushl  -0xc(%ebp)
c01053de:	e8 3d f9 ff ff       	call   c0104d20 <page_ref>
c01053e3:	83 c4 10             	add    $0x10,%esp
c01053e6:	85 c0                	test   %eax,%eax
c01053e8:	74 19                	je     c0105403 <basic_check+0x126>
c01053ea:	68 f8 96 10 c0       	push   $0xc01096f8
c01053ef:	68 1a 96 10 c0       	push   $0xc010961a
c01053f4:	68 d5 00 00 00       	push   $0xd5
c01053f9:	68 2f 96 10 c0       	push   $0xc010962f
c01053fe:	e8 ed af ff ff       	call   c01003f0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105403:	83 ec 0c             	sub    $0xc,%esp
c0105406:	ff 75 ec             	pushl  -0x14(%ebp)
c0105409:	e8 ff f8 ff ff       	call   c0104d0d <page2pa>
c010540e:	83 c4 10             	add    $0x10,%esp
c0105411:	89 c2                	mov    %eax,%edx
c0105413:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0105418:	c1 e0 0c             	shl    $0xc,%eax
c010541b:	39 c2                	cmp    %eax,%edx
c010541d:	72 19                	jb     c0105438 <basic_check+0x15b>
c010541f:	68 34 97 10 c0       	push   $0xc0109734
c0105424:	68 1a 96 10 c0       	push   $0xc010961a
c0105429:	68 d7 00 00 00       	push   $0xd7
c010542e:	68 2f 96 10 c0       	push   $0xc010962f
c0105433:	e8 b8 af ff ff       	call   c01003f0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105438:	83 ec 0c             	sub    $0xc,%esp
c010543b:	ff 75 f0             	pushl  -0x10(%ebp)
c010543e:	e8 ca f8 ff ff       	call   c0104d0d <page2pa>
c0105443:	83 c4 10             	add    $0x10,%esp
c0105446:	89 c2                	mov    %eax,%edx
c0105448:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c010544d:	c1 e0 0c             	shl    $0xc,%eax
c0105450:	39 c2                	cmp    %eax,%edx
c0105452:	72 19                	jb     c010546d <basic_check+0x190>
c0105454:	68 51 97 10 c0       	push   $0xc0109751
c0105459:	68 1a 96 10 c0       	push   $0xc010961a
c010545e:	68 d8 00 00 00       	push   $0xd8
c0105463:	68 2f 96 10 c0       	push   $0xc010962f
c0105468:	e8 83 af ff ff       	call   c01003f0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010546d:	83 ec 0c             	sub    $0xc,%esp
c0105470:	ff 75 f4             	pushl  -0xc(%ebp)
c0105473:	e8 95 f8 ff ff       	call   c0104d0d <page2pa>
c0105478:	83 c4 10             	add    $0x10,%esp
c010547b:	89 c2                	mov    %eax,%edx
c010547d:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0105482:	c1 e0 0c             	shl    $0xc,%eax
c0105485:	39 c2                	cmp    %eax,%edx
c0105487:	72 19                	jb     c01054a2 <basic_check+0x1c5>
c0105489:	68 6e 97 10 c0       	push   $0xc010976e
c010548e:	68 1a 96 10 c0       	push   $0xc010961a
c0105493:	68 d9 00 00 00       	push   $0xd9
c0105498:	68 2f 96 10 c0       	push   $0xc010962f
c010549d:	e8 4e af ff ff       	call   c01003f0 <__panic>

    list_entry_t free_list_store = free_list;
c01054a2:	a1 44 31 12 c0       	mov    0xc0123144,%eax
c01054a7:	8b 15 48 31 12 c0    	mov    0xc0123148,%edx
c01054ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01054b3:	c7 45 e4 44 31 12 c0 	movl   $0xc0123144,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01054ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054c0:	89 50 04             	mov    %edx,0x4(%eax)
c01054c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054c6:	8b 50 04             	mov    0x4(%eax),%edx
c01054c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054cc:	89 10                	mov    %edx,(%eax)
c01054ce:	c7 45 d8 44 31 12 c0 	movl   $0xc0123144,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01054d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054d8:	8b 40 04             	mov    0x4(%eax),%eax
c01054db:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01054de:	0f 94 c0             	sete   %al
c01054e1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01054e4:	85 c0                	test   %eax,%eax
c01054e6:	75 19                	jne    c0105501 <basic_check+0x224>
c01054e8:	68 8b 97 10 c0       	push   $0xc010978b
c01054ed:	68 1a 96 10 c0       	push   $0xc010961a
c01054f2:	68 dd 00 00 00       	push   $0xdd
c01054f7:	68 2f 96 10 c0       	push   $0xc010962f
c01054fc:	e8 ef ae ff ff       	call   c01003f0 <__panic>

    unsigned int nr_free_store = nr_free;
c0105501:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0105506:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0105509:	c7 05 4c 31 12 c0 00 	movl   $0x0,0xc012314c
c0105510:	00 00 00 

    assert(alloc_page() == NULL);
c0105513:	83 ec 0c             	sub    $0xc,%esp
c0105516:	6a 01                	push   $0x1
c0105518:	e8 e9 0a 00 00       	call   c0106006 <alloc_pages>
c010551d:	83 c4 10             	add    $0x10,%esp
c0105520:	85 c0                	test   %eax,%eax
c0105522:	74 19                	je     c010553d <basic_check+0x260>
c0105524:	68 a2 97 10 c0       	push   $0xc01097a2
c0105529:	68 1a 96 10 c0       	push   $0xc010961a
c010552e:	68 e2 00 00 00       	push   $0xe2
c0105533:	68 2f 96 10 c0       	push   $0xc010962f
c0105538:	e8 b3 ae ff ff       	call   c01003f0 <__panic>

    free_page(p0);
c010553d:	83 ec 08             	sub    $0x8,%esp
c0105540:	6a 01                	push   $0x1
c0105542:	ff 75 ec             	pushl  -0x14(%ebp)
c0105545:	e8 28 0b 00 00       	call   c0106072 <free_pages>
c010554a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010554d:	83 ec 08             	sub    $0x8,%esp
c0105550:	6a 01                	push   $0x1
c0105552:	ff 75 f0             	pushl  -0x10(%ebp)
c0105555:	e8 18 0b 00 00       	call   c0106072 <free_pages>
c010555a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010555d:	83 ec 08             	sub    $0x8,%esp
c0105560:	6a 01                	push   $0x1
c0105562:	ff 75 f4             	pushl  -0xc(%ebp)
c0105565:	e8 08 0b 00 00       	call   c0106072 <free_pages>
c010556a:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010556d:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0105572:	83 f8 03             	cmp    $0x3,%eax
c0105575:	74 19                	je     c0105590 <basic_check+0x2b3>
c0105577:	68 b7 97 10 c0       	push   $0xc01097b7
c010557c:	68 1a 96 10 c0       	push   $0xc010961a
c0105581:	68 e7 00 00 00       	push   $0xe7
c0105586:	68 2f 96 10 c0       	push   $0xc010962f
c010558b:	e8 60 ae ff ff       	call   c01003f0 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105590:	83 ec 0c             	sub    $0xc,%esp
c0105593:	6a 01                	push   $0x1
c0105595:	e8 6c 0a 00 00       	call   c0106006 <alloc_pages>
c010559a:	83 c4 10             	add    $0x10,%esp
c010559d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01055a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01055a4:	75 19                	jne    c01055bf <basic_check+0x2e2>
c01055a6:	68 7d 96 10 c0       	push   $0xc010967d
c01055ab:	68 1a 96 10 c0       	push   $0xc010961a
c01055b0:	68 e9 00 00 00       	push   $0xe9
c01055b5:	68 2f 96 10 c0       	push   $0xc010962f
c01055ba:	e8 31 ae ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01055bf:	83 ec 0c             	sub    $0xc,%esp
c01055c2:	6a 01                	push   $0x1
c01055c4:	e8 3d 0a 00 00       	call   c0106006 <alloc_pages>
c01055c9:	83 c4 10             	add    $0x10,%esp
c01055cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01055d3:	75 19                	jne    c01055ee <basic_check+0x311>
c01055d5:	68 99 96 10 c0       	push   $0xc0109699
c01055da:	68 1a 96 10 c0       	push   $0xc010961a
c01055df:	68 ea 00 00 00       	push   $0xea
c01055e4:	68 2f 96 10 c0       	push   $0xc010962f
c01055e9:	e8 02 ae ff ff       	call   c01003f0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01055ee:	83 ec 0c             	sub    $0xc,%esp
c01055f1:	6a 01                	push   $0x1
c01055f3:	e8 0e 0a 00 00       	call   c0106006 <alloc_pages>
c01055f8:	83 c4 10             	add    $0x10,%esp
c01055fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105602:	75 19                	jne    c010561d <basic_check+0x340>
c0105604:	68 b5 96 10 c0       	push   $0xc01096b5
c0105609:	68 1a 96 10 c0       	push   $0xc010961a
c010560e:	68 eb 00 00 00       	push   $0xeb
c0105613:	68 2f 96 10 c0       	push   $0xc010962f
c0105618:	e8 d3 ad ff ff       	call   c01003f0 <__panic>

    assert(alloc_page() == NULL);
c010561d:	83 ec 0c             	sub    $0xc,%esp
c0105620:	6a 01                	push   $0x1
c0105622:	e8 df 09 00 00       	call   c0106006 <alloc_pages>
c0105627:	83 c4 10             	add    $0x10,%esp
c010562a:	85 c0                	test   %eax,%eax
c010562c:	74 19                	je     c0105647 <basic_check+0x36a>
c010562e:	68 a2 97 10 c0       	push   $0xc01097a2
c0105633:	68 1a 96 10 c0       	push   $0xc010961a
c0105638:	68 ed 00 00 00       	push   $0xed
c010563d:	68 2f 96 10 c0       	push   $0xc010962f
c0105642:	e8 a9 ad ff ff       	call   c01003f0 <__panic>

    free_page(p0);
c0105647:	83 ec 08             	sub    $0x8,%esp
c010564a:	6a 01                	push   $0x1
c010564c:	ff 75 ec             	pushl  -0x14(%ebp)
c010564f:	e8 1e 0a 00 00       	call   c0106072 <free_pages>
c0105654:	83 c4 10             	add    $0x10,%esp
c0105657:	c7 45 e8 44 31 12 c0 	movl   $0xc0123144,-0x18(%ebp)
c010565e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105661:	8b 40 04             	mov    0x4(%eax),%eax
c0105664:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105667:	0f 94 c0             	sete   %al
c010566a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010566d:	85 c0                	test   %eax,%eax
c010566f:	74 19                	je     c010568a <basic_check+0x3ad>
c0105671:	68 c4 97 10 c0       	push   $0xc01097c4
c0105676:	68 1a 96 10 c0       	push   $0xc010961a
c010567b:	68 f0 00 00 00       	push   $0xf0
c0105680:	68 2f 96 10 c0       	push   $0xc010962f
c0105685:	e8 66 ad ff ff       	call   c01003f0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010568a:	83 ec 0c             	sub    $0xc,%esp
c010568d:	6a 01                	push   $0x1
c010568f:	e8 72 09 00 00       	call   c0106006 <alloc_pages>
c0105694:	83 c4 10             	add    $0x10,%esp
c0105697:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010569a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010569d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01056a0:	74 19                	je     c01056bb <basic_check+0x3de>
c01056a2:	68 dc 97 10 c0       	push   $0xc01097dc
c01056a7:	68 1a 96 10 c0       	push   $0xc010961a
c01056ac:	68 f3 00 00 00       	push   $0xf3
c01056b1:	68 2f 96 10 c0       	push   $0xc010962f
c01056b6:	e8 35 ad ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c01056bb:	83 ec 0c             	sub    $0xc,%esp
c01056be:	6a 01                	push   $0x1
c01056c0:	e8 41 09 00 00       	call   c0106006 <alloc_pages>
c01056c5:	83 c4 10             	add    $0x10,%esp
c01056c8:	85 c0                	test   %eax,%eax
c01056ca:	74 19                	je     c01056e5 <basic_check+0x408>
c01056cc:	68 a2 97 10 c0       	push   $0xc01097a2
c01056d1:	68 1a 96 10 c0       	push   $0xc010961a
c01056d6:	68 f4 00 00 00       	push   $0xf4
c01056db:	68 2f 96 10 c0       	push   $0xc010962f
c01056e0:	e8 0b ad ff ff       	call   c01003f0 <__panic>

    assert(nr_free == 0);
c01056e5:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c01056ea:	85 c0                	test   %eax,%eax
c01056ec:	74 19                	je     c0105707 <basic_check+0x42a>
c01056ee:	68 f5 97 10 c0       	push   $0xc01097f5
c01056f3:	68 1a 96 10 c0       	push   $0xc010961a
c01056f8:	68 f6 00 00 00       	push   $0xf6
c01056fd:	68 2f 96 10 c0       	push   $0xc010962f
c0105702:	e8 e9 ac ff ff       	call   c01003f0 <__panic>
    free_list = free_list_store;
c0105707:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010570a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010570d:	a3 44 31 12 c0       	mov    %eax,0xc0123144
c0105712:	89 15 48 31 12 c0    	mov    %edx,0xc0123148
    nr_free = nr_free_store;
c0105718:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010571b:	a3 4c 31 12 c0       	mov    %eax,0xc012314c

    free_page(p);
c0105720:	83 ec 08             	sub    $0x8,%esp
c0105723:	6a 01                	push   $0x1
c0105725:	ff 75 dc             	pushl  -0x24(%ebp)
c0105728:	e8 45 09 00 00       	call   c0106072 <free_pages>
c010572d:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0105730:	83 ec 08             	sub    $0x8,%esp
c0105733:	6a 01                	push   $0x1
c0105735:	ff 75 f0             	pushl  -0x10(%ebp)
c0105738:	e8 35 09 00 00       	call   c0106072 <free_pages>
c010573d:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105740:	83 ec 08             	sub    $0x8,%esp
c0105743:	6a 01                	push   $0x1
c0105745:	ff 75 f4             	pushl  -0xc(%ebp)
c0105748:	e8 25 09 00 00       	call   c0106072 <free_pages>
c010574d:	83 c4 10             	add    $0x10,%esp
}
c0105750:	90                   	nop
c0105751:	c9                   	leave  
c0105752:	c3                   	ret    

c0105753 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0105753:	55                   	push   %ebp
c0105754:	89 e5                	mov    %esp,%ebp
c0105756:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c010575c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010576a:	c7 45 ec 44 31 12 c0 	movl   $0xc0123144,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105771:	eb 60                	jmp    c01057d3 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0105773:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105776:	83 e8 0c             	sub    $0xc,%eax
c0105779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c010577c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010577f:	83 c0 04             	add    $0x4,%eax
c0105782:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105789:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010578c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010578f:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105792:	0f a3 10             	bt     %edx,(%eax)
c0105795:	19 c0                	sbb    %eax,%eax
c0105797:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c010579a:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c010579e:	0f 95 c0             	setne  %al
c01057a1:	0f b6 c0             	movzbl %al,%eax
c01057a4:	85 c0                	test   %eax,%eax
c01057a6:	75 19                	jne    c01057c1 <default_check+0x6e>
c01057a8:	68 02 98 10 c0       	push   $0xc0109802
c01057ad:	68 1a 96 10 c0       	push   $0xc010961a
c01057b2:	68 07 01 00 00       	push   $0x107
c01057b7:	68 2f 96 10 c0       	push   $0xc010962f
c01057bc:	e8 2f ac ff ff       	call   c01003f0 <__panic>
        count ++, total += p->property;
c01057c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01057c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057c8:	8b 50 08             	mov    0x8(%eax),%edx
c01057cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057ce:	01 d0                	add    %edx,%eax
c01057d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01057d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057dc:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01057df:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057e2:	81 7d ec 44 31 12 c0 	cmpl   $0xc0123144,-0x14(%ebp)
c01057e9:	75 88                	jne    c0105773 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01057eb:	e8 b7 08 00 00       	call   c01060a7 <nr_free_pages>
c01057f0:	89 c2                	mov    %eax,%edx
c01057f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f5:	39 c2                	cmp    %eax,%edx
c01057f7:	74 19                	je     c0105812 <default_check+0xbf>
c01057f9:	68 12 98 10 c0       	push   $0xc0109812
c01057fe:	68 1a 96 10 c0       	push   $0xc010961a
c0105803:	68 0a 01 00 00       	push   $0x10a
c0105808:	68 2f 96 10 c0       	push   $0xc010962f
c010580d:	e8 de ab ff ff       	call   c01003f0 <__panic>

    basic_check();
c0105812:	e8 c6 fa ff ff       	call   c01052dd <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105817:	83 ec 0c             	sub    $0xc,%esp
c010581a:	6a 05                	push   $0x5
c010581c:	e8 e5 07 00 00       	call   c0106006 <alloc_pages>
c0105821:	83 c4 10             	add    $0x10,%esp
c0105824:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0105827:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010582b:	75 19                	jne    c0105846 <default_check+0xf3>
c010582d:	68 2b 98 10 c0       	push   $0xc010982b
c0105832:	68 1a 96 10 c0       	push   $0xc010961a
c0105837:	68 0f 01 00 00       	push   $0x10f
c010583c:	68 2f 96 10 c0       	push   $0xc010962f
c0105841:	e8 aa ab ff ff       	call   c01003f0 <__panic>
    assert(!PageProperty(p0));
c0105846:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105849:	83 c0 04             	add    $0x4,%eax
c010584c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0105853:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105856:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105859:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010585c:	0f a3 10             	bt     %edx,(%eax)
c010585f:	19 c0                	sbb    %eax,%eax
c0105861:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0105864:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0105868:	0f 95 c0             	setne  %al
c010586b:	0f b6 c0             	movzbl %al,%eax
c010586e:	85 c0                	test   %eax,%eax
c0105870:	74 19                	je     c010588b <default_check+0x138>
c0105872:	68 36 98 10 c0       	push   $0xc0109836
c0105877:	68 1a 96 10 c0       	push   $0xc010961a
c010587c:	68 10 01 00 00       	push   $0x110
c0105881:	68 2f 96 10 c0       	push   $0xc010962f
c0105886:	e8 65 ab ff ff       	call   c01003f0 <__panic>

    list_entry_t free_list_store = free_list;
c010588b:	a1 44 31 12 c0       	mov    0xc0123144,%eax
c0105890:	8b 15 48 31 12 c0    	mov    0xc0123148,%edx
c0105896:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105899:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010589c:	c7 45 d0 44 31 12 c0 	movl   $0xc0123144,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01058a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058a6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01058a9:	89 50 04             	mov    %edx,0x4(%eax)
c01058ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058af:	8b 50 04             	mov    0x4(%eax),%edx
c01058b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058b5:	89 10                	mov    %edx,(%eax)
c01058b7:	c7 45 d8 44 31 12 c0 	movl   $0xc0123144,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01058be:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01058c1:	8b 40 04             	mov    0x4(%eax),%eax
c01058c4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01058c7:	0f 94 c0             	sete   %al
c01058ca:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01058cd:	85 c0                	test   %eax,%eax
c01058cf:	75 19                	jne    c01058ea <default_check+0x197>
c01058d1:	68 8b 97 10 c0       	push   $0xc010978b
c01058d6:	68 1a 96 10 c0       	push   $0xc010961a
c01058db:	68 14 01 00 00       	push   $0x114
c01058e0:	68 2f 96 10 c0       	push   $0xc010962f
c01058e5:	e8 06 ab ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c01058ea:	83 ec 0c             	sub    $0xc,%esp
c01058ed:	6a 01                	push   $0x1
c01058ef:	e8 12 07 00 00       	call   c0106006 <alloc_pages>
c01058f4:	83 c4 10             	add    $0x10,%esp
c01058f7:	85 c0                	test   %eax,%eax
c01058f9:	74 19                	je     c0105914 <default_check+0x1c1>
c01058fb:	68 a2 97 10 c0       	push   $0xc01097a2
c0105900:	68 1a 96 10 c0       	push   $0xc010961a
c0105905:	68 15 01 00 00       	push   $0x115
c010590a:	68 2f 96 10 c0       	push   $0xc010962f
c010590f:	e8 dc aa ff ff       	call   c01003f0 <__panic>

    unsigned int nr_free_store = nr_free;
c0105914:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0105919:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c010591c:	c7 05 4c 31 12 c0 00 	movl   $0x0,0xc012314c
c0105923:	00 00 00 

    free_pages(p0 + 2, 3);
c0105926:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105929:	83 c0 40             	add    $0x40,%eax
c010592c:	83 ec 08             	sub    $0x8,%esp
c010592f:	6a 03                	push   $0x3
c0105931:	50                   	push   %eax
c0105932:	e8 3b 07 00 00       	call   c0106072 <free_pages>
c0105937:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c010593a:	83 ec 0c             	sub    $0xc,%esp
c010593d:	6a 04                	push   $0x4
c010593f:	e8 c2 06 00 00       	call   c0106006 <alloc_pages>
c0105944:	83 c4 10             	add    $0x10,%esp
c0105947:	85 c0                	test   %eax,%eax
c0105949:	74 19                	je     c0105964 <default_check+0x211>
c010594b:	68 48 98 10 c0       	push   $0xc0109848
c0105950:	68 1a 96 10 c0       	push   $0xc010961a
c0105955:	68 1b 01 00 00       	push   $0x11b
c010595a:	68 2f 96 10 c0       	push   $0xc010962f
c010595f:	e8 8c aa ff ff       	call   c01003f0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105964:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105967:	83 c0 40             	add    $0x40,%eax
c010596a:	83 c0 04             	add    $0x4,%eax
c010596d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105974:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105977:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010597a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010597d:	0f a3 10             	bt     %edx,(%eax)
c0105980:	19 c0                	sbb    %eax,%eax
c0105982:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105985:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105989:	0f 95 c0             	setne  %al
c010598c:	0f b6 c0             	movzbl %al,%eax
c010598f:	85 c0                	test   %eax,%eax
c0105991:	74 0e                	je     c01059a1 <default_check+0x24e>
c0105993:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105996:	83 c0 40             	add    $0x40,%eax
c0105999:	8b 40 08             	mov    0x8(%eax),%eax
c010599c:	83 f8 03             	cmp    $0x3,%eax
c010599f:	74 19                	je     c01059ba <default_check+0x267>
c01059a1:	68 60 98 10 c0       	push   $0xc0109860
c01059a6:	68 1a 96 10 c0       	push   $0xc010961a
c01059ab:	68 1c 01 00 00       	push   $0x11c
c01059b0:	68 2f 96 10 c0       	push   $0xc010962f
c01059b5:	e8 36 aa ff ff       	call   c01003f0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01059ba:	83 ec 0c             	sub    $0xc,%esp
c01059bd:	6a 03                	push   $0x3
c01059bf:	e8 42 06 00 00       	call   c0106006 <alloc_pages>
c01059c4:	83 c4 10             	add    $0x10,%esp
c01059c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01059ca:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01059ce:	75 19                	jne    c01059e9 <default_check+0x296>
c01059d0:	68 8c 98 10 c0       	push   $0xc010988c
c01059d5:	68 1a 96 10 c0       	push   $0xc010961a
c01059da:	68 1d 01 00 00       	push   $0x11d
c01059df:	68 2f 96 10 c0       	push   $0xc010962f
c01059e4:	e8 07 aa ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c01059e9:	83 ec 0c             	sub    $0xc,%esp
c01059ec:	6a 01                	push   $0x1
c01059ee:	e8 13 06 00 00       	call   c0106006 <alloc_pages>
c01059f3:	83 c4 10             	add    $0x10,%esp
c01059f6:	85 c0                	test   %eax,%eax
c01059f8:	74 19                	je     c0105a13 <default_check+0x2c0>
c01059fa:	68 a2 97 10 c0       	push   $0xc01097a2
c01059ff:	68 1a 96 10 c0       	push   $0xc010961a
c0105a04:	68 1e 01 00 00       	push   $0x11e
c0105a09:	68 2f 96 10 c0       	push   $0xc010962f
c0105a0e:	e8 dd a9 ff ff       	call   c01003f0 <__panic>
    assert(p0 + 2 == p1);
c0105a13:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a16:	83 c0 40             	add    $0x40,%eax
c0105a19:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0105a1c:	74 19                	je     c0105a37 <default_check+0x2e4>
c0105a1e:	68 aa 98 10 c0       	push   $0xc01098aa
c0105a23:	68 1a 96 10 c0       	push   $0xc010961a
c0105a28:	68 1f 01 00 00       	push   $0x11f
c0105a2d:	68 2f 96 10 c0       	push   $0xc010962f
c0105a32:	e8 b9 a9 ff ff       	call   c01003f0 <__panic>

    p2 = p0 + 1;
c0105a37:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a3a:	83 c0 20             	add    $0x20,%eax
c0105a3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0105a40:	83 ec 08             	sub    $0x8,%esp
c0105a43:	6a 01                	push   $0x1
c0105a45:	ff 75 dc             	pushl  -0x24(%ebp)
c0105a48:	e8 25 06 00 00       	call   c0106072 <free_pages>
c0105a4d:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0105a50:	83 ec 08             	sub    $0x8,%esp
c0105a53:	6a 03                	push   $0x3
c0105a55:	ff 75 c4             	pushl  -0x3c(%ebp)
c0105a58:	e8 15 06 00 00       	call   c0106072 <free_pages>
c0105a5d:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0105a60:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a63:	83 c0 04             	add    $0x4,%eax
c0105a66:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0105a6d:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105a70:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105a73:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105a76:	0f a3 10             	bt     %edx,(%eax)
c0105a79:	19 c0                	sbb    %eax,%eax
c0105a7b:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0105a7e:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0105a82:	0f 95 c0             	setne  %al
c0105a85:	0f b6 c0             	movzbl %al,%eax
c0105a88:	85 c0                	test   %eax,%eax
c0105a8a:	74 0b                	je     c0105a97 <default_check+0x344>
c0105a8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a8f:	8b 40 08             	mov    0x8(%eax),%eax
c0105a92:	83 f8 01             	cmp    $0x1,%eax
c0105a95:	74 19                	je     c0105ab0 <default_check+0x35d>
c0105a97:	68 b8 98 10 c0       	push   $0xc01098b8
c0105a9c:	68 1a 96 10 c0       	push   $0xc010961a
c0105aa1:	68 24 01 00 00       	push   $0x124
c0105aa6:	68 2f 96 10 c0       	push   $0xc010962f
c0105aab:	e8 40 a9 ff ff       	call   c01003f0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105ab0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105ab3:	83 c0 04             	add    $0x4,%eax
c0105ab6:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0105abd:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105ac0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105ac3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105ac6:	0f a3 10             	bt     %edx,(%eax)
c0105ac9:	19 c0                	sbb    %eax,%eax
c0105acb:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0105ace:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0105ad2:	0f 95 c0             	setne  %al
c0105ad5:	0f b6 c0             	movzbl %al,%eax
c0105ad8:	85 c0                	test   %eax,%eax
c0105ada:	74 0b                	je     c0105ae7 <default_check+0x394>
c0105adc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105adf:	8b 40 08             	mov    0x8(%eax),%eax
c0105ae2:	83 f8 03             	cmp    $0x3,%eax
c0105ae5:	74 19                	je     c0105b00 <default_check+0x3ad>
c0105ae7:	68 e0 98 10 c0       	push   $0xc01098e0
c0105aec:	68 1a 96 10 c0       	push   $0xc010961a
c0105af1:	68 25 01 00 00       	push   $0x125
c0105af6:	68 2f 96 10 c0       	push   $0xc010962f
c0105afb:	e8 f0 a8 ff ff       	call   c01003f0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105b00:	83 ec 0c             	sub    $0xc,%esp
c0105b03:	6a 01                	push   $0x1
c0105b05:	e8 fc 04 00 00       	call   c0106006 <alloc_pages>
c0105b0a:	83 c4 10             	add    $0x10,%esp
c0105b0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105b10:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105b13:	83 e8 20             	sub    $0x20,%eax
c0105b16:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105b19:	74 19                	je     c0105b34 <default_check+0x3e1>
c0105b1b:	68 06 99 10 c0       	push   $0xc0109906
c0105b20:	68 1a 96 10 c0       	push   $0xc010961a
c0105b25:	68 27 01 00 00       	push   $0x127
c0105b2a:	68 2f 96 10 c0       	push   $0xc010962f
c0105b2f:	e8 bc a8 ff ff       	call   c01003f0 <__panic>
    free_page(p0);
c0105b34:	83 ec 08             	sub    $0x8,%esp
c0105b37:	6a 01                	push   $0x1
c0105b39:	ff 75 dc             	pushl  -0x24(%ebp)
c0105b3c:	e8 31 05 00 00       	call   c0106072 <free_pages>
c0105b41:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105b44:	83 ec 0c             	sub    $0xc,%esp
c0105b47:	6a 02                	push   $0x2
c0105b49:	e8 b8 04 00 00       	call   c0106006 <alloc_pages>
c0105b4e:	83 c4 10             	add    $0x10,%esp
c0105b51:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105b54:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105b57:	83 c0 20             	add    $0x20,%eax
c0105b5a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105b5d:	74 19                	je     c0105b78 <default_check+0x425>
c0105b5f:	68 24 99 10 c0       	push   $0xc0109924
c0105b64:	68 1a 96 10 c0       	push   $0xc010961a
c0105b69:	68 29 01 00 00       	push   $0x129
c0105b6e:	68 2f 96 10 c0       	push   $0xc010962f
c0105b73:	e8 78 a8 ff ff       	call   c01003f0 <__panic>

    free_pages(p0, 2);
c0105b78:	83 ec 08             	sub    $0x8,%esp
c0105b7b:	6a 02                	push   $0x2
c0105b7d:	ff 75 dc             	pushl  -0x24(%ebp)
c0105b80:	e8 ed 04 00 00       	call   c0106072 <free_pages>
c0105b85:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105b88:	83 ec 08             	sub    $0x8,%esp
c0105b8b:	6a 01                	push   $0x1
c0105b8d:	ff 75 c0             	pushl  -0x40(%ebp)
c0105b90:	e8 dd 04 00 00       	call   c0106072 <free_pages>
c0105b95:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0105b98:	83 ec 0c             	sub    $0xc,%esp
c0105b9b:	6a 05                	push   $0x5
c0105b9d:	e8 64 04 00 00       	call   c0106006 <alloc_pages>
c0105ba2:	83 c4 10             	add    $0x10,%esp
c0105ba5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105ba8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105bac:	75 19                	jne    c0105bc7 <default_check+0x474>
c0105bae:	68 44 99 10 c0       	push   $0xc0109944
c0105bb3:	68 1a 96 10 c0       	push   $0xc010961a
c0105bb8:	68 2e 01 00 00       	push   $0x12e
c0105bbd:	68 2f 96 10 c0       	push   $0xc010962f
c0105bc2:	e8 29 a8 ff ff       	call   c01003f0 <__panic>
    assert(alloc_page() == NULL);
c0105bc7:	83 ec 0c             	sub    $0xc,%esp
c0105bca:	6a 01                	push   $0x1
c0105bcc:	e8 35 04 00 00       	call   c0106006 <alloc_pages>
c0105bd1:	83 c4 10             	add    $0x10,%esp
c0105bd4:	85 c0                	test   %eax,%eax
c0105bd6:	74 19                	je     c0105bf1 <default_check+0x49e>
c0105bd8:	68 a2 97 10 c0       	push   $0xc01097a2
c0105bdd:	68 1a 96 10 c0       	push   $0xc010961a
c0105be2:	68 2f 01 00 00       	push   $0x12f
c0105be7:	68 2f 96 10 c0       	push   $0xc010962f
c0105bec:	e8 ff a7 ff ff       	call   c01003f0 <__panic>

    assert(nr_free == 0);
c0105bf1:	a1 4c 31 12 c0       	mov    0xc012314c,%eax
c0105bf6:	85 c0                	test   %eax,%eax
c0105bf8:	74 19                	je     c0105c13 <default_check+0x4c0>
c0105bfa:	68 f5 97 10 c0       	push   $0xc01097f5
c0105bff:	68 1a 96 10 c0       	push   $0xc010961a
c0105c04:	68 31 01 00 00       	push   $0x131
c0105c09:	68 2f 96 10 c0       	push   $0xc010962f
c0105c0e:	e8 dd a7 ff ff       	call   c01003f0 <__panic>
    nr_free = nr_free_store;
c0105c13:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105c16:	a3 4c 31 12 c0       	mov    %eax,0xc012314c

    free_list = free_list_store;
c0105c1b:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105c1e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105c21:	a3 44 31 12 c0       	mov    %eax,0xc0123144
c0105c26:	89 15 48 31 12 c0    	mov    %edx,0xc0123148
    free_pages(p0, 5);
c0105c2c:	83 ec 08             	sub    $0x8,%esp
c0105c2f:	6a 05                	push   $0x5
c0105c31:	ff 75 dc             	pushl  -0x24(%ebp)
c0105c34:	e8 39 04 00 00       	call   c0106072 <free_pages>
c0105c39:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0105c3c:	c7 45 ec 44 31 12 c0 	movl   $0xc0123144,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105c43:	eb 1d                	jmp    c0105c62 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0105c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c48:	83 e8 0c             	sub    $0xc,%eax
c0105c4b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0105c4e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105c55:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105c58:	8b 40 08             	mov    0x8(%eax),%eax
c0105c5b:	29 c2                	sub    %eax,%edx
c0105c5d:	89 d0                	mov    %edx,%eax
c0105c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c65:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105c68:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105c6b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0105c6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c71:	81 7d ec 44 31 12 c0 	cmpl   $0xc0123144,-0x14(%ebp)
c0105c78:	75 cb                	jne    c0105c45 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0105c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c7e:	74 19                	je     c0105c99 <default_check+0x546>
c0105c80:	68 62 99 10 c0       	push   $0xc0109962
c0105c85:	68 1a 96 10 c0       	push   $0xc010961a
c0105c8a:	68 3c 01 00 00       	push   $0x13c
c0105c8f:	68 2f 96 10 c0       	push   $0xc010962f
c0105c94:	e8 57 a7 ff ff       	call   c01003f0 <__panic>
    assert(total == 0);
c0105c99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105c9d:	74 19                	je     c0105cb8 <default_check+0x565>
c0105c9f:	68 6d 99 10 c0       	push   $0xc010996d
c0105ca4:	68 1a 96 10 c0       	push   $0xc010961a
c0105ca9:	68 3d 01 00 00       	push   $0x13d
c0105cae:	68 2f 96 10 c0       	push   $0xc010962f
c0105cb3:	e8 38 a7 ff ff       	call   c01003f0 <__panic>
}
c0105cb8:	90                   	nop
c0105cb9:	c9                   	leave  
c0105cba:	c3                   	ret    

c0105cbb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0105cbb:	55                   	push   %ebp
c0105cbc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0105cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc1:	8b 15 58 31 12 c0    	mov    0xc0123158,%edx
c0105cc7:	29 d0                	sub    %edx,%eax
c0105cc9:	c1 f8 05             	sar    $0x5,%eax
}
c0105ccc:	5d                   	pop    %ebp
c0105ccd:	c3                   	ret    

c0105cce <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0105cce:	55                   	push   %ebp
c0105ccf:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0105cd1:	ff 75 08             	pushl  0x8(%ebp)
c0105cd4:	e8 e2 ff ff ff       	call   c0105cbb <page2ppn>
c0105cd9:	83 c4 04             	add    $0x4,%esp
c0105cdc:	c1 e0 0c             	shl    $0xc,%eax
}
c0105cdf:	c9                   	leave  
c0105ce0:	c3                   	ret    

c0105ce1 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0105ce1:	55                   	push   %ebp
c0105ce2:	89 e5                	mov    %esp,%ebp
c0105ce4:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0105ce7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cea:	c1 e8 0c             	shr    $0xc,%eax
c0105ced:	89 c2                	mov    %eax,%edx
c0105cef:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0105cf4:	39 c2                	cmp    %eax,%edx
c0105cf6:	72 14                	jb     c0105d0c <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0105cf8:	83 ec 04             	sub    $0x4,%esp
c0105cfb:	68 a8 99 10 c0       	push   $0xc01099a8
c0105d00:	6a 5b                	push   $0x5b
c0105d02:	68 c7 99 10 c0       	push   $0xc01099c7
c0105d07:	e8 e4 a6 ff ff       	call   c01003f0 <__panic>
    }
    return &pages[PPN(pa)];
c0105d0c:	a1 58 31 12 c0       	mov    0xc0123158,%eax
c0105d11:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d14:	c1 ea 0c             	shr    $0xc,%edx
c0105d17:	c1 e2 05             	shl    $0x5,%edx
c0105d1a:	01 d0                	add    %edx,%eax
}
c0105d1c:	c9                   	leave  
c0105d1d:	c3                   	ret    

c0105d1e <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0105d1e:	55                   	push   %ebp
c0105d1f:	89 e5                	mov    %esp,%ebp
c0105d21:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0105d24:	ff 75 08             	pushl  0x8(%ebp)
c0105d27:	e8 a2 ff ff ff       	call   c0105cce <page2pa>
c0105d2c:	83 c4 04             	add    $0x4,%esp
c0105d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d35:	c1 e8 0c             	shr    $0xc,%eax
c0105d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d3b:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0105d40:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0105d43:	72 14                	jb     c0105d59 <page2kva+0x3b>
c0105d45:	ff 75 f4             	pushl  -0xc(%ebp)
c0105d48:	68 d8 99 10 c0       	push   $0xc01099d8
c0105d4d:	6a 62                	push   $0x62
c0105d4f:	68 c7 99 10 c0       	push   $0xc01099c7
c0105d54:	e8 97 a6 ff ff       	call   c01003f0 <__panic>
c0105d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d5c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0105d61:	c9                   	leave  
c0105d62:	c3                   	ret    

c0105d63 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0105d63:	55                   	push   %ebp
c0105d64:	89 e5                	mov    %esp,%ebp
c0105d66:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c0105d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d6f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105d76:	77 14                	ja     c0105d8c <kva2page+0x29>
c0105d78:	ff 75 f4             	pushl  -0xc(%ebp)
c0105d7b:	68 fc 99 10 c0       	push   $0xc01099fc
c0105d80:	6a 67                	push   $0x67
c0105d82:	68 c7 99 10 c0       	push   $0xc01099c7
c0105d87:	e8 64 a6 ff ff       	call   c01003f0 <__panic>
c0105d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d8f:	05 00 00 00 40       	add    $0x40000000,%eax
c0105d94:	83 ec 0c             	sub    $0xc,%esp
c0105d97:	50                   	push   %eax
c0105d98:	e8 44 ff ff ff       	call   c0105ce1 <pa2page>
c0105d9d:	83 c4 10             	add    $0x10,%esp
}
c0105da0:	c9                   	leave  
c0105da1:	c3                   	ret    

c0105da2 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c0105da2:	55                   	push   %ebp
c0105da3:	89 e5                	mov    %esp,%ebp
c0105da5:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0105da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dab:	83 e0 01             	and    $0x1,%eax
c0105dae:	85 c0                	test   %eax,%eax
c0105db0:	75 14                	jne    c0105dc6 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0105db2:	83 ec 04             	sub    $0x4,%esp
c0105db5:	68 20 9a 10 c0       	push   $0xc0109a20
c0105dba:	6a 6d                	push   $0x6d
c0105dbc:	68 c7 99 10 c0       	push   $0xc01099c7
c0105dc1:	e8 2a a6 ff ff       	call   c01003f0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0105dc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105dce:	83 ec 0c             	sub    $0xc,%esp
c0105dd1:	50                   	push   %eax
c0105dd2:	e8 0a ff ff ff       	call   c0105ce1 <pa2page>
c0105dd7:	83 c4 10             	add    $0x10,%esp
}
c0105dda:	c9                   	leave  
c0105ddb:	c3                   	ret    

c0105ddc <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0105ddc:	55                   	push   %ebp
c0105ddd:	89 e5                	mov    %esp,%ebp
c0105ddf:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0105de2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105dea:	83 ec 0c             	sub    $0xc,%esp
c0105ded:	50                   	push   %eax
c0105dee:	e8 ee fe ff ff       	call   c0105ce1 <pa2page>
c0105df3:	83 c4 10             	add    $0x10,%esp
}
c0105df6:	c9                   	leave  
c0105df7:	c3                   	ret    

c0105df8 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0105df8:	55                   	push   %ebp
c0105df9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105dfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfe:	8b 00                	mov    (%eax),%eax
}
c0105e00:	5d                   	pop    %ebp
c0105e01:	c3                   	ret    

c0105e02 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0105e02:	55                   	push   %ebp
c0105e03:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e08:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e0b:	89 10                	mov    %edx,(%eax)
}
c0105e0d:	90                   	nop
c0105e0e:	5d                   	pop    %ebp
c0105e0f:	c3                   	ret    

c0105e10 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0105e10:	55                   	push   %ebp
c0105e11:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0105e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e16:	8b 00                	mov    (%eax),%eax
c0105e18:	8d 50 01             	lea    0x1(%eax),%edx
c0105e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1e:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0105e20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e23:	8b 00                	mov    (%eax),%eax
}
c0105e25:	5d                   	pop    %ebp
c0105e26:	c3                   	ret    

c0105e27 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0105e27:	55                   	push   %ebp
c0105e28:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0105e2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e2d:	8b 00                	mov    (%eax),%eax
c0105e2f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e35:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0105e37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3a:	8b 00                	mov    (%eax),%eax
}
c0105e3c:	5d                   	pop    %ebp
c0105e3d:	c3                   	ret    

c0105e3e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0105e3e:	55                   	push   %ebp
c0105e3f:	89 e5                	mov    %esp,%ebp
c0105e41:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0105e44:	9c                   	pushf  
c0105e45:	58                   	pop    %eax
c0105e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0105e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0105e4c:	25 00 02 00 00       	and    $0x200,%eax
c0105e51:	85 c0                	test   %eax,%eax
c0105e53:	74 0c                	je     c0105e61 <__intr_save+0x23>
        intr_disable();
c0105e55:	e8 69 c2 ff ff       	call   c01020c3 <intr_disable>
        return 1;
c0105e5a:	b8 01 00 00 00       	mov    $0x1,%eax
c0105e5f:	eb 05                	jmp    c0105e66 <__intr_save+0x28>
    }
    return 0;
c0105e61:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e66:	c9                   	leave  
c0105e67:	c3                   	ret    

c0105e68 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0105e68:	55                   	push   %ebp
c0105e69:	89 e5                	mov    %esp,%ebp
c0105e6b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0105e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105e72:	74 05                	je     c0105e79 <__intr_restore+0x11>
        intr_enable();
c0105e74:	e8 43 c2 ff ff       	call   c01020bc <intr_enable>
    }
}
c0105e79:	90                   	nop
c0105e7a:	c9                   	leave  
c0105e7b:	c3                   	ret    

c0105e7c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0105e7c:	55                   	push   %ebp
c0105e7d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0105e7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e82:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0105e85:	b8 23 00 00 00       	mov    $0x23,%eax
c0105e8a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0105e8c:	b8 23 00 00 00       	mov    $0x23,%eax
c0105e91:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0105e93:	b8 10 00 00 00       	mov    $0x10,%eax
c0105e98:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0105e9a:	b8 10 00 00 00       	mov    $0x10,%eax
c0105e9f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0105ea1:	b8 10 00 00 00       	mov    $0x10,%eax
c0105ea6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0105ea8:	ea af 5e 10 c0 08 00 	ljmp   $0x8,$0xc0105eaf
}
c0105eaf:	90                   	nop
c0105eb0:	5d                   	pop    %ebp
c0105eb1:	c3                   	ret    

c0105eb2 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0105eb2:	55                   	push   %ebp
c0105eb3:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0105eb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb8:	a3 a4 2f 12 c0       	mov    %eax,0xc0122fa4
}
c0105ebd:	90                   	nop
c0105ebe:	5d                   	pop    %ebp
c0105ebf:	c3                   	ret    

c0105ec0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0105ec0:	55                   	push   %ebp
c0105ec1:	89 e5                	mov    %esp,%ebp
c0105ec3:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0105ec6:	b8 00 f0 11 c0       	mov    $0xc011f000,%eax
c0105ecb:	50                   	push   %eax
c0105ecc:	e8 e1 ff ff ff       	call   c0105eb2 <load_esp0>
c0105ed1:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0105ed4:	66 c7 05 a8 2f 12 c0 	movw   $0x10,0xc0122fa8
c0105edb:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0105edd:	66 c7 05 48 fa 11 c0 	movw   $0x68,0xc011fa48
c0105ee4:	68 00 
c0105ee6:	b8 a0 2f 12 c0       	mov    $0xc0122fa0,%eax
c0105eeb:	66 a3 4a fa 11 c0    	mov    %ax,0xc011fa4a
c0105ef1:	b8 a0 2f 12 c0       	mov    $0xc0122fa0,%eax
c0105ef6:	c1 e8 10             	shr    $0x10,%eax
c0105ef9:	a2 4c fa 11 c0       	mov    %al,0xc011fa4c
c0105efe:	0f b6 05 4d fa 11 c0 	movzbl 0xc011fa4d,%eax
c0105f05:	83 e0 f0             	and    $0xfffffff0,%eax
c0105f08:	83 c8 09             	or     $0x9,%eax
c0105f0b:	a2 4d fa 11 c0       	mov    %al,0xc011fa4d
c0105f10:	0f b6 05 4d fa 11 c0 	movzbl 0xc011fa4d,%eax
c0105f17:	83 e0 ef             	and    $0xffffffef,%eax
c0105f1a:	a2 4d fa 11 c0       	mov    %al,0xc011fa4d
c0105f1f:	0f b6 05 4d fa 11 c0 	movzbl 0xc011fa4d,%eax
c0105f26:	83 e0 9f             	and    $0xffffff9f,%eax
c0105f29:	a2 4d fa 11 c0       	mov    %al,0xc011fa4d
c0105f2e:	0f b6 05 4d fa 11 c0 	movzbl 0xc011fa4d,%eax
c0105f35:	83 c8 80             	or     $0xffffff80,%eax
c0105f38:	a2 4d fa 11 c0       	mov    %al,0xc011fa4d
c0105f3d:	0f b6 05 4e fa 11 c0 	movzbl 0xc011fa4e,%eax
c0105f44:	83 e0 f0             	and    $0xfffffff0,%eax
c0105f47:	a2 4e fa 11 c0       	mov    %al,0xc011fa4e
c0105f4c:	0f b6 05 4e fa 11 c0 	movzbl 0xc011fa4e,%eax
c0105f53:	83 e0 ef             	and    $0xffffffef,%eax
c0105f56:	a2 4e fa 11 c0       	mov    %al,0xc011fa4e
c0105f5b:	0f b6 05 4e fa 11 c0 	movzbl 0xc011fa4e,%eax
c0105f62:	83 e0 df             	and    $0xffffffdf,%eax
c0105f65:	a2 4e fa 11 c0       	mov    %al,0xc011fa4e
c0105f6a:	0f b6 05 4e fa 11 c0 	movzbl 0xc011fa4e,%eax
c0105f71:	83 c8 40             	or     $0x40,%eax
c0105f74:	a2 4e fa 11 c0       	mov    %al,0xc011fa4e
c0105f79:	0f b6 05 4e fa 11 c0 	movzbl 0xc011fa4e,%eax
c0105f80:	83 e0 7f             	and    $0x7f,%eax
c0105f83:	a2 4e fa 11 c0       	mov    %al,0xc011fa4e
c0105f88:	b8 a0 2f 12 c0       	mov    $0xc0122fa0,%eax
c0105f8d:	c1 e8 18             	shr    $0x18,%eax
c0105f90:	a2 4f fa 11 c0       	mov    %al,0xc011fa4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0105f95:	68 50 fa 11 c0       	push   $0xc011fa50
c0105f9a:	e8 dd fe ff ff       	call   c0105e7c <lgdt>
c0105f9f:	83 c4 04             	add    $0x4,%esp
c0105fa2:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0105fa8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0105fac:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0105faf:	90                   	nop
c0105fb0:	c9                   	leave  
c0105fb1:	c3                   	ret    

c0105fb2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0105fb2:	55                   	push   %ebp
c0105fb3:	89 e5                	mov    %esp,%ebp
c0105fb5:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0105fb8:	c7 05 50 31 12 c0 8c 	movl   $0xc010998c,0xc0123150
c0105fbf:	99 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0105fc2:	a1 50 31 12 c0       	mov    0xc0123150,%eax
c0105fc7:	8b 00                	mov    (%eax),%eax
c0105fc9:	83 ec 08             	sub    $0x8,%esp
c0105fcc:	50                   	push   %eax
c0105fcd:	68 4c 9a 10 c0       	push   $0xc0109a4c
c0105fd2:	e8 b3 a2 ff ff       	call   c010028a <cprintf>
c0105fd7:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0105fda:	a1 50 31 12 c0       	mov    0xc0123150,%eax
c0105fdf:	8b 40 04             	mov    0x4(%eax),%eax
c0105fe2:	ff d0                	call   *%eax
}
c0105fe4:	90                   	nop
c0105fe5:	c9                   	leave  
c0105fe6:	c3                   	ret    

c0105fe7 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0105fe7:	55                   	push   %ebp
c0105fe8:	89 e5                	mov    %esp,%ebp
c0105fea:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0105fed:	a1 50 31 12 c0       	mov    0xc0123150,%eax
c0105ff2:	8b 40 08             	mov    0x8(%eax),%eax
c0105ff5:	83 ec 08             	sub    $0x8,%esp
c0105ff8:	ff 75 0c             	pushl  0xc(%ebp)
c0105ffb:	ff 75 08             	pushl  0x8(%ebp)
c0105ffe:	ff d0                	call   *%eax
c0106000:	83 c4 10             	add    $0x10,%esp
}
c0106003:	90                   	nop
c0106004:	c9                   	leave  
c0106005:	c3                   	ret    

c0106006 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106006:	55                   	push   %ebp
c0106007:	89 e5                	mov    %esp,%ebp
c0106009:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c010600c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106013:	e8 26 fe ff ff       	call   c0105e3e <__intr_save>
c0106018:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c010601b:	a1 50 31 12 c0       	mov    0xc0123150,%eax
c0106020:	8b 40 0c             	mov    0xc(%eax),%eax
c0106023:	83 ec 0c             	sub    $0xc,%esp
c0106026:	ff 75 08             	pushl  0x8(%ebp)
c0106029:	ff d0                	call   *%eax
c010602b:	83 c4 10             	add    $0x10,%esp
c010602e:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106031:	83 ec 0c             	sub    $0xc,%esp
c0106034:	ff 75 f0             	pushl  -0x10(%ebp)
c0106037:	e8 2c fe ff ff       	call   c0105e68 <__intr_restore>
c010603c:	83 c4 10             	add    $0x10,%esp

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c010603f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106043:	75 28                	jne    c010606d <alloc_pages+0x67>
c0106045:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106049:	77 22                	ja     c010606d <alloc_pages+0x67>
c010604b:	a1 68 2f 12 c0       	mov    0xc0122f68,%eax
c0106050:	85 c0                	test   %eax,%eax
c0106052:	74 19                	je     c010606d <alloc_pages+0x67>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0106054:	8b 55 08             	mov    0x8(%ebp),%edx
c0106057:	a1 70 30 12 c0       	mov    0xc0123070,%eax
c010605c:	83 ec 04             	sub    $0x4,%esp
c010605f:	6a 00                	push   $0x0
c0106061:	52                   	push   %edx
c0106062:	50                   	push   %eax
c0106063:	e8 62 e3 ff ff       	call   c01043ca <swap_out>
c0106068:	83 c4 10             	add    $0x10,%esp
    }
c010606b:	eb a6                	jmp    c0106013 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010606d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106070:	c9                   	leave  
c0106071:	c3                   	ret    

c0106072 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0106072:	55                   	push   %ebp
c0106073:	89 e5                	mov    %esp,%ebp
c0106075:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0106078:	e8 c1 fd ff ff       	call   c0105e3e <__intr_save>
c010607d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106080:	a1 50 31 12 c0       	mov    0xc0123150,%eax
c0106085:	8b 40 10             	mov    0x10(%eax),%eax
c0106088:	83 ec 08             	sub    $0x8,%esp
c010608b:	ff 75 0c             	pushl  0xc(%ebp)
c010608e:	ff 75 08             	pushl  0x8(%ebp)
c0106091:	ff d0                	call   *%eax
c0106093:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0106096:	83 ec 0c             	sub    $0xc,%esp
c0106099:	ff 75 f4             	pushl  -0xc(%ebp)
c010609c:	e8 c7 fd ff ff       	call   c0105e68 <__intr_restore>
c01060a1:	83 c4 10             	add    $0x10,%esp
}
c01060a4:	90                   	nop
c01060a5:	c9                   	leave  
c01060a6:	c3                   	ret    

c01060a7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01060a7:	55                   	push   %ebp
c01060a8:	89 e5                	mov    %esp,%ebp
c01060aa:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01060ad:	e8 8c fd ff ff       	call   c0105e3e <__intr_save>
c01060b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01060b5:	a1 50 31 12 c0       	mov    0xc0123150,%eax
c01060ba:	8b 40 14             	mov    0x14(%eax),%eax
c01060bd:	ff d0                	call   *%eax
c01060bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01060c2:	83 ec 0c             	sub    $0xc,%esp
c01060c5:	ff 75 f4             	pushl  -0xc(%ebp)
c01060c8:	e8 9b fd ff ff       	call   c0105e68 <__intr_restore>
c01060cd:	83 c4 10             	add    $0x10,%esp
    return ret;
c01060d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01060d3:	c9                   	leave  
c01060d4:	c3                   	ret    

c01060d5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01060d5:	55                   	push   %ebp
c01060d6:	89 e5                	mov    %esp,%ebp
c01060d8:	57                   	push   %edi
c01060d9:	56                   	push   %esi
c01060da:	53                   	push   %ebx
c01060db:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01060de:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01060e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01060ec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01060f3:	83 ec 0c             	sub    $0xc,%esp
c01060f6:	68 63 9a 10 c0       	push   $0xc0109a63
c01060fb:	e8 8a a1 ff ff       	call   c010028a <cprintf>
c0106100:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106103:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010610a:	e9 fc 00 00 00       	jmp    c010620b <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010610f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106112:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106115:	89 d0                	mov    %edx,%eax
c0106117:	c1 e0 02             	shl    $0x2,%eax
c010611a:	01 d0                	add    %edx,%eax
c010611c:	c1 e0 02             	shl    $0x2,%eax
c010611f:	01 c8                	add    %ecx,%eax
c0106121:	8b 50 08             	mov    0x8(%eax),%edx
c0106124:	8b 40 04             	mov    0x4(%eax),%eax
c0106127:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010612a:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010612d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106130:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106133:	89 d0                	mov    %edx,%eax
c0106135:	c1 e0 02             	shl    $0x2,%eax
c0106138:	01 d0                	add    %edx,%eax
c010613a:	c1 e0 02             	shl    $0x2,%eax
c010613d:	01 c8                	add    %ecx,%eax
c010613f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106142:	8b 58 10             	mov    0x10(%eax),%ebx
c0106145:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106148:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010614b:	01 c8                	add    %ecx,%eax
c010614d:	11 da                	adc    %ebx,%edx
c010614f:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106152:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106155:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106158:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010615b:	89 d0                	mov    %edx,%eax
c010615d:	c1 e0 02             	shl    $0x2,%eax
c0106160:	01 d0                	add    %edx,%eax
c0106162:	c1 e0 02             	shl    $0x2,%eax
c0106165:	01 c8                	add    %ecx,%eax
c0106167:	83 c0 14             	add    $0x14,%eax
c010616a:	8b 00                	mov    (%eax),%eax
c010616c:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010616f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106172:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106175:	83 c0 ff             	add    $0xffffffff,%eax
c0106178:	83 d2 ff             	adc    $0xffffffff,%edx
c010617b:	89 c1                	mov    %eax,%ecx
c010617d:	89 d3                	mov    %edx,%ebx
c010617f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106182:	89 55 80             	mov    %edx,-0x80(%ebp)
c0106185:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106188:	89 d0                	mov    %edx,%eax
c010618a:	c1 e0 02             	shl    $0x2,%eax
c010618d:	01 d0                	add    %edx,%eax
c010618f:	c1 e0 02             	shl    $0x2,%eax
c0106192:	03 45 80             	add    -0x80(%ebp),%eax
c0106195:	8b 50 10             	mov    0x10(%eax),%edx
c0106198:	8b 40 0c             	mov    0xc(%eax),%eax
c010619b:	ff 75 84             	pushl  -0x7c(%ebp)
c010619e:	53                   	push   %ebx
c010619f:	51                   	push   %ecx
c01061a0:	ff 75 bc             	pushl  -0x44(%ebp)
c01061a3:	ff 75 b8             	pushl  -0x48(%ebp)
c01061a6:	52                   	push   %edx
c01061a7:	50                   	push   %eax
c01061a8:	68 70 9a 10 c0       	push   $0xc0109a70
c01061ad:	e8 d8 a0 ff ff       	call   c010028a <cprintf>
c01061b2:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01061b5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01061b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01061bb:	89 d0                	mov    %edx,%eax
c01061bd:	c1 e0 02             	shl    $0x2,%eax
c01061c0:	01 d0                	add    %edx,%eax
c01061c2:	c1 e0 02             	shl    $0x2,%eax
c01061c5:	01 c8                	add    %ecx,%eax
c01061c7:	83 c0 14             	add    $0x14,%eax
c01061ca:	8b 00                	mov    (%eax),%eax
c01061cc:	83 f8 01             	cmp    $0x1,%eax
c01061cf:	75 36                	jne    c0106207 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c01061d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01061d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061d7:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01061da:	77 2b                	ja     c0106207 <page_init+0x132>
c01061dc:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01061df:	72 05                	jb     c01061e6 <page_init+0x111>
c01061e1:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01061e4:	73 21                	jae    c0106207 <page_init+0x132>
c01061e6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01061ea:	77 1b                	ja     c0106207 <page_init+0x132>
c01061ec:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01061f0:	72 09                	jb     c01061fb <page_init+0x126>
c01061f2:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01061f9:	77 0c                	ja     c0106207 <page_init+0x132>
                maxpa = end;
c01061fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01061fe:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106201:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106204:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106207:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010620b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010620e:	8b 00                	mov    (%eax),%eax
c0106210:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106213:	0f 8f f6 fe ff ff    	jg     c010610f <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106219:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010621d:	72 1d                	jb     c010623c <page_init+0x167>
c010621f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106223:	77 09                	ja     c010622e <page_init+0x159>
c0106225:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010622c:	76 0e                	jbe    c010623c <page_init+0x167>
        maxpa = KMEMSIZE;
c010622e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106235:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010623c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010623f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106242:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106246:	c1 ea 0c             	shr    $0xc,%edx
c0106249:	a3 80 2f 12 c0       	mov    %eax,0xc0122f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010624e:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0106255:	b8 5c 31 12 c0       	mov    $0xc012315c,%eax
c010625a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010625d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106260:	01 d0                	add    %edx,%eax
c0106262:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106265:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106268:	ba 00 00 00 00       	mov    $0x0,%edx
c010626d:	f7 75 ac             	divl   -0x54(%ebp)
c0106270:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106273:	29 d0                	sub    %edx,%eax
c0106275:	a3 58 31 12 c0       	mov    %eax,0xc0123158

    for (i = 0; i < npage; i ++) {
c010627a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106281:	eb 27                	jmp    c01062aa <page_init+0x1d5>
        SetPageReserved(pages + i);
c0106283:	a1 58 31 12 c0       	mov    0xc0123158,%eax
c0106288:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010628b:	c1 e2 05             	shl    $0x5,%edx
c010628e:	01 d0                	add    %edx,%eax
c0106290:	83 c0 04             	add    $0x4,%eax
c0106293:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010629a:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010629d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01062a0:	8b 55 90             	mov    -0x70(%ebp),%edx
c01062a3:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01062a6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01062aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01062ad:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c01062b2:	39 c2                	cmp    %eax,%edx
c01062b4:	72 cd                	jb     c0106283 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01062b6:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c01062bb:	c1 e0 05             	shl    $0x5,%eax
c01062be:	89 c2                	mov    %eax,%edx
c01062c0:	a1 58 31 12 c0       	mov    0xc0123158,%eax
c01062c5:	01 d0                	add    %edx,%eax
c01062c7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01062ca:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01062d1:	77 17                	ja     c01062ea <page_init+0x215>
c01062d3:	ff 75 a4             	pushl  -0x5c(%ebp)
c01062d6:	68 fc 99 10 c0       	push   $0xc01099fc
c01062db:	68 e9 00 00 00       	push   $0xe9
c01062e0:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01062e5:	e8 06 a1 ff ff       	call   c01003f0 <__panic>
c01062ea:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01062ed:	05 00 00 00 40       	add    $0x40000000,%eax
c01062f2:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01062f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01062fc:	e9 69 01 00 00       	jmp    c010646a <page_init+0x395>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106301:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106304:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106307:	89 d0                	mov    %edx,%eax
c0106309:	c1 e0 02             	shl    $0x2,%eax
c010630c:	01 d0                	add    %edx,%eax
c010630e:	c1 e0 02             	shl    $0x2,%eax
c0106311:	01 c8                	add    %ecx,%eax
c0106313:	8b 50 08             	mov    0x8(%eax),%edx
c0106316:	8b 40 04             	mov    0x4(%eax),%eax
c0106319:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010631c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010631f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106322:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106325:	89 d0                	mov    %edx,%eax
c0106327:	c1 e0 02             	shl    $0x2,%eax
c010632a:	01 d0                	add    %edx,%eax
c010632c:	c1 e0 02             	shl    $0x2,%eax
c010632f:	01 c8                	add    %ecx,%eax
c0106331:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106334:	8b 58 10             	mov    0x10(%eax),%ebx
c0106337:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010633a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010633d:	01 c8                	add    %ecx,%eax
c010633f:	11 da                	adc    %ebx,%edx
c0106341:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106344:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0106347:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010634a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010634d:	89 d0                	mov    %edx,%eax
c010634f:	c1 e0 02             	shl    $0x2,%eax
c0106352:	01 d0                	add    %edx,%eax
c0106354:	c1 e0 02             	shl    $0x2,%eax
c0106357:	01 c8                	add    %ecx,%eax
c0106359:	83 c0 14             	add    $0x14,%eax
c010635c:	8b 00                	mov    (%eax),%eax
c010635e:	83 f8 01             	cmp    $0x1,%eax
c0106361:	0f 85 ff 00 00 00    	jne    c0106466 <page_init+0x391>
            if (begin < freemem) {
c0106367:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010636a:	ba 00 00 00 00       	mov    $0x0,%edx
c010636f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106372:	72 17                	jb     c010638b <page_init+0x2b6>
c0106374:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0106377:	77 05                	ja     c010637e <page_init+0x2a9>
c0106379:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010637c:	76 0d                	jbe    c010638b <page_init+0x2b6>
                begin = freemem;
c010637e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106381:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106384:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010638b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010638f:	72 1d                	jb     c01063ae <page_init+0x2d9>
c0106391:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106395:	77 09                	ja     c01063a0 <page_init+0x2cb>
c0106397:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010639e:	76 0e                	jbe    c01063ae <page_init+0x2d9>
                end = KMEMSIZE;
c01063a0:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01063a7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01063ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01063b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01063b4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01063b7:	0f 87 a9 00 00 00    	ja     c0106466 <page_init+0x391>
c01063bd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01063c0:	72 09                	jb     c01063cb <page_init+0x2f6>
c01063c2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01063c5:	0f 83 9b 00 00 00    	jae    c0106466 <page_init+0x391>
                begin = ROUNDUP(begin, PGSIZE);
c01063cb:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01063d2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01063d5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01063d8:	01 d0                	add    %edx,%eax
c01063da:	83 e8 01             	sub    $0x1,%eax
c01063dd:	89 45 98             	mov    %eax,-0x68(%ebp)
c01063e0:	8b 45 98             	mov    -0x68(%ebp),%eax
c01063e3:	ba 00 00 00 00       	mov    $0x0,%edx
c01063e8:	f7 75 9c             	divl   -0x64(%ebp)
c01063eb:	8b 45 98             	mov    -0x68(%ebp),%eax
c01063ee:	29 d0                	sub    %edx,%eax
c01063f0:	ba 00 00 00 00       	mov    $0x0,%edx
c01063f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01063f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01063fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01063fe:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0106401:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106404:	ba 00 00 00 00       	mov    $0x0,%edx
c0106409:	89 c3                	mov    %eax,%ebx
c010640b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0106411:	89 de                	mov    %ebx,%esi
c0106413:	89 d0                	mov    %edx,%eax
c0106415:	83 e0 00             	and    $0x0,%eax
c0106418:	89 c7                	mov    %eax,%edi
c010641a:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010641d:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0106420:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106423:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106426:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106429:	77 3b                	ja     c0106466 <page_init+0x391>
c010642b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010642e:	72 05                	jb     c0106435 <page_init+0x360>
c0106430:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106433:	73 31                	jae    c0106466 <page_init+0x391>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0106435:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106438:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010643b:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010643e:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0106441:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106445:	c1 ea 0c             	shr    $0xc,%edx
c0106448:	89 c3                	mov    %eax,%ebx
c010644a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010644d:	83 ec 0c             	sub    $0xc,%esp
c0106450:	50                   	push   %eax
c0106451:	e8 8b f8 ff ff       	call   c0105ce1 <pa2page>
c0106456:	83 c4 10             	add    $0x10,%esp
c0106459:	83 ec 08             	sub    $0x8,%esp
c010645c:	53                   	push   %ebx
c010645d:	50                   	push   %eax
c010645e:	e8 84 fb ff ff       	call   c0105fe7 <init_memmap>
c0106463:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0106466:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010646a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010646d:	8b 00                	mov    (%eax),%eax
c010646f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106472:	0f 8f 89 fe ff ff    	jg     c0106301 <page_init+0x22c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0106478:	90                   	nop
c0106479:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010647c:	5b                   	pop    %ebx
c010647d:	5e                   	pop    %esi
c010647e:	5f                   	pop    %edi
c010647f:	5d                   	pop    %ebp
c0106480:	c3                   	ret    

c0106481 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0106481:	55                   	push   %ebp
c0106482:	89 e5                	mov    %esp,%ebp
c0106484:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0106487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010648a:	33 45 14             	xor    0x14(%ebp),%eax
c010648d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106492:	85 c0                	test   %eax,%eax
c0106494:	74 19                	je     c01064af <boot_map_segment+0x2e>
c0106496:	68 ae 9a 10 c0       	push   $0xc0109aae
c010649b:	68 c5 9a 10 c0       	push   $0xc0109ac5
c01064a0:	68 07 01 00 00       	push   $0x107
c01064a5:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01064aa:	e8 41 9f ff ff       	call   c01003f0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01064af:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01064b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064b9:	25 ff 0f 00 00       	and    $0xfff,%eax
c01064be:	89 c2                	mov    %eax,%edx
c01064c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01064c3:	01 c2                	add    %eax,%edx
c01064c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064c8:	01 d0                	add    %edx,%eax
c01064ca:	83 e8 01             	sub    $0x1,%eax
c01064cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01064d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01064d3:	ba 00 00 00 00       	mov    $0x0,%edx
c01064d8:	f7 75 f0             	divl   -0x10(%ebp)
c01064db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01064de:	29 d0                	sub    %edx,%eax
c01064e0:	c1 e8 0c             	shr    $0xc,%eax
c01064e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01064e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01064ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01064ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01064f4:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01064f7:	8b 45 14             	mov    0x14(%ebp),%eax
c01064fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01064fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106505:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0106508:	eb 57                	jmp    c0106561 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010650a:	83 ec 04             	sub    $0x4,%esp
c010650d:	6a 01                	push   $0x1
c010650f:	ff 75 0c             	pushl  0xc(%ebp)
c0106512:	ff 75 08             	pushl  0x8(%ebp)
c0106515:	e8 53 01 00 00       	call   c010666d <get_pte>
c010651a:	83 c4 10             	add    $0x10,%esp
c010651d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0106520:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106524:	75 19                	jne    c010653f <boot_map_segment+0xbe>
c0106526:	68 da 9a 10 c0       	push   $0xc0109ada
c010652b:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106530:	68 0d 01 00 00       	push   $0x10d
c0106535:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010653a:	e8 b1 9e ff ff       	call   c01003f0 <__panic>
        *ptep = pa | PTE_P | perm;
c010653f:	8b 45 14             	mov    0x14(%ebp),%eax
c0106542:	0b 45 18             	or     0x18(%ebp),%eax
c0106545:	83 c8 01             	or     $0x1,%eax
c0106548:	89 c2                	mov    %eax,%edx
c010654a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010654d:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010654f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106553:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010655a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0106561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106565:	75 a3                	jne    c010650a <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0106567:	90                   	nop
c0106568:	c9                   	leave  
c0106569:	c3                   	ret    

c010656a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010656a:	55                   	push   %ebp
c010656b:	89 e5                	mov    %esp,%ebp
c010656d:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0106570:	83 ec 0c             	sub    $0xc,%esp
c0106573:	6a 01                	push   $0x1
c0106575:	e8 8c fa ff ff       	call   c0106006 <alloc_pages>
c010657a:	83 c4 10             	add    $0x10,%esp
c010657d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0106580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106584:	75 17                	jne    c010659d <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0106586:	83 ec 04             	sub    $0x4,%esp
c0106589:	68 e7 9a 10 c0       	push   $0xc0109ae7
c010658e:	68 19 01 00 00       	push   $0x119
c0106593:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106598:	e8 53 9e ff ff       	call   c01003f0 <__panic>
    }
    return page2kva(p);
c010659d:	83 ec 0c             	sub    $0xc,%esp
c01065a0:	ff 75 f4             	pushl  -0xc(%ebp)
c01065a3:	e8 76 f7 ff ff       	call   c0105d1e <page2kva>
c01065a8:	83 c4 10             	add    $0x10,%esp
}
c01065ab:	c9                   	leave  
c01065ac:	c3                   	ret    

c01065ad <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01065ad:	55                   	push   %ebp
c01065ae:	89 e5                	mov    %esp,%ebp
c01065b0:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01065b3:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c01065b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01065bb:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01065c2:	77 17                	ja     c01065db <pmm_init+0x2e>
c01065c4:	ff 75 f4             	pushl  -0xc(%ebp)
c01065c7:	68 fc 99 10 c0       	push   $0xc01099fc
c01065cc:	68 23 01 00 00       	push   $0x123
c01065d1:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01065d6:	e8 15 9e ff ff       	call   c01003f0 <__panic>
c01065db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01065de:	05 00 00 00 40       	add    $0x40000000,%eax
c01065e3:	a3 54 31 12 c0       	mov    %eax,0xc0123154
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01065e8:	e8 c5 f9 ff ff       	call   c0105fb2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01065ed:	e8 e3 fa ff ff       	call   c01060d5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01065f2:	e8 66 04 00 00       	call   c0106a5d <check_alloc_page>

    check_pgdir();
c01065f7:	e8 84 04 00 00       	call   c0106a80 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01065fc:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106601:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0106607:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c010660c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010660f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0106616:	77 17                	ja     c010662f <pmm_init+0x82>
c0106618:	ff 75 f0             	pushl  -0x10(%ebp)
c010661b:	68 fc 99 10 c0       	push   $0xc01099fc
c0106620:	68 39 01 00 00       	push   $0x139
c0106625:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010662a:	e8 c1 9d ff ff       	call   c01003f0 <__panic>
c010662f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106632:	05 00 00 00 40       	add    $0x40000000,%eax
c0106637:	83 c8 03             	or     $0x3,%eax
c010663a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010663c:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106641:	83 ec 0c             	sub    $0xc,%esp
c0106644:	6a 02                	push   $0x2
c0106646:	6a 00                	push   $0x0
c0106648:	68 00 00 00 38       	push   $0x38000000
c010664d:	68 00 00 00 c0       	push   $0xc0000000
c0106652:	50                   	push   %eax
c0106653:	e8 29 fe ff ff       	call   c0106481 <boot_map_segment>
c0106658:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010665b:	e8 60 f8 ff ff       	call   c0105ec0 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0106660:	e8 81 09 00 00       	call   c0106fe6 <check_boot_pgdir>

    print_pgdir();
c0106665:	e8 77 0d 00 00       	call   c01073e1 <print_pgdir>

}
c010666a:	90                   	nop
c010666b:	c9                   	leave  
c010666c:	c3                   	ret    

c010666d <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010666d:	55                   	push   %ebp
c010666e:	89 e5                	mov    %esp,%ebp
c0106670:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
c0106673:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106676:	c1 e8 16             	shr    $0x16,%eax
c0106679:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
c010667c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010667f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106686:	8b 45 08             	mov    0x8(%ebp),%eax
c0106689:	01 d0                	add    %edx,%eax
c010668b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
c010668e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106691:	8b 00                	mov    (%eax),%eax
c0106693:	83 e0 01             	and    $0x1,%eax
c0106696:	85 c0                	test   %eax,%eax
c0106698:	0f 85 ae 00 00 00    	jne    c010674c <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
c010669e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01066a2:	75 0a                	jne    c01066ae <get_pte+0x41>
            return NULL;
c01066a4:	b8 00 00 00 00       	mov    $0x0,%eax
c01066a9:	e9 01 01 00 00       	jmp    c01067af <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
c01066ae:	83 ec 0c             	sub    $0xc,%esp
c01066b1:	6a 01                	push   $0x1
c01066b3:	e8 4e f9 ff ff       	call   c0106006 <alloc_pages>
c01066b8:	83 c4 10             	add    $0x10,%esp
c01066bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
c01066be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01066c2:	75 0a                	jne    c01066ce <get_pte+0x61>
            return NULL;
c01066c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01066c9:	e9 e1 00 00 00       	jmp    c01067af <get_pte+0x142>
        }
        // (4) set page reference
        set_page_ref(pt_page, 1);
c01066ce:	83 ec 08             	sub    $0x8,%esp
c01066d1:	6a 01                	push   $0x1
c01066d3:	ff 75 ec             	pushl  -0x14(%ebp)
c01066d6:	e8 27 f7 ff ff       	call   c0105e02 <set_page_ref>
c01066db:	83 c4 10             	add    $0x10,%esp
        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
c01066de:	83 ec 0c             	sub    $0xc,%esp
c01066e1:	ff 75 ec             	pushl  -0x14(%ebp)
c01066e4:	e8 e5 f5 ff ff       	call   c0105cce <page2pa>
c01066e9:	83 c4 10             	add    $0x10,%esp
c01066ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
c01066ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01066f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01066f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066f8:	c1 e8 0c             	shr    $0xc,%eax
c01066fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01066fe:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0106703:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0106706:	72 17                	jb     c010671f <get_pte+0xb2>
c0106708:	ff 75 e4             	pushl  -0x1c(%ebp)
c010670b:	68 d8 99 10 c0       	push   $0xc01099d8
c0106710:	68 8a 01 00 00       	push   $0x18a
c0106715:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010671a:	e8 d1 9c ff ff       	call   c01003f0 <__panic>
c010671f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106722:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106727:	83 ec 04             	sub    $0x4,%esp
c010672a:	68 00 10 00 00       	push   $0x1000
c010672f:	6a 00                	push   $0x0
c0106731:	50                   	push   %eax
c0106732:	e8 a8 13 00 00       	call   c0107adf <memset>
c0106737:	83 c4 10             	add    $0x10,%esp
        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
c010673a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010673d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106742:	83 c8 07             	or     $0x7,%eax
c0106745:	89 c2                	mov    %eax,%edx
c0106747:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010674a:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
c010674c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010674f:	c1 e8 0c             	shr    $0xc,%eax
c0106752:	25 ff 03 00 00       	and    $0x3ff,%eax
c0106757:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
c010675a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010675d:	8b 00                	mov    (%eax),%eax
c010675f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106764:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
c0106767:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010676a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010676d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106770:	c1 e8 0c             	shr    $0xc,%eax
c0106773:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106776:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c010677b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010677e:	72 17                	jb     c0106797 <get_pte+0x12a>
c0106780:	ff 75 d4             	pushl  -0x2c(%ebp)
c0106783:	68 d8 99 10 c0       	push   $0xc01099d8
c0106788:	68 91 01 00 00       	push   $0x191
c010678d:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106792:	e8 59 9c ff ff       	call   c01003f0 <__panic>
c0106797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010679a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010679f:	89 c2                	mov    %eax,%edx
c01067a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01067a4:	c1 e0 02             	shl    $0x2,%eax
c01067a7:	01 d0                	add    %edx,%eax
c01067a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
c01067ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
c01067af:	c9                   	leave  
c01067b0:	c3                   	ret    

c01067b1 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01067b1:	55                   	push   %ebp
c01067b2:	89 e5                	mov    %esp,%ebp
c01067b4:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01067b7:	83 ec 04             	sub    $0x4,%esp
c01067ba:	6a 00                	push   $0x0
c01067bc:	ff 75 0c             	pushl  0xc(%ebp)
c01067bf:	ff 75 08             	pushl  0x8(%ebp)
c01067c2:	e8 a6 fe ff ff       	call   c010666d <get_pte>
c01067c7:	83 c4 10             	add    $0x10,%esp
c01067ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01067cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01067d1:	74 08                	je     c01067db <get_page+0x2a>
        *ptep_store = ptep;
c01067d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01067d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01067d9:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01067db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01067df:	74 1f                	je     c0106800 <get_page+0x4f>
c01067e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067e4:	8b 00                	mov    (%eax),%eax
c01067e6:	83 e0 01             	and    $0x1,%eax
c01067e9:	85 c0                	test   %eax,%eax
c01067eb:	74 13                	je     c0106800 <get_page+0x4f>
        return pte2page(*ptep);
c01067ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067f0:	8b 00                	mov    (%eax),%eax
c01067f2:	83 ec 0c             	sub    $0xc,%esp
c01067f5:	50                   	push   %eax
c01067f6:	e8 a7 f5 ff ff       	call   c0105da2 <pte2page>
c01067fb:	83 c4 10             	add    $0x10,%esp
c01067fe:	eb 05                	jmp    c0106805 <get_page+0x54>
    }
    return NULL;
c0106800:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106805:	c9                   	leave  
c0106806:	c3                   	ret    

c0106807 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0106807:	55                   	push   %ebp
c0106808:	89 e5                	mov    %esp,%ebp
c010680a:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
c010680d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106810:	8b 00                	mov    (%eax),%eax
c0106812:	83 e0 01             	and    $0x1,%eax
c0106815:	85 c0                	test   %eax,%eax
c0106817:	74 57                	je     c0106870 <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
c0106819:	8b 45 10             	mov    0x10(%ebp),%eax
c010681c:	8b 00                	mov    (%eax),%eax
c010681e:	83 ec 0c             	sub    $0xc,%esp
c0106821:	50                   	push   %eax
c0106822:	e8 7b f5 ff ff       	call   c0105da2 <pte2page>
c0106827:	83 c4 10             	add    $0x10,%esp
c010682a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //(3) decrease page reference
    page_ref_dec(page);
c010682d:	83 ec 0c             	sub    $0xc,%esp
c0106830:	ff 75 f4             	pushl  -0xc(%ebp)
c0106833:	e8 ef f5 ff ff       	call   c0105e27 <page_ref_dec>
c0106838:	83 c4 10             	add    $0x10,%esp
    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
c010683b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010683e:	8b 00                	mov    (%eax),%eax
c0106840:	85 c0                	test   %eax,%eax
c0106842:	75 10                	jne    c0106854 <page_remove_pte+0x4d>
        free_page(page);
c0106844:	83 ec 08             	sub    $0x8,%esp
c0106847:	6a 01                	push   $0x1
c0106849:	ff 75 f4             	pushl  -0xc(%ebp)
c010684c:	e8 21 f8 ff ff       	call   c0106072 <free_pages>
c0106851:	83 c4 10             	add    $0x10,%esp
    }
    //(5) clear second page table entry
    *ptep = 0;
c0106854:	8b 45 10             	mov    0x10(%ebp),%eax
c0106857:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
c010685d:	83 ec 08             	sub    $0x8,%esp
c0106860:	ff 75 0c             	pushl  0xc(%ebp)
c0106863:	ff 75 08             	pushl  0x8(%ebp)
c0106866:	e8 fa 00 00 00       	call   c0106965 <tlb_invalidate>
c010686b:	83 c4 10             	add    $0x10,%esp
c010686e:	eb 01                	jmp    c0106871 <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
c0106870:	90                   	nop
    }
    //(5) clear second page table entry
    *ptep = 0;
    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
c0106871:	c9                   	leave  
c0106872:	c3                   	ret    

c0106873 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0106873:	55                   	push   %ebp
c0106874:	89 e5                	mov    %esp,%ebp
c0106876:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0106879:	83 ec 04             	sub    $0x4,%esp
c010687c:	6a 00                	push   $0x0
c010687e:	ff 75 0c             	pushl  0xc(%ebp)
c0106881:	ff 75 08             	pushl  0x8(%ebp)
c0106884:	e8 e4 fd ff ff       	call   c010666d <get_pte>
c0106889:	83 c4 10             	add    $0x10,%esp
c010688c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010688f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106893:	74 14                	je     c01068a9 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c0106895:	83 ec 04             	sub    $0x4,%esp
c0106898:	ff 75 f4             	pushl  -0xc(%ebp)
c010689b:	ff 75 0c             	pushl  0xc(%ebp)
c010689e:	ff 75 08             	pushl  0x8(%ebp)
c01068a1:	e8 61 ff ff ff       	call   c0106807 <page_remove_pte>
c01068a6:	83 c4 10             	add    $0x10,%esp
    }
}
c01068a9:	90                   	nop
c01068aa:	c9                   	leave  
c01068ab:	c3                   	ret    

c01068ac <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01068ac:	55                   	push   %ebp
c01068ad:	89 e5                	mov    %esp,%ebp
c01068af:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01068b2:	83 ec 04             	sub    $0x4,%esp
c01068b5:	6a 01                	push   $0x1
c01068b7:	ff 75 10             	pushl  0x10(%ebp)
c01068ba:	ff 75 08             	pushl  0x8(%ebp)
c01068bd:	e8 ab fd ff ff       	call   c010666d <get_pte>
c01068c2:	83 c4 10             	add    $0x10,%esp
c01068c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01068c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068cc:	75 0a                	jne    c01068d8 <page_insert+0x2c>
        return -E_NO_MEM;
c01068ce:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01068d3:	e9 8b 00 00 00       	jmp    c0106963 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01068d8:	83 ec 0c             	sub    $0xc,%esp
c01068db:	ff 75 0c             	pushl  0xc(%ebp)
c01068de:	e8 2d f5 ff ff       	call   c0105e10 <page_ref_inc>
c01068e3:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01068e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01068e9:	8b 00                	mov    (%eax),%eax
c01068eb:	83 e0 01             	and    $0x1,%eax
c01068ee:	85 c0                	test   %eax,%eax
c01068f0:	74 40                	je     c0106932 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01068f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01068f5:	8b 00                	mov    (%eax),%eax
c01068f7:	83 ec 0c             	sub    $0xc,%esp
c01068fa:	50                   	push   %eax
c01068fb:	e8 a2 f4 ff ff       	call   c0105da2 <pte2page>
c0106900:	83 c4 10             	add    $0x10,%esp
c0106903:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0106906:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106909:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010690c:	75 10                	jne    c010691e <page_insert+0x72>
            page_ref_dec(page);
c010690e:	83 ec 0c             	sub    $0xc,%esp
c0106911:	ff 75 0c             	pushl  0xc(%ebp)
c0106914:	e8 0e f5 ff ff       	call   c0105e27 <page_ref_dec>
c0106919:	83 c4 10             	add    $0x10,%esp
c010691c:	eb 14                	jmp    c0106932 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010691e:	83 ec 04             	sub    $0x4,%esp
c0106921:	ff 75 f4             	pushl  -0xc(%ebp)
c0106924:	ff 75 10             	pushl  0x10(%ebp)
c0106927:	ff 75 08             	pushl  0x8(%ebp)
c010692a:	e8 d8 fe ff ff       	call   c0106807 <page_remove_pte>
c010692f:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0106932:	83 ec 0c             	sub    $0xc,%esp
c0106935:	ff 75 0c             	pushl  0xc(%ebp)
c0106938:	e8 91 f3 ff ff       	call   c0105cce <page2pa>
c010693d:	83 c4 10             	add    $0x10,%esp
c0106940:	0b 45 14             	or     0x14(%ebp),%eax
c0106943:	83 c8 01             	or     $0x1,%eax
c0106946:	89 c2                	mov    %eax,%edx
c0106948:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010694b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010694d:	83 ec 08             	sub    $0x8,%esp
c0106950:	ff 75 10             	pushl  0x10(%ebp)
c0106953:	ff 75 08             	pushl  0x8(%ebp)
c0106956:	e8 0a 00 00 00       	call   c0106965 <tlb_invalidate>
c010695b:	83 c4 10             	add    $0x10,%esp
    return 0;
c010695e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106963:	c9                   	leave  
c0106964:	c3                   	ret    

c0106965 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0106965:	55                   	push   %ebp
c0106966:	89 e5                	mov    %esp,%ebp
c0106968:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010696b:	0f 20 d8             	mov    %cr3,%eax
c010696e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0106971:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0106974:	8b 45 08             	mov    0x8(%ebp),%eax
c0106977:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010697a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0106981:	77 17                	ja     c010699a <tlb_invalidate+0x35>
c0106983:	ff 75 f0             	pushl  -0x10(%ebp)
c0106986:	68 fc 99 10 c0       	push   $0xc01099fc
c010698b:	68 fc 01 00 00       	push   $0x1fc
c0106990:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106995:	e8 56 9a ff ff       	call   c01003f0 <__panic>
c010699a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010699d:	05 00 00 00 40       	add    $0x40000000,%eax
c01069a2:	39 c2                	cmp    %eax,%edx
c01069a4:	75 0c                	jne    c01069b2 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c01069a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01069ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069af:	0f 01 38             	invlpg (%eax)
    }
}
c01069b2:	90                   	nop
c01069b3:	c9                   	leave  
c01069b4:	c3                   	ret    

c01069b5 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01069b5:	55                   	push   %ebp
c01069b6:	89 e5                	mov    %esp,%ebp
c01069b8:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_page();
c01069bb:	83 ec 0c             	sub    $0xc,%esp
c01069be:	6a 01                	push   $0x1
c01069c0:	e8 41 f6 ff ff       	call   c0106006 <alloc_pages>
c01069c5:	83 c4 10             	add    $0x10,%esp
c01069c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01069cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01069cf:	0f 84 83 00 00 00    	je     c0106a58 <pgdir_alloc_page+0xa3>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01069d5:	ff 75 10             	pushl  0x10(%ebp)
c01069d8:	ff 75 0c             	pushl  0xc(%ebp)
c01069db:	ff 75 f4             	pushl  -0xc(%ebp)
c01069de:	ff 75 08             	pushl  0x8(%ebp)
c01069e1:	e8 c6 fe ff ff       	call   c01068ac <page_insert>
c01069e6:	83 c4 10             	add    $0x10,%esp
c01069e9:	85 c0                	test   %eax,%eax
c01069eb:	74 17                	je     c0106a04 <pgdir_alloc_page+0x4f>
            free_page(page);
c01069ed:	83 ec 08             	sub    $0x8,%esp
c01069f0:	6a 01                	push   $0x1
c01069f2:	ff 75 f4             	pushl  -0xc(%ebp)
c01069f5:	e8 78 f6 ff ff       	call   c0106072 <free_pages>
c01069fa:	83 c4 10             	add    $0x10,%esp
            return NULL;
c01069fd:	b8 00 00 00 00       	mov    $0x0,%eax
c0106a02:	eb 57                	jmp    c0106a5b <pgdir_alloc_page+0xa6>
        }
        if (swap_init_ok){
c0106a04:	a1 68 2f 12 c0       	mov    0xc0122f68,%eax
c0106a09:	85 c0                	test   %eax,%eax
c0106a0b:	74 4b                	je     c0106a58 <pgdir_alloc_page+0xa3>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0106a0d:	a1 70 30 12 c0       	mov    0xc0123070,%eax
c0106a12:	6a 00                	push   $0x0
c0106a14:	ff 75 f4             	pushl  -0xc(%ebp)
c0106a17:	ff 75 0c             	pushl  0xc(%ebp)
c0106a1a:	50                   	push   %eax
c0106a1b:	e8 6b d9 ff ff       	call   c010438b <swap_map_swappable>
c0106a20:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr=la;
c0106a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a26:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106a29:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0106a2c:	83 ec 0c             	sub    $0xc,%esp
c0106a2f:	ff 75 f4             	pushl  -0xc(%ebp)
c0106a32:	e8 c1 f3 ff ff       	call   c0105df8 <page_ref>
c0106a37:	83 c4 10             	add    $0x10,%esp
c0106a3a:	83 f8 01             	cmp    $0x1,%eax
c0106a3d:	74 19                	je     c0106a58 <pgdir_alloc_page+0xa3>
c0106a3f:	68 00 9b 10 c0       	push   $0xc0109b00
c0106a44:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106a49:	68 0f 02 00 00       	push   $0x20f
c0106a4e:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106a53:	e8 98 99 ff ff       	call   c01003f0 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0106a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106a5b:	c9                   	leave  
c0106a5c:	c3                   	ret    

c0106a5d <check_alloc_page>:

static void
check_alloc_page(void) {
c0106a5d:	55                   	push   %ebp
c0106a5e:	89 e5                	mov    %esp,%ebp
c0106a60:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0106a63:	a1 50 31 12 c0       	mov    0xc0123150,%eax
c0106a68:	8b 40 18             	mov    0x18(%eax),%eax
c0106a6b:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0106a6d:	83 ec 0c             	sub    $0xc,%esp
c0106a70:	68 14 9b 10 c0       	push   $0xc0109b14
c0106a75:	e8 10 98 ff ff       	call   c010028a <cprintf>
c0106a7a:	83 c4 10             	add    $0x10,%esp
}
c0106a7d:	90                   	nop
c0106a7e:	c9                   	leave  
c0106a7f:	c3                   	ret    

c0106a80 <check_pgdir>:

static void
check_pgdir(void) {
c0106a80:	55                   	push   %ebp
c0106a81:	89 e5                	mov    %esp,%ebp
c0106a83:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0106a86:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0106a8b:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0106a90:	76 19                	jbe    c0106aab <check_pgdir+0x2b>
c0106a92:	68 33 9b 10 c0       	push   $0xc0109b33
c0106a97:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106a9c:	68 20 02 00 00       	push   $0x220
c0106aa1:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106aa6:	e8 45 99 ff ff       	call   c01003f0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0106aab:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106ab0:	85 c0                	test   %eax,%eax
c0106ab2:	74 0e                	je     c0106ac2 <check_pgdir+0x42>
c0106ab4:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106ab9:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106abe:	85 c0                	test   %eax,%eax
c0106ac0:	74 19                	je     c0106adb <check_pgdir+0x5b>
c0106ac2:	68 50 9b 10 c0       	push   $0xc0109b50
c0106ac7:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106acc:	68 21 02 00 00       	push   $0x221
c0106ad1:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106ad6:	e8 15 99 ff ff       	call   c01003f0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0106adb:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106ae0:	83 ec 04             	sub    $0x4,%esp
c0106ae3:	6a 00                	push   $0x0
c0106ae5:	6a 00                	push   $0x0
c0106ae7:	50                   	push   %eax
c0106ae8:	e8 c4 fc ff ff       	call   c01067b1 <get_page>
c0106aed:	83 c4 10             	add    $0x10,%esp
c0106af0:	85 c0                	test   %eax,%eax
c0106af2:	74 19                	je     c0106b0d <check_pgdir+0x8d>
c0106af4:	68 88 9b 10 c0       	push   $0xc0109b88
c0106af9:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106afe:	68 22 02 00 00       	push   $0x222
c0106b03:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106b08:	e8 e3 98 ff ff       	call   c01003f0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0106b0d:	83 ec 0c             	sub    $0xc,%esp
c0106b10:	6a 01                	push   $0x1
c0106b12:	e8 ef f4 ff ff       	call   c0106006 <alloc_pages>
c0106b17:	83 c4 10             	add    $0x10,%esp
c0106b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0106b1d:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106b22:	6a 00                	push   $0x0
c0106b24:	6a 00                	push   $0x0
c0106b26:	ff 75 f4             	pushl  -0xc(%ebp)
c0106b29:	50                   	push   %eax
c0106b2a:	e8 7d fd ff ff       	call   c01068ac <page_insert>
c0106b2f:	83 c4 10             	add    $0x10,%esp
c0106b32:	85 c0                	test   %eax,%eax
c0106b34:	74 19                	je     c0106b4f <check_pgdir+0xcf>
c0106b36:	68 b0 9b 10 c0       	push   $0xc0109bb0
c0106b3b:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106b40:	68 26 02 00 00       	push   $0x226
c0106b45:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106b4a:	e8 a1 98 ff ff       	call   c01003f0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0106b4f:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106b54:	83 ec 04             	sub    $0x4,%esp
c0106b57:	6a 00                	push   $0x0
c0106b59:	6a 00                	push   $0x0
c0106b5b:	50                   	push   %eax
c0106b5c:	e8 0c fb ff ff       	call   c010666d <get_pte>
c0106b61:	83 c4 10             	add    $0x10,%esp
c0106b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106b67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106b6b:	75 19                	jne    c0106b86 <check_pgdir+0x106>
c0106b6d:	68 dc 9b 10 c0       	push   $0xc0109bdc
c0106b72:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106b77:	68 29 02 00 00       	push   $0x229
c0106b7c:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106b81:	e8 6a 98 ff ff       	call   c01003f0 <__panic>
    assert(pte2page(*ptep) == p1);
c0106b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b89:	8b 00                	mov    (%eax),%eax
c0106b8b:	83 ec 0c             	sub    $0xc,%esp
c0106b8e:	50                   	push   %eax
c0106b8f:	e8 0e f2 ff ff       	call   c0105da2 <pte2page>
c0106b94:	83 c4 10             	add    $0x10,%esp
c0106b97:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106b9a:	74 19                	je     c0106bb5 <check_pgdir+0x135>
c0106b9c:	68 09 9c 10 c0       	push   $0xc0109c09
c0106ba1:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106ba6:	68 2a 02 00 00       	push   $0x22a
c0106bab:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106bb0:	e8 3b 98 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p1) == 1);
c0106bb5:	83 ec 0c             	sub    $0xc,%esp
c0106bb8:	ff 75 f4             	pushl  -0xc(%ebp)
c0106bbb:	e8 38 f2 ff ff       	call   c0105df8 <page_ref>
c0106bc0:	83 c4 10             	add    $0x10,%esp
c0106bc3:	83 f8 01             	cmp    $0x1,%eax
c0106bc6:	74 19                	je     c0106be1 <check_pgdir+0x161>
c0106bc8:	68 1f 9c 10 c0       	push   $0xc0109c1f
c0106bcd:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106bd2:	68 2b 02 00 00       	push   $0x22b
c0106bd7:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106bdc:	e8 0f 98 ff ff       	call   c01003f0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0106be1:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106be6:	8b 00                	mov    (%eax),%eax
c0106be8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106bed:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bf3:	c1 e8 0c             	shr    $0xc,%eax
c0106bf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106bf9:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0106bfe:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106c01:	72 17                	jb     c0106c1a <check_pgdir+0x19a>
c0106c03:	ff 75 ec             	pushl  -0x14(%ebp)
c0106c06:	68 d8 99 10 c0       	push   $0xc01099d8
c0106c0b:	68 2d 02 00 00       	push   $0x22d
c0106c10:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106c15:	e8 d6 97 ff ff       	call   c01003f0 <__panic>
c0106c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c1d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106c22:	83 c0 04             	add    $0x4,%eax
c0106c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0106c28:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106c2d:	83 ec 04             	sub    $0x4,%esp
c0106c30:	6a 00                	push   $0x0
c0106c32:	68 00 10 00 00       	push   $0x1000
c0106c37:	50                   	push   %eax
c0106c38:	e8 30 fa ff ff       	call   c010666d <get_pte>
c0106c3d:	83 c4 10             	add    $0x10,%esp
c0106c40:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106c43:	74 19                	je     c0106c5e <check_pgdir+0x1de>
c0106c45:	68 34 9c 10 c0       	push   $0xc0109c34
c0106c4a:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106c4f:	68 2e 02 00 00       	push   $0x22e
c0106c54:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106c59:	e8 92 97 ff ff       	call   c01003f0 <__panic>

    p2 = alloc_page();
c0106c5e:	83 ec 0c             	sub    $0xc,%esp
c0106c61:	6a 01                	push   $0x1
c0106c63:	e8 9e f3 ff ff       	call   c0106006 <alloc_pages>
c0106c68:	83 c4 10             	add    $0x10,%esp
c0106c6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0106c6e:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106c73:	6a 06                	push   $0x6
c0106c75:	68 00 10 00 00       	push   $0x1000
c0106c7a:	ff 75 e4             	pushl  -0x1c(%ebp)
c0106c7d:	50                   	push   %eax
c0106c7e:	e8 29 fc ff ff       	call   c01068ac <page_insert>
c0106c83:	83 c4 10             	add    $0x10,%esp
c0106c86:	85 c0                	test   %eax,%eax
c0106c88:	74 19                	je     c0106ca3 <check_pgdir+0x223>
c0106c8a:	68 5c 9c 10 c0       	push   $0xc0109c5c
c0106c8f:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106c94:	68 31 02 00 00       	push   $0x231
c0106c99:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106c9e:	e8 4d 97 ff ff       	call   c01003f0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106ca3:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106ca8:	83 ec 04             	sub    $0x4,%esp
c0106cab:	6a 00                	push   $0x0
c0106cad:	68 00 10 00 00       	push   $0x1000
c0106cb2:	50                   	push   %eax
c0106cb3:	e8 b5 f9 ff ff       	call   c010666d <get_pte>
c0106cb8:	83 c4 10             	add    $0x10,%esp
c0106cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106cc2:	75 19                	jne    c0106cdd <check_pgdir+0x25d>
c0106cc4:	68 94 9c 10 c0       	push   $0xc0109c94
c0106cc9:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106cce:	68 32 02 00 00       	push   $0x232
c0106cd3:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106cd8:	e8 13 97 ff ff       	call   c01003f0 <__panic>
    assert(*ptep & PTE_U);
c0106cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ce0:	8b 00                	mov    (%eax),%eax
c0106ce2:	83 e0 04             	and    $0x4,%eax
c0106ce5:	85 c0                	test   %eax,%eax
c0106ce7:	75 19                	jne    c0106d02 <check_pgdir+0x282>
c0106ce9:	68 c4 9c 10 c0       	push   $0xc0109cc4
c0106cee:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106cf3:	68 33 02 00 00       	push   $0x233
c0106cf8:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106cfd:	e8 ee 96 ff ff       	call   c01003f0 <__panic>
    assert(*ptep & PTE_W);
c0106d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d05:	8b 00                	mov    (%eax),%eax
c0106d07:	83 e0 02             	and    $0x2,%eax
c0106d0a:	85 c0                	test   %eax,%eax
c0106d0c:	75 19                	jne    c0106d27 <check_pgdir+0x2a7>
c0106d0e:	68 d2 9c 10 c0       	push   $0xc0109cd2
c0106d13:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106d18:	68 34 02 00 00       	push   $0x234
c0106d1d:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106d22:	e8 c9 96 ff ff       	call   c01003f0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0106d27:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106d2c:	8b 00                	mov    (%eax),%eax
c0106d2e:	83 e0 04             	and    $0x4,%eax
c0106d31:	85 c0                	test   %eax,%eax
c0106d33:	75 19                	jne    c0106d4e <check_pgdir+0x2ce>
c0106d35:	68 e0 9c 10 c0       	push   $0xc0109ce0
c0106d3a:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106d3f:	68 35 02 00 00       	push   $0x235
c0106d44:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106d49:	e8 a2 96 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 1);
c0106d4e:	83 ec 0c             	sub    $0xc,%esp
c0106d51:	ff 75 e4             	pushl  -0x1c(%ebp)
c0106d54:	e8 9f f0 ff ff       	call   c0105df8 <page_ref>
c0106d59:	83 c4 10             	add    $0x10,%esp
c0106d5c:	83 f8 01             	cmp    $0x1,%eax
c0106d5f:	74 19                	je     c0106d7a <check_pgdir+0x2fa>
c0106d61:	68 f6 9c 10 c0       	push   $0xc0109cf6
c0106d66:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106d6b:	68 36 02 00 00       	push   $0x236
c0106d70:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106d75:	e8 76 96 ff ff       	call   c01003f0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0106d7a:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106d7f:	6a 00                	push   $0x0
c0106d81:	68 00 10 00 00       	push   $0x1000
c0106d86:	ff 75 f4             	pushl  -0xc(%ebp)
c0106d89:	50                   	push   %eax
c0106d8a:	e8 1d fb ff ff       	call   c01068ac <page_insert>
c0106d8f:	83 c4 10             	add    $0x10,%esp
c0106d92:	85 c0                	test   %eax,%eax
c0106d94:	74 19                	je     c0106daf <check_pgdir+0x32f>
c0106d96:	68 08 9d 10 c0       	push   $0xc0109d08
c0106d9b:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106da0:	68 38 02 00 00       	push   $0x238
c0106da5:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106daa:	e8 41 96 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p1) == 2);
c0106daf:	83 ec 0c             	sub    $0xc,%esp
c0106db2:	ff 75 f4             	pushl  -0xc(%ebp)
c0106db5:	e8 3e f0 ff ff       	call   c0105df8 <page_ref>
c0106dba:	83 c4 10             	add    $0x10,%esp
c0106dbd:	83 f8 02             	cmp    $0x2,%eax
c0106dc0:	74 19                	je     c0106ddb <check_pgdir+0x35b>
c0106dc2:	68 34 9d 10 c0       	push   $0xc0109d34
c0106dc7:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106dcc:	68 39 02 00 00       	push   $0x239
c0106dd1:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106dd6:	e8 15 96 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c0106ddb:	83 ec 0c             	sub    $0xc,%esp
c0106dde:	ff 75 e4             	pushl  -0x1c(%ebp)
c0106de1:	e8 12 f0 ff ff       	call   c0105df8 <page_ref>
c0106de6:	83 c4 10             	add    $0x10,%esp
c0106de9:	85 c0                	test   %eax,%eax
c0106deb:	74 19                	je     c0106e06 <check_pgdir+0x386>
c0106ded:	68 46 9d 10 c0       	push   $0xc0109d46
c0106df2:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106df7:	68 3a 02 00 00       	push   $0x23a
c0106dfc:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106e01:	e8 ea 95 ff ff       	call   c01003f0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106e06:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106e0b:	83 ec 04             	sub    $0x4,%esp
c0106e0e:	6a 00                	push   $0x0
c0106e10:	68 00 10 00 00       	push   $0x1000
c0106e15:	50                   	push   %eax
c0106e16:	e8 52 f8 ff ff       	call   c010666d <get_pte>
c0106e1b:	83 c4 10             	add    $0x10,%esp
c0106e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106e21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106e25:	75 19                	jne    c0106e40 <check_pgdir+0x3c0>
c0106e27:	68 94 9c 10 c0       	push   $0xc0109c94
c0106e2c:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106e31:	68 3b 02 00 00       	push   $0x23b
c0106e36:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106e3b:	e8 b0 95 ff ff       	call   c01003f0 <__panic>
    assert(pte2page(*ptep) == p1);
c0106e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e43:	8b 00                	mov    (%eax),%eax
c0106e45:	83 ec 0c             	sub    $0xc,%esp
c0106e48:	50                   	push   %eax
c0106e49:	e8 54 ef ff ff       	call   c0105da2 <pte2page>
c0106e4e:	83 c4 10             	add    $0x10,%esp
c0106e51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106e54:	74 19                	je     c0106e6f <check_pgdir+0x3ef>
c0106e56:	68 09 9c 10 c0       	push   $0xc0109c09
c0106e5b:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106e60:	68 3c 02 00 00       	push   $0x23c
c0106e65:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106e6a:	e8 81 95 ff ff       	call   c01003f0 <__panic>
    assert((*ptep & PTE_U) == 0);
c0106e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e72:	8b 00                	mov    (%eax),%eax
c0106e74:	83 e0 04             	and    $0x4,%eax
c0106e77:	85 c0                	test   %eax,%eax
c0106e79:	74 19                	je     c0106e94 <check_pgdir+0x414>
c0106e7b:	68 58 9d 10 c0       	push   $0xc0109d58
c0106e80:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106e85:	68 3d 02 00 00       	push   $0x23d
c0106e8a:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106e8f:	e8 5c 95 ff ff       	call   c01003f0 <__panic>

    page_remove(boot_pgdir, 0x0);
c0106e94:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106e99:	83 ec 08             	sub    $0x8,%esp
c0106e9c:	6a 00                	push   $0x0
c0106e9e:	50                   	push   %eax
c0106e9f:	e8 cf f9 ff ff       	call   c0106873 <page_remove>
c0106ea4:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0106ea7:	83 ec 0c             	sub    $0xc,%esp
c0106eaa:	ff 75 f4             	pushl  -0xc(%ebp)
c0106ead:	e8 46 ef ff ff       	call   c0105df8 <page_ref>
c0106eb2:	83 c4 10             	add    $0x10,%esp
c0106eb5:	83 f8 01             	cmp    $0x1,%eax
c0106eb8:	74 19                	je     c0106ed3 <check_pgdir+0x453>
c0106eba:	68 1f 9c 10 c0       	push   $0xc0109c1f
c0106ebf:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106ec4:	68 40 02 00 00       	push   $0x240
c0106ec9:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106ece:	e8 1d 95 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c0106ed3:	83 ec 0c             	sub    $0xc,%esp
c0106ed6:	ff 75 e4             	pushl  -0x1c(%ebp)
c0106ed9:	e8 1a ef ff ff       	call   c0105df8 <page_ref>
c0106ede:	83 c4 10             	add    $0x10,%esp
c0106ee1:	85 c0                	test   %eax,%eax
c0106ee3:	74 19                	je     c0106efe <check_pgdir+0x47e>
c0106ee5:	68 46 9d 10 c0       	push   $0xc0109d46
c0106eea:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106eef:	68 41 02 00 00       	push   $0x241
c0106ef4:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106ef9:	e8 f2 94 ff ff       	call   c01003f0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0106efe:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106f03:	83 ec 08             	sub    $0x8,%esp
c0106f06:	68 00 10 00 00       	push   $0x1000
c0106f0b:	50                   	push   %eax
c0106f0c:	e8 62 f9 ff ff       	call   c0106873 <page_remove>
c0106f11:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0106f14:	83 ec 0c             	sub    $0xc,%esp
c0106f17:	ff 75 f4             	pushl  -0xc(%ebp)
c0106f1a:	e8 d9 ee ff ff       	call   c0105df8 <page_ref>
c0106f1f:	83 c4 10             	add    $0x10,%esp
c0106f22:	85 c0                	test   %eax,%eax
c0106f24:	74 19                	je     c0106f3f <check_pgdir+0x4bf>
c0106f26:	68 6d 9d 10 c0       	push   $0xc0109d6d
c0106f2b:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106f30:	68 44 02 00 00       	push   $0x244
c0106f35:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106f3a:	e8 b1 94 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p2) == 0);
c0106f3f:	83 ec 0c             	sub    $0xc,%esp
c0106f42:	ff 75 e4             	pushl  -0x1c(%ebp)
c0106f45:	e8 ae ee ff ff       	call   c0105df8 <page_ref>
c0106f4a:	83 c4 10             	add    $0x10,%esp
c0106f4d:	85 c0                	test   %eax,%eax
c0106f4f:	74 19                	je     c0106f6a <check_pgdir+0x4ea>
c0106f51:	68 46 9d 10 c0       	push   $0xc0109d46
c0106f56:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106f5b:	68 45 02 00 00       	push   $0x245
c0106f60:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106f65:	e8 86 94 ff ff       	call   c01003f0 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0106f6a:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106f6f:	8b 00                	mov    (%eax),%eax
c0106f71:	83 ec 0c             	sub    $0xc,%esp
c0106f74:	50                   	push   %eax
c0106f75:	e8 62 ee ff ff       	call   c0105ddc <pde2page>
c0106f7a:	83 c4 10             	add    $0x10,%esp
c0106f7d:	83 ec 0c             	sub    $0xc,%esp
c0106f80:	50                   	push   %eax
c0106f81:	e8 72 ee ff ff       	call   c0105df8 <page_ref>
c0106f86:	83 c4 10             	add    $0x10,%esp
c0106f89:	83 f8 01             	cmp    $0x1,%eax
c0106f8c:	74 19                	je     c0106fa7 <check_pgdir+0x527>
c0106f8e:	68 80 9d 10 c0       	push   $0xc0109d80
c0106f93:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0106f98:	68 47 02 00 00       	push   $0x247
c0106f9d:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0106fa2:	e8 49 94 ff ff       	call   c01003f0 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0106fa7:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106fac:	8b 00                	mov    (%eax),%eax
c0106fae:	83 ec 0c             	sub    $0xc,%esp
c0106fb1:	50                   	push   %eax
c0106fb2:	e8 25 ee ff ff       	call   c0105ddc <pde2page>
c0106fb7:	83 c4 10             	add    $0x10,%esp
c0106fba:	83 ec 08             	sub    $0x8,%esp
c0106fbd:	6a 01                	push   $0x1
c0106fbf:	50                   	push   %eax
c0106fc0:	e8 ad f0 ff ff       	call   c0106072 <free_pages>
c0106fc5:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0106fc8:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0106fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0106fd3:	83 ec 0c             	sub    $0xc,%esp
c0106fd6:	68 a7 9d 10 c0       	push   $0xc0109da7
c0106fdb:	e8 aa 92 ff ff       	call   c010028a <cprintf>
c0106fe0:	83 c4 10             	add    $0x10,%esp
}
c0106fe3:	90                   	nop
c0106fe4:	c9                   	leave  
c0106fe5:	c3                   	ret    

c0106fe6 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0106fe6:	55                   	push   %ebp
c0106fe7:	89 e5                	mov    %esp,%ebp
c0106fe9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106ff3:	e9 a3 00 00 00       	jmp    c010709b <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0106ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107001:	c1 e8 0c             	shr    $0xc,%eax
c0107004:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107007:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c010700c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010700f:	72 17                	jb     c0107028 <check_boot_pgdir+0x42>
c0107011:	ff 75 f0             	pushl  -0x10(%ebp)
c0107014:	68 d8 99 10 c0       	push   $0xc01099d8
c0107019:	68 53 02 00 00       	push   $0x253
c010701e:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0107023:	e8 c8 93 ff ff       	call   c01003f0 <__panic>
c0107028:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010702b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107030:	89 c2                	mov    %eax,%edx
c0107032:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0107037:	83 ec 04             	sub    $0x4,%esp
c010703a:	6a 00                	push   $0x0
c010703c:	52                   	push   %edx
c010703d:	50                   	push   %eax
c010703e:	e8 2a f6 ff ff       	call   c010666d <get_pte>
c0107043:	83 c4 10             	add    $0x10,%esp
c0107046:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107049:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010704d:	75 19                	jne    c0107068 <check_boot_pgdir+0x82>
c010704f:	68 c4 9d 10 c0       	push   $0xc0109dc4
c0107054:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107059:	68 53 02 00 00       	push   $0x253
c010705e:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0107063:	e8 88 93 ff ff       	call   c01003f0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0107068:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010706b:	8b 00                	mov    (%eax),%eax
c010706d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107072:	89 c2                	mov    %eax,%edx
c0107074:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107077:	39 c2                	cmp    %eax,%edx
c0107079:	74 19                	je     c0107094 <check_boot_pgdir+0xae>
c010707b:	68 01 9e 10 c0       	push   $0xc0109e01
c0107080:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107085:	68 54 02 00 00       	push   $0x254
c010708a:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010708f:	e8 5c 93 ff ff       	call   c01003f0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107094:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010709b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010709e:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c01070a3:	39 c2                	cmp    %eax,%edx
c01070a5:	0f 82 4d ff ff ff    	jb     c0106ff8 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01070ab:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c01070b0:	05 ac 0f 00 00       	add    $0xfac,%eax
c01070b5:	8b 00                	mov    (%eax),%eax
c01070b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01070bc:	89 c2                	mov    %eax,%edx
c01070be:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c01070c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01070c6:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01070cd:	77 17                	ja     c01070e6 <check_boot_pgdir+0x100>
c01070cf:	ff 75 e4             	pushl  -0x1c(%ebp)
c01070d2:	68 fc 99 10 c0       	push   $0xc01099fc
c01070d7:	68 57 02 00 00       	push   $0x257
c01070dc:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01070e1:	e8 0a 93 ff ff       	call   c01003f0 <__panic>
c01070e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01070e9:	05 00 00 00 40       	add    $0x40000000,%eax
c01070ee:	39 c2                	cmp    %eax,%edx
c01070f0:	74 19                	je     c010710b <check_boot_pgdir+0x125>
c01070f2:	68 18 9e 10 c0       	push   $0xc0109e18
c01070f7:	68 c5 9a 10 c0       	push   $0xc0109ac5
c01070fc:	68 57 02 00 00       	push   $0x257
c0107101:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0107106:	e8 e5 92 ff ff       	call   c01003f0 <__panic>

    assert(boot_pgdir[0] == 0);
c010710b:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0107110:	8b 00                	mov    (%eax),%eax
c0107112:	85 c0                	test   %eax,%eax
c0107114:	74 19                	je     c010712f <check_boot_pgdir+0x149>
c0107116:	68 4c 9e 10 c0       	push   $0xc0109e4c
c010711b:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107120:	68 59 02 00 00       	push   $0x259
c0107125:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010712a:	e8 c1 92 ff ff       	call   c01003f0 <__panic>

    struct Page *p;
    p = alloc_page();
c010712f:	83 ec 0c             	sub    $0xc,%esp
c0107132:	6a 01                	push   $0x1
c0107134:	e8 cd ee ff ff       	call   c0106006 <alloc_pages>
c0107139:	83 c4 10             	add    $0x10,%esp
c010713c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010713f:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c0107144:	6a 02                	push   $0x2
c0107146:	68 00 01 00 00       	push   $0x100
c010714b:	ff 75 e0             	pushl  -0x20(%ebp)
c010714e:	50                   	push   %eax
c010714f:	e8 58 f7 ff ff       	call   c01068ac <page_insert>
c0107154:	83 c4 10             	add    $0x10,%esp
c0107157:	85 c0                	test   %eax,%eax
c0107159:	74 19                	je     c0107174 <check_boot_pgdir+0x18e>
c010715b:	68 60 9e 10 c0       	push   $0xc0109e60
c0107160:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107165:	68 5d 02 00 00       	push   $0x25d
c010716a:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010716f:	e8 7c 92 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p) == 1);
c0107174:	83 ec 0c             	sub    $0xc,%esp
c0107177:	ff 75 e0             	pushl  -0x20(%ebp)
c010717a:	e8 79 ec ff ff       	call   c0105df8 <page_ref>
c010717f:	83 c4 10             	add    $0x10,%esp
c0107182:	83 f8 01             	cmp    $0x1,%eax
c0107185:	74 19                	je     c01071a0 <check_boot_pgdir+0x1ba>
c0107187:	68 8e 9e 10 c0       	push   $0xc0109e8e
c010718c:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107191:	68 5e 02 00 00       	push   $0x25e
c0107196:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010719b:	e8 50 92 ff ff       	call   c01003f0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01071a0:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c01071a5:	6a 02                	push   $0x2
c01071a7:	68 00 11 00 00       	push   $0x1100
c01071ac:	ff 75 e0             	pushl  -0x20(%ebp)
c01071af:	50                   	push   %eax
c01071b0:	e8 f7 f6 ff ff       	call   c01068ac <page_insert>
c01071b5:	83 c4 10             	add    $0x10,%esp
c01071b8:	85 c0                	test   %eax,%eax
c01071ba:	74 19                	je     c01071d5 <check_boot_pgdir+0x1ef>
c01071bc:	68 a0 9e 10 c0       	push   $0xc0109ea0
c01071c1:	68 c5 9a 10 c0       	push   $0xc0109ac5
c01071c6:	68 5f 02 00 00       	push   $0x25f
c01071cb:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01071d0:	e8 1b 92 ff ff       	call   c01003f0 <__panic>
    assert(page_ref(p) == 2);
c01071d5:	83 ec 0c             	sub    $0xc,%esp
c01071d8:	ff 75 e0             	pushl  -0x20(%ebp)
c01071db:	e8 18 ec ff ff       	call   c0105df8 <page_ref>
c01071e0:	83 c4 10             	add    $0x10,%esp
c01071e3:	83 f8 02             	cmp    $0x2,%eax
c01071e6:	74 19                	je     c0107201 <check_boot_pgdir+0x21b>
c01071e8:	68 d7 9e 10 c0       	push   $0xc0109ed7
c01071ed:	68 c5 9a 10 c0       	push   $0xc0109ac5
c01071f2:	68 60 02 00 00       	push   $0x260
c01071f7:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01071fc:	e8 ef 91 ff ff       	call   c01003f0 <__panic>

    const char *str = "ucore: Hello world!!";
c0107201:	c7 45 dc e8 9e 10 c0 	movl   $0xc0109ee8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0107208:	83 ec 08             	sub    $0x8,%esp
c010720b:	ff 75 dc             	pushl  -0x24(%ebp)
c010720e:	68 00 01 00 00       	push   $0x100
c0107213:	e8 ee 05 00 00       	call   c0107806 <strcpy>
c0107218:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010721b:	83 ec 08             	sub    $0x8,%esp
c010721e:	68 00 11 00 00       	push   $0x1100
c0107223:	68 00 01 00 00       	push   $0x100
c0107228:	e8 53 06 00 00       	call   c0107880 <strcmp>
c010722d:	83 c4 10             	add    $0x10,%esp
c0107230:	85 c0                	test   %eax,%eax
c0107232:	74 19                	je     c010724d <check_boot_pgdir+0x267>
c0107234:	68 00 9f 10 c0       	push   $0xc0109f00
c0107239:	68 c5 9a 10 c0       	push   $0xc0109ac5
c010723e:	68 64 02 00 00       	push   $0x264
c0107243:	68 a0 9a 10 c0       	push   $0xc0109aa0
c0107248:	e8 a3 91 ff ff       	call   c01003f0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010724d:	83 ec 0c             	sub    $0xc,%esp
c0107250:	ff 75 e0             	pushl  -0x20(%ebp)
c0107253:	e8 c6 ea ff ff       	call   c0105d1e <page2kva>
c0107258:	83 c4 10             	add    $0x10,%esp
c010725b:	05 00 01 00 00       	add    $0x100,%eax
c0107260:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0107263:	83 ec 0c             	sub    $0xc,%esp
c0107266:	68 00 01 00 00       	push   $0x100
c010726b:	e8 3e 05 00 00       	call   c01077ae <strlen>
c0107270:	83 c4 10             	add    $0x10,%esp
c0107273:	85 c0                	test   %eax,%eax
c0107275:	74 19                	je     c0107290 <check_boot_pgdir+0x2aa>
c0107277:	68 38 9f 10 c0       	push   $0xc0109f38
c010727c:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107281:	68 67 02 00 00       	push   $0x267
c0107286:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010728b:	e8 60 91 ff ff       	call   c01003f0 <__panic>

    free_page(p);
c0107290:	83 ec 08             	sub    $0x8,%esp
c0107293:	6a 01                	push   $0x1
c0107295:	ff 75 e0             	pushl  -0x20(%ebp)
c0107298:	e8 d5 ed ff ff       	call   c0106072 <free_pages>
c010729d:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c01072a0:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c01072a5:	8b 00                	mov    (%eax),%eax
c01072a7:	83 ec 0c             	sub    $0xc,%esp
c01072aa:	50                   	push   %eax
c01072ab:	e8 2c eb ff ff       	call   c0105ddc <pde2page>
c01072b0:	83 c4 10             	add    $0x10,%esp
c01072b3:	83 ec 08             	sub    $0x8,%esp
c01072b6:	6a 01                	push   $0x1
c01072b8:	50                   	push   %eax
c01072b9:	e8 b4 ed ff ff       	call   c0106072 <free_pages>
c01072be:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01072c1:	a1 00 fa 11 c0       	mov    0xc011fa00,%eax
c01072c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01072cc:	83 ec 0c             	sub    $0xc,%esp
c01072cf:	68 5c 9f 10 c0       	push   $0xc0109f5c
c01072d4:	e8 b1 8f ff ff       	call   c010028a <cprintf>
c01072d9:	83 c4 10             	add    $0x10,%esp
}
c01072dc:	90                   	nop
c01072dd:	c9                   	leave  
c01072de:	c3                   	ret    

c01072df <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01072df:	55                   	push   %ebp
c01072e0:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01072e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01072e5:	83 e0 04             	and    $0x4,%eax
c01072e8:	85 c0                	test   %eax,%eax
c01072ea:	74 07                	je     c01072f3 <perm2str+0x14>
c01072ec:	b8 75 00 00 00       	mov    $0x75,%eax
c01072f1:	eb 05                	jmp    c01072f8 <perm2str+0x19>
c01072f3:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01072f8:	a2 08 30 12 c0       	mov    %al,0xc0123008
    str[1] = 'r';
c01072fd:	c6 05 09 30 12 c0 72 	movb   $0x72,0xc0123009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0107304:	8b 45 08             	mov    0x8(%ebp),%eax
c0107307:	83 e0 02             	and    $0x2,%eax
c010730a:	85 c0                	test   %eax,%eax
c010730c:	74 07                	je     c0107315 <perm2str+0x36>
c010730e:	b8 77 00 00 00       	mov    $0x77,%eax
c0107313:	eb 05                	jmp    c010731a <perm2str+0x3b>
c0107315:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010731a:	a2 0a 30 12 c0       	mov    %al,0xc012300a
    str[3] = '\0';
c010731f:	c6 05 0b 30 12 c0 00 	movb   $0x0,0xc012300b
    return str;
c0107326:	b8 08 30 12 c0       	mov    $0xc0123008,%eax
}
c010732b:	5d                   	pop    %ebp
c010732c:	c3                   	ret    

c010732d <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010732d:	55                   	push   %ebp
c010732e:	89 e5                	mov    %esp,%ebp
c0107330:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0107333:	8b 45 10             	mov    0x10(%ebp),%eax
c0107336:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107339:	72 0e                	jb     c0107349 <get_pgtable_items+0x1c>
        return 0;
c010733b:	b8 00 00 00 00       	mov    $0x0,%eax
c0107340:	e9 9a 00 00 00       	jmp    c01073df <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0107345:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0107349:	8b 45 10             	mov    0x10(%ebp),%eax
c010734c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010734f:	73 18                	jae    c0107369 <get_pgtable_items+0x3c>
c0107351:	8b 45 10             	mov    0x10(%ebp),%eax
c0107354:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010735b:	8b 45 14             	mov    0x14(%ebp),%eax
c010735e:	01 d0                	add    %edx,%eax
c0107360:	8b 00                	mov    (%eax),%eax
c0107362:	83 e0 01             	and    $0x1,%eax
c0107365:	85 c0                	test   %eax,%eax
c0107367:	74 dc                	je     c0107345 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0107369:	8b 45 10             	mov    0x10(%ebp),%eax
c010736c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010736f:	73 69                	jae    c01073da <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0107371:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0107375:	74 08                	je     c010737f <get_pgtable_items+0x52>
            *left_store = start;
c0107377:	8b 45 18             	mov    0x18(%ebp),%eax
c010737a:	8b 55 10             	mov    0x10(%ebp),%edx
c010737d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010737f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107382:	8d 50 01             	lea    0x1(%eax),%edx
c0107385:	89 55 10             	mov    %edx,0x10(%ebp)
c0107388:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010738f:	8b 45 14             	mov    0x14(%ebp),%eax
c0107392:	01 d0                	add    %edx,%eax
c0107394:	8b 00                	mov    (%eax),%eax
c0107396:	83 e0 07             	and    $0x7,%eax
c0107399:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010739c:	eb 04                	jmp    c01073a2 <get_pgtable_items+0x75>
            start ++;
c010739e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01073a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01073a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073a8:	73 1d                	jae    c01073c7 <get_pgtable_items+0x9a>
c01073aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01073ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01073b4:	8b 45 14             	mov    0x14(%ebp),%eax
c01073b7:	01 d0                	add    %edx,%eax
c01073b9:	8b 00                	mov    (%eax),%eax
c01073bb:	83 e0 07             	and    $0x7,%eax
c01073be:	89 c2                	mov    %eax,%edx
c01073c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073c3:	39 c2                	cmp    %eax,%edx
c01073c5:	74 d7                	je     c010739e <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c01073c7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01073cb:	74 08                	je     c01073d5 <get_pgtable_items+0xa8>
            *right_store = start;
c01073cd:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01073d0:	8b 55 10             	mov    0x10(%ebp),%edx
c01073d3:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01073d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073d8:	eb 05                	jmp    c01073df <get_pgtable_items+0xb2>
    }
    return 0;
c01073da:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01073df:	c9                   	leave  
c01073e0:	c3                   	ret    

c01073e1 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01073e1:	55                   	push   %ebp
c01073e2:	89 e5                	mov    %esp,%ebp
c01073e4:	57                   	push   %edi
c01073e5:	56                   	push   %esi
c01073e6:	53                   	push   %ebx
c01073e7:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01073ea:	83 ec 0c             	sub    $0xc,%esp
c01073ed:	68 7c 9f 10 c0       	push   $0xc0109f7c
c01073f2:	e8 93 8e ff ff       	call   c010028a <cprintf>
c01073f7:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c01073fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0107401:	e9 e5 00 00 00       	jmp    c01074eb <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107409:	83 ec 0c             	sub    $0xc,%esp
c010740c:	50                   	push   %eax
c010740d:	e8 cd fe ff ff       	call   c01072df <perm2str>
c0107412:	83 c4 10             	add    $0x10,%esp
c0107415:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0107417:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010741a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010741d:	29 c2                	sub    %eax,%edx
c010741f:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107421:	c1 e0 16             	shl    $0x16,%eax
c0107424:	89 c3                	mov    %eax,%ebx
c0107426:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107429:	c1 e0 16             	shl    $0x16,%eax
c010742c:	89 c1                	mov    %eax,%ecx
c010742e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107431:	c1 e0 16             	shl    $0x16,%eax
c0107434:	89 c2                	mov    %eax,%edx
c0107436:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0107439:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010743c:	29 c6                	sub    %eax,%esi
c010743e:	89 f0                	mov    %esi,%eax
c0107440:	83 ec 08             	sub    $0x8,%esp
c0107443:	57                   	push   %edi
c0107444:	53                   	push   %ebx
c0107445:	51                   	push   %ecx
c0107446:	52                   	push   %edx
c0107447:	50                   	push   %eax
c0107448:	68 ad 9f 10 c0       	push   $0xc0109fad
c010744d:	e8 38 8e ff ff       	call   c010028a <cprintf>
c0107452:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0107455:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107458:	c1 e0 0a             	shl    $0xa,%eax
c010745b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010745e:	eb 4f                	jmp    c01074af <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0107460:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107463:	83 ec 0c             	sub    $0xc,%esp
c0107466:	50                   	push   %eax
c0107467:	e8 73 fe ff ff       	call   c01072df <perm2str>
c010746c:	83 c4 10             	add    $0x10,%esp
c010746f:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0107471:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107474:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107477:	29 c2                	sub    %eax,%edx
c0107479:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010747b:	c1 e0 0c             	shl    $0xc,%eax
c010747e:	89 c3                	mov    %eax,%ebx
c0107480:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107483:	c1 e0 0c             	shl    $0xc,%eax
c0107486:	89 c1                	mov    %eax,%ecx
c0107488:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010748b:	c1 e0 0c             	shl    $0xc,%eax
c010748e:	89 c2                	mov    %eax,%edx
c0107490:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0107493:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107496:	29 c6                	sub    %eax,%esi
c0107498:	89 f0                	mov    %esi,%eax
c010749a:	83 ec 08             	sub    $0x8,%esp
c010749d:	57                   	push   %edi
c010749e:	53                   	push   %ebx
c010749f:	51                   	push   %ecx
c01074a0:	52                   	push   %edx
c01074a1:	50                   	push   %eax
c01074a2:	68 cc 9f 10 c0       	push   $0xc0109fcc
c01074a7:	e8 de 8d ff ff       	call   c010028a <cprintf>
c01074ac:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01074af:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01074b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01074b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01074ba:	89 d3                	mov    %edx,%ebx
c01074bc:	c1 e3 0a             	shl    $0xa,%ebx
c01074bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01074c2:	89 d1                	mov    %edx,%ecx
c01074c4:	c1 e1 0a             	shl    $0xa,%ecx
c01074c7:	83 ec 08             	sub    $0x8,%esp
c01074ca:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01074cd:	52                   	push   %edx
c01074ce:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01074d1:	52                   	push   %edx
c01074d2:	56                   	push   %esi
c01074d3:	50                   	push   %eax
c01074d4:	53                   	push   %ebx
c01074d5:	51                   	push   %ecx
c01074d6:	e8 52 fe ff ff       	call   c010732d <get_pgtable_items>
c01074db:	83 c4 20             	add    $0x20,%esp
c01074de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01074e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01074e5:	0f 85 75 ff ff ff    	jne    c0107460 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01074eb:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01074f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074f3:	83 ec 08             	sub    $0x8,%esp
c01074f6:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01074f9:	52                   	push   %edx
c01074fa:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01074fd:	52                   	push   %edx
c01074fe:	51                   	push   %ecx
c01074ff:	50                   	push   %eax
c0107500:	68 00 04 00 00       	push   $0x400
c0107505:	6a 00                	push   $0x0
c0107507:	e8 21 fe ff ff       	call   c010732d <get_pgtable_items>
c010750c:	83 c4 20             	add    $0x20,%esp
c010750f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107512:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107516:	0f 85 ea fe ff ff    	jne    c0107406 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010751c:	83 ec 0c             	sub    $0xc,%esp
c010751f:	68 f0 9f 10 c0       	push   $0xc0109ff0
c0107524:	e8 61 8d ff ff       	call   c010028a <cprintf>
c0107529:	83 c4 10             	add    $0x10,%esp
}
c010752c:	90                   	nop
c010752d:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0107530:	5b                   	pop    %ebx
c0107531:	5e                   	pop    %esi
c0107532:	5f                   	pop    %edi
c0107533:	5d                   	pop    %ebp
c0107534:	c3                   	ret    

c0107535 <kmalloc>:

void *
kmalloc(size_t n) {
c0107535:	55                   	push   %ebp
c0107536:	89 e5                	mov    %esp,%ebp
c0107538:	83 ec 18             	sub    $0x18,%esp
    void * ptr=NULL;
c010753b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0107542:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0107549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010754d:	74 09                	je     c0107558 <kmalloc+0x23>
c010754f:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0107556:	76 19                	jbe    c0107571 <kmalloc+0x3c>
c0107558:	68 21 a0 10 c0       	push   $0xc010a021
c010755d:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107562:	68 b3 02 00 00       	push   $0x2b3
c0107567:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010756c:	e8 7f 8e ff ff       	call   c01003f0 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0107571:	8b 45 08             	mov    0x8(%ebp),%eax
c0107574:	05 ff 0f 00 00       	add    $0xfff,%eax
c0107579:	c1 e8 0c             	shr    $0xc,%eax
c010757c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c010757f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107582:	83 ec 0c             	sub    $0xc,%esp
c0107585:	50                   	push   %eax
c0107586:	e8 7b ea ff ff       	call   c0106006 <alloc_pages>
c010758b:	83 c4 10             	add    $0x10,%esp
c010758e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0107591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107595:	75 19                	jne    c01075b0 <kmalloc+0x7b>
c0107597:	68 38 a0 10 c0       	push   $0xc010a038
c010759c:	68 c5 9a 10 c0       	push   $0xc0109ac5
c01075a1:	68 b6 02 00 00       	push   $0x2b6
c01075a6:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01075ab:	e8 40 8e ff ff       	call   c01003f0 <__panic>
    ptr=page2kva(base);
c01075b0:	83 ec 0c             	sub    $0xc,%esp
c01075b3:	ff 75 f0             	pushl  -0x10(%ebp)
c01075b6:	e8 63 e7 ff ff       	call   c0105d1e <page2kva>
c01075bb:	83 c4 10             	add    $0x10,%esp
c01075be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c01075c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01075c4:	c9                   	leave  
c01075c5:	c3                   	ret    

c01075c6 <kfree>:

void 
kfree(void *ptr, size_t n) {
c01075c6:	55                   	push   %ebp
c01075c7:	89 e5                	mov    %esp,%ebp
c01075c9:	83 ec 18             	sub    $0x18,%esp
    assert(n > 0 && n < 1024*0124);
c01075cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01075d0:	74 09                	je     c01075db <kfree+0x15>
c01075d2:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c01075d9:	76 19                	jbe    c01075f4 <kfree+0x2e>
c01075db:	68 21 a0 10 c0       	push   $0xc010a021
c01075e0:	68 c5 9a 10 c0       	push   $0xc0109ac5
c01075e5:	68 bd 02 00 00       	push   $0x2bd
c01075ea:	68 a0 9a 10 c0       	push   $0xc0109aa0
c01075ef:	e8 fc 8d ff ff       	call   c01003f0 <__panic>
    assert(ptr != NULL);
c01075f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01075f8:	75 19                	jne    c0107613 <kfree+0x4d>
c01075fa:	68 45 a0 10 c0       	push   $0xc010a045
c01075ff:	68 c5 9a 10 c0       	push   $0xc0109ac5
c0107604:	68 be 02 00 00       	push   $0x2be
c0107609:	68 a0 9a 10 c0       	push   $0xc0109aa0
c010760e:	e8 dd 8d ff ff       	call   c01003f0 <__panic>
    struct Page *base=NULL;
c0107613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c010761a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010761d:	05 ff 0f 00 00       	add    $0xfff,%eax
c0107622:	c1 e8 0c             	shr    $0xc,%eax
c0107625:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0107628:	83 ec 0c             	sub    $0xc,%esp
c010762b:	ff 75 08             	pushl  0x8(%ebp)
c010762e:	e8 30 e7 ff ff       	call   c0105d63 <kva2page>
c0107633:	83 c4 10             	add    $0x10,%esp
c0107636:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0107639:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010763c:	83 ec 08             	sub    $0x8,%esp
c010763f:	50                   	push   %eax
c0107640:	ff 75 f4             	pushl  -0xc(%ebp)
c0107643:	e8 2a ea ff ff       	call   c0106072 <free_pages>
c0107648:	83 c4 10             	add    $0x10,%esp
}
c010764b:	90                   	nop
c010764c:	c9                   	leave  
c010764d:	c3                   	ret    

c010764e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010764e:	55                   	push   %ebp
c010764f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107651:	8b 45 08             	mov    0x8(%ebp),%eax
c0107654:	8b 15 58 31 12 c0    	mov    0xc0123158,%edx
c010765a:	29 d0                	sub    %edx,%eax
c010765c:	c1 f8 05             	sar    $0x5,%eax
}
c010765f:	5d                   	pop    %ebp
c0107660:	c3                   	ret    

c0107661 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107661:	55                   	push   %ebp
c0107662:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0107664:	ff 75 08             	pushl  0x8(%ebp)
c0107667:	e8 e2 ff ff ff       	call   c010764e <page2ppn>
c010766c:	83 c4 04             	add    $0x4,%esp
c010766f:	c1 e0 0c             	shl    $0xc,%eax
}
c0107672:	c9                   	leave  
c0107673:	c3                   	ret    

c0107674 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107674:	55                   	push   %ebp
c0107675:	89 e5                	mov    %esp,%ebp
c0107677:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c010767a:	ff 75 08             	pushl  0x8(%ebp)
c010767d:	e8 df ff ff ff       	call   c0107661 <page2pa>
c0107682:	83 c4 04             	add    $0x4,%esp
c0107685:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107688:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010768b:	c1 e8 0c             	shr    $0xc,%eax
c010768e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107691:	a1 80 2f 12 c0       	mov    0xc0122f80,%eax
c0107696:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107699:	72 14                	jb     c01076af <page2kva+0x3b>
c010769b:	ff 75 f4             	pushl  -0xc(%ebp)
c010769e:	68 54 a0 10 c0       	push   $0xc010a054
c01076a3:	6a 62                	push   $0x62
c01076a5:	68 77 a0 10 c0       	push   $0xc010a077
c01076aa:	e8 41 8d ff ff       	call   c01003f0 <__panic>
c01076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01076b7:	c9                   	leave  
c01076b8:	c3                   	ret    

c01076b9 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01076b9:	55                   	push   %ebp
c01076ba:	89 e5                	mov    %esp,%ebp
c01076bc:	83 ec 08             	sub    $0x8,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01076bf:	83 ec 0c             	sub    $0xc,%esp
c01076c2:	6a 01                	push   $0x1
c01076c4:	e8 17 9a ff ff       	call   c01010e0 <ide_device_valid>
c01076c9:	83 c4 10             	add    $0x10,%esp
c01076cc:	85 c0                	test   %eax,%eax
c01076ce:	75 14                	jne    c01076e4 <swapfs_init+0x2b>
        panic("swap fs isn't available.\n");
c01076d0:	83 ec 04             	sub    $0x4,%esp
c01076d3:	68 85 a0 10 c0       	push   $0xc010a085
c01076d8:	6a 0d                	push   $0xd
c01076da:	68 9f a0 10 c0       	push   $0xc010a09f
c01076df:	e8 0c 8d ff ff       	call   c01003f0 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01076e4:	83 ec 0c             	sub    $0xc,%esp
c01076e7:	6a 01                	push   $0x1
c01076e9:	e8 32 9a ff ff       	call   c0101120 <ide_device_size>
c01076ee:	83 c4 10             	add    $0x10,%esp
c01076f1:	c1 e8 03             	shr    $0x3,%eax
c01076f4:	a3 1c 31 12 c0       	mov    %eax,0xc012311c
}
c01076f9:	90                   	nop
c01076fa:	c9                   	leave  
c01076fb:	c3                   	ret    

c01076fc <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01076fc:	55                   	push   %ebp
c01076fd:	89 e5                	mov    %esp,%ebp
c01076ff:	83 ec 18             	sub    $0x18,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107702:	83 ec 0c             	sub    $0xc,%esp
c0107705:	ff 75 0c             	pushl  0xc(%ebp)
c0107708:	e8 67 ff ff ff       	call   c0107674 <page2kva>
c010770d:	83 c4 10             	add    $0x10,%esp
c0107710:	89 c2                	mov    %eax,%edx
c0107712:	8b 45 08             	mov    0x8(%ebp),%eax
c0107715:	c1 e8 08             	shr    $0x8,%eax
c0107718:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010771b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010771f:	74 0a                	je     c010772b <swapfs_read+0x2f>
c0107721:	a1 1c 31 12 c0       	mov    0xc012311c,%eax
c0107726:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0107729:	72 14                	jb     c010773f <swapfs_read+0x43>
c010772b:	ff 75 08             	pushl  0x8(%ebp)
c010772e:	68 b0 a0 10 c0       	push   $0xc010a0b0
c0107733:	6a 14                	push   $0x14
c0107735:	68 9f a0 10 c0       	push   $0xc010a09f
c010773a:	e8 b1 8c ff ff       	call   c01003f0 <__panic>
c010773f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107742:	c1 e0 03             	shl    $0x3,%eax
c0107745:	6a 08                	push   $0x8
c0107747:	52                   	push   %edx
c0107748:	50                   	push   %eax
c0107749:	6a 01                	push   $0x1
c010774b:	e8 10 9a ff ff       	call   c0101160 <ide_read_secs>
c0107750:	83 c4 10             	add    $0x10,%esp
}
c0107753:	c9                   	leave  
c0107754:	c3                   	ret    

c0107755 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107755:	55                   	push   %ebp
c0107756:	89 e5                	mov    %esp,%ebp
c0107758:	83 ec 18             	sub    $0x18,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010775b:	83 ec 0c             	sub    $0xc,%esp
c010775e:	ff 75 0c             	pushl  0xc(%ebp)
c0107761:	e8 0e ff ff ff       	call   c0107674 <page2kva>
c0107766:	83 c4 10             	add    $0x10,%esp
c0107769:	89 c2                	mov    %eax,%edx
c010776b:	8b 45 08             	mov    0x8(%ebp),%eax
c010776e:	c1 e8 08             	shr    $0x8,%eax
c0107771:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107778:	74 0a                	je     c0107784 <swapfs_write+0x2f>
c010777a:	a1 1c 31 12 c0       	mov    0xc012311c,%eax
c010777f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0107782:	72 14                	jb     c0107798 <swapfs_write+0x43>
c0107784:	ff 75 08             	pushl  0x8(%ebp)
c0107787:	68 b0 a0 10 c0       	push   $0xc010a0b0
c010778c:	6a 19                	push   $0x19
c010778e:	68 9f a0 10 c0       	push   $0xc010a09f
c0107793:	e8 58 8c ff ff       	call   c01003f0 <__panic>
c0107798:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010779b:	c1 e0 03             	shl    $0x3,%eax
c010779e:	6a 08                	push   $0x8
c01077a0:	52                   	push   %edx
c01077a1:	50                   	push   %eax
c01077a2:	6a 01                	push   $0x1
c01077a4:	e8 e1 9b ff ff       	call   c010138a <ide_write_secs>
c01077a9:	83 c4 10             	add    $0x10,%esp
}
c01077ac:	c9                   	leave  
c01077ad:	c3                   	ret    

c01077ae <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01077ae:	55                   	push   %ebp
c01077af:	89 e5                	mov    %esp,%ebp
c01077b1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01077b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01077bb:	eb 04                	jmp    c01077c1 <strlen+0x13>
        cnt ++;
c01077bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01077c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01077c4:	8d 50 01             	lea    0x1(%eax),%edx
c01077c7:	89 55 08             	mov    %edx,0x8(%ebp)
c01077ca:	0f b6 00             	movzbl (%eax),%eax
c01077cd:	84 c0                	test   %al,%al
c01077cf:	75 ec                	jne    c01077bd <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01077d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01077d4:	c9                   	leave  
c01077d5:	c3                   	ret    

c01077d6 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01077d6:	55                   	push   %ebp
c01077d7:	89 e5                	mov    %esp,%ebp
c01077d9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01077dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01077e3:	eb 04                	jmp    c01077e9 <strnlen+0x13>
        cnt ++;
c01077e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01077e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01077ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01077ef:	73 10                	jae    c0107801 <strnlen+0x2b>
c01077f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01077f4:	8d 50 01             	lea    0x1(%eax),%edx
c01077f7:	89 55 08             	mov    %edx,0x8(%ebp)
c01077fa:	0f b6 00             	movzbl (%eax),%eax
c01077fd:	84 c0                	test   %al,%al
c01077ff:	75 e4                	jne    c01077e5 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0107801:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107804:	c9                   	leave  
c0107805:	c3                   	ret    

c0107806 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0107806:	55                   	push   %ebp
c0107807:	89 e5                	mov    %esp,%ebp
c0107809:	57                   	push   %edi
c010780a:	56                   	push   %esi
c010780b:	83 ec 20             	sub    $0x20,%esp
c010780e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107811:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107814:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107817:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010781a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010781d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107820:	89 d1                	mov    %edx,%ecx
c0107822:	89 c2                	mov    %eax,%edx
c0107824:	89 ce                	mov    %ecx,%esi
c0107826:	89 d7                	mov    %edx,%edi
c0107828:	ac                   	lods   %ds:(%esi),%al
c0107829:	aa                   	stos   %al,%es:(%edi)
c010782a:	84 c0                	test   %al,%al
c010782c:	75 fa                	jne    c0107828 <strcpy+0x22>
c010782e:	89 fa                	mov    %edi,%edx
c0107830:	89 f1                	mov    %esi,%ecx
c0107832:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0107835:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010783b:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c010783e:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010783f:	83 c4 20             	add    $0x20,%esp
c0107842:	5e                   	pop    %esi
c0107843:	5f                   	pop    %edi
c0107844:	5d                   	pop    %ebp
c0107845:	c3                   	ret    

c0107846 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0107846:	55                   	push   %ebp
c0107847:	89 e5                	mov    %esp,%ebp
c0107849:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010784c:	8b 45 08             	mov    0x8(%ebp),%eax
c010784f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0107852:	eb 21                	jmp    c0107875 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0107854:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107857:	0f b6 10             	movzbl (%eax),%edx
c010785a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010785d:	88 10                	mov    %dl,(%eax)
c010785f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107862:	0f b6 00             	movzbl (%eax),%eax
c0107865:	84 c0                	test   %al,%al
c0107867:	74 04                	je     c010786d <strncpy+0x27>
            src ++;
c0107869:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010786d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0107871:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0107875:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107879:	75 d9                	jne    c0107854 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010787b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010787e:	c9                   	leave  
c010787f:	c3                   	ret    

c0107880 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0107880:	55                   	push   %ebp
c0107881:	89 e5                	mov    %esp,%ebp
c0107883:	57                   	push   %edi
c0107884:	56                   	push   %esi
c0107885:	83 ec 20             	sub    $0x20,%esp
c0107888:	8b 45 08             	mov    0x8(%ebp),%eax
c010788b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010788e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107891:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0107894:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107897:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010789a:	89 d1                	mov    %edx,%ecx
c010789c:	89 c2                	mov    %eax,%edx
c010789e:	89 ce                	mov    %ecx,%esi
c01078a0:	89 d7                	mov    %edx,%edi
c01078a2:	ac                   	lods   %ds:(%esi),%al
c01078a3:	ae                   	scas   %es:(%edi),%al
c01078a4:	75 08                	jne    c01078ae <strcmp+0x2e>
c01078a6:	84 c0                	test   %al,%al
c01078a8:	75 f8                	jne    c01078a2 <strcmp+0x22>
c01078aa:	31 c0                	xor    %eax,%eax
c01078ac:	eb 04                	jmp    c01078b2 <strcmp+0x32>
c01078ae:	19 c0                	sbb    %eax,%eax
c01078b0:	0c 01                	or     $0x1,%al
c01078b2:	89 fa                	mov    %edi,%edx
c01078b4:	89 f1                	mov    %esi,%ecx
c01078b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01078b9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01078bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01078bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01078c2:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01078c3:	83 c4 20             	add    $0x20,%esp
c01078c6:	5e                   	pop    %esi
c01078c7:	5f                   	pop    %edi
c01078c8:	5d                   	pop    %ebp
c01078c9:	c3                   	ret    

c01078ca <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01078ca:	55                   	push   %ebp
c01078cb:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01078cd:	eb 0c                	jmp    c01078db <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01078cf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01078d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01078d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01078db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01078df:	74 1a                	je     c01078fb <strncmp+0x31>
c01078e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01078e4:	0f b6 00             	movzbl (%eax),%eax
c01078e7:	84 c0                	test   %al,%al
c01078e9:	74 10                	je     c01078fb <strncmp+0x31>
c01078eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01078ee:	0f b6 10             	movzbl (%eax),%edx
c01078f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078f4:	0f b6 00             	movzbl (%eax),%eax
c01078f7:	38 c2                	cmp    %al,%dl
c01078f9:	74 d4                	je     c01078cf <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01078fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01078ff:	74 18                	je     c0107919 <strncmp+0x4f>
c0107901:	8b 45 08             	mov    0x8(%ebp),%eax
c0107904:	0f b6 00             	movzbl (%eax),%eax
c0107907:	0f b6 d0             	movzbl %al,%edx
c010790a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010790d:	0f b6 00             	movzbl (%eax),%eax
c0107910:	0f b6 c0             	movzbl %al,%eax
c0107913:	29 c2                	sub    %eax,%edx
c0107915:	89 d0                	mov    %edx,%eax
c0107917:	eb 05                	jmp    c010791e <strncmp+0x54>
c0107919:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010791e:	5d                   	pop    %ebp
c010791f:	c3                   	ret    

c0107920 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0107920:	55                   	push   %ebp
c0107921:	89 e5                	mov    %esp,%ebp
c0107923:	83 ec 04             	sub    $0x4,%esp
c0107926:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107929:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010792c:	eb 14                	jmp    c0107942 <strchr+0x22>
        if (*s == c) {
c010792e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107931:	0f b6 00             	movzbl (%eax),%eax
c0107934:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0107937:	75 05                	jne    c010793e <strchr+0x1e>
            return (char *)s;
c0107939:	8b 45 08             	mov    0x8(%ebp),%eax
c010793c:	eb 13                	jmp    c0107951 <strchr+0x31>
        }
        s ++;
c010793e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0107942:	8b 45 08             	mov    0x8(%ebp),%eax
c0107945:	0f b6 00             	movzbl (%eax),%eax
c0107948:	84 c0                	test   %al,%al
c010794a:	75 e2                	jne    c010792e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010794c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107951:	c9                   	leave  
c0107952:	c3                   	ret    

c0107953 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0107953:	55                   	push   %ebp
c0107954:	89 e5                	mov    %esp,%ebp
c0107956:	83 ec 04             	sub    $0x4,%esp
c0107959:	8b 45 0c             	mov    0xc(%ebp),%eax
c010795c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010795f:	eb 0f                	jmp    c0107970 <strfind+0x1d>
        if (*s == c) {
c0107961:	8b 45 08             	mov    0x8(%ebp),%eax
c0107964:	0f b6 00             	movzbl (%eax),%eax
c0107967:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010796a:	74 10                	je     c010797c <strfind+0x29>
            break;
        }
        s ++;
c010796c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0107970:	8b 45 08             	mov    0x8(%ebp),%eax
c0107973:	0f b6 00             	movzbl (%eax),%eax
c0107976:	84 c0                	test   %al,%al
c0107978:	75 e7                	jne    c0107961 <strfind+0xe>
c010797a:	eb 01                	jmp    c010797d <strfind+0x2a>
        if (*s == c) {
            break;
c010797c:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c010797d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0107980:	c9                   	leave  
c0107981:	c3                   	ret    

c0107982 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0107982:	55                   	push   %ebp
c0107983:	89 e5                	mov    %esp,%ebp
c0107985:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0107988:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010798f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0107996:	eb 04                	jmp    c010799c <strtol+0x1a>
        s ++;
c0107998:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010799c:	8b 45 08             	mov    0x8(%ebp),%eax
c010799f:	0f b6 00             	movzbl (%eax),%eax
c01079a2:	3c 20                	cmp    $0x20,%al
c01079a4:	74 f2                	je     c0107998 <strtol+0x16>
c01079a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01079a9:	0f b6 00             	movzbl (%eax),%eax
c01079ac:	3c 09                	cmp    $0x9,%al
c01079ae:	74 e8                	je     c0107998 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01079b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01079b3:	0f b6 00             	movzbl (%eax),%eax
c01079b6:	3c 2b                	cmp    $0x2b,%al
c01079b8:	75 06                	jne    c01079c0 <strtol+0x3e>
        s ++;
c01079ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01079be:	eb 15                	jmp    c01079d5 <strtol+0x53>
    }
    else if (*s == '-') {
c01079c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01079c3:	0f b6 00             	movzbl (%eax),%eax
c01079c6:	3c 2d                	cmp    $0x2d,%al
c01079c8:	75 0b                	jne    c01079d5 <strtol+0x53>
        s ++, neg = 1;
c01079ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01079ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01079d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01079d9:	74 06                	je     c01079e1 <strtol+0x5f>
c01079db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01079df:	75 24                	jne    c0107a05 <strtol+0x83>
c01079e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01079e4:	0f b6 00             	movzbl (%eax),%eax
c01079e7:	3c 30                	cmp    $0x30,%al
c01079e9:	75 1a                	jne    c0107a05 <strtol+0x83>
c01079eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01079ee:	83 c0 01             	add    $0x1,%eax
c01079f1:	0f b6 00             	movzbl (%eax),%eax
c01079f4:	3c 78                	cmp    $0x78,%al
c01079f6:	75 0d                	jne    c0107a05 <strtol+0x83>
        s += 2, base = 16;
c01079f8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01079fc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0107a03:	eb 2a                	jmp    c0107a2f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0107a05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107a09:	75 17                	jne    c0107a22 <strtol+0xa0>
c0107a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a0e:	0f b6 00             	movzbl (%eax),%eax
c0107a11:	3c 30                	cmp    $0x30,%al
c0107a13:	75 0d                	jne    c0107a22 <strtol+0xa0>
        s ++, base = 8;
c0107a15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107a19:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0107a20:	eb 0d                	jmp    c0107a2f <strtol+0xad>
    }
    else if (base == 0) {
c0107a22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107a26:	75 07                	jne    c0107a2f <strtol+0xad>
        base = 10;
c0107a28:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0107a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a32:	0f b6 00             	movzbl (%eax),%eax
c0107a35:	3c 2f                	cmp    $0x2f,%al
c0107a37:	7e 1b                	jle    c0107a54 <strtol+0xd2>
c0107a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a3c:	0f b6 00             	movzbl (%eax),%eax
c0107a3f:	3c 39                	cmp    $0x39,%al
c0107a41:	7f 11                	jg     c0107a54 <strtol+0xd2>
            dig = *s - '0';
c0107a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a46:	0f b6 00             	movzbl (%eax),%eax
c0107a49:	0f be c0             	movsbl %al,%eax
c0107a4c:	83 e8 30             	sub    $0x30,%eax
c0107a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a52:	eb 48                	jmp    c0107a9c <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0107a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a57:	0f b6 00             	movzbl (%eax),%eax
c0107a5a:	3c 60                	cmp    $0x60,%al
c0107a5c:	7e 1b                	jle    c0107a79 <strtol+0xf7>
c0107a5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a61:	0f b6 00             	movzbl (%eax),%eax
c0107a64:	3c 7a                	cmp    $0x7a,%al
c0107a66:	7f 11                	jg     c0107a79 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0107a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a6b:	0f b6 00             	movzbl (%eax),%eax
c0107a6e:	0f be c0             	movsbl %al,%eax
c0107a71:	83 e8 57             	sub    $0x57,%eax
c0107a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a77:	eb 23                	jmp    c0107a9c <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0107a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a7c:	0f b6 00             	movzbl (%eax),%eax
c0107a7f:	3c 40                	cmp    $0x40,%al
c0107a81:	7e 3c                	jle    c0107abf <strtol+0x13d>
c0107a83:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a86:	0f b6 00             	movzbl (%eax),%eax
c0107a89:	3c 5a                	cmp    $0x5a,%al
c0107a8b:	7f 32                	jg     c0107abf <strtol+0x13d>
            dig = *s - 'A' + 10;
c0107a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a90:	0f b6 00             	movzbl (%eax),%eax
c0107a93:	0f be c0             	movsbl %al,%eax
c0107a96:	83 e8 37             	sub    $0x37,%eax
c0107a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0107a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a9f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107aa2:	7d 1a                	jge    c0107abe <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c0107aa4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107aa8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107aab:	0f af 45 10          	imul   0x10(%ebp),%eax
c0107aaf:	89 c2                	mov    %eax,%edx
c0107ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ab4:	01 d0                	add    %edx,%eax
c0107ab6:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0107ab9:	e9 71 ff ff ff       	jmp    c0107a2f <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0107abe:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0107abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107ac3:	74 08                	je     c0107acd <strtol+0x14b>
        *endptr = (char *) s;
c0107ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ac8:	8b 55 08             	mov    0x8(%ebp),%edx
c0107acb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0107acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107ad1:	74 07                	je     c0107ada <strtol+0x158>
c0107ad3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107ad6:	f7 d8                	neg    %eax
c0107ad8:	eb 03                	jmp    c0107add <strtol+0x15b>
c0107ada:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0107add:	c9                   	leave  
c0107ade:	c3                   	ret    

c0107adf <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0107adf:	55                   	push   %ebp
c0107ae0:	89 e5                	mov    %esp,%ebp
c0107ae2:	57                   	push   %edi
c0107ae3:	83 ec 24             	sub    $0x24,%esp
c0107ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ae9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0107aec:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0107af0:	8b 55 08             	mov    0x8(%ebp),%edx
c0107af3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0107af6:	88 45 f7             	mov    %al,-0x9(%ebp)
c0107af9:	8b 45 10             	mov    0x10(%ebp),%eax
c0107afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0107aff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107b02:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0107b06:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0107b09:	89 d7                	mov    %edx,%edi
c0107b0b:	f3 aa                	rep stos %al,%es:(%edi)
c0107b0d:	89 fa                	mov    %edi,%edx
c0107b0f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0107b12:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0107b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107b18:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0107b19:	83 c4 24             	add    $0x24,%esp
c0107b1c:	5f                   	pop    %edi
c0107b1d:	5d                   	pop    %ebp
c0107b1e:	c3                   	ret    

c0107b1f <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0107b1f:	55                   	push   %ebp
c0107b20:	89 e5                	mov    %esp,%ebp
c0107b22:	57                   	push   %edi
c0107b23:	56                   	push   %esi
c0107b24:	53                   	push   %ebx
c0107b25:	83 ec 30             	sub    $0x30,%esp
c0107b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b31:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107b34:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b37:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0107b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b3d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b40:	73 42                	jae    c0107b84 <memmove+0x65>
c0107b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b51:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0107b54:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b57:	c1 e8 02             	shr    $0x2,%eax
c0107b5a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0107b5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b62:	89 d7                	mov    %edx,%edi
c0107b64:	89 c6                	mov    %eax,%esi
c0107b66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0107b68:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107b6b:	83 e1 03             	and    $0x3,%ecx
c0107b6e:	74 02                	je     c0107b72 <memmove+0x53>
c0107b70:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107b72:	89 f0                	mov    %esi,%eax
c0107b74:	89 fa                	mov    %edi,%edx
c0107b76:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0107b79:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0107b7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0107b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0107b82:	eb 36                	jmp    c0107bba <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0107b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b87:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b8d:	01 c2                	add    %eax,%edx
c0107b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b92:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0107b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b98:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0107b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b9e:	89 c1                	mov    %eax,%ecx
c0107ba0:	89 d8                	mov    %ebx,%eax
c0107ba2:	89 d6                	mov    %edx,%esi
c0107ba4:	89 c7                	mov    %eax,%edi
c0107ba6:	fd                   	std    
c0107ba7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107ba9:	fc                   	cld    
c0107baa:	89 f8                	mov    %edi,%eax
c0107bac:	89 f2                	mov    %esi,%edx
c0107bae:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0107bb1:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0107bb4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0107bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0107bba:	83 c4 30             	add    $0x30,%esp
c0107bbd:	5b                   	pop    %ebx
c0107bbe:	5e                   	pop    %esi
c0107bbf:	5f                   	pop    %edi
c0107bc0:	5d                   	pop    %ebp
c0107bc1:	c3                   	ret    

c0107bc2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0107bc2:	55                   	push   %ebp
c0107bc3:	89 e5                	mov    %esp,%ebp
c0107bc5:	57                   	push   %edi
c0107bc6:	56                   	push   %esi
c0107bc7:	83 ec 20             	sub    $0x20,%esp
c0107bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107bd6:	8b 45 10             	mov    0x10(%ebp),%eax
c0107bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0107bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bdf:	c1 e8 02             	shr    $0x2,%eax
c0107be2:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0107be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bea:	89 d7                	mov    %edx,%edi
c0107bec:	89 c6                	mov    %eax,%esi
c0107bee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0107bf0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0107bf3:	83 e1 03             	and    $0x3,%ecx
c0107bf6:	74 02                	je     c0107bfa <memcpy+0x38>
c0107bf8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107bfa:	89 f0                	mov    %esi,%eax
c0107bfc:	89 fa                	mov    %edi,%edx
c0107bfe:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0107c01:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107c04:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0107c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0107c0a:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0107c0b:	83 c4 20             	add    $0x20,%esp
c0107c0e:	5e                   	pop    %esi
c0107c0f:	5f                   	pop    %edi
c0107c10:	5d                   	pop    %ebp
c0107c11:	c3                   	ret    

c0107c12 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0107c12:	55                   	push   %ebp
c0107c13:	89 e5                	mov    %esp,%ebp
c0107c15:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0107c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0107c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107c21:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0107c24:	eb 30                	jmp    c0107c56 <memcmp+0x44>
        if (*s1 != *s2) {
c0107c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107c29:	0f b6 10             	movzbl (%eax),%edx
c0107c2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107c2f:	0f b6 00             	movzbl (%eax),%eax
c0107c32:	38 c2                	cmp    %al,%dl
c0107c34:	74 18                	je     c0107c4e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0107c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107c39:	0f b6 00             	movzbl (%eax),%eax
c0107c3c:	0f b6 d0             	movzbl %al,%edx
c0107c3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107c42:	0f b6 00             	movzbl (%eax),%eax
c0107c45:	0f b6 c0             	movzbl %al,%eax
c0107c48:	29 c2                	sub    %eax,%edx
c0107c4a:	89 d0                	mov    %edx,%eax
c0107c4c:	eb 1a                	jmp    c0107c68 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0107c4e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0107c52:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0107c56:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c59:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107c5c:	89 55 10             	mov    %edx,0x10(%ebp)
c0107c5f:	85 c0                	test   %eax,%eax
c0107c61:	75 c3                	jne    c0107c26 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0107c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107c68:	c9                   	leave  
c0107c69:	c3                   	ret    

c0107c6a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107c6a:	55                   	push   %ebp
c0107c6b:	89 e5                	mov    %esp,%ebp
c0107c6d:	83 ec 38             	sub    $0x38,%esp
c0107c70:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c73:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107c76:	8b 45 14             	mov    0x14(%ebp),%eax
c0107c79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0107c7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107c7f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107c82:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107c85:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107c88:	8b 45 18             	mov    0x18(%ebp),%eax
c0107c8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c91:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107c94:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107c97:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107ca0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ca4:	74 1c                	je     c0107cc2 <printnum+0x58>
c0107ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ca9:	ba 00 00 00 00       	mov    $0x0,%edx
c0107cae:	f7 75 e4             	divl   -0x1c(%ebp)
c0107cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cb7:	ba 00 00 00 00       	mov    $0x0,%edx
c0107cbc:	f7 75 e4             	divl   -0x1c(%ebp)
c0107cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107cc8:	f7 75 e4             	divl   -0x1c(%ebp)
c0107ccb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107cce:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107cd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107cd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107cda:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107cdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ce0:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0107ce3:	8b 45 18             	mov    0x18(%ebp),%eax
c0107ce6:	ba 00 00 00 00       	mov    $0x0,%edx
c0107ceb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107cee:	77 41                	ja     c0107d31 <printnum+0xc7>
c0107cf0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107cf3:	72 05                	jb     c0107cfa <printnum+0x90>
c0107cf5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0107cf8:	77 37                	ja     c0107d31 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0107cfa:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107cfd:	83 e8 01             	sub    $0x1,%eax
c0107d00:	83 ec 04             	sub    $0x4,%esp
c0107d03:	ff 75 20             	pushl  0x20(%ebp)
c0107d06:	50                   	push   %eax
c0107d07:	ff 75 18             	pushl  0x18(%ebp)
c0107d0a:	ff 75 ec             	pushl  -0x14(%ebp)
c0107d0d:	ff 75 e8             	pushl  -0x18(%ebp)
c0107d10:	ff 75 0c             	pushl  0xc(%ebp)
c0107d13:	ff 75 08             	pushl  0x8(%ebp)
c0107d16:	e8 4f ff ff ff       	call   c0107c6a <printnum>
c0107d1b:	83 c4 20             	add    $0x20,%esp
c0107d1e:	eb 1b                	jmp    c0107d3b <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0107d20:	83 ec 08             	sub    $0x8,%esp
c0107d23:	ff 75 0c             	pushl  0xc(%ebp)
c0107d26:	ff 75 20             	pushl  0x20(%ebp)
c0107d29:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d2c:	ff d0                	call   *%eax
c0107d2e:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0107d31:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0107d35:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107d39:	7f e5                	jg     c0107d20 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0107d3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d3e:	05 50 a1 10 c0       	add    $0xc010a150,%eax
c0107d43:	0f b6 00             	movzbl (%eax),%eax
c0107d46:	0f be c0             	movsbl %al,%eax
c0107d49:	83 ec 08             	sub    $0x8,%esp
c0107d4c:	ff 75 0c             	pushl  0xc(%ebp)
c0107d4f:	50                   	push   %eax
c0107d50:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d53:	ff d0                	call   *%eax
c0107d55:	83 c4 10             	add    $0x10,%esp
}
c0107d58:	90                   	nop
c0107d59:	c9                   	leave  
c0107d5a:	c3                   	ret    

c0107d5b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0107d5b:	55                   	push   %ebp
c0107d5c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107d5e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107d62:	7e 14                	jle    c0107d78 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0107d64:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d67:	8b 00                	mov    (%eax),%eax
c0107d69:	8d 48 08             	lea    0x8(%eax),%ecx
c0107d6c:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d6f:	89 0a                	mov    %ecx,(%edx)
c0107d71:	8b 50 04             	mov    0x4(%eax),%edx
c0107d74:	8b 00                	mov    (%eax),%eax
c0107d76:	eb 30                	jmp    c0107da8 <getuint+0x4d>
    }
    else if (lflag) {
c0107d78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107d7c:	74 16                	je     c0107d94 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0107d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d81:	8b 00                	mov    (%eax),%eax
c0107d83:	8d 48 04             	lea    0x4(%eax),%ecx
c0107d86:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d89:	89 0a                	mov    %ecx,(%edx)
c0107d8b:	8b 00                	mov    (%eax),%eax
c0107d8d:	ba 00 00 00 00       	mov    $0x0,%edx
c0107d92:	eb 14                	jmp    c0107da8 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0107d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d97:	8b 00                	mov    (%eax),%eax
c0107d99:	8d 48 04             	lea    0x4(%eax),%ecx
c0107d9c:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d9f:	89 0a                	mov    %ecx,(%edx)
c0107da1:	8b 00                	mov    (%eax),%eax
c0107da3:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0107da8:	5d                   	pop    %ebp
c0107da9:	c3                   	ret    

c0107daa <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0107daa:	55                   	push   %ebp
c0107dab:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107dad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107db1:	7e 14                	jle    c0107dc7 <getint+0x1d>
        return va_arg(*ap, long long);
c0107db3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107db6:	8b 00                	mov    (%eax),%eax
c0107db8:	8d 48 08             	lea    0x8(%eax),%ecx
c0107dbb:	8b 55 08             	mov    0x8(%ebp),%edx
c0107dbe:	89 0a                	mov    %ecx,(%edx)
c0107dc0:	8b 50 04             	mov    0x4(%eax),%edx
c0107dc3:	8b 00                	mov    (%eax),%eax
c0107dc5:	eb 28                	jmp    c0107def <getint+0x45>
    }
    else if (lflag) {
c0107dc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107dcb:	74 12                	je     c0107ddf <getint+0x35>
        return va_arg(*ap, long);
c0107dcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dd0:	8b 00                	mov    (%eax),%eax
c0107dd2:	8d 48 04             	lea    0x4(%eax),%ecx
c0107dd5:	8b 55 08             	mov    0x8(%ebp),%edx
c0107dd8:	89 0a                	mov    %ecx,(%edx)
c0107dda:	8b 00                	mov    (%eax),%eax
c0107ddc:	99                   	cltd   
c0107ddd:	eb 10                	jmp    c0107def <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0107ddf:	8b 45 08             	mov    0x8(%ebp),%eax
c0107de2:	8b 00                	mov    (%eax),%eax
c0107de4:	8d 48 04             	lea    0x4(%eax),%ecx
c0107de7:	8b 55 08             	mov    0x8(%ebp),%edx
c0107dea:	89 0a                	mov    %ecx,(%edx)
c0107dec:	8b 00                	mov    (%eax),%eax
c0107dee:	99                   	cltd   
    }
}
c0107def:	5d                   	pop    %ebp
c0107df0:	c3                   	ret    

c0107df1 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0107df1:	55                   	push   %ebp
c0107df2:	89 e5                	mov    %esp,%ebp
c0107df4:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c0107df7:	8d 45 14             	lea    0x14(%ebp),%eax
c0107dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0107dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e00:	50                   	push   %eax
c0107e01:	ff 75 10             	pushl  0x10(%ebp)
c0107e04:	ff 75 0c             	pushl  0xc(%ebp)
c0107e07:	ff 75 08             	pushl  0x8(%ebp)
c0107e0a:	e8 06 00 00 00       	call   c0107e15 <vprintfmt>
c0107e0f:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0107e12:	90                   	nop
c0107e13:	c9                   	leave  
c0107e14:	c3                   	ret    

c0107e15 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0107e15:	55                   	push   %ebp
c0107e16:	89 e5                	mov    %esp,%ebp
c0107e18:	56                   	push   %esi
c0107e19:	53                   	push   %ebx
c0107e1a:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0107e1d:	eb 17                	jmp    c0107e36 <vprintfmt+0x21>
            if (ch == '\0') {
c0107e1f:	85 db                	test   %ebx,%ebx
c0107e21:	0f 84 8e 03 00 00    	je     c01081b5 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c0107e27:	83 ec 08             	sub    $0x8,%esp
c0107e2a:	ff 75 0c             	pushl  0xc(%ebp)
c0107e2d:	53                   	push   %ebx
c0107e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e31:	ff d0                	call   *%eax
c0107e33:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0107e36:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e39:	8d 50 01             	lea    0x1(%eax),%edx
c0107e3c:	89 55 10             	mov    %edx,0x10(%ebp)
c0107e3f:	0f b6 00             	movzbl (%eax),%eax
c0107e42:	0f b6 d8             	movzbl %al,%ebx
c0107e45:	83 fb 25             	cmp    $0x25,%ebx
c0107e48:	75 d5                	jne    c0107e1f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0107e4a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0107e4e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0107e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e58:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0107e5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0107e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107e65:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0107e68:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e6b:	8d 50 01             	lea    0x1(%eax),%edx
c0107e6e:	89 55 10             	mov    %edx,0x10(%ebp)
c0107e71:	0f b6 00             	movzbl (%eax),%eax
c0107e74:	0f b6 d8             	movzbl %al,%ebx
c0107e77:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0107e7a:	83 f8 55             	cmp    $0x55,%eax
c0107e7d:	0f 87 05 03 00 00    	ja     c0108188 <vprintfmt+0x373>
c0107e83:	8b 04 85 74 a1 10 c0 	mov    -0x3fef5e8c(,%eax,4),%eax
c0107e8a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0107e8c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0107e90:	eb d6                	jmp    c0107e68 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0107e92:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0107e96:	eb d0                	jmp    c0107e68 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0107e98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0107e9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107ea2:	89 d0                	mov    %edx,%eax
c0107ea4:	c1 e0 02             	shl    $0x2,%eax
c0107ea7:	01 d0                	add    %edx,%eax
c0107ea9:	01 c0                	add    %eax,%eax
c0107eab:	01 d8                	add    %ebx,%eax
c0107ead:	83 e8 30             	sub    $0x30,%eax
c0107eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0107eb3:	8b 45 10             	mov    0x10(%ebp),%eax
c0107eb6:	0f b6 00             	movzbl (%eax),%eax
c0107eb9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0107ebc:	83 fb 2f             	cmp    $0x2f,%ebx
c0107ebf:	7e 39                	jle    c0107efa <vprintfmt+0xe5>
c0107ec1:	83 fb 39             	cmp    $0x39,%ebx
c0107ec4:	7f 34                	jg     c0107efa <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0107ec6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0107eca:	eb d3                	jmp    c0107e9f <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0107ecc:	8b 45 14             	mov    0x14(%ebp),%eax
c0107ecf:	8d 50 04             	lea    0x4(%eax),%edx
c0107ed2:	89 55 14             	mov    %edx,0x14(%ebp)
c0107ed5:	8b 00                	mov    (%eax),%eax
c0107ed7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0107eda:	eb 1f                	jmp    c0107efb <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0107edc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107ee0:	79 86                	jns    c0107e68 <vprintfmt+0x53>
                width = 0;
c0107ee2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0107ee9:	e9 7a ff ff ff       	jmp    c0107e68 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0107eee:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0107ef5:	e9 6e ff ff ff       	jmp    c0107e68 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0107efa:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0107efb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107eff:	0f 89 63 ff ff ff    	jns    c0107e68 <vprintfmt+0x53>
                width = precision, precision = -1;
c0107f05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f08:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f0b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0107f12:	e9 51 ff ff ff       	jmp    c0107e68 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0107f17:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0107f1b:	e9 48 ff ff ff       	jmp    c0107e68 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0107f20:	8b 45 14             	mov    0x14(%ebp),%eax
c0107f23:	8d 50 04             	lea    0x4(%eax),%edx
c0107f26:	89 55 14             	mov    %edx,0x14(%ebp)
c0107f29:	8b 00                	mov    (%eax),%eax
c0107f2b:	83 ec 08             	sub    $0x8,%esp
c0107f2e:	ff 75 0c             	pushl  0xc(%ebp)
c0107f31:	50                   	push   %eax
c0107f32:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f35:	ff d0                	call   *%eax
c0107f37:	83 c4 10             	add    $0x10,%esp
            break;
c0107f3a:	e9 71 02 00 00       	jmp    c01081b0 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0107f3f:	8b 45 14             	mov    0x14(%ebp),%eax
c0107f42:	8d 50 04             	lea    0x4(%eax),%edx
c0107f45:	89 55 14             	mov    %edx,0x14(%ebp)
c0107f48:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0107f4a:	85 db                	test   %ebx,%ebx
c0107f4c:	79 02                	jns    c0107f50 <vprintfmt+0x13b>
                err = -err;
c0107f4e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0107f50:	83 fb 06             	cmp    $0x6,%ebx
c0107f53:	7f 0b                	jg     c0107f60 <vprintfmt+0x14b>
c0107f55:	8b 34 9d 34 a1 10 c0 	mov    -0x3fef5ecc(,%ebx,4),%esi
c0107f5c:	85 f6                	test   %esi,%esi
c0107f5e:	75 19                	jne    c0107f79 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0107f60:	53                   	push   %ebx
c0107f61:	68 61 a1 10 c0       	push   $0xc010a161
c0107f66:	ff 75 0c             	pushl  0xc(%ebp)
c0107f69:	ff 75 08             	pushl  0x8(%ebp)
c0107f6c:	e8 80 fe ff ff       	call   c0107df1 <printfmt>
c0107f71:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0107f74:	e9 37 02 00 00       	jmp    c01081b0 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0107f79:	56                   	push   %esi
c0107f7a:	68 6a a1 10 c0       	push   $0xc010a16a
c0107f7f:	ff 75 0c             	pushl  0xc(%ebp)
c0107f82:	ff 75 08             	pushl  0x8(%ebp)
c0107f85:	e8 67 fe ff ff       	call   c0107df1 <printfmt>
c0107f8a:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0107f8d:	e9 1e 02 00 00       	jmp    c01081b0 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0107f92:	8b 45 14             	mov    0x14(%ebp),%eax
c0107f95:	8d 50 04             	lea    0x4(%eax),%edx
c0107f98:	89 55 14             	mov    %edx,0x14(%ebp)
c0107f9b:	8b 30                	mov    (%eax),%esi
c0107f9d:	85 f6                	test   %esi,%esi
c0107f9f:	75 05                	jne    c0107fa6 <vprintfmt+0x191>
                p = "(null)";
c0107fa1:	be 6d a1 10 c0       	mov    $0xc010a16d,%esi
            }
            if (width > 0 && padc != '-') {
c0107fa6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107faa:	7e 76                	jle    c0108022 <vprintfmt+0x20d>
c0107fac:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0107fb0:	74 70                	je     c0108022 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0107fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107fb5:	83 ec 08             	sub    $0x8,%esp
c0107fb8:	50                   	push   %eax
c0107fb9:	56                   	push   %esi
c0107fba:	e8 17 f8 ff ff       	call   c01077d6 <strnlen>
c0107fbf:	83 c4 10             	add    $0x10,%esp
c0107fc2:	89 c2                	mov    %eax,%edx
c0107fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fc7:	29 d0                	sub    %edx,%eax
c0107fc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107fcc:	eb 17                	jmp    c0107fe5 <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0107fce:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0107fd2:	83 ec 08             	sub    $0x8,%esp
c0107fd5:	ff 75 0c             	pushl  0xc(%ebp)
c0107fd8:	50                   	push   %eax
c0107fd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fdc:	ff d0                	call   *%eax
c0107fde:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0107fe1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0107fe5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107fe9:	7f e3                	jg     c0107fce <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0107feb:	eb 35                	jmp    c0108022 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0107fed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107ff1:	74 1c                	je     c010800f <vprintfmt+0x1fa>
c0107ff3:	83 fb 1f             	cmp    $0x1f,%ebx
c0107ff6:	7e 05                	jle    c0107ffd <vprintfmt+0x1e8>
c0107ff8:	83 fb 7e             	cmp    $0x7e,%ebx
c0107ffb:	7e 12                	jle    c010800f <vprintfmt+0x1fa>
                    putch('?', putdat);
c0107ffd:	83 ec 08             	sub    $0x8,%esp
c0108000:	ff 75 0c             	pushl  0xc(%ebp)
c0108003:	6a 3f                	push   $0x3f
c0108005:	8b 45 08             	mov    0x8(%ebp),%eax
c0108008:	ff d0                	call   *%eax
c010800a:	83 c4 10             	add    $0x10,%esp
c010800d:	eb 0f                	jmp    c010801e <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c010800f:	83 ec 08             	sub    $0x8,%esp
c0108012:	ff 75 0c             	pushl  0xc(%ebp)
c0108015:	53                   	push   %ebx
c0108016:	8b 45 08             	mov    0x8(%ebp),%eax
c0108019:	ff d0                	call   *%eax
c010801b:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010801e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108022:	89 f0                	mov    %esi,%eax
c0108024:	8d 70 01             	lea    0x1(%eax),%esi
c0108027:	0f b6 00             	movzbl (%eax),%eax
c010802a:	0f be d8             	movsbl %al,%ebx
c010802d:	85 db                	test   %ebx,%ebx
c010802f:	74 26                	je     c0108057 <vprintfmt+0x242>
c0108031:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108035:	78 b6                	js     c0107fed <vprintfmt+0x1d8>
c0108037:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010803b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010803f:	79 ac                	jns    c0107fed <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108041:	eb 14                	jmp    c0108057 <vprintfmt+0x242>
                putch(' ', putdat);
c0108043:	83 ec 08             	sub    $0x8,%esp
c0108046:	ff 75 0c             	pushl  0xc(%ebp)
c0108049:	6a 20                	push   $0x20
c010804b:	8b 45 08             	mov    0x8(%ebp),%eax
c010804e:	ff d0                	call   *%eax
c0108050:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108053:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108057:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010805b:	7f e6                	jg     c0108043 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c010805d:	e9 4e 01 00 00       	jmp    c01081b0 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108062:	83 ec 08             	sub    $0x8,%esp
c0108065:	ff 75 e0             	pushl  -0x20(%ebp)
c0108068:	8d 45 14             	lea    0x14(%ebp),%eax
c010806b:	50                   	push   %eax
c010806c:	e8 39 fd ff ff       	call   c0107daa <getint>
c0108071:	83 c4 10             	add    $0x10,%esp
c0108074:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108077:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010807a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010807d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108080:	85 d2                	test   %edx,%edx
c0108082:	79 23                	jns    c01080a7 <vprintfmt+0x292>
                putch('-', putdat);
c0108084:	83 ec 08             	sub    $0x8,%esp
c0108087:	ff 75 0c             	pushl  0xc(%ebp)
c010808a:	6a 2d                	push   $0x2d
c010808c:	8b 45 08             	mov    0x8(%ebp),%eax
c010808f:	ff d0                	call   *%eax
c0108091:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0108094:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108097:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010809a:	f7 d8                	neg    %eax
c010809c:	83 d2 00             	adc    $0x0,%edx
c010809f:	f7 da                	neg    %edx
c01080a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01080a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01080ae:	e9 9f 00 00 00       	jmp    c0108152 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01080b3:	83 ec 08             	sub    $0x8,%esp
c01080b6:	ff 75 e0             	pushl  -0x20(%ebp)
c01080b9:	8d 45 14             	lea    0x14(%ebp),%eax
c01080bc:	50                   	push   %eax
c01080bd:	e8 99 fc ff ff       	call   c0107d5b <getuint>
c01080c2:	83 c4 10             	add    $0x10,%esp
c01080c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01080cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01080d2:	eb 7e                	jmp    c0108152 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01080d4:	83 ec 08             	sub    $0x8,%esp
c01080d7:	ff 75 e0             	pushl  -0x20(%ebp)
c01080da:	8d 45 14             	lea    0x14(%ebp),%eax
c01080dd:	50                   	push   %eax
c01080de:	e8 78 fc ff ff       	call   c0107d5b <getuint>
c01080e3:	83 c4 10             	add    $0x10,%esp
c01080e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01080ec:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01080f3:	eb 5d                	jmp    c0108152 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c01080f5:	83 ec 08             	sub    $0x8,%esp
c01080f8:	ff 75 0c             	pushl  0xc(%ebp)
c01080fb:	6a 30                	push   $0x30
c01080fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108100:	ff d0                	call   *%eax
c0108102:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0108105:	83 ec 08             	sub    $0x8,%esp
c0108108:	ff 75 0c             	pushl  0xc(%ebp)
c010810b:	6a 78                	push   $0x78
c010810d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108110:	ff d0                	call   *%eax
c0108112:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108115:	8b 45 14             	mov    0x14(%ebp),%eax
c0108118:	8d 50 04             	lea    0x4(%eax),%edx
c010811b:	89 55 14             	mov    %edx,0x14(%ebp)
c010811e:	8b 00                	mov    (%eax),%eax
c0108120:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010812a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108131:	eb 1f                	jmp    c0108152 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108133:	83 ec 08             	sub    $0x8,%esp
c0108136:	ff 75 e0             	pushl  -0x20(%ebp)
c0108139:	8d 45 14             	lea    0x14(%ebp),%eax
c010813c:	50                   	push   %eax
c010813d:	e8 19 fc ff ff       	call   c0107d5b <getuint>
c0108142:	83 c4 10             	add    $0x10,%esp
c0108145:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108148:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010814b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108152:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108156:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108159:	83 ec 04             	sub    $0x4,%esp
c010815c:	52                   	push   %edx
c010815d:	ff 75 e8             	pushl  -0x18(%ebp)
c0108160:	50                   	push   %eax
c0108161:	ff 75 f4             	pushl  -0xc(%ebp)
c0108164:	ff 75 f0             	pushl  -0x10(%ebp)
c0108167:	ff 75 0c             	pushl  0xc(%ebp)
c010816a:	ff 75 08             	pushl  0x8(%ebp)
c010816d:	e8 f8 fa ff ff       	call   c0107c6a <printnum>
c0108172:	83 c4 20             	add    $0x20,%esp
            break;
c0108175:	eb 39                	jmp    c01081b0 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108177:	83 ec 08             	sub    $0x8,%esp
c010817a:	ff 75 0c             	pushl  0xc(%ebp)
c010817d:	53                   	push   %ebx
c010817e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108181:	ff d0                	call   *%eax
c0108183:	83 c4 10             	add    $0x10,%esp
            break;
c0108186:	eb 28                	jmp    c01081b0 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108188:	83 ec 08             	sub    $0x8,%esp
c010818b:	ff 75 0c             	pushl  0xc(%ebp)
c010818e:	6a 25                	push   $0x25
c0108190:	8b 45 08             	mov    0x8(%ebp),%eax
c0108193:	ff d0                	call   *%eax
c0108195:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108198:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010819c:	eb 04                	jmp    c01081a2 <vprintfmt+0x38d>
c010819e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01081a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01081a5:	83 e8 01             	sub    $0x1,%eax
c01081a8:	0f b6 00             	movzbl (%eax),%eax
c01081ab:	3c 25                	cmp    $0x25,%al
c01081ad:	75 ef                	jne    c010819e <vprintfmt+0x389>
                /* do nothing */;
            break;
c01081af:	90                   	nop
        }
    }
c01081b0:	e9 68 fc ff ff       	jmp    c0107e1d <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c01081b5:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01081b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01081b9:	5b                   	pop    %ebx
c01081ba:	5e                   	pop    %esi
c01081bb:	5d                   	pop    %ebp
c01081bc:	c3                   	ret    

c01081bd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01081bd:	55                   	push   %ebp
c01081be:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01081c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081c3:	8b 40 08             	mov    0x8(%eax),%eax
c01081c6:	8d 50 01             	lea    0x1(%eax),%edx
c01081c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081cc:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01081cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081d2:	8b 10                	mov    (%eax),%edx
c01081d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081d7:	8b 40 04             	mov    0x4(%eax),%eax
c01081da:	39 c2                	cmp    %eax,%edx
c01081dc:	73 12                	jae    c01081f0 <sprintputch+0x33>
        *b->buf ++ = ch;
c01081de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081e1:	8b 00                	mov    (%eax),%eax
c01081e3:	8d 48 01             	lea    0x1(%eax),%ecx
c01081e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01081e9:	89 0a                	mov    %ecx,(%edx)
c01081eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01081ee:	88 10                	mov    %dl,(%eax)
    }
}
c01081f0:	90                   	nop
c01081f1:	5d                   	pop    %ebp
c01081f2:	c3                   	ret    

c01081f3 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01081f3:	55                   	push   %ebp
c01081f4:	89 e5                	mov    %esp,%ebp
c01081f6:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01081f9:	8d 45 14             	lea    0x14(%ebp),%eax
c01081fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01081ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108202:	50                   	push   %eax
c0108203:	ff 75 10             	pushl  0x10(%ebp)
c0108206:	ff 75 0c             	pushl  0xc(%ebp)
c0108209:	ff 75 08             	pushl  0x8(%ebp)
c010820c:	e8 0b 00 00 00       	call   c010821c <vsnprintf>
c0108211:	83 c4 10             	add    $0x10,%esp
c0108214:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108217:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010821a:	c9                   	leave  
c010821b:	c3                   	ret    

c010821c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010821c:	55                   	push   %ebp
c010821d:	89 e5                	mov    %esp,%ebp
c010821f:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108222:	8b 45 08             	mov    0x8(%ebp),%eax
c0108225:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108228:	8b 45 0c             	mov    0xc(%ebp),%eax
c010822b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010822e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108231:	01 d0                	add    %edx,%eax
c0108233:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108236:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010823d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108241:	74 0a                	je     c010824d <vsnprintf+0x31>
c0108243:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108246:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108249:	39 c2                	cmp    %eax,%edx
c010824b:	76 07                	jbe    c0108254 <vsnprintf+0x38>
        return -E_INVAL;
c010824d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108252:	eb 20                	jmp    c0108274 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108254:	ff 75 14             	pushl  0x14(%ebp)
c0108257:	ff 75 10             	pushl  0x10(%ebp)
c010825a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010825d:	50                   	push   %eax
c010825e:	68 bd 81 10 c0       	push   $0xc01081bd
c0108263:	e8 ad fb ff ff       	call   c0107e15 <vprintfmt>
c0108268:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c010826b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010826e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108271:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108274:	c9                   	leave  
c0108275:	c3                   	ret    

c0108276 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108276:	55                   	push   %ebp
c0108277:	89 e5                	mov    %esp,%ebp
c0108279:	57                   	push   %edi
c010827a:	56                   	push   %esi
c010827b:	53                   	push   %ebx
c010827c:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010827f:	a1 58 fa 11 c0       	mov    0xc011fa58,%eax
c0108284:	8b 15 5c fa 11 c0    	mov    0xc011fa5c,%edx
c010828a:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108290:	6b f0 05             	imul   $0x5,%eax,%esi
c0108293:	01 fe                	add    %edi,%esi
c0108295:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c010829a:	f7 e7                	mul    %edi
c010829c:	01 d6                	add    %edx,%esi
c010829e:	89 f2                	mov    %esi,%edx
c01082a0:	83 c0 0b             	add    $0xb,%eax
c01082a3:	83 d2 00             	adc    $0x0,%edx
c01082a6:	89 c7                	mov    %eax,%edi
c01082a8:	83 e7 ff             	and    $0xffffffff,%edi
c01082ab:	89 f9                	mov    %edi,%ecx
c01082ad:	0f b7 da             	movzwl %dx,%ebx
c01082b0:	89 0d 58 fa 11 c0    	mov    %ecx,0xc011fa58
c01082b6:	89 1d 5c fa 11 c0    	mov    %ebx,0xc011fa5c
    unsigned long long result = (next >> 12);
c01082bc:	a1 58 fa 11 c0       	mov    0xc011fa58,%eax
c01082c1:	8b 15 5c fa 11 c0    	mov    0xc011fa5c,%edx
c01082c7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01082cb:	c1 ea 0c             	shr    $0xc,%edx
c01082ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01082d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01082d4:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01082db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01082e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01082e4:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01082e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01082ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01082ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082f1:	74 1c                	je     c010830f <rand+0x99>
c01082f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01082f6:	ba 00 00 00 00       	mov    $0x0,%edx
c01082fb:	f7 75 dc             	divl   -0x24(%ebp)
c01082fe:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108301:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108304:	ba 00 00 00 00       	mov    $0x0,%edx
c0108309:	f7 75 dc             	divl   -0x24(%ebp)
c010830c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010830f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108312:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108315:	f7 75 dc             	divl   -0x24(%ebp)
c0108318:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010831b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010831e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108321:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108324:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108327:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010832a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010832d:	83 c4 24             	add    $0x24,%esp
c0108330:	5b                   	pop    %ebx
c0108331:	5e                   	pop    %esi
c0108332:	5f                   	pop    %edi
c0108333:	5d                   	pop    %ebp
c0108334:	c3                   	ret    

c0108335 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108335:	55                   	push   %ebp
c0108336:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108338:	8b 45 08             	mov    0x8(%ebp),%eax
c010833b:	ba 00 00 00 00       	mov    $0x0,%edx
c0108340:	a3 58 fa 11 c0       	mov    %eax,0xc011fa58
c0108345:	89 15 5c fa 11 c0    	mov    %edx,0xc011fa5c
}
c010834b:	90                   	nop
c010834c:	5d                   	pop    %ebp
c010834d:	c3                   	ret    
