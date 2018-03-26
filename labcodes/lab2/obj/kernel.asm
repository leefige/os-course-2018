
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
c0100049:	e8 2a 54 00 00       	call   c0105478 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 6a 15 00 00       	call   c01015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 20 5c 10 c0 	movl   $0xc0105c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 3c 5c 10 c0       	push   $0xc0105c3c
c0100068:	e8 02 02 00 00       	call   c010026f <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 84 08 00 00       	call   c01008f9 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 b2 31 00 00       	call   c0103231 <pmm_init>

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
c0100137:	68 41 5c 10 c0       	push   $0xc0105c41
c010013c:	e8 2e 01 00 00       	call   c010026f <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 4f 5c 10 c0       	push   $0xc0105c4f
c010015a:	e8 10 01 00 00       	call   c010026f <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 5d 5c 10 c0       	push   $0xc0105c5d
c0100178:	e8 f2 00 00 00       	call   c010026f <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 6b 5c 10 c0       	push   $0xc0105c6b
c0100196:	e8 d4 00 00 00       	call   c010026f <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 79 5c 10 c0       	push   $0xc0105c79
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
c01001ee:	68 88 5c 10 c0       	push   $0xc0105c88
c01001f3:	e8 77 00 00 00       	call   c010026f <cprintf>
c01001f8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001fb:	e8 cc ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100200:	e8 0a ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100205:	83 ec 0c             	sub    $0xc,%esp
c0100208:	68 a8 5c 10 c0       	push   $0xc0105ca8
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
c0100262:	e8 47 55 00 00       	call   c01057ae <vprintfmt>
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
c0100325:	68 c7 5c 10 c0       	push   $0xc0105cc7
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
c01003fd:	68 ca 5c 10 c0       	push   $0xc0105cca
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
c010041f:	68 e6 5c 10 c0       	push   $0xc0105ce6
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
c0100458:	68 e8 5c 10 c0       	push   $0xc0105ce8
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
c010047a:	68 e6 5c 10 c0       	push   $0xc0105ce6
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
c01005f4:	c7 00 08 5d 10 c0    	movl   $0xc0105d08,(%eax)
    info->eip_line = 0;
c01005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100604:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100607:	c7 40 08 08 5d 10 c0 	movl   $0xc0105d08,0x8(%eax)
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
c010062b:	c7 45 f4 28 6f 10 c0 	movl   $0xc0106f28,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100632:	c7 45 f0 1c 20 11 c0 	movl   $0xc011201c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100639:	c7 45 ec 1d 20 11 c0 	movl   $0xc011201d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100640:	c7 45 e8 4f 4b 11 c0 	movl   $0xc0114b4f,-0x18(%ebp)

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
c010077a:	e8 6d 4b 00 00       	call   c01052ec <strfind>
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
c0100902:	68 12 5d 10 c0       	push   $0xc0105d12
c0100907:	e8 63 f9 ff ff       	call   c010026f <cprintf>
c010090c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010090f:	83 ec 08             	sub    $0x8,%esp
c0100912:	68 2a 00 10 c0       	push   $0xc010002a
c0100917:	68 2b 5d 10 c0       	push   $0xc0105d2b
c010091c:	e8 4e f9 ff ff       	call   c010026f <cprintf>
c0100921:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100924:	83 ec 08             	sub    $0x8,%esp
c0100927:	68 0f 5c 10 c0       	push   $0xc0105c0f
c010092c:	68 43 5d 10 c0       	push   $0xc0105d43
c0100931:	e8 39 f9 ff ff       	call   c010026f <cprintf>
c0100936:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100939:	83 ec 08             	sub    $0x8,%esp
c010093c:	68 36 7a 11 c0       	push   $0xc0117a36
c0100941:	68 5b 5d 10 c0       	push   $0xc0105d5b
c0100946:	e8 24 f9 ff ff       	call   c010026f <cprintf>
c010094b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010094e:	83 ec 08             	sub    $0x8,%esp
c0100951:	68 c8 89 11 c0       	push   $0xc01189c8
c0100956:	68 73 5d 10 c0       	push   $0xc0105d73
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
c0100986:	68 8c 5d 10 c0       	push   $0xc0105d8c
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
c01009bb:	68 b6 5d 10 c0       	push   $0xc0105db6
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
c0100a22:	68 d2 5d 10 c0       	push   $0xc0105dd2
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
c0100a72:	68 e4 5d 10 c0       	push   $0xc0105de4
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
c0100ac0:	68 fc 5d 10 c0       	push   $0xc0105dfc
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
c0100b41:	68 a0 5e 10 c0       	push   $0xc0105ea0
c0100b46:	e8 6e 47 00 00       	call   c01052b9 <strchr>
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
c0100b67:	68 a5 5e 10 c0       	push   $0xc0105ea5
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
c0100baf:	68 a0 5e 10 c0       	push   $0xc0105ea0
c0100bb4:	e8 00 47 00 00       	call   c01052b9 <strchr>
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
c0100c1a:	e8 fa 45 00 00       	call   c0105219 <strcmp>
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
c0100c67:	68 c3 5e 10 c0       	push   $0xc0105ec3
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
c0100c84:	68 dc 5e 10 c0       	push   $0xc0105edc
c0100c89:	e8 e1 f5 ff ff       	call   c010026f <cprintf>
c0100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c91:	83 ec 0c             	sub    $0xc,%esp
c0100c94:	68 04 5f 10 c0       	push   $0xc0105f04
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
c0100cb8:	68 29 5f 10 c0       	push   $0xc0105f29
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
c0100d23:	68 2d 5f 10 c0       	push   $0xc0105f2d
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
c0100db3:	68 36 5f 10 c0       	push   $0xc0105f36
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
c01011dc:	e8 d7 42 00 00       	call   c01054b8 <memmove>
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
c0101567:	68 51 5f 10 c0       	push   $0xc0105f51
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
c01015e1:	68 5d 5f 10 c0       	push   $0xc0105f5d
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
c0101888:	68 80 5f 10 c0       	push   $0xc0105f80
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
c0101a17:	8b 04 85 e0 62 10 c0 	mov    -0x3fef9d20(,%eax,4),%eax
c0101a1e:	eb 18                	jmp    c0101a38 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a20:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a24:	7e 0d                	jle    c0101a33 <trapname+0x2a>
c0101a26:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a2a:	7f 07                	jg     c0101a33 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a2c:	b8 8a 5f 10 c0       	mov    $0xc0105f8a,%eax
c0101a31:	eb 05                	jmp    c0101a38 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a33:	b8 9d 5f 10 c0       	mov    $0xc0105f9d,%eax
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
c0101a5c:	68 de 5f 10 c0       	push   $0xc0105fde
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
c0101a86:	68 ef 5f 10 c0       	push   $0xc0105fef
c0101a8b:	e8 df e7 ff ff       	call   c010026f <cprintf>
c0101a90:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a96:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a9a:	0f b7 c0             	movzwl %ax,%eax
c0101a9d:	83 ec 08             	sub    $0x8,%esp
c0101aa0:	50                   	push   %eax
c0101aa1:	68 02 60 10 c0       	push   $0xc0106002
c0101aa6:	e8 c4 e7 ff ff       	call   c010026f <cprintf>
c0101aab:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ab5:	0f b7 c0             	movzwl %ax,%eax
c0101ab8:	83 ec 08             	sub    $0x8,%esp
c0101abb:	50                   	push   %eax
c0101abc:	68 15 60 10 c0       	push   $0xc0106015
c0101ac1:	e8 a9 e7 ff ff       	call   c010026f <cprintf>
c0101ac6:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ad0:	0f b7 c0             	movzwl %ax,%eax
c0101ad3:	83 ec 08             	sub    $0x8,%esp
c0101ad6:	50                   	push   %eax
c0101ad7:	68 28 60 10 c0       	push   $0xc0106028
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
c0101b03:	68 3b 60 10 c0       	push   $0xc010603b
c0101b08:	e8 62 e7 ff ff       	call   c010026f <cprintf>
c0101b0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b13:	8b 40 34             	mov    0x34(%eax),%eax
c0101b16:	83 ec 08             	sub    $0x8,%esp
c0101b19:	50                   	push   %eax
c0101b1a:	68 4d 60 10 c0       	push   $0xc010604d
c0101b1f:	e8 4b e7 ff ff       	call   c010026f <cprintf>
c0101b24:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2a:	8b 40 38             	mov    0x38(%eax),%eax
c0101b2d:	83 ec 08             	sub    $0x8,%esp
c0101b30:	50                   	push   %eax
c0101b31:	68 5c 60 10 c0       	push   $0xc010605c
c0101b36:	e8 34 e7 ff ff       	call   c010026f <cprintf>
c0101b3b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b45:	0f b7 c0             	movzwl %ax,%eax
c0101b48:	83 ec 08             	sub    $0x8,%esp
c0101b4b:	50                   	push   %eax
c0101b4c:	68 6b 60 10 c0       	push   $0xc010606b
c0101b51:	e8 19 e7 ff ff       	call   c010026f <cprintf>
c0101b56:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5c:	8b 40 40             	mov    0x40(%eax),%eax
c0101b5f:	83 ec 08             	sub    $0x8,%esp
c0101b62:	50                   	push   %eax
c0101b63:	68 7e 60 10 c0       	push   $0xc010607e
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
c0101bab:	68 8d 60 10 c0       	push   $0xc010608d
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
c0101bd9:	68 91 60 10 c0       	push   $0xc0106091
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
c0101c02:	68 9a 60 10 c0       	push   $0xc010609a
c0101c07:	e8 63 e6 ff ff       	call   c010026f <cprintf>
c0101c0c:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c12:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c16:	0f b7 c0             	movzwl %ax,%eax
c0101c19:	83 ec 08             	sub    $0x8,%esp
c0101c1c:	50                   	push   %eax
c0101c1d:	68 a9 60 10 c0       	push   $0xc01060a9
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
c0101c3c:	68 bc 60 10 c0       	push   $0xc01060bc
c0101c41:	e8 29 e6 ff ff       	call   c010026f <cprintf>
c0101c46:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	8b 40 04             	mov    0x4(%eax),%eax
c0101c4f:	83 ec 08             	sub    $0x8,%esp
c0101c52:	50                   	push   %eax
c0101c53:	68 cb 60 10 c0       	push   $0xc01060cb
c0101c58:	e8 12 e6 ff ff       	call   c010026f <cprintf>
c0101c5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	8b 40 08             	mov    0x8(%eax),%eax
c0101c66:	83 ec 08             	sub    $0x8,%esp
c0101c69:	50                   	push   %eax
c0101c6a:	68 da 60 10 c0       	push   $0xc01060da
c0101c6f:	e8 fb e5 ff ff       	call   c010026f <cprintf>
c0101c74:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c7d:	83 ec 08             	sub    $0x8,%esp
c0101c80:	50                   	push   %eax
c0101c81:	68 e9 60 10 c0       	push   $0xc01060e9
c0101c86:	e8 e4 e5 ff ff       	call   c010026f <cprintf>
c0101c8b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 10             	mov    0x10(%eax),%eax
c0101c94:	83 ec 08             	sub    $0x8,%esp
c0101c97:	50                   	push   %eax
c0101c98:	68 f8 60 10 c0       	push   $0xc01060f8
c0101c9d:	e8 cd e5 ff ff       	call   c010026f <cprintf>
c0101ca2:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca8:	8b 40 14             	mov    0x14(%eax),%eax
c0101cab:	83 ec 08             	sub    $0x8,%esp
c0101cae:	50                   	push   %eax
c0101caf:	68 07 61 10 c0       	push   $0xc0106107
c0101cb4:	e8 b6 e5 ff ff       	call   c010026f <cprintf>
c0101cb9:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbf:	8b 40 18             	mov    0x18(%eax),%eax
c0101cc2:	83 ec 08             	sub    $0x8,%esp
c0101cc5:	50                   	push   %eax
c0101cc6:	68 16 61 10 c0       	push   $0xc0106116
c0101ccb:	e8 9f e5 ff ff       	call   c010026f <cprintf>
c0101cd0:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd6:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cd9:	83 ec 08             	sub    $0x8,%esp
c0101cdc:	50                   	push   %eax
c0101cdd:	68 25 61 10 c0       	push   $0xc0106125
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
c0101d88:	68 34 61 10 c0       	push   $0xc0106134
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
c0101daf:	68 46 61 10 c0       	push   $0xc0106146
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
c0101e86:	68 55 61 10 c0       	push   $0xc0106155
c0101e8b:	68 dc 00 00 00       	push   $0xdc
c0101e90:	68 71 61 10 c0       	push   $0xc0106171
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
c0102998:	68 30 63 10 c0       	push   $0xc0106330
c010299d:	6a 5a                	push   $0x5a
c010299f:	68 4f 63 10 c0       	push   $0xc010634f
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
c01029ef:	68 60 63 10 c0       	push   $0xc0106360
c01029f4:	6a 61                	push   $0x61
c01029f6:	68 4f 63 10 c0       	push   $0xc010634f
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
c0102a1d:	68 84 63 10 c0       	push   $0xc0106384
c0102a22:	6a 6c                	push   $0x6c
c0102a24:	68 4f 63 10 c0       	push   $0xc010634f
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

c0102a6a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a6a:	55                   	push   %ebp
c0102a6b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a70:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a73:	89 10                	mov    %edx,(%eax)
}
c0102a75:	90                   	nop
c0102a76:	5d                   	pop    %ebp
c0102a77:	c3                   	ret    

c0102a78 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102a78:	55                   	push   %ebp
c0102a79:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102a7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a7e:	8b 00                	mov    (%eax),%eax
c0102a80:	8d 50 01             	lea    0x1(%eax),%edx
c0102a83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a86:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a8b:	8b 00                	mov    (%eax),%eax
}
c0102a8d:	5d                   	pop    %ebp
c0102a8e:	c3                   	ret    

c0102a8f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102a8f:	55                   	push   %ebp
c0102a90:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a95:	8b 00                	mov    (%eax),%eax
c0102a97:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa2:	8b 00                	mov    (%eax),%eax
}
c0102aa4:	5d                   	pop    %ebp
c0102aa5:	c3                   	ret    

c0102aa6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0102aa6:	55                   	push   %ebp
c0102aa7:	89 e5                	mov    %esp,%ebp
c0102aa9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102aac:	9c                   	pushf  
c0102aad:	58                   	pop    %eax
c0102aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102ab4:	25 00 02 00 00       	and    $0x200,%eax
c0102ab9:	85 c0                	test   %eax,%eax
c0102abb:	74 0c                	je     c0102ac9 <__intr_save+0x23>
        intr_disable();
c0102abd:	e8 b4 ed ff ff       	call   c0101876 <intr_disable>
        return 1;
c0102ac2:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ac7:	eb 05                	jmp    c0102ace <__intr_save+0x28>
    }
    return 0;
c0102ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ace:	c9                   	leave  
c0102acf:	c3                   	ret    

c0102ad0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102ad0:	55                   	push   %ebp
c0102ad1:	89 e5                	mov    %esp,%ebp
c0102ad3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102ad6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102ada:	74 05                	je     c0102ae1 <__intr_restore+0x11>
        intr_enable();
c0102adc:	e8 8e ed ff ff       	call   c010186f <intr_enable>
    }
}
c0102ae1:	90                   	nop
c0102ae2:	c9                   	leave  
c0102ae3:	c3                   	ret    

c0102ae4 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102ae4:	55                   	push   %ebp
c0102ae5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aea:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102aed:	b8 23 00 00 00       	mov    $0x23,%eax
c0102af2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102af4:	b8 23 00 00 00       	mov    $0x23,%eax
c0102af9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102afb:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b00:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b02:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b07:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b09:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b0e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b10:	ea 17 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b17
}
c0102b17:	90                   	nop
c0102b18:	5d                   	pop    %ebp
c0102b19:	c3                   	ret    

c0102b1a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b1a:	55                   	push   %ebp
c0102b1b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b20:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102b25:	90                   	nop
c0102b26:	5d                   	pop    %ebp
c0102b27:	c3                   	ret    

c0102b28 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b28:	55                   	push   %ebp
c0102b29:	89 e5                	mov    %esp,%ebp
c0102b2b:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b2e:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102b33:	50                   	push   %eax
c0102b34:	e8 e1 ff ff ff       	call   c0102b1a <load_esp0>
c0102b39:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102b3c:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102b43:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b45:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102b4c:	68 00 
c0102b4e:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b53:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102b59:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b5e:	c1 e8 10             	shr    $0x10,%eax
c0102b61:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102b66:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b6d:	83 e0 f0             	and    $0xfffffff0,%eax
c0102b70:	83 c8 09             	or     $0x9,%eax
c0102b73:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b78:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b7f:	83 e0 ef             	and    $0xffffffef,%eax
c0102b82:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b87:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b8e:	83 e0 9f             	and    $0xffffff9f,%eax
c0102b91:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b96:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b9d:	83 c8 80             	or     $0xffffff80,%eax
c0102ba0:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ba5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bac:	83 e0 f0             	and    $0xfffffff0,%eax
c0102baf:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bb4:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bbb:	83 e0 ef             	and    $0xffffffef,%eax
c0102bbe:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bc3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bca:	83 e0 df             	and    $0xffffffdf,%eax
c0102bcd:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bd2:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102bd9:	83 c8 40             	or     $0x40,%eax
c0102bdc:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102be1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102be8:	83 e0 7f             	and    $0x7f,%eax
c0102beb:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102bf0:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102bf5:	c1 e8 18             	shr    $0x18,%eax
c0102bf8:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102bfd:	68 30 7a 11 c0       	push   $0xc0117a30
c0102c02:	e8 dd fe ff ff       	call   c0102ae4 <lgdt>
c0102c07:	83 c4 04             	add    $0x4,%esp
c0102c0a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c10:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c14:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102c17:	90                   	nop
c0102c18:	c9                   	leave  
c0102c19:	c3                   	ret    

c0102c1a <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c1a:	55                   	push   %ebp
c0102c1b:	89 e5                	mov    %esp,%ebp
c0102c1d:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102c20:	c7 05 b0 89 11 c0 10 	movl   $0xc0106d10,0xc01189b0
c0102c27:	6d 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c2a:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c2f:	8b 00                	mov    (%eax),%eax
c0102c31:	83 ec 08             	sub    $0x8,%esp
c0102c34:	50                   	push   %eax
c0102c35:	68 b0 63 10 c0       	push   $0xc01063b0
c0102c3a:	e8 30 d6 ff ff       	call   c010026f <cprintf>
c0102c3f:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102c42:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c47:	8b 40 04             	mov    0x4(%eax),%eax
c0102c4a:	ff d0                	call   *%eax
}
c0102c4c:	90                   	nop
c0102c4d:	c9                   	leave  
c0102c4e:	c3                   	ret    

c0102c4f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102c4f:	55                   	push   %ebp
c0102c50:	89 e5                	mov    %esp,%ebp
c0102c52:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102c55:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c5a:	8b 40 08             	mov    0x8(%eax),%eax
c0102c5d:	83 ec 08             	sub    $0x8,%esp
c0102c60:	ff 75 0c             	pushl  0xc(%ebp)
c0102c63:	ff 75 08             	pushl  0x8(%ebp)
c0102c66:	ff d0                	call   *%eax
c0102c68:	83 c4 10             	add    $0x10,%esp
}
c0102c6b:	90                   	nop
c0102c6c:	c9                   	leave  
c0102c6d:	c3                   	ret    

c0102c6e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102c6e:	55                   	push   %ebp
c0102c6f:	89 e5                	mov    %esp,%ebp
c0102c71:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);     // save interrupt state
c0102c7b:	e8 26 fe ff ff       	call   c0102aa6 <__intr_save>
c0102c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102c83:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102c88:	8b 40 0c             	mov    0xc(%eax),%eax
c0102c8b:	83 ec 0c             	sub    $0xc,%esp
c0102c8e:	ff 75 08             	pushl  0x8(%ebp)
c0102c91:	ff d0                	call   *%eax
c0102c93:	83 c4 10             	add    $0x10,%esp
c0102c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c99:	83 ec 0c             	sub    $0xc,%esp
c0102c9c:	ff 75 f0             	pushl  -0x10(%ebp)
c0102c9f:	e8 2c fe ff ff       	call   c0102ad0 <__intr_restore>
c0102ca4:	83 c4 10             	add    $0x10,%esp
    return page;
c0102ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102caa:	c9                   	leave  
c0102cab:	c3                   	ret    

c0102cac <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102cac:	55                   	push   %ebp
c0102cad:	89 e5                	mov    %esp,%ebp
c0102caf:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cb2:	e8 ef fd ff ff       	call   c0102aa6 <__intr_save>
c0102cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102cba:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102cbf:	8b 40 10             	mov    0x10(%eax),%eax
c0102cc2:	83 ec 08             	sub    $0x8,%esp
c0102cc5:	ff 75 0c             	pushl  0xc(%ebp)
c0102cc8:	ff 75 08             	pushl  0x8(%ebp)
c0102ccb:	ff d0                	call   *%eax
c0102ccd:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102cd0:	83 ec 0c             	sub    $0xc,%esp
c0102cd3:	ff 75 f4             	pushl  -0xc(%ebp)
c0102cd6:	e8 f5 fd ff ff       	call   c0102ad0 <__intr_restore>
c0102cdb:	83 c4 10             	add    $0x10,%esp
}
c0102cde:	90                   	nop
c0102cdf:	c9                   	leave  
c0102ce0:	c3                   	ret    

c0102ce1 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102ce1:	55                   	push   %ebp
c0102ce2:	89 e5                	mov    %esp,%ebp
c0102ce4:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ce7:	e8 ba fd ff ff       	call   c0102aa6 <__intr_save>
c0102cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102cef:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0102cf4:	8b 40 14             	mov    0x14(%eax),%eax
c0102cf7:	ff d0                	call   *%eax
c0102cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102cfc:	83 ec 0c             	sub    $0xc,%esp
c0102cff:	ff 75 f4             	pushl  -0xc(%ebp)
c0102d02:	e8 c9 fd ff ff       	call   c0102ad0 <__intr_restore>
c0102d07:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d0d:	c9                   	leave  
c0102d0e:	c3                   	ret    

c0102d0f <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d0f:	55                   	push   %ebp
c0102d10:	89 e5                	mov    %esp,%ebp
c0102d12:	57                   	push   %edi
c0102d13:	56                   	push   %esi
c0102d14:	53                   	push   %ebx
c0102d15:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d18:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d2d:	83 ec 0c             	sub    $0xc,%esp
c0102d30:	68 c7 63 10 c0       	push   $0xc01063c7
c0102d35:	e8 35 d5 ff ff       	call   c010026f <cprintf>
c0102d3a:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d3d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d44:	e9 fc 00 00 00       	jmp    c0102e45 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d49:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d4f:	89 d0                	mov    %edx,%eax
c0102d51:	c1 e0 02             	shl    $0x2,%eax
c0102d54:	01 d0                	add    %edx,%eax
c0102d56:	c1 e0 02             	shl    $0x2,%eax
c0102d59:	01 c8                	add    %ecx,%eax
c0102d5b:	8b 50 08             	mov    0x8(%eax),%edx
c0102d5e:	8b 40 04             	mov    0x4(%eax),%eax
c0102d61:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102d64:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102d67:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d6d:	89 d0                	mov    %edx,%eax
c0102d6f:	c1 e0 02             	shl    $0x2,%eax
c0102d72:	01 d0                	add    %edx,%eax
c0102d74:	c1 e0 02             	shl    $0x2,%eax
c0102d77:	01 c8                	add    %ecx,%eax
c0102d79:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102d7c:	8b 58 10             	mov    0x10(%eax),%ebx
c0102d7f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d82:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d85:	01 c8                	add    %ecx,%eax
c0102d87:	11 da                	adc    %ebx,%edx
c0102d89:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102d8c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102d8f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d92:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d95:	89 d0                	mov    %edx,%eax
c0102d97:	c1 e0 02             	shl    $0x2,%eax
c0102d9a:	01 d0                	add    %edx,%eax
c0102d9c:	c1 e0 02             	shl    $0x2,%eax
c0102d9f:	01 c8                	add    %ecx,%eax
c0102da1:	83 c0 14             	add    $0x14,%eax
c0102da4:	8b 00                	mov    (%eax),%eax
c0102da6:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102da9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102dac:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102daf:	83 c0 ff             	add    $0xffffffff,%eax
c0102db2:	83 d2 ff             	adc    $0xffffffff,%edx
c0102db5:	89 c1                	mov    %eax,%ecx
c0102db7:	89 d3                	mov    %edx,%ebx
c0102db9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102dbc:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102dbf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dc2:	89 d0                	mov    %edx,%eax
c0102dc4:	c1 e0 02             	shl    $0x2,%eax
c0102dc7:	01 d0                	add    %edx,%eax
c0102dc9:	c1 e0 02             	shl    $0x2,%eax
c0102dcc:	03 45 80             	add    -0x80(%ebp),%eax
c0102dcf:	8b 50 10             	mov    0x10(%eax),%edx
c0102dd2:	8b 40 0c             	mov    0xc(%eax),%eax
c0102dd5:	ff 75 84             	pushl  -0x7c(%ebp)
c0102dd8:	53                   	push   %ebx
c0102dd9:	51                   	push   %ecx
c0102dda:	ff 75 bc             	pushl  -0x44(%ebp)
c0102ddd:	ff 75 b8             	pushl  -0x48(%ebp)
c0102de0:	52                   	push   %edx
c0102de1:	50                   	push   %eax
c0102de2:	68 d4 63 10 c0       	push   $0xc01063d4
c0102de7:	e8 83 d4 ff ff       	call   c010026f <cprintf>
c0102dec:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102def:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102df2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102df5:	89 d0                	mov    %edx,%eax
c0102df7:	c1 e0 02             	shl    $0x2,%eax
c0102dfa:	01 d0                	add    %edx,%eax
c0102dfc:	c1 e0 02             	shl    $0x2,%eax
c0102dff:	01 c8                	add    %ecx,%eax
c0102e01:	83 c0 14             	add    $0x14,%eax
c0102e04:	8b 00                	mov    (%eax),%eax
c0102e06:	83 f8 01             	cmp    $0x1,%eax
c0102e09:	75 36                	jne    c0102e41 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e11:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e14:	77 2b                	ja     c0102e41 <page_init+0x132>
c0102e16:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102e19:	72 05                	jb     c0102e20 <page_init+0x111>
c0102e1b:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102e1e:	73 21                	jae    c0102e41 <page_init+0x132>
c0102e20:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e24:	77 1b                	ja     c0102e41 <page_init+0x132>
c0102e26:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102e2a:	72 09                	jb     c0102e35 <page_init+0x126>
c0102e2c:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102e33:	77 0c                	ja     c0102e41 <page_init+0x132>
                maxpa = end;
