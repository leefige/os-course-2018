
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
c0100049:	e8 4b 54 00 00       	call   c0105499 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 6a 15 00 00       	call   c01015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 40 5c 10 c0 	movl   $0xc0105c40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 5c 5c 10 c0       	push   $0xc0105c5c
c0100068:	e8 02 02 00 00       	call   c010026f <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 84 08 00 00       	call   c01008f9 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 d3 31 00 00       	call   c0103252 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 ae 16 00 00       	call   c0101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 30 18 00 00       	call   c01018b9 <idt_init>

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
c0100137:	68 61 5c 10 c0       	push   $0xc0105c61
c010013c:	e8 2e 01 00 00       	call   c010026f <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 6f 5c 10 c0       	push   $0xc0105c6f
c010015a:	e8 10 01 00 00       	call   c010026f <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 7d 5c 10 c0       	push   $0xc0105c7d
c0100178:	e8 f2 00 00 00       	call   c010026f <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 8b 5c 10 c0       	push   $0xc0105c8b
c0100196:	e8 d4 00 00 00       	call   c010026f <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 99 5c 10 c0       	push   $0xc0105c99
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
c01001ee:	68 a8 5c 10 c0       	push   $0xc0105ca8
c01001f3:	e8 77 00 00 00       	call   c010026f <cprintf>
c01001f8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001fb:	e8 cc ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100200:	e8 0a ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100205:	83 ec 0c             	sub    $0xc,%esp
c0100208:	68 c8 5c 10 c0       	push   $0xc0105cc8
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
c0100262:	e8 68 55 00 00       	call   c01057cf <vprintfmt>
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
c0100325:	68 e7 5c 10 c0       	push   $0xc0105ce7
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
c01003fd:	68 ea 5c 10 c0       	push   $0xc0105cea
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
c010041f:	68 06 5d 10 c0       	push   $0xc0105d06
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
c0100458:	68 08 5d 10 c0       	push   $0xc0105d08
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
c010047a:	68 06 5d 10 c0       	push   $0xc0105d06
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
c01005f4:	c7 00 28 5d 10 c0    	movl   $0xc0105d28,(%eax)
    info->eip_line = 0;
c01005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100604:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100607:	c7 40 08 28 5d 10 c0 	movl   $0xc0105d28,0x8(%eax)
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
c010062b:	c7 45 f4 68 6f 10 c0 	movl   $0xc0106f68,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100632:	c7 45 f0 68 20 11 c0 	movl   $0xc0112068,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100639:	c7 45 ec 69 20 11 c0 	movl   $0xc0112069,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100640:	c7 45 e8 9b 4b 11 c0 	movl   $0xc0114b9b,-0x18(%ebp)

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
c010077a:	e8 8e 4b 00 00       	call   c010530d <strfind>
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
c0100902:	68 32 5d 10 c0       	push   $0xc0105d32
c0100907:	e8 63 f9 ff ff       	call   c010026f <cprintf>
c010090c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010090f:	83 ec 08             	sub    $0x8,%esp
c0100912:	68 2a 00 10 c0       	push   $0xc010002a
c0100917:	68 4b 5d 10 c0       	push   $0xc0105d4b
c010091c:	e8 4e f9 ff ff       	call   c010026f <cprintf>
c0100921:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100924:	83 ec 08             	sub    $0x8,%esp
c0100927:	68 30 5c 10 c0       	push   $0xc0105c30
c010092c:	68 63 5d 10 c0       	push   $0xc0105d63
c0100931:	e8 39 f9 ff ff       	call   c010026f <cprintf>
c0100936:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100939:	83 ec 08             	sub    $0x8,%esp
c010093c:	68 36 7a 11 c0       	push   $0xc0117a36
c0100941:	68 7b 5d 10 c0       	push   $0xc0105d7b
c0100946:	e8 24 f9 ff ff       	call   c010026f <cprintf>
c010094b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010094e:	83 ec 08             	sub    $0x8,%esp
c0100951:	68 c8 89 11 c0       	push   $0xc01189c8
c0100956:	68 93 5d 10 c0       	push   $0xc0105d93
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
c0100986:	68 ac 5d 10 c0       	push   $0xc0105dac
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
c01009bb:	68 d6 5d 10 c0       	push   $0xc0105dd6
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
c0100a22:	68 f2 5d 10 c0       	push   $0xc0105df2
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
c0100a72:	68 04 5e 10 c0       	push   $0xc0105e04
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
c0100ac0:	68 1c 5e 10 c0       	push   $0xc0105e1c
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
c0100b41:	68 c0 5e 10 c0       	push   $0xc0105ec0
c0100b46:	e8 8f 47 00 00       	call   c01052da <strchr>
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
c0100b67:	68 c5 5e 10 c0       	push   $0xc0105ec5
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
c0100baf:	68 c0 5e 10 c0       	push   $0xc0105ec0
c0100bb4:	e8 21 47 00 00       	call   c01052da <strchr>
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
c0100c1a:	e8 1b 46 00 00       	call   c010523a <strcmp>
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
c0100c67:	68 e3 5e 10 c0       	push   $0xc0105ee3
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
c0100c84:	68 fc 5e 10 c0       	push   $0xc0105efc
c0100c89:	e8 e1 f5 ff ff       	call   c010026f <cprintf>
c0100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c91:	83 ec 0c             	sub    $0xc,%esp
c0100c94:	68 24 5f 10 c0       	push   $0xc0105f24
c0100c99:	e8 d1 f5 ff ff       	call   c010026f <cprintf>
c0100c9e:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ca5:	74 0e                	je     c0100cb5 <kmonitor+0x3a>
        print_trapframe(tf);
c0100ca7:	83 ec 0c             	sub    $0xc,%esp
c0100caa:	ff 75 08             	pushl  0x8(%ebp)
c0100cad:	e8 bf 0d 00 00       	call   c0101a71 <print_trapframe>
c0100cb2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cb5:	83 ec 0c             	sub    $0xc,%esp
c0100cb8:	68 49 5f 10 c0       	push   $0xc0105f49
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
c0100d23:	68 4d 5f 10 c0       	push   $0xc0105f4d
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
c0100db3:	68 56 5f 10 c0       	push   $0xc0105f56
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
c01011dc:	e8 f8 42 00 00       	call   c01054d9 <memmove>
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
c0101567:	68 71 5f 10 c0       	push   $0xc0105f71
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
c01015e1:	68 7d 5f 10 c0       	push   $0xc0105f7d
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
c0101888:	68 a0 5f 10 c0       	push   $0xc0105fa0
c010188d:	e8 dd e9 ff ff       	call   c010026f <cprintf>
c0101892:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101895:	83 ec 0c             	sub    $0xc,%esp
c0101898:	68 aa 5f 10 c0       	push   $0xc0105faa
c010189d:	e8 cd e9 ff ff       	call   c010026f <cprintf>
c01018a2:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01018a5:	83 ec 04             	sub    $0x4,%esp
c01018a8:	68 b8 5f 10 c0       	push   $0xc0105fb8
c01018ad:	6a 12                	push   $0x12
c01018af:	68 ce 5f 10 c0       	push   $0xc0105fce
c01018b4:	e8 1c eb ff ff       	call   c01003d5 <__panic>

c01018b9 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018b9:	55                   	push   %ebp
c01018ba:	89 e5                	mov    %esp,%ebp
c01018bc:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c01018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018c6:	e9 c3 00 00 00       	jmp    c010198e <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ce:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018d5:	89 c2                	mov    %eax,%edx
c01018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018da:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018e1:	c0 
c01018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e5:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018ec:	c0 08 00 
c01018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f2:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f9:	c0 
c01018fa:	83 e2 e0             	and    $0xffffffe0,%edx
c01018fd:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c010190e:	c0 
c010190f:	83 e2 1f             	and    $0x1f,%edx
c0101912:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101923:	c0 
c0101924:	83 e2 f0             	and    $0xfffffff0,%edx
c0101927:	83 ca 0e             	or     $0xe,%edx
c010192a:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101934:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010193b:	c0 
c010193c:	83 e2 ef             	and    $0xffffffef,%edx
c010193f:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101949:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101950:	c0 
c0101951:	83 e2 9f             	and    $0xffffff9f,%edx
c0101954:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101965:	c0 
c0101966:	83 ca 80             	or     $0xffffff80,%edx
c0101969:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101973:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010197a:	c1 e8 10             	shr    $0x10,%eax
c010197d:	89 c2                	mov    %eax,%edx
c010197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101982:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101989:	c0 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
c010198a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010198e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101995:	0f 8e 30 ff ff ff    	jle    c01018cb <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010199b:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019a0:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c01019a6:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c01019ad:	08 00 
c01019af:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019b6:	83 e0 e0             	and    $0xffffffe0,%eax
c01019b9:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019be:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019c5:	83 e0 1f             	and    $0x1f,%eax
c01019c8:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019cd:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d4:	83 e0 f0             	and    $0xfffffff0,%eax
c01019d7:	83 c8 0e             	or     $0xe,%eax
c01019da:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019df:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019e6:	83 e0 ef             	and    $0xffffffef,%eax
c01019e9:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019ee:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019f5:	83 c8 60             	or     $0x60,%eax
c01019f8:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019fd:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a04:	83 c8 80             	or     $0xffffff80,%eax
c0101a07:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a0c:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101a11:	c1 e8 10             	shr    $0x10,%eax
c0101a14:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101a1a:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a21:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a24:	0f 01 18             	lidtl  (%eax)

    // 3. LIDT
    lidt(&idt_pd);
}
c0101a27:	90                   	nop
c0101a28:	c9                   	leave  
c0101a29:	c3                   	ret    

c0101a2a <trapname>:

static const char *
trapname(int trapno) {
c0101a2a:	55                   	push   %ebp
c0101a2b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a30:	83 f8 13             	cmp    $0x13,%eax
c0101a33:	77 0c                	ja     c0101a41 <trapname+0x17>
        return excnames[trapno];
c0101a35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a38:	8b 04 85 20 63 10 c0 	mov    -0x3fef9ce0(,%eax,4),%eax
c0101a3f:	eb 18                	jmp    c0101a59 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a41:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a45:	7e 0d                	jle    c0101a54 <trapname+0x2a>
c0101a47:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a4b:	7f 07                	jg     c0101a54 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a4d:	b8 df 5f 10 c0       	mov    $0xc0105fdf,%eax
c0101a52:	eb 05                	jmp    c0101a59 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a54:	b8 f2 5f 10 c0       	mov    $0xc0105ff2,%eax
}
c0101a59:	5d                   	pop    %ebp
c0101a5a:	c3                   	ret    

c0101a5b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a5b:	55                   	push   %ebp
c0101a5c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a61:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a65:	66 83 f8 08          	cmp    $0x8,%ax
c0101a69:	0f 94 c0             	sete   %al
c0101a6c:	0f b6 c0             	movzbl %al,%eax
}
c0101a6f:	5d                   	pop    %ebp
c0101a70:	c3                   	ret    

c0101a71 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a71:	55                   	push   %ebp
c0101a72:	89 e5                	mov    %esp,%ebp
c0101a74:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a77:	83 ec 08             	sub    $0x8,%esp
c0101a7a:	ff 75 08             	pushl  0x8(%ebp)
c0101a7d:	68 33 60 10 c0       	push   $0xc0106033
c0101a82:	e8 e8 e7 ff ff       	call   c010026f <cprintf>
c0101a87:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8d:	83 ec 0c             	sub    $0xc,%esp
c0101a90:	50                   	push   %eax
c0101a91:	e8 b8 01 00 00       	call   c0101c4e <print_regs>
c0101a96:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101aa0:	0f b7 c0             	movzwl %ax,%eax
c0101aa3:	83 ec 08             	sub    $0x8,%esp
c0101aa6:	50                   	push   %eax
c0101aa7:	68 44 60 10 c0       	push   $0xc0106044
c0101aac:	e8 be e7 ff ff       	call   c010026f <cprintf>
c0101ab1:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101abb:	0f b7 c0             	movzwl %ax,%eax
c0101abe:	83 ec 08             	sub    $0x8,%esp
c0101ac1:	50                   	push   %eax
c0101ac2:	68 57 60 10 c0       	push   $0xc0106057
c0101ac7:	e8 a3 e7 ff ff       	call   c010026f <cprintf>
c0101acc:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ad6:	0f b7 c0             	movzwl %ax,%eax
c0101ad9:	83 ec 08             	sub    $0x8,%esp
c0101adc:	50                   	push   %eax
c0101add:	68 6a 60 10 c0       	push   $0xc010606a
c0101ae2:	e8 88 e7 ff ff       	call   c010026f <cprintf>
c0101ae7:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aed:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101af1:	0f b7 c0             	movzwl %ax,%eax
c0101af4:	83 ec 08             	sub    $0x8,%esp
c0101af7:	50                   	push   %eax
c0101af8:	68 7d 60 10 c0       	push   $0xc010607d
c0101afd:	e8 6d e7 ff ff       	call   c010026f <cprintf>
c0101b02:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b08:	8b 40 30             	mov    0x30(%eax),%eax
c0101b0b:	83 ec 0c             	sub    $0xc,%esp
c0101b0e:	50                   	push   %eax
c0101b0f:	e8 16 ff ff ff       	call   c0101a2a <trapname>
c0101b14:	83 c4 10             	add    $0x10,%esp
c0101b17:	89 c2                	mov    %eax,%edx
c0101b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1c:	8b 40 30             	mov    0x30(%eax),%eax
c0101b1f:	83 ec 04             	sub    $0x4,%esp
c0101b22:	52                   	push   %edx
c0101b23:	50                   	push   %eax
c0101b24:	68 90 60 10 c0       	push   $0xc0106090
c0101b29:	e8 41 e7 ff ff       	call   c010026f <cprintf>
c0101b2e:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b34:	8b 40 34             	mov    0x34(%eax),%eax
c0101b37:	83 ec 08             	sub    $0x8,%esp
c0101b3a:	50                   	push   %eax
c0101b3b:	68 a2 60 10 c0       	push   $0xc01060a2
c0101b40:	e8 2a e7 ff ff       	call   c010026f <cprintf>
c0101b45:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4b:	8b 40 38             	mov    0x38(%eax),%eax
c0101b4e:	83 ec 08             	sub    $0x8,%esp
c0101b51:	50                   	push   %eax
c0101b52:	68 b1 60 10 c0       	push   $0xc01060b1
c0101b57:	e8 13 e7 ff ff       	call   c010026f <cprintf>
c0101b5c:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b62:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b66:	0f b7 c0             	movzwl %ax,%eax
c0101b69:	83 ec 08             	sub    $0x8,%esp
c0101b6c:	50                   	push   %eax
c0101b6d:	68 c0 60 10 c0       	push   $0xc01060c0
c0101b72:	e8 f8 e6 ff ff       	call   c010026f <cprintf>
c0101b77:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7d:	8b 40 40             	mov    0x40(%eax),%eax
c0101b80:	83 ec 08             	sub    $0x8,%esp
c0101b83:	50                   	push   %eax
c0101b84:	68 d3 60 10 c0       	push   $0xc01060d3
c0101b89:	e8 e1 e6 ff ff       	call   c010026f <cprintf>
c0101b8e:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b98:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b9f:	eb 3f                	jmp    c0101be0 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba4:	8b 50 40             	mov    0x40(%eax),%edx
c0101ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101baa:	21 d0                	and    %edx,%eax
c0101bac:	85 c0                	test   %eax,%eax
c0101bae:	74 29                	je     c0101bd9 <print_trapframe+0x168>
c0101bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb3:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bba:	85 c0                	test   %eax,%eax
c0101bbc:	74 1b                	je     c0101bd9 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc1:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bc8:	83 ec 08             	sub    $0x8,%esp
c0101bcb:	50                   	push   %eax
c0101bcc:	68 e2 60 10 c0       	push   $0xc01060e2
c0101bd1:	e8 99 e6 ff ff       	call   c010026f <cprintf>
c0101bd6:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bdd:	d1 65 f0             	shll   -0x10(%ebp)
c0101be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101be3:	83 f8 17             	cmp    $0x17,%eax
c0101be6:	76 b9                	jbe    c0101ba1 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101beb:	8b 40 40             	mov    0x40(%eax),%eax
c0101bee:	25 00 30 00 00       	and    $0x3000,%eax
c0101bf3:	c1 e8 0c             	shr    $0xc,%eax
c0101bf6:	83 ec 08             	sub    $0x8,%esp
c0101bf9:	50                   	push   %eax
c0101bfa:	68 e6 60 10 c0       	push   $0xc01060e6
c0101bff:	e8 6b e6 ff ff       	call   c010026f <cprintf>
c0101c04:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101c07:	83 ec 0c             	sub    $0xc,%esp
c0101c0a:	ff 75 08             	pushl  0x8(%ebp)
c0101c0d:	e8 49 fe ff ff       	call   c0101a5b <trap_in_kernel>
c0101c12:	83 c4 10             	add    $0x10,%esp
c0101c15:	85 c0                	test   %eax,%eax
c0101c17:	75 32                	jne    c0101c4b <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1c:	8b 40 44             	mov    0x44(%eax),%eax
c0101c1f:	83 ec 08             	sub    $0x8,%esp
c0101c22:	50                   	push   %eax
c0101c23:	68 ef 60 10 c0       	push   $0xc01060ef
c0101c28:	e8 42 e6 ff ff       	call   c010026f <cprintf>
c0101c2d:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c33:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c37:	0f b7 c0             	movzwl %ax,%eax
c0101c3a:	83 ec 08             	sub    $0x8,%esp
c0101c3d:	50                   	push   %eax
c0101c3e:	68 fe 60 10 c0       	push   $0xc01060fe
c0101c43:	e8 27 e6 ff ff       	call   c010026f <cprintf>
c0101c48:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c4b:	90                   	nop
c0101c4c:	c9                   	leave  
c0101c4d:	c3                   	ret    

c0101c4e <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c4e:	55                   	push   %ebp
c0101c4f:	89 e5                	mov    %esp,%ebp
c0101c51:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c57:	8b 00                	mov    (%eax),%eax
c0101c59:	83 ec 08             	sub    $0x8,%esp
c0101c5c:	50                   	push   %eax
c0101c5d:	68 11 61 10 c0       	push   $0xc0106111
c0101c62:	e8 08 e6 ff ff       	call   c010026f <cprintf>
c0101c67:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6d:	8b 40 04             	mov    0x4(%eax),%eax
c0101c70:	83 ec 08             	sub    $0x8,%esp
c0101c73:	50                   	push   %eax
c0101c74:	68 20 61 10 c0       	push   $0xc0106120
c0101c79:	e8 f1 e5 ff ff       	call   c010026f <cprintf>
c0101c7e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c84:	8b 40 08             	mov    0x8(%eax),%eax
c0101c87:	83 ec 08             	sub    $0x8,%esp
c0101c8a:	50                   	push   %eax
c0101c8b:	68 2f 61 10 c0       	push   $0xc010612f
c0101c90:	e8 da e5 ff ff       	call   c010026f <cprintf>
c0101c95:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9b:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c9e:	83 ec 08             	sub    $0x8,%esp
c0101ca1:	50                   	push   %eax
c0101ca2:	68 3e 61 10 c0       	push   $0xc010613e
c0101ca7:	e8 c3 e5 ff ff       	call   c010026f <cprintf>
c0101cac:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb2:	8b 40 10             	mov    0x10(%eax),%eax
c0101cb5:	83 ec 08             	sub    $0x8,%esp
c0101cb8:	50                   	push   %eax
c0101cb9:	68 4d 61 10 c0       	push   $0xc010614d
c0101cbe:	e8 ac e5 ff ff       	call   c010026f <cprintf>
c0101cc3:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc9:	8b 40 14             	mov    0x14(%eax),%eax
c0101ccc:	83 ec 08             	sub    $0x8,%esp
c0101ccf:	50                   	push   %eax
c0101cd0:	68 5c 61 10 c0       	push   $0xc010615c
c0101cd5:	e8 95 e5 ff ff       	call   c010026f <cprintf>
c0101cda:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce0:	8b 40 18             	mov    0x18(%eax),%eax
c0101ce3:	83 ec 08             	sub    $0x8,%esp
c0101ce6:	50                   	push   %eax
c0101ce7:	68 6b 61 10 c0       	push   $0xc010616b
c0101cec:	e8 7e e5 ff ff       	call   c010026f <cprintf>
c0101cf1:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf7:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cfa:	83 ec 08             	sub    $0x8,%esp
c0101cfd:	50                   	push   %eax
c0101cfe:	68 7a 61 10 c0       	push   $0xc010617a
c0101d03:	e8 67 e5 ff ff       	call   c010026f <cprintf>
c0101d08:	83 c4 10             	add    $0x10,%esp
}
c0101d0b:	90                   	nop
c0101d0c:	c9                   	leave  
c0101d0d:	c3                   	ret    

