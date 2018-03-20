
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba c8 89 11 c0       	mov    $0xc01189c8,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 7a 11 c0       	push   $0xc0117a36
c0100049:	e8 04 52 00 00       	call   c0105252 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 6a 15 00 00       	call   c01015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 00 5a 10 c0 	movl   $0xc0105a00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 1c 5a 10 c0       	push   $0xc0105a1c
c0100068:	e8 02 02 00 00       	call   c010026f <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 84 08 00 00       	call   c01008f9 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 a4 31 00 00       	call   c0103223 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 ae 16 00 00       	call   c0101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 0f 18 00 00       	call   c0101898 <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 d9 0c 00 00       	call   c0100d67 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 dc 17 00 00       	call   c010186f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100093:	eb fe                	jmp    c0100093 <kern_init+0x69>

c0100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c0100095:	55                   	push   %ebp
c0100096:	89 e5                	mov    %esp,%ebp
c0100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c010009b:	83 ec 04             	sub    $0x4,%esp
c010009e:	6a 00                	push   $0x0
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e8 ac 0c 00 00       	call   c0100d55 <mon_backtrace>
c01000a9:	83 c4 10             	add    $0x10,%esp
}
c01000ac:	90                   	nop
c01000ad:	c9                   	leave  
c01000ae:	c3                   	ret    

c01000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	53                   	push   %ebx
c01000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c2:	51                   	push   %ecx
c01000c3:	52                   	push   %edx
c01000c4:	53                   	push   %ebx
c01000c5:	50                   	push   %eax
c01000c6:	e8 ca ff ff ff       	call   c0100095 <grade_backtrace2>
c01000cb:	83 c4 10             	add    $0x10,%esp
}
c01000ce:	90                   	nop
c01000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d4:	55                   	push   %ebp
c01000d5:	89 e5                	mov    %esp,%ebp
c01000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000da:	83 ec 08             	sub    $0x8,%esp
c01000dd:	ff 75 10             	pushl  0x10(%ebp)
c01000e0:	ff 75 08             	pushl  0x8(%ebp)
c01000e3:	e8 c7 ff ff ff       	call   c01000af <grade_backtrace1>
c01000e8:	83 c4 10             	add    $0x10,%esp
}
c01000eb:	90                   	nop
c01000ec:	c9                   	leave  
c01000ed:	c3                   	ret    

c01000ee <grade_backtrace>:

void
grade_backtrace(void) {
c01000ee:	55                   	push   %ebp
c01000ef:	89 e5                	mov    %esp,%ebp
c01000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000f9:	83 ec 04             	sub    $0x4,%esp
c01000fc:	68 00 00 ff ff       	push   $0xffff0000
c0100101:	50                   	push   %eax
c0100102:	6a 00                	push   $0x0
c0100104:	e8 cb ff ff ff       	call   c01000d4 <grade_backtrace0>
c0100109:	83 c4 10             	add    $0x10,%esp
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100125:	0f b7 c0             	movzwl %ax,%eax
c0100128:	83 e0 03             	and    $0x3,%eax
c010012b:	89 c2                	mov    %eax,%edx
c010012d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100132:	83 ec 04             	sub    $0x4,%esp
c0100135:	52                   	push   %edx
c0100136:	50                   	push   %eax
c0100137:	68 21 5a 10 c0       	push   $0xc0105a21
c010013c:	e8 2e 01 00 00       	call   c010026f <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 2f 5a 10 c0       	push   $0xc0105a2f
c010015a:	e8 10 01 00 00       	call   c010026f <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 3d 5a 10 c0       	push   $0xc0105a3d
c0100178:	e8 f2 00 00 00       	call   c010026f <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 4b 5a 10 c0       	push   $0xc0105a4b
c0100196:	e8 d4 00 00 00       	call   c010026f <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 59 5a 10 c0       	push   $0xc0105a59
c01001b4:	e8 b6 00 00 00       	call   c010026f <cprintf>
c01001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001bc:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001c1:	83 c0 01             	add    $0x1,%eax
c01001c4:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001c9:	90                   	nop
c01001ca:	c9                   	leave  
c01001cb:	c3                   	ret    

c01001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001cc:	55                   	push   %ebp
c01001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    // "movl %%ebp, %%esp" esure that before ret, esp = ebp -> old ebp
    asm volatile (
c01001cf:	cd 78                	int    $0x78
c01001d1:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c01001d3:	90                   	nop
c01001d4:	5d                   	pop    %ebp
c01001d5:	c3                   	ret    

c01001d6 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d6:	55                   	push   %ebp
c01001d7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    // cprintf("in lab1_switch_to_kernel\n");
    asm volatile (
c01001d9:	cd 79                	int    $0x79
c01001db:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
        : 
	    : "i"(T_SWITCH_TOK)
	);
}
c01001dd:	90                   	nop
c01001de:	5d                   	pop    %ebp
c01001df:	c3                   	ret    

c01001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001e0:	55                   	push   %ebp
c01001e1:	89 e5                	mov    %esp,%ebp
c01001e3:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001e6:	e8 24 ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001eb:	83 ec 0c             	sub    $0xc,%esp
c01001ee:	68 68 5a 10 c0       	push   $0xc0105a68
c01001f3:	e8 77 00 00 00       	call   c010026f <cprintf>
c01001f8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001fb:	e8 cc ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100200:	e8 0a ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100205:	83 ec 0c             	sub    $0xc,%esp
c0100208:	68 88 5a 10 c0       	push   $0xc0105a88
c010020d:	e8 5d 00 00 00       	call   c010026f <cprintf>
c0100212:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100215:	e8 bc ff ff ff       	call   c01001d6 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010021a:	e8 f0 fe ff ff       	call   c010010f <lab1_print_cur_status>
}
c010021f:	90                   	nop
c0100220:	c9                   	leave  
c0100221:	c3                   	ret    

c0100222 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100222:	55                   	push   %ebp
c0100223:	89 e5                	mov    %esp,%ebp
c0100225:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100228:	83 ec 0c             	sub    $0xc,%esp
c010022b:	ff 75 08             	pushl  0x8(%ebp)
c010022e:	e8 be 13 00 00       	call   c01015f1 <cons_putc>
c0100233:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c0100236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100239:	8b 00                	mov    (%eax),%eax
c010023b:	8d 50 01             	lea    0x1(%eax),%edx
c010023e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100241:	89 10                	mov    %edx,(%eax)
}
c0100243:	90                   	nop
c0100244:	c9                   	leave  
c0100245:	c3                   	ret    

c0100246 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100246:	55                   	push   %ebp
c0100247:	89 e5                	mov    %esp,%ebp
c0100249:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c010024c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100253:	ff 75 0c             	pushl  0xc(%ebp)
c0100256:	ff 75 08             	pushl  0x8(%ebp)
c0100259:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010025c:	50                   	push   %eax
c010025d:	68 22 02 10 c0       	push   $0xc0100222
c0100262:	e8 21 53 00 00       	call   c0105588 <vprintfmt>
c0100267:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010026a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010026d:	c9                   	leave  
c010026e:	c3                   	ret    

c010026f <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010026f:	55                   	push   %ebp
c0100270:	89 e5                	mov    %esp,%ebp
c0100272:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100275:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100278:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010027b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010027e:	83 ec 08             	sub    $0x8,%esp
c0100281:	50                   	push   %eax
c0100282:	ff 75 08             	pushl  0x8(%ebp)
c0100285:	e8 bc ff ff ff       	call   c0100246 <vcprintf>
c010028a:	83 c4 10             	add    $0x10,%esp
c010028d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100290:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100293:	c9                   	leave  
c0100294:	c3                   	ret    

c0100295 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100295:	55                   	push   %ebp
c0100296:	89 e5                	mov    %esp,%ebp
c0100298:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c010029b:	83 ec 0c             	sub    $0xc,%esp
c010029e:	ff 75 08             	pushl  0x8(%ebp)
c01002a1:	e8 4b 13 00 00       	call   c01015f1 <cons_putc>
c01002a6:	83 c4 10             	add    $0x10,%esp
}
c01002a9:	90                   	nop
c01002aa:	c9                   	leave  
c01002ab:	c3                   	ret    

c01002ac <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002ac:	55                   	push   %ebp
c01002ad:	89 e5                	mov    %esp,%ebp
c01002af:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b9:	eb 14                	jmp    c01002cf <cputs+0x23>
        cputch(c, &cnt);
c01002bb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002bf:	83 ec 08             	sub    $0x8,%esp
c01002c2:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002c5:	52                   	push   %edx
c01002c6:	50                   	push   %eax
c01002c7:	e8 56 ff ff ff       	call   c0100222 <cputch>
c01002cc:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d2:	8d 50 01             	lea    0x1(%eax),%edx
c01002d5:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d8:	0f b6 00             	movzbl (%eax),%eax
c01002db:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002de:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002e2:	75 d7                	jne    c01002bb <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002e4:	83 ec 08             	sub    $0x8,%esp
c01002e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002ea:	50                   	push   %eax
c01002eb:	6a 0a                	push   $0xa
c01002ed:	e8 30 ff ff ff       	call   c0100222 <cputch>
c01002f2:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f8:	c9                   	leave  
c01002f9:	c3                   	ret    

c01002fa <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002fa:	55                   	push   %ebp
c01002fb:	89 e5                	mov    %esp,%ebp
c01002fd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100300:	e8 35 13 00 00       	call   c010163a <cons_getc>
c0100305:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010030c:	74 f2                	je     c0100300 <getchar+0x6>
        /* do nothing */;
    return c;
c010030e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100311:	c9                   	leave  
c0100312:	c3                   	ret    

c0100313 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100313:	55                   	push   %ebp
c0100314:	89 e5                	mov    %esp,%ebp
c0100316:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010031d:	74 13                	je     c0100332 <readline+0x1f>
        cprintf("%s", prompt);
c010031f:	83 ec 08             	sub    $0x8,%esp
c0100322:	ff 75 08             	pushl  0x8(%ebp)
c0100325:	68 a7 5a 10 c0       	push   $0xc0105aa7
c010032a:	e8 40 ff ff ff       	call   c010026f <cprintf>
c010032f:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100339:	e8 bc ff ff ff       	call   c01002fa <getchar>
c010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100345:	79 0a                	jns    c0100351 <readline+0x3e>
            return NULL;
c0100347:	b8 00 00 00 00       	mov    $0x0,%eax
c010034c:	e9 82 00 00 00       	jmp    c01003d3 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100351:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100355:	7e 2b                	jle    c0100382 <readline+0x6f>
c0100357:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010035e:	7f 22                	jg     c0100382 <readline+0x6f>
            cputchar(c);
c0100360:	83 ec 0c             	sub    $0xc,%esp
c0100363:	ff 75 f0             	pushl  -0x10(%ebp)
c0100366:	e8 2a ff ff ff       	call   c0100295 <cputchar>
c010036b:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010036e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100371:	8d 50 01             	lea    0x1(%eax),%edx
c0100374:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100377:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010037a:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c0100380:	eb 4c                	jmp    c01003ce <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c0100382:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100386:	75 1a                	jne    c01003a2 <readline+0x8f>
c0100388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010038c:	7e 14                	jle    c01003a2 <readline+0x8f>
            cputchar(c);
c010038e:	83 ec 0c             	sub    $0xc,%esp
c0100391:	ff 75 f0             	pushl  -0x10(%ebp)
c0100394:	e8 fc fe ff ff       	call   c0100295 <cputchar>
c0100399:	83 c4 10             	add    $0x10,%esp
            i --;
c010039c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003a0:	eb 2c                	jmp    c01003ce <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01003a2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003a6:	74 06                	je     c01003ae <readline+0x9b>
c01003a8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003ac:	75 8b                	jne    c0100339 <readline+0x26>
            cputchar(c);
c01003ae:	83 ec 0c             	sub    $0xc,%esp
c01003b1:	ff 75 f0             	pushl  -0x10(%ebp)
c01003b4:	e8 dc fe ff ff       	call   c0100295 <cputchar>
c01003b9:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003bf:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003c4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003c7:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003cc:	eb 05                	jmp    c01003d3 <readline+0xc0>
        }
    }
c01003ce:	e9 66 ff ff ff       	jmp    c0100339 <readline+0x26>
}
c01003d3:	c9                   	leave  
c01003d4:	c3                   	ret    

c01003d5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003d5:	55                   	push   %ebp
c01003d6:	89 e5                	mov    %esp,%ebp
c01003d8:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003db:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003e0:	85 c0                	test   %eax,%eax
c01003e2:	75 4a                	jne    c010042e <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003e4:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c01003eb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003ee:	8d 45 14             	lea    0x14(%ebp),%eax
c01003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003f4:	83 ec 04             	sub    $0x4,%esp
c01003f7:	ff 75 0c             	pushl  0xc(%ebp)
c01003fa:	ff 75 08             	pushl  0x8(%ebp)
c01003fd:	68 aa 5a 10 c0       	push   $0xc0105aaa
c0100402:	e8 68 fe ff ff       	call   c010026f <cprintf>
c0100407:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010040d:	83 ec 08             	sub    $0x8,%esp
c0100410:	50                   	push   %eax
c0100411:	ff 75 10             	pushl  0x10(%ebp)
c0100414:	e8 2d fe ff ff       	call   c0100246 <vcprintf>
c0100419:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010041c:	83 ec 0c             	sub    $0xc,%esp
c010041f:	68 c6 5a 10 c0       	push   $0xc0105ac6
c0100424:	e8 46 fe ff ff       	call   c010026f <cprintf>
c0100429:	83 c4 10             	add    $0x10,%esp
c010042c:	eb 01                	jmp    c010042f <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c010042e:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c010042f:	e8 42 14 00 00       	call   c0101876 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100434:	83 ec 0c             	sub    $0xc,%esp
c0100437:	6a 00                	push   $0x0
c0100439:	e8 3d 08 00 00       	call   c0100c7b <kmonitor>
c010043e:	83 c4 10             	add    $0x10,%esp
    }
c0100441:	eb f1                	jmp    c0100434 <__panic+0x5f>

c0100443 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100443:	55                   	push   %ebp
c0100444:	89 e5                	mov    %esp,%ebp
c0100446:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100449:	8d 45 14             	lea    0x14(%ebp),%eax
c010044c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010044f:	83 ec 04             	sub    $0x4,%esp
c0100452:	ff 75 0c             	pushl  0xc(%ebp)
c0100455:	ff 75 08             	pushl  0x8(%ebp)
c0100458:	68 c8 5a 10 c0       	push   $0xc0105ac8
c010045d:	e8 0d fe ff ff       	call   c010026f <cprintf>
c0100462:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100465:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100468:	83 ec 08             	sub    $0x8,%esp
c010046b:	50                   	push   %eax
c010046c:	ff 75 10             	pushl  0x10(%ebp)
c010046f:	e8 d2 fd ff ff       	call   c0100246 <vcprintf>
c0100474:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100477:	83 ec 0c             	sub    $0xc,%esp
c010047a:	68 c6 5a 10 c0       	push   $0xc0105ac6
c010047f:	e8 eb fd ff ff       	call   c010026f <cprintf>
c0100484:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100487:	90                   	nop
c0100488:	c9                   	leave  
c0100489:	c3                   	ret    

c010048a <is_kernel_panic>:

bool
is_kernel_panic(void) {
c010048a:	55                   	push   %ebp
c010048b:	89 e5                	mov    %esp,%ebp
    return is_panic;
c010048d:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100492:	5d                   	pop    %ebp
c0100493:	c3                   	ret    

c0100494 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100494:	55                   	push   %ebp
c0100495:	89 e5                	mov    %esp,%ebp
c0100497:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c010049a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010049d:	8b 00                	mov    (%eax),%eax
c010049f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a5:	8b 00                	mov    (%eax),%eax
c01004a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004b1:	e9 d2 00 00 00       	jmp    c0100588 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004bc:	01 d0                	add    %edx,%eax
c01004be:	89 c2                	mov    %eax,%edx
c01004c0:	c1 ea 1f             	shr    $0x1f,%edx
c01004c3:	01 d0                	add    %edx,%eax
c01004c5:	d1 f8                	sar    %eax
c01004c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004cd:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004d0:	eb 04                	jmp    c01004d6 <stab_binsearch+0x42>
            m --;
c01004d2:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004dc:	7c 1f                	jl     c01004fd <stab_binsearch+0x69>
c01004de:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e1:	89 d0                	mov    %edx,%eax
c01004e3:	01 c0                	add    %eax,%eax
c01004e5:	01 d0                	add    %edx,%eax
c01004e7:	c1 e0 02             	shl    $0x2,%eax
c01004ea:	89 c2                	mov    %eax,%edx
c01004ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ef:	01 d0                	add    %edx,%eax
c01004f1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004f5:	0f b6 c0             	movzbl %al,%eax
c01004f8:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004fb:	75 d5                	jne    c01004d2 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100500:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100503:	7d 0b                	jge    c0100510 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100505:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100508:	83 c0 01             	add    $0x1,%eax
c010050b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010050e:	eb 78                	jmp    c0100588 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100510:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100517:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010051a:	89 d0                	mov    %edx,%eax
c010051c:	01 c0                	add    %eax,%eax
c010051e:	01 d0                	add    %edx,%eax
c0100520:	c1 e0 02             	shl    $0x2,%eax
c0100523:	89 c2                	mov    %eax,%edx
c0100525:	8b 45 08             	mov    0x8(%ebp),%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	8b 40 08             	mov    0x8(%eax),%eax
c010052d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100530:	73 13                	jae    c0100545 <stab_binsearch+0xb1>
            *region_left = m;
c0100532:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100535:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100538:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010053a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010053d:	83 c0 01             	add    $0x1,%eax
c0100540:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100543:	eb 43                	jmp    c0100588 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100545:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100548:	89 d0                	mov    %edx,%eax
c010054a:	01 c0                	add    %eax,%eax
c010054c:	01 d0                	add    %edx,%eax
c010054e:	c1 e0 02             	shl    $0x2,%eax
c0100551:	89 c2                	mov    %eax,%edx
c0100553:	8b 45 08             	mov    0x8(%ebp),%eax
c0100556:	01 d0                	add    %edx,%eax
c0100558:	8b 40 08             	mov    0x8(%eax),%eax
c010055b:	3b 45 18             	cmp    0x18(%ebp),%eax
c010055e:	76 16                	jbe    c0100576 <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100560:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100563:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100566:	8b 45 10             	mov    0x10(%ebp),%eax
c0100569:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010056b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010056e:	83 e8 01             	sub    $0x1,%eax
c0100571:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100574:	eb 12                	jmp    c0100588 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100576:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100579:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010057c:	89 10                	mov    %edx,(%eax)
            l = m;
c010057e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100581:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c0100584:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100588:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010058b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010058e:	0f 8e 22 ff ff ff    	jle    c01004b6 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c0100594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100598:	75 0f                	jne    c01005a9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c010059a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010059d:	8b 00                	mov    (%eax),%eax
c010059f:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a5:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005a7:	eb 3f                	jmp    c01005e8 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01005ac:	8b 00                	mov    (%eax),%eax
c01005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005b1:	eb 04                	jmp    c01005b7 <stab_binsearch+0x123>
c01005b3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ba:	8b 00                	mov    (%eax),%eax
c01005bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005bf:	7d 1f                	jge    c01005e0 <stab_binsearch+0x14c>
c01005c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005c4:	89 d0                	mov    %edx,%eax
c01005c6:	01 c0                	add    %eax,%eax
c01005c8:	01 d0                	add    %edx,%eax
c01005ca:	c1 e0 02             	shl    $0x2,%eax
c01005cd:	89 c2                	mov    %eax,%edx
c01005cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d2:	01 d0                	add    %edx,%eax
c01005d4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d8:	0f b6 c0             	movzbl %al,%eax
c01005db:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005de:	75 d3                	jne    c01005b3 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005e6:	89 10                	mov    %edx,(%eax)
    }
}
c01005e8:	90                   	nop
c01005e9:	c9                   	leave  
c01005ea:	c3                   	ret    

c01005eb <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005eb:	55                   	push   %ebp
c01005ec:	89 e5                	mov    %esp,%ebp
c01005ee:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f4:	c7 00 e8 5a 10 c0    	movl   $0xc0105ae8,(%eax)
    info->eip_line = 0;
c01005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100604:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100607:	c7 40 08 e8 5a 10 c0 	movl   $0xc0105ae8,0x8(%eax)
    info->eip_fn_namelen = 9;
c010060e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100611:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100618:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061b:	8b 55 08             	mov    0x8(%ebp),%edx
c010061e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100624:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010062b:	c7 45 f4 08 6d 10 c0 	movl   $0xc0106d08,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100632:	c7 45 f0 24 1a 11 c0 	movl   $0xc0111a24,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100639:	c7 45 ec 25 1a 11 c0 	movl   $0xc0111a25,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100640:	c7 45 e8 f7 44 11 c0 	movl   $0xc01144f7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010064d:	76 0d                	jbe    c010065c <debuginfo_eip+0x71>
c010064f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100652:	83 e8 01             	sub    $0x1,%eax
c0100655:	0f b6 00             	movzbl (%eax),%eax
c0100658:	84 c0                	test   %al,%al
c010065a:	74 0a                	je     c0100666 <debuginfo_eip+0x7b>
        return -1;
c010065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100661:	e9 91 02 00 00       	jmp    c01008f7 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100666:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010066d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100673:	29 c2                	sub    %eax,%edx
c0100675:	89 d0                	mov    %edx,%eax
c0100677:	c1 f8 02             	sar    $0x2,%eax
c010067a:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100680:	83 e8 01             	sub    $0x1,%eax
c0100683:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100686:	ff 75 08             	pushl  0x8(%ebp)
c0100689:	6a 64                	push   $0x64
c010068b:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010068e:	50                   	push   %eax
c010068f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100692:	50                   	push   %eax
c0100693:	ff 75 f4             	pushl  -0xc(%ebp)
c0100696:	e8 f9 fd ff ff       	call   c0100494 <stab_binsearch>
c010069b:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c010069e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006a1:	85 c0                	test   %eax,%eax
c01006a3:	75 0a                	jne    c01006af <debuginfo_eip+0xc4>
        return -1;
c01006a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006aa:	e9 48 02 00 00       	jmp    c01008f7 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006bb:	ff 75 08             	pushl  0x8(%ebp)
c01006be:	6a 24                	push   $0x24
c01006c0:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006c3:	50                   	push   %eax
c01006c4:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006c7:	50                   	push   %eax
c01006c8:	ff 75 f4             	pushl  -0xc(%ebp)
c01006cb:	e8 c4 fd ff ff       	call   c0100494 <stab_binsearch>
c01006d0:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d9:	39 c2                	cmp    %eax,%edx
c01006db:	7f 7c                	jg     c0100759 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006e0:	89 c2                	mov    %eax,%edx
c01006e2:	89 d0                	mov    %edx,%eax
c01006e4:	01 c0                	add    %eax,%eax
c01006e6:	01 d0                	add    %edx,%eax
c01006e8:	c1 e0 02             	shl    $0x2,%eax
c01006eb:	89 c2                	mov    %eax,%edx
c01006ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006f0:	01 d0                	add    %edx,%eax
c01006f2:	8b 00                	mov    (%eax),%eax
c01006f4:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006fa:	29 d1                	sub    %edx,%ecx
c01006fc:	89 ca                	mov    %ecx,%edx
c01006fe:	39 d0                	cmp    %edx,%eax
c0100700:	73 22                	jae    c0100724 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100702:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100705:	89 c2                	mov    %eax,%edx
c0100707:	89 d0                	mov    %edx,%eax
c0100709:	01 c0                	add    %eax,%eax
c010070b:	01 d0                	add    %edx,%eax
c010070d:	c1 e0 02             	shl    $0x2,%eax
c0100710:	89 c2                	mov    %eax,%edx
c0100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100715:	01 d0                	add    %edx,%eax
c0100717:	8b 10                	mov    (%eax),%edx
c0100719:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010071c:	01 c2                	add    %eax,%edx
c010071e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100721:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100724:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100727:	89 c2                	mov    %eax,%edx
c0100729:	89 d0                	mov    %edx,%eax
c010072b:	01 c0                	add    %eax,%eax
c010072d:	01 d0                	add    %edx,%eax
c010072f:	c1 e0 02             	shl    $0x2,%eax
c0100732:	89 c2                	mov    %eax,%edx
c0100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	8b 50 08             	mov    0x8(%eax),%edx
c010073c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073f:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100742:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100745:	8b 40 10             	mov    0x10(%eax),%eax
c0100748:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010074b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010074e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100751:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100754:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100757:	eb 15                	jmp    c010076e <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	8b 55 08             	mov    0x8(%ebp),%edx
c010075f:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100765:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100768:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010076b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010076e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100771:	8b 40 08             	mov    0x8(%eax),%eax
c0100774:	83 ec 08             	sub    $0x8,%esp
c0100777:	6a 3a                	push   $0x3a
c0100779:	50                   	push   %eax
c010077a:	e8 47 49 00 00       	call   c01050c6 <strfind>
c010077f:	83 c4 10             	add    $0x10,%esp
c0100782:	89 c2                	mov    %eax,%edx
c0100784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100787:	8b 40 08             	mov    0x8(%eax),%eax
c010078a:	29 c2                	sub    %eax,%edx
c010078c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078f:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100792:	83 ec 0c             	sub    $0xc,%esp
c0100795:	ff 75 08             	pushl  0x8(%ebp)
c0100798:	6a 44                	push   $0x44
c010079a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010079d:	50                   	push   %eax
c010079e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007a1:	50                   	push   %eax
c01007a2:	ff 75 f4             	pushl  -0xc(%ebp)
c01007a5:	e8 ea fc ff ff       	call   c0100494 <stab_binsearch>
c01007aa:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b3:	39 c2                	cmp    %eax,%edx
c01007b5:	7f 24                	jg     c01007db <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ba:	89 c2                	mov    %eax,%edx
c01007bc:	89 d0                	mov    %edx,%eax
c01007be:	01 c0                	add    %eax,%eax
c01007c0:	01 d0                	add    %edx,%eax
c01007c2:	c1 e0 02             	shl    $0x2,%eax
c01007c5:	89 c2                	mov    %eax,%edx
c01007c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ca:	01 d0                	add    %edx,%eax
c01007cc:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007d0:	0f b7 d0             	movzwl %ax,%edx
c01007d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d6:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d9:	eb 13                	jmp    c01007ee <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007e0:	e9 12 01 00 00       	jmp    c01008f7 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e8:	83 e8 01             	sub    $0x1,%eax
c01007eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f4:	39 c2                	cmp    %eax,%edx
c01007f6:	7c 56                	jl     c010084e <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	89 d0                	mov    %edx,%eax
c01007ff:	01 c0                	add    %eax,%eax
c0100801:	01 d0                	add    %edx,%eax
c0100803:	c1 e0 02             	shl    $0x2,%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010080b:	01 d0                	add    %edx,%eax
c010080d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100811:	3c 84                	cmp    $0x84,%al
c0100813:	74 39                	je     c010084e <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100818:	89 c2                	mov    %eax,%edx
c010081a:	89 d0                	mov    %edx,%eax
c010081c:	01 c0                	add    %eax,%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	c1 e0 02             	shl    $0x2,%eax
c0100823:	89 c2                	mov    %eax,%edx
c0100825:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100828:	01 d0                	add    %edx,%eax
c010082a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010082e:	3c 64                	cmp    $0x64,%al
c0100830:	75 b3                	jne    c01007e5 <debuginfo_eip+0x1fa>
c0100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100835:	89 c2                	mov    %eax,%edx
c0100837:	89 d0                	mov    %edx,%eax
c0100839:	01 c0                	add    %eax,%eax
c010083b:	01 d0                	add    %edx,%eax
c010083d:	c1 e0 02             	shl    $0x2,%eax
c0100840:	89 c2                	mov    %eax,%edx
c0100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100845:	01 d0                	add    %edx,%eax
c0100847:	8b 40 08             	mov    0x8(%eax),%eax
c010084a:	85 c0                	test   %eax,%eax
c010084c:	74 97                	je     c01007e5 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c010084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100854:	39 c2                	cmp    %eax,%edx
c0100856:	7c 46                	jl     c010089e <debuginfo_eip+0x2b3>
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	8b 00                	mov    (%eax),%eax
c010086f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100872:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100875:	29 d1                	sub    %edx,%ecx
c0100877:	89 ca                	mov    %ecx,%edx
c0100879:	39 d0                	cmp    %edx,%eax
c010087b:	73 21                	jae    c010089e <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010087d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100880:	89 c2                	mov    %eax,%edx
c0100882:	89 d0                	mov    %edx,%eax
c0100884:	01 c0                	add    %eax,%eax
c0100886:	01 d0                	add    %edx,%eax
c0100888:	c1 e0 02             	shl    $0x2,%eax
c010088b:	89 c2                	mov    %eax,%edx
c010088d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100890:	01 d0                	add    %edx,%eax
c0100892:	8b 10                	mov    (%eax),%edx
c0100894:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100897:	01 c2                	add    %eax,%edx
c0100899:	8b 45 0c             	mov    0xc(%ebp),%eax
c010089c:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010089e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008a4:	39 c2                	cmp    %eax,%edx
c01008a6:	7d 4a                	jge    c01008f2 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008ab:	83 c0 01             	add    $0x1,%eax
c01008ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008b1:	eb 18                	jmp    c01008cb <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b6:	8b 40 14             	mov    0x14(%eax),%eax
c01008b9:	8d 50 01             	lea    0x1(%eax),%edx
c01008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008bf:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c5:	83 c0 01             	add    $0x1,%eax
c01008c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008d1:	39 c2                	cmp    %eax,%edx
c01008d3:	7d 1d                	jge    c01008f2 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d8:	89 c2                	mov    %eax,%edx
c01008da:	89 d0                	mov    %edx,%eax
c01008dc:	01 c0                	add    %eax,%eax
c01008de:	01 d0                	add    %edx,%eax
c01008e0:	c1 e0 02             	shl    $0x2,%eax
c01008e3:	89 c2                	mov    %eax,%edx
c01008e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e8:	01 d0                	add    %edx,%eax
c01008ea:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008ee:	3c a0                	cmp    $0xa0,%al
c01008f0:	74 c1                	je     c01008b3 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008f7:	c9                   	leave  
c01008f8:	c3                   	ret    

c01008f9 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f9:	55                   	push   %ebp
c01008fa:	89 e5                	mov    %esp,%ebp
c01008fc:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008ff:	83 ec 0c             	sub    $0xc,%esp
c0100902:	68 f2 5a 10 c0       	push   $0xc0105af2
c0100907:	e8 63 f9 ff ff       	call   c010026f <cprintf>
c010090c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010090f:	83 ec 08             	sub    $0x8,%esp
c0100912:	68 2a 00 10 c0       	push   $0xc010002a
c0100917:	68 0b 5b 10 c0       	push   $0xc0105b0b
c010091c:	e8 4e f9 ff ff       	call   c010026f <cprintf>
c0100921:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100924:	83 ec 08             	sub    $0x8,%esp
c0100927:	68 e9 59 10 c0       	push   $0xc01059e9
c010092c:	68 23 5b 10 c0       	push   $0xc0105b23
c0100931:	e8 39 f9 ff ff       	call   c010026f <cprintf>
c0100936:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100939:	83 ec 08             	sub    $0x8,%esp
c010093c:	68 36 7a 11 c0       	push   $0xc0117a36
c0100941:	68 3b 5b 10 c0       	push   $0xc0105b3b
c0100946:	e8 24 f9 ff ff       	call   c010026f <cprintf>
c010094b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010094e:	83 ec 08             	sub    $0x8,%esp
c0100951:	68 c8 89 11 c0       	push   $0xc01189c8
c0100956:	68 53 5b 10 c0       	push   $0xc0105b53
c010095b:	e8 0f f9 ff ff       	call   c010026f <cprintf>
c0100960:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100963:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c0100968:	05 ff 03 00 00       	add    $0x3ff,%eax
c010096d:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c0100972:	29 d0                	sub    %edx,%eax
c0100974:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c010097a:	85 c0                	test   %eax,%eax
c010097c:	0f 48 c2             	cmovs  %edx,%eax
c010097f:	c1 f8 0a             	sar    $0xa,%eax
c0100982:	83 ec 08             	sub    $0x8,%esp
c0100985:	50                   	push   %eax
c0100986:	68 6c 5b 10 c0       	push   $0xc0105b6c
c010098b:	e8 df f8 ff ff       	call   c010026f <cprintf>
c0100990:	83 c4 10             	add    $0x10,%esp
}
c0100993:	90                   	nop
c0100994:	c9                   	leave  
c0100995:	c3                   	ret    

c0100996 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100996:	55                   	push   %ebp
c0100997:	89 e5                	mov    %esp,%ebp
c0100999:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010099f:	83 ec 08             	sub    $0x8,%esp
c01009a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009a5:	50                   	push   %eax
c01009a6:	ff 75 08             	pushl  0x8(%ebp)
c01009a9:	e8 3d fc ff ff       	call   c01005eb <debuginfo_eip>
c01009ae:	83 c4 10             	add    $0x10,%esp
c01009b1:	85 c0                	test   %eax,%eax
c01009b3:	74 15                	je     c01009ca <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009b5:	83 ec 08             	sub    $0x8,%esp
c01009b8:	ff 75 08             	pushl  0x8(%ebp)
c01009bb:	68 96 5b 10 c0       	push   $0xc0105b96
c01009c0:	e8 aa f8 ff ff       	call   c010026f <cprintf>
c01009c5:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c8:	eb 65                	jmp    c0100a2f <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009d1:	eb 1c                	jmp    c01009ef <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d9:	01 d0                	add    %edx,%eax
c01009db:	0f b6 00             	movzbl (%eax),%eax
c01009de:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009e7:	01 ca                	add    %ecx,%edx
c01009e9:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009f5:	7f dc                	jg     c01009d3 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009f7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a00:	01 d0                	add    %edx,%eax
c0100a02:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a08:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a0b:	89 d1                	mov    %edx,%ecx
c0100a0d:	29 c1                	sub    %eax,%ecx
c0100a0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a12:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a15:	83 ec 0c             	sub    $0xc,%esp
c0100a18:	51                   	push   %ecx
c0100a19:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1f:	51                   	push   %ecx
c0100a20:	52                   	push   %edx
c0100a21:	50                   	push   %eax
c0100a22:	68 b2 5b 10 c0       	push   $0xc0105bb2
c0100a27:	e8 43 f8 ff ff       	call   c010026f <cprintf>
c0100a2c:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a2f:	90                   	nop
c0100a30:	c9                   	leave  
c0100a31:	c3                   	ret    

c0100a32 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a32:	55                   	push   %ebp
c0100a33:	89 e5                	mov    %esp,%ebp
c0100a35:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a38:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a41:	c9                   	leave  
c0100a42:	c3                   	ret    

c0100a43 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a43:	55                   	push   %ebp
c0100a44:	89 e5                	mov    %esp,%ebp
c0100a46:	53                   	push   %ebx
c0100a47:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a4a:	89 e8                	mov    %ebp,%eax
c0100a4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
c0100a52:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
c0100a55:	e8 d8 ff ff ff       	call   c0100a32 <read_eip>
c0100a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c0100a5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a64:	e9 93 00 00 00       	jmp    c0100afc <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
c0100a69:	83 ec 04             	sub    $0x4,%esp
c0100a6c:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a6f:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a72:	68 c4 5b 10 c0       	push   $0xc0105bc4
c0100a77:	e8 f3 f7 ff ff       	call   c010026f <cprintf>
c0100a7c:	83 c4 10             	add    $0x10,%esp

        // get args
        for (int j = 0; j < 4; j++) {
c0100a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a86:	eb 1f                	jmp    c0100aa7 <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
c0100a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a95:	01 d0                	add    %edx,%eax
c0100a97:	83 c0 08             	add    $0x8,%eax
c0100a9a:	8b 10                	mov    (%eax),%edx
c0100a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a9f:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);

        // get args
        for (int j = 0; j < 4; j++) {
c0100aa3:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100aa7:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100aab:	7e db                	jle    c0100a88 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
c0100aad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c0100ab0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0100ab3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0100ab6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100ab9:	83 ec 0c             	sub    $0xc,%esp
c0100abc:	53                   	push   %ebx
c0100abd:	51                   	push   %ecx
c0100abe:	52                   	push   %edx
c0100abf:	50                   	push   %eax
c0100ac0:	68 dc 5b 10 c0       	push   $0xc0105bdc
c0100ac5:	e8 a5 f7 ff ff       	call   c010026f <cprintf>
c0100aca:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);

        // print function info
        print_debuginfo(stack_val_eip - 1);
c0100acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ad0:	83 e8 01             	sub    $0x1,%eax
c0100ad3:	83 ec 0c             	sub    $0xc,%esp
c0100ad6:	50                   	push   %eax
c0100ad7:	e8 ba fe ff ff       	call   c0100996 <print_debuginfo>
c0100adc:	83 c4 10             	add    $0x10,%esp

        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
c0100adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae2:	83 c0 04             	add    $0x4,%eax
c0100ae5:	8b 00                	mov    (%eax),%eax
c0100ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	8b 00                	mov    (%eax),%eax
c0100aef:	89 45 f4             	mov    %eax,-0xc(%ebp)

        // ebp should be valid
        if (stack_val_ebp <= 0) {
c0100af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100af6:	74 10                	je     c0100b08 <print_stackframe+0xc5>
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c0100af8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100afc:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b00:	0f 8e 63 ff ff ff    	jle    c0100a69 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
c0100b06:	eb 01                	jmp    c0100b09 <print_stackframe+0xc6>
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));

        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
c0100b08:	90                   	nop
        }
    }
}
c0100b09:	90                   	nop
c0100b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100b0d:	c9                   	leave  
c0100b0e:	c3                   	ret    

c0100b0f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b0f:	55                   	push   %ebp
c0100b10:	89 e5                	mov    %esp,%ebp
c0100b12:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b1c:	eb 0c                	jmp    c0100b2a <parse+0x1b>
            *buf ++ = '\0';
c0100b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b21:	8d 50 01             	lea    0x1(%eax),%edx
c0100b24:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b27:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2d:	0f b6 00             	movzbl (%eax),%eax
c0100b30:	84 c0                	test   %al,%al
c0100b32:	74 1e                	je     c0100b52 <parse+0x43>
c0100b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b37:	0f b6 00             	movzbl (%eax),%eax
c0100b3a:	0f be c0             	movsbl %al,%eax
c0100b3d:	83 ec 08             	sub    $0x8,%esp
c0100b40:	50                   	push   %eax
c0100b41:	68 80 5c 10 c0       	push   $0xc0105c80
c0100b46:	e8 48 45 00 00       	call   c0105093 <strchr>
c0100b4b:	83 c4 10             	add    $0x10,%esp
c0100b4e:	85 c0                	test   %eax,%eax
c0100b50:	75 cc                	jne    c0100b1e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b55:	0f b6 00             	movzbl (%eax),%eax
c0100b58:	84 c0                	test   %al,%al
c0100b5a:	74 69                	je     c0100bc5 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b5c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b60:	75 12                	jne    c0100b74 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b62:	83 ec 08             	sub    $0x8,%esp
c0100b65:	6a 10                	push   $0x10
c0100b67:	68 85 5c 10 c0       	push   $0xc0105c85
c0100b6c:	e8 fe f6 ff ff       	call   c010026f <cprintf>
c0100b71:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b77:	8d 50 01             	lea    0x1(%eax),%edx
c0100b7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b87:	01 c2                	add    %eax,%edx
c0100b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b8e:	eb 04                	jmp    c0100b94 <parse+0x85>
            buf ++;
c0100b90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b97:	0f b6 00             	movzbl (%eax),%eax
c0100b9a:	84 c0                	test   %al,%al
c0100b9c:	0f 84 7a ff ff ff    	je     c0100b1c <parse+0xd>
c0100ba2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba5:	0f b6 00             	movzbl (%eax),%eax
c0100ba8:	0f be c0             	movsbl %al,%eax
c0100bab:	83 ec 08             	sub    $0x8,%esp
c0100bae:	50                   	push   %eax
c0100baf:	68 80 5c 10 c0       	push   $0xc0105c80
c0100bb4:	e8 da 44 00 00       	call   c0105093 <strchr>
c0100bb9:	83 c4 10             	add    $0x10,%esp
c0100bbc:	85 c0                	test   %eax,%eax
c0100bbe:	74 d0                	je     c0100b90 <parse+0x81>
            buf ++;
        }
    }
c0100bc0:	e9 57 ff ff ff       	jmp    c0100b1c <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bc5:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bc9:	c9                   	leave  
c0100bca:	c3                   	ret    

c0100bcb <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bcb:	55                   	push   %ebp
c0100bcc:	89 e5                	mov    %esp,%ebp
c0100bce:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bd1:	83 ec 08             	sub    $0x8,%esp
c0100bd4:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bd7:	50                   	push   %eax
c0100bd8:	ff 75 08             	pushl  0x8(%ebp)
c0100bdb:	e8 2f ff ff ff       	call   c0100b0f <parse>
c0100be0:	83 c4 10             	add    $0x10,%esp
c0100be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bea:	75 0a                	jne    c0100bf6 <runcmd+0x2b>
        return 0;
c0100bec:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bf1:	e9 83 00 00 00       	jmp    c0100c79 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bfd:	eb 59                	jmp    c0100c58 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100bff:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c05:	89 d0                	mov    %edx,%eax
c0100c07:	01 c0                	add    %eax,%eax
c0100c09:	01 d0                	add    %edx,%eax
c0100c0b:	c1 e0 02             	shl    $0x2,%eax
c0100c0e:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c13:	8b 00                	mov    (%eax),%eax
c0100c15:	83 ec 08             	sub    $0x8,%esp
c0100c18:	51                   	push   %ecx
c0100c19:	50                   	push   %eax
c0100c1a:	e8 d4 43 00 00       	call   c0104ff3 <strcmp>
c0100c1f:	83 c4 10             	add    $0x10,%esp
c0100c22:	85 c0                	test   %eax,%eax
c0100c24:	75 2e                	jne    c0100c54 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c29:	89 d0                	mov    %edx,%eax
c0100c2b:	01 c0                	add    %eax,%eax
c0100c2d:	01 d0                	add    %edx,%eax
c0100c2f:	c1 e0 02             	shl    $0x2,%eax
c0100c32:	05 28 70 11 c0       	add    $0xc0117028,%eax
c0100c37:	8b 10                	mov    (%eax),%edx
c0100c39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c3c:	83 c0 04             	add    $0x4,%eax
c0100c3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c42:	83 e9 01             	sub    $0x1,%ecx
c0100c45:	83 ec 04             	sub    $0x4,%esp
c0100c48:	ff 75 0c             	pushl  0xc(%ebp)
c0100c4b:	50                   	push   %eax
c0100c4c:	51                   	push   %ecx
c0100c4d:	ff d2                	call   *%edx
c0100c4f:	83 c4 10             	add    $0x10,%esp
c0100c52:	eb 25                	jmp    c0100c79 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5b:	83 f8 02             	cmp    $0x2,%eax
c0100c5e:	76 9f                	jbe    c0100bff <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c60:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c63:	83 ec 08             	sub    $0x8,%esp
c0100c66:	50                   	push   %eax
c0100c67:	68 a3 5c 10 c0       	push   $0xc0105ca3
c0100c6c:	e8 fe f5 ff ff       	call   c010026f <cprintf>
c0100c71:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c79:	c9                   	leave  
c0100c7a:	c3                   	ret    

c0100c7b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c7b:	55                   	push   %ebp
c0100c7c:	89 e5                	mov    %esp,%ebp
c0100c7e:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c81:	83 ec 0c             	sub    $0xc,%esp
c0100c84:	68 bc 5c 10 c0       	push   $0xc0105cbc
c0100c89:	e8 e1 f5 ff ff       	call   c010026f <cprintf>
c0100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c91:	83 ec 0c             	sub    $0xc,%esp
c0100c94:	68 e4 5c 10 c0       	push   $0xc0105ce4
c0100c99:	e8 d1 f5 ff ff       	call   c010026f <cprintf>
c0100c9e:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ca5:	74 0e                	je     c0100cb5 <kmonitor+0x3a>
        print_trapframe(tf);
c0100ca7:	83 ec 0c             	sub    $0xc,%esp
c0100caa:	ff 75 08             	pushl  0x8(%ebp)
c0100cad:	e8 9e 0d 00 00       	call   c0101a50 <print_trapframe>
c0100cb2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cb5:	83 ec 0c             	sub    $0xc,%esp
c0100cb8:	68 09 5d 10 c0       	push   $0xc0105d09
c0100cbd:	e8 51 f6 ff ff       	call   c0100313 <readline>
c0100cc2:	83 c4 10             	add    $0x10,%esp
c0100cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ccc:	74 e7                	je     c0100cb5 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cce:	83 ec 08             	sub    $0x8,%esp
c0100cd1:	ff 75 08             	pushl  0x8(%ebp)
c0100cd4:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cd7:	e8 ef fe ff ff       	call   c0100bcb <runcmd>
c0100cdc:	83 c4 10             	add    $0x10,%esp
c0100cdf:	85 c0                	test   %eax,%eax
c0100ce1:	78 02                	js     c0100ce5 <kmonitor+0x6a>
                break;
            }
        }
    }
c0100ce3:	eb d0                	jmp    c0100cb5 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100ce5:	90                   	nop
            }
        }
    }
}
c0100ce6:	90                   	nop
c0100ce7:	c9                   	leave  
c0100ce8:	c3                   	ret    

c0100ce9 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100ce9:	55                   	push   %ebp
c0100cea:	89 e5                	mov    %esp,%ebp
c0100cec:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cf6:	eb 3c                	jmp    c0100d34 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cfb:	89 d0                	mov    %edx,%eax
c0100cfd:	01 c0                	add    %eax,%eax
c0100cff:	01 d0                	add    %edx,%eax
c0100d01:	c1 e0 02             	shl    $0x2,%eax
c0100d04:	05 24 70 11 c0       	add    $0xc0117024,%eax
c0100d09:	8b 08                	mov    (%eax),%ecx
c0100d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d0e:	89 d0                	mov    %edx,%eax
c0100d10:	01 c0                	add    %eax,%eax
c0100d12:	01 d0                	add    %edx,%eax
c0100d14:	c1 e0 02             	shl    $0x2,%eax
c0100d17:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100d1c:	8b 00                	mov    (%eax),%eax
c0100d1e:	83 ec 04             	sub    $0x4,%esp
c0100d21:	51                   	push   %ecx
c0100d22:	50                   	push   %eax
c0100d23:	68 0d 5d 10 c0       	push   $0xc0105d0d
c0100d28:	e8 42 f5 ff ff       	call   c010026f <cprintf>
c0100d2d:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d37:	83 f8 02             	cmp    $0x2,%eax
c0100d3a:	76 bc                	jbe    c0100cf8 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d41:	c9                   	leave  
c0100d42:	c3                   	ret    

c0100d43 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d43:	55                   	push   %ebp
c0100d44:	89 e5                	mov    %esp,%ebp
c0100d46:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d49:	e8 ab fb ff ff       	call   c01008f9 <print_kerninfo>
    return 0;
c0100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d53:	c9                   	leave  
c0100d54:	c3                   	ret    

c0100d55 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d55:	55                   	push   %ebp
c0100d56:	89 e5                	mov    %esp,%ebp
c0100d58:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d5b:	e8 e3 fc ff ff       	call   c0100a43 <print_stackframe>
    return 0;
c0100d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d65:	c9                   	leave  
c0100d66:	c3                   	ret    

c0100d67 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d67:	55                   	push   %ebp
c0100d68:	89 e5                	mov    %esp,%ebp
c0100d6a:	83 ec 18             	sub    $0x18,%esp
c0100d6d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d73:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d77:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d7f:	ee                   	out    %al,(%dx)
c0100d80:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d86:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d8a:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d8e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d92:	ee                   	out    %al,(%dx)
c0100d93:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d99:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d9d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100da5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100da6:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db0:	83 ec 0c             	sub    $0xc,%esp
c0100db3:	68 16 5d 10 c0       	push   $0xc0105d16
c0100db8:	e8 b2 f4 ff ff       	call   c010026f <cprintf>
c0100dbd:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dc0:	83 ec 0c             	sub    $0xc,%esp
c0100dc3:	6a 00                	push   $0x0
c0100dc5:	e8 3b 09 00 00       	call   c0101705 <pic_enable>
c0100dca:	83 c4 10             	add    $0x10,%esp
}
c0100dcd:	90                   	nop
c0100dce:	c9                   	leave  
c0100dcf:	c3                   	ret    

c0100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd0:	55                   	push   %ebp
c0100dd1:	89 e5                	mov    %esp,%ebp
c0100dd3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dd6:	9c                   	pushf  
c0100dd7:	58                   	pop    %eax
c0100dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dde:	25 00 02 00 00       	and    $0x200,%eax
c0100de3:	85 c0                	test   %eax,%eax
c0100de5:	74 0c                	je     c0100df3 <__intr_save+0x23>
        intr_disable();
c0100de7:	e8 8a 0a 00 00       	call   c0101876 <intr_disable>
        return 1;
c0100dec:	b8 01 00 00 00       	mov    $0x1,%eax
c0100df1:	eb 05                	jmp    c0100df8 <__intr_save+0x28>
    }
    return 0;
c0100df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df8:	c9                   	leave  
c0100df9:	c3                   	ret    

c0100dfa <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dfa:	55                   	push   %ebp
c0100dfb:	89 e5                	mov    %esp,%ebp
c0100dfd:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e04:	74 05                	je     c0100e0b <__intr_restore+0x11>
        intr_enable();
c0100e06:	e8 64 0a 00 00       	call   c010186f <intr_enable>
    }
}
c0100e0b:	90                   	nop
c0100e0c:	c9                   	leave  
c0100e0d:	c3                   	ret    

c0100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e0e:	55                   	push   %ebp
c0100e0f:	89 e5                	mov    %esp,%ebp
c0100e11:	83 ec 10             	sub    $0x10,%esp
c0100e14:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e1a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e1e:	89 c2                	mov    %eax,%edx
c0100e20:	ec                   	in     (%dx),%al
c0100e21:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e24:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e2a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e2e:	89 c2                	mov    %eax,%edx
c0100e30:	ec                   	in     (%dx),%al
c0100e31:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e34:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e3e:	89 c2                	mov    %eax,%edx
c0100e40:	ec                   	in     (%dx),%al
c0100e41:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e44:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e4a:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e4e:	89 c2                	mov    %eax,%edx
c0100e50:	ec                   	in     (%dx),%al
c0100e51:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e54:	90                   	nop
c0100e55:	c9                   	leave  
c0100e56:	c3                   	ret    

c0100e57 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e57:	55                   	push   %ebp
c0100e58:	89 e5                	mov    %esp,%ebp
c0100e5a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e5d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e67:	0f b7 00             	movzwl (%eax),%eax
c0100e6a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e71:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e79:	0f b7 00             	movzwl (%eax),%eax
c0100e7c:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e80:	74 12                	je     c0100e94 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e82:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e89:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e90:	b4 03 
c0100e92:	eb 13                	jmp    c0100ea7 <cga_init+0x50>
    } else {
        *cp = was;
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e9b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e9e:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ea5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ea7:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eae:	0f b7 c0             	movzwl %ax,%eax
c0100eb1:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100eb5:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb9:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100ebd:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100ec1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ec2:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec9:	83 c0 01             	add    $0x1,%eax
c0100ecc:	0f b7 c0             	movzwl %ax,%eax
c0100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ed3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ed7:	89 c2                	mov    %eax,%edx
c0100ed9:	ec                   	in     (%dx),%al
c0100eda:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100edd:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100ee1:	0f b6 c0             	movzbl %al,%eax
c0100ee4:	c1 e0 08             	shl    $0x8,%eax
c0100ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100eea:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ef1:	0f b7 c0             	movzwl %ax,%eax
c0100ef4:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100ef8:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100f00:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f04:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f05:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0c:	83 c0 01             	add    $0x1,%eax
c0100f0f:	0f b7 c0             	movzwl %ax,%eax
c0100f12:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f16:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f1a:	89 c2                	mov    %eax,%edx
c0100f1c:	ec                   	in     (%dx),%al
c0100f1d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f20:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f24:	0f b6 c0             	movzbl %al,%eax
c0100f27:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2d:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f35:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f3b:	90                   	nop
c0100f3c:	c9                   	leave  
c0100f3d:	c3                   	ret    

c0100f3e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f3e:	55                   	push   %ebp
c0100f3f:	89 e5                	mov    %esp,%ebp
c0100f41:	83 ec 28             	sub    $0x28,%esp
c0100f44:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f4a:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f4e:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f52:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f56:	ee                   	out    %al,(%dx)
c0100f57:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f5d:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f61:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f65:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f69:	ee                   	out    %al,(%dx)
c0100f6a:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f70:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f74:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f78:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7c:	ee                   	out    %al,(%dx)
c0100f7d:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f83:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f87:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f8b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f8f:	ee                   	out    %al,(%dx)
c0100f90:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f96:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f9a:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f9e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa2:	ee                   	out    %al,(%dx)
c0100fa3:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100fa9:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100fad:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100fb1:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100fb5:	ee                   	out    %al,(%dx)
c0100fb6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fbc:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100fc0:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100fc4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fc8:	ee                   	out    %al,(%dx)
c0100fc9:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fcf:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fd3:	89 c2                	mov    %eax,%edx
c0100fd5:	ec                   	in     (%dx),%al
c0100fd6:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fd9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fdd:	3c ff                	cmp    $0xff,%al
c0100fdf:	0f 95 c0             	setne  %al
c0100fe2:	0f b6 c0             	movzbl %al,%eax
c0100fe5:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fea:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100ff4:	89 c2                	mov    %eax,%edx
c0100ff6:	ec                   	in     (%dx),%al
c0100ff7:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100ffa:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0101000:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0101004:	89 c2                	mov    %eax,%edx
c0101006:	ec                   	in     (%dx),%al
c0101007:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010100a:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010100f:	85 c0                	test   %eax,%eax
c0101011:	74 0d                	je     c0101020 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101013:	83 ec 0c             	sub    $0xc,%esp
c0101016:	6a 04                	push   $0x4
c0101018:	e8 e8 06 00 00       	call   c0101705 <pic_enable>
c010101d:	83 c4 10             	add    $0x10,%esp
    }
}
c0101020:	90                   	nop
c0101021:	c9                   	leave  
c0101022:	c3                   	ret    

c0101023 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101023:	55                   	push   %ebp
c0101024:	89 e5                	mov    %esp,%ebp
c0101026:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101030:	eb 09                	jmp    c010103b <lpt_putc_sub+0x18>
        delay();
c0101032:	e8 d7 fd ff ff       	call   c0100e0e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101037:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010103b:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c0101041:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0101045:	89 c2                	mov    %eax,%edx
c0101047:	ec                   	in     (%dx),%al
c0101048:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c010104b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010104f:	84 c0                	test   %al,%al
c0101051:	78 09                	js     c010105c <lpt_putc_sub+0x39>
c0101053:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010105a:	7e d6                	jle    c0101032 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010105c:	8b 45 08             	mov    0x8(%ebp),%eax
c010105f:	0f b6 c0             	movzbl %al,%eax
c0101062:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101068:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c010106f:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101073:	ee                   	out    %al,(%dx)
c0101074:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010107a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010107e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101082:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101086:	ee                   	out    %al,(%dx)
c0101087:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c010108d:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c0101091:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0101095:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101099:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010109a:	90                   	nop
c010109b:	c9                   	leave  
c010109c:	c3                   	ret    

c010109d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010109d:	55                   	push   %ebp
c010109e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01010a0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010a4:	74 0d                	je     c01010b3 <lpt_putc+0x16>
        lpt_putc_sub(c);
c01010a6:	ff 75 08             	pushl  0x8(%ebp)
c01010a9:	e8 75 ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010ae:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010b1:	eb 1e                	jmp    c01010d1 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c01010b3:	6a 08                	push   $0x8
c01010b5:	e8 69 ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010ba:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010bd:	6a 20                	push   $0x20
c01010bf:	e8 5f ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010c4:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010c7:	6a 08                	push   $0x8
c01010c9:	e8 55 ff ff ff       	call   c0101023 <lpt_putc_sub>
c01010ce:	83 c4 04             	add    $0x4,%esp
    }
}
c01010d1:	90                   	nop
c01010d2:	c9                   	leave  
c01010d3:	c3                   	ret    

c01010d4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010d4:	55                   	push   %ebp
c01010d5:	89 e5                	mov    %esp,%ebp
c01010d7:	53                   	push   %ebx
c01010d8:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010db:	8b 45 08             	mov    0x8(%ebp),%eax
c01010de:	b0 00                	mov    $0x0,%al
c01010e0:	85 c0                	test   %eax,%eax
c01010e2:	75 07                	jne    c01010eb <cga_putc+0x17>
        c |= 0x0700;
c01010e4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ee:	0f b6 c0             	movzbl %al,%eax
c01010f1:	83 f8 0a             	cmp    $0xa,%eax
c01010f4:	74 4e                	je     c0101144 <cga_putc+0x70>
c01010f6:	83 f8 0d             	cmp    $0xd,%eax
c01010f9:	74 59                	je     c0101154 <cga_putc+0x80>
c01010fb:	83 f8 08             	cmp    $0x8,%eax
c01010fe:	0f 85 8a 00 00 00    	jne    c010118e <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c0101104:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010110b:	66 85 c0             	test   %ax,%ax
c010110e:	0f 84 a0 00 00 00    	je     c01011b4 <cga_putc+0xe0>
            crt_pos --;
c0101114:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010111b:	83 e8 01             	sub    $0x1,%eax
c010111e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101124:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101129:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101130:	0f b7 d2             	movzwl %dx,%edx
c0101133:	01 d2                	add    %edx,%edx
c0101135:	01 d0                	add    %edx,%eax
c0101137:	8b 55 08             	mov    0x8(%ebp),%edx
c010113a:	b2 00                	mov    $0x0,%dl
c010113c:	83 ca 20             	or     $0x20,%edx
c010113f:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101142:	eb 70                	jmp    c01011b4 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c0101144:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010114b:	83 c0 50             	add    $0x50,%eax
c010114e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101154:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010115b:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101162:	0f b7 c1             	movzwl %cx,%eax
c0101165:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010116b:	c1 e8 10             	shr    $0x10,%eax
c010116e:	89 c2                	mov    %eax,%edx
c0101170:	66 c1 ea 06          	shr    $0x6,%dx
c0101174:	89 d0                	mov    %edx,%eax
c0101176:	c1 e0 02             	shl    $0x2,%eax
c0101179:	01 d0                	add    %edx,%eax
c010117b:	c1 e0 04             	shl    $0x4,%eax
c010117e:	29 c1                	sub    %eax,%ecx
c0101180:	89 ca                	mov    %ecx,%edx
c0101182:	89 d8                	mov    %ebx,%eax
c0101184:	29 d0                	sub    %edx,%eax
c0101186:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c010118c:	eb 27                	jmp    c01011b5 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010118e:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c0101194:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010119b:	8d 50 01             	lea    0x1(%eax),%edx
c010119e:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011a5:	0f b7 c0             	movzwl %ax,%eax
c01011a8:	01 c0                	add    %eax,%eax
c01011aa:	01 c8                	add    %ecx,%eax
c01011ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01011af:	66 89 10             	mov    %dx,(%eax)
        break;
c01011b2:	eb 01                	jmp    c01011b5 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c01011b4:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011b5:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011bc:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011c0:	76 59                	jbe    c010121b <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011c2:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011c7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011cd:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011d2:	83 ec 04             	sub    $0x4,%esp
c01011d5:	68 00 0f 00 00       	push   $0xf00
c01011da:	52                   	push   %edx
c01011db:	50                   	push   %eax
c01011dc:	e8 b1 40 00 00       	call   c0105292 <memmove>
c01011e1:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011e4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011eb:	eb 15                	jmp    c0101202 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011ed:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011f5:	01 d2                	add    %edx,%edx
c01011f7:	01 d0                	add    %edx,%eax
c01011f9:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101202:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101209:	7e e2                	jle    c01011ed <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010120b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101212:	83 e8 50             	sub    $0x50,%eax
c0101215:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010121b:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101222:	0f b7 c0             	movzwl %ax,%eax
c0101225:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101229:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c010122d:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101231:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101235:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101236:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010123d:	66 c1 e8 08          	shr    $0x8,%ax
c0101241:	0f b6 c0             	movzbl %al,%eax
c0101244:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010124b:	83 c2 01             	add    $0x1,%edx
c010124e:	0f b7 d2             	movzwl %dx,%edx
c0101251:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101255:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101258:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010125c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101260:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101261:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101268:	0f b7 c0             	movzwl %ax,%eax
c010126b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010126f:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101273:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010127c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101283:	0f b6 c0             	movzbl %al,%eax
c0101286:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010128d:	83 c2 01             	add    $0x1,%edx
c0101290:	0f b7 d2             	movzwl %dx,%edx
c0101293:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101297:	88 45 eb             	mov    %al,-0x15(%ebp)
c010129a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010129e:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01012a2:	ee                   	out    %al,(%dx)
}
c01012a3:	90                   	nop
c01012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012a7:	c9                   	leave  
c01012a8:	c3                   	ret    

c01012a9 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012a9:	55                   	push   %ebp
c01012aa:	89 e5                	mov    %esp,%ebp
c01012ac:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012b6:	eb 09                	jmp    c01012c1 <serial_putc_sub+0x18>
        delay();
c01012b8:	e8 51 fb ff ff       	call   c0100e0e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012c1:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012c7:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012cb:	89 c2                	mov    %eax,%edx
c01012cd:	ec                   	in     (%dx),%al
c01012ce:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012d5:	0f b6 c0             	movzbl %al,%eax
c01012d8:	83 e0 20             	and    $0x20,%eax
c01012db:	85 c0                	test   %eax,%eax
c01012dd:	75 09                	jne    c01012e8 <serial_putc_sub+0x3f>
c01012df:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012e6:	7e d0                	jle    c01012b8 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012f4:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f7:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012fb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012ff:	ee                   	out    %al,(%dx)
}
c0101300:	90                   	nop
c0101301:	c9                   	leave  
c0101302:	c3                   	ret    

c0101303 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101303:	55                   	push   %ebp
c0101304:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101306:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010130a:	74 0d                	je     c0101319 <serial_putc+0x16>
        serial_putc_sub(c);
c010130c:	ff 75 08             	pushl  0x8(%ebp)
c010130f:	e8 95 ff ff ff       	call   c01012a9 <serial_putc_sub>
c0101314:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101317:	eb 1e                	jmp    c0101337 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101319:	6a 08                	push   $0x8
c010131b:	e8 89 ff ff ff       	call   c01012a9 <serial_putc_sub>
c0101320:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101323:	6a 20                	push   $0x20
c0101325:	e8 7f ff ff ff       	call   c01012a9 <serial_putc_sub>
c010132a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010132d:	6a 08                	push   $0x8
c010132f:	e8 75 ff ff ff       	call   c01012a9 <serial_putc_sub>
c0101334:	83 c4 04             	add    $0x4,%esp
    }
}
c0101337:	90                   	nop
c0101338:	c9                   	leave  
c0101339:	c3                   	ret    

c010133a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010133a:	55                   	push   %ebp
c010133b:	89 e5                	mov    %esp,%ebp
c010133d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101340:	eb 33                	jmp    c0101375 <cons_intr+0x3b>
        if (c != 0) {
c0101342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101346:	74 2d                	je     c0101375 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101348:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010134d:	8d 50 01             	lea    0x1(%eax),%edx
c0101350:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101356:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101359:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010135f:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101364:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101369:	75 0a                	jne    c0101375 <cons_intr+0x3b>
                cons.wpos = 0;
c010136b:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101372:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101375:	8b 45 08             	mov    0x8(%ebp),%eax
c0101378:	ff d0                	call   *%eax
c010137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010137d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101381:	75 bf                	jne    c0101342 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101383:	90                   	nop
c0101384:	c9                   	leave  
c0101385:	c3                   	ret    

c0101386 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101386:	55                   	push   %ebp
c0101387:	89 e5                	mov    %esp,%ebp
c0101389:	83 ec 10             	sub    $0x10,%esp
c010138c:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101392:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101396:	89 c2                	mov    %eax,%edx
c0101398:	ec                   	in     (%dx),%al
c0101399:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c010139c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013a0:	0f b6 c0             	movzbl %al,%eax
c01013a3:	83 e0 01             	and    $0x1,%eax
c01013a6:	85 c0                	test   %eax,%eax
c01013a8:	75 07                	jne    c01013b1 <serial_proc_data+0x2b>
        return -1;
c01013aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013af:	eb 2a                	jmp    c01013db <serial_proc_data+0x55>
c01013b1:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bb:	89 c2                	mov    %eax,%edx
c01013bd:	ec                   	in     (%dx),%al
c01013be:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c01013c1:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013c5:	0f b6 c0             	movzbl %al,%eax
c01013c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013cb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013cf:	75 07                	jne    c01013d8 <serial_proc_data+0x52>
        c = '\b';
c01013d1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013db:	c9                   	leave  
c01013dc:	c3                   	ret    

c01013dd <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013dd:	55                   	push   %ebp
c01013de:	89 e5                	mov    %esp,%ebp
c01013e0:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013e3:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013e8:	85 c0                	test   %eax,%eax
c01013ea:	74 10                	je     c01013fc <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013ec:	83 ec 0c             	sub    $0xc,%esp
c01013ef:	68 86 13 10 c0       	push   $0xc0101386
c01013f4:	e8 41 ff ff ff       	call   c010133a <cons_intr>
c01013f9:	83 c4 10             	add    $0x10,%esp
    }
}
c01013fc:	90                   	nop
c01013fd:	c9                   	leave  
c01013fe:	c3                   	ret    

c01013ff <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013ff:	55                   	push   %ebp
c0101400:	89 e5                	mov    %esp,%ebp
c0101402:	83 ec 18             	sub    $0x18,%esp
c0101405:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010140b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010140f:	89 c2                	mov    %eax,%edx
c0101411:	ec                   	in     (%dx),%al
c0101412:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101415:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101419:	0f b6 c0             	movzbl %al,%eax
c010141c:	83 e0 01             	and    $0x1,%eax
c010141f:	85 c0                	test   %eax,%eax
c0101421:	75 0a                	jne    c010142d <kbd_proc_data+0x2e>
        return -1;
c0101423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101428:	e9 5d 01 00 00       	jmp    c010158a <kbd_proc_data+0x18b>
c010142d:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101433:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101437:	89 c2                	mov    %eax,%edx
c0101439:	ec                   	in     (%dx),%al
c010143a:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c010143d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101441:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101444:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101448:	75 17                	jne    c0101461 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010144a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010144f:	83 c8 40             	or     $0x40,%eax
c0101452:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101457:	b8 00 00 00 00       	mov    $0x0,%eax
c010145c:	e9 29 01 00 00       	jmp    c010158a <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101461:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101465:	84 c0                	test   %al,%al
c0101467:	79 47                	jns    c01014b0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101469:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146e:	83 e0 40             	and    $0x40,%eax
c0101471:	85 c0                	test   %eax,%eax
c0101473:	75 09                	jne    c010147e <kbd_proc_data+0x7f>
c0101475:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101479:	83 e0 7f             	and    $0x7f,%eax
c010147c:	eb 04                	jmp    c0101482 <kbd_proc_data+0x83>
c010147e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101482:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101485:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101489:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101490:	83 c8 40             	or     $0x40,%eax
c0101493:	0f b6 c0             	movzbl %al,%eax
c0101496:	f7 d0                	not    %eax
c0101498:	89 c2                	mov    %eax,%edx
c010149a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010149f:	21 d0                	and    %edx,%eax
c01014a1:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014a6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ab:	e9 da 00 00 00       	jmp    c010158a <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c01014b0:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b5:	83 e0 40             	and    $0x40,%eax
c01014b8:	85 c0                	test   %eax,%eax
c01014ba:	74 11                	je     c01014cd <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014bc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014c0:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c5:	83 e0 bf             	and    $0xffffffbf,%eax
c01014c8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d1:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014d8:	0f b6 d0             	movzbl %al,%edx
c01014db:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e0:	09 d0                	or     %edx,%eax
c01014e2:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014eb:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014f2:	0f b6 d0             	movzbl %al,%edx
c01014f5:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fa:	31 d0                	xor    %edx,%eax
c01014fc:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101501:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101506:	83 e0 03             	and    $0x3,%eax
c0101509:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101514:	01 d0                	add    %edx,%eax
c0101516:	0f b6 00             	movzbl (%eax),%eax
c0101519:	0f b6 c0             	movzbl %al,%eax
c010151c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010151f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101524:	83 e0 08             	and    $0x8,%eax
c0101527:	85 c0                	test   %eax,%eax
c0101529:	74 22                	je     c010154d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010152b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010152f:	7e 0c                	jle    c010153d <kbd_proc_data+0x13e>
c0101531:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101535:	7f 06                	jg     c010153d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101537:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010153b:	eb 10                	jmp    c010154d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010153d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101541:	7e 0a                	jle    c010154d <kbd_proc_data+0x14e>
c0101543:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101547:	7f 04                	jg     c010154d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101549:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010154d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101552:	f7 d0                	not    %eax
c0101554:	83 e0 06             	and    $0x6,%eax
c0101557:	85 c0                	test   %eax,%eax
c0101559:	75 2c                	jne    c0101587 <kbd_proc_data+0x188>
c010155b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101562:	75 23                	jne    c0101587 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101564:	83 ec 0c             	sub    $0xc,%esp
c0101567:	68 31 5d 10 c0       	push   $0xc0105d31
c010156c:	e8 fe ec ff ff       	call   c010026f <cprintf>
c0101571:	83 c4 10             	add    $0x10,%esp
c0101574:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c010157a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010157e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101582:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101586:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101587:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010158a:	c9                   	leave  
c010158b:	c3                   	ret    

c010158c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010158c:	55                   	push   %ebp
c010158d:	89 e5                	mov    %esp,%ebp
c010158f:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101592:	83 ec 0c             	sub    $0xc,%esp
c0101595:	68 ff 13 10 c0       	push   $0xc01013ff
c010159a:	e8 9b fd ff ff       	call   c010133a <cons_intr>
c010159f:	83 c4 10             	add    $0x10,%esp
}
c01015a2:	90                   	nop
c01015a3:	c9                   	leave  
c01015a4:	c3                   	ret    

c01015a5 <kbd_init>:

static void
kbd_init(void) {
c01015a5:	55                   	push   %ebp
c01015a6:	89 e5                	mov    %esp,%ebp
c01015a8:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015ab:	e8 dc ff ff ff       	call   c010158c <kbd_intr>
    pic_enable(IRQ_KBD);
c01015b0:	83 ec 0c             	sub    $0xc,%esp
c01015b3:	6a 01                	push   $0x1
c01015b5:	e8 4b 01 00 00       	call   c0101705 <pic_enable>
c01015ba:	83 c4 10             	add    $0x10,%esp
}
c01015bd:	90                   	nop
c01015be:	c9                   	leave  
c01015bf:	c3                   	ret    

c01015c0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015c0:	55                   	push   %ebp
c01015c1:	89 e5                	mov    %esp,%ebp
c01015c3:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015c6:	e8 8c f8 ff ff       	call   c0100e57 <cga_init>
    serial_init();
c01015cb:	e8 6e f9 ff ff       	call   c0100f3e <serial_init>
    kbd_init();
c01015d0:	e8 d0 ff ff ff       	call   c01015a5 <kbd_init>
    if (!serial_exists) {
c01015d5:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015da:	85 c0                	test   %eax,%eax
c01015dc:	75 10                	jne    c01015ee <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015de:	83 ec 0c             	sub    $0xc,%esp
c01015e1:	68 3d 5d 10 c0       	push   $0xc0105d3d
c01015e6:	e8 84 ec ff ff       	call   c010026f <cprintf>
c01015eb:	83 c4 10             	add    $0x10,%esp
    }
}
c01015ee:	90                   	nop
c01015ef:	c9                   	leave  
c01015f0:	c3                   	ret    

c01015f1 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f1:	55                   	push   %ebp
c01015f2:	89 e5                	mov    %esp,%ebp
c01015f4:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015f7:	e8 d4 f7 ff ff       	call   c0100dd0 <__intr_save>
c01015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015ff:	83 ec 0c             	sub    $0xc,%esp
c0101602:	ff 75 08             	pushl  0x8(%ebp)
c0101605:	e8 93 fa ff ff       	call   c010109d <lpt_putc>
c010160a:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c010160d:	83 ec 0c             	sub    $0xc,%esp
c0101610:	ff 75 08             	pushl  0x8(%ebp)
c0101613:	e8 bc fa ff ff       	call   c01010d4 <cga_putc>
c0101618:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010161b:	83 ec 0c             	sub    $0xc,%esp
c010161e:	ff 75 08             	pushl  0x8(%ebp)
c0101621:	e8 dd fc ff ff       	call   c0101303 <serial_putc>
c0101626:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101629:	83 ec 0c             	sub    $0xc,%esp
c010162c:	ff 75 f4             	pushl  -0xc(%ebp)
c010162f:	e8 c6 f7 ff ff       	call   c0100dfa <__intr_restore>
c0101634:	83 c4 10             	add    $0x10,%esp
}
c0101637:	90                   	nop
c0101638:	c9                   	leave  
c0101639:	c3                   	ret    

c010163a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163a:	55                   	push   %ebp
c010163b:	89 e5                	mov    %esp,%ebp
c010163d:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101647:	e8 84 f7 ff ff       	call   c0100dd0 <__intr_save>
c010164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010164f:	e8 89 fd ff ff       	call   c01013dd <serial_intr>
        kbd_intr();
c0101654:	e8 33 ff ff ff       	call   c010158c <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101659:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010165f:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101664:	39 c2                	cmp    %eax,%edx
c0101666:	74 31                	je     c0101699 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101668:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166d:	8d 50 01             	lea    0x1(%eax),%edx
c0101670:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101676:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010167d:	0f b6 c0             	movzbl %al,%eax
c0101680:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101683:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101688:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168d:	75 0a                	jne    c0101699 <cons_getc+0x5f>
                cons.rpos = 0;
c010168f:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101696:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101699:	83 ec 0c             	sub    $0xc,%esp
c010169c:	ff 75 f0             	pushl  -0x10(%ebp)
c010169f:	e8 56 f7 ff ff       	call   c0100dfa <__intr_restore>
c01016a4:	83 c4 10             	add    $0x10,%esp
    return c;
c01016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016aa:	c9                   	leave  
c01016ab:	c3                   	ret    

c01016ac <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ac:	55                   	push   %ebp
c01016ad:	89 e5                	mov    %esp,%ebp
c01016af:	83 ec 14             	sub    $0x14,%esp
c01016b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016b9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016bd:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c3:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016c8:	85 c0                	test   %eax,%eax
c01016ca:	74 36                	je     c0101702 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d0:	0f b6 c0             	movzbl %al,%eax
c01016d3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016d9:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016dc:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016e0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e4:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e9:	66 c1 e8 08          	shr    $0x8,%ax
c01016ed:	0f b6 c0             	movzbl %al,%eax
c01016f0:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016f6:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016f9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016fd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101701:	ee                   	out    %al,(%dx)
    }
}
c0101702:	90                   	nop
c0101703:	c9                   	leave  
c0101704:	c3                   	ret    

c0101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101705:	55                   	push   %ebp
c0101706:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c0101708:	8b 45 08             	mov    0x8(%ebp),%eax
c010170b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101710:	89 c1                	mov    %eax,%ecx
c0101712:	d3 e2                	shl    %cl,%edx
c0101714:	89 d0                	mov    %edx,%eax
c0101716:	f7 d0                	not    %eax
c0101718:	89 c2                	mov    %eax,%edx
c010171a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101721:	21 d0                	and    %edx,%eax
c0101723:	0f b7 c0             	movzwl %ax,%eax
c0101726:	50                   	push   %eax
c0101727:	e8 80 ff ff ff       	call   c01016ac <pic_setmask>
c010172c:	83 c4 04             	add    $0x4,%esp
}
c010172f:	90                   	nop
c0101730:	c9                   	leave  
c0101731:	c3                   	ret    

c0101732 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101732:	55                   	push   %ebp
c0101733:	89 e5                	mov    %esp,%ebp
c0101735:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101738:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c010173f:	00 00 00 
c0101742:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101748:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c010174c:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101750:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101754:	ee                   	out    %al,(%dx)
c0101755:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c010175b:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c010175f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101763:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101767:	ee                   	out    %al,(%dx)
c0101768:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c010176e:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101772:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101776:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010177a:	ee                   	out    %al,(%dx)
c010177b:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0101781:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101785:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101789:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010178d:	ee                   	out    %al,(%dx)
c010178e:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0101794:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101798:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c010179c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017a0:	ee                   	out    %al,(%dx)
c01017a1:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c01017a7:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01017ab:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01017af:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01017b3:	ee                   	out    %al,(%dx)
c01017b4:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c01017ba:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c01017be:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017c2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017c6:	ee                   	out    %al,(%dx)
c01017c7:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017cd:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017d1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017d5:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017d9:	ee                   	out    %al,(%dx)
c01017da:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017e0:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017e4:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017e8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ec:	ee                   	out    %al,(%dx)
c01017ed:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017f3:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017f7:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017fb:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017ff:	ee                   	out    %al,(%dx)
c0101800:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c0101806:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c010180a:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c010180e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101812:	ee                   	out    %al,(%dx)
c0101813:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0101819:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c010181d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101821:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101825:	ee                   	out    %al,(%dx)
c0101826:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010182c:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c0101830:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c0101834:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101838:	ee                   	out    %al,(%dx)
c0101839:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c010183f:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c0101843:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101847:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c010184b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184c:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101853:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101857:	74 13                	je     c010186c <pic_init+0x13a>
        pic_setmask(irq_mask);
c0101859:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101860:	0f b7 c0             	movzwl %ax,%eax
c0101863:	50                   	push   %eax
c0101864:	e8 43 fe ff ff       	call   c01016ac <pic_setmask>
c0101869:	83 c4 04             	add    $0x4,%esp
    }
}
c010186c:	90                   	nop
c010186d:	c9                   	leave  
c010186e:	c3                   	ret    

c010186f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010186f:	55                   	push   %ebp
c0101870:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101872:	fb                   	sti    
    sti();
}
c0101873:	90                   	nop
c0101874:	5d                   	pop    %ebp
c0101875:	c3                   	ret    

c0101876 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101876:	55                   	push   %ebp
c0101877:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101879:	fa                   	cli    
    cli();
}
c010187a:	90                   	nop
c010187b:	5d                   	pop    %ebp
c010187c:	c3                   	ret    

c010187d <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010187d:	55                   	push   %ebp
c010187e:	89 e5                	mov    %esp,%ebp
c0101880:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101883:	83 ec 08             	sub    $0x8,%esp
c0101886:	6a 64                	push   $0x64
c0101888:	68 60 5d 10 c0       	push   $0xc0105d60
c010188d:	e8 dd e9 ff ff       	call   c010026f <cprintf>
c0101892:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101895:	90                   	nop
c0101896:	c9                   	leave  
c0101897:	c3                   	ret    

c0101898 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101898:	55                   	push   %ebp
c0101899:	89 e5                	mov    %esp,%ebp
c010189b:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c010189e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018a5:	e9 c3 00 00 00       	jmp    c010196d <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ad:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018b4:	89 c2                	mov    %eax,%edx
c01018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b9:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018c0:	c0 
c01018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c4:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018cb:	c0 08 00 
c01018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d1:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018d8:	c0 
c01018d9:	83 e2 e0             	and    $0xffffffe0,%edx
c01018dc:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e6:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018ed:	c0 
c01018ee:	83 e2 1f             	and    $0x1f,%edx
c01018f1:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fb:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101902:	c0 
c0101903:	83 e2 f0             	and    $0xfffffff0,%edx
c0101906:	83 ca 0e             	or     $0xe,%edx
c0101909:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101913:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010191a:	c0 
c010191b:	83 e2 ef             	and    $0xffffffef,%edx
c010191e:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101925:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101928:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010192f:	c0 
c0101930:	83 e2 9f             	and    $0xffffff9f,%edx
c0101933:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193d:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101944:	c0 
c0101945:	83 ca 80             	or     $0xffffff80,%edx
c0101948:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101952:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101959:	c1 e8 10             	shr    $0x10,%eax
c010195c:	89 c2                	mov    %eax,%edx
c010195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101961:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101968:	c0 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c0101969:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010196d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101974:	0f 8e 30 ff ff ff    	jle    c01018aa <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010197a:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c010197f:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c0101985:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c010198c:	08 00 
c010198e:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101995:	83 e0 e0             	and    $0xffffffe0,%eax
c0101998:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c010199d:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019a4:	83 e0 1f             	and    $0x1f,%eax
c01019a7:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019ac:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019b3:	83 e0 f0             	and    $0xfffffff0,%eax
c01019b6:	83 c8 0e             	or     $0xe,%eax
c01019b9:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019be:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019c5:	83 e0 ef             	and    $0xffffffef,%eax
c01019c8:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019cd:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d4:	83 c8 60             	or     $0x60,%eax
c01019d7:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019dc:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019e3:	83 c8 80             	or     $0xffffff80,%eax
c01019e6:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019eb:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019f0:	c1 e8 10             	shr    $0x10,%eax
c01019f3:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019f9:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a00:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a03:	0f 01 18             	lidtl  (%eax)

    // 3. LIDT
    lidt(&idt_pd);
}
c0101a06:	90                   	nop
c0101a07:	c9                   	leave  
c0101a08:	c3                   	ret    

c0101a09 <trapname>:

static const char *
trapname(int trapno) {
c0101a09:	55                   	push   %ebp
c0101a0a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0f:	83 f8 13             	cmp    $0x13,%eax
c0101a12:	77 0c                	ja     c0101a20 <trapname+0x17>
        return excnames[trapno];
c0101a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a17:	8b 04 85 c0 60 10 c0 	mov    -0x3fef9f40(,%eax,4),%eax
c0101a1e:	eb 18                	jmp    c0101a38 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a20:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a24:	7e 0d                	jle    c0101a33 <trapname+0x2a>
c0101a26:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a2a:	7f 07                	jg     c0101a33 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a2c:	b8 6a 5d 10 c0       	mov    $0xc0105d6a,%eax
c0101a31:	eb 05                	jmp    c0101a38 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a33:	b8 7d 5d 10 c0       	mov    $0xc0105d7d,%eax
}
c0101a38:	5d                   	pop    %ebp
c0101a39:	c3                   	ret    

c0101a3a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a3a:	55                   	push   %ebp
c0101a3b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a40:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a44:	66 83 f8 08          	cmp    $0x8,%ax
c0101a48:	0f 94 c0             	sete   %al
c0101a4b:	0f b6 c0             	movzbl %al,%eax
}
c0101a4e:	5d                   	pop    %ebp
c0101a4f:	c3                   	ret    

c0101a50 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a50:	55                   	push   %ebp
c0101a51:	89 e5                	mov    %esp,%ebp
c0101a53:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a56:	83 ec 08             	sub    $0x8,%esp
c0101a59:	ff 75 08             	pushl  0x8(%ebp)
c0101a5c:	68 be 5d 10 c0       	push   $0xc0105dbe
c0101a61:	e8 09 e8 ff ff       	call   c010026f <cprintf>
c0101a66:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6c:	83 ec 0c             	sub    $0xc,%esp
c0101a6f:	50                   	push   %eax
c0101a70:	e8 b8 01 00 00       	call   c0101c2d <print_regs>
c0101a75:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a7f:	0f b7 c0             	movzwl %ax,%eax
c0101a82:	83 ec 08             	sub    $0x8,%esp
c0101a85:	50                   	push   %eax
c0101a86:	68 cf 5d 10 c0       	push   $0xc0105dcf
c0101a8b:	e8 df e7 ff ff       	call   c010026f <cprintf>
c0101a90:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a96:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a9a:	0f b7 c0             	movzwl %ax,%eax
c0101a9d:	83 ec 08             	sub    $0x8,%esp
c0101aa0:	50                   	push   %eax
c0101aa1:	68 e2 5d 10 c0       	push   $0xc0105de2
c0101aa6:	e8 c4 e7 ff ff       	call   c010026f <cprintf>
c0101aab:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ab5:	0f b7 c0             	movzwl %ax,%eax
c0101ab8:	83 ec 08             	sub    $0x8,%esp
c0101abb:	50                   	push   %eax
c0101abc:	68 f5 5d 10 c0       	push   $0xc0105df5
c0101ac1:	e8 a9 e7 ff ff       	call   c010026f <cprintf>
c0101ac6:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ad0:	0f b7 c0             	movzwl %ax,%eax
c0101ad3:	83 ec 08             	sub    $0x8,%esp
c0101ad6:	50                   	push   %eax
c0101ad7:	68 08 5e 10 c0       	push   $0xc0105e08
c0101adc:	e8 8e e7 ff ff       	call   c010026f <cprintf>
c0101ae1:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae7:	8b 40 30             	mov    0x30(%eax),%eax
c0101aea:	83 ec 0c             	sub    $0xc,%esp
c0101aed:	50                   	push   %eax
c0101aee:	e8 16 ff ff ff       	call   c0101a09 <trapname>
c0101af3:	83 c4 10             	add    $0x10,%esp
c0101af6:	89 c2                	mov    %eax,%edx
c0101af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afb:	8b 40 30             	mov    0x30(%eax),%eax
c0101afe:	83 ec 04             	sub    $0x4,%esp
c0101b01:	52                   	push   %edx
c0101b02:	50                   	push   %eax
c0101b03:	68 1b 5e 10 c0       	push   $0xc0105e1b
c0101b08:	e8 62 e7 ff ff       	call   c010026f <cprintf>
c0101b0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b13:	8b 40 34             	mov    0x34(%eax),%eax
c0101b16:	83 ec 08             	sub    $0x8,%esp
c0101b19:	50                   	push   %eax
c0101b1a:	68 2d 5e 10 c0       	push   $0xc0105e2d
c0101b1f:	e8 4b e7 ff ff       	call   c010026f <cprintf>
c0101b24:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2a:	8b 40 38             	mov    0x38(%eax),%eax
c0101b2d:	83 ec 08             	sub    $0x8,%esp
c0101b30:	50                   	push   %eax
c0101b31:	68 3c 5e 10 c0       	push   $0xc0105e3c
c0101b36:	e8 34 e7 ff ff       	call   c010026f <cprintf>
c0101b3b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b45:	0f b7 c0             	movzwl %ax,%eax
c0101b48:	83 ec 08             	sub    $0x8,%esp
c0101b4b:	50                   	push   %eax
c0101b4c:	68 4b 5e 10 c0       	push   $0xc0105e4b
c0101b51:	e8 19 e7 ff ff       	call   c010026f <cprintf>
c0101b56:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5c:	8b 40 40             	mov    0x40(%eax),%eax
c0101b5f:	83 ec 08             	sub    $0x8,%esp
c0101b62:	50                   	push   %eax
c0101b63:	68 5e 5e 10 c0       	push   $0xc0105e5e
c0101b68:	e8 02 e7 ff ff       	call   c010026f <cprintf>
c0101b6d:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b7e:	eb 3f                	jmp    c0101bbf <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b83:	8b 50 40             	mov    0x40(%eax),%edx
c0101b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b89:	21 d0                	and    %edx,%eax
c0101b8b:	85 c0                	test   %eax,%eax
c0101b8d:	74 29                	je     c0101bb8 <print_trapframe+0x168>
c0101b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b92:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b99:	85 c0                	test   %eax,%eax
c0101b9b:	74 1b                	je     c0101bb8 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba0:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101ba7:	83 ec 08             	sub    $0x8,%esp
c0101baa:	50                   	push   %eax
c0101bab:	68 6d 5e 10 c0       	push   $0xc0105e6d
c0101bb0:	e8 ba e6 ff ff       	call   c010026f <cprintf>
c0101bb5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bb8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bbc:	d1 65 f0             	shll   -0x10(%ebp)
c0101bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc2:	83 f8 17             	cmp    $0x17,%eax
c0101bc5:	76 b9                	jbe    c0101b80 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bca:	8b 40 40             	mov    0x40(%eax),%eax
c0101bcd:	25 00 30 00 00       	and    $0x3000,%eax
c0101bd2:	c1 e8 0c             	shr    $0xc,%eax
c0101bd5:	83 ec 08             	sub    $0x8,%esp
c0101bd8:	50                   	push   %eax
c0101bd9:	68 71 5e 10 c0       	push   $0xc0105e71
c0101bde:	e8 8c e6 ff ff       	call   c010026f <cprintf>
c0101be3:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101be6:	83 ec 0c             	sub    $0xc,%esp
c0101be9:	ff 75 08             	pushl  0x8(%ebp)
c0101bec:	e8 49 fe ff ff       	call   c0101a3a <trap_in_kernel>
c0101bf1:	83 c4 10             	add    $0x10,%esp
c0101bf4:	85 c0                	test   %eax,%eax
c0101bf6:	75 32                	jne    c0101c2a <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfb:	8b 40 44             	mov    0x44(%eax),%eax
c0101bfe:	83 ec 08             	sub    $0x8,%esp
c0101c01:	50                   	push   %eax
c0101c02:	68 7a 5e 10 c0       	push   $0xc0105e7a
c0101c07:	e8 63 e6 ff ff       	call   c010026f <cprintf>
c0101c0c:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c12:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c16:	0f b7 c0             	movzwl %ax,%eax
c0101c19:	83 ec 08             	sub    $0x8,%esp
c0101c1c:	50                   	push   %eax
c0101c1d:	68 89 5e 10 c0       	push   $0xc0105e89
c0101c22:	e8 48 e6 ff ff       	call   c010026f <cprintf>
c0101c27:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c2a:	90                   	nop
c0101c2b:	c9                   	leave  
c0101c2c:	c3                   	ret    

c0101c2d <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c2d:	55                   	push   %ebp
c0101c2e:	89 e5                	mov    %esp,%ebp
c0101c30:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c36:	8b 00                	mov    (%eax),%eax
c0101c38:	83 ec 08             	sub    $0x8,%esp
c0101c3b:	50                   	push   %eax
c0101c3c:	68 9c 5e 10 c0       	push   $0xc0105e9c
c0101c41:	e8 29 e6 ff ff       	call   c010026f <cprintf>
c0101c46:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	8b 40 04             	mov    0x4(%eax),%eax
c0101c4f:	83 ec 08             	sub    $0x8,%esp
c0101c52:	50                   	push   %eax
c0101c53:	68 ab 5e 10 c0       	push   $0xc0105eab
c0101c58:	e8 12 e6 ff ff       	call   c010026f <cprintf>
c0101c5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	8b 40 08             	mov    0x8(%eax),%eax
c0101c66:	83 ec 08             	sub    $0x8,%esp
c0101c69:	50                   	push   %eax
c0101c6a:	68 ba 5e 10 c0       	push   $0xc0105eba
c0101c6f:	e8 fb e5 ff ff       	call   c010026f <cprintf>
c0101c74:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c7d:	83 ec 08             	sub    $0x8,%esp
c0101c80:	50                   	push   %eax
c0101c81:	68 c9 5e 10 c0       	push   $0xc0105ec9
c0101c86:	e8 e4 e5 ff ff       	call   c010026f <cprintf>
c0101c8b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 10             	mov    0x10(%eax),%eax
c0101c94:	83 ec 08             	sub    $0x8,%esp
c0101c97:	50                   	push   %eax
c0101c98:	68 d8 5e 10 c0       	push   $0xc0105ed8
c0101c9d:	e8 cd e5 ff ff       	call   c010026f <cprintf>
c0101ca2:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca8:	8b 40 14             	mov    0x14(%eax),%eax
c0101cab:	83 ec 08             	sub    $0x8,%esp
c0101cae:	50                   	push   %eax
c0101caf:	68 e7 5e 10 c0       	push   $0xc0105ee7
c0101cb4:	e8 b6 e5 ff ff       	call   c010026f <cprintf>
c0101cb9:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbf:	8b 40 18             	mov    0x18(%eax),%eax
c0101cc2:	83 ec 08             	sub    $0x8,%esp
c0101cc5:	50                   	push   %eax
c0101cc6:	68 f6 5e 10 c0       	push   $0xc0105ef6
c0101ccb:	e8 9f e5 ff ff       	call   c010026f <cprintf>
c0101cd0:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd6:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cd9:	83 ec 08             	sub    $0x8,%esp
c0101cdc:	50                   	push   %eax
c0101cdd:	68 05 5f 10 c0       	push   $0xc0105f05
c0101ce2:	e8 88 e5 ff ff       	call   c010026f <cprintf>
c0101ce7:	83 c4 10             	add    $0x10,%esp
}
c0101cea:	90                   	nop
c0101ceb:	c9                   	leave  
c0101cec:	c3                   	ret    

c0101ced <trap_dispatch>:
/* LAB1: temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ced:	55                   	push   %ebp
c0101cee:	89 e5                	mov    %esp,%ebp
c0101cf0:	57                   	push   %edi
c0101cf1:	56                   	push   %esi
c0101cf2:	53                   	push   %ebx
c0101cf3:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf9:	8b 40 30             	mov    0x30(%eax),%eax
c0101cfc:	83 f8 2f             	cmp    $0x2f,%eax
c0101cff:	77 21                	ja     c0101d22 <trap_dispatch+0x35>
c0101d01:	83 f8 2e             	cmp    $0x2e,%eax
c0101d04:	0f 83 90 01 00 00    	jae    c0101e9a <trap_dispatch+0x1ad>
c0101d0a:	83 f8 21             	cmp    $0x21,%eax
c0101d0d:	0f 84 87 00 00 00    	je     c0101d9a <trap_dispatch+0xad>
c0101d13:	83 f8 24             	cmp    $0x24,%eax
c0101d16:	74 5b                	je     c0101d73 <trap_dispatch+0x86>
c0101d18:	83 f8 20             	cmp    $0x20,%eax
c0101d1b:	74 1c                	je     c0101d39 <trap_dispatch+0x4c>
c0101d1d:	e9 42 01 00 00       	jmp    c0101e64 <trap_dispatch+0x177>
c0101d22:	83 f8 78             	cmp    $0x78,%eax
c0101d25:	0f 84 96 00 00 00    	je     c0101dc1 <trap_dispatch+0xd4>
c0101d2b:	83 f8 79             	cmp    $0x79,%eax
c0101d2e:	0f 84 02 01 00 00    	je     c0101e36 <trap_dispatch+0x149>
c0101d34:	e9 2b 01 00 00       	jmp    c0101e64 <trap_dispatch+0x177>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
c0101d39:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d3e:	83 c0 01             	add    $0x1,%eax
c0101d41:	a3 4c 89 11 c0       	mov    %eax,0xc011894c

        // 2. print
        if (ticks % TICK_NUM == 0) {
c0101d46:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d4c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d51:	89 c8                	mov    %ecx,%eax
c0101d53:	f7 e2                	mul    %edx
c0101d55:	89 d0                	mov    %edx,%eax
c0101d57:	c1 e8 05             	shr    $0x5,%eax
c0101d5a:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d5d:	29 c1                	sub    %eax,%ecx
c0101d5f:	89 c8                	mov    %ecx,%eax
c0101d61:	85 c0                	test   %eax,%eax
c0101d63:	0f 85 34 01 00 00    	jne    c0101e9d <trap_dispatch+0x1b0>
            print_ticks();
c0101d69:	e8 0f fb ff ff       	call   c010187d <print_ticks>
        }

        // 3. too simple ?!
        break;
c0101d6e:	e9 2a 01 00 00       	jmp    c0101e9d <trap_dispatch+0x1b0>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d73:	e8 c2 f8 ff ff       	call   c010163a <cons_getc>
c0101d78:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d7b:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d7f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d83:	83 ec 04             	sub    $0x4,%esp
c0101d86:	52                   	push   %edx
c0101d87:	50                   	push   %eax
c0101d88:	68 14 5f 10 c0       	push   $0xc0105f14
c0101d8d:	e8 dd e4 ff ff       	call   c010026f <cprintf>
c0101d92:	83 c4 10             	add    $0x10,%esp
        break;
c0101d95:	e9 04 01 00 00       	jmp    c0101e9e <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d9a:	e8 9b f8 ff ff       	call   c010163a <cons_getc>
c0101d9f:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101da2:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101da6:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101daa:	83 ec 04             	sub    $0x4,%esp
c0101dad:	52                   	push   %edx
c0101dae:	50                   	push   %eax
c0101daf:	68 26 5f 10 c0       	push   $0xc0105f26
c0101db4:	e8 b6 e4 ff ff       	call   c010026f <cprintf>
c0101db9:	83 c4 10             	add    $0x10,%esp
        break;
c0101dbc:	e9 dd 00 00 00       	jmp    c0101e9e <trap_dispatch+0x1b1>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
c0101dc1:	8b 55 08             	mov    0x8(%ebp),%edx
c0101dc4:	b8 60 89 11 c0       	mov    $0xc0118960,%eax
c0101dc9:	89 d3                	mov    %edx,%ebx
c0101dcb:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0101dd0:	8b 0b                	mov    (%ebx),%ecx
c0101dd2:	89 08                	mov    %ecx,(%eax)
c0101dd4:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c0101dd8:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0101ddc:	8d 78 04             	lea    0x4(%eax),%edi
c0101ddf:	83 e7 fc             	and    $0xfffffffc,%edi
c0101de2:	29 f8                	sub    %edi,%eax
c0101de4:	29 c3                	sub    %eax,%ebx
c0101de6:	01 c2                	add    %eax,%edx
c0101de8:	83 e2 fc             	and    $0xfffffffc,%edx
c0101deb:	89 d0                	mov    %edx,%eax
c0101ded:	c1 e8 02             	shr    $0x2,%eax
c0101df0:	89 de                	mov    %ebx,%esi
c0101df2:	89 c1                	mov    %eax,%ecx
c0101df4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
c0101df6:	66 c7 05 9c 89 11 c0 	movw   $0x1b,0xc011899c
c0101dfd:	1b 00 
        switchk2u.tf_ds = USER_DS;
c0101dff:	66 c7 05 8c 89 11 c0 	movw   $0x23,0xc011898c
c0101e06:	23 00 
        switchk2u.tf_es = USER_DS;
c0101e08:	66 c7 05 88 89 11 c0 	movw   $0x23,0xc0118988
c0101e0f:	23 00 
        switchk2u.tf_ss = USER_DS;
c0101e11:	66 c7 05 a8 89 11 c0 	movw   $0x23,0xc01189a8
c0101e18:	23 00 

        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101e1a:	a1 a0 89 11 c0       	mov    0xc01189a0,%eax
c0101e1f:	80 cc 30             	or     $0x30,%ah
c0101e22:	a3 a0 89 11 c0       	mov    %eax,0xc01189a0
        // set trap frame pointer
        // tf is the pointer to the pointer of trap frame (a structure)
        // tf = esp, while esp -> esp - 1 (*trap_frame) due to `pushl %esp`
        // so *(tf - 1) is the pointer to trap frame
        // change *trap_frame to point to the new frame
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101e27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e2a:	83 e8 04             	sub    $0x4,%eax
c0101e2d:	ba 60 89 11 c0       	mov    $0xc0118960,%edx
c0101e32:	89 10                	mov    %edx,(%eax)
        break;
c0101e34:	eb 68                	jmp    c0101e9e <trap_dispatch+0x1b1>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
c0101e36:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e39:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c0101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e42:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c0101e48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4b:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)

        // restore eflags
        tf->tf_eflags &= ~FL_IOPL_MASK;
c0101e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e54:	8b 40 40             	mov    0x40(%eax),%eax
c0101e57:	80 e4 cf             	and    $0xcf,%ah
c0101e5a:	89 c2                	mov    %eax,%edx
c0101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5f:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c0101e62:	eb 3a                	jmp    c0101e9e <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e67:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e6b:	0f b7 c0             	movzwl %ax,%eax
c0101e6e:	83 e0 03             	and    $0x3,%eax
c0101e71:	85 c0                	test   %eax,%eax
c0101e73:	75 29                	jne    c0101e9e <trap_dispatch+0x1b1>
            print_trapframe(tf);
c0101e75:	83 ec 0c             	sub    $0xc,%esp
c0101e78:	ff 75 08             	pushl  0x8(%ebp)
c0101e7b:	e8 d0 fb ff ff       	call   c0101a50 <print_trapframe>
c0101e80:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101e83:	83 ec 04             	sub    $0x4,%esp
c0101e86:	68 35 5f 10 c0       	push   $0xc0105f35
c0101e8b:	68 dc 00 00 00       	push   $0xdc
c0101e90:	68 51 5f 10 c0       	push   $0xc0105f51
c0101e95:	e8 3b e5 ff ff       	call   c01003d5 <__panic>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e9a:	90                   	nop
c0101e9b:	eb 01                	jmp    c0101e9e <trap_dispatch+0x1b1>
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }

        // 3. too simple ?!
        break;
c0101e9d:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e9e:	90                   	nop
c0101e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0101ea2:	5b                   	pop    %ebx
c0101ea3:	5e                   	pop    %esi
c0101ea4:	5f                   	pop    %edi
c0101ea5:	5d                   	pop    %ebp
c0101ea6:	c3                   	ret    

c0101ea7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101ea7:	55                   	push   %ebp
c0101ea8:	89 e5                	mov    %esp,%ebp
c0101eaa:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ead:	83 ec 0c             	sub    $0xc,%esp
c0101eb0:	ff 75 08             	pushl  0x8(%ebp)
c0101eb3:	e8 35 fe ff ff       	call   c0101ced <trap_dispatch>
c0101eb8:	83 c4 10             	add    $0x10,%esp
}
c0101ebb:	90                   	nop
c0101ebc:	c9                   	leave  
c0101ebd:	c3                   	ret    

c0101ebe <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101ebe:	6a 00                	push   $0x0
  pushl $0
c0101ec0:	6a 00                	push   $0x0
  jmp __alltraps
c0101ec2:	e9 69 0a 00 00       	jmp    c0102930 <__alltraps>

c0101ec7 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ec7:	6a 00                	push   $0x0
  pushl $1
c0101ec9:	6a 01                	push   $0x1
  jmp __alltraps
c0101ecb:	e9 60 0a 00 00       	jmp    c0102930 <__alltraps>

c0101ed0 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ed0:	6a 00                	push   $0x0
  pushl $2
c0101ed2:	6a 02                	push   $0x2
  jmp __alltraps
c0101ed4:	e9 57 0a 00 00       	jmp    c0102930 <__alltraps>

c0101ed9 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ed9:	6a 00                	push   $0x0
  pushl $3
c0101edb:	6a 03                	push   $0x3
  jmp __alltraps
c0101edd:	e9 4e 0a 00 00       	jmp    c0102930 <__alltraps>

c0101ee2 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ee2:	6a 00                	push   $0x0
  pushl $4
c0101ee4:	6a 04                	push   $0x4
  jmp __alltraps
c0101ee6:	e9 45 0a 00 00       	jmp    c0102930 <__alltraps>

c0101eeb <vector5>:
.globl vector5
vector5:
  pushl $0
c0101eeb:	6a 00                	push   $0x0
  pushl $5
c0101eed:	6a 05                	push   $0x5
  jmp __alltraps
c0101eef:	e9 3c 0a 00 00       	jmp    c0102930 <__alltraps>

c0101ef4 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101ef4:	6a 00                	push   $0x0
  pushl $6
c0101ef6:	6a 06                	push   $0x6
  jmp __alltraps
c0101ef8:	e9 33 0a 00 00       	jmp    c0102930 <__alltraps>

c0101efd <vector7>:
.globl vector7
vector7:
  pushl $0
c0101efd:	6a 00                	push   $0x0
  pushl $7
c0101eff:	6a 07                	push   $0x7
  jmp __alltraps
c0101f01:	e9 2a 0a 00 00       	jmp    c0102930 <__alltraps>

c0101f06 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f06:	6a 08                	push   $0x8
  jmp __alltraps
c0101f08:	e9 23 0a 00 00       	jmp    c0102930 <__alltraps>

c0101f0d <vector9>:
.globl vector9
vector9:
  pushl $0
c0101f0d:	6a 00                	push   $0x0
  pushl $9
c0101f0f:	6a 09                	push   $0x9
  jmp __alltraps
c0101f11:	e9 1a 0a 00 00       	jmp    c0102930 <__alltraps>

c0101f16 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f16:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f18:	e9 13 0a 00 00       	jmp    c0102930 <__alltraps>

c0101f1d <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f1d:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f1f:	e9 0c 0a 00 00       	jmp    c0102930 <__alltraps>

c0101f24 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f24:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f26:	e9 05 0a 00 00       	jmp    c0102930 <__alltraps>

c0101f2b <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f2b:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f2d:	e9 fe 09 00 00       	jmp    c0102930 <__alltraps>

c0101f32 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f32:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f34:	e9 f7 09 00 00       	jmp    c0102930 <__alltraps>

c0101f39 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f39:	6a 00                	push   $0x0
  pushl $15
c0101f3b:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f3d:	e9 ee 09 00 00       	jmp    c0102930 <__alltraps>

c0101f42 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f42:	6a 00                	push   $0x0
  pushl $16
c0101f44:	6a 10                	push   $0x10
  jmp __alltraps
c0101f46:	e9 e5 09 00 00       	jmp    c0102930 <__alltraps>

c0101f4b <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f4b:	6a 11                	push   $0x11
  jmp __alltraps
c0101f4d:	e9 de 09 00 00       	jmp    c0102930 <__alltraps>

c0101f52 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $18
c0101f54:	6a 12                	push   $0x12
  jmp __alltraps
c0101f56:	e9 d5 09 00 00       	jmp    c0102930 <__alltraps>

c0101f5b <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $19
c0101f5d:	6a 13                	push   $0x13
  jmp __alltraps
c0101f5f:	e9 cc 09 00 00       	jmp    c0102930 <__alltraps>

c0101f64 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $20
c0101f66:	6a 14                	push   $0x14
  jmp __alltraps
c0101f68:	e9 c3 09 00 00       	jmp    c0102930 <__alltraps>

c0101f6d <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $21
c0101f6f:	6a 15                	push   $0x15
  jmp __alltraps
c0101f71:	e9 ba 09 00 00       	jmp    c0102930 <__alltraps>

c0101f76 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $22
c0101f78:	6a 16                	push   $0x16
  jmp __alltraps
c0101f7a:	e9 b1 09 00 00       	jmp    c0102930 <__alltraps>

c0101f7f <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $23
c0101f81:	6a 17                	push   $0x17
  jmp __alltraps
c0101f83:	e9 a8 09 00 00       	jmp    c0102930 <__alltraps>

c0101f88 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $24
c0101f8a:	6a 18                	push   $0x18
  jmp __alltraps
c0101f8c:	e9 9f 09 00 00       	jmp    c0102930 <__alltraps>

c0101f91 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $25
c0101f93:	6a 19                	push   $0x19
  jmp __alltraps
c0101f95:	e9 96 09 00 00       	jmp    c0102930 <__alltraps>

c0101f9a <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $26
c0101f9c:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f9e:	e9 8d 09 00 00       	jmp    c0102930 <__alltraps>

c0101fa3 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $27
c0101fa5:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fa7:	e9 84 09 00 00       	jmp    c0102930 <__alltraps>

c0101fac <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $28
c0101fae:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fb0:	e9 7b 09 00 00       	jmp    c0102930 <__alltraps>

c0101fb5 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $29
c0101fb7:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fb9:	e9 72 09 00 00       	jmp    c0102930 <__alltraps>

c0101fbe <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $30
c0101fc0:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fc2:	e9 69 09 00 00       	jmp    c0102930 <__alltraps>

c0101fc7 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $31
c0101fc9:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101fcb:	e9 60 09 00 00       	jmp    c0102930 <__alltraps>

c0101fd0 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $32
c0101fd2:	6a 20                	push   $0x20
  jmp __alltraps
c0101fd4:	e9 57 09 00 00       	jmp    c0102930 <__alltraps>

c0101fd9 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $33
c0101fdb:	6a 21                	push   $0x21
  jmp __alltraps
c0101fdd:	e9 4e 09 00 00       	jmp    c0102930 <__alltraps>

c0101fe2 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $34
c0101fe4:	6a 22                	push   $0x22
  jmp __alltraps
c0101fe6:	e9 45 09 00 00       	jmp    c0102930 <__alltraps>

c0101feb <vector35>:
.globl vector35
vector35:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $35
c0101fed:	6a 23                	push   $0x23
  jmp __alltraps
c0101fef:	e9 3c 09 00 00       	jmp    c0102930 <__alltraps>

c0101ff4 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $36
c0101ff6:	6a 24                	push   $0x24
  jmp __alltraps
c0101ff8:	e9 33 09 00 00       	jmp    c0102930 <__alltraps>

c0101ffd <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $37
c0101fff:	6a 25                	push   $0x25
  jmp __alltraps
c0102001:	e9 2a 09 00 00       	jmp    c0102930 <__alltraps>

c0102006 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $38
c0102008:	6a 26                	push   $0x26
  jmp __alltraps
c010200a:	e9 21 09 00 00       	jmp    c0102930 <__alltraps>

c010200f <vector39>:
.globl vector39
vector39:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $39
c0102011:	6a 27                	push   $0x27
  jmp __alltraps
c0102013:	e9 18 09 00 00       	jmp    c0102930 <__alltraps>

c0102018 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $40
c010201a:	6a 28                	push   $0x28
  jmp __alltraps
c010201c:	e9 0f 09 00 00       	jmp    c0102930 <__alltraps>

c0102021 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $41
c0102023:	6a 29                	push   $0x29
  jmp __alltraps
c0102025:	e9 06 09 00 00       	jmp    c0102930 <__alltraps>

c010202a <vector42>:
.globl vector42
vector42:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $42
c010202c:	6a 2a                	push   $0x2a
  jmp __alltraps
c010202e:	e9 fd 08 00 00       	jmp    c0102930 <__alltraps>

c0102033 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $43
c0102035:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102037:	e9 f4 08 00 00       	jmp    c0102930 <__alltraps>

c010203c <vector44>:
.globl vector44
vector44:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $44
c010203e:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102040:	e9 eb 08 00 00       	jmp    c0102930 <__alltraps>

c0102045 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $45
c0102047:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102049:	e9 e2 08 00 00       	jmp    c0102930 <__alltraps>

c010204e <vector46>:
.globl vector46
vector46:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $46
c0102050:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102052:	e9 d9 08 00 00       	jmp    c0102930 <__alltraps>

c0102057 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $47
c0102059:	6a 2f                	push   $0x2f
  jmp __alltraps
c010205b:	e9 d0 08 00 00       	jmp    c0102930 <__alltraps>

c0102060 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $48
c0102062:	6a 30                	push   $0x30
  jmp __alltraps
c0102064:	e9 c7 08 00 00       	jmp    c0102930 <__alltraps>

c0102069 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $49
c010206b:	6a 31                	push   $0x31
  jmp __alltraps
c010206d:	e9 be 08 00 00       	jmp    c0102930 <__alltraps>

c0102072 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $50
c0102074:	6a 32                	push   $0x32
  jmp __alltraps
c0102076:	e9 b5 08 00 00       	jmp    c0102930 <__alltraps>

c010207b <vector51>:
.globl vector51
vector51:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $51
c010207d:	6a 33                	push   $0x33
  jmp __alltraps
c010207f:	e9 ac 08 00 00       	jmp    c0102930 <__alltraps>

c0102084 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $52
c0102086:	6a 34                	push   $0x34
  jmp __alltraps
c0102088:	e9 a3 08 00 00       	jmp    c0102930 <__alltraps>

c010208d <vector53>:
.globl vector53
vector53:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $53
c010208f:	6a 35                	push   $0x35
  jmp __alltraps
c0102091:	e9 9a 08 00 00       	jmp    c0102930 <__alltraps>

c0102096 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $54
c0102098:	6a 36                	push   $0x36
  jmp __alltraps
c010209a:	e9 91 08 00 00       	jmp    c0102930 <__alltraps>

c010209f <vector55>:
.globl vector55
vector55:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $55
c01020a1:	6a 37                	push   $0x37
  jmp __alltraps
c01020a3:	e9 88 08 00 00       	jmp    c0102930 <__alltraps>

c01020a8 <vector56>:
.globl vector56
vector56:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $56
c01020aa:	6a 38                	push   $0x38
  jmp __alltraps
c01020ac:	e9 7f 08 00 00       	jmp    c0102930 <__alltraps>

c01020b1 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $57
c01020b3:	6a 39                	push   $0x39
  jmp __alltraps
c01020b5:	e9 76 08 00 00       	jmp    c0102930 <__alltraps>

c01020ba <vector58>:
.globl vector58
vector58:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $58
c01020bc:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020be:	e9 6d 08 00 00       	jmp    c0102930 <__alltraps>

c01020c3 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $59
c01020c5:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020c7:	e9 64 08 00 00       	jmp    c0102930 <__alltraps>

c01020cc <vector60>:
.globl vector60
vector60:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $60
c01020ce:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020d0:	e9 5b 08 00 00       	jmp    c0102930 <__alltraps>

c01020d5 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $61
c01020d7:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020d9:	e9 52 08 00 00       	jmp    c0102930 <__alltraps>

c01020de <vector62>:
.globl vector62
vector62:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $62
c01020e0:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020e2:	e9 49 08 00 00       	jmp    c0102930 <__alltraps>

c01020e7 <vector63>:
.globl vector63
vector63:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $63
c01020e9:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020eb:	e9 40 08 00 00       	jmp    c0102930 <__alltraps>

c01020f0 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $64
c01020f2:	6a 40                	push   $0x40
  jmp __alltraps
c01020f4:	e9 37 08 00 00       	jmp    c0102930 <__alltraps>

c01020f9 <vector65>:
.globl vector65
vector65:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $65
c01020fb:	6a 41                	push   $0x41
  jmp __alltraps
c01020fd:	e9 2e 08 00 00       	jmp    c0102930 <__alltraps>

c0102102 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $66
c0102104:	6a 42                	push   $0x42
  jmp __alltraps
c0102106:	e9 25 08 00 00       	jmp    c0102930 <__alltraps>

c010210b <vector67>:
.globl vector67
vector67:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $67
c010210d:	6a 43                	push   $0x43
  jmp __alltraps
c010210f:	e9 1c 08 00 00       	jmp    c0102930 <__alltraps>

c0102114 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $68
c0102116:	6a 44                	push   $0x44
  jmp __alltraps
c0102118:	e9 13 08 00 00       	jmp    c0102930 <__alltraps>

c010211d <vector69>:
.globl vector69
vector69:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $69
c010211f:	6a 45                	push   $0x45
  jmp __alltraps
c0102121:	e9 0a 08 00 00       	jmp    c0102930 <__alltraps>

c0102126 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $70
c0102128:	6a 46                	push   $0x46
  jmp __alltraps
c010212a:	e9 01 08 00 00       	jmp    c0102930 <__alltraps>

c010212f <vector71>:
.globl vector71
vector71:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $71
c0102131:	6a 47                	push   $0x47
  jmp __alltraps
c0102133:	e9 f8 07 00 00       	jmp    c0102930 <__alltraps>

c0102138 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $72
c010213a:	6a 48                	push   $0x48
  jmp __alltraps
c010213c:	e9 ef 07 00 00       	jmp    c0102930 <__alltraps>

c0102141 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $73
c0102143:	6a 49                	push   $0x49
  jmp __alltraps
c0102145:	e9 e6 07 00 00       	jmp    c0102930 <__alltraps>

c010214a <vector74>:
.globl vector74
vector74:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $74
c010214c:	6a 4a                	push   $0x4a
  jmp __alltraps
c010214e:	e9 dd 07 00 00       	jmp    c0102930 <__alltraps>

c0102153 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $75
c0102155:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102157:	e9 d4 07 00 00       	jmp    c0102930 <__alltraps>

c010215c <vector76>:
.globl vector76
vector76:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $76
c010215e:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102160:	e9 cb 07 00 00       	jmp    c0102930 <__alltraps>

c0102165 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $77
c0102167:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102169:	e9 c2 07 00 00       	jmp    c0102930 <__alltraps>

c010216e <vector78>:
.globl vector78
vector78:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $78
c0102170:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102172:	e9 b9 07 00 00       	jmp    c0102930 <__alltraps>

c0102177 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $79
c0102179:	6a 4f                	push   $0x4f
  jmp __alltraps
c010217b:	e9 b0 07 00 00       	jmp    c0102930 <__alltraps>

c0102180 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $80
c0102182:	6a 50                	push   $0x50
  jmp __alltraps
c0102184:	e9 a7 07 00 00       	jmp    c0102930 <__alltraps>

c0102189 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $81
c010218b:	6a 51                	push   $0x51
  jmp __alltraps
c010218d:	e9 9e 07 00 00       	jmp    c0102930 <__alltraps>

c0102192 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $82
c0102194:	6a 52                	push   $0x52
  jmp __alltraps
c0102196:	e9 95 07 00 00       	jmp    c0102930 <__alltraps>

c010219b <vector83>:
.globl vector83
vector83:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $83
c010219d:	6a 53                	push   $0x53
  jmp __alltraps
c010219f:	e9 8c 07 00 00       	jmp    c0102930 <__alltraps>

c01021a4 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $84
c01021a6:	6a 54                	push   $0x54
  jmp __alltraps
c01021a8:	e9 83 07 00 00       	jmp    c0102930 <__alltraps>

c01021ad <vector85>:
.globl vector85
vector85:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $85
c01021af:	6a 55                	push   $0x55
  jmp __alltraps
c01021b1:	e9 7a 07 00 00       	jmp    c0102930 <__alltraps>

c01021b6 <vector86>:
.globl vector86
vector86:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $86
c01021b8:	6a 56                	push   $0x56
  jmp __alltraps
c01021ba:	e9 71 07 00 00       	jmp    c0102930 <__alltraps>

c01021bf <vector87>:
.globl vector87
vector87:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $87
c01021c1:	6a 57                	push   $0x57
  jmp __alltraps
c01021c3:	e9 68 07 00 00       	jmp    c0102930 <__alltraps>

c01021c8 <vector88>:
.globl vector88
vector88:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $88
c01021ca:	6a 58                	push   $0x58
  jmp __alltraps
c01021cc:	e9 5f 07 00 00       	jmp    c0102930 <__alltraps>

c01021d1 <vector89>:
.globl vector89
vector89:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $89
c01021d3:	6a 59                	push   $0x59
  jmp __alltraps
c01021d5:	e9 56 07 00 00       	jmp    c0102930 <__alltraps>

c01021da <vector90>:
.globl vector90
vector90:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $90
c01021dc:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021de:	e9 4d 07 00 00       	jmp    c0102930 <__alltraps>

c01021e3 <vector91>:
.globl vector91
vector91:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $91
c01021e5:	6a 5b                	push   $0x5b
  jmp __alltraps
c01021e7:	e9 44 07 00 00       	jmp    c0102930 <__alltraps>

c01021ec <vector92>:
.globl vector92
vector92:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $92
c01021ee:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021f0:	e9 3b 07 00 00       	jmp    c0102930 <__alltraps>

c01021f5 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $93
c01021f7:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021f9:	e9 32 07 00 00       	jmp    c0102930 <__alltraps>

c01021fe <vector94>:
.globl vector94
vector94:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $94
c0102200:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102202:	e9 29 07 00 00       	jmp    c0102930 <__alltraps>

c0102207 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $95
c0102209:	6a 5f                	push   $0x5f
  jmp __alltraps
c010220b:	e9 20 07 00 00       	jmp    c0102930 <__alltraps>

c0102210 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $96
c0102212:	6a 60                	push   $0x60
  jmp __alltraps
c0102214:	e9 17 07 00 00       	jmp    c0102930 <__alltraps>

c0102219 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $97
c010221b:	6a 61                	push   $0x61
  jmp __alltraps
c010221d:	e9 0e 07 00 00       	jmp    c0102930 <__alltraps>

c0102222 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $98
c0102224:	6a 62                	push   $0x62
  jmp __alltraps
c0102226:	e9 05 07 00 00       	jmp    c0102930 <__alltraps>

c010222b <vector99>:
.globl vector99
vector99:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $99
c010222d:	6a 63                	push   $0x63
  jmp __alltraps
c010222f:	e9 fc 06 00 00       	jmp    c0102930 <__alltraps>

c0102234 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $100
c0102236:	6a 64                	push   $0x64
  jmp __alltraps
c0102238:	e9 f3 06 00 00       	jmp    c0102930 <__alltraps>

c010223d <vector101>:
.globl vector101
vector101:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $101
c010223f:	6a 65                	push   $0x65
  jmp __alltraps
c0102241:	e9 ea 06 00 00       	jmp    c0102930 <__alltraps>

c0102246 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $102
c0102248:	6a 66                	push   $0x66
  jmp __alltraps
c010224a:	e9 e1 06 00 00       	jmp    c0102930 <__alltraps>

c010224f <vector103>:
.globl vector103
vector103:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $103
c0102251:	6a 67                	push   $0x67
  jmp __alltraps
c0102253:	e9 d8 06 00 00       	jmp    c0102930 <__alltraps>

c0102258 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $104
c010225a:	6a 68                	push   $0x68
  jmp __alltraps
c010225c:	e9 cf 06 00 00       	jmp    c0102930 <__alltraps>

c0102261 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $105
c0102263:	6a 69                	push   $0x69
  jmp __alltraps
c0102265:	e9 c6 06 00 00       	jmp    c0102930 <__alltraps>

c010226a <vector106>:
.globl vector106
vector106:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $106
c010226c:	6a 6a                	push   $0x6a
  jmp __alltraps
c010226e:	e9 bd 06 00 00       	jmp    c0102930 <__alltraps>

c0102273 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $107
c0102275:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102277:	e9 b4 06 00 00       	jmp    c0102930 <__alltraps>

c010227c <vector108>:
.globl vector108
vector108:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $108
c010227e:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102280:	e9 ab 06 00 00       	jmp    c0102930 <__alltraps>

c0102285 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $109
c0102287:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102289:	e9 a2 06 00 00       	jmp    c0102930 <__alltraps>

c010228e <vector110>:
.globl vector110
vector110:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $110
c0102290:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102292:	e9 99 06 00 00       	jmp    c0102930 <__alltraps>

c0102297 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $111
c0102299:	6a 6f                	push   $0x6f
  jmp __alltraps
c010229b:	e9 90 06 00 00       	jmp    c0102930 <__alltraps>

c01022a0 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $112
c01022a2:	6a 70                	push   $0x70
  jmp __alltraps
c01022a4:	e9 87 06 00 00       	jmp    c0102930 <__alltraps>

c01022a9 <vector113>:
.globl vector113
vector113:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $113
c01022ab:	6a 71                	push   $0x71
  jmp __alltraps
c01022ad:	e9 7e 06 00 00       	jmp    c0102930 <__alltraps>

c01022b2 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $114
c01022b4:	6a 72                	push   $0x72
  jmp __alltraps
c01022b6:	e9 75 06 00 00       	jmp    c0102930 <__alltraps>

c01022bb <vector115>:
.globl vector115
vector115:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $115
c01022bd:	6a 73                	push   $0x73
  jmp __alltraps
c01022bf:	e9 6c 06 00 00       	jmp    c0102930 <__alltraps>

c01022c4 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $116
c01022c6:	6a 74                	push   $0x74
  jmp __alltraps
c01022c8:	e9 63 06 00 00       	jmp    c0102930 <__alltraps>

c01022cd <vector117>:
.globl vector117
vector117:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $117
c01022cf:	6a 75                	push   $0x75
  jmp __alltraps
c01022d1:	e9 5a 06 00 00       	jmp    c0102930 <__alltraps>

c01022d6 <vector118>:
.globl vector118
vector118:
  pushl $0
c01022d6:	6a 00                	push   $0x0
  pushl $118
c01022d8:	6a 76                	push   $0x76
  jmp __alltraps
c01022da:	e9 51 06 00 00       	jmp    c0102930 <__alltraps>

c01022df <vector119>:
.globl vector119
vector119:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $119
c01022e1:	6a 77                	push   $0x77
  jmp __alltraps
c01022e3:	e9 48 06 00 00       	jmp    c0102930 <__alltraps>

c01022e8 <vector120>:
.globl vector120
vector120:
  pushl $0
c01022e8:	6a 00                	push   $0x0
  pushl $120
c01022ea:	6a 78                	push   $0x78
  jmp __alltraps
c01022ec:	e9 3f 06 00 00       	jmp    c0102930 <__alltraps>

c01022f1 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $121
c01022f3:	6a 79                	push   $0x79
  jmp __alltraps
c01022f5:	e9 36 06 00 00       	jmp    c0102930 <__alltraps>

c01022fa <vector122>:
.globl vector122
vector122:
  pushl $0
c01022fa:	6a 00                	push   $0x0
  pushl $122
c01022fc:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022fe:	e9 2d 06 00 00       	jmp    c0102930 <__alltraps>

c0102303 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102303:	6a 00                	push   $0x0
  pushl $123
c0102305:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102307:	e9 24 06 00 00       	jmp    c0102930 <__alltraps>

c010230c <vector124>:
.globl vector124
vector124:
  pushl $0
c010230c:	6a 00                	push   $0x0
  pushl $124
c010230e:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102310:	e9 1b 06 00 00       	jmp    c0102930 <__alltraps>

c0102315 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $125
c0102317:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102319:	e9 12 06 00 00       	jmp    c0102930 <__alltraps>

c010231e <vector126>:
.globl vector126
vector126:
  pushl $0
c010231e:	6a 00                	push   $0x0
  pushl $126
c0102320:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102322:	e9 09 06 00 00       	jmp    c0102930 <__alltraps>

c0102327 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102327:	6a 00                	push   $0x0
  pushl $127
c0102329:	6a 7f                	push   $0x7f
  jmp __alltraps
c010232b:	e9 00 06 00 00       	jmp    c0102930 <__alltraps>

c0102330 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $128
c0102332:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102337:	e9 f4 05 00 00       	jmp    c0102930 <__alltraps>

c010233c <vector129>:
.globl vector129
vector129:
  pushl $0
c010233c:	6a 00                	push   $0x0
  pushl $129
c010233e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102343:	e9 e8 05 00 00       	jmp    c0102930 <__alltraps>

c0102348 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $130
c010234a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010234f:	e9 dc 05 00 00       	jmp    c0102930 <__alltraps>

c0102354 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $131
c0102356:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010235b:	e9 d0 05 00 00       	jmp    c0102930 <__alltraps>

c0102360 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102360:	6a 00                	push   $0x0
  pushl $132
c0102362:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102367:	e9 c4 05 00 00       	jmp    c0102930 <__alltraps>

c010236c <vector133>:
.globl vector133
vector133:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $133
c010236e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102373:	e9 b8 05 00 00       	jmp    c0102930 <__alltraps>

c0102378 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $134
c010237a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010237f:	e9 ac 05 00 00       	jmp    c0102930 <__alltraps>

c0102384 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102384:	6a 00                	push   $0x0
  pushl $135
c0102386:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010238b:	e9 a0 05 00 00       	jmp    c0102930 <__alltraps>

c0102390 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $136
c0102392:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102397:	e9 94 05 00 00       	jmp    c0102930 <__alltraps>

c010239c <vector137>:
.globl vector137
vector137:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $137
c010239e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023a3:	e9 88 05 00 00       	jmp    c0102930 <__alltraps>

c01023a8 <vector138>:
.globl vector138
vector138:
  pushl $0
c01023a8:	6a 00                	push   $0x0
  pushl $138
c01023aa:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023af:	e9 7c 05 00 00       	jmp    c0102930 <__alltraps>

c01023b4 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $139
c01023b6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023bb:	e9 70 05 00 00       	jmp    c0102930 <__alltraps>

c01023c0 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $140
c01023c2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023c7:	e9 64 05 00 00       	jmp    c0102930 <__alltraps>

c01023cc <vector141>:
.globl vector141
vector141:
  pushl $0
c01023cc:	6a 00                	push   $0x0
  pushl $141
c01023ce:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023d3:	e9 58 05 00 00       	jmp    c0102930 <__alltraps>

c01023d8 <vector142>:
.globl vector142
vector142:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $142
c01023da:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023df:	e9 4c 05 00 00       	jmp    c0102930 <__alltraps>

c01023e4 <vector143>:
.globl vector143
vector143:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $143
c01023e6:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023eb:	e9 40 05 00 00       	jmp    c0102930 <__alltraps>

c01023f0 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023f0:	6a 00                	push   $0x0
  pushl $144
c01023f2:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023f7:	e9 34 05 00 00       	jmp    c0102930 <__alltraps>

c01023fc <vector145>:
.globl vector145
vector145:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $145
c01023fe:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102403:	e9 28 05 00 00       	jmp    c0102930 <__alltraps>

c0102408 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $146
c010240a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010240f:	e9 1c 05 00 00       	jmp    c0102930 <__alltraps>

c0102414 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102414:	6a 00                	push   $0x0
  pushl $147
c0102416:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010241b:	e9 10 05 00 00       	jmp    c0102930 <__alltraps>

c0102420 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $148
c0102422:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102427:	e9 04 05 00 00       	jmp    c0102930 <__alltraps>

c010242c <vector149>:
.globl vector149
vector149:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $149
c010242e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102433:	e9 f8 04 00 00       	jmp    c0102930 <__alltraps>

c0102438 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102438:	6a 00                	push   $0x0
  pushl $150
c010243a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010243f:	e9 ec 04 00 00       	jmp    c0102930 <__alltraps>

c0102444 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $151
c0102446:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010244b:	e9 e0 04 00 00       	jmp    c0102930 <__alltraps>

c0102450 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $152
c0102452:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102457:	e9 d4 04 00 00       	jmp    c0102930 <__alltraps>

c010245c <vector153>:
.globl vector153
vector153:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $153
c010245e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102463:	e9 c8 04 00 00       	jmp    c0102930 <__alltraps>

c0102468 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $154
c010246a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010246f:	e9 bc 04 00 00       	jmp    c0102930 <__alltraps>

c0102474 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $155
c0102476:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010247b:	e9 b0 04 00 00       	jmp    c0102930 <__alltraps>

c0102480 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $156
c0102482:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102487:	e9 a4 04 00 00       	jmp    c0102930 <__alltraps>

c010248c <vector157>:
.globl vector157
vector157:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $157
c010248e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102493:	e9 98 04 00 00       	jmp    c0102930 <__alltraps>

c0102498 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $158
c010249a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010249f:	e9 8c 04 00 00       	jmp    c0102930 <__alltraps>

c01024a4 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $159
c01024a6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024ab:	e9 80 04 00 00       	jmp    c0102930 <__alltraps>

c01024b0 <vector160>:
.globl vector160
vector160:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $160
c01024b2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024b7:	e9 74 04 00 00       	jmp    c0102930 <__alltraps>

c01024bc <vector161>:
.globl vector161
vector161:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $161
c01024be:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024c3:	e9 68 04 00 00       	jmp    c0102930 <__alltraps>

c01024c8 <vector162>:
.globl vector162
vector162:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $162
c01024ca:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024cf:	e9 5c 04 00 00       	jmp    c0102930 <__alltraps>

c01024d4 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $163
c01024d6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024db:	e9 50 04 00 00       	jmp    c0102930 <__alltraps>

c01024e0 <vector164>:
.globl vector164
vector164:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $164
c01024e2:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01024e7:	e9 44 04 00 00       	jmp    c0102930 <__alltraps>

c01024ec <vector165>:
.globl vector165
vector165:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $165
c01024ee:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024f3:	e9 38 04 00 00       	jmp    c0102930 <__alltraps>

c01024f8 <vector166>:
.globl vector166
vector166:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $166
c01024fa:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024ff:	e9 2c 04 00 00       	jmp    c0102930 <__alltraps>

c0102504 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $167
c0102506:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010250b:	e9 20 04 00 00       	jmp    c0102930 <__alltraps>

c0102510 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $168
c0102512:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102517:	e9 14 04 00 00       	jmp    c0102930 <__alltraps>

c010251c <vector169>:
.globl vector169
vector169:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $169
c010251e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102523:	e9 08 04 00 00       	jmp    c0102930 <__alltraps>

c0102528 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $170
c010252a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010252f:	e9 fc 03 00 00       	jmp    c0102930 <__alltraps>

c0102534 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $171
c0102536:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010253b:	e9 f0 03 00 00       	jmp    c0102930 <__alltraps>

c0102540 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $172
c0102542:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102547:	e9 e4 03 00 00       	jmp    c0102930 <__alltraps>

c010254c <vector173>:
.globl vector173
vector173:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $173
c010254e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102553:	e9 d8 03 00 00       	jmp    c0102930 <__alltraps>

c0102558 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $174
c010255a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010255f:	e9 cc 03 00 00       	jmp    c0102930 <__alltraps>

c0102564 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $175
c0102566:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010256b:	e9 c0 03 00 00       	jmp    c0102930 <__alltraps>

c0102570 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $176
c0102572:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102577:	e9 b4 03 00 00       	jmp    c0102930 <__alltraps>

c010257c <vector177>:
.globl vector177
vector177:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $177
c010257e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102583:	e9 a8 03 00 00       	jmp    c0102930 <__alltraps>

c0102588 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $178
c010258a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010258f:	e9 9c 03 00 00       	jmp    c0102930 <__alltraps>

c0102594 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $179
c0102596:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010259b:	e9 90 03 00 00       	jmp    c0102930 <__alltraps>

c01025a0 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $180
c01025a2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025a7:	e9 84 03 00 00       	jmp    c0102930 <__alltraps>

c01025ac <vector181>:
.globl vector181
vector181:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $181
c01025ae:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025b3:	e9 78 03 00 00       	jmp    c0102930 <__alltraps>

c01025b8 <vector182>:
.globl vector182
vector182:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $182
c01025ba:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025bf:	e9 6c 03 00 00       	jmp    c0102930 <__alltraps>

c01025c4 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $183
c01025c6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025cb:	e9 60 03 00 00       	jmp    c0102930 <__alltraps>

c01025d0 <vector184>:
.globl vector184
vector184:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $184
c01025d2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025d7:	e9 54 03 00 00       	jmp    c0102930 <__alltraps>

c01025dc <vector185>:
.globl vector185
vector185:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $185
c01025de:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01025e3:	e9 48 03 00 00       	jmp    c0102930 <__alltraps>

c01025e8 <vector186>:
.globl vector186
vector186:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $186
c01025ea:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025ef:	e9 3c 03 00 00       	jmp    c0102930 <__alltraps>

c01025f4 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $187
c01025f6:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025fb:	e9 30 03 00 00       	jmp    c0102930 <__alltraps>

c0102600 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $188
c0102602:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102607:	e9 24 03 00 00       	jmp    c0102930 <__alltraps>

c010260c <vector189>:
.globl vector189
vector189:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $189
c010260e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102613:	e9 18 03 00 00       	jmp    c0102930 <__alltraps>

c0102618 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $190
c010261a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010261f:	e9 0c 03 00 00       	jmp    c0102930 <__alltraps>

c0102624 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $191
c0102626:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010262b:	e9 00 03 00 00       	jmp    c0102930 <__alltraps>

c0102630 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $192
c0102632:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102637:	e9 f4 02 00 00       	jmp    c0102930 <__alltraps>

c010263c <vector193>:
.globl vector193
vector193:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $193
c010263e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102643:	e9 e8 02 00 00       	jmp    c0102930 <__alltraps>

c0102648 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $194
c010264a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010264f:	e9 dc 02 00 00       	jmp    c0102930 <__alltraps>

c0102654 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $195
c0102656:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010265b:	e9 d0 02 00 00       	jmp    c0102930 <__alltraps>

c0102660 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $196
c0102662:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102667:	e9 c4 02 00 00       	jmp    c0102930 <__alltraps>

c010266c <vector197>:
.globl vector197
vector197:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $197
c010266e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102673:	e9 b8 02 00 00       	jmp    c0102930 <__alltraps>

c0102678 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $198
c010267a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010267f:	e9 ac 02 00 00       	jmp    c0102930 <__alltraps>

c0102684 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $199
c0102686:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010268b:	e9 a0 02 00 00       	jmp    c0102930 <__alltraps>

c0102690 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $200
c0102692:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102697:	e9 94 02 00 00       	jmp    c0102930 <__alltraps>

c010269c <vector201>:
.globl vector201
vector201:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $201
c010269e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026a3:	e9 88 02 00 00       	jmp    c0102930 <__alltraps>

c01026a8 <vector202>:
.globl vector202
vector202:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $202
c01026aa:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026af:	e9 7c 02 00 00       	jmp    c0102930 <__alltraps>

c01026b4 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $203
c01026b6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026bb:	e9 70 02 00 00       	jmp    c0102930 <__alltraps>

c01026c0 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $204
c01026c2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026c7:	e9 64 02 00 00       	jmp    c0102930 <__alltraps>

c01026cc <vector205>:
.globl vector205
vector205:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $205
c01026ce:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026d3:	e9 58 02 00 00       	jmp    c0102930 <__alltraps>

c01026d8 <vector206>:
.globl vector206
vector206:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $206
c01026da:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026df:	e9 4c 02 00 00       	jmp    c0102930 <__alltraps>

c01026e4 <vector207>:
.globl vector207
vector207:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $207
c01026e6:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026eb:	e9 40 02 00 00       	jmp    c0102930 <__alltraps>

c01026f0 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $208
c01026f2:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026f7:	e9 34 02 00 00       	jmp    c0102930 <__alltraps>

c01026fc <vector209>:
.globl vector209
vector209:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $209
c01026fe:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102703:	e9 28 02 00 00       	jmp    c0102930 <__alltraps>

c0102708 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $210
c010270a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010270f:	e9 1c 02 00 00       	jmp    c0102930 <__alltraps>

c0102714 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $211
c0102716:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010271b:	e9 10 02 00 00       	jmp    c0102930 <__alltraps>

c0102720 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $212
c0102722:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102727:	e9 04 02 00 00       	jmp    c0102930 <__alltraps>

c010272c <vector213>:
.globl vector213
vector213:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $213
c010272e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102733:	e9 f8 01 00 00       	jmp    c0102930 <__alltraps>

c0102738 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $214
c010273a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010273f:	e9 ec 01 00 00       	jmp    c0102930 <__alltraps>

c0102744 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $215
c0102746:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010274b:	e9 e0 01 00 00       	jmp    c0102930 <__alltraps>

c0102750 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $216
c0102752:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102757:	e9 d4 01 00 00       	jmp    c0102930 <__alltraps>

c010275c <vector217>:
.globl vector217
vector217:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $217
c010275e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102763:	e9 c8 01 00 00       	jmp    c0102930 <__alltraps>

c0102768 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $218
c010276a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010276f:	e9 bc 01 00 00       	jmp    c0102930 <__alltraps>

c0102774 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $219
c0102776:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010277b:	e9 b0 01 00 00       	jmp    c0102930 <__alltraps>

c0102780 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $220
c0102782:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102787:	e9 a4 01 00 00       	jmp    c0102930 <__alltraps>

c010278c <vector221>:
.globl vector221
vector221:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $221
c010278e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102793:	e9 98 01 00 00       	jmp    c0102930 <__alltraps>

c0102798 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $222
c010279a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010279f:	e9 8c 01 00 00       	jmp    c0102930 <__alltraps>

c01027a4 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $223
c01027a6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027ab:	e9 80 01 00 00       	jmp    c0102930 <__alltraps>

c01027b0 <vector224>:
.globl vector224
vector224:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $224
c01027b2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027b7:	e9 74 01 00 00       	jmp    c0102930 <__alltraps>

c01027bc <vector225>:
.globl vector225
vector225:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $225
c01027be:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027c3:	e9 68 01 00 00       	jmp    c0102930 <__alltraps>

c01027c8 <vector226>:
.globl vector226
vector226:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $226
c01027ca:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027cf:	e9 5c 01 00 00       	jmp    c0102930 <__alltraps>

c01027d4 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $227
c01027d6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027db:	e9 50 01 00 00       	jmp    c0102930 <__alltraps>

c01027e0 <vector228>:
.globl vector228
vector228:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $228
c01027e2:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01027e7:	e9 44 01 00 00       	jmp    c0102930 <__alltraps>

c01027ec <vector229>:
.globl vector229
vector229:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $229
c01027ee:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027f3:	e9 38 01 00 00       	jmp    c0102930 <__alltraps>

c01027f8 <vector230>:
.globl vector230
vector230:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $230
c01027fa:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027ff:	e9 2c 01 00 00       	jmp    c0102930 <__alltraps>

c0102804 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $231
c0102806:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010280b:	e9 20 01 00 00       	jmp    c0102930 <__alltraps>

c0102810 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $232
c0102812:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102817:	e9 14 01 00 00       	jmp    c0102930 <__alltraps>

c010281c <vector233>:
.globl vector233
vector233:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $233
c010281e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102823:	e9 08 01 00 00       	jmp    c0102930 <__alltraps>

c0102828 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $234
c010282a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010282f:	e9 fc 00 00 00       	jmp    c0102930 <__alltraps>

c0102834 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $235
c0102836:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010283b:	e9 f0 00 00 00       	jmp    c0102930 <__alltraps>

c0102840 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $236
c0102842:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102847:	e9 e4 00 00 00       	jmp    c0102930 <__alltraps>

c010284c <vector237>:
.globl vector237
vector237:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $237
c010284e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102853:	e9 d8 00 00 00       	jmp    c0102930 <__alltraps>

c0102858 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $238
c010285a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010285f:	e9 cc 00 00 00       	jmp    c0102930 <__alltraps>

c0102864 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $239
c0102866:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010286b:	e9 c0 00 00 00       	jmp    c0102930 <__alltraps>

c0102870 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $240
c0102872:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102877:	e9 b4 00 00 00       	jmp    c0102930 <__alltraps>

c010287c <vector241>:
.globl vector241
vector241:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $241
c010287e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102883:	e9 a8 00 00 00       	jmp    c0102930 <__alltraps>

c0102888 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $242
c010288a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010288f:	e9 9c 00 00 00       	jmp    c0102930 <__alltraps>

c0102894 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $243
c0102896:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010289b:	e9 90 00 00 00       	jmp    c0102930 <__alltraps>

c01028a0 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $244
c01028a2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028a7:	e9 84 00 00 00       	jmp    c0102930 <__alltraps>

c01028ac <vector245>:
.globl vector245
vector245:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $245
c01028ae:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028b3:	e9 78 00 00 00       	jmp    c0102930 <__alltraps>

c01028b8 <vector246>:
.globl vector246
vector246:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $246
c01028ba:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028bf:	e9 6c 00 00 00       	jmp    c0102930 <__alltraps>

c01028c4 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $247
c01028c6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028cb:	e9 60 00 00 00       	jmp    c0102930 <__alltraps>

c01028d0 <vector248>:
.globl vector248
vector248:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $248
c01028d2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028d7:	e9 54 00 00 00       	jmp    c0102930 <__alltraps>

c01028dc <vector249>:
.globl vector249
vector249:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $249
c01028de:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01028e3:	e9 48 00 00 00       	jmp    c0102930 <__alltraps>

c01028e8 <vector250>:
.globl vector250
vector250:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $250
c01028ea:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028ef:	e9 3c 00 00 00       	jmp    c0102930 <__alltraps>

c01028f4 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $251
c01028f6:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028fb:	e9 30 00 00 00       	jmp    c0102930 <__alltraps>

c0102900 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $252
c0102902:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102907:	e9 24 00 00 00       	jmp    c0102930 <__alltraps>

c010290c <vector253>:
.globl vector253
vector253:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $253
c010290e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102913:	e9 18 00 00 00       	jmp    c0102930 <__alltraps>

c0102918 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $254
c010291a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010291f:	e9 0c 00 00 00       	jmp    c0102930 <__alltraps>

c0102924 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $255
c0102926:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010292b:	e9 00 00 00 00       	jmp    c0102930 <__alltraps>

c0102930 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102930:	1e                   	push   %ds
    pushl %es
c0102931:	06                   	push   %es
    pushl %fs
c0102932:	0f a0                	push   %fs
    pushl %gs
c0102934:	0f a8                	push   %gs
    pushal
c0102936:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102937:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010293c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010293e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102940:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102941:	e8 61 f5 ff ff       	call   c0101ea7 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102946:	5c                   	pop    %esp

c0102947 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102947:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102948:	0f a9                	pop    %gs
    popl %fs
c010294a:	0f a1                	pop    %fs
    popl %es
c010294c:	07                   	pop    %es
    popl %ds
c010294d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010294e:	83 c4 08             	add    $0x8,%esp
    iret
c0102951:	cf                   	iret   

c0102952 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102952:	55                   	push   %ebp
c0102953:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102955:	8b 45 08             	mov    0x8(%ebp),%eax
c0102958:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c010295e:	29 d0                	sub    %edx,%eax
c0102960:	c1 f8 02             	sar    $0x2,%eax
c0102963:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102969:	5d                   	pop    %ebp
c010296a:	c3                   	ret    

c010296b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010296b:	55                   	push   %ebp
c010296c:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c010296e:	ff 75 08             	pushl  0x8(%ebp)
c0102971:	e8 dc ff ff ff       	call   c0102952 <page2ppn>
c0102976:	83 c4 04             	add    $0x4,%esp
c0102979:	c1 e0 0c             	shl    $0xc,%eax
}
c010297c:	c9                   	leave  
c010297d:	c3                   	ret    

c010297e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010297e:	55                   	push   %ebp
c010297f:	89 e5                	mov    %esp,%ebp
c0102981:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0102984:	8b 45 08             	mov    0x8(%ebp),%eax
c0102987:	c1 e8 0c             	shr    $0xc,%eax
c010298a:	89 c2                	mov    %eax,%edx
c010298c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102991:	39 c2                	cmp    %eax,%edx
c0102993:	72 14                	jb     c01029a9 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0102995:	83 ec 04             	sub    $0x4,%esp
c0102998:	68 10 61 10 c0       	push   $0xc0106110
c010299d:	6a 5a                	push   $0x5a
c010299f:	68 2f 61 10 c0       	push   $0xc010612f
c01029a4:	e8 2c da ff ff       	call   c01003d5 <__panic>
    }
    return &pages[PPN(pa)];
c01029a9:	8b 0d b8 89 11 c0    	mov    0xc01189b8,%ecx
c01029af:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b2:	c1 e8 0c             	shr    $0xc,%eax
c01029b5:	89 c2                	mov    %eax,%edx
c01029b7:	89 d0                	mov    %edx,%eax
c01029b9:	c1 e0 02             	shl    $0x2,%eax
c01029bc:	01 d0                	add    %edx,%eax
c01029be:	c1 e0 02             	shl    $0x2,%eax
c01029c1:	01 c8                	add    %ecx,%eax
}
c01029c3:	c9                   	leave  
c01029c4:	c3                   	ret    

c01029c5 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01029c5:	55                   	push   %ebp
c01029c6:	89 e5                	mov    %esp,%ebp
c01029c8:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01029cb:	ff 75 08             	pushl  0x8(%ebp)
c01029ce:	e8 98 ff ff ff       	call   c010296b <page2pa>
c01029d3:	83 c4 04             	add    $0x4,%esp
c01029d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029dc:	c1 e8 0c             	shr    $0xc,%eax
c01029df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01029e2:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01029e7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01029ea:	72 14                	jb     c0102a00 <page2kva+0x3b>
c01029ec:	ff 75 f4             	pushl  -0xc(%ebp)
c01029ef:	68 40 61 10 c0       	push   $0xc0106140
c01029f4:	6a 61                	push   $0x61
c01029f6:	68 2f 61 10 c0       	push   $0xc010612f
c01029fb:	e8 d5 d9 ff ff       	call   c01003d5 <__panic>
c0102a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a03:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a08:	c9                   	leave  
c0102a09:	c3                   	ret    

c0102a0a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a0a:	55                   	push   %ebp
c0102a0b:	89 e5                	mov    %esp,%ebp
c0102a0d:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a13:	83 e0 01             	and    $0x1,%eax
c0102a16:	85 c0                	test   %eax,%eax
c0102a18:	75 14                	jne    c0102a2e <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102a1a:	83 ec 04             	sub    $0x4,%esp
c0102a1d:	68 64 61 10 c0       	push   $0xc0106164
c0102a22:	6a 6c                	push   $0x6c
c0102a24:	68 2f 61 10 c0       	push   $0xc010612f
c0102a29:	e8 a7 d9 ff ff       	call   c01003d5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a36:	83 ec 0c             	sub    $0xc,%esp
c0102a39:	50                   	push   %eax
c0102a3a:	e8 3f ff ff ff       	call   c010297e <pa2page>
c0102a3f:	83 c4 10             	add    $0x10,%esp
}
c0102a42:	c9                   	leave  
c0102a43:	c3                   	ret    

c0102a44 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102a44:	55                   	push   %ebp
c0102a45:	89 e5                	mov    %esp,%ebp
c0102a47:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a52:	83 ec 0c             	sub    $0xc,%esp
c0102a55:	50                   	push   %eax
c0102a56:	e8 23 ff ff ff       	call   c010297e <pa2page>
c0102a5b:	83 c4 10             	add    $0x10,%esp
}
c0102a5e:	c9                   	leave  
c0102a5f:	c3                   	ret    

c0102a60 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102a60:	55                   	push   %ebp
c0102a61:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a66:	8b 00                	mov    (%eax),%eax
}
c0102a68:	5d                   	pop    %ebp
c0102a69:	c3                   	ret    

c0102a6a <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0102a6a:	55                   	push   %ebp
c0102a6b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a70:	8b 00                	mov    (%eax),%eax
c0102a72:	8d 50 01             	lea    0x1(%eax),%edx
c0102a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a78:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a7d:	8b 00                	mov    (%eax),%eax
}
c0102a7f:	5d                   	pop    %ebp
c0102a80:	c3                   	ret    

c0102a81 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102a81:	55                   	push   %ebp
c0102a82:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a87:	8b 00                	mov    (%eax),%eax
c0102a89:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a8f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a94:	8b 00                	mov    (%eax),%eax
}
c0102a96:	5d                   	pop    %ebp
c0102a97:	c3                   	ret    

c0102a98 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0102a98:	55                   	push   %ebp
c0102a99:	89 e5                	mov    %esp,%ebp
c0102a9b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102a9e:	9c                   	pushf  
c0102a9f:	58                   	pop    %eax
c0102aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102aa6:	25 00 02 00 00       	and    $0x200,%eax
c0102aab:	85 c0                	test   %eax,%eax
c0102aad:	74 0c                	je     c0102abb <__intr_save+0x23>
        intr_disable();
c0102aaf:	e8 c2 ed ff ff       	call   c0101876 <intr_disable>
        return 1;
c0102ab4:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ab9:	eb 05                	jmp    c0102ac0 <__intr_save+0x28>
    }
    return 0;
c0102abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ac0:	c9                   	leave  
c0102ac1:	c3                   	ret    

c0102ac2 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102ac2:	55                   	push   %ebp
c0102ac3:	89 e5                	mov    %esp,%ebp
c0102ac5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102ac8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102acc:	74 05                	je     c0102ad3 <__intr_restore+0x11>
        intr_enable();
c0102ace:	e8 9c ed ff ff       	call   c010186f <intr_enable>
    }
}
c0102ad3:	90                   	nop
c0102ad4:	c9                   	leave  
c0102ad5:	c3                   	ret    

c0102ad6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102ad6:	55                   	push   %ebp
c0102ad7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102adc:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102adf:	b8 23 00 00 00       	mov    $0x23,%eax
c0102ae4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102ae6:	b8 23 00 00 00       	mov    $0x23,%eax
c0102aeb:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102aed:	b8 10 00 00 00       	mov    $0x10,%eax
c0102af2:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102af4:	b8 10 00 00 00       	mov    $0x10,%eax
c0102af9:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102afb:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b00:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b02:	ea 09 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b09
}
c0102b09:	90                   	nop
c0102b0a:	5d                   	pop    %ebp
c0102b0b:	c3                   	ret    

c0102b0c <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b0c:	55                   	push   %ebp
c0102b0d:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b12:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102b17:	90                   	nop
c0102b18:	5d                   	pop    %ebp
c0102b19:	c3                   	ret    

c0102b1a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b1a:	55                   	push   %ebp
c0102b1b:	89 e5                	mov    %esp,%ebp
c0102b1d:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b20:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102b25:	50                   	push   %eax
c0102b26:	e8 e1 ff ff ff       	call   c0102b0c <load_esp0>
c0102b2b:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102b2e:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102b35:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b37:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102b3e:	68 00 
c0102b40:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b45:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102b4b:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b50:	c1 e8 10             	shr    $0x10,%eax
c0102b53:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102b58:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b5f:	83 e0 f0             	and    $0xfffffff0,%eax
c0102b62:	83 c8 09             	or     $0x9,%eax
c0102b65:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b6a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b71:	83 e0 ef             	and    $0xffffffef,%eax
c0102b74:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b79:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b80:	83 e0 9f             	and    $0xffffff9f,%eax
c0102b83:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b88:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b8f:	83 c8 80             	or     $0xffffff80,%eax
c0102b92:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b97:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b9e:	83 e0 f0             	and    $0xfffffff0,%eax
c0102ba1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ba6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bad:	83 e0 ef             	and    $0xffffffef,%eax
c0102bb0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bb5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bbc:	83 e0 df             	and    $0xffffffdf,%eax
c0102bbf:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bc4:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bcb:	83 c8 40             	or     $0x40,%eax
c0102bce:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bd3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bda:	83 e0 7f             	and    $0x7f,%eax
c0102bdd:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102be2:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102be7:	c1 e8 18             	shr    $0x18,%eax
c0102bea:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102bef:	68 30 7a 11 c0       	push   $0xc0117a30
c0102bf4:	e8 dd fe ff ff       	call   c0102ad6 <lgdt>
c0102bf9:	83 c4 04             	add    $0x4,%esp
c0102bfc:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c02:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c06:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102c09:	90                   	nop
c0102c0a:	c9                   	leave  
c0102c0b:	c3                   	ret    

c0102c0c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c0c:	55                   	push   %ebp
c0102c0d:	89 e5                	mov    %esp,%ebp
c0102c0f:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102c12:	c7 05 b0 89 11 c0 f0 	movl   $0xc0106af0,0xc01189b0
c0102c19:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c1c:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c21:	8b 00                	mov    (%eax),%eax
c0102c23:	83 ec 08             	sub    $0x8,%esp
c0102c26:	50                   	push   %eax
c0102c27:	68 90 61 10 c0       	push   $0xc0106190
c0102c2c:	e8 3e d6 ff ff       	call   c010026f <cprintf>
c0102c31:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102c34:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c39:	8b 40 04             	mov    0x4(%eax),%eax
c0102c3c:	ff d0                	call   *%eax
}
c0102c3e:	90                   	nop
c0102c3f:	c9                   	leave  
c0102c40:	c3                   	ret    

c0102c41 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102c41:	55                   	push   %ebp
c0102c42:	89 e5                	mov    %esp,%ebp
c0102c44:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102c47:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c4c:	8b 40 08             	mov    0x8(%eax),%eax
c0102c4f:	83 ec 08             	sub    $0x8,%esp
c0102c52:	ff 75 0c             	pushl  0xc(%ebp)
c0102c55:	ff 75 08             	pushl  0x8(%ebp)
c0102c58:	ff d0                	call   *%eax
c0102c5a:	83 c4 10             	add    $0x10,%esp
}
c0102c5d:	90                   	nop
c0102c5e:	c9                   	leave  
c0102c5f:	c3                   	ret    

c0102c60 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102c60:	55                   	push   %ebp
c0102c61:	89 e5                	mov    %esp,%ebp
c0102c63:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c6d:	e8 26 fe ff ff       	call   c0102a98 <__intr_save>
c0102c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102c75:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c7a:	8b 40 0c             	mov    0xc(%eax),%eax
c0102c7d:	83 ec 0c             	sub    $0xc,%esp
c0102c80:	ff 75 08             	pushl  0x8(%ebp)
c0102c83:	ff d0                	call   *%eax
c0102c85:	83 c4 10             	add    $0x10,%esp
c0102c88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c8b:	83 ec 0c             	sub    $0xc,%esp
c0102c8e:	ff 75 f0             	pushl  -0x10(%ebp)
c0102c91:	e8 2c fe ff ff       	call   c0102ac2 <__intr_restore>
c0102c96:	83 c4 10             	add    $0x10,%esp
    return page;
c0102c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c9c:	c9                   	leave  
c0102c9d:	c3                   	ret    

c0102c9e <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102c9e:	55                   	push   %ebp
c0102c9f:	89 e5                	mov    %esp,%ebp
c0102ca1:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ca4:	e8 ef fd ff ff       	call   c0102a98 <__intr_save>
c0102ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102cac:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102cb1:	8b 40 10             	mov    0x10(%eax),%eax
c0102cb4:	83 ec 08             	sub    $0x8,%esp
c0102cb7:	ff 75 0c             	pushl  0xc(%ebp)
c0102cba:	ff 75 08             	pushl  0x8(%ebp)
c0102cbd:	ff d0                	call   *%eax
c0102cbf:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102cc2:	83 ec 0c             	sub    $0xc,%esp
c0102cc5:	ff 75 f4             	pushl  -0xc(%ebp)
c0102cc8:	e8 f5 fd ff ff       	call   c0102ac2 <__intr_restore>
c0102ccd:	83 c4 10             	add    $0x10,%esp
}
c0102cd0:	90                   	nop
c0102cd1:	c9                   	leave  
c0102cd2:	c3                   	ret    

c0102cd3 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102cd3:	55                   	push   %ebp
c0102cd4:	89 e5                	mov    %esp,%ebp
c0102cd6:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cd9:	e8 ba fd ff ff       	call   c0102a98 <__intr_save>
c0102cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102ce1:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102ce6:	8b 40 14             	mov    0x14(%eax),%eax
c0102ce9:	ff d0                	call   *%eax
c0102ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102cee:	83 ec 0c             	sub    $0xc,%esp
c0102cf1:	ff 75 f4             	pushl  -0xc(%ebp)
c0102cf4:	e8 c9 fd ff ff       	call   c0102ac2 <__intr_restore>
c0102cf9:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102cff:	c9                   	leave  
c0102d00:	c3                   	ret    

c0102d01 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d01:	55                   	push   %ebp
c0102d02:	89 e5                	mov    %esp,%ebp
c0102d04:	57                   	push   %edi
c0102d05:	56                   	push   %esi
c0102d06:	53                   	push   %ebx
c0102d07:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d0a:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d1f:	83 ec 0c             	sub    $0xc,%esp
c0102d22:	68 a7 61 10 c0       	push   $0xc01061a7
c0102d27:	e8 43 d5 ff ff       	call   c010026f <cprintf>
c0102d2c:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d2f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d36:	e9 fc 00 00 00       	jmp    c0102e37 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d3b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d41:	89 d0                	mov    %edx,%eax
c0102d43:	c1 e0 02             	shl    $0x2,%eax
c0102d46:	01 d0                	add    %edx,%eax
c0102d48:	c1 e0 02             	shl    $0x2,%eax
c0102d4b:	01 c8                	add    %ecx,%eax
c0102d4d:	8b 50 08             	mov    0x8(%eax),%edx
c0102d50:	8b 40 04             	mov    0x4(%eax),%eax
c0102d53:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102d56:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102d59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d5f:	89 d0                	mov    %edx,%eax
c0102d61:	c1 e0 02             	shl    $0x2,%eax
c0102d64:	01 d0                	add    %edx,%eax
c0102d66:	c1 e0 02             	shl    $0x2,%eax
c0102d69:	01 c8                	add    %ecx,%eax
c0102d6b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102d6e:	8b 58 10             	mov    0x10(%eax),%ebx
c0102d71:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d74:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d77:	01 c8                	add    %ecx,%eax
c0102d79:	11 da                	adc    %ebx,%edx
c0102d7b:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102d7e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102d81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d87:	89 d0                	mov    %edx,%eax
c0102d89:	c1 e0 02             	shl    $0x2,%eax
c0102d8c:	01 d0                	add    %edx,%eax
c0102d8e:	c1 e0 02             	shl    $0x2,%eax
c0102d91:	01 c8                	add    %ecx,%eax
c0102d93:	83 c0 14             	add    $0x14,%eax
c0102d96:	8b 00                	mov    (%eax),%eax
c0102d98:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102d9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d9e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102da1:	83 c0 ff             	add    $0xffffffff,%eax
c0102da4:	83 d2 ff             	adc    $0xffffffff,%edx
c0102da7:	89 c1                	mov    %eax,%ecx
c0102da9:	89 d3                	mov    %edx,%ebx
c0102dab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102dae:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102db4:	89 d0                	mov    %edx,%eax
c0102db6:	c1 e0 02             	shl    $0x2,%eax
c0102db9:	01 d0                	add    %edx,%eax
c0102dbb:	c1 e0 02             	shl    $0x2,%eax
c0102dbe:	03 45 80             	add    -0x80(%ebp),%eax
c0102dc1:	8b 50 10             	mov    0x10(%eax),%edx
c0102dc4:	8b 40 0c             	mov    0xc(%eax),%eax
c0102dc7:	ff 75 84             	pushl  -0x7c(%ebp)
c0102dca:	53                   	push   %ebx
c0102dcb:	51                   	push   %ecx
c0102dcc:	ff 75 bc             	pushl  -0x44(%ebp)
c0102dcf:	ff 75 b8             	pushl  -0x48(%ebp)
c0102dd2:	52                   	push   %edx
c0102dd3:	50                   	push   %eax
c0102dd4:	68 b4 61 10 c0       	push   $0xc01061b4
c0102dd9:	e8 91 d4 ff ff       	call   c010026f <cprintf>
c0102dde:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102de1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102de4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102de7:	89 d0                	mov    %edx,%eax
c0102de9:	c1 e0 02             	shl    $0x2,%eax
c0102dec:	01 d0                	add    %edx,%eax
c0102dee:	c1 e0 02             	shl    $0x2,%eax
c0102df1:	01 c8                	add    %ecx,%eax
c0102df3:	83 c0 14             	add    $0x14,%eax
c0102df6:	8b 00                	mov    (%eax),%eax
c0102df8:	83 f8 01             	cmp    $0x1,%eax
c0102dfb:	75 36                	jne    c0102e33 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e03:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e06:	77 2b                	ja     c0102e33 <page_init+0x132>
c0102e08:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e0b:	72 05                	jb     c0102e12 <page_init+0x111>
c0102e0d:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102e10:	73 21                	jae    c0102e33 <page_init+0x132>
c0102e12:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e16:	77 1b                	ja     c0102e33 <page_init+0x132>
c0102e18:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e1c:	72 09                	jb     c0102e27 <page_init+0x126>
c0102e1e:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102e25:	77 0c                	ja     c0102e33 <page_init+0x132>
                maxpa = end;
c0102e27:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e2a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e30:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e33:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e3a:	8b 00                	mov    (%eax),%eax
c0102e3c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102e3f:	0f 8f f6 fe ff ff    	jg     c0102d3b <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102e45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102e49:	72 1d                	jb     c0102e68 <page_init+0x167>
c0102e4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102e4f:	77 09                	ja     c0102e5a <page_init+0x159>
c0102e51:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102e58:	76 0e                	jbe    c0102e68 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102e5a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102e61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e6e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102e72:	c1 ea 0c             	shr    $0xc,%edx
c0102e75:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102e7a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102e81:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c0102e86:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e89:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e8c:	01 d0                	add    %edx,%eax
c0102e8e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102e91:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e94:	ba 00 00 00 00       	mov    $0x0,%edx
c0102e99:	f7 75 ac             	divl   -0x54(%ebp)
c0102e9c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e9f:	29 d0                	sub    %edx,%eax
c0102ea1:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    for (i = 0; i < npage; i ++) {
c0102ea6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102ead:	eb 2f                	jmp    c0102ede <page_init+0x1dd>
        SetPageReserved(pages + i);
c0102eaf:	8b 0d b8 89 11 c0    	mov    0xc01189b8,%ecx
c0102eb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eb8:	89 d0                	mov    %edx,%eax
c0102eba:	c1 e0 02             	shl    $0x2,%eax
c0102ebd:	01 d0                	add    %edx,%eax
c0102ebf:	c1 e0 02             	shl    $0x2,%eax
c0102ec2:	01 c8                	add    %ecx,%eax
c0102ec4:	83 c0 04             	add    $0x4,%eax
c0102ec7:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102ece:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ed1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ed4:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102ed7:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102eda:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ee1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102ee6:	39 c2                	cmp    %eax,%edx
c0102ee8:	72 c5                	jb     c0102eaf <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102eea:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102ef0:	89 d0                	mov    %edx,%eax
c0102ef2:	c1 e0 02             	shl    $0x2,%eax
c0102ef5:	01 d0                	add    %edx,%eax
c0102ef7:	c1 e0 02             	shl    $0x2,%eax
c0102efa:	89 c2                	mov    %eax,%edx
c0102efc:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102f01:	01 d0                	add    %edx,%eax
c0102f03:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102f06:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102f0d:	77 17                	ja     c0102f26 <page_init+0x225>
c0102f0f:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102f12:	68 e4 61 10 c0       	push   $0xc01061e4
c0102f17:	68 db 00 00 00       	push   $0xdb
c0102f1c:	68 08 62 10 c0       	push   $0xc0106208
c0102f21:	e8 af d4 ff ff       	call   c01003d5 <__panic>
c0102f26:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f29:	05 00 00 00 40       	add    $0x40000000,%eax
c0102f2e:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102f31:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f38:	e9 69 01 00 00       	jmp    c01030a6 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f3d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f40:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f43:	89 d0                	mov    %edx,%eax
c0102f45:	c1 e0 02             	shl    $0x2,%eax
c0102f48:	01 d0                	add    %edx,%eax
c0102f4a:	c1 e0 02             	shl    $0x2,%eax
c0102f4d:	01 c8                	add    %ecx,%eax
c0102f4f:	8b 50 08             	mov    0x8(%eax),%edx
c0102f52:	8b 40 04             	mov    0x4(%eax),%eax
c0102f55:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f58:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102f5b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f5e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f61:	89 d0                	mov    %edx,%eax
c0102f63:	c1 e0 02             	shl    $0x2,%eax
c0102f66:	01 d0                	add    %edx,%eax
c0102f68:	c1 e0 02             	shl    $0x2,%eax
c0102f6b:	01 c8                	add    %ecx,%eax
c0102f6d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102f70:	8b 58 10             	mov    0x10(%eax),%ebx
c0102f73:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f76:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f79:	01 c8                	add    %ecx,%eax
c0102f7b:	11 da                	adc    %ebx,%edx
c0102f7d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102f80:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102f83:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f86:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f89:	89 d0                	mov    %edx,%eax
c0102f8b:	c1 e0 02             	shl    $0x2,%eax
c0102f8e:	01 d0                	add    %edx,%eax
c0102f90:	c1 e0 02             	shl    $0x2,%eax
c0102f93:	01 c8                	add    %ecx,%eax
c0102f95:	83 c0 14             	add    $0x14,%eax
c0102f98:	8b 00                	mov    (%eax),%eax
c0102f9a:	83 f8 01             	cmp    $0x1,%eax
c0102f9d:	0f 85 ff 00 00 00    	jne    c01030a2 <page_init+0x3a1>
            if (begin < freemem) {
c0102fa3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fa6:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fab:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102fae:	72 17                	jb     c0102fc7 <page_init+0x2c6>
c0102fb0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102fb3:	77 05                	ja     c0102fba <page_init+0x2b9>
c0102fb5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102fb8:	76 0d                	jbe    c0102fc7 <page_init+0x2c6>
                begin = freemem;
c0102fba:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fbd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fc0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102fc7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102fcb:	72 1d                	jb     c0102fea <page_init+0x2e9>
c0102fcd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102fd1:	77 09                	ja     c0102fdc <page_init+0x2db>
c0102fd3:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102fda:	76 0e                	jbe    c0102fea <page_init+0x2e9>
                end = KMEMSIZE;
c0102fdc:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102fe3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102fea:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ff0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102ff3:	0f 87 a9 00 00 00    	ja     c01030a2 <page_init+0x3a1>
c0102ff9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102ffc:	72 09                	jb     c0103007 <page_init+0x306>
c0102ffe:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103001:	0f 83 9b 00 00 00    	jae    c01030a2 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0103007:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010300e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103011:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103014:	01 d0                	add    %edx,%eax
c0103016:	83 e8 01             	sub    $0x1,%eax
c0103019:	89 45 98             	mov    %eax,-0x68(%ebp)
c010301c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010301f:	ba 00 00 00 00       	mov    $0x0,%edx
c0103024:	f7 75 9c             	divl   -0x64(%ebp)
c0103027:	8b 45 98             	mov    -0x68(%ebp),%eax
c010302a:	29 d0                	sub    %edx,%eax
c010302c:	ba 00 00 00 00       	mov    $0x0,%edx
c0103031:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103034:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103037:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010303a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010303d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103040:	ba 00 00 00 00       	mov    $0x0,%edx
c0103045:	89 c3                	mov    %eax,%ebx
c0103047:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010304d:	89 de                	mov    %ebx,%esi
c010304f:	89 d0                	mov    %edx,%eax
c0103051:	83 e0 00             	and    $0x0,%eax
c0103054:	89 c7                	mov    %eax,%edi
c0103056:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103059:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c010305c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010305f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103062:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103065:	77 3b                	ja     c01030a2 <page_init+0x3a1>
c0103067:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010306a:	72 05                	jb     c0103071 <page_init+0x370>
c010306c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010306f:	73 31                	jae    c01030a2 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103071:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103074:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103077:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010307a:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010307d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103081:	c1 ea 0c             	shr    $0xc,%edx
c0103084:	89 c3                	mov    %eax,%ebx
c0103086:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103089:	83 ec 0c             	sub    $0xc,%esp
c010308c:	50                   	push   %eax
c010308d:	e8 ec f8 ff ff       	call   c010297e <pa2page>
c0103092:	83 c4 10             	add    $0x10,%esp
c0103095:	83 ec 08             	sub    $0x8,%esp
c0103098:	53                   	push   %ebx
c0103099:	50                   	push   %eax
c010309a:	e8 a2 fb ff ff       	call   c0102c41 <init_memmap>
c010309f:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01030a2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01030a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030a9:	8b 00                	mov    (%eax),%eax
c01030ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01030ae:	0f 8f 89 fe ff ff    	jg     c0102f3d <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01030b4:	90                   	nop
c01030b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01030b8:	5b                   	pop    %ebx
c01030b9:	5e                   	pop    %esi
c01030ba:	5f                   	pop    %edi
c01030bb:	5d                   	pop    %ebp
c01030bc:	c3                   	ret    

c01030bd <enable_paging>:

static void
enable_paging(void) {
c01030bd:	55                   	push   %ebp
c01030be:	89 e5                	mov    %esp,%ebp
c01030c0:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01030c3:	a1 b4 89 11 c0       	mov    0xc01189b4,%eax
c01030c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01030cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01030ce:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01030d1:	0f 20 c0             	mov    %cr0,%eax
c01030d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01030da:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01030dd:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01030e4:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c01030e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01030eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030f1:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01030f4:	90                   	nop
c01030f5:	c9                   	leave  
c01030f6:	c3                   	ret    

c01030f7 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01030f7:	55                   	push   %ebp
c01030f8:	89 e5                	mov    %esp,%ebp
c01030fa:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01030fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103100:	33 45 14             	xor    0x14(%ebp),%eax
c0103103:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103108:	85 c0                	test   %eax,%eax
c010310a:	74 19                	je     c0103125 <boot_map_segment+0x2e>
c010310c:	68 16 62 10 c0       	push   $0xc0106216
c0103111:	68 2d 62 10 c0       	push   $0xc010622d
c0103116:	68 04 01 00 00       	push   $0x104
c010311b:	68 08 62 10 c0       	push   $0xc0106208
c0103120:	e8 b0 d2 ff ff       	call   c01003d5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103125:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010312c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010312f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103134:	89 c2                	mov    %eax,%edx
c0103136:	8b 45 10             	mov    0x10(%ebp),%eax
c0103139:	01 c2                	add    %eax,%edx
c010313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010313e:	01 d0                	add    %edx,%eax
c0103140:	83 e8 01             	sub    $0x1,%eax
c0103143:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103146:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103149:	ba 00 00 00 00       	mov    $0x0,%edx
c010314e:	f7 75 f0             	divl   -0x10(%ebp)
c0103151:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103154:	29 d0                	sub    %edx,%eax
c0103156:	c1 e8 0c             	shr    $0xc,%eax
c0103159:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010315c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010315f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103162:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103165:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010316a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010316d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103176:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010317b:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010317e:	eb 57                	jmp    c01031d7 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103180:	83 ec 04             	sub    $0x4,%esp
c0103183:	6a 01                	push   $0x1
c0103185:	ff 75 0c             	pushl  0xc(%ebp)
c0103188:	ff 75 08             	pushl  0x8(%ebp)
c010318b:	e8 98 01 00 00       	call   c0103328 <get_pte>
c0103190:	83 c4 10             	add    $0x10,%esp
c0103193:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103196:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010319a:	75 19                	jne    c01031b5 <boot_map_segment+0xbe>
c010319c:	68 42 62 10 c0       	push   $0xc0106242
c01031a1:	68 2d 62 10 c0       	push   $0xc010622d
c01031a6:	68 0a 01 00 00       	push   $0x10a
c01031ab:	68 08 62 10 c0       	push   $0xc0106208
c01031b0:	e8 20 d2 ff ff       	call   c01003d5 <__panic>
        *ptep = pa | PTE_P | perm;
c01031b5:	8b 45 14             	mov    0x14(%ebp),%eax
c01031b8:	0b 45 18             	or     0x18(%ebp),%eax
c01031bb:	83 c8 01             	or     $0x1,%eax
c01031be:	89 c2                	mov    %eax,%edx
c01031c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031c3:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031c5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01031c9:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01031d0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01031d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031db:	75 a3                	jne    c0103180 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01031dd:	90                   	nop
c01031de:	c9                   	leave  
c01031df:	c3                   	ret    

c01031e0 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01031e0:	55                   	push   %ebp
c01031e1:	89 e5                	mov    %esp,%ebp
c01031e3:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01031e6:	83 ec 0c             	sub    $0xc,%esp
c01031e9:	6a 01                	push   $0x1
c01031eb:	e8 70 fa ff ff       	call   c0102c60 <alloc_pages>
c01031f0:	83 c4 10             	add    $0x10,%esp
c01031f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01031f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031fa:	75 17                	jne    c0103213 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c01031fc:	83 ec 04             	sub    $0x4,%esp
c01031ff:	68 4f 62 10 c0       	push   $0xc010624f
c0103204:	68 16 01 00 00       	push   $0x116
c0103209:	68 08 62 10 c0       	push   $0xc0106208
c010320e:	e8 c2 d1 ff ff       	call   c01003d5 <__panic>
    }
    return page2kva(p);
c0103213:	83 ec 0c             	sub    $0xc,%esp
c0103216:	ff 75 f4             	pushl  -0xc(%ebp)
c0103219:	e8 a7 f7 ff ff       	call   c01029c5 <page2kva>
c010321e:	83 c4 10             	add    $0x10,%esp
}
c0103221:	c9                   	leave  
c0103222:	c3                   	ret    

c0103223 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103223:	55                   	push   %ebp
c0103224:	89 e5                	mov    %esp,%ebp
c0103226:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103229:	e8 de f9 ff ff       	call   c0102c0c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010322e:	e8 ce fa ff ff       	call   c0102d01 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103233:	e8 85 02 00 00       	call   c01034bd <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0103238:	e8 a3 ff ff ff       	call   c01031e0 <boot_alloc_page>
c010323d:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0103242:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103247:	83 ec 04             	sub    $0x4,%esp
c010324a:	68 00 10 00 00       	push   $0x1000
c010324f:	6a 00                	push   $0x0
c0103251:	50                   	push   %eax
c0103252:	e8 fb 1f 00 00       	call   c0105252 <memset>
c0103257:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c010325a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010325f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103262:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103269:	77 17                	ja     c0103282 <pmm_init+0x5f>
c010326b:	ff 75 f4             	pushl  -0xc(%ebp)
c010326e:	68 e4 61 10 c0       	push   $0xc01061e4
c0103273:	68 30 01 00 00       	push   $0x130
c0103278:	68 08 62 10 c0       	push   $0xc0106208
c010327d:	e8 53 d1 ff ff       	call   c01003d5 <__panic>
c0103282:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103285:	05 00 00 00 40       	add    $0x40000000,%eax
c010328a:	a3 b4 89 11 c0       	mov    %eax,0xc01189b4

    check_pgdir();
c010328f:	e8 4c 02 00 00       	call   c01034e0 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103294:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103299:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010329f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032a7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01032ae:	77 17                	ja     c01032c7 <pmm_init+0xa4>
c01032b0:	ff 75 f0             	pushl  -0x10(%ebp)
c01032b3:	68 e4 61 10 c0       	push   $0xc01061e4
c01032b8:	68 38 01 00 00       	push   $0x138
c01032bd:	68 08 62 10 c0       	push   $0xc0106208
c01032c2:	e8 0e d1 ff ff       	call   c01003d5 <__panic>
c01032c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032ca:	05 00 00 00 40       	add    $0x40000000,%eax
c01032cf:	83 c8 03             	or     $0x3,%eax
c01032d2:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01032d4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032d9:	83 ec 0c             	sub    $0xc,%esp
c01032dc:	6a 02                	push   $0x2
c01032de:	6a 00                	push   $0x0
c01032e0:	68 00 00 00 38       	push   $0x38000000
c01032e5:	68 00 00 00 c0       	push   $0xc0000000
c01032ea:	50                   	push   %eax
c01032eb:	e8 07 fe ff ff       	call   c01030f7 <boot_map_segment>
c01032f0:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01032f3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032f8:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01032fe:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103304:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103306:	e8 b2 fd ff ff       	call   c01030bd <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010330b:	e8 0a f8 ff ff       	call   c0102b1a <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103310:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010331b:	e8 26 07 00 00       	call   c0103a46 <check_boot_pgdir>

    print_pgdir();
c0103320:	e8 1c 0b 00 00       	call   c0103e41 <print_pgdir>

}
c0103325:	90                   	nop
c0103326:	c9                   	leave  
c0103327:	c3                   	ret    

c0103328 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103328:	55                   	push   %ebp
c0103329:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010332b:	90                   	nop
c010332c:	5d                   	pop    %ebp
c010332d:	c3                   	ret    

c010332e <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010332e:	55                   	push   %ebp
c010332f:	89 e5                	mov    %esp,%ebp
c0103331:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103334:	6a 00                	push   $0x0
c0103336:	ff 75 0c             	pushl  0xc(%ebp)
c0103339:	ff 75 08             	pushl  0x8(%ebp)
c010333c:	e8 e7 ff ff ff       	call   c0103328 <get_pte>
c0103341:	83 c4 0c             	add    $0xc,%esp
c0103344:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103347:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010334b:	74 08                	je     c0103355 <get_page+0x27>
        *ptep_store = ptep;
c010334d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103350:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103353:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103355:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103359:	74 1f                	je     c010337a <get_page+0x4c>
c010335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010335e:	8b 00                	mov    (%eax),%eax
c0103360:	83 e0 01             	and    $0x1,%eax
c0103363:	85 c0                	test   %eax,%eax
c0103365:	74 13                	je     c010337a <get_page+0x4c>
        return pte2page(*ptep);
c0103367:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010336a:	8b 00                	mov    (%eax),%eax
c010336c:	83 ec 0c             	sub    $0xc,%esp
c010336f:	50                   	push   %eax
c0103370:	e8 95 f6 ff ff       	call   c0102a0a <pte2page>
c0103375:	83 c4 10             	add    $0x10,%esp
c0103378:	eb 05                	jmp    c010337f <get_page+0x51>
    }
    return NULL;
c010337a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010337f:	c9                   	leave  
c0103380:	c3                   	ret    

c0103381 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103381:	55                   	push   %ebp
c0103382:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103384:	90                   	nop
c0103385:	5d                   	pop    %ebp
c0103386:	c3                   	ret    

c0103387 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103387:	55                   	push   %ebp
c0103388:	89 e5                	mov    %esp,%ebp
c010338a:	83 ec 10             	sub    $0x10,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010338d:	6a 00                	push   $0x0
c010338f:	ff 75 0c             	pushl  0xc(%ebp)
c0103392:	ff 75 08             	pushl  0x8(%ebp)
c0103395:	e8 8e ff ff ff       	call   c0103328 <get_pte>
c010339a:	83 c4 0c             	add    $0xc,%esp
c010339d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01033a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01033a4:	74 11                	je     c01033b7 <page_remove+0x30>
        page_remove_pte(pgdir, la, ptep);
c01033a6:	ff 75 fc             	pushl  -0x4(%ebp)
c01033a9:	ff 75 0c             	pushl  0xc(%ebp)
c01033ac:	ff 75 08             	pushl  0x8(%ebp)
c01033af:	e8 cd ff ff ff       	call   c0103381 <page_remove_pte>
c01033b4:	83 c4 0c             	add    $0xc,%esp
    }
}
c01033b7:	90                   	nop
c01033b8:	c9                   	leave  
c01033b9:	c3                   	ret    

c01033ba <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01033ba:	55                   	push   %ebp
c01033bb:	89 e5                	mov    %esp,%ebp
c01033bd:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01033c0:	6a 01                	push   $0x1
c01033c2:	ff 75 10             	pushl  0x10(%ebp)
c01033c5:	ff 75 08             	pushl  0x8(%ebp)
c01033c8:	e8 5b ff ff ff       	call   c0103328 <get_pte>
c01033cd:	83 c4 0c             	add    $0xc,%esp
c01033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01033d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033d7:	75 0a                	jne    c01033e3 <page_insert+0x29>
        return -E_NO_MEM;
c01033d9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01033de:	e9 88 00 00 00       	jmp    c010346b <page_insert+0xb1>
    }
    page_ref_inc(page);
c01033e3:	ff 75 0c             	pushl  0xc(%ebp)
c01033e6:	e8 7f f6 ff ff       	call   c0102a6a <page_ref_inc>
c01033eb:	83 c4 04             	add    $0x4,%esp
    if (*ptep & PTE_P) {
c01033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f1:	8b 00                	mov    (%eax),%eax
c01033f3:	83 e0 01             	and    $0x1,%eax
c01033f6:	85 c0                	test   %eax,%eax
c01033f8:	74 40                	je     c010343a <page_insert+0x80>
        struct Page *p = pte2page(*ptep);
c01033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033fd:	8b 00                	mov    (%eax),%eax
c01033ff:	83 ec 0c             	sub    $0xc,%esp
c0103402:	50                   	push   %eax
c0103403:	e8 02 f6 ff ff       	call   c0102a0a <pte2page>
c0103408:	83 c4 10             	add    $0x10,%esp
c010340b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010340e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103411:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103414:	75 10                	jne    c0103426 <page_insert+0x6c>
            page_ref_dec(page);
c0103416:	83 ec 0c             	sub    $0xc,%esp
c0103419:	ff 75 0c             	pushl  0xc(%ebp)
c010341c:	e8 60 f6 ff ff       	call   c0102a81 <page_ref_dec>
c0103421:	83 c4 10             	add    $0x10,%esp
c0103424:	eb 14                	jmp    c010343a <page_insert+0x80>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103426:	83 ec 04             	sub    $0x4,%esp
c0103429:	ff 75 f4             	pushl  -0xc(%ebp)
c010342c:	ff 75 10             	pushl  0x10(%ebp)
c010342f:	ff 75 08             	pushl  0x8(%ebp)
c0103432:	e8 4a ff ff ff       	call   c0103381 <page_remove_pte>
c0103437:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010343a:	83 ec 0c             	sub    $0xc,%esp
c010343d:	ff 75 0c             	pushl  0xc(%ebp)
c0103440:	e8 26 f5 ff ff       	call   c010296b <page2pa>
c0103445:	83 c4 10             	add    $0x10,%esp
c0103448:	0b 45 14             	or     0x14(%ebp),%eax
c010344b:	83 c8 01             	or     $0x1,%eax
c010344e:	89 c2                	mov    %eax,%edx
c0103450:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103453:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103455:	83 ec 08             	sub    $0x8,%esp
c0103458:	ff 75 10             	pushl  0x10(%ebp)
c010345b:	ff 75 08             	pushl  0x8(%ebp)
c010345e:	e8 0a 00 00 00       	call   c010346d <tlb_invalidate>
c0103463:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103466:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010346b:	c9                   	leave  
c010346c:	c3                   	ret    

c010346d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010346d:	55                   	push   %ebp
c010346e:	89 e5                	mov    %esp,%ebp
c0103470:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103473:	0f 20 d8             	mov    %cr3,%eax
c0103476:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0103479:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010347c:	8b 45 08             	mov    0x8(%ebp),%eax
c010347f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103482:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103489:	77 17                	ja     c01034a2 <tlb_invalidate+0x35>
c010348b:	ff 75 f0             	pushl  -0x10(%ebp)
c010348e:	68 e4 61 10 c0       	push   $0xc01061e4
c0103493:	68 d8 01 00 00       	push   $0x1d8
c0103498:	68 08 62 10 c0       	push   $0xc0106208
c010349d:	e8 33 cf ff ff       	call   c01003d5 <__panic>
c01034a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034a5:	05 00 00 00 40       	add    $0x40000000,%eax
c01034aa:	39 c2                	cmp    %eax,%edx
c01034ac:	75 0c                	jne    c01034ba <tlb_invalidate+0x4d>
        invlpg((void *)la);
c01034ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01034b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b7:	0f 01 38             	invlpg (%eax)
    }
}
c01034ba:	90                   	nop
c01034bb:	c9                   	leave  
c01034bc:	c3                   	ret    

c01034bd <check_alloc_page>:

static void
check_alloc_page(void) {
c01034bd:	55                   	push   %ebp
c01034be:	89 e5                	mov    %esp,%ebp
c01034c0:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01034c3:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c01034c8:	8b 40 18             	mov    0x18(%eax),%eax
c01034cb:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01034cd:	83 ec 0c             	sub    $0xc,%esp
c01034d0:	68 68 62 10 c0       	push   $0xc0106268
c01034d5:	e8 95 cd ff ff       	call   c010026f <cprintf>
c01034da:	83 c4 10             	add    $0x10,%esp
}
c01034dd:	90                   	nop
c01034de:	c9                   	leave  
c01034df:	c3                   	ret    

c01034e0 <check_pgdir>:

static void
check_pgdir(void) {
c01034e0:	55                   	push   %ebp
c01034e1:	89 e5                	mov    %esp,%ebp
c01034e3:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01034e6:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01034eb:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01034f0:	76 19                	jbe    c010350b <check_pgdir+0x2b>
c01034f2:	68 87 62 10 c0       	push   $0xc0106287
c01034f7:	68 2d 62 10 c0       	push   $0xc010622d
c01034fc:	68 e5 01 00 00       	push   $0x1e5
c0103501:	68 08 62 10 c0       	push   $0xc0106208
c0103506:	e8 ca ce ff ff       	call   c01003d5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010350b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103510:	85 c0                	test   %eax,%eax
c0103512:	74 0e                	je     c0103522 <check_pgdir+0x42>
c0103514:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103519:	25 ff 0f 00 00       	and    $0xfff,%eax
c010351e:	85 c0                	test   %eax,%eax
c0103520:	74 19                	je     c010353b <check_pgdir+0x5b>
c0103522:	68 a4 62 10 c0       	push   $0xc01062a4
c0103527:	68 2d 62 10 c0       	push   $0xc010622d
c010352c:	68 e6 01 00 00       	push   $0x1e6
c0103531:	68 08 62 10 c0       	push   $0xc0106208
c0103536:	e8 9a ce ff ff       	call   c01003d5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010353b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103540:	83 ec 04             	sub    $0x4,%esp
c0103543:	6a 00                	push   $0x0
c0103545:	6a 00                	push   $0x0
c0103547:	50                   	push   %eax
c0103548:	e8 e1 fd ff ff       	call   c010332e <get_page>
c010354d:	83 c4 10             	add    $0x10,%esp
c0103550:	85 c0                	test   %eax,%eax
c0103552:	74 19                	je     c010356d <check_pgdir+0x8d>
c0103554:	68 dc 62 10 c0       	push   $0xc01062dc
c0103559:	68 2d 62 10 c0       	push   $0xc010622d
c010355e:	68 e7 01 00 00       	push   $0x1e7
c0103563:	68 08 62 10 c0       	push   $0xc0106208
c0103568:	e8 68 ce ff ff       	call   c01003d5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010356d:	83 ec 0c             	sub    $0xc,%esp
c0103570:	6a 01                	push   $0x1
c0103572:	e8 e9 f6 ff ff       	call   c0102c60 <alloc_pages>
c0103577:	83 c4 10             	add    $0x10,%esp
c010357a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010357d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103582:	6a 00                	push   $0x0
c0103584:	6a 00                	push   $0x0
c0103586:	ff 75 f4             	pushl  -0xc(%ebp)
c0103589:	50                   	push   %eax
c010358a:	e8 2b fe ff ff       	call   c01033ba <page_insert>
c010358f:	83 c4 10             	add    $0x10,%esp
c0103592:	85 c0                	test   %eax,%eax
c0103594:	74 19                	je     c01035af <check_pgdir+0xcf>
c0103596:	68 04 63 10 c0       	push   $0xc0106304
c010359b:	68 2d 62 10 c0       	push   $0xc010622d
c01035a0:	68 eb 01 00 00       	push   $0x1eb
c01035a5:	68 08 62 10 c0       	push   $0xc0106208
c01035aa:	e8 26 ce ff ff       	call   c01003d5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01035af:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01035b4:	83 ec 04             	sub    $0x4,%esp
c01035b7:	6a 00                	push   $0x0
c01035b9:	6a 00                	push   $0x0
c01035bb:	50                   	push   %eax
c01035bc:	e8 67 fd ff ff       	call   c0103328 <get_pte>
c01035c1:	83 c4 10             	add    $0x10,%esp
c01035c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01035cb:	75 19                	jne    c01035e6 <check_pgdir+0x106>
c01035cd:	68 30 63 10 c0       	push   $0xc0106330
c01035d2:	68 2d 62 10 c0       	push   $0xc010622d
c01035d7:	68 ee 01 00 00       	push   $0x1ee
c01035dc:	68 08 62 10 c0       	push   $0xc0106208
c01035e1:	e8 ef cd ff ff       	call   c01003d5 <__panic>
    assert(pte2page(*ptep) == p1);
c01035e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035e9:	8b 00                	mov    (%eax),%eax
c01035eb:	83 ec 0c             	sub    $0xc,%esp
c01035ee:	50                   	push   %eax
c01035ef:	e8 16 f4 ff ff       	call   c0102a0a <pte2page>
c01035f4:	83 c4 10             	add    $0x10,%esp
c01035f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01035fa:	74 19                	je     c0103615 <check_pgdir+0x135>
c01035fc:	68 5d 63 10 c0       	push   $0xc010635d
c0103601:	68 2d 62 10 c0       	push   $0xc010622d
c0103606:	68 ef 01 00 00       	push   $0x1ef
c010360b:	68 08 62 10 c0       	push   $0xc0106208
c0103610:	e8 c0 cd ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p1) == 1);
c0103615:	83 ec 0c             	sub    $0xc,%esp
c0103618:	ff 75 f4             	pushl  -0xc(%ebp)
c010361b:	e8 40 f4 ff ff       	call   c0102a60 <page_ref>
c0103620:	83 c4 10             	add    $0x10,%esp
c0103623:	83 f8 01             	cmp    $0x1,%eax
c0103626:	74 19                	je     c0103641 <check_pgdir+0x161>
c0103628:	68 73 63 10 c0       	push   $0xc0106373
c010362d:	68 2d 62 10 c0       	push   $0xc010622d
c0103632:	68 f0 01 00 00       	push   $0x1f0
c0103637:	68 08 62 10 c0       	push   $0xc0106208
c010363c:	e8 94 cd ff ff       	call   c01003d5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103641:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103646:	8b 00                	mov    (%eax),%eax
c0103648:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010364d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103650:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103653:	c1 e8 0c             	shr    $0xc,%eax
c0103656:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103659:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010365e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103661:	72 17                	jb     c010367a <check_pgdir+0x19a>
c0103663:	ff 75 ec             	pushl  -0x14(%ebp)
c0103666:	68 40 61 10 c0       	push   $0xc0106140
c010366b:	68 f2 01 00 00       	push   $0x1f2
c0103670:	68 08 62 10 c0       	push   $0xc0106208
c0103675:	e8 5b cd ff ff       	call   c01003d5 <__panic>
c010367a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010367d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103682:	83 c0 04             	add    $0x4,%eax
c0103685:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103688:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010368d:	83 ec 04             	sub    $0x4,%esp
c0103690:	6a 00                	push   $0x0
c0103692:	68 00 10 00 00       	push   $0x1000
c0103697:	50                   	push   %eax
c0103698:	e8 8b fc ff ff       	call   c0103328 <get_pte>
c010369d:	83 c4 10             	add    $0x10,%esp
c01036a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01036a3:	74 19                	je     c01036be <check_pgdir+0x1de>
c01036a5:	68 88 63 10 c0       	push   $0xc0106388
c01036aa:	68 2d 62 10 c0       	push   $0xc010622d
c01036af:	68 f3 01 00 00       	push   $0x1f3
c01036b4:	68 08 62 10 c0       	push   $0xc0106208
c01036b9:	e8 17 cd ff ff       	call   c01003d5 <__panic>

    p2 = alloc_page();
c01036be:	83 ec 0c             	sub    $0xc,%esp
c01036c1:	6a 01                	push   $0x1
c01036c3:	e8 98 f5 ff ff       	call   c0102c60 <alloc_pages>
c01036c8:	83 c4 10             	add    $0x10,%esp
c01036cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01036ce:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036d3:	6a 06                	push   $0x6
c01036d5:	68 00 10 00 00       	push   $0x1000
c01036da:	ff 75 e4             	pushl  -0x1c(%ebp)
c01036dd:	50                   	push   %eax
c01036de:	e8 d7 fc ff ff       	call   c01033ba <page_insert>
c01036e3:	83 c4 10             	add    $0x10,%esp
c01036e6:	85 c0                	test   %eax,%eax
c01036e8:	74 19                	je     c0103703 <check_pgdir+0x223>
c01036ea:	68 b0 63 10 c0       	push   $0xc01063b0
c01036ef:	68 2d 62 10 c0       	push   $0xc010622d
c01036f4:	68 f6 01 00 00       	push   $0x1f6
c01036f9:	68 08 62 10 c0       	push   $0xc0106208
c01036fe:	e8 d2 cc ff ff       	call   c01003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103703:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103708:	83 ec 04             	sub    $0x4,%esp
c010370b:	6a 00                	push   $0x0
c010370d:	68 00 10 00 00       	push   $0x1000
c0103712:	50                   	push   %eax
c0103713:	e8 10 fc ff ff       	call   c0103328 <get_pte>
c0103718:	83 c4 10             	add    $0x10,%esp
c010371b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010371e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103722:	75 19                	jne    c010373d <check_pgdir+0x25d>
c0103724:	68 e8 63 10 c0       	push   $0xc01063e8
c0103729:	68 2d 62 10 c0       	push   $0xc010622d
c010372e:	68 f7 01 00 00       	push   $0x1f7
c0103733:	68 08 62 10 c0       	push   $0xc0106208
c0103738:	e8 98 cc ff ff       	call   c01003d5 <__panic>
    assert(*ptep & PTE_U);
c010373d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103740:	8b 00                	mov    (%eax),%eax
c0103742:	83 e0 04             	and    $0x4,%eax
c0103745:	85 c0                	test   %eax,%eax
c0103747:	75 19                	jne    c0103762 <check_pgdir+0x282>
c0103749:	68 18 64 10 c0       	push   $0xc0106418
c010374e:	68 2d 62 10 c0       	push   $0xc010622d
c0103753:	68 f8 01 00 00       	push   $0x1f8
c0103758:	68 08 62 10 c0       	push   $0xc0106208
c010375d:	e8 73 cc ff ff       	call   c01003d5 <__panic>
    assert(*ptep & PTE_W);
c0103762:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103765:	8b 00                	mov    (%eax),%eax
c0103767:	83 e0 02             	and    $0x2,%eax
c010376a:	85 c0                	test   %eax,%eax
c010376c:	75 19                	jne    c0103787 <check_pgdir+0x2a7>
c010376e:	68 26 64 10 c0       	push   $0xc0106426
c0103773:	68 2d 62 10 c0       	push   $0xc010622d
c0103778:	68 f9 01 00 00       	push   $0x1f9
c010377d:	68 08 62 10 c0       	push   $0xc0106208
c0103782:	e8 4e cc ff ff       	call   c01003d5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103787:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010378c:	8b 00                	mov    (%eax),%eax
c010378e:	83 e0 04             	and    $0x4,%eax
c0103791:	85 c0                	test   %eax,%eax
c0103793:	75 19                	jne    c01037ae <check_pgdir+0x2ce>
c0103795:	68 34 64 10 c0       	push   $0xc0106434
c010379a:	68 2d 62 10 c0       	push   $0xc010622d
c010379f:	68 fa 01 00 00       	push   $0x1fa
c01037a4:	68 08 62 10 c0       	push   $0xc0106208
c01037a9:	e8 27 cc ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 1);
c01037ae:	83 ec 0c             	sub    $0xc,%esp
c01037b1:	ff 75 e4             	pushl  -0x1c(%ebp)
c01037b4:	e8 a7 f2 ff ff       	call   c0102a60 <page_ref>
c01037b9:	83 c4 10             	add    $0x10,%esp
c01037bc:	83 f8 01             	cmp    $0x1,%eax
c01037bf:	74 19                	je     c01037da <check_pgdir+0x2fa>
c01037c1:	68 4a 64 10 c0       	push   $0xc010644a
c01037c6:	68 2d 62 10 c0       	push   $0xc010622d
c01037cb:	68 fb 01 00 00       	push   $0x1fb
c01037d0:	68 08 62 10 c0       	push   $0xc0106208
c01037d5:	e8 fb cb ff ff       	call   c01003d5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01037da:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037df:	6a 00                	push   $0x0
c01037e1:	68 00 10 00 00       	push   $0x1000
c01037e6:	ff 75 f4             	pushl  -0xc(%ebp)
c01037e9:	50                   	push   %eax
c01037ea:	e8 cb fb ff ff       	call   c01033ba <page_insert>
c01037ef:	83 c4 10             	add    $0x10,%esp
c01037f2:	85 c0                	test   %eax,%eax
c01037f4:	74 19                	je     c010380f <check_pgdir+0x32f>
c01037f6:	68 5c 64 10 c0       	push   $0xc010645c
c01037fb:	68 2d 62 10 c0       	push   $0xc010622d
c0103800:	68 fd 01 00 00       	push   $0x1fd
c0103805:	68 08 62 10 c0       	push   $0xc0106208
c010380a:	e8 c6 cb ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p1) == 2);
c010380f:	83 ec 0c             	sub    $0xc,%esp
c0103812:	ff 75 f4             	pushl  -0xc(%ebp)
c0103815:	e8 46 f2 ff ff       	call   c0102a60 <page_ref>
c010381a:	83 c4 10             	add    $0x10,%esp
c010381d:	83 f8 02             	cmp    $0x2,%eax
c0103820:	74 19                	je     c010383b <check_pgdir+0x35b>
c0103822:	68 88 64 10 c0       	push   $0xc0106488
c0103827:	68 2d 62 10 c0       	push   $0xc010622d
c010382c:	68 fe 01 00 00       	push   $0x1fe
c0103831:	68 08 62 10 c0       	push   $0xc0106208
c0103836:	e8 9a cb ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c010383b:	83 ec 0c             	sub    $0xc,%esp
c010383e:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103841:	e8 1a f2 ff ff       	call   c0102a60 <page_ref>
c0103846:	83 c4 10             	add    $0x10,%esp
c0103849:	85 c0                	test   %eax,%eax
c010384b:	74 19                	je     c0103866 <check_pgdir+0x386>
c010384d:	68 9a 64 10 c0       	push   $0xc010649a
c0103852:	68 2d 62 10 c0       	push   $0xc010622d
c0103857:	68 ff 01 00 00       	push   $0x1ff
c010385c:	68 08 62 10 c0       	push   $0xc0106208
c0103861:	e8 6f cb ff ff       	call   c01003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103866:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010386b:	83 ec 04             	sub    $0x4,%esp
c010386e:	6a 00                	push   $0x0
c0103870:	68 00 10 00 00       	push   $0x1000
c0103875:	50                   	push   %eax
c0103876:	e8 ad fa ff ff       	call   c0103328 <get_pte>
c010387b:	83 c4 10             	add    $0x10,%esp
c010387e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103881:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103885:	75 19                	jne    c01038a0 <check_pgdir+0x3c0>
c0103887:	68 e8 63 10 c0       	push   $0xc01063e8
c010388c:	68 2d 62 10 c0       	push   $0xc010622d
c0103891:	68 00 02 00 00       	push   $0x200
c0103896:	68 08 62 10 c0       	push   $0xc0106208
c010389b:	e8 35 cb ff ff       	call   c01003d5 <__panic>
    assert(pte2page(*ptep) == p1);
c01038a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038a3:	8b 00                	mov    (%eax),%eax
c01038a5:	83 ec 0c             	sub    $0xc,%esp
c01038a8:	50                   	push   %eax
c01038a9:	e8 5c f1 ff ff       	call   c0102a0a <pte2page>
c01038ae:	83 c4 10             	add    $0x10,%esp
c01038b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038b4:	74 19                	je     c01038cf <check_pgdir+0x3ef>
c01038b6:	68 5d 63 10 c0       	push   $0xc010635d
c01038bb:	68 2d 62 10 c0       	push   $0xc010622d
c01038c0:	68 01 02 00 00       	push   $0x201
c01038c5:	68 08 62 10 c0       	push   $0xc0106208
c01038ca:	e8 06 cb ff ff       	call   c01003d5 <__panic>
    assert((*ptep & PTE_U) == 0);
c01038cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d2:	8b 00                	mov    (%eax),%eax
c01038d4:	83 e0 04             	and    $0x4,%eax
c01038d7:	85 c0                	test   %eax,%eax
c01038d9:	74 19                	je     c01038f4 <check_pgdir+0x414>
c01038db:	68 ac 64 10 c0       	push   $0xc01064ac
c01038e0:	68 2d 62 10 c0       	push   $0xc010622d
c01038e5:	68 02 02 00 00       	push   $0x202
c01038ea:	68 08 62 10 c0       	push   $0xc0106208
c01038ef:	e8 e1 ca ff ff       	call   c01003d5 <__panic>

    page_remove(boot_pgdir, 0x0);
c01038f4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038f9:	83 ec 08             	sub    $0x8,%esp
c01038fc:	6a 00                	push   $0x0
c01038fe:	50                   	push   %eax
c01038ff:	e8 83 fa ff ff       	call   c0103387 <page_remove>
c0103904:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103907:	83 ec 0c             	sub    $0xc,%esp
c010390a:	ff 75 f4             	pushl  -0xc(%ebp)
c010390d:	e8 4e f1 ff ff       	call   c0102a60 <page_ref>
c0103912:	83 c4 10             	add    $0x10,%esp
c0103915:	83 f8 01             	cmp    $0x1,%eax
c0103918:	74 19                	je     c0103933 <check_pgdir+0x453>
c010391a:	68 73 63 10 c0       	push   $0xc0106373
c010391f:	68 2d 62 10 c0       	push   $0xc010622d
c0103924:	68 05 02 00 00       	push   $0x205
c0103929:	68 08 62 10 c0       	push   $0xc0106208
c010392e:	e8 a2 ca ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c0103933:	83 ec 0c             	sub    $0xc,%esp
c0103936:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103939:	e8 22 f1 ff ff       	call   c0102a60 <page_ref>
c010393e:	83 c4 10             	add    $0x10,%esp
c0103941:	85 c0                	test   %eax,%eax
c0103943:	74 19                	je     c010395e <check_pgdir+0x47e>
c0103945:	68 9a 64 10 c0       	push   $0xc010649a
c010394a:	68 2d 62 10 c0       	push   $0xc010622d
c010394f:	68 06 02 00 00       	push   $0x206
c0103954:	68 08 62 10 c0       	push   $0xc0106208
c0103959:	e8 77 ca ff ff       	call   c01003d5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010395e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103963:	83 ec 08             	sub    $0x8,%esp
c0103966:	68 00 10 00 00       	push   $0x1000
c010396b:	50                   	push   %eax
c010396c:	e8 16 fa ff ff       	call   c0103387 <page_remove>
c0103971:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103974:	83 ec 0c             	sub    $0xc,%esp
c0103977:	ff 75 f4             	pushl  -0xc(%ebp)
c010397a:	e8 e1 f0 ff ff       	call   c0102a60 <page_ref>
c010397f:	83 c4 10             	add    $0x10,%esp
c0103982:	85 c0                	test   %eax,%eax
c0103984:	74 19                	je     c010399f <check_pgdir+0x4bf>
c0103986:	68 c1 64 10 c0       	push   $0xc01064c1
c010398b:	68 2d 62 10 c0       	push   $0xc010622d
c0103990:	68 09 02 00 00       	push   $0x209
c0103995:	68 08 62 10 c0       	push   $0xc0106208
c010399a:	e8 36 ca ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c010399f:	83 ec 0c             	sub    $0xc,%esp
c01039a2:	ff 75 e4             	pushl  -0x1c(%ebp)
c01039a5:	e8 b6 f0 ff ff       	call   c0102a60 <page_ref>
c01039aa:	83 c4 10             	add    $0x10,%esp
c01039ad:	85 c0                	test   %eax,%eax
c01039af:	74 19                	je     c01039ca <check_pgdir+0x4ea>
c01039b1:	68 9a 64 10 c0       	push   $0xc010649a
c01039b6:	68 2d 62 10 c0       	push   $0xc010622d
c01039bb:	68 0a 02 00 00       	push   $0x20a
c01039c0:	68 08 62 10 c0       	push   $0xc0106208
c01039c5:	e8 0b ca ff ff       	call   c01003d5 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01039ca:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039cf:	8b 00                	mov    (%eax),%eax
c01039d1:	83 ec 0c             	sub    $0xc,%esp
c01039d4:	50                   	push   %eax
c01039d5:	e8 6a f0 ff ff       	call   c0102a44 <pde2page>
c01039da:	83 c4 10             	add    $0x10,%esp
c01039dd:	83 ec 0c             	sub    $0xc,%esp
c01039e0:	50                   	push   %eax
c01039e1:	e8 7a f0 ff ff       	call   c0102a60 <page_ref>
c01039e6:	83 c4 10             	add    $0x10,%esp
c01039e9:	83 f8 01             	cmp    $0x1,%eax
c01039ec:	74 19                	je     c0103a07 <check_pgdir+0x527>
c01039ee:	68 d4 64 10 c0       	push   $0xc01064d4
c01039f3:	68 2d 62 10 c0       	push   $0xc010622d
c01039f8:	68 0c 02 00 00       	push   $0x20c
c01039fd:	68 08 62 10 c0       	push   $0xc0106208
c0103a02:	e8 ce c9 ff ff       	call   c01003d5 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103a07:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a0c:	8b 00                	mov    (%eax),%eax
c0103a0e:	83 ec 0c             	sub    $0xc,%esp
c0103a11:	50                   	push   %eax
c0103a12:	e8 2d f0 ff ff       	call   c0102a44 <pde2page>
c0103a17:	83 c4 10             	add    $0x10,%esp
c0103a1a:	83 ec 08             	sub    $0x8,%esp
c0103a1d:	6a 01                	push   $0x1
c0103a1f:	50                   	push   %eax
c0103a20:	e8 79 f2 ff ff       	call   c0102c9e <free_pages>
c0103a25:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103a28:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103a33:	83 ec 0c             	sub    $0xc,%esp
c0103a36:	68 fb 64 10 c0       	push   $0xc01064fb
c0103a3b:	e8 2f c8 ff ff       	call   c010026f <cprintf>
c0103a40:	83 c4 10             	add    $0x10,%esp
}
c0103a43:	90                   	nop
c0103a44:	c9                   	leave  
c0103a45:	c3                   	ret    

c0103a46 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103a46:	55                   	push   %ebp
c0103a47:	89 e5                	mov    %esp,%ebp
c0103a49:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103a4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103a53:	e9 a3 00 00 00       	jmp    c0103afb <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a61:	c1 e8 0c             	shr    $0xc,%eax
c0103a64:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a67:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a6c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103a6f:	72 17                	jb     c0103a88 <check_boot_pgdir+0x42>
c0103a71:	ff 75 f0             	pushl  -0x10(%ebp)
c0103a74:	68 40 61 10 c0       	push   $0xc0106140
c0103a79:	68 18 02 00 00       	push   $0x218
c0103a7e:	68 08 62 10 c0       	push   $0xc0106208
c0103a83:	e8 4d c9 ff ff       	call   c01003d5 <__panic>
c0103a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a8b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103a90:	89 c2                	mov    %eax,%edx
c0103a92:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a97:	83 ec 04             	sub    $0x4,%esp
c0103a9a:	6a 00                	push   $0x0
c0103a9c:	52                   	push   %edx
c0103a9d:	50                   	push   %eax
c0103a9e:	e8 85 f8 ff ff       	call   c0103328 <get_pte>
c0103aa3:	83 c4 10             	add    $0x10,%esp
c0103aa6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103aa9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103aad:	75 19                	jne    c0103ac8 <check_boot_pgdir+0x82>
c0103aaf:	68 18 65 10 c0       	push   $0xc0106518
c0103ab4:	68 2d 62 10 c0       	push   $0xc010622d
c0103ab9:	68 18 02 00 00       	push   $0x218
c0103abe:	68 08 62 10 c0       	push   $0xc0106208
c0103ac3:	e8 0d c9 ff ff       	call   c01003d5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103acb:	8b 00                	mov    (%eax),%eax
c0103acd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ad2:	89 c2                	mov    %eax,%edx
c0103ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad7:	39 c2                	cmp    %eax,%edx
c0103ad9:	74 19                	je     c0103af4 <check_boot_pgdir+0xae>
c0103adb:	68 55 65 10 c0       	push   $0xc0106555
c0103ae0:	68 2d 62 10 c0       	push   $0xc010622d
c0103ae5:	68 19 02 00 00       	push   $0x219
c0103aea:	68 08 62 10 c0       	push   $0xc0106208
c0103aef:	e8 e1 c8 ff ff       	call   c01003d5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103af4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103afe:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103b03:	39 c2                	cmp    %eax,%edx
c0103b05:	0f 82 4d ff ff ff    	jb     c0103a58 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103b0b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b10:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103b15:	8b 00                	mov    (%eax),%eax
c0103b17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b1c:	89 c2                	mov    %eax,%edx
c0103b1e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b26:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103b2d:	77 17                	ja     c0103b46 <check_boot_pgdir+0x100>
c0103b2f:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b32:	68 e4 61 10 c0       	push   $0xc01061e4
c0103b37:	68 1c 02 00 00       	push   $0x21c
c0103b3c:	68 08 62 10 c0       	push   $0xc0106208
c0103b41:	e8 8f c8 ff ff       	call   c01003d5 <__panic>
c0103b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b49:	05 00 00 00 40       	add    $0x40000000,%eax
c0103b4e:	39 c2                	cmp    %eax,%edx
c0103b50:	74 19                	je     c0103b6b <check_boot_pgdir+0x125>
c0103b52:	68 6c 65 10 c0       	push   $0xc010656c
c0103b57:	68 2d 62 10 c0       	push   $0xc010622d
c0103b5c:	68 1c 02 00 00       	push   $0x21c
c0103b61:	68 08 62 10 c0       	push   $0xc0106208
c0103b66:	e8 6a c8 ff ff       	call   c01003d5 <__panic>

    assert(boot_pgdir[0] == 0);
c0103b6b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b70:	8b 00                	mov    (%eax),%eax
c0103b72:	85 c0                	test   %eax,%eax
c0103b74:	74 19                	je     c0103b8f <check_boot_pgdir+0x149>
c0103b76:	68 a0 65 10 c0       	push   $0xc01065a0
c0103b7b:	68 2d 62 10 c0       	push   $0xc010622d
c0103b80:	68 1e 02 00 00       	push   $0x21e
c0103b85:	68 08 62 10 c0       	push   $0xc0106208
c0103b8a:	e8 46 c8 ff ff       	call   c01003d5 <__panic>

    struct Page *p;
    p = alloc_page();
c0103b8f:	83 ec 0c             	sub    $0xc,%esp
c0103b92:	6a 01                	push   $0x1
c0103b94:	e8 c7 f0 ff ff       	call   c0102c60 <alloc_pages>
c0103b99:	83 c4 10             	add    $0x10,%esp
c0103b9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103b9f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ba4:	6a 02                	push   $0x2
c0103ba6:	68 00 01 00 00       	push   $0x100
c0103bab:	ff 75 e0             	pushl  -0x20(%ebp)
c0103bae:	50                   	push   %eax
c0103baf:	e8 06 f8 ff ff       	call   c01033ba <page_insert>
c0103bb4:	83 c4 10             	add    $0x10,%esp
c0103bb7:	85 c0                	test   %eax,%eax
c0103bb9:	74 19                	je     c0103bd4 <check_boot_pgdir+0x18e>
c0103bbb:	68 b4 65 10 c0       	push   $0xc01065b4
c0103bc0:	68 2d 62 10 c0       	push   $0xc010622d
c0103bc5:	68 22 02 00 00       	push   $0x222
c0103bca:	68 08 62 10 c0       	push   $0xc0106208
c0103bcf:	e8 01 c8 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p) == 1);
c0103bd4:	83 ec 0c             	sub    $0xc,%esp
c0103bd7:	ff 75 e0             	pushl  -0x20(%ebp)
c0103bda:	e8 81 ee ff ff       	call   c0102a60 <page_ref>
c0103bdf:	83 c4 10             	add    $0x10,%esp
c0103be2:	83 f8 01             	cmp    $0x1,%eax
c0103be5:	74 19                	je     c0103c00 <check_boot_pgdir+0x1ba>
c0103be7:	68 e2 65 10 c0       	push   $0xc01065e2
c0103bec:	68 2d 62 10 c0       	push   $0xc010622d
c0103bf1:	68 23 02 00 00       	push   $0x223
c0103bf6:	68 08 62 10 c0       	push   $0xc0106208
c0103bfb:	e8 d5 c7 ff ff       	call   c01003d5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103c00:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c05:	6a 02                	push   $0x2
c0103c07:	68 00 11 00 00       	push   $0x1100
c0103c0c:	ff 75 e0             	pushl  -0x20(%ebp)
c0103c0f:	50                   	push   %eax
c0103c10:	e8 a5 f7 ff ff       	call   c01033ba <page_insert>
c0103c15:	83 c4 10             	add    $0x10,%esp
c0103c18:	85 c0                	test   %eax,%eax
c0103c1a:	74 19                	je     c0103c35 <check_boot_pgdir+0x1ef>
c0103c1c:	68 f4 65 10 c0       	push   $0xc01065f4
c0103c21:	68 2d 62 10 c0       	push   $0xc010622d
c0103c26:	68 24 02 00 00       	push   $0x224
c0103c2b:	68 08 62 10 c0       	push   $0xc0106208
c0103c30:	e8 a0 c7 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p) == 2);
c0103c35:	83 ec 0c             	sub    $0xc,%esp
c0103c38:	ff 75 e0             	pushl  -0x20(%ebp)
c0103c3b:	e8 20 ee ff ff       	call   c0102a60 <page_ref>
c0103c40:	83 c4 10             	add    $0x10,%esp
c0103c43:	83 f8 02             	cmp    $0x2,%eax
c0103c46:	74 19                	je     c0103c61 <check_boot_pgdir+0x21b>
c0103c48:	68 2b 66 10 c0       	push   $0xc010662b
c0103c4d:	68 2d 62 10 c0       	push   $0xc010622d
c0103c52:	68 25 02 00 00       	push   $0x225
c0103c57:	68 08 62 10 c0       	push   $0xc0106208
c0103c5c:	e8 74 c7 ff ff       	call   c01003d5 <__panic>

    const char *str = "ucore: Hello world!!";
c0103c61:	c7 45 dc 3c 66 10 c0 	movl   $0xc010663c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103c68:	83 ec 08             	sub    $0x8,%esp
c0103c6b:	ff 75 dc             	pushl  -0x24(%ebp)
c0103c6e:	68 00 01 00 00       	push   $0x100
c0103c73:	e8 01 13 00 00       	call   c0104f79 <strcpy>
c0103c78:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103c7b:	83 ec 08             	sub    $0x8,%esp
c0103c7e:	68 00 11 00 00       	push   $0x1100
c0103c83:	68 00 01 00 00       	push   $0x100
c0103c88:	e8 66 13 00 00       	call   c0104ff3 <strcmp>
c0103c8d:	83 c4 10             	add    $0x10,%esp
c0103c90:	85 c0                	test   %eax,%eax
c0103c92:	74 19                	je     c0103cad <check_boot_pgdir+0x267>
c0103c94:	68 54 66 10 c0       	push   $0xc0106654
c0103c99:	68 2d 62 10 c0       	push   $0xc010622d
c0103c9e:	68 29 02 00 00       	push   $0x229
c0103ca3:	68 08 62 10 c0       	push   $0xc0106208
c0103ca8:	e8 28 c7 ff ff       	call   c01003d5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103cad:	83 ec 0c             	sub    $0xc,%esp
c0103cb0:	ff 75 e0             	pushl  -0x20(%ebp)
c0103cb3:	e8 0d ed ff ff       	call   c01029c5 <page2kva>
c0103cb8:	83 c4 10             	add    $0x10,%esp
c0103cbb:	05 00 01 00 00       	add    $0x100,%eax
c0103cc0:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103cc3:	83 ec 0c             	sub    $0xc,%esp
c0103cc6:	68 00 01 00 00       	push   $0x100
c0103ccb:	e8 51 12 00 00       	call   c0104f21 <strlen>
c0103cd0:	83 c4 10             	add    $0x10,%esp
c0103cd3:	85 c0                	test   %eax,%eax
c0103cd5:	74 19                	je     c0103cf0 <check_boot_pgdir+0x2aa>
c0103cd7:	68 8c 66 10 c0       	push   $0xc010668c
c0103cdc:	68 2d 62 10 c0       	push   $0xc010622d
c0103ce1:	68 2c 02 00 00       	push   $0x22c
c0103ce6:	68 08 62 10 c0       	push   $0xc0106208
c0103ceb:	e8 e5 c6 ff ff       	call   c01003d5 <__panic>

    free_page(p);
c0103cf0:	83 ec 08             	sub    $0x8,%esp
c0103cf3:	6a 01                	push   $0x1
c0103cf5:	ff 75 e0             	pushl  -0x20(%ebp)
c0103cf8:	e8 a1 ef ff ff       	call   c0102c9e <free_pages>
c0103cfd:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103d00:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d05:	8b 00                	mov    (%eax),%eax
c0103d07:	83 ec 0c             	sub    $0xc,%esp
c0103d0a:	50                   	push   %eax
c0103d0b:	e8 34 ed ff ff       	call   c0102a44 <pde2page>
c0103d10:	83 c4 10             	add    $0x10,%esp
c0103d13:	83 ec 08             	sub    $0x8,%esp
c0103d16:	6a 01                	push   $0x1
c0103d18:	50                   	push   %eax
c0103d19:	e8 80 ef ff ff       	call   c0102c9e <free_pages>
c0103d1e:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103d21:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103d2c:	83 ec 0c             	sub    $0xc,%esp
c0103d2f:	68 b0 66 10 c0       	push   $0xc01066b0
c0103d34:	e8 36 c5 ff ff       	call   c010026f <cprintf>
c0103d39:	83 c4 10             	add    $0x10,%esp
}
c0103d3c:	90                   	nop
c0103d3d:	c9                   	leave  
c0103d3e:	c3                   	ret    

c0103d3f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103d3f:	55                   	push   %ebp
c0103d40:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103d42:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d45:	83 e0 04             	and    $0x4,%eax
c0103d48:	85 c0                	test   %eax,%eax
c0103d4a:	74 07                	je     c0103d53 <perm2str+0x14>
c0103d4c:	b8 75 00 00 00       	mov    $0x75,%eax
c0103d51:	eb 05                	jmp    c0103d58 <perm2str+0x19>
c0103d53:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103d58:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103d5d:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103d64:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d67:	83 e0 02             	and    $0x2,%eax
c0103d6a:	85 c0                	test   %eax,%eax
c0103d6c:	74 07                	je     c0103d75 <perm2str+0x36>
c0103d6e:	b8 77 00 00 00       	mov    $0x77,%eax
c0103d73:	eb 05                	jmp    c0103d7a <perm2str+0x3b>
c0103d75:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103d7a:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103d7f:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103d86:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103d8b:	5d                   	pop    %ebp
c0103d8c:	c3                   	ret    

c0103d8d <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103d8d:	55                   	push   %ebp
c0103d8e:	89 e5                	mov    %esp,%ebp
c0103d90:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103d93:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d96:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d99:	72 0e                	jb     c0103da9 <get_pgtable_items+0x1c>
        return 0;
c0103d9b:	b8 00 00 00 00       	mov    $0x0,%eax
c0103da0:	e9 9a 00 00 00       	jmp    c0103e3f <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103da5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103da9:	8b 45 10             	mov    0x10(%ebp),%eax
c0103dac:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103daf:	73 18                	jae    c0103dc9 <get_pgtable_items+0x3c>
c0103db1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103db4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103dbb:	8b 45 14             	mov    0x14(%ebp),%eax
c0103dbe:	01 d0                	add    %edx,%eax
c0103dc0:	8b 00                	mov    (%eax),%eax
c0103dc2:	83 e0 01             	and    $0x1,%eax
c0103dc5:	85 c0                	test   %eax,%eax
c0103dc7:	74 dc                	je     c0103da5 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103dc9:	8b 45 10             	mov    0x10(%ebp),%eax
c0103dcc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103dcf:	73 69                	jae    c0103e3a <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103dd1:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103dd5:	74 08                	je     c0103ddf <get_pgtable_items+0x52>
            *left_store = start;
c0103dd7:	8b 45 18             	mov    0x18(%ebp),%eax
c0103dda:	8b 55 10             	mov    0x10(%ebp),%edx
c0103ddd:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103ddf:	8b 45 10             	mov    0x10(%ebp),%eax
c0103de2:	8d 50 01             	lea    0x1(%eax),%edx
c0103de5:	89 55 10             	mov    %edx,0x10(%ebp)
c0103de8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103def:	8b 45 14             	mov    0x14(%ebp),%eax
c0103df2:	01 d0                	add    %edx,%eax
c0103df4:	8b 00                	mov    (%eax),%eax
c0103df6:	83 e0 07             	and    $0x7,%eax
c0103df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103dfc:	eb 04                	jmp    c0103e02 <get_pgtable_items+0x75>
            start ++;
c0103dfe:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103e02:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e05:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e08:	73 1d                	jae    c0103e27 <get_pgtable_items+0x9a>
c0103e0a:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103e14:	8b 45 14             	mov    0x14(%ebp),%eax
c0103e17:	01 d0                	add    %edx,%eax
c0103e19:	8b 00                	mov    (%eax),%eax
c0103e1b:	83 e0 07             	and    $0x7,%eax
c0103e1e:	89 c2                	mov    %eax,%edx
c0103e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e23:	39 c2                	cmp    %eax,%edx
c0103e25:	74 d7                	je     c0103dfe <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103e27:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103e2b:	74 08                	je     c0103e35 <get_pgtable_items+0xa8>
            *right_store = start;
c0103e2d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103e30:	8b 55 10             	mov    0x10(%ebp),%edx
c0103e33:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e38:	eb 05                	jmp    c0103e3f <get_pgtable_items+0xb2>
    }
    return 0;
c0103e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103e3f:	c9                   	leave  
c0103e40:	c3                   	ret    

c0103e41 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103e41:	55                   	push   %ebp
c0103e42:	89 e5                	mov    %esp,%ebp
c0103e44:	57                   	push   %edi
c0103e45:	56                   	push   %esi
c0103e46:	53                   	push   %ebx
c0103e47:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103e4a:	83 ec 0c             	sub    $0xc,%esp
c0103e4d:	68 d0 66 10 c0       	push   $0xc01066d0
c0103e52:	e8 18 c4 ff ff       	call   c010026f <cprintf>
c0103e57:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103e5a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103e61:	e9 e5 00 00 00       	jmp    c0103f4b <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e69:	83 ec 0c             	sub    $0xc,%esp
c0103e6c:	50                   	push   %eax
c0103e6d:	e8 cd fe ff ff       	call   c0103d3f <perm2str>
c0103e72:	83 c4 10             	add    $0x10,%esp
c0103e75:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103e77:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e7d:	29 c2                	sub    %eax,%edx
c0103e7f:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103e81:	c1 e0 16             	shl    $0x16,%eax
c0103e84:	89 c3                	mov    %eax,%ebx
c0103e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e89:	c1 e0 16             	shl    $0x16,%eax
c0103e8c:	89 c1                	mov    %eax,%ecx
c0103e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e91:	c1 e0 16             	shl    $0x16,%eax
c0103e94:	89 c2                	mov    %eax,%edx
c0103e96:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0103e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e9c:	29 c6                	sub    %eax,%esi
c0103e9e:	89 f0                	mov    %esi,%eax
c0103ea0:	83 ec 08             	sub    $0x8,%esp
c0103ea3:	57                   	push   %edi
c0103ea4:	53                   	push   %ebx
c0103ea5:	51                   	push   %ecx
c0103ea6:	52                   	push   %edx
c0103ea7:	50                   	push   %eax
c0103ea8:	68 01 67 10 c0       	push   $0xc0106701
c0103ead:	e8 bd c3 ff ff       	call   c010026f <cprintf>
c0103eb2:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0103eb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103eb8:	c1 e0 0a             	shl    $0xa,%eax
c0103ebb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103ebe:	eb 4f                	jmp    c0103f0f <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ec3:	83 ec 0c             	sub    $0xc,%esp
c0103ec6:	50                   	push   %eax
c0103ec7:	e8 73 fe ff ff       	call   c0103d3f <perm2str>
c0103ecc:	83 c4 10             	add    $0x10,%esp
c0103ecf:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103ed1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ed4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ed7:	29 c2                	sub    %eax,%edx
c0103ed9:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103edb:	c1 e0 0c             	shl    $0xc,%eax
c0103ede:	89 c3                	mov    %eax,%ebx
c0103ee0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103ee3:	c1 e0 0c             	shl    $0xc,%eax
c0103ee6:	89 c1                	mov    %eax,%ecx
c0103ee8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103eeb:	c1 e0 0c             	shl    $0xc,%eax
c0103eee:	89 c2                	mov    %eax,%edx
c0103ef0:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0103ef3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ef6:	29 c6                	sub    %eax,%esi
c0103ef8:	89 f0                	mov    %esi,%eax
c0103efa:	83 ec 08             	sub    $0x8,%esp
c0103efd:	57                   	push   %edi
c0103efe:	53                   	push   %ebx
c0103eff:	51                   	push   %ecx
c0103f00:	52                   	push   %edx
c0103f01:	50                   	push   %eax
c0103f02:	68 20 67 10 c0       	push   $0xc0106720
c0103f07:	e8 63 c3 ff ff       	call   c010026f <cprintf>
c0103f0c:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103f0f:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0103f14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103f17:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f1a:	89 d3                	mov    %edx,%ebx
c0103f1c:	c1 e3 0a             	shl    $0xa,%ebx
c0103f1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103f22:	89 d1                	mov    %edx,%ecx
c0103f24:	c1 e1 0a             	shl    $0xa,%ecx
c0103f27:	83 ec 08             	sub    $0x8,%esp
c0103f2a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0103f2d:	52                   	push   %edx
c0103f2e:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0103f31:	52                   	push   %edx
c0103f32:	56                   	push   %esi
c0103f33:	50                   	push   %eax
c0103f34:	53                   	push   %ebx
c0103f35:	51                   	push   %ecx
c0103f36:	e8 52 fe ff ff       	call   c0103d8d <get_pgtable_items>
c0103f3b:	83 c4 20             	add    $0x20,%esp
c0103f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f45:	0f 85 75 ff ff ff    	jne    c0103ec0 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103f4b:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0103f50:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f53:	83 ec 08             	sub    $0x8,%esp
c0103f56:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0103f59:	52                   	push   %edx
c0103f5a:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0103f5d:	52                   	push   %edx
c0103f5e:	51                   	push   %ecx
c0103f5f:	50                   	push   %eax
c0103f60:	68 00 04 00 00       	push   $0x400
c0103f65:	6a 00                	push   $0x0
c0103f67:	e8 21 fe ff ff       	call   c0103d8d <get_pgtable_items>
c0103f6c:	83 c4 20             	add    $0x20,%esp
c0103f6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f76:	0f 85 ea fe ff ff    	jne    c0103e66 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0103f7c:	83 ec 0c             	sub    $0xc,%esp
c0103f7f:	68 44 67 10 c0       	push   $0xc0106744
c0103f84:	e8 e6 c2 ff ff       	call   c010026f <cprintf>
c0103f89:	83 c4 10             	add    $0x10,%esp
}
c0103f8c:	90                   	nop
c0103f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103f90:	5b                   	pop    %ebx
c0103f91:	5e                   	pop    %esi
c0103f92:	5f                   	pop    %edi
c0103f93:	5d                   	pop    %ebp
c0103f94:	c3                   	ret    

c0103f95 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103f95:	55                   	push   %ebp
c0103f96:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f9b:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0103fa1:	29 d0                	sub    %edx,%eax
c0103fa3:	c1 f8 02             	sar    $0x2,%eax
c0103fa6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103fac:	5d                   	pop    %ebp
c0103fad:	c3                   	ret    

c0103fae <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103fae:	55                   	push   %ebp
c0103faf:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0103fb1:	ff 75 08             	pushl  0x8(%ebp)
c0103fb4:	e8 dc ff ff ff       	call   c0103f95 <page2ppn>
c0103fb9:	83 c4 04             	add    $0x4,%esp
c0103fbc:	c1 e0 0c             	shl    $0xc,%eax
}
c0103fbf:	c9                   	leave  
c0103fc0:	c3                   	ret    

c0103fc1 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103fc1:	55                   	push   %ebp
c0103fc2:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103fc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fc7:	8b 00                	mov    (%eax),%eax
}
c0103fc9:	5d                   	pop    %ebp
c0103fca:	c3                   	ret    

c0103fcb <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103fcb:	55                   	push   %ebp
c0103fcc:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103fce:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fd4:	89 10                	mov    %edx,(%eax)
}
c0103fd6:	90                   	nop
c0103fd7:	5d                   	pop    %ebp
c0103fd8:	c3                   	ret    

c0103fd9 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103fd9:	55                   	push   %ebp
c0103fda:	89 e5                	mov    %esp,%ebp
c0103fdc:	83 ec 10             	sub    $0x10,%esp
c0103fdf:	c7 45 fc bc 89 11 c0 	movl   $0xc01189bc,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103fe6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103fec:	89 50 04             	mov    %edx,0x4(%eax)
c0103fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ff2:	8b 50 04             	mov    0x4(%eax),%edx
c0103ff5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ff8:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103ffa:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c0104001:	00 00 00 
}
c0104004:	90                   	nop
c0104005:	c9                   	leave  
c0104006:	c3                   	ret    

c0104007 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104007:	55                   	push   %ebp
c0104008:	89 e5                	mov    %esp,%ebp
c010400a:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010400d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104011:	75 16                	jne    c0104029 <default_init_memmap+0x22>
c0104013:	68 78 67 10 c0       	push   $0xc0106778
c0104018:	68 7e 67 10 c0       	push   $0xc010677e
c010401d:	6a 6d                	push   $0x6d
c010401f:	68 93 67 10 c0       	push   $0xc0106793
c0104024:	e8 ac c3 ff ff       	call   c01003d5 <__panic>
    struct Page *p = base;
c0104029:	8b 45 08             	mov    0x8(%ebp),%eax
c010402c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010402f:	eb 6c                	jmp    c010409d <default_init_memmap+0x96>
        assert(PageReserved(p));
c0104031:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104034:	83 c0 04             	add    $0x4,%eax
c0104037:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010403e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104044:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104047:	0f a3 10             	bt     %edx,(%eax)
c010404a:	19 c0                	sbb    %eax,%eax
c010404c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c010404f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104053:	0f 95 c0             	setne  %al
c0104056:	0f b6 c0             	movzbl %al,%eax
c0104059:	85 c0                	test   %eax,%eax
c010405b:	75 16                	jne    c0104073 <default_init_memmap+0x6c>
c010405d:	68 a9 67 10 c0       	push   $0xc01067a9
c0104062:	68 7e 67 10 c0       	push   $0xc010677e
c0104067:	6a 70                	push   $0x70
c0104069:	68 93 67 10 c0       	push   $0xc0106793
c010406e:	e8 62 c3 ff ff       	call   c01003d5 <__panic>
        p->flags = p->property = 0;
c0104073:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104076:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010407d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104080:	8b 50 08             	mov    0x8(%eax),%edx
c0104083:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104086:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104089:	83 ec 08             	sub    $0x8,%esp
c010408c:	6a 00                	push   $0x0
c010408e:	ff 75 f4             	pushl  -0xc(%ebp)
c0104091:	e8 35 ff ff ff       	call   c0103fcb <set_page_ref>
c0104096:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104099:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010409d:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040a0:	89 d0                	mov    %edx,%eax
c01040a2:	c1 e0 02             	shl    $0x2,%eax
c01040a5:	01 d0                	add    %edx,%eax
c01040a7:	c1 e0 02             	shl    $0x2,%eax
c01040aa:	89 c2                	mov    %eax,%edx
c01040ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01040af:	01 d0                	add    %edx,%eax
c01040b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01040b4:	0f 85 77 ff ff ff    	jne    c0104031 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01040ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01040bd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040c0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01040c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01040c6:	83 c0 04             	add    $0x4,%eax
c01040c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c01040d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01040d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01040d9:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01040dc:	8b 15 c4 89 11 c0    	mov    0xc01189c4,%edx
c01040e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040e5:	01 d0                	add    %edx,%eax
c01040e7:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
    list_add(&free_list, &(base->page_link));
c01040ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01040ef:	83 c0 0c             	add    $0xc,%eax
c01040f2:	c7 45 f0 bc 89 11 c0 	movl   $0xc01189bc,-0x10(%ebp)
c01040f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01040fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104102:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104105:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104108:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010410b:	8b 40 04             	mov    0x4(%eax),%eax
c010410e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104111:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104114:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104117:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010411a:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010411d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104120:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104123:	89 10                	mov    %edx,(%eax)
c0104125:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104128:	8b 10                	mov    (%eax),%edx
c010412a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010412d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104130:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104133:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104136:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104139:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010413c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010413f:	89 10                	mov    %edx,(%eax)
}
c0104141:	90                   	nop
c0104142:	c9                   	leave  
c0104143:	c3                   	ret    

c0104144 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104144:	55                   	push   %ebp
c0104145:	89 e5                	mov    %esp,%ebp
c0104147:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010414a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010414e:	75 16                	jne    c0104166 <default_alloc_pages+0x22>
c0104150:	68 78 67 10 c0       	push   $0xc0106778
c0104155:	68 7e 67 10 c0       	push   $0xc010677e
c010415a:	6a 7c                	push   $0x7c
c010415c:	68 93 67 10 c0       	push   $0xc0106793
c0104161:	e8 6f c2 ff ff       	call   c01003d5 <__panic>
    if (n > nr_free) {
c0104166:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c010416b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010416e:	73 0a                	jae    c010417a <default_alloc_pages+0x36>
        return NULL;
c0104170:	b8 00 00 00 00       	mov    $0x0,%eax
c0104175:	e9 2a 01 00 00       	jmp    c01042a4 <default_alloc_pages+0x160>
    }
    struct Page *page = NULL;
c010417a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104181:	c7 45 f0 bc 89 11 c0 	movl   $0xc01189bc,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104188:	eb 1c                	jmp    c01041a6 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c010418a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010418d:	83 e8 0c             	sub    $0xc,%eax
c0104190:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0104193:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104196:	8b 40 08             	mov    0x8(%eax),%eax
c0104199:	3b 45 08             	cmp    0x8(%ebp),%eax
c010419c:	72 08                	jb     c01041a6 <default_alloc_pages+0x62>
            page = p;
c010419e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01041a4:	eb 18                	jmp    c01041be <default_alloc_pages+0x7a>
c01041a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01041ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041af:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01041b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041b5:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c01041bc:	75 cc                	jne    c010418a <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c01041be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041c2:	0f 84 d9 00 00 00    	je     c01042a1 <default_alloc_pages+0x15d>
        list_del(&(page->page_link));
c01041c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041cb:	83 c0 0c             	add    $0xc,%eax
c01041ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01041d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041d4:	8b 40 04             	mov    0x4(%eax),%eax
c01041d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041da:	8b 12                	mov    (%edx),%edx
c01041dc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01041df:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01041e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041e8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01041eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041f1:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01041f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041f6:	8b 40 08             	mov    0x8(%eax),%eax
c01041f9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01041fc:	76 7d                	jbe    c010427b <default_alloc_pages+0x137>
            struct Page *p = page + n;
c01041fe:	8b 55 08             	mov    0x8(%ebp),%edx
c0104201:	89 d0                	mov    %edx,%eax
c0104203:	c1 e0 02             	shl    $0x2,%eax
c0104206:	01 d0                	add    %edx,%eax
c0104208:	c1 e0 02             	shl    $0x2,%eax
c010420b:	89 c2                	mov    %eax,%edx
c010420d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104210:	01 d0                	add    %edx,%eax
c0104212:	89 45 e0             	mov    %eax,-0x20(%ebp)
            p->property = page->property - n;
c0104215:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104218:	8b 40 08             	mov    0x8(%eax),%eax
c010421b:	2b 45 08             	sub    0x8(%ebp),%eax
c010421e:	89 c2                	mov    %eax,%edx
c0104220:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104223:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0104226:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104229:	83 c0 0c             	add    $0xc,%eax
c010422c:	c7 45 e4 bc 89 11 c0 	movl   $0xc01189bc,-0x1c(%ebp)
c0104233:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0104236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104239:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010423c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010423f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104242:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104245:	8b 40 04             	mov    0x4(%eax),%eax
c0104248:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010424b:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010424e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104251:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104254:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104257:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010425a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010425d:	89 10                	mov    %edx,(%eax)
c010425f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104262:	8b 10                	mov    (%eax),%edx
c0104264:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104267:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010426a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010426d:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104270:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104273:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104276:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104279:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c010427b:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104280:	2b 45 08             	sub    0x8(%ebp),%eax
c0104283:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
        ClearPageProperty(page);
c0104288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010428b:	83 c0 04             	add    $0x4,%eax
c010428e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0104295:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104298:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010429b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010429e:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c01042a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01042a4:	c9                   	leave  
c01042a5:	c3                   	ret    

c01042a6 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01042a6:	55                   	push   %ebp
c01042a7:	89 e5                	mov    %esp,%ebp
c01042a9:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c01042af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01042b3:	75 19                	jne    c01042ce <default_free_pages+0x28>
c01042b5:	68 78 67 10 c0       	push   $0xc0106778
c01042ba:	68 7e 67 10 c0       	push   $0xc010677e
c01042bf:	68 98 00 00 00       	push   $0x98
c01042c4:	68 93 67 10 c0       	push   $0xc0106793
c01042c9:	e8 07 c1 ff ff       	call   c01003d5 <__panic>
    struct Page *p = base;
c01042ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01042d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01042d4:	e9 8f 00 00 00       	jmp    c0104368 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c01042d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042dc:	83 c0 04             	add    $0x4,%eax
c01042df:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
c01042e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01042ec:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01042ef:	0f a3 10             	bt     %edx,(%eax)
c01042f2:	19 c0                	sbb    %eax,%eax
c01042f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
c01042f7:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01042fb:	0f 95 c0             	setne  %al
c01042fe:	0f b6 c0             	movzbl %al,%eax
c0104301:	85 c0                	test   %eax,%eax
c0104303:	75 2c                	jne    c0104331 <default_free_pages+0x8b>
c0104305:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104308:	83 c0 04             	add    $0x4,%eax
c010430b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104312:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104315:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104318:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010431b:	0f a3 10             	bt     %edx,(%eax)
c010431e:	19 c0                	sbb    %eax,%eax
c0104320:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104323:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104327:	0f 95 c0             	setne  %al
c010432a:	0f b6 c0             	movzbl %al,%eax
c010432d:	85 c0                	test   %eax,%eax
c010432f:	74 19                	je     c010434a <default_free_pages+0xa4>
c0104331:	68 bc 67 10 c0       	push   $0xc01067bc
c0104336:	68 7e 67 10 c0       	push   $0xc010677e
c010433b:	68 9b 00 00 00       	push   $0x9b
c0104340:	68 93 67 10 c0       	push   $0xc0106793
c0104345:	e8 8b c0 ff ff       	call   c01003d5 <__panic>
        p->flags = 0;
c010434a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104354:	83 ec 08             	sub    $0x8,%esp
c0104357:	6a 00                	push   $0x0
c0104359:	ff 75 f4             	pushl  -0xc(%ebp)
c010435c:	e8 6a fc ff ff       	call   c0103fcb <set_page_ref>
c0104361:	83 c4 10             	add    $0x10,%esp

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104364:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104368:	8b 55 0c             	mov    0xc(%ebp),%edx
c010436b:	89 d0                	mov    %edx,%eax
c010436d:	c1 e0 02             	shl    $0x2,%eax
c0104370:	01 d0                	add    %edx,%eax
c0104372:	c1 e0 02             	shl    $0x2,%eax
c0104375:	89 c2                	mov    %eax,%edx
c0104377:	8b 45 08             	mov    0x8(%ebp),%eax
c010437a:	01 d0                	add    %edx,%eax
c010437c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010437f:	0f 85 54 ff ff ff    	jne    c01042d9 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0104385:	8b 45 08             	mov    0x8(%ebp),%eax
c0104388:	8b 55 0c             	mov    0xc(%ebp),%edx
c010438b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010438e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104391:	83 c0 04             	add    $0x4,%eax
c0104394:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010439b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010439e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01043a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01043a4:	0f ab 10             	bts    %edx,(%eax)
c01043a7:	c7 45 e8 bc 89 11 c0 	movl   $0xc01189bc,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01043ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043b1:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01043b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01043b7:	e9 08 01 00 00       	jmp    c01044c4 <default_free_pages+0x21e>
        p = le2page(le, page_link);
c01043bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043bf:	83 e8 0c             	sub    $0xc,%eax
c01043c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043ce:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01043d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c01043d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d7:	8b 50 08             	mov    0x8(%eax),%edx
c01043da:	89 d0                	mov    %edx,%eax
c01043dc:	c1 e0 02             	shl    $0x2,%eax
c01043df:	01 d0                	add    %edx,%eax
c01043e1:	c1 e0 02             	shl    $0x2,%eax
c01043e4:	89 c2                	mov    %eax,%edx
c01043e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e9:	01 d0                	add    %edx,%eax
c01043eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01043ee:	75 5a                	jne    c010444a <default_free_pages+0x1a4>
            base->property += p->property;
c01043f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f3:	8b 50 08             	mov    0x8(%eax),%edx
c01043f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f9:	8b 40 08             	mov    0x8(%eax),%eax
c01043fc:	01 c2                	add    %eax,%edx
c01043fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104401:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104404:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104407:	83 c0 04             	add    $0x4,%eax
c010440a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104411:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104414:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104417:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010441a:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c010441d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104420:	83 c0 0c             	add    $0xc,%eax
c0104423:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104426:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104429:	8b 40 04             	mov    0x4(%eax),%eax
c010442c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010442f:	8b 12                	mov    (%edx),%edx
c0104431:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0104434:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104437:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010443a:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010443d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104440:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104443:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104446:	89 10                	mov    %edx,(%eax)
c0104448:	eb 7a                	jmp    c01044c4 <default_free_pages+0x21e>
        }
        else if (p + p->property == base) {
c010444a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010444d:	8b 50 08             	mov    0x8(%eax),%edx
c0104450:	89 d0                	mov    %edx,%eax
c0104452:	c1 e0 02             	shl    $0x2,%eax
c0104455:	01 d0                	add    %edx,%eax
c0104457:	c1 e0 02             	shl    $0x2,%eax
c010445a:	89 c2                	mov    %eax,%edx
c010445c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445f:	01 d0                	add    %edx,%eax
c0104461:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104464:	75 5e                	jne    c01044c4 <default_free_pages+0x21e>
            p->property += base->property;
c0104466:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104469:	8b 50 08             	mov    0x8(%eax),%edx
c010446c:	8b 45 08             	mov    0x8(%ebp),%eax
c010446f:	8b 40 08             	mov    0x8(%eax),%eax
c0104472:	01 c2                	add    %eax,%edx
c0104474:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104477:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010447a:	8b 45 08             	mov    0x8(%ebp),%eax
c010447d:	83 c0 04             	add    $0x4,%eax
c0104480:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104487:	89 45 9c             	mov    %eax,-0x64(%ebp)
c010448a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010448d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104490:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104493:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104496:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104499:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010449c:	83 c0 0c             	add    $0xc,%eax
c010449f:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01044a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044a5:	8b 40 04             	mov    0x4(%eax),%eax
c01044a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044ab:	8b 12                	mov    (%edx),%edx
c01044ad:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01044b0:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01044b3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01044b6:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01044b9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01044bc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01044bf:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01044c2:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c01044c4:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c01044cb:	0f 85 eb fe ff ff    	jne    c01043bc <default_free_pages+0x116>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c01044d1:	8b 15 c4 89 11 c0    	mov    0xc01189c4,%edx
c01044d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044da:	01 d0                	add    %edx,%eax
c01044dc:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
    list_add(&free_list, &(base->page_link));
c01044e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01044e4:	83 c0 0c             	add    $0xc,%eax
c01044e7:	c7 45 d0 bc 89 11 c0 	movl   $0xc01189bc,-0x30(%ebp)
c01044ee:	89 45 98             	mov    %eax,-0x68(%ebp)
c01044f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044f4:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01044f7:	8b 45 98             	mov    -0x68(%ebp),%eax
c01044fa:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01044fd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104500:	8b 40 04             	mov    0x4(%eax),%eax
c0104503:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104506:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104509:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010450c:	89 55 88             	mov    %edx,-0x78(%ebp)
c010450f:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104512:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104515:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104518:	89 10                	mov    %edx,(%eax)
c010451a:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010451d:	8b 10                	mov    (%eax),%edx
c010451f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104522:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104525:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104528:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010452b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010452e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104531:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104534:	89 10                	mov    %edx,(%eax)
}
c0104536:	90                   	nop
c0104537:	c9                   	leave  
c0104538:	c3                   	ret    

c0104539 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104539:	55                   	push   %ebp
c010453a:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010453c:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
}
c0104541:	5d                   	pop    %ebp
c0104542:	c3                   	ret    

c0104543 <basic_check>:

static void
basic_check(void) {
c0104543:	55                   	push   %ebp
c0104544:	89 e5                	mov    %esp,%ebp
c0104546:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104550:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104553:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104556:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104559:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010455c:	83 ec 0c             	sub    $0xc,%esp
c010455f:	6a 01                	push   $0x1
c0104561:	e8 fa e6 ff ff       	call   c0102c60 <alloc_pages>
c0104566:	83 c4 10             	add    $0x10,%esp
c0104569:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010456c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104570:	75 19                	jne    c010458b <basic_check+0x48>
c0104572:	68 e1 67 10 c0       	push   $0xc01067e1
c0104577:	68 7e 67 10 c0       	push   $0xc010677e
c010457c:	68 be 00 00 00       	push   $0xbe
c0104581:	68 93 67 10 c0       	push   $0xc0106793
c0104586:	e8 4a be ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010458b:	83 ec 0c             	sub    $0xc,%esp
c010458e:	6a 01                	push   $0x1
c0104590:	e8 cb e6 ff ff       	call   c0102c60 <alloc_pages>
c0104595:	83 c4 10             	add    $0x10,%esp
c0104598:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010459b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010459f:	75 19                	jne    c01045ba <basic_check+0x77>
c01045a1:	68 fd 67 10 c0       	push   $0xc01067fd
c01045a6:	68 7e 67 10 c0       	push   $0xc010677e
c01045ab:	68 bf 00 00 00       	push   $0xbf
c01045b0:	68 93 67 10 c0       	push   $0xc0106793
c01045b5:	e8 1b be ff ff       	call   c01003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01045ba:	83 ec 0c             	sub    $0xc,%esp
c01045bd:	6a 01                	push   $0x1
c01045bf:	e8 9c e6 ff ff       	call   c0102c60 <alloc_pages>
c01045c4:	83 c4 10             	add    $0x10,%esp
c01045c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045ce:	75 19                	jne    c01045e9 <basic_check+0xa6>
c01045d0:	68 19 68 10 c0       	push   $0xc0106819
c01045d5:	68 7e 67 10 c0       	push   $0xc010677e
c01045da:	68 c0 00 00 00       	push   $0xc0
c01045df:	68 93 67 10 c0       	push   $0xc0106793
c01045e4:	e8 ec bd ff ff       	call   c01003d5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01045e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01045ef:	74 10                	je     c0104601 <basic_check+0xbe>
c01045f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01045f7:	74 08                	je     c0104601 <basic_check+0xbe>
c01045f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01045ff:	75 19                	jne    c010461a <basic_check+0xd7>
c0104601:	68 38 68 10 c0       	push   $0xc0106838
c0104606:	68 7e 67 10 c0       	push   $0xc010677e
c010460b:	68 c2 00 00 00       	push   $0xc2
c0104610:	68 93 67 10 c0       	push   $0xc0106793
c0104615:	e8 bb bd ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010461a:	83 ec 0c             	sub    $0xc,%esp
c010461d:	ff 75 ec             	pushl  -0x14(%ebp)
c0104620:	e8 9c f9 ff ff       	call   c0103fc1 <page_ref>
c0104625:	83 c4 10             	add    $0x10,%esp
c0104628:	85 c0                	test   %eax,%eax
c010462a:	75 24                	jne    c0104650 <basic_check+0x10d>
c010462c:	83 ec 0c             	sub    $0xc,%esp
c010462f:	ff 75 f0             	pushl  -0x10(%ebp)
c0104632:	e8 8a f9 ff ff       	call   c0103fc1 <page_ref>
c0104637:	83 c4 10             	add    $0x10,%esp
c010463a:	85 c0                	test   %eax,%eax
c010463c:	75 12                	jne    c0104650 <basic_check+0x10d>
c010463e:	83 ec 0c             	sub    $0xc,%esp
c0104641:	ff 75 f4             	pushl  -0xc(%ebp)
c0104644:	e8 78 f9 ff ff       	call   c0103fc1 <page_ref>
c0104649:	83 c4 10             	add    $0x10,%esp
c010464c:	85 c0                	test   %eax,%eax
c010464e:	74 19                	je     c0104669 <basic_check+0x126>
c0104650:	68 5c 68 10 c0       	push   $0xc010685c
c0104655:	68 7e 67 10 c0       	push   $0xc010677e
c010465a:	68 c3 00 00 00       	push   $0xc3
c010465f:	68 93 67 10 c0       	push   $0xc0106793
c0104664:	e8 6c bd ff ff       	call   c01003d5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104669:	83 ec 0c             	sub    $0xc,%esp
c010466c:	ff 75 ec             	pushl  -0x14(%ebp)
c010466f:	e8 3a f9 ff ff       	call   c0103fae <page2pa>
c0104674:	83 c4 10             	add    $0x10,%esp
c0104677:	89 c2                	mov    %eax,%edx
c0104679:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010467e:	c1 e0 0c             	shl    $0xc,%eax
c0104681:	39 c2                	cmp    %eax,%edx
c0104683:	72 19                	jb     c010469e <basic_check+0x15b>
c0104685:	68 98 68 10 c0       	push   $0xc0106898
c010468a:	68 7e 67 10 c0       	push   $0xc010677e
c010468f:	68 c5 00 00 00       	push   $0xc5
c0104694:	68 93 67 10 c0       	push   $0xc0106793
c0104699:	e8 37 bd ff ff       	call   c01003d5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010469e:	83 ec 0c             	sub    $0xc,%esp
c01046a1:	ff 75 f0             	pushl  -0x10(%ebp)
c01046a4:	e8 05 f9 ff ff       	call   c0103fae <page2pa>
c01046a9:	83 c4 10             	add    $0x10,%esp
c01046ac:	89 c2                	mov    %eax,%edx
c01046ae:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046b3:	c1 e0 0c             	shl    $0xc,%eax
c01046b6:	39 c2                	cmp    %eax,%edx
c01046b8:	72 19                	jb     c01046d3 <basic_check+0x190>
c01046ba:	68 b5 68 10 c0       	push   $0xc01068b5
c01046bf:	68 7e 67 10 c0       	push   $0xc010677e
c01046c4:	68 c6 00 00 00       	push   $0xc6
c01046c9:	68 93 67 10 c0       	push   $0xc0106793
c01046ce:	e8 02 bd ff ff       	call   c01003d5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01046d3:	83 ec 0c             	sub    $0xc,%esp
c01046d6:	ff 75 f4             	pushl  -0xc(%ebp)
c01046d9:	e8 d0 f8 ff ff       	call   c0103fae <page2pa>
c01046de:	83 c4 10             	add    $0x10,%esp
c01046e1:	89 c2                	mov    %eax,%edx
c01046e3:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046e8:	c1 e0 0c             	shl    $0xc,%eax
c01046eb:	39 c2                	cmp    %eax,%edx
c01046ed:	72 19                	jb     c0104708 <basic_check+0x1c5>
c01046ef:	68 d2 68 10 c0       	push   $0xc01068d2
c01046f4:	68 7e 67 10 c0       	push   $0xc010677e
c01046f9:	68 c7 00 00 00       	push   $0xc7
c01046fe:	68 93 67 10 c0       	push   $0xc0106793
c0104703:	e8 cd bc ff ff       	call   c01003d5 <__panic>

    list_entry_t free_list_store = free_list;
c0104708:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c010470d:	8b 15 c0 89 11 c0    	mov    0xc01189c0,%edx
c0104713:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104716:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104719:	c7 45 e4 bc 89 11 c0 	movl   $0xc01189bc,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104723:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104726:	89 50 04             	mov    %edx,0x4(%eax)
c0104729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010472c:	8b 50 04             	mov    0x4(%eax),%edx
c010472f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104732:	89 10                	mov    %edx,(%eax)
c0104734:	c7 45 d8 bc 89 11 c0 	movl   $0xc01189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010473b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010473e:	8b 40 04             	mov    0x4(%eax),%eax
c0104741:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104744:	0f 94 c0             	sete   %al
c0104747:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010474a:	85 c0                	test   %eax,%eax
c010474c:	75 19                	jne    c0104767 <basic_check+0x224>
c010474e:	68 ef 68 10 c0       	push   $0xc01068ef
c0104753:	68 7e 67 10 c0       	push   $0xc010677e
c0104758:	68 cb 00 00 00       	push   $0xcb
c010475d:	68 93 67 10 c0       	push   $0xc0106793
c0104762:	e8 6e bc ff ff       	call   c01003d5 <__panic>

    unsigned int nr_free_store = nr_free;
c0104767:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c010476c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010476f:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c0104776:	00 00 00 

    assert(alloc_page() == NULL);
c0104779:	83 ec 0c             	sub    $0xc,%esp
c010477c:	6a 01                	push   $0x1
c010477e:	e8 dd e4 ff ff       	call   c0102c60 <alloc_pages>
c0104783:	83 c4 10             	add    $0x10,%esp
c0104786:	85 c0                	test   %eax,%eax
c0104788:	74 19                	je     c01047a3 <basic_check+0x260>
c010478a:	68 06 69 10 c0       	push   $0xc0106906
c010478f:	68 7e 67 10 c0       	push   $0xc010677e
c0104794:	68 d0 00 00 00       	push   $0xd0
c0104799:	68 93 67 10 c0       	push   $0xc0106793
c010479e:	e8 32 bc ff ff       	call   c01003d5 <__panic>

    free_page(p0);
c01047a3:	83 ec 08             	sub    $0x8,%esp
c01047a6:	6a 01                	push   $0x1
c01047a8:	ff 75 ec             	pushl  -0x14(%ebp)
c01047ab:	e8 ee e4 ff ff       	call   c0102c9e <free_pages>
c01047b0:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01047b3:	83 ec 08             	sub    $0x8,%esp
c01047b6:	6a 01                	push   $0x1
c01047b8:	ff 75 f0             	pushl  -0x10(%ebp)
c01047bb:	e8 de e4 ff ff       	call   c0102c9e <free_pages>
c01047c0:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01047c3:	83 ec 08             	sub    $0x8,%esp
c01047c6:	6a 01                	push   $0x1
c01047c8:	ff 75 f4             	pushl  -0xc(%ebp)
c01047cb:	e8 ce e4 ff ff       	call   c0102c9e <free_pages>
c01047d0:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c01047d3:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c01047d8:	83 f8 03             	cmp    $0x3,%eax
c01047db:	74 19                	je     c01047f6 <basic_check+0x2b3>
c01047dd:	68 1b 69 10 c0       	push   $0xc010691b
c01047e2:	68 7e 67 10 c0       	push   $0xc010677e
c01047e7:	68 d5 00 00 00       	push   $0xd5
c01047ec:	68 93 67 10 c0       	push   $0xc0106793
c01047f1:	e8 df bb ff ff       	call   c01003d5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01047f6:	83 ec 0c             	sub    $0xc,%esp
c01047f9:	6a 01                	push   $0x1
c01047fb:	e8 60 e4 ff ff       	call   c0102c60 <alloc_pages>
c0104800:	83 c4 10             	add    $0x10,%esp
c0104803:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010480a:	75 19                	jne    c0104825 <basic_check+0x2e2>
c010480c:	68 e1 67 10 c0       	push   $0xc01067e1
c0104811:	68 7e 67 10 c0       	push   $0xc010677e
c0104816:	68 d7 00 00 00       	push   $0xd7
c010481b:	68 93 67 10 c0       	push   $0xc0106793
c0104820:	e8 b0 bb ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104825:	83 ec 0c             	sub    $0xc,%esp
c0104828:	6a 01                	push   $0x1
c010482a:	e8 31 e4 ff ff       	call   c0102c60 <alloc_pages>
c010482f:	83 c4 10             	add    $0x10,%esp
c0104832:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104835:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104839:	75 19                	jne    c0104854 <basic_check+0x311>
c010483b:	68 fd 67 10 c0       	push   $0xc01067fd
c0104840:	68 7e 67 10 c0       	push   $0xc010677e
c0104845:	68 d8 00 00 00       	push   $0xd8
c010484a:	68 93 67 10 c0       	push   $0xc0106793
c010484f:	e8 81 bb ff ff       	call   c01003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104854:	83 ec 0c             	sub    $0xc,%esp
c0104857:	6a 01                	push   $0x1
c0104859:	e8 02 e4 ff ff       	call   c0102c60 <alloc_pages>
c010485e:	83 c4 10             	add    $0x10,%esp
c0104861:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104864:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104868:	75 19                	jne    c0104883 <basic_check+0x340>
c010486a:	68 19 68 10 c0       	push   $0xc0106819
c010486f:	68 7e 67 10 c0       	push   $0xc010677e
c0104874:	68 d9 00 00 00       	push   $0xd9
c0104879:	68 93 67 10 c0       	push   $0xc0106793
c010487e:	e8 52 bb ff ff       	call   c01003d5 <__panic>

    assert(alloc_page() == NULL);
c0104883:	83 ec 0c             	sub    $0xc,%esp
c0104886:	6a 01                	push   $0x1
c0104888:	e8 d3 e3 ff ff       	call   c0102c60 <alloc_pages>
c010488d:	83 c4 10             	add    $0x10,%esp
c0104890:	85 c0                	test   %eax,%eax
c0104892:	74 19                	je     c01048ad <basic_check+0x36a>
c0104894:	68 06 69 10 c0       	push   $0xc0106906
c0104899:	68 7e 67 10 c0       	push   $0xc010677e
c010489e:	68 db 00 00 00       	push   $0xdb
c01048a3:	68 93 67 10 c0       	push   $0xc0106793
c01048a8:	e8 28 bb ff ff       	call   c01003d5 <__panic>

    free_page(p0);
c01048ad:	83 ec 08             	sub    $0x8,%esp
c01048b0:	6a 01                	push   $0x1
c01048b2:	ff 75 ec             	pushl  -0x14(%ebp)
c01048b5:	e8 e4 e3 ff ff       	call   c0102c9e <free_pages>
c01048ba:	83 c4 10             	add    $0x10,%esp
c01048bd:	c7 45 e8 bc 89 11 c0 	movl   $0xc01189bc,-0x18(%ebp)
c01048c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01048c7:	8b 40 04             	mov    0x4(%eax),%eax
c01048ca:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01048cd:	0f 94 c0             	sete   %al
c01048d0:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01048d3:	85 c0                	test   %eax,%eax
c01048d5:	74 19                	je     c01048f0 <basic_check+0x3ad>
c01048d7:	68 28 69 10 c0       	push   $0xc0106928
c01048dc:	68 7e 67 10 c0       	push   $0xc010677e
c01048e1:	68 de 00 00 00       	push   $0xde
c01048e6:	68 93 67 10 c0       	push   $0xc0106793
c01048eb:	e8 e5 ba ff ff       	call   c01003d5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01048f0:	83 ec 0c             	sub    $0xc,%esp
c01048f3:	6a 01                	push   $0x1
c01048f5:	e8 66 e3 ff ff       	call   c0102c60 <alloc_pages>
c01048fa:	83 c4 10             	add    $0x10,%esp
c01048fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104900:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104903:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104906:	74 19                	je     c0104921 <basic_check+0x3de>
c0104908:	68 40 69 10 c0       	push   $0xc0106940
c010490d:	68 7e 67 10 c0       	push   $0xc010677e
c0104912:	68 e1 00 00 00       	push   $0xe1
c0104917:	68 93 67 10 c0       	push   $0xc0106793
c010491c:	e8 b4 ba ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104921:	83 ec 0c             	sub    $0xc,%esp
c0104924:	6a 01                	push   $0x1
c0104926:	e8 35 e3 ff ff       	call   c0102c60 <alloc_pages>
c010492b:	83 c4 10             	add    $0x10,%esp
c010492e:	85 c0                	test   %eax,%eax
c0104930:	74 19                	je     c010494b <basic_check+0x408>
c0104932:	68 06 69 10 c0       	push   $0xc0106906
c0104937:	68 7e 67 10 c0       	push   $0xc010677e
c010493c:	68 e2 00 00 00       	push   $0xe2
c0104941:	68 93 67 10 c0       	push   $0xc0106793
c0104946:	e8 8a ba ff ff       	call   c01003d5 <__panic>

    assert(nr_free == 0);
c010494b:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104950:	85 c0                	test   %eax,%eax
c0104952:	74 19                	je     c010496d <basic_check+0x42a>
c0104954:	68 59 69 10 c0       	push   $0xc0106959
c0104959:	68 7e 67 10 c0       	push   $0xc010677e
c010495e:	68 e4 00 00 00       	push   $0xe4
c0104963:	68 93 67 10 c0       	push   $0xc0106793
c0104968:	e8 68 ba ff ff       	call   c01003d5 <__panic>
    free_list = free_list_store;
c010496d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104970:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104973:	a3 bc 89 11 c0       	mov    %eax,0xc01189bc
c0104978:	89 15 c0 89 11 c0    	mov    %edx,0xc01189c0
    nr_free = nr_free_store;
c010497e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104981:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    free_page(p);
c0104986:	83 ec 08             	sub    $0x8,%esp
c0104989:	6a 01                	push   $0x1
c010498b:	ff 75 dc             	pushl  -0x24(%ebp)
c010498e:	e8 0b e3 ff ff       	call   c0102c9e <free_pages>
c0104993:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104996:	83 ec 08             	sub    $0x8,%esp
c0104999:	6a 01                	push   $0x1
c010499b:	ff 75 f0             	pushl  -0x10(%ebp)
c010499e:	e8 fb e2 ff ff       	call   c0102c9e <free_pages>
c01049a3:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01049a6:	83 ec 08             	sub    $0x8,%esp
c01049a9:	6a 01                	push   $0x1
c01049ab:	ff 75 f4             	pushl  -0xc(%ebp)
c01049ae:	e8 eb e2 ff ff       	call   c0102c9e <free_pages>
c01049b3:	83 c4 10             	add    $0x10,%esp
}
c01049b6:	90                   	nop
c01049b7:	c9                   	leave  
c01049b8:	c3                   	ret    

c01049b9 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01049b9:	55                   	push   %ebp
c01049ba:	89 e5                	mov    %esp,%ebp
c01049bc:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c01049c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01049c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01049d0:	c7 45 ec bc 89 11 c0 	movl   $0xc01189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01049d7:	eb 60                	jmp    c0104a39 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c01049d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049dc:	83 e8 0c             	sub    $0xc,%eax
c01049df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01049e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049e5:	83 c0 04             	add    $0x4,%eax
c01049e8:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01049ef:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01049f2:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01049f5:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01049f8:	0f a3 10             	bt     %edx,(%eax)
c01049fb:	19 c0                	sbb    %eax,%eax
c01049fd:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104a00:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104a04:	0f 95 c0             	setne  %al
c0104a07:	0f b6 c0             	movzbl %al,%eax
c0104a0a:	85 c0                	test   %eax,%eax
c0104a0c:	75 19                	jne    c0104a27 <default_check+0x6e>
c0104a0e:	68 66 69 10 c0       	push   $0xc0106966
c0104a13:	68 7e 67 10 c0       	push   $0xc010677e
c0104a18:	68 f5 00 00 00       	push   $0xf5
c0104a1d:	68 93 67 10 c0       	push   $0xc0106793
c0104a22:	e8 ae b9 ff ff       	call   c01003d5 <__panic>
        count ++, total += p->property;
c0104a27:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a2e:	8b 50 08             	mov    0x8(%eax),%edx
c0104a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a34:	01 d0                	add    %edx,%eax
c0104a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a42:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104a45:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a48:	81 7d ec bc 89 11 c0 	cmpl   $0xc01189bc,-0x14(%ebp)
c0104a4f:	75 88                	jne    c01049d9 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104a51:	e8 7d e2 ff ff       	call   c0102cd3 <nr_free_pages>
c0104a56:	89 c2                	mov    %eax,%edx
c0104a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a5b:	39 c2                	cmp    %eax,%edx
c0104a5d:	74 19                	je     c0104a78 <default_check+0xbf>
c0104a5f:	68 76 69 10 c0       	push   $0xc0106976
c0104a64:	68 7e 67 10 c0       	push   $0xc010677e
c0104a69:	68 f8 00 00 00       	push   $0xf8
c0104a6e:	68 93 67 10 c0       	push   $0xc0106793
c0104a73:	e8 5d b9 ff ff       	call   c01003d5 <__panic>

    basic_check();
c0104a78:	e8 c6 fa ff ff       	call   c0104543 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104a7d:	83 ec 0c             	sub    $0xc,%esp
c0104a80:	6a 05                	push   $0x5
c0104a82:	e8 d9 e1 ff ff       	call   c0102c60 <alloc_pages>
c0104a87:	83 c4 10             	add    $0x10,%esp
c0104a8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0104a8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104a91:	75 19                	jne    c0104aac <default_check+0xf3>
c0104a93:	68 8f 69 10 c0       	push   $0xc010698f
c0104a98:	68 7e 67 10 c0       	push   $0xc010677e
c0104a9d:	68 fd 00 00 00       	push   $0xfd
c0104aa2:	68 93 67 10 c0       	push   $0xc0106793
c0104aa7:	e8 29 b9 ff ff       	call   c01003d5 <__panic>
    assert(!PageProperty(p0));
c0104aac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104aaf:	83 c0 04             	add    $0x4,%eax
c0104ab2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104ab9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104abc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104abf:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104ac2:	0f a3 10             	bt     %edx,(%eax)
c0104ac5:	19 c0                	sbb    %eax,%eax
c0104ac7:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104aca:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104ace:	0f 95 c0             	setne  %al
c0104ad1:	0f b6 c0             	movzbl %al,%eax
c0104ad4:	85 c0                	test   %eax,%eax
c0104ad6:	74 19                	je     c0104af1 <default_check+0x138>
c0104ad8:	68 9a 69 10 c0       	push   $0xc010699a
c0104add:	68 7e 67 10 c0       	push   $0xc010677e
c0104ae2:	68 fe 00 00 00       	push   $0xfe
c0104ae7:	68 93 67 10 c0       	push   $0xc0106793
c0104aec:	e8 e4 b8 ff ff       	call   c01003d5 <__panic>

    list_entry_t free_list_store = free_list;
c0104af1:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104af6:	8b 15 c0 89 11 c0    	mov    0xc01189c0,%edx
c0104afc:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104aff:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104b02:	c7 45 d0 bc 89 11 c0 	movl   $0xc01189bc,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104b09:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b0c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104b0f:	89 50 04             	mov    %edx,0x4(%eax)
c0104b12:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b15:	8b 50 04             	mov    0x4(%eax),%edx
c0104b18:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b1b:	89 10                	mov    %edx,(%eax)
c0104b1d:	c7 45 d8 bc 89 11 c0 	movl   $0xc01189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104b24:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b27:	8b 40 04             	mov    0x4(%eax),%eax
c0104b2a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104b2d:	0f 94 c0             	sete   %al
c0104b30:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104b33:	85 c0                	test   %eax,%eax
c0104b35:	75 19                	jne    c0104b50 <default_check+0x197>
c0104b37:	68 ef 68 10 c0       	push   $0xc01068ef
c0104b3c:	68 7e 67 10 c0       	push   $0xc010677e
c0104b41:	68 02 01 00 00       	push   $0x102
c0104b46:	68 93 67 10 c0       	push   $0xc0106793
c0104b4b:	e8 85 b8 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104b50:	83 ec 0c             	sub    $0xc,%esp
c0104b53:	6a 01                	push   $0x1
c0104b55:	e8 06 e1 ff ff       	call   c0102c60 <alloc_pages>
c0104b5a:	83 c4 10             	add    $0x10,%esp
c0104b5d:	85 c0                	test   %eax,%eax
c0104b5f:	74 19                	je     c0104b7a <default_check+0x1c1>
c0104b61:	68 06 69 10 c0       	push   $0xc0106906
c0104b66:	68 7e 67 10 c0       	push   $0xc010677e
c0104b6b:	68 03 01 00 00       	push   $0x103
c0104b70:	68 93 67 10 c0       	push   $0xc0106793
c0104b75:	e8 5b b8 ff ff       	call   c01003d5 <__panic>

    unsigned int nr_free_store = nr_free;
c0104b7a:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104b7f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104b82:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c0104b89:	00 00 00 

    free_pages(p0 + 2, 3);
c0104b8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b8f:	83 c0 28             	add    $0x28,%eax
c0104b92:	83 ec 08             	sub    $0x8,%esp
c0104b95:	6a 03                	push   $0x3
c0104b97:	50                   	push   %eax
c0104b98:	e8 01 e1 ff ff       	call   c0102c9e <free_pages>
c0104b9d:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104ba0:	83 ec 0c             	sub    $0xc,%esp
c0104ba3:	6a 04                	push   $0x4
c0104ba5:	e8 b6 e0 ff ff       	call   c0102c60 <alloc_pages>
c0104baa:	83 c4 10             	add    $0x10,%esp
c0104bad:	85 c0                	test   %eax,%eax
c0104baf:	74 19                	je     c0104bca <default_check+0x211>
c0104bb1:	68 ac 69 10 c0       	push   $0xc01069ac
c0104bb6:	68 7e 67 10 c0       	push   $0xc010677e
c0104bbb:	68 09 01 00 00       	push   $0x109
c0104bc0:	68 93 67 10 c0       	push   $0xc0106793
c0104bc5:	e8 0b b8 ff ff       	call   c01003d5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104bca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104bcd:	83 c0 28             	add    $0x28,%eax
c0104bd0:	83 c0 04             	add    $0x4,%eax
c0104bd3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104bda:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104bdd:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104be0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104be3:	0f a3 10             	bt     %edx,(%eax)
c0104be6:	19 c0                	sbb    %eax,%eax
c0104be8:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104beb:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104bef:	0f 95 c0             	setne  %al
c0104bf2:	0f b6 c0             	movzbl %al,%eax
c0104bf5:	85 c0                	test   %eax,%eax
c0104bf7:	74 0e                	je     c0104c07 <default_check+0x24e>
c0104bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104bfc:	83 c0 28             	add    $0x28,%eax
c0104bff:	8b 40 08             	mov    0x8(%eax),%eax
c0104c02:	83 f8 03             	cmp    $0x3,%eax
c0104c05:	74 19                	je     c0104c20 <default_check+0x267>
c0104c07:	68 c4 69 10 c0       	push   $0xc01069c4
c0104c0c:	68 7e 67 10 c0       	push   $0xc010677e
c0104c11:	68 0a 01 00 00       	push   $0x10a
c0104c16:	68 93 67 10 c0       	push   $0xc0106793
c0104c1b:	e8 b5 b7 ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104c20:	83 ec 0c             	sub    $0xc,%esp
c0104c23:	6a 03                	push   $0x3
c0104c25:	e8 36 e0 ff ff       	call   c0102c60 <alloc_pages>
c0104c2a:	83 c4 10             	add    $0x10,%esp
c0104c2d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104c30:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104c34:	75 19                	jne    c0104c4f <default_check+0x296>
c0104c36:	68 f0 69 10 c0       	push   $0xc01069f0
c0104c3b:	68 7e 67 10 c0       	push   $0xc010677e
c0104c40:	68 0b 01 00 00       	push   $0x10b
c0104c45:	68 93 67 10 c0       	push   $0xc0106793
c0104c4a:	e8 86 b7 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104c4f:	83 ec 0c             	sub    $0xc,%esp
c0104c52:	6a 01                	push   $0x1
c0104c54:	e8 07 e0 ff ff       	call   c0102c60 <alloc_pages>
c0104c59:	83 c4 10             	add    $0x10,%esp
c0104c5c:	85 c0                	test   %eax,%eax
c0104c5e:	74 19                	je     c0104c79 <default_check+0x2c0>
c0104c60:	68 06 69 10 c0       	push   $0xc0106906
c0104c65:	68 7e 67 10 c0       	push   $0xc010677e
c0104c6a:	68 0c 01 00 00       	push   $0x10c
c0104c6f:	68 93 67 10 c0       	push   $0xc0106793
c0104c74:	e8 5c b7 ff ff       	call   c01003d5 <__panic>
    assert(p0 + 2 == p1);
c0104c79:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c7c:	83 c0 28             	add    $0x28,%eax
c0104c7f:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104c82:	74 19                	je     c0104c9d <default_check+0x2e4>
c0104c84:	68 0e 6a 10 c0       	push   $0xc0106a0e
c0104c89:	68 7e 67 10 c0       	push   $0xc010677e
c0104c8e:	68 0d 01 00 00       	push   $0x10d
c0104c93:	68 93 67 10 c0       	push   $0xc0106793
c0104c98:	e8 38 b7 ff ff       	call   c01003d5 <__panic>

    p2 = p0 + 1;
c0104c9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ca0:	83 c0 14             	add    $0x14,%eax
c0104ca3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104ca6:	83 ec 08             	sub    $0x8,%esp
c0104ca9:	6a 01                	push   $0x1
c0104cab:	ff 75 dc             	pushl  -0x24(%ebp)
c0104cae:	e8 eb df ff ff       	call   c0102c9e <free_pages>
c0104cb3:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104cb6:	83 ec 08             	sub    $0x8,%esp
c0104cb9:	6a 03                	push   $0x3
c0104cbb:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104cbe:	e8 db df ff ff       	call   c0102c9e <free_pages>
c0104cc3:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104cc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104cc9:	83 c0 04             	add    $0x4,%eax
c0104ccc:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104cd3:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104cd6:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104cd9:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104cdc:	0f a3 10             	bt     %edx,(%eax)
c0104cdf:	19 c0                	sbb    %eax,%eax
c0104ce1:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104ce4:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104ce8:	0f 95 c0             	setne  %al
c0104ceb:	0f b6 c0             	movzbl %al,%eax
c0104cee:	85 c0                	test   %eax,%eax
c0104cf0:	74 0b                	je     c0104cfd <default_check+0x344>
c0104cf2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104cf5:	8b 40 08             	mov    0x8(%eax),%eax
c0104cf8:	83 f8 01             	cmp    $0x1,%eax
c0104cfb:	74 19                	je     c0104d16 <default_check+0x35d>
c0104cfd:	68 1c 6a 10 c0       	push   $0xc0106a1c
c0104d02:	68 7e 67 10 c0       	push   $0xc010677e
c0104d07:	68 12 01 00 00       	push   $0x112
c0104d0c:	68 93 67 10 c0       	push   $0xc0106793
c0104d11:	e8 bf b6 ff ff       	call   c01003d5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104d16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d19:	83 c0 04             	add    $0x4,%eax
c0104d1c:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104d23:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d26:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104d29:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104d2c:	0f a3 10             	bt     %edx,(%eax)
c0104d2f:	19 c0                	sbb    %eax,%eax
c0104d31:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104d34:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104d38:	0f 95 c0             	setne  %al
c0104d3b:	0f b6 c0             	movzbl %al,%eax
c0104d3e:	85 c0                	test   %eax,%eax
c0104d40:	74 0b                	je     c0104d4d <default_check+0x394>
c0104d42:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d45:	8b 40 08             	mov    0x8(%eax),%eax
c0104d48:	83 f8 03             	cmp    $0x3,%eax
c0104d4b:	74 19                	je     c0104d66 <default_check+0x3ad>
c0104d4d:	68 44 6a 10 c0       	push   $0xc0106a44
c0104d52:	68 7e 67 10 c0       	push   $0xc010677e
c0104d57:	68 13 01 00 00       	push   $0x113
c0104d5c:	68 93 67 10 c0       	push   $0xc0106793
c0104d61:	e8 6f b6 ff ff       	call   c01003d5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104d66:	83 ec 0c             	sub    $0xc,%esp
c0104d69:	6a 01                	push   $0x1
c0104d6b:	e8 f0 de ff ff       	call   c0102c60 <alloc_pages>
c0104d70:	83 c4 10             	add    $0x10,%esp
c0104d73:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104d76:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104d79:	83 e8 14             	sub    $0x14,%eax
c0104d7c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104d7f:	74 19                	je     c0104d9a <default_check+0x3e1>
c0104d81:	68 6a 6a 10 c0       	push   $0xc0106a6a
c0104d86:	68 7e 67 10 c0       	push   $0xc010677e
c0104d8b:	68 15 01 00 00       	push   $0x115
c0104d90:	68 93 67 10 c0       	push   $0xc0106793
c0104d95:	e8 3b b6 ff ff       	call   c01003d5 <__panic>
    free_page(p0);
c0104d9a:	83 ec 08             	sub    $0x8,%esp
c0104d9d:	6a 01                	push   $0x1
c0104d9f:	ff 75 dc             	pushl  -0x24(%ebp)
c0104da2:	e8 f7 de ff ff       	call   c0102c9e <free_pages>
c0104da7:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104daa:	83 ec 0c             	sub    $0xc,%esp
c0104dad:	6a 02                	push   $0x2
c0104daf:	e8 ac de ff ff       	call   c0102c60 <alloc_pages>
c0104db4:	83 c4 10             	add    $0x10,%esp
c0104db7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104dba:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104dbd:	83 c0 14             	add    $0x14,%eax
c0104dc0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104dc3:	74 19                	je     c0104dde <default_check+0x425>
c0104dc5:	68 88 6a 10 c0       	push   $0xc0106a88
c0104dca:	68 7e 67 10 c0       	push   $0xc010677e
c0104dcf:	68 17 01 00 00       	push   $0x117
c0104dd4:	68 93 67 10 c0       	push   $0xc0106793
c0104dd9:	e8 f7 b5 ff ff       	call   c01003d5 <__panic>

    free_pages(p0, 2);
c0104dde:	83 ec 08             	sub    $0x8,%esp
c0104de1:	6a 02                	push   $0x2
c0104de3:	ff 75 dc             	pushl  -0x24(%ebp)
c0104de6:	e8 b3 de ff ff       	call   c0102c9e <free_pages>
c0104deb:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104dee:	83 ec 08             	sub    $0x8,%esp
c0104df1:	6a 01                	push   $0x1
c0104df3:	ff 75 c0             	pushl  -0x40(%ebp)
c0104df6:	e8 a3 de ff ff       	call   c0102c9e <free_pages>
c0104dfb:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0104dfe:	83 ec 0c             	sub    $0xc,%esp
c0104e01:	6a 05                	push   $0x5
c0104e03:	e8 58 de ff ff       	call   c0102c60 <alloc_pages>
c0104e08:	83 c4 10             	add    $0x10,%esp
c0104e0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104e12:	75 19                	jne    c0104e2d <default_check+0x474>
c0104e14:	68 a8 6a 10 c0       	push   $0xc0106aa8
c0104e19:	68 7e 67 10 c0       	push   $0xc010677e
c0104e1e:	68 1c 01 00 00       	push   $0x11c
c0104e23:	68 93 67 10 c0       	push   $0xc0106793
c0104e28:	e8 a8 b5 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104e2d:	83 ec 0c             	sub    $0xc,%esp
c0104e30:	6a 01                	push   $0x1
c0104e32:	e8 29 de ff ff       	call   c0102c60 <alloc_pages>
c0104e37:	83 c4 10             	add    $0x10,%esp
c0104e3a:	85 c0                	test   %eax,%eax
c0104e3c:	74 19                	je     c0104e57 <default_check+0x49e>
c0104e3e:	68 06 69 10 c0       	push   $0xc0106906
c0104e43:	68 7e 67 10 c0       	push   $0xc010677e
c0104e48:	68 1d 01 00 00       	push   $0x11d
c0104e4d:	68 93 67 10 c0       	push   $0xc0106793
c0104e52:	e8 7e b5 ff ff       	call   c01003d5 <__panic>

    assert(nr_free == 0);
c0104e57:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104e5c:	85 c0                	test   %eax,%eax
c0104e5e:	74 19                	je     c0104e79 <default_check+0x4c0>
c0104e60:	68 59 69 10 c0       	push   $0xc0106959
c0104e65:	68 7e 67 10 c0       	push   $0xc010677e
c0104e6a:	68 1f 01 00 00       	push   $0x11f
c0104e6f:	68 93 67 10 c0       	push   $0xc0106793
c0104e74:	e8 5c b5 ff ff       	call   c01003d5 <__panic>
    nr_free = nr_free_store;
c0104e79:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104e7c:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    free_list = free_list_store;
c0104e81:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104e84:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104e87:	a3 bc 89 11 c0       	mov    %eax,0xc01189bc
c0104e8c:	89 15 c0 89 11 c0    	mov    %edx,0xc01189c0
    free_pages(p0, 5);
c0104e92:	83 ec 08             	sub    $0x8,%esp
c0104e95:	6a 05                	push   $0x5
c0104e97:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e9a:	e8 ff dd ff ff       	call   c0102c9e <free_pages>
c0104e9f:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0104ea2:	c7 45 ec bc 89 11 c0 	movl   $0xc01189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104ea9:	eb 1d                	jmp    c0104ec8 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0104eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eae:	83 e8 0c             	sub    $0xc,%eax
c0104eb1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0104eb4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ebb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104ebe:	8b 40 08             	mov    0x8(%eax),%eax
c0104ec1:	29 c2                	sub    %eax,%edx
c0104ec3:	89 d0                	mov    %edx,%eax
c0104ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ecb:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104ece:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104ed1:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104ed7:	81 7d ec bc 89 11 c0 	cmpl   $0xc01189bc,-0x14(%ebp)
c0104ede:	75 cb                	jne    c0104eab <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104ee0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ee4:	74 19                	je     c0104eff <default_check+0x546>
c0104ee6:	68 c6 6a 10 c0       	push   $0xc0106ac6
c0104eeb:	68 7e 67 10 c0       	push   $0xc010677e
c0104ef0:	68 2a 01 00 00       	push   $0x12a
c0104ef5:	68 93 67 10 c0       	push   $0xc0106793
c0104efa:	e8 d6 b4 ff ff       	call   c01003d5 <__panic>
    assert(total == 0);
c0104eff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104f03:	74 19                	je     c0104f1e <default_check+0x565>
c0104f05:	68 d1 6a 10 c0       	push   $0xc0106ad1
c0104f0a:	68 7e 67 10 c0       	push   $0xc010677e
c0104f0f:	68 2b 01 00 00       	push   $0x12b
c0104f14:	68 93 67 10 c0       	push   $0xc0106793
c0104f19:	e8 b7 b4 ff ff       	call   c01003d5 <__panic>
}
c0104f1e:	90                   	nop
c0104f1f:	c9                   	leave  
c0104f20:	c3                   	ret    

c0104f21 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0104f21:	55                   	push   %ebp
c0104f22:	89 e5                	mov    %esp,%ebp
c0104f24:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104f27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0104f2e:	eb 04                	jmp    c0104f34 <strlen+0x13>
        cnt ++;
c0104f30:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0104f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f37:	8d 50 01             	lea    0x1(%eax),%edx
c0104f3a:	89 55 08             	mov    %edx,0x8(%ebp)
c0104f3d:	0f b6 00             	movzbl (%eax),%eax
c0104f40:	84 c0                	test   %al,%al
c0104f42:	75 ec                	jne    c0104f30 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0104f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104f47:	c9                   	leave  
c0104f48:	c3                   	ret    

c0104f49 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0104f49:	55                   	push   %ebp
c0104f4a:	89 e5                	mov    %esp,%ebp
c0104f4c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104f4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0104f56:	eb 04                	jmp    c0104f5c <strnlen+0x13>
        cnt ++;
c0104f58:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0104f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104f5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104f62:	73 10                	jae    c0104f74 <strnlen+0x2b>
c0104f64:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f67:	8d 50 01             	lea    0x1(%eax),%edx
c0104f6a:	89 55 08             	mov    %edx,0x8(%ebp)
c0104f6d:	0f b6 00             	movzbl (%eax),%eax
c0104f70:	84 c0                	test   %al,%al
c0104f72:	75 e4                	jne    c0104f58 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0104f74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104f77:	c9                   	leave  
c0104f78:	c3                   	ret    

c0104f79 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0104f79:	55                   	push   %ebp
c0104f7a:	89 e5                	mov    %esp,%ebp
c0104f7c:	57                   	push   %edi
c0104f7d:	56                   	push   %esi
c0104f7e:	83 ec 20             	sub    $0x20,%esp
c0104f81:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0104f8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f93:	89 d1                	mov    %edx,%ecx
c0104f95:	89 c2                	mov    %eax,%edx
c0104f97:	89 ce                	mov    %ecx,%esi
c0104f99:	89 d7                	mov    %edx,%edi
c0104f9b:	ac                   	lods   %ds:(%esi),%al
c0104f9c:	aa                   	stos   %al,%es:(%edi)
c0104f9d:	84 c0                	test   %al,%al
c0104f9f:	75 fa                	jne    c0104f9b <strcpy+0x22>
c0104fa1:	89 fa                	mov    %edi,%edx
c0104fa3:	89 f1                	mov    %esi,%ecx
c0104fa5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0104fa8:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0104fab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0104fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0104fb1:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0104fb2:	83 c4 20             	add    $0x20,%esp
c0104fb5:	5e                   	pop    %esi
c0104fb6:	5f                   	pop    %edi
c0104fb7:	5d                   	pop    %ebp
c0104fb8:	c3                   	ret    

c0104fb9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0104fb9:	55                   	push   %ebp
c0104fba:	89 e5                	mov    %esp,%ebp
c0104fbc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0104fbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0104fc5:	eb 21                	jmp    c0104fe8 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0104fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fca:	0f b6 10             	movzbl (%eax),%edx
c0104fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104fd0:	88 10                	mov    %dl,(%eax)
c0104fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104fd5:	0f b6 00             	movzbl (%eax),%eax
c0104fd8:	84 c0                	test   %al,%al
c0104fda:	74 04                	je     c0104fe0 <strncpy+0x27>
            src ++;
c0104fdc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0104fe0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104fe4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0104fe8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104fec:	75 d9                	jne    c0104fc7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0104fee:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0104ff1:	c9                   	leave  
c0104ff2:	c3                   	ret    

c0104ff3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0104ff3:	55                   	push   %ebp
c0104ff4:	89 e5                	mov    %esp,%ebp
c0104ff6:	57                   	push   %edi
c0104ff7:	56                   	push   %esi
c0104ff8:	83 ec 20             	sub    $0x20,%esp
c0104ffb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105001:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105004:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105007:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010500a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010500d:	89 d1                	mov    %edx,%ecx
c010500f:	89 c2                	mov    %eax,%edx
c0105011:	89 ce                	mov    %ecx,%esi
c0105013:	89 d7                	mov    %edx,%edi
c0105015:	ac                   	lods   %ds:(%esi),%al
c0105016:	ae                   	scas   %es:(%edi),%al
c0105017:	75 08                	jne    c0105021 <strcmp+0x2e>
c0105019:	84 c0                	test   %al,%al
c010501b:	75 f8                	jne    c0105015 <strcmp+0x22>
c010501d:	31 c0                	xor    %eax,%eax
c010501f:	eb 04                	jmp    c0105025 <strcmp+0x32>
c0105021:	19 c0                	sbb    %eax,%eax
c0105023:	0c 01                	or     $0x1,%al
c0105025:	89 fa                	mov    %edi,%edx
c0105027:	89 f1                	mov    %esi,%ecx
c0105029:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010502c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010502f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105032:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105035:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105036:	83 c4 20             	add    $0x20,%esp
c0105039:	5e                   	pop    %esi
c010503a:	5f                   	pop    %edi
c010503b:	5d                   	pop    %ebp
c010503c:	c3                   	ret    

c010503d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010503d:	55                   	push   %ebp
c010503e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105040:	eb 0c                	jmp    c010504e <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105042:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105046:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010504a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010504e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105052:	74 1a                	je     c010506e <strncmp+0x31>
c0105054:	8b 45 08             	mov    0x8(%ebp),%eax
c0105057:	0f b6 00             	movzbl (%eax),%eax
c010505a:	84 c0                	test   %al,%al
c010505c:	74 10                	je     c010506e <strncmp+0x31>
c010505e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105061:	0f b6 10             	movzbl (%eax),%edx
c0105064:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105067:	0f b6 00             	movzbl (%eax),%eax
c010506a:	38 c2                	cmp    %al,%dl
c010506c:	74 d4                	je     c0105042 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010506e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105072:	74 18                	je     c010508c <strncmp+0x4f>
c0105074:	8b 45 08             	mov    0x8(%ebp),%eax
c0105077:	0f b6 00             	movzbl (%eax),%eax
c010507a:	0f b6 d0             	movzbl %al,%edx
c010507d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105080:	0f b6 00             	movzbl (%eax),%eax
c0105083:	0f b6 c0             	movzbl %al,%eax
c0105086:	29 c2                	sub    %eax,%edx
c0105088:	89 d0                	mov    %edx,%eax
c010508a:	eb 05                	jmp    c0105091 <strncmp+0x54>
c010508c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105091:	5d                   	pop    %ebp
c0105092:	c3                   	ret    

c0105093 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105093:	55                   	push   %ebp
c0105094:	89 e5                	mov    %esp,%ebp
c0105096:	83 ec 04             	sub    $0x4,%esp
c0105099:	8b 45 0c             	mov    0xc(%ebp),%eax
c010509c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010509f:	eb 14                	jmp    c01050b5 <strchr+0x22>
        if (*s == c) {
c01050a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01050a4:	0f b6 00             	movzbl (%eax),%eax
c01050a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01050aa:	75 05                	jne    c01050b1 <strchr+0x1e>
            return (char *)s;
c01050ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01050af:	eb 13                	jmp    c01050c4 <strchr+0x31>
        }
        s ++;
c01050b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01050b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01050b8:	0f b6 00             	movzbl (%eax),%eax
c01050bb:	84 c0                	test   %al,%al
c01050bd:	75 e2                	jne    c01050a1 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c01050bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050c4:	c9                   	leave  
c01050c5:	c3                   	ret    

c01050c6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01050c6:	55                   	push   %ebp
c01050c7:	89 e5                	mov    %esp,%ebp
c01050c9:	83 ec 04             	sub    $0x4,%esp
c01050cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050cf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01050d2:	eb 0f                	jmp    c01050e3 <strfind+0x1d>
        if (*s == c) {
c01050d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01050d7:	0f b6 00             	movzbl (%eax),%eax
c01050da:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01050dd:	74 10                	je     c01050ef <strfind+0x29>
            break;
        }
        s ++;
c01050df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01050e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01050e6:	0f b6 00             	movzbl (%eax),%eax
c01050e9:	84 c0                	test   %al,%al
c01050eb:	75 e7                	jne    c01050d4 <strfind+0xe>
c01050ed:	eb 01                	jmp    c01050f0 <strfind+0x2a>
        if (*s == c) {
            break;
c01050ef:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c01050f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01050f3:	c9                   	leave  
c01050f4:	c3                   	ret    

c01050f5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01050f5:	55                   	push   %ebp
c01050f6:	89 e5                	mov    %esp,%ebp
c01050f8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01050fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105102:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105109:	eb 04                	jmp    c010510f <strtol+0x1a>
        s ++;
c010510b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010510f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105112:	0f b6 00             	movzbl (%eax),%eax
c0105115:	3c 20                	cmp    $0x20,%al
c0105117:	74 f2                	je     c010510b <strtol+0x16>
c0105119:	8b 45 08             	mov    0x8(%ebp),%eax
c010511c:	0f b6 00             	movzbl (%eax),%eax
c010511f:	3c 09                	cmp    $0x9,%al
c0105121:	74 e8                	je     c010510b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105123:	8b 45 08             	mov    0x8(%ebp),%eax
c0105126:	0f b6 00             	movzbl (%eax),%eax
c0105129:	3c 2b                	cmp    $0x2b,%al
c010512b:	75 06                	jne    c0105133 <strtol+0x3e>
        s ++;
c010512d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105131:	eb 15                	jmp    c0105148 <strtol+0x53>
    }
    else if (*s == '-') {
c0105133:	8b 45 08             	mov    0x8(%ebp),%eax
c0105136:	0f b6 00             	movzbl (%eax),%eax
c0105139:	3c 2d                	cmp    $0x2d,%al
c010513b:	75 0b                	jne    c0105148 <strtol+0x53>
        s ++, neg = 1;
c010513d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105141:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010514c:	74 06                	je     c0105154 <strtol+0x5f>
c010514e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105152:	75 24                	jne    c0105178 <strtol+0x83>
c0105154:	8b 45 08             	mov    0x8(%ebp),%eax
c0105157:	0f b6 00             	movzbl (%eax),%eax
c010515a:	3c 30                	cmp    $0x30,%al
c010515c:	75 1a                	jne    c0105178 <strtol+0x83>
c010515e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105161:	83 c0 01             	add    $0x1,%eax
c0105164:	0f b6 00             	movzbl (%eax),%eax
c0105167:	3c 78                	cmp    $0x78,%al
c0105169:	75 0d                	jne    c0105178 <strtol+0x83>
        s += 2, base = 16;
c010516b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010516f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105176:	eb 2a                	jmp    c01051a2 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105178:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010517c:	75 17                	jne    c0105195 <strtol+0xa0>
c010517e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105181:	0f b6 00             	movzbl (%eax),%eax
c0105184:	3c 30                	cmp    $0x30,%al
c0105186:	75 0d                	jne    c0105195 <strtol+0xa0>
        s ++, base = 8;
c0105188:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010518c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105193:	eb 0d                	jmp    c01051a2 <strtol+0xad>
    }
    else if (base == 0) {
c0105195:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105199:	75 07                	jne    c01051a2 <strtol+0xad>
        base = 10;
c010519b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01051a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a5:	0f b6 00             	movzbl (%eax),%eax
c01051a8:	3c 2f                	cmp    $0x2f,%al
c01051aa:	7e 1b                	jle    c01051c7 <strtol+0xd2>
c01051ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01051af:	0f b6 00             	movzbl (%eax),%eax
c01051b2:	3c 39                	cmp    $0x39,%al
c01051b4:	7f 11                	jg     c01051c7 <strtol+0xd2>
            dig = *s - '0';
c01051b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b9:	0f b6 00             	movzbl (%eax),%eax
c01051bc:	0f be c0             	movsbl %al,%eax
c01051bf:	83 e8 30             	sub    $0x30,%eax
c01051c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051c5:	eb 48                	jmp    c010520f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01051c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ca:	0f b6 00             	movzbl (%eax),%eax
c01051cd:	3c 60                	cmp    $0x60,%al
c01051cf:	7e 1b                	jle    c01051ec <strtol+0xf7>
c01051d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d4:	0f b6 00             	movzbl (%eax),%eax
c01051d7:	3c 7a                	cmp    $0x7a,%al
c01051d9:	7f 11                	jg     c01051ec <strtol+0xf7>
            dig = *s - 'a' + 10;
c01051db:	8b 45 08             	mov    0x8(%ebp),%eax
c01051de:	0f b6 00             	movzbl (%eax),%eax
c01051e1:	0f be c0             	movsbl %al,%eax
c01051e4:	83 e8 57             	sub    $0x57,%eax
c01051e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051ea:	eb 23                	jmp    c010520f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01051ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ef:	0f b6 00             	movzbl (%eax),%eax
c01051f2:	3c 40                	cmp    $0x40,%al
c01051f4:	7e 3c                	jle    c0105232 <strtol+0x13d>
c01051f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f9:	0f b6 00             	movzbl (%eax),%eax
c01051fc:	3c 5a                	cmp    $0x5a,%al
c01051fe:	7f 32                	jg     c0105232 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105200:	8b 45 08             	mov    0x8(%ebp),%eax
c0105203:	0f b6 00             	movzbl (%eax),%eax
c0105206:	0f be c0             	movsbl %al,%eax
c0105209:	83 e8 37             	sub    $0x37,%eax
c010520c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010520f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105212:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105215:	7d 1a                	jge    c0105231 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c0105217:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010521b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010521e:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105222:	89 c2                	mov    %eax,%edx
c0105224:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105227:	01 d0                	add    %edx,%eax
c0105229:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010522c:	e9 71 ff ff ff       	jmp    c01051a2 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105231:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105232:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105236:	74 08                	je     c0105240 <strtol+0x14b>
        *endptr = (char *) s;
c0105238:	8b 45 0c             	mov    0xc(%ebp),%eax
c010523b:	8b 55 08             	mov    0x8(%ebp),%edx
c010523e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105240:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105244:	74 07                	je     c010524d <strtol+0x158>
c0105246:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105249:	f7 d8                	neg    %eax
c010524b:	eb 03                	jmp    c0105250 <strtol+0x15b>
c010524d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105250:	c9                   	leave  
c0105251:	c3                   	ret    

c0105252 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105252:	55                   	push   %ebp
c0105253:	89 e5                	mov    %esp,%ebp
c0105255:	57                   	push   %edi
c0105256:	83 ec 24             	sub    $0x24,%esp
c0105259:	8b 45 0c             	mov    0xc(%ebp),%eax
c010525c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010525f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105263:	8b 55 08             	mov    0x8(%ebp),%edx
c0105266:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105269:	88 45 f7             	mov    %al,-0x9(%ebp)
c010526c:	8b 45 10             	mov    0x10(%ebp),%eax
c010526f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105272:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105275:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105279:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010527c:	89 d7                	mov    %edx,%edi
c010527e:	f3 aa                	rep stos %al,%es:(%edi)
c0105280:	89 fa                	mov    %edi,%edx
c0105282:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105285:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105288:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010528b:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010528c:	83 c4 24             	add    $0x24,%esp
c010528f:	5f                   	pop    %edi
c0105290:	5d                   	pop    %ebp
c0105291:	c3                   	ret    

c0105292 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105292:	55                   	push   %ebp
c0105293:	89 e5                	mov    %esp,%ebp
c0105295:	57                   	push   %edi
c0105296:	56                   	push   %esi
c0105297:	53                   	push   %ebx
c0105298:	83 ec 30             	sub    $0x30,%esp
c010529b:	8b 45 08             	mov    0x8(%ebp),%eax
c010529e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01052a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01052aa:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01052ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01052b3:	73 42                	jae    c01052f7 <memmove+0x65>
c01052b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052be:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01052c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052ca:	c1 e8 02             	shr    $0x2,%eax
c01052cd:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01052cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052d5:	89 d7                	mov    %edx,%edi
c01052d7:	89 c6                	mov    %eax,%esi
c01052d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01052db:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052de:	83 e1 03             	and    $0x3,%ecx
c01052e1:	74 02                	je     c01052e5 <memmove+0x53>
c01052e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01052e5:	89 f0                	mov    %esi,%eax
c01052e7:	89 fa                	mov    %edi,%edx
c01052e9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01052ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01052ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01052f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01052f5:	eb 36                	jmp    c010532d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01052f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052fa:	8d 50 ff             	lea    -0x1(%eax),%edx
c01052fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105300:	01 c2                	add    %eax,%edx
c0105302:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105305:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105308:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010530b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010530e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105311:	89 c1                	mov    %eax,%ecx
c0105313:	89 d8                	mov    %ebx,%eax
c0105315:	89 d6                	mov    %edx,%esi
c0105317:	89 c7                	mov    %eax,%edi
c0105319:	fd                   	std    
c010531a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010531c:	fc                   	cld    
c010531d:	89 f8                	mov    %edi,%eax
c010531f:	89 f2                	mov    %esi,%edx
c0105321:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105324:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105327:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010532a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010532d:	83 c4 30             	add    $0x30,%esp
c0105330:	5b                   	pop    %ebx
c0105331:	5e                   	pop    %esi
c0105332:	5f                   	pop    %edi
c0105333:	5d                   	pop    %ebp
c0105334:	c3                   	ret    

c0105335 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105335:	55                   	push   %ebp
c0105336:	89 e5                	mov    %esp,%ebp
c0105338:	57                   	push   %edi
c0105339:	56                   	push   %esi
c010533a:	83 ec 20             	sub    $0x20,%esp
c010533d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105340:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105343:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105346:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105349:	8b 45 10             	mov    0x10(%ebp),%eax
c010534c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010534f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105352:	c1 e8 02             	shr    $0x2,%eax
c0105355:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105357:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010535a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010535d:	89 d7                	mov    %edx,%edi
c010535f:	89 c6                	mov    %eax,%esi
c0105361:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105363:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105366:	83 e1 03             	and    $0x3,%ecx
c0105369:	74 02                	je     c010536d <memcpy+0x38>
c010536b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010536d:	89 f0                	mov    %esi,%eax
c010536f:	89 fa                	mov    %edi,%edx
c0105371:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105374:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105377:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010537a:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010537d:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010537e:	83 c4 20             	add    $0x20,%esp
c0105381:	5e                   	pop    %esi
c0105382:	5f                   	pop    %edi
c0105383:	5d                   	pop    %ebp
c0105384:	c3                   	ret    

c0105385 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105385:	55                   	push   %ebp
c0105386:	89 e5                	mov    %esp,%ebp
c0105388:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010538b:	8b 45 08             	mov    0x8(%ebp),%eax
c010538e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105391:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105394:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105397:	eb 30                	jmp    c01053c9 <memcmp+0x44>
        if (*s1 != *s2) {
c0105399:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010539c:	0f b6 10             	movzbl (%eax),%edx
c010539f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01053a2:	0f b6 00             	movzbl (%eax),%eax
c01053a5:	38 c2                	cmp    %al,%dl
c01053a7:	74 18                	je     c01053c1 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01053a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01053ac:	0f b6 00             	movzbl (%eax),%eax
c01053af:	0f b6 d0             	movzbl %al,%edx
c01053b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01053b5:	0f b6 00             	movzbl (%eax),%eax
c01053b8:	0f b6 c0             	movzbl %al,%eax
c01053bb:	29 c2                	sub    %eax,%edx
c01053bd:	89 d0                	mov    %edx,%eax
c01053bf:	eb 1a                	jmp    c01053db <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01053c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01053c5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c01053c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01053cc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01053cf:	89 55 10             	mov    %edx,0x10(%ebp)
c01053d2:	85 c0                	test   %eax,%eax
c01053d4:	75 c3                	jne    c0105399 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01053d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053db:	c9                   	leave  
c01053dc:	c3                   	ret    

c01053dd <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01053dd:	55                   	push   %ebp
c01053de:	89 e5                	mov    %esp,%ebp
c01053e0:	83 ec 38             	sub    $0x38,%esp
c01053e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01053e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01053e9:	8b 45 14             	mov    0x14(%ebp),%eax
c01053ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01053ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01053fb:	8b 45 18             	mov    0x18(%ebp),%eax
c01053fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105401:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105404:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105407:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010540a:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010540d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105410:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105417:	74 1c                	je     c0105435 <printnum+0x58>
c0105419:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010541c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105421:	f7 75 e4             	divl   -0x1c(%ebp)
c0105424:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105427:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010542a:	ba 00 00 00 00       	mov    $0x0,%edx
c010542f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105432:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105435:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105438:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010543b:	f7 75 e4             	divl   -0x1c(%ebp)
c010543e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105441:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105444:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105447:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010544a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010544d:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105450:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105453:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105456:	8b 45 18             	mov    0x18(%ebp),%eax
c0105459:	ba 00 00 00 00       	mov    $0x0,%edx
c010545e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105461:	77 41                	ja     c01054a4 <printnum+0xc7>
c0105463:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105466:	72 05                	jb     c010546d <printnum+0x90>
c0105468:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010546b:	77 37                	ja     c01054a4 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010546d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105470:	83 e8 01             	sub    $0x1,%eax
c0105473:	83 ec 04             	sub    $0x4,%esp
c0105476:	ff 75 20             	pushl  0x20(%ebp)
c0105479:	50                   	push   %eax
c010547a:	ff 75 18             	pushl  0x18(%ebp)
c010547d:	ff 75 ec             	pushl  -0x14(%ebp)
c0105480:	ff 75 e8             	pushl  -0x18(%ebp)
c0105483:	ff 75 0c             	pushl  0xc(%ebp)
c0105486:	ff 75 08             	pushl  0x8(%ebp)
c0105489:	e8 4f ff ff ff       	call   c01053dd <printnum>
c010548e:	83 c4 20             	add    $0x20,%esp
c0105491:	eb 1b                	jmp    c01054ae <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105493:	83 ec 08             	sub    $0x8,%esp
c0105496:	ff 75 0c             	pushl  0xc(%ebp)
c0105499:	ff 75 20             	pushl  0x20(%ebp)
c010549c:	8b 45 08             	mov    0x8(%ebp),%eax
c010549f:	ff d0                	call   *%eax
c01054a1:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01054a4:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01054a8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01054ac:	7f e5                	jg     c0105493 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01054ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054b1:	05 8c 6b 10 c0       	add    $0xc0106b8c,%eax
c01054b6:	0f b6 00             	movzbl (%eax),%eax
c01054b9:	0f be c0             	movsbl %al,%eax
c01054bc:	83 ec 08             	sub    $0x8,%esp
c01054bf:	ff 75 0c             	pushl  0xc(%ebp)
c01054c2:	50                   	push   %eax
c01054c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c6:	ff d0                	call   *%eax
c01054c8:	83 c4 10             	add    $0x10,%esp
}
c01054cb:	90                   	nop
c01054cc:	c9                   	leave  
c01054cd:	c3                   	ret    

c01054ce <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01054ce:	55                   	push   %ebp
c01054cf:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01054d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01054d5:	7e 14                	jle    c01054eb <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01054d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01054da:	8b 00                	mov    (%eax),%eax
c01054dc:	8d 48 08             	lea    0x8(%eax),%ecx
c01054df:	8b 55 08             	mov    0x8(%ebp),%edx
c01054e2:	89 0a                	mov    %ecx,(%edx)
c01054e4:	8b 50 04             	mov    0x4(%eax),%edx
c01054e7:	8b 00                	mov    (%eax),%eax
c01054e9:	eb 30                	jmp    c010551b <getuint+0x4d>
    }
    else if (lflag) {
c01054eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054ef:	74 16                	je     c0105507 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01054f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f4:	8b 00                	mov    (%eax),%eax
c01054f6:	8d 48 04             	lea    0x4(%eax),%ecx
c01054f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01054fc:	89 0a                	mov    %ecx,(%edx)
c01054fe:	8b 00                	mov    (%eax),%eax
c0105500:	ba 00 00 00 00       	mov    $0x0,%edx
c0105505:	eb 14                	jmp    c010551b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105507:	8b 45 08             	mov    0x8(%ebp),%eax
c010550a:	8b 00                	mov    (%eax),%eax
c010550c:	8d 48 04             	lea    0x4(%eax),%ecx
c010550f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105512:	89 0a                	mov    %ecx,(%edx)
c0105514:	8b 00                	mov    (%eax),%eax
c0105516:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010551b:	5d                   	pop    %ebp
c010551c:	c3                   	ret    

c010551d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010551d:	55                   	push   %ebp
c010551e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105520:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105524:	7e 14                	jle    c010553a <getint+0x1d>
        return va_arg(*ap, long long);
c0105526:	8b 45 08             	mov    0x8(%ebp),%eax
c0105529:	8b 00                	mov    (%eax),%eax
c010552b:	8d 48 08             	lea    0x8(%eax),%ecx
c010552e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105531:	89 0a                	mov    %ecx,(%edx)
c0105533:	8b 50 04             	mov    0x4(%eax),%edx
c0105536:	8b 00                	mov    (%eax),%eax
c0105538:	eb 28                	jmp    c0105562 <getint+0x45>
    }
    else if (lflag) {
c010553a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010553e:	74 12                	je     c0105552 <getint+0x35>
        return va_arg(*ap, long);
c0105540:	8b 45 08             	mov    0x8(%ebp),%eax
c0105543:	8b 00                	mov    (%eax),%eax
c0105545:	8d 48 04             	lea    0x4(%eax),%ecx
c0105548:	8b 55 08             	mov    0x8(%ebp),%edx
c010554b:	89 0a                	mov    %ecx,(%edx)
c010554d:	8b 00                	mov    (%eax),%eax
c010554f:	99                   	cltd   
c0105550:	eb 10                	jmp    c0105562 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105552:	8b 45 08             	mov    0x8(%ebp),%eax
c0105555:	8b 00                	mov    (%eax),%eax
c0105557:	8d 48 04             	lea    0x4(%eax),%ecx
c010555a:	8b 55 08             	mov    0x8(%ebp),%edx
c010555d:	89 0a                	mov    %ecx,(%edx)
c010555f:	8b 00                	mov    (%eax),%eax
c0105561:	99                   	cltd   
    }
}
c0105562:	5d                   	pop    %ebp
c0105563:	c3                   	ret    

c0105564 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105564:	55                   	push   %ebp
c0105565:	89 e5                	mov    %esp,%ebp
c0105567:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010556a:	8d 45 14             	lea    0x14(%ebp),%eax
c010556d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105573:	50                   	push   %eax
c0105574:	ff 75 10             	pushl  0x10(%ebp)
c0105577:	ff 75 0c             	pushl  0xc(%ebp)
c010557a:	ff 75 08             	pushl  0x8(%ebp)
c010557d:	e8 06 00 00 00       	call   c0105588 <vprintfmt>
c0105582:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105585:	90                   	nop
c0105586:	c9                   	leave  
c0105587:	c3                   	ret    

c0105588 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105588:	55                   	push   %ebp
c0105589:	89 e5                	mov    %esp,%ebp
c010558b:	56                   	push   %esi
c010558c:	53                   	push   %ebx
c010558d:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105590:	eb 17                	jmp    c01055a9 <vprintfmt+0x21>
            if (ch == '\0') {
c0105592:	85 db                	test   %ebx,%ebx
c0105594:	0f 84 8e 03 00 00    	je     c0105928 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c010559a:	83 ec 08             	sub    $0x8,%esp
c010559d:	ff 75 0c             	pushl  0xc(%ebp)
c01055a0:	53                   	push   %ebx
c01055a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a4:	ff d0                	call   *%eax
c01055a6:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01055ac:	8d 50 01             	lea    0x1(%eax),%edx
c01055af:	89 55 10             	mov    %edx,0x10(%ebp)
c01055b2:	0f b6 00             	movzbl (%eax),%eax
c01055b5:	0f b6 d8             	movzbl %al,%ebx
c01055b8:	83 fb 25             	cmp    $0x25,%ebx
c01055bb:	75 d5                	jne    c0105592 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01055bd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01055c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01055c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01055ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01055d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055d8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01055db:	8b 45 10             	mov    0x10(%ebp),%eax
c01055de:	8d 50 01             	lea    0x1(%eax),%edx
c01055e1:	89 55 10             	mov    %edx,0x10(%ebp)
c01055e4:	0f b6 00             	movzbl (%eax),%eax
c01055e7:	0f b6 d8             	movzbl %al,%ebx
c01055ea:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01055ed:	83 f8 55             	cmp    $0x55,%eax
c01055f0:	0f 87 05 03 00 00    	ja     c01058fb <vprintfmt+0x373>
c01055f6:	8b 04 85 b0 6b 10 c0 	mov    -0x3fef9450(,%eax,4),%eax
c01055fd:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01055ff:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105603:	eb d6                	jmp    c01055db <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105605:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105609:	eb d0                	jmp    c01055db <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010560b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105615:	89 d0                	mov    %edx,%eax
c0105617:	c1 e0 02             	shl    $0x2,%eax
c010561a:	01 d0                	add    %edx,%eax
c010561c:	01 c0                	add    %eax,%eax
c010561e:	01 d8                	add    %ebx,%eax
c0105620:	83 e8 30             	sub    $0x30,%eax
c0105623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105626:	8b 45 10             	mov    0x10(%ebp),%eax
c0105629:	0f b6 00             	movzbl (%eax),%eax
c010562c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010562f:	83 fb 2f             	cmp    $0x2f,%ebx
c0105632:	7e 39                	jle    c010566d <vprintfmt+0xe5>
c0105634:	83 fb 39             	cmp    $0x39,%ebx
c0105637:	7f 34                	jg     c010566d <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105639:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010563d:	eb d3                	jmp    c0105612 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010563f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105642:	8d 50 04             	lea    0x4(%eax),%edx
c0105645:	89 55 14             	mov    %edx,0x14(%ebp)
c0105648:	8b 00                	mov    (%eax),%eax
c010564a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010564d:	eb 1f                	jmp    c010566e <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c010564f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105653:	79 86                	jns    c01055db <vprintfmt+0x53>
                width = 0;
c0105655:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010565c:	e9 7a ff ff ff       	jmp    c01055db <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105661:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105668:	e9 6e ff ff ff       	jmp    c01055db <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c010566d:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c010566e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105672:	0f 89 63 ff ff ff    	jns    c01055db <vprintfmt+0x53>
                width = precision, precision = -1;
c0105678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010567b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010567e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105685:	e9 51 ff ff ff       	jmp    c01055db <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010568a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010568e:	e9 48 ff ff ff       	jmp    c01055db <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105693:	8b 45 14             	mov    0x14(%ebp),%eax
c0105696:	8d 50 04             	lea    0x4(%eax),%edx
c0105699:	89 55 14             	mov    %edx,0x14(%ebp)
c010569c:	8b 00                	mov    (%eax),%eax
c010569e:	83 ec 08             	sub    $0x8,%esp
c01056a1:	ff 75 0c             	pushl  0xc(%ebp)
c01056a4:	50                   	push   %eax
c01056a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a8:	ff d0                	call   *%eax
c01056aa:	83 c4 10             	add    $0x10,%esp
            break;
c01056ad:	e9 71 02 00 00       	jmp    c0105923 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01056b2:	8b 45 14             	mov    0x14(%ebp),%eax
c01056b5:	8d 50 04             	lea    0x4(%eax),%edx
c01056b8:	89 55 14             	mov    %edx,0x14(%ebp)
c01056bb:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01056bd:	85 db                	test   %ebx,%ebx
c01056bf:	79 02                	jns    c01056c3 <vprintfmt+0x13b>
                err = -err;
c01056c1:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01056c3:	83 fb 06             	cmp    $0x6,%ebx
c01056c6:	7f 0b                	jg     c01056d3 <vprintfmt+0x14b>
c01056c8:	8b 34 9d 70 6b 10 c0 	mov    -0x3fef9490(,%ebx,4),%esi
c01056cf:	85 f6                	test   %esi,%esi
c01056d1:	75 19                	jne    c01056ec <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c01056d3:	53                   	push   %ebx
c01056d4:	68 9d 6b 10 c0       	push   $0xc0106b9d
c01056d9:	ff 75 0c             	pushl  0xc(%ebp)
c01056dc:	ff 75 08             	pushl  0x8(%ebp)
c01056df:	e8 80 fe ff ff       	call   c0105564 <printfmt>
c01056e4:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01056e7:	e9 37 02 00 00       	jmp    c0105923 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01056ec:	56                   	push   %esi
c01056ed:	68 a6 6b 10 c0       	push   $0xc0106ba6
c01056f2:	ff 75 0c             	pushl  0xc(%ebp)
c01056f5:	ff 75 08             	pushl  0x8(%ebp)
c01056f8:	e8 67 fe ff ff       	call   c0105564 <printfmt>
c01056fd:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0105700:	e9 1e 02 00 00       	jmp    c0105923 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105705:	8b 45 14             	mov    0x14(%ebp),%eax
c0105708:	8d 50 04             	lea    0x4(%eax),%edx
c010570b:	89 55 14             	mov    %edx,0x14(%ebp)
c010570e:	8b 30                	mov    (%eax),%esi
c0105710:	85 f6                	test   %esi,%esi
c0105712:	75 05                	jne    c0105719 <vprintfmt+0x191>
                p = "(null)";
c0105714:	be a9 6b 10 c0       	mov    $0xc0106ba9,%esi
            }
            if (width > 0 && padc != '-') {
c0105719:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010571d:	7e 76                	jle    c0105795 <vprintfmt+0x20d>
c010571f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105723:	74 70                	je     c0105795 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105728:	83 ec 08             	sub    $0x8,%esp
c010572b:	50                   	push   %eax
c010572c:	56                   	push   %esi
c010572d:	e8 17 f8 ff ff       	call   c0104f49 <strnlen>
c0105732:	83 c4 10             	add    $0x10,%esp
c0105735:	89 c2                	mov    %eax,%edx
c0105737:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010573a:	29 d0                	sub    %edx,%eax
c010573c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010573f:	eb 17                	jmp    c0105758 <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105741:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105745:	83 ec 08             	sub    $0x8,%esp
c0105748:	ff 75 0c             	pushl  0xc(%ebp)
c010574b:	50                   	push   %eax
c010574c:	8b 45 08             	mov    0x8(%ebp),%eax
c010574f:	ff d0                	call   *%eax
c0105751:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105754:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105758:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010575c:	7f e3                	jg     c0105741 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010575e:	eb 35                	jmp    c0105795 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105760:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105764:	74 1c                	je     c0105782 <vprintfmt+0x1fa>
c0105766:	83 fb 1f             	cmp    $0x1f,%ebx
c0105769:	7e 05                	jle    c0105770 <vprintfmt+0x1e8>
c010576b:	83 fb 7e             	cmp    $0x7e,%ebx
c010576e:	7e 12                	jle    c0105782 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0105770:	83 ec 08             	sub    $0x8,%esp
c0105773:	ff 75 0c             	pushl  0xc(%ebp)
c0105776:	6a 3f                	push   $0x3f
c0105778:	8b 45 08             	mov    0x8(%ebp),%eax
c010577b:	ff d0                	call   *%eax
c010577d:	83 c4 10             	add    $0x10,%esp
c0105780:	eb 0f                	jmp    c0105791 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0105782:	83 ec 08             	sub    $0x8,%esp
c0105785:	ff 75 0c             	pushl  0xc(%ebp)
c0105788:	53                   	push   %ebx
c0105789:	8b 45 08             	mov    0x8(%ebp),%eax
c010578c:	ff d0                	call   *%eax
c010578e:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105791:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105795:	89 f0                	mov    %esi,%eax
c0105797:	8d 70 01             	lea    0x1(%eax),%esi
c010579a:	0f b6 00             	movzbl (%eax),%eax
c010579d:	0f be d8             	movsbl %al,%ebx
c01057a0:	85 db                	test   %ebx,%ebx
c01057a2:	74 26                	je     c01057ca <vprintfmt+0x242>
c01057a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01057a8:	78 b6                	js     c0105760 <vprintfmt+0x1d8>
c01057aa:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01057ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01057b2:	79 ac                	jns    c0105760 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01057b4:	eb 14                	jmp    c01057ca <vprintfmt+0x242>
                putch(' ', putdat);
c01057b6:	83 ec 08             	sub    $0x8,%esp
c01057b9:	ff 75 0c             	pushl  0xc(%ebp)
c01057bc:	6a 20                	push   $0x20
c01057be:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c1:	ff d0                	call   *%eax
c01057c3:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01057c6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057ce:	7f e6                	jg     c01057b6 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c01057d0:	e9 4e 01 00 00       	jmp    c0105923 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01057d5:	83 ec 08             	sub    $0x8,%esp
c01057d8:	ff 75 e0             	pushl  -0x20(%ebp)
c01057db:	8d 45 14             	lea    0x14(%ebp),%eax
c01057de:	50                   	push   %eax
c01057df:	e8 39 fd ff ff       	call   c010551d <getint>
c01057e4:	83 c4 10             	add    $0x10,%esp
c01057e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01057ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057f3:	85 d2                	test   %edx,%edx
c01057f5:	79 23                	jns    c010581a <vprintfmt+0x292>
                putch('-', putdat);
c01057f7:	83 ec 08             	sub    $0x8,%esp
c01057fa:	ff 75 0c             	pushl  0xc(%ebp)
c01057fd:	6a 2d                	push   $0x2d
c01057ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105802:	ff d0                	call   *%eax
c0105804:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105807:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010580a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010580d:	f7 d8                	neg    %eax
c010580f:	83 d2 00             	adc    $0x0,%edx
c0105812:	f7 da                	neg    %edx
c0105814:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105817:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010581a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105821:	e9 9f 00 00 00       	jmp    c01058c5 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105826:	83 ec 08             	sub    $0x8,%esp
c0105829:	ff 75 e0             	pushl  -0x20(%ebp)
c010582c:	8d 45 14             	lea    0x14(%ebp),%eax
c010582f:	50                   	push   %eax
c0105830:	e8 99 fc ff ff       	call   c01054ce <getuint>
c0105835:	83 c4 10             	add    $0x10,%esp
c0105838:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010583b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010583e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105845:	eb 7e                	jmp    c01058c5 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105847:	83 ec 08             	sub    $0x8,%esp
c010584a:	ff 75 e0             	pushl  -0x20(%ebp)
c010584d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105850:	50                   	push   %eax
c0105851:	e8 78 fc ff ff       	call   c01054ce <getuint>
c0105856:	83 c4 10             	add    $0x10,%esp
c0105859:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010585c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010585f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105866:	eb 5d                	jmp    c01058c5 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0105868:	83 ec 08             	sub    $0x8,%esp
c010586b:	ff 75 0c             	pushl  0xc(%ebp)
c010586e:	6a 30                	push   $0x30
c0105870:	8b 45 08             	mov    0x8(%ebp),%eax
c0105873:	ff d0                	call   *%eax
c0105875:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105878:	83 ec 08             	sub    $0x8,%esp
c010587b:	ff 75 0c             	pushl  0xc(%ebp)
c010587e:	6a 78                	push   $0x78
c0105880:	8b 45 08             	mov    0x8(%ebp),%eax
c0105883:	ff d0                	call   *%eax
c0105885:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105888:	8b 45 14             	mov    0x14(%ebp),%eax
c010588b:	8d 50 04             	lea    0x4(%eax),%edx
c010588e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105891:	8b 00                	mov    (%eax),%eax
c0105893:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010589d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01058a4:	eb 1f                	jmp    c01058c5 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01058a6:	83 ec 08             	sub    $0x8,%esp
c01058a9:	ff 75 e0             	pushl  -0x20(%ebp)
c01058ac:	8d 45 14             	lea    0x14(%ebp),%eax
c01058af:	50                   	push   %eax
c01058b0:	e8 19 fc ff ff       	call   c01054ce <getuint>
c01058b5:	83 c4 10             	add    $0x10,%esp
c01058b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01058be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01058c5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01058c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058cc:	83 ec 04             	sub    $0x4,%esp
c01058cf:	52                   	push   %edx
c01058d0:	ff 75 e8             	pushl  -0x18(%ebp)
c01058d3:	50                   	push   %eax
c01058d4:	ff 75 f4             	pushl  -0xc(%ebp)
c01058d7:	ff 75 f0             	pushl  -0x10(%ebp)
c01058da:	ff 75 0c             	pushl  0xc(%ebp)
c01058dd:	ff 75 08             	pushl  0x8(%ebp)
c01058e0:	e8 f8 fa ff ff       	call   c01053dd <printnum>
c01058e5:	83 c4 20             	add    $0x20,%esp
            break;
c01058e8:	eb 39                	jmp    c0105923 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01058ea:	83 ec 08             	sub    $0x8,%esp
c01058ed:	ff 75 0c             	pushl  0xc(%ebp)
c01058f0:	53                   	push   %ebx
c01058f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f4:	ff d0                	call   *%eax
c01058f6:	83 c4 10             	add    $0x10,%esp
            break;
c01058f9:	eb 28                	jmp    c0105923 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01058fb:	83 ec 08             	sub    $0x8,%esp
c01058fe:	ff 75 0c             	pushl  0xc(%ebp)
c0105901:	6a 25                	push   $0x25
c0105903:	8b 45 08             	mov    0x8(%ebp),%eax
c0105906:	ff d0                	call   *%eax
c0105908:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c010590b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010590f:	eb 04                	jmp    c0105915 <vprintfmt+0x38d>
c0105911:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105915:	8b 45 10             	mov    0x10(%ebp),%eax
c0105918:	83 e8 01             	sub    $0x1,%eax
c010591b:	0f b6 00             	movzbl (%eax),%eax
c010591e:	3c 25                	cmp    $0x25,%al
c0105920:	75 ef                	jne    c0105911 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105922:	90                   	nop
        }
    }
c0105923:	e9 68 fc ff ff       	jmp    c0105590 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0105928:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105929:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010592c:	5b                   	pop    %ebx
c010592d:	5e                   	pop    %esi
c010592e:	5d                   	pop    %ebp
c010592f:	c3                   	ret    

c0105930 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105930:	55                   	push   %ebp
c0105931:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105933:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105936:	8b 40 08             	mov    0x8(%eax),%eax
c0105939:	8d 50 01             	lea    0x1(%eax),%edx
c010593c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010593f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105945:	8b 10                	mov    (%eax),%edx
c0105947:	8b 45 0c             	mov    0xc(%ebp),%eax
c010594a:	8b 40 04             	mov    0x4(%eax),%eax
c010594d:	39 c2                	cmp    %eax,%edx
c010594f:	73 12                	jae    c0105963 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105951:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105954:	8b 00                	mov    (%eax),%eax
c0105956:	8d 48 01             	lea    0x1(%eax),%ecx
c0105959:	8b 55 0c             	mov    0xc(%ebp),%edx
c010595c:	89 0a                	mov    %ecx,(%edx)
c010595e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105961:	88 10                	mov    %dl,(%eax)
    }
}
c0105963:	90                   	nop
c0105964:	5d                   	pop    %ebp
c0105965:	c3                   	ret    

c0105966 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105966:	55                   	push   %ebp
c0105967:	89 e5                	mov    %esp,%ebp
c0105969:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010596c:	8d 45 14             	lea    0x14(%ebp),%eax
c010596f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105972:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105975:	50                   	push   %eax
c0105976:	ff 75 10             	pushl  0x10(%ebp)
c0105979:	ff 75 0c             	pushl  0xc(%ebp)
c010597c:	ff 75 08             	pushl  0x8(%ebp)
c010597f:	e8 0b 00 00 00       	call   c010598f <vsnprintf>
c0105984:	83 c4 10             	add    $0x10,%esp
c0105987:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010598a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010598d:	c9                   	leave  
c010598e:	c3                   	ret    

c010598f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010598f:	55                   	push   %ebp
c0105990:	89 e5                	mov    %esp,%ebp
c0105992:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105995:	8b 45 08             	mov    0x8(%ebp),%eax
c0105998:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010599b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010599e:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a4:	01 d0                	add    %edx,%eax
c01059a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01059b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01059b4:	74 0a                	je     c01059c0 <vsnprintf+0x31>
c01059b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01059b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059bc:	39 c2                	cmp    %eax,%edx
c01059be:	76 07                	jbe    c01059c7 <vsnprintf+0x38>
        return -E_INVAL;
c01059c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01059c5:	eb 20                	jmp    c01059e7 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01059c7:	ff 75 14             	pushl  0x14(%ebp)
c01059ca:	ff 75 10             	pushl  0x10(%ebp)
c01059cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01059d0:	50                   	push   %eax
c01059d1:	68 30 59 10 c0       	push   $0xc0105930
c01059d6:	e8 ad fb ff ff       	call   c0105588 <vprintfmt>
c01059db:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c01059de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059e1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01059e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059e7:	c9                   	leave  
c01059e8:	c3                   	ret    