c0102e35:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e38:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e41:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e45:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e48:	8b 00                	mov    (%eax),%eax
c0102e4a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102e4d:	0f 8f f6 fe ff ff    	jg     c0102d49 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102e53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102e57:	72 1d                	jb     c0102e76 <page_init+0x167>
c0102e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102e5d:	77 09                	ja     c0102e68 <page_init+0x159>
c0102e5f:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102e66:	76 0e                	jbe    c0102e76 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102e68:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102e6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
c0102e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e7c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102e80:	c1 ea 0c             	shr    $0xc,%edx
c0102e83:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102e88:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102e8f:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c0102e94:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e97:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e9a:	01 d0                	add    %edx,%eax
c0102e9c:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102e9f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102ea2:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ea7:	f7 75 ac             	divl   -0x54(%ebp)
c0102eaa:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102ead:	29 d0                	sub    %edx,%eax
c0102eaf:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    for (i = 0; i < npage; i ++) {
c0102eb4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102ebb:	eb 2f                	jmp    c0102eec <page_init+0x1dd>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
c0102ebd:	8b 0d b8 89 11 c0    	mov    0xc01189b8,%ecx
c0102ec3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ec6:	89 d0                	mov    %edx,%eax
c0102ec8:	c1 e0 02             	shl    $0x2,%eax
c0102ecb:	01 d0                	add    %edx,%eax
c0102ecd:	c1 e0 02             	shl    $0x2,%eax
c0102ed0:	01 c8                	add    %ecx,%eax
c0102ed2:	83 c0 04             	add    $0x4,%eax
c0102ed5:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102edc:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102edf:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ee2:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102ee5:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102ee8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102eec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eef:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102ef4:	39 c2                	cmp    %eax,%edx
c0102ef6:	72 c5                	jb     c0102ebd <page_init+0x1ae>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt
c0102ef8:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102efe:	89 d0                	mov    %edx,%eax
c0102f00:	c1 e0 02             	shl    $0x2,%eax
c0102f03:	01 d0                	add    %edx,%eax
c0102f05:	c1 e0 02             	shl    $0x2,%eax
c0102f08:	89 c2                	mov    %eax,%edx
c0102f0a:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102f0f:	01 d0                	add    %edx,%eax
c0102f11:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102f14:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102f1b:	77 17                	ja     c0102f34 <page_init+0x225>
c0102f1d:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102f20:	68 04 64 10 c0       	push   $0xc0106404
c0102f25:	68 dc 00 00 00       	push   $0xdc
c0102f2a:	68 28 64 10 c0       	push   $0xc0106428
c0102f2f:	e8 a1 d4 ff ff       	call   c01003d5 <__panic>
c0102f34:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f37:	05 00 00 00 40       	add    $0x40000000,%eax
c0102f3c:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102f3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f46:	e9 69 01 00 00       	jmp    c01030b4 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f51:	89 d0                	mov    %edx,%eax
c0102f53:	c1 e0 02             	shl    $0x2,%eax
c0102f56:	01 d0                	add    %edx,%eax
c0102f58:	c1 e0 02             	shl    $0x2,%eax
c0102f5b:	01 c8                	add    %ecx,%eax
c0102f5d:	8b 50 08             	mov    0x8(%eax),%edx
c0102f60:	8b 40 04             	mov    0x4(%eax),%eax
c0102f63:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f66:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102f69:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f6f:	89 d0                	mov    %edx,%eax
c0102f71:	c1 e0 02             	shl    $0x2,%eax
c0102f74:	01 d0                	add    %edx,%eax
c0102f76:	c1 e0 02             	shl    $0x2,%eax
c0102f79:	01 c8                	add    %ecx,%eax
c0102f7b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102f7e:	8b 58 10             	mov    0x10(%eax),%ebx
c0102f81:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f87:	01 c8                	add    %ecx,%eax
c0102f89:	11 da                	adc    %ebx,%edx
c0102f8b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102f8e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102f91:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f94:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f97:	89 d0                	mov    %edx,%eax
c0102f99:	c1 e0 02             	shl    $0x2,%eax
c0102f9c:	01 d0                	add    %edx,%eax
c0102f9e:	c1 e0 02             	shl    $0x2,%eax
c0102fa1:	01 c8                	add    %ecx,%eax
c0102fa3:	83 c0 14             	add    $0x14,%eax
c0102fa6:	8b 00                	mov    (%eax),%eax
c0102fa8:	83 f8 01             	cmp    $0x1,%eax
c0102fab:	0f 85 ff 00 00 00    	jne    c01030b0 <page_init+0x3a1>
            if (begin < freemem) {
c0102fb1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fb4:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fb9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102fbc:	72 17                	jb     c0102fd5 <page_init+0x2c6>
c0102fbe:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102fc1:	77 05                	ja     c0102fc8 <page_init+0x2b9>
c0102fc3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102fc6:	76 0d                	jbe    c0102fd5 <page_init+0x2c6>
                begin = freemem;
c0102fc8:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fcb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fce:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102fd5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102fd9:	72 1d                	jb     c0102ff8 <page_init+0x2e9>
c0102fdb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102fdf:	77 09                	ja     c0102fea <page_init+0x2db>
c0102fe1:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102fe8:	76 0e                	jbe    c0102ff8 <page_init+0x2e9>
                end = KMEMSIZE;
c0102fea:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102ff1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102ff8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ffb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ffe:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103001:	0f 87 a9 00 00 00    	ja     c01030b0 <page_init+0x3a1>
c0103007:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010300a:	72 09                	jb     c0103015 <page_init+0x306>
c010300c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010300f:	0f 83 9b 00 00 00    	jae    c01030b0 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0103015:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010301c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010301f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103022:	01 d0                	add    %edx,%eax
c0103024:	83 e8 01             	sub    $0x1,%eax
c0103027:	89 45 98             	mov    %eax,-0x68(%ebp)
c010302a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010302d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103032:	f7 75 9c             	divl   -0x64(%ebp)
c0103035:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103038:	29 d0                	sub    %edx,%eax
c010303a:	ba 00 00 00 00       	mov    $0x0,%edx
c010303f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103042:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103045:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103048:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010304b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010304e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103053:	89 c3                	mov    %eax,%ebx
c0103055:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010305b:	89 de                	mov    %ebx,%esi
c010305d:	89 d0                	mov    %edx,%eax
c010305f:	83 e0 00             	and    $0x0,%eax
c0103062:	89 c7                	mov    %eax,%edi
c0103064:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103067:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c010306a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010306d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103070:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103073:	77 3b                	ja     c01030b0 <page_init+0x3a1>
c0103075:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103078:	72 05                	jb     c010307f <page_init+0x370>
c010307a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010307d:	73 31                	jae    c01030b0 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010307f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103082:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103085:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103088:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010308b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010308f:	c1 ea 0c             	shr    $0xc,%edx
c0103092:	89 c3                	mov    %eax,%ebx
c0103094:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103097:	83 ec 0c             	sub    $0xc,%esp
c010309a:	50                   	push   %eax
c010309b:	e8 de f8 ff ff       	call   c010297e <pa2page>
c01030a0:	83 c4 10             	add    $0x10,%esp
c01030a3:	83 ec 08             	sub    $0x8,%esp
c01030a6:	53                   	push   %ebx
c01030a7:	50                   	push   %eax
c01030a8:	e8 a2 fb ff ff       	call   c0102c4f <init_memmap>
c01030ad:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt

    for (i = 0; i < memmap->nr_map; i ++) {
c01030b0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01030b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030b7:	8b 00                	mov    (%eax),%eax
c01030b9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01030bc:	0f 8f 89 fe ff ff    	jg     c0102f4b <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01030c2:	90                   	nop
c01030c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01030c6:	5b                   	pop    %ebx
c01030c7:	5e                   	pop    %esi
c01030c8:	5f                   	pop    %edi
c01030c9:	5d                   	pop    %ebp
c01030ca:	c3                   	ret    

c01030cb <enable_paging>:

static void
enable_paging(void) {
c01030cb:	55                   	push   %ebp
c01030cc:	89 e5                	mov    %esp,%ebp
c01030ce:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01030d1:	a1 b4 89 11 c0       	mov    0xc01189b4,%eax
c01030d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01030d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01030dc:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01030df:	0f 20 c0             	mov    %cr0,%eax
c01030e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01030e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01030eb:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01030f2:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c01030f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01030f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030ff:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103102:	90                   	nop
c0103103:	c9                   	leave  
c0103104:	c3                   	ret    

c0103105 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103105:	55                   	push   %ebp
c0103106:	89 e5                	mov    %esp,%ebp
c0103108:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010310b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010310e:	33 45 14             	xor    0x14(%ebp),%eax
c0103111:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103116:	85 c0                	test   %eax,%eax
c0103118:	74 19                	je     c0103133 <boot_map_segment+0x2e>
c010311a:	68 36 64 10 c0       	push   $0xc0106436
c010311f:	68 4d 64 10 c0       	push   $0xc010644d
c0103124:	68 05 01 00 00       	push   $0x105
c0103129:	68 28 64 10 c0       	push   $0xc0106428
c010312e:	e8 a2 d2 ff ff       	call   c01003d5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103133:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010313a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010313d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103142:	89 c2                	mov    %eax,%edx
c0103144:	8b 45 10             	mov    0x10(%ebp),%eax
c0103147:	01 c2                	add    %eax,%edx
c0103149:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010314c:	01 d0                	add    %edx,%eax
c010314e:	83 e8 01             	sub    $0x1,%eax
c0103151:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103154:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103157:	ba 00 00 00 00       	mov    $0x0,%edx
c010315c:	f7 75 f0             	divl   -0x10(%ebp)
c010315f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103162:	29 d0                	sub    %edx,%eax
c0103164:	c1 e8 0c             	shr    $0xc,%eax
c0103167:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010316a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010316d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103170:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103173:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103178:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010317b:	8b 45 14             	mov    0x14(%ebp),%eax
c010317e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103184:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103189:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010318c:	eb 57                	jmp    c01031e5 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010318e:	83 ec 04             	sub    $0x4,%esp
c0103191:	6a 01                	push   $0x1
c0103193:	ff 75 0c             	pushl  0xc(%ebp)
c0103196:	ff 75 08             	pushl  0x8(%ebp)
c0103199:	e8 98 01 00 00       	call   c0103336 <get_pte>
c010319e:	83 c4 10             	add    $0x10,%esp
c01031a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01031a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01031a8:	75 19                	jne    c01031c3 <boot_map_segment+0xbe>
c01031aa:	68 62 64 10 c0       	push   $0xc0106462
c01031af:	68 4d 64 10 c0       	push   $0xc010644d
c01031b4:	68 0b 01 00 00       	push   $0x10b
c01031b9:	68 28 64 10 c0       	push   $0xc0106428
c01031be:	e8 12 d2 ff ff       	call   c01003d5 <__panic>
        *ptep = pa | PTE_P | perm;
c01031c3:	8b 45 14             	mov    0x14(%ebp),%eax
c01031c6:	0b 45 18             	or     0x18(%ebp),%eax
c01031c9:	83 c8 01             	or     $0x1,%eax
c01031cc:	89 c2                	mov    %eax,%edx
c01031ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031d1:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01031d7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01031de:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01031e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031e9:	75 a3                	jne    c010318e <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01031eb:	90                   	nop
c01031ec:	c9                   	leave  
c01031ed:	c3                   	ret    

c01031ee <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01031ee:	55                   	push   %ebp
c01031ef:	89 e5                	mov    %esp,%ebp
c01031f1:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01031f4:	83 ec 0c             	sub    $0xc,%esp
c01031f7:	6a 01                	push   $0x1
c01031f9:	e8 70 fa ff ff       	call   c0102c6e <alloc_pages>
c01031fe:	83 c4 10             	add    $0x10,%esp
c0103201:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103208:	75 17                	jne    c0103221 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c010320a:	83 ec 04             	sub    $0x4,%esp
c010320d:	68 6f 64 10 c0       	push   $0xc010646f
c0103212:	68 17 01 00 00       	push   $0x117
c0103217:	68 28 64 10 c0       	push   $0xc0106428
c010321c:	e8 b4 d1 ff ff       	call   c01003d5 <__panic>
    }
    return page2kva(p);     // va = pa + KERNELBASE(0x C000 0000)
c0103221:	83 ec 0c             	sub    $0xc,%esp
c0103224:	ff 75 f4             	pushl  -0xc(%ebp)
c0103227:	e8 99 f7 ff ff       	call   c01029c5 <page2kva>
c010322c:	83 c4 10             	add    $0x10,%esp
}
c010322f:	c9                   	leave  
c0103230:	c3                   	ret    

c0103231 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103231:	55                   	push   %ebp
c0103232:	89 e5                	mov    %esp,%ebp
c0103234:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103237:	e8 de f9 ff ff       	call   c0102c1a <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010323c:	e8 ce fa ff ff       	call   c0102d0f <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103241:	e8 38 04 00 00       	call   c010367e <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0103246:	e8 a3 ff ff ff       	call   c01031ee <boot_alloc_page>
c010324b:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0103250:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103255:	83 ec 04             	sub    $0x4,%esp
c0103258:	68 00 10 00 00       	push   $0x1000
c010325d:	6a 00                	push   $0x0
c010325f:	50                   	push   %eax
c0103260:	e8 13 22 00 00       	call   c0105478 <memset>
c0103265:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);   // paddr of pgdir
c0103268:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010326d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103270:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103277:	77 17                	ja     c0103290 <pmm_init+0x5f>
c0103279:	ff 75 f4             	pushl  -0xc(%ebp)
c010327c:	68 04 64 10 c0       	push   $0xc0106404
c0103281:	68 31 01 00 00       	push   $0x131
c0103286:	68 28 64 10 c0       	push   $0xc0106428
c010328b:	e8 45 d1 ff ff       	call   c01003d5 <__panic>
c0103290:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103293:	05 00 00 00 40       	add    $0x40000000,%eax
c0103298:	a3 b4 89 11 c0       	mov    %eax,0xc01189b4

    check_pgdir();
c010329d:	e8 ff 03 00 00       	call   c01036a1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01032a2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032a7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01032ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032b5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01032bc:	77 17                	ja     c01032d5 <pmm_init+0xa4>
c01032be:	ff 75 f0             	pushl  -0x10(%ebp)
c01032c1:	68 04 64 10 c0       	push   $0xc0106404
c01032c6:	68 39 01 00 00       	push   $0x139
c01032cb:	68 28 64 10 c0       	push   $0xc0106428
c01032d0:	e8 00 d1 ff ff       	call   c01003d5 <__panic>
c01032d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032d8:	05 00 00 00 40       	add    $0x40000000,%eax
c01032dd:	83 c8 03             	or     $0x3,%eax
c01032e0:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01032e2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032e7:	83 ec 0c             	sub    $0xc,%esp
c01032ea:	6a 02                	push   $0x2
c01032ec:	6a 00                	push   $0x0
c01032ee:	68 00 00 00 38       	push   $0x38000000
c01032f3:	68 00 00 00 c0       	push   $0xc0000000
c01032f8:	50                   	push   %eax
c01032f9:	e8 07 fe ff ff       	call   c0103105 <boot_map_segment>
c01032fe:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103301:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103306:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c010330c:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103312:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103314:	e8 b2 fd ff ff       	call   c01030cb <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103319:	e8 0a f8 ff ff       	call   c0102b28 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010331e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103329:	e8 d9 08 00 00       	call   c0103c07 <check_boot_pgdir>

    print_pgdir();
c010332e:	e8 cf 0c 00 00       	call   c0104002 <print_pgdir>

}
c0103333:	90                   	nop
c0103334:	c9                   	leave  
c0103335:	c3                   	ret    

c0103336 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103336:	55                   	push   %ebp
c0103337:	89 e5                	mov    %esp,%ebp
c0103339:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
c010333c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010333f:	c1 e8 16             	shr    $0x16,%eax
c0103342:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
c0103345:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010334f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103352:	01 d0                	add    %edx,%eax
c0103354:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
c0103357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010335a:	8b 00                	mov    (%eax),%eax
c010335c:	83 e0 01             	and    $0x1,%eax
c010335f:	85 c0                	test   %eax,%eax
c0103361:	0f 85 ae 00 00 00    	jne    c0103415 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
c0103367:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010336b:	75 0a                	jne    c0103377 <get_pte+0x41>
            return NULL;
c010336d:	b8 00 00 00 00       	mov    $0x0,%eax
c0103372:	e9 01 01 00 00       	jmp    c0103478 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
c0103377:	83 ec 0c             	sub    $0xc,%esp
c010337a:	6a 01                	push   $0x1
c010337c:	e8 ed f8 ff ff       	call   c0102c6e <alloc_pages>
c0103381:	83 c4 10             	add    $0x10,%esp
c0103384:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
c0103387:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010338b:	75 0a                	jne    c0103397 <get_pte+0x61>
            return NULL;
c010338d:	b8 00 00 00 00       	mov    $0x0,%eax
c0103392:	e9 e1 00 00 00       	jmp    c0103478 <get_pte+0x142>
        }

        // (4) set page reference
        set_page_ref(pt_page, 1);
c0103397:	83 ec 08             	sub    $0x8,%esp
c010339a:	6a 01                	push   $0x1
c010339c:	ff 75 ec             	pushl  -0x14(%ebp)
c010339f:	e8 c6 f6 ff ff       	call   c0102a6a <set_page_ref>
c01033a4:	83 c4 10             	add    $0x10,%esp

        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
c01033a7:	83 ec 0c             	sub    $0xc,%esp
c01033aa:	ff 75 ec             	pushl  -0x14(%ebp)
c01033ad:	e8 b9 f5 ff ff       	call   c010296b <page2pa>
c01033b2:	83 c4 10             	add    $0x10,%esp
c01033b5:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
c01033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033c1:	c1 e8 0c             	shr    $0xc,%eax
c01033c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01033c7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01033cc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01033cf:	72 17                	jb     c01033e8 <get_pte+0xb2>
c01033d1:	ff 75 e4             	pushl  -0x1c(%ebp)
c01033d4:	68 60 63 10 c0       	push   $0xc0106360
c01033d9:	68 97 01 00 00       	push   $0x197
c01033de:	68 28 64 10 c0       	push   $0xc0106428
c01033e3:	e8 ed cf ff ff       	call   c01003d5 <__panic>
c01033e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033eb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01033f0:	83 ec 04             	sub    $0x4,%esp
c01033f3:	68 00 10 00 00       	push   $0x1000
c01033f8:	6a 00                	push   $0x0
c01033fa:	50                   	push   %eax
c01033fb:	e8 78 20 00 00       	call   c0105478 <memset>
c0103400:	83 c4 10             	add    $0x10,%esp

        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
c0103403:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010340b:	83 c8 07             	or     $0x7,%eax
c010340e:	89 c2                	mov    %eax,%edx
c0103410:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103413:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
c0103415:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103418:	c1 e8 0c             	shr    $0xc,%eax
c010341b:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103420:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
c0103423:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103426:	8b 00                	mov    (%eax),%eax
c0103428:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010342d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
c0103430:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103433:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103436:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103439:	c1 e8 0c             	shr    $0xc,%eax
c010343c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010343f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103444:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103447:	72 17                	jb     c0103460 <get_pte+0x12a>
c0103449:	ff 75 d4             	pushl  -0x2c(%ebp)
c010344c:	68 60 63 10 c0       	push   $0xc0106360
c0103451:	68 9f 01 00 00       	push   $0x19f
c0103456:	68 28 64 10 c0       	push   $0xc0106428
c010345b:	e8 75 cf ff ff       	call   c01003d5 <__panic>
c0103460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103463:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103468:	89 c2                	mov    %eax,%edx
c010346a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010346d:	c1 e0 02             	shl    $0x2,%eax
c0103470:	01 d0                	add    %edx,%eax
c0103472:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
c0103475:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
c0103478:	c9                   	leave  
c0103479:	c3                   	ret    

c010347a <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010347a:	55                   	push   %ebp
c010347b:	89 e5                	mov    %esp,%ebp
c010347d:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103480:	83 ec 04             	sub    $0x4,%esp
c0103483:	6a 00                	push   $0x0
c0103485:	ff 75 0c             	pushl  0xc(%ebp)
c0103488:	ff 75 08             	pushl  0x8(%ebp)
c010348b:	e8 a6 fe ff ff       	call   c0103336 <get_pte>
c0103490:	83 c4 10             	add    $0x10,%esp
c0103493:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103496:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010349a:	74 08                	je     c01034a4 <get_page+0x2a>
        *ptep_store = ptep;
c010349c:	8b 45 10             	mov    0x10(%ebp),%eax
c010349f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01034a2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034a8:	74 1f                	je     c01034c9 <get_page+0x4f>
c01034aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ad:	8b 00                	mov    (%eax),%eax
c01034af:	83 e0 01             	and    $0x1,%eax
c01034b2:	85 c0                	test   %eax,%eax
c01034b4:	74 13                	je     c01034c9 <get_page+0x4f>
        return pte2page(*ptep);
c01034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b9:	8b 00                	mov    (%eax),%eax
c01034bb:	83 ec 0c             	sub    $0xc,%esp
c01034be:	50                   	push   %eax
c01034bf:	e8 46 f5 ff ff       	call   c0102a0a <pte2page>
c01034c4:	83 c4 10             	add    $0x10,%esp
c01034c7:	eb 05                	jmp    c01034ce <get_page+0x54>
    }
    return NULL;
c01034c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01034ce:	c9                   	leave  
c01034cf:	c3                   	ret    

c01034d0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01034d0:	55                   	push   %ebp
c01034d1:	89 e5                	mov    %esp,%ebp
c01034d3:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
c01034d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01034d9:	8b 00                	mov    (%eax),%eax
c01034db:	83 e0 01             	and    $0x1,%eax
c01034de:	85 c0                	test   %eax,%eax
c01034e0:	74 57                	je     c0103539 <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
c01034e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01034e5:	8b 00                	mov    (%eax),%eax
c01034e7:	83 ec 0c             	sub    $0xc,%esp
c01034ea:	50                   	push   %eax
c01034eb:	e8 1a f5 ff ff       	call   c0102a0a <pte2page>
c01034f0:	83 c4 10             	add    $0x10,%esp
c01034f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

    //(3) decrease page reference
    page_ref_dec(page);
c01034f6:	83 ec 0c             	sub    $0xc,%esp
c01034f9:	ff 75 f4             	pushl  -0xc(%ebp)
c01034fc:	e8 8e f5 ff ff       	call   c0102a8f <page_ref_dec>
c0103501:	83 c4 10             	add    $0x10,%esp

    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
c0103504:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103507:	8b 00                	mov    (%eax),%eax
c0103509:	85 c0                	test   %eax,%eax
c010350b:	75 10                	jne    c010351d <page_remove_pte+0x4d>
        free_page(page);
c010350d:	83 ec 08             	sub    $0x8,%esp
c0103510:	6a 01                	push   $0x1
c0103512:	ff 75 f4             	pushl  -0xc(%ebp)
c0103515:	e8 92 f7 ff ff       	call   c0102cac <free_pages>
c010351a:	83 c4 10             	add    $0x10,%esp
    }

    //(5) clear second page table entry
    *ptep = 0;
c010351d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
c0103526:	83 ec 08             	sub    $0x8,%esp
c0103529:	ff 75 0c             	pushl  0xc(%ebp)
c010352c:	ff 75 08             	pushl  0x8(%ebp)
c010352f:	e8 fa 00 00 00       	call   c010362e <tlb_invalidate>
c0103534:	83 c4 10             	add    $0x10,%esp
c0103537:	eb 01                	jmp    c010353a <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
c0103539:	90                   	nop
    //(5) clear second page table entry
    *ptep = 0;

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
c010353a:	c9                   	leave  
c010353b:	c3                   	ret    