c0101d0e <trap_dispatch>:
/* LAB1: temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d0e:	55                   	push   %ebp
c0101d0f:	89 e5                	mov    %esp,%ebp
c0101d11:	57                   	push   %edi
c0101d12:	56                   	push   %esi
c0101d13:	53                   	push   %ebx
c0101d14:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1a:	8b 40 30             	mov    0x30(%eax),%eax
c0101d1d:	83 f8 2f             	cmp    $0x2f,%eax
c0101d20:	77 21                	ja     c0101d43 <trap_dispatch+0x35>
c0101d22:	83 f8 2e             	cmp    $0x2e,%eax
c0101d25:	0f 83 90 01 00 00    	jae    c0101ebb <trap_dispatch+0x1ad>
c0101d2b:	83 f8 21             	cmp    $0x21,%eax
c0101d2e:	0f 84 87 00 00 00    	je     c0101dbb <trap_dispatch+0xad>
c0101d34:	83 f8 24             	cmp    $0x24,%eax
c0101d37:	74 5b                	je     c0101d94 <trap_dispatch+0x86>
c0101d39:	83 f8 20             	cmp    $0x20,%eax
c0101d3c:	74 1c                	je     c0101d5a <trap_dispatch+0x4c>
c0101d3e:	e9 42 01 00 00       	jmp    c0101e85 <trap_dispatch+0x177>
c0101d43:	83 f8 78             	cmp    $0x78,%eax
c0101d46:	0f 84 96 00 00 00    	je     c0101de2 <trap_dispatch+0xd4>
c0101d4c:	83 f8 79             	cmp    $0x79,%eax
c0101d4f:	0f 84 02 01 00 00    	je     c0101e57 <trap_dispatch+0x149>
c0101d55:	e9 2b 01 00 00       	jmp    c0101e85 <trap_dispatch+0x177>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
c0101d5a:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d5f:	83 c0 01             	add    $0x1,%eax
c0101d62:	a3 4c 89 11 c0       	mov    %eax,0xc011894c

        // 2. print
        if (ticks % TICK_NUM == 0) {
c0101d67:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d6d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d72:	89 c8                	mov    %ecx,%eax
c0101d74:	f7 e2                	mul    %edx
c0101d76:	89 d0                	mov    %edx,%eax
c0101d78:	c1 e8 05             	shr    $0x5,%eax
c0101d7b:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d7e:	29 c1                	sub    %eax,%ecx
c0101d80:	89 c8                	mov    %ecx,%eax
c0101d82:	85 c0                	test   %eax,%eax
c0101d84:	0f 85 34 01 00 00    	jne    c0101ebe <trap_dispatch+0x1b0>
            print_ticks();
c0101d8a:	e8 ee fa ff ff       	call   c010187d <print_ticks>
        }

        // 3. too simple ?!
        break;
c0101d8f:	e9 2a 01 00 00       	jmp    c0101ebe <trap_dispatch+0x1b0>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d94:	e8 a1 f8 ff ff       	call   c010163a <cons_getc>
c0101d99:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d9c:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101da0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101da4:	83 ec 04             	sub    $0x4,%esp
c0101da7:	52                   	push   %edx
c0101da8:	50                   	push   %eax
c0101da9:	68 89 61 10 c0       	push   $0xc0106189
c0101dae:	e8 bc e4 ff ff       	call   c010026f <cprintf>
c0101db3:	83 c4 10             	add    $0x10,%esp
        break;
c0101db6:	e9 04 01 00 00       	jmp    c0101ebf <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dbb:	e8 7a f8 ff ff       	call   c010163a <cons_getc>
c0101dc0:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dc3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101dc7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dcb:	83 ec 04             	sub    $0x4,%esp
c0101dce:	52                   	push   %edx
c0101dcf:	50                   	push   %eax
c0101dd0:	68 9b 61 10 c0       	push   $0xc010619b
c0101dd5:	e8 95 e4 ff ff       	call   c010026f <cprintf>
c0101dda:	83 c4 10             	add    $0x10,%esp
        break;
c0101ddd:	e9 dd 00 00 00       	jmp    c0101ebf <trap_dispatch+0x1b1>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
c0101de2:	8b 55 08             	mov    0x8(%ebp),%edx
c0101de5:	b8 60 89 11 c0       	mov    $0xc0118960,%eax
c0101dea:	89 d3                	mov    %edx,%ebx
c0101dec:	ba 4c 00 00 00       	mov    $0x4c,%edx
c0101df1:	8b 0b                	mov    (%ebx),%ecx
c0101df3:	89 08                	mov    %ecx,(%eax)
c0101df5:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
c0101df9:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
c0101dfd:	8d 78 04             	lea    0x4(%eax),%edi
c0101e00:	83 e7 fc             	and    $0xfffffffc,%edi
c0101e03:	29 f8                	sub    %edi,%eax
c0101e05:	29 c3                	sub    %eax,%ebx
c0101e07:	01 c2                	add    %eax,%edx
c0101e09:	83 e2 fc             	and    $0xfffffffc,%edx
c0101e0c:	89 d0                	mov    %edx,%eax
c0101e0e:	c1 e8 02             	shr    $0x2,%eax
c0101e11:	89 de                	mov    %ebx,%esi
c0101e13:	89 c1                	mov    %eax,%ecx
c0101e15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
c0101e17:	66 c7 05 9c 89 11 c0 	movw   $0x1b,0xc011899c
c0101e1e:	1b 00 
        switchk2u.tf_ds = USER_DS;
c0101e20:	66 c7 05 8c 89 11 c0 	movw   $0x23,0xc011898c
c0101e27:	23 00 
        switchk2u.tf_es = USER_DS;
c0101e29:	66 c7 05 88 89 11 c0 	movw   $0x23,0xc0118988
c0101e30:	23 00 
        switchk2u.tf_ss = USER_DS;
c0101e32:	66 c7 05 a8 89 11 c0 	movw   $0x23,0xc01189a8
c0101e39:	23 00 

        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101e3b:	a1 a0 89 11 c0       	mov    0xc01189a0,%eax
c0101e40:	80 cc 30             	or     $0x30,%ah
c0101e43:	a3 a0 89 11 c0       	mov    %eax,0xc01189a0
        // set trap frame pointer
        // tf is the pointer to the pointer of trap frame (a structure)
        // tf = esp, while esp -> esp - 1 (*trap_frame) due to `pushl %esp`
        // so *(tf - 1) is the pointer to trap frame
        // change *trap_frame to point to the new frame
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101e48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4b:	83 e8 04             	sub    $0x4,%eax
c0101e4e:	ba 60 89 11 c0       	mov    $0xc0118960,%edx
c0101e53:	89 10                	mov    %edx,(%eax)
        break;
c0101e55:	eb 68                	jmp    c0101ebf <trap_dispatch+0x1b1>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
c0101e57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5a:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c0101e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e63:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c0101e69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6c:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)

        // restore eflags
        tf->tf_eflags &= ~FL_IOPL_MASK;
c0101e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e75:	8b 40 40             	mov    0x40(%eax),%eax
c0101e78:	80 e4 cf             	and    $0xcf,%ah
c0101e7b:	89 c2                	mov    %eax,%edx
c0101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e80:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c0101e83:	eb 3a                	jmp    c0101ebf <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e8c:	0f b7 c0             	movzwl %ax,%eax
c0101e8f:	83 e0 03             	and    $0x3,%eax
c0101e92:	85 c0                	test   %eax,%eax
c0101e94:	75 29                	jne    c0101ebf <trap_dispatch+0x1b1>
            print_trapframe(tf);
c0101e96:	83 ec 0c             	sub    $0xc,%esp
c0101e99:	ff 75 08             	pushl  0x8(%ebp)
c0101e9c:	e8 d0 fb ff ff       	call   c0101a71 <print_trapframe>
c0101ea1:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101ea4:	83 ec 04             	sub    $0x4,%esp
c0101ea7:	68 aa 61 10 c0       	push   $0xc01061aa
c0101eac:	68 dc 00 00 00       	push   $0xdc
c0101eb1:	68 ce 5f 10 c0       	push   $0xc0105fce
c0101eb6:	e8 1a e5 ff ff       	call   c01003d5 <__panic>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101ebb:	90                   	nop
c0101ebc:	eb 01                	jmp    c0101ebf <trap_dispatch+0x1b1>
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }

        // 3. too simple ?!
        break;
c0101ebe:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101ebf:	90                   	nop
c0101ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0101ec3:	5b                   	pop    %ebx
c0101ec4:	5e                   	pop    %esi
c0101ec5:	5f                   	pop    %edi
c0101ec6:	5d                   	pop    %ebp
c0101ec7:	c3                   	ret    

c0101ec8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101ec8:	55                   	push   %ebp
c0101ec9:	89 e5                	mov    %esp,%ebp
c0101ecb:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ece:	83 ec 0c             	sub    $0xc,%esp
c0101ed1:	ff 75 08             	pushl  0x8(%ebp)
c0101ed4:	e8 35 fe ff ff       	call   c0101d0e <trap_dispatch>
c0101ed9:	83 c4 10             	add    $0x10,%esp
}
c0101edc:	90                   	nop
c0101edd:	c9                   	leave  
c0101ede:	c3                   	ret    

c0101edf <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101edf:	6a 00                	push   $0x0
  pushl $0
c0101ee1:	6a 00                	push   $0x0
  jmp __alltraps
c0101ee3:	e9 69 0a 00 00       	jmp    c0102951 <__alltraps>

c0101ee8 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ee8:	6a 00                	push   $0x0
  pushl $1
c0101eea:	6a 01                	push   $0x1
  jmp __alltraps
c0101eec:	e9 60 0a 00 00       	jmp    c0102951 <__alltraps>

c0101ef1 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ef1:	6a 00                	push   $0x0
  pushl $2
c0101ef3:	6a 02                	push   $0x2
  jmp __alltraps
c0101ef5:	e9 57 0a 00 00       	jmp    c0102951 <__alltraps>

c0101efa <vector3>:
.globl vector3
vector3:
  pushl $0
c0101efa:	6a 00                	push   $0x0
  pushl $3
c0101efc:	6a 03                	push   $0x3
  jmp __alltraps
c0101efe:	e9 4e 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f03 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f03:	6a 00                	push   $0x0
  pushl $4
c0101f05:	6a 04                	push   $0x4
  jmp __alltraps
c0101f07:	e9 45 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f0c <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f0c:	6a 00                	push   $0x0
  pushl $5
c0101f0e:	6a 05                	push   $0x5
  jmp __alltraps
c0101f10:	e9 3c 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f15 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f15:	6a 00                	push   $0x0
  pushl $6
c0101f17:	6a 06                	push   $0x6
  jmp __alltraps
c0101f19:	e9 33 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f1e <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f1e:	6a 00                	push   $0x0
  pushl $7
c0101f20:	6a 07                	push   $0x7
  jmp __alltraps
c0101f22:	e9 2a 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f27 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f27:	6a 08                	push   $0x8
  jmp __alltraps
c0101f29:	e9 23 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f2e <vector9>:
.globl vector9
vector9:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $9
c0101f30:	6a 09                	push   $0x9
  jmp __alltraps
c0101f32:	e9 1a 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f37 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f37:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f39:	e9 13 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f3e <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f3e:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f40:	e9 0c 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f45 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f45:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f47:	e9 05 0a 00 00       	jmp    c0102951 <__alltraps>

c0101f4c <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f4c:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f4e:	e9 fe 09 00 00       	jmp    c0102951 <__alltraps>

c0101f53 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f53:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f55:	e9 f7 09 00 00       	jmp    c0102951 <__alltraps>

c0101f5a <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f5a:	6a 00                	push   $0x0
  pushl $15
c0101f5c:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f5e:	e9 ee 09 00 00       	jmp    c0102951 <__alltraps>

c0101f63 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $16
c0101f65:	6a 10                	push   $0x10
  jmp __alltraps
c0101f67:	e9 e5 09 00 00       	jmp    c0102951 <__alltraps>

c0101f6c <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f6c:	6a 11                	push   $0x11
  jmp __alltraps
c0101f6e:	e9 de 09 00 00       	jmp    c0102951 <__alltraps>

c0101f73 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $18
c0101f75:	6a 12                	push   $0x12
  jmp __alltraps
c0101f77:	e9 d5 09 00 00       	jmp    c0102951 <__alltraps>

c0101f7c <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $19
c0101f7e:	6a 13                	push   $0x13
  jmp __alltraps
c0101f80:	e9 cc 09 00 00       	jmp    c0102951 <__alltraps>

c0101f85 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $20
c0101f87:	6a 14                	push   $0x14
  jmp __alltraps
c0101f89:	e9 c3 09 00 00       	jmp    c0102951 <__alltraps>

c0101f8e <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $21
c0101f90:	6a 15                	push   $0x15
  jmp __alltraps
c0101f92:	e9 ba 09 00 00       	jmp    c0102951 <__alltraps>

c0101f97 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $22
c0101f99:	6a 16                	push   $0x16
  jmp __alltraps
c0101f9b:	e9 b1 09 00 00       	jmp    c0102951 <__alltraps>

c0101fa0 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $23
c0101fa2:	6a 17                	push   $0x17
  jmp __alltraps
c0101fa4:	e9 a8 09 00 00       	jmp    c0102951 <__alltraps>

c0101fa9 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $24
c0101fab:	6a 18                	push   $0x18
  jmp __alltraps
c0101fad:	e9 9f 09 00 00       	jmp    c0102951 <__alltraps>

c0101fb2 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $25
c0101fb4:	6a 19                	push   $0x19
  jmp __alltraps
c0101fb6:	e9 96 09 00 00       	jmp    c0102951 <__alltraps>

c0101fbb <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $26
c0101fbd:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101fbf:	e9 8d 09 00 00       	jmp    c0102951 <__alltraps>

c0101fc4 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $27
c0101fc6:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fc8:	e9 84 09 00 00       	jmp    c0102951 <__alltraps>

c0101fcd <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $28
c0101fcf:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fd1:	e9 7b 09 00 00       	jmp    c0102951 <__alltraps>

c0101fd6 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $29
c0101fd8:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fda:	e9 72 09 00 00       	jmp    c0102951 <__alltraps>

c0101fdf <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $30
c0101fe1:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fe3:	e9 69 09 00 00       	jmp    c0102951 <__alltraps>

c0101fe8 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $31
c0101fea:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101fec:	e9 60 09 00 00       	jmp    c0102951 <__alltraps>

c0101ff1 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $32
c0101ff3:	6a 20                	push   $0x20
  jmp __alltraps
c0101ff5:	e9 57 09 00 00       	jmp    c0102951 <__alltraps>

c0101ffa <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $33
c0101ffc:	6a 21                	push   $0x21
  jmp __alltraps
c0101ffe:	e9 4e 09 00 00       	jmp    c0102951 <__alltraps>

c0102003 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $34
c0102005:	6a 22                	push   $0x22
  jmp __alltraps
c0102007:	e9 45 09 00 00       	jmp    c0102951 <__alltraps>

c010200c <vector35>:
.globl vector35
vector35:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $35
c010200e:	6a 23                	push   $0x23
  jmp __alltraps
c0102010:	e9 3c 09 00 00       	jmp    c0102951 <__alltraps>

c0102015 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $36
c0102017:	6a 24                	push   $0x24
  jmp __alltraps
c0102019:	e9 33 09 00 00       	jmp    c0102951 <__alltraps>

c010201e <vector37>:
.globl vector37
vector37:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $37
c0102020:	6a 25                	push   $0x25
  jmp __alltraps
c0102022:	e9 2a 09 00 00       	jmp    c0102951 <__alltraps>

c0102027 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $38
c0102029:	6a 26                	push   $0x26
  jmp __alltraps
c010202b:	e9 21 09 00 00       	jmp    c0102951 <__alltraps>

c0102030 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $39
c0102032:	6a 27                	push   $0x27
  jmp __alltraps
c0102034:	e9 18 09 00 00       	jmp    c0102951 <__alltraps>

c0102039 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $40
c010203b:	6a 28                	push   $0x28
  jmp __alltraps
c010203d:	e9 0f 09 00 00       	jmp    c0102951 <__alltraps>

c0102042 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $41
c0102044:	6a 29                	push   $0x29
  jmp __alltraps
c0102046:	e9 06 09 00 00       	jmp    c0102951 <__alltraps>

c010204b <vector42>:
.globl vector42
vector42:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $42
c010204d:	6a 2a                	push   $0x2a
  jmp __alltraps
c010204f:	e9 fd 08 00 00       	jmp    c0102951 <__alltraps>

c0102054 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $43
c0102056:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102058:	e9 f4 08 00 00       	jmp    c0102951 <__alltraps>

c010205d <vector44>:
.globl vector44
vector44:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $44
c010205f:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102061:	e9 eb 08 00 00       	jmp    c0102951 <__alltraps>

c0102066 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $45
c0102068:	6a 2d                	push   $0x2d
  jmp __alltraps
c010206a:	e9 e2 08 00 00       	jmp    c0102951 <__alltraps>

c010206f <vector46>:
.globl vector46
vector46:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $46
c0102071:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102073:	e9 d9 08 00 00       	jmp    c0102951 <__alltraps>

c0102078 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $47
c010207a:	6a 2f                	push   $0x2f
  jmp __alltraps
c010207c:	e9 d0 08 00 00       	jmp    c0102951 <__alltraps>

c0102081 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $48
c0102083:	6a 30                	push   $0x30
  jmp __alltraps
c0102085:	e9 c7 08 00 00       	jmp    c0102951 <__alltraps>

c010208a <vector49>:
.globl vector49
vector49:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $49
c010208c:	6a 31                	push   $0x31
  jmp __alltraps
c010208e:	e9 be 08 00 00       	jmp    c0102951 <__alltraps>

c0102093 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $50
c0102095:	6a 32                	push   $0x32
  jmp __alltraps
c0102097:	e9 b5 08 00 00       	jmp    c0102951 <__alltraps>

c010209c <vector51>:
.globl vector51
vector51:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $51
c010209e:	6a 33                	push   $0x33
  jmp __alltraps
c01020a0:	e9 ac 08 00 00       	jmp    c0102951 <__alltraps>

c01020a5 <vector52>:
.globl vector52
vector52:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $52
c01020a7:	6a 34                	push   $0x34
  jmp __alltraps
c01020a9:	e9 a3 08 00 00       	jmp    c0102951 <__alltraps>

c01020ae <vector53>:
.globl vector53
vector53:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $53
c01020b0:	6a 35                	push   $0x35
  jmp __alltraps
c01020b2:	e9 9a 08 00 00       	jmp    c0102951 <__alltraps>

c01020b7 <vector54>:
.globl vector54
vector54:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $54
c01020b9:	6a 36                	push   $0x36
  jmp __alltraps
c01020bb:	e9 91 08 00 00       	jmp    c0102951 <__alltraps>

c01020c0 <vector55>:
.globl vector55
vector55:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $55
c01020c2:	6a 37                	push   $0x37
  jmp __alltraps
c01020c4:	e9 88 08 00 00       	jmp    c0102951 <__alltraps>

c01020c9 <vector56>:
.globl vector56
vector56:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $56
c01020cb:	6a 38                	push   $0x38
  jmp __alltraps
c01020cd:	e9 7f 08 00 00       	jmp    c0102951 <__alltraps>

c01020d2 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $57
c01020d4:	6a 39                	push   $0x39
  jmp __alltraps
c01020d6:	e9 76 08 00 00       	jmp    c0102951 <__alltraps>

c01020db <vector58>:
.globl vector58
vector58:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $58
c01020dd:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020df:	e9 6d 08 00 00       	jmp    c0102951 <__alltraps>

c01020e4 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $59
c01020e6:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020e8:	e9 64 08 00 00       	jmp    c0102951 <__alltraps>

c01020ed <vector60>:
.globl vector60
vector60:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $60
c01020ef:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020f1:	e9 5b 08 00 00       	jmp    c0102951 <__alltraps>

c01020f6 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $61
c01020f8:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020fa:	e9 52 08 00 00       	jmp    c0102951 <__alltraps>

c01020ff <vector62>:
.globl vector62
vector62:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $62
c0102101:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102103:	e9 49 08 00 00       	jmp    c0102951 <__alltraps>

c0102108 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $63
c010210a:	6a 3f                	push   $0x3f
  jmp __alltraps
c010210c:	e9 40 08 00 00       	jmp    c0102951 <__alltraps>

c0102111 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $64
c0102113:	6a 40                	push   $0x40
  jmp __alltraps
c0102115:	e9 37 08 00 00       	jmp    c0102951 <__alltraps>

c010211a <vector65>:
.globl vector65
vector65:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $65
c010211c:	6a 41                	push   $0x41
  jmp __alltraps
c010211e:	e9 2e 08 00 00       	jmp    c0102951 <__alltraps>

c0102123 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $66
c0102125:	6a 42                	push   $0x42
  jmp __alltraps
c0102127:	e9 25 08 00 00       	jmp    c0102951 <__alltraps>

c010212c <vector67>:
.globl vector67
vector67:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $67
c010212e:	6a 43                	push   $0x43
  jmp __alltraps
c0102130:	e9 1c 08 00 00       	jmp    c0102951 <__alltraps>

c0102135 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $68
c0102137:	6a 44                	push   $0x44
  jmp __alltraps
c0102139:	e9 13 08 00 00       	jmp    c0102951 <__alltraps>

c010213e <vector69>:
.globl vector69
vector69:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $69
c0102140:	6a 45                	push   $0x45
  jmp __alltraps
c0102142:	e9 0a 08 00 00       	jmp    c0102951 <__alltraps>

c0102147 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $70
c0102149:	6a 46                	push   $0x46
  jmp __alltraps
c010214b:	e9 01 08 00 00       	jmp    c0102951 <__alltraps>

c0102150 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $71
c0102152:	6a 47                	push   $0x47
  jmp __alltraps
c0102154:	e9 f8 07 00 00       	jmp    c0102951 <__alltraps>

c0102159 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $72
c010215b:	6a 48                	push   $0x48
  jmp __alltraps
c010215d:	e9 ef 07 00 00       	jmp    c0102951 <__alltraps>

c0102162 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $73
c0102164:	6a 49                	push   $0x49
  jmp __alltraps
c0102166:	e9 e6 07 00 00       	jmp    c0102951 <__alltraps>

c010216b <vector74>:
.globl vector74
vector74:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $74
c010216d:	6a 4a                	push   $0x4a
  jmp __alltraps
c010216f:	e9 dd 07 00 00       	jmp    c0102951 <__alltraps>

c0102174 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $75
c0102176:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102178:	e9 d4 07 00 00       	jmp    c0102951 <__alltraps>

c010217d <vector76>:
.globl vector76
vector76:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $76
c010217f:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102181:	e9 cb 07 00 00       	jmp    c0102951 <__alltraps>

c0102186 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $77
c0102188:	6a 4d                	push   $0x4d
  jmp __alltraps
c010218a:	e9 c2 07 00 00       	jmp    c0102951 <__alltraps>

c010218f <vector78>:
.globl vector78
vector78:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $78
c0102191:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102193:	e9 b9 07 00 00       	jmp    c0102951 <__alltraps>

c0102198 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $79
c010219a:	6a 4f                	push   $0x4f
  jmp __alltraps
c010219c:	e9 b0 07 00 00       	jmp    c0102951 <__alltraps>

c01021a1 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $80
c01021a3:	6a 50                	push   $0x50
  jmp __alltraps
c01021a5:	e9 a7 07 00 00       	jmp    c0102951 <__alltraps>

c01021aa <vector81>:
.globl vector81
vector81:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $81
c01021ac:	6a 51                	push   $0x51
  jmp __alltraps
c01021ae:	e9 9e 07 00 00       	jmp    c0102951 <__alltraps>

c01021b3 <vector82>:
.globl vector82
vector82:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $82
c01021b5:	6a 52                	push   $0x52
  jmp __alltraps
c01021b7:	e9 95 07 00 00       	jmp    c0102951 <__alltraps>

c01021bc <vector83>:
.globl vector83
vector83:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $83
c01021be:	6a 53                	push   $0x53
  jmp __alltraps
c01021c0:	e9 8c 07 00 00       	jmp    c0102951 <__alltraps>

c01021c5 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $84
c01021c7:	6a 54                	push   $0x54
  jmp __alltraps
c01021c9:	e9 83 07 00 00       	jmp    c0102951 <__alltraps>

c01021ce <vector85>:
.globl vector85
vector85:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $85
c01021d0:	6a 55                	push   $0x55
  jmp __alltraps
c01021d2:	e9 7a 07 00 00       	jmp    c0102951 <__alltraps>

c01021d7 <vector86>:
.globl vector86
vector86:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $86
c01021d9:	6a 56                	push   $0x56
  jmp __alltraps
c01021db:	e9 71 07 00 00       	jmp    c0102951 <__alltraps>

c01021e0 <vector87>:
.globl vector87
vector87:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $87
c01021e2:	6a 57                	push   $0x57
  jmp __alltraps
c01021e4:	e9 68 07 00 00       	jmp    c0102951 <__alltraps>

c01021e9 <vector88>:
.globl vector88
vector88:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $88
c01021eb:	6a 58                	push   $0x58
  jmp __alltraps
c01021ed:	e9 5f 07 00 00       	jmp    c0102951 <__alltraps>

c01021f2 <vector89>:
.globl vector89
vector89:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $89
c01021f4:	6a 59                	push   $0x59
  jmp __alltraps
c01021f6:	e9 56 07 00 00       	jmp    c0102951 <__alltraps>

c01021fb <vector90>:
.globl vector90
vector90:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $90
c01021fd:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021ff:	e9 4d 07 00 00       	jmp    c0102951 <__alltraps>

c0102204 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $91
c0102206:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102208:	e9 44 07 00 00       	jmp    c0102951 <__alltraps>

c010220d <vector92>:
.globl vector92
vector92:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $92
c010220f:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102211:	e9 3b 07 00 00       	jmp    c0102951 <__alltraps>

c0102216 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $93
c0102218:	6a 5d                	push   $0x5d
  jmp __alltraps
c010221a:	e9 32 07 00 00       	jmp    c0102951 <__alltraps>

c010221f <vector94>:
.globl vector94
vector94:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $94
c0102221:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102223:	e9 29 07 00 00       	jmp    c0102951 <__alltraps>

c0102228 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $95
c010222a:	6a 5f                	push   $0x5f
  jmp __alltraps
c010222c:	e9 20 07 00 00       	jmp    c0102951 <__alltraps>

c0102231 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $96
c0102233:	6a 60                	push   $0x60
  jmp __alltraps
c0102235:	e9 17 07 00 00       	jmp    c0102951 <__alltraps>

c010223a <vector97>:
.globl vector97
vector97:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $97
c010223c:	6a 61                	push   $0x61
  jmp __alltraps
c010223e:	e9 0e 07 00 00       	jmp    c0102951 <__alltraps>

c0102243 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $98
c0102245:	6a 62                	push   $0x62
  jmp __alltraps
c0102247:	e9 05 07 00 00       	jmp    c0102951 <__alltraps>

c010224c <vector99>:
.globl vector99
vector99:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $99
c010224e:	6a 63                	push   $0x63
  jmp __alltraps
c0102250:	e9 fc 06 00 00       	jmp    c0102951 <__alltraps>

c0102255 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $100
c0102257:	6a 64                	push   $0x64
  jmp __alltraps
c0102259:	e9 f3 06 00 00       	jmp    c0102951 <__alltraps>

c010225e <vector101>:
.globl vector101
vector101:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $101
c0102260:	6a 65                	push   $0x65
  jmp __alltraps
c0102262:	e9 ea 06 00 00       	jmp    c0102951 <__alltraps>

c0102267 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $102
c0102269:	6a 66                	push   $0x66
  jmp __alltraps
c010226b:	e9 e1 06 00 00       	jmp    c0102951 <__alltraps>

c0102270 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $103
c0102272:	6a 67                	push   $0x67
  jmp __alltraps
c0102274:	e9 d8 06 00 00       	jmp    c0102951 <__alltraps>

c0102279 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $104
c010227b:	6a 68                	push   $0x68
  jmp __alltraps
c010227d:	e9 cf 06 00 00       	jmp    c0102951 <__alltraps>

c0102282 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $105
c0102284:	6a 69                	push   $0x69
  jmp __alltraps
c0102286:	e9 c6 06 00 00       	jmp    c0102951 <__alltraps>

c010228b <vector106>:
.globl vector106
vector106:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $106
c010228d:	6a 6a                	push   $0x6a
  jmp __alltraps
c010228f:	e9 bd 06 00 00       	jmp    c0102951 <__alltraps>

c0102294 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $107
c0102296:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102298:	e9 b4 06 00 00       	jmp    c0102951 <__alltraps>

c010229d <vector108>:
.globl vector108
vector108:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $108
c010229f:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022a1:	e9 ab 06 00 00       	jmp    c0102951 <__alltraps>

c01022a6 <vector109>:
.globl vector109
vector109:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $109
c01022a8:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022aa:	e9 a2 06 00 00       	jmp    c0102951 <__alltraps>

c01022af <vector110>:
.globl vector110
vector110:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $110
c01022b1:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022b3:	e9 99 06 00 00       	jmp    c0102951 <__alltraps>

c01022b8 <vector111>:
.globl vector111
vector111:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $111
c01022ba:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022bc:	e9 90 06 00 00       	jmp    c0102951 <__alltraps>

c01022c1 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $112
c01022c3:	6a 70                	push   $0x70
  jmp __alltraps
c01022c5:	e9 87 06 00 00       	jmp    c0102951 <__alltraps>

c01022ca <vector113>:
.globl vector113
vector113:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $113
c01022cc:	6a 71                	push   $0x71
  jmp __alltraps
c01022ce:	e9 7e 06 00 00       	jmp    c0102951 <__alltraps>

c01022d3 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $114
c01022d5:	6a 72                	push   $0x72
  jmp __alltraps
c01022d7:	e9 75 06 00 00       	jmp    c0102951 <__alltraps>

c01022dc <vector115>:
.globl vector115
vector115:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $115
c01022de:	6a 73                	push   $0x73
  jmp __alltraps
c01022e0:	e9 6c 06 00 00       	jmp    c0102951 <__alltraps>

c01022e5 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $116
c01022e7:	6a 74                	push   $0x74
  jmp __alltraps
c01022e9:	e9 63 06 00 00       	jmp    c0102951 <__alltraps>

c01022ee <vector117>:
.globl vector117
vector117:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $117
c01022f0:	6a 75                	push   $0x75
  jmp __alltraps
c01022f2:	e9 5a 06 00 00       	jmp    c0102951 <__alltraps>

c01022f7 <vector118>:
.globl vector118
vector118:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $118
c01022f9:	6a 76                	push   $0x76
  jmp __alltraps
c01022fb:	e9 51 06 00 00       	jmp    c0102951 <__alltraps>

c0102300 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $119
c0102302:	6a 77                	push   $0x77
  jmp __alltraps
c0102304:	e9 48 06 00 00       	jmp    c0102951 <__alltraps>

c0102309 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $120
c010230b:	6a 78                	push   $0x78
  jmp __alltraps
c010230d:	e9 3f 06 00 00       	jmp    c0102951 <__alltraps>

c0102312 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $121
c0102314:	6a 79                	push   $0x79
  jmp __alltraps
c0102316:	e9 36 06 00 00       	jmp    c0102951 <__alltraps>

c010231b <vector122>:
.globl vector122
vector122:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $122
c010231d:	6a 7a                	push   $0x7a
  jmp __alltraps
c010231f:	e9 2d 06 00 00       	jmp    c0102951 <__alltraps>

c0102324 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $123
c0102326:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102328:	e9 24 06 00 00       	jmp    c0102951 <__alltraps>

c010232d <vector124>:
.globl vector124
vector124:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $124
c010232f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102331:	e9 1b 06 00 00       	jmp    c0102951 <__alltraps>

c0102336 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $125
c0102338:	6a 7d                	push   $0x7d
  jmp __alltraps
c010233a:	e9 12 06 00 00       	jmp    c0102951 <__alltraps>

c010233f <vector126>:
.globl vector126
vector126:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $126
c0102341:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102343:	e9 09 06 00 00       	jmp    c0102951 <__alltraps>

c0102348 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $127
c010234a:	6a 7f                	push   $0x7f
  jmp __alltraps
c010234c:	e9 00 06 00 00       	jmp    c0102951 <__alltraps>

c0102351 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $128
c0102353:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102358:	e9 f4 05 00 00       	jmp    c0102951 <__alltraps>

c010235d <vector129>:
.globl vector129
vector129:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $129
c010235f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102364:	e9 e8 05 00 00       	jmp    c0102951 <__alltraps>

c0102369 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102369:	6a 00                	push   $0x0
  pushl $130
c010236b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102370:	e9 dc 05 00 00       	jmp    c0102951 <__alltraps>

c0102375 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $131
c0102377:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010237c:	e9 d0 05 00 00       	jmp    c0102951 <__alltraps>

c0102381 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $132
c0102383:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102388:	e9 c4 05 00 00       	jmp    c0102951 <__alltraps>

c010238d <vector133>:
.globl vector133
vector133:
  pushl $0
c010238d:	6a 00                	push   $0x0
  pushl $133
c010238f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102394:	e9 b8 05 00 00       	jmp    c0102951 <__alltraps>

c0102399 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $134
c010239b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023a0:	e9 ac 05 00 00       	jmp    c0102951 <__alltraps>

c01023a5 <vector135>:
.globl vector135
vector135:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $135
c01023a7:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023ac:	e9 a0 05 00 00       	jmp    c0102951 <__alltraps>

c01023b1 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023b1:	6a 00                	push   $0x0
  pushl $136
c01023b3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023b8:	e9 94 05 00 00       	jmp    c0102951 <__alltraps>

c01023bd <vector137>:
.globl vector137
vector137:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $137
c01023bf:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023c4:	e9 88 05 00 00       	jmp    c0102951 <__alltraps>

c01023c9 <vector138>:
.globl vector138
vector138:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $138
c01023cb:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023d0:	e9 7c 05 00 00       	jmp    c0102951 <__alltraps>

c01023d5 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023d5:	6a 00                	push   $0x0
  pushl $139
c01023d7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023dc:	e9 70 05 00 00       	jmp    c0102951 <__alltraps>

c01023e1 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $140
c01023e3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023e8:	e9 64 05 00 00       	jmp    c0102951 <__alltraps>

c01023ed <vector141>:
.globl vector141
vector141:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $141
c01023ef:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023f4:	e9 58 05 00 00       	jmp    c0102951 <__alltraps>

c01023f9 <vector142>:
.globl vector142
vector142:
  pushl $0
c01023f9:	6a 00                	push   $0x0
  pushl $142
c01023fb:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102400:	e9 4c 05 00 00       	jmp    c0102951 <__alltraps>

c0102405 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $143
c0102407:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010240c:	e9 40 05 00 00       	jmp    c0102951 <__alltraps>

c0102411 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $144
c0102413:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102418:	e9 34 05 00 00       	jmp    c0102951 <__alltraps>

c010241d <vector145>:
.globl vector145
vector145:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $145
c010241f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102424:	e9 28 05 00 00       	jmp    c0102951 <__alltraps>

c0102429 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $146
c010242b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102430:	e9 1c 05 00 00       	jmp    c0102951 <__alltraps>

c0102435 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $147
c0102437:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010243c:	e9 10 05 00 00       	jmp    c0102951 <__alltraps>

c0102441 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $148
c0102443:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102448:	e9 04 05 00 00       	jmp    c0102951 <__alltraps>

c010244d <vector149>:
.globl vector149
vector149:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $149
c010244f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102454:	e9 f8 04 00 00       	jmp    c0102951 <__alltraps>

c0102459 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $150
c010245b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102460:	e9 ec 04 00 00       	jmp    c0102951 <__alltraps>

c0102465 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $151
c0102467:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010246c:	e9 e0 04 00 00       	jmp    c0102951 <__alltraps>

c0102471 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $152
c0102473:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102478:	e9 d4 04 00 00       	jmp    c0102951 <__alltraps>

c010247d <vector153>:
.globl vector153
vector153:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $153
c010247f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102484:	e9 c8 04 00 00       	jmp    c0102951 <__alltraps>

c0102489 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $154
c010248b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102490:	e9 bc 04 00 00       	jmp    c0102951 <__alltraps>

c0102495 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $155
c0102497:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010249c:	e9 b0 04 00 00       	jmp    c0102951 <__alltraps>

c01024a1 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $156
c01024a3:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024a8:	e9 a4 04 00 00       	jmp    c0102951 <__alltraps>

c01024ad <vector157>:
.globl vector157
vector157:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $157
c01024af:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024b4:	e9 98 04 00 00       	jmp    c0102951 <__alltraps>

c01024b9 <vector158>:
.globl vector158
vector158:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $158
c01024bb:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024c0:	e9 8c 04 00 00       	jmp    c0102951 <__alltraps>

c01024c5 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $159
c01024c7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024cc:	e9 80 04 00 00       	jmp    c0102951 <__alltraps>

c01024d1 <vector160>:
.globl vector160
vector160:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $160
c01024d3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024d8:	e9 74 04 00 00       	jmp    c0102951 <__alltraps>

c01024dd <vector161>:
.globl vector161
vector161:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $161
c01024df:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024e4:	e9 68 04 00 00       	jmp    c0102951 <__alltraps>

c01024e9 <vector162>:
.globl vector162
vector162:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $162
c01024eb:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024f0:	e9 5c 04 00 00       	jmp    c0102951 <__alltraps>

c01024f5 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $163
c01024f7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024fc:	e9 50 04 00 00       	jmp    c0102951 <__alltraps>

c0102501 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $164
c0102503:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102508:	e9 44 04 00 00       	jmp    c0102951 <__alltraps>

c010250d <vector165>:
.globl vector165
vector165:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $165
c010250f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102514:	e9 38 04 00 00       	jmp    c0102951 <__alltraps>

c0102519 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $166
c010251b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102520:	e9 2c 04 00 00       	jmp    c0102951 <__alltraps>

c0102525 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $167
c0102527:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010252c:	e9 20 04 00 00       	jmp    c0102951 <__alltraps>

c0102531 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $168
c0102533:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102538:	e9 14 04 00 00       	jmp    c0102951 <__alltraps>

c010253d <vector169>:
.globl vector169
vector169:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $169
c010253f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102544:	e9 08 04 00 00       	jmp    c0102951 <__alltraps>

c0102549 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $170
c010254b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102550:	e9 fc 03 00 00       	jmp    c0102951 <__alltraps>

c0102555 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $171
c0102557:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010255c:	e9 f0 03 00 00       	jmp    c0102951 <__alltraps>

c0102561 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $172
c0102563:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102568:	e9 e4 03 00 00       	jmp    c0102951 <__alltraps>

c010256d <vector173>:
.globl vector173
vector173:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $173
c010256f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102574:	e9 d8 03 00 00       	jmp    c0102951 <__alltraps>

c0102579 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $174
c010257b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102580:	e9 cc 03 00 00       	jmp    c0102951 <__alltraps>

c0102585 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $175
c0102587:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010258c:	e9 c0 03 00 00       	jmp    c0102951 <__alltraps>

c0102591 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $176
c0102593:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102598:	e9 b4 03 00 00       	jmp    c0102951 <__alltraps>

c010259d <vector177>:
.globl vector177
vector177:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $177
c010259f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025a4:	e9 a8 03 00 00       	jmp    c0102951 <__alltraps>

c01025a9 <vector178>:
.globl vector178
vector178:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $178
c01025ab:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025b0:	e9 9c 03 00 00       	jmp    c0102951 <__alltraps>

c01025b5 <vector179>:
.globl vector179
vector179:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $179
c01025b7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025bc:	e9 90 03 00 00       	jmp    c0102951 <__alltraps>

c01025c1 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $180
c01025c3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025c8:	e9 84 03 00 00       	jmp    c0102951 <__alltraps>

c01025cd <vector181>:
.globl vector181
vector181:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $181
c01025cf:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025d4:	e9 78 03 00 00       	jmp    c0102951 <__alltraps>

c01025d9 <vector182>:
.globl vector182
vector182:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $182
c01025db:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025e0:	e9 6c 03 00 00       	jmp    c0102951 <__alltraps>

c01025e5 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $183
c01025e7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025ec:	e9 60 03 00 00       	jmp    c0102951 <__alltraps>

c01025f1 <vector184>:
.globl vector184
vector184:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $184
c01025f3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025f8:	e9 54 03 00 00       	jmp    c0102951 <__alltraps>

c01025fd <vector185>:
.globl vector185
vector185:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $185
c01025ff:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102604:	e9 48 03 00 00       	jmp    c0102951 <__alltraps>

c0102609 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $186
c010260b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102610:	e9 3c 03 00 00       	jmp    c0102951 <__alltraps>

c0102615 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $187
c0102617:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010261c:	e9 30 03 00 00       	jmp    c0102951 <__alltraps>

c0102621 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $188
c0102623:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102628:	e9 24 03 00 00       	jmp    c0102951 <__alltraps>

c010262d <vector189>:
.globl vector189
vector189:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $189
c010262f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102634:	e9 18 03 00 00       	jmp    c0102951 <__alltraps>

c0102639 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $190
c010263b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102640:	e9 0c 03 00 00       	jmp    c0102951 <__alltraps>

c0102645 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $191
c0102647:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010264c:	e9 00 03 00 00       	jmp    c0102951 <__alltraps>

c0102651 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $192
c0102653:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102658:	e9 f4 02 00 00       	jmp    c0102951 <__alltraps>

c010265d <vector193>:
.globl vector193
vector193:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $193
c010265f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102664:	e9 e8 02 00 00       	jmp    c0102951 <__alltraps>

c0102669 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $194
c010266b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102670:	e9 dc 02 00 00       	jmp    c0102951 <__alltraps>

c0102675 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $195
c0102677:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010267c:	e9 d0 02 00 00       	jmp    c0102951 <__alltraps>

c0102681 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $196
c0102683:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102688:	e9 c4 02 00 00       	jmp    c0102951 <__alltraps>

c010268d <vector197>:
.globl vector197
vector197:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $197
c010268f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102694:	e9 b8 02 00 00       	jmp    c0102951 <__alltraps>

c0102699 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $198
c010269b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026a0:	e9 ac 02 00 00       	jmp    c0102951 <__alltraps>

c01026a5 <vector199>:
.globl vector199
vector199:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $199
c01026a7:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026ac:	e9 a0 02 00 00       	jmp    c0102951 <__alltraps>

c01026b1 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $200
c01026b3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026b8:	e9 94 02 00 00       	jmp    c0102951 <__alltraps>

c01026bd <vector201>:
.globl vector201
vector201:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $201
c01026bf:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026c4:	e9 88 02 00 00       	jmp    c0102951 <__alltraps>

c01026c9 <vector202>:
.globl vector202
vector202:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $202
c01026cb:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026d0:	e9 7c 02 00 00       	jmp    c0102951 <__alltraps>

c01026d5 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $203
c01026d7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026dc:	e9 70 02 00 00       	jmp    c0102951 <__alltraps>

c01026e1 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $204
c01026e3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026e8:	e9 64 02 00 00       	jmp    c0102951 <__alltraps>

c01026ed <vector205>:
.globl vector205
vector205:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $205
c01026ef:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026f4:	e9 58 02 00 00       	jmp    c0102951 <__alltraps>

c01026f9 <vector206>:
.globl vector206
vector206:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $206
c01026fb:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102700:	e9 4c 02 00 00       	jmp    c0102951 <__alltraps>

c0102705 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $207
c0102707:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010270c:	e9 40 02 00 00       	jmp    c0102951 <__alltraps>

c0102711 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $208
c0102713:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102718:	e9 34 02 00 00       	jmp    c0102951 <__alltraps>

c010271d <vector209>:
.globl vector209
vector209:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $209
c010271f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102724:	e9 28 02 00 00       	jmp    c0102951 <__alltraps>

c0102729 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $210
c010272b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102730:	e9 1c 02 00 00       	jmp    c0102951 <__alltraps>

c0102735 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $211
c0102737:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010273c:	e9 10 02 00 00       	jmp    c0102951 <__alltraps>

c0102741 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $212
c0102743:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102748:	e9 04 02 00 00       	jmp    c0102951 <__alltraps>

c010274d <vector213>:
.globl vector213
vector213:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $213
c010274f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102754:	e9 f8 01 00 00       	jmp    c0102951 <__alltraps>

c0102759 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $214
c010275b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102760:	e9 ec 01 00 00       	jmp    c0102951 <__alltraps>

c0102765 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $215
c0102767:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010276c:	e9 e0 01 00 00       	jmp    c0102951 <__alltraps>

c0102771 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $216
c0102773:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102778:	e9 d4 01 00 00       	jmp    c0102951 <__alltraps>

c010277d <vector217>:
.globl vector217
vector217:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $217
c010277f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102784:	e9 c8 01 00 00       	jmp    c0102951 <__alltraps>

c0102789 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $218
c010278b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102790:	e9 bc 01 00 00       	jmp    c0102951 <__alltraps>

c0102795 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $219
c0102797:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010279c:	e9 b0 01 00 00       	jmp    c0102951 <__alltraps>

c01027a1 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $220
c01027a3:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027a8:	e9 a4 01 00 00       	jmp    c0102951 <__alltraps>

c01027ad <vector221>:
.globl vector221
vector221:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $221
c01027af:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027b4:	e9 98 01 00 00       	jmp    c0102951 <__alltraps>

c01027b9 <vector222>:
.globl vector222
vector222:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $222
c01027bb:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027c0:	e9 8c 01 00 00       	jmp    c0102951 <__alltraps>

c01027c5 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $223
c01027c7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027cc:	e9 80 01 00 00       	jmp    c0102951 <__alltraps>

c01027d1 <vector224>:
.globl vector224
vector224:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $224
c01027d3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027d8:	e9 74 01 00 00       	jmp    c0102951 <__alltraps>

c01027dd <vector225>:
.globl vector225
vector225:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $225
c01027df:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027e4:	e9 68 01 00 00       	jmp    c0102951 <__alltraps>

c01027e9 <vector226>:
.globl vector226
vector226:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $226
c01027eb:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027f0:	e9 5c 01 00 00       	jmp    c0102951 <__alltraps>

c01027f5 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $227
c01027f7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027fc:	e9 50 01 00 00       	jmp    c0102951 <__alltraps>

c0102801 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $228
c0102803:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102808:	e9 44 01 00 00       	jmp    c0102951 <__alltraps>

c010280d <vector229>:
.globl vector229
vector229:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $229
c010280f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102814:	e9 38 01 00 00       	jmp    c0102951 <__alltraps>

c0102819 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $230
c010281b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102820:	e9 2c 01 00 00       	jmp    c0102951 <__alltraps>

c0102825 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $231
c0102827:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010282c:	e9 20 01 00 00       	jmp    c0102951 <__alltraps>

c0102831 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $232
c0102833:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102838:	e9 14 01 00 00       	jmp    c0102951 <__alltraps>

c010283d <vector233>:
.globl vector233
vector233:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $233
c010283f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102844:	e9 08 01 00 00       	jmp    c0102951 <__alltraps>

c0102849 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $234
c010284b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102850:	e9 fc 00 00 00       	jmp    c0102951 <__alltraps>

c0102855 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $235
c0102857:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010285c:	e9 f0 00 00 00       	jmp    c0102951 <__alltraps>

c0102861 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $236
c0102863:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102868:	e9 e4 00 00 00       	jmp    c0102951 <__alltraps>

c010286d <vector237>:
.globl vector237
vector237:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $237
c010286f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102874:	e9 d8 00 00 00       	jmp    c0102951 <__alltraps>

c0102879 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $238
c010287b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102880:	e9 cc 00 00 00       	jmp    c0102951 <__alltraps>

c0102885 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $239
c0102887:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010288c:	e9 c0 00 00 00       	jmp    c0102951 <__alltraps>

c0102891 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $240
c0102893:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102898:	e9 b4 00 00 00       	jmp    c0102951 <__alltraps>

c010289d <vector241>:
.globl vector241
vector241:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $241
c010289f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028a4:	e9 a8 00 00 00       	jmp    c0102951 <__alltraps>

c01028a9 <vector242>:
.globl vector242
vector242:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $242
c01028ab:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028b0:	e9 9c 00 00 00       	jmp    c0102951 <__alltraps>

c01028b5 <vector243>:
.globl vector243
vector243:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $243
c01028b7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028bc:	e9 90 00 00 00       	jmp    c0102951 <__alltraps>

c01028c1 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $244
c01028c3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028c8:	e9 84 00 00 00       	jmp    c0102951 <__alltraps>

c01028cd <vector245>:
.globl vector245
vector245:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $245
c01028cf:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028d4:	e9 78 00 00 00       	jmp    c0102951 <__alltraps>

c01028d9 <vector246>:
.globl vector246
vector246:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $246
c01028db:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028e0:	e9 6c 00 00 00       	jmp    c0102951 <__alltraps>

c01028e5 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $247
c01028e7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028ec:	e9 60 00 00 00       	jmp    c0102951 <__alltraps>

c01028f1 <vector248>:
.globl vector248
vector248:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $248
c01028f3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028f8:	e9 54 00 00 00       	jmp    c0102951 <__alltraps>

c01028fd <vector249>:
.globl vector249
vector249:
  pushl $0
c01028fd:	6a 00                	push   $0x0
  pushl $249
c01028ff:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102904:	e9 48 00 00 00       	jmp    c0102951 <__alltraps>

c0102909 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $250
c010290b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102910:	e9 3c 00 00 00       	jmp    c0102951 <__alltraps>

c0102915 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102915:	6a 00                	push   $0x0
  pushl $251
c0102917:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010291c:	e9 30 00 00 00       	jmp    c0102951 <__alltraps>

c0102921 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $252
c0102923:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102928:	e9 24 00 00 00       	jmp    c0102951 <__alltraps>

c010292d <vector253>:
.globl vector253
vector253:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $253
c010292f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102934:	e9 18 00 00 00       	jmp    c0102951 <__alltraps>

c0102939 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102939:	6a 00                	push   $0x0
  pushl $254
c010293b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102940:	e9 0c 00 00 00       	jmp    c0102951 <__alltraps>

c0102945 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $255
c0102947:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010294c:	e9 00 00 00 00       	jmp    c0102951 <__alltraps>

c0102951 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102951:	1e                   	push   %ds
    pushl %es
c0102952:	06                   	push   %es
    pushl %fs
c0102953:	0f a0                	push   %fs
    pushl %gs
c0102955:	0f a8                	push   %gs
    pushal
c0102957:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102958:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010295d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010295f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102961:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102962:	e8 61 f5 ff ff       	call   c0101ec8 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102967:	5c                   	pop    %esp

c0102968 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102968:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102969:	0f a9                	pop    %gs
    popl %fs
c010296b:	0f a1                	pop    %fs
    popl %es
c010296d:	07                   	pop    %es
    popl %ds
c010296e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010296f:	83 c4 08             	add    $0x8,%esp
    iret
c0102972:	cf                   	iret   

c0102973 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102973:	55                   	push   %ebp
c0102974:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102976:	8b 45 08             	mov    0x8(%ebp),%eax
c0102979:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c010297f:	29 d0                	sub    %edx,%eax
c0102981:	c1 f8 02             	sar    $0x2,%eax
c0102984:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010298a:	5d                   	pop    %ebp
c010298b:	c3                   	ret    

c010298c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010298c:	55                   	push   %ebp
c010298d:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c010298f:	ff 75 08             	pushl  0x8(%ebp)
c0102992:	e8 dc ff ff ff       	call   c0102973 <page2ppn>
c0102997:	83 c4 04             	add    $0x4,%esp
c010299a:	c1 e0 0c             	shl    $0xc,%eax
}
c010299d:	c9                   	leave  
c010299e:	c3                   	ret    

c010299f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010299f:	55                   	push   %ebp
c01029a0:	89 e5                	mov    %esp,%ebp
c01029a2:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01029a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a8:	c1 e8 0c             	shr    $0xc,%eax
c01029ab:	89 c2                	mov    %eax,%edx
c01029ad:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01029b2:	39 c2                	cmp    %eax,%edx
c01029b4:	72 14                	jb     c01029ca <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01029b6:	83 ec 04             	sub    $0x4,%esp
c01029b9:	68 70 63 10 c0       	push   $0xc0106370
c01029be:	6a 5a                	push   $0x5a
c01029c0:	68 8f 63 10 c0       	push   $0xc010638f
c01029c5:	e8 0b da ff ff       	call   c01003d5 <__panic>
    }
    return &pages[PPN(pa)];
c01029ca:	8b 0d b8 89 11 c0    	mov    0xc01189b8,%ecx
c01029d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d3:	c1 e8 0c             	shr    $0xc,%eax
c01029d6:	89 c2                	mov    %eax,%edx
c01029d8:	89 d0                	mov    %edx,%eax
c01029da:	c1 e0 02             	shl    $0x2,%eax
c01029dd:	01 d0                	add    %edx,%eax
c01029df:	c1 e0 02             	shl    $0x2,%eax
c01029e2:	01 c8                	add    %ecx,%eax
}
c01029e4:	c9                   	leave  
c01029e5:	c3                   	ret    

c01029e6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01029e6:	55                   	push   %ebp
c01029e7:	89 e5                	mov    %esp,%ebp
c01029e9:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01029ec:	ff 75 08             	pushl  0x8(%ebp)
c01029ef:	e8 98 ff ff ff       	call   c010298c <page2pa>
c01029f4:	83 c4 04             	add    $0x4,%esp
c01029f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029fd:	c1 e8 0c             	shr    $0xc,%eax
c0102a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a03:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102a08:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102a0b:	72 14                	jb     c0102a21 <page2kva+0x3b>
c0102a0d:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a10:	68 a0 63 10 c0       	push   $0xc01063a0
c0102a15:	6a 61                	push   $0x61
c0102a17:	68 8f 63 10 c0       	push   $0xc010638f
c0102a1c:	e8 b4 d9 ff ff       	call   c01003d5 <__panic>
c0102a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a24:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a29:	c9                   	leave  
c0102a2a:	c3                   	ret    

c0102a2b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a2b:	55                   	push   %ebp
c0102a2c:	89 e5                	mov    %esp,%ebp
c0102a2e:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a34:	83 e0 01             	and    $0x1,%eax
c0102a37:	85 c0                	test   %eax,%eax
c0102a39:	75 14                	jne    c0102a4f <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102a3b:	83 ec 04             	sub    $0x4,%esp
c0102a3e:	68 c4 63 10 c0       	push   $0xc01063c4
c0102a43:	6a 6c                	push   $0x6c
c0102a45:	68 8f 63 10 c0       	push   $0xc010638f
c0102a4a:	e8 86 d9 ff ff       	call   c01003d5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102a4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a57:	83 ec 0c             	sub    $0xc,%esp
c0102a5a:	50                   	push   %eax
c0102a5b:	e8 3f ff ff ff       	call   c010299f <pa2page>
c0102a60:	83 c4 10             	add    $0x10,%esp
}
c0102a63:	c9                   	leave  
c0102a64:	c3                   	ret    

c0102a65 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102a65:	55                   	push   %ebp
c0102a66:	89 e5                	mov    %esp,%ebp
c0102a68:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a73:	83 ec 0c             	sub    $0xc,%esp
c0102a76:	50                   	push   %eax
c0102a77:	e8 23 ff ff ff       	call   c010299f <pa2page>
c0102a7c:	83 c4 10             	add    $0x10,%esp
}
c0102a7f:	c9                   	leave  
c0102a80:	c3                   	ret    

c0102a81 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102a81:	55                   	push   %ebp
c0102a82:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a87:	8b 00                	mov    (%eax),%eax
}
c0102a89:	5d                   	pop    %ebp
c0102a8a:	c3                   	ret    

c0102a8b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a8b:	55                   	push   %ebp
c0102a8c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a91:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a94:	89 10                	mov    %edx,(%eax)
}
c0102a96:	90                   	nop
c0102a97:	5d                   	pop    %ebp
c0102a98:	c3                   	ret    

c0102a99 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102a99:	55                   	push   %ebp
c0102a9a:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9f:	8b 00                	mov    (%eax),%eax
c0102aa1:	8d 50 01             	lea    0x1(%eax),%edx
c0102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aac:	8b 00                	mov    (%eax),%eax
}
c0102aae:	5d                   	pop    %ebp
c0102aaf:	c3                   	ret    

c0102ab0 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102ab0:	55                   	push   %ebp
c0102ab1:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab6:	8b 00                	mov    (%eax),%eax
c0102ab8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102abe:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac3:	8b 00                	mov    (%eax),%eax
}
c0102ac5:	5d                   	pop    %ebp
c0102ac6:	c3                   	ret    

c0102ac7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0102ac7:	55                   	push   %ebp
c0102ac8:	89 e5                	mov    %esp,%ebp
c0102aca:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102acd:	9c                   	pushf  
c0102ace:	58                   	pop    %eax
c0102acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102ad5:	25 00 02 00 00       	and    $0x200,%eax
c0102ada:	85 c0                	test   %eax,%eax
c0102adc:	74 0c                	je     c0102aea <__intr_save+0x23>
        intr_disable();
c0102ade:	e8 93 ed ff ff       	call   c0101876 <intr_disable>
        return 1;
c0102ae3:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ae8:	eb 05                	jmp    c0102aef <__intr_save+0x28>
    }
    return 0;
c0102aea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102aef:	c9                   	leave  
c0102af0:	c3                   	ret    

c0102af1 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102af1:	55                   	push   %ebp
c0102af2:	89 e5                	mov    %esp,%ebp
c0102af4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102af7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102afb:	74 05                	je     c0102b02 <__intr_restore+0x11>
        intr_enable();
c0102afd:	e8 6d ed ff ff       	call   c010186f <intr_enable>
    }
}
c0102b02:	90                   	nop
c0102b03:	c9                   	leave  
c0102b04:	c3                   	ret    

c0102b05 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102b05:	55                   	push   %ebp
c0102b06:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b0b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102b0e:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b13:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b15:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b1a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b1c:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b21:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b23:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b28:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b2a:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b2f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b31:	ea 38 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b38
}
c0102b38:	90                   	nop
c0102b39:	5d                   	pop    %ebp
c0102b3a:	c3                   	ret    

c0102b3b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b3b:	55                   	push   %ebp
c0102b3c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b41:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102b46:	90                   	nop
c0102b47:	5d                   	pop    %ebp
c0102b48:	c3                   	ret    

c0102b49 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b49:	55                   	push   %ebp
c0102b4a:	89 e5                	mov    %esp,%ebp
c0102b4c:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b4f:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102b54:	50                   	push   %eax
c0102b55:	e8 e1 ff ff ff       	call   c0102b3b <load_esp0>
c0102b5a:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102b5d:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102b64:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b66:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102b6d:	68 00 
c0102b6f:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b74:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102b7a:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b7f:	c1 e8 10             	shr    $0x10,%eax
c0102b82:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102b87:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b8e:	83 e0 f0             	and    $0xfffffff0,%eax
c0102b91:	83 c8 09             	or     $0x9,%eax
c0102b94:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b99:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ba0:	83 e0 ef             	and    $0xffffffef,%eax
c0102ba3:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ba8:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102baf:	83 e0 9f             	and    $0xffffff9f,%eax
c0102bb2:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102bb7:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102bbe:	83 c8 80             	or     $0xffffff80,%eax
c0102bc1:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102bc6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bcd:	83 e0 f0             	and    $0xfffffff0,%eax
c0102bd0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bd5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bdc:	83 e0 ef             	and    $0xffffffef,%eax
c0102bdf:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102be4:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102beb:	83 e0 df             	and    $0xffffffdf,%eax
c0102bee:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bf3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bfa:	83 c8 40             	or     $0x40,%eax
c0102bfd:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c02:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c09:	83 e0 7f             	and    $0x7f,%eax
c0102c0c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c11:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102c16:	c1 e8 18             	shr    $0x18,%eax
c0102c19:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c1e:	68 30 7a 11 c0       	push   $0xc0117a30
c0102c23:	e8 dd fe ff ff       	call   c0102b05 <lgdt>
c0102c28:	83 c4 04             	add    $0x4,%esp
c0102c2b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c31:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c35:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102c38:	90                   	nop
c0102c39:	c9                   	leave  
c0102c3a:	c3                   	ret    

c0102c3b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c3b:	55                   	push   %ebp
c0102c3c:	89 e5                	mov    %esp,%ebp
c0102c3e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102c41:	c7 05 b0 89 11 c0 50 	movl   $0xc0106d50,0xc01189b0
c0102c48:	6d 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c4b:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c50:	8b 00                	mov    (%eax),%eax
c0102c52:	83 ec 08             	sub    $0x8,%esp
c0102c55:	50                   	push   %eax
c0102c56:	68 f0 63 10 c0       	push   $0xc01063f0
c0102c5b:	e8 0f d6 ff ff       	call   c010026f <cprintf>
c0102c60:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102c63:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c68:	8b 40 04             	mov    0x4(%eax),%eax
c0102c6b:	ff d0                	call   *%eax
}
c0102c6d:	90                   	nop
c0102c6e:	c9                   	leave  
c0102c6f:	c3                   	ret    

c0102c70 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102c70:	55                   	push   %ebp
c0102c71:	89 e5                	mov    %esp,%ebp
c0102c73:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102c76:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c7b:	8b 40 08             	mov    0x8(%eax),%eax
c0102c7e:	83 ec 08             	sub    $0x8,%esp
c0102c81:	ff 75 0c             	pushl  0xc(%ebp)
c0102c84:	ff 75 08             	pushl  0x8(%ebp)
c0102c87:	ff d0                	call   *%eax
c0102c89:	83 c4 10             	add    $0x10,%esp
}
c0102c8c:	90                   	nop
c0102c8d:	c9                   	leave  
c0102c8e:	c3                   	ret    

c0102c8f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102c8f:	55                   	push   %ebp
c0102c90:	89 e5                	mov    %esp,%ebp
c0102c92:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102c95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);     // save interrupt state
c0102c9c:	e8 26 fe ff ff       	call   c0102ac7 <__intr_save>
c0102ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102ca4:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102ca9:	8b 40 0c             	mov    0xc(%eax),%eax
c0102cac:	83 ec 0c             	sub    $0xc,%esp
c0102caf:	ff 75 08             	pushl  0x8(%ebp)
c0102cb2:	ff d0                	call   *%eax
c0102cb4:	83 c4 10             	add    $0x10,%esp
c0102cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102cba:	83 ec 0c             	sub    $0xc,%esp
c0102cbd:	ff 75 f0             	pushl  -0x10(%ebp)
c0102cc0:	e8 2c fe ff ff       	call   c0102af1 <__intr_restore>
c0102cc5:	83 c4 10             	add    $0x10,%esp
    return page;
c0102cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102ccb:	c9                   	leave  
c0102ccc:	c3                   	ret    

c0102ccd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102ccd:	55                   	push   %ebp
c0102cce:	89 e5                	mov    %esp,%ebp
c0102cd0:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cd3:	e8 ef fd ff ff       	call   c0102ac7 <__intr_save>
c0102cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102cdb:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102ce0:	8b 40 10             	mov    0x10(%eax),%eax
c0102ce3:	83 ec 08             	sub    $0x8,%esp
c0102ce6:	ff 75 0c             	pushl  0xc(%ebp)
c0102ce9:	ff 75 08             	pushl  0x8(%ebp)
c0102cec:	ff d0                	call   *%eax
c0102cee:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102cf1:	83 ec 0c             	sub    $0xc,%esp
c0102cf4:	ff 75 f4             	pushl  -0xc(%ebp)
c0102cf7:	e8 f5 fd ff ff       	call   c0102af1 <__intr_restore>
c0102cfc:	83 c4 10             	add    $0x10,%esp
}
c0102cff:	90                   	nop
c0102d00:	c9                   	leave  
c0102d01:	c3                   	ret    

c0102d02 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102d02:	55                   	push   %ebp
c0102d03:	89 e5                	mov    %esp,%ebp
c0102d05:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d08:	e8 ba fd ff ff       	call   c0102ac7 <__intr_save>
c0102d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d10:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102d15:	8b 40 14             	mov    0x14(%eax),%eax
c0102d18:	ff d0                	call   *%eax
c0102d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d1d:	83 ec 0c             	sub    $0xc,%esp
c0102d20:	ff 75 f4             	pushl  -0xc(%ebp)
c0102d23:	e8 c9 fd ff ff       	call   c0102af1 <__intr_restore>
c0102d28:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d2e:	c9                   	leave  
c0102d2f:	c3                   	ret    

c0102d30 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d30:	55                   	push   %ebp
c0102d31:	89 e5                	mov    %esp,%ebp
c0102d33:	57                   	push   %edi
c0102d34:	56                   	push   %esi
c0102d35:	53                   	push   %ebx
c0102d36:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d39:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d4e:	83 ec 0c             	sub    $0xc,%esp
c0102d51:	68 07 64 10 c0       	push   $0xc0106407
c0102d56:	e8 14 d5 ff ff       	call   c010026f <cprintf>
c0102d5b:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d65:	e9 fc 00 00 00       	jmp    c0102e66 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d70:	89 d0                	mov    %edx,%eax
c0102d72:	c1 e0 02             	shl    $0x2,%eax
c0102d75:	01 d0                	add    %edx,%eax
c0102d77:	c1 e0 02             	shl    $0x2,%eax
c0102d7a:	01 c8                	add    %ecx,%eax
c0102d7c:	8b 50 08             	mov    0x8(%eax),%edx
c0102d7f:	8b 40 04             	mov    0x4(%eax),%eax
c0102d82:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102d85:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102d88:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d8e:	89 d0                	mov    %edx,%eax
c0102d90:	c1 e0 02             	shl    $0x2,%eax
c0102d93:	01 d0                	add    %edx,%eax
c0102d95:	c1 e0 02             	shl    $0x2,%eax
c0102d98:	01 c8                	add    %ecx,%eax
c0102d9a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102d9d:	8b 58 10             	mov    0x10(%eax),%ebx
c0102da0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102da3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102da6:	01 c8                	add    %ecx,%eax
c0102da8:	11 da                	adc    %ebx,%edx
c0102daa:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102dad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102db0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102db3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102db6:	89 d0                	mov    %edx,%eax
c0102db8:	c1 e0 02             	shl    $0x2,%eax
c0102dbb:	01 d0                	add    %edx,%eax
c0102dbd:	c1 e0 02             	shl    $0x2,%eax
c0102dc0:	01 c8                	add    %ecx,%eax
c0102dc2:	83 c0 14             	add    $0x14,%eax
c0102dc5:	8b 00                	mov    (%eax),%eax
c0102dc7:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102dca:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102dcd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102dd0:	83 c0 ff             	add    $0xffffffff,%eax
c0102dd3:	83 d2 ff             	adc    $0xffffffff,%edx
c0102dd6:	89 c1                	mov    %eax,%ecx
c0102dd8:	89 d3                	mov    %edx,%ebx
c0102dda:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ddd:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102de0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102de3:	89 d0                	mov    %edx,%eax
c0102de5:	c1 e0 02             	shl    $0x2,%eax
c0102de8:	01 d0                	add    %edx,%eax
c0102dea:	c1 e0 02             	shl    $0x2,%eax
c0102ded:	03 45 80             	add    -0x80(%ebp),%eax
c0102df0:	8b 50 10             	mov    0x10(%eax),%edx
c0102df3:	8b 40 0c             	mov    0xc(%eax),%eax
c0102df6:	ff 75 84             	pushl  -0x7c(%ebp)
c0102df9:	53                   	push   %ebx
c0102dfa:	51                   	push   %ecx
c0102dfb:	ff 75 bc             	pushl  -0x44(%ebp)
c0102dfe:	ff 75 b8             	pushl  -0x48(%ebp)
c0102e01:	52                   	push   %edx
c0102e02:	50                   	push   %eax
c0102e03:	68 14 64 10 c0       	push   $0xc0106414
c0102e08:	e8 62 d4 ff ff       	call   c010026f <cprintf>
c0102e0d:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e10:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e13:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e16:	89 d0                	mov    %edx,%eax
c0102e18:	c1 e0 02             	shl    $0x2,%eax
c0102e1b:	01 d0                	add    %edx,%eax
c0102e1d:	c1 e0 02             	shl    $0x2,%eax
c0102e20:	01 c8                	add    %ecx,%eax
c0102e22:	83 c0 14             	add    $0x14,%eax
c0102e25:	8b 00                	mov    (%eax),%eax
c0102e27:	83 f8 01             	cmp    $0x1,%eax
c0102e2a:	75 36                	jne    c0102e62 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e32:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e35:	77 2b                	ja     c0102e62 <page_init+0x132>
c0102e37:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e3a:	72 05                	jb     c0102e41 <page_init+0x111>
c0102e3c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102e3f:	73 21                	jae    c0102e62 <page_init+0x132>
c0102e41:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e45:	77 1b                	ja     c0102e62 <page_init+0x132>
c0102e47:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e4b:	72 09                	jb     c0102e56 <page_init+0x126>
c0102e4d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102e54:	77 0c                	ja     c0102e62 <page_init+0x132>
                maxpa = end;
c0102e56:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e59:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e62:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e69:	8b 00                	mov    (%eax),%eax
c0102e6b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102e6e:	0f 8f f6 fe ff ff    	jg     c0102d6a <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102e78:	72 1d                	jb     c0102e97 <page_init+0x167>
c0102e7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102e7e:	77 09                	ja     c0102e89 <page_init+0x159>
c0102e80:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102e87:	76 0e                	jbe    c0102e97 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102e89:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102e90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
c0102e97:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e9d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102ea1:	c1 ea 0c             	shr    $0xc,%edx
c0102ea4:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102ea9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102eb0:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c0102eb5:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102eb8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102ebb:	01 d0                	add    %edx,%eax
c0102ebd:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102ec0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102ec3:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ec8:	f7 75 ac             	divl   -0x54(%ebp)
c0102ecb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102ece:	29 d0                	sub    %edx,%eax
c0102ed0:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    for (i = 0; i < npage; i ++) {
c0102ed5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102edc:	eb 2f                	jmp    c0102f0d <page_init+0x1dd>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
c0102ede:	8b 0d b8 89 11 c0    	mov    0xc01189b8,%ecx
c0102ee4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ee7:	89 d0                	mov    %edx,%eax
c0102ee9:	c1 e0 02             	shl    $0x2,%eax
c0102eec:	01 d0                	add    %edx,%eax
c0102eee:	c1 e0 02             	shl    $0x2,%eax
c0102ef1:	01 c8                	add    %ecx,%eax
c0102ef3:	83 c0 04             	add    $0x4,%eax
c0102ef6:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102efd:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f00:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f03:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f06:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102f09:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102f0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f10:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102f15:	39 c2                	cmp    %eax,%edx
c0102f17:	72 c5                	jb     c0102ede <page_init+0x1ae>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt
c0102f19:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f1f:	89 d0                	mov    %edx,%eax
c0102f21:	c1 e0 02             	shl    $0x2,%eax
c0102f24:	01 d0                	add    %edx,%eax
c0102f26:	c1 e0 02             	shl    $0x2,%eax
c0102f29:	89 c2                	mov    %eax,%edx
c0102f2b:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102f30:	01 d0                	add    %edx,%eax
c0102f32:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102f35:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102f3c:	77 17                	ja     c0102f55 <page_init+0x225>
c0102f3e:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102f41:	68 44 64 10 c0       	push   $0xc0106444
c0102f46:	68 dc 00 00 00       	push   $0xdc
c0102f4b:	68 68 64 10 c0       	push   $0xc0106468
c0102f50:	e8 80 d4 ff ff       	call   c01003d5 <__panic>
c0102f55:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f58:	05 00 00 00 40       	add    $0x40000000,%eax
c0102f5d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102f60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f67:	e9 69 01 00 00       	jmp    c01030d5 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f6c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f6f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f72:	89 d0                	mov    %edx,%eax
c0102f74:	c1 e0 02             	shl    $0x2,%eax
c0102f77:	01 d0                	add    %edx,%eax
c0102f79:	c1 e0 02             	shl    $0x2,%eax
c0102f7c:	01 c8                	add    %ecx,%eax
c0102f7e:	8b 50 08             	mov    0x8(%eax),%edx
c0102f81:	8b 40 04             	mov    0x4(%eax),%eax
c0102f84:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102f8a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f90:	89 d0                	mov    %edx,%eax
c0102f92:	c1 e0 02             	shl    $0x2,%eax
c0102f95:	01 d0                	add    %edx,%eax
c0102f97:	c1 e0 02             	shl    $0x2,%eax
c0102f9a:	01 c8                	add    %ecx,%eax
c0102f9c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102f9f:	8b 58 10             	mov    0x10(%eax),%ebx
c0102fa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fa8:	01 c8                	add    %ecx,%eax
c0102faa:	11 da                	adc    %ebx,%edx
c0102fac:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102faf:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102fb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fb8:	89 d0                	mov    %edx,%eax
c0102fba:	c1 e0 02             	shl    $0x2,%eax
c0102fbd:	01 d0                	add    %edx,%eax
c0102fbf:	c1 e0 02             	shl    $0x2,%eax
c0102fc2:	01 c8                	add    %ecx,%eax
c0102fc4:	83 c0 14             	add    $0x14,%eax
c0102fc7:	8b 00                	mov    (%eax),%eax
c0102fc9:	83 f8 01             	cmp    $0x1,%eax
c0102fcc:	0f 85 ff 00 00 00    	jne    c01030d1 <page_init+0x3a1>
            if (begin < freemem) {
c0102fd2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fd5:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fda:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102fdd:	72 17                	jb     c0102ff6 <page_init+0x2c6>
c0102fdf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102fe2:	77 05                	ja     c0102fe9 <page_init+0x2b9>
c0102fe4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102fe7:	76 0d                	jbe    c0102ff6 <page_init+0x2c6>
                begin = freemem;
c0102fe9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fec:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fef:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102ff6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ffa:	72 1d                	jb     c0103019 <page_init+0x2e9>
c0102ffc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103000:	77 09                	ja     c010300b <page_init+0x2db>
c0103002:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103009:	76 0e                	jbe    c0103019 <page_init+0x2e9>
                end = KMEMSIZE;
c010300b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103012:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103019:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010301c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010301f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103022:	0f 87 a9 00 00 00    	ja     c01030d1 <page_init+0x3a1>
c0103028:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010302b:	72 09                	jb     c0103036 <page_init+0x306>
c010302d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103030:	0f 83 9b 00 00 00    	jae    c01030d1 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0103036:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010303d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103040:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103043:	01 d0                	add    %edx,%eax
c0103045:	83 e8 01             	sub    $0x1,%eax
c0103048:	89 45 98             	mov    %eax,-0x68(%ebp)
c010304b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010304e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103053:	f7 75 9c             	divl   -0x64(%ebp)
c0103056:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103059:	29 d0                	sub    %edx,%eax
c010305b:	ba 00 00 00 00       	mov    $0x0,%edx
c0103060:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103063:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103066:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103069:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010306c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010306f:	ba 00 00 00 00       	mov    $0x0,%edx
c0103074:	89 c3                	mov    %eax,%ebx
c0103076:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010307c:	89 de                	mov    %ebx,%esi
c010307e:	89 d0                	mov    %edx,%eax
c0103080:	83 e0 00             	and    $0x0,%eax
c0103083:	89 c7                	mov    %eax,%edi
c0103085:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103088:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c010308b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010308e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103091:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103094:	77 3b                	ja     c01030d1 <page_init+0x3a1>
c0103096:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103099:	72 05                	jb     c01030a0 <page_init+0x370>
c010309b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010309e:	73 31                	jae    c01030d1 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01030a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030a3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01030a6:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01030a9:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01030ac:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01030b0:	c1 ea 0c             	shr    $0xc,%edx
c01030b3:	89 c3                	mov    %eax,%ebx
c01030b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030b8:	83 ec 0c             	sub    $0xc,%esp
c01030bb:	50                   	push   %eax
c01030bc:	e8 de f8 ff ff       	call   c010299f <pa2page>
c01030c1:	83 c4 10             	add    $0x10,%esp
c01030c4:	83 ec 08             	sub    $0x8,%esp
c01030c7:	53                   	push   %ebx
c01030c8:	50                   	push   %eax
c01030c9:	e8 a2 fb ff ff       	call   c0102c70 <init_memmap>
c01030ce:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt

    for (i = 0; i < memmap->nr_map; i ++) {
c01030d1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01030d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030d8:	8b 00                	mov    (%eax),%eax
c01030da:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01030dd:	0f 8f 89 fe ff ff    	jg     c0102f6c <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01030e3:	90                   	nop
c01030e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01030e7:	5b                   	pop    %ebx
c01030e8:	5e                   	pop    %esi
c01030e9:	5f                   	pop    %edi
c01030ea:	5d                   	pop    %ebp
c01030eb:	c3                   	ret    

c01030ec <enable_paging>:

static void
enable_paging(void) {
c01030ec:	55                   	push   %ebp
c01030ed:	89 e5                	mov    %esp,%ebp
c01030ef:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01030f2:	a1 b4 89 11 c0       	mov    0xc01189b4,%eax
c01030f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01030fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01030fd:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103100:	0f 20 c0             	mov    %cr0,%eax
c0103103:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103106:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103109:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010310c:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103113:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0103117:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010311a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103120:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103123:	90                   	nop
c0103124:	c9                   	leave  
c0103125:	c3                   	ret    

c0103126 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103126:	55                   	push   %ebp
c0103127:	89 e5                	mov    %esp,%ebp
c0103129:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010312c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010312f:	33 45 14             	xor    0x14(%ebp),%eax
c0103132:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103137:	85 c0                	test   %eax,%eax
c0103139:	74 19                	je     c0103154 <boot_map_segment+0x2e>
c010313b:	68 76 64 10 c0       	push   $0xc0106476
c0103140:	68 8d 64 10 c0       	push   $0xc010648d
c0103145:	68 05 01 00 00       	push   $0x105
c010314a:	68 68 64 10 c0       	push   $0xc0106468
c010314f:	e8 81 d2 ff ff       	call   c01003d5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103154:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010315b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010315e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103163:	89 c2                	mov    %eax,%edx
c0103165:	8b 45 10             	mov    0x10(%ebp),%eax
c0103168:	01 c2                	add    %eax,%edx
c010316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010316d:	01 d0                	add    %edx,%eax
c010316f:	83 e8 01             	sub    $0x1,%eax
c0103172:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103175:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103178:	ba 00 00 00 00       	mov    $0x0,%edx
c010317d:	f7 75 f0             	divl   -0x10(%ebp)
c0103180:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103183:	29 d0                	sub    %edx,%eax
c0103185:	c1 e8 0c             	shr    $0xc,%eax
c0103188:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010318b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010318e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103191:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103194:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103199:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010319c:	8b 45 14             	mov    0x14(%ebp),%eax
c010319f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01031a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01031aa:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031ad:	eb 57                	jmp    c0103206 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01031af:	83 ec 04             	sub    $0x4,%esp
c01031b2:	6a 01                	push   $0x1
c01031b4:	ff 75 0c             	pushl  0xc(%ebp)
c01031b7:	ff 75 08             	pushl  0x8(%ebp)
c01031ba:	e8 98 01 00 00       	call   c0103357 <get_pte>
c01031bf:	83 c4 10             	add    $0x10,%esp
c01031c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01031c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01031c9:	75 19                	jne    c01031e4 <boot_map_segment+0xbe>
c01031cb:	68 a2 64 10 c0       	push   $0xc01064a2
c01031d0:	68 8d 64 10 c0       	push   $0xc010648d
c01031d5:	68 0b 01 00 00       	push   $0x10b
c01031da:	68 68 64 10 c0       	push   $0xc0106468
c01031df:	e8 f1 d1 ff ff       	call   c01003d5 <__panic>
        *ptep = pa | PTE_P | perm;
c01031e4:	8b 45 14             	mov    0x14(%ebp),%eax
c01031e7:	0b 45 18             	or     0x18(%ebp),%eax
c01031ea:	83 c8 01             	or     $0x1,%eax
c01031ed:	89 c2                	mov    %eax,%edx
c01031ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031f2:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01031f8:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01031ff:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010320a:	75 a3                	jne    c01031af <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010320c:	90                   	nop
c010320d:	c9                   	leave  
c010320e:	c3                   	ret    

c010320f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010320f:	55                   	push   %ebp
c0103210:	89 e5                	mov    %esp,%ebp
c0103212:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0103215:	83 ec 0c             	sub    $0xc,%esp
c0103218:	6a 01                	push   $0x1
c010321a:	e8 70 fa ff ff       	call   c0102c8f <alloc_pages>
c010321f:	83 c4 10             	add    $0x10,%esp
c0103222:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103229:	75 17                	jne    c0103242 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c010322b:	83 ec 04             	sub    $0x4,%esp
c010322e:	68 af 64 10 c0       	push   $0xc01064af
c0103233:	68 17 01 00 00       	push   $0x117
c0103238:	68 68 64 10 c0       	push   $0xc0106468
c010323d:	e8 93 d1 ff ff       	call   c01003d5 <__panic>
    }
    return page2kva(p);     // va = pa + KERNELBASE(0x C000 0000)
c0103242:	83 ec 0c             	sub    $0xc,%esp
c0103245:	ff 75 f4             	pushl  -0xc(%ebp)
c0103248:	e8 99 f7 ff ff       	call   c01029e6 <page2kva>
c010324d:	83 c4 10             	add    $0x10,%esp
}
c0103250:	c9                   	leave  
c0103251:	c3                   	ret    

c0103252 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103252:	55                   	push   %ebp
c0103253:	89 e5                	mov    %esp,%ebp
c0103255:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103258:	e8 de f9 ff ff       	call   c0102c3b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010325d:	e8 ce fa ff ff       	call   c0102d30 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103262:	e8 38 04 00 00       	call   c010369f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0103267:	e8 a3 ff ff ff       	call   c010320f <boot_alloc_page>
c010326c:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0103271:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103276:	83 ec 04             	sub    $0x4,%esp
c0103279:	68 00 10 00 00       	push   $0x1000
c010327e:	6a 00                	push   $0x0
c0103280:	50                   	push   %eax
c0103281:	e8 13 22 00 00       	call   c0105499 <memset>
c0103286:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);   // paddr of pgdir
c0103289:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103291:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103298:	77 17                	ja     c01032b1 <pmm_init+0x5f>
c010329a:	ff 75 f4             	pushl  -0xc(%ebp)
c010329d:	68 44 64 10 c0       	push   $0xc0106444
c01032a2:	68 31 01 00 00       	push   $0x131
c01032a7:	68 68 64 10 c0       	push   $0xc0106468
c01032ac:	e8 24 d1 ff ff       	call   c01003d5 <__panic>
c01032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032b4:	05 00 00 00 40       	add    $0x40000000,%eax
c01032b9:	a3 b4 89 11 c0       	mov    %eax,0xc01189b4

    check_pgdir();
c01032be:	e8 ff 03 00 00       	call   c01036c2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01032c3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032c8:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01032ce:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032d6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01032dd:	77 17                	ja     c01032f6 <pmm_init+0xa4>
c01032df:	ff 75 f0             	pushl  -0x10(%ebp)
c01032e2:	68 44 64 10 c0       	push   $0xc0106444
c01032e7:	68 39 01 00 00       	push   $0x139
c01032ec:	68 68 64 10 c0       	push   $0xc0106468
c01032f1:	e8 df d0 ff ff       	call   c01003d5 <__panic>
c01032f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032f9:	05 00 00 00 40       	add    $0x40000000,%eax
c01032fe:	83 c8 03             	or     $0x3,%eax
c0103301:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103303:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103308:	83 ec 0c             	sub    $0xc,%esp
c010330b:	6a 02                	push   $0x2
c010330d:	6a 00                	push   $0x0
c010330f:	68 00 00 00 38       	push   $0x38000000
c0103314:	68 00 00 00 c0       	push   $0xc0000000
c0103319:	50                   	push   %eax
c010331a:	e8 07 fe ff ff       	call   c0103126 <boot_map_segment>
c010331f:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103322:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103327:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c010332d:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103333:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103335:	e8 b2 fd ff ff       	call   c01030ec <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010333a:	e8 0a f8 ff ff       	call   c0102b49 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010333f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010334a:	e8 d9 08 00 00       	call   c0103c28 <check_boot_pgdir>

    print_pgdir();
c010334f:	e8 cf 0c 00 00       	call   c0104023 <print_pgdir>

}
c0103354:	90                   	nop
c0103355:	c9                   	leave  
c0103356:	c3                   	ret    

c0103357 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103357:	55                   	push   %ebp
c0103358:	89 e5                	mov    %esp,%ebp
c010335a:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
c010335d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103360:	c1 e8 16             	shr    $0x16,%eax
c0103363:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
c0103366:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103369:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103370:	8b 45 08             	mov    0x8(%ebp),%eax
c0103373:	01 d0                	add    %edx,%eax
c0103375:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
c0103378:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010337b:	8b 00                	mov    (%eax),%eax
c010337d:	83 e0 01             	and    $0x1,%eax
c0103380:	85 c0                	test   %eax,%eax
c0103382:	0f 85 ae 00 00 00    	jne    c0103436 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
c0103388:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010338c:	75 0a                	jne    c0103398 <get_pte+0x41>
            return NULL;
c010338e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103393:	e9 01 01 00 00       	jmp    c0103499 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
c0103398:	83 ec 0c             	sub    $0xc,%esp
c010339b:	6a 01                	push   $0x1
c010339d:	e8 ed f8 ff ff       	call   c0102c8f <alloc_pages>
c01033a2:	83 c4 10             	add    $0x10,%esp
c01033a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
c01033a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01033ac:	75 0a                	jne    c01033b8 <get_pte+0x61>
            return NULL;
c01033ae:	b8 00 00 00 00       	mov    $0x0,%eax
c01033b3:	e9 e1 00 00 00       	jmp    c0103499 <get_pte+0x142>
        }

        // (4) set page reference
        set_page_ref(pt_page, 1);
c01033b8:	83 ec 08             	sub    $0x8,%esp
c01033bb:	6a 01                	push   $0x1
c01033bd:	ff 75 ec             	pushl  -0x14(%ebp)
c01033c0:	e8 c6 f6 ff ff       	call   c0102a8b <set_page_ref>
c01033c5:	83 c4 10             	add    $0x10,%esp

        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
c01033c8:	83 ec 0c             	sub    $0xc,%esp
c01033cb:	ff 75 ec             	pushl  -0x14(%ebp)
c01033ce:	e8 b9 f5 ff ff       	call   c010298c <page2pa>
c01033d3:	83 c4 10             	add    $0x10,%esp
c01033d6:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
c01033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033e2:	c1 e8 0c             	shr    $0xc,%eax
c01033e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01033e8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01033ed:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01033f0:	72 17                	jb     c0103409 <get_pte+0xb2>
c01033f2:	ff 75 e4             	pushl  -0x1c(%ebp)
c01033f5:	68 a0 63 10 c0       	push   $0xc01063a0
c01033fa:	68 97 01 00 00       	push   $0x197
c01033ff:	68 68 64 10 c0       	push   $0xc0106468
c0103404:	e8 cc cf ff ff       	call   c01003d5 <__panic>
c0103409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010340c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103411:	83 ec 04             	sub    $0x4,%esp
c0103414:	68 00 10 00 00       	push   $0x1000
c0103419:	6a 00                	push   $0x0
c010341b:	50                   	push   %eax
c010341c:	e8 78 20 00 00       	call   c0105499 <memset>
c0103421:	83 c4 10             	add    $0x10,%esp

        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
c0103424:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103427:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010342c:	83 c8 07             	or     $0x7,%eax
c010342f:	89 c2                	mov    %eax,%edx
c0103431:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103434:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
c0103436:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103439:	c1 e8 0c             	shr    $0xc,%eax
c010343c:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103441:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
c0103444:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103447:	8b 00                	mov    (%eax),%eax
c0103449:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010344e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
c0103451:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103454:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103457:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010345a:	c1 e8 0c             	shr    $0xc,%eax
c010345d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103460:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103465:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103468:	72 17                	jb     c0103481 <get_pte+0x12a>
c010346a:	ff 75 d4             	pushl  -0x2c(%ebp)
c010346d:	68 a0 63 10 c0       	push   $0xc01063a0
c0103472:	68 9f 01 00 00       	push   $0x19f
c0103477:	68 68 64 10 c0       	push   $0xc0106468
c010347c:	e8 54 cf ff ff       	call   c01003d5 <__panic>
c0103481:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103484:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103489:	89 c2                	mov    %eax,%edx
c010348b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010348e:	c1 e0 02             	shl    $0x2,%eax
c0103491:	01 d0                	add    %edx,%eax
c0103493:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
c0103496:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
c0103499:	c9                   	leave  
c010349a:	c3                   	ret    

c010349b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010349b:	55                   	push   %ebp
c010349c:	89 e5                	mov    %esp,%ebp
c010349e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01034a1:	83 ec 04             	sub    $0x4,%esp
c01034a4:	6a 00                	push   $0x0
c01034a6:	ff 75 0c             	pushl  0xc(%ebp)
c01034a9:	ff 75 08             	pushl  0x8(%ebp)
c01034ac:	e8 a6 fe ff ff       	call   c0103357 <get_pte>
c01034b1:	83 c4 10             	add    $0x10,%esp
c01034b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01034b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01034bb:	74 08                	je     c01034c5 <get_page+0x2a>
        *ptep_store = ptep;
c01034bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01034c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01034c3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01034c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034c9:	74 1f                	je     c01034ea <get_page+0x4f>
c01034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ce:	8b 00                	mov    (%eax),%eax
c01034d0:	83 e0 01             	and    $0x1,%eax
c01034d3:	85 c0                	test   %eax,%eax
c01034d5:	74 13                	je     c01034ea <get_page+0x4f>
        return pte2page(*ptep);
c01034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034da:	8b 00                	mov    (%eax),%eax
c01034dc:	83 ec 0c             	sub    $0xc,%esp
c01034df:	50                   	push   %eax
c01034e0:	e8 46 f5 ff ff       	call   c0102a2b <pte2page>
c01034e5:	83 c4 10             	add    $0x10,%esp
c01034e8:	eb 05                	jmp    c01034ef <get_page+0x54>
    }
    return NULL;
c01034ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01034ef:	c9                   	leave  
c01034f0:	c3                   	ret    

c01034f1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01034f1:	55                   	push   %ebp
c01034f2:	89 e5                	mov    %esp,%ebp
c01034f4:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
c01034f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01034fa:	8b 00                	mov    (%eax),%eax
c01034fc:	83 e0 01             	and    $0x1,%eax
c01034ff:	85 c0                	test   %eax,%eax
c0103501:	74 57                	je     c010355a <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
c0103503:	8b 45 10             	mov    0x10(%ebp),%eax
c0103506:	8b 00                	mov    (%eax),%eax
c0103508:	83 ec 0c             	sub    $0xc,%esp
c010350b:	50                   	push   %eax
c010350c:	e8 1a f5 ff ff       	call   c0102a2b <pte2page>
c0103511:	83 c4 10             	add    $0x10,%esp
c0103514:	89 45 f4             	mov    %eax,-0xc(%ebp)

    //(3) decrease page reference
    page_ref_dec(page);
c0103517:	83 ec 0c             	sub    $0xc,%esp
c010351a:	ff 75 f4             	pushl  -0xc(%ebp)
c010351d:	e8 8e f5 ff ff       	call   c0102ab0 <page_ref_dec>
c0103522:	83 c4 10             	add    $0x10,%esp

    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
c0103525:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103528:	8b 00                	mov    (%eax),%eax
c010352a:	85 c0                	test   %eax,%eax
c010352c:	75 10                	jne    c010353e <page_remove_pte+0x4d>
        free_page(page);
c010352e:	83 ec 08             	sub    $0x8,%esp
c0103531:	6a 01                	push   $0x1
c0103533:	ff 75 f4             	pushl  -0xc(%ebp)
c0103536:	e8 92 f7 ff ff       	call   c0102ccd <free_pages>
c010353b:	83 c4 10             	add    $0x10,%esp
    }

    //(5) clear second page table entry
    *ptep = 0;
c010353e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
c0103547:	83 ec 08             	sub    $0x8,%esp
c010354a:	ff 75 0c             	pushl  0xc(%ebp)
c010354d:	ff 75 08             	pushl  0x8(%ebp)
c0103550:	e8 fa 00 00 00       	call   c010364f <tlb_invalidate>
c0103555:	83 c4 10             	add    $0x10,%esp
c0103558:	eb 01                	jmp    c010355b <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
c010355a:	90                   	nop
    //(5) clear second page table entry
    *ptep = 0;

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
c010355b:	c9                   	leave  
c010355c:	c3                   	ret    

c010355d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010355d:	55                   	push   %ebp
c010355e:	89 e5                	mov    %esp,%ebp
c0103560:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103563:	83 ec 04             	sub    $0x4,%esp
c0103566:	6a 00                	push   $0x0
c0103568:	ff 75 0c             	pushl  0xc(%ebp)
c010356b:	ff 75 08             	pushl  0x8(%ebp)
c010356e:	e8 e4 fd ff ff       	call   c0103357 <get_pte>
c0103573:	83 c4 10             	add    $0x10,%esp
c0103576:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010357d:	74 14                	je     c0103593 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010357f:	83 ec 04             	sub    $0x4,%esp
c0103582:	ff 75 f4             	pushl  -0xc(%ebp)
c0103585:	ff 75 0c             	pushl  0xc(%ebp)
c0103588:	ff 75 08             	pushl  0x8(%ebp)
c010358b:	e8 61 ff ff ff       	call   c01034f1 <page_remove_pte>
c0103590:	83 c4 10             	add    $0x10,%esp
    }
}
c0103593:	90                   	nop
c0103594:	c9                   	leave  
c0103595:	c3                   	ret    

c0103596 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103596:	55                   	push   %ebp
c0103597:	89 e5                	mov    %esp,%ebp
c0103599:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010359c:	83 ec 04             	sub    $0x4,%esp
c010359f:	6a 01                	push   $0x1
c01035a1:	ff 75 10             	pushl  0x10(%ebp)
c01035a4:	ff 75 08             	pushl  0x8(%ebp)
c01035a7:	e8 ab fd ff ff       	call   c0103357 <get_pte>
c01035ac:	83 c4 10             	add    $0x10,%esp
c01035af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01035b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035b6:	75 0a                	jne    c01035c2 <page_insert+0x2c>
        return -E_NO_MEM;
c01035b8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01035bd:	e9 8b 00 00 00       	jmp    c010364d <page_insert+0xb7>
    }
    page_ref_inc(page);
c01035c2:	83 ec 0c             	sub    $0xc,%esp
c01035c5:	ff 75 0c             	pushl  0xc(%ebp)
c01035c8:	e8 cc f4 ff ff       	call   c0102a99 <page_ref_inc>
c01035cd:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d3:	8b 00                	mov    (%eax),%eax
c01035d5:	83 e0 01             	and    $0x1,%eax
c01035d8:	85 c0                	test   %eax,%eax
c01035da:	74 40                	je     c010361c <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035df:	8b 00                	mov    (%eax),%eax
c01035e1:	83 ec 0c             	sub    $0xc,%esp
c01035e4:	50                   	push   %eax
c01035e5:	e8 41 f4 ff ff       	call   c0102a2b <pte2page>
c01035ea:	83 c4 10             	add    $0x10,%esp
c01035ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01035f6:	75 10                	jne    c0103608 <page_insert+0x72>
            page_ref_dec(page);
c01035f8:	83 ec 0c             	sub    $0xc,%esp
c01035fb:	ff 75 0c             	pushl  0xc(%ebp)
c01035fe:	e8 ad f4 ff ff       	call   c0102ab0 <page_ref_dec>
c0103603:	83 c4 10             	add    $0x10,%esp
c0103606:	eb 14                	jmp    c010361c <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103608:	83 ec 04             	sub    $0x4,%esp
c010360b:	ff 75 f4             	pushl  -0xc(%ebp)
c010360e:	ff 75 10             	pushl  0x10(%ebp)
c0103611:	ff 75 08             	pushl  0x8(%ebp)
c0103614:	e8 d8 fe ff ff       	call   c01034f1 <page_remove_pte>
c0103619:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010361c:	83 ec 0c             	sub    $0xc,%esp
c010361f:	ff 75 0c             	pushl  0xc(%ebp)
c0103622:	e8 65 f3 ff ff       	call   c010298c <page2pa>
c0103627:	83 c4 10             	add    $0x10,%esp
c010362a:	0b 45 14             	or     0x14(%ebp),%eax
c010362d:	83 c8 01             	or     $0x1,%eax
c0103630:	89 c2                	mov    %eax,%edx
c0103632:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103635:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103637:	83 ec 08             	sub    $0x8,%esp
c010363a:	ff 75 10             	pushl  0x10(%ebp)
c010363d:	ff 75 08             	pushl  0x8(%ebp)
c0103640:	e8 0a 00 00 00       	call   c010364f <tlb_invalidate>
c0103645:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103648:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010364d:	c9                   	leave  
c010364e:	c3                   	ret    

c010364f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010364f:	55                   	push   %ebp
c0103650:	89 e5                	mov    %esp,%ebp
c0103652:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103655:	0f 20 d8             	mov    %cr3,%eax
c0103658:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c010365b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010365e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103661:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103664:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010366b:	77 17                	ja     c0103684 <tlb_invalidate+0x35>
c010366d:	ff 75 f0             	pushl  -0x10(%ebp)
c0103670:	68 44 64 10 c0       	push   $0xc0106444
c0103675:	68 0e 02 00 00       	push   $0x20e
c010367a:	68 68 64 10 c0       	push   $0xc0106468
c010367f:	e8 51 cd ff ff       	call   c01003d5 <__panic>
c0103684:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103687:	05 00 00 00 40       	add    $0x40000000,%eax
c010368c:	39 c2                	cmp    %eax,%edx
c010368e:	75 0c                	jne    c010369c <tlb_invalidate+0x4d>
        invlpg((void *)la);
c0103690:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103693:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103696:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103699:	0f 01 38             	invlpg (%eax)
    }
}
c010369c:	90                   	nop
c010369d:	c9                   	leave  
c010369e:	c3                   	ret    

c010369f <check_alloc_page>:

static void
check_alloc_page(void) {
c010369f:	55                   	push   %ebp
c01036a0:	89 e5                	mov    %esp,%ebp
c01036a2:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01036a5:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c01036aa:	8b 40 18             	mov    0x18(%eax),%eax
c01036ad:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01036af:	83 ec 0c             	sub    $0xc,%esp
c01036b2:	68 c8 64 10 c0       	push   $0xc01064c8
c01036b7:	e8 b3 cb ff ff       	call   c010026f <cprintf>
c01036bc:	83 c4 10             	add    $0x10,%esp
}
c01036bf:	90                   	nop
c01036c0:	c9                   	leave  
c01036c1:	c3                   	ret    

c01036c2 <check_pgdir>:

static void
check_pgdir(void) {
c01036c2:	55                   	push   %ebp
c01036c3:	89 e5                	mov    %esp,%ebp
c01036c5:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01036c8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01036cd:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01036d2:	76 19                	jbe    c01036ed <check_pgdir+0x2b>
c01036d4:	68 e7 64 10 c0       	push   $0xc01064e7
c01036d9:	68 8d 64 10 c0       	push   $0xc010648d
c01036de:	68 1b 02 00 00       	push   $0x21b
c01036e3:	68 68 64 10 c0       	push   $0xc0106468
c01036e8:	e8 e8 cc ff ff       	call   c01003d5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01036ed:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036f2:	85 c0                	test   %eax,%eax
c01036f4:	74 0e                	je     c0103704 <check_pgdir+0x42>
c01036f6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036fb:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103700:	85 c0                	test   %eax,%eax
c0103702:	74 19                	je     c010371d <check_pgdir+0x5b>
c0103704:	68 04 65 10 c0       	push   $0xc0106504
c0103709:	68 8d 64 10 c0       	push   $0xc010648d
c010370e:	68 1c 02 00 00       	push   $0x21c
c0103713:	68 68 64 10 c0       	push   $0xc0106468
c0103718:	e8 b8 cc ff ff       	call   c01003d5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010371d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103722:	83 ec 04             	sub    $0x4,%esp
c0103725:	6a 00                	push   $0x0
c0103727:	6a 00                	push   $0x0
c0103729:	50                   	push   %eax
c010372a:	e8 6c fd ff ff       	call   c010349b <get_page>
c010372f:	83 c4 10             	add    $0x10,%esp
c0103732:	85 c0                	test   %eax,%eax
c0103734:	74 19                	je     c010374f <check_pgdir+0x8d>
c0103736:	68 3c 65 10 c0       	push   $0xc010653c
c010373b:	68 8d 64 10 c0       	push   $0xc010648d
c0103740:	68 1d 02 00 00       	push   $0x21d
c0103745:	68 68 64 10 c0       	push   $0xc0106468
c010374a:	e8 86 cc ff ff       	call   c01003d5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010374f:	83 ec 0c             	sub    $0xc,%esp
c0103752:	6a 01                	push   $0x1
c0103754:	e8 36 f5 ff ff       	call   c0102c8f <alloc_pages>
c0103759:	83 c4 10             	add    $0x10,%esp
c010375c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010375f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103764:	6a 00                	push   $0x0
c0103766:	6a 00                	push   $0x0
c0103768:	ff 75 f4             	pushl  -0xc(%ebp)
c010376b:	50                   	push   %eax
c010376c:	e8 25 fe ff ff       	call   c0103596 <page_insert>
c0103771:	83 c4 10             	add    $0x10,%esp
c0103774:	85 c0                	test   %eax,%eax
c0103776:	74 19                	je     c0103791 <check_pgdir+0xcf>
c0103778:	68 64 65 10 c0       	push   $0xc0106564
c010377d:	68 8d 64 10 c0       	push   $0xc010648d
c0103782:	68 21 02 00 00       	push   $0x221
c0103787:	68 68 64 10 c0       	push   $0xc0106468
c010378c:	e8 44 cc ff ff       	call   c01003d5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103791:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103796:	83 ec 04             	sub    $0x4,%esp
c0103799:	6a 00                	push   $0x0
c010379b:	6a 00                	push   $0x0
c010379d:	50                   	push   %eax
c010379e:	e8 b4 fb ff ff       	call   c0103357 <get_pte>
c01037a3:	83 c4 10             	add    $0x10,%esp
c01037a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037ad:	75 19                	jne    c01037c8 <check_pgdir+0x106>
c01037af:	68 90 65 10 c0       	push   $0xc0106590
c01037b4:	68 8d 64 10 c0       	push   $0xc010648d
c01037b9:	68 24 02 00 00       	push   $0x224
c01037be:	68 68 64 10 c0       	push   $0xc0106468
c01037c3:	e8 0d cc ff ff       	call   c01003d5 <__panic>
    assert(pte2page(*ptep) == p1);
c01037c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037cb:	8b 00                	mov    (%eax),%eax
c01037cd:	83 ec 0c             	sub    $0xc,%esp
c01037d0:	50                   	push   %eax
c01037d1:	e8 55 f2 ff ff       	call   c0102a2b <pte2page>
c01037d6:	83 c4 10             	add    $0x10,%esp
c01037d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037dc:	74 19                	je     c01037f7 <check_pgdir+0x135>
c01037de:	68 bd 65 10 c0       	push   $0xc01065bd
c01037e3:	68 8d 64 10 c0       	push   $0xc010648d
c01037e8:	68 25 02 00 00       	push   $0x225
c01037ed:	68 68 64 10 c0       	push   $0xc0106468
c01037f2:	e8 de cb ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p1) == 1);
c01037f7:	83 ec 0c             	sub    $0xc,%esp
c01037fa:	ff 75 f4             	pushl  -0xc(%ebp)
c01037fd:	e8 7f f2 ff ff       	call   c0102a81 <page_ref>
c0103802:	83 c4 10             	add    $0x10,%esp
c0103805:	83 f8 01             	cmp    $0x1,%eax
c0103808:	74 19                	je     c0103823 <check_pgdir+0x161>
c010380a:	68 d3 65 10 c0       	push   $0xc01065d3
c010380f:	68 8d 64 10 c0       	push   $0xc010648d
c0103814:	68 26 02 00 00       	push   $0x226
c0103819:	68 68 64 10 c0       	push   $0xc0106468
c010381e:	e8 b2 cb ff ff       	call   c01003d5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103823:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103828:	8b 00                	mov    (%eax),%eax
c010382a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010382f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103832:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103835:	c1 e8 0c             	shr    $0xc,%eax
c0103838:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010383b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103840:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103843:	72 17                	jb     c010385c <check_pgdir+0x19a>
c0103845:	ff 75 ec             	pushl  -0x14(%ebp)
c0103848:	68 a0 63 10 c0       	push   $0xc01063a0
c010384d:	68 28 02 00 00       	push   $0x228
c0103852:	68 68 64 10 c0       	push   $0xc0106468
c0103857:	e8 79 cb ff ff       	call   c01003d5 <__panic>
c010385c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010385f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103864:	83 c0 04             	add    $0x4,%eax
c0103867:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010386a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010386f:	83 ec 04             	sub    $0x4,%esp
c0103872:	6a 00                	push   $0x0
c0103874:	68 00 10 00 00       	push   $0x1000
c0103879:	50                   	push   %eax
c010387a:	e8 d8 fa ff ff       	call   c0103357 <get_pte>
c010387f:	83 c4 10             	add    $0x10,%esp
c0103882:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103885:	74 19                	je     c01038a0 <check_pgdir+0x1de>
c0103887:	68 e8 65 10 c0       	push   $0xc01065e8
c010388c:	68 8d 64 10 c0       	push   $0xc010648d
c0103891:	68 29 02 00 00       	push   $0x229
c0103896:	68 68 64 10 c0       	push   $0xc0106468
c010389b:	e8 35 cb ff ff       	call   c01003d5 <__panic>

    p2 = alloc_page();
c01038a0:	83 ec 0c             	sub    $0xc,%esp
c01038a3:	6a 01                	push   $0x1
c01038a5:	e8 e5 f3 ff ff       	call   c0102c8f <alloc_pages>
c01038aa:	83 c4 10             	add    $0x10,%esp
c01038ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01038b0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038b5:	6a 06                	push   $0x6
c01038b7:	68 00 10 00 00       	push   $0x1000
c01038bc:	ff 75 e4             	pushl  -0x1c(%ebp)
c01038bf:	50                   	push   %eax
c01038c0:	e8 d1 fc ff ff       	call   c0103596 <page_insert>
c01038c5:	83 c4 10             	add    $0x10,%esp
c01038c8:	85 c0                	test   %eax,%eax
c01038ca:	74 19                	je     c01038e5 <check_pgdir+0x223>
c01038cc:	68 10 66 10 c0       	push   $0xc0106610
c01038d1:	68 8d 64 10 c0       	push   $0xc010648d
c01038d6:	68 2c 02 00 00       	push   $0x22c
c01038db:	68 68 64 10 c0       	push   $0xc0106468
c01038e0:	e8 f0 ca ff ff       	call   c01003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01038e5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038ea:	83 ec 04             	sub    $0x4,%esp
c01038ed:	6a 00                	push   $0x0
c01038ef:	68 00 10 00 00       	push   $0x1000
c01038f4:	50                   	push   %eax
c01038f5:	e8 5d fa ff ff       	call   c0103357 <get_pte>
c01038fa:	83 c4 10             	add    $0x10,%esp
c01038fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103904:	75 19                	jne    c010391f <check_pgdir+0x25d>
c0103906:	68 48 66 10 c0       	push   $0xc0106648
c010390b:	68 8d 64 10 c0       	push   $0xc010648d
c0103910:	68 2d 02 00 00       	push   $0x22d
c0103915:	68 68 64 10 c0       	push   $0xc0106468
c010391a:	e8 b6 ca ff ff       	call   c01003d5 <__panic>
    assert(*ptep & PTE_U);
c010391f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103922:	8b 00                	mov    (%eax),%eax
c0103924:	83 e0 04             	and    $0x4,%eax
c0103927:	85 c0                	test   %eax,%eax
c0103929:	75 19                	jne    c0103944 <check_pgdir+0x282>
c010392b:	68 78 66 10 c0       	push   $0xc0106678
c0103930:	68 8d 64 10 c0       	push   $0xc010648d
c0103935:	68 2e 02 00 00       	push   $0x22e
c010393a:	68 68 64 10 c0       	push   $0xc0106468
c010393f:	e8 91 ca ff ff       	call   c01003d5 <__panic>
    assert(*ptep & PTE_W);
c0103944:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103947:	8b 00                	mov    (%eax),%eax
c0103949:	83 e0 02             	and    $0x2,%eax
c010394c:	85 c0                	test   %eax,%eax
c010394e:	75 19                	jne    c0103969 <check_pgdir+0x2a7>
c0103950:	68 86 66 10 c0       	push   $0xc0106686
c0103955:	68 8d 64 10 c0       	push   $0xc010648d
c010395a:	68 2f 02 00 00       	push   $0x22f
c010395f:	68 68 64 10 c0       	push   $0xc0106468
c0103964:	e8 6c ca ff ff       	call   c01003d5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103969:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010396e:	8b 00                	mov    (%eax),%eax
c0103970:	83 e0 04             	and    $0x4,%eax
c0103973:	85 c0                	test   %eax,%eax
c0103975:	75 19                	jne    c0103990 <check_pgdir+0x2ce>
c0103977:	68 94 66 10 c0       	push   $0xc0106694
c010397c:	68 8d 64 10 c0       	push   $0xc010648d
c0103981:	68 30 02 00 00       	push   $0x230
c0103986:	68 68 64 10 c0       	push   $0xc0106468
c010398b:	e8 45 ca ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 1);
c0103990:	83 ec 0c             	sub    $0xc,%esp
c0103993:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103996:	e8 e6 f0 ff ff       	call   c0102a81 <page_ref>
c010399b:	83 c4 10             	add    $0x10,%esp
c010399e:	83 f8 01             	cmp    $0x1,%eax
c01039a1:	74 19                	je     c01039bc <check_pgdir+0x2fa>
c01039a3:	68 aa 66 10 c0       	push   $0xc01066aa
c01039a8:	68 8d 64 10 c0       	push   $0xc010648d
c01039ad:	68 31 02 00 00       	push   $0x231
c01039b2:	68 68 64 10 c0       	push   $0xc0106468
c01039b7:	e8 19 ca ff ff       	call   c01003d5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01039bc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039c1:	6a 00                	push   $0x0
c01039c3:	68 00 10 00 00       	push   $0x1000
c01039c8:	ff 75 f4             	pushl  -0xc(%ebp)
c01039cb:	50                   	push   %eax
c01039cc:	e8 c5 fb ff ff       	call   c0103596 <page_insert>
c01039d1:	83 c4 10             	add    $0x10,%esp
c01039d4:	85 c0                	test   %eax,%eax
c01039d6:	74 19                	je     c01039f1 <check_pgdir+0x32f>
c01039d8:	68 bc 66 10 c0       	push   $0xc01066bc
c01039dd:	68 8d 64 10 c0       	push   $0xc010648d
c01039e2:	68 33 02 00 00       	push   $0x233
c01039e7:	68 68 64 10 c0       	push   $0xc0106468
c01039ec:	e8 e4 c9 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p1) == 2);
c01039f1:	83 ec 0c             	sub    $0xc,%esp
c01039f4:	ff 75 f4             	pushl  -0xc(%ebp)
c01039f7:	e8 85 f0 ff ff       	call   c0102a81 <page_ref>
c01039fc:	83 c4 10             	add    $0x10,%esp
c01039ff:	83 f8 02             	cmp    $0x2,%eax
c0103a02:	74 19                	je     c0103a1d <check_pgdir+0x35b>
c0103a04:	68 e8 66 10 c0       	push   $0xc01066e8
c0103a09:	68 8d 64 10 c0       	push   $0xc010648d
c0103a0e:	68 34 02 00 00       	push   $0x234
c0103a13:	68 68 64 10 c0       	push   $0xc0106468
c0103a18:	e8 b8 c9 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c0103a1d:	83 ec 0c             	sub    $0xc,%esp
c0103a20:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a23:	e8 59 f0 ff ff       	call   c0102a81 <page_ref>
c0103a28:	83 c4 10             	add    $0x10,%esp
c0103a2b:	85 c0                	test   %eax,%eax
c0103a2d:	74 19                	je     c0103a48 <check_pgdir+0x386>
c0103a2f:	68 fa 66 10 c0       	push   $0xc01066fa
c0103a34:	68 8d 64 10 c0       	push   $0xc010648d
c0103a39:	68 35 02 00 00       	push   $0x235
c0103a3e:	68 68 64 10 c0       	push   $0xc0106468
c0103a43:	e8 8d c9 ff ff       	call   c01003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a48:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a4d:	83 ec 04             	sub    $0x4,%esp
c0103a50:	6a 00                	push   $0x0
c0103a52:	68 00 10 00 00       	push   $0x1000
c0103a57:	50                   	push   %eax
c0103a58:	e8 fa f8 ff ff       	call   c0103357 <get_pte>
c0103a5d:	83 c4 10             	add    $0x10,%esp
c0103a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a67:	75 19                	jne    c0103a82 <check_pgdir+0x3c0>
c0103a69:	68 48 66 10 c0       	push   $0xc0106648
c0103a6e:	68 8d 64 10 c0       	push   $0xc010648d
c0103a73:	68 36 02 00 00       	push   $0x236
c0103a78:	68 68 64 10 c0       	push   $0xc0106468
c0103a7d:	e8 53 c9 ff ff       	call   c01003d5 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a85:	8b 00                	mov    (%eax),%eax
c0103a87:	83 ec 0c             	sub    $0xc,%esp
c0103a8a:	50                   	push   %eax
c0103a8b:	e8 9b ef ff ff       	call   c0102a2b <pte2page>
c0103a90:	83 c4 10             	add    $0x10,%esp
c0103a93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a96:	74 19                	je     c0103ab1 <check_pgdir+0x3ef>
c0103a98:	68 bd 65 10 c0       	push   $0xc01065bd
c0103a9d:	68 8d 64 10 c0       	push   $0xc010648d
c0103aa2:	68 37 02 00 00       	push   $0x237
c0103aa7:	68 68 64 10 c0       	push   $0xc0106468
c0103aac:	e8 24 c9 ff ff       	call   c01003d5 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ab4:	8b 00                	mov    (%eax),%eax
c0103ab6:	83 e0 04             	and    $0x4,%eax
c0103ab9:	85 c0                	test   %eax,%eax
c0103abb:	74 19                	je     c0103ad6 <check_pgdir+0x414>
c0103abd:	68 0c 67 10 c0       	push   $0xc010670c
c0103ac2:	68 8d 64 10 c0       	push   $0xc010648d
c0103ac7:	68 38 02 00 00       	push   $0x238
c0103acc:	68 68 64 10 c0       	push   $0xc0106468
c0103ad1:	e8 ff c8 ff ff       	call   c01003d5 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103ad6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103adb:	83 ec 08             	sub    $0x8,%esp
c0103ade:	6a 00                	push   $0x0
c0103ae0:	50                   	push   %eax
c0103ae1:	e8 77 fa ff ff       	call   c010355d <page_remove>
c0103ae6:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103ae9:	83 ec 0c             	sub    $0xc,%esp
c0103aec:	ff 75 f4             	pushl  -0xc(%ebp)
c0103aef:	e8 8d ef ff ff       	call   c0102a81 <page_ref>
c0103af4:	83 c4 10             	add    $0x10,%esp
c0103af7:	83 f8 01             	cmp    $0x1,%eax
c0103afa:	74 19                	je     c0103b15 <check_pgdir+0x453>
c0103afc:	68 d3 65 10 c0       	push   $0xc01065d3
c0103b01:	68 8d 64 10 c0       	push   $0xc010648d
c0103b06:	68 3b 02 00 00       	push   $0x23b
c0103b0b:	68 68 64 10 c0       	push   $0xc0106468
c0103b10:	e8 c0 c8 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c0103b15:	83 ec 0c             	sub    $0xc,%esp
c0103b18:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b1b:	e8 61 ef ff ff       	call   c0102a81 <page_ref>
c0103b20:	83 c4 10             	add    $0x10,%esp
c0103b23:	85 c0                	test   %eax,%eax
c0103b25:	74 19                	je     c0103b40 <check_pgdir+0x47e>
c0103b27:	68 fa 66 10 c0       	push   $0xc01066fa
c0103b2c:	68 8d 64 10 c0       	push   $0xc010648d
c0103b31:	68 3c 02 00 00       	push   $0x23c
c0103b36:	68 68 64 10 c0       	push   $0xc0106468
c0103b3b:	e8 95 c8 ff ff       	call   c01003d5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103b40:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b45:	83 ec 08             	sub    $0x8,%esp
c0103b48:	68 00 10 00 00       	push   $0x1000
c0103b4d:	50                   	push   %eax
c0103b4e:	e8 0a fa ff ff       	call   c010355d <page_remove>
c0103b53:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103b56:	83 ec 0c             	sub    $0xc,%esp
c0103b59:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b5c:	e8 20 ef ff ff       	call   c0102a81 <page_ref>
c0103b61:	83 c4 10             	add    $0x10,%esp
c0103b64:	85 c0                	test   %eax,%eax
c0103b66:	74 19                	je     c0103b81 <check_pgdir+0x4bf>
c0103b68:	68 21 67 10 c0       	push   $0xc0106721
c0103b6d:	68 8d 64 10 c0       	push   $0xc010648d
c0103b72:	68 3f 02 00 00       	push   $0x23f
c0103b77:	68 68 64 10 c0       	push   $0xc0106468
c0103b7c:	e8 54 c8 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c0103b81:	83 ec 0c             	sub    $0xc,%esp
c0103b84:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b87:	e8 f5 ee ff ff       	call   c0102a81 <page_ref>
c0103b8c:	83 c4 10             	add    $0x10,%esp
c0103b8f:	85 c0                	test   %eax,%eax
c0103b91:	74 19                	je     c0103bac <check_pgdir+0x4ea>
c0103b93:	68 fa 66 10 c0       	push   $0xc01066fa
c0103b98:	68 8d 64 10 c0       	push   $0xc010648d
c0103b9d:	68 40 02 00 00       	push   $0x240
c0103ba2:	68 68 64 10 c0       	push   $0xc0106468
c0103ba7:	e8 29 c8 ff ff       	call   c01003d5 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103bac:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bb1:	8b 00                	mov    (%eax),%eax
c0103bb3:	83 ec 0c             	sub    $0xc,%esp
c0103bb6:	50                   	push   %eax
c0103bb7:	e8 a9 ee ff ff       	call   c0102a65 <pde2page>
c0103bbc:	83 c4 10             	add    $0x10,%esp
c0103bbf:	83 ec 0c             	sub    $0xc,%esp
c0103bc2:	50                   	push   %eax
c0103bc3:	e8 b9 ee ff ff       	call   c0102a81 <page_ref>
c0103bc8:	83 c4 10             	add    $0x10,%esp
c0103bcb:	83 f8 01             	cmp    $0x1,%eax
c0103bce:	74 19                	je     c0103be9 <check_pgdir+0x527>
c0103bd0:	68 34 67 10 c0       	push   $0xc0106734
c0103bd5:	68 8d 64 10 c0       	push   $0xc010648d
c0103bda:	68 42 02 00 00       	push   $0x242
c0103bdf:	68 68 64 10 c0       	push   $0xc0106468
c0103be4:	e8 ec c7 ff ff       	call   c01003d5 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103be9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bee:	8b 00                	mov    (%eax),%eax
c0103bf0:	83 ec 0c             	sub    $0xc,%esp
c0103bf3:	50                   	push   %eax
c0103bf4:	e8 6c ee ff ff       	call   c0102a65 <pde2page>
c0103bf9:	83 c4 10             	add    $0x10,%esp
c0103bfc:	83 ec 08             	sub    $0x8,%esp
c0103bff:	6a 01                	push   $0x1
c0103c01:	50                   	push   %eax
c0103c02:	e8 c6 f0 ff ff       	call   c0102ccd <free_pages>
c0103c07:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103c0a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103c15:	83 ec 0c             	sub    $0xc,%esp
c0103c18:	68 5b 67 10 c0       	push   $0xc010675b
c0103c1d:	e8 4d c6 ff ff       	call   c010026f <cprintf>
c0103c22:	83 c4 10             	add    $0x10,%esp
}
c0103c25:	90                   	nop
c0103c26:	c9                   	leave  
c0103c27:	c3                   	ret    

c0103c28 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103c28:	55                   	push   %ebp
c0103c29:	89 e5                	mov    %esp,%ebp
c0103c2b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c35:	e9 a3 00 00 00       	jmp    c0103cdd <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c43:	c1 e8 0c             	shr    $0xc,%eax
c0103c46:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c49:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c4e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103c51:	72 17                	jb     c0103c6a <check_boot_pgdir+0x42>
c0103c53:	ff 75 f0             	pushl  -0x10(%ebp)
c0103c56:	68 a0 63 10 c0       	push   $0xc01063a0
c0103c5b:	68 4e 02 00 00       	push   $0x24e
c0103c60:	68 68 64 10 c0       	push   $0xc0106468
c0103c65:	e8 6b c7 ff ff       	call   c01003d5 <__panic>
c0103c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c6d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103c72:	89 c2                	mov    %eax,%edx
c0103c74:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c79:	83 ec 04             	sub    $0x4,%esp
c0103c7c:	6a 00                	push   $0x0
c0103c7e:	52                   	push   %edx
c0103c7f:	50                   	push   %eax
c0103c80:	e8 d2 f6 ff ff       	call   c0103357 <get_pte>
c0103c85:	83 c4 10             	add    $0x10,%esp
c0103c88:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103c8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103c8f:	75 19                	jne    c0103caa <check_boot_pgdir+0x82>
c0103c91:	68 78 67 10 c0       	push   $0xc0106778
c0103c96:	68 8d 64 10 c0       	push   $0xc010648d
c0103c9b:	68 4e 02 00 00       	push   $0x24e
c0103ca0:	68 68 64 10 c0       	push   $0xc0106468
c0103ca5:	e8 2b c7 ff ff       	call   c01003d5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cad:	8b 00                	mov    (%eax),%eax
c0103caf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cb4:	89 c2                	mov    %eax,%edx
c0103cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb9:	39 c2                	cmp    %eax,%edx
c0103cbb:	74 19                	je     c0103cd6 <check_boot_pgdir+0xae>
c0103cbd:	68 b5 67 10 c0       	push   $0xc01067b5
c0103cc2:	68 8d 64 10 c0       	push   $0xc010648d
c0103cc7:	68 4f 02 00 00       	push   $0x24f
c0103ccc:	68 68 64 10 c0       	push   $0xc0106468
c0103cd1:	e8 ff c6 ff ff       	call   c01003d5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103cd6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ce0:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103ce5:	39 c2                	cmp    %eax,%edx
c0103ce7:	0f 82 4d ff ff ff    	jb     c0103c3a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103ced:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103cf2:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103cf7:	8b 00                	mov    (%eax),%eax
c0103cf9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cfe:	89 c2                	mov    %eax,%edx
c0103d00:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103d08:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103d0f:	77 17                	ja     c0103d28 <check_boot_pgdir+0x100>
c0103d11:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103d14:	68 44 64 10 c0       	push   $0xc0106444
c0103d19:	68 52 02 00 00       	push   $0x252
c0103d1e:	68 68 64 10 c0       	push   $0xc0106468
c0103d23:	e8 ad c6 ff ff       	call   c01003d5 <__panic>
c0103d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d2b:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d30:	39 c2                	cmp    %eax,%edx
c0103d32:	74 19                	je     c0103d4d <check_boot_pgdir+0x125>
c0103d34:	68 cc 67 10 c0       	push   $0xc01067cc
c0103d39:	68 8d 64 10 c0       	push   $0xc010648d
c0103d3e:	68 52 02 00 00       	push   $0x252
c0103d43:	68 68 64 10 c0       	push   $0xc0106468
c0103d48:	e8 88 c6 ff ff       	call   c01003d5 <__panic>

    assert(boot_pgdir[0] == 0);
c0103d4d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d52:	8b 00                	mov    (%eax),%eax
c0103d54:	85 c0                	test   %eax,%eax
c0103d56:	74 19                	je     c0103d71 <check_boot_pgdir+0x149>
c0103d58:	68 00 68 10 c0       	push   $0xc0106800
c0103d5d:	68 8d 64 10 c0       	push   $0xc010648d
c0103d62:	68 54 02 00 00       	push   $0x254
c0103d67:	68 68 64 10 c0       	push   $0xc0106468
c0103d6c:	e8 64 c6 ff ff       	call   c01003d5 <__panic>

    struct Page *p;
    p = alloc_page();
c0103d71:	83 ec 0c             	sub    $0xc,%esp
c0103d74:	6a 01                	push   $0x1
c0103d76:	e8 14 ef ff ff       	call   c0102c8f <alloc_pages>
c0103d7b:	83 c4 10             	add    $0x10,%esp
c0103d7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103d81:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d86:	6a 02                	push   $0x2
c0103d88:	68 00 01 00 00       	push   $0x100
c0103d8d:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d90:	50                   	push   %eax
c0103d91:	e8 00 f8 ff ff       	call   c0103596 <page_insert>
c0103d96:	83 c4 10             	add    $0x10,%esp
c0103d99:	85 c0                	test   %eax,%eax
c0103d9b:	74 19                	je     c0103db6 <check_boot_pgdir+0x18e>
c0103d9d:	68 14 68 10 c0       	push   $0xc0106814
c0103da2:	68 8d 64 10 c0       	push   $0xc010648d
c0103da7:	68 58 02 00 00       	push   $0x258
c0103dac:	68 68 64 10 c0       	push   $0xc0106468
c0103db1:	e8 1f c6 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p) == 1);
c0103db6:	83 ec 0c             	sub    $0xc,%esp
c0103db9:	ff 75 e0             	pushl  -0x20(%ebp)
c0103dbc:	e8 c0 ec ff ff       	call   c0102a81 <page_ref>
c0103dc1:	83 c4 10             	add    $0x10,%esp
c0103dc4:	83 f8 01             	cmp    $0x1,%eax
c0103dc7:	74 19                	je     c0103de2 <check_boot_pgdir+0x1ba>
c0103dc9:	68 42 68 10 c0       	push   $0xc0106842
c0103dce:	68 8d 64 10 c0       	push   $0xc010648d
c0103dd3:	68 59 02 00 00       	push   $0x259
c0103dd8:	68 68 64 10 c0       	push   $0xc0106468
c0103ddd:	e8 f3 c5 ff ff       	call   c01003d5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103de2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103de7:	6a 02                	push   $0x2
c0103de9:	68 00 11 00 00       	push   $0x1100
c0103dee:	ff 75 e0             	pushl  -0x20(%ebp)
c0103df1:	50                   	push   %eax
c0103df2:	e8 9f f7 ff ff       	call   c0103596 <page_insert>
c0103df7:	83 c4 10             	add    $0x10,%esp
c0103dfa:	85 c0                	test   %eax,%eax
c0103dfc:	74 19                	je     c0103e17 <check_boot_pgdir+0x1ef>
c0103dfe:	68 54 68 10 c0       	push   $0xc0106854
c0103e03:	68 8d 64 10 c0       	push   $0xc010648d
c0103e08:	68 5a 02 00 00       	push   $0x25a
c0103e0d:	68 68 64 10 c0       	push   $0xc0106468
c0103e12:	e8 be c5 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p) == 2);
c0103e17:	83 ec 0c             	sub    $0xc,%esp
c0103e1a:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e1d:	e8 5f ec ff ff       	call   c0102a81 <page_ref>
c0103e22:	83 c4 10             	add    $0x10,%esp
c0103e25:	83 f8 02             	cmp    $0x2,%eax
c0103e28:	74 19                	je     c0103e43 <check_boot_pgdir+0x21b>
c0103e2a:	68 8b 68 10 c0       	push   $0xc010688b
c0103e2f:	68 8d 64 10 c0       	push   $0xc010648d
c0103e34:	68 5b 02 00 00       	push   $0x25b
c0103e39:	68 68 64 10 c0       	push   $0xc0106468
c0103e3e:	e8 92 c5 ff ff       	call   c01003d5 <__panic>

    const char *str = "ucore: Hello world!!";
c0103e43:	c7 45 dc 9c 68 10 c0 	movl   $0xc010689c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103e4a:	83 ec 08             	sub    $0x8,%esp
c0103e4d:	ff 75 dc             	pushl  -0x24(%ebp)
c0103e50:	68 00 01 00 00       	push   $0x100
c0103e55:	e8 66 13 00 00       	call   c01051c0 <strcpy>
c0103e5a:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103e5d:	83 ec 08             	sub    $0x8,%esp
c0103e60:	68 00 11 00 00       	push   $0x1100
c0103e65:	68 00 01 00 00       	push   $0x100
c0103e6a:	e8 cb 13 00 00       	call   c010523a <strcmp>
c0103e6f:	83 c4 10             	add    $0x10,%esp
c0103e72:	85 c0                	test   %eax,%eax
c0103e74:	74 19                	je     c0103e8f <check_boot_pgdir+0x267>
c0103e76:	68 b4 68 10 c0       	push   $0xc01068b4
c0103e7b:	68 8d 64 10 c0       	push   $0xc010648d
c0103e80:	68 5f 02 00 00       	push   $0x25f
c0103e85:	68 68 64 10 c0       	push   $0xc0106468
c0103e8a:	e8 46 c5 ff ff       	call   c01003d5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103e8f:	83 ec 0c             	sub    $0xc,%esp
c0103e92:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e95:	e8 4c eb ff ff       	call   c01029e6 <page2kva>
c0103e9a:	83 c4 10             	add    $0x10,%esp
c0103e9d:	05 00 01 00 00       	add    $0x100,%eax
c0103ea2:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103ea5:	83 ec 0c             	sub    $0xc,%esp
c0103ea8:	68 00 01 00 00       	push   $0x100
c0103ead:	e8 b6 12 00 00       	call   c0105168 <strlen>
c0103eb2:	83 c4 10             	add    $0x10,%esp
c0103eb5:	85 c0                	test   %eax,%eax
c0103eb7:	74 19                	je     c0103ed2 <check_boot_pgdir+0x2aa>
c0103eb9:	68 ec 68 10 c0       	push   $0xc01068ec
c0103ebe:	68 8d 64 10 c0       	push   $0xc010648d
c0103ec3:	68 62 02 00 00       	push   $0x262
c0103ec8:	68 68 64 10 c0       	push   $0xc0106468
c0103ecd:	e8 03 c5 ff ff       	call   c01003d5 <__panic>

    free_page(p);
c0103ed2:	83 ec 08             	sub    $0x8,%esp
c0103ed5:	6a 01                	push   $0x1
c0103ed7:	ff 75 e0             	pushl  -0x20(%ebp)
c0103eda:	e8 ee ed ff ff       	call   c0102ccd <free_pages>
c0103edf:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103ee2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ee7:	8b 00                	mov    (%eax),%eax
c0103ee9:	83 ec 0c             	sub    $0xc,%esp
c0103eec:	50                   	push   %eax
c0103eed:	e8 73 eb ff ff       	call   c0102a65 <pde2page>
c0103ef2:	83 c4 10             	add    $0x10,%esp
c0103ef5:	83 ec 08             	sub    $0x8,%esp
c0103ef8:	6a 01                	push   $0x1
c0103efa:	50                   	push   %eax
c0103efb:	e8 cd ed ff ff       	call   c0102ccd <free_pages>
c0103f00:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103f03:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103f08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103f0e:	83 ec 0c             	sub    $0xc,%esp
c0103f11:	68 10 69 10 c0       	push   $0xc0106910
c0103f16:	e8 54 c3 ff ff       	call   c010026f <cprintf>
c0103f1b:	83 c4 10             	add    $0x10,%esp
}
c0103f1e:	90                   	nop
c0103f1f:	c9                   	leave  
c0103f20:	c3                   	ret    

c0103f21 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103f21:	55                   	push   %ebp
c0103f22:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103f24:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f27:	83 e0 04             	and    $0x4,%eax
c0103f2a:	85 c0                	test   %eax,%eax
c0103f2c:	74 07                	je     c0103f35 <perm2str+0x14>
c0103f2e:	b8 75 00 00 00       	mov    $0x75,%eax
c0103f33:	eb 05                	jmp    c0103f3a <perm2str+0x19>
c0103f35:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103f3a:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103f3f:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f49:	83 e0 02             	and    $0x2,%eax
c0103f4c:	85 c0                	test   %eax,%eax
c0103f4e:	74 07                	je     c0103f57 <perm2str+0x36>
c0103f50:	b8 77 00 00 00       	mov    $0x77,%eax
c0103f55:	eb 05                	jmp    c0103f5c <perm2str+0x3b>
c0103f57:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103f5c:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103f61:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103f68:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103f6d:	5d                   	pop    %ebp
c0103f6e:	c3                   	ret    

c0103f6f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103f6f:	55                   	push   %ebp
c0103f70:	89 e5                	mov    %esp,%ebp
c0103f72:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103f75:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f78:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f7b:	72 0e                	jb     c0103f8b <get_pgtable_items+0x1c>
        return 0;
c0103f7d:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f82:	e9 9a 00 00 00       	jmp    c0104021 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103f87:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103f8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f91:	73 18                	jae    c0103fab <get_pgtable_items+0x3c>
c0103f93:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f9d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fa0:	01 d0                	add    %edx,%eax
c0103fa2:	8b 00                	mov    (%eax),%eax
c0103fa4:	83 e0 01             	and    $0x1,%eax
c0103fa7:	85 c0                	test   %eax,%eax
c0103fa9:	74 dc                	je     c0103f87 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103fab:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fae:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fb1:	73 69                	jae    c010401c <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103fb3:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103fb7:	74 08                	je     c0103fc1 <get_pgtable_items+0x52>
            *left_store = start;
c0103fb9:	8b 45 18             	mov    0x18(%ebp),%eax
c0103fbc:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fbf:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103fc1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fc4:	8d 50 01             	lea    0x1(%eax),%edx
c0103fc7:	89 55 10             	mov    %edx,0x10(%ebp)
c0103fca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103fd1:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fd4:	01 d0                	add    %edx,%eax
c0103fd6:	8b 00                	mov    (%eax),%eax
c0103fd8:	83 e0 07             	and    $0x7,%eax
c0103fdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103fde:	eb 04                	jmp    c0103fe4 <get_pgtable_items+0x75>
            start ++;
c0103fe0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103fe4:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fe7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fea:	73 1d                	jae    c0104009 <get_pgtable_items+0x9a>
c0103fec:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103ff6:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ff9:	01 d0                	add    %edx,%eax
c0103ffb:	8b 00                	mov    (%eax),%eax
c0103ffd:	83 e0 07             	and    $0x7,%eax
c0104000:	89 c2                	mov    %eax,%edx
c0104002:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104005:	39 c2                	cmp    %eax,%edx
c0104007:	74 d7                	je     c0103fe0 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0104009:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010400d:	74 08                	je     c0104017 <get_pgtable_items+0xa8>
            *right_store = start;
c010400f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104012:	8b 55 10             	mov    0x10(%ebp),%edx
c0104015:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104017:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010401a:	eb 05                	jmp    c0104021 <get_pgtable_items+0xb2>
    }
    return 0;
c010401c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104021:	c9                   	leave  
c0104022:	c3                   	ret    

c0104023 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104023:	55                   	push   %ebp
c0104024:	89 e5                	mov    %esp,%ebp
c0104026:	57                   	push   %edi
c0104027:	56                   	push   %esi
c0104028:	53                   	push   %ebx
c0104029:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010402c:	83 ec 0c             	sub    $0xc,%esp
c010402f:	68 30 69 10 c0       	push   $0xc0106930
c0104034:	e8 36 c2 ff ff       	call   c010026f <cprintf>
c0104039:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c010403c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104043:	e9 e5 00 00 00       	jmp    c010412d <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010404b:	83 ec 0c             	sub    $0xc,%esp
c010404e:	50                   	push   %eax
c010404f:	e8 cd fe ff ff       	call   c0103f21 <perm2str>
c0104054:	83 c4 10             	add    $0x10,%esp
c0104057:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104059:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010405c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010405f:	29 c2                	sub    %eax,%edx
c0104061:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104063:	c1 e0 16             	shl    $0x16,%eax
c0104066:	89 c3                	mov    %eax,%ebx
c0104068:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010406b:	c1 e0 16             	shl    $0x16,%eax
c010406e:	89 c1                	mov    %eax,%ecx
c0104070:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104073:	c1 e0 16             	shl    $0x16,%eax
c0104076:	89 c2                	mov    %eax,%edx
c0104078:	8b 75 dc             	mov    -0x24(%ebp),%esi
c010407b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010407e:	29 c6                	sub    %eax,%esi
c0104080:	89 f0                	mov    %esi,%eax
c0104082:	83 ec 08             	sub    $0x8,%esp
c0104085:	57                   	push   %edi
c0104086:	53                   	push   %ebx
c0104087:	51                   	push   %ecx
c0104088:	52                   	push   %edx
c0104089:	50                   	push   %eax
c010408a:	68 61 69 10 c0       	push   $0xc0106961
c010408f:	e8 db c1 ff ff       	call   c010026f <cprintf>
c0104094:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0104097:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010409a:	c1 e0 0a             	shl    $0xa,%eax
c010409d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01040a0:	eb 4f                	jmp    c01040f1 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01040a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040a5:	83 ec 0c             	sub    $0xc,%esp
c01040a8:	50                   	push   %eax
c01040a9:	e8 73 fe ff ff       	call   c0103f21 <perm2str>
c01040ae:	83 c4 10             	add    $0x10,%esp
c01040b1:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01040b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040b9:	29 c2                	sub    %eax,%edx
c01040bb:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01040bd:	c1 e0 0c             	shl    $0xc,%eax
c01040c0:	89 c3                	mov    %eax,%ebx
c01040c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040c5:	c1 e0 0c             	shl    $0xc,%eax
c01040c8:	89 c1                	mov    %eax,%ecx
c01040ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040cd:	c1 e0 0c             	shl    $0xc,%eax
c01040d0:	89 c2                	mov    %eax,%edx
c01040d2:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c01040d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040d8:	29 c6                	sub    %eax,%esi
c01040da:	89 f0                	mov    %esi,%eax
c01040dc:	83 ec 08             	sub    $0x8,%esp
c01040df:	57                   	push   %edi
c01040e0:	53                   	push   %ebx
c01040e1:	51                   	push   %ecx
c01040e2:	52                   	push   %edx
c01040e3:	50                   	push   %eax
c01040e4:	68 80 69 10 c0       	push   $0xc0106980
c01040e9:	e8 81 c1 ff ff       	call   c010026f <cprintf>
c01040ee:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01040f1:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01040f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040fc:	89 d3                	mov    %edx,%ebx
c01040fe:	c1 e3 0a             	shl    $0xa,%ebx
c0104101:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104104:	89 d1                	mov    %edx,%ecx
c0104106:	c1 e1 0a             	shl    $0xa,%ecx
c0104109:	83 ec 08             	sub    $0x8,%esp
c010410c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010410f:	52                   	push   %edx
c0104110:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104113:	52                   	push   %edx
c0104114:	56                   	push   %esi
c0104115:	50                   	push   %eax
c0104116:	53                   	push   %ebx
c0104117:	51                   	push   %ecx
c0104118:	e8 52 fe ff ff       	call   c0103f6f <get_pgtable_items>
c010411d:	83 c4 20             	add    $0x20,%esp
c0104120:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104123:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104127:	0f 85 75 ff ff ff    	jne    c01040a2 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010412d:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104132:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104135:	83 ec 08             	sub    $0x8,%esp
c0104138:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010413b:	52                   	push   %edx
c010413c:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010413f:	52                   	push   %edx
c0104140:	51                   	push   %ecx
c0104141:	50                   	push   %eax
c0104142:	68 00 04 00 00       	push   $0x400
c0104147:	6a 00                	push   $0x0
c0104149:	e8 21 fe ff ff       	call   c0103f6f <get_pgtable_items>
c010414e:	83 c4 20             	add    $0x20,%esp
c0104151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104154:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104158:	0f 85 ea fe ff ff    	jne    c0104048 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010415e:	83 ec 0c             	sub    $0xc,%esp
c0104161:	68 a4 69 10 c0       	push   $0xc01069a4
c0104166:	e8 04 c1 ff ff       	call   c010026f <cprintf>
c010416b:	83 c4 10             	add    $0x10,%esp
}
c010416e:	90                   	nop
c010416f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104172:	5b                   	pop    %ebx
c0104173:	5e                   	pop    %esi
c0104174:	5f                   	pop    %edi
c0104175:	5d                   	pop    %ebp
c0104176:	c3                   	ret    

c0104177 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104177:	55                   	push   %ebp
c0104178:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010417a:	8b 45 08             	mov    0x8(%ebp),%eax
c010417d:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0104183:	29 d0                	sub    %edx,%eax
c0104185:	c1 f8 02             	sar    $0x2,%eax
c0104188:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010418e:	5d                   	pop    %ebp
c010418f:	c3                   	ret    

c0104190 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104190:	55                   	push   %ebp
c0104191:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104193:	ff 75 08             	pushl  0x8(%ebp)
c0104196:	e8 dc ff ff ff       	call   c0104177 <page2ppn>
c010419b:	83 c4 04             	add    $0x4,%esp
c010419e:	c1 e0 0c             	shl    $0xc,%eax
}
c01041a1:	c9                   	leave  
c01041a2:	c3                   	ret    

c01041a3 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01041a3:	55                   	push   %ebp
c01041a4:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01041a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01041a9:	8b 00                	mov    (%eax),%eax
}
c01041ab:	5d                   	pop    %ebp
c01041ac:	c3                   	ret    

c01041ad <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01041ad:	55                   	push   %ebp
c01041ae:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01041b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01041b3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041b6:	89 10                	mov    %edx,(%eax)
}
c01041b8:	90                   	nop
c01041b9:	5d                   	pop    %ebp
c01041ba:	c3                   	ret    

c01041bb <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01041bb:	55                   	push   %ebp
c01041bc:	89 e5                	mov    %esp,%ebp
c01041be:	83 ec 10             	sub    $0x10,%esp
c01041c1:	c7 45 fc bc 89 11 c0 	movl   $0xc01189bc,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01041c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01041ce:	89 50 04             	mov    %edx,0x4(%eax)
c01041d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041d4:	8b 50 04             	mov    0x4(%eax),%edx
c01041d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041da:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01041dc:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c01041e3:	00 00 00 
}
c01041e6:	90                   	nop
c01041e7:	c9                   	leave  
c01041e8:	c3                   	ret    

c01041e9 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01041e9:	55                   	push   %ebp
c01041ea:	89 e5                	mov    %esp,%ebp
c01041ec:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01041ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01041f3:	75 16                	jne    c010420b <default_init_memmap+0x22>
c01041f5:	68 d8 69 10 c0       	push   $0xc01069d8
c01041fa:	68 de 69 10 c0       	push   $0xc01069de
c01041ff:	6a 6d                	push   $0x6d
c0104201:	68 f3 69 10 c0       	push   $0xc01069f3
c0104206:	e8 ca c1 ff ff       	call   c01003d5 <__panic>
    struct Page *p = base;
c010420b:	8b 45 08             	mov    0x8(%ebp),%eax
c010420e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104211:	eb 6c                	jmp    c010427f <default_init_memmap+0x96>
        assert(PageReserved(p));
c0104213:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104216:	83 c0 04             	add    $0x4,%eax
c0104219:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104220:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104226:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104229:	0f a3 10             	bt     %edx,(%eax)
c010422c:	19 c0                	sbb    %eax,%eax
c010422e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104231:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104235:	0f 95 c0             	setne  %al
c0104238:	0f b6 c0             	movzbl %al,%eax
c010423b:	85 c0                	test   %eax,%eax
c010423d:	75 16                	jne    c0104255 <default_init_memmap+0x6c>
c010423f:	68 09 6a 10 c0       	push   $0xc0106a09
c0104244:	68 de 69 10 c0       	push   $0xc01069de
c0104249:	6a 70                	push   $0x70
c010424b:	68 f3 69 10 c0       	push   $0xc01069f3
c0104250:	e8 80 c1 ff ff       	call   c01003d5 <__panic>
        p->flags = p->property = 0;     // set all following pages as "not the head page"
c0104255:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104258:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010425f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104262:	8b 50 08             	mov    0x8(%eax),%edx
c0104265:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104268:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010426b:	83 ec 08             	sub    $0x8,%esp
c010426e:	6a 00                	push   $0x0
c0104270:	ff 75 f4             	pushl  -0xc(%ebp)
c0104273:	e8 35 ff ff ff       	call   c01041ad <set_page_ref>
c0104278:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010427b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010427f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104282:	89 d0                	mov    %edx,%eax
c0104284:	c1 e0 02             	shl    $0x2,%eax
c0104287:	01 d0                	add    %edx,%eax
c0104289:	c1 e0 02             	shl    $0x2,%eax
c010428c:	89 c2                	mov    %eax,%edx
c010428e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104291:	01 d0                	add    %edx,%eax
c0104293:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104296:	0f 85 77 ff ff ff    	jne    c0104213 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;     // set all following pages as "not the head page"
        set_page_ref(p, 0);
    }
    base->property = n;
c010429c:	8b 45 08             	mov    0x8(%ebp),%eax
c010429f:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042a2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);              // mark as the head page
c01042a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01042a8:	83 c0 04             	add    $0x4,%eax
c01042ab:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c01042b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01042b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01042b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042bb:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01042be:	8b 15 c4 89 11 c0    	mov    0xc01189c4,%edx
c01042c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042c7:	01 d0                	add    %edx,%eax
c01042c9:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
    list_add(&free_list, &(base->page_link));
c01042ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01042d1:	83 c0 0c             	add    $0xc,%eax
c01042d4:	c7 45 f0 bc 89 11 c0 	movl   $0xc01189bc,-0x10(%ebp)
c01042db:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01042de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01042e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01042ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042ed:	8b 40 04             	mov    0x4(%eax),%eax
c01042f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042f3:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01042f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042f9:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01042fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01042ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104302:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104305:	89 10                	mov    %edx,(%eax)
c0104307:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010430a:	8b 10                	mov    (%eax),%edx
c010430c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010430f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104312:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104315:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104318:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010431b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010431e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104321:	89 10                	mov    %edx,(%eax)
}
c0104323:	90                   	nop
c0104324:	c9                   	leave  
c0104325:	c3                   	ret    

c0104326 <default_alloc_pages>:

// MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
c0104326:	55                   	push   %ebp
c0104327:	89 e5                	mov    %esp,%ebp
c0104329:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010432c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104330:	75 16                	jne    c0104348 <default_alloc_pages+0x22>
c0104332:	68 d8 69 10 c0       	push   $0xc01069d8
c0104337:	68 de 69 10 c0       	push   $0xc01069de
c010433c:	6a 7d                	push   $0x7d
c010433e:	68 f3 69 10 c0       	push   $0xc01069f3
c0104343:	e8 8d c0 ff ff       	call   c01003d5 <__panic>
    if (n > nr_free) {
c0104348:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c010434d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104350:	73 0a                	jae    c010435c <default_alloc_pages+0x36>
        return NULL;
c0104352:	b8 00 00 00 00       	mov    $0x0,%eax
c0104357:	e9 48 01 00 00       	jmp    c01044a4 <default_alloc_pages+0x17e>
    }
    struct Page *page = NULL;
c010435c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104363:	c7 45 f0 bc 89 11 c0 	movl   $0xc01189bc,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010436a:	eb 1c                	jmp    c0104388 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c010436c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010436f:	83 e8 0c             	sub    $0xc,%eax
c0104372:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0104375:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104378:	8b 40 08             	mov    0x8(%eax),%eax
c010437b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010437e:	72 08                	jb     c0104388 <default_alloc_pages+0x62>
            page = p;
c0104380:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104383:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104386:	eb 18                	jmp    c01043a0 <default_alloc_pages+0x7a>
c0104388:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010438b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010438e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104391:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104394:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104397:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c010439e:	75 cc                	jne    c010436c <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c01043a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043a4:	0f 84 f7 00 00 00    	je     c01044a1 <default_alloc_pages+0x17b>
c01043aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01043b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043b3:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
c01043b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
c01043b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043bc:	83 c0 0c             	add    $0xc,%eax
c01043bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01043c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043c5:	8b 40 04             	mov    0x4(%eax),%eax
c01043c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01043cb:	8b 12                	mov    (%edx),%edx
c01043cd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01043d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01043d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01043d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01043d9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01043dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043df:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01043e2:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01043e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e7:	8b 40 08             	mov    0x8(%eax),%eax
c01043ea:	3b 45 08             	cmp    0x8(%ebp),%eax
c01043ed:	0f 86 88 00 00 00    	jbe    c010447b <default_alloc_pages+0x155>
            struct Page *p = page + n;                      // split the allocated page
c01043f3:	8b 55 08             	mov    0x8(%ebp),%edx
c01043f6:	89 d0                	mov    %edx,%eax
c01043f8:	c1 e0 02             	shl    $0x2,%eax
c01043fb:	01 d0                	add    %edx,%eax
c01043fd:	c1 e0 02             	shl    $0x2,%eax
c0104400:	89 c2                	mov    %eax,%edx
c0104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104405:	01 d0                	add    %edx,%eax
c0104407:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
c010440a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440d:	8b 40 08             	mov    0x8(%eax),%eax
c0104410:	2b 45 08             	sub    0x8(%ebp),%eax
c0104413:	89 c2                	mov    %eax,%edx
c0104415:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104418:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
c010441b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010441e:	83 c0 04             	add    $0x4,%eax
c0104421:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104428:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010442b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010442e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104431:	0f ab 10             	bts    %edx,(%eax)
            // list_add(&free_list, &(p->page_link));
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
c0104434:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104437:	8d 50 0c             	lea    0xc(%eax),%edx
c010443a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010443d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104440:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104446:	8b 00                	mov    (%eax),%eax
c0104448:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010444b:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010444e:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104454:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104457:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010445a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010445d:	89 10                	mov    %edx,(%eax)
c010445f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104462:	8b 10                	mov    (%eax),%edx
c0104464:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104467:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010446a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010446d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104470:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104473:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104476:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104479:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c010447b:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104480:	2b 45 08             	sub    0x8(%ebp),%eax
c0104483:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
        ClearPageProperty(page);    // mark as "not head page"
c0104488:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010448b:	83 c0 04             	add    $0x4,%eax
c010448e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104495:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104498:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010449b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010449e:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c01044a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01044a4:	c9                   	leave  
c01044a5:	c3                   	ret    

c01044a6 <default_free_pages>:

// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
c01044a6:	55                   	push   %ebp
c01044a7:	89 e5                	mov    %esp,%ebp
c01044a9:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c01044af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01044b3:	75 19                	jne    c01044ce <default_free_pages+0x28>
c01044b5:	68 d8 69 10 c0       	push   $0xc01069d8
c01044ba:	68 de 69 10 c0       	push   $0xc01069de
c01044bf:	68 9d 00 00 00       	push   $0x9d
c01044c4:	68 f3 69 10 c0       	push   $0xc01069f3
c01044c9:	e8 07 bf ff ff       	call   c01003d5 <__panic>
    struct Page *p = base;
c01044ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01044d4:	e9 8f 00 00 00       	jmp    c0104568 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c01044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044dc:	83 c0 04             	add    $0x4,%eax
c01044df:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c01044e6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01044e9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01044ec:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01044ef:	0f a3 10             	bt     %edx,(%eax)
c01044f2:	19 c0                	sbb    %eax,%eax
c01044f4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01044f7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01044fb:	0f 95 c0             	setne  %al
c01044fe:	0f b6 c0             	movzbl %al,%eax
c0104501:	85 c0                	test   %eax,%eax
c0104503:	75 2c                	jne    c0104531 <default_free_pages+0x8b>
c0104505:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104508:	83 c0 04             	add    $0x4,%eax
c010450b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104512:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104515:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104518:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010451b:	0f a3 10             	bt     %edx,(%eax)
c010451e:	19 c0                	sbb    %eax,%eax
c0104520:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
c0104523:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
c0104527:	0f 95 c0             	setne  %al
c010452a:	0f b6 c0             	movzbl %al,%eax
c010452d:	85 c0                	test   %eax,%eax
c010452f:	74 19                	je     c010454a <default_free_pages+0xa4>
c0104531:	68 1c 6a 10 c0       	push   $0xc0106a1c
c0104536:	68 de 69 10 c0       	push   $0xc01069de
c010453b:	68 a0 00 00 00       	push   $0xa0
c0104540:	68 f3 69 10 c0       	push   $0xc01069f3
c0104545:	e8 8b be ff ff       	call   c01003d5 <__panic>
        p->flags = 0;
c010454a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
c0104554:	83 ec 08             	sub    $0x8,%esp
c0104557:	6a 00                	push   $0x0
c0104559:	ff 75 f4             	pushl  -0xc(%ebp)
c010455c:	e8 4c fc ff ff       	call   c01041ad <set_page_ref>
c0104561:	83 c4 10             	add    $0x10,%esp
// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104564:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104568:	8b 55 0c             	mov    0xc(%ebp),%edx
c010456b:	89 d0                	mov    %edx,%eax
c010456d:	c1 e0 02             	shl    $0x2,%eax
c0104570:	01 d0                	add    %edx,%eax
c0104572:	c1 e0 02             	shl    $0x2,%eax
c0104575:	89 c2                	mov    %eax,%edx
c0104577:	8b 45 08             	mov    0x8(%ebp),%eax
c010457a:	01 d0                	add    %edx,%eax
c010457c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010457f:	0f 85 54 ff ff ff    	jne    c01044d9 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
c0104585:	8b 45 08             	mov    0x8(%ebp),%eax
c0104588:	8b 55 0c             	mov    0xc(%ebp),%edx
c010458b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010458e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104591:	83 c0 04             	add    $0x4,%eax
c0104594:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010459b:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010459e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01045a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045a4:	0f ab 10             	bts    %edx,(%eax)
c01045a7:	c7 45 e8 bc 89 11 c0 	movl   $0xc01189bc,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01045ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045b1:	8b 40 04             	mov    0x4(%eax),%eax

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
c01045b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01045b7:	e9 1f 01 00 00       	jmp    c01046db <default_free_pages+0x235>
        p = le2page(le, page_link);
c01045bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045bf:	83 e8 0c             	sub    $0xc,%eax
c01045c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045ce:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01045d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
c01045d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d7:	8b 50 08             	mov    0x8(%eax),%edx
c01045da:	89 d0                	mov    %edx,%eax
c01045dc:	c1 e0 02             	shl    $0x2,%eax
c01045df:	01 d0                	add    %edx,%eax
c01045e1:	c1 e0 02             	shl    $0x2,%eax
c01045e4:	89 c2                	mov    %eax,%edx
c01045e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e9:	01 d0                	add    %edx,%eax
c01045eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01045ee:	75 67                	jne    c0104657 <default_free_pages+0x1b1>
            base->property += p->property;
c01045f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045f3:	8b 50 08             	mov    0x8(%eax),%edx
c01045f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f9:	8b 40 08             	mov    0x8(%eax),%eax
c01045fc:	01 c2                	add    %eax,%edx
c01045fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104601:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
c0104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104607:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c010460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104611:	83 c0 04             	add    $0x4,%eax
c0104614:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010461b:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010461e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104621:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104624:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462a:	83 c0 0c             	add    $0xc,%eax
c010462d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104630:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104633:	8b 40 04             	mov    0x4(%eax),%eax
c0104636:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104639:	8b 12                	mov    (%edx),%edx
c010463b:	89 55 a8             	mov    %edx,-0x58(%ebp)
c010463e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104641:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104644:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104647:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010464a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010464d:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104650:	89 10                	mov    %edx,(%eax)
c0104652:	e9 84 00 00 00       	jmp    c01046db <default_free_pages+0x235>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
c0104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010465a:	8b 50 08             	mov    0x8(%eax),%edx
c010465d:	89 d0                	mov    %edx,%eax
c010465f:	c1 e0 02             	shl    $0x2,%eax
c0104662:	01 d0                	add    %edx,%eax
c0104664:	c1 e0 02             	shl    $0x2,%eax
c0104667:	89 c2                	mov    %eax,%edx
c0104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010466c:	01 d0                	add    %edx,%eax
c010466e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104671:	75 68                	jne    c01046db <default_free_pages+0x235>
            p->property += base->property;
c0104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104676:	8b 50 08             	mov    0x8(%eax),%edx
c0104679:	8b 45 08             	mov    0x8(%ebp),%eax
c010467c:	8b 40 08             	mov    0x8(%eax),%eax
c010467f:	01 c2                	add    %eax,%edx
c0104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104684:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
c0104687:	8b 45 08             	mov    0x8(%ebp),%eax
c010468a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
c0104691:	8b 45 08             	mov    0x8(%ebp),%eax
c0104694:	83 c0 04             	add    $0x4,%eax
c0104697:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010469e:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01046a1:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01046a4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01046a7:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01046aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ad:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01046b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b3:	83 c0 0c             	add    $0xc,%eax
c01046b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01046b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01046bc:	8b 40 04             	mov    0x4(%eax),%eax
c01046bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046c2:	8b 12                	mov    (%edx),%edx
c01046c4:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01046c7:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01046ca:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01046cd:	8b 55 98             	mov    -0x68(%ebp),%edx
c01046d0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01046d3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01046d6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01046d9:	89 10                	mov    %edx,(%eax)
    base->property = n;
    SetPageProperty(base);

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c01046db:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c01046e2:	0f 85 d4 fe ff ff    	jne    c01045bc <default_free_pages+0x116>
c01046e8:	c7 45 d0 bc 89 11 c0 	movl   $0xc01189bc,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01046ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01046f2:	8b 40 04             	mov    0x4(%eax),%eax
            list_del(&(p->page_link));
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
c01046f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01046f8:	eb 20                	jmp    c010471a <default_free_pages+0x274>
        p = le2page(le, page_link);
c01046fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046fd:	83 e8 0c             	sub    $0xc,%eax
c0104700:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
c0104703:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104706:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104709:	77 1a                	ja     c0104725 <default_free_pages+0x27f>
c010470b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010470e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104711:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104714:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0104717:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
c010471a:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c0104721:	75 d7                	jne    c01046fa <default_free_pages+0x254>
c0104723:	eb 01                	jmp    c0104726 <default_free_pages+0x280>
        p = le2page(le, page_link);
        if (p > base) {
            break;
c0104725:	90                   	nop
        }
        le = list_next(le);
    }
    
    nr_free += n;
c0104726:	8b 15 c4 89 11 c0    	mov    0xc01189c4,%edx
c010472c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010472f:	01 d0                	add    %edx,%eax
c0104731:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
    // list_add(&free_list, &(base->page_link));
    list_add_before(le, &(base->page_link)); 
c0104736:	8b 45 08             	mov    0x8(%ebp),%eax
c0104739:	8d 50 0c             	lea    0xc(%eax),%edx
c010473c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010473f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104742:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104745:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104748:	8b 00                	mov    (%eax),%eax
c010474a:	8b 55 90             	mov    -0x70(%ebp),%edx
c010474d:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104750:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104753:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104756:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104759:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010475c:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010475f:	89 10                	mov    %edx,(%eax)
c0104761:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104764:	8b 10                	mov    (%eax),%edx
c0104766:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104769:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010476c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010476f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104772:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104775:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104778:	8b 55 88             	mov    -0x78(%ebp),%edx
c010477b:	89 10                	mov    %edx,(%eax)
}
c010477d:	90                   	nop
c010477e:	c9                   	leave  
c010477f:	c3                   	ret    

c0104780 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104780:	55                   	push   %ebp
c0104781:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104783:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
}
c0104788:	5d                   	pop    %ebp
c0104789:	c3                   	ret    

c010478a <basic_check>:

static void
basic_check(void) {
c010478a:	55                   	push   %ebp
c010478b:	89 e5                	mov    %esp,%ebp
c010478d:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104797:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010479d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01047a3:	83 ec 0c             	sub    $0xc,%esp
c01047a6:	6a 01                	push   $0x1
c01047a8:	e8 e2 e4 ff ff       	call   c0102c8f <alloc_pages>
c01047ad:	83 c4 10             	add    $0x10,%esp
c01047b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01047b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01047b7:	75 19                	jne    c01047d2 <basic_check+0x48>
c01047b9:	68 41 6a 10 c0       	push   $0xc0106a41
c01047be:	68 de 69 10 c0       	push   $0xc01069de
c01047c3:	68 d5 00 00 00       	push   $0xd5
c01047c8:	68 f3 69 10 c0       	push   $0xc01069f3
c01047cd:	e8 03 bc ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01047d2:	83 ec 0c             	sub    $0xc,%esp
c01047d5:	6a 01                	push   $0x1
c01047d7:	e8 b3 e4 ff ff       	call   c0102c8f <alloc_pages>
c01047dc:	83 c4 10             	add    $0x10,%esp
c01047df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047e6:	75 19                	jne    c0104801 <basic_check+0x77>
c01047e8:	68 5d 6a 10 c0       	push   $0xc0106a5d
c01047ed:	68 de 69 10 c0       	push   $0xc01069de
c01047f2:	68 d6 00 00 00       	push   $0xd6
c01047f7:	68 f3 69 10 c0       	push   $0xc01069f3
c01047fc:	e8 d4 bb ff ff       	call   c01003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104801:	83 ec 0c             	sub    $0xc,%esp
c0104804:	6a 01                	push   $0x1
c0104806:	e8 84 e4 ff ff       	call   c0102c8f <alloc_pages>
c010480b:	83 c4 10             	add    $0x10,%esp
c010480e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104815:	75 19                	jne    c0104830 <basic_check+0xa6>
c0104817:	68 79 6a 10 c0       	push   $0xc0106a79
c010481c:	68 de 69 10 c0       	push   $0xc01069de
c0104821:	68 d7 00 00 00       	push   $0xd7
c0104826:	68 f3 69 10 c0       	push   $0xc01069f3
c010482b:	e8 a5 bb ff ff       	call   c01003d5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104830:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104833:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104836:	74 10                	je     c0104848 <basic_check+0xbe>
c0104838:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010483b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010483e:	74 08                	je     c0104848 <basic_check+0xbe>
c0104840:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104843:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104846:	75 19                	jne    c0104861 <basic_check+0xd7>
c0104848:	68 98 6a 10 c0       	push   $0xc0106a98
c010484d:	68 de 69 10 c0       	push   $0xc01069de
c0104852:	68 d9 00 00 00       	push   $0xd9
c0104857:	68 f3 69 10 c0       	push   $0xc01069f3
c010485c:	e8 74 bb ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104861:	83 ec 0c             	sub    $0xc,%esp
c0104864:	ff 75 ec             	pushl  -0x14(%ebp)
c0104867:	e8 37 f9 ff ff       	call   c01041a3 <page_ref>
c010486c:	83 c4 10             	add    $0x10,%esp
c010486f:	85 c0                	test   %eax,%eax
c0104871:	75 24                	jne    c0104897 <basic_check+0x10d>
c0104873:	83 ec 0c             	sub    $0xc,%esp
c0104876:	ff 75 f0             	pushl  -0x10(%ebp)
c0104879:	e8 25 f9 ff ff       	call   c01041a3 <page_ref>
c010487e:	83 c4 10             	add    $0x10,%esp
c0104881:	85 c0                	test   %eax,%eax
c0104883:	75 12                	jne    c0104897 <basic_check+0x10d>
c0104885:	83 ec 0c             	sub    $0xc,%esp
c0104888:	ff 75 f4             	pushl  -0xc(%ebp)
c010488b:	e8 13 f9 ff ff       	call   c01041a3 <page_ref>
c0104890:	83 c4 10             	add    $0x10,%esp
c0104893:	85 c0                	test   %eax,%eax
c0104895:	74 19                	je     c01048b0 <basic_check+0x126>
c0104897:	68 bc 6a 10 c0       	push   $0xc0106abc
c010489c:	68 de 69 10 c0       	push   $0xc01069de
c01048a1:	68 da 00 00 00       	push   $0xda
c01048a6:	68 f3 69 10 c0       	push   $0xc01069f3
c01048ab:	e8 25 bb ff ff       	call   c01003d5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01048b0:	83 ec 0c             	sub    $0xc,%esp
c01048b3:	ff 75 ec             	pushl  -0x14(%ebp)
c01048b6:	e8 d5 f8 ff ff       	call   c0104190 <page2pa>
c01048bb:	83 c4 10             	add    $0x10,%esp
c01048be:	89 c2                	mov    %eax,%edx
c01048c0:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01048c5:	c1 e0 0c             	shl    $0xc,%eax
c01048c8:	39 c2                	cmp    %eax,%edx
c01048ca:	72 19                	jb     c01048e5 <basic_check+0x15b>
c01048cc:	68 f8 6a 10 c0       	push   $0xc0106af8
c01048d1:	68 de 69 10 c0       	push   $0xc01069de
c01048d6:	68 dc 00 00 00       	push   $0xdc
c01048db:	68 f3 69 10 c0       	push   $0xc01069f3
c01048e0:	e8 f0 ba ff ff       	call   c01003d5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01048e5:	83 ec 0c             	sub    $0xc,%esp
c01048e8:	ff 75 f0             	pushl  -0x10(%ebp)
c01048eb:	e8 a0 f8 ff ff       	call   c0104190 <page2pa>
c01048f0:	83 c4 10             	add    $0x10,%esp
c01048f3:	89 c2                	mov    %eax,%edx
c01048f5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01048fa:	c1 e0 0c             	shl    $0xc,%eax
c01048fd:	39 c2                	cmp    %eax,%edx
c01048ff:	72 19                	jb     c010491a <basic_check+0x190>
c0104901:	68 15 6b 10 c0       	push   $0xc0106b15
c0104906:	68 de 69 10 c0       	push   $0xc01069de
c010490b:	68 dd 00 00 00       	push   $0xdd
c0104910:	68 f3 69 10 c0       	push   $0xc01069f3
c0104915:	e8 bb ba ff ff       	call   c01003d5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010491a:	83 ec 0c             	sub    $0xc,%esp
c010491d:	ff 75 f4             	pushl  -0xc(%ebp)
c0104920:	e8 6b f8 ff ff       	call   c0104190 <page2pa>
c0104925:	83 c4 10             	add    $0x10,%esp
c0104928:	89 c2                	mov    %eax,%edx
c010492a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010492f:	c1 e0 0c             	shl    $0xc,%eax
c0104932:	39 c2                	cmp    %eax,%edx
c0104934:	72 19                	jb     c010494f <basic_check+0x1c5>
c0104936:	68 32 6b 10 c0       	push   $0xc0106b32
c010493b:	68 de 69 10 c0       	push   $0xc01069de
c0104940:	68 de 00 00 00       	push   $0xde
c0104945:	68 f3 69 10 c0       	push   $0xc01069f3
c010494a:	e8 86 ba ff ff       	call   c01003d5 <__panic>

    list_entry_t free_list_store = free_list;
c010494f:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104954:	8b 15 c0 89 11 c0    	mov    0xc01189c0,%edx
c010495a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010495d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104960:	c7 45 e4 bc 89 11 c0 	movl   $0xc01189bc,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010496a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010496d:	89 50 04             	mov    %edx,0x4(%eax)
c0104970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104973:	8b 50 04             	mov    0x4(%eax),%edx
c0104976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104979:	89 10                	mov    %edx,(%eax)
c010497b:	c7 45 d8 bc 89 11 c0 	movl   $0xc01189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104982:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104985:	8b 40 04             	mov    0x4(%eax),%eax
c0104988:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010498b:	0f 94 c0             	sete   %al
c010498e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104991:	85 c0                	test   %eax,%eax
c0104993:	75 19                	jne    c01049ae <basic_check+0x224>
c0104995:	68 4f 6b 10 c0       	push   $0xc0106b4f
c010499a:	68 de 69 10 c0       	push   $0xc01069de
c010499f:	68 e2 00 00 00       	push   $0xe2
c01049a4:	68 f3 69 10 c0       	push   $0xc01069f3
c01049a9:	e8 27 ba ff ff       	call   c01003d5 <__panic>

    unsigned int nr_free_store = nr_free;
c01049ae:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c01049b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01049b6:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c01049bd:	00 00 00 

    assert(alloc_page() == NULL);
c01049c0:	83 ec 0c             	sub    $0xc,%esp
c01049c3:	6a 01                	push   $0x1
c01049c5:	e8 c5 e2 ff ff       	call   c0102c8f <alloc_pages>
c01049ca:	83 c4 10             	add    $0x10,%esp
c01049cd:	85 c0                	test   %eax,%eax
c01049cf:	74 19                	je     c01049ea <basic_check+0x260>
c01049d1:	68 66 6b 10 c0       	push   $0xc0106b66
c01049d6:	68 de 69 10 c0       	push   $0xc01069de
c01049db:	68 e7 00 00 00       	push   $0xe7
c01049e0:	68 f3 69 10 c0       	push   $0xc01069f3
c01049e5:	e8 eb b9 ff ff       	call   c01003d5 <__panic>

    free_page(p0);
c01049ea:	83 ec 08             	sub    $0x8,%esp
c01049ed:	6a 01                	push   $0x1
c01049ef:	ff 75 ec             	pushl  -0x14(%ebp)
c01049f2:	e8 d6 e2 ff ff       	call   c0102ccd <free_pages>
c01049f7:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01049fa:	83 ec 08             	sub    $0x8,%esp
c01049fd:	6a 01                	push   $0x1
c01049ff:	ff 75 f0             	pushl  -0x10(%ebp)
c0104a02:	e8 c6 e2 ff ff       	call   c0102ccd <free_pages>
c0104a07:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104a0a:	83 ec 08             	sub    $0x8,%esp
c0104a0d:	6a 01                	push   $0x1
c0104a0f:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a12:	e8 b6 e2 ff ff       	call   c0102ccd <free_pages>
c0104a17:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104a1a:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104a1f:	83 f8 03             	cmp    $0x3,%eax
c0104a22:	74 19                	je     c0104a3d <basic_check+0x2b3>
c0104a24:	68 7b 6b 10 c0       	push   $0xc0106b7b
c0104a29:	68 de 69 10 c0       	push   $0xc01069de
c0104a2e:	68 ec 00 00 00       	push   $0xec
c0104a33:	68 f3 69 10 c0       	push   $0xc01069f3
c0104a38:	e8 98 b9 ff ff       	call   c01003d5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104a3d:	83 ec 0c             	sub    $0xc,%esp
c0104a40:	6a 01                	push   $0x1
c0104a42:	e8 48 e2 ff ff       	call   c0102c8f <alloc_pages>
c0104a47:	83 c4 10             	add    $0x10,%esp
c0104a4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104a51:	75 19                	jne    c0104a6c <basic_check+0x2e2>
c0104a53:	68 41 6a 10 c0       	push   $0xc0106a41
c0104a58:	68 de 69 10 c0       	push   $0xc01069de
c0104a5d:	68 ee 00 00 00       	push   $0xee
c0104a62:	68 f3 69 10 c0       	push   $0xc01069f3
c0104a67:	e8 69 b9 ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104a6c:	83 ec 0c             	sub    $0xc,%esp
c0104a6f:	6a 01                	push   $0x1
c0104a71:	e8 19 e2 ff ff       	call   c0102c8f <alloc_pages>
c0104a76:	83 c4 10             	add    $0x10,%esp
c0104a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a80:	75 19                	jne    c0104a9b <basic_check+0x311>
c0104a82:	68 5d 6a 10 c0       	push   $0xc0106a5d
c0104a87:	68 de 69 10 c0       	push   $0xc01069de
c0104a8c:	68 ef 00 00 00       	push   $0xef
c0104a91:	68 f3 69 10 c0       	push   $0xc01069f3
c0104a96:	e8 3a b9 ff ff       	call   c01003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104a9b:	83 ec 0c             	sub    $0xc,%esp
c0104a9e:	6a 01                	push   $0x1
c0104aa0:	e8 ea e1 ff ff       	call   c0102c8f <alloc_pages>
c0104aa5:	83 c4 10             	add    $0x10,%esp
c0104aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104aaf:	75 19                	jne    c0104aca <basic_check+0x340>
c0104ab1:	68 79 6a 10 c0       	push   $0xc0106a79
c0104ab6:	68 de 69 10 c0       	push   $0xc01069de
c0104abb:	68 f0 00 00 00       	push   $0xf0
c0104ac0:	68 f3 69 10 c0       	push   $0xc01069f3
c0104ac5:	e8 0b b9 ff ff       	call   c01003d5 <__panic>

    assert(alloc_page() == NULL);
c0104aca:	83 ec 0c             	sub    $0xc,%esp
c0104acd:	6a 01                	push   $0x1
c0104acf:	e8 bb e1 ff ff       	call   c0102c8f <alloc_pages>
c0104ad4:	83 c4 10             	add    $0x10,%esp
c0104ad7:	85 c0                	test   %eax,%eax
c0104ad9:	74 19                	je     c0104af4 <basic_check+0x36a>
c0104adb:	68 66 6b 10 c0       	push   $0xc0106b66
c0104ae0:	68 de 69 10 c0       	push   $0xc01069de
c0104ae5:	68 f2 00 00 00       	push   $0xf2
c0104aea:	68 f3 69 10 c0       	push   $0xc01069f3
c0104aef:	e8 e1 b8 ff ff       	call   c01003d5 <__panic>

    free_page(p0);
c0104af4:	83 ec 08             	sub    $0x8,%esp
c0104af7:	6a 01                	push   $0x1
c0104af9:	ff 75 ec             	pushl  -0x14(%ebp)
c0104afc:	e8 cc e1 ff ff       	call   c0102ccd <free_pages>
c0104b01:	83 c4 10             	add    $0x10,%esp
c0104b04:	c7 45 e8 bc 89 11 c0 	movl   $0xc01189bc,-0x18(%ebp)
c0104b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b0e:	8b 40 04             	mov    0x4(%eax),%eax
c0104b11:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b14:	0f 94 c0             	sete   %al
c0104b17:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104b1a:	85 c0                	test   %eax,%eax
c0104b1c:	74 19                	je     c0104b37 <basic_check+0x3ad>
c0104b1e:	68 88 6b 10 c0       	push   $0xc0106b88
c0104b23:	68 de 69 10 c0       	push   $0xc01069de
c0104b28:	68 f5 00 00 00       	push   $0xf5
c0104b2d:	68 f3 69 10 c0       	push   $0xc01069f3
c0104b32:	e8 9e b8 ff ff       	call   c01003d5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104b37:	83 ec 0c             	sub    $0xc,%esp
c0104b3a:	6a 01                	push   $0x1
c0104b3c:	e8 4e e1 ff ff       	call   c0102c8f <alloc_pages>
c0104b41:	83 c4 10             	add    $0x10,%esp
c0104b44:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104b47:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b4a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104b4d:	74 19                	je     c0104b68 <basic_check+0x3de>
c0104b4f:	68 a0 6b 10 c0       	push   $0xc0106ba0
c0104b54:	68 de 69 10 c0       	push   $0xc01069de
c0104b59:	68 f8 00 00 00       	push   $0xf8
c0104b5e:	68 f3 69 10 c0       	push   $0xc01069f3
c0104b63:	e8 6d b8 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104b68:	83 ec 0c             	sub    $0xc,%esp
c0104b6b:	6a 01                	push   $0x1
c0104b6d:	e8 1d e1 ff ff       	call   c0102c8f <alloc_pages>
c0104b72:	83 c4 10             	add    $0x10,%esp
c0104b75:	85 c0                	test   %eax,%eax
c0104b77:	74 19                	je     c0104b92 <basic_check+0x408>
c0104b79:	68 66 6b 10 c0       	push   $0xc0106b66
c0104b7e:	68 de 69 10 c0       	push   $0xc01069de
c0104b83:	68 f9 00 00 00       	push   $0xf9
c0104b88:	68 f3 69 10 c0       	push   $0xc01069f3
c0104b8d:	e8 43 b8 ff ff       	call   c01003d5 <__panic>

    assert(nr_free == 0);
c0104b92:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104b97:	85 c0                	test   %eax,%eax
c0104b99:	74 19                	je     c0104bb4 <basic_check+0x42a>
c0104b9b:	68 b9 6b 10 c0       	push   $0xc0106bb9
c0104ba0:	68 de 69 10 c0       	push   $0xc01069de
c0104ba5:	68 fb 00 00 00       	push   $0xfb
c0104baa:	68 f3 69 10 c0       	push   $0xc01069f3
c0104baf:	e8 21 b8 ff ff       	call   c01003d5 <__panic>
    free_list = free_list_store;
c0104bb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104bba:	a3 bc 89 11 c0       	mov    %eax,0xc01189bc
c0104bbf:	89 15 c0 89 11 c0    	mov    %edx,0xc01189c0
    nr_free = nr_free_store;
c0104bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104bc8:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    free_page(p);
c0104bcd:	83 ec 08             	sub    $0x8,%esp
c0104bd0:	6a 01                	push   $0x1
c0104bd2:	ff 75 dc             	pushl  -0x24(%ebp)
c0104bd5:	e8 f3 e0 ff ff       	call   c0102ccd <free_pages>
c0104bda:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104bdd:	83 ec 08             	sub    $0x8,%esp
c0104be0:	6a 01                	push   $0x1
c0104be2:	ff 75 f0             	pushl  -0x10(%ebp)
c0104be5:	e8 e3 e0 ff ff       	call   c0102ccd <free_pages>
c0104bea:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104bed:	83 ec 08             	sub    $0x8,%esp
c0104bf0:	6a 01                	push   $0x1
c0104bf2:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bf5:	e8 d3 e0 ff ff       	call   c0102ccd <free_pages>
c0104bfa:	83 c4 10             	add    $0x10,%esp
}
c0104bfd:	90                   	nop
c0104bfe:	c9                   	leave  
c0104bff:	c3                   	ret    

c0104c00 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104c00:	55                   	push   %ebp
c0104c01:	89 e5                	mov    %esp,%ebp
c0104c03:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104c09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104c10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104c17:	c7 45 ec bc 89 11 c0 	movl   $0xc01189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104c1e:	eb 60                	jmp    c0104c80 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c23:	83 e8 0c             	sub    $0xc,%eax
c0104c26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c2c:	83 c0 04             	add    $0x4,%eax
c0104c2f:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104c36:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c39:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104c3c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104c3f:	0f a3 10             	bt     %edx,(%eax)
c0104c42:	19 c0                	sbb    %eax,%eax
c0104c44:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104c47:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104c4b:	0f 95 c0             	setne  %al
c0104c4e:	0f b6 c0             	movzbl %al,%eax
c0104c51:	85 c0                	test   %eax,%eax
c0104c53:	75 19                	jne    c0104c6e <default_check+0x6e>
c0104c55:	68 c6 6b 10 c0       	push   $0xc0106bc6
c0104c5a:	68 de 69 10 c0       	push   $0xc01069de
c0104c5f:	68 0c 01 00 00       	push   $0x10c
c0104c64:	68 f3 69 10 c0       	push   $0xc01069f3
c0104c69:	e8 67 b7 ff ff       	call   c01003d5 <__panic>
        count ++, total += p->property;
c0104c6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c75:	8b 50 08             	mov    0x8(%eax),%edx
c0104c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c7b:	01 d0                	add    %edx,%eax
c0104c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c83:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c89:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c8f:	81 7d ec bc 89 11 c0 	cmpl   $0xc01189bc,-0x14(%ebp)
c0104c96:	75 88                	jne    c0104c20 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104c98:	e8 65 e0 ff ff       	call   c0102d02 <nr_free_pages>
c0104c9d:	89 c2                	mov    %eax,%edx
c0104c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca2:	39 c2                	cmp    %eax,%edx
c0104ca4:	74 19                	je     c0104cbf <default_check+0xbf>
c0104ca6:	68 d6 6b 10 c0       	push   $0xc0106bd6
c0104cab:	68 de 69 10 c0       	push   $0xc01069de
c0104cb0:	68 0f 01 00 00       	push   $0x10f
c0104cb5:	68 f3 69 10 c0       	push   $0xc01069f3
c0104cba:	e8 16 b7 ff ff       	call   c01003d5 <__panic>

    basic_check();
c0104cbf:	e8 c6 fa ff ff       	call   c010478a <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104cc4:	83 ec 0c             	sub    $0xc,%esp
c0104cc7:	6a 05                	push   $0x5
c0104cc9:	e8 c1 df ff ff       	call   c0102c8f <alloc_pages>
c0104cce:	83 c4 10             	add    $0x10,%esp
c0104cd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0104cd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104cd8:	75 19                	jne    c0104cf3 <default_check+0xf3>
c0104cda:	68 ef 6b 10 c0       	push   $0xc0106bef
c0104cdf:	68 de 69 10 c0       	push   $0xc01069de
c0104ce4:	68 14 01 00 00       	push   $0x114
c0104ce9:	68 f3 69 10 c0       	push   $0xc01069f3
c0104cee:	e8 e2 b6 ff ff       	call   c01003d5 <__panic>
    assert(!PageProperty(p0));
c0104cf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104cf6:	83 c0 04             	add    $0x4,%eax
c0104cf9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104d00:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d03:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104d06:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104d09:	0f a3 10             	bt     %edx,(%eax)
c0104d0c:	19 c0                	sbb    %eax,%eax
c0104d0e:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104d11:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104d15:	0f 95 c0             	setne  %al
c0104d18:	0f b6 c0             	movzbl %al,%eax
c0104d1b:	85 c0                	test   %eax,%eax
c0104d1d:	74 19                	je     c0104d38 <default_check+0x138>
c0104d1f:	68 fa 6b 10 c0       	push   $0xc0106bfa
c0104d24:	68 de 69 10 c0       	push   $0xc01069de
c0104d29:	68 15 01 00 00       	push   $0x115
c0104d2e:	68 f3 69 10 c0       	push   $0xc01069f3
c0104d33:	e8 9d b6 ff ff       	call   c01003d5 <__panic>

    list_entry_t free_list_store = free_list;
c0104d38:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104d3d:	8b 15 c0 89 11 c0    	mov    0xc01189c0,%edx
c0104d43:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104d46:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104d49:	c7 45 d0 bc 89 11 c0 	movl   $0xc01189bc,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104d50:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d53:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104d56:	89 50 04             	mov    %edx,0x4(%eax)
c0104d59:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d5c:	8b 50 04             	mov    0x4(%eax),%edx
c0104d5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d62:	89 10                	mov    %edx,(%eax)
c0104d64:	c7 45 d8 bc 89 11 c0 	movl   $0xc01189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104d6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104d6e:	8b 40 04             	mov    0x4(%eax),%eax
c0104d71:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104d74:	0f 94 c0             	sete   %al
c0104d77:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104d7a:	85 c0                	test   %eax,%eax
c0104d7c:	75 19                	jne    c0104d97 <default_check+0x197>
c0104d7e:	68 4f 6b 10 c0       	push   $0xc0106b4f
c0104d83:	68 de 69 10 c0       	push   $0xc01069de
c0104d88:	68 19 01 00 00       	push   $0x119
c0104d8d:	68 f3 69 10 c0       	push   $0xc01069f3
c0104d92:	e8 3e b6 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104d97:	83 ec 0c             	sub    $0xc,%esp
c0104d9a:	6a 01                	push   $0x1
c0104d9c:	e8 ee de ff ff       	call   c0102c8f <alloc_pages>
c0104da1:	83 c4 10             	add    $0x10,%esp
c0104da4:	85 c0                	test   %eax,%eax
c0104da6:	74 19                	je     c0104dc1 <default_check+0x1c1>
c0104da8:	68 66 6b 10 c0       	push   $0xc0106b66
c0104dad:	68 de 69 10 c0       	push   $0xc01069de
c0104db2:	68 1a 01 00 00       	push   $0x11a
c0104db7:	68 f3 69 10 c0       	push   $0xc01069f3
c0104dbc:	e8 14 b6 ff ff       	call   c01003d5 <__panic>

    unsigned int nr_free_store = nr_free;
c0104dc1:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104dc6:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104dc9:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c0104dd0:	00 00 00 

    free_pages(p0 + 2, 3);
c0104dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104dd6:	83 c0 28             	add    $0x28,%eax
c0104dd9:	83 ec 08             	sub    $0x8,%esp
c0104ddc:	6a 03                	push   $0x3
c0104dde:	50                   	push   %eax
c0104ddf:	e8 e9 de ff ff       	call   c0102ccd <free_pages>
c0104de4:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104de7:	83 ec 0c             	sub    $0xc,%esp
c0104dea:	6a 04                	push   $0x4
c0104dec:	e8 9e de ff ff       	call   c0102c8f <alloc_pages>
c0104df1:	83 c4 10             	add    $0x10,%esp
c0104df4:	85 c0                	test   %eax,%eax
c0104df6:	74 19                	je     c0104e11 <default_check+0x211>
c0104df8:	68 0c 6c 10 c0       	push   $0xc0106c0c
c0104dfd:	68 de 69 10 c0       	push   $0xc01069de
c0104e02:	68 20 01 00 00       	push   $0x120
c0104e07:	68 f3 69 10 c0       	push   $0xc01069f3
c0104e0c:	e8 c4 b5 ff ff       	call   c01003d5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104e11:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e14:	83 c0 28             	add    $0x28,%eax
c0104e17:	83 c0 04             	add    $0x4,%eax
c0104e1a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104e21:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e24:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104e27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e2a:	0f a3 10             	bt     %edx,(%eax)
c0104e2d:	19 c0                	sbb    %eax,%eax
c0104e2f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104e32:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104e36:	0f 95 c0             	setne  %al
c0104e39:	0f b6 c0             	movzbl %al,%eax
c0104e3c:	85 c0                	test   %eax,%eax
c0104e3e:	74 0e                	je     c0104e4e <default_check+0x24e>
c0104e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e43:	83 c0 28             	add    $0x28,%eax
c0104e46:	8b 40 08             	mov    0x8(%eax),%eax
c0104e49:	83 f8 03             	cmp    $0x3,%eax
c0104e4c:	74 19                	je     c0104e67 <default_check+0x267>
c0104e4e:	68 24 6c 10 c0       	push   $0xc0106c24
c0104e53:	68 de 69 10 c0       	push   $0xc01069de
c0104e58:	68 21 01 00 00       	push   $0x121
c0104e5d:	68 f3 69 10 c0       	push   $0xc01069f3
c0104e62:	e8 6e b5 ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104e67:	83 ec 0c             	sub    $0xc,%esp
c0104e6a:	6a 03                	push   $0x3
c0104e6c:	e8 1e de ff ff       	call   c0102c8f <alloc_pages>
c0104e71:	83 c4 10             	add    $0x10,%esp
c0104e74:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104e77:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104e7b:	75 19                	jne    c0104e96 <default_check+0x296>
c0104e7d:	68 50 6c 10 c0       	push   $0xc0106c50
c0104e82:	68 de 69 10 c0       	push   $0xc01069de
c0104e87:	68 22 01 00 00       	push   $0x122
c0104e8c:	68 f3 69 10 c0       	push   $0xc01069f3
c0104e91:	e8 3f b5 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104e96:	83 ec 0c             	sub    $0xc,%esp
c0104e99:	6a 01                	push   $0x1
c0104e9b:	e8 ef dd ff ff       	call   c0102c8f <alloc_pages>
c0104ea0:	83 c4 10             	add    $0x10,%esp
c0104ea3:	85 c0                	test   %eax,%eax
c0104ea5:	74 19                	je     c0104ec0 <default_check+0x2c0>
c0104ea7:	68 66 6b 10 c0       	push   $0xc0106b66
c0104eac:	68 de 69 10 c0       	push   $0xc01069de
c0104eb1:	68 23 01 00 00       	push   $0x123
c0104eb6:	68 f3 69 10 c0       	push   $0xc01069f3
c0104ebb:	e8 15 b5 ff ff       	call   c01003d5 <__panic>
    assert(p0 + 2 == p1);
c0104ec0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ec3:	83 c0 28             	add    $0x28,%eax
c0104ec6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104ec9:	74 19                	je     c0104ee4 <default_check+0x2e4>
c0104ecb:	68 6e 6c 10 c0       	push   $0xc0106c6e
c0104ed0:	68 de 69 10 c0       	push   $0xc01069de
c0104ed5:	68 24 01 00 00       	push   $0x124
c0104eda:	68 f3 69 10 c0       	push   $0xc01069f3
c0104edf:	e8 f1 b4 ff ff       	call   c01003d5 <__panic>

    p2 = p0 + 1;
c0104ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ee7:	83 c0 14             	add    $0x14,%eax
c0104eea:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104eed:	83 ec 08             	sub    $0x8,%esp
c0104ef0:	6a 01                	push   $0x1
c0104ef2:	ff 75 dc             	pushl  -0x24(%ebp)
c0104ef5:	e8 d3 dd ff ff       	call   c0102ccd <free_pages>
c0104efa:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104efd:	83 ec 08             	sub    $0x8,%esp
c0104f00:	6a 03                	push   $0x3
c0104f02:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104f05:	e8 c3 dd ff ff       	call   c0102ccd <free_pages>
c0104f0a:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f10:	83 c0 04             	add    $0x4,%eax
c0104f13:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104f1a:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f1d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104f20:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104f23:	0f a3 10             	bt     %edx,(%eax)
c0104f26:	19 c0                	sbb    %eax,%eax
c0104f28:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104f2b:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104f2f:	0f 95 c0             	setne  %al
c0104f32:	0f b6 c0             	movzbl %al,%eax
c0104f35:	85 c0                	test   %eax,%eax
c0104f37:	74 0b                	je     c0104f44 <default_check+0x344>
c0104f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f3c:	8b 40 08             	mov    0x8(%eax),%eax
c0104f3f:	83 f8 01             	cmp    $0x1,%eax
c0104f42:	74 19                	je     c0104f5d <default_check+0x35d>
c0104f44:	68 7c 6c 10 c0       	push   $0xc0106c7c
c0104f49:	68 de 69 10 c0       	push   $0xc01069de
c0104f4e:	68 29 01 00 00       	push   $0x129
c0104f53:	68 f3 69 10 c0       	push   $0xc01069f3
c0104f58:	e8 78 b4 ff ff       	call   c01003d5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104f5d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f60:	83 c0 04             	add    $0x4,%eax
c0104f63:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104f6a:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f6d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104f70:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104f73:	0f a3 10             	bt     %edx,(%eax)
c0104f76:	19 c0                	sbb    %eax,%eax
c0104f78:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104f7b:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104f7f:	0f 95 c0             	setne  %al
c0104f82:	0f b6 c0             	movzbl %al,%eax
c0104f85:	85 c0                	test   %eax,%eax
c0104f87:	74 0b                	je     c0104f94 <default_check+0x394>
c0104f89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f8c:	8b 40 08             	mov    0x8(%eax),%eax
c0104f8f:	83 f8 03             	cmp    $0x3,%eax
c0104f92:	74 19                	je     c0104fad <default_check+0x3ad>
c0104f94:	68 a4 6c 10 c0       	push   $0xc0106ca4
c0104f99:	68 de 69 10 c0       	push   $0xc01069de
c0104f9e:	68 2a 01 00 00       	push   $0x12a
c0104fa3:	68 f3 69 10 c0       	push   $0xc01069f3
c0104fa8:	e8 28 b4 ff ff       	call   c01003d5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104fad:	83 ec 0c             	sub    $0xc,%esp
c0104fb0:	6a 01                	push   $0x1
c0104fb2:	e8 d8 dc ff ff       	call   c0102c8f <alloc_pages>
c0104fb7:	83 c4 10             	add    $0x10,%esp
c0104fba:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104fbd:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104fc0:	83 e8 14             	sub    $0x14,%eax
c0104fc3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104fc6:	74 19                	je     c0104fe1 <default_check+0x3e1>
c0104fc8:	68 ca 6c 10 c0       	push   $0xc0106cca
c0104fcd:	68 de 69 10 c0       	push   $0xc01069de
c0104fd2:	68 2c 01 00 00       	push   $0x12c
c0104fd7:	68 f3 69 10 c0       	push   $0xc01069f3
c0104fdc:	e8 f4 b3 ff ff       	call   c01003d5 <__panic>
    free_page(p0);
c0104fe1:	83 ec 08             	sub    $0x8,%esp
c0104fe4:	6a 01                	push   $0x1
c0104fe6:	ff 75 dc             	pushl  -0x24(%ebp)
c0104fe9:	e8 df dc ff ff       	call   c0102ccd <free_pages>
c0104fee:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104ff1:	83 ec 0c             	sub    $0xc,%esp
c0104ff4:	6a 02                	push   $0x2
c0104ff6:	e8 94 dc ff ff       	call   c0102c8f <alloc_pages>
c0104ffb:	83 c4 10             	add    $0x10,%esp
c0104ffe:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105001:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105004:	83 c0 14             	add    $0x14,%eax
c0105007:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010500a:	74 19                	je     c0105025 <default_check+0x425>
c010500c:	68 e8 6c 10 c0       	push   $0xc0106ce8
c0105011:	68 de 69 10 c0       	push   $0xc01069de
c0105016:	68 2e 01 00 00       	push   $0x12e
c010501b:	68 f3 69 10 c0       	push   $0xc01069f3
c0105020:	e8 b0 b3 ff ff       	call   c01003d5 <__panic>

    free_pages(p0, 2);
c0105025:	83 ec 08             	sub    $0x8,%esp
c0105028:	6a 02                	push   $0x2
c010502a:	ff 75 dc             	pushl  -0x24(%ebp)
c010502d:	e8 9b dc ff ff       	call   c0102ccd <free_pages>
c0105032:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105035:	83 ec 08             	sub    $0x8,%esp
c0105038:	6a 01                	push   $0x1
c010503a:	ff 75 c0             	pushl  -0x40(%ebp)
c010503d:	e8 8b dc ff ff       	call   c0102ccd <free_pages>
c0105042:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0105045:	83 ec 0c             	sub    $0xc,%esp
c0105048:	6a 05                	push   $0x5
c010504a:	e8 40 dc ff ff       	call   c0102c8f <alloc_pages>
c010504f:	83 c4 10             	add    $0x10,%esp
c0105052:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105055:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105059:	75 19                	jne    c0105074 <default_check+0x474>
c010505b:	68 08 6d 10 c0       	push   $0xc0106d08
c0105060:	68 de 69 10 c0       	push   $0xc01069de
c0105065:	68 33 01 00 00       	push   $0x133
c010506a:	68 f3 69 10 c0       	push   $0xc01069f3
c010506f:	e8 61 b3 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0105074:	83 ec 0c             	sub    $0xc,%esp
c0105077:	6a 01                	push   $0x1
c0105079:	e8 11 dc ff ff       	call   c0102c8f <alloc_pages>
c010507e:	83 c4 10             	add    $0x10,%esp
c0105081:	85 c0                	test   %eax,%eax
c0105083:	74 19                	je     c010509e <default_check+0x49e>
c0105085:	68 66 6b 10 c0       	push   $0xc0106b66
c010508a:	68 de 69 10 c0       	push   $0xc01069de
c010508f:	68 34 01 00 00       	push   $0x134
c0105094:	68 f3 69 10 c0       	push   $0xc01069f3
c0105099:	e8 37 b3 ff ff       	call   c01003d5 <__panic>

    assert(nr_free == 0);
c010509e:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c01050a3:	85 c0                	test   %eax,%eax
c01050a5:	74 19                	je     c01050c0 <default_check+0x4c0>
c01050a7:	68 b9 6b 10 c0       	push   $0xc0106bb9
c01050ac:	68 de 69 10 c0       	push   $0xc01069de
c01050b1:	68 36 01 00 00       	push   $0x136
c01050b6:	68 f3 69 10 c0       	push   $0xc01069f3
c01050bb:	e8 15 b3 ff ff       	call   c01003d5 <__panic>
    nr_free = nr_free_store;
c01050c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01050c3:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    free_list = free_list_store;
c01050c8:	8b 45 80             	mov    -0x80(%ebp),%eax
c01050cb:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01050ce:	a3 bc 89 11 c0       	mov    %eax,0xc01189bc
c01050d3:	89 15 c0 89 11 c0    	mov    %edx,0xc01189c0
    free_pages(p0, 5);
c01050d9:	83 ec 08             	sub    $0x8,%esp
c01050dc:	6a 05                	push   $0x5
c01050de:	ff 75 dc             	pushl  -0x24(%ebp)
c01050e1:	e8 e7 db ff ff       	call   c0102ccd <free_pages>
c01050e6:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01050e9:	c7 45 ec bc 89 11 c0 	movl   $0xc01189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01050f0:	eb 1d                	jmp    c010510f <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c01050f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050f5:	83 e8 0c             	sub    $0xc,%eax
c01050f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c01050fb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01050ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105102:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105105:	8b 40 08             	mov    0x8(%eax),%eax
c0105108:	29 c2                	sub    %eax,%edx
c010510a:	89 d0                	mov    %edx,%eax
c010510c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010510f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105112:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105115:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105118:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010511b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010511e:	81 7d ec bc 89 11 c0 	cmpl   $0xc01189bc,-0x14(%ebp)
c0105125:	75 cb                	jne    c01050f2 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0105127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010512b:	74 19                	je     c0105146 <default_check+0x546>
c010512d:	68 26 6d 10 c0       	push   $0xc0106d26
c0105132:	68 de 69 10 c0       	push   $0xc01069de
c0105137:	68 41 01 00 00       	push   $0x141
c010513c:	68 f3 69 10 c0       	push   $0xc01069f3
c0105141:	e8 8f b2 ff ff       	call   c01003d5 <__panic>
    assert(total == 0);
c0105146:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010514a:	74 19                	je     c0105165 <default_check+0x565>
c010514c:	68 31 6d 10 c0       	push   $0xc0106d31
c0105151:	68 de 69 10 c0       	push   $0xc01069de
c0105156:	68 42 01 00 00       	push   $0x142
c010515b:	68 f3 69 10 c0       	push   $0xc01069f3
c0105160:	e8 70 b2 ff ff       	call   c01003d5 <__panic>
}
c0105165:	90                   	nop
c0105166:	c9                   	leave  
c0105167:	c3                   	ret    

c0105168 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105168:	55                   	push   %ebp
c0105169:	89 e5                	mov    %esp,%ebp
c010516b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010516e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105175:	eb 04                	jmp    c010517b <strlen+0x13>
        cnt ++;
c0105177:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010517b:	8b 45 08             	mov    0x8(%ebp),%eax
c010517e:	8d 50 01             	lea    0x1(%eax),%edx
c0105181:	89 55 08             	mov    %edx,0x8(%ebp)
c0105184:	0f b6 00             	movzbl (%eax),%eax
c0105187:	84 c0                	test   %al,%al
c0105189:	75 ec                	jne    c0105177 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010518b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010518e:	c9                   	leave  
c010518f:	c3                   	ret    

c0105190 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105190:	55                   	push   %ebp
c0105191:	89 e5                	mov    %esp,%ebp
c0105193:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010519d:	eb 04                	jmp    c01051a3 <strnlen+0x13>
        cnt ++;
c010519f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01051a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051a9:	73 10                	jae    c01051bb <strnlen+0x2b>
c01051ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ae:	8d 50 01             	lea    0x1(%eax),%edx
c01051b1:	89 55 08             	mov    %edx,0x8(%ebp)
c01051b4:	0f b6 00             	movzbl (%eax),%eax
c01051b7:	84 c0                	test   %al,%al
c01051b9:	75 e4                	jne    c010519f <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01051bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01051be:	c9                   	leave  
c01051bf:	c3                   	ret    

c01051c0 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01051c0:	55                   	push   %ebp
c01051c1:	89 e5                	mov    %esp,%ebp
c01051c3:	57                   	push   %edi
c01051c4:	56                   	push   %esi
c01051c5:	83 ec 20             	sub    $0x20,%esp
c01051c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01051cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01051d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01051d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051da:	89 d1                	mov    %edx,%ecx
c01051dc:	89 c2                	mov    %eax,%edx
c01051de:	89 ce                	mov    %ecx,%esi
c01051e0:	89 d7                	mov    %edx,%edi
c01051e2:	ac                   	lods   %ds:(%esi),%al
c01051e3:	aa                   	stos   %al,%es:(%edi)
c01051e4:	84 c0                	test   %al,%al
c01051e6:	75 fa                	jne    c01051e2 <strcpy+0x22>
c01051e8:	89 fa                	mov    %edi,%edx
c01051ea:	89 f1                	mov    %esi,%ecx
c01051ec:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01051ef:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01051f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01051f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01051f8:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01051f9:	83 c4 20             	add    $0x20,%esp
c01051fc:	5e                   	pop    %esi
c01051fd:	5f                   	pop    %edi
c01051fe:	5d                   	pop    %ebp
c01051ff:	c3                   	ret    

c0105200 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105200:	55                   	push   %ebp
c0105201:	89 e5                	mov    %esp,%ebp
c0105203:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105206:	8b 45 08             	mov    0x8(%ebp),%eax
c0105209:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010520c:	eb 21                	jmp    c010522f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010520e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105211:	0f b6 10             	movzbl (%eax),%edx
c0105214:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105217:	88 10                	mov    %dl,(%eax)
c0105219:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010521c:	0f b6 00             	movzbl (%eax),%eax
c010521f:	84 c0                	test   %al,%al
c0105221:	74 04                	je     c0105227 <strncpy+0x27>
            src ++;
c0105223:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105227:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010522b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010522f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105233:	75 d9                	jne    c010520e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105235:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105238:	c9                   	leave  
c0105239:	c3                   	ret    

c010523a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010523a:	55                   	push   %ebp
c010523b:	89 e5                	mov    %esp,%ebp
c010523d:	57                   	push   %edi
c010523e:	56                   	push   %esi
c010523f:	83 ec 20             	sub    $0x20,%esp
c0105242:	8b 45 08             	mov    0x8(%ebp),%eax
c0105245:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105248:	8b 45 0c             	mov    0xc(%ebp),%eax
c010524b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010524e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105251:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105254:	89 d1                	mov    %edx,%ecx
c0105256:	89 c2                	mov    %eax,%edx
c0105258:	89 ce                	mov    %ecx,%esi
c010525a:	89 d7                	mov    %edx,%edi
c010525c:	ac                   	lods   %ds:(%esi),%al
c010525d:	ae                   	scas   %es:(%edi),%al
c010525e:	75 08                	jne    c0105268 <strcmp+0x2e>
c0105260:	84 c0                	test   %al,%al
c0105262:	75 f8                	jne    c010525c <strcmp+0x22>
c0105264:	31 c0                	xor    %eax,%eax
c0105266:	eb 04                	jmp    c010526c <strcmp+0x32>
c0105268:	19 c0                	sbb    %eax,%eax
c010526a:	0c 01                	or     $0x1,%al
c010526c:	89 fa                	mov    %edi,%edx
c010526e:	89 f1                	mov    %esi,%ecx
c0105270:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105273:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105276:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105279:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c010527c:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010527d:	83 c4 20             	add    $0x20,%esp
c0105280:	5e                   	pop    %esi
c0105281:	5f                   	pop    %edi
c0105282:	5d                   	pop    %ebp
c0105283:	c3                   	ret    

c0105284 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105284:	55                   	push   %ebp
c0105285:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105287:	eb 0c                	jmp    c0105295 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105289:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010528d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105291:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105299:	74 1a                	je     c01052b5 <strncmp+0x31>
c010529b:	8b 45 08             	mov    0x8(%ebp),%eax
c010529e:	0f b6 00             	movzbl (%eax),%eax
c01052a1:	84 c0                	test   %al,%al
c01052a3:	74 10                	je     c01052b5 <strncmp+0x31>
c01052a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a8:	0f b6 10             	movzbl (%eax),%edx
c01052ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052ae:	0f b6 00             	movzbl (%eax),%eax
c01052b1:	38 c2                	cmp    %al,%dl
c01052b3:	74 d4                	je     c0105289 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01052b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01052b9:	74 18                	je     c01052d3 <strncmp+0x4f>
c01052bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01052be:	0f b6 00             	movzbl (%eax),%eax
c01052c1:	0f b6 d0             	movzbl %al,%edx
c01052c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052c7:	0f b6 00             	movzbl (%eax),%eax
c01052ca:	0f b6 c0             	movzbl %al,%eax
c01052cd:	29 c2                	sub    %eax,%edx
c01052cf:	89 d0                	mov    %edx,%eax
c01052d1:	eb 05                	jmp    c01052d8 <strncmp+0x54>
c01052d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052d8:	5d                   	pop    %ebp
c01052d9:	c3                   	ret    

c01052da <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01052da:	55                   	push   %ebp
c01052db:	89 e5                	mov    %esp,%ebp
c01052dd:	83 ec 04             	sub    $0x4,%esp
c01052e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052e3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01052e6:	eb 14                	jmp    c01052fc <strchr+0x22>
        if (*s == c) {
c01052e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01052eb:	0f b6 00             	movzbl (%eax),%eax
c01052ee:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01052f1:	75 05                	jne    c01052f8 <strchr+0x1e>
            return (char *)s;
c01052f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f6:	eb 13                	jmp    c010530b <strchr+0x31>
        }
        s ++;
c01052f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01052fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ff:	0f b6 00             	movzbl (%eax),%eax
c0105302:	84 c0                	test   %al,%al
c0105304:	75 e2                	jne    c01052e8 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105306:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010530b:	c9                   	leave  
c010530c:	c3                   	ret    

c010530d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010530d:	55                   	push   %ebp
c010530e:	89 e5                	mov    %esp,%ebp
c0105310:	83 ec 04             	sub    $0x4,%esp
c0105313:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105316:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105319:	eb 0f                	jmp    c010532a <strfind+0x1d>
        if (*s == c) {
c010531b:	8b 45 08             	mov    0x8(%ebp),%eax
c010531e:	0f b6 00             	movzbl (%eax),%eax
c0105321:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105324:	74 10                	je     c0105336 <strfind+0x29>
            break;
        }
        s ++;
c0105326:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010532a:	8b 45 08             	mov    0x8(%ebp),%eax
c010532d:	0f b6 00             	movzbl (%eax),%eax
c0105330:	84 c0                	test   %al,%al
c0105332:	75 e7                	jne    c010531b <strfind+0xe>
c0105334:	eb 01                	jmp    c0105337 <strfind+0x2a>
        if (*s == c) {
            break;
c0105336:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105337:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010533a:	c9                   	leave  
c010533b:	c3                   	ret    

c010533c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010533c:	55                   	push   %ebp
c010533d:	89 e5                	mov    %esp,%ebp
c010533f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105349:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105350:	eb 04                	jmp    c0105356 <strtol+0x1a>
        s ++;
c0105352:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105356:	8b 45 08             	mov    0x8(%ebp),%eax
c0105359:	0f b6 00             	movzbl (%eax),%eax
c010535c:	3c 20                	cmp    $0x20,%al
c010535e:	74 f2                	je     c0105352 <strtol+0x16>
c0105360:	8b 45 08             	mov    0x8(%ebp),%eax
c0105363:	0f b6 00             	movzbl (%eax),%eax
c0105366:	3c 09                	cmp    $0x9,%al
c0105368:	74 e8                	je     c0105352 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010536a:	8b 45 08             	mov    0x8(%ebp),%eax
c010536d:	0f b6 00             	movzbl (%eax),%eax
c0105370:	3c 2b                	cmp    $0x2b,%al
c0105372:	75 06                	jne    c010537a <strtol+0x3e>
        s ++;
c0105374:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105378:	eb 15                	jmp    c010538f <strtol+0x53>
    }
    else if (*s == '-') {
c010537a:	8b 45 08             	mov    0x8(%ebp),%eax
c010537d:	0f b6 00             	movzbl (%eax),%eax
c0105380:	3c 2d                	cmp    $0x2d,%al
c0105382:	75 0b                	jne    c010538f <strtol+0x53>
        s ++, neg = 1;
c0105384:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105388:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010538f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105393:	74 06                	je     c010539b <strtol+0x5f>
c0105395:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105399:	75 24                	jne    c01053bf <strtol+0x83>
c010539b:	8b 45 08             	mov    0x8(%ebp),%eax
c010539e:	0f b6 00             	movzbl (%eax),%eax
c01053a1:	3c 30                	cmp    $0x30,%al
c01053a3:	75 1a                	jne    c01053bf <strtol+0x83>
c01053a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a8:	83 c0 01             	add    $0x1,%eax
c01053ab:	0f b6 00             	movzbl (%eax),%eax
c01053ae:	3c 78                	cmp    $0x78,%al
c01053b0:	75 0d                	jne    c01053bf <strtol+0x83>
        s += 2, base = 16;
c01053b2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01053b6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01053bd:	eb 2a                	jmp    c01053e9 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01053bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053c3:	75 17                	jne    c01053dc <strtol+0xa0>
c01053c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01053c8:	0f b6 00             	movzbl (%eax),%eax
c01053cb:	3c 30                	cmp    $0x30,%al
c01053cd:	75 0d                	jne    c01053dc <strtol+0xa0>
        s ++, base = 8;
c01053cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01053d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01053da:	eb 0d                	jmp    c01053e9 <strtol+0xad>
    }
    else if (base == 0) {
c01053dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053e0:	75 07                	jne    c01053e9 <strtol+0xad>
        base = 10;
c01053e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01053e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ec:	0f b6 00             	movzbl (%eax),%eax
c01053ef:	3c 2f                	cmp    $0x2f,%al
c01053f1:	7e 1b                	jle    c010540e <strtol+0xd2>
c01053f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f6:	0f b6 00             	movzbl (%eax),%eax
c01053f9:	3c 39                	cmp    $0x39,%al
c01053fb:	7f 11                	jg     c010540e <strtol+0xd2>
            dig = *s - '0';
c01053fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105400:	0f b6 00             	movzbl (%eax),%eax
c0105403:	0f be c0             	movsbl %al,%eax
c0105406:	83 e8 30             	sub    $0x30,%eax
c0105409:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010540c:	eb 48                	jmp    c0105456 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010540e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105411:	0f b6 00             	movzbl (%eax),%eax
c0105414:	3c 60                	cmp    $0x60,%al
c0105416:	7e 1b                	jle    c0105433 <strtol+0xf7>
c0105418:	8b 45 08             	mov    0x8(%ebp),%eax
c010541b:	0f b6 00             	movzbl (%eax),%eax
c010541e:	3c 7a                	cmp    $0x7a,%al
c0105420:	7f 11                	jg     c0105433 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105422:	8b 45 08             	mov    0x8(%ebp),%eax
c0105425:	0f b6 00             	movzbl (%eax),%eax
c0105428:	0f be c0             	movsbl %al,%eax
c010542b:	83 e8 57             	sub    $0x57,%eax
c010542e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105431:	eb 23                	jmp    c0105456 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105433:	8b 45 08             	mov    0x8(%ebp),%eax
c0105436:	0f b6 00             	movzbl (%eax),%eax
c0105439:	3c 40                	cmp    $0x40,%al
c010543b:	7e 3c                	jle    c0105479 <strtol+0x13d>
c010543d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105440:	0f b6 00             	movzbl (%eax),%eax
c0105443:	3c 5a                	cmp    $0x5a,%al
c0105445:	7f 32                	jg     c0105479 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105447:	8b 45 08             	mov    0x8(%ebp),%eax
c010544a:	0f b6 00             	movzbl (%eax),%eax
c010544d:	0f be c0             	movsbl %al,%eax
c0105450:	83 e8 37             	sub    $0x37,%eax
c0105453:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105456:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105459:	3b 45 10             	cmp    0x10(%ebp),%eax
c010545c:	7d 1a                	jge    c0105478 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010545e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105462:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105465:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105469:	89 c2                	mov    %eax,%edx
c010546b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010546e:	01 d0                	add    %edx,%eax
c0105470:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105473:	e9 71 ff ff ff       	jmp    c01053e9 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105478:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105479:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010547d:	74 08                	je     c0105487 <strtol+0x14b>
        *endptr = (char *) s;
c010547f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105482:	8b 55 08             	mov    0x8(%ebp),%edx
c0105485:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105487:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010548b:	74 07                	je     c0105494 <strtol+0x158>
c010548d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105490:	f7 d8                	neg    %eax
c0105492:	eb 03                	jmp    c0105497 <strtol+0x15b>
c0105494:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105497:	c9                   	leave  
c0105498:	c3                   	ret    

c0105499 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105499:	55                   	push   %ebp
c010549a:	89 e5                	mov    %esp,%ebp
c010549c:	57                   	push   %edi
c010549d:	83 ec 24             	sub    $0x24,%esp
c01054a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054a3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01054a6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01054aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01054ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01054b0:	88 45 f7             	mov    %al,-0x9(%ebp)
c01054b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01054b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01054bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01054c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01054c3:	89 d7                	mov    %edx,%edi
c01054c5:	f3 aa                	rep stos %al,%es:(%edi)
c01054c7:	89 fa                	mov    %edi,%edx
c01054c9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01054cc:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01054cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054d2:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01054d3:	83 c4 24             	add    $0x24,%esp
c01054d6:	5f                   	pop    %edi
c01054d7:	5d                   	pop    %ebp
c01054d8:	c3                   	ret    

c01054d9 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01054d9:	55                   	push   %ebp
c01054da:	89 e5                	mov    %esp,%ebp
c01054dc:	57                   	push   %edi
c01054dd:	56                   	push   %esi
c01054de:	53                   	push   %ebx
c01054df:	83 ec 30             	sub    $0x30,%esp
c01054e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01054f1:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01054f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01054fa:	73 42                	jae    c010553e <memmove+0x65>
c01054fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105502:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105505:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105508:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010550b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010550e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105511:	c1 e8 02             	shr    $0x2,%eax
c0105514:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105516:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105519:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010551c:	89 d7                	mov    %edx,%edi
c010551e:	89 c6                	mov    %eax,%esi
c0105520:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105522:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105525:	83 e1 03             	and    $0x3,%ecx
c0105528:	74 02                	je     c010552c <memmove+0x53>
c010552a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010552c:	89 f0                	mov    %esi,%eax
c010552e:	89 fa                	mov    %edi,%edx
c0105530:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105533:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105536:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010553c:	eb 36                	jmp    c0105574 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010553e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105541:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105544:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105547:	01 c2                	add    %eax,%edx
c0105549:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010554c:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010554f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105552:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105555:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105558:	89 c1                	mov    %eax,%ecx
c010555a:	89 d8                	mov    %ebx,%eax
c010555c:	89 d6                	mov    %edx,%esi
c010555e:	89 c7                	mov    %eax,%edi
c0105560:	fd                   	std    
c0105561:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105563:	fc                   	cld    
c0105564:	89 f8                	mov    %edi,%eax
c0105566:	89 f2                	mov    %esi,%edx
c0105568:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010556b:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010556e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105571:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105574:	83 c4 30             	add    $0x30,%esp
c0105577:	5b                   	pop    %ebx
c0105578:	5e                   	pop    %esi
c0105579:	5f                   	pop    %edi
c010557a:	5d                   	pop    %ebp
c010557b:	c3                   	ret    

c010557c <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010557c:	55                   	push   %ebp
c010557d:	89 e5                	mov    %esp,%ebp
c010557f:	57                   	push   %edi
c0105580:	56                   	push   %esi
c0105581:	83 ec 20             	sub    $0x20,%esp
c0105584:	8b 45 08             	mov    0x8(%ebp),%eax
c0105587:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010558a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010558d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105590:	8b 45 10             	mov    0x10(%ebp),%eax
c0105593:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105596:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105599:	c1 e8 02             	shr    $0x2,%eax
c010559c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010559e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055a4:	89 d7                	mov    %edx,%edi
c01055a6:	89 c6                	mov    %eax,%esi
c01055a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01055aa:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01055ad:	83 e1 03             	and    $0x3,%ecx
c01055b0:	74 02                	je     c01055b4 <memcpy+0x38>
c01055b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01055b4:	89 f0                	mov    %esi,%eax
c01055b6:	89 fa                	mov    %edi,%edx
c01055b8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01055bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01055be:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01055c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01055c4:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01055c5:	83 c4 20             	add    $0x20,%esp
c01055c8:	5e                   	pop    %esi
c01055c9:	5f                   	pop    %edi
c01055ca:	5d                   	pop    %ebp
c01055cb:	c3                   	ret    

c01055cc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01055cc:	55                   	push   %ebp
c01055cd:	89 e5                	mov    %esp,%ebp
c01055cf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01055d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01055d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055db:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01055de:	eb 30                	jmp    c0105610 <memcmp+0x44>
        if (*s1 != *s2) {
c01055e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055e3:	0f b6 10             	movzbl (%eax),%edx
c01055e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055e9:	0f b6 00             	movzbl (%eax),%eax
c01055ec:	38 c2                	cmp    %al,%dl
c01055ee:	74 18                	je     c0105608 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01055f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055f3:	0f b6 00             	movzbl (%eax),%eax
c01055f6:	0f b6 d0             	movzbl %al,%edx
c01055f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055fc:	0f b6 00             	movzbl (%eax),%eax
c01055ff:	0f b6 c0             	movzbl %al,%eax
c0105602:	29 c2                	sub    %eax,%edx
c0105604:	89 d0                	mov    %edx,%eax
c0105606:	eb 1a                	jmp    c0105622 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105608:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010560c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105610:	8b 45 10             	mov    0x10(%ebp),%eax
c0105613:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105616:	89 55 10             	mov    %edx,0x10(%ebp)
c0105619:	85 c0                	test   %eax,%eax
c010561b:	75 c3                	jne    c01055e0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010561d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105622:	c9                   	leave  
c0105623:	c3                   	ret    

c0105624 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105624:	55                   	push   %ebp
c0105625:	89 e5                	mov    %esp,%ebp
c0105627:	83 ec 38             	sub    $0x38,%esp
c010562a:	8b 45 10             	mov    0x10(%ebp),%eax
c010562d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105630:	8b 45 14             	mov    0x14(%ebp),%eax
c0105633:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105636:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105639:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010563c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010563f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105642:	8b 45 18             	mov    0x18(%ebp),%eax
c0105645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105648:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010564b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010564e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105651:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105654:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105657:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010565a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010565e:	74 1c                	je     c010567c <printnum+0x58>
c0105660:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105663:	ba 00 00 00 00       	mov    $0x0,%edx
c0105668:	f7 75 e4             	divl   -0x1c(%ebp)
c010566b:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010566e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105671:	ba 00 00 00 00       	mov    $0x0,%edx
c0105676:	f7 75 e4             	divl   -0x1c(%ebp)
c0105679:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010567c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010567f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105682:	f7 75 e4             	divl   -0x1c(%ebp)
c0105685:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105688:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010568b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010568e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105691:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105694:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105697:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010569a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010569d:	8b 45 18             	mov    0x18(%ebp),%eax
c01056a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01056a5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01056a8:	77 41                	ja     c01056eb <printnum+0xc7>
c01056aa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01056ad:	72 05                	jb     c01056b4 <printnum+0x90>
c01056af:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01056b2:	77 37                	ja     c01056eb <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01056b4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01056b7:	83 e8 01             	sub    $0x1,%eax
c01056ba:	83 ec 04             	sub    $0x4,%esp
c01056bd:	ff 75 20             	pushl  0x20(%ebp)
c01056c0:	50                   	push   %eax
c01056c1:	ff 75 18             	pushl  0x18(%ebp)
c01056c4:	ff 75 ec             	pushl  -0x14(%ebp)
c01056c7:	ff 75 e8             	pushl  -0x18(%ebp)
c01056ca:	ff 75 0c             	pushl  0xc(%ebp)
c01056cd:	ff 75 08             	pushl  0x8(%ebp)
c01056d0:	e8 4f ff ff ff       	call   c0105624 <printnum>
c01056d5:	83 c4 20             	add    $0x20,%esp
c01056d8:	eb 1b                	jmp    c01056f5 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01056da:	83 ec 08             	sub    $0x8,%esp
c01056dd:	ff 75 0c             	pushl  0xc(%ebp)
c01056e0:	ff 75 20             	pushl  0x20(%ebp)
c01056e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e6:	ff d0                	call   *%eax
c01056e8:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01056eb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01056ef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056f3:	7f e5                	jg     c01056da <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056f8:	05 ec 6d 10 c0       	add    $0xc0106dec,%eax
c01056fd:	0f b6 00             	movzbl (%eax),%eax
c0105700:	0f be c0             	movsbl %al,%eax
c0105703:	83 ec 08             	sub    $0x8,%esp
c0105706:	ff 75 0c             	pushl  0xc(%ebp)
c0105709:	50                   	push   %eax
c010570a:	8b 45 08             	mov    0x8(%ebp),%eax
c010570d:	ff d0                	call   *%eax
c010570f:	83 c4 10             	add    $0x10,%esp
}
c0105712:	90                   	nop
c0105713:	c9                   	leave  
c0105714:	c3                   	ret    

c0105715 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105715:	55                   	push   %ebp
c0105716:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105718:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010571c:	7e 14                	jle    c0105732 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010571e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105721:	8b 00                	mov    (%eax),%eax
c0105723:	8d 48 08             	lea    0x8(%eax),%ecx
c0105726:	8b 55 08             	mov    0x8(%ebp),%edx
c0105729:	89 0a                	mov    %ecx,(%edx)
c010572b:	8b 50 04             	mov    0x4(%eax),%edx
c010572e:	8b 00                	mov    (%eax),%eax
c0105730:	eb 30                	jmp    c0105762 <getuint+0x4d>
    }
    else if (lflag) {
c0105732:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105736:	74 16                	je     c010574e <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105738:	8b 45 08             	mov    0x8(%ebp),%eax
c010573b:	8b 00                	mov    (%eax),%eax
c010573d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105740:	8b 55 08             	mov    0x8(%ebp),%edx
c0105743:	89 0a                	mov    %ecx,(%edx)
c0105745:	8b 00                	mov    (%eax),%eax
c0105747:	ba 00 00 00 00       	mov    $0x0,%edx
c010574c:	eb 14                	jmp    c0105762 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010574e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105751:	8b 00                	mov    (%eax),%eax
c0105753:	8d 48 04             	lea    0x4(%eax),%ecx
c0105756:	8b 55 08             	mov    0x8(%ebp),%edx
c0105759:	89 0a                	mov    %ecx,(%edx)
c010575b:	8b 00                	mov    (%eax),%eax
c010575d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105762:	5d                   	pop    %ebp
c0105763:	c3                   	ret    

c0105764 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105764:	55                   	push   %ebp
c0105765:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010576b:	7e 14                	jle    c0105781 <getint+0x1d>
        return va_arg(*ap, long long);
c010576d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105770:	8b 00                	mov    (%eax),%eax
c0105772:	8d 48 08             	lea    0x8(%eax),%ecx
c0105775:	8b 55 08             	mov    0x8(%ebp),%edx
c0105778:	89 0a                	mov    %ecx,(%edx)
c010577a:	8b 50 04             	mov    0x4(%eax),%edx
c010577d:	8b 00                	mov    (%eax),%eax
c010577f:	eb 28                	jmp    c01057a9 <getint+0x45>
    }
    else if (lflag) {
c0105781:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105785:	74 12                	je     c0105799 <getint+0x35>
        return va_arg(*ap, long);
c0105787:	8b 45 08             	mov    0x8(%ebp),%eax
c010578a:	8b 00                	mov    (%eax),%eax
c010578c:	8d 48 04             	lea    0x4(%eax),%ecx
c010578f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105792:	89 0a                	mov    %ecx,(%edx)
c0105794:	8b 00                	mov    (%eax),%eax
c0105796:	99                   	cltd   
c0105797:	eb 10                	jmp    c01057a9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105799:	8b 45 08             	mov    0x8(%ebp),%eax
c010579c:	8b 00                	mov    (%eax),%eax
c010579e:	8d 48 04             	lea    0x4(%eax),%ecx
c01057a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01057a4:	89 0a                	mov    %ecx,(%edx)
c01057a6:	8b 00                	mov    (%eax),%eax
c01057a8:	99                   	cltd   
    }
}
c01057a9:	5d                   	pop    %ebp
c01057aa:	c3                   	ret    

c01057ab <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01057ab:	55                   	push   %ebp
c01057ac:	89 e5                	mov    %esp,%ebp
c01057ae:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01057b1:	8d 45 14             	lea    0x14(%ebp),%eax
c01057b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01057b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057ba:	50                   	push   %eax
c01057bb:	ff 75 10             	pushl  0x10(%ebp)
c01057be:	ff 75 0c             	pushl  0xc(%ebp)
c01057c1:	ff 75 08             	pushl  0x8(%ebp)
c01057c4:	e8 06 00 00 00       	call   c01057cf <vprintfmt>
c01057c9:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01057cc:	90                   	nop
c01057cd:	c9                   	leave  
c01057ce:	c3                   	ret    

c01057cf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01057cf:	55                   	push   %ebp
c01057d0:	89 e5                	mov    %esp,%ebp
c01057d2:	56                   	push   %esi
c01057d3:	53                   	push   %ebx
c01057d4:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057d7:	eb 17                	jmp    c01057f0 <vprintfmt+0x21>
            if (ch == '\0') {
c01057d9:	85 db                	test   %ebx,%ebx
c01057db:	0f 84 8e 03 00 00    	je     c0105b6f <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c01057e1:	83 ec 08             	sub    $0x8,%esp
c01057e4:	ff 75 0c             	pushl  0xc(%ebp)
c01057e7:	53                   	push   %ebx
c01057e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057eb:	ff d0                	call   *%eax
c01057ed:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f3:	8d 50 01             	lea    0x1(%eax),%edx
c01057f6:	89 55 10             	mov    %edx,0x10(%ebp)
c01057f9:	0f b6 00             	movzbl (%eax),%eax
c01057fc:	0f b6 d8             	movzbl %al,%ebx
c01057ff:	83 fb 25             	cmp    $0x25,%ebx
c0105802:	75 d5                	jne    c01057d9 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105804:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105808:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010580f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105812:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105815:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010581c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010581f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105822:	8b 45 10             	mov    0x10(%ebp),%eax
c0105825:	8d 50 01             	lea    0x1(%eax),%edx
c0105828:	89 55 10             	mov    %edx,0x10(%ebp)
c010582b:	0f b6 00             	movzbl (%eax),%eax
c010582e:	0f b6 d8             	movzbl %al,%ebx
c0105831:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105834:	83 f8 55             	cmp    $0x55,%eax
c0105837:	0f 87 05 03 00 00    	ja     c0105b42 <vprintfmt+0x373>
c010583d:	8b 04 85 10 6e 10 c0 	mov    -0x3fef91f0(,%eax,4),%eax
c0105844:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105846:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010584a:	eb d6                	jmp    c0105822 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010584c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105850:	eb d0                	jmp    c0105822 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105852:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105859:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010585c:	89 d0                	mov    %edx,%eax
c010585e:	c1 e0 02             	shl    $0x2,%eax
c0105861:	01 d0                	add    %edx,%eax
c0105863:	01 c0                	add    %eax,%eax
c0105865:	01 d8                	add    %ebx,%eax
c0105867:	83 e8 30             	sub    $0x30,%eax
c010586a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010586d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105870:	0f b6 00             	movzbl (%eax),%eax
c0105873:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105876:	83 fb 2f             	cmp    $0x2f,%ebx
c0105879:	7e 39                	jle    c01058b4 <vprintfmt+0xe5>
c010587b:	83 fb 39             	cmp    $0x39,%ebx
c010587e:	7f 34                	jg     c01058b4 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105880:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105884:	eb d3                	jmp    c0105859 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105886:	8b 45 14             	mov    0x14(%ebp),%eax
c0105889:	8d 50 04             	lea    0x4(%eax),%edx
c010588c:	89 55 14             	mov    %edx,0x14(%ebp)
c010588f:	8b 00                	mov    (%eax),%eax
c0105891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105894:	eb 1f                	jmp    c01058b5 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0105896:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010589a:	79 86                	jns    c0105822 <vprintfmt+0x53>
                width = 0;
c010589c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01058a3:	e9 7a ff ff ff       	jmp    c0105822 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01058a8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01058af:	e9 6e ff ff ff       	jmp    c0105822 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01058b4:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01058b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058b9:	0f 89 63 ff ff ff    	jns    c0105822 <vprintfmt+0x53>
                width = precision, precision = -1;
c01058bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058c5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01058cc:	e9 51 ff ff ff       	jmp    c0105822 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01058d1:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01058d5:	e9 48 ff ff ff       	jmp    c0105822 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058da:	8b 45 14             	mov    0x14(%ebp),%eax
c01058dd:	8d 50 04             	lea    0x4(%eax),%edx
c01058e0:	89 55 14             	mov    %edx,0x14(%ebp)
c01058e3:	8b 00                	mov    (%eax),%eax
c01058e5:	83 ec 08             	sub    $0x8,%esp
c01058e8:	ff 75 0c             	pushl  0xc(%ebp)
c01058eb:	50                   	push   %eax
c01058ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ef:	ff d0                	call   *%eax
c01058f1:	83 c4 10             	add    $0x10,%esp
            break;
c01058f4:	e9 71 02 00 00       	jmp    c0105b6a <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01058fc:	8d 50 04             	lea    0x4(%eax),%edx
c01058ff:	89 55 14             	mov    %edx,0x14(%ebp)
c0105902:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105904:	85 db                	test   %ebx,%ebx
c0105906:	79 02                	jns    c010590a <vprintfmt+0x13b>
                err = -err;
c0105908:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010590a:	83 fb 06             	cmp    $0x6,%ebx
c010590d:	7f 0b                	jg     c010591a <vprintfmt+0x14b>
c010590f:	8b 34 9d d0 6d 10 c0 	mov    -0x3fef9230(,%ebx,4),%esi
c0105916:	85 f6                	test   %esi,%esi
c0105918:	75 19                	jne    c0105933 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c010591a:	53                   	push   %ebx
c010591b:	68 fd 6d 10 c0       	push   $0xc0106dfd
c0105920:	ff 75 0c             	pushl  0xc(%ebp)
c0105923:	ff 75 08             	pushl  0x8(%ebp)
c0105926:	e8 80 fe ff ff       	call   c01057ab <printfmt>
c010592b:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010592e:	e9 37 02 00 00       	jmp    c0105b6a <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105933:	56                   	push   %esi
c0105934:	68 06 6e 10 c0       	push   $0xc0106e06
c0105939:	ff 75 0c             	pushl  0xc(%ebp)
c010593c:	ff 75 08             	pushl  0x8(%ebp)
c010593f:	e8 67 fe ff ff       	call   c01057ab <printfmt>
c0105944:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0105947:	e9 1e 02 00 00       	jmp    c0105b6a <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010594c:	8b 45 14             	mov    0x14(%ebp),%eax
c010594f:	8d 50 04             	lea    0x4(%eax),%edx
c0105952:	89 55 14             	mov    %edx,0x14(%ebp)
c0105955:	8b 30                	mov    (%eax),%esi
c0105957:	85 f6                	test   %esi,%esi
c0105959:	75 05                	jne    c0105960 <vprintfmt+0x191>
                p = "(null)";
c010595b:	be 09 6e 10 c0       	mov    $0xc0106e09,%esi
            }
            if (width > 0 && padc != '-') {
c0105960:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105964:	7e 76                	jle    c01059dc <vprintfmt+0x20d>
c0105966:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010596a:	74 70                	je     c01059dc <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010596c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010596f:	83 ec 08             	sub    $0x8,%esp
c0105972:	50                   	push   %eax
c0105973:	56                   	push   %esi
c0105974:	e8 17 f8 ff ff       	call   c0105190 <strnlen>
c0105979:	83 c4 10             	add    $0x10,%esp
c010597c:	89 c2                	mov    %eax,%edx
c010597e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105981:	29 d0                	sub    %edx,%eax
c0105983:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105986:	eb 17                	jmp    c010599f <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105988:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010598c:	83 ec 08             	sub    $0x8,%esp
c010598f:	ff 75 0c             	pushl  0xc(%ebp)
c0105992:	50                   	push   %eax
c0105993:	8b 45 08             	mov    0x8(%ebp),%eax
c0105996:	ff d0                	call   *%eax
c0105998:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010599b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010599f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059a3:	7f e3                	jg     c0105988 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059a5:	eb 35                	jmp    c01059dc <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c01059a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01059ab:	74 1c                	je     c01059c9 <vprintfmt+0x1fa>
c01059ad:	83 fb 1f             	cmp    $0x1f,%ebx
c01059b0:	7e 05                	jle    c01059b7 <vprintfmt+0x1e8>
c01059b2:	83 fb 7e             	cmp    $0x7e,%ebx
c01059b5:	7e 12                	jle    c01059c9 <vprintfmt+0x1fa>
                    putch('?', putdat);
c01059b7:	83 ec 08             	sub    $0x8,%esp
c01059ba:	ff 75 0c             	pushl  0xc(%ebp)
c01059bd:	6a 3f                	push   $0x3f
c01059bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c2:	ff d0                	call   *%eax
c01059c4:	83 c4 10             	add    $0x10,%esp
c01059c7:	eb 0f                	jmp    c01059d8 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c01059c9:	83 ec 08             	sub    $0x8,%esp
c01059cc:	ff 75 0c             	pushl  0xc(%ebp)
c01059cf:	53                   	push   %ebx
c01059d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d3:	ff d0                	call   *%eax
c01059d5:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059d8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059dc:	89 f0                	mov    %esi,%eax
c01059de:	8d 70 01             	lea    0x1(%eax),%esi
c01059e1:	0f b6 00             	movzbl (%eax),%eax
c01059e4:	0f be d8             	movsbl %al,%ebx
c01059e7:	85 db                	test   %ebx,%ebx
c01059e9:	74 26                	je     c0105a11 <vprintfmt+0x242>
c01059eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059ef:	78 b6                	js     c01059a7 <vprintfmt+0x1d8>
c01059f1:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01059f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059f9:	79 ac                	jns    c01059a7 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059fb:	eb 14                	jmp    c0105a11 <vprintfmt+0x242>
                putch(' ', putdat);
c01059fd:	83 ec 08             	sub    $0x8,%esp
c0105a00:	ff 75 0c             	pushl  0xc(%ebp)
c0105a03:	6a 20                	push   $0x20
c0105a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a08:	ff d0                	call   *%eax
c0105a0a:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105a0d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a11:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a15:	7f e6                	jg     c01059fd <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0105a17:	e9 4e 01 00 00       	jmp    c0105b6a <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a1c:	83 ec 08             	sub    $0x8,%esp
c0105a1f:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a22:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a25:	50                   	push   %eax
c0105a26:	e8 39 fd ff ff       	call   c0105764 <getint>
c0105a2b:	83 c4 10             	add    $0x10,%esp
c0105a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a3a:	85 d2                	test   %edx,%edx
c0105a3c:	79 23                	jns    c0105a61 <vprintfmt+0x292>
                putch('-', putdat);
c0105a3e:	83 ec 08             	sub    $0x8,%esp
c0105a41:	ff 75 0c             	pushl  0xc(%ebp)
c0105a44:	6a 2d                	push   $0x2d
c0105a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a49:	ff d0                	call   *%eax
c0105a4b:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a54:	f7 d8                	neg    %eax
c0105a56:	83 d2 00             	adc    $0x0,%edx
c0105a59:	f7 da                	neg    %edx
c0105a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a61:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a68:	e9 9f 00 00 00       	jmp    c0105b0c <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a6d:	83 ec 08             	sub    $0x8,%esp
c0105a70:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a73:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a76:	50                   	push   %eax
c0105a77:	e8 99 fc ff ff       	call   c0105715 <getuint>
c0105a7c:	83 c4 10             	add    $0x10,%esp
c0105a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a8c:	eb 7e                	jmp    c0105b0c <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a8e:	83 ec 08             	sub    $0x8,%esp
c0105a91:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a94:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a97:	50                   	push   %eax
c0105a98:	e8 78 fc ff ff       	call   c0105715 <getuint>
c0105a9d:	83 c4 10             	add    $0x10,%esp
c0105aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105aa6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105aad:	eb 5d                	jmp    c0105b0c <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0105aaf:	83 ec 08             	sub    $0x8,%esp
c0105ab2:	ff 75 0c             	pushl  0xc(%ebp)
c0105ab5:	6a 30                	push   $0x30
c0105ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aba:	ff d0                	call   *%eax
c0105abc:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105abf:	83 ec 08             	sub    $0x8,%esp
c0105ac2:	ff 75 0c             	pushl  0xc(%ebp)
c0105ac5:	6a 78                	push   $0x78
c0105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aca:	ff d0                	call   *%eax
c0105acc:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105acf:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ad2:	8d 50 04             	lea    0x4(%eax),%edx
c0105ad5:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ad8:	8b 00                	mov    (%eax),%eax
c0105ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105add:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ae4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105aeb:	eb 1f                	jmp    c0105b0c <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105aed:	83 ec 08             	sub    $0x8,%esp
c0105af0:	ff 75 e0             	pushl  -0x20(%ebp)
c0105af3:	8d 45 14             	lea    0x14(%ebp),%eax
c0105af6:	50                   	push   %eax
c0105af7:	e8 19 fc ff ff       	call   c0105715 <getuint>
c0105afc:	83 c4 10             	add    $0x10,%esp
c0105aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b02:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b0c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b13:	83 ec 04             	sub    $0x4,%esp
c0105b16:	52                   	push   %edx
c0105b17:	ff 75 e8             	pushl  -0x18(%ebp)
c0105b1a:	50                   	push   %eax
c0105b1b:	ff 75 f4             	pushl  -0xc(%ebp)
c0105b1e:	ff 75 f0             	pushl  -0x10(%ebp)
c0105b21:	ff 75 0c             	pushl  0xc(%ebp)
c0105b24:	ff 75 08             	pushl  0x8(%ebp)
c0105b27:	e8 f8 fa ff ff       	call   c0105624 <printnum>
c0105b2c:	83 c4 20             	add    $0x20,%esp
            break;
c0105b2f:	eb 39                	jmp    c0105b6a <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b31:	83 ec 08             	sub    $0x8,%esp
c0105b34:	ff 75 0c             	pushl  0xc(%ebp)
c0105b37:	53                   	push   %ebx
c0105b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3b:	ff d0                	call   *%eax
c0105b3d:	83 c4 10             	add    $0x10,%esp
            break;
c0105b40:	eb 28                	jmp    c0105b6a <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b42:	83 ec 08             	sub    $0x8,%esp
c0105b45:	ff 75 0c             	pushl  0xc(%ebp)
c0105b48:	6a 25                	push   $0x25
c0105b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4d:	ff d0                	call   *%eax
c0105b4f:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b52:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b56:	eb 04                	jmp    c0105b5c <vprintfmt+0x38d>
c0105b58:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b5c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b5f:	83 e8 01             	sub    $0x1,%eax
c0105b62:	0f b6 00             	movzbl (%eax),%eax
c0105b65:	3c 25                	cmp    $0x25,%al
c0105b67:	75 ef                	jne    c0105b58 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105b69:	90                   	nop
        }
    }
c0105b6a:	e9 68 fc ff ff       	jmp    c01057d7 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0105b6f:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105b73:	5b                   	pop    %ebx
c0105b74:	5e                   	pop    %esi
c0105b75:	5d                   	pop    %ebp
c0105b76:	c3                   	ret    

c0105b77 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b77:	55                   	push   %ebp
c0105b78:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7d:	8b 40 08             	mov    0x8(%eax),%eax
c0105b80:	8d 50 01             	lea    0x1(%eax),%edx
c0105b83:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b86:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105b89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8c:	8b 10                	mov    (%eax),%edx
c0105b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b91:	8b 40 04             	mov    0x4(%eax),%eax
c0105b94:	39 c2                	cmp    %eax,%edx
c0105b96:	73 12                	jae    c0105baa <sprintputch+0x33>
        *b->buf ++ = ch;
c0105b98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9b:	8b 00                	mov    (%eax),%eax
c0105b9d:	8d 48 01             	lea    0x1(%eax),%ecx
c0105ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ba3:	89 0a                	mov    %ecx,(%edx)
c0105ba5:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ba8:	88 10                	mov    %dl,(%eax)
    }
}
c0105baa:	90                   	nop
c0105bab:	5d                   	pop    %ebp
c0105bac:	c3                   	ret    

c0105bad <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105bad:	55                   	push   %ebp
c0105bae:	89 e5                	mov    %esp,%ebp
c0105bb0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105bb3:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bbc:	50                   	push   %eax
c0105bbd:	ff 75 10             	pushl  0x10(%ebp)
c0105bc0:	ff 75 0c             	pushl  0xc(%ebp)
c0105bc3:	ff 75 08             	pushl  0x8(%ebp)
c0105bc6:	e8 0b 00 00 00       	call   c0105bd6 <vsnprintf>
c0105bcb:	83 c4 10             	add    $0x10,%esp
c0105bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bd4:	c9                   	leave  
c0105bd5:	c3                   	ret    

c0105bd6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105bd6:	55                   	push   %ebp
c0105bd7:	89 e5                	mov    %esp,%ebp
c0105bd9:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105be2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be5:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105beb:	01 d0                	add    %edx,%eax
c0105bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105bf7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105bfb:	74 0a                	je     c0105c07 <vsnprintf+0x31>
c0105bfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c03:	39 c2                	cmp    %eax,%edx
c0105c05:	76 07                	jbe    c0105c0e <vsnprintf+0x38>
        return -E_INVAL;
c0105c07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c0c:	eb 20                	jmp    c0105c2e <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c0e:	ff 75 14             	pushl  0x14(%ebp)
c0105c11:	ff 75 10             	pushl  0x10(%ebp)
c0105c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c17:	50                   	push   %eax
c0105c18:	68 77 5b 10 c0       	push   $0xc0105b77
c0105c1d:	e8 ad fb ff ff       	call   c01057cf <vprintfmt>
c0105c22:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c28:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c2e:	c9                   	leave  
c0105c2f:	c3                   	ret    