c010353c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010353c:	55                   	push   %ebp
c010353d:	89 e5                	mov    %esp,%ebp
c010353f:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103542:	83 ec 04             	sub    $0x4,%esp
c0103545:	6a 00                	push   $0x0
c0103547:	ff 75 0c             	pushl  0xc(%ebp)
c010354a:	ff 75 08             	pushl  0x8(%ebp)
c010354d:	e8 e4 fd ff ff       	call   c0103336 <get_pte>
c0103552:	83 c4 10             	add    $0x10,%esp
c0103555:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010355c:	74 14                	je     c0103572 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010355e:	83 ec 04             	sub    $0x4,%esp
c0103561:	ff 75 f4             	pushl  -0xc(%ebp)
c0103564:	ff 75 0c             	pushl  0xc(%ebp)
c0103567:	ff 75 08             	pushl  0x8(%ebp)
c010356a:	e8 61 ff ff ff       	call   c01034d0 <page_remove_pte>
c010356f:	83 c4 10             	add    $0x10,%esp
    }
}
c0103572:	90                   	nop
c0103573:	c9                   	leave  
c0103574:	c3                   	ret    

c0103575 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103575:	55                   	push   %ebp
c0103576:	89 e5                	mov    %esp,%ebp
c0103578:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010357b:	83 ec 04             	sub    $0x4,%esp
c010357e:	6a 01                	push   $0x1
c0103580:	ff 75 10             	pushl  0x10(%ebp)
c0103583:	ff 75 08             	pushl  0x8(%ebp)
c0103586:	e8 ab fd ff ff       	call   c0103336 <get_pte>
c010358b:	83 c4 10             	add    $0x10,%esp
c010358e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103595:	75 0a                	jne    c01035a1 <page_insert+0x2c>
        return -E_NO_MEM;
c0103597:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010359c:	e9 8b 00 00 00       	jmp    c010362c <page_insert+0xb7>
    }
    page_ref_inc(page);
c01035a1:	83 ec 0c             	sub    $0xc,%esp
c01035a4:	ff 75 0c             	pushl  0xc(%ebp)
c01035a7:	e8 cc f4 ff ff       	call   c0102a78 <page_ref_inc>
c01035ac:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b2:	8b 00                	mov    (%eax),%eax
c01035b4:	83 e0 01             	and    $0x1,%eax
c01035b7:	85 c0                	test   %eax,%eax
c01035b9:	74 40                	je     c01035fb <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035be:	8b 00                	mov    (%eax),%eax
c01035c0:	83 ec 0c             	sub    $0xc,%esp
c01035c3:	50                   	push   %eax
c01035c4:	e8 41 f4 ff ff       	call   c0102a0a <pte2page>
c01035c9:	83 c4 10             	add    $0x10,%esp
c01035cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01035cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01035d5:	75 10                	jne    c01035e7 <page_insert+0x72>
            page_ref_dec(page);
c01035d7:	83 ec 0c             	sub    $0xc,%esp
c01035da:	ff 75 0c             	pushl  0xc(%ebp)
c01035dd:	e8 ad f4 ff ff       	call   c0102a8f <page_ref_dec>
c01035e2:	83 c4 10             	add    $0x10,%esp
c01035e5:	eb 14                	jmp    c01035fb <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01035e7:	83 ec 04             	sub    $0x4,%esp
c01035ea:	ff 75 f4             	pushl  -0xc(%ebp)
c01035ed:	ff 75 10             	pushl  0x10(%ebp)
c01035f0:	ff 75 08             	pushl  0x8(%ebp)
c01035f3:	e8 d8 fe ff ff       	call   c01034d0 <page_remove_pte>
c01035f8:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01035fb:	83 ec 0c             	sub    $0xc,%esp
c01035fe:	ff 75 0c             	pushl  0xc(%ebp)
c0103601:	e8 65 f3 ff ff       	call   c010296b <page2pa>
c0103606:	83 c4 10             	add    $0x10,%esp
c0103609:	0b 45 14             	or     0x14(%ebp),%eax
c010360c:	83 c8 01             	or     $0x1,%eax
c010360f:	89 c2                	mov    %eax,%edx
c0103611:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103614:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103616:	83 ec 08             	sub    $0x8,%esp
c0103619:	ff 75 10             	pushl  0x10(%ebp)
c010361c:	ff 75 08             	pushl  0x8(%ebp)
c010361f:	e8 0a 00 00 00       	call   c010362e <tlb_invalidate>
c0103624:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103627:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010362c:	c9                   	leave  
c010362d:	c3                   	ret    

c010362e <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010362e:	55                   	push   %ebp
c010362f:	89 e5                	mov    %esp,%ebp
c0103631:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103634:	0f 20 d8             	mov    %cr3,%eax
c0103637:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c010363a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010363d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103640:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103643:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010364a:	77 17                	ja     c0103663 <tlb_invalidate+0x35>
c010364c:	ff 75 f0             	pushl  -0x10(%ebp)
c010364f:	68 04 64 10 c0       	push   $0xc0106404
c0103654:	68 0e 02 00 00       	push   $0x20e
c0103659:	68 28 64 10 c0       	push   $0xc0106428
c010365e:	e8 72 cd ff ff       	call   c01003d5 <__panic>
c0103663:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103666:	05 00 00 00 40       	add    $0x40000000,%eax
c010366b:	39 c2                	cmp    %eax,%edx
c010366d:	75 0c                	jne    c010367b <tlb_invalidate+0x4d>
        invlpg((void *)la);
c010366f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103672:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103675:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103678:	0f 01 38             	invlpg (%eax)
    }
}
c010367b:	90                   	nop
c010367c:	c9                   	leave  
c010367d:	c3                   	ret    

c010367e <check_alloc_page>:

static void
check_alloc_page(void) {
c010367e:	55                   	push   %ebp
c010367f:	89 e5                	mov    %esp,%ebp
c0103681:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0103684:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0103689:	8b 40 18             	mov    0x18(%eax),%eax
c010368c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010368e:	83 ec 0c             	sub    $0xc,%esp
c0103691:	68 88 64 10 c0       	push   $0xc0106488
c0103696:	e8 d4 cb ff ff       	call   c010026f <cprintf>
c010369b:	83 c4 10             	add    $0x10,%esp
}
c010369e:	90                   	nop
c010369f:	c9                   	leave  
c01036a0:	c3                   	ret    

c01036a1 <check_pgdir>:

static void
check_pgdir(void) {
c01036a1:	55                   	push   %ebp
c01036a2:	89 e5                	mov    %esp,%ebp
c01036a4:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01036a7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01036ac:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01036b1:	76 19                	jbe    c01036cc <check_pgdir+0x2b>
c01036b3:	68 a7 64 10 c0       	push   $0xc01064a7
c01036b8:	68 4d 64 10 c0       	push   $0xc010644d
c01036bd:	68 1b 02 00 00       	push   $0x21b
c01036c2:	68 28 64 10 c0       	push   $0xc0106428
c01036c7:	e8 09 cd ff ff       	call   c01003d5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01036cc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036d1:	85 c0                	test   %eax,%eax
c01036d3:	74 0e                	je     c01036e3 <check_pgdir+0x42>
c01036d5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036da:	25 ff 0f 00 00       	and    $0xfff,%eax
c01036df:	85 c0                	test   %eax,%eax
c01036e1:	74 19                	je     c01036fc <check_pgdir+0x5b>
c01036e3:	68 c4 64 10 c0       	push   $0xc01064c4
c01036e8:	68 4d 64 10 c0       	push   $0xc010644d
c01036ed:	68 1c 02 00 00       	push   $0x21c
c01036f2:	68 28 64 10 c0       	push   $0xc0106428
c01036f7:	e8 d9 cc ff ff       	call   c01003d5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01036fc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103701:	83 ec 04             	sub    $0x4,%esp
c0103704:	6a 00                	push   $0x0
c0103706:	6a 00                	push   $0x0
c0103708:	50                   	push   %eax
c0103709:	e8 6c fd ff ff       	call   c010347a <get_page>
c010370e:	83 c4 10             	add    $0x10,%esp
c0103711:	85 c0                	test   %eax,%eax
c0103713:	74 19                	je     c010372e <check_pgdir+0x8d>
c0103715:	68 fc 64 10 c0       	push   $0xc01064fc
c010371a:	68 4d 64 10 c0       	push   $0xc010644d
c010371f:	68 1d 02 00 00       	push   $0x21d
c0103724:	68 28 64 10 c0       	push   $0xc0106428
c0103729:	e8 a7 cc ff ff       	call   c01003d5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010372e:	83 ec 0c             	sub    $0xc,%esp
c0103731:	6a 01                	push   $0x1
c0103733:	e8 36 f5 ff ff       	call   c0102c6e <alloc_pages>
c0103738:	83 c4 10             	add    $0x10,%esp
c010373b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010373e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103743:	6a 00                	push   $0x0
c0103745:	6a 00                	push   $0x0
c0103747:	ff 75 f4             	pushl  -0xc(%ebp)
c010374a:	50                   	push   %eax
c010374b:	e8 25 fe ff ff       	call   c0103575 <page_insert>
c0103750:	83 c4 10             	add    $0x10,%esp
c0103753:	85 c0                	test   %eax,%eax
c0103755:	74 19                	je     c0103770 <check_pgdir+0xcf>
c0103757:	68 24 65 10 c0       	push   $0xc0106524
c010375c:	68 4d 64 10 c0       	push   $0xc010644d
c0103761:	68 21 02 00 00       	push   $0x221
c0103766:	68 28 64 10 c0       	push   $0xc0106428
c010376b:	e8 65 cc ff ff       	call   c01003d5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103770:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103775:	83 ec 04             	sub    $0x4,%esp
c0103778:	6a 00                	push   $0x0
c010377a:	6a 00                	push   $0x0
c010377c:	50                   	push   %eax
c010377d:	e8 b4 fb ff ff       	call   c0103336 <get_pte>
c0103782:	83 c4 10             	add    $0x10,%esp
c0103785:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010378c:	75 19                	jne    c01037a7 <check_pgdir+0x106>
c010378e:	68 50 65 10 c0       	push   $0xc0106550
c0103793:	68 4d 64 10 c0       	push   $0xc010644d
c0103798:	68 24 02 00 00       	push   $0x224
c010379d:	68 28 64 10 c0       	push   $0xc0106428
c01037a2:	e8 2e cc ff ff       	call   c01003d5 <__panic>
    assert(pte2page(*ptep) == p1);
c01037a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037aa:	8b 00                	mov    (%eax),%eax
c01037ac:	83 ec 0c             	sub    $0xc,%esp
c01037af:	50                   	push   %eax
c01037b0:	e8 55 f2 ff ff       	call   c0102a0a <pte2page>
c01037b5:	83 c4 10             	add    $0x10,%esp
c01037b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037bb:	74 19                	je     c01037d6 <check_pgdir+0x135>
c01037bd:	68 7d 65 10 c0       	push   $0xc010657d
c01037c2:	68 4d 64 10 c0       	push   $0xc010644d
c01037c7:	68 25 02 00 00       	push   $0x225
c01037cc:	68 28 64 10 c0       	push   $0xc0106428
c01037d1:	e8 ff cb ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p1) == 1);
c01037d6:	83 ec 0c             	sub    $0xc,%esp
c01037d9:	ff 75 f4             	pushl  -0xc(%ebp)
c01037dc:	e8 7f f2 ff ff       	call   c0102a60 <page_ref>
c01037e1:	83 c4 10             	add    $0x10,%esp
c01037e4:	83 f8 01             	cmp    $0x1,%eax
c01037e7:	74 19                	je     c0103802 <check_pgdir+0x161>
c01037e9:	68 93 65 10 c0       	push   $0xc0106593
c01037ee:	68 4d 64 10 c0       	push   $0xc010644d
c01037f3:	68 26 02 00 00       	push   $0x226
c01037f8:	68 28 64 10 c0       	push   $0xc0106428
c01037fd:	e8 d3 cb ff ff       	call   c01003d5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103802:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103807:	8b 00                	mov    (%eax),%eax
c0103809:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010380e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103811:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103814:	c1 e8 0c             	shr    $0xc,%eax
c0103817:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010381a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010381f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103822:	72 17                	jb     c010383b <check_pgdir+0x19a>
c0103824:	ff 75 ec             	pushl  -0x14(%ebp)
c0103827:	68 60 63 10 c0       	push   $0xc0106360
c010382c:	68 28 02 00 00       	push   $0x228
c0103831:	68 28 64 10 c0       	push   $0xc0106428
c0103836:	e8 9a cb ff ff       	call   c01003d5 <__panic>
c010383b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010383e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103843:	83 c0 04             	add    $0x4,%eax
c0103846:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103849:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010384e:	83 ec 04             	sub    $0x4,%esp
c0103851:	6a 00                	push   $0x0
c0103853:	68 00 10 00 00       	push   $0x1000
c0103858:	50                   	push   %eax
c0103859:	e8 d8 fa ff ff       	call   c0103336 <get_pte>
c010385e:	83 c4 10             	add    $0x10,%esp
c0103861:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103864:	74 19                	je     c010387f <check_pgdir+0x1de>
c0103866:	68 a8 65 10 c0       	push   $0xc01065a8
c010386b:	68 4d 64 10 c0       	push   $0xc010644d
c0103870:	68 29 02 00 00       	push   $0x229
c0103875:	68 28 64 10 c0       	push   $0xc0106428
c010387a:	e8 56 cb ff ff       	call   c01003d5 <__panic>

    p2 = alloc_page();
c010387f:	83 ec 0c             	sub    $0xc,%esp
c0103882:	6a 01                	push   $0x1
c0103884:	e8 e5 f3 ff ff       	call   c0102c6e <alloc_pages>
c0103889:	83 c4 10             	add    $0x10,%esp
c010388c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010388f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103894:	6a 06                	push   $0x6
c0103896:	68 00 10 00 00       	push   $0x1000
c010389b:	ff 75 e4             	pushl  -0x1c(%ebp)
c010389e:	50                   	push   %eax
c010389f:	e8 d1 fc ff ff       	call   c0103575 <page_insert>
c01038a4:	83 c4 10             	add    $0x10,%esp
c01038a7:	85 c0                	test   %eax,%eax
c01038a9:	74 19                	je     c01038c4 <check_pgdir+0x223>
c01038ab:	68 d0 65 10 c0       	push   $0xc01065d0
c01038b0:	68 4d 64 10 c0       	push   $0xc010644d
c01038b5:	68 2c 02 00 00       	push   $0x22c
c01038ba:	68 28 64 10 c0       	push   $0xc0106428
c01038bf:	e8 11 cb ff ff       	call   c01003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01038c4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038c9:	83 ec 04             	sub    $0x4,%esp
c01038cc:	6a 00                	push   $0x0
c01038ce:	68 00 10 00 00       	push   $0x1000
c01038d3:	50                   	push   %eax
c01038d4:	e8 5d fa ff ff       	call   c0103336 <get_pte>
c01038d9:	83 c4 10             	add    $0x10,%esp
c01038dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038e3:	75 19                	jne    c01038fe <check_pgdir+0x25d>
c01038e5:	68 08 66 10 c0       	push   $0xc0106608
c01038ea:	68 4d 64 10 c0       	push   $0xc010644d
c01038ef:	68 2d 02 00 00       	push   $0x22d
c01038f4:	68 28 64 10 c0       	push   $0xc0106428
c01038f9:	e8 d7 ca ff ff       	call   c01003d5 <__panic>
    assert(*ptep & PTE_U);
c01038fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103901:	8b 00                	mov    (%eax),%eax
c0103903:	83 e0 04             	and    $0x4,%eax
c0103906:	85 c0                	test   %eax,%eax
c0103908:	75 19                	jne    c0103923 <check_pgdir+0x282>
c010390a:	68 38 66 10 c0       	push   $0xc0106638
c010390f:	68 4d 64 10 c0       	push   $0xc010644d
c0103914:	68 2e 02 00 00       	push   $0x22e
c0103919:	68 28 64 10 c0       	push   $0xc0106428
c010391e:	e8 b2 ca ff ff       	call   c01003d5 <__panic>
    assert(*ptep & PTE_W);
c0103923:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103926:	8b 00                	mov    (%eax),%eax
c0103928:	83 e0 02             	and    $0x2,%eax
c010392b:	85 c0                	test   %eax,%eax
c010392d:	75 19                	jne    c0103948 <check_pgdir+0x2a7>
c010392f:	68 46 66 10 c0       	push   $0xc0106646
c0103934:	68 4d 64 10 c0       	push   $0xc010644d
c0103939:	68 2f 02 00 00       	push   $0x22f
c010393e:	68 28 64 10 c0       	push   $0xc0106428
c0103943:	e8 8d ca ff ff       	call   c01003d5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103948:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010394d:	8b 00                	mov    (%eax),%eax
c010394f:	83 e0 04             	and    $0x4,%eax
c0103952:	85 c0                	test   %eax,%eax
c0103954:	75 19                	jne    c010396f <check_pgdir+0x2ce>
c0103956:	68 54 66 10 c0       	push   $0xc0106654
c010395b:	68 4d 64 10 c0       	push   $0xc010644d
c0103960:	68 30 02 00 00       	push   $0x230
c0103965:	68 28 64 10 c0       	push   $0xc0106428
c010396a:	e8 66 ca ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 1);
c010396f:	83 ec 0c             	sub    $0xc,%esp
c0103972:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103975:	e8 e6 f0 ff ff       	call   c0102a60 <page_ref>
c010397a:	83 c4 10             	add    $0x10,%esp
c010397d:	83 f8 01             	cmp    $0x1,%eax
c0103980:	74 19                	je     c010399b <check_pgdir+0x2fa>
c0103982:	68 6a 66 10 c0       	push   $0xc010666a
c0103987:	68 4d 64 10 c0       	push   $0xc010644d
c010398c:	68 31 02 00 00       	push   $0x231
c0103991:	68 28 64 10 c0       	push   $0xc0106428
c0103996:	e8 3a ca ff ff       	call   c01003d5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010399b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039a0:	6a 00                	push   $0x0
c01039a2:	68 00 10 00 00       	push   $0x1000
c01039a7:	ff 75 f4             	pushl  -0xc(%ebp)
c01039aa:	50                   	push   %eax
c01039ab:	e8 c5 fb ff ff       	call   c0103575 <page_insert>
c01039b0:	83 c4 10             	add    $0x10,%esp
c01039b3:	85 c0                	test   %eax,%eax
c01039b5:	74 19                	je     c01039d0 <check_pgdir+0x32f>
c01039b7:	68 7c 66 10 c0       	push   $0xc010667c
c01039bc:	68 4d 64 10 c0       	push   $0xc010644d
c01039c1:	68 33 02 00 00       	push   $0x233
c01039c6:	68 28 64 10 c0       	push   $0xc0106428
c01039cb:	e8 05 ca ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p1) == 2);
c01039d0:	83 ec 0c             	sub    $0xc,%esp
c01039d3:	ff 75 f4             	pushl  -0xc(%ebp)
c01039d6:	e8 85 f0 ff ff       	call   c0102a60 <page_ref>
c01039db:	83 c4 10             	add    $0x10,%esp
c01039de:	83 f8 02             	cmp    $0x2,%eax
c01039e1:	74 19                	je     c01039fc <check_pgdir+0x35b>
c01039e3:	68 a8 66 10 c0       	push   $0xc01066a8
c01039e8:	68 4d 64 10 c0       	push   $0xc010644d
c01039ed:	68 34 02 00 00       	push   $0x234
c01039f2:	68 28 64 10 c0       	push   $0xc0106428
c01039f7:	e8 d9 c9 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c01039fc:	83 ec 0c             	sub    $0xc,%esp
c01039ff:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a02:	e8 59 f0 ff ff       	call   c0102a60 <page_ref>
c0103a07:	83 c4 10             	add    $0x10,%esp
c0103a0a:	85 c0                	test   %eax,%eax
c0103a0c:	74 19                	je     c0103a27 <check_pgdir+0x386>
c0103a0e:	68 ba 66 10 c0       	push   $0xc01066ba
c0103a13:	68 4d 64 10 c0       	push   $0xc010644d
c0103a18:	68 35 02 00 00       	push   $0x235
c0103a1d:	68 28 64 10 c0       	push   $0xc0106428
c0103a22:	e8 ae c9 ff ff       	call   c01003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a27:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a2c:	83 ec 04             	sub    $0x4,%esp
c0103a2f:	6a 00                	push   $0x0
c0103a31:	68 00 10 00 00       	push   $0x1000
c0103a36:	50                   	push   %eax
c0103a37:	e8 fa f8 ff ff       	call   c0103336 <get_pte>
c0103a3c:	83 c4 10             	add    $0x10,%esp
c0103a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a46:	75 19                	jne    c0103a61 <check_pgdir+0x3c0>
c0103a48:	68 08 66 10 c0       	push   $0xc0106608
c0103a4d:	68 4d 64 10 c0       	push   $0xc010644d
c0103a52:	68 36 02 00 00       	push   $0x236
c0103a57:	68 28 64 10 c0       	push   $0xc0106428
c0103a5c:	e8 74 c9 ff ff       	call   c01003d5 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a64:	8b 00                	mov    (%eax),%eax
c0103a66:	83 ec 0c             	sub    $0xc,%esp
c0103a69:	50                   	push   %eax
c0103a6a:	e8 9b ef ff ff       	call   c0102a0a <pte2page>
c0103a6f:	83 c4 10             	add    $0x10,%esp
c0103a72:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a75:	74 19                	je     c0103a90 <check_pgdir+0x3ef>
c0103a77:	68 7d 65 10 c0       	push   $0xc010657d
c0103a7c:	68 4d 64 10 c0       	push   $0xc010644d
c0103a81:	68 37 02 00 00       	push   $0x237
c0103a86:	68 28 64 10 c0       	push   $0xc0106428
c0103a8b:	e8 45 c9 ff ff       	call   c01003d5 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a93:	8b 00                	mov    (%eax),%eax
c0103a95:	83 e0 04             	and    $0x4,%eax
c0103a98:	85 c0                	test   %eax,%eax
c0103a9a:	74 19                	je     c0103ab5 <check_pgdir+0x414>
c0103a9c:	68 cc 66 10 c0       	push   $0xc01066cc
c0103aa1:	68 4d 64 10 c0       	push   $0xc010644d
c0103aa6:	68 38 02 00 00       	push   $0x238
c0103aab:	68 28 64 10 c0       	push   $0xc0106428
c0103ab0:	e8 20 c9 ff ff       	call   c01003d5 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103ab5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103aba:	83 ec 08             	sub    $0x8,%esp
c0103abd:	6a 00                	push   $0x0
c0103abf:	50                   	push   %eax
c0103ac0:	e8 77 fa ff ff       	call   c010353c <page_remove>
c0103ac5:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103ac8:	83 ec 0c             	sub    $0xc,%esp
c0103acb:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ace:	e8 8d ef ff ff       	call   c0102a60 <page_ref>
c0103ad3:	83 c4 10             	add    $0x10,%esp
c0103ad6:	83 f8 01             	cmp    $0x1,%eax
c0103ad9:	74 19                	je     c0103af4 <check_pgdir+0x453>
c0103adb:	68 93 65 10 c0       	push   $0xc0106593
c0103ae0:	68 4d 64 10 c0       	push   $0xc010644d
c0103ae5:	68 3b 02 00 00       	push   $0x23b
c0103aea:	68 28 64 10 c0       	push   $0xc0106428
c0103aef:	e8 e1 c8 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c0103af4:	83 ec 0c             	sub    $0xc,%esp
c0103af7:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103afa:	e8 61 ef ff ff       	call   c0102a60 <page_ref>
c0103aff:	83 c4 10             	add    $0x10,%esp
c0103b02:	85 c0                	test   %eax,%eax
c0103b04:	74 19                	je     c0103b1f <check_pgdir+0x47e>
c0103b06:	68 ba 66 10 c0       	push   $0xc01066ba
c0103b0b:	68 4d 64 10 c0       	push   $0xc010644d
c0103b10:	68 3c 02 00 00       	push   $0x23c
c0103b15:	68 28 64 10 c0       	push   $0xc0106428
c0103b1a:	e8 b6 c8 ff ff       	call   c01003d5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103b1f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b24:	83 ec 08             	sub    $0x8,%esp
c0103b27:	68 00 10 00 00       	push   $0x1000
c0103b2c:	50                   	push   %eax
c0103b2d:	e8 0a fa ff ff       	call   c010353c <page_remove>
c0103b32:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103b35:	83 ec 0c             	sub    $0xc,%esp
c0103b38:	ff 75 f4             	pushl  -0xc(%ebp)
c0103b3b:	e8 20 ef ff ff       	call   c0102a60 <page_ref>
c0103b40:	83 c4 10             	add    $0x10,%esp
c0103b43:	85 c0                	test   %eax,%eax
c0103b45:	74 19                	je     c0103b60 <check_pgdir+0x4bf>
c0103b47:	68 e1 66 10 c0       	push   $0xc01066e1
c0103b4c:	68 4d 64 10 c0       	push   $0xc010644d
c0103b51:	68 3f 02 00 00       	push   $0x23f
c0103b56:	68 28 64 10 c0       	push   $0xc0106428
c0103b5b:	e8 75 c8 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p2) == 0);
c0103b60:	83 ec 0c             	sub    $0xc,%esp
c0103b63:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b66:	e8 f5 ee ff ff       	call   c0102a60 <page_ref>
c0103b6b:	83 c4 10             	add    $0x10,%esp
c0103b6e:	85 c0                	test   %eax,%eax
c0103b70:	74 19                	je     c0103b8b <check_pgdir+0x4ea>
c0103b72:	68 ba 66 10 c0       	push   $0xc01066ba
c0103b77:	68 4d 64 10 c0       	push   $0xc010644d
c0103b7c:	68 40 02 00 00       	push   $0x240
c0103b81:	68 28 64 10 c0       	push   $0xc0106428
c0103b86:	e8 4a c8 ff ff       	call   c01003d5 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103b8b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b90:	8b 00                	mov    (%eax),%eax
c0103b92:	83 ec 0c             	sub    $0xc,%esp
c0103b95:	50                   	push   %eax
c0103b96:	e8 a9 ee ff ff       	call   c0102a44 <pde2page>
c0103b9b:	83 c4 10             	add    $0x10,%esp
c0103b9e:	83 ec 0c             	sub    $0xc,%esp
c0103ba1:	50                   	push   %eax
c0103ba2:	e8 b9 ee ff ff       	call   c0102a60 <page_ref>
c0103ba7:	83 c4 10             	add    $0x10,%esp
c0103baa:	83 f8 01             	cmp    $0x1,%eax
c0103bad:	74 19                	je     c0103bc8 <check_pgdir+0x527>
c0103baf:	68 f4 66 10 c0       	push   $0xc01066f4
c0103bb4:	68 4d 64 10 c0       	push   $0xc010644d
c0103bb9:	68 42 02 00 00       	push   $0x242
c0103bbe:	68 28 64 10 c0       	push   $0xc0106428
c0103bc3:	e8 0d c8 ff ff       	call   c01003d5 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103bc8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bcd:	8b 00                	mov    (%eax),%eax
c0103bcf:	83 ec 0c             	sub    $0xc,%esp
c0103bd2:	50                   	push   %eax
c0103bd3:	e8 6c ee ff ff       	call   c0102a44 <pde2page>
c0103bd8:	83 c4 10             	add    $0x10,%esp
c0103bdb:	83 ec 08             	sub    $0x8,%esp
c0103bde:	6a 01                	push   $0x1
c0103be0:	50                   	push   %eax
c0103be1:	e8 c6 f0 ff ff       	call   c0102cac <free_pages>
c0103be6:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103be9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103bf4:	83 ec 0c             	sub    $0xc,%esp
c0103bf7:	68 1b 67 10 c0       	push   $0xc010671b
c0103bfc:	e8 6e c6 ff ff       	call   c010026f <cprintf>
c0103c01:	83 c4 10             	add    $0x10,%esp
}
c0103c04:	90                   	nop
c0103c05:	c9                   	leave  
c0103c06:	c3                   	ret    

c0103c07 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103c07:	55                   	push   %ebp
c0103c08:	89 e5                	mov    %esp,%ebp
c0103c0a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c14:	e9 a3 00 00 00       	jmp    c0103cbc <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c22:	c1 e8 0c             	shr    $0xc,%eax
c0103c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c28:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c2d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103c30:	72 17                	jb     c0103c49 <check_boot_pgdir+0x42>
c0103c32:	ff 75 f0             	pushl  -0x10(%ebp)
c0103c35:	68 60 63 10 c0       	push   $0xc0106360
c0103c3a:	68 4e 02 00 00       	push   $0x24e
c0103c3f:	68 28 64 10 c0       	push   $0xc0106428
c0103c44:	e8 8c c7 ff ff       	call   c01003d5 <__panic>
c0103c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c4c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103c51:	89 c2                	mov    %eax,%edx
c0103c53:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c58:	83 ec 04             	sub    $0x4,%esp
c0103c5b:	6a 00                	push   $0x0
c0103c5d:	52                   	push   %edx
c0103c5e:	50                   	push   %eax
c0103c5f:	e8 d2 f6 ff ff       	call   c0103336 <get_pte>
c0103c64:	83 c4 10             	add    $0x10,%esp
c0103c67:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103c6a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103c6e:	75 19                	jne    c0103c89 <check_boot_pgdir+0x82>
c0103c70:	68 38 67 10 c0       	push   $0xc0106738
c0103c75:	68 4d 64 10 c0       	push   $0xc010644d
c0103c7a:	68 4e 02 00 00       	push   $0x24e
c0103c7f:	68 28 64 10 c0       	push   $0xc0106428
c0103c84:	e8 4c c7 ff ff       	call   c01003d5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103c89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c8c:	8b 00                	mov    (%eax),%eax
c0103c8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c93:	89 c2                	mov    %eax,%edx
c0103c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c98:	39 c2                	cmp    %eax,%edx
c0103c9a:	74 19                	je     c0103cb5 <check_boot_pgdir+0xae>
c0103c9c:	68 75 67 10 c0       	push   $0xc0106775
c0103ca1:	68 4d 64 10 c0       	push   $0xc010644d
c0103ca6:	68 4f 02 00 00       	push   $0x24f
c0103cab:	68 28 64 10 c0       	push   $0xc0106428
c0103cb0:	e8 20 c7 ff ff       	call   c01003d5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103cb5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103cbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103cbf:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103cc4:	39 c2                	cmp    %eax,%edx
c0103cc6:	0f 82 4d ff ff ff    	jb     c0103c19 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103ccc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103cd1:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103cd6:	8b 00                	mov    (%eax),%eax
c0103cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cdd:	89 c2                	mov    %eax,%edx
c0103cdf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ce4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ce7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103cee:	77 17                	ja     c0103d07 <check_boot_pgdir+0x100>
c0103cf0:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103cf3:	68 04 64 10 c0       	push   $0xc0106404
c0103cf8:	68 52 02 00 00       	push   $0x252
c0103cfd:	68 28 64 10 c0       	push   $0xc0106428
c0103d02:	e8 ce c6 ff ff       	call   c01003d5 <__panic>
c0103d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d0a:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d0f:	39 c2                	cmp    %eax,%edx
c0103d11:	74 19                	je     c0103d2c <check_boot_pgdir+0x125>
c0103d13:	68 8c 67 10 c0       	push   $0xc010678c
c0103d18:	68 4d 64 10 c0       	push   $0xc010644d
c0103d1d:	68 52 02 00 00       	push   $0x252
c0103d22:	68 28 64 10 c0       	push   $0xc0106428
c0103d27:	e8 a9 c6 ff ff       	call   c01003d5 <__panic>

    assert(boot_pgdir[0] == 0);
c0103d2c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d31:	8b 00                	mov    (%eax),%eax
c0103d33:	85 c0                	test   %eax,%eax
c0103d35:	74 19                	je     c0103d50 <check_boot_pgdir+0x149>
c0103d37:	68 c0 67 10 c0       	push   $0xc01067c0
c0103d3c:	68 4d 64 10 c0       	push   $0xc010644d
c0103d41:	68 54 02 00 00       	push   $0x254
c0103d46:	68 28 64 10 c0       	push   $0xc0106428
c0103d4b:	e8 85 c6 ff ff       	call   c01003d5 <__panic>

    struct Page *p;
    p = alloc_page();
c0103d50:	83 ec 0c             	sub    $0xc,%esp
c0103d53:	6a 01                	push   $0x1
c0103d55:	e8 14 ef ff ff       	call   c0102c6e <alloc_pages>
c0103d5a:	83 c4 10             	add    $0x10,%esp
c0103d5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103d60:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d65:	6a 02                	push   $0x2
c0103d67:	68 00 01 00 00       	push   $0x100
c0103d6c:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d6f:	50                   	push   %eax
c0103d70:	e8 00 f8 ff ff       	call   c0103575 <page_insert>
c0103d75:	83 c4 10             	add    $0x10,%esp
c0103d78:	85 c0                	test   %eax,%eax
c0103d7a:	74 19                	je     c0103d95 <check_boot_pgdir+0x18e>
c0103d7c:	68 d4 67 10 c0       	push   $0xc01067d4
c0103d81:	68 4d 64 10 c0       	push   $0xc010644d
c0103d86:	68 58 02 00 00       	push   $0x258
c0103d8b:	68 28 64 10 c0       	push   $0xc0106428
c0103d90:	e8 40 c6 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p) == 1);
c0103d95:	83 ec 0c             	sub    $0xc,%esp
c0103d98:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d9b:	e8 c0 ec ff ff       	call   c0102a60 <page_ref>
c0103da0:	83 c4 10             	add    $0x10,%esp
c0103da3:	83 f8 01             	cmp    $0x1,%eax
c0103da6:	74 19                	je     c0103dc1 <check_boot_pgdir+0x1ba>
c0103da8:	68 02 68 10 c0       	push   $0xc0106802
c0103dad:	68 4d 64 10 c0       	push   $0xc010644d
c0103db2:	68 59 02 00 00       	push   $0x259
c0103db7:	68 28 64 10 c0       	push   $0xc0106428
c0103dbc:	e8 14 c6 ff ff       	call   c01003d5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103dc1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103dc6:	6a 02                	push   $0x2
c0103dc8:	68 00 11 00 00       	push   $0x1100
c0103dcd:	ff 75 e0             	pushl  -0x20(%ebp)
c0103dd0:	50                   	push   %eax
c0103dd1:	e8 9f f7 ff ff       	call   c0103575 <page_insert>
c0103dd6:	83 c4 10             	add    $0x10,%esp
c0103dd9:	85 c0                	test   %eax,%eax
c0103ddb:	74 19                	je     c0103df6 <check_boot_pgdir+0x1ef>
c0103ddd:	68 14 68 10 c0       	push   $0xc0106814
c0103de2:	68 4d 64 10 c0       	push   $0xc010644d
c0103de7:	68 5a 02 00 00       	push   $0x25a
c0103dec:	68 28 64 10 c0       	push   $0xc0106428
c0103df1:	e8 df c5 ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p) == 2);
c0103df6:	83 ec 0c             	sub    $0xc,%esp
c0103df9:	ff 75 e0             	pushl  -0x20(%ebp)
c0103dfc:	e8 5f ec ff ff       	call   c0102a60 <page_ref>
c0103e01:	83 c4 10             	add    $0x10,%esp
c0103e04:	83 f8 02             	cmp    $0x2,%eax
c0103e07:	74 19                	je     c0103e22 <check_boot_pgdir+0x21b>
c0103e09:	68 4b 68 10 c0       	push   $0xc010684b
c0103e0e:	68 4d 64 10 c0       	push   $0xc010644d
c0103e13:	68 5b 02 00 00       	push   $0x25b
c0103e18:	68 28 64 10 c0       	push   $0xc0106428
c0103e1d:	e8 b3 c5 ff ff       	call   c01003d5 <__panic>

    const char *str = "ucore: Hello world!!";
c0103e22:	c7 45 dc 5c 68 10 c0 	movl   $0xc010685c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103e29:	83 ec 08             	sub    $0x8,%esp
c0103e2c:	ff 75 dc             	pushl  -0x24(%ebp)
c0103e2f:	68 00 01 00 00       	push   $0x100
c0103e34:	e8 66 13 00 00       	call   c010519f <strcpy>
c0103e39:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103e3c:	83 ec 08             	sub    $0x8,%esp
c0103e3f:	68 00 11 00 00       	push   $0x1100
c0103e44:	68 00 01 00 00       	push   $0x100
c0103e49:	e8 cb 13 00 00       	call   c0105219 <strcmp>
c0103e4e:	83 c4 10             	add    $0x10,%esp
c0103e51:	85 c0                	test   %eax,%eax
c0103e53:	74 19                	je     c0103e6e <check_boot_pgdir+0x267>
c0103e55:	68 74 68 10 c0       	push   $0xc0106874
c0103e5a:	68 4d 64 10 c0       	push   $0xc010644d
c0103e5f:	68 5f 02 00 00       	push   $0x25f
c0103e64:	68 28 64 10 c0       	push   $0xc0106428
c0103e69:	e8 67 c5 ff ff       	call   c01003d5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103e6e:	83 ec 0c             	sub    $0xc,%esp
c0103e71:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e74:	e8 4c eb ff ff       	call   c01029c5 <page2kva>
c0103e79:	83 c4 10             	add    $0x10,%esp
c0103e7c:	05 00 01 00 00       	add    $0x100,%eax
c0103e81:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103e84:	83 ec 0c             	sub    $0xc,%esp
c0103e87:	68 00 01 00 00       	push   $0x100
c0103e8c:	e8 b6 12 00 00       	call   c0105147 <strlen>
c0103e91:	83 c4 10             	add    $0x10,%esp
c0103e94:	85 c0                	test   %eax,%eax
c0103e96:	74 19                	je     c0103eb1 <check_boot_pgdir+0x2aa>
c0103e98:	68 ac 68 10 c0       	push   $0xc01068ac
c0103e9d:	68 4d 64 10 c0       	push   $0xc010644d
c0103ea2:	68 62 02 00 00       	push   $0x262
c0103ea7:	68 28 64 10 c0       	push   $0xc0106428
c0103eac:	e8 24 c5 ff ff       	call   c01003d5 <__panic>

    free_page(p);
c0103eb1:	83 ec 08             	sub    $0x8,%esp
c0103eb4:	6a 01                	push   $0x1
c0103eb6:	ff 75 e0             	pushl  -0x20(%ebp)
c0103eb9:	e8 ee ed ff ff       	call   c0102cac <free_pages>
c0103ebe:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103ec1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ec6:	8b 00                	mov    (%eax),%eax
c0103ec8:	83 ec 0c             	sub    $0xc,%esp
c0103ecb:	50                   	push   %eax
c0103ecc:	e8 73 eb ff ff       	call   c0102a44 <pde2page>
c0103ed1:	83 c4 10             	add    $0x10,%esp
c0103ed4:	83 ec 08             	sub    $0x8,%esp
c0103ed7:	6a 01                	push   $0x1
c0103ed9:	50                   	push   %eax
c0103eda:	e8 cd ed ff ff       	call   c0102cac <free_pages>
c0103edf:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103ee2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103eed:	83 ec 0c             	sub    $0xc,%esp
c0103ef0:	68 d0 68 10 c0       	push   $0xc01068d0
c0103ef5:	e8 75 c3 ff ff       	call   c010026f <cprintf>
c0103efa:	83 c4 10             	add    $0x10,%esp
}
c0103efd:	90                   	nop
c0103efe:	c9                   	leave  
c0103eff:	c3                   	ret    

c0103f00 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103f00:	55                   	push   %ebp
c0103f01:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103f03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f06:	83 e0 04             	and    $0x4,%eax
c0103f09:	85 c0                	test   %eax,%eax
c0103f0b:	74 07                	je     c0103f14 <perm2str+0x14>
c0103f0d:	b8 75 00 00 00       	mov    $0x75,%eax
c0103f12:	eb 05                	jmp    c0103f19 <perm2str+0x19>
c0103f14:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103f19:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103f1e:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f28:	83 e0 02             	and    $0x2,%eax
c0103f2b:	85 c0                	test   %eax,%eax
c0103f2d:	74 07                	je     c0103f36 <perm2str+0x36>
c0103f2f:	b8 77 00 00 00       	mov    $0x77,%eax
c0103f34:	eb 05                	jmp    c0103f3b <perm2str+0x3b>
c0103f36:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103f3b:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103f40:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103f47:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103f4c:	5d                   	pop    %ebp
c0103f4d:	c3                   	ret    

c0103f4e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103f4e:	55                   	push   %ebp
c0103f4f:	89 e5                	mov    %esp,%ebp
c0103f51:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103f54:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f57:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f5a:	72 0e                	jb     c0103f6a <get_pgtable_items+0x1c>
        return 0;
c0103f5c:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f61:	e9 9a 00 00 00       	jmp    c0104000 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103f66:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103f6a:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f6d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f70:	73 18                	jae    c0103f8a <get_pgtable_items+0x3c>
c0103f72:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f7c:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f7f:	01 d0                	add    %edx,%eax
c0103f81:	8b 00                	mov    (%eax),%eax
c0103f83:	83 e0 01             	and    $0x1,%eax
c0103f86:	85 c0                	test   %eax,%eax
c0103f88:	74 dc                	je     c0103f66 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103f8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f90:	73 69                	jae    c0103ffb <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103f92:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103f96:	74 08                	je     c0103fa0 <get_pgtable_items+0x52>
            *left_store = start;
c0103f98:	8b 45 18             	mov    0x18(%ebp),%eax
c0103f9b:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f9e:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103fa0:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fa3:	8d 50 01             	lea    0x1(%eax),%edx
c0103fa6:	89 55 10             	mov    %edx,0x10(%ebp)
c0103fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103fb0:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fb3:	01 d0                	add    %edx,%eax
c0103fb5:	8b 00                	mov    (%eax),%eax
c0103fb7:	83 e0 07             	and    $0x7,%eax
c0103fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103fbd:	eb 04                	jmp    c0103fc3 <get_pgtable_items+0x75>
            start ++;
c0103fbf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103fc3:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fc9:	73 1d                	jae    c0103fe8 <get_pgtable_items+0x9a>
c0103fcb:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103fd5:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fd8:	01 d0                	add    %edx,%eax
c0103fda:	8b 00                	mov    (%eax),%eax
c0103fdc:	83 e0 07             	and    $0x7,%eax
c0103fdf:	89 c2                	mov    %eax,%edx
c0103fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fe4:	39 c2                	cmp    %eax,%edx
c0103fe6:	74 d7                	je     c0103fbf <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103fe8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103fec:	74 08                	je     c0103ff6 <get_pgtable_items+0xa8>
            *right_store = start;
c0103fee:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103ff1:	8b 55 10             	mov    0x10(%ebp),%edx
c0103ff4:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ff9:	eb 05                	jmp    c0104000 <get_pgtable_items+0xb2>
    }
    return 0;
c0103ffb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104000:	c9                   	leave  
c0104001:	c3                   	ret    

c0104002 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104002:	55                   	push   %ebp
c0104003:	89 e5                	mov    %esp,%ebp
c0104005:	57                   	push   %edi
c0104006:	56                   	push   %esi
c0104007:	53                   	push   %ebx
c0104008:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010400b:	83 ec 0c             	sub    $0xc,%esp
c010400e:	68 f0 68 10 c0       	push   $0xc01068f0
c0104013:	e8 57 c2 ff ff       	call   c010026f <cprintf>
c0104018:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c010401b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104022:	e9 e5 00 00 00       	jmp    c010410c <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010402a:	83 ec 0c             	sub    $0xc,%esp
c010402d:	50                   	push   %eax
c010402e:	e8 cd fe ff ff       	call   c0103f00 <perm2str>
c0104033:	83 c4 10             	add    $0x10,%esp
c0104036:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104038:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010403b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010403e:	29 c2                	sub    %eax,%edx
c0104040:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104042:	c1 e0 16             	shl    $0x16,%eax
c0104045:	89 c3                	mov    %eax,%ebx
c0104047:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010404a:	c1 e0 16             	shl    $0x16,%eax
c010404d:	89 c1                	mov    %eax,%ecx
c010404f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104052:	c1 e0 16             	shl    $0x16,%eax
c0104055:	89 c2                	mov    %eax,%edx
c0104057:	8b 75 dc             	mov    -0x24(%ebp),%esi
c010405a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010405d:	29 c6                	sub    %eax,%esi
c010405f:	89 f0                	mov    %esi,%eax
c0104061:	83 ec 08             	sub    $0x8,%esp
c0104064:	57                   	push   %edi
c0104065:	53                   	push   %ebx
c0104066:	51                   	push   %ecx
c0104067:	52                   	push   %edx
c0104068:	50                   	push   %eax
c0104069:	68 21 69 10 c0       	push   $0xc0106921
c010406e:	e8 fc c1 ff ff       	call   c010026f <cprintf>
c0104073:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0104076:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104079:	c1 e0 0a             	shl    $0xa,%eax
c010407c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010407f:	eb 4f                	jmp    c01040d0 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104084:	83 ec 0c             	sub    $0xc,%esp
c0104087:	50                   	push   %eax
c0104088:	e8 73 fe ff ff       	call   c0103f00 <perm2str>
c010408d:	83 c4 10             	add    $0x10,%esp
c0104090:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104092:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104095:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104098:	29 c2                	sub    %eax,%edx
c010409a:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010409c:	c1 e0 0c             	shl    $0xc,%eax
c010409f:	89 c3                	mov    %eax,%ebx
c01040a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040a4:	c1 e0 0c             	shl    $0xc,%eax
c01040a7:	89 c1                	mov    %eax,%ecx
c01040a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040ac:	c1 e0 0c             	shl    $0xc,%eax
c01040af:	89 c2                	mov    %eax,%edx
c01040b1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c01040b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040b7:	29 c6                	sub    %eax,%esi
c01040b9:	89 f0                	mov    %esi,%eax
c01040bb:	83 ec 08             	sub    $0x8,%esp
c01040be:	57                   	push   %edi
c01040bf:	53                   	push   %ebx
c01040c0:	51                   	push   %ecx
c01040c1:	52                   	push   %edx
c01040c2:	50                   	push   %eax
c01040c3:	68 40 69 10 c0       	push   $0xc0106940
c01040c8:	e8 a2 c1 ff ff       	call   c010026f <cprintf>
c01040cd:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01040d0:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01040d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040db:	89 d3                	mov    %edx,%ebx
c01040dd:	c1 e3 0a             	shl    $0xa,%ebx
c01040e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01040e3:	89 d1                	mov    %edx,%ecx
c01040e5:	c1 e1 0a             	shl    $0xa,%ecx
c01040e8:	83 ec 08             	sub    $0x8,%esp
c01040eb:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01040ee:	52                   	push   %edx
c01040ef:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01040f2:	52                   	push   %edx
c01040f3:	56                   	push   %esi
c01040f4:	50                   	push   %eax
c01040f5:	53                   	push   %ebx
c01040f6:	51                   	push   %ecx
c01040f7:	e8 52 fe ff ff       	call   c0103f4e <get_pgtable_items>
c01040fc:	83 c4 20             	add    $0x20,%esp
c01040ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104102:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104106:	0f 85 75 ff ff ff    	jne    c0104081 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010410c:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104111:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104114:	83 ec 08             	sub    $0x8,%esp
c0104117:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010411a:	52                   	push   %edx
c010411b:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010411e:	52                   	push   %edx
c010411f:	51                   	push   %ecx
c0104120:	50                   	push   %eax
c0104121:	68 00 04 00 00       	push   $0x400
c0104126:	6a 00                	push   $0x0
c0104128:	e8 21 fe ff ff       	call   c0103f4e <get_pgtable_items>
c010412d:	83 c4 20             	add    $0x20,%esp
c0104130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104133:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104137:	0f 85 ea fe ff ff    	jne    c0104027 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010413d:	83 ec 0c             	sub    $0xc,%esp
c0104140:	68 64 69 10 c0       	push   $0xc0106964
c0104145:	e8 25 c1 ff ff       	call   c010026f <cprintf>
c010414a:	83 c4 10             	add    $0x10,%esp
}
c010414d:	90                   	nop
c010414e:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104151:	5b                   	pop    %ebx
c0104152:	5e                   	pop    %esi
c0104153:	5f                   	pop    %edi
c0104154:	5d                   	pop    %ebp
c0104155:	c3                   	ret    

c0104156 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104156:	55                   	push   %ebp
c0104157:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104159:	8b 45 08             	mov    0x8(%ebp),%eax
c010415c:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0104162:	29 d0                	sub    %edx,%eax
c0104164:	c1 f8 02             	sar    $0x2,%eax
c0104167:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010416d:	5d                   	pop    %ebp
c010416e:	c3                   	ret    

c010416f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010416f:	55                   	push   %ebp
c0104170:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104172:	ff 75 08             	pushl  0x8(%ebp)
c0104175:	e8 dc ff ff ff       	call   c0104156 <page2ppn>
c010417a:	83 c4 04             	add    $0x4,%esp
c010417d:	c1 e0 0c             	shl    $0xc,%eax
}
c0104180:	c9                   	leave  
c0104181:	c3                   	ret    

c0104182 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104182:	55                   	push   %ebp
c0104183:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104185:	8b 45 08             	mov    0x8(%ebp),%eax
c0104188:	8b 00                	mov    (%eax),%eax
}
c010418a:	5d                   	pop    %ebp
c010418b:	c3                   	ret    

c010418c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010418c:	55                   	push   %ebp
c010418d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010418f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104192:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104195:	89 10                	mov    %edx,(%eax)
}
c0104197:	90                   	nop
c0104198:	5d                   	pop    %ebp
c0104199:	c3                   	ret    

c010419a <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010419a:	55                   	push   %ebp
c010419b:	89 e5                	mov    %esp,%ebp
c010419d:	83 ec 10             	sub    $0x10,%esp
c01041a0:	c7 45 fc bc 89 11 c0 	movl   $0xc01189bc,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01041a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01041ad:	89 50 04             	mov    %edx,0x4(%eax)
c01041b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041b3:	8b 50 04             	mov    0x4(%eax),%edx
c01041b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041b9:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01041bb:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c01041c2:	00 00 00 
}
c01041c5:	90                   	nop
c01041c6:	c9                   	leave  
c01041c7:	c3                   	ret    

c01041c8 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01041c8:	55                   	push   %ebp
c01041c9:	89 e5                	mov    %esp,%ebp
c01041cb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01041ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01041d2:	75 16                	jne    c01041ea <default_init_memmap+0x22>
c01041d4:	68 98 69 10 c0       	push   $0xc0106998
c01041d9:	68 9e 69 10 c0       	push   $0xc010699e
c01041de:	6a 6d                	push   $0x6d
c01041e0:	68 b3 69 10 c0       	push   $0xc01069b3
c01041e5:	e8 eb c1 ff ff       	call   c01003d5 <__panic>
    struct Page *p = base;
c01041ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01041ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01041f0:	eb 6c                	jmp    c010425e <default_init_memmap+0x96>
        assert(PageReserved(p));
c01041f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041f5:	83 c0 04             	add    $0x4,%eax
c01041f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01041ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104205:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104208:	0f a3 10             	bt     %edx,(%eax)
c010420b:	19 c0                	sbb    %eax,%eax
c010420d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104210:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104214:	0f 95 c0             	setne  %al
c0104217:	0f b6 c0             	movzbl %al,%eax
c010421a:	85 c0                	test   %eax,%eax
c010421c:	75 16                	jne    c0104234 <default_init_memmap+0x6c>
c010421e:	68 c9 69 10 c0       	push   $0xc01069c9
c0104223:	68 9e 69 10 c0       	push   $0xc010699e
c0104228:	6a 70                	push   $0x70
c010422a:	68 b3 69 10 c0       	push   $0xc01069b3
c010422f:	e8 a1 c1 ff ff       	call   c01003d5 <__panic>
        p->flags = p->property = 0;     // set all following pages as "not the head page"
c0104234:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104237:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010423e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104241:	8b 50 08             	mov    0x8(%eax),%edx
c0104244:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104247:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010424a:	83 ec 08             	sub    $0x8,%esp
c010424d:	6a 00                	push   $0x0
c010424f:	ff 75 f4             	pushl  -0xc(%ebp)
c0104252:	e8 35 ff ff ff       	call   c010418c <set_page_ref>
c0104257:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010425a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010425e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104261:	89 d0                	mov    %edx,%eax
c0104263:	c1 e0 02             	shl    $0x2,%eax
c0104266:	01 d0                	add    %edx,%eax
c0104268:	c1 e0 02             	shl    $0x2,%eax
c010426b:	89 c2                	mov    %eax,%edx
c010426d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104270:	01 d0                	add    %edx,%eax
c0104272:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104275:	0f 85 77 ff ff ff    	jne    c01041f2 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;     // set all following pages as "not the head page"
        set_page_ref(p, 0);
    }
    base->property = n;
c010427b:	8b 45 08             	mov    0x8(%ebp),%eax
c010427e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104281:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);              // mark as the head page
c0104284:	8b 45 08             	mov    0x8(%ebp),%eax
c0104287:	83 c0 04             	add    $0x4,%eax
c010428a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104291:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104294:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104297:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010429a:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010429d:	8b 15 c4 89 11 c0    	mov    0xc01189c4,%edx
c01042a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042a6:	01 d0                	add    %edx,%eax
c01042a8:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
    list_add(&free_list, &(base->page_link));
c01042ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01042b0:	83 c0 0c             	add    $0xc,%eax
c01042b3:	c7 45 f0 bc 89 11 c0 	movl   $0xc01189bc,-0x10(%ebp)
c01042ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01042bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01042c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01042c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042cc:	8b 40 04             	mov    0x4(%eax),%eax
c01042cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042d2:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01042d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042d8:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01042db:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01042de:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042e1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01042e4:	89 10                	mov    %edx,(%eax)
c01042e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042e9:	8b 10                	mov    (%eax),%edx
c01042eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01042ee:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01042f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01042f7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01042fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104300:	89 10                	mov    %edx,(%eax)
}
c0104302:	90                   	nop
c0104303:	c9                   	leave  
c0104304:	c3                   	ret    

c0104305 <default_alloc_pages>:

// MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
c0104305:	55                   	push   %ebp
c0104306:	89 e5                	mov    %esp,%ebp
c0104308:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010430b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010430f:	75 16                	jne    c0104327 <default_alloc_pages+0x22>
c0104311:	68 98 69 10 c0       	push   $0xc0106998
c0104316:	68 9e 69 10 c0       	push   $0xc010699e
c010431b:	6a 7d                	push   $0x7d
c010431d:	68 b3 69 10 c0       	push   $0xc01069b3
c0104322:	e8 ae c0 ff ff       	call   c01003d5 <__panic>
    if (n > nr_free) {
c0104327:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c010432c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010432f:	73 0a                	jae    c010433b <default_alloc_pages+0x36>
        return NULL;
c0104331:	b8 00 00 00 00       	mov    $0x0,%eax
c0104336:	e9 48 01 00 00       	jmp    c0104483 <default_alloc_pages+0x17e>
    }
    struct Page *page = NULL;
c010433b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104342:	c7 45 f0 bc 89 11 c0 	movl   $0xc01189bc,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104349:	eb 1c                	jmp    c0104367 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c010434b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010434e:	83 e8 0c             	sub    $0xc,%eax
c0104351:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0104354:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104357:	8b 40 08             	mov    0x8(%eax),%eax
c010435a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010435d:	72 08                	jb     c0104367 <default_alloc_pages+0x62>
            page = p;
c010435f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104362:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104365:	eb 18                	jmp    c010437f <default_alloc_pages+0x7a>
c0104367:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010436a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010436d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104370:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104373:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104376:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c010437d:	75 cc                	jne    c010434b <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c010437f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104383:	0f 84 f7 00 00 00    	je     c0104480 <default_alloc_pages+0x17b>
c0104389:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010438c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010438f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104392:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
c0104395:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
c0104398:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439b:	83 c0 0c             	add    $0xc,%eax
c010439e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01043a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043a4:	8b 40 04             	mov    0x4(%eax),%eax
c01043a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01043aa:	8b 12                	mov    (%edx),%edx
c01043ac:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01043af:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01043b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01043b5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01043b8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01043bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043be:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01043c1:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01043c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043c6:	8b 40 08             	mov    0x8(%eax),%eax
c01043c9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01043cc:	0f 86 88 00 00 00    	jbe    c010445a <default_alloc_pages+0x155>
            struct Page *p = page + n;                      // split the allocated page
c01043d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01043d5:	89 d0                	mov    %edx,%eax
c01043d7:	c1 e0 02             	shl    $0x2,%eax
c01043da:	01 d0                	add    %edx,%eax
c01043dc:	c1 e0 02             	shl    $0x2,%eax
c01043df:	89 c2                	mov    %eax,%edx
c01043e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e4:	01 d0                	add    %edx,%eax
c01043e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
c01043e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ec:	8b 40 08             	mov    0x8(%eax),%eax
c01043ef:	2b 45 08             	sub    0x8(%ebp),%eax
c01043f2:	89 c2                	mov    %eax,%edx
c01043f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043f7:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
c01043fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043fd:	83 c0 04             	add    $0x4,%eax
c0104400:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104407:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010440a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010440d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104410:	0f ab 10             	bts    %edx,(%eax)
            // list_add(&free_list, &(p->page_link));
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
c0104413:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104416:	8d 50 0c             	lea    0xc(%eax),%edx
c0104419:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010441c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010441f:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104425:	8b 00                	mov    (%eax),%eax
c0104427:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010442a:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010442d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104433:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104436:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104439:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010443c:	89 10                	mov    %edx,(%eax)
c010443e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104441:	8b 10                	mov    (%eax),%edx
c0104443:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104446:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104449:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010444c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010444f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104452:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104455:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104458:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c010445a:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c010445f:	2b 45 08             	sub    0x8(%ebp),%eax
c0104462:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
        ClearPageProperty(page);    // mark as "not head page"
c0104467:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010446a:	83 c0 04             	add    $0x4,%eax
c010446d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104474:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104477:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010447a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010447d:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104483:	c9                   	leave  
c0104484:	c3                   	ret    

c0104485 <default_free_pages>:

// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
c0104485:	55                   	push   %ebp
c0104486:	89 e5                	mov    %esp,%ebp
c0104488:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010448e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104492:	75 19                	jne    c01044ad <default_free_pages+0x28>
c0104494:	68 98 69 10 c0       	push   $0xc0106998
c0104499:	68 9e 69 10 c0       	push   $0xc010699e
c010449e:	68 9d 00 00 00       	push   $0x9d
c01044a3:	68 b3 69 10 c0       	push   $0xc01069b3
c01044a8:	e8 28 bf ff ff       	call   c01003d5 <__panic>
    struct Page *p = base;
c01044ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01044b3:	e9 8f 00 00 00       	jmp    c0104547 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c01044b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044bb:	83 c0 04             	add    $0x4,%eax
c01044be:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c01044c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01044c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01044cb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01044ce:	0f a3 10             	bt     %edx,(%eax)
c01044d1:	19 c0                	sbb    %eax,%eax
c01044d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01044d6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01044da:	0f 95 c0             	setne  %al
c01044dd:	0f b6 c0             	movzbl %al,%eax
c01044e0:	85 c0                	test   %eax,%eax
c01044e2:	75 2c                	jne    c0104510 <default_free_pages+0x8b>
c01044e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e7:	83 c0 04             	add    $0x4,%eax
c01044ea:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c01044f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01044f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01044f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01044fa:	0f a3 10             	bt     %edx,(%eax)
c01044fd:	19 c0                	sbb    %eax,%eax
c01044ff:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
c0104502:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
c0104506:	0f 95 c0             	setne  %al
c0104509:	0f b6 c0             	movzbl %al,%eax
c010450c:	85 c0                	test   %eax,%eax
c010450e:	74 19                	je     c0104529 <default_free_pages+0xa4>
c0104510:	68 dc 69 10 c0       	push   $0xc01069dc
c0104515:	68 9e 69 10 c0       	push   $0xc010699e
c010451a:	68 a0 00 00 00       	push   $0xa0
c010451f:	68 b3 69 10 c0       	push   $0xc01069b3
c0104524:	e8 ac be ff ff       	call   c01003d5 <__panic>
        p->flags = 0;
c0104529:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
c0104533:	83 ec 08             	sub    $0x8,%esp
c0104536:	6a 00                	push   $0x0
c0104538:	ff 75 f4             	pushl  -0xc(%ebp)
c010453b:	e8 4c fc ff ff       	call   c010418c <set_page_ref>
c0104540:	83 c4 10             	add    $0x10,%esp
// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104543:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104547:	8b 55 0c             	mov    0xc(%ebp),%edx
c010454a:	89 d0                	mov    %edx,%eax
c010454c:	c1 e0 02             	shl    $0x2,%eax
c010454f:	01 d0                	add    %edx,%eax
c0104551:	c1 e0 02             	shl    $0x2,%eax
c0104554:	89 c2                	mov    %eax,%edx
c0104556:	8b 45 08             	mov    0x8(%ebp),%eax
c0104559:	01 d0                	add    %edx,%eax
c010455b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010455e:	0f 85 54 ff ff ff    	jne    c01044b8 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
c0104564:	8b 45 08             	mov    0x8(%ebp),%eax
c0104567:	8b 55 0c             	mov    0xc(%ebp),%edx
c010456a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010456d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104570:	83 c0 04             	add    $0x4,%eax
c0104573:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010457a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010457d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104580:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104583:	0f ab 10             	bts    %edx,(%eax)
c0104586:	c7 45 e8 bc 89 11 c0 	movl   $0xc01189bc,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010458d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104590:	8b 40 04             	mov    0x4(%eax),%eax

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
c0104593:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104596:	e9 1f 01 00 00       	jmp    c01046ba <default_free_pages+0x235>
        p = le2page(le, page_link);
c010459b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010459e:	83 e8 0c             	sub    $0xc,%eax
c01045a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045ad:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01045b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
c01045b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b6:	8b 50 08             	mov    0x8(%eax),%edx
c01045b9:	89 d0                	mov    %edx,%eax
c01045bb:	c1 e0 02             	shl    $0x2,%eax
c01045be:	01 d0                	add    %edx,%eax
c01045c0:	c1 e0 02             	shl    $0x2,%eax
c01045c3:	89 c2                	mov    %eax,%edx
c01045c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c8:	01 d0                	add    %edx,%eax
c01045ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01045cd:	75 67                	jne    c0104636 <default_free_pages+0x1b1>
            base->property += p->property;
c01045cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d2:	8b 50 08             	mov    0x8(%eax),%edx
c01045d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d8:	8b 40 08             	mov    0x8(%eax),%eax
c01045db:	01 c2                	add    %eax,%edx
c01045dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e0:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
c01045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
c01045ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f0:	83 c0 04             	add    $0x4,%eax
c01045f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01045fa:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01045fd:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104600:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104603:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104606:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104609:	83 c0 0c             	add    $0xc,%eax
c010460c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010460f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104612:	8b 40 04             	mov    0x4(%eax),%eax
c0104615:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104618:	8b 12                	mov    (%edx),%edx
c010461a:	89 55 a8             	mov    %edx,-0x58(%ebp)
c010461d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104620:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104623:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104626:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104629:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010462c:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010462f:	89 10                	mov    %edx,(%eax)
c0104631:	e9 84 00 00 00       	jmp    c01046ba <default_free_pages+0x235>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
c0104636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104639:	8b 50 08             	mov    0x8(%eax),%edx
c010463c:	89 d0                	mov    %edx,%eax
c010463e:	c1 e0 02             	shl    $0x2,%eax
c0104641:	01 d0                	add    %edx,%eax
c0104643:	c1 e0 02             	shl    $0x2,%eax
c0104646:	89 c2                	mov    %eax,%edx
c0104648:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010464b:	01 d0                	add    %edx,%eax
c010464d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104650:	75 68                	jne    c01046ba <default_free_pages+0x235>
            p->property += base->property;
c0104652:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104655:	8b 50 08             	mov    0x8(%eax),%edx
c0104658:	8b 45 08             	mov    0x8(%ebp),%eax
c010465b:	8b 40 08             	mov    0x8(%eax),%eax
c010465e:	01 c2                	add    %eax,%edx
c0104660:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104663:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
c0104666:	8b 45 08             	mov    0x8(%ebp),%eax
c0104669:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
c0104670:	8b 45 08             	mov    0x8(%ebp),%eax
c0104673:	83 c0 04             	add    $0x4,%eax
c0104676:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010467d:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104680:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104683:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104686:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010468c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010468f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104692:	83 c0 0c             	add    $0xc,%eax
c0104695:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104698:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010469b:	8b 40 04             	mov    0x4(%eax),%eax
c010469e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046a1:	8b 12                	mov    (%edx),%edx
c01046a3:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01046a6:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01046a9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01046ac:	8b 55 98             	mov    -0x68(%ebp),%edx
c01046af:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01046b2:	8b 45 98             	mov    -0x68(%ebp),%eax
c01046b5:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01046b8:	89 10                	mov    %edx,(%eax)
    base->property = n;
    SetPageProperty(base);

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c01046ba:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c01046c1:	0f 85 d4 fe ff ff    	jne    c010459b <default_free_pages+0x116>
c01046c7:	c7 45 d0 bc 89 11 c0 	movl   $0xc01189bc,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01046ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01046d1:	8b 40 04             	mov    0x4(%eax),%eax
            list_del(&(p->page_link));
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
c01046d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01046d7:	eb 20                	jmp    c01046f9 <default_free_pages+0x274>
        p = le2page(le, page_link);
c01046d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046dc:	83 e8 0c             	sub    $0xc,%eax
c01046df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
c01046e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e5:	3b 45 08             	cmp    0x8(%ebp),%eax
c01046e8:	77 1a                	ja     c0104704 <default_free_pages+0x27f>
c01046ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01046f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01046f3:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c01046f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
c01046f9:	81 7d f0 bc 89 11 c0 	cmpl   $0xc01189bc,-0x10(%ebp)
c0104700:	75 d7                	jne    c01046d9 <default_free_pages+0x254>
c0104702:	eb 01                	jmp    c0104705 <default_free_pages+0x280>
        p = le2page(le, page_link);
        if (p > base) {
            break;
c0104704:	90                   	nop
        }
        le = list_next(le);
    }
    
    nr_free += n;
c0104705:	8b 15 c4 89 11 c0    	mov    0xc01189c4,%edx
c010470b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010470e:	01 d0                	add    %edx,%eax
c0104710:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4
    // list_add(&free_list, &(base->page_link));
    list_add_before(le, &(base->page_link)); 
c0104715:	8b 45 08             	mov    0x8(%ebp),%eax
c0104718:	8d 50 0c             	lea    0xc(%eax),%edx
c010471b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010471e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104721:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104724:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104727:	8b 00                	mov    (%eax),%eax
c0104729:	8b 55 90             	mov    -0x70(%ebp),%edx
c010472c:	89 55 8c             	mov    %edx,-0x74(%ebp)
c010472f:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104732:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104735:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104738:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010473b:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010473e:	89 10                	mov    %edx,(%eax)
c0104740:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104743:	8b 10                	mov    (%eax),%edx
c0104745:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104748:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010474b:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010474e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104751:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104754:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104757:	8b 55 88             	mov    -0x78(%ebp),%edx
c010475a:	89 10                	mov    %edx,(%eax)
}
c010475c:	90                   	nop
c010475d:	c9                   	leave  
c010475e:	c3                   	ret    

c010475f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010475f:	55                   	push   %ebp
c0104760:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104762:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
}
c0104767:	5d                   	pop    %ebp
c0104768:	c3                   	ret    

c0104769 <basic_check>:

static void
basic_check(void) {
c0104769:	55                   	push   %ebp
c010476a:	89 e5                	mov    %esp,%ebp
c010476c:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010476f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104776:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104779:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010477c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010477f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104782:	83 ec 0c             	sub    $0xc,%esp
c0104785:	6a 01                	push   $0x1
c0104787:	e8 e2 e4 ff ff       	call   c0102c6e <alloc_pages>
c010478c:	83 c4 10             	add    $0x10,%esp
c010478f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104792:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104796:	75 19                	jne    c01047b1 <basic_check+0x48>
c0104798:	68 01 6a 10 c0       	push   $0xc0106a01
c010479d:	68 9e 69 10 c0       	push   $0xc010699e
c01047a2:	68 d5 00 00 00       	push   $0xd5
c01047a7:	68 b3 69 10 c0       	push   $0xc01069b3
c01047ac:	e8 24 bc ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01047b1:	83 ec 0c             	sub    $0xc,%esp
c01047b4:	6a 01                	push   $0x1
c01047b6:	e8 b3 e4 ff ff       	call   c0102c6e <alloc_pages>
c01047bb:	83 c4 10             	add    $0x10,%esp
c01047be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047c5:	75 19                	jne    c01047e0 <basic_check+0x77>
c01047c7:	68 1d 6a 10 c0       	push   $0xc0106a1d
c01047cc:	68 9e 69 10 c0       	push   $0xc010699e
c01047d1:	68 d6 00 00 00       	push   $0xd6
c01047d6:	68 b3 69 10 c0       	push   $0xc01069b3
c01047db:	e8 f5 bb ff ff       	call   c01003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01047e0:	83 ec 0c             	sub    $0xc,%esp
c01047e3:	6a 01                	push   $0x1
c01047e5:	e8 84 e4 ff ff       	call   c0102c6e <alloc_pages>
c01047ea:	83 c4 10             	add    $0x10,%esp
c01047ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047f4:	75 19                	jne    c010480f <basic_check+0xa6>
c01047f6:	68 39 6a 10 c0       	push   $0xc0106a39
c01047fb:	68 9e 69 10 c0       	push   $0xc010699e
c0104800:	68 d7 00 00 00       	push   $0xd7
c0104805:	68 b3 69 10 c0       	push   $0xc01069b3
c010480a:	e8 c6 bb ff ff       	call   c01003d5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010480f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104812:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104815:	74 10                	je     c0104827 <basic_check+0xbe>
c0104817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010481a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010481d:	74 08                	je     c0104827 <basic_check+0xbe>
c010481f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104822:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104825:	75 19                	jne    c0104840 <basic_check+0xd7>
c0104827:	68 58 6a 10 c0       	push   $0xc0106a58
c010482c:	68 9e 69 10 c0       	push   $0xc010699e
c0104831:	68 d9 00 00 00       	push   $0xd9
c0104836:	68 b3 69 10 c0       	push   $0xc01069b3
c010483b:	e8 95 bb ff ff       	call   c01003d5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104840:	83 ec 0c             	sub    $0xc,%esp
c0104843:	ff 75 ec             	pushl  -0x14(%ebp)
c0104846:	e8 37 f9 ff ff       	call   c0104182 <page_ref>
c010484b:	83 c4 10             	add    $0x10,%esp
c010484e:	85 c0                	test   %eax,%eax
c0104850:	75 24                	jne    c0104876 <basic_check+0x10d>
c0104852:	83 ec 0c             	sub    $0xc,%esp
c0104855:	ff 75 f0             	pushl  -0x10(%ebp)
c0104858:	e8 25 f9 ff ff       	call   c0104182 <page_ref>
c010485d:	83 c4 10             	add    $0x10,%esp
c0104860:	85 c0                	test   %eax,%eax
c0104862:	75 12                	jne    c0104876 <basic_check+0x10d>
c0104864:	83 ec 0c             	sub    $0xc,%esp
c0104867:	ff 75 f4             	pushl  -0xc(%ebp)
c010486a:	e8 13 f9 ff ff       	call   c0104182 <page_ref>
c010486f:	83 c4 10             	add    $0x10,%esp
c0104872:	85 c0                	test   %eax,%eax
c0104874:	74 19                	je     c010488f <basic_check+0x126>
c0104876:	68 7c 6a 10 c0       	push   $0xc0106a7c
c010487b:	68 9e 69 10 c0       	push   $0xc010699e
c0104880:	68 da 00 00 00       	push   $0xda
c0104885:	68 b3 69 10 c0       	push   $0xc01069b3
c010488a:	e8 46 bb ff ff       	call   c01003d5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010488f:	83 ec 0c             	sub    $0xc,%esp
c0104892:	ff 75 ec             	pushl  -0x14(%ebp)
c0104895:	e8 d5 f8 ff ff       	call   c010416f <page2pa>
c010489a:	83 c4 10             	add    $0x10,%esp
c010489d:	89 c2                	mov    %eax,%edx
c010489f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01048a4:	c1 e0 0c             	shl    $0xc,%eax
c01048a7:	39 c2                	cmp    %eax,%edx
c01048a9:	72 19                	jb     c01048c4 <basic_check+0x15b>
c01048ab:	68 b8 6a 10 c0       	push   $0xc0106ab8
c01048b0:	68 9e 69 10 c0       	push   $0xc010699e
c01048b5:	68 dc 00 00 00       	push   $0xdc
c01048ba:	68 b3 69 10 c0       	push   $0xc01069b3
c01048bf:	e8 11 bb ff ff       	call   c01003d5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01048c4:	83 ec 0c             	sub    $0xc,%esp
c01048c7:	ff 75 f0             	pushl  -0x10(%ebp)
c01048ca:	e8 a0 f8 ff ff       	call   c010416f <page2pa>
c01048cf:	83 c4 10             	add    $0x10,%esp
c01048d2:	89 c2                	mov    %eax,%edx
c01048d4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01048d9:	c1 e0 0c             	shl    $0xc,%eax
c01048dc:	39 c2                	cmp    %eax,%edx
c01048de:	72 19                	jb     c01048f9 <basic_check+0x190>
c01048e0:	68 d5 6a 10 c0       	push   $0xc0106ad5
c01048e5:	68 9e 69 10 c0       	push   $0xc010699e
c01048ea:	68 dd 00 00 00       	push   $0xdd
c01048ef:	68 b3 69 10 c0       	push   $0xc01069b3
c01048f4:	e8 dc ba ff ff       	call   c01003d5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01048f9:	83 ec 0c             	sub    $0xc,%esp
c01048fc:	ff 75 f4             	pushl  -0xc(%ebp)
c01048ff:	e8 6b f8 ff ff       	call   c010416f <page2pa>
c0104904:	83 c4 10             	add    $0x10,%esp
c0104907:	89 c2                	mov    %eax,%edx
c0104909:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010490e:	c1 e0 0c             	shl    $0xc,%eax
c0104911:	39 c2                	cmp    %eax,%edx
c0104913:	72 19                	jb     c010492e <basic_check+0x1c5>
c0104915:	68 f2 6a 10 c0       	push   $0xc0106af2
c010491a:	68 9e 69 10 c0       	push   $0xc010699e
c010491f:	68 de 00 00 00       	push   $0xde
c0104924:	68 b3 69 10 c0       	push   $0xc01069b3
c0104929:	e8 a7 ba ff ff       	call   c01003d5 <__panic>

    list_entry_t free_list_store = free_list;
c010492e:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104933:	8b 15 c0 89 11 c0    	mov    0xc01189c0,%edx
c0104939:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010493c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010493f:	c7 45 e4 bc 89 11 c0 	movl   $0xc01189bc,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010494c:	89 50 04             	mov    %edx,0x4(%eax)
c010494f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104952:	8b 50 04             	mov    0x4(%eax),%edx
c0104955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104958:	89 10                	mov    %edx,(%eax)
c010495a:	c7 45 d8 bc 89 11 c0 	movl   $0xc01189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104961:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104964:	8b 40 04             	mov    0x4(%eax),%eax
c0104967:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010496a:	0f 94 c0             	sete   %al
c010496d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104970:	85 c0                	test   %eax,%eax
c0104972:	75 19                	jne    c010498d <basic_check+0x224>
c0104974:	68 0f 6b 10 c0       	push   $0xc0106b0f
c0104979:	68 9e 69 10 c0       	push   $0xc010699e
c010497e:	68 e2 00 00 00       	push   $0xe2
c0104983:	68 b3 69 10 c0       	push   $0xc01069b3
c0104988:	e8 48 ba ff ff       	call   c01003d5 <__panic>

    unsigned int nr_free_store = nr_free;
c010498d:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104992:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104995:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c010499c:	00 00 00 

    assert(alloc_page() == NULL);
c010499f:	83 ec 0c             	sub    $0xc,%esp
c01049a2:	6a 01                	push   $0x1
c01049a4:	e8 c5 e2 ff ff       	call   c0102c6e <alloc_pages>
c01049a9:	83 c4 10             	add    $0x10,%esp
c01049ac:	85 c0                	test   %eax,%eax
c01049ae:	74 19                	je     c01049c9 <basic_check+0x260>
c01049b0:	68 26 6b 10 c0       	push   $0xc0106b26
c01049b5:	68 9e 69 10 c0       	push   $0xc010699e
c01049ba:	68 e7 00 00 00       	push   $0xe7
c01049bf:	68 b3 69 10 c0       	push   $0xc01069b3
c01049c4:	e8 0c ba ff ff       	call   c01003d5 <__panic>

    free_page(p0);
c01049c9:	83 ec 08             	sub    $0x8,%esp
c01049cc:	6a 01                	push   $0x1
c01049ce:	ff 75 ec             	pushl  -0x14(%ebp)
c01049d1:	e8 d6 e2 ff ff       	call   c0102cac <free_pages>
c01049d6:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01049d9:	83 ec 08             	sub    $0x8,%esp
c01049dc:	6a 01                	push   $0x1
c01049de:	ff 75 f0             	pushl  -0x10(%ebp)
c01049e1:	e8 c6 e2 ff ff       	call   c0102cac <free_pages>
c01049e6:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01049e9:	83 ec 08             	sub    $0x8,%esp
c01049ec:	6a 01                	push   $0x1
c01049ee:	ff 75 f4             	pushl  -0xc(%ebp)
c01049f1:	e8 b6 e2 ff ff       	call   c0102cac <free_pages>
c01049f6:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c01049f9:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c01049fe:	83 f8 03             	cmp    $0x3,%eax
c0104a01:	74 19                	je     c0104a1c <basic_check+0x2b3>
c0104a03:	68 3b 6b 10 c0       	push   $0xc0106b3b
c0104a08:	68 9e 69 10 c0       	push   $0xc010699e
c0104a0d:	68 ec 00 00 00       	push   $0xec
c0104a12:	68 b3 69 10 c0       	push   $0xc01069b3
c0104a17:	e8 b9 b9 ff ff       	call   c01003d5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104a1c:	83 ec 0c             	sub    $0xc,%esp
c0104a1f:	6a 01                	push   $0x1
c0104a21:	e8 48 e2 ff ff       	call   c0102c6e <alloc_pages>
c0104a26:	83 c4 10             	add    $0x10,%esp
c0104a29:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104a30:	75 19                	jne    c0104a4b <basic_check+0x2e2>
c0104a32:	68 01 6a 10 c0       	push   $0xc0106a01
c0104a37:	68 9e 69 10 c0       	push   $0xc010699e
c0104a3c:	68 ee 00 00 00       	push   $0xee
c0104a41:	68 b3 69 10 c0       	push   $0xc01069b3
c0104a46:	e8 8a b9 ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104a4b:	83 ec 0c             	sub    $0xc,%esp
c0104a4e:	6a 01                	push   $0x1
c0104a50:	e8 19 e2 ff ff       	call   c0102c6e <alloc_pages>
c0104a55:	83 c4 10             	add    $0x10,%esp
c0104a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a5f:	75 19                	jne    c0104a7a <basic_check+0x311>
c0104a61:	68 1d 6a 10 c0       	push   $0xc0106a1d
c0104a66:	68 9e 69 10 c0       	push   $0xc010699e
c0104a6b:	68 ef 00 00 00       	push   $0xef
c0104a70:	68 b3 69 10 c0       	push   $0xc01069b3
c0104a75:	e8 5b b9 ff ff       	call   c01003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104a7a:	83 ec 0c             	sub    $0xc,%esp
c0104a7d:	6a 01                	push   $0x1
c0104a7f:	e8 ea e1 ff ff       	call   c0102c6e <alloc_pages>
c0104a84:	83 c4 10             	add    $0x10,%esp
c0104a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a8e:	75 19                	jne    c0104aa9 <basic_check+0x340>
c0104a90:	68 39 6a 10 c0       	push   $0xc0106a39
c0104a95:	68 9e 69 10 c0       	push   $0xc010699e
c0104a9a:	68 f0 00 00 00       	push   $0xf0
c0104a9f:	68 b3 69 10 c0       	push   $0xc01069b3
c0104aa4:	e8 2c b9 ff ff       	call   c01003d5 <__panic>

    assert(alloc_page() == NULL);
c0104aa9:	83 ec 0c             	sub    $0xc,%esp
c0104aac:	6a 01                	push   $0x1
c0104aae:	e8 bb e1 ff ff       	call   c0102c6e <alloc_pages>
c0104ab3:	83 c4 10             	add    $0x10,%esp
c0104ab6:	85 c0                	test   %eax,%eax
c0104ab8:	74 19                	je     c0104ad3 <basic_check+0x36a>
c0104aba:	68 26 6b 10 c0       	push   $0xc0106b26
c0104abf:	68 9e 69 10 c0       	push   $0xc010699e
c0104ac4:	68 f2 00 00 00       	push   $0xf2
c0104ac9:	68 b3 69 10 c0       	push   $0xc01069b3
c0104ace:	e8 02 b9 ff ff       	call   c01003d5 <__panic>

    free_page(p0);
c0104ad3:	83 ec 08             	sub    $0x8,%esp
c0104ad6:	6a 01                	push   $0x1
c0104ad8:	ff 75 ec             	pushl  -0x14(%ebp)
c0104adb:	e8 cc e1 ff ff       	call   c0102cac <free_pages>
c0104ae0:	83 c4 10             	add    $0x10,%esp
c0104ae3:	c7 45 e8 bc 89 11 c0 	movl   $0xc01189bc,-0x18(%ebp)
c0104aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104aed:	8b 40 04             	mov    0x4(%eax),%eax
c0104af0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104af3:	0f 94 c0             	sete   %al
c0104af6:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104af9:	85 c0                	test   %eax,%eax
c0104afb:	74 19                	je     c0104b16 <basic_check+0x3ad>
c0104afd:	68 48 6b 10 c0       	push   $0xc0106b48
c0104b02:	68 9e 69 10 c0       	push   $0xc010699e
c0104b07:	68 f5 00 00 00       	push   $0xf5
c0104b0c:	68 b3 69 10 c0       	push   $0xc01069b3
c0104b11:	e8 bf b8 ff ff       	call   c01003d5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104b16:	83 ec 0c             	sub    $0xc,%esp
c0104b19:	6a 01                	push   $0x1
c0104b1b:	e8 4e e1 ff ff       	call   c0102c6e <alloc_pages>
c0104b20:	83 c4 10             	add    $0x10,%esp
c0104b23:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104b26:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b29:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104b2c:	74 19                	je     c0104b47 <basic_check+0x3de>
c0104b2e:	68 60 6b 10 c0       	push   $0xc0106b60
c0104b33:	68 9e 69 10 c0       	push   $0xc010699e
c0104b38:	68 f8 00 00 00       	push   $0xf8
c0104b3d:	68 b3 69 10 c0       	push   $0xc01069b3
c0104b42:	e8 8e b8 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104b47:	83 ec 0c             	sub    $0xc,%esp
c0104b4a:	6a 01                	push   $0x1
c0104b4c:	e8 1d e1 ff ff       	call   c0102c6e <alloc_pages>
c0104b51:	83 c4 10             	add    $0x10,%esp
c0104b54:	85 c0                	test   %eax,%eax
c0104b56:	74 19                	je     c0104b71 <basic_check+0x408>
c0104b58:	68 26 6b 10 c0       	push   $0xc0106b26
c0104b5d:	68 9e 69 10 c0       	push   $0xc010699e
c0104b62:	68 f9 00 00 00       	push   $0xf9
c0104b67:	68 b3 69 10 c0       	push   $0xc01069b3
c0104b6c:	e8 64 b8 ff ff       	call   c01003d5 <__panic>

    assert(nr_free == 0);
c0104b71:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104b76:	85 c0                	test   %eax,%eax
c0104b78:	74 19                	je     c0104b93 <basic_check+0x42a>
c0104b7a:	68 79 6b 10 c0       	push   $0xc0106b79
c0104b7f:	68 9e 69 10 c0       	push   $0xc010699e
c0104b84:	68 fb 00 00 00       	push   $0xfb
c0104b89:	68 b3 69 10 c0       	push   $0xc01069b3
c0104b8e:	e8 42 b8 ff ff       	call   c01003d5 <__panic>
    free_list = free_list_store;
c0104b93:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b99:	a3 bc 89 11 c0       	mov    %eax,0xc01189bc
c0104b9e:	89 15 c0 89 11 c0    	mov    %edx,0xc01189c0
    nr_free = nr_free_store;
c0104ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ba7:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    free_page(p);
c0104bac:	83 ec 08             	sub    $0x8,%esp
c0104baf:	6a 01                	push   $0x1
c0104bb1:	ff 75 dc             	pushl  -0x24(%ebp)
c0104bb4:	e8 f3 e0 ff ff       	call   c0102cac <free_pages>
c0104bb9:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104bbc:	83 ec 08             	sub    $0x8,%esp
c0104bbf:	6a 01                	push   $0x1
c0104bc1:	ff 75 f0             	pushl  -0x10(%ebp)
c0104bc4:	e8 e3 e0 ff ff       	call   c0102cac <free_pages>
c0104bc9:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104bcc:	83 ec 08             	sub    $0x8,%esp
c0104bcf:	6a 01                	push   $0x1
c0104bd1:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bd4:	e8 d3 e0 ff ff       	call   c0102cac <free_pages>
c0104bd9:	83 c4 10             	add    $0x10,%esp
}
c0104bdc:	90                   	nop
c0104bdd:	c9                   	leave  
c0104bde:	c3                   	ret    

c0104bdf <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104bdf:	55                   	push   %ebp
c0104be0:	89 e5                	mov    %esp,%ebp
c0104be2:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104be8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104bef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104bf6:	c7 45 ec bc 89 11 c0 	movl   $0xc01189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104bfd:	eb 60                	jmp    c0104c5f <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c02:	83 e8 0c             	sub    $0xc,%eax
c0104c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c0b:	83 c0 04             	add    $0x4,%eax
c0104c0e:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104c15:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c18:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104c1b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104c1e:	0f a3 10             	bt     %edx,(%eax)
c0104c21:	19 c0                	sbb    %eax,%eax
c0104c23:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104c26:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104c2a:	0f 95 c0             	setne  %al
c0104c2d:	0f b6 c0             	movzbl %al,%eax
c0104c30:	85 c0                	test   %eax,%eax
c0104c32:	75 19                	jne    c0104c4d <default_check+0x6e>
c0104c34:	68 86 6b 10 c0       	push   $0xc0106b86
c0104c39:	68 9e 69 10 c0       	push   $0xc010699e
c0104c3e:	68 0c 01 00 00       	push   $0x10c
c0104c43:	68 b3 69 10 c0       	push   $0xc01069b3
c0104c48:	e8 88 b7 ff ff       	call   c01003d5 <__panic>
        count ++, total += p->property;
c0104c4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c54:	8b 50 08             	mov    0x8(%eax),%edx
c0104c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c5a:	01 d0                	add    %edx,%eax
c0104c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c62:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c68:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104c6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c6e:	81 7d ec bc 89 11 c0 	cmpl   $0xc01189bc,-0x14(%ebp)
c0104c75:	75 88                	jne    c0104bff <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104c77:	e8 65 e0 ff ff       	call   c0102ce1 <nr_free_pages>
c0104c7c:	89 c2                	mov    %eax,%edx
c0104c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c81:	39 c2                	cmp    %eax,%edx
c0104c83:	74 19                	je     c0104c9e <default_check+0xbf>
c0104c85:	68 96 6b 10 c0       	push   $0xc0106b96
c0104c8a:	68 9e 69 10 c0       	push   $0xc010699e
c0104c8f:	68 0f 01 00 00       	push   $0x10f
c0104c94:	68 b3 69 10 c0       	push   $0xc01069b3
c0104c99:	e8 37 b7 ff ff       	call   c01003d5 <__panic>

    basic_check();
c0104c9e:	e8 c6 fa ff ff       	call   c0104769 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104ca3:	83 ec 0c             	sub    $0xc,%esp
c0104ca6:	6a 05                	push   $0x5
c0104ca8:	e8 c1 df ff ff       	call   c0102c6e <alloc_pages>
c0104cad:	83 c4 10             	add    $0x10,%esp
c0104cb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0104cb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104cb7:	75 19                	jne    c0104cd2 <default_check+0xf3>
c0104cb9:	68 af 6b 10 c0       	push   $0xc0106baf
c0104cbe:	68 9e 69 10 c0       	push   $0xc010699e
c0104cc3:	68 14 01 00 00       	push   $0x114
c0104cc8:	68 b3 69 10 c0       	push   $0xc01069b3
c0104ccd:	e8 03 b7 ff ff       	call   c01003d5 <__panic>
    assert(!PageProperty(p0));
c0104cd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104cd5:	83 c0 04             	add    $0x4,%eax
c0104cd8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104cdf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ce2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104ce5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104ce8:	0f a3 10             	bt     %edx,(%eax)
c0104ceb:	19 c0                	sbb    %eax,%eax
c0104ced:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104cf0:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104cf4:	0f 95 c0             	setne  %al
c0104cf7:	0f b6 c0             	movzbl %al,%eax
c0104cfa:	85 c0                	test   %eax,%eax
c0104cfc:	74 19                	je     c0104d17 <default_check+0x138>
c0104cfe:	68 ba 6b 10 c0       	push   $0xc0106bba
c0104d03:	68 9e 69 10 c0       	push   $0xc010699e
c0104d08:	68 15 01 00 00       	push   $0x115
c0104d0d:	68 b3 69 10 c0       	push   $0xc01069b3
c0104d12:	e8 be b6 ff ff       	call   c01003d5 <__panic>

    list_entry_t free_list_store = free_list;
c0104d17:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104d1c:	8b 15 c0 89 11 c0    	mov    0xc01189c0,%edx
c0104d22:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104d25:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104d28:	c7 45 d0 bc 89 11 c0 	movl   $0xc01189bc,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d32:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104d35:	89 50 04             	mov    %edx,0x4(%eax)
c0104d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d3b:	8b 50 04             	mov    0x4(%eax),%edx
c0104d3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d41:	89 10                	mov    %edx,(%eax)
c0104d43:	c7 45 d8 bc 89 11 c0 	movl   $0xc01189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104d4d:	8b 40 04             	mov    0x4(%eax),%eax
c0104d50:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104d53:	0f 94 c0             	sete   %al
c0104d56:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104d59:	85 c0                	test   %eax,%eax
c0104d5b:	75 19                	jne    c0104d76 <default_check+0x197>
c0104d5d:	68 0f 6b 10 c0       	push   $0xc0106b0f
c0104d62:	68 9e 69 10 c0       	push   $0xc010699e
c0104d67:	68 19 01 00 00       	push   $0x119
c0104d6c:	68 b3 69 10 c0       	push   $0xc01069b3
c0104d71:	e8 5f b6 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104d76:	83 ec 0c             	sub    $0xc,%esp
c0104d79:	6a 01                	push   $0x1
c0104d7b:	e8 ee de ff ff       	call   c0102c6e <alloc_pages>
c0104d80:	83 c4 10             	add    $0x10,%esp
c0104d83:	85 c0                	test   %eax,%eax
c0104d85:	74 19                	je     c0104da0 <default_check+0x1c1>
c0104d87:	68 26 6b 10 c0       	push   $0xc0106b26
c0104d8c:	68 9e 69 10 c0       	push   $0xc010699e
c0104d91:	68 1a 01 00 00       	push   $0x11a
c0104d96:	68 b3 69 10 c0       	push   $0xc01069b3
c0104d9b:	e8 35 b6 ff ff       	call   c01003d5 <__panic>

    unsigned int nr_free_store = nr_free;
c0104da0:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104da5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104da8:	c7 05 c4 89 11 c0 00 	movl   $0x0,0xc01189c4
c0104daf:	00 00 00 

    free_pages(p0 + 2, 3);
c0104db2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104db5:	83 c0 28             	add    $0x28,%eax
c0104db8:	83 ec 08             	sub    $0x8,%esp
c0104dbb:	6a 03                	push   $0x3
c0104dbd:	50                   	push   %eax
c0104dbe:	e8 e9 de ff ff       	call   c0102cac <free_pages>
c0104dc3:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104dc6:	83 ec 0c             	sub    $0xc,%esp
c0104dc9:	6a 04                	push   $0x4
c0104dcb:	e8 9e de ff ff       	call   c0102c6e <alloc_pages>
c0104dd0:	83 c4 10             	add    $0x10,%esp
c0104dd3:	85 c0                	test   %eax,%eax
c0104dd5:	74 19                	je     c0104df0 <default_check+0x211>
c0104dd7:	68 cc 6b 10 c0       	push   $0xc0106bcc
c0104ddc:	68 9e 69 10 c0       	push   $0xc010699e
c0104de1:	68 20 01 00 00       	push   $0x120
c0104de6:	68 b3 69 10 c0       	push   $0xc01069b3
c0104deb:	e8 e5 b5 ff ff       	call   c01003d5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104df0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104df3:	83 c0 28             	add    $0x28,%eax
c0104df6:	83 c0 04             	add    $0x4,%eax
c0104df9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104e00:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e03:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104e06:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e09:	0f a3 10             	bt     %edx,(%eax)
c0104e0c:	19 c0                	sbb    %eax,%eax
c0104e0e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104e11:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104e15:	0f 95 c0             	setne  %al
c0104e18:	0f b6 c0             	movzbl %al,%eax
c0104e1b:	85 c0                	test   %eax,%eax
c0104e1d:	74 0e                	je     c0104e2d <default_check+0x24e>
c0104e1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e22:	83 c0 28             	add    $0x28,%eax
c0104e25:	8b 40 08             	mov    0x8(%eax),%eax
c0104e28:	83 f8 03             	cmp    $0x3,%eax
c0104e2b:	74 19                	je     c0104e46 <default_check+0x267>
c0104e2d:	68 e4 6b 10 c0       	push   $0xc0106be4
c0104e32:	68 9e 69 10 c0       	push   $0xc010699e
c0104e37:	68 21 01 00 00       	push   $0x121
c0104e3c:	68 b3 69 10 c0       	push   $0xc01069b3
c0104e41:	e8 8f b5 ff ff       	call   c01003d5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104e46:	83 ec 0c             	sub    $0xc,%esp
c0104e49:	6a 03                	push   $0x3
c0104e4b:	e8 1e de ff ff       	call   c0102c6e <alloc_pages>
c0104e50:	83 c4 10             	add    $0x10,%esp
c0104e53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104e56:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104e5a:	75 19                	jne    c0104e75 <default_check+0x296>
c0104e5c:	68 10 6c 10 c0       	push   $0xc0106c10
c0104e61:	68 9e 69 10 c0       	push   $0xc010699e
c0104e66:	68 22 01 00 00       	push   $0x122
c0104e6b:	68 b3 69 10 c0       	push   $0xc01069b3
c0104e70:	e8 60 b5 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0104e75:	83 ec 0c             	sub    $0xc,%esp
c0104e78:	6a 01                	push   $0x1
c0104e7a:	e8 ef dd ff ff       	call   c0102c6e <alloc_pages>
c0104e7f:	83 c4 10             	add    $0x10,%esp
c0104e82:	85 c0                	test   %eax,%eax
c0104e84:	74 19                	je     c0104e9f <default_check+0x2c0>
c0104e86:	68 26 6b 10 c0       	push   $0xc0106b26
c0104e8b:	68 9e 69 10 c0       	push   $0xc010699e
c0104e90:	68 23 01 00 00       	push   $0x123
c0104e95:	68 b3 69 10 c0       	push   $0xc01069b3
c0104e9a:	e8 36 b5 ff ff       	call   c01003d5 <__panic>
    assert(p0 + 2 == p1);
c0104e9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ea2:	83 c0 28             	add    $0x28,%eax
c0104ea5:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104ea8:	74 19                	je     c0104ec3 <default_check+0x2e4>
c0104eaa:	68 2e 6c 10 c0       	push   $0xc0106c2e
c0104eaf:	68 9e 69 10 c0       	push   $0xc010699e
c0104eb4:	68 24 01 00 00       	push   $0x124
c0104eb9:	68 b3 69 10 c0       	push   $0xc01069b3
c0104ebe:	e8 12 b5 ff ff       	call   c01003d5 <__panic>

    p2 = p0 + 1;
c0104ec3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ec6:	83 c0 14             	add    $0x14,%eax
c0104ec9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104ecc:	83 ec 08             	sub    $0x8,%esp
c0104ecf:	6a 01                	push   $0x1
c0104ed1:	ff 75 dc             	pushl  -0x24(%ebp)
c0104ed4:	e8 d3 dd ff ff       	call   c0102cac <free_pages>
c0104ed9:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104edc:	83 ec 08             	sub    $0x8,%esp
c0104edf:	6a 03                	push   $0x3
c0104ee1:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104ee4:	e8 c3 dd ff ff       	call   c0102cac <free_pages>
c0104ee9:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104eec:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104eef:	83 c0 04             	add    $0x4,%eax
c0104ef2:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104ef9:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104efc:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104eff:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104f02:	0f a3 10             	bt     %edx,(%eax)
c0104f05:	19 c0                	sbb    %eax,%eax
c0104f07:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104f0a:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104f0e:	0f 95 c0             	setne  %al
c0104f11:	0f b6 c0             	movzbl %al,%eax
c0104f14:	85 c0                	test   %eax,%eax
c0104f16:	74 0b                	je     c0104f23 <default_check+0x344>
c0104f18:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f1b:	8b 40 08             	mov    0x8(%eax),%eax
c0104f1e:	83 f8 01             	cmp    $0x1,%eax
c0104f21:	74 19                	je     c0104f3c <default_check+0x35d>
c0104f23:	68 3c 6c 10 c0       	push   $0xc0106c3c
c0104f28:	68 9e 69 10 c0       	push   $0xc010699e
c0104f2d:	68 29 01 00 00       	push   $0x129
c0104f32:	68 b3 69 10 c0       	push   $0xc01069b3
c0104f37:	e8 99 b4 ff ff       	call   c01003d5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104f3c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f3f:	83 c0 04             	add    $0x4,%eax
c0104f42:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104f49:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f4c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104f4f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104f52:	0f a3 10             	bt     %edx,(%eax)
c0104f55:	19 c0                	sbb    %eax,%eax
c0104f57:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104f5a:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104f5e:	0f 95 c0             	setne  %al
c0104f61:	0f b6 c0             	movzbl %al,%eax
c0104f64:	85 c0                	test   %eax,%eax
c0104f66:	74 0b                	je     c0104f73 <default_check+0x394>
c0104f68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f6b:	8b 40 08             	mov    0x8(%eax),%eax
c0104f6e:	83 f8 03             	cmp    $0x3,%eax
c0104f71:	74 19                	je     c0104f8c <default_check+0x3ad>
c0104f73:	68 64 6c 10 c0       	push   $0xc0106c64
c0104f78:	68 9e 69 10 c0       	push   $0xc010699e
c0104f7d:	68 2a 01 00 00       	push   $0x12a
c0104f82:	68 b3 69 10 c0       	push   $0xc01069b3
c0104f87:	e8 49 b4 ff ff       	call   c01003d5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104f8c:	83 ec 0c             	sub    $0xc,%esp
c0104f8f:	6a 01                	push   $0x1
c0104f91:	e8 d8 dc ff ff       	call   c0102c6e <alloc_pages>
c0104f96:	83 c4 10             	add    $0x10,%esp
c0104f99:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104f9f:	83 e8 14             	sub    $0x14,%eax
c0104fa2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104fa5:	74 19                	je     c0104fc0 <default_check+0x3e1>
c0104fa7:	68 8a 6c 10 c0       	push   $0xc0106c8a
c0104fac:	68 9e 69 10 c0       	push   $0xc010699e
c0104fb1:	68 2c 01 00 00       	push   $0x12c
c0104fb6:	68 b3 69 10 c0       	push   $0xc01069b3
c0104fbb:	e8 15 b4 ff ff       	call   c01003d5 <__panic>
    free_page(p0);
c0104fc0:	83 ec 08             	sub    $0x8,%esp
c0104fc3:	6a 01                	push   $0x1
c0104fc5:	ff 75 dc             	pushl  -0x24(%ebp)
c0104fc8:	e8 df dc ff ff       	call   c0102cac <free_pages>
c0104fcd:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104fd0:	83 ec 0c             	sub    $0xc,%esp
c0104fd3:	6a 02                	push   $0x2
c0104fd5:	e8 94 dc ff ff       	call   c0102c6e <alloc_pages>
c0104fda:	83 c4 10             	add    $0x10,%esp
c0104fdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104fe0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104fe3:	83 c0 14             	add    $0x14,%eax
c0104fe6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104fe9:	74 19                	je     c0105004 <default_check+0x425>
c0104feb:	68 a8 6c 10 c0       	push   $0xc0106ca8
c0104ff0:	68 9e 69 10 c0       	push   $0xc010699e
c0104ff5:	68 2e 01 00 00       	push   $0x12e
c0104ffa:	68 b3 69 10 c0       	push   $0xc01069b3
c0104fff:	e8 d1 b3 ff ff       	call   c01003d5 <__panic>

    free_pages(p0, 2);
c0105004:	83 ec 08             	sub    $0x8,%esp
c0105007:	6a 02                	push   $0x2
c0105009:	ff 75 dc             	pushl  -0x24(%ebp)
c010500c:	e8 9b dc ff ff       	call   c0102cac <free_pages>
c0105011:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105014:	83 ec 08             	sub    $0x8,%esp
c0105017:	6a 01                	push   $0x1
c0105019:	ff 75 c0             	pushl  -0x40(%ebp)
c010501c:	e8 8b dc ff ff       	call   c0102cac <free_pages>
c0105021:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0105024:	83 ec 0c             	sub    $0xc,%esp
c0105027:	6a 05                	push   $0x5
c0105029:	e8 40 dc ff ff       	call   c0102c6e <alloc_pages>
c010502e:	83 c4 10             	add    $0x10,%esp
c0105031:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105034:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105038:	75 19                	jne    c0105053 <default_check+0x474>
c010503a:	68 c8 6c 10 c0       	push   $0xc0106cc8
c010503f:	68 9e 69 10 c0       	push   $0xc010699e
c0105044:	68 33 01 00 00       	push   $0x133
c0105049:	68 b3 69 10 c0       	push   $0xc01069b3
c010504e:	e8 82 b3 ff ff       	call   c01003d5 <__panic>
    assert(alloc_page() == NULL);
c0105053:	83 ec 0c             	sub    $0xc,%esp
c0105056:	6a 01                	push   $0x1
c0105058:	e8 11 dc ff ff       	call   c0102c6e <alloc_pages>
c010505d:	83 c4 10             	add    $0x10,%esp
c0105060:	85 c0                	test   %eax,%eax
c0105062:	74 19                	je     c010507d <default_check+0x49e>
c0105064:	68 26 6b 10 c0       	push   $0xc0106b26
c0105069:	68 9e 69 10 c0       	push   $0xc010699e
c010506e:	68 34 01 00 00       	push   $0x134
c0105073:	68 b3 69 10 c0       	push   $0xc01069b3
c0105078:	e8 58 b3 ff ff       	call   c01003d5 <__panic>

    assert(nr_free == 0);
c010507d:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0105082:	85 c0                	test   %eax,%eax
c0105084:	74 19                	je     c010509f <default_check+0x4c0>
c0105086:	68 79 6b 10 c0       	push   $0xc0106b79
c010508b:	68 9e 69 10 c0       	push   $0xc010699e
c0105090:	68 36 01 00 00       	push   $0x136
c0105095:	68 b3 69 10 c0       	push   $0xc01069b3
c010509a:	e8 36 b3 ff ff       	call   c01003d5 <__panic>
    nr_free = nr_free_store;
c010509f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01050a2:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    free_list = free_list_store;
c01050a7:	8b 45 80             	mov    -0x80(%ebp),%eax
c01050aa:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01050ad:	a3 bc 89 11 c0       	mov    %eax,0xc01189bc
c01050b2:	89 15 c0 89 11 c0    	mov    %edx,0xc01189c0
    free_pages(p0, 5);
c01050b8:	83 ec 08             	sub    $0x8,%esp
c01050bb:	6a 05                	push   $0x5
c01050bd:	ff 75 dc             	pushl  -0x24(%ebp)
c01050c0:	e8 e7 db ff ff       	call   c0102cac <free_pages>
c01050c5:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01050c8:	c7 45 ec bc 89 11 c0 	movl   $0xc01189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01050cf:	eb 1d                	jmp    c01050ee <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c01050d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050d4:	83 e8 0c             	sub    $0xc,%eax
c01050d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c01050da:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01050de:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01050e1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01050e4:	8b 40 08             	mov    0x8(%eax),%eax
c01050e7:	29 c2                	sub    %eax,%edx
c01050e9:	89 d0                	mov    %edx,%eax
c01050eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01050f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01050f7:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01050fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050fd:	81 7d ec bc 89 11 c0 	cmpl   $0xc01189bc,-0x14(%ebp)
c0105104:	75 cb                	jne    c01050d1 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0105106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010510a:	74 19                	je     c0105125 <default_check+0x546>
c010510c:	68 e6 6c 10 c0       	push   $0xc0106ce6
c0105111:	68 9e 69 10 c0       	push   $0xc010699e
c0105116:	68 41 01 00 00       	push   $0x141
c010511b:	68 b3 69 10 c0       	push   $0xc01069b3
c0105120:	e8 b0 b2 ff ff       	call   c01003d5 <__panic>
    assert(total == 0);
c0105125:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105129:	74 19                	je     c0105144 <default_check+0x565>
c010512b:	68 f1 6c 10 c0       	push   $0xc0106cf1
c0105130:	68 9e 69 10 c0       	push   $0xc010699e
c0105135:	68 42 01 00 00       	push   $0x142
c010513a:	68 b3 69 10 c0       	push   $0xc01069b3
c010513f:	e8 91 b2 ff ff       	call   c01003d5 <__panic>
}
c0105144:	90                   	nop
c0105145:	c9                   	leave  
c0105146:	c3                   	ret    

c0105147 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105147:	55                   	push   %ebp
c0105148:	89 e5                	mov    %esp,%ebp
c010514a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010514d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105154:	eb 04                	jmp    c010515a <strlen+0x13>
        cnt ++;
c0105156:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010515a:	8b 45 08             	mov    0x8(%ebp),%eax
c010515d:	8d 50 01             	lea    0x1(%eax),%edx
c0105160:	89 55 08             	mov    %edx,0x8(%ebp)
c0105163:	0f b6 00             	movzbl (%eax),%eax
c0105166:	84 c0                	test   %al,%al
c0105168:	75 ec                	jne    c0105156 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010516a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010516d:	c9                   	leave  
c010516e:	c3                   	ret    

c010516f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010516f:	55                   	push   %ebp
c0105170:	89 e5                	mov    %esp,%ebp
c0105172:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010517c:	eb 04                	jmp    c0105182 <strnlen+0x13>
        cnt ++;
c010517e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105182:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105185:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105188:	73 10                	jae    c010519a <strnlen+0x2b>
c010518a:	8b 45 08             	mov    0x8(%ebp),%eax
c010518d:	8d 50 01             	lea    0x1(%eax),%edx
c0105190:	89 55 08             	mov    %edx,0x8(%ebp)
c0105193:	0f b6 00             	movzbl (%eax),%eax
c0105196:	84 c0                	test   %al,%al
c0105198:	75 e4                	jne    c010517e <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010519a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010519d:	c9                   	leave  
c010519e:	c3                   	ret    

c010519f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010519f:	55                   	push   %ebp
c01051a0:	89 e5                	mov    %esp,%ebp
c01051a2:	57                   	push   %edi
c01051a3:	56                   	push   %esi
c01051a4:	83 ec 20             	sub    $0x20,%esp
c01051a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01051aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01051b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01051b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051b9:	89 d1                	mov    %edx,%ecx
c01051bb:	89 c2                	mov    %eax,%edx
c01051bd:	89 ce                	mov    %ecx,%esi
c01051bf:	89 d7                	mov    %edx,%edi
c01051c1:	ac                   	lods   %ds:(%esi),%al
c01051c2:	aa                   	stos   %al,%es:(%edi)
c01051c3:	84 c0                	test   %al,%al
c01051c5:	75 fa                	jne    c01051c1 <strcpy+0x22>
c01051c7:	89 fa                	mov    %edi,%edx
c01051c9:	89 f1                	mov    %esi,%ecx
c01051cb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01051ce:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01051d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01051d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01051d7:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01051d8:	83 c4 20             	add    $0x20,%esp
c01051db:	5e                   	pop    %esi
c01051dc:	5f                   	pop    %edi
c01051dd:	5d                   	pop    %ebp
c01051de:	c3                   	ret    

c01051df <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01051df:	55                   	push   %ebp
c01051e0:	89 e5                	mov    %esp,%ebp
c01051e2:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01051e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01051eb:	eb 21                	jmp    c010520e <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01051ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051f0:	0f b6 10             	movzbl (%eax),%edx
c01051f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051f6:	88 10                	mov    %dl,(%eax)
c01051f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051fb:	0f b6 00             	movzbl (%eax),%eax
c01051fe:	84 c0                	test   %al,%al
c0105200:	74 04                	je     c0105206 <strncpy+0x27>
            src ++;
c0105202:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105206:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010520a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010520e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105212:	75 d9                	jne    c01051ed <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105214:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105217:	c9                   	leave  
c0105218:	c3                   	ret    

c0105219 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105219:	55                   	push   %ebp
c010521a:	89 e5                	mov    %esp,%ebp
c010521c:	57                   	push   %edi
c010521d:	56                   	push   %esi
c010521e:	83 ec 20             	sub    $0x20,%esp
c0105221:	8b 45 08             	mov    0x8(%ebp),%eax
c0105224:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105227:	8b 45 0c             	mov    0xc(%ebp),%eax
c010522a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010522d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105230:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105233:	89 d1                	mov    %edx,%ecx
c0105235:	89 c2                	mov    %eax,%edx
c0105237:	89 ce                	mov    %ecx,%esi
c0105239:	89 d7                	mov    %edx,%edi
c010523b:	ac                   	lods   %ds:(%esi),%al
c010523c:	ae                   	scas   %es:(%edi),%al
c010523d:	75 08                	jne    c0105247 <strcmp+0x2e>
c010523f:	84 c0                	test   %al,%al
c0105241:	75 f8                	jne    c010523b <strcmp+0x22>
c0105243:	31 c0                	xor    %eax,%eax
c0105245:	eb 04                	jmp    c010524b <strcmp+0x32>
c0105247:	19 c0                	sbb    %eax,%eax
c0105249:	0c 01                	or     $0x1,%al
c010524b:	89 fa                	mov    %edi,%edx
c010524d:	89 f1                	mov    %esi,%ecx
c010524f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105252:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105255:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105258:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c010525b:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010525c:	83 c4 20             	add    $0x20,%esp
c010525f:	5e                   	pop    %esi
c0105260:	5f                   	pop    %edi
c0105261:	5d                   	pop    %ebp
c0105262:	c3                   	ret    

c0105263 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105263:	55                   	push   %ebp
c0105264:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105266:	eb 0c                	jmp    c0105274 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105268:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010526c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105270:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105274:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105278:	74 1a                	je     c0105294 <strncmp+0x31>
c010527a:	8b 45 08             	mov    0x8(%ebp),%eax
c010527d:	0f b6 00             	movzbl (%eax),%eax
c0105280:	84 c0                	test   %al,%al
c0105282:	74 10                	je     c0105294 <strncmp+0x31>
c0105284:	8b 45 08             	mov    0x8(%ebp),%eax
c0105287:	0f b6 10             	movzbl (%eax),%edx
c010528a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010528d:	0f b6 00             	movzbl (%eax),%eax
c0105290:	38 c2                	cmp    %al,%dl
c0105292:	74 d4                	je     c0105268 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105294:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105298:	74 18                	je     c01052b2 <strncmp+0x4f>
c010529a:	8b 45 08             	mov    0x8(%ebp),%eax
c010529d:	0f b6 00             	movzbl (%eax),%eax
c01052a0:	0f b6 d0             	movzbl %al,%edx
c01052a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052a6:	0f b6 00             	movzbl (%eax),%eax
c01052a9:	0f b6 c0             	movzbl %al,%eax
c01052ac:	29 c2                	sub    %eax,%edx
c01052ae:	89 d0                	mov    %edx,%eax
c01052b0:	eb 05                	jmp    c01052b7 <strncmp+0x54>
c01052b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052b7:	5d                   	pop    %ebp
c01052b8:	c3                   	ret    

c01052b9 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01052b9:	55                   	push   %ebp
c01052ba:	89 e5                	mov    %esp,%ebp
c01052bc:	83 ec 04             	sub    $0x4,%esp
c01052bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052c2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01052c5:	eb 14                	jmp    c01052db <strchr+0x22>
        if (*s == c) {
c01052c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ca:	0f b6 00             	movzbl (%eax),%eax
c01052cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01052d0:	75 05                	jne    c01052d7 <strchr+0x1e>
            return (char *)s;
c01052d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01052d5:	eb 13                	jmp    c01052ea <strchr+0x31>
        }
        s ++;
c01052d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01052db:	8b 45 08             	mov    0x8(%ebp),%eax
c01052de:	0f b6 00             	movzbl (%eax),%eax
c01052e1:	84 c0                	test   %al,%al
c01052e3:	75 e2                	jne    c01052c7 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c01052e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052ea:	c9                   	leave  
c01052eb:	c3                   	ret    

c01052ec <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01052ec:	55                   	push   %ebp
c01052ed:	89 e5                	mov    %esp,%ebp
c01052ef:	83 ec 04             	sub    $0x4,%esp
c01052f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052f5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01052f8:	eb 0f                	jmp    c0105309 <strfind+0x1d>
        if (*s == c) {
c01052fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01052fd:	0f b6 00             	movzbl (%eax),%eax
c0105300:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105303:	74 10                	je     c0105315 <strfind+0x29>
            break;
        }
        s ++;
c0105305:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105309:	8b 45 08             	mov    0x8(%ebp),%eax
c010530c:	0f b6 00             	movzbl (%eax),%eax
c010530f:	84 c0                	test   %al,%al
c0105311:	75 e7                	jne    c01052fa <strfind+0xe>
c0105313:	eb 01                	jmp    c0105316 <strfind+0x2a>
        if (*s == c) {
            break;
c0105315:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105316:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105319:	c9                   	leave  
c010531a:	c3                   	ret    

c010531b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010531b:	55                   	push   %ebp
c010531c:	89 e5                	mov    %esp,%ebp
c010531e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010532f:	eb 04                	jmp    c0105335 <strtol+0x1a>
        s ++;
c0105331:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105335:	8b 45 08             	mov    0x8(%ebp),%eax
c0105338:	0f b6 00             	movzbl (%eax),%eax
c010533b:	3c 20                	cmp    $0x20,%al
c010533d:	74 f2                	je     c0105331 <strtol+0x16>
c010533f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105342:	0f b6 00             	movzbl (%eax),%eax
c0105345:	3c 09                	cmp    $0x9,%al
c0105347:	74 e8                	je     c0105331 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105349:	8b 45 08             	mov    0x8(%ebp),%eax
c010534c:	0f b6 00             	movzbl (%eax),%eax
c010534f:	3c 2b                	cmp    $0x2b,%al
c0105351:	75 06                	jne    c0105359 <strtol+0x3e>
        s ++;
c0105353:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105357:	eb 15                	jmp    c010536e <strtol+0x53>
    }
    else if (*s == '-') {
c0105359:	8b 45 08             	mov    0x8(%ebp),%eax
c010535c:	0f b6 00             	movzbl (%eax),%eax
c010535f:	3c 2d                	cmp    $0x2d,%al
c0105361:	75 0b                	jne    c010536e <strtol+0x53>
        s ++, neg = 1;
c0105363:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105367:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010536e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105372:	74 06                	je     c010537a <strtol+0x5f>
c0105374:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105378:	75 24                	jne    c010539e <strtol+0x83>
c010537a:	8b 45 08             	mov    0x8(%ebp),%eax
c010537d:	0f b6 00             	movzbl (%eax),%eax
c0105380:	3c 30                	cmp    $0x30,%al
c0105382:	75 1a                	jne    c010539e <strtol+0x83>
c0105384:	8b 45 08             	mov    0x8(%ebp),%eax
c0105387:	83 c0 01             	add    $0x1,%eax
c010538a:	0f b6 00             	movzbl (%eax),%eax
c010538d:	3c 78                	cmp    $0x78,%al
c010538f:	75 0d                	jne    c010539e <strtol+0x83>
        s += 2, base = 16;
c0105391:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105395:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010539c:	eb 2a                	jmp    c01053c8 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010539e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053a2:	75 17                	jne    c01053bb <strtol+0xa0>
c01053a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a7:	0f b6 00             	movzbl (%eax),%eax
c01053aa:	3c 30                	cmp    $0x30,%al
c01053ac:	75 0d                	jne    c01053bb <strtol+0xa0>
        s ++, base = 8;
c01053ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01053b2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01053b9:	eb 0d                	jmp    c01053c8 <strtol+0xad>
    }
    else if (base == 0) {
c01053bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053bf:	75 07                	jne    c01053c8 <strtol+0xad>
        base = 10;
c01053c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01053c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053cb:	0f b6 00             	movzbl (%eax),%eax
c01053ce:	3c 2f                	cmp    $0x2f,%al
c01053d0:	7e 1b                	jle    c01053ed <strtol+0xd2>
c01053d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d5:	0f b6 00             	movzbl (%eax),%eax
c01053d8:	3c 39                	cmp    $0x39,%al
c01053da:	7f 11                	jg     c01053ed <strtol+0xd2>
            dig = *s - '0';
c01053dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01053df:	0f b6 00             	movzbl (%eax),%eax
c01053e2:	0f be c0             	movsbl %al,%eax
c01053e5:	83 e8 30             	sub    $0x30,%eax
c01053e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053eb:	eb 48                	jmp    c0105435 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01053ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f0:	0f b6 00             	movzbl (%eax),%eax
c01053f3:	3c 60                	cmp    $0x60,%al
c01053f5:	7e 1b                	jle    c0105412 <strtol+0xf7>
c01053f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01053fa:	0f b6 00             	movzbl (%eax),%eax
c01053fd:	3c 7a                	cmp    $0x7a,%al
c01053ff:	7f 11                	jg     c0105412 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105401:	8b 45 08             	mov    0x8(%ebp),%eax
c0105404:	0f b6 00             	movzbl (%eax),%eax
c0105407:	0f be c0             	movsbl %al,%eax
c010540a:	83 e8 57             	sub    $0x57,%eax
c010540d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105410:	eb 23                	jmp    c0105435 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105412:	8b 45 08             	mov    0x8(%ebp),%eax
c0105415:	0f b6 00             	movzbl (%eax),%eax
c0105418:	3c 40                	cmp    $0x40,%al
c010541a:	7e 3c                	jle    c0105458 <strtol+0x13d>
c010541c:	8b 45 08             	mov    0x8(%ebp),%eax
c010541f:	0f b6 00             	movzbl (%eax),%eax
c0105422:	3c 5a                	cmp    $0x5a,%al
c0105424:	7f 32                	jg     c0105458 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105426:	8b 45 08             	mov    0x8(%ebp),%eax
c0105429:	0f b6 00             	movzbl (%eax),%eax
c010542c:	0f be c0             	movsbl %al,%eax
c010542f:	83 e8 37             	sub    $0x37,%eax
c0105432:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105435:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105438:	3b 45 10             	cmp    0x10(%ebp),%eax
c010543b:	7d 1a                	jge    c0105457 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010543d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105441:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105444:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105448:	89 c2                	mov    %eax,%edx
c010544a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010544d:	01 d0                	add    %edx,%eax
c010544f:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105452:	e9 71 ff ff ff       	jmp    c01053c8 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105457:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105458:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010545c:	74 08                	je     c0105466 <strtol+0x14b>
        *endptr = (char *) s;
c010545e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105461:	8b 55 08             	mov    0x8(%ebp),%edx
c0105464:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105466:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010546a:	74 07                	je     c0105473 <strtol+0x158>
c010546c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010546f:	f7 d8                	neg    %eax
c0105471:	eb 03                	jmp    c0105476 <strtol+0x15b>
c0105473:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105476:	c9                   	leave  
c0105477:	c3                   	ret    

c0105478 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105478:	55                   	push   %ebp
c0105479:	89 e5                	mov    %esp,%ebp
c010547b:	57                   	push   %edi
c010547c:	83 ec 24             	sub    $0x24,%esp
c010547f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105482:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105485:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105489:	8b 55 08             	mov    0x8(%ebp),%edx
c010548c:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010548f:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105492:	8b 45 10             	mov    0x10(%ebp),%eax
c0105495:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105498:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010549b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010549f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01054a2:	89 d7                	mov    %edx,%edi
c01054a4:	f3 aa                	rep stos %al,%es:(%edi)
c01054a6:	89 fa                	mov    %edi,%edx
c01054a8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01054ab:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01054ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054b1:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01054b2:	83 c4 24             	add    $0x24,%esp
c01054b5:	5f                   	pop    %edi
c01054b6:	5d                   	pop    %ebp
c01054b7:	c3                   	ret    

c01054b8 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01054b8:	55                   	push   %ebp
c01054b9:	89 e5                	mov    %esp,%ebp
c01054bb:	57                   	push   %edi
c01054bc:	56                   	push   %esi
c01054bd:	53                   	push   %ebx
c01054be:	83 ec 30             	sub    $0x30,%esp
c01054c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01054d0:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01054d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01054d9:	73 42                	jae    c010551d <memmove+0x65>
c01054db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01054ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054f0:	c1 e8 02             	shr    $0x2,%eax
c01054f3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01054f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054fb:	89 d7                	mov    %edx,%edi
c01054fd:	89 c6                	mov    %eax,%esi
c01054ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105501:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105504:	83 e1 03             	and    $0x3,%ecx
c0105507:	74 02                	je     c010550b <memmove+0x53>
c0105509:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010550b:	89 f0                	mov    %esi,%eax
c010550d:	89 fa                	mov    %edi,%edx
c010550f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105512:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105515:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010551b:	eb 36                	jmp    c0105553 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010551d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105520:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105523:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105526:	01 c2                	add    %eax,%edx
c0105528:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010552b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010552e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105531:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105534:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105537:	89 c1                	mov    %eax,%ecx
c0105539:	89 d8                	mov    %ebx,%eax
c010553b:	89 d6                	mov    %edx,%esi
c010553d:	89 c7                	mov    %eax,%edi
c010553f:	fd                   	std    
c0105540:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105542:	fc                   	cld    
c0105543:	89 f8                	mov    %edi,%eax
c0105545:	89 f2                	mov    %esi,%edx
c0105547:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010554a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010554d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105550:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105553:	83 c4 30             	add    $0x30,%esp
c0105556:	5b                   	pop    %ebx
c0105557:	5e                   	pop    %esi
c0105558:	5f                   	pop    %edi
c0105559:	5d                   	pop    %ebp
c010555a:	c3                   	ret    

c010555b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010555b:	55                   	push   %ebp
c010555c:	89 e5                	mov    %esp,%ebp
c010555e:	57                   	push   %edi
c010555f:	56                   	push   %esi
c0105560:	83 ec 20             	sub    $0x20,%esp
c0105563:	8b 45 08             	mov    0x8(%ebp),%eax
c0105566:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010556c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010556f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105572:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105575:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105578:	c1 e8 02             	shr    $0x2,%eax
c010557b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010557d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105580:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105583:	89 d7                	mov    %edx,%edi
c0105585:	89 c6                	mov    %eax,%esi
c0105587:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105589:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010558c:	83 e1 03             	and    $0x3,%ecx
c010558f:	74 02                	je     c0105593 <memcpy+0x38>
c0105591:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105593:	89 f0                	mov    %esi,%eax
c0105595:	89 fa                	mov    %edi,%edx
c0105597:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010559a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010559d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01055a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01055a3:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01055a4:	83 c4 20             	add    $0x20,%esp
c01055a7:	5e                   	pop    %esi
c01055a8:	5f                   	pop    %edi
c01055a9:	5d                   	pop    %ebp
c01055aa:	c3                   	ret    

c01055ab <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01055ab:	55                   	push   %ebp
c01055ac:	89 e5                	mov    %esp,%ebp
c01055ae:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01055b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01055b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01055bd:	eb 30                	jmp    c01055ef <memcmp+0x44>
        if (*s1 != *s2) {
c01055bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055c2:	0f b6 10             	movzbl (%eax),%edx
c01055c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055c8:	0f b6 00             	movzbl (%eax),%eax
c01055cb:	38 c2                	cmp    %al,%dl
c01055cd:	74 18                	je     c01055e7 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01055cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055d2:	0f b6 00             	movzbl (%eax),%eax
c01055d5:	0f b6 d0             	movzbl %al,%edx
c01055d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055db:	0f b6 00             	movzbl (%eax),%eax
c01055de:	0f b6 c0             	movzbl %al,%eax
c01055e1:	29 c2                	sub    %eax,%edx
c01055e3:	89 d0                	mov    %edx,%eax
c01055e5:	eb 1a                	jmp    c0105601 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01055e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01055eb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c01055ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01055f2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01055f5:	89 55 10             	mov    %edx,0x10(%ebp)
c01055f8:	85 c0                	test   %eax,%eax
c01055fa:	75 c3                	jne    c01055bf <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01055fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105601:	c9                   	leave  
c0105602:	c3                   	ret    

c0105603 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105603:	55                   	push   %ebp
c0105604:	89 e5                	mov    %esp,%ebp
c0105606:	83 ec 38             	sub    $0x38,%esp
c0105609:	8b 45 10             	mov    0x10(%ebp),%eax
c010560c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010560f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105612:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105615:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105618:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010561b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010561e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105621:	8b 45 18             	mov    0x18(%ebp),%eax
c0105624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105627:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010562a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010562d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105630:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105633:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105636:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010563d:	74 1c                	je     c010565b <printnum+0x58>
c010563f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105642:	ba 00 00 00 00       	mov    $0x0,%edx
c0105647:	f7 75 e4             	divl   -0x1c(%ebp)
c010564a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010564d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105650:	ba 00 00 00 00       	mov    $0x0,%edx
c0105655:	f7 75 e4             	divl   -0x1c(%ebp)
c0105658:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010565b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010565e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105661:	f7 75 e4             	divl   -0x1c(%ebp)
c0105664:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105667:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010566a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010566d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105670:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105673:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105679:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010567c:	8b 45 18             	mov    0x18(%ebp),%eax
c010567f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105684:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105687:	77 41                	ja     c01056ca <printnum+0xc7>
c0105689:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010568c:	72 05                	jb     c0105693 <printnum+0x90>
c010568e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105691:	77 37                	ja     c01056ca <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105693:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105696:	83 e8 01             	sub    $0x1,%eax
c0105699:	83 ec 04             	sub    $0x4,%esp
c010569c:	ff 75 20             	pushl  0x20(%ebp)
c010569f:	50                   	push   %eax
c01056a0:	ff 75 18             	pushl  0x18(%ebp)
c01056a3:	ff 75 ec             	pushl  -0x14(%ebp)
c01056a6:	ff 75 e8             	pushl  -0x18(%ebp)
c01056a9:	ff 75 0c             	pushl  0xc(%ebp)
c01056ac:	ff 75 08             	pushl  0x8(%ebp)
c01056af:	e8 4f ff ff ff       	call   c0105603 <printnum>
c01056b4:	83 c4 20             	add    $0x20,%esp
c01056b7:	eb 1b                	jmp    c01056d4 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01056b9:	83 ec 08             	sub    $0x8,%esp
c01056bc:	ff 75 0c             	pushl  0xc(%ebp)
c01056bf:	ff 75 20             	pushl  0x20(%ebp)
c01056c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c5:	ff d0                	call   *%eax
c01056c7:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01056ca:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01056ce:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056d2:	7f e5                	jg     c01056b9 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056d7:	05 ac 6d 10 c0       	add    $0xc0106dac,%eax
c01056dc:	0f b6 00             	movzbl (%eax),%eax
c01056df:	0f be c0             	movsbl %al,%eax
c01056e2:	83 ec 08             	sub    $0x8,%esp
c01056e5:	ff 75 0c             	pushl  0xc(%ebp)
c01056e8:	50                   	push   %eax
c01056e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ec:	ff d0                	call   *%eax
c01056ee:	83 c4 10             	add    $0x10,%esp
}
c01056f1:	90                   	nop
c01056f2:	c9                   	leave  
c01056f3:	c3                   	ret    

c01056f4 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01056f4:	55                   	push   %ebp
c01056f5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056fb:	7e 14                	jle    c0105711 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01056fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105700:	8b 00                	mov    (%eax),%eax
c0105702:	8d 48 08             	lea    0x8(%eax),%ecx
c0105705:	8b 55 08             	mov    0x8(%ebp),%edx
c0105708:	89 0a                	mov    %ecx,(%edx)
c010570a:	8b 50 04             	mov    0x4(%eax),%edx
c010570d:	8b 00                	mov    (%eax),%eax
c010570f:	eb 30                	jmp    c0105741 <getuint+0x4d>
    }
    else if (lflag) {
c0105711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105715:	74 16                	je     c010572d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105717:	8b 45 08             	mov    0x8(%ebp),%eax
c010571a:	8b 00                	mov    (%eax),%eax
c010571c:	8d 48 04             	lea    0x4(%eax),%ecx
c010571f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105722:	89 0a                	mov    %ecx,(%edx)
c0105724:	8b 00                	mov    (%eax),%eax
c0105726:	ba 00 00 00 00       	mov    $0x0,%edx
c010572b:	eb 14                	jmp    c0105741 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010572d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105730:	8b 00                	mov    (%eax),%eax
c0105732:	8d 48 04             	lea    0x4(%eax),%ecx
c0105735:	8b 55 08             	mov    0x8(%ebp),%edx
c0105738:	89 0a                	mov    %ecx,(%edx)
c010573a:	8b 00                	mov    (%eax),%eax
c010573c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105741:	5d                   	pop    %ebp
c0105742:	c3                   	ret    

c0105743 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105743:	55                   	push   %ebp
c0105744:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105746:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010574a:	7e 14                	jle    c0105760 <getint+0x1d>
        return va_arg(*ap, long long);
c010574c:	8b 45 08             	mov    0x8(%ebp),%eax
c010574f:	8b 00                	mov    (%eax),%eax
c0105751:	8d 48 08             	lea    0x8(%eax),%ecx
c0105754:	8b 55 08             	mov    0x8(%ebp),%edx
c0105757:	89 0a                	mov    %ecx,(%edx)
c0105759:	8b 50 04             	mov    0x4(%eax),%edx
c010575c:	8b 00                	mov    (%eax),%eax
c010575e:	eb 28                	jmp    c0105788 <getint+0x45>
    }
    else if (lflag) {
c0105760:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105764:	74 12                	je     c0105778 <getint+0x35>
        return va_arg(*ap, long);
c0105766:	8b 45 08             	mov    0x8(%ebp),%eax
c0105769:	8b 00                	mov    (%eax),%eax
c010576b:	8d 48 04             	lea    0x4(%eax),%ecx
c010576e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105771:	89 0a                	mov    %ecx,(%edx)
c0105773:	8b 00                	mov    (%eax),%eax
c0105775:	99                   	cltd   
c0105776:	eb 10                	jmp    c0105788 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105778:	8b 45 08             	mov    0x8(%ebp),%eax
c010577b:	8b 00                	mov    (%eax),%eax
c010577d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105780:	8b 55 08             	mov    0x8(%ebp),%edx
c0105783:	89 0a                	mov    %ecx,(%edx)
c0105785:	8b 00                	mov    (%eax),%eax
c0105787:	99                   	cltd   
    }
}
c0105788:	5d                   	pop    %ebp
c0105789:	c3                   	ret    

c010578a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010578a:	55                   	push   %ebp
c010578b:	89 e5                	mov    %esp,%ebp
c010578d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c0105790:	8d 45 14             	lea    0x14(%ebp),%eax
c0105793:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105799:	50                   	push   %eax
c010579a:	ff 75 10             	pushl  0x10(%ebp)
c010579d:	ff 75 0c             	pushl  0xc(%ebp)
c01057a0:	ff 75 08             	pushl  0x8(%ebp)
c01057a3:	e8 06 00 00 00       	call   c01057ae <vprintfmt>
c01057a8:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01057ab:	90                   	nop
c01057ac:	c9                   	leave  
c01057ad:	c3                   	ret    

c01057ae <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01057ae:	55                   	push   %ebp
c01057af:	89 e5                	mov    %esp,%ebp
c01057b1:	56                   	push   %esi
c01057b2:	53                   	push   %ebx
c01057b3:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057b6:	eb 17                	jmp    c01057cf <vprintfmt+0x21>
            if (ch == '\0') {
c01057b8:	85 db                	test   %ebx,%ebx
c01057ba:	0f 84 8e 03 00 00    	je     c0105b4e <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c01057c0:	83 ec 08             	sub    $0x8,%esp
c01057c3:	ff 75 0c             	pushl  0xc(%ebp)
c01057c6:	53                   	push   %ebx
c01057c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ca:	ff d0                	call   *%eax
c01057cc:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01057d2:	8d 50 01             	lea    0x1(%eax),%edx
c01057d5:	89 55 10             	mov    %edx,0x10(%ebp)
c01057d8:	0f b6 00             	movzbl (%eax),%eax
c01057db:	0f b6 d8             	movzbl %al,%ebx
c01057de:	83 fb 25             	cmp    $0x25,%ebx
c01057e1:	75 d5                	jne    c01057b8 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01057e3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01057e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01057ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01057f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01057fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105801:	8b 45 10             	mov    0x10(%ebp),%eax
c0105804:	8d 50 01             	lea    0x1(%eax),%edx
c0105807:	89 55 10             	mov    %edx,0x10(%ebp)
c010580a:	0f b6 00             	movzbl (%eax),%eax
c010580d:	0f b6 d8             	movzbl %al,%ebx
c0105810:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105813:	83 f8 55             	cmp    $0x55,%eax
c0105816:	0f 87 05 03 00 00    	ja     c0105b21 <vprintfmt+0x373>
c010581c:	8b 04 85 d0 6d 10 c0 	mov    -0x3fef9230(,%eax,4),%eax
c0105823:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105825:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105829:	eb d6                	jmp    c0105801 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010582b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010582f:	eb d0                	jmp    c0105801 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105831:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105838:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010583b:	89 d0                	mov    %edx,%eax
c010583d:	c1 e0 02             	shl    $0x2,%eax
c0105840:	01 d0                	add    %edx,%eax
c0105842:	01 c0                	add    %eax,%eax
c0105844:	01 d8                	add    %ebx,%eax
c0105846:	83 e8 30             	sub    $0x30,%eax
c0105849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010584c:	8b 45 10             	mov    0x10(%ebp),%eax
c010584f:	0f b6 00             	movzbl (%eax),%eax
c0105852:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105855:	83 fb 2f             	cmp    $0x2f,%ebx
c0105858:	7e 39                	jle    c0105893 <vprintfmt+0xe5>
c010585a:	83 fb 39             	cmp    $0x39,%ebx
c010585d:	7f 34                	jg     c0105893 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010585f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105863:	eb d3                	jmp    c0105838 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105865:	8b 45 14             	mov    0x14(%ebp),%eax
c0105868:	8d 50 04             	lea    0x4(%eax),%edx
c010586b:	89 55 14             	mov    %edx,0x14(%ebp)
c010586e:	8b 00                	mov    (%eax),%eax
c0105870:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105873:	eb 1f                	jmp    c0105894 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0105875:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105879:	79 86                	jns    c0105801 <vprintfmt+0x53>
                width = 0;
c010587b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105882:	e9 7a ff ff ff       	jmp    c0105801 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105887:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010588e:	e9 6e ff ff ff       	jmp    c0105801 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0105893:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0105894:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105898:	0f 89 63 ff ff ff    	jns    c0105801 <vprintfmt+0x53>
                width = precision, precision = -1;
c010589e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01058ab:	e9 51 ff ff ff       	jmp    c0105801 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01058b0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01058b4:	e9 48 ff ff ff       	jmp    c0105801 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01058bc:	8d 50 04             	lea    0x4(%eax),%edx
c01058bf:	89 55 14             	mov    %edx,0x14(%ebp)
c01058c2:	8b 00                	mov    (%eax),%eax
c01058c4:	83 ec 08             	sub    $0x8,%esp
c01058c7:	ff 75 0c             	pushl  0xc(%ebp)
c01058ca:	50                   	push   %eax
c01058cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ce:	ff d0                	call   *%eax
c01058d0:	83 c4 10             	add    $0x10,%esp
            break;
c01058d3:	e9 71 02 00 00       	jmp    c0105b49 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01058db:	8d 50 04             	lea    0x4(%eax),%edx
c01058de:	89 55 14             	mov    %edx,0x14(%ebp)
c01058e1:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01058e3:	85 db                	test   %ebx,%ebx
c01058e5:	79 02                	jns    c01058e9 <vprintfmt+0x13b>
                err = -err;
c01058e7:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01058e9:	83 fb 06             	cmp    $0x6,%ebx
c01058ec:	7f 0b                	jg     c01058f9 <vprintfmt+0x14b>
c01058ee:	8b 34 9d 90 6d 10 c0 	mov    -0x3fef9270(,%ebx,4),%esi
c01058f5:	85 f6                	test   %esi,%esi
c01058f7:	75 19                	jne    c0105912 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c01058f9:	53                   	push   %ebx
c01058fa:	68 bd 6d 10 c0       	push   $0xc0106dbd
c01058ff:	ff 75 0c             	pushl  0xc(%ebp)
c0105902:	ff 75 08             	pushl  0x8(%ebp)
c0105905:	e8 80 fe ff ff       	call   c010578a <printfmt>
c010590a:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010590d:	e9 37 02 00 00       	jmp    c0105b49 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105912:	56                   	push   %esi
c0105913:	68 c6 6d 10 c0       	push   $0xc0106dc6
c0105918:	ff 75 0c             	pushl  0xc(%ebp)
c010591b:	ff 75 08             	pushl  0x8(%ebp)
c010591e:	e8 67 fe ff ff       	call   c010578a <printfmt>
c0105923:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0105926:	e9 1e 02 00 00       	jmp    c0105b49 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010592b:	8b 45 14             	mov    0x14(%ebp),%eax
c010592e:	8d 50 04             	lea    0x4(%eax),%edx
c0105931:	89 55 14             	mov    %edx,0x14(%ebp)
c0105934:	8b 30                	mov    (%eax),%esi
c0105936:	85 f6                	test   %esi,%esi
c0105938:	75 05                	jne    c010593f <vprintfmt+0x191>
                p = "(null)";
c010593a:	be c9 6d 10 c0       	mov    $0xc0106dc9,%esi
            }
            if (width > 0 && padc != '-') {
c010593f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105943:	7e 76                	jle    c01059bb <vprintfmt+0x20d>
c0105945:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105949:	74 70                	je     c01059bb <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010594b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010594e:	83 ec 08             	sub    $0x8,%esp
c0105951:	50                   	push   %eax
c0105952:	56                   	push   %esi
c0105953:	e8 17 f8 ff ff       	call   c010516f <strnlen>
c0105958:	83 c4 10             	add    $0x10,%esp
c010595b:	89 c2                	mov    %eax,%edx
c010595d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105960:	29 d0                	sub    %edx,%eax
c0105962:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105965:	eb 17                	jmp    c010597e <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105967:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010596b:	83 ec 08             	sub    $0x8,%esp
c010596e:	ff 75 0c             	pushl  0xc(%ebp)
c0105971:	50                   	push   %eax
c0105972:	8b 45 08             	mov    0x8(%ebp),%eax
c0105975:	ff d0                	call   *%eax
c0105977:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010597a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010597e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105982:	7f e3                	jg     c0105967 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105984:	eb 35                	jmp    c01059bb <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105986:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010598a:	74 1c                	je     c01059a8 <vprintfmt+0x1fa>
c010598c:	83 fb 1f             	cmp    $0x1f,%ebx
c010598f:	7e 05                	jle    c0105996 <vprintfmt+0x1e8>
c0105991:	83 fb 7e             	cmp    $0x7e,%ebx
c0105994:	7e 12                	jle    c01059a8 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0105996:	83 ec 08             	sub    $0x8,%esp
c0105999:	ff 75 0c             	pushl  0xc(%ebp)
c010599c:	6a 3f                	push   $0x3f
c010599e:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a1:	ff d0                	call   *%eax
c01059a3:	83 c4 10             	add    $0x10,%esp
c01059a6:	eb 0f                	jmp    c01059b7 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c01059a8:	83 ec 08             	sub    $0x8,%esp
c01059ab:	ff 75 0c             	pushl  0xc(%ebp)
c01059ae:	53                   	push   %ebx
c01059af:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b2:	ff d0                	call   *%eax
c01059b4:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059b7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059bb:	89 f0                	mov    %esi,%eax
c01059bd:	8d 70 01             	lea    0x1(%eax),%esi
c01059c0:	0f b6 00             	movzbl (%eax),%eax
c01059c3:	0f be d8             	movsbl %al,%ebx
c01059c6:	85 db                	test   %ebx,%ebx
c01059c8:	74 26                	je     c01059f0 <vprintfmt+0x242>
c01059ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059ce:	78 b6                	js     c0105986 <vprintfmt+0x1d8>
c01059d0:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01059d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059d8:	79 ac                	jns    c0105986 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059da:	eb 14                	jmp    c01059f0 <vprintfmt+0x242>
                putch(' ', putdat);
c01059dc:	83 ec 08             	sub    $0x8,%esp
c01059df:	ff 75 0c             	pushl  0xc(%ebp)
c01059e2:	6a 20                	push   $0x20
c01059e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e7:	ff d0                	call   *%eax
c01059e9:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059ec:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059f4:	7f e6                	jg     c01059dc <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c01059f6:	e9 4e 01 00 00       	jmp    c0105b49 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01059fb:	83 ec 08             	sub    $0x8,%esp
c01059fe:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a01:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a04:	50                   	push   %eax
c0105a05:	e8 39 fd ff ff       	call   c0105743 <getint>
c0105a0a:	83 c4 10             	add    $0x10,%esp
c0105a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a10:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a19:	85 d2                	test   %edx,%edx
c0105a1b:	79 23                	jns    c0105a40 <vprintfmt+0x292>
                putch('-', putdat);
c0105a1d:	83 ec 08             	sub    $0x8,%esp
c0105a20:	ff 75 0c             	pushl  0xc(%ebp)
c0105a23:	6a 2d                	push   $0x2d
c0105a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a28:	ff d0                	call   *%eax
c0105a2a:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a33:	f7 d8                	neg    %eax
c0105a35:	83 d2 00             	adc    $0x0,%edx
c0105a38:	f7 da                	neg    %edx
c0105a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a40:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a47:	e9 9f 00 00 00       	jmp    c0105aeb <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a4c:	83 ec 08             	sub    $0x8,%esp
c0105a4f:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a52:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a55:	50                   	push   %eax
c0105a56:	e8 99 fc ff ff       	call   c01056f4 <getuint>
c0105a5b:	83 c4 10             	add    $0x10,%esp
c0105a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a6b:	eb 7e                	jmp    c0105aeb <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a6d:	83 ec 08             	sub    $0x8,%esp
c0105a70:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a73:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a76:	50                   	push   %eax
c0105a77:	e8 78 fc ff ff       	call   c01056f4 <getuint>
c0105a7c:	83 c4 10             	add    $0x10,%esp
c0105a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105a85:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105a8c:	eb 5d                	jmp    c0105aeb <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0105a8e:	83 ec 08             	sub    $0x8,%esp
c0105a91:	ff 75 0c             	pushl  0xc(%ebp)
c0105a94:	6a 30                	push   $0x30
c0105a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a99:	ff d0                	call   *%eax
c0105a9b:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105a9e:	83 ec 08             	sub    $0x8,%esp
c0105aa1:	ff 75 0c             	pushl  0xc(%ebp)
c0105aa4:	6a 78                	push   $0x78
c0105aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa9:	ff d0                	call   *%eax
c0105aab:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105aae:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ab1:	8d 50 04             	lea    0x4(%eax),%edx
c0105ab4:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ab7:	8b 00                	mov    (%eax),%eax
c0105ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105abc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ac3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105aca:	eb 1f                	jmp    c0105aeb <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105acc:	83 ec 08             	sub    $0x8,%esp
c0105acf:	ff 75 e0             	pushl  -0x20(%ebp)
c0105ad2:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ad5:	50                   	push   %eax
c0105ad6:	e8 19 fc ff ff       	call   c01056f4 <getuint>
c0105adb:	83 c4 10             	add    $0x10,%esp
c0105ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ae1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105ae4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105aeb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105af2:	83 ec 04             	sub    $0x4,%esp
c0105af5:	52                   	push   %edx
c0105af6:	ff 75 e8             	pushl  -0x18(%ebp)
c0105af9:	50                   	push   %eax
c0105afa:	ff 75 f4             	pushl  -0xc(%ebp)
c0105afd:	ff 75 f0             	pushl  -0x10(%ebp)
c0105b00:	ff 75 0c             	pushl  0xc(%ebp)
c0105b03:	ff 75 08             	pushl  0x8(%ebp)
c0105b06:	e8 f8 fa ff ff       	call   c0105603 <printnum>
c0105b0b:	83 c4 20             	add    $0x20,%esp
            break;
c0105b0e:	eb 39                	jmp    c0105b49 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b10:	83 ec 08             	sub    $0x8,%esp
c0105b13:	ff 75 0c             	pushl  0xc(%ebp)
c0105b16:	53                   	push   %ebx
c0105b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1a:	ff d0                	call   *%eax
c0105b1c:	83 c4 10             	add    $0x10,%esp
            break;
c0105b1f:	eb 28                	jmp    c0105b49 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b21:	83 ec 08             	sub    $0x8,%esp
c0105b24:	ff 75 0c             	pushl  0xc(%ebp)
c0105b27:	6a 25                	push   $0x25
c0105b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2c:	ff d0                	call   *%eax
c0105b2e:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b31:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b35:	eb 04                	jmp    c0105b3b <vprintfmt+0x38d>
c0105b37:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b3b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b3e:	83 e8 01             	sub    $0x1,%eax
c0105b41:	0f b6 00             	movzbl (%eax),%eax
c0105b44:	3c 25                	cmp    $0x25,%al
c0105b46:	75 ef                	jne    c0105b37 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105b48:	90                   	nop
        }
    }
c0105b49:	e9 68 fc ff ff       	jmp    c01057b6 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0105b4e:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105b52:	5b                   	pop    %ebx
c0105b53:	5e                   	pop    %esi
c0105b54:	5d                   	pop    %ebp
c0105b55:	c3                   	ret    

c0105b56 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b56:	55                   	push   %ebp
c0105b57:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b5c:	8b 40 08             	mov    0x8(%eax),%eax
c0105b5f:	8d 50 01             	lea    0x1(%eax),%edx
c0105b62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b65:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105b68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b6b:	8b 10                	mov    (%eax),%edx
c0105b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b70:	8b 40 04             	mov    0x4(%eax),%eax
c0105b73:	39 c2                	cmp    %eax,%edx
c0105b75:	73 12                	jae    c0105b89 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105b77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7a:	8b 00                	mov    (%eax),%eax
c0105b7c:	8d 48 01             	lea    0x1(%eax),%ecx
c0105b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b82:	89 0a                	mov    %ecx,(%edx)
c0105b84:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b87:	88 10                	mov    %dl,(%eax)
    }
}
c0105b89:	90                   	nop
c0105b8a:	5d                   	pop    %ebp
c0105b8b:	c3                   	ret    

c0105b8c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105b8c:	55                   	push   %ebp
c0105b8d:	89 e5                	mov    %esp,%ebp
c0105b8f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105b92:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b9b:	50                   	push   %eax
c0105b9c:	ff 75 10             	pushl  0x10(%ebp)
c0105b9f:	ff 75 0c             	pushl  0xc(%ebp)
c0105ba2:	ff 75 08             	pushl  0x8(%ebp)
c0105ba5:	e8 0b 00 00 00       	call   c0105bb5 <vsnprintf>
c0105baa:	83 c4 10             	add    $0x10,%esp
c0105bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bb3:	c9                   	leave  
c0105bb4:	c3                   	ret    

c0105bb5 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105bb5:	55                   	push   %ebp
c0105bb6:	89 e5                	mov    %esp,%ebp
c0105bb8:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bca:	01 d0                	add    %edx,%eax
c0105bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105bd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105bda:	74 0a                	je     c0105be6 <vsnprintf+0x31>
c0105bdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105be2:	39 c2                	cmp    %eax,%edx
c0105be4:	76 07                	jbe    c0105bed <vsnprintf+0x38>
        return -E_INVAL;
c0105be6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105beb:	eb 20                	jmp    c0105c0d <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105bed:	ff 75 14             	pushl  0x14(%ebp)
c0105bf0:	ff 75 10             	pushl  0x10(%ebp)
c0105bf3:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105bf6:	50                   	push   %eax
c0105bf7:	68 56 5b 10 c0       	push   $0xc0105b56
c0105bfc:	e8 ad fb ff ff       	call   c01057ae <vprintfmt>
c0105c01:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c07:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c0d:	c9                   	leave  
c0105c0e:	c3                   	ret    
