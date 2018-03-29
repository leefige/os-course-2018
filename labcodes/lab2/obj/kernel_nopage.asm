
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba c8 89 11 00       	mov    $0x1189c8,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 36 7a 11 00       	push   $0x117a36
  100049:	e8 4b 54 00 00       	call   105499 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 6a 15 00 00       	call   1015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 40 5c 10 00 	movl   $0x105c40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 5c 5c 10 00       	push   $0x105c5c
  100068:	e8 02 02 00 00       	call   10026f <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 84 08 00 00       	call   1008f9 <print_kerninfo>

    grade_backtrace();
  100075:	e8 74 00 00 00       	call   1000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 d3 31 00 00       	call   103252 <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 ae 16 00 00       	call   101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 30 18 00 00       	call   1018b9 <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 d9 0c 00 00       	call   100d67 <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 dc 17 00 00       	call   10186f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100093:	eb fe                	jmp    100093 <kern_init+0x69>

00100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10009b:	83 ec 04             	sub    $0x4,%esp
  10009e:	6a 00                	push   $0x0
  1000a0:	6a 00                	push   $0x0
  1000a2:	6a 00                	push   $0x0
  1000a4:	e8 ac 0c 00 00       	call   100d55 <mon_backtrace>
  1000a9:	83 c4 10             	add    $0x10,%esp
}
  1000ac:	90                   	nop
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	53                   	push   %ebx
  1000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c2:	51                   	push   %ecx
  1000c3:	52                   	push   %edx
  1000c4:	53                   	push   %ebx
  1000c5:	50                   	push   %eax
  1000c6:	e8 ca ff ff ff       	call   100095 <grade_backtrace2>
  1000cb:	83 c4 10             	add    $0x10,%esp
}
  1000ce:	90                   	nop
  1000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	83 ec 08             	sub    $0x8,%esp
  1000dd:	ff 75 10             	pushl  0x10(%ebp)
  1000e0:	ff 75 08             	pushl  0x8(%ebp)
  1000e3:	e8 c7 ff ff ff       	call   1000af <grade_backtrace1>
  1000e8:	83 c4 10             	add    $0x10,%esp
}
  1000eb:	90                   	nop
  1000ec:	c9                   	leave  
  1000ed:	c3                   	ret    

001000ee <grade_backtrace>:

void
grade_backtrace(void) {
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000f9:	83 ec 04             	sub    $0x4,%esp
  1000fc:	68 00 00 ff ff       	push   $0xffff0000
  100101:	50                   	push   %eax
  100102:	6a 00                	push   $0x0
  100104:	e8 cb ff ff ff       	call   1000d4 <grade_backtrace0>
  100109:	83 c4 10             	add    $0x10,%esp
}
  10010c:	90                   	nop
  10010d:	c9                   	leave  
  10010e:	c3                   	ret    

0010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010f:	55                   	push   %ebp
  100110:	89 e5                	mov    %esp,%ebp
  100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100125:	0f b7 c0             	movzwl %ax,%eax
  100128:	83 e0 03             	and    $0x3,%eax
  10012b:	89 c2                	mov    %eax,%edx
  10012d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100132:	83 ec 04             	sub    $0x4,%esp
  100135:	52                   	push   %edx
  100136:	50                   	push   %eax
  100137:	68 61 5c 10 00       	push   $0x105c61
  10013c:	e8 2e 01 00 00       	call   10026f <cprintf>
  100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100148:	0f b7 d0             	movzwl %ax,%edx
  10014b:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100150:	83 ec 04             	sub    $0x4,%esp
  100153:	52                   	push   %edx
  100154:	50                   	push   %eax
  100155:	68 6f 5c 10 00       	push   $0x105c6f
  10015a:	e8 10 01 00 00       	call   10026f <cprintf>
  10015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100166:	0f b7 d0             	movzwl %ax,%edx
  100169:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016e:	83 ec 04             	sub    $0x4,%esp
  100171:	52                   	push   %edx
  100172:	50                   	push   %eax
  100173:	68 7d 5c 10 00       	push   $0x105c7d
  100178:	e8 f2 00 00 00       	call   10026f <cprintf>
  10017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	0f b7 d0             	movzwl %ax,%edx
  100187:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018c:	83 ec 04             	sub    $0x4,%esp
  10018f:	52                   	push   %edx
  100190:	50                   	push   %eax
  100191:	68 8b 5c 10 00       	push   $0x105c8b
  100196:	e8 d4 00 00 00       	call   10026f <cprintf>
  10019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001aa:	83 ec 04             	sub    $0x4,%esp
  1001ad:	52                   	push   %edx
  1001ae:	50                   	push   %eax
  1001af:	68 99 5c 10 00       	push   $0x105c99
  1001b4:	e8 b6 00 00 00       	call   10026f <cprintf>
  1001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001bc:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001c9:	90                   	nop
  1001ca:	c9                   	leave  
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cc:	55                   	push   %ebp
  1001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    // "movl %%ebp, %%esp" esure that before ret, esp = ebp -> old ebp
    asm volatile (
  1001cf:	cd 78                	int    $0x78
  1001d1:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d3:	90                   	nop
  1001d4:	5d                   	pop    %ebp
  1001d5:	c3                   	ret    

001001d6 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d6:	55                   	push   %ebp
  1001d7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    // cprintf("in lab1_switch_to_kernel\n");
    asm volatile (
  1001d9:	cd 79                	int    $0x79
  1001db:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
        : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001dd:	90                   	nop
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e0:	55                   	push   %ebp
  1001e1:	89 e5                	mov    %esp,%ebp
  1001e3:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001e6:	e8 24 ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001eb:	83 ec 0c             	sub    $0xc,%esp
  1001ee:	68 a8 5c 10 00       	push   $0x105ca8
  1001f3:	e8 77 00 00 00       	call   10026f <cprintf>
  1001f8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001fb:	e8 cc ff ff ff       	call   1001cc <lab1_switch_to_user>
    lab1_print_cur_status();
  100200:	e8 0a ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100205:	83 ec 0c             	sub    $0xc,%esp
  100208:	68 c8 5c 10 00       	push   $0x105cc8
  10020d:	e8 5d 00 00 00       	call   10026f <cprintf>
  100212:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  100215:	e8 bc ff ff ff       	call   1001d6 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10021a:	e8 f0 fe ff ff       	call   10010f <lab1_print_cur_status>
}
  10021f:	90                   	nop
  100220:	c9                   	leave  
  100221:	c3                   	ret    

00100222 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100222:	55                   	push   %ebp
  100223:	89 e5                	mov    %esp,%ebp
  100225:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100228:	83 ec 0c             	sub    $0xc,%esp
  10022b:	ff 75 08             	pushl  0x8(%ebp)
  10022e:	e8 be 13 00 00       	call   1015f1 <cons_putc>
  100233:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	8b 00                	mov    (%eax),%eax
  10023b:	8d 50 01             	lea    0x1(%eax),%edx
  10023e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100241:	89 10                	mov    %edx,(%eax)
}
  100243:	90                   	nop
  100244:	c9                   	leave  
  100245:	c3                   	ret    

00100246 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100246:	55                   	push   %ebp
  100247:	89 e5                	mov    %esp,%ebp
  100249:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10024c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100253:	ff 75 0c             	pushl  0xc(%ebp)
  100256:	ff 75 08             	pushl  0x8(%ebp)
  100259:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10025c:	50                   	push   %eax
  10025d:	68 22 02 10 00       	push   $0x100222
  100262:	e8 68 55 00 00       	call   1057cf <vprintfmt>
  100267:	83 c4 10             	add    $0x10,%esp
    return cnt;
  10026a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026d:	c9                   	leave  
  10026e:	c3                   	ret    

0010026f <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026f:	55                   	push   %ebp
  100270:	89 e5                	mov    %esp,%ebp
  100272:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100275:	8d 45 0c             	lea    0xc(%ebp),%eax
  100278:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10027b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027e:	83 ec 08             	sub    $0x8,%esp
  100281:	50                   	push   %eax
  100282:	ff 75 08             	pushl  0x8(%ebp)
  100285:	e8 bc ff ff ff       	call   100246 <vcprintf>
  10028a:	83 c4 10             	add    $0x10,%esp
  10028d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100290:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100293:	c9                   	leave  
  100294:	c3                   	ret    

00100295 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100295:	55                   	push   %ebp
  100296:	89 e5                	mov    %esp,%ebp
  100298:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  10029b:	83 ec 0c             	sub    $0xc,%esp
  10029e:	ff 75 08             	pushl  0x8(%ebp)
  1002a1:	e8 4b 13 00 00       	call   1015f1 <cons_putc>
  1002a6:	83 c4 10             	add    $0x10,%esp
}
  1002a9:	90                   	nop
  1002aa:	c9                   	leave  
  1002ab:	c3                   	ret    

001002ac <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002ac:	55                   	push   %ebp
  1002ad:	89 e5                	mov    %esp,%ebp
  1002af:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b9:	eb 14                	jmp    1002cf <cputs+0x23>
        cputch(c, &cnt);
  1002bb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002bf:	83 ec 08             	sub    $0x8,%esp
  1002c2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002c5:	52                   	push   %edx
  1002c6:	50                   	push   %eax
  1002c7:	e8 56 ff ff ff       	call   100222 <cputch>
  1002cc:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d2:	8d 50 01             	lea    0x1(%eax),%edx
  1002d5:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d8:	0f b6 00             	movzbl (%eax),%eax
  1002db:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002de:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002e2:	75 d7                	jne    1002bb <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002e4:	83 ec 08             	sub    $0x8,%esp
  1002e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002ea:	50                   	push   %eax
  1002eb:	6a 0a                	push   $0xa
  1002ed:	e8 30 ff ff ff       	call   100222 <cputch>
  1002f2:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f8:	c9                   	leave  
  1002f9:	c3                   	ret    

001002fa <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002fa:	55                   	push   %ebp
  1002fb:	89 e5                	mov    %esp,%ebp
  1002fd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100300:	e8 35 13 00 00       	call   10163a <cons_getc>
  100305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10030c:	74 f2                	je     100300 <getchar+0x6>
        /* do nothing */;
    return c;
  10030e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100311:	c9                   	leave  
  100312:	c3                   	ret    

00100313 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100313:	55                   	push   %ebp
  100314:	89 e5                	mov    %esp,%ebp
  100316:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10031d:	74 13                	je     100332 <readline+0x1f>
        cprintf("%s", prompt);
  10031f:	83 ec 08             	sub    $0x8,%esp
  100322:	ff 75 08             	pushl  0x8(%ebp)
  100325:	68 e7 5c 10 00       	push   $0x105ce7
  10032a:	e8 40 ff ff ff       	call   10026f <cprintf>
  10032f:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100339:	e8 bc ff ff ff       	call   1002fa <getchar>
  10033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100345:	79 0a                	jns    100351 <readline+0x3e>
            return NULL;
  100347:	b8 00 00 00 00       	mov    $0x0,%eax
  10034c:	e9 82 00 00 00       	jmp    1003d3 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100351:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100355:	7e 2b                	jle    100382 <readline+0x6f>
  100357:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10035e:	7f 22                	jg     100382 <readline+0x6f>
            cputchar(c);
  100360:	83 ec 0c             	sub    $0xc,%esp
  100363:	ff 75 f0             	pushl  -0x10(%ebp)
  100366:	e8 2a ff ff ff       	call   100295 <cputchar>
  10036b:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10036e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100371:	8d 50 01             	lea    0x1(%eax),%edx
  100374:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100377:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10037a:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  100380:	eb 4c                	jmp    1003ce <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100382:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100386:	75 1a                	jne    1003a2 <readline+0x8f>
  100388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10038c:	7e 14                	jle    1003a2 <readline+0x8f>
            cputchar(c);
  10038e:	83 ec 0c             	sub    $0xc,%esp
  100391:	ff 75 f0             	pushl  -0x10(%ebp)
  100394:	e8 fc fe ff ff       	call   100295 <cputchar>
  100399:	83 c4 10             	add    $0x10,%esp
            i --;
  10039c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003a0:	eb 2c                	jmp    1003ce <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  1003a2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003a6:	74 06                	je     1003ae <readline+0x9b>
  1003a8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003ac:	75 8b                	jne    100339 <readline+0x26>
            cputchar(c);
  1003ae:	83 ec 0c             	sub    $0xc,%esp
  1003b1:	ff 75 f0             	pushl  -0x10(%ebp)
  1003b4:	e8 dc fe ff ff       	call   100295 <cputchar>
  1003b9:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003bf:	05 60 7a 11 00       	add    $0x117a60,%eax
  1003c4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003c7:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1003cc:	eb 05                	jmp    1003d3 <readline+0xc0>
        }
    }
  1003ce:	e9 66 ff ff ff       	jmp    100339 <readline+0x26>
}
  1003d3:	c9                   	leave  
  1003d4:	c3                   	ret    

001003d5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003d5:	55                   	push   %ebp
  1003d6:	89 e5                	mov    %esp,%ebp
  1003d8:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003db:	a1 60 7e 11 00       	mov    0x117e60,%eax
  1003e0:	85 c0                	test   %eax,%eax
  1003e2:	75 4a                	jne    10042e <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003e4:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  1003eb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003ee:	8d 45 14             	lea    0x14(%ebp),%eax
  1003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003f4:	83 ec 04             	sub    $0x4,%esp
  1003f7:	ff 75 0c             	pushl  0xc(%ebp)
  1003fa:	ff 75 08             	pushl  0x8(%ebp)
  1003fd:	68 ea 5c 10 00       	push   $0x105cea
  100402:	e8 68 fe ff ff       	call   10026f <cprintf>
  100407:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10040d:	83 ec 08             	sub    $0x8,%esp
  100410:	50                   	push   %eax
  100411:	ff 75 10             	pushl  0x10(%ebp)
  100414:	e8 2d fe ff ff       	call   100246 <vcprintf>
  100419:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10041c:	83 ec 0c             	sub    $0xc,%esp
  10041f:	68 06 5d 10 00       	push   $0x105d06
  100424:	e8 46 fe ff ff       	call   10026f <cprintf>
  100429:	83 c4 10             	add    $0x10,%esp
  10042c:	eb 01                	jmp    10042f <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  10042e:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  10042f:	e8 42 14 00 00       	call   101876 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100434:	83 ec 0c             	sub    $0xc,%esp
  100437:	6a 00                	push   $0x0
  100439:	e8 3d 08 00 00       	call   100c7b <kmonitor>
  10043e:	83 c4 10             	add    $0x10,%esp
    }
  100441:	eb f1                	jmp    100434 <__panic+0x5f>

00100443 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100443:	55                   	push   %ebp
  100444:	89 e5                	mov    %esp,%ebp
  100446:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100449:	8d 45 14             	lea    0x14(%ebp),%eax
  10044c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044f:	83 ec 04             	sub    $0x4,%esp
  100452:	ff 75 0c             	pushl  0xc(%ebp)
  100455:	ff 75 08             	pushl  0x8(%ebp)
  100458:	68 08 5d 10 00       	push   $0x105d08
  10045d:	e8 0d fe ff ff       	call   10026f <cprintf>
  100462:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100468:	83 ec 08             	sub    $0x8,%esp
  10046b:	50                   	push   %eax
  10046c:	ff 75 10             	pushl  0x10(%ebp)
  10046f:	e8 d2 fd ff ff       	call   100246 <vcprintf>
  100474:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100477:	83 ec 0c             	sub    $0xc,%esp
  10047a:	68 06 5d 10 00       	push   $0x105d06
  10047f:	e8 eb fd ff ff       	call   10026f <cprintf>
  100484:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100487:	90                   	nop
  100488:	c9                   	leave  
  100489:	c3                   	ret    

0010048a <is_kernel_panic>:

bool
is_kernel_panic(void) {
  10048a:	55                   	push   %ebp
  10048b:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10048d:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100492:	5d                   	pop    %ebp
  100493:	c3                   	ret    

00100494 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100494:	55                   	push   %ebp
  100495:	89 e5                	mov    %esp,%ebp
  100497:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049d:	8b 00                	mov    (%eax),%eax
  10049f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a5:	8b 00                	mov    (%eax),%eax
  1004a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004b1:	e9 d2 00 00 00       	jmp    100588 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004bc:	01 d0                	add    %edx,%eax
  1004be:	89 c2                	mov    %eax,%edx
  1004c0:	c1 ea 1f             	shr    $0x1f,%edx
  1004c3:	01 d0                	add    %edx,%eax
  1004c5:	d1 f8                	sar    %eax
  1004c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004cd:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x42>
            m --;
  1004d2:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004dc:	7c 1f                	jl     1004fd <stab_binsearch+0x69>
  1004de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e1:	89 d0                	mov    %edx,%eax
  1004e3:	01 c0                	add    %eax,%eax
  1004e5:	01 d0                	add    %edx,%eax
  1004e7:	c1 e0 02             	shl    $0x2,%eax
  1004ea:	89 c2                	mov    %eax,%edx
  1004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ef:	01 d0                	add    %edx,%eax
  1004f1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f5:	0f b6 c0             	movzbl %al,%eax
  1004f8:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fb:	75 d5                	jne    1004d2 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100500:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100503:	7d 0b                	jge    100510 <stab_binsearch+0x7c>
            l = true_m + 1;
  100505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100508:	83 c0 01             	add    $0x1,%eax
  10050b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10050e:	eb 78                	jmp    100588 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100510:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100517:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10051a:	89 d0                	mov    %edx,%eax
  10051c:	01 c0                	add    %eax,%eax
  10051e:	01 d0                	add    %edx,%eax
  100520:	c1 e0 02             	shl    $0x2,%eax
  100523:	89 c2                	mov    %eax,%edx
  100525:	8b 45 08             	mov    0x8(%ebp),%eax
  100528:	01 d0                	add    %edx,%eax
  10052a:	8b 40 08             	mov    0x8(%eax),%eax
  10052d:	3b 45 18             	cmp    0x18(%ebp),%eax
  100530:	73 13                	jae    100545 <stab_binsearch+0xb1>
            *region_left = m;
  100532:	8b 45 0c             	mov    0xc(%ebp),%eax
  100535:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100538:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10053a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053d:	83 c0 01             	add    $0x1,%eax
  100540:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100543:	eb 43                	jmp    100588 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100548:	89 d0                	mov    %edx,%eax
  10054a:	01 c0                	add    %eax,%eax
  10054c:	01 d0                	add    %edx,%eax
  10054e:	c1 e0 02             	shl    $0x2,%eax
  100551:	89 c2                	mov    %eax,%edx
  100553:	8b 45 08             	mov    0x8(%ebp),%eax
  100556:	01 d0                	add    %edx,%eax
  100558:	8b 40 08             	mov    0x8(%eax),%eax
  10055b:	3b 45 18             	cmp    0x18(%ebp),%eax
  10055e:	76 16                	jbe    100576 <stab_binsearch+0xe2>
            *region_right = m - 1;
  100560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100563:	8d 50 ff             	lea    -0x1(%eax),%edx
  100566:	8b 45 10             	mov    0x10(%ebp),%eax
  100569:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10056b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056e:	83 e8 01             	sub    $0x1,%eax
  100571:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100574:	eb 12                	jmp    100588 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100576:	8b 45 0c             	mov    0xc(%ebp),%eax
  100579:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10057c:	89 10                	mov    %edx,(%eax)
            l = m;
  10057e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100581:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100584:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100588:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10058b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10058e:	0f 8e 22 ff ff ff    	jle    1004b6 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100598:	75 0f                	jne    1005a9 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  10059a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10059d:	8b 00                	mov    (%eax),%eax
  10059f:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a5:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005a7:	eb 3f                	jmp    1005e8 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ac:	8b 00                	mov    (%eax),%eax
  1005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005b1:	eb 04                	jmp    1005b7 <stab_binsearch+0x123>
  1005b3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ba:	8b 00                	mov    (%eax),%eax
  1005bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005bf:	7d 1f                	jge    1005e0 <stab_binsearch+0x14c>
  1005c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c4:	89 d0                	mov    %edx,%eax
  1005c6:	01 c0                	add    %eax,%eax
  1005c8:	01 d0                	add    %edx,%eax
  1005ca:	c1 e0 02             	shl    $0x2,%eax
  1005cd:	89 c2                	mov    %eax,%edx
  1005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d2:	01 d0                	add    %edx,%eax
  1005d4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d8:	0f b6 c0             	movzbl %al,%eax
  1005db:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005de:	75 d3                	jne    1005b3 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005e6:	89 10                	mov    %edx,(%eax)
    }
}
  1005e8:	90                   	nop
  1005e9:	c9                   	leave  
  1005ea:	c3                   	ret    

001005eb <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005eb:	55                   	push   %ebp
  1005ec:	89 e5                	mov    %esp,%ebp
  1005ee:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f4:	c7 00 28 5d 10 00    	movl   $0x105d28,(%eax)
    info->eip_line = 0;
  1005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100604:	8b 45 0c             	mov    0xc(%ebp),%eax
  100607:	c7 40 08 28 5d 10 00 	movl   $0x105d28,0x8(%eax)
    info->eip_fn_namelen = 9;
  10060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100611:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100618:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061b:	8b 55 08             	mov    0x8(%ebp),%edx
  10061e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100621:	8b 45 0c             	mov    0xc(%ebp),%eax
  100624:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10062b:	c7 45 f4 68 6f 10 00 	movl   $0x106f68,-0xc(%ebp)
    stab_end = __STAB_END__;
  100632:	c7 45 f0 68 20 11 00 	movl   $0x112068,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100639:	c7 45 ec 69 20 11 00 	movl   $0x112069,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100640:	c7 45 e8 9b 4b 11 00 	movl   $0x114b9b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10064d:	76 0d                	jbe    10065c <debuginfo_eip+0x71>
  10064f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100652:	83 e8 01             	sub    $0x1,%eax
  100655:	0f b6 00             	movzbl (%eax),%eax
  100658:	84 c0                	test   %al,%al
  10065a:	74 0a                	je     100666 <debuginfo_eip+0x7b>
        return -1;
  10065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100661:	e9 91 02 00 00       	jmp    1008f7 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100666:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10066d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100673:	29 c2                	sub    %eax,%edx
  100675:	89 d0                	mov    %edx,%eax
  100677:	c1 f8 02             	sar    $0x2,%eax
  10067a:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100680:	83 e8 01             	sub    $0x1,%eax
  100683:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100686:	ff 75 08             	pushl  0x8(%ebp)
  100689:	6a 64                	push   $0x64
  10068b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10068e:	50                   	push   %eax
  10068f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100692:	50                   	push   %eax
  100693:	ff 75 f4             	pushl  -0xc(%ebp)
  100696:	e8 f9 fd ff ff       	call   100494 <stab_binsearch>
  10069b:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10069e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a1:	85 c0                	test   %eax,%eax
  1006a3:	75 0a                	jne    1006af <debuginfo_eip+0xc4>
        return -1;
  1006a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006aa:	e9 48 02 00 00       	jmp    1008f7 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006bb:	ff 75 08             	pushl  0x8(%ebp)
  1006be:	6a 24                	push   $0x24
  1006c0:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006c3:	50                   	push   %eax
  1006c4:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006c7:	50                   	push   %eax
  1006c8:	ff 75 f4             	pushl  -0xc(%ebp)
  1006cb:	e8 c4 fd ff ff       	call   100494 <stab_binsearch>
  1006d0:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d9:	39 c2                	cmp    %eax,%edx
  1006db:	7f 7c                	jg     100759 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e0:	89 c2                	mov    %eax,%edx
  1006e2:	89 d0                	mov    %edx,%eax
  1006e4:	01 c0                	add    %eax,%eax
  1006e6:	01 d0                	add    %edx,%eax
  1006e8:	c1 e0 02             	shl    $0x2,%eax
  1006eb:	89 c2                	mov    %eax,%edx
  1006ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f0:	01 d0                	add    %edx,%eax
  1006f2:	8b 00                	mov    (%eax),%eax
  1006f4:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006fa:	29 d1                	sub    %edx,%ecx
  1006fc:	89 ca                	mov    %ecx,%edx
  1006fe:	39 d0                	cmp    %edx,%eax
  100700:	73 22                	jae    100724 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100705:	89 c2                	mov    %eax,%edx
  100707:	89 d0                	mov    %edx,%eax
  100709:	01 c0                	add    %eax,%eax
  10070b:	01 d0                	add    %edx,%eax
  10070d:	c1 e0 02             	shl    $0x2,%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	8b 10                	mov    (%eax),%edx
  100719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10071c:	01 c2                	add    %eax,%edx
  10071e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100721:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100727:	89 c2                	mov    %eax,%edx
  100729:	89 d0                	mov    %edx,%eax
  10072b:	01 c0                	add    %eax,%eax
  10072d:	01 d0                	add    %edx,%eax
  10072f:	c1 e0 02             	shl    $0x2,%eax
  100732:	89 c2                	mov    %eax,%edx
  100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	8b 50 08             	mov    0x8(%eax),%edx
  10073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073f:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100742:	8b 45 0c             	mov    0xc(%ebp),%eax
  100745:	8b 40 10             	mov    0x10(%eax),%eax
  100748:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10074b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100751:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100754:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100757:	eb 15                	jmp    10076e <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100759:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075c:	8b 55 08             	mov    0x8(%ebp),%edx
  10075f:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100765:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100768:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10076b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100771:	8b 40 08             	mov    0x8(%eax),%eax
  100774:	83 ec 08             	sub    $0x8,%esp
  100777:	6a 3a                	push   $0x3a
  100779:	50                   	push   %eax
  10077a:	e8 8e 4b 00 00       	call   10530d <strfind>
  10077f:	83 c4 10             	add    $0x10,%esp
  100782:	89 c2                	mov    %eax,%edx
  100784:	8b 45 0c             	mov    0xc(%ebp),%eax
  100787:	8b 40 08             	mov    0x8(%eax),%eax
  10078a:	29 c2                	sub    %eax,%edx
  10078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078f:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100792:	83 ec 0c             	sub    $0xc,%esp
  100795:	ff 75 08             	pushl  0x8(%ebp)
  100798:	6a 44                	push   $0x44
  10079a:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10079d:	50                   	push   %eax
  10079e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007a1:	50                   	push   %eax
  1007a2:	ff 75 f4             	pushl  -0xc(%ebp)
  1007a5:	e8 ea fc ff ff       	call   100494 <stab_binsearch>
  1007aa:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b3:	39 c2                	cmp    %eax,%edx
  1007b5:	7f 24                	jg     1007db <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ba:	89 c2                	mov    %eax,%edx
  1007bc:	89 d0                	mov    %edx,%eax
  1007be:	01 c0                	add    %eax,%eax
  1007c0:	01 d0                	add    %edx,%eax
  1007c2:	c1 e0 02             	shl    $0x2,%eax
  1007c5:	89 c2                	mov    %eax,%edx
  1007c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ca:	01 d0                	add    %edx,%eax
  1007cc:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007d0:	0f b7 d0             	movzwl %ax,%edx
  1007d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d6:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d9:	eb 13                	jmp    1007ee <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007e0:	e9 12 01 00 00       	jmp    1008f7 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e8:	83 e8 01             	sub    $0x1,%eax
  1007eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f4:	39 c2                	cmp    %eax,%edx
  1007f6:	7c 56                	jl     10084e <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007fb:	89 c2                	mov    %eax,%edx
  1007fd:	89 d0                	mov    %edx,%eax
  1007ff:	01 c0                	add    %eax,%eax
  100801:	01 d0                	add    %edx,%eax
  100803:	c1 e0 02             	shl    $0x2,%eax
  100806:	89 c2                	mov    %eax,%edx
  100808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080b:	01 d0                	add    %edx,%eax
  10080d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100811:	3c 84                	cmp    $0x84,%al
  100813:	74 39                	je     10084e <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	89 d0                	mov    %edx,%eax
  10081c:	01 c0                	add    %eax,%eax
  10081e:	01 d0                	add    %edx,%eax
  100820:	c1 e0 02             	shl    $0x2,%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100828:	01 d0                	add    %edx,%eax
  10082a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082e:	3c 64                	cmp    $0x64,%al
  100830:	75 b3                	jne    1007e5 <debuginfo_eip+0x1fa>
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	8b 40 08             	mov    0x8(%eax),%eax
  10084a:	85 c0                	test   %eax,%eax
  10084c:	74 97                	je     1007e5 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100854:	39 c2                	cmp    %eax,%edx
  100856:	7c 46                	jl     10089e <debuginfo_eip+0x2b3>
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	8b 00                	mov    (%eax),%eax
  10086f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100872:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100875:	29 d1                	sub    %edx,%ecx
  100877:	89 ca                	mov    %ecx,%edx
  100879:	39 d0                	cmp    %edx,%eax
  10087b:	73 21                	jae    10089e <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10087d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100880:	89 c2                	mov    %eax,%edx
  100882:	89 d0                	mov    %edx,%eax
  100884:	01 c0                	add    %eax,%eax
  100886:	01 d0                	add    %edx,%eax
  100888:	c1 e0 02             	shl    $0x2,%eax
  10088b:	89 c2                	mov    %eax,%edx
  10088d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100890:	01 d0                	add    %edx,%eax
  100892:	8b 10                	mov    (%eax),%edx
  100894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100897:	01 c2                	add    %eax,%edx
  100899:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089c:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10089e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008a4:	39 c2                	cmp    %eax,%edx
  1008a6:	7d 4a                	jge    1008f2 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008ab:	83 c0 01             	add    $0x1,%eax
  1008ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008b1:	eb 18                	jmp    1008cb <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b6:	8b 40 14             	mov    0x14(%eax),%eax
  1008b9:	8d 50 01             	lea    0x1(%eax),%edx
  1008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008bf:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c5:	83 c0 01             	add    $0x1,%eax
  1008c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008d1:	39 c2                	cmp    %eax,%edx
  1008d3:	7d 1d                	jge    1008f2 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d8:	89 c2                	mov    %eax,%edx
  1008da:	89 d0                	mov    %edx,%eax
  1008dc:	01 c0                	add    %eax,%eax
  1008de:	01 d0                	add    %edx,%eax
  1008e0:	c1 e0 02             	shl    $0x2,%eax
  1008e3:	89 c2                	mov    %eax,%edx
  1008e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e8:	01 d0                	add    %edx,%eax
  1008ea:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ee:	3c a0                	cmp    $0xa0,%al
  1008f0:	74 c1                	je     1008b3 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008f7:	c9                   	leave  
  1008f8:	c3                   	ret    

001008f9 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f9:	55                   	push   %ebp
  1008fa:	89 e5                	mov    %esp,%ebp
  1008fc:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008ff:	83 ec 0c             	sub    $0xc,%esp
  100902:	68 32 5d 10 00       	push   $0x105d32
  100907:	e8 63 f9 ff ff       	call   10026f <cprintf>
  10090c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10090f:	83 ec 08             	sub    $0x8,%esp
  100912:	68 2a 00 10 00       	push   $0x10002a
  100917:	68 4b 5d 10 00       	push   $0x105d4b
  10091c:	e8 4e f9 ff ff       	call   10026f <cprintf>
  100921:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100924:	83 ec 08             	sub    $0x8,%esp
  100927:	68 30 5c 10 00       	push   $0x105c30
  10092c:	68 63 5d 10 00       	push   $0x105d63
  100931:	e8 39 f9 ff ff       	call   10026f <cprintf>
  100936:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100939:	83 ec 08             	sub    $0x8,%esp
  10093c:	68 36 7a 11 00       	push   $0x117a36
  100941:	68 7b 5d 10 00       	push   $0x105d7b
  100946:	e8 24 f9 ff ff       	call   10026f <cprintf>
  10094b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10094e:	83 ec 08             	sub    $0x8,%esp
  100951:	68 c8 89 11 00       	push   $0x1189c8
  100956:	68 93 5d 10 00       	push   $0x105d93
  10095b:	e8 0f f9 ff ff       	call   10026f <cprintf>
  100960:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100963:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  100968:	05 ff 03 00 00       	add    $0x3ff,%eax
  10096d:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  100972:	29 d0                	sub    %edx,%eax
  100974:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097a:	85 c0                	test   %eax,%eax
  10097c:	0f 48 c2             	cmovs  %edx,%eax
  10097f:	c1 f8 0a             	sar    $0xa,%eax
  100982:	83 ec 08             	sub    $0x8,%esp
  100985:	50                   	push   %eax
  100986:	68 ac 5d 10 00       	push   $0x105dac
  10098b:	e8 df f8 ff ff       	call   10026f <cprintf>
  100990:	83 c4 10             	add    $0x10,%esp
}
  100993:	90                   	nop
  100994:	c9                   	leave  
  100995:	c3                   	ret    

00100996 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100996:	55                   	push   %ebp
  100997:	89 e5                	mov    %esp,%ebp
  100999:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10099f:	83 ec 08             	sub    $0x8,%esp
  1009a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009a5:	50                   	push   %eax
  1009a6:	ff 75 08             	pushl  0x8(%ebp)
  1009a9:	e8 3d fc ff ff       	call   1005eb <debuginfo_eip>
  1009ae:	83 c4 10             	add    $0x10,%esp
  1009b1:	85 c0                	test   %eax,%eax
  1009b3:	74 15                	je     1009ca <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009b5:	83 ec 08             	sub    $0x8,%esp
  1009b8:	ff 75 08             	pushl  0x8(%ebp)
  1009bb:	68 d6 5d 10 00       	push   $0x105dd6
  1009c0:	e8 aa f8 ff ff       	call   10026f <cprintf>
  1009c5:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c8:	eb 65                	jmp    100a2f <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009d1:	eb 1c                	jmp    1009ef <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d9:	01 d0                	add    %edx,%eax
  1009db:	0f b6 00             	movzbl (%eax),%eax
  1009de:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009e7:	01 ca                	add    %ecx,%edx
  1009e9:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009f5:	7f dc                	jg     1009d3 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009f7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a00:	01 d0                	add    %edx,%eax
  100a02:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a08:	8b 55 08             	mov    0x8(%ebp),%edx
  100a0b:	89 d1                	mov    %edx,%ecx
  100a0d:	29 c1                	sub    %eax,%ecx
  100a0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a15:	83 ec 0c             	sub    $0xc,%esp
  100a18:	51                   	push   %ecx
  100a19:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1f:	51                   	push   %ecx
  100a20:	52                   	push   %edx
  100a21:	50                   	push   %eax
  100a22:	68 f2 5d 10 00       	push   $0x105df2
  100a27:	e8 43 f8 ff ff       	call   10026f <cprintf>
  100a2c:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a2f:	90                   	nop
  100a30:	c9                   	leave  
  100a31:	c3                   	ret    

00100a32 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a32:	55                   	push   %ebp
  100a33:	89 e5                	mov    %esp,%ebp
  100a35:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a38:	8b 45 04             	mov    0x4(%ebp),%eax
  100a3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a41:	c9                   	leave  
  100a42:	c3                   	ret    

00100a43 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a43:	55                   	push   %ebp
  100a44:	89 e5                	mov    %esp,%ebp
  100a46:	53                   	push   %ebx
  100a47:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a4a:	89 e8                	mov    %ebp,%eax
  100a4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
  100a52:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
  100a55:	e8 d8 ff ff ff       	call   100a32 <read_eip>
  100a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100a5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a64:	e9 93 00 00 00       	jmp    100afc <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
  100a69:	83 ec 04             	sub    $0x4,%esp
  100a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  100a6f:	ff 75 f4             	pushl  -0xc(%ebp)
  100a72:	68 04 5e 10 00       	push   $0x105e04
  100a77:	e8 f3 f7 ff ff       	call   10026f <cprintf>
  100a7c:	83 c4 10             	add    $0x10,%esp

        // get args
        for (int j = 0; j < 4; j++) {
  100a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a86:	eb 1f                	jmp    100aa7 <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
  100a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a95:	01 d0                	add    %edx,%eax
  100a97:	83 c0 08             	add    $0x8,%eax
  100a9a:	8b 10                	mov    (%eax),%edx
  100a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a9f:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);

        // get args
        for (int j = 0; j < 4; j++) {
  100aa3:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aa7:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100aab:	7e db                	jle    100a88 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
  100aad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100ab0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100ab3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100ab6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100ab9:	83 ec 0c             	sub    $0xc,%esp
  100abc:	53                   	push   %ebx
  100abd:	51                   	push   %ecx
  100abe:	52                   	push   %edx
  100abf:	50                   	push   %eax
  100ac0:	68 1c 5e 10 00       	push   $0x105e1c
  100ac5:	e8 a5 f7 ff ff       	call   10026f <cprintf>
  100aca:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);

        // print function info
        print_debuginfo(stack_val_eip - 1);
  100acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad0:	83 e8 01             	sub    $0x1,%eax
  100ad3:	83 ec 0c             	sub    $0xc,%esp
  100ad6:	50                   	push   %eax
  100ad7:	e8 ba fe ff ff       	call   100996 <print_debuginfo>
  100adc:	83 c4 10             	add    $0x10,%esp

        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
  100adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae2:	83 c0 04             	add    $0x4,%eax
  100ae5:	8b 00                	mov    (%eax),%eax
  100ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
  100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aed:	8b 00                	mov    (%eax),%eax
  100aef:	89 45 f4             	mov    %eax,-0xc(%ebp)

        // ebp should be valid
        if (stack_val_ebp <= 0) {
  100af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100af6:	74 10                	je     100b08 <print_stackframe+0xc5>
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100af8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100afc:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b00:	0f 8e 63 ff ff ff    	jle    100a69 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
  100b06:	eb 01                	jmp    100b09 <print_stackframe+0xc6>
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));

        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
  100b08:	90                   	nop
        }
    }
}
  100b09:	90                   	nop
  100b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b0d:	c9                   	leave  
  100b0e:	c3                   	ret    

00100b0f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b0f:	55                   	push   %ebp
  100b10:	89 e5                	mov    %esp,%ebp
  100b12:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b1c:	eb 0c                	jmp    100b2a <parse+0x1b>
            *buf ++ = '\0';
  100b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b21:	8d 50 01             	lea    0x1(%eax),%edx
  100b24:	89 55 08             	mov    %edx,0x8(%ebp)
  100b27:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2d:	0f b6 00             	movzbl (%eax),%eax
  100b30:	84 c0                	test   %al,%al
  100b32:	74 1e                	je     100b52 <parse+0x43>
  100b34:	8b 45 08             	mov    0x8(%ebp),%eax
  100b37:	0f b6 00             	movzbl (%eax),%eax
  100b3a:	0f be c0             	movsbl %al,%eax
  100b3d:	83 ec 08             	sub    $0x8,%esp
  100b40:	50                   	push   %eax
  100b41:	68 c0 5e 10 00       	push   $0x105ec0
  100b46:	e8 8f 47 00 00       	call   1052da <strchr>
  100b4b:	83 c4 10             	add    $0x10,%esp
  100b4e:	85 c0                	test   %eax,%eax
  100b50:	75 cc                	jne    100b1e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b52:	8b 45 08             	mov    0x8(%ebp),%eax
  100b55:	0f b6 00             	movzbl (%eax),%eax
  100b58:	84 c0                	test   %al,%al
  100b5a:	74 69                	je     100bc5 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b5c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b60:	75 12                	jne    100b74 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b62:	83 ec 08             	sub    $0x8,%esp
  100b65:	6a 10                	push   $0x10
  100b67:	68 c5 5e 10 00       	push   $0x105ec5
  100b6c:	e8 fe f6 ff ff       	call   10026f <cprintf>
  100b71:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b77:	8d 50 01             	lea    0x1(%eax),%edx
  100b7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b87:	01 c2                	add    %eax,%edx
  100b89:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b8e:	eb 04                	jmp    100b94 <parse+0x85>
            buf ++;
  100b90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b94:	8b 45 08             	mov    0x8(%ebp),%eax
  100b97:	0f b6 00             	movzbl (%eax),%eax
  100b9a:	84 c0                	test   %al,%al
  100b9c:	0f 84 7a ff ff ff    	je     100b1c <parse+0xd>
  100ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba5:	0f b6 00             	movzbl (%eax),%eax
  100ba8:	0f be c0             	movsbl %al,%eax
  100bab:	83 ec 08             	sub    $0x8,%esp
  100bae:	50                   	push   %eax
  100baf:	68 c0 5e 10 00       	push   $0x105ec0
  100bb4:	e8 21 47 00 00       	call   1052da <strchr>
  100bb9:	83 c4 10             	add    $0x10,%esp
  100bbc:	85 c0                	test   %eax,%eax
  100bbe:	74 d0                	je     100b90 <parse+0x81>
            buf ++;
        }
    }
  100bc0:	e9 57 ff ff ff       	jmp    100b1c <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100bc5:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bc9:	c9                   	leave  
  100bca:	c3                   	ret    

00100bcb <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bcb:	55                   	push   %ebp
  100bcc:	89 e5                	mov    %esp,%ebp
  100bce:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bd1:	83 ec 08             	sub    $0x8,%esp
  100bd4:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bd7:	50                   	push   %eax
  100bd8:	ff 75 08             	pushl  0x8(%ebp)
  100bdb:	e8 2f ff ff ff       	call   100b0f <parse>
  100be0:	83 c4 10             	add    $0x10,%esp
  100be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bea:	75 0a                	jne    100bf6 <runcmd+0x2b>
        return 0;
  100bec:	b8 00 00 00 00       	mov    $0x0,%eax
  100bf1:	e9 83 00 00 00       	jmp    100c79 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bfd:	eb 59                	jmp    100c58 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bff:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c05:	89 d0                	mov    %edx,%eax
  100c07:	01 c0                	add    %eax,%eax
  100c09:	01 d0                	add    %edx,%eax
  100c0b:	c1 e0 02             	shl    $0x2,%eax
  100c0e:	05 20 70 11 00       	add    $0x117020,%eax
  100c13:	8b 00                	mov    (%eax),%eax
  100c15:	83 ec 08             	sub    $0x8,%esp
  100c18:	51                   	push   %ecx
  100c19:	50                   	push   %eax
  100c1a:	e8 1b 46 00 00       	call   10523a <strcmp>
  100c1f:	83 c4 10             	add    $0x10,%esp
  100c22:	85 c0                	test   %eax,%eax
  100c24:	75 2e                	jne    100c54 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c29:	89 d0                	mov    %edx,%eax
  100c2b:	01 c0                	add    %eax,%eax
  100c2d:	01 d0                	add    %edx,%eax
  100c2f:	c1 e0 02             	shl    $0x2,%eax
  100c32:	05 28 70 11 00       	add    $0x117028,%eax
  100c37:	8b 10                	mov    (%eax),%edx
  100c39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c3c:	83 c0 04             	add    $0x4,%eax
  100c3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c42:	83 e9 01             	sub    $0x1,%ecx
  100c45:	83 ec 04             	sub    $0x4,%esp
  100c48:	ff 75 0c             	pushl  0xc(%ebp)
  100c4b:	50                   	push   %eax
  100c4c:	51                   	push   %ecx
  100c4d:	ff d2                	call   *%edx
  100c4f:	83 c4 10             	add    $0x10,%esp
  100c52:	eb 25                	jmp    100c79 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5b:	83 f8 02             	cmp    $0x2,%eax
  100c5e:	76 9f                	jbe    100bff <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c60:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c63:	83 ec 08             	sub    $0x8,%esp
  100c66:	50                   	push   %eax
  100c67:	68 e3 5e 10 00       	push   $0x105ee3
  100c6c:	e8 fe f5 ff ff       	call   10026f <cprintf>
  100c71:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c79:	c9                   	leave  
  100c7a:	c3                   	ret    

00100c7b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c7b:	55                   	push   %ebp
  100c7c:	89 e5                	mov    %esp,%ebp
  100c7e:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c81:	83 ec 0c             	sub    $0xc,%esp
  100c84:	68 fc 5e 10 00       	push   $0x105efc
  100c89:	e8 e1 f5 ff ff       	call   10026f <cprintf>
  100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c91:	83 ec 0c             	sub    $0xc,%esp
  100c94:	68 24 5f 10 00       	push   $0x105f24
  100c99:	e8 d1 f5 ff ff       	call   10026f <cprintf>
  100c9e:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ca5:	74 0e                	je     100cb5 <kmonitor+0x3a>
        print_trapframe(tf);
  100ca7:	83 ec 0c             	sub    $0xc,%esp
  100caa:	ff 75 08             	pushl  0x8(%ebp)
  100cad:	e8 bf 0d 00 00       	call   101a71 <print_trapframe>
  100cb2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cb5:	83 ec 0c             	sub    $0xc,%esp
  100cb8:	68 49 5f 10 00       	push   $0x105f49
  100cbd:	e8 51 f6 ff ff       	call   100313 <readline>
  100cc2:	83 c4 10             	add    $0x10,%esp
  100cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ccc:	74 e7                	je     100cb5 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cce:	83 ec 08             	sub    $0x8,%esp
  100cd1:	ff 75 08             	pushl  0x8(%ebp)
  100cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  100cd7:	e8 ef fe ff ff       	call   100bcb <runcmd>
  100cdc:	83 c4 10             	add    $0x10,%esp
  100cdf:	85 c0                	test   %eax,%eax
  100ce1:	78 02                	js     100ce5 <kmonitor+0x6a>
                break;
            }
        }
    }
  100ce3:	eb d0                	jmp    100cb5 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100ce5:	90                   	nop
            }
        }
    }
}
  100ce6:	90                   	nop
  100ce7:	c9                   	leave  
  100ce8:	c3                   	ret    

00100ce9 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100ce9:	55                   	push   %ebp
  100cea:	89 e5                	mov    %esp,%ebp
  100cec:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cf6:	eb 3c                	jmp    100d34 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfb:	89 d0                	mov    %edx,%eax
  100cfd:	01 c0                	add    %eax,%eax
  100cff:	01 d0                	add    %edx,%eax
  100d01:	c1 e0 02             	shl    $0x2,%eax
  100d04:	05 24 70 11 00       	add    $0x117024,%eax
  100d09:	8b 08                	mov    (%eax),%ecx
  100d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d0e:	89 d0                	mov    %edx,%eax
  100d10:	01 c0                	add    %eax,%eax
  100d12:	01 d0                	add    %edx,%eax
  100d14:	c1 e0 02             	shl    $0x2,%eax
  100d17:	05 20 70 11 00       	add    $0x117020,%eax
  100d1c:	8b 00                	mov    (%eax),%eax
  100d1e:	83 ec 04             	sub    $0x4,%esp
  100d21:	51                   	push   %ecx
  100d22:	50                   	push   %eax
  100d23:	68 4d 5f 10 00       	push   $0x105f4d
  100d28:	e8 42 f5 ff ff       	call   10026f <cprintf>
  100d2d:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d37:	83 f8 02             	cmp    $0x2,%eax
  100d3a:	76 bc                	jbe    100cf8 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d41:	c9                   	leave  
  100d42:	c3                   	ret    

00100d43 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d43:	55                   	push   %ebp
  100d44:	89 e5                	mov    %esp,%ebp
  100d46:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d49:	e8 ab fb ff ff       	call   1008f9 <print_kerninfo>
    return 0;
  100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d53:	c9                   	leave  
  100d54:	c3                   	ret    

00100d55 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d55:	55                   	push   %ebp
  100d56:	89 e5                	mov    %esp,%ebp
  100d58:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d5b:	e8 e3 fc ff ff       	call   100a43 <print_stackframe>
    return 0;
  100d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d65:	c9                   	leave  
  100d66:	c3                   	ret    

00100d67 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d67:	55                   	push   %ebp
  100d68:	89 e5                	mov    %esp,%ebp
  100d6a:	83 ec 18             	sub    $0x18,%esp
  100d6d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d73:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d77:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7f:	ee                   	out    %al,(%dx)
  100d80:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d86:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d8a:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d8e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d92:	ee                   	out    %al,(%dx)
  100d93:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d99:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d9d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da6:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db0:	83 ec 0c             	sub    $0xc,%esp
  100db3:	68 56 5f 10 00       	push   $0x105f56
  100db8:	e8 b2 f4 ff ff       	call   10026f <cprintf>
  100dbd:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100dc0:	83 ec 0c             	sub    $0xc,%esp
  100dc3:	6a 00                	push   $0x0
  100dc5:	e8 3b 09 00 00       	call   101705 <pic_enable>
  100dca:	83 c4 10             	add    $0x10,%esp
}
  100dcd:	90                   	nop
  100dce:	c9                   	leave  
  100dcf:	c3                   	ret    

00100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dd0:	55                   	push   %ebp
  100dd1:	89 e5                	mov    %esp,%ebp
  100dd3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dd6:	9c                   	pushf  
  100dd7:	58                   	pop    %eax
  100dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dde:	25 00 02 00 00       	and    $0x200,%eax
  100de3:	85 c0                	test   %eax,%eax
  100de5:	74 0c                	je     100df3 <__intr_save+0x23>
        intr_disable();
  100de7:	e8 8a 0a 00 00       	call   101876 <intr_disable>
        return 1;
  100dec:	b8 01 00 00 00       	mov    $0x1,%eax
  100df1:	eb 05                	jmp    100df8 <__intr_save+0x28>
    }
    return 0;
  100df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df8:	c9                   	leave  
  100df9:	c3                   	ret    

00100dfa <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100dfa:	55                   	push   %ebp
  100dfb:	89 e5                	mov    %esp,%ebp
  100dfd:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e04:	74 05                	je     100e0b <__intr_restore+0x11>
        intr_enable();
  100e06:	e8 64 0a 00 00       	call   10186f <intr_enable>
    }
}
  100e0b:	90                   	nop
  100e0c:	c9                   	leave  
  100e0d:	c3                   	ret    

00100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e0e:	55                   	push   %ebp
  100e0f:	89 e5                	mov    %esp,%ebp
  100e11:	83 ec 10             	sub    $0x10,%esp
  100e14:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e1a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e1e:	89 c2                	mov    %eax,%edx
  100e20:	ec                   	in     (%dx),%al
  100e21:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e24:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e2a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100e2e:	89 c2                	mov    %eax,%edx
  100e30:	ec                   	in     (%dx),%al
  100e31:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e34:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e3e:	89 c2                	mov    %eax,%edx
  100e40:	ec                   	in     (%dx),%al
  100e41:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e44:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e4a:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100e4e:	89 c2                	mov    %eax,%edx
  100e50:	ec                   	in     (%dx),%al
  100e51:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e54:	90                   	nop
  100e55:	c9                   	leave  
  100e56:	c3                   	ret    

00100e57 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e57:	55                   	push   %ebp
  100e58:	89 e5                	mov    %esp,%ebp
  100e5a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e5d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e67:	0f b7 00             	movzwl (%eax),%eax
  100e6a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e71:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e79:	0f b7 00             	movzwl (%eax),%eax
  100e7c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e80:	74 12                	je     100e94 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e82:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e89:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e90:	b4 03 
  100e92:	eb 13                	jmp    100ea7 <cga_init+0x50>
    } else {
        *cp = was;
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e9b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e9e:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ea5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ea7:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eae:	0f b7 c0             	movzwl %ax,%eax
  100eb1:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100eb5:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eb9:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100ebd:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100ec1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ec2:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec9:	83 c0 01             	add    $0x1,%eax
  100ecc:	0f b7 c0             	movzwl %ax,%eax
  100ecf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ed3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ed7:	89 c2                	mov    %eax,%edx
  100ed9:	ec                   	in     (%dx),%al
  100eda:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100edd:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100ee1:	0f b6 c0             	movzbl %al,%eax
  100ee4:	c1 e0 08             	shl    $0x8,%eax
  100ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eea:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ef1:	0f b7 c0             	movzwl %ax,%eax
  100ef4:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ef8:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100efc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100f00:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f04:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f05:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0c:	83 c0 01             	add    $0x1,%eax
  100f0f:	0f b7 c0             	movzwl %ax,%eax
  100f12:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f16:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f1a:	89 c2                	mov    %eax,%edx
  100f1c:	ec                   	in     (%dx),%al
  100f1d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f20:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f24:	0f b6 c0             	movzbl %al,%eax
  100f27:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2d:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f35:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f3b:	90                   	nop
  100f3c:	c9                   	leave  
  100f3d:	c3                   	ret    

00100f3e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f3e:	55                   	push   %ebp
  100f3f:	89 e5                	mov    %esp,%ebp
  100f41:	83 ec 28             	sub    $0x28,%esp
  100f44:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f4a:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4e:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f52:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f56:	ee                   	out    %al,(%dx)
  100f57:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f5d:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f61:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f65:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f69:	ee                   	out    %al,(%dx)
  100f6a:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f70:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f74:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f78:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7c:	ee                   	out    %al,(%dx)
  100f7d:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f83:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f87:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f8b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f8f:	ee                   	out    %al,(%dx)
  100f90:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f96:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f9a:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f9e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
  100fa3:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100fa9:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100fad:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100fb1:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100fb5:	ee                   	out    %al,(%dx)
  100fb6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fbc:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100fc0:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100fc4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fc8:	ee                   	out    %al,(%dx)
  100fc9:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fcf:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100fd3:	89 c2                	mov    %eax,%edx
  100fd5:	ec                   	in     (%dx),%al
  100fd6:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fd9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fdd:	3c ff                	cmp    $0xff,%al
  100fdf:	0f 95 c0             	setne  %al
  100fe2:	0f b6 c0             	movzbl %al,%eax
  100fe5:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fea:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ff4:	89 c2                	mov    %eax,%edx
  100ff6:	ec                   	in     (%dx),%al
  100ff7:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100ffa:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  101000:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  101004:	89 c2                	mov    %eax,%edx
  101006:	ec                   	in     (%dx),%al
  101007:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10100a:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10100f:	85 c0                	test   %eax,%eax
  101011:	74 0d                	je     101020 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  101013:	83 ec 0c             	sub    $0xc,%esp
  101016:	6a 04                	push   $0x4
  101018:	e8 e8 06 00 00       	call   101705 <pic_enable>
  10101d:	83 c4 10             	add    $0x10,%esp
    }
}
  101020:	90                   	nop
  101021:	c9                   	leave  
  101022:	c3                   	ret    

00101023 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101023:	55                   	push   %ebp
  101024:	89 e5                	mov    %esp,%ebp
  101026:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101030:	eb 09                	jmp    10103b <lpt_putc_sub+0x18>
        delay();
  101032:	e8 d7 fd ff ff       	call   100e0e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101037:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10103b:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  101041:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101045:	89 c2                	mov    %eax,%edx
  101047:	ec                   	in     (%dx),%al
  101048:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  10104b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10104f:	84 c0                	test   %al,%al
  101051:	78 09                	js     10105c <lpt_putc_sub+0x39>
  101053:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10105a:	7e d6                	jle    101032 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10105c:	8b 45 08             	mov    0x8(%ebp),%eax
  10105f:	0f b6 c0             	movzbl %al,%eax
  101062:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101068:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10106b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10106f:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101073:	ee                   	out    %al,(%dx)
  101074:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10107a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10107e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101082:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101086:	ee                   	out    %al,(%dx)
  101087:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10108d:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101091:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101095:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101099:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10109a:	90                   	nop
  10109b:	c9                   	leave  
  10109c:	c3                   	ret    

0010109d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10109d:	55                   	push   %ebp
  10109e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1010a0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a4:	74 0d                	je     1010b3 <lpt_putc+0x16>
        lpt_putc_sub(c);
  1010a6:	ff 75 08             	pushl  0x8(%ebp)
  1010a9:	e8 75 ff ff ff       	call   101023 <lpt_putc_sub>
  1010ae:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010b1:	eb 1e                	jmp    1010d1 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  1010b3:	6a 08                	push   $0x8
  1010b5:	e8 69 ff ff ff       	call   101023 <lpt_putc_sub>
  1010ba:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010bd:	6a 20                	push   $0x20
  1010bf:	e8 5f ff ff ff       	call   101023 <lpt_putc_sub>
  1010c4:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010c7:	6a 08                	push   $0x8
  1010c9:	e8 55 ff ff ff       	call   101023 <lpt_putc_sub>
  1010ce:	83 c4 04             	add    $0x4,%esp
    }
}
  1010d1:	90                   	nop
  1010d2:	c9                   	leave  
  1010d3:	c3                   	ret    

001010d4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010d4:	55                   	push   %ebp
  1010d5:	89 e5                	mov    %esp,%ebp
  1010d7:	53                   	push   %ebx
  1010d8:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010db:	8b 45 08             	mov    0x8(%ebp),%eax
  1010de:	b0 00                	mov    $0x0,%al
  1010e0:	85 c0                	test   %eax,%eax
  1010e2:	75 07                	jne    1010eb <cga_putc+0x17>
        c |= 0x0700;
  1010e4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ee:	0f b6 c0             	movzbl %al,%eax
  1010f1:	83 f8 0a             	cmp    $0xa,%eax
  1010f4:	74 4e                	je     101144 <cga_putc+0x70>
  1010f6:	83 f8 0d             	cmp    $0xd,%eax
  1010f9:	74 59                	je     101154 <cga_putc+0x80>
  1010fb:	83 f8 08             	cmp    $0x8,%eax
  1010fe:	0f 85 8a 00 00 00    	jne    10118e <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  101104:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10110b:	66 85 c0             	test   %ax,%ax
  10110e:	0f 84 a0 00 00 00    	je     1011b4 <cga_putc+0xe0>
            crt_pos --;
  101114:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10111b:	83 e8 01             	sub    $0x1,%eax
  10111e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101124:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101129:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101130:	0f b7 d2             	movzwl %dx,%edx
  101133:	01 d2                	add    %edx,%edx
  101135:	01 d0                	add    %edx,%eax
  101137:	8b 55 08             	mov    0x8(%ebp),%edx
  10113a:	b2 00                	mov    $0x0,%dl
  10113c:	83 ca 20             	or     $0x20,%edx
  10113f:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101142:	eb 70                	jmp    1011b4 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  101144:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10114b:	83 c0 50             	add    $0x50,%eax
  10114e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101154:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10115b:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101162:	0f b7 c1             	movzwl %cx,%eax
  101165:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10116b:	c1 e8 10             	shr    $0x10,%eax
  10116e:	89 c2                	mov    %eax,%edx
  101170:	66 c1 ea 06          	shr    $0x6,%dx
  101174:	89 d0                	mov    %edx,%eax
  101176:	c1 e0 02             	shl    $0x2,%eax
  101179:	01 d0                	add    %edx,%eax
  10117b:	c1 e0 04             	shl    $0x4,%eax
  10117e:	29 c1                	sub    %eax,%ecx
  101180:	89 ca                	mov    %ecx,%edx
  101182:	89 d8                	mov    %ebx,%eax
  101184:	29 d0                	sub    %edx,%eax
  101186:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  10118c:	eb 27                	jmp    1011b5 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10118e:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  101194:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10119b:	8d 50 01             	lea    0x1(%eax),%edx
  10119e:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011a5:	0f b7 c0             	movzwl %ax,%eax
  1011a8:	01 c0                	add    %eax,%eax
  1011aa:	01 c8                	add    %ecx,%eax
  1011ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1011af:	66 89 10             	mov    %dx,(%eax)
        break;
  1011b2:	eb 01                	jmp    1011b5 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1011b4:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011b5:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011bc:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011c0:	76 59                	jbe    10121b <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011c2:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011c7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011cd:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011d2:	83 ec 04             	sub    $0x4,%esp
  1011d5:	68 00 0f 00 00       	push   $0xf00
  1011da:	52                   	push   %edx
  1011db:	50                   	push   %eax
  1011dc:	e8 f8 42 00 00       	call   1054d9 <memmove>
  1011e1:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011e4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011eb:	eb 15                	jmp    101202 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1011ed:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011f5:	01 d2                	add    %edx,%edx
  1011f7:	01 d0                	add    %edx,%eax
  1011f9:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101202:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101209:	7e e2                	jle    1011ed <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10120b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101212:	83 e8 50             	sub    $0x50,%eax
  101215:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10121b:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101222:	0f b7 c0             	movzwl %ax,%eax
  101225:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101229:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10122d:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  101231:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101235:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101236:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10123d:	66 c1 e8 08          	shr    $0x8,%ax
  101241:	0f b6 c0             	movzbl %al,%eax
  101244:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10124b:	83 c2 01             	add    $0x1,%edx
  10124e:	0f b7 d2             	movzwl %dx,%edx
  101251:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101255:	88 45 e9             	mov    %al,-0x17(%ebp)
  101258:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10125c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101260:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101261:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101268:	0f b7 c0             	movzwl %ax,%eax
  10126b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10126f:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101273:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10127c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101283:	0f b6 c0             	movzbl %al,%eax
  101286:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10128d:	83 c2 01             	add    $0x1,%edx
  101290:	0f b7 d2             	movzwl %dx,%edx
  101293:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101297:	88 45 eb             	mov    %al,-0x15(%ebp)
  10129a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10129e:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1012a2:	ee                   	out    %al,(%dx)
}
  1012a3:	90                   	nop
  1012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012a7:	c9                   	leave  
  1012a8:	c3                   	ret    

001012a9 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012a9:	55                   	push   %ebp
  1012aa:	89 e5                	mov    %esp,%ebp
  1012ac:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012b6:	eb 09                	jmp    1012c1 <serial_putc_sub+0x18>
        delay();
  1012b8:	e8 51 fb ff ff       	call   100e0e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012c1:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012c7:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1012cb:	89 c2                	mov    %eax,%edx
  1012cd:	ec                   	in     (%dx),%al
  1012ce:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012d5:	0f b6 c0             	movzbl %al,%eax
  1012d8:	83 e0 20             	and    $0x20,%eax
  1012db:	85 c0                	test   %eax,%eax
  1012dd:	75 09                	jne    1012e8 <serial_putc_sub+0x3f>
  1012df:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012e6:	7e d0                	jle    1012b8 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012f4:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f7:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012fb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012ff:	ee                   	out    %al,(%dx)
}
  101300:	90                   	nop
  101301:	c9                   	leave  
  101302:	c3                   	ret    

00101303 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101303:	55                   	push   %ebp
  101304:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101306:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10130a:	74 0d                	je     101319 <serial_putc+0x16>
        serial_putc_sub(c);
  10130c:	ff 75 08             	pushl  0x8(%ebp)
  10130f:	e8 95 ff ff ff       	call   1012a9 <serial_putc_sub>
  101314:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101317:	eb 1e                	jmp    101337 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  101319:	6a 08                	push   $0x8
  10131b:	e8 89 ff ff ff       	call   1012a9 <serial_putc_sub>
  101320:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101323:	6a 20                	push   $0x20
  101325:	e8 7f ff ff ff       	call   1012a9 <serial_putc_sub>
  10132a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10132d:	6a 08                	push   $0x8
  10132f:	e8 75 ff ff ff       	call   1012a9 <serial_putc_sub>
  101334:	83 c4 04             	add    $0x4,%esp
    }
}
  101337:	90                   	nop
  101338:	c9                   	leave  
  101339:	c3                   	ret    

0010133a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10133a:	55                   	push   %ebp
  10133b:	89 e5                	mov    %esp,%ebp
  10133d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101340:	eb 33                	jmp    101375 <cons_intr+0x3b>
        if (c != 0) {
  101342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101346:	74 2d                	je     101375 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101348:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10134d:	8d 50 01             	lea    0x1(%eax),%edx
  101350:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101359:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10135f:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101364:	3d 00 02 00 00       	cmp    $0x200,%eax
  101369:	75 0a                	jne    101375 <cons_intr+0x3b>
                cons.wpos = 0;
  10136b:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101372:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101375:	8b 45 08             	mov    0x8(%ebp),%eax
  101378:	ff d0                	call   *%eax
  10137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10137d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101381:	75 bf                	jne    101342 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101383:	90                   	nop
  101384:	c9                   	leave  
  101385:	c3                   	ret    

00101386 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101386:	55                   	push   %ebp
  101387:	89 e5                	mov    %esp,%ebp
  101389:	83 ec 10             	sub    $0x10,%esp
  10138c:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101392:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101396:	89 c2                	mov    %eax,%edx
  101398:	ec                   	in     (%dx),%al
  101399:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10139c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013a0:	0f b6 c0             	movzbl %al,%eax
  1013a3:	83 e0 01             	and    $0x1,%eax
  1013a6:	85 c0                	test   %eax,%eax
  1013a8:	75 07                	jne    1013b1 <serial_proc_data+0x2b>
        return -1;
  1013aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013af:	eb 2a                	jmp    1013db <serial_proc_data+0x55>
  1013b1:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bb:	89 c2                	mov    %eax,%edx
  1013bd:	ec                   	in     (%dx),%al
  1013be:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1013c1:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013c5:	0f b6 c0             	movzbl %al,%eax
  1013c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013cb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013cf:	75 07                	jne    1013d8 <serial_proc_data+0x52>
        c = '\b';
  1013d1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013db:	c9                   	leave  
  1013dc:	c3                   	ret    

001013dd <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013dd:	55                   	push   %ebp
  1013de:	89 e5                	mov    %esp,%ebp
  1013e0:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013e3:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013e8:	85 c0                	test   %eax,%eax
  1013ea:	74 10                	je     1013fc <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013ec:	83 ec 0c             	sub    $0xc,%esp
  1013ef:	68 86 13 10 00       	push   $0x101386
  1013f4:	e8 41 ff ff ff       	call   10133a <cons_intr>
  1013f9:	83 c4 10             	add    $0x10,%esp
    }
}
  1013fc:	90                   	nop
  1013fd:	c9                   	leave  
  1013fe:	c3                   	ret    

001013ff <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ff:	55                   	push   %ebp
  101400:	89 e5                	mov    %esp,%ebp
  101402:	83 ec 18             	sub    $0x18,%esp
  101405:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10140b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10140f:	89 c2                	mov    %eax,%edx
  101411:	ec                   	in     (%dx),%al
  101412:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101415:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101419:	0f b6 c0             	movzbl %al,%eax
  10141c:	83 e0 01             	and    $0x1,%eax
  10141f:	85 c0                	test   %eax,%eax
  101421:	75 0a                	jne    10142d <kbd_proc_data+0x2e>
        return -1;
  101423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101428:	e9 5d 01 00 00       	jmp    10158a <kbd_proc_data+0x18b>
  10142d:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101433:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101437:	89 c2                	mov    %eax,%edx
  101439:	ec                   	in     (%dx),%al
  10143a:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  10143d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  101441:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101444:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101448:	75 17                	jne    101461 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10144a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10144f:	83 c8 40             	or     $0x40,%eax
  101452:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101457:	b8 00 00 00 00       	mov    $0x0,%eax
  10145c:	e9 29 01 00 00       	jmp    10158a <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  101461:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101465:	84 c0                	test   %al,%al
  101467:	79 47                	jns    1014b0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101469:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146e:	83 e0 40             	and    $0x40,%eax
  101471:	85 c0                	test   %eax,%eax
  101473:	75 09                	jne    10147e <kbd_proc_data+0x7f>
  101475:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101479:	83 e0 7f             	and    $0x7f,%eax
  10147c:	eb 04                	jmp    101482 <kbd_proc_data+0x83>
  10147e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101482:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101485:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101489:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101490:	83 c8 40             	or     $0x40,%eax
  101493:	0f b6 c0             	movzbl %al,%eax
  101496:	f7 d0                	not    %eax
  101498:	89 c2                	mov    %eax,%edx
  10149a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10149f:	21 d0                	and    %edx,%eax
  1014a1:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014a6:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ab:	e9 da 00 00 00       	jmp    10158a <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  1014b0:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b5:	83 e0 40             	and    $0x40,%eax
  1014b8:	85 c0                	test   %eax,%eax
  1014ba:	74 11                	je     1014cd <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014bc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014c0:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c5:	83 e0 bf             	and    $0xffffffbf,%eax
  1014c8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d1:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014d8:	0f b6 d0             	movzbl %al,%edx
  1014db:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e0:	09 d0                	or     %edx,%eax
  1014e2:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014eb:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  1014f2:	0f b6 d0             	movzbl %al,%edx
  1014f5:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fa:	31 d0                	xor    %edx,%eax
  1014fc:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101501:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101506:	83 e0 03             	and    $0x3,%eax
  101509:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101514:	01 d0                	add    %edx,%eax
  101516:	0f b6 00             	movzbl (%eax),%eax
  101519:	0f b6 c0             	movzbl %al,%eax
  10151c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10151f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101524:	83 e0 08             	and    $0x8,%eax
  101527:	85 c0                	test   %eax,%eax
  101529:	74 22                	je     10154d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10152b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10152f:	7e 0c                	jle    10153d <kbd_proc_data+0x13e>
  101531:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101535:	7f 06                	jg     10153d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101537:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10153b:	eb 10                	jmp    10154d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10153d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101541:	7e 0a                	jle    10154d <kbd_proc_data+0x14e>
  101543:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101547:	7f 04                	jg     10154d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101549:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10154d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101552:	f7 d0                	not    %eax
  101554:	83 e0 06             	and    $0x6,%eax
  101557:	85 c0                	test   %eax,%eax
  101559:	75 2c                	jne    101587 <kbd_proc_data+0x188>
  10155b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101562:	75 23                	jne    101587 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101564:	83 ec 0c             	sub    $0xc,%esp
  101567:	68 71 5f 10 00       	push   $0x105f71
  10156c:	e8 fe ec ff ff       	call   10026f <cprintf>
  101571:	83 c4 10             	add    $0x10,%esp
  101574:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  10157a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10157e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101582:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101586:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101587:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10158a:	c9                   	leave  
  10158b:	c3                   	ret    

0010158c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10158c:	55                   	push   %ebp
  10158d:	89 e5                	mov    %esp,%ebp
  10158f:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101592:	83 ec 0c             	sub    $0xc,%esp
  101595:	68 ff 13 10 00       	push   $0x1013ff
  10159a:	e8 9b fd ff ff       	call   10133a <cons_intr>
  10159f:	83 c4 10             	add    $0x10,%esp
}
  1015a2:	90                   	nop
  1015a3:	c9                   	leave  
  1015a4:	c3                   	ret    

001015a5 <kbd_init>:

static void
kbd_init(void) {
  1015a5:	55                   	push   %ebp
  1015a6:	89 e5                	mov    %esp,%ebp
  1015a8:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1015ab:	e8 dc ff ff ff       	call   10158c <kbd_intr>
    pic_enable(IRQ_KBD);
  1015b0:	83 ec 0c             	sub    $0xc,%esp
  1015b3:	6a 01                	push   $0x1
  1015b5:	e8 4b 01 00 00       	call   101705 <pic_enable>
  1015ba:	83 c4 10             	add    $0x10,%esp
}
  1015bd:	90                   	nop
  1015be:	c9                   	leave  
  1015bf:	c3                   	ret    

001015c0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015c0:	55                   	push   %ebp
  1015c1:	89 e5                	mov    %esp,%ebp
  1015c3:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015c6:	e8 8c f8 ff ff       	call   100e57 <cga_init>
    serial_init();
  1015cb:	e8 6e f9 ff ff       	call   100f3e <serial_init>
    kbd_init();
  1015d0:	e8 d0 ff ff ff       	call   1015a5 <kbd_init>
    if (!serial_exists) {
  1015d5:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015da:	85 c0                	test   %eax,%eax
  1015dc:	75 10                	jne    1015ee <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015de:	83 ec 0c             	sub    $0xc,%esp
  1015e1:	68 7d 5f 10 00       	push   $0x105f7d
  1015e6:	e8 84 ec ff ff       	call   10026f <cprintf>
  1015eb:	83 c4 10             	add    $0x10,%esp
    }
}
  1015ee:	90                   	nop
  1015ef:	c9                   	leave  
  1015f0:	c3                   	ret    

001015f1 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f1:	55                   	push   %ebp
  1015f2:	89 e5                	mov    %esp,%ebp
  1015f4:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015f7:	e8 d4 f7 ff ff       	call   100dd0 <__intr_save>
  1015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015ff:	83 ec 0c             	sub    $0xc,%esp
  101602:	ff 75 08             	pushl  0x8(%ebp)
  101605:	e8 93 fa ff ff       	call   10109d <lpt_putc>
  10160a:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  10160d:	83 ec 0c             	sub    $0xc,%esp
  101610:	ff 75 08             	pushl  0x8(%ebp)
  101613:	e8 bc fa ff ff       	call   1010d4 <cga_putc>
  101618:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  10161b:	83 ec 0c             	sub    $0xc,%esp
  10161e:	ff 75 08             	pushl  0x8(%ebp)
  101621:	e8 dd fc ff ff       	call   101303 <serial_putc>
  101626:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  101629:	83 ec 0c             	sub    $0xc,%esp
  10162c:	ff 75 f4             	pushl  -0xc(%ebp)
  10162f:	e8 c6 f7 ff ff       	call   100dfa <__intr_restore>
  101634:	83 c4 10             	add    $0x10,%esp
}
  101637:	90                   	nop
  101638:	c9                   	leave  
  101639:	c3                   	ret    

0010163a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163a:	55                   	push   %ebp
  10163b:	89 e5                	mov    %esp,%ebp
  10163d:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  101640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101647:	e8 84 f7 ff ff       	call   100dd0 <__intr_save>
  10164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164f:	e8 89 fd ff ff       	call   1013dd <serial_intr>
        kbd_intr();
  101654:	e8 33 ff ff ff       	call   10158c <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101659:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10165f:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101664:	39 c2                	cmp    %eax,%edx
  101666:	74 31                	je     101699 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101668:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166d:	8d 50 01             	lea    0x1(%eax),%edx
  101670:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101676:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10167d:	0f b6 c0             	movzbl %al,%eax
  101680:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101683:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101688:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168d:	75 0a                	jne    101699 <cons_getc+0x5f>
                cons.rpos = 0;
  10168f:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101696:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101699:	83 ec 0c             	sub    $0xc,%esp
  10169c:	ff 75 f0             	pushl  -0x10(%ebp)
  10169f:	e8 56 f7 ff ff       	call   100dfa <__intr_restore>
  1016a4:	83 c4 10             	add    $0x10,%esp
    return c;
  1016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016aa:	c9                   	leave  
  1016ab:	c3                   	ret    

001016ac <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
  1016af:	83 ec 14             	sub    $0x14,%esp
  1016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016bd:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c3:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016c8:	85 c0                	test   %eax,%eax
  1016ca:	74 36                	je     101702 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d0:	0f b6 c0             	movzbl %al,%eax
  1016d3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d9:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016dc:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016e0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e9:	66 c1 e8 08          	shr    $0x8,%ax
  1016ed:	0f b6 c0             	movzbl %al,%eax
  1016f0:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016f6:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016f9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016fd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
    }
}
  101702:	90                   	nop
  101703:	c9                   	leave  
  101704:	c3                   	ret    

00101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101705:	55                   	push   %ebp
  101706:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101708:	8b 45 08             	mov    0x8(%ebp),%eax
  10170b:	ba 01 00 00 00       	mov    $0x1,%edx
  101710:	89 c1                	mov    %eax,%ecx
  101712:	d3 e2                	shl    %cl,%edx
  101714:	89 d0                	mov    %edx,%eax
  101716:	f7 d0                	not    %eax
  101718:	89 c2                	mov    %eax,%edx
  10171a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101721:	21 d0                	and    %edx,%eax
  101723:	0f b7 c0             	movzwl %ax,%eax
  101726:	50                   	push   %eax
  101727:	e8 80 ff ff ff       	call   1016ac <pic_setmask>
  10172c:	83 c4 04             	add    $0x4,%esp
}
  10172f:	90                   	nop
  101730:	c9                   	leave  
  101731:	c3                   	ret    

00101732 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101732:	55                   	push   %ebp
  101733:	89 e5                	mov    %esp,%ebp
  101735:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101738:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10173f:	00 00 00 
  101742:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101748:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  10174c:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  101750:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101754:	ee                   	out    %al,(%dx)
  101755:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  10175b:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  10175f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  101763:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  10176e:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  101772:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  101776:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  101781:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101785:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101789:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101794:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101798:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10179c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  1017a7:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  1017ab:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1017af:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
  1017b4:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  1017ba:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  1017be:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1017c2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
  1017c7:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017cd:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017d1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017d5:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1017d9:	ee                   	out    %al,(%dx)
  1017da:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017e0:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017e4:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017e8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
  1017ed:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017f3:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017f7:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017fb:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
  101800:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101806:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  10180a:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10180e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
  101813:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101819:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10181d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101821:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101825:	ee                   	out    %al,(%dx)
  101826:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10182c:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101830:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  101834:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101838:	ee                   	out    %al,(%dx)
  101839:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  10183f:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  101843:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  101847:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  10184b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184c:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101853:	66 83 f8 ff          	cmp    $0xffff,%ax
  101857:	74 13                	je     10186c <pic_init+0x13a>
        pic_setmask(irq_mask);
  101859:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101860:	0f b7 c0             	movzwl %ax,%eax
  101863:	50                   	push   %eax
  101864:	e8 43 fe ff ff       	call   1016ac <pic_setmask>
  101869:	83 c4 04             	add    $0x4,%esp
    }
}
  10186c:	90                   	nop
  10186d:	c9                   	leave  
  10186e:	c3                   	ret    

0010186f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10186f:	55                   	push   %ebp
  101870:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  101872:	fb                   	sti    
    sti();
}
  101873:	90                   	nop
  101874:	5d                   	pop    %ebp
  101875:	c3                   	ret    

00101876 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101876:	55                   	push   %ebp
  101877:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101879:	fa                   	cli    
    cli();
}
  10187a:	90                   	nop
  10187b:	5d                   	pop    %ebp
  10187c:	c3                   	ret    

0010187d <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10187d:	55                   	push   %ebp
  10187e:	89 e5                	mov    %esp,%ebp
  101880:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101883:	83 ec 08             	sub    $0x8,%esp
  101886:	6a 64                	push   $0x64
  101888:	68 a0 5f 10 00       	push   $0x105fa0
  10188d:	e8 dd e9 ff ff       	call   10026f <cprintf>
  101892:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101895:	83 ec 0c             	sub    $0xc,%esp
  101898:	68 aa 5f 10 00       	push   $0x105faa
  10189d:	e8 cd e9 ff ff       	call   10026f <cprintf>
  1018a2:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  1018a5:	83 ec 04             	sub    $0x4,%esp
  1018a8:	68 b8 5f 10 00       	push   $0x105fb8
  1018ad:	6a 12                	push   $0x12
  1018af:	68 ce 5f 10 00       	push   $0x105fce
  1018b4:	e8 1c eb ff ff       	call   1003d5 <__panic>

001018b9 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b9:	55                   	push   %ebp
  1018ba:	89 e5                	mov    %esp,%ebp
  1018bc:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  1018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018c6:	e9 c3 00 00 00       	jmp    10198e <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ce:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018d5:	89 c2                	mov    %eax,%edx
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018e1:	00 
  1018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e5:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018ec:	00 08 00 
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f9:	00 
  1018fa:	83 e2 e0             	and    $0xffffffe0,%edx
  1018fd:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  10190e:	00 
  10190f:	83 e2 1f             	and    $0x1f,%edx
  101912:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101923:	00 
  101924:	83 e2 f0             	and    $0xfffffff0,%edx
  101927:	83 ca 0e             	or     $0xe,%edx
  10192a:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101934:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193b:	00 
  10193c:	83 e2 ef             	and    $0xffffffef,%edx
  10193f:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101949:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101950:	00 
  101951:	83 e2 9f             	and    $0xffffff9f,%edx
  101954:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101965:	00 
  101966:	83 ca 80             	or     $0xffffff80,%edx
  101969:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101973:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10197a:	c1 e8 10             	shr    $0x10,%eax
  10197d:	89 c2                	mov    %eax,%edx
  10197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101982:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101989:	00 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  10198a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10198e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101995:	0f 8e 30 ff ff ff    	jle    1018cb <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10199b:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019a0:	66 a3 88 84 11 00    	mov    %ax,0x118488
  1019a6:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1019ad:	08 00 
  1019af:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019b6:	83 e0 e0             	and    $0xffffffe0,%eax
  1019b9:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019be:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019c5:	83 e0 1f             	and    $0x1f,%eax
  1019c8:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019cd:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d4:	83 e0 f0             	and    $0xfffffff0,%eax
  1019d7:	83 c8 0e             	or     $0xe,%eax
  1019da:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019df:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019e6:	83 e0 ef             	and    $0xffffffef,%eax
  1019e9:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019ee:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019f5:	83 c8 60             	or     $0x60,%eax
  1019f8:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019fd:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a04:	83 c8 80             	or     $0xffffff80,%eax
  101a07:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a0c:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a11:	c1 e8 10             	shr    $0x10,%eax
  101a14:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101a1a:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a24:	0f 01 18             	lidtl  (%eax)

    // 3. LIDT
    lidt(&idt_pd);
}
  101a27:	90                   	nop
  101a28:	c9                   	leave  
  101a29:	c3                   	ret    

00101a2a <trapname>:

static const char *
trapname(int trapno) {
  101a2a:	55                   	push   %ebp
  101a2b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a30:	83 f8 13             	cmp    $0x13,%eax
  101a33:	77 0c                	ja     101a41 <trapname+0x17>
        return excnames[trapno];
  101a35:	8b 45 08             	mov    0x8(%ebp),%eax
  101a38:	8b 04 85 20 63 10 00 	mov    0x106320(,%eax,4),%eax
  101a3f:	eb 18                	jmp    101a59 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a41:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a45:	7e 0d                	jle    101a54 <trapname+0x2a>
  101a47:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a4b:	7f 07                	jg     101a54 <trapname+0x2a>
        return "Hardware Interrupt";
  101a4d:	b8 df 5f 10 00       	mov    $0x105fdf,%eax
  101a52:	eb 05                	jmp    101a59 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a54:	b8 f2 5f 10 00       	mov    $0x105ff2,%eax
}
  101a59:	5d                   	pop    %ebp
  101a5a:	c3                   	ret    

00101a5b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a5b:	55                   	push   %ebp
  101a5c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a61:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a65:	66 83 f8 08          	cmp    $0x8,%ax
  101a69:	0f 94 c0             	sete   %al
  101a6c:	0f b6 c0             	movzbl %al,%eax
}
  101a6f:	5d                   	pop    %ebp
  101a70:	c3                   	ret    

00101a71 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a71:	55                   	push   %ebp
  101a72:	89 e5                	mov    %esp,%ebp
  101a74:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a77:	83 ec 08             	sub    $0x8,%esp
  101a7a:	ff 75 08             	pushl  0x8(%ebp)
  101a7d:	68 33 60 10 00       	push   $0x106033
  101a82:	e8 e8 e7 ff ff       	call   10026f <cprintf>
  101a87:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8d:	83 ec 0c             	sub    $0xc,%esp
  101a90:	50                   	push   %eax
  101a91:	e8 b8 01 00 00       	call   101c4e <print_regs>
  101a96:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aa0:	0f b7 c0             	movzwl %ax,%eax
  101aa3:	83 ec 08             	sub    $0x8,%esp
  101aa6:	50                   	push   %eax
  101aa7:	68 44 60 10 00       	push   $0x106044
  101aac:	e8 be e7 ff ff       	call   10026f <cprintf>
  101ab1:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101abb:	0f b7 c0             	movzwl %ax,%eax
  101abe:	83 ec 08             	sub    $0x8,%esp
  101ac1:	50                   	push   %eax
  101ac2:	68 57 60 10 00       	push   $0x106057
  101ac7:	e8 a3 e7 ff ff       	call   10026f <cprintf>
  101acc:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ad6:	0f b7 c0             	movzwl %ax,%eax
  101ad9:	83 ec 08             	sub    $0x8,%esp
  101adc:	50                   	push   %eax
  101add:	68 6a 60 10 00       	push   $0x10606a
  101ae2:	e8 88 e7 ff ff       	call   10026f <cprintf>
  101ae7:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101aea:	8b 45 08             	mov    0x8(%ebp),%eax
  101aed:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101af1:	0f b7 c0             	movzwl %ax,%eax
  101af4:	83 ec 08             	sub    $0x8,%esp
  101af7:	50                   	push   %eax
  101af8:	68 7d 60 10 00       	push   $0x10607d
  101afd:	e8 6d e7 ff ff       	call   10026f <cprintf>
  101b02:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b05:	8b 45 08             	mov    0x8(%ebp),%eax
  101b08:	8b 40 30             	mov    0x30(%eax),%eax
  101b0b:	83 ec 0c             	sub    $0xc,%esp
  101b0e:	50                   	push   %eax
  101b0f:	e8 16 ff ff ff       	call   101a2a <trapname>
  101b14:	83 c4 10             	add    $0x10,%esp
  101b17:	89 c2                	mov    %eax,%edx
  101b19:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1c:	8b 40 30             	mov    0x30(%eax),%eax
  101b1f:	83 ec 04             	sub    $0x4,%esp
  101b22:	52                   	push   %edx
  101b23:	50                   	push   %eax
  101b24:	68 90 60 10 00       	push   $0x106090
  101b29:	e8 41 e7 ff ff       	call   10026f <cprintf>
  101b2e:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b31:	8b 45 08             	mov    0x8(%ebp),%eax
  101b34:	8b 40 34             	mov    0x34(%eax),%eax
  101b37:	83 ec 08             	sub    $0x8,%esp
  101b3a:	50                   	push   %eax
  101b3b:	68 a2 60 10 00       	push   $0x1060a2
  101b40:	e8 2a e7 ff ff       	call   10026f <cprintf>
  101b45:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	8b 40 38             	mov    0x38(%eax),%eax
  101b4e:	83 ec 08             	sub    $0x8,%esp
  101b51:	50                   	push   %eax
  101b52:	68 b1 60 10 00       	push   $0x1060b1
  101b57:	e8 13 e7 ff ff       	call   10026f <cprintf>
  101b5c:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b66:	0f b7 c0             	movzwl %ax,%eax
  101b69:	83 ec 08             	sub    $0x8,%esp
  101b6c:	50                   	push   %eax
  101b6d:	68 c0 60 10 00       	push   $0x1060c0
  101b72:	e8 f8 e6 ff ff       	call   10026f <cprintf>
  101b77:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7d:	8b 40 40             	mov    0x40(%eax),%eax
  101b80:	83 ec 08             	sub    $0x8,%esp
  101b83:	50                   	push   %eax
  101b84:	68 d3 60 10 00       	push   $0x1060d3
  101b89:	e8 e1 e6 ff ff       	call   10026f <cprintf>
  101b8e:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b98:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b9f:	eb 3f                	jmp    101be0 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba4:	8b 50 40             	mov    0x40(%eax),%edx
  101ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101baa:	21 d0                	and    %edx,%eax
  101bac:	85 c0                	test   %eax,%eax
  101bae:	74 29                	je     101bd9 <print_trapframe+0x168>
  101bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb3:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bba:	85 c0                	test   %eax,%eax
  101bbc:	74 1b                	je     101bd9 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc1:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bc8:	83 ec 08             	sub    $0x8,%esp
  101bcb:	50                   	push   %eax
  101bcc:	68 e2 60 10 00       	push   $0x1060e2
  101bd1:	e8 99 e6 ff ff       	call   10026f <cprintf>
  101bd6:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bdd:	d1 65 f0             	shll   -0x10(%ebp)
  101be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101be3:	83 f8 17             	cmp    $0x17,%eax
  101be6:	76 b9                	jbe    101ba1 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 40             	mov    0x40(%eax),%eax
  101bee:	25 00 30 00 00       	and    $0x3000,%eax
  101bf3:	c1 e8 0c             	shr    $0xc,%eax
  101bf6:	83 ec 08             	sub    $0x8,%esp
  101bf9:	50                   	push   %eax
  101bfa:	68 e6 60 10 00       	push   $0x1060e6
  101bff:	e8 6b e6 ff ff       	call   10026f <cprintf>
  101c04:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101c07:	83 ec 0c             	sub    $0xc,%esp
  101c0a:	ff 75 08             	pushl  0x8(%ebp)
  101c0d:	e8 49 fe ff ff       	call   101a5b <trap_in_kernel>
  101c12:	83 c4 10             	add    $0x10,%esp
  101c15:	85 c0                	test   %eax,%eax
  101c17:	75 32                	jne    101c4b <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c19:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1c:	8b 40 44             	mov    0x44(%eax),%eax
  101c1f:	83 ec 08             	sub    $0x8,%esp
  101c22:	50                   	push   %eax
  101c23:	68 ef 60 10 00       	push   $0x1060ef
  101c28:	e8 42 e6 ff ff       	call   10026f <cprintf>
  101c2d:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c30:	8b 45 08             	mov    0x8(%ebp),%eax
  101c33:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c37:	0f b7 c0             	movzwl %ax,%eax
  101c3a:	83 ec 08             	sub    $0x8,%esp
  101c3d:	50                   	push   %eax
  101c3e:	68 fe 60 10 00       	push   $0x1060fe
  101c43:	e8 27 e6 ff ff       	call   10026f <cprintf>
  101c48:	83 c4 10             	add    $0x10,%esp
    }
}
  101c4b:	90                   	nop
  101c4c:	c9                   	leave  
  101c4d:	c3                   	ret    

00101c4e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c4e:	55                   	push   %ebp
  101c4f:	89 e5                	mov    %esp,%ebp
  101c51:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c54:	8b 45 08             	mov    0x8(%ebp),%eax
  101c57:	8b 00                	mov    (%eax),%eax
  101c59:	83 ec 08             	sub    $0x8,%esp
  101c5c:	50                   	push   %eax
  101c5d:	68 11 61 10 00       	push   $0x106111
  101c62:	e8 08 e6 ff ff       	call   10026f <cprintf>
  101c67:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6d:	8b 40 04             	mov    0x4(%eax),%eax
  101c70:	83 ec 08             	sub    $0x8,%esp
  101c73:	50                   	push   %eax
  101c74:	68 20 61 10 00       	push   $0x106120
  101c79:	e8 f1 e5 ff ff       	call   10026f <cprintf>
  101c7e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c81:	8b 45 08             	mov    0x8(%ebp),%eax
  101c84:	8b 40 08             	mov    0x8(%eax),%eax
  101c87:	83 ec 08             	sub    $0x8,%esp
  101c8a:	50                   	push   %eax
  101c8b:	68 2f 61 10 00       	push   $0x10612f
  101c90:	e8 da e5 ff ff       	call   10026f <cprintf>
  101c95:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c98:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9b:	8b 40 0c             	mov    0xc(%eax),%eax
  101c9e:	83 ec 08             	sub    $0x8,%esp
  101ca1:	50                   	push   %eax
  101ca2:	68 3e 61 10 00       	push   $0x10613e
  101ca7:	e8 c3 e5 ff ff       	call   10026f <cprintf>
  101cac:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101caf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb2:	8b 40 10             	mov    0x10(%eax),%eax
  101cb5:	83 ec 08             	sub    $0x8,%esp
  101cb8:	50                   	push   %eax
  101cb9:	68 4d 61 10 00       	push   $0x10614d
  101cbe:	e8 ac e5 ff ff       	call   10026f <cprintf>
  101cc3:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	8b 40 14             	mov    0x14(%eax),%eax
  101ccc:	83 ec 08             	sub    $0x8,%esp
  101ccf:	50                   	push   %eax
  101cd0:	68 5c 61 10 00       	push   $0x10615c
  101cd5:	e8 95 e5 ff ff       	call   10026f <cprintf>
  101cda:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce0:	8b 40 18             	mov    0x18(%eax),%eax
  101ce3:	83 ec 08             	sub    $0x8,%esp
  101ce6:	50                   	push   %eax
  101ce7:	68 6b 61 10 00       	push   $0x10616b
  101cec:	e8 7e e5 ff ff       	call   10026f <cprintf>
  101cf1:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf7:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cfa:	83 ec 08             	sub    $0x8,%esp
  101cfd:	50                   	push   %eax
  101cfe:	68 7a 61 10 00       	push   $0x10617a
  101d03:	e8 67 e5 ff ff       	call   10026f <cprintf>
  101d08:	83 c4 10             	add    $0x10,%esp
}
  101d0b:	90                   	nop
  101d0c:	c9                   	leave  
  101d0d:	c3                   	ret    

00101d0e <trap_dispatch>:
/* LAB1: temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d0e:	55                   	push   %ebp
  101d0f:	89 e5                	mov    %esp,%ebp
  101d11:	57                   	push   %edi
  101d12:	56                   	push   %esi
  101d13:	53                   	push   %ebx
  101d14:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d17:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1a:	8b 40 30             	mov    0x30(%eax),%eax
  101d1d:	83 f8 2f             	cmp    $0x2f,%eax
  101d20:	77 21                	ja     101d43 <trap_dispatch+0x35>
  101d22:	83 f8 2e             	cmp    $0x2e,%eax
  101d25:	0f 83 90 01 00 00    	jae    101ebb <trap_dispatch+0x1ad>
  101d2b:	83 f8 21             	cmp    $0x21,%eax
  101d2e:	0f 84 87 00 00 00    	je     101dbb <trap_dispatch+0xad>
  101d34:	83 f8 24             	cmp    $0x24,%eax
  101d37:	74 5b                	je     101d94 <trap_dispatch+0x86>
  101d39:	83 f8 20             	cmp    $0x20,%eax
  101d3c:	74 1c                	je     101d5a <trap_dispatch+0x4c>
  101d3e:	e9 42 01 00 00       	jmp    101e85 <trap_dispatch+0x177>
  101d43:	83 f8 78             	cmp    $0x78,%eax
  101d46:	0f 84 96 00 00 00    	je     101de2 <trap_dispatch+0xd4>
  101d4c:	83 f8 79             	cmp    $0x79,%eax
  101d4f:	0f 84 02 01 00 00    	je     101e57 <trap_dispatch+0x149>
  101d55:	e9 2b 01 00 00       	jmp    101e85 <trap_dispatch+0x177>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
  101d5a:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d5f:	83 c0 01             	add    $0x1,%eax
  101d62:	a3 4c 89 11 00       	mov    %eax,0x11894c

        // 2. print
        if (ticks % TICK_NUM == 0) {
  101d67:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d6d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d72:	89 c8                	mov    %ecx,%eax
  101d74:	f7 e2                	mul    %edx
  101d76:	89 d0                	mov    %edx,%eax
  101d78:	c1 e8 05             	shr    $0x5,%eax
  101d7b:	6b c0 64             	imul   $0x64,%eax,%eax
  101d7e:	29 c1                	sub    %eax,%ecx
  101d80:	89 c8                	mov    %ecx,%eax
  101d82:	85 c0                	test   %eax,%eax
  101d84:	0f 85 34 01 00 00    	jne    101ebe <trap_dispatch+0x1b0>
            print_ticks();
  101d8a:	e8 ee fa ff ff       	call   10187d <print_ticks>
        }

        // 3. too simple ?!
        break;
  101d8f:	e9 2a 01 00 00       	jmp    101ebe <trap_dispatch+0x1b0>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d94:	e8 a1 f8 ff ff       	call   10163a <cons_getc>
  101d99:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d9c:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101da0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101da4:	83 ec 04             	sub    $0x4,%esp
  101da7:	52                   	push   %edx
  101da8:	50                   	push   %eax
  101da9:	68 89 61 10 00       	push   $0x106189
  101dae:	e8 bc e4 ff ff       	call   10026f <cprintf>
  101db3:	83 c4 10             	add    $0x10,%esp
        break;
  101db6:	e9 04 01 00 00       	jmp    101ebf <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dbb:	e8 7a f8 ff ff       	call   10163a <cons_getc>
  101dc0:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dc3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101dc7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dcb:	83 ec 04             	sub    $0x4,%esp
  101dce:	52                   	push   %edx
  101dcf:	50                   	push   %eax
  101dd0:	68 9b 61 10 00       	push   $0x10619b
  101dd5:	e8 95 e4 ff ff       	call   10026f <cprintf>
  101dda:	83 c4 10             	add    $0x10,%esp
        break;
  101ddd:	e9 dd 00 00 00       	jmp    101ebf <trap_dispatch+0x1b1>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
  101de2:	8b 55 08             	mov    0x8(%ebp),%edx
  101de5:	b8 60 89 11 00       	mov    $0x118960,%eax
  101dea:	89 d3                	mov    %edx,%ebx
  101dec:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101df1:	8b 0b                	mov    (%ebx),%ecx
  101df3:	89 08                	mov    %ecx,(%eax)
  101df5:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101df9:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101dfd:	8d 78 04             	lea    0x4(%eax),%edi
  101e00:	83 e7 fc             	and    $0xfffffffc,%edi
  101e03:	29 f8                	sub    %edi,%eax
  101e05:	29 c3                	sub    %eax,%ebx
  101e07:	01 c2                	add    %eax,%edx
  101e09:	83 e2 fc             	and    $0xfffffffc,%edx
  101e0c:	89 d0                	mov    %edx,%eax
  101e0e:	c1 e8 02             	shr    $0x2,%eax
  101e11:	89 de                	mov    %ebx,%esi
  101e13:	89 c1                	mov    %eax,%ecx
  101e15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
  101e17:	66 c7 05 9c 89 11 00 	movw   $0x1b,0x11899c
  101e1e:	1b 00 
        switchk2u.tf_ds = USER_DS;
  101e20:	66 c7 05 8c 89 11 00 	movw   $0x23,0x11898c
  101e27:	23 00 
        switchk2u.tf_es = USER_DS;
  101e29:	66 c7 05 88 89 11 00 	movw   $0x23,0x118988
  101e30:	23 00 
        switchk2u.tf_ss = USER_DS;
  101e32:	66 c7 05 a8 89 11 00 	movw   $0x23,0x1189a8
  101e39:	23 00 

        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e3b:	a1 a0 89 11 00       	mov    0x1189a0,%eax
  101e40:	80 cc 30             	or     $0x30,%ah
  101e43:	a3 a0 89 11 00       	mov    %eax,0x1189a0
        // set trap frame pointer
        // tf is the pointer to the pointer of trap frame (a structure)
        // tf = esp, while esp -> esp - 1 (*trap_frame) due to `pushl %esp`
        // so *(tf - 1) is the pointer to trap frame
        // change *trap_frame to point to the new frame
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e48:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4b:	83 e8 04             	sub    $0x4,%eax
  101e4e:	ba 60 89 11 00       	mov    $0x118960,%edx
  101e53:	89 10                	mov    %edx,(%eax)
        break;
  101e55:	eb 68                	jmp    101ebf <trap_dispatch+0x1b1>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
  101e57:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5a:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
  101e60:	8b 45 08             	mov    0x8(%ebp),%eax
  101e63:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
  101e69:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6c:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)

        // restore eflags
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101e72:	8b 45 08             	mov    0x8(%ebp),%eax
  101e75:	8b 40 40             	mov    0x40(%eax),%eax
  101e78:	80 e4 cf             	and    $0xcf,%ah
  101e7b:	89 c2                	mov    %eax,%edx
  101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e80:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101e83:	eb 3a                	jmp    101ebf <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e85:	8b 45 08             	mov    0x8(%ebp),%eax
  101e88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e8c:	0f b7 c0             	movzwl %ax,%eax
  101e8f:	83 e0 03             	and    $0x3,%eax
  101e92:	85 c0                	test   %eax,%eax
  101e94:	75 29                	jne    101ebf <trap_dispatch+0x1b1>
            print_trapframe(tf);
  101e96:	83 ec 0c             	sub    $0xc,%esp
  101e99:	ff 75 08             	pushl  0x8(%ebp)
  101e9c:	e8 d0 fb ff ff       	call   101a71 <print_trapframe>
  101ea1:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101ea4:	83 ec 04             	sub    $0x4,%esp
  101ea7:	68 aa 61 10 00       	push   $0x1061aa
  101eac:	68 dc 00 00 00       	push   $0xdc
  101eb1:	68 ce 5f 10 00       	push   $0x105fce
  101eb6:	e8 1a e5 ff ff       	call   1003d5 <__panic>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ebb:	90                   	nop
  101ebc:	eb 01                	jmp    101ebf <trap_dispatch+0x1b1>
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }

        // 3. too simple ?!
        break;
  101ebe:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ebf:	90                   	nop
  101ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101ec3:	5b                   	pop    %ebx
  101ec4:	5e                   	pop    %esi
  101ec5:	5f                   	pop    %edi
  101ec6:	5d                   	pop    %ebp
  101ec7:	c3                   	ret    

00101ec8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ec8:	55                   	push   %ebp
  101ec9:	89 e5                	mov    %esp,%ebp
  101ecb:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ece:	83 ec 0c             	sub    $0xc,%esp
  101ed1:	ff 75 08             	pushl  0x8(%ebp)
  101ed4:	e8 35 fe ff ff       	call   101d0e <trap_dispatch>
  101ed9:	83 c4 10             	add    $0x10,%esp
}
  101edc:	90                   	nop
  101edd:	c9                   	leave  
  101ede:	c3                   	ret    

00101edf <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101edf:	6a 00                	push   $0x0
  pushl $0
  101ee1:	6a 00                	push   $0x0
  jmp __alltraps
  101ee3:	e9 69 0a 00 00       	jmp    102951 <__alltraps>

00101ee8 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ee8:	6a 00                	push   $0x0
  pushl $1
  101eea:	6a 01                	push   $0x1
  jmp __alltraps
  101eec:	e9 60 0a 00 00       	jmp    102951 <__alltraps>

00101ef1 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ef1:	6a 00                	push   $0x0
  pushl $2
  101ef3:	6a 02                	push   $0x2
  jmp __alltraps
  101ef5:	e9 57 0a 00 00       	jmp    102951 <__alltraps>

00101efa <vector3>:
.globl vector3
vector3:
  pushl $0
  101efa:	6a 00                	push   $0x0
  pushl $3
  101efc:	6a 03                	push   $0x3
  jmp __alltraps
  101efe:	e9 4e 0a 00 00       	jmp    102951 <__alltraps>

00101f03 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f03:	6a 00                	push   $0x0
  pushl $4
  101f05:	6a 04                	push   $0x4
  jmp __alltraps
  101f07:	e9 45 0a 00 00       	jmp    102951 <__alltraps>

00101f0c <vector5>:
.globl vector5
vector5:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $5
  101f0e:	6a 05                	push   $0x5
  jmp __alltraps
  101f10:	e9 3c 0a 00 00       	jmp    102951 <__alltraps>

00101f15 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $6
  101f17:	6a 06                	push   $0x6
  jmp __alltraps
  101f19:	e9 33 0a 00 00       	jmp    102951 <__alltraps>

00101f1e <vector7>:
.globl vector7
vector7:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $7
  101f20:	6a 07                	push   $0x7
  jmp __alltraps
  101f22:	e9 2a 0a 00 00       	jmp    102951 <__alltraps>

00101f27 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f27:	6a 08                	push   $0x8
  jmp __alltraps
  101f29:	e9 23 0a 00 00       	jmp    102951 <__alltraps>

00101f2e <vector9>:
.globl vector9
vector9:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $9
  101f30:	6a 09                	push   $0x9
  jmp __alltraps
  101f32:	e9 1a 0a 00 00       	jmp    102951 <__alltraps>

00101f37 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f37:	6a 0a                	push   $0xa
  jmp __alltraps
  101f39:	e9 13 0a 00 00       	jmp    102951 <__alltraps>

00101f3e <vector11>:
.globl vector11
vector11:
  pushl $11
  101f3e:	6a 0b                	push   $0xb
  jmp __alltraps
  101f40:	e9 0c 0a 00 00       	jmp    102951 <__alltraps>

00101f45 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f45:	6a 0c                	push   $0xc
  jmp __alltraps
  101f47:	e9 05 0a 00 00       	jmp    102951 <__alltraps>

00101f4c <vector13>:
.globl vector13
vector13:
  pushl $13
  101f4c:	6a 0d                	push   $0xd
  jmp __alltraps
  101f4e:	e9 fe 09 00 00       	jmp    102951 <__alltraps>

00101f53 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f53:	6a 0e                	push   $0xe
  jmp __alltraps
  101f55:	e9 f7 09 00 00       	jmp    102951 <__alltraps>

00101f5a <vector15>:
.globl vector15
vector15:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $15
  101f5c:	6a 0f                	push   $0xf
  jmp __alltraps
  101f5e:	e9 ee 09 00 00       	jmp    102951 <__alltraps>

00101f63 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $16
  101f65:	6a 10                	push   $0x10
  jmp __alltraps
  101f67:	e9 e5 09 00 00       	jmp    102951 <__alltraps>

00101f6c <vector17>:
.globl vector17
vector17:
  pushl $17
  101f6c:	6a 11                	push   $0x11
  jmp __alltraps
  101f6e:	e9 de 09 00 00       	jmp    102951 <__alltraps>

00101f73 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $18
  101f75:	6a 12                	push   $0x12
  jmp __alltraps
  101f77:	e9 d5 09 00 00       	jmp    102951 <__alltraps>

00101f7c <vector19>:
.globl vector19
vector19:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $19
  101f7e:	6a 13                	push   $0x13
  jmp __alltraps
  101f80:	e9 cc 09 00 00       	jmp    102951 <__alltraps>

00101f85 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $20
  101f87:	6a 14                	push   $0x14
  jmp __alltraps
  101f89:	e9 c3 09 00 00       	jmp    102951 <__alltraps>

00101f8e <vector21>:
.globl vector21
vector21:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $21
  101f90:	6a 15                	push   $0x15
  jmp __alltraps
  101f92:	e9 ba 09 00 00       	jmp    102951 <__alltraps>

00101f97 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $22
  101f99:	6a 16                	push   $0x16
  jmp __alltraps
  101f9b:	e9 b1 09 00 00       	jmp    102951 <__alltraps>

00101fa0 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $23
  101fa2:	6a 17                	push   $0x17
  jmp __alltraps
  101fa4:	e9 a8 09 00 00       	jmp    102951 <__alltraps>

00101fa9 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $24
  101fab:	6a 18                	push   $0x18
  jmp __alltraps
  101fad:	e9 9f 09 00 00       	jmp    102951 <__alltraps>

00101fb2 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $25
  101fb4:	6a 19                	push   $0x19
  jmp __alltraps
  101fb6:	e9 96 09 00 00       	jmp    102951 <__alltraps>

00101fbb <vector26>:
.globl vector26
vector26:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $26
  101fbd:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fbf:	e9 8d 09 00 00       	jmp    102951 <__alltraps>

00101fc4 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $27
  101fc6:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fc8:	e9 84 09 00 00       	jmp    102951 <__alltraps>

00101fcd <vector28>:
.globl vector28
vector28:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $28
  101fcf:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fd1:	e9 7b 09 00 00       	jmp    102951 <__alltraps>

00101fd6 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $29
  101fd8:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fda:	e9 72 09 00 00       	jmp    102951 <__alltraps>

00101fdf <vector30>:
.globl vector30
vector30:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $30
  101fe1:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fe3:	e9 69 09 00 00       	jmp    102951 <__alltraps>

00101fe8 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $31
  101fea:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fec:	e9 60 09 00 00       	jmp    102951 <__alltraps>

00101ff1 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $32
  101ff3:	6a 20                	push   $0x20
  jmp __alltraps
  101ff5:	e9 57 09 00 00       	jmp    102951 <__alltraps>

00101ffa <vector33>:
.globl vector33
vector33:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $33
  101ffc:	6a 21                	push   $0x21
  jmp __alltraps
  101ffe:	e9 4e 09 00 00       	jmp    102951 <__alltraps>

00102003 <vector34>:
.globl vector34
vector34:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $34
  102005:	6a 22                	push   $0x22
  jmp __alltraps
  102007:	e9 45 09 00 00       	jmp    102951 <__alltraps>

0010200c <vector35>:
.globl vector35
vector35:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $35
  10200e:	6a 23                	push   $0x23
  jmp __alltraps
  102010:	e9 3c 09 00 00       	jmp    102951 <__alltraps>

00102015 <vector36>:
.globl vector36
vector36:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $36
  102017:	6a 24                	push   $0x24
  jmp __alltraps
  102019:	e9 33 09 00 00       	jmp    102951 <__alltraps>

0010201e <vector37>:
.globl vector37
vector37:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $37
  102020:	6a 25                	push   $0x25
  jmp __alltraps
  102022:	e9 2a 09 00 00       	jmp    102951 <__alltraps>

00102027 <vector38>:
.globl vector38
vector38:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $38
  102029:	6a 26                	push   $0x26
  jmp __alltraps
  10202b:	e9 21 09 00 00       	jmp    102951 <__alltraps>

00102030 <vector39>:
.globl vector39
vector39:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $39
  102032:	6a 27                	push   $0x27
  jmp __alltraps
  102034:	e9 18 09 00 00       	jmp    102951 <__alltraps>

00102039 <vector40>:
.globl vector40
vector40:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $40
  10203b:	6a 28                	push   $0x28
  jmp __alltraps
  10203d:	e9 0f 09 00 00       	jmp    102951 <__alltraps>

00102042 <vector41>:
.globl vector41
vector41:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $41
  102044:	6a 29                	push   $0x29
  jmp __alltraps
  102046:	e9 06 09 00 00       	jmp    102951 <__alltraps>

0010204b <vector42>:
.globl vector42
vector42:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $42
  10204d:	6a 2a                	push   $0x2a
  jmp __alltraps
  10204f:	e9 fd 08 00 00       	jmp    102951 <__alltraps>

00102054 <vector43>:
.globl vector43
vector43:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $43
  102056:	6a 2b                	push   $0x2b
  jmp __alltraps
  102058:	e9 f4 08 00 00       	jmp    102951 <__alltraps>

0010205d <vector44>:
.globl vector44
vector44:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $44
  10205f:	6a 2c                	push   $0x2c
  jmp __alltraps
  102061:	e9 eb 08 00 00       	jmp    102951 <__alltraps>

00102066 <vector45>:
.globl vector45
vector45:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $45
  102068:	6a 2d                	push   $0x2d
  jmp __alltraps
  10206a:	e9 e2 08 00 00       	jmp    102951 <__alltraps>

0010206f <vector46>:
.globl vector46
vector46:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $46
  102071:	6a 2e                	push   $0x2e
  jmp __alltraps
  102073:	e9 d9 08 00 00       	jmp    102951 <__alltraps>

00102078 <vector47>:
.globl vector47
vector47:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $47
  10207a:	6a 2f                	push   $0x2f
  jmp __alltraps
  10207c:	e9 d0 08 00 00       	jmp    102951 <__alltraps>

00102081 <vector48>:
.globl vector48
vector48:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $48
  102083:	6a 30                	push   $0x30
  jmp __alltraps
  102085:	e9 c7 08 00 00       	jmp    102951 <__alltraps>

0010208a <vector49>:
.globl vector49
vector49:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $49
  10208c:	6a 31                	push   $0x31
  jmp __alltraps
  10208e:	e9 be 08 00 00       	jmp    102951 <__alltraps>

00102093 <vector50>:
.globl vector50
vector50:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $50
  102095:	6a 32                	push   $0x32
  jmp __alltraps
  102097:	e9 b5 08 00 00       	jmp    102951 <__alltraps>

0010209c <vector51>:
.globl vector51
vector51:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $51
  10209e:	6a 33                	push   $0x33
  jmp __alltraps
  1020a0:	e9 ac 08 00 00       	jmp    102951 <__alltraps>

001020a5 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $52
  1020a7:	6a 34                	push   $0x34
  jmp __alltraps
  1020a9:	e9 a3 08 00 00       	jmp    102951 <__alltraps>

001020ae <vector53>:
.globl vector53
vector53:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $53
  1020b0:	6a 35                	push   $0x35
  jmp __alltraps
  1020b2:	e9 9a 08 00 00       	jmp    102951 <__alltraps>

001020b7 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $54
  1020b9:	6a 36                	push   $0x36
  jmp __alltraps
  1020bb:	e9 91 08 00 00       	jmp    102951 <__alltraps>

001020c0 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $55
  1020c2:	6a 37                	push   $0x37
  jmp __alltraps
  1020c4:	e9 88 08 00 00       	jmp    102951 <__alltraps>

001020c9 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $56
  1020cb:	6a 38                	push   $0x38
  jmp __alltraps
  1020cd:	e9 7f 08 00 00       	jmp    102951 <__alltraps>

001020d2 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $57
  1020d4:	6a 39                	push   $0x39
  jmp __alltraps
  1020d6:	e9 76 08 00 00       	jmp    102951 <__alltraps>

001020db <vector58>:
.globl vector58
vector58:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $58
  1020dd:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020df:	e9 6d 08 00 00       	jmp    102951 <__alltraps>

001020e4 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $59
  1020e6:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020e8:	e9 64 08 00 00       	jmp    102951 <__alltraps>

001020ed <vector60>:
.globl vector60
vector60:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $60
  1020ef:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020f1:	e9 5b 08 00 00       	jmp    102951 <__alltraps>

001020f6 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $61
  1020f8:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020fa:	e9 52 08 00 00       	jmp    102951 <__alltraps>

001020ff <vector62>:
.globl vector62
vector62:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $62
  102101:	6a 3e                	push   $0x3e
  jmp __alltraps
  102103:	e9 49 08 00 00       	jmp    102951 <__alltraps>

00102108 <vector63>:
.globl vector63
vector63:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $63
  10210a:	6a 3f                	push   $0x3f
  jmp __alltraps
  10210c:	e9 40 08 00 00       	jmp    102951 <__alltraps>

00102111 <vector64>:
.globl vector64
vector64:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $64
  102113:	6a 40                	push   $0x40
  jmp __alltraps
  102115:	e9 37 08 00 00       	jmp    102951 <__alltraps>

0010211a <vector65>:
.globl vector65
vector65:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $65
  10211c:	6a 41                	push   $0x41
  jmp __alltraps
  10211e:	e9 2e 08 00 00       	jmp    102951 <__alltraps>

00102123 <vector66>:
.globl vector66
vector66:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $66
  102125:	6a 42                	push   $0x42
  jmp __alltraps
  102127:	e9 25 08 00 00       	jmp    102951 <__alltraps>

0010212c <vector67>:
.globl vector67
vector67:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $67
  10212e:	6a 43                	push   $0x43
  jmp __alltraps
  102130:	e9 1c 08 00 00       	jmp    102951 <__alltraps>

00102135 <vector68>:
.globl vector68
vector68:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $68
  102137:	6a 44                	push   $0x44
  jmp __alltraps
  102139:	e9 13 08 00 00       	jmp    102951 <__alltraps>

0010213e <vector69>:
.globl vector69
vector69:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $69
  102140:	6a 45                	push   $0x45
  jmp __alltraps
  102142:	e9 0a 08 00 00       	jmp    102951 <__alltraps>

00102147 <vector70>:
.globl vector70
vector70:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $70
  102149:	6a 46                	push   $0x46
  jmp __alltraps
  10214b:	e9 01 08 00 00       	jmp    102951 <__alltraps>

00102150 <vector71>:
.globl vector71
vector71:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $71
  102152:	6a 47                	push   $0x47
  jmp __alltraps
  102154:	e9 f8 07 00 00       	jmp    102951 <__alltraps>

00102159 <vector72>:
.globl vector72
vector72:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $72
  10215b:	6a 48                	push   $0x48
  jmp __alltraps
  10215d:	e9 ef 07 00 00       	jmp    102951 <__alltraps>

00102162 <vector73>:
.globl vector73
vector73:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $73
  102164:	6a 49                	push   $0x49
  jmp __alltraps
  102166:	e9 e6 07 00 00       	jmp    102951 <__alltraps>

0010216b <vector74>:
.globl vector74
vector74:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $74
  10216d:	6a 4a                	push   $0x4a
  jmp __alltraps
  10216f:	e9 dd 07 00 00       	jmp    102951 <__alltraps>

00102174 <vector75>:
.globl vector75
vector75:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $75
  102176:	6a 4b                	push   $0x4b
  jmp __alltraps
  102178:	e9 d4 07 00 00       	jmp    102951 <__alltraps>

0010217d <vector76>:
.globl vector76
vector76:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $76
  10217f:	6a 4c                	push   $0x4c
  jmp __alltraps
  102181:	e9 cb 07 00 00       	jmp    102951 <__alltraps>

00102186 <vector77>:
.globl vector77
vector77:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $77
  102188:	6a 4d                	push   $0x4d
  jmp __alltraps
  10218a:	e9 c2 07 00 00       	jmp    102951 <__alltraps>

0010218f <vector78>:
.globl vector78
vector78:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $78
  102191:	6a 4e                	push   $0x4e
  jmp __alltraps
  102193:	e9 b9 07 00 00       	jmp    102951 <__alltraps>

00102198 <vector79>:
.globl vector79
vector79:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $79
  10219a:	6a 4f                	push   $0x4f
  jmp __alltraps
  10219c:	e9 b0 07 00 00       	jmp    102951 <__alltraps>

001021a1 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $80
  1021a3:	6a 50                	push   $0x50
  jmp __alltraps
  1021a5:	e9 a7 07 00 00       	jmp    102951 <__alltraps>

001021aa <vector81>:
.globl vector81
vector81:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $81
  1021ac:	6a 51                	push   $0x51
  jmp __alltraps
  1021ae:	e9 9e 07 00 00       	jmp    102951 <__alltraps>

001021b3 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $82
  1021b5:	6a 52                	push   $0x52
  jmp __alltraps
  1021b7:	e9 95 07 00 00       	jmp    102951 <__alltraps>

001021bc <vector83>:
.globl vector83
vector83:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $83
  1021be:	6a 53                	push   $0x53
  jmp __alltraps
  1021c0:	e9 8c 07 00 00       	jmp    102951 <__alltraps>

001021c5 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $84
  1021c7:	6a 54                	push   $0x54
  jmp __alltraps
  1021c9:	e9 83 07 00 00       	jmp    102951 <__alltraps>

001021ce <vector85>:
.globl vector85
vector85:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $85
  1021d0:	6a 55                	push   $0x55
  jmp __alltraps
  1021d2:	e9 7a 07 00 00       	jmp    102951 <__alltraps>

001021d7 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $86
  1021d9:	6a 56                	push   $0x56
  jmp __alltraps
  1021db:	e9 71 07 00 00       	jmp    102951 <__alltraps>

001021e0 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $87
  1021e2:	6a 57                	push   $0x57
  jmp __alltraps
  1021e4:	e9 68 07 00 00       	jmp    102951 <__alltraps>

001021e9 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $88
  1021eb:	6a 58                	push   $0x58
  jmp __alltraps
  1021ed:	e9 5f 07 00 00       	jmp    102951 <__alltraps>

001021f2 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $89
  1021f4:	6a 59                	push   $0x59
  jmp __alltraps
  1021f6:	e9 56 07 00 00       	jmp    102951 <__alltraps>

001021fb <vector90>:
.globl vector90
vector90:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $90
  1021fd:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021ff:	e9 4d 07 00 00       	jmp    102951 <__alltraps>

00102204 <vector91>:
.globl vector91
vector91:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $91
  102206:	6a 5b                	push   $0x5b
  jmp __alltraps
  102208:	e9 44 07 00 00       	jmp    102951 <__alltraps>

0010220d <vector92>:
.globl vector92
vector92:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $92
  10220f:	6a 5c                	push   $0x5c
  jmp __alltraps
  102211:	e9 3b 07 00 00       	jmp    102951 <__alltraps>

00102216 <vector93>:
.globl vector93
vector93:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $93
  102218:	6a 5d                	push   $0x5d
  jmp __alltraps
  10221a:	e9 32 07 00 00       	jmp    102951 <__alltraps>

0010221f <vector94>:
.globl vector94
vector94:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $94
  102221:	6a 5e                	push   $0x5e
  jmp __alltraps
  102223:	e9 29 07 00 00       	jmp    102951 <__alltraps>

00102228 <vector95>:
.globl vector95
vector95:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $95
  10222a:	6a 5f                	push   $0x5f
  jmp __alltraps
  10222c:	e9 20 07 00 00       	jmp    102951 <__alltraps>

00102231 <vector96>:
.globl vector96
vector96:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $96
  102233:	6a 60                	push   $0x60
  jmp __alltraps
  102235:	e9 17 07 00 00       	jmp    102951 <__alltraps>

0010223a <vector97>:
.globl vector97
vector97:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $97
  10223c:	6a 61                	push   $0x61
  jmp __alltraps
  10223e:	e9 0e 07 00 00       	jmp    102951 <__alltraps>

00102243 <vector98>:
.globl vector98
vector98:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $98
  102245:	6a 62                	push   $0x62
  jmp __alltraps
  102247:	e9 05 07 00 00       	jmp    102951 <__alltraps>

0010224c <vector99>:
.globl vector99
vector99:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $99
  10224e:	6a 63                	push   $0x63
  jmp __alltraps
  102250:	e9 fc 06 00 00       	jmp    102951 <__alltraps>

00102255 <vector100>:
.globl vector100
vector100:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $100
  102257:	6a 64                	push   $0x64
  jmp __alltraps
  102259:	e9 f3 06 00 00       	jmp    102951 <__alltraps>

0010225e <vector101>:
.globl vector101
vector101:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $101
  102260:	6a 65                	push   $0x65
  jmp __alltraps
  102262:	e9 ea 06 00 00       	jmp    102951 <__alltraps>

00102267 <vector102>:
.globl vector102
vector102:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $102
  102269:	6a 66                	push   $0x66
  jmp __alltraps
  10226b:	e9 e1 06 00 00       	jmp    102951 <__alltraps>

00102270 <vector103>:
.globl vector103
vector103:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $103
  102272:	6a 67                	push   $0x67
  jmp __alltraps
  102274:	e9 d8 06 00 00       	jmp    102951 <__alltraps>

00102279 <vector104>:
.globl vector104
vector104:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $104
  10227b:	6a 68                	push   $0x68
  jmp __alltraps
  10227d:	e9 cf 06 00 00       	jmp    102951 <__alltraps>

00102282 <vector105>:
.globl vector105
vector105:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $105
  102284:	6a 69                	push   $0x69
  jmp __alltraps
  102286:	e9 c6 06 00 00       	jmp    102951 <__alltraps>

0010228b <vector106>:
.globl vector106
vector106:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $106
  10228d:	6a 6a                	push   $0x6a
  jmp __alltraps
  10228f:	e9 bd 06 00 00       	jmp    102951 <__alltraps>

00102294 <vector107>:
.globl vector107
vector107:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $107
  102296:	6a 6b                	push   $0x6b
  jmp __alltraps
  102298:	e9 b4 06 00 00       	jmp    102951 <__alltraps>

0010229d <vector108>:
.globl vector108
vector108:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $108
  10229f:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022a1:	e9 ab 06 00 00       	jmp    102951 <__alltraps>

001022a6 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $109
  1022a8:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022aa:	e9 a2 06 00 00       	jmp    102951 <__alltraps>

001022af <vector110>:
.globl vector110
vector110:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $110
  1022b1:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022b3:	e9 99 06 00 00       	jmp    102951 <__alltraps>

001022b8 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $111
  1022ba:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022bc:	e9 90 06 00 00       	jmp    102951 <__alltraps>

001022c1 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $112
  1022c3:	6a 70                	push   $0x70
  jmp __alltraps
  1022c5:	e9 87 06 00 00       	jmp    102951 <__alltraps>

001022ca <vector113>:
.globl vector113
vector113:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $113
  1022cc:	6a 71                	push   $0x71
  jmp __alltraps
  1022ce:	e9 7e 06 00 00       	jmp    102951 <__alltraps>

001022d3 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $114
  1022d5:	6a 72                	push   $0x72
  jmp __alltraps
  1022d7:	e9 75 06 00 00       	jmp    102951 <__alltraps>

001022dc <vector115>:
.globl vector115
vector115:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $115
  1022de:	6a 73                	push   $0x73
  jmp __alltraps
  1022e0:	e9 6c 06 00 00       	jmp    102951 <__alltraps>

001022e5 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $116
  1022e7:	6a 74                	push   $0x74
  jmp __alltraps
  1022e9:	e9 63 06 00 00       	jmp    102951 <__alltraps>

001022ee <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $117
  1022f0:	6a 75                	push   $0x75
  jmp __alltraps
  1022f2:	e9 5a 06 00 00       	jmp    102951 <__alltraps>

001022f7 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $118
  1022f9:	6a 76                	push   $0x76
  jmp __alltraps
  1022fb:	e9 51 06 00 00       	jmp    102951 <__alltraps>

00102300 <vector119>:
.globl vector119
vector119:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $119
  102302:	6a 77                	push   $0x77
  jmp __alltraps
  102304:	e9 48 06 00 00       	jmp    102951 <__alltraps>

00102309 <vector120>:
.globl vector120
vector120:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $120
  10230b:	6a 78                	push   $0x78
  jmp __alltraps
  10230d:	e9 3f 06 00 00       	jmp    102951 <__alltraps>

00102312 <vector121>:
.globl vector121
vector121:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $121
  102314:	6a 79                	push   $0x79
  jmp __alltraps
  102316:	e9 36 06 00 00       	jmp    102951 <__alltraps>

0010231b <vector122>:
.globl vector122
vector122:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $122
  10231d:	6a 7a                	push   $0x7a
  jmp __alltraps
  10231f:	e9 2d 06 00 00       	jmp    102951 <__alltraps>

00102324 <vector123>:
.globl vector123
vector123:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $123
  102326:	6a 7b                	push   $0x7b
  jmp __alltraps
  102328:	e9 24 06 00 00       	jmp    102951 <__alltraps>

0010232d <vector124>:
.globl vector124
vector124:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $124
  10232f:	6a 7c                	push   $0x7c
  jmp __alltraps
  102331:	e9 1b 06 00 00       	jmp    102951 <__alltraps>

00102336 <vector125>:
.globl vector125
vector125:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $125
  102338:	6a 7d                	push   $0x7d
  jmp __alltraps
  10233a:	e9 12 06 00 00       	jmp    102951 <__alltraps>

0010233f <vector126>:
.globl vector126
vector126:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $126
  102341:	6a 7e                	push   $0x7e
  jmp __alltraps
  102343:	e9 09 06 00 00       	jmp    102951 <__alltraps>

00102348 <vector127>:
.globl vector127
vector127:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $127
  10234a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10234c:	e9 00 06 00 00       	jmp    102951 <__alltraps>

00102351 <vector128>:
.globl vector128
vector128:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $128
  102353:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102358:	e9 f4 05 00 00       	jmp    102951 <__alltraps>

0010235d <vector129>:
.globl vector129
vector129:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $129
  10235f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102364:	e9 e8 05 00 00       	jmp    102951 <__alltraps>

00102369 <vector130>:
.globl vector130
vector130:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $130
  10236b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102370:	e9 dc 05 00 00       	jmp    102951 <__alltraps>

00102375 <vector131>:
.globl vector131
vector131:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $131
  102377:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10237c:	e9 d0 05 00 00       	jmp    102951 <__alltraps>

00102381 <vector132>:
.globl vector132
vector132:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $132
  102383:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102388:	e9 c4 05 00 00       	jmp    102951 <__alltraps>

0010238d <vector133>:
.globl vector133
vector133:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $133
  10238f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102394:	e9 b8 05 00 00       	jmp    102951 <__alltraps>

00102399 <vector134>:
.globl vector134
vector134:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $134
  10239b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023a0:	e9 ac 05 00 00       	jmp    102951 <__alltraps>

001023a5 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $135
  1023a7:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023ac:	e9 a0 05 00 00       	jmp    102951 <__alltraps>

001023b1 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $136
  1023b3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023b8:	e9 94 05 00 00       	jmp    102951 <__alltraps>

001023bd <vector137>:
.globl vector137
vector137:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $137
  1023bf:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023c4:	e9 88 05 00 00       	jmp    102951 <__alltraps>

001023c9 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $138
  1023cb:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023d0:	e9 7c 05 00 00       	jmp    102951 <__alltraps>

001023d5 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $139
  1023d7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023dc:	e9 70 05 00 00       	jmp    102951 <__alltraps>

001023e1 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $140
  1023e3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023e8:	e9 64 05 00 00       	jmp    102951 <__alltraps>

001023ed <vector141>:
.globl vector141
vector141:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $141
  1023ef:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023f4:	e9 58 05 00 00       	jmp    102951 <__alltraps>

001023f9 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $142
  1023fb:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102400:	e9 4c 05 00 00       	jmp    102951 <__alltraps>

00102405 <vector143>:
.globl vector143
vector143:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $143
  102407:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10240c:	e9 40 05 00 00       	jmp    102951 <__alltraps>

00102411 <vector144>:
.globl vector144
vector144:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $144
  102413:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102418:	e9 34 05 00 00       	jmp    102951 <__alltraps>

0010241d <vector145>:
.globl vector145
vector145:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $145
  10241f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102424:	e9 28 05 00 00       	jmp    102951 <__alltraps>

00102429 <vector146>:
.globl vector146
vector146:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $146
  10242b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102430:	e9 1c 05 00 00       	jmp    102951 <__alltraps>

00102435 <vector147>:
.globl vector147
vector147:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $147
  102437:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10243c:	e9 10 05 00 00       	jmp    102951 <__alltraps>

00102441 <vector148>:
.globl vector148
vector148:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $148
  102443:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102448:	e9 04 05 00 00       	jmp    102951 <__alltraps>

0010244d <vector149>:
.globl vector149
vector149:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $149
  10244f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102454:	e9 f8 04 00 00       	jmp    102951 <__alltraps>

00102459 <vector150>:
.globl vector150
vector150:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $150
  10245b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102460:	e9 ec 04 00 00       	jmp    102951 <__alltraps>

00102465 <vector151>:
.globl vector151
vector151:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $151
  102467:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10246c:	e9 e0 04 00 00       	jmp    102951 <__alltraps>

00102471 <vector152>:
.globl vector152
vector152:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $152
  102473:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102478:	e9 d4 04 00 00       	jmp    102951 <__alltraps>

0010247d <vector153>:
.globl vector153
vector153:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $153
  10247f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102484:	e9 c8 04 00 00       	jmp    102951 <__alltraps>

00102489 <vector154>:
.globl vector154
vector154:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $154
  10248b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102490:	e9 bc 04 00 00       	jmp    102951 <__alltraps>

00102495 <vector155>:
.globl vector155
vector155:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $155
  102497:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10249c:	e9 b0 04 00 00       	jmp    102951 <__alltraps>

001024a1 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $156
  1024a3:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024a8:	e9 a4 04 00 00       	jmp    102951 <__alltraps>

001024ad <vector157>:
.globl vector157
vector157:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $157
  1024af:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024b4:	e9 98 04 00 00       	jmp    102951 <__alltraps>

001024b9 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $158
  1024bb:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024c0:	e9 8c 04 00 00       	jmp    102951 <__alltraps>

001024c5 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $159
  1024c7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024cc:	e9 80 04 00 00       	jmp    102951 <__alltraps>

001024d1 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $160
  1024d3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024d8:	e9 74 04 00 00       	jmp    102951 <__alltraps>

001024dd <vector161>:
.globl vector161
vector161:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $161
  1024df:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024e4:	e9 68 04 00 00       	jmp    102951 <__alltraps>

001024e9 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $162
  1024eb:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024f0:	e9 5c 04 00 00       	jmp    102951 <__alltraps>

001024f5 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $163
  1024f7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024fc:	e9 50 04 00 00       	jmp    102951 <__alltraps>

00102501 <vector164>:
.globl vector164
vector164:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $164
  102503:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102508:	e9 44 04 00 00       	jmp    102951 <__alltraps>

0010250d <vector165>:
.globl vector165
vector165:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $165
  10250f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102514:	e9 38 04 00 00       	jmp    102951 <__alltraps>

00102519 <vector166>:
.globl vector166
vector166:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $166
  10251b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102520:	e9 2c 04 00 00       	jmp    102951 <__alltraps>

00102525 <vector167>:
.globl vector167
vector167:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $167
  102527:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10252c:	e9 20 04 00 00       	jmp    102951 <__alltraps>

00102531 <vector168>:
.globl vector168
vector168:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $168
  102533:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102538:	e9 14 04 00 00       	jmp    102951 <__alltraps>

0010253d <vector169>:
.globl vector169
vector169:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $169
  10253f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102544:	e9 08 04 00 00       	jmp    102951 <__alltraps>

00102549 <vector170>:
.globl vector170
vector170:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $170
  10254b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102550:	e9 fc 03 00 00       	jmp    102951 <__alltraps>

00102555 <vector171>:
.globl vector171
vector171:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $171
  102557:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10255c:	e9 f0 03 00 00       	jmp    102951 <__alltraps>

00102561 <vector172>:
.globl vector172
vector172:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $172
  102563:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102568:	e9 e4 03 00 00       	jmp    102951 <__alltraps>

0010256d <vector173>:
.globl vector173
vector173:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $173
  10256f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102574:	e9 d8 03 00 00       	jmp    102951 <__alltraps>

00102579 <vector174>:
.globl vector174
vector174:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $174
  10257b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102580:	e9 cc 03 00 00       	jmp    102951 <__alltraps>

00102585 <vector175>:
.globl vector175
vector175:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $175
  102587:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10258c:	e9 c0 03 00 00       	jmp    102951 <__alltraps>

00102591 <vector176>:
.globl vector176
vector176:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $176
  102593:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102598:	e9 b4 03 00 00       	jmp    102951 <__alltraps>

0010259d <vector177>:
.globl vector177
vector177:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $177
  10259f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025a4:	e9 a8 03 00 00       	jmp    102951 <__alltraps>

001025a9 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $178
  1025ab:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025b0:	e9 9c 03 00 00       	jmp    102951 <__alltraps>

001025b5 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $179
  1025b7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025bc:	e9 90 03 00 00       	jmp    102951 <__alltraps>

001025c1 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $180
  1025c3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025c8:	e9 84 03 00 00       	jmp    102951 <__alltraps>

001025cd <vector181>:
.globl vector181
vector181:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $181
  1025cf:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025d4:	e9 78 03 00 00       	jmp    102951 <__alltraps>

001025d9 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $182
  1025db:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025e0:	e9 6c 03 00 00       	jmp    102951 <__alltraps>

001025e5 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $183
  1025e7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025ec:	e9 60 03 00 00       	jmp    102951 <__alltraps>

001025f1 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $184
  1025f3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025f8:	e9 54 03 00 00       	jmp    102951 <__alltraps>

001025fd <vector185>:
.globl vector185
vector185:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $185
  1025ff:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102604:	e9 48 03 00 00       	jmp    102951 <__alltraps>

00102609 <vector186>:
.globl vector186
vector186:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $186
  10260b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102610:	e9 3c 03 00 00       	jmp    102951 <__alltraps>

00102615 <vector187>:
.globl vector187
vector187:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $187
  102617:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10261c:	e9 30 03 00 00       	jmp    102951 <__alltraps>

00102621 <vector188>:
.globl vector188
vector188:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $188
  102623:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102628:	e9 24 03 00 00       	jmp    102951 <__alltraps>

0010262d <vector189>:
.globl vector189
vector189:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $189
  10262f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102634:	e9 18 03 00 00       	jmp    102951 <__alltraps>

00102639 <vector190>:
.globl vector190
vector190:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $190
  10263b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102640:	e9 0c 03 00 00       	jmp    102951 <__alltraps>

00102645 <vector191>:
.globl vector191
vector191:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $191
  102647:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10264c:	e9 00 03 00 00       	jmp    102951 <__alltraps>

00102651 <vector192>:
.globl vector192
vector192:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $192
  102653:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102658:	e9 f4 02 00 00       	jmp    102951 <__alltraps>

0010265d <vector193>:
.globl vector193
vector193:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $193
  10265f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102664:	e9 e8 02 00 00       	jmp    102951 <__alltraps>

00102669 <vector194>:
.globl vector194
vector194:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $194
  10266b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102670:	e9 dc 02 00 00       	jmp    102951 <__alltraps>

00102675 <vector195>:
.globl vector195
vector195:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $195
  102677:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10267c:	e9 d0 02 00 00       	jmp    102951 <__alltraps>

00102681 <vector196>:
.globl vector196
vector196:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $196
  102683:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102688:	e9 c4 02 00 00       	jmp    102951 <__alltraps>

0010268d <vector197>:
.globl vector197
vector197:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $197
  10268f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102694:	e9 b8 02 00 00       	jmp    102951 <__alltraps>

00102699 <vector198>:
.globl vector198
vector198:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $198
  10269b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026a0:	e9 ac 02 00 00       	jmp    102951 <__alltraps>

001026a5 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $199
  1026a7:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026ac:	e9 a0 02 00 00       	jmp    102951 <__alltraps>

001026b1 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $200
  1026b3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026b8:	e9 94 02 00 00       	jmp    102951 <__alltraps>

001026bd <vector201>:
.globl vector201
vector201:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $201
  1026bf:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026c4:	e9 88 02 00 00       	jmp    102951 <__alltraps>

001026c9 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $202
  1026cb:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026d0:	e9 7c 02 00 00       	jmp    102951 <__alltraps>

001026d5 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $203
  1026d7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026dc:	e9 70 02 00 00       	jmp    102951 <__alltraps>

001026e1 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $204
  1026e3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026e8:	e9 64 02 00 00       	jmp    102951 <__alltraps>

001026ed <vector205>:
.globl vector205
vector205:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $205
  1026ef:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026f4:	e9 58 02 00 00       	jmp    102951 <__alltraps>

001026f9 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $206
  1026fb:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102700:	e9 4c 02 00 00       	jmp    102951 <__alltraps>

00102705 <vector207>:
.globl vector207
vector207:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $207
  102707:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10270c:	e9 40 02 00 00       	jmp    102951 <__alltraps>

00102711 <vector208>:
.globl vector208
vector208:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $208
  102713:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102718:	e9 34 02 00 00       	jmp    102951 <__alltraps>

0010271d <vector209>:
.globl vector209
vector209:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $209
  10271f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102724:	e9 28 02 00 00       	jmp    102951 <__alltraps>

00102729 <vector210>:
.globl vector210
vector210:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $210
  10272b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102730:	e9 1c 02 00 00       	jmp    102951 <__alltraps>

00102735 <vector211>:
.globl vector211
vector211:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $211
  102737:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10273c:	e9 10 02 00 00       	jmp    102951 <__alltraps>

00102741 <vector212>:
.globl vector212
vector212:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $212
  102743:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102748:	e9 04 02 00 00       	jmp    102951 <__alltraps>

0010274d <vector213>:
.globl vector213
vector213:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $213
  10274f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102754:	e9 f8 01 00 00       	jmp    102951 <__alltraps>

00102759 <vector214>:
.globl vector214
vector214:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $214
  10275b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102760:	e9 ec 01 00 00       	jmp    102951 <__alltraps>

00102765 <vector215>:
.globl vector215
vector215:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $215
  102767:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10276c:	e9 e0 01 00 00       	jmp    102951 <__alltraps>

00102771 <vector216>:
.globl vector216
vector216:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $216
  102773:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102778:	e9 d4 01 00 00       	jmp    102951 <__alltraps>

0010277d <vector217>:
.globl vector217
vector217:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $217
  10277f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102784:	e9 c8 01 00 00       	jmp    102951 <__alltraps>

00102789 <vector218>:
.globl vector218
vector218:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $218
  10278b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102790:	e9 bc 01 00 00       	jmp    102951 <__alltraps>

00102795 <vector219>:
.globl vector219
vector219:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $219
  102797:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10279c:	e9 b0 01 00 00       	jmp    102951 <__alltraps>

001027a1 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $220
  1027a3:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027a8:	e9 a4 01 00 00       	jmp    102951 <__alltraps>

001027ad <vector221>:
.globl vector221
vector221:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $221
  1027af:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027b4:	e9 98 01 00 00       	jmp    102951 <__alltraps>

001027b9 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $222
  1027bb:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027c0:	e9 8c 01 00 00       	jmp    102951 <__alltraps>

001027c5 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $223
  1027c7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027cc:	e9 80 01 00 00       	jmp    102951 <__alltraps>

001027d1 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $224
  1027d3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027d8:	e9 74 01 00 00       	jmp    102951 <__alltraps>

001027dd <vector225>:
.globl vector225
vector225:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $225
  1027df:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027e4:	e9 68 01 00 00       	jmp    102951 <__alltraps>

001027e9 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $226
  1027eb:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027f0:	e9 5c 01 00 00       	jmp    102951 <__alltraps>

001027f5 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $227
  1027f7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027fc:	e9 50 01 00 00       	jmp    102951 <__alltraps>

00102801 <vector228>:
.globl vector228
vector228:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $228
  102803:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102808:	e9 44 01 00 00       	jmp    102951 <__alltraps>

0010280d <vector229>:
.globl vector229
vector229:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $229
  10280f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102814:	e9 38 01 00 00       	jmp    102951 <__alltraps>

00102819 <vector230>:
.globl vector230
vector230:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $230
  10281b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102820:	e9 2c 01 00 00       	jmp    102951 <__alltraps>

00102825 <vector231>:
.globl vector231
vector231:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $231
  102827:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10282c:	e9 20 01 00 00       	jmp    102951 <__alltraps>

00102831 <vector232>:
.globl vector232
vector232:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $232
  102833:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102838:	e9 14 01 00 00       	jmp    102951 <__alltraps>

0010283d <vector233>:
.globl vector233
vector233:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $233
  10283f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102844:	e9 08 01 00 00       	jmp    102951 <__alltraps>

00102849 <vector234>:
.globl vector234
vector234:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $234
  10284b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102850:	e9 fc 00 00 00       	jmp    102951 <__alltraps>

00102855 <vector235>:
.globl vector235
vector235:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $235
  102857:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10285c:	e9 f0 00 00 00       	jmp    102951 <__alltraps>

00102861 <vector236>:
.globl vector236
vector236:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $236
  102863:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102868:	e9 e4 00 00 00       	jmp    102951 <__alltraps>

0010286d <vector237>:
.globl vector237
vector237:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $237
  10286f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102874:	e9 d8 00 00 00       	jmp    102951 <__alltraps>

00102879 <vector238>:
.globl vector238
vector238:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $238
  10287b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102880:	e9 cc 00 00 00       	jmp    102951 <__alltraps>

00102885 <vector239>:
.globl vector239
vector239:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $239
  102887:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10288c:	e9 c0 00 00 00       	jmp    102951 <__alltraps>

00102891 <vector240>:
.globl vector240
vector240:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $240
  102893:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102898:	e9 b4 00 00 00       	jmp    102951 <__alltraps>

0010289d <vector241>:
.globl vector241
vector241:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $241
  10289f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028a4:	e9 a8 00 00 00       	jmp    102951 <__alltraps>

001028a9 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $242
  1028ab:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028b0:	e9 9c 00 00 00       	jmp    102951 <__alltraps>

001028b5 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $243
  1028b7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028bc:	e9 90 00 00 00       	jmp    102951 <__alltraps>

001028c1 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $244
  1028c3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028c8:	e9 84 00 00 00       	jmp    102951 <__alltraps>

001028cd <vector245>:
.globl vector245
vector245:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $245
  1028cf:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028d4:	e9 78 00 00 00       	jmp    102951 <__alltraps>

001028d9 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $246
  1028db:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028e0:	e9 6c 00 00 00       	jmp    102951 <__alltraps>

001028e5 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $247
  1028e7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028ec:	e9 60 00 00 00       	jmp    102951 <__alltraps>

001028f1 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $248
  1028f3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028f8:	e9 54 00 00 00       	jmp    102951 <__alltraps>

001028fd <vector249>:
.globl vector249
vector249:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $249
  1028ff:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102904:	e9 48 00 00 00       	jmp    102951 <__alltraps>

00102909 <vector250>:
.globl vector250
vector250:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $250
  10290b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102910:	e9 3c 00 00 00       	jmp    102951 <__alltraps>

00102915 <vector251>:
.globl vector251
vector251:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $251
  102917:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10291c:	e9 30 00 00 00       	jmp    102951 <__alltraps>

00102921 <vector252>:
.globl vector252
vector252:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $252
  102923:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102928:	e9 24 00 00 00       	jmp    102951 <__alltraps>

0010292d <vector253>:
.globl vector253
vector253:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $253
  10292f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102934:	e9 18 00 00 00       	jmp    102951 <__alltraps>

00102939 <vector254>:
.globl vector254
vector254:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $254
  10293b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102940:	e9 0c 00 00 00       	jmp    102951 <__alltraps>

00102945 <vector255>:
.globl vector255
vector255:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $255
  102947:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10294c:	e9 00 00 00 00       	jmp    102951 <__alltraps>

00102951 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102951:	1e                   	push   %ds
    pushl %es
  102952:	06                   	push   %es
    pushl %fs
  102953:	0f a0                	push   %fs
    pushl %gs
  102955:	0f a8                	push   %gs
    pushal
  102957:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102958:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10295d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10295f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102961:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102962:	e8 61 f5 ff ff       	call   101ec8 <trap>

    # pop the pushed stack pointer
    popl %esp
  102967:	5c                   	pop    %esp

00102968 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102968:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102969:	0f a9                	pop    %gs
    popl %fs
  10296b:	0f a1                	pop    %fs
    popl %es
  10296d:	07                   	pop    %es
    popl %ds
  10296e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10296f:	83 c4 08             	add    $0x8,%esp
    iret
  102972:	cf                   	iret   

00102973 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102973:	55                   	push   %ebp
  102974:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102976:	8b 45 08             	mov    0x8(%ebp),%eax
  102979:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  10297f:	29 d0                	sub    %edx,%eax
  102981:	c1 f8 02             	sar    $0x2,%eax
  102984:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10298a:	5d                   	pop    %ebp
  10298b:	c3                   	ret    

0010298c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10298c:	55                   	push   %ebp
  10298d:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  10298f:	ff 75 08             	pushl  0x8(%ebp)
  102992:	e8 dc ff ff ff       	call   102973 <page2ppn>
  102997:	83 c4 04             	add    $0x4,%esp
  10299a:	c1 e0 0c             	shl    $0xc,%eax
}
  10299d:	c9                   	leave  
  10299e:	c3                   	ret    

0010299f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  10299f:	55                   	push   %ebp
  1029a0:	89 e5                	mov    %esp,%ebp
  1029a2:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  1029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a8:	c1 e8 0c             	shr    $0xc,%eax
  1029ab:	89 c2                	mov    %eax,%edx
  1029ad:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1029b2:	39 c2                	cmp    %eax,%edx
  1029b4:	72 14                	jb     1029ca <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  1029b6:	83 ec 04             	sub    $0x4,%esp
  1029b9:	68 70 63 10 00       	push   $0x106370
  1029be:	6a 5a                	push   $0x5a
  1029c0:	68 8f 63 10 00       	push   $0x10638f
  1029c5:	e8 0b da ff ff       	call   1003d5 <__panic>
    }
    return &pages[PPN(pa)];
  1029ca:	8b 0d b8 89 11 00    	mov    0x1189b8,%ecx
  1029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d3:	c1 e8 0c             	shr    $0xc,%eax
  1029d6:	89 c2                	mov    %eax,%edx
  1029d8:	89 d0                	mov    %edx,%eax
  1029da:	c1 e0 02             	shl    $0x2,%eax
  1029dd:	01 d0                	add    %edx,%eax
  1029df:	c1 e0 02             	shl    $0x2,%eax
  1029e2:	01 c8                	add    %ecx,%eax
}
  1029e4:	c9                   	leave  
  1029e5:	c3                   	ret    

001029e6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1029e6:	55                   	push   %ebp
  1029e7:	89 e5                	mov    %esp,%ebp
  1029e9:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  1029ec:	ff 75 08             	pushl  0x8(%ebp)
  1029ef:	e8 98 ff ff ff       	call   10298c <page2pa>
  1029f4:	83 c4 04             	add    $0x4,%esp
  1029f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029fd:	c1 e8 0c             	shr    $0xc,%eax
  102a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a03:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102a08:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102a0b:	72 14                	jb     102a21 <page2kva+0x3b>
  102a0d:	ff 75 f4             	pushl  -0xc(%ebp)
  102a10:	68 a0 63 10 00       	push   $0x1063a0
  102a15:	6a 61                	push   $0x61
  102a17:	68 8f 63 10 00       	push   $0x10638f
  102a1c:	e8 b4 d9 ff ff       	call   1003d5 <__panic>
  102a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a24:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a29:	c9                   	leave  
  102a2a:	c3                   	ret    

00102a2b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102a2b:	55                   	push   %ebp
  102a2c:	89 e5                	mov    %esp,%ebp
  102a2e:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  102a31:	8b 45 08             	mov    0x8(%ebp),%eax
  102a34:	83 e0 01             	and    $0x1,%eax
  102a37:	85 c0                	test   %eax,%eax
  102a39:	75 14                	jne    102a4f <pte2page+0x24>
        panic("pte2page called with invalid pte");
  102a3b:	83 ec 04             	sub    $0x4,%esp
  102a3e:	68 c4 63 10 00       	push   $0x1063c4
  102a43:	6a 6c                	push   $0x6c
  102a45:	68 8f 63 10 00       	push   $0x10638f
  102a4a:	e8 86 d9 ff ff       	call   1003d5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a57:	83 ec 0c             	sub    $0xc,%esp
  102a5a:	50                   	push   %eax
  102a5b:	e8 3f ff ff ff       	call   10299f <pa2page>
  102a60:	83 c4 10             	add    $0x10,%esp
}
  102a63:	c9                   	leave  
  102a64:	c3                   	ret    

00102a65 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102a65:	55                   	push   %ebp
  102a66:	89 e5                	mov    %esp,%ebp
  102a68:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  102a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a73:	83 ec 0c             	sub    $0xc,%esp
  102a76:	50                   	push   %eax
  102a77:	e8 23 ff ff ff       	call   10299f <pa2page>
  102a7c:	83 c4 10             	add    $0x10,%esp
}
  102a7f:	c9                   	leave  
  102a80:	c3                   	ret    

00102a81 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102a81:	55                   	push   %ebp
  102a82:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a84:	8b 45 08             	mov    0x8(%ebp),%eax
  102a87:	8b 00                	mov    (%eax),%eax
}
  102a89:	5d                   	pop    %ebp
  102a8a:	c3                   	ret    

00102a8b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a8b:	55                   	push   %ebp
  102a8c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a94:	89 10                	mov    %edx,(%eax)
}
  102a96:	90                   	nop
  102a97:	5d                   	pop    %ebp
  102a98:	c3                   	ret    

00102a99 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102a99:	55                   	push   %ebp
  102a9a:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9f:	8b 00                	mov    (%eax),%eax
  102aa1:	8d 50 01             	lea    0x1(%eax),%edx
  102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa7:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  102aac:	8b 00                	mov    (%eax),%eax
}
  102aae:	5d                   	pop    %ebp
  102aaf:	c3                   	ret    

00102ab0 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102ab0:	55                   	push   %ebp
  102ab1:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab6:	8b 00                	mov    (%eax),%eax
  102ab8:	8d 50 ff             	lea    -0x1(%eax),%edx
  102abb:	8b 45 08             	mov    0x8(%ebp),%eax
  102abe:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac3:	8b 00                	mov    (%eax),%eax
}
  102ac5:	5d                   	pop    %ebp
  102ac6:	c3                   	ret    

00102ac7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  102ac7:	55                   	push   %ebp
  102ac8:	89 e5                	mov    %esp,%ebp
  102aca:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102acd:	9c                   	pushf  
  102ace:	58                   	pop    %eax
  102acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102ad5:	25 00 02 00 00       	and    $0x200,%eax
  102ada:	85 c0                	test   %eax,%eax
  102adc:	74 0c                	je     102aea <__intr_save+0x23>
        intr_disable();
  102ade:	e8 93 ed ff ff       	call   101876 <intr_disable>
        return 1;
  102ae3:	b8 01 00 00 00       	mov    $0x1,%eax
  102ae8:	eb 05                	jmp    102aef <__intr_save+0x28>
    }
    return 0;
  102aea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102aef:	c9                   	leave  
  102af0:	c3                   	ret    

00102af1 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102af1:	55                   	push   %ebp
  102af2:	89 e5                	mov    %esp,%ebp
  102af4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102af7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102afb:	74 05                	je     102b02 <__intr_restore+0x11>
        intr_enable();
  102afd:	e8 6d ed ff ff       	call   10186f <intr_enable>
    }
}
  102b02:	90                   	nop
  102b03:	c9                   	leave  
  102b04:	c3                   	ret    

00102b05 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b05:	55                   	push   %ebp
  102b06:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b08:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b0e:	b8 23 00 00 00       	mov    $0x23,%eax
  102b13:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b15:	b8 23 00 00 00       	mov    $0x23,%eax
  102b1a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b1c:	b8 10 00 00 00       	mov    $0x10,%eax
  102b21:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b23:	b8 10 00 00 00       	mov    $0x10,%eax
  102b28:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b2a:	b8 10 00 00 00       	mov    $0x10,%eax
  102b2f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b31:	ea 38 2b 10 00 08 00 	ljmp   $0x8,$0x102b38
}
  102b38:	90                   	nop
  102b39:	5d                   	pop    %ebp
  102b3a:	c3                   	ret    

00102b3b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b3b:	55                   	push   %ebp
  102b3c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b41:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  102b46:	90                   	nop
  102b47:	5d                   	pop    %ebp
  102b48:	c3                   	ret    

00102b49 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b49:	55                   	push   %ebp
  102b4a:	89 e5                	mov    %esp,%ebp
  102b4c:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102b4f:	b8 00 70 11 00       	mov    $0x117000,%eax
  102b54:	50                   	push   %eax
  102b55:	e8 e1 ff ff ff       	call   102b3b <load_esp0>
  102b5a:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102b5d:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102b64:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102b66:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102b6d:	68 00 
  102b6f:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102b74:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102b7a:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102b7f:	c1 e8 10             	shr    $0x10,%eax
  102b82:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102b87:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102b8e:	83 e0 f0             	and    $0xfffffff0,%eax
  102b91:	83 c8 09             	or     $0x9,%eax
  102b94:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102b99:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ba0:	83 e0 ef             	and    $0xffffffef,%eax
  102ba3:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102ba8:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102baf:	83 e0 9f             	and    $0xffffff9f,%eax
  102bb2:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102bb7:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102bbe:	83 c8 80             	or     $0xffffff80,%eax
  102bc1:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102bc6:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102bcd:	83 e0 f0             	and    $0xfffffff0,%eax
  102bd0:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102bd5:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102bdc:	83 e0 ef             	and    $0xffffffef,%eax
  102bdf:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102be4:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102beb:	83 e0 df             	and    $0xffffffdf,%eax
  102bee:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102bf3:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102bfa:	83 c8 40             	or     $0x40,%eax
  102bfd:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c02:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c09:	83 e0 7f             	and    $0x7f,%eax
  102c0c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c11:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102c16:	c1 e8 18             	shr    $0x18,%eax
  102c19:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c1e:	68 30 7a 11 00       	push   $0x117a30
  102c23:	e8 dd fe ff ff       	call   102b05 <lgdt>
  102c28:	83 c4 04             	add    $0x4,%esp
  102c2b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c31:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c35:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102c38:	90                   	nop
  102c39:	c9                   	leave  
  102c3a:	c3                   	ret    

00102c3b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c3b:	55                   	push   %ebp
  102c3c:	89 e5                	mov    %esp,%ebp
  102c3e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102c41:	c7 05 b0 89 11 00 50 	movl   $0x106d50,0x1189b0
  102c48:	6d 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102c4b:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102c50:	8b 00                	mov    (%eax),%eax
  102c52:	83 ec 08             	sub    $0x8,%esp
  102c55:	50                   	push   %eax
  102c56:	68 f0 63 10 00       	push   $0x1063f0
  102c5b:	e8 0f d6 ff ff       	call   10026f <cprintf>
  102c60:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102c63:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102c68:	8b 40 04             	mov    0x4(%eax),%eax
  102c6b:	ff d0                	call   *%eax
}
  102c6d:	90                   	nop
  102c6e:	c9                   	leave  
  102c6f:	c3                   	ret    

00102c70 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102c70:	55                   	push   %ebp
  102c71:	89 e5                	mov    %esp,%ebp
  102c73:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102c76:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102c7b:	8b 40 08             	mov    0x8(%eax),%eax
  102c7e:	83 ec 08             	sub    $0x8,%esp
  102c81:	ff 75 0c             	pushl  0xc(%ebp)
  102c84:	ff 75 08             	pushl  0x8(%ebp)
  102c87:	ff d0                	call   *%eax
  102c89:	83 c4 10             	add    $0x10,%esp
}
  102c8c:	90                   	nop
  102c8d:	c9                   	leave  
  102c8e:	c3                   	ret    

00102c8f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102c8f:	55                   	push   %ebp
  102c90:	89 e5                	mov    %esp,%ebp
  102c92:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102c95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);     // save interrupt state
  102c9c:	e8 26 fe ff ff       	call   102ac7 <__intr_save>
  102ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102ca4:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  102cac:	83 ec 0c             	sub    $0xc,%esp
  102caf:	ff 75 08             	pushl  0x8(%ebp)
  102cb2:	ff d0                	call   *%eax
  102cb4:	83 c4 10             	add    $0x10,%esp
  102cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102cba:	83 ec 0c             	sub    $0xc,%esp
  102cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  102cc0:	e8 2c fe ff ff       	call   102af1 <__intr_restore>
  102cc5:	83 c4 10             	add    $0x10,%esp
    return page;
  102cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ccb:	c9                   	leave  
  102ccc:	c3                   	ret    

00102ccd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102ccd:	55                   	push   %ebp
  102cce:	89 e5                	mov    %esp,%ebp
  102cd0:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102cd3:	e8 ef fd ff ff       	call   102ac7 <__intr_save>
  102cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102cdb:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102ce0:	8b 40 10             	mov    0x10(%eax),%eax
  102ce3:	83 ec 08             	sub    $0x8,%esp
  102ce6:	ff 75 0c             	pushl  0xc(%ebp)
  102ce9:	ff 75 08             	pushl  0x8(%ebp)
  102cec:	ff d0                	call   *%eax
  102cee:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102cf1:	83 ec 0c             	sub    $0xc,%esp
  102cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  102cf7:	e8 f5 fd ff ff       	call   102af1 <__intr_restore>
  102cfc:	83 c4 10             	add    $0x10,%esp
}
  102cff:	90                   	nop
  102d00:	c9                   	leave  
  102d01:	c3                   	ret    

00102d02 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102d02:	55                   	push   %ebp
  102d03:	89 e5                	mov    %esp,%ebp
  102d05:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102d08:	e8 ba fd ff ff       	call   102ac7 <__intr_save>
  102d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d10:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102d15:	8b 40 14             	mov    0x14(%eax),%eax
  102d18:	ff d0                	call   *%eax
  102d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d1d:	83 ec 0c             	sub    $0xc,%esp
  102d20:	ff 75 f4             	pushl  -0xc(%ebp)
  102d23:	e8 c9 fd ff ff       	call   102af1 <__intr_restore>
  102d28:	83 c4 10             	add    $0x10,%esp
    return ret;
  102d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d2e:	c9                   	leave  
  102d2f:	c3                   	ret    

00102d30 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d30:	55                   	push   %ebp
  102d31:	89 e5                	mov    %esp,%ebp
  102d33:	57                   	push   %edi
  102d34:	56                   	push   %esi
  102d35:	53                   	push   %ebx
  102d36:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d39:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d4e:	83 ec 0c             	sub    $0xc,%esp
  102d51:	68 07 64 10 00       	push   $0x106407
  102d56:	e8 14 d5 ff ff       	call   10026f <cprintf>
  102d5b:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d65:	e9 fc 00 00 00       	jmp    102e66 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d70:	89 d0                	mov    %edx,%eax
  102d72:	c1 e0 02             	shl    $0x2,%eax
  102d75:	01 d0                	add    %edx,%eax
  102d77:	c1 e0 02             	shl    $0x2,%eax
  102d7a:	01 c8                	add    %ecx,%eax
  102d7c:	8b 50 08             	mov    0x8(%eax),%edx
  102d7f:	8b 40 04             	mov    0x4(%eax),%eax
  102d82:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102d85:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102d88:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d8e:	89 d0                	mov    %edx,%eax
  102d90:	c1 e0 02             	shl    $0x2,%eax
  102d93:	01 d0                	add    %edx,%eax
  102d95:	c1 e0 02             	shl    $0x2,%eax
  102d98:	01 c8                	add    %ecx,%eax
  102d9a:	8b 48 0c             	mov    0xc(%eax),%ecx
  102d9d:	8b 58 10             	mov    0x10(%eax),%ebx
  102da0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102da3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102da6:	01 c8                	add    %ecx,%eax
  102da8:	11 da                	adc    %ebx,%edx
  102daa:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102dad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102db0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102db3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102db6:	89 d0                	mov    %edx,%eax
  102db8:	c1 e0 02             	shl    $0x2,%eax
  102dbb:	01 d0                	add    %edx,%eax
  102dbd:	c1 e0 02             	shl    $0x2,%eax
  102dc0:	01 c8                	add    %ecx,%eax
  102dc2:	83 c0 14             	add    $0x14,%eax
  102dc5:	8b 00                	mov    (%eax),%eax
  102dc7:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102dca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102dcd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102dd0:	83 c0 ff             	add    $0xffffffff,%eax
  102dd3:	83 d2 ff             	adc    $0xffffffff,%edx
  102dd6:	89 c1                	mov    %eax,%ecx
  102dd8:	89 d3                	mov    %edx,%ebx
  102dda:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102ddd:	89 55 80             	mov    %edx,-0x80(%ebp)
  102de0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102de3:	89 d0                	mov    %edx,%eax
  102de5:	c1 e0 02             	shl    $0x2,%eax
  102de8:	01 d0                	add    %edx,%eax
  102dea:	c1 e0 02             	shl    $0x2,%eax
  102ded:	03 45 80             	add    -0x80(%ebp),%eax
  102df0:	8b 50 10             	mov    0x10(%eax),%edx
  102df3:	8b 40 0c             	mov    0xc(%eax),%eax
  102df6:	ff 75 84             	pushl  -0x7c(%ebp)
  102df9:	53                   	push   %ebx
  102dfa:	51                   	push   %ecx
  102dfb:	ff 75 bc             	pushl  -0x44(%ebp)
  102dfe:	ff 75 b8             	pushl  -0x48(%ebp)
  102e01:	52                   	push   %edx
  102e02:	50                   	push   %eax
  102e03:	68 14 64 10 00       	push   $0x106414
  102e08:	e8 62 d4 ff ff       	call   10026f <cprintf>
  102e0d:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e10:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e13:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e16:	89 d0                	mov    %edx,%eax
  102e18:	c1 e0 02             	shl    $0x2,%eax
  102e1b:	01 d0                	add    %edx,%eax
  102e1d:	c1 e0 02             	shl    $0x2,%eax
  102e20:	01 c8                	add    %ecx,%eax
  102e22:	83 c0 14             	add    $0x14,%eax
  102e25:	8b 00                	mov    (%eax),%eax
  102e27:	83 f8 01             	cmp    $0x1,%eax
  102e2a:	75 36                	jne    102e62 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e32:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e35:	77 2b                	ja     102e62 <page_init+0x132>
  102e37:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e3a:	72 05                	jb     102e41 <page_init+0x111>
  102e3c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102e3f:	73 21                	jae    102e62 <page_init+0x132>
  102e41:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102e45:	77 1b                	ja     102e62 <page_init+0x132>
  102e47:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102e4b:	72 09                	jb     102e56 <page_init+0x126>
  102e4d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102e54:	77 0c                	ja     102e62 <page_init+0x132>
                maxpa = end;
  102e56:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e59:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102e62:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102e66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e69:	8b 00                	mov    (%eax),%eax
  102e6b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102e6e:	0f 8f f6 fe ff ff    	jg     102d6a <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e78:	72 1d                	jb     102e97 <page_init+0x167>
  102e7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e7e:	77 09                	ja     102e89 <page_init+0x159>
  102e80:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102e87:	76 0e                	jbe    102e97 <page_init+0x167>
        maxpa = KMEMSIZE;
  102e89:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102e90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
  102e97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e9d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102ea1:	c1 ea 0c             	shr    $0xc,%edx
  102ea4:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102ea9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102eb0:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  102eb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  102eb8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102ebb:	01 d0                	add    %edx,%eax
  102ebd:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102ec0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102ec3:	ba 00 00 00 00       	mov    $0x0,%edx
  102ec8:	f7 75 ac             	divl   -0x54(%ebp)
  102ecb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102ece:	29 d0                	sub    %edx,%eax
  102ed0:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    for (i = 0; i < npage; i ++) {
  102ed5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102edc:	eb 2f                	jmp    102f0d <page_init+0x1dd>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
  102ede:	8b 0d b8 89 11 00    	mov    0x1189b8,%ecx
  102ee4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ee7:	89 d0                	mov    %edx,%eax
  102ee9:	c1 e0 02             	shl    $0x2,%eax
  102eec:	01 d0                	add    %edx,%eax
  102eee:	c1 e0 02             	shl    $0x2,%eax
  102ef1:	01 c8                	add    %ecx,%eax
  102ef3:	83 c0 04             	add    $0x4,%eax
  102ef6:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102efd:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f00:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f03:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f06:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  102f09:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102f0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f10:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102f15:	39 c2                	cmp    %eax,%edx
  102f17:	72 c5                	jb     102ede <page_init+0x1ae>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt
  102f19:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f1f:	89 d0                	mov    %edx,%eax
  102f21:	c1 e0 02             	shl    $0x2,%eax
  102f24:	01 d0                	add    %edx,%eax
  102f26:	c1 e0 02             	shl    $0x2,%eax
  102f29:	89 c2                	mov    %eax,%edx
  102f2b:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102f30:	01 d0                	add    %edx,%eax
  102f32:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102f35:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102f3c:	77 17                	ja     102f55 <page_init+0x225>
  102f3e:	ff 75 a4             	pushl  -0x5c(%ebp)
  102f41:	68 44 64 10 00       	push   $0x106444
  102f46:	68 dc 00 00 00       	push   $0xdc
  102f4b:	68 68 64 10 00       	push   $0x106468
  102f50:	e8 80 d4 ff ff       	call   1003d5 <__panic>
  102f55:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102f58:	05 00 00 00 40       	add    $0x40000000,%eax
  102f5d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102f60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f67:	e9 69 01 00 00       	jmp    1030d5 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102f6c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f6f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f72:	89 d0                	mov    %edx,%eax
  102f74:	c1 e0 02             	shl    $0x2,%eax
  102f77:	01 d0                	add    %edx,%eax
  102f79:	c1 e0 02             	shl    $0x2,%eax
  102f7c:	01 c8                	add    %ecx,%eax
  102f7e:	8b 50 08             	mov    0x8(%eax),%edx
  102f81:	8b 40 04             	mov    0x4(%eax),%eax
  102f84:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f8a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f90:	89 d0                	mov    %edx,%eax
  102f92:	c1 e0 02             	shl    $0x2,%eax
  102f95:	01 d0                	add    %edx,%eax
  102f97:	c1 e0 02             	shl    $0x2,%eax
  102f9a:	01 c8                	add    %ecx,%eax
  102f9c:	8b 48 0c             	mov    0xc(%eax),%ecx
  102f9f:	8b 58 10             	mov    0x10(%eax),%ebx
  102fa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fa8:	01 c8                	add    %ecx,%eax
  102faa:	11 da                	adc    %ebx,%edx
  102fac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102faf:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102fb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fb8:	89 d0                	mov    %edx,%eax
  102fba:	c1 e0 02             	shl    $0x2,%eax
  102fbd:	01 d0                	add    %edx,%eax
  102fbf:	c1 e0 02             	shl    $0x2,%eax
  102fc2:	01 c8                	add    %ecx,%eax
  102fc4:	83 c0 14             	add    $0x14,%eax
  102fc7:	8b 00                	mov    (%eax),%eax
  102fc9:	83 f8 01             	cmp    $0x1,%eax
  102fcc:	0f 85 ff 00 00 00    	jne    1030d1 <page_init+0x3a1>
            if (begin < freemem) {
  102fd2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102fd5:	ba 00 00 00 00       	mov    $0x0,%edx
  102fda:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fdd:	72 17                	jb     102ff6 <page_init+0x2c6>
  102fdf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fe2:	77 05                	ja     102fe9 <page_init+0x2b9>
  102fe4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102fe7:	76 0d                	jbe    102ff6 <page_init+0x2c6>
                begin = freemem;
  102fe9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102fec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fef:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102ff6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102ffa:	72 1d                	jb     103019 <page_init+0x2e9>
  102ffc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103000:	77 09                	ja     10300b <page_init+0x2db>
  103002:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103009:	76 0e                	jbe    103019 <page_init+0x2e9>
                end = KMEMSIZE;
  10300b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103012:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103019:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10301c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10301f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103022:	0f 87 a9 00 00 00    	ja     1030d1 <page_init+0x3a1>
  103028:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10302b:	72 09                	jb     103036 <page_init+0x306>
  10302d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103030:	0f 83 9b 00 00 00    	jae    1030d1 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
  103036:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10303d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103040:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103043:	01 d0                	add    %edx,%eax
  103045:	83 e8 01             	sub    $0x1,%eax
  103048:	89 45 98             	mov    %eax,-0x68(%ebp)
  10304b:	8b 45 98             	mov    -0x68(%ebp),%eax
  10304e:	ba 00 00 00 00       	mov    $0x0,%edx
  103053:	f7 75 9c             	divl   -0x64(%ebp)
  103056:	8b 45 98             	mov    -0x68(%ebp),%eax
  103059:	29 d0                	sub    %edx,%eax
  10305b:	ba 00 00 00 00       	mov    $0x0,%edx
  103060:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103063:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103066:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103069:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10306c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10306f:	ba 00 00 00 00       	mov    $0x0,%edx
  103074:	89 c3                	mov    %eax,%ebx
  103076:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  10307c:	89 de                	mov    %ebx,%esi
  10307e:	89 d0                	mov    %edx,%eax
  103080:	83 e0 00             	and    $0x0,%eax
  103083:	89 c7                	mov    %eax,%edi
  103085:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103088:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  10308b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10308e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103091:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103094:	77 3b                	ja     1030d1 <page_init+0x3a1>
  103096:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103099:	72 05                	jb     1030a0 <page_init+0x370>
  10309b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10309e:	73 31                	jae    1030d1 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1030a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030a3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1030a6:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1030a9:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1030ac:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1030b0:	c1 ea 0c             	shr    $0xc,%edx
  1030b3:	89 c3                	mov    %eax,%ebx
  1030b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030b8:	83 ec 0c             	sub    $0xc,%esp
  1030bb:	50                   	push   %eax
  1030bc:	e8 de f8 ff ff       	call   10299f <pa2page>
  1030c1:	83 c4 10             	add    $0x10,%esp
  1030c4:	83 ec 08             	sub    $0x8,%esp
  1030c7:	53                   	push   %ebx
  1030c8:	50                   	push   %eax
  1030c9:	e8 a2 fb ff ff       	call   102c70 <init_memmap>
  1030ce:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt

    for (i = 0; i < memmap->nr_map; i ++) {
  1030d1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1030d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1030d8:	8b 00                	mov    (%eax),%eax
  1030da:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1030dd:	0f 8f 89 fe ff ff    	jg     102f6c <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1030e3:	90                   	nop
  1030e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1030e7:	5b                   	pop    %ebx
  1030e8:	5e                   	pop    %esi
  1030e9:	5f                   	pop    %edi
  1030ea:	5d                   	pop    %ebp
  1030eb:	c3                   	ret    

001030ec <enable_paging>:

static void
enable_paging(void) {
  1030ec:	55                   	push   %ebp
  1030ed:	89 e5                	mov    %esp,%ebp
  1030ef:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1030f2:	a1 b4 89 11 00       	mov    0x1189b4,%eax
  1030f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1030fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030fd:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103100:	0f 20 c0             	mov    %cr0,%eax
  103103:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103106:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103109:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10310c:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103113:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  103117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10311a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103120:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103123:	90                   	nop
  103124:	c9                   	leave  
  103125:	c3                   	ret    

00103126 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103126:	55                   	push   %ebp
  103127:	89 e5                	mov    %esp,%ebp
  103129:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10312c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10312f:	33 45 14             	xor    0x14(%ebp),%eax
  103132:	25 ff 0f 00 00       	and    $0xfff,%eax
  103137:	85 c0                	test   %eax,%eax
  103139:	74 19                	je     103154 <boot_map_segment+0x2e>
  10313b:	68 76 64 10 00       	push   $0x106476
  103140:	68 8d 64 10 00       	push   $0x10648d
  103145:	68 05 01 00 00       	push   $0x105
  10314a:	68 68 64 10 00       	push   $0x106468
  10314f:	e8 81 d2 ff ff       	call   1003d5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103154:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10315b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10315e:	25 ff 0f 00 00       	and    $0xfff,%eax
  103163:	89 c2                	mov    %eax,%edx
  103165:	8b 45 10             	mov    0x10(%ebp),%eax
  103168:	01 c2                	add    %eax,%edx
  10316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316d:	01 d0                	add    %edx,%eax
  10316f:	83 e8 01             	sub    $0x1,%eax
  103172:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103178:	ba 00 00 00 00       	mov    $0x0,%edx
  10317d:	f7 75 f0             	divl   -0x10(%ebp)
  103180:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103183:	29 d0                	sub    %edx,%eax
  103185:	c1 e8 0c             	shr    $0xc,%eax
  103188:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10318b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10318e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103194:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103199:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10319c:	8b 45 14             	mov    0x14(%ebp),%eax
  10319f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1031aa:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1031ad:	eb 57                	jmp    103206 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1031af:	83 ec 04             	sub    $0x4,%esp
  1031b2:	6a 01                	push   $0x1
  1031b4:	ff 75 0c             	pushl  0xc(%ebp)
  1031b7:	ff 75 08             	pushl  0x8(%ebp)
  1031ba:	e8 98 01 00 00       	call   103357 <get_pte>
  1031bf:	83 c4 10             	add    $0x10,%esp
  1031c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1031c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1031c9:	75 19                	jne    1031e4 <boot_map_segment+0xbe>
  1031cb:	68 a2 64 10 00       	push   $0x1064a2
  1031d0:	68 8d 64 10 00       	push   $0x10648d
  1031d5:	68 0b 01 00 00       	push   $0x10b
  1031da:	68 68 64 10 00       	push   $0x106468
  1031df:	e8 f1 d1 ff ff       	call   1003d5 <__panic>
        *ptep = pa | PTE_P | perm;
  1031e4:	8b 45 14             	mov    0x14(%ebp),%eax
  1031e7:	0b 45 18             	or     0x18(%ebp),%eax
  1031ea:	83 c8 01             	or     $0x1,%eax
  1031ed:	89 c2                	mov    %eax,%edx
  1031ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031f2:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1031f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1031f8:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1031ff:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10320a:	75 a3                	jne    1031af <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10320c:	90                   	nop
  10320d:	c9                   	leave  
  10320e:	c3                   	ret    

0010320f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10320f:	55                   	push   %ebp
  103210:	89 e5                	mov    %esp,%ebp
  103212:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  103215:	83 ec 0c             	sub    $0xc,%esp
  103218:	6a 01                	push   $0x1
  10321a:	e8 70 fa ff ff       	call   102c8f <alloc_pages>
  10321f:	83 c4 10             	add    $0x10,%esp
  103222:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103229:	75 17                	jne    103242 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  10322b:	83 ec 04             	sub    $0x4,%esp
  10322e:	68 af 64 10 00       	push   $0x1064af
  103233:	68 17 01 00 00       	push   $0x117
  103238:	68 68 64 10 00       	push   $0x106468
  10323d:	e8 93 d1 ff ff       	call   1003d5 <__panic>
    }
    return page2kva(p);     // va = pa + KERNELBASE(0x C000 0000)
  103242:	83 ec 0c             	sub    $0xc,%esp
  103245:	ff 75 f4             	pushl  -0xc(%ebp)
  103248:	e8 99 f7 ff ff       	call   1029e6 <page2kva>
  10324d:	83 c4 10             	add    $0x10,%esp
}
  103250:	c9                   	leave  
  103251:	c3                   	ret    

00103252 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103252:	55                   	push   %ebp
  103253:	89 e5                	mov    %esp,%ebp
  103255:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103258:	e8 de f9 ff ff       	call   102c3b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10325d:	e8 ce fa ff ff       	call   102d30 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103262:	e8 38 04 00 00       	call   10369f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  103267:	e8 a3 ff ff ff       	call   10320f <boot_alloc_page>
  10326c:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  103271:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103276:	83 ec 04             	sub    $0x4,%esp
  103279:	68 00 10 00 00       	push   $0x1000
  10327e:	6a 00                	push   $0x0
  103280:	50                   	push   %eax
  103281:	e8 13 22 00 00       	call   105499 <memset>
  103286:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);   // paddr of pgdir
  103289:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103291:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103298:	77 17                	ja     1032b1 <pmm_init+0x5f>
  10329a:	ff 75 f4             	pushl  -0xc(%ebp)
  10329d:	68 44 64 10 00       	push   $0x106444
  1032a2:	68 31 01 00 00       	push   $0x131
  1032a7:	68 68 64 10 00       	push   $0x106468
  1032ac:	e8 24 d1 ff ff       	call   1003d5 <__panic>
  1032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032b4:	05 00 00 00 40       	add    $0x40000000,%eax
  1032b9:	a3 b4 89 11 00       	mov    %eax,0x1189b4

    check_pgdir();
  1032be:	e8 ff 03 00 00       	call   1036c2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1032c3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1032c8:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1032ce:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1032d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032d6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1032dd:	77 17                	ja     1032f6 <pmm_init+0xa4>
  1032df:	ff 75 f0             	pushl  -0x10(%ebp)
  1032e2:	68 44 64 10 00       	push   $0x106444
  1032e7:	68 39 01 00 00       	push   $0x139
  1032ec:	68 68 64 10 00       	push   $0x106468
  1032f1:	e8 df d0 ff ff       	call   1003d5 <__panic>
  1032f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032f9:	05 00 00 00 40       	add    $0x40000000,%eax
  1032fe:	83 c8 03             	or     $0x3,%eax
  103301:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103303:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103308:	83 ec 0c             	sub    $0xc,%esp
  10330b:	6a 02                	push   $0x2
  10330d:	6a 00                	push   $0x0
  10330f:	68 00 00 00 38       	push   $0x38000000
  103314:	68 00 00 00 c0       	push   $0xc0000000
  103319:	50                   	push   %eax
  10331a:	e8 07 fe ff ff       	call   103126 <boot_map_segment>
  10331f:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103322:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103327:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  10332d:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103333:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103335:	e8 b2 fd ff ff       	call   1030ec <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10333a:	e8 0a f8 ff ff       	call   102b49 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10333f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10334a:	e8 d9 08 00 00       	call   103c28 <check_boot_pgdir>

    print_pgdir();
  10334f:	e8 cf 0c 00 00       	call   104023 <print_pgdir>

}
  103354:	90                   	nop
  103355:	c9                   	leave  
  103356:	c3                   	ret    

00103357 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103357:	55                   	push   %ebp
  103358:	89 e5                	mov    %esp,%ebp
  10335a:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
  10335d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103360:	c1 e8 16             	shr    $0x16,%eax
  103363:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
  103366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103369:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103370:	8b 45 08             	mov    0x8(%ebp),%eax
  103373:	01 d0                	add    %edx,%eax
  103375:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
  103378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337b:	8b 00                	mov    (%eax),%eax
  10337d:	83 e0 01             	and    $0x1,%eax
  103380:	85 c0                	test   %eax,%eax
  103382:	0f 85 ae 00 00 00    	jne    103436 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
  103388:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10338c:	75 0a                	jne    103398 <get_pte+0x41>
            return NULL;
  10338e:	b8 00 00 00 00       	mov    $0x0,%eax
  103393:	e9 01 01 00 00       	jmp    103499 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
  103398:	83 ec 0c             	sub    $0xc,%esp
  10339b:	6a 01                	push   $0x1
  10339d:	e8 ed f8 ff ff       	call   102c8f <alloc_pages>
  1033a2:	83 c4 10             	add    $0x10,%esp
  1033a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
  1033a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1033ac:	75 0a                	jne    1033b8 <get_pte+0x61>
            return NULL;
  1033ae:	b8 00 00 00 00       	mov    $0x0,%eax
  1033b3:	e9 e1 00 00 00       	jmp    103499 <get_pte+0x142>
        }

        // (4) set page reference
        set_page_ref(pt_page, 1);
  1033b8:	83 ec 08             	sub    $0x8,%esp
  1033bb:	6a 01                	push   $0x1
  1033bd:	ff 75 ec             	pushl  -0x14(%ebp)
  1033c0:	e8 c6 f6 ff ff       	call   102a8b <set_page_ref>
  1033c5:	83 c4 10             	add    $0x10,%esp

        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
  1033c8:	83 ec 0c             	sub    $0xc,%esp
  1033cb:	ff 75 ec             	pushl  -0x14(%ebp)
  1033ce:	e8 b9 f5 ff ff       	call   10298c <page2pa>
  1033d3:	83 c4 10             	add    $0x10,%esp
  1033d6:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
  1033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033e2:	c1 e8 0c             	shr    $0xc,%eax
  1033e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1033e8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1033ed:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1033f0:	72 17                	jb     103409 <get_pte+0xb2>
  1033f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  1033f5:	68 a0 63 10 00       	push   $0x1063a0
  1033fa:	68 97 01 00 00       	push   $0x197
  1033ff:	68 68 64 10 00       	push   $0x106468
  103404:	e8 cc cf ff ff       	call   1003d5 <__panic>
  103409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10340c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103411:	83 ec 04             	sub    $0x4,%esp
  103414:	68 00 10 00 00       	push   $0x1000
  103419:	6a 00                	push   $0x0
  10341b:	50                   	push   %eax
  10341c:	e8 78 20 00 00       	call   105499 <memset>
  103421:	83 c4 10             	add    $0x10,%esp

        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
  103424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103427:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10342c:	83 c8 07             	or     $0x7,%eax
  10342f:	89 c2                	mov    %eax,%edx
  103431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103434:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
  103436:	8b 45 0c             	mov    0xc(%ebp),%eax
  103439:	c1 e8 0c             	shr    $0xc,%eax
  10343c:	25 ff 03 00 00       	and    $0x3ff,%eax
  103441:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
  103444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103447:	8b 00                	mov    (%eax),%eax
  103449:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10344e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
  103451:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103454:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  103457:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10345a:	c1 e8 0c             	shr    $0xc,%eax
  10345d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103460:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103465:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103468:	72 17                	jb     103481 <get_pte+0x12a>
  10346a:	ff 75 d4             	pushl  -0x2c(%ebp)
  10346d:	68 a0 63 10 00       	push   $0x1063a0
  103472:	68 9f 01 00 00       	push   $0x19f
  103477:	68 68 64 10 00       	push   $0x106468
  10347c:	e8 54 cf ff ff       	call   1003d5 <__panic>
  103481:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103484:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103489:	89 c2                	mov    %eax,%edx
  10348b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10348e:	c1 e0 02             	shl    $0x2,%eax
  103491:	01 d0                	add    %edx,%eax
  103493:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
  103496:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
  103499:	c9                   	leave  
  10349a:	c3                   	ret    

0010349b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10349b:	55                   	push   %ebp
  10349c:	89 e5                	mov    %esp,%ebp
  10349e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1034a1:	83 ec 04             	sub    $0x4,%esp
  1034a4:	6a 00                	push   $0x0
  1034a6:	ff 75 0c             	pushl  0xc(%ebp)
  1034a9:	ff 75 08             	pushl  0x8(%ebp)
  1034ac:	e8 a6 fe ff ff       	call   103357 <get_pte>
  1034b1:	83 c4 10             	add    $0x10,%esp
  1034b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1034b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1034bb:	74 08                	je     1034c5 <get_page+0x2a>
        *ptep_store = ptep;
  1034bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034c3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1034c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034c9:	74 1f                	je     1034ea <get_page+0x4f>
  1034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034ce:	8b 00                	mov    (%eax),%eax
  1034d0:	83 e0 01             	and    $0x1,%eax
  1034d3:	85 c0                	test   %eax,%eax
  1034d5:	74 13                	je     1034ea <get_page+0x4f>
        return pte2page(*ptep);
  1034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034da:	8b 00                	mov    (%eax),%eax
  1034dc:	83 ec 0c             	sub    $0xc,%esp
  1034df:	50                   	push   %eax
  1034e0:	e8 46 f5 ff ff       	call   102a2b <pte2page>
  1034e5:	83 c4 10             	add    $0x10,%esp
  1034e8:	eb 05                	jmp    1034ef <get_page+0x54>
    }
    return NULL;
  1034ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034ef:	c9                   	leave  
  1034f0:	c3                   	ret    

001034f1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1034f1:	55                   	push   %ebp
  1034f2:	89 e5                	mov    %esp,%ebp
  1034f4:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
  1034f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1034fa:	8b 00                	mov    (%eax),%eax
  1034fc:	83 e0 01             	and    $0x1,%eax
  1034ff:	85 c0                	test   %eax,%eax
  103501:	74 57                	je     10355a <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
  103503:	8b 45 10             	mov    0x10(%ebp),%eax
  103506:	8b 00                	mov    (%eax),%eax
  103508:	83 ec 0c             	sub    $0xc,%esp
  10350b:	50                   	push   %eax
  10350c:	e8 1a f5 ff ff       	call   102a2b <pte2page>
  103511:	83 c4 10             	add    $0x10,%esp
  103514:	89 45 f4             	mov    %eax,-0xc(%ebp)

    //(3) decrease page reference
    page_ref_dec(page);
  103517:	83 ec 0c             	sub    $0xc,%esp
  10351a:	ff 75 f4             	pushl  -0xc(%ebp)
  10351d:	e8 8e f5 ff ff       	call   102ab0 <page_ref_dec>
  103522:	83 c4 10             	add    $0x10,%esp

    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
  103525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103528:	8b 00                	mov    (%eax),%eax
  10352a:	85 c0                	test   %eax,%eax
  10352c:	75 10                	jne    10353e <page_remove_pte+0x4d>
        free_page(page);
  10352e:	83 ec 08             	sub    $0x8,%esp
  103531:	6a 01                	push   $0x1
  103533:	ff 75 f4             	pushl  -0xc(%ebp)
  103536:	e8 92 f7 ff ff       	call   102ccd <free_pages>
  10353b:	83 c4 10             	add    $0x10,%esp
    }

    //(5) clear second page table entry
    *ptep = 0;
  10353e:	8b 45 10             	mov    0x10(%ebp),%eax
  103541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
  103547:	83 ec 08             	sub    $0x8,%esp
  10354a:	ff 75 0c             	pushl  0xc(%ebp)
  10354d:	ff 75 08             	pushl  0x8(%ebp)
  103550:	e8 fa 00 00 00       	call   10364f <tlb_invalidate>
  103555:	83 c4 10             	add    $0x10,%esp
  103558:	eb 01                	jmp    10355b <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
  10355a:	90                   	nop
    //(5) clear second page table entry
    *ptep = 0;

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
  10355b:	c9                   	leave  
  10355c:	c3                   	ret    

0010355d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10355d:	55                   	push   %ebp
  10355e:	89 e5                	mov    %esp,%ebp
  103560:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103563:	83 ec 04             	sub    $0x4,%esp
  103566:	6a 00                	push   $0x0
  103568:	ff 75 0c             	pushl  0xc(%ebp)
  10356b:	ff 75 08             	pushl  0x8(%ebp)
  10356e:	e8 e4 fd ff ff       	call   103357 <get_pte>
  103573:	83 c4 10             	add    $0x10,%esp
  103576:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10357d:	74 14                	je     103593 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  10357f:	83 ec 04             	sub    $0x4,%esp
  103582:	ff 75 f4             	pushl  -0xc(%ebp)
  103585:	ff 75 0c             	pushl  0xc(%ebp)
  103588:	ff 75 08             	pushl  0x8(%ebp)
  10358b:	e8 61 ff ff ff       	call   1034f1 <page_remove_pte>
  103590:	83 c4 10             	add    $0x10,%esp
    }
}
  103593:	90                   	nop
  103594:	c9                   	leave  
  103595:	c3                   	ret    

00103596 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103596:	55                   	push   %ebp
  103597:	89 e5                	mov    %esp,%ebp
  103599:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10359c:	83 ec 04             	sub    $0x4,%esp
  10359f:	6a 01                	push   $0x1
  1035a1:	ff 75 10             	pushl  0x10(%ebp)
  1035a4:	ff 75 08             	pushl  0x8(%ebp)
  1035a7:	e8 ab fd ff ff       	call   103357 <get_pte>
  1035ac:	83 c4 10             	add    $0x10,%esp
  1035af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1035b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035b6:	75 0a                	jne    1035c2 <page_insert+0x2c>
        return -E_NO_MEM;
  1035b8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1035bd:	e9 8b 00 00 00       	jmp    10364d <page_insert+0xb7>
    }
    page_ref_inc(page);
  1035c2:	83 ec 0c             	sub    $0xc,%esp
  1035c5:	ff 75 0c             	pushl  0xc(%ebp)
  1035c8:	e8 cc f4 ff ff       	call   102a99 <page_ref_inc>
  1035cd:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  1035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035d3:	8b 00                	mov    (%eax),%eax
  1035d5:	83 e0 01             	and    $0x1,%eax
  1035d8:	85 c0                	test   %eax,%eax
  1035da:	74 40                	je     10361c <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  1035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035df:	8b 00                	mov    (%eax),%eax
  1035e1:	83 ec 0c             	sub    $0xc,%esp
  1035e4:	50                   	push   %eax
  1035e5:	e8 41 f4 ff ff       	call   102a2b <pte2page>
  1035ea:	83 c4 10             	add    $0x10,%esp
  1035ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1035f6:	75 10                	jne    103608 <page_insert+0x72>
            page_ref_dec(page);
  1035f8:	83 ec 0c             	sub    $0xc,%esp
  1035fb:	ff 75 0c             	pushl  0xc(%ebp)
  1035fe:	e8 ad f4 ff ff       	call   102ab0 <page_ref_dec>
  103603:	83 c4 10             	add    $0x10,%esp
  103606:	eb 14                	jmp    10361c <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103608:	83 ec 04             	sub    $0x4,%esp
  10360b:	ff 75 f4             	pushl  -0xc(%ebp)
  10360e:	ff 75 10             	pushl  0x10(%ebp)
  103611:	ff 75 08             	pushl  0x8(%ebp)
  103614:	e8 d8 fe ff ff       	call   1034f1 <page_remove_pte>
  103619:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10361c:	83 ec 0c             	sub    $0xc,%esp
  10361f:	ff 75 0c             	pushl  0xc(%ebp)
  103622:	e8 65 f3 ff ff       	call   10298c <page2pa>
  103627:	83 c4 10             	add    $0x10,%esp
  10362a:	0b 45 14             	or     0x14(%ebp),%eax
  10362d:	83 c8 01             	or     $0x1,%eax
  103630:	89 c2                	mov    %eax,%edx
  103632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103635:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103637:	83 ec 08             	sub    $0x8,%esp
  10363a:	ff 75 10             	pushl  0x10(%ebp)
  10363d:	ff 75 08             	pushl  0x8(%ebp)
  103640:	e8 0a 00 00 00       	call   10364f <tlb_invalidate>
  103645:	83 c4 10             	add    $0x10,%esp
    return 0;
  103648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10364d:	c9                   	leave  
  10364e:	c3                   	ret    

0010364f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10364f:	55                   	push   %ebp
  103650:	89 e5                	mov    %esp,%ebp
  103652:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103655:	0f 20 d8             	mov    %cr3,%eax
  103658:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  10365b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10365e:	8b 45 08             	mov    0x8(%ebp),%eax
  103661:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103664:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10366b:	77 17                	ja     103684 <tlb_invalidate+0x35>
  10366d:	ff 75 f0             	pushl  -0x10(%ebp)
  103670:	68 44 64 10 00       	push   $0x106444
  103675:	68 0e 02 00 00       	push   $0x20e
  10367a:	68 68 64 10 00       	push   $0x106468
  10367f:	e8 51 cd ff ff       	call   1003d5 <__panic>
  103684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103687:	05 00 00 00 40       	add    $0x40000000,%eax
  10368c:	39 c2                	cmp    %eax,%edx
  10368e:	75 0c                	jne    10369c <tlb_invalidate+0x4d>
        invlpg((void *)la);
  103690:	8b 45 0c             	mov    0xc(%ebp),%eax
  103693:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103699:	0f 01 38             	invlpg (%eax)
    }
}
  10369c:	90                   	nop
  10369d:	c9                   	leave  
  10369e:	c3                   	ret    

0010369f <check_alloc_page>:

static void
check_alloc_page(void) {
  10369f:	55                   	push   %ebp
  1036a0:	89 e5                	mov    %esp,%ebp
  1036a2:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  1036a5:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  1036aa:	8b 40 18             	mov    0x18(%eax),%eax
  1036ad:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1036af:	83 ec 0c             	sub    $0xc,%esp
  1036b2:	68 c8 64 10 00       	push   $0x1064c8
  1036b7:	e8 b3 cb ff ff       	call   10026f <cprintf>
  1036bc:	83 c4 10             	add    $0x10,%esp
}
  1036bf:	90                   	nop
  1036c0:	c9                   	leave  
  1036c1:	c3                   	ret    

001036c2 <check_pgdir>:

static void
check_pgdir(void) {
  1036c2:	55                   	push   %ebp
  1036c3:	89 e5                	mov    %esp,%ebp
  1036c5:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1036c8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1036cd:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1036d2:	76 19                	jbe    1036ed <check_pgdir+0x2b>
  1036d4:	68 e7 64 10 00       	push   $0x1064e7
  1036d9:	68 8d 64 10 00       	push   $0x10648d
  1036de:	68 1b 02 00 00       	push   $0x21b
  1036e3:	68 68 64 10 00       	push   $0x106468
  1036e8:	e8 e8 cc ff ff       	call   1003d5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1036ed:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036f2:	85 c0                	test   %eax,%eax
  1036f4:	74 0e                	je     103704 <check_pgdir+0x42>
  1036f6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036fb:	25 ff 0f 00 00       	and    $0xfff,%eax
  103700:	85 c0                	test   %eax,%eax
  103702:	74 19                	je     10371d <check_pgdir+0x5b>
  103704:	68 04 65 10 00       	push   $0x106504
  103709:	68 8d 64 10 00       	push   $0x10648d
  10370e:	68 1c 02 00 00       	push   $0x21c
  103713:	68 68 64 10 00       	push   $0x106468
  103718:	e8 b8 cc ff ff       	call   1003d5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10371d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103722:	83 ec 04             	sub    $0x4,%esp
  103725:	6a 00                	push   $0x0
  103727:	6a 00                	push   $0x0
  103729:	50                   	push   %eax
  10372a:	e8 6c fd ff ff       	call   10349b <get_page>
  10372f:	83 c4 10             	add    $0x10,%esp
  103732:	85 c0                	test   %eax,%eax
  103734:	74 19                	je     10374f <check_pgdir+0x8d>
  103736:	68 3c 65 10 00       	push   $0x10653c
  10373b:	68 8d 64 10 00       	push   $0x10648d
  103740:	68 1d 02 00 00       	push   $0x21d
  103745:	68 68 64 10 00       	push   $0x106468
  10374a:	e8 86 cc ff ff       	call   1003d5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10374f:	83 ec 0c             	sub    $0xc,%esp
  103752:	6a 01                	push   $0x1
  103754:	e8 36 f5 ff ff       	call   102c8f <alloc_pages>
  103759:	83 c4 10             	add    $0x10,%esp
  10375c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10375f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103764:	6a 00                	push   $0x0
  103766:	6a 00                	push   $0x0
  103768:	ff 75 f4             	pushl  -0xc(%ebp)
  10376b:	50                   	push   %eax
  10376c:	e8 25 fe ff ff       	call   103596 <page_insert>
  103771:	83 c4 10             	add    $0x10,%esp
  103774:	85 c0                	test   %eax,%eax
  103776:	74 19                	je     103791 <check_pgdir+0xcf>
  103778:	68 64 65 10 00       	push   $0x106564
  10377d:	68 8d 64 10 00       	push   $0x10648d
  103782:	68 21 02 00 00       	push   $0x221
  103787:	68 68 64 10 00       	push   $0x106468
  10378c:	e8 44 cc ff ff       	call   1003d5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103791:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103796:	83 ec 04             	sub    $0x4,%esp
  103799:	6a 00                	push   $0x0
  10379b:	6a 00                	push   $0x0
  10379d:	50                   	push   %eax
  10379e:	e8 b4 fb ff ff       	call   103357 <get_pte>
  1037a3:	83 c4 10             	add    $0x10,%esp
  1037a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037ad:	75 19                	jne    1037c8 <check_pgdir+0x106>
  1037af:	68 90 65 10 00       	push   $0x106590
  1037b4:	68 8d 64 10 00       	push   $0x10648d
  1037b9:	68 24 02 00 00       	push   $0x224
  1037be:	68 68 64 10 00       	push   $0x106468
  1037c3:	e8 0d cc ff ff       	call   1003d5 <__panic>
    assert(pte2page(*ptep) == p1);
  1037c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037cb:	8b 00                	mov    (%eax),%eax
  1037cd:	83 ec 0c             	sub    $0xc,%esp
  1037d0:	50                   	push   %eax
  1037d1:	e8 55 f2 ff ff       	call   102a2b <pte2page>
  1037d6:	83 c4 10             	add    $0x10,%esp
  1037d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1037dc:	74 19                	je     1037f7 <check_pgdir+0x135>
  1037de:	68 bd 65 10 00       	push   $0x1065bd
  1037e3:	68 8d 64 10 00       	push   $0x10648d
  1037e8:	68 25 02 00 00       	push   $0x225
  1037ed:	68 68 64 10 00       	push   $0x106468
  1037f2:	e8 de cb ff ff       	call   1003d5 <__panic>
    assert(page_ref(p1) == 1);
  1037f7:	83 ec 0c             	sub    $0xc,%esp
  1037fa:	ff 75 f4             	pushl  -0xc(%ebp)
  1037fd:	e8 7f f2 ff ff       	call   102a81 <page_ref>
  103802:	83 c4 10             	add    $0x10,%esp
  103805:	83 f8 01             	cmp    $0x1,%eax
  103808:	74 19                	je     103823 <check_pgdir+0x161>
  10380a:	68 d3 65 10 00       	push   $0x1065d3
  10380f:	68 8d 64 10 00       	push   $0x10648d
  103814:	68 26 02 00 00       	push   $0x226
  103819:	68 68 64 10 00       	push   $0x106468
  10381e:	e8 b2 cb ff ff       	call   1003d5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103823:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103828:	8b 00                	mov    (%eax),%eax
  10382a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10382f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103835:	c1 e8 0c             	shr    $0xc,%eax
  103838:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10383b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103840:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103843:	72 17                	jb     10385c <check_pgdir+0x19a>
  103845:	ff 75 ec             	pushl  -0x14(%ebp)
  103848:	68 a0 63 10 00       	push   $0x1063a0
  10384d:	68 28 02 00 00       	push   $0x228
  103852:	68 68 64 10 00       	push   $0x106468
  103857:	e8 79 cb ff ff       	call   1003d5 <__panic>
  10385c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10385f:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103864:	83 c0 04             	add    $0x4,%eax
  103867:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10386a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10386f:	83 ec 04             	sub    $0x4,%esp
  103872:	6a 00                	push   $0x0
  103874:	68 00 10 00 00       	push   $0x1000
  103879:	50                   	push   %eax
  10387a:	e8 d8 fa ff ff       	call   103357 <get_pte>
  10387f:	83 c4 10             	add    $0x10,%esp
  103882:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103885:	74 19                	je     1038a0 <check_pgdir+0x1de>
  103887:	68 e8 65 10 00       	push   $0x1065e8
  10388c:	68 8d 64 10 00       	push   $0x10648d
  103891:	68 29 02 00 00       	push   $0x229
  103896:	68 68 64 10 00       	push   $0x106468
  10389b:	e8 35 cb ff ff       	call   1003d5 <__panic>

    p2 = alloc_page();
  1038a0:	83 ec 0c             	sub    $0xc,%esp
  1038a3:	6a 01                	push   $0x1
  1038a5:	e8 e5 f3 ff ff       	call   102c8f <alloc_pages>
  1038aa:	83 c4 10             	add    $0x10,%esp
  1038ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1038b0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038b5:	6a 06                	push   $0x6
  1038b7:	68 00 10 00 00       	push   $0x1000
  1038bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  1038bf:	50                   	push   %eax
  1038c0:	e8 d1 fc ff ff       	call   103596 <page_insert>
  1038c5:	83 c4 10             	add    $0x10,%esp
  1038c8:	85 c0                	test   %eax,%eax
  1038ca:	74 19                	je     1038e5 <check_pgdir+0x223>
  1038cc:	68 10 66 10 00       	push   $0x106610
  1038d1:	68 8d 64 10 00       	push   $0x10648d
  1038d6:	68 2c 02 00 00       	push   $0x22c
  1038db:	68 68 64 10 00       	push   $0x106468
  1038e0:	e8 f0 ca ff ff       	call   1003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1038e5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038ea:	83 ec 04             	sub    $0x4,%esp
  1038ed:	6a 00                	push   $0x0
  1038ef:	68 00 10 00 00       	push   $0x1000
  1038f4:	50                   	push   %eax
  1038f5:	e8 5d fa ff ff       	call   103357 <get_pte>
  1038fa:	83 c4 10             	add    $0x10,%esp
  1038fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103904:	75 19                	jne    10391f <check_pgdir+0x25d>
  103906:	68 48 66 10 00       	push   $0x106648
  10390b:	68 8d 64 10 00       	push   $0x10648d
  103910:	68 2d 02 00 00       	push   $0x22d
  103915:	68 68 64 10 00       	push   $0x106468
  10391a:	e8 b6 ca ff ff       	call   1003d5 <__panic>
    assert(*ptep & PTE_U);
  10391f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103922:	8b 00                	mov    (%eax),%eax
  103924:	83 e0 04             	and    $0x4,%eax
  103927:	85 c0                	test   %eax,%eax
  103929:	75 19                	jne    103944 <check_pgdir+0x282>
  10392b:	68 78 66 10 00       	push   $0x106678
  103930:	68 8d 64 10 00       	push   $0x10648d
  103935:	68 2e 02 00 00       	push   $0x22e
  10393a:	68 68 64 10 00       	push   $0x106468
  10393f:	e8 91 ca ff ff       	call   1003d5 <__panic>
    assert(*ptep & PTE_W);
  103944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103947:	8b 00                	mov    (%eax),%eax
  103949:	83 e0 02             	and    $0x2,%eax
  10394c:	85 c0                	test   %eax,%eax
  10394e:	75 19                	jne    103969 <check_pgdir+0x2a7>
  103950:	68 86 66 10 00       	push   $0x106686
  103955:	68 8d 64 10 00       	push   $0x10648d
  10395a:	68 2f 02 00 00       	push   $0x22f
  10395f:	68 68 64 10 00       	push   $0x106468
  103964:	e8 6c ca ff ff       	call   1003d5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103969:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10396e:	8b 00                	mov    (%eax),%eax
  103970:	83 e0 04             	and    $0x4,%eax
  103973:	85 c0                	test   %eax,%eax
  103975:	75 19                	jne    103990 <check_pgdir+0x2ce>
  103977:	68 94 66 10 00       	push   $0x106694
  10397c:	68 8d 64 10 00       	push   $0x10648d
  103981:	68 30 02 00 00       	push   $0x230
  103986:	68 68 64 10 00       	push   $0x106468
  10398b:	e8 45 ca ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 1);
  103990:	83 ec 0c             	sub    $0xc,%esp
  103993:	ff 75 e4             	pushl  -0x1c(%ebp)
  103996:	e8 e6 f0 ff ff       	call   102a81 <page_ref>
  10399b:	83 c4 10             	add    $0x10,%esp
  10399e:	83 f8 01             	cmp    $0x1,%eax
  1039a1:	74 19                	je     1039bc <check_pgdir+0x2fa>
  1039a3:	68 aa 66 10 00       	push   $0x1066aa
  1039a8:	68 8d 64 10 00       	push   $0x10648d
  1039ad:	68 31 02 00 00       	push   $0x231
  1039b2:	68 68 64 10 00       	push   $0x106468
  1039b7:	e8 19 ca ff ff       	call   1003d5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1039bc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039c1:	6a 00                	push   $0x0
  1039c3:	68 00 10 00 00       	push   $0x1000
  1039c8:	ff 75 f4             	pushl  -0xc(%ebp)
  1039cb:	50                   	push   %eax
  1039cc:	e8 c5 fb ff ff       	call   103596 <page_insert>
  1039d1:	83 c4 10             	add    $0x10,%esp
  1039d4:	85 c0                	test   %eax,%eax
  1039d6:	74 19                	je     1039f1 <check_pgdir+0x32f>
  1039d8:	68 bc 66 10 00       	push   $0x1066bc
  1039dd:	68 8d 64 10 00       	push   $0x10648d
  1039e2:	68 33 02 00 00       	push   $0x233
  1039e7:	68 68 64 10 00       	push   $0x106468
  1039ec:	e8 e4 c9 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p1) == 2);
  1039f1:	83 ec 0c             	sub    $0xc,%esp
  1039f4:	ff 75 f4             	pushl  -0xc(%ebp)
  1039f7:	e8 85 f0 ff ff       	call   102a81 <page_ref>
  1039fc:	83 c4 10             	add    $0x10,%esp
  1039ff:	83 f8 02             	cmp    $0x2,%eax
  103a02:	74 19                	je     103a1d <check_pgdir+0x35b>
  103a04:	68 e8 66 10 00       	push   $0x1066e8
  103a09:	68 8d 64 10 00       	push   $0x10648d
  103a0e:	68 34 02 00 00       	push   $0x234
  103a13:	68 68 64 10 00       	push   $0x106468
  103a18:	e8 b8 c9 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 0);
  103a1d:	83 ec 0c             	sub    $0xc,%esp
  103a20:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a23:	e8 59 f0 ff ff       	call   102a81 <page_ref>
  103a28:	83 c4 10             	add    $0x10,%esp
  103a2b:	85 c0                	test   %eax,%eax
  103a2d:	74 19                	je     103a48 <check_pgdir+0x386>
  103a2f:	68 fa 66 10 00       	push   $0x1066fa
  103a34:	68 8d 64 10 00       	push   $0x10648d
  103a39:	68 35 02 00 00       	push   $0x235
  103a3e:	68 68 64 10 00       	push   $0x106468
  103a43:	e8 8d c9 ff ff       	call   1003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a48:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a4d:	83 ec 04             	sub    $0x4,%esp
  103a50:	6a 00                	push   $0x0
  103a52:	68 00 10 00 00       	push   $0x1000
  103a57:	50                   	push   %eax
  103a58:	e8 fa f8 ff ff       	call   103357 <get_pte>
  103a5d:	83 c4 10             	add    $0x10,%esp
  103a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a67:	75 19                	jne    103a82 <check_pgdir+0x3c0>
  103a69:	68 48 66 10 00       	push   $0x106648
  103a6e:	68 8d 64 10 00       	push   $0x10648d
  103a73:	68 36 02 00 00       	push   $0x236
  103a78:	68 68 64 10 00       	push   $0x106468
  103a7d:	e8 53 c9 ff ff       	call   1003d5 <__panic>
    assert(pte2page(*ptep) == p1);
  103a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a85:	8b 00                	mov    (%eax),%eax
  103a87:	83 ec 0c             	sub    $0xc,%esp
  103a8a:	50                   	push   %eax
  103a8b:	e8 9b ef ff ff       	call   102a2b <pte2page>
  103a90:	83 c4 10             	add    $0x10,%esp
  103a93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103a96:	74 19                	je     103ab1 <check_pgdir+0x3ef>
  103a98:	68 bd 65 10 00       	push   $0x1065bd
  103a9d:	68 8d 64 10 00       	push   $0x10648d
  103aa2:	68 37 02 00 00       	push   $0x237
  103aa7:	68 68 64 10 00       	push   $0x106468
  103aac:	e8 24 c9 ff ff       	call   1003d5 <__panic>
    assert((*ptep & PTE_U) == 0);
  103ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ab4:	8b 00                	mov    (%eax),%eax
  103ab6:	83 e0 04             	and    $0x4,%eax
  103ab9:	85 c0                	test   %eax,%eax
  103abb:	74 19                	je     103ad6 <check_pgdir+0x414>
  103abd:	68 0c 67 10 00       	push   $0x10670c
  103ac2:	68 8d 64 10 00       	push   $0x10648d
  103ac7:	68 38 02 00 00       	push   $0x238
  103acc:	68 68 64 10 00       	push   $0x106468
  103ad1:	e8 ff c8 ff ff       	call   1003d5 <__panic>

    page_remove(boot_pgdir, 0x0);
  103ad6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103adb:	83 ec 08             	sub    $0x8,%esp
  103ade:	6a 00                	push   $0x0
  103ae0:	50                   	push   %eax
  103ae1:	e8 77 fa ff ff       	call   10355d <page_remove>
  103ae6:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103ae9:	83 ec 0c             	sub    $0xc,%esp
  103aec:	ff 75 f4             	pushl  -0xc(%ebp)
  103aef:	e8 8d ef ff ff       	call   102a81 <page_ref>
  103af4:	83 c4 10             	add    $0x10,%esp
  103af7:	83 f8 01             	cmp    $0x1,%eax
  103afa:	74 19                	je     103b15 <check_pgdir+0x453>
  103afc:	68 d3 65 10 00       	push   $0x1065d3
  103b01:	68 8d 64 10 00       	push   $0x10648d
  103b06:	68 3b 02 00 00       	push   $0x23b
  103b0b:	68 68 64 10 00       	push   $0x106468
  103b10:	e8 c0 c8 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 0);
  103b15:	83 ec 0c             	sub    $0xc,%esp
  103b18:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b1b:	e8 61 ef ff ff       	call   102a81 <page_ref>
  103b20:	83 c4 10             	add    $0x10,%esp
  103b23:	85 c0                	test   %eax,%eax
  103b25:	74 19                	je     103b40 <check_pgdir+0x47e>
  103b27:	68 fa 66 10 00       	push   $0x1066fa
  103b2c:	68 8d 64 10 00       	push   $0x10648d
  103b31:	68 3c 02 00 00       	push   $0x23c
  103b36:	68 68 64 10 00       	push   $0x106468
  103b3b:	e8 95 c8 ff ff       	call   1003d5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103b40:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b45:	83 ec 08             	sub    $0x8,%esp
  103b48:	68 00 10 00 00       	push   $0x1000
  103b4d:	50                   	push   %eax
  103b4e:	e8 0a fa ff ff       	call   10355d <page_remove>
  103b53:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103b56:	83 ec 0c             	sub    $0xc,%esp
  103b59:	ff 75 f4             	pushl  -0xc(%ebp)
  103b5c:	e8 20 ef ff ff       	call   102a81 <page_ref>
  103b61:	83 c4 10             	add    $0x10,%esp
  103b64:	85 c0                	test   %eax,%eax
  103b66:	74 19                	je     103b81 <check_pgdir+0x4bf>
  103b68:	68 21 67 10 00       	push   $0x106721
  103b6d:	68 8d 64 10 00       	push   $0x10648d
  103b72:	68 3f 02 00 00       	push   $0x23f
  103b77:	68 68 64 10 00       	push   $0x106468
  103b7c:	e8 54 c8 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 0);
  103b81:	83 ec 0c             	sub    $0xc,%esp
  103b84:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b87:	e8 f5 ee ff ff       	call   102a81 <page_ref>
  103b8c:	83 c4 10             	add    $0x10,%esp
  103b8f:	85 c0                	test   %eax,%eax
  103b91:	74 19                	je     103bac <check_pgdir+0x4ea>
  103b93:	68 fa 66 10 00       	push   $0x1066fa
  103b98:	68 8d 64 10 00       	push   $0x10648d
  103b9d:	68 40 02 00 00       	push   $0x240
  103ba2:	68 68 64 10 00       	push   $0x106468
  103ba7:	e8 29 c8 ff ff       	call   1003d5 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103bac:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bb1:	8b 00                	mov    (%eax),%eax
  103bb3:	83 ec 0c             	sub    $0xc,%esp
  103bb6:	50                   	push   %eax
  103bb7:	e8 a9 ee ff ff       	call   102a65 <pde2page>
  103bbc:	83 c4 10             	add    $0x10,%esp
  103bbf:	83 ec 0c             	sub    $0xc,%esp
  103bc2:	50                   	push   %eax
  103bc3:	e8 b9 ee ff ff       	call   102a81 <page_ref>
  103bc8:	83 c4 10             	add    $0x10,%esp
  103bcb:	83 f8 01             	cmp    $0x1,%eax
  103bce:	74 19                	je     103be9 <check_pgdir+0x527>
  103bd0:	68 34 67 10 00       	push   $0x106734
  103bd5:	68 8d 64 10 00       	push   $0x10648d
  103bda:	68 42 02 00 00       	push   $0x242
  103bdf:	68 68 64 10 00       	push   $0x106468
  103be4:	e8 ec c7 ff ff       	call   1003d5 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103be9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bee:	8b 00                	mov    (%eax),%eax
  103bf0:	83 ec 0c             	sub    $0xc,%esp
  103bf3:	50                   	push   %eax
  103bf4:	e8 6c ee ff ff       	call   102a65 <pde2page>
  103bf9:	83 c4 10             	add    $0x10,%esp
  103bfc:	83 ec 08             	sub    $0x8,%esp
  103bff:	6a 01                	push   $0x1
  103c01:	50                   	push   %eax
  103c02:	e8 c6 f0 ff ff       	call   102ccd <free_pages>
  103c07:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103c0a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103c15:	83 ec 0c             	sub    $0xc,%esp
  103c18:	68 5b 67 10 00       	push   $0x10675b
  103c1d:	e8 4d c6 ff ff       	call   10026f <cprintf>
  103c22:	83 c4 10             	add    $0x10,%esp
}
  103c25:	90                   	nop
  103c26:	c9                   	leave  
  103c27:	c3                   	ret    

00103c28 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103c28:	55                   	push   %ebp
  103c29:	89 e5                	mov    %esp,%ebp
  103c2b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c35:	e9 a3 00 00 00       	jmp    103cdd <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c43:	c1 e8 0c             	shr    $0xc,%eax
  103c46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103c49:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c4e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103c51:	72 17                	jb     103c6a <check_boot_pgdir+0x42>
  103c53:	ff 75 f0             	pushl  -0x10(%ebp)
  103c56:	68 a0 63 10 00       	push   $0x1063a0
  103c5b:	68 4e 02 00 00       	push   $0x24e
  103c60:	68 68 64 10 00       	push   $0x106468
  103c65:	e8 6b c7 ff ff       	call   1003d5 <__panic>
  103c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c6d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103c72:	89 c2                	mov    %eax,%edx
  103c74:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c79:	83 ec 04             	sub    $0x4,%esp
  103c7c:	6a 00                	push   $0x0
  103c7e:	52                   	push   %edx
  103c7f:	50                   	push   %eax
  103c80:	e8 d2 f6 ff ff       	call   103357 <get_pte>
  103c85:	83 c4 10             	add    $0x10,%esp
  103c88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103c8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103c8f:	75 19                	jne    103caa <check_boot_pgdir+0x82>
  103c91:	68 78 67 10 00       	push   $0x106778
  103c96:	68 8d 64 10 00       	push   $0x10648d
  103c9b:	68 4e 02 00 00       	push   $0x24e
  103ca0:	68 68 64 10 00       	push   $0x106468
  103ca5:	e8 2b c7 ff ff       	call   1003d5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103cad:	8b 00                	mov    (%eax),%eax
  103caf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cb4:	89 c2                	mov    %eax,%edx
  103cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb9:	39 c2                	cmp    %eax,%edx
  103cbb:	74 19                	je     103cd6 <check_boot_pgdir+0xae>
  103cbd:	68 b5 67 10 00       	push   $0x1067b5
  103cc2:	68 8d 64 10 00       	push   $0x10648d
  103cc7:	68 4f 02 00 00       	push   $0x24f
  103ccc:	68 68 64 10 00       	push   $0x106468
  103cd1:	e8 ff c6 ff ff       	call   1003d5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103cd6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ce0:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103ce5:	39 c2                	cmp    %eax,%edx
  103ce7:	0f 82 4d ff ff ff    	jb     103c3a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103ced:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103cf2:	05 ac 0f 00 00       	add    $0xfac,%eax
  103cf7:	8b 00                	mov    (%eax),%eax
  103cf9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cfe:	89 c2                	mov    %eax,%edx
  103d00:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103d08:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103d0f:	77 17                	ja     103d28 <check_boot_pgdir+0x100>
  103d11:	ff 75 e4             	pushl  -0x1c(%ebp)
  103d14:	68 44 64 10 00       	push   $0x106444
  103d19:	68 52 02 00 00       	push   $0x252
  103d1e:	68 68 64 10 00       	push   $0x106468
  103d23:	e8 ad c6 ff ff       	call   1003d5 <__panic>
  103d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d2b:	05 00 00 00 40       	add    $0x40000000,%eax
  103d30:	39 c2                	cmp    %eax,%edx
  103d32:	74 19                	je     103d4d <check_boot_pgdir+0x125>
  103d34:	68 cc 67 10 00       	push   $0x1067cc
  103d39:	68 8d 64 10 00       	push   $0x10648d
  103d3e:	68 52 02 00 00       	push   $0x252
  103d43:	68 68 64 10 00       	push   $0x106468
  103d48:	e8 88 c6 ff ff       	call   1003d5 <__panic>

    assert(boot_pgdir[0] == 0);
  103d4d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d52:	8b 00                	mov    (%eax),%eax
  103d54:	85 c0                	test   %eax,%eax
  103d56:	74 19                	je     103d71 <check_boot_pgdir+0x149>
  103d58:	68 00 68 10 00       	push   $0x106800
  103d5d:	68 8d 64 10 00       	push   $0x10648d
  103d62:	68 54 02 00 00       	push   $0x254
  103d67:	68 68 64 10 00       	push   $0x106468
  103d6c:	e8 64 c6 ff ff       	call   1003d5 <__panic>

    struct Page *p;
    p = alloc_page();
  103d71:	83 ec 0c             	sub    $0xc,%esp
  103d74:	6a 01                	push   $0x1
  103d76:	e8 14 ef ff ff       	call   102c8f <alloc_pages>
  103d7b:	83 c4 10             	add    $0x10,%esp
  103d7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103d81:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d86:	6a 02                	push   $0x2
  103d88:	68 00 01 00 00       	push   $0x100
  103d8d:	ff 75 e0             	pushl  -0x20(%ebp)
  103d90:	50                   	push   %eax
  103d91:	e8 00 f8 ff ff       	call   103596 <page_insert>
  103d96:	83 c4 10             	add    $0x10,%esp
  103d99:	85 c0                	test   %eax,%eax
  103d9b:	74 19                	je     103db6 <check_boot_pgdir+0x18e>
  103d9d:	68 14 68 10 00       	push   $0x106814
  103da2:	68 8d 64 10 00       	push   $0x10648d
  103da7:	68 58 02 00 00       	push   $0x258
  103dac:	68 68 64 10 00       	push   $0x106468
  103db1:	e8 1f c6 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p) == 1);
  103db6:	83 ec 0c             	sub    $0xc,%esp
  103db9:	ff 75 e0             	pushl  -0x20(%ebp)
  103dbc:	e8 c0 ec ff ff       	call   102a81 <page_ref>
  103dc1:	83 c4 10             	add    $0x10,%esp
  103dc4:	83 f8 01             	cmp    $0x1,%eax
  103dc7:	74 19                	je     103de2 <check_boot_pgdir+0x1ba>
  103dc9:	68 42 68 10 00       	push   $0x106842
  103dce:	68 8d 64 10 00       	push   $0x10648d
  103dd3:	68 59 02 00 00       	push   $0x259
  103dd8:	68 68 64 10 00       	push   $0x106468
  103ddd:	e8 f3 c5 ff ff       	call   1003d5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103de2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103de7:	6a 02                	push   $0x2
  103de9:	68 00 11 00 00       	push   $0x1100
  103dee:	ff 75 e0             	pushl  -0x20(%ebp)
  103df1:	50                   	push   %eax
  103df2:	e8 9f f7 ff ff       	call   103596 <page_insert>
  103df7:	83 c4 10             	add    $0x10,%esp
  103dfa:	85 c0                	test   %eax,%eax
  103dfc:	74 19                	je     103e17 <check_boot_pgdir+0x1ef>
  103dfe:	68 54 68 10 00       	push   $0x106854
  103e03:	68 8d 64 10 00       	push   $0x10648d
  103e08:	68 5a 02 00 00       	push   $0x25a
  103e0d:	68 68 64 10 00       	push   $0x106468
  103e12:	e8 be c5 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p) == 2);
  103e17:	83 ec 0c             	sub    $0xc,%esp
  103e1a:	ff 75 e0             	pushl  -0x20(%ebp)
  103e1d:	e8 5f ec ff ff       	call   102a81 <page_ref>
  103e22:	83 c4 10             	add    $0x10,%esp
  103e25:	83 f8 02             	cmp    $0x2,%eax
  103e28:	74 19                	je     103e43 <check_boot_pgdir+0x21b>
  103e2a:	68 8b 68 10 00       	push   $0x10688b
  103e2f:	68 8d 64 10 00       	push   $0x10648d
  103e34:	68 5b 02 00 00       	push   $0x25b
  103e39:	68 68 64 10 00       	push   $0x106468
  103e3e:	e8 92 c5 ff ff       	call   1003d5 <__panic>

    const char *str = "ucore: Hello world!!";
  103e43:	c7 45 dc 9c 68 10 00 	movl   $0x10689c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103e4a:	83 ec 08             	sub    $0x8,%esp
  103e4d:	ff 75 dc             	pushl  -0x24(%ebp)
  103e50:	68 00 01 00 00       	push   $0x100
  103e55:	e8 66 13 00 00       	call   1051c0 <strcpy>
  103e5a:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103e5d:	83 ec 08             	sub    $0x8,%esp
  103e60:	68 00 11 00 00       	push   $0x1100
  103e65:	68 00 01 00 00       	push   $0x100
  103e6a:	e8 cb 13 00 00       	call   10523a <strcmp>
  103e6f:	83 c4 10             	add    $0x10,%esp
  103e72:	85 c0                	test   %eax,%eax
  103e74:	74 19                	je     103e8f <check_boot_pgdir+0x267>
  103e76:	68 b4 68 10 00       	push   $0x1068b4
  103e7b:	68 8d 64 10 00       	push   $0x10648d
  103e80:	68 5f 02 00 00       	push   $0x25f
  103e85:	68 68 64 10 00       	push   $0x106468
  103e8a:	e8 46 c5 ff ff       	call   1003d5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103e8f:	83 ec 0c             	sub    $0xc,%esp
  103e92:	ff 75 e0             	pushl  -0x20(%ebp)
  103e95:	e8 4c eb ff ff       	call   1029e6 <page2kva>
  103e9a:	83 c4 10             	add    $0x10,%esp
  103e9d:	05 00 01 00 00       	add    $0x100,%eax
  103ea2:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103ea5:	83 ec 0c             	sub    $0xc,%esp
  103ea8:	68 00 01 00 00       	push   $0x100
  103ead:	e8 b6 12 00 00       	call   105168 <strlen>
  103eb2:	83 c4 10             	add    $0x10,%esp
  103eb5:	85 c0                	test   %eax,%eax
  103eb7:	74 19                	je     103ed2 <check_boot_pgdir+0x2aa>
  103eb9:	68 ec 68 10 00       	push   $0x1068ec
  103ebe:	68 8d 64 10 00       	push   $0x10648d
  103ec3:	68 62 02 00 00       	push   $0x262
  103ec8:	68 68 64 10 00       	push   $0x106468
  103ecd:	e8 03 c5 ff ff       	call   1003d5 <__panic>

    free_page(p);
  103ed2:	83 ec 08             	sub    $0x8,%esp
  103ed5:	6a 01                	push   $0x1
  103ed7:	ff 75 e0             	pushl  -0x20(%ebp)
  103eda:	e8 ee ed ff ff       	call   102ccd <free_pages>
  103edf:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  103ee2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ee7:	8b 00                	mov    (%eax),%eax
  103ee9:	83 ec 0c             	sub    $0xc,%esp
  103eec:	50                   	push   %eax
  103eed:	e8 73 eb ff ff       	call   102a65 <pde2page>
  103ef2:	83 c4 10             	add    $0x10,%esp
  103ef5:	83 ec 08             	sub    $0x8,%esp
  103ef8:	6a 01                	push   $0x1
  103efa:	50                   	push   %eax
  103efb:	e8 cd ed ff ff       	call   102ccd <free_pages>
  103f00:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103f03:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103f08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103f0e:	83 ec 0c             	sub    $0xc,%esp
  103f11:	68 10 69 10 00       	push   $0x106910
  103f16:	e8 54 c3 ff ff       	call   10026f <cprintf>
  103f1b:	83 c4 10             	add    $0x10,%esp
}
  103f1e:	90                   	nop
  103f1f:	c9                   	leave  
  103f20:	c3                   	ret    

00103f21 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103f21:	55                   	push   %ebp
  103f22:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103f24:	8b 45 08             	mov    0x8(%ebp),%eax
  103f27:	83 e0 04             	and    $0x4,%eax
  103f2a:	85 c0                	test   %eax,%eax
  103f2c:	74 07                	je     103f35 <perm2str+0x14>
  103f2e:	b8 75 00 00 00       	mov    $0x75,%eax
  103f33:	eb 05                	jmp    103f3a <perm2str+0x19>
  103f35:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103f3a:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  103f3f:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103f46:	8b 45 08             	mov    0x8(%ebp),%eax
  103f49:	83 e0 02             	and    $0x2,%eax
  103f4c:	85 c0                	test   %eax,%eax
  103f4e:	74 07                	je     103f57 <perm2str+0x36>
  103f50:	b8 77 00 00 00       	mov    $0x77,%eax
  103f55:	eb 05                	jmp    103f5c <perm2str+0x3b>
  103f57:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103f5c:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  103f61:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  103f68:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  103f6d:	5d                   	pop    %ebp
  103f6e:	c3                   	ret    

00103f6f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103f6f:	55                   	push   %ebp
  103f70:	89 e5                	mov    %esp,%ebp
  103f72:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103f75:	8b 45 10             	mov    0x10(%ebp),%eax
  103f78:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f7b:	72 0e                	jb     103f8b <get_pgtable_items+0x1c>
        return 0;
  103f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  103f82:	e9 9a 00 00 00       	jmp    104021 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103f87:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  103f8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f91:	73 18                	jae    103fab <get_pgtable_items+0x3c>
  103f93:	8b 45 10             	mov    0x10(%ebp),%eax
  103f96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103f9d:	8b 45 14             	mov    0x14(%ebp),%eax
  103fa0:	01 d0                	add    %edx,%eax
  103fa2:	8b 00                	mov    (%eax),%eax
  103fa4:	83 e0 01             	and    $0x1,%eax
  103fa7:	85 c0                	test   %eax,%eax
  103fa9:	74 dc                	je     103f87 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103fab:	8b 45 10             	mov    0x10(%ebp),%eax
  103fae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fb1:	73 69                	jae    10401c <get_pgtable_items+0xad>
        if (left_store != NULL) {
  103fb3:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103fb7:	74 08                	je     103fc1 <get_pgtable_items+0x52>
            *left_store = start;
  103fb9:	8b 45 18             	mov    0x18(%ebp),%eax
  103fbc:	8b 55 10             	mov    0x10(%ebp),%edx
  103fbf:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  103fc4:	8d 50 01             	lea    0x1(%eax),%edx
  103fc7:	89 55 10             	mov    %edx,0x10(%ebp)
  103fca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  103fd4:	01 d0                	add    %edx,%eax
  103fd6:	8b 00                	mov    (%eax),%eax
  103fd8:	83 e0 07             	and    $0x7,%eax
  103fdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103fde:	eb 04                	jmp    103fe4 <get_pgtable_items+0x75>
            start ++;
  103fe0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  103fe7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fea:	73 1d                	jae    104009 <get_pgtable_items+0x9a>
  103fec:	8b 45 10             	mov    0x10(%ebp),%eax
  103fef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  103ff9:	01 d0                	add    %edx,%eax
  103ffb:	8b 00                	mov    (%eax),%eax
  103ffd:	83 e0 07             	and    $0x7,%eax
  104000:	89 c2                	mov    %eax,%edx
  104002:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104005:	39 c2                	cmp    %eax,%edx
  104007:	74 d7                	je     103fe0 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  104009:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10400d:	74 08                	je     104017 <get_pgtable_items+0xa8>
            *right_store = start;
  10400f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104012:	8b 55 10             	mov    0x10(%ebp),%edx
  104015:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10401a:	eb 05                	jmp    104021 <get_pgtable_items+0xb2>
    }
    return 0;
  10401c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104021:	c9                   	leave  
  104022:	c3                   	ret    

00104023 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104023:	55                   	push   %ebp
  104024:	89 e5                	mov    %esp,%ebp
  104026:	57                   	push   %edi
  104027:	56                   	push   %esi
  104028:	53                   	push   %ebx
  104029:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10402c:	83 ec 0c             	sub    $0xc,%esp
  10402f:	68 30 69 10 00       	push   $0x106930
  104034:	e8 36 c2 ff ff       	call   10026f <cprintf>
  104039:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  10403c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104043:	e9 e5 00 00 00       	jmp    10412d <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10404b:	83 ec 0c             	sub    $0xc,%esp
  10404e:	50                   	push   %eax
  10404f:	e8 cd fe ff ff       	call   103f21 <perm2str>
  104054:	83 c4 10             	add    $0x10,%esp
  104057:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104059:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10405c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10405f:	29 c2                	sub    %eax,%edx
  104061:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104063:	c1 e0 16             	shl    $0x16,%eax
  104066:	89 c3                	mov    %eax,%ebx
  104068:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10406b:	c1 e0 16             	shl    $0x16,%eax
  10406e:	89 c1                	mov    %eax,%ecx
  104070:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104073:	c1 e0 16             	shl    $0x16,%eax
  104076:	89 c2                	mov    %eax,%edx
  104078:	8b 75 dc             	mov    -0x24(%ebp),%esi
  10407b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10407e:	29 c6                	sub    %eax,%esi
  104080:	89 f0                	mov    %esi,%eax
  104082:	83 ec 08             	sub    $0x8,%esp
  104085:	57                   	push   %edi
  104086:	53                   	push   %ebx
  104087:	51                   	push   %ecx
  104088:	52                   	push   %edx
  104089:	50                   	push   %eax
  10408a:	68 61 69 10 00       	push   $0x106961
  10408f:	e8 db c1 ff ff       	call   10026f <cprintf>
  104094:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  104097:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10409a:	c1 e0 0a             	shl    $0xa,%eax
  10409d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1040a0:	eb 4f                	jmp    1040f1 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1040a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040a5:	83 ec 0c             	sub    $0xc,%esp
  1040a8:	50                   	push   %eax
  1040a9:	e8 73 fe ff ff       	call   103f21 <perm2str>
  1040ae:	83 c4 10             	add    $0x10,%esp
  1040b1:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1040b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040b9:	29 c2                	sub    %eax,%edx
  1040bb:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1040bd:	c1 e0 0c             	shl    $0xc,%eax
  1040c0:	89 c3                	mov    %eax,%ebx
  1040c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1040c5:	c1 e0 0c             	shl    $0xc,%eax
  1040c8:	89 c1                	mov    %eax,%ecx
  1040ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040cd:	c1 e0 0c             	shl    $0xc,%eax
  1040d0:	89 c2                	mov    %eax,%edx
  1040d2:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  1040d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040d8:	29 c6                	sub    %eax,%esi
  1040da:	89 f0                	mov    %esi,%eax
  1040dc:	83 ec 08             	sub    $0x8,%esp
  1040df:	57                   	push   %edi
  1040e0:	53                   	push   %ebx
  1040e1:	51                   	push   %ecx
  1040e2:	52                   	push   %edx
  1040e3:	50                   	push   %eax
  1040e4:	68 80 69 10 00       	push   $0x106980
  1040e9:	e8 81 c1 ff ff       	call   10026f <cprintf>
  1040ee:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1040f1:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1040f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1040f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040fc:	89 d3                	mov    %edx,%ebx
  1040fe:	c1 e3 0a             	shl    $0xa,%ebx
  104101:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104104:	89 d1                	mov    %edx,%ecx
  104106:	c1 e1 0a             	shl    $0xa,%ecx
  104109:	83 ec 08             	sub    $0x8,%esp
  10410c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10410f:	52                   	push   %edx
  104110:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104113:	52                   	push   %edx
  104114:	56                   	push   %esi
  104115:	50                   	push   %eax
  104116:	53                   	push   %ebx
  104117:	51                   	push   %ecx
  104118:	e8 52 fe ff ff       	call   103f6f <get_pgtable_items>
  10411d:	83 c4 20             	add    $0x20,%esp
  104120:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104123:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104127:	0f 85 75 ff ff ff    	jne    1040a2 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10412d:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104132:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104135:	83 ec 08             	sub    $0x8,%esp
  104138:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10413b:	52                   	push   %edx
  10413c:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10413f:	52                   	push   %edx
  104140:	51                   	push   %ecx
  104141:	50                   	push   %eax
  104142:	68 00 04 00 00       	push   $0x400
  104147:	6a 00                	push   $0x0
  104149:	e8 21 fe ff ff       	call   103f6f <get_pgtable_items>
  10414e:	83 c4 20             	add    $0x20,%esp
  104151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104154:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104158:	0f 85 ea fe ff ff    	jne    104048 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10415e:	83 ec 0c             	sub    $0xc,%esp
  104161:	68 a4 69 10 00       	push   $0x1069a4
  104166:	e8 04 c1 ff ff       	call   10026f <cprintf>
  10416b:	83 c4 10             	add    $0x10,%esp
}
  10416e:	90                   	nop
  10416f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  104172:	5b                   	pop    %ebx
  104173:	5e                   	pop    %esi
  104174:	5f                   	pop    %edi
  104175:	5d                   	pop    %ebp
  104176:	c3                   	ret    

00104177 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104177:	55                   	push   %ebp
  104178:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10417a:	8b 45 08             	mov    0x8(%ebp),%eax
  10417d:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  104183:	29 d0                	sub    %edx,%eax
  104185:	c1 f8 02             	sar    $0x2,%eax
  104188:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10418e:	5d                   	pop    %ebp
  10418f:	c3                   	ret    

00104190 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  104190:	55                   	push   %ebp
  104191:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  104193:	ff 75 08             	pushl  0x8(%ebp)
  104196:	e8 dc ff ff ff       	call   104177 <page2ppn>
  10419b:	83 c4 04             	add    $0x4,%esp
  10419e:	c1 e0 0c             	shl    $0xc,%eax
}
  1041a1:	c9                   	leave  
  1041a2:	c3                   	ret    

001041a3 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1041a3:	55                   	push   %ebp
  1041a4:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1041a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1041a9:	8b 00                	mov    (%eax),%eax
}
  1041ab:	5d                   	pop    %ebp
  1041ac:	c3                   	ret    

001041ad <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1041ad:	55                   	push   %ebp
  1041ae:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1041b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1041b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041b6:	89 10                	mov    %edx,(%eax)
}
  1041b8:	90                   	nop
  1041b9:	5d                   	pop    %ebp
  1041ba:	c3                   	ret    

001041bb <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1041bb:	55                   	push   %ebp
  1041bc:	89 e5                	mov    %esp,%ebp
  1041be:	83 ec 10             	sub    $0x10,%esp
  1041c1:	c7 45 fc bc 89 11 00 	movl   $0x1189bc,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1041c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1041ce:	89 50 04             	mov    %edx,0x4(%eax)
  1041d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041d4:	8b 50 04             	mov    0x4(%eax),%edx
  1041d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041da:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1041dc:	c7 05 c4 89 11 00 00 	movl   $0x0,0x1189c4
  1041e3:	00 00 00 
}
  1041e6:	90                   	nop
  1041e7:	c9                   	leave  
  1041e8:	c3                   	ret    

001041e9 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1041e9:	55                   	push   %ebp
  1041ea:	89 e5                	mov    %esp,%ebp
  1041ec:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1041ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1041f3:	75 16                	jne    10420b <default_init_memmap+0x22>
  1041f5:	68 d8 69 10 00       	push   $0x1069d8
  1041fa:	68 de 69 10 00       	push   $0x1069de
  1041ff:	6a 6d                	push   $0x6d
  104201:	68 f3 69 10 00       	push   $0x1069f3
  104206:	e8 ca c1 ff ff       	call   1003d5 <__panic>
    struct Page *p = base;
  10420b:	8b 45 08             	mov    0x8(%ebp),%eax
  10420e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104211:	eb 6c                	jmp    10427f <default_init_memmap+0x96>
        assert(PageReserved(p));
  104213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104216:	83 c0 04             	add    $0x4,%eax
  104219:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104220:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104226:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104229:	0f a3 10             	bt     %edx,(%eax)
  10422c:	19 c0                	sbb    %eax,%eax
  10422e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  104231:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104235:	0f 95 c0             	setne  %al
  104238:	0f b6 c0             	movzbl %al,%eax
  10423b:	85 c0                	test   %eax,%eax
  10423d:	75 16                	jne    104255 <default_init_memmap+0x6c>
  10423f:	68 09 6a 10 00       	push   $0x106a09
  104244:	68 de 69 10 00       	push   $0x1069de
  104249:	6a 70                	push   $0x70
  10424b:	68 f3 69 10 00       	push   $0x1069f3
  104250:	e8 80 c1 ff ff       	call   1003d5 <__panic>
        p->flags = p->property = 0;     // set all following pages as "not the head page"
  104255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104258:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10425f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104262:	8b 50 08             	mov    0x8(%eax),%edx
  104265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104268:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10426b:	83 ec 08             	sub    $0x8,%esp
  10426e:	6a 00                	push   $0x0
  104270:	ff 75 f4             	pushl  -0xc(%ebp)
  104273:	e8 35 ff ff ff       	call   1041ad <set_page_ref>
  104278:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  10427b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10427f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104282:	89 d0                	mov    %edx,%eax
  104284:	c1 e0 02             	shl    $0x2,%eax
  104287:	01 d0                	add    %edx,%eax
  104289:	c1 e0 02             	shl    $0x2,%eax
  10428c:	89 c2                	mov    %eax,%edx
  10428e:	8b 45 08             	mov    0x8(%ebp),%eax
  104291:	01 d0                	add    %edx,%eax
  104293:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104296:	0f 85 77 ff ff ff    	jne    104213 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;     // set all following pages as "not the head page"
        set_page_ref(p, 0);
    }
    base->property = n;
  10429c:	8b 45 08             	mov    0x8(%ebp),%eax
  10429f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042a2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);              // mark as the head page
  1042a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1042a8:	83 c0 04             	add    $0x4,%eax
  1042ab:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  1042b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1042b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1042b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1042bb:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1042be:	8b 15 c4 89 11 00    	mov    0x1189c4,%edx
  1042c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042c7:	01 d0                	add    %edx,%eax
  1042c9:	a3 c4 89 11 00       	mov    %eax,0x1189c4
    list_add(&free_list, &(base->page_link));
  1042ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1042d1:	83 c0 0c             	add    $0xc,%eax
  1042d4:	c7 45 f0 bc 89 11 00 	movl   $0x1189bc,-0x10(%ebp)
  1042db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1042de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1042e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1042e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1042ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1042ed:	8b 40 04             	mov    0x4(%eax),%eax
  1042f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042f3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1042f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042f9:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1042fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1042ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104302:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104305:	89 10                	mov    %edx,(%eax)
  104307:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10430a:	8b 10                	mov    (%eax),%edx
  10430c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10430f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104312:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104315:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104318:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10431b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10431e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104321:	89 10                	mov    %edx,(%eax)
}
  104323:	90                   	nop
  104324:	c9                   	leave  
  104325:	c3                   	ret    

00104326 <default_alloc_pages>:

// MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
  104326:	55                   	push   %ebp
  104327:	89 e5                	mov    %esp,%ebp
  104329:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10432c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104330:	75 16                	jne    104348 <default_alloc_pages+0x22>
  104332:	68 d8 69 10 00       	push   $0x1069d8
  104337:	68 de 69 10 00       	push   $0x1069de
  10433c:	6a 7d                	push   $0x7d
  10433e:	68 f3 69 10 00       	push   $0x1069f3
  104343:	e8 8d c0 ff ff       	call   1003d5 <__panic>
    if (n > nr_free) {
  104348:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  10434d:	3b 45 08             	cmp    0x8(%ebp),%eax
  104350:	73 0a                	jae    10435c <default_alloc_pages+0x36>
        return NULL;
  104352:	b8 00 00 00 00       	mov    $0x0,%eax
  104357:	e9 48 01 00 00       	jmp    1044a4 <default_alloc_pages+0x17e>
    }
    struct Page *page = NULL;
  10435c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104363:	c7 45 f0 bc 89 11 00 	movl   $0x1189bc,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10436a:	eb 1c                	jmp    104388 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
  10436c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10436f:	83 e8 0c             	sub    $0xc,%eax
  104372:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  104375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104378:	8b 40 08             	mov    0x8(%eax),%eax
  10437b:	3b 45 08             	cmp    0x8(%ebp),%eax
  10437e:	72 08                	jb     104388 <default_alloc_pages+0x62>
            page = p;
  104380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104383:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104386:	eb 18                	jmp    1043a0 <default_alloc_pages+0x7a>
  104388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10438b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10438e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104391:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104394:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104397:	81 7d f0 bc 89 11 00 	cmpl   $0x1189bc,-0x10(%ebp)
  10439e:	75 cc                	jne    10436c <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  1043a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1043a4:	0f 84 f7 00 00 00    	je     1044a1 <default_alloc_pages+0x17b>
  1043aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1043b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043b3:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
  1043b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
  1043b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043bc:	83 c0 0c             	add    $0xc,%eax
  1043bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1043c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043c5:	8b 40 04             	mov    0x4(%eax),%eax
  1043c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1043cb:	8b 12                	mov    (%edx),%edx
  1043cd:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1043d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1043d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1043d6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1043d9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1043dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043df:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1043e2:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  1043e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043e7:	8b 40 08             	mov    0x8(%eax),%eax
  1043ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  1043ed:	0f 86 88 00 00 00    	jbe    10447b <default_alloc_pages+0x155>
            struct Page *p = page + n;                      // split the allocated page
  1043f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1043f6:	89 d0                	mov    %edx,%eax
  1043f8:	c1 e0 02             	shl    $0x2,%eax
  1043fb:	01 d0                	add    %edx,%eax
  1043fd:	c1 e0 02             	shl    $0x2,%eax
  104400:	89 c2                	mov    %eax,%edx
  104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104405:	01 d0                	add    %edx,%eax
  104407:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
  10440a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10440d:	8b 40 08             	mov    0x8(%eax),%eax
  104410:	2b 45 08             	sub    0x8(%ebp),%eax
  104413:	89 c2                	mov    %eax,%edx
  104415:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104418:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
  10441b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10441e:	83 c0 04             	add    $0x4,%eax
  104421:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104428:	89 45 b0             	mov    %eax,-0x50(%ebp)
  10442b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10442e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104431:	0f ab 10             	bts    %edx,(%eax)
            // list_add(&free_list, &(p->page_link));
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
  104434:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104437:	8d 50 0c             	lea    0xc(%eax),%edx
  10443a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10443d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104440:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104446:	8b 00                	mov    (%eax),%eax
  104448:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10444b:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10444e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104454:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104457:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10445a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10445d:	89 10                	mov    %edx,(%eax)
  10445f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104462:	8b 10                	mov    (%eax),%edx
  104464:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104467:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10446a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10446d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104470:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104473:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104476:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104479:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
  10447b:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104480:	2b 45 08             	sub    0x8(%ebp),%eax
  104483:	a3 c4 89 11 00       	mov    %eax,0x1189c4
        ClearPageProperty(page);    // mark as "not head page"
  104488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10448b:	83 c0 04             	add    $0x4,%eax
  10448e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104495:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104498:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10449b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10449e:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  1044a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1044a4:	c9                   	leave  
  1044a5:	c3                   	ret    

001044a6 <default_free_pages>:

// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
  1044a6:	55                   	push   %ebp
  1044a7:	89 e5                	mov    %esp,%ebp
  1044a9:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  1044af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1044b3:	75 19                	jne    1044ce <default_free_pages+0x28>
  1044b5:	68 d8 69 10 00       	push   $0x1069d8
  1044ba:	68 de 69 10 00       	push   $0x1069de
  1044bf:	68 9d 00 00 00       	push   $0x9d
  1044c4:	68 f3 69 10 00       	push   $0x1069f3
  1044c9:	e8 07 bf ff ff       	call   1003d5 <__panic>
    struct Page *p = base;
  1044ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1044d4:	e9 8f 00 00 00       	jmp    104568 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
  1044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044dc:	83 c0 04             	add    $0x4,%eax
  1044df:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  1044e6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1044e9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1044ec:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1044ef:	0f a3 10             	bt     %edx,(%eax)
  1044f2:	19 c0                	sbb    %eax,%eax
  1044f4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1044f7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1044fb:	0f 95 c0             	setne  %al
  1044fe:	0f b6 c0             	movzbl %al,%eax
  104501:	85 c0                	test   %eax,%eax
  104503:	75 2c                	jne    104531 <default_free_pages+0x8b>
  104505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104508:	83 c0 04             	add    $0x4,%eax
  10450b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  104512:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104515:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104518:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10451b:	0f a3 10             	bt     %edx,(%eax)
  10451e:	19 c0                	sbb    %eax,%eax
  104520:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
  104523:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  104527:	0f 95 c0             	setne  %al
  10452a:	0f b6 c0             	movzbl %al,%eax
  10452d:	85 c0                	test   %eax,%eax
  10452f:	74 19                	je     10454a <default_free_pages+0xa4>
  104531:	68 1c 6a 10 00       	push   $0x106a1c
  104536:	68 de 69 10 00       	push   $0x1069de
  10453b:	68 a0 00 00 00       	push   $0xa0
  104540:	68 f3 69 10 00       	push   $0x1069f3
  104545:	e8 8b be ff ff       	call   1003d5 <__panic>
        p->flags = 0;
  10454a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10454d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
  104554:	83 ec 08             	sub    $0x8,%esp
  104557:	6a 00                	push   $0x0
  104559:	ff 75 f4             	pushl  -0xc(%ebp)
  10455c:	e8 4c fc ff ff       	call   1041ad <set_page_ref>
  104561:	83 c4 10             	add    $0x10,%esp
// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  104564:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104568:	8b 55 0c             	mov    0xc(%ebp),%edx
  10456b:	89 d0                	mov    %edx,%eax
  10456d:	c1 e0 02             	shl    $0x2,%eax
  104570:	01 d0                	add    %edx,%eax
  104572:	c1 e0 02             	shl    $0x2,%eax
  104575:	89 c2                	mov    %eax,%edx
  104577:	8b 45 08             	mov    0x8(%ebp),%eax
  10457a:	01 d0                	add    %edx,%eax
  10457c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10457f:	0f 85 54 ff ff ff    	jne    1044d9 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
  104585:	8b 45 08             	mov    0x8(%ebp),%eax
  104588:	8b 55 0c             	mov    0xc(%ebp),%edx
  10458b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10458e:	8b 45 08             	mov    0x8(%ebp),%eax
  104591:	83 c0 04             	add    $0x4,%eax
  104594:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10459b:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10459e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1045a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1045a4:	0f ab 10             	bts    %edx,(%eax)
  1045a7:	c7 45 e8 bc 89 11 00 	movl   $0x1189bc,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1045ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045b1:	8b 40 04             	mov    0x4(%eax),%eax

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
  1045b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1045b7:	e9 1f 01 00 00       	jmp    1046db <default_free_pages+0x235>
        p = le2page(le, page_link);
  1045bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045bf:	83 e8 0c             	sub    $0xc,%eax
  1045c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045ce:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1045d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
  1045d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d7:	8b 50 08             	mov    0x8(%eax),%edx
  1045da:	89 d0                	mov    %edx,%eax
  1045dc:	c1 e0 02             	shl    $0x2,%eax
  1045df:	01 d0                	add    %edx,%eax
  1045e1:	c1 e0 02             	shl    $0x2,%eax
  1045e4:	89 c2                	mov    %eax,%edx
  1045e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e9:	01 d0                	add    %edx,%eax
  1045eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1045ee:	75 67                	jne    104657 <default_free_pages+0x1b1>
            base->property += p->property;
  1045f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1045f3:	8b 50 08             	mov    0x8(%eax),%edx
  1045f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f9:	8b 40 08             	mov    0x8(%eax),%eax
  1045fc:	01 c2                	add    %eax,%edx
  1045fe:	8b 45 08             	mov    0x8(%ebp),%eax
  104601:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
  104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104607:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
  10460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104611:	83 c0 04             	add    $0x4,%eax
  104614:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  10461b:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10461e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104621:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104624:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10462a:	83 c0 0c             	add    $0xc,%eax
  10462d:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104630:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104633:	8b 40 04             	mov    0x4(%eax),%eax
  104636:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104639:	8b 12                	mov    (%edx),%edx
  10463b:	89 55 a8             	mov    %edx,-0x58(%ebp)
  10463e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104641:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104644:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104647:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10464a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10464d:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104650:	89 10                	mov    %edx,(%eax)
  104652:	e9 84 00 00 00       	jmp    1046db <default_free_pages+0x235>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
  104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10465a:	8b 50 08             	mov    0x8(%eax),%edx
  10465d:	89 d0                	mov    %edx,%eax
  10465f:	c1 e0 02             	shl    $0x2,%eax
  104662:	01 d0                	add    %edx,%eax
  104664:	c1 e0 02             	shl    $0x2,%eax
  104667:	89 c2                	mov    %eax,%edx
  104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10466c:	01 d0                	add    %edx,%eax
  10466e:	3b 45 08             	cmp    0x8(%ebp),%eax
  104671:	75 68                	jne    1046db <default_free_pages+0x235>
            p->property += base->property;
  104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104676:	8b 50 08             	mov    0x8(%eax),%edx
  104679:	8b 45 08             	mov    0x8(%ebp),%eax
  10467c:	8b 40 08             	mov    0x8(%eax),%eax
  10467f:	01 c2                	add    %eax,%edx
  104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104684:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
  104687:	8b 45 08             	mov    0x8(%ebp),%eax
  10468a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
  104691:	8b 45 08             	mov    0x8(%ebp),%eax
  104694:	83 c0 04             	add    $0x4,%eax
  104697:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  10469e:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1046a1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1046a4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1046a7:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  1046aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ad:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  1046b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b3:	83 c0 0c             	add    $0xc,%eax
  1046b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1046b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1046bc:	8b 40 04             	mov    0x4(%eax),%eax
  1046bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046c2:	8b 12                	mov    (%edx),%edx
  1046c4:	89 55 9c             	mov    %edx,-0x64(%ebp)
  1046c7:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1046ca:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1046cd:	8b 55 98             	mov    -0x68(%ebp),%edx
  1046d0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1046d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  1046d6:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1046d9:	89 10                	mov    %edx,(%eax)
    base->property = n;
    SetPageProperty(base);

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  1046db:	81 7d f0 bc 89 11 00 	cmpl   $0x1189bc,-0x10(%ebp)
  1046e2:	0f 85 d4 fe ff ff    	jne    1045bc <default_free_pages+0x116>
  1046e8:	c7 45 d0 bc 89 11 00 	movl   $0x1189bc,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1046ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1046f2:	8b 40 04             	mov    0x4(%eax),%eax
            list_del(&(p->page_link));
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
  1046f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1046f8:	eb 20                	jmp    10471a <default_free_pages+0x274>
        p = le2page(le, page_link);
  1046fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046fd:	83 e8 0c             	sub    $0xc,%eax
  104700:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
  104703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104706:	3b 45 08             	cmp    0x8(%ebp),%eax
  104709:	77 1a                	ja     104725 <default_free_pages+0x27f>
  10470b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10470e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104711:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104714:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  104717:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
  10471a:	81 7d f0 bc 89 11 00 	cmpl   $0x1189bc,-0x10(%ebp)
  104721:	75 d7                	jne    1046fa <default_free_pages+0x254>
  104723:	eb 01                	jmp    104726 <default_free_pages+0x280>
        p = le2page(le, page_link);
        if (p > base) {
            break;
  104725:	90                   	nop
        }
        le = list_next(le);
    }
    
    nr_free += n;
  104726:	8b 15 c4 89 11 00    	mov    0x1189c4,%edx
  10472c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10472f:	01 d0                	add    %edx,%eax
  104731:	a3 c4 89 11 00       	mov    %eax,0x1189c4
    // list_add(&free_list, &(base->page_link));
    list_add_before(le, &(base->page_link)); 
  104736:	8b 45 08             	mov    0x8(%ebp),%eax
  104739:	8d 50 0c             	lea    0xc(%eax),%edx
  10473c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10473f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104742:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104745:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104748:	8b 00                	mov    (%eax),%eax
  10474a:	8b 55 90             	mov    -0x70(%ebp),%edx
  10474d:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104750:	89 45 88             	mov    %eax,-0x78(%ebp)
  104753:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104756:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104759:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10475c:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10475f:	89 10                	mov    %edx,(%eax)
  104761:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104764:	8b 10                	mov    (%eax),%edx
  104766:	8b 45 88             	mov    -0x78(%ebp),%eax
  104769:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10476c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10476f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104772:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104775:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104778:	8b 55 88             	mov    -0x78(%ebp),%edx
  10477b:	89 10                	mov    %edx,(%eax)
}
  10477d:	90                   	nop
  10477e:	c9                   	leave  
  10477f:	c3                   	ret    

00104780 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104780:	55                   	push   %ebp
  104781:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104783:	a1 c4 89 11 00       	mov    0x1189c4,%eax
}
  104788:	5d                   	pop    %ebp
  104789:	c3                   	ret    

0010478a <basic_check>:

static void
basic_check(void) {
  10478a:	55                   	push   %ebp
  10478b:	89 e5                	mov    %esp,%ebp
  10478d:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10479a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10479d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1047a3:	83 ec 0c             	sub    $0xc,%esp
  1047a6:	6a 01                	push   $0x1
  1047a8:	e8 e2 e4 ff ff       	call   102c8f <alloc_pages>
  1047ad:	83 c4 10             	add    $0x10,%esp
  1047b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1047b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1047b7:	75 19                	jne    1047d2 <basic_check+0x48>
  1047b9:	68 41 6a 10 00       	push   $0x106a41
  1047be:	68 de 69 10 00       	push   $0x1069de
  1047c3:	68 d5 00 00 00       	push   $0xd5
  1047c8:	68 f3 69 10 00       	push   $0x1069f3
  1047cd:	e8 03 bc ff ff       	call   1003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1047d2:	83 ec 0c             	sub    $0xc,%esp
  1047d5:	6a 01                	push   $0x1
  1047d7:	e8 b3 e4 ff ff       	call   102c8f <alloc_pages>
  1047dc:	83 c4 10             	add    $0x10,%esp
  1047df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1047e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1047e6:	75 19                	jne    104801 <basic_check+0x77>
  1047e8:	68 5d 6a 10 00       	push   $0x106a5d
  1047ed:	68 de 69 10 00       	push   $0x1069de
  1047f2:	68 d6 00 00 00       	push   $0xd6
  1047f7:	68 f3 69 10 00       	push   $0x1069f3
  1047fc:	e8 d4 bb ff ff       	call   1003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104801:	83 ec 0c             	sub    $0xc,%esp
  104804:	6a 01                	push   $0x1
  104806:	e8 84 e4 ff ff       	call   102c8f <alloc_pages>
  10480b:	83 c4 10             	add    $0x10,%esp
  10480e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104815:	75 19                	jne    104830 <basic_check+0xa6>
  104817:	68 79 6a 10 00       	push   $0x106a79
  10481c:	68 de 69 10 00       	push   $0x1069de
  104821:	68 d7 00 00 00       	push   $0xd7
  104826:	68 f3 69 10 00       	push   $0x1069f3
  10482b:	e8 a5 bb ff ff       	call   1003d5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104833:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104836:	74 10                	je     104848 <basic_check+0xbe>
  104838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10483b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10483e:	74 08                	je     104848 <basic_check+0xbe>
  104840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104843:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104846:	75 19                	jne    104861 <basic_check+0xd7>
  104848:	68 98 6a 10 00       	push   $0x106a98
  10484d:	68 de 69 10 00       	push   $0x1069de
  104852:	68 d9 00 00 00       	push   $0xd9
  104857:	68 f3 69 10 00       	push   $0x1069f3
  10485c:	e8 74 bb ff ff       	call   1003d5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104861:	83 ec 0c             	sub    $0xc,%esp
  104864:	ff 75 ec             	pushl  -0x14(%ebp)
  104867:	e8 37 f9 ff ff       	call   1041a3 <page_ref>
  10486c:	83 c4 10             	add    $0x10,%esp
  10486f:	85 c0                	test   %eax,%eax
  104871:	75 24                	jne    104897 <basic_check+0x10d>
  104873:	83 ec 0c             	sub    $0xc,%esp
  104876:	ff 75 f0             	pushl  -0x10(%ebp)
  104879:	e8 25 f9 ff ff       	call   1041a3 <page_ref>
  10487e:	83 c4 10             	add    $0x10,%esp
  104881:	85 c0                	test   %eax,%eax
  104883:	75 12                	jne    104897 <basic_check+0x10d>
  104885:	83 ec 0c             	sub    $0xc,%esp
  104888:	ff 75 f4             	pushl  -0xc(%ebp)
  10488b:	e8 13 f9 ff ff       	call   1041a3 <page_ref>
  104890:	83 c4 10             	add    $0x10,%esp
  104893:	85 c0                	test   %eax,%eax
  104895:	74 19                	je     1048b0 <basic_check+0x126>
  104897:	68 bc 6a 10 00       	push   $0x106abc
  10489c:	68 de 69 10 00       	push   $0x1069de
  1048a1:	68 da 00 00 00       	push   $0xda
  1048a6:	68 f3 69 10 00       	push   $0x1069f3
  1048ab:	e8 25 bb ff ff       	call   1003d5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1048b0:	83 ec 0c             	sub    $0xc,%esp
  1048b3:	ff 75 ec             	pushl  -0x14(%ebp)
  1048b6:	e8 d5 f8 ff ff       	call   104190 <page2pa>
  1048bb:	83 c4 10             	add    $0x10,%esp
  1048be:	89 c2                	mov    %eax,%edx
  1048c0:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048c5:	c1 e0 0c             	shl    $0xc,%eax
  1048c8:	39 c2                	cmp    %eax,%edx
  1048ca:	72 19                	jb     1048e5 <basic_check+0x15b>
  1048cc:	68 f8 6a 10 00       	push   $0x106af8
  1048d1:	68 de 69 10 00       	push   $0x1069de
  1048d6:	68 dc 00 00 00       	push   $0xdc
  1048db:	68 f3 69 10 00       	push   $0x1069f3
  1048e0:	e8 f0 ba ff ff       	call   1003d5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1048e5:	83 ec 0c             	sub    $0xc,%esp
  1048e8:	ff 75 f0             	pushl  -0x10(%ebp)
  1048eb:	e8 a0 f8 ff ff       	call   104190 <page2pa>
  1048f0:	83 c4 10             	add    $0x10,%esp
  1048f3:	89 c2                	mov    %eax,%edx
  1048f5:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048fa:	c1 e0 0c             	shl    $0xc,%eax
  1048fd:	39 c2                	cmp    %eax,%edx
  1048ff:	72 19                	jb     10491a <basic_check+0x190>
  104901:	68 15 6b 10 00       	push   $0x106b15
  104906:	68 de 69 10 00       	push   $0x1069de
  10490b:	68 dd 00 00 00       	push   $0xdd
  104910:	68 f3 69 10 00       	push   $0x1069f3
  104915:	e8 bb ba ff ff       	call   1003d5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10491a:	83 ec 0c             	sub    $0xc,%esp
  10491d:	ff 75 f4             	pushl  -0xc(%ebp)
  104920:	e8 6b f8 ff ff       	call   104190 <page2pa>
  104925:	83 c4 10             	add    $0x10,%esp
  104928:	89 c2                	mov    %eax,%edx
  10492a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10492f:	c1 e0 0c             	shl    $0xc,%eax
  104932:	39 c2                	cmp    %eax,%edx
  104934:	72 19                	jb     10494f <basic_check+0x1c5>
  104936:	68 32 6b 10 00       	push   $0x106b32
  10493b:	68 de 69 10 00       	push   $0x1069de
  104940:	68 de 00 00 00       	push   $0xde
  104945:	68 f3 69 10 00       	push   $0x1069f3
  10494a:	e8 86 ba ff ff       	call   1003d5 <__panic>

    list_entry_t free_list_store = free_list;
  10494f:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104954:	8b 15 c0 89 11 00    	mov    0x1189c0,%edx
  10495a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10495d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104960:	c7 45 e4 bc 89 11 00 	movl   $0x1189bc,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10496a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10496d:	89 50 04             	mov    %edx,0x4(%eax)
  104970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104973:	8b 50 04             	mov    0x4(%eax),%edx
  104976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104979:	89 10                	mov    %edx,(%eax)
  10497b:	c7 45 d8 bc 89 11 00 	movl   $0x1189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104982:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104985:	8b 40 04             	mov    0x4(%eax),%eax
  104988:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10498b:	0f 94 c0             	sete   %al
  10498e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104991:	85 c0                	test   %eax,%eax
  104993:	75 19                	jne    1049ae <basic_check+0x224>
  104995:	68 4f 6b 10 00       	push   $0x106b4f
  10499a:	68 de 69 10 00       	push   $0x1069de
  10499f:	68 e2 00 00 00       	push   $0xe2
  1049a4:	68 f3 69 10 00       	push   $0x1069f3
  1049a9:	e8 27 ba ff ff       	call   1003d5 <__panic>

    unsigned int nr_free_store = nr_free;
  1049ae:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  1049b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1049b6:	c7 05 c4 89 11 00 00 	movl   $0x0,0x1189c4
  1049bd:	00 00 00 

    assert(alloc_page() == NULL);
  1049c0:	83 ec 0c             	sub    $0xc,%esp
  1049c3:	6a 01                	push   $0x1
  1049c5:	e8 c5 e2 ff ff       	call   102c8f <alloc_pages>
  1049ca:	83 c4 10             	add    $0x10,%esp
  1049cd:	85 c0                	test   %eax,%eax
  1049cf:	74 19                	je     1049ea <basic_check+0x260>
  1049d1:	68 66 6b 10 00       	push   $0x106b66
  1049d6:	68 de 69 10 00       	push   $0x1069de
  1049db:	68 e7 00 00 00       	push   $0xe7
  1049e0:	68 f3 69 10 00       	push   $0x1069f3
  1049e5:	e8 eb b9 ff ff       	call   1003d5 <__panic>

    free_page(p0);
  1049ea:	83 ec 08             	sub    $0x8,%esp
  1049ed:	6a 01                	push   $0x1
  1049ef:	ff 75 ec             	pushl  -0x14(%ebp)
  1049f2:	e8 d6 e2 ff ff       	call   102ccd <free_pages>
  1049f7:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  1049fa:	83 ec 08             	sub    $0x8,%esp
  1049fd:	6a 01                	push   $0x1
  1049ff:	ff 75 f0             	pushl  -0x10(%ebp)
  104a02:	e8 c6 e2 ff ff       	call   102ccd <free_pages>
  104a07:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104a0a:	83 ec 08             	sub    $0x8,%esp
  104a0d:	6a 01                	push   $0x1
  104a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  104a12:	e8 b6 e2 ff ff       	call   102ccd <free_pages>
  104a17:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  104a1a:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104a1f:	83 f8 03             	cmp    $0x3,%eax
  104a22:	74 19                	je     104a3d <basic_check+0x2b3>
  104a24:	68 7b 6b 10 00       	push   $0x106b7b
  104a29:	68 de 69 10 00       	push   $0x1069de
  104a2e:	68 ec 00 00 00       	push   $0xec
  104a33:	68 f3 69 10 00       	push   $0x1069f3
  104a38:	e8 98 b9 ff ff       	call   1003d5 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104a3d:	83 ec 0c             	sub    $0xc,%esp
  104a40:	6a 01                	push   $0x1
  104a42:	e8 48 e2 ff ff       	call   102c8f <alloc_pages>
  104a47:	83 c4 10             	add    $0x10,%esp
  104a4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104a51:	75 19                	jne    104a6c <basic_check+0x2e2>
  104a53:	68 41 6a 10 00       	push   $0x106a41
  104a58:	68 de 69 10 00       	push   $0x1069de
  104a5d:	68 ee 00 00 00       	push   $0xee
  104a62:	68 f3 69 10 00       	push   $0x1069f3
  104a67:	e8 69 b9 ff ff       	call   1003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104a6c:	83 ec 0c             	sub    $0xc,%esp
  104a6f:	6a 01                	push   $0x1
  104a71:	e8 19 e2 ff ff       	call   102c8f <alloc_pages>
  104a76:	83 c4 10             	add    $0x10,%esp
  104a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a80:	75 19                	jne    104a9b <basic_check+0x311>
  104a82:	68 5d 6a 10 00       	push   $0x106a5d
  104a87:	68 de 69 10 00       	push   $0x1069de
  104a8c:	68 ef 00 00 00       	push   $0xef
  104a91:	68 f3 69 10 00       	push   $0x1069f3
  104a96:	e8 3a b9 ff ff       	call   1003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104a9b:	83 ec 0c             	sub    $0xc,%esp
  104a9e:	6a 01                	push   $0x1
  104aa0:	e8 ea e1 ff ff       	call   102c8f <alloc_pages>
  104aa5:	83 c4 10             	add    $0x10,%esp
  104aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104aaf:	75 19                	jne    104aca <basic_check+0x340>
  104ab1:	68 79 6a 10 00       	push   $0x106a79
  104ab6:	68 de 69 10 00       	push   $0x1069de
  104abb:	68 f0 00 00 00       	push   $0xf0
  104ac0:	68 f3 69 10 00       	push   $0x1069f3
  104ac5:	e8 0b b9 ff ff       	call   1003d5 <__panic>

    assert(alloc_page() == NULL);
  104aca:	83 ec 0c             	sub    $0xc,%esp
  104acd:	6a 01                	push   $0x1
  104acf:	e8 bb e1 ff ff       	call   102c8f <alloc_pages>
  104ad4:	83 c4 10             	add    $0x10,%esp
  104ad7:	85 c0                	test   %eax,%eax
  104ad9:	74 19                	je     104af4 <basic_check+0x36a>
  104adb:	68 66 6b 10 00       	push   $0x106b66
  104ae0:	68 de 69 10 00       	push   $0x1069de
  104ae5:	68 f2 00 00 00       	push   $0xf2
  104aea:	68 f3 69 10 00       	push   $0x1069f3
  104aef:	e8 e1 b8 ff ff       	call   1003d5 <__panic>

    free_page(p0);
  104af4:	83 ec 08             	sub    $0x8,%esp
  104af7:	6a 01                	push   $0x1
  104af9:	ff 75 ec             	pushl  -0x14(%ebp)
  104afc:	e8 cc e1 ff ff       	call   102ccd <free_pages>
  104b01:	83 c4 10             	add    $0x10,%esp
  104b04:	c7 45 e8 bc 89 11 00 	movl   $0x1189bc,-0x18(%ebp)
  104b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104b0e:	8b 40 04             	mov    0x4(%eax),%eax
  104b11:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b14:	0f 94 c0             	sete   %al
  104b17:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104b1a:	85 c0                	test   %eax,%eax
  104b1c:	74 19                	je     104b37 <basic_check+0x3ad>
  104b1e:	68 88 6b 10 00       	push   $0x106b88
  104b23:	68 de 69 10 00       	push   $0x1069de
  104b28:	68 f5 00 00 00       	push   $0xf5
  104b2d:	68 f3 69 10 00       	push   $0x1069f3
  104b32:	e8 9e b8 ff ff       	call   1003d5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104b37:	83 ec 0c             	sub    $0xc,%esp
  104b3a:	6a 01                	push   $0x1
  104b3c:	e8 4e e1 ff ff       	call   102c8f <alloc_pages>
  104b41:	83 c4 10             	add    $0x10,%esp
  104b44:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104b47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b4a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104b4d:	74 19                	je     104b68 <basic_check+0x3de>
  104b4f:	68 a0 6b 10 00       	push   $0x106ba0
  104b54:	68 de 69 10 00       	push   $0x1069de
  104b59:	68 f8 00 00 00       	push   $0xf8
  104b5e:	68 f3 69 10 00       	push   $0x1069f3
  104b63:	e8 6d b8 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  104b68:	83 ec 0c             	sub    $0xc,%esp
  104b6b:	6a 01                	push   $0x1
  104b6d:	e8 1d e1 ff ff       	call   102c8f <alloc_pages>
  104b72:	83 c4 10             	add    $0x10,%esp
  104b75:	85 c0                	test   %eax,%eax
  104b77:	74 19                	je     104b92 <basic_check+0x408>
  104b79:	68 66 6b 10 00       	push   $0x106b66
  104b7e:	68 de 69 10 00       	push   $0x1069de
  104b83:	68 f9 00 00 00       	push   $0xf9
  104b88:	68 f3 69 10 00       	push   $0x1069f3
  104b8d:	e8 43 b8 ff ff       	call   1003d5 <__panic>

    assert(nr_free == 0);
  104b92:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104b97:	85 c0                	test   %eax,%eax
  104b99:	74 19                	je     104bb4 <basic_check+0x42a>
  104b9b:	68 b9 6b 10 00       	push   $0x106bb9
  104ba0:	68 de 69 10 00       	push   $0x1069de
  104ba5:	68 fb 00 00 00       	push   $0xfb
  104baa:	68 f3 69 10 00       	push   $0x1069f3
  104baf:	e8 21 b8 ff ff       	call   1003d5 <__panic>
    free_list = free_list_store;
  104bb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104bb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104bba:	a3 bc 89 11 00       	mov    %eax,0x1189bc
  104bbf:	89 15 c0 89 11 00    	mov    %edx,0x1189c0
    nr_free = nr_free_store;
  104bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104bc8:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    free_page(p);
  104bcd:	83 ec 08             	sub    $0x8,%esp
  104bd0:	6a 01                	push   $0x1
  104bd2:	ff 75 dc             	pushl  -0x24(%ebp)
  104bd5:	e8 f3 e0 ff ff       	call   102ccd <free_pages>
  104bda:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104bdd:	83 ec 08             	sub    $0x8,%esp
  104be0:	6a 01                	push   $0x1
  104be2:	ff 75 f0             	pushl  -0x10(%ebp)
  104be5:	e8 e3 e0 ff ff       	call   102ccd <free_pages>
  104bea:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104bed:	83 ec 08             	sub    $0x8,%esp
  104bf0:	6a 01                	push   $0x1
  104bf2:	ff 75 f4             	pushl  -0xc(%ebp)
  104bf5:	e8 d3 e0 ff ff       	call   102ccd <free_pages>
  104bfa:	83 c4 10             	add    $0x10,%esp
}
  104bfd:	90                   	nop
  104bfe:	c9                   	leave  
  104bff:	c3                   	ret    

00104c00 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104c00:	55                   	push   %ebp
  104c01:	89 e5                	mov    %esp,%ebp
  104c03:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  104c09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104c10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104c17:	c7 45 ec bc 89 11 00 	movl   $0x1189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104c1e:	eb 60                	jmp    104c80 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
  104c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c23:	83 e8 0c             	sub    $0xc,%eax
  104c26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  104c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c2c:	83 c0 04             	add    $0x4,%eax
  104c2f:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104c36:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c39:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104c3c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104c3f:	0f a3 10             	bt     %edx,(%eax)
  104c42:	19 c0                	sbb    %eax,%eax
  104c44:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  104c47:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  104c4b:	0f 95 c0             	setne  %al
  104c4e:	0f b6 c0             	movzbl %al,%eax
  104c51:	85 c0                	test   %eax,%eax
  104c53:	75 19                	jne    104c6e <default_check+0x6e>
  104c55:	68 c6 6b 10 00       	push   $0x106bc6
  104c5a:	68 de 69 10 00       	push   $0x1069de
  104c5f:	68 0c 01 00 00       	push   $0x10c
  104c64:	68 f3 69 10 00       	push   $0x1069f3
  104c69:	e8 67 b7 ff ff       	call   1003d5 <__panic>
        count ++, total += p->property;
  104c6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c75:	8b 50 08             	mov    0x8(%eax),%edx
  104c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c7b:	01 d0                	add    %edx,%eax
  104c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c83:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c89:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c8f:	81 7d ec bc 89 11 00 	cmpl   $0x1189bc,-0x14(%ebp)
  104c96:	75 88                	jne    104c20 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  104c98:	e8 65 e0 ff ff       	call   102d02 <nr_free_pages>
  104c9d:	89 c2                	mov    %eax,%edx
  104c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ca2:	39 c2                	cmp    %eax,%edx
  104ca4:	74 19                	je     104cbf <default_check+0xbf>
  104ca6:	68 d6 6b 10 00       	push   $0x106bd6
  104cab:	68 de 69 10 00       	push   $0x1069de
  104cb0:	68 0f 01 00 00       	push   $0x10f
  104cb5:	68 f3 69 10 00       	push   $0x1069f3
  104cba:	e8 16 b7 ff ff       	call   1003d5 <__panic>

    basic_check();
  104cbf:	e8 c6 fa ff ff       	call   10478a <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104cc4:	83 ec 0c             	sub    $0xc,%esp
  104cc7:	6a 05                	push   $0x5
  104cc9:	e8 c1 df ff ff       	call   102c8f <alloc_pages>
  104cce:	83 c4 10             	add    $0x10,%esp
  104cd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
  104cd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104cd8:	75 19                	jne    104cf3 <default_check+0xf3>
  104cda:	68 ef 6b 10 00       	push   $0x106bef
  104cdf:	68 de 69 10 00       	push   $0x1069de
  104ce4:	68 14 01 00 00       	push   $0x114
  104ce9:	68 f3 69 10 00       	push   $0x1069f3
  104cee:	e8 e2 b6 ff ff       	call   1003d5 <__panic>
    assert(!PageProperty(p0));
  104cf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104cf6:	83 c0 04             	add    $0x4,%eax
  104cf9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104d00:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d03:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104d06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104d09:	0f a3 10             	bt     %edx,(%eax)
  104d0c:	19 c0                	sbb    %eax,%eax
  104d0e:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  104d11:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  104d15:	0f 95 c0             	setne  %al
  104d18:	0f b6 c0             	movzbl %al,%eax
  104d1b:	85 c0                	test   %eax,%eax
  104d1d:	74 19                	je     104d38 <default_check+0x138>
  104d1f:	68 fa 6b 10 00       	push   $0x106bfa
  104d24:	68 de 69 10 00       	push   $0x1069de
  104d29:	68 15 01 00 00       	push   $0x115
  104d2e:	68 f3 69 10 00       	push   $0x1069f3
  104d33:	e8 9d b6 ff ff       	call   1003d5 <__panic>

    list_entry_t free_list_store = free_list;
  104d38:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104d3d:	8b 15 c0 89 11 00    	mov    0x1189c0,%edx
  104d43:	89 45 80             	mov    %eax,-0x80(%ebp)
  104d46:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104d49:	c7 45 d0 bc 89 11 00 	movl   $0x1189bc,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104d50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d53:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104d56:	89 50 04             	mov    %edx,0x4(%eax)
  104d59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d5c:	8b 50 04             	mov    0x4(%eax),%edx
  104d5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d62:	89 10                	mov    %edx,(%eax)
  104d64:	c7 45 d8 bc 89 11 00 	movl   $0x1189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104d6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104d6e:	8b 40 04             	mov    0x4(%eax),%eax
  104d71:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104d74:	0f 94 c0             	sete   %al
  104d77:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104d7a:	85 c0                	test   %eax,%eax
  104d7c:	75 19                	jne    104d97 <default_check+0x197>
  104d7e:	68 4f 6b 10 00       	push   $0x106b4f
  104d83:	68 de 69 10 00       	push   $0x1069de
  104d88:	68 19 01 00 00       	push   $0x119
  104d8d:	68 f3 69 10 00       	push   $0x1069f3
  104d92:	e8 3e b6 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  104d97:	83 ec 0c             	sub    $0xc,%esp
  104d9a:	6a 01                	push   $0x1
  104d9c:	e8 ee de ff ff       	call   102c8f <alloc_pages>
  104da1:	83 c4 10             	add    $0x10,%esp
  104da4:	85 c0                	test   %eax,%eax
  104da6:	74 19                	je     104dc1 <default_check+0x1c1>
  104da8:	68 66 6b 10 00       	push   $0x106b66
  104dad:	68 de 69 10 00       	push   $0x1069de
  104db2:	68 1a 01 00 00       	push   $0x11a
  104db7:	68 f3 69 10 00       	push   $0x1069f3
  104dbc:	e8 14 b6 ff ff       	call   1003d5 <__panic>

    unsigned int nr_free_store = nr_free;
  104dc1:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104dc6:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  104dc9:	c7 05 c4 89 11 00 00 	movl   $0x0,0x1189c4
  104dd0:	00 00 00 

    free_pages(p0 + 2, 3);
  104dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104dd6:	83 c0 28             	add    $0x28,%eax
  104dd9:	83 ec 08             	sub    $0x8,%esp
  104ddc:	6a 03                	push   $0x3
  104dde:	50                   	push   %eax
  104ddf:	e8 e9 de ff ff       	call   102ccd <free_pages>
  104de4:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  104de7:	83 ec 0c             	sub    $0xc,%esp
  104dea:	6a 04                	push   $0x4
  104dec:	e8 9e de ff ff       	call   102c8f <alloc_pages>
  104df1:	83 c4 10             	add    $0x10,%esp
  104df4:	85 c0                	test   %eax,%eax
  104df6:	74 19                	je     104e11 <default_check+0x211>
  104df8:	68 0c 6c 10 00       	push   $0x106c0c
  104dfd:	68 de 69 10 00       	push   $0x1069de
  104e02:	68 20 01 00 00       	push   $0x120
  104e07:	68 f3 69 10 00       	push   $0x1069f3
  104e0c:	e8 c4 b5 ff ff       	call   1003d5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104e11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e14:	83 c0 28             	add    $0x28,%eax
  104e17:	83 c0 04             	add    $0x4,%eax
  104e1a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104e21:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e24:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104e27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104e2a:	0f a3 10             	bt     %edx,(%eax)
  104e2d:	19 c0                	sbb    %eax,%eax
  104e2f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104e32:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104e36:	0f 95 c0             	setne  %al
  104e39:	0f b6 c0             	movzbl %al,%eax
  104e3c:	85 c0                	test   %eax,%eax
  104e3e:	74 0e                	je     104e4e <default_check+0x24e>
  104e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e43:	83 c0 28             	add    $0x28,%eax
  104e46:	8b 40 08             	mov    0x8(%eax),%eax
  104e49:	83 f8 03             	cmp    $0x3,%eax
  104e4c:	74 19                	je     104e67 <default_check+0x267>
  104e4e:	68 24 6c 10 00       	push   $0x106c24
  104e53:	68 de 69 10 00       	push   $0x1069de
  104e58:	68 21 01 00 00       	push   $0x121
  104e5d:	68 f3 69 10 00       	push   $0x1069f3
  104e62:	e8 6e b5 ff ff       	call   1003d5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104e67:	83 ec 0c             	sub    $0xc,%esp
  104e6a:	6a 03                	push   $0x3
  104e6c:	e8 1e de ff ff       	call   102c8f <alloc_pages>
  104e71:	83 c4 10             	add    $0x10,%esp
  104e74:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104e77:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104e7b:	75 19                	jne    104e96 <default_check+0x296>
  104e7d:	68 50 6c 10 00       	push   $0x106c50
  104e82:	68 de 69 10 00       	push   $0x1069de
  104e87:	68 22 01 00 00       	push   $0x122
  104e8c:	68 f3 69 10 00       	push   $0x1069f3
  104e91:	e8 3f b5 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  104e96:	83 ec 0c             	sub    $0xc,%esp
  104e99:	6a 01                	push   $0x1
  104e9b:	e8 ef dd ff ff       	call   102c8f <alloc_pages>
  104ea0:	83 c4 10             	add    $0x10,%esp
  104ea3:	85 c0                	test   %eax,%eax
  104ea5:	74 19                	je     104ec0 <default_check+0x2c0>
  104ea7:	68 66 6b 10 00       	push   $0x106b66
  104eac:	68 de 69 10 00       	push   $0x1069de
  104eb1:	68 23 01 00 00       	push   $0x123
  104eb6:	68 f3 69 10 00       	push   $0x1069f3
  104ebb:	e8 15 b5 ff ff       	call   1003d5 <__panic>
    assert(p0 + 2 == p1);
  104ec0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ec3:	83 c0 28             	add    $0x28,%eax
  104ec6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  104ec9:	74 19                	je     104ee4 <default_check+0x2e4>
  104ecb:	68 6e 6c 10 00       	push   $0x106c6e
  104ed0:	68 de 69 10 00       	push   $0x1069de
  104ed5:	68 24 01 00 00       	push   $0x124
  104eda:	68 f3 69 10 00       	push   $0x1069f3
  104edf:	e8 f1 b4 ff ff       	call   1003d5 <__panic>

    p2 = p0 + 1;
  104ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ee7:	83 c0 14             	add    $0x14,%eax
  104eea:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  104eed:	83 ec 08             	sub    $0x8,%esp
  104ef0:	6a 01                	push   $0x1
  104ef2:	ff 75 dc             	pushl  -0x24(%ebp)
  104ef5:	e8 d3 dd ff ff       	call   102ccd <free_pages>
  104efa:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  104efd:	83 ec 08             	sub    $0x8,%esp
  104f00:	6a 03                	push   $0x3
  104f02:	ff 75 c4             	pushl  -0x3c(%ebp)
  104f05:	e8 c3 dd ff ff       	call   102ccd <free_pages>
  104f0a:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  104f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f10:	83 c0 04             	add    $0x4,%eax
  104f13:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104f1a:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f1d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104f20:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104f23:	0f a3 10             	bt     %edx,(%eax)
  104f26:	19 c0                	sbb    %eax,%eax
  104f28:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  104f2b:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  104f2f:	0f 95 c0             	setne  %al
  104f32:	0f b6 c0             	movzbl %al,%eax
  104f35:	85 c0                	test   %eax,%eax
  104f37:	74 0b                	je     104f44 <default_check+0x344>
  104f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f3c:	8b 40 08             	mov    0x8(%eax),%eax
  104f3f:	83 f8 01             	cmp    $0x1,%eax
  104f42:	74 19                	je     104f5d <default_check+0x35d>
  104f44:	68 7c 6c 10 00       	push   $0x106c7c
  104f49:	68 de 69 10 00       	push   $0x1069de
  104f4e:	68 29 01 00 00       	push   $0x129
  104f53:	68 f3 69 10 00       	push   $0x1069f3
  104f58:	e8 78 b4 ff ff       	call   1003d5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104f5d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104f60:	83 c0 04             	add    $0x4,%eax
  104f63:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104f6a:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f6d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104f70:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104f73:	0f a3 10             	bt     %edx,(%eax)
  104f76:	19 c0                	sbb    %eax,%eax
  104f78:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  104f7b:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  104f7f:	0f 95 c0             	setne  %al
  104f82:	0f b6 c0             	movzbl %al,%eax
  104f85:	85 c0                	test   %eax,%eax
  104f87:	74 0b                	je     104f94 <default_check+0x394>
  104f89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104f8c:	8b 40 08             	mov    0x8(%eax),%eax
  104f8f:	83 f8 03             	cmp    $0x3,%eax
  104f92:	74 19                	je     104fad <default_check+0x3ad>
  104f94:	68 a4 6c 10 00       	push   $0x106ca4
  104f99:	68 de 69 10 00       	push   $0x1069de
  104f9e:	68 2a 01 00 00       	push   $0x12a
  104fa3:	68 f3 69 10 00       	push   $0x1069f3
  104fa8:	e8 28 b4 ff ff       	call   1003d5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104fad:	83 ec 0c             	sub    $0xc,%esp
  104fb0:	6a 01                	push   $0x1
  104fb2:	e8 d8 dc ff ff       	call   102c8f <alloc_pages>
  104fb7:	83 c4 10             	add    $0x10,%esp
  104fba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104fbd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104fc0:	83 e8 14             	sub    $0x14,%eax
  104fc3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104fc6:	74 19                	je     104fe1 <default_check+0x3e1>
  104fc8:	68 ca 6c 10 00       	push   $0x106cca
  104fcd:	68 de 69 10 00       	push   $0x1069de
  104fd2:	68 2c 01 00 00       	push   $0x12c
  104fd7:	68 f3 69 10 00       	push   $0x1069f3
  104fdc:	e8 f4 b3 ff ff       	call   1003d5 <__panic>
    free_page(p0);
  104fe1:	83 ec 08             	sub    $0x8,%esp
  104fe4:	6a 01                	push   $0x1
  104fe6:	ff 75 dc             	pushl  -0x24(%ebp)
  104fe9:	e8 df dc ff ff       	call   102ccd <free_pages>
  104fee:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104ff1:	83 ec 0c             	sub    $0xc,%esp
  104ff4:	6a 02                	push   $0x2
  104ff6:	e8 94 dc ff ff       	call   102c8f <alloc_pages>
  104ffb:	83 c4 10             	add    $0x10,%esp
  104ffe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105001:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105004:	83 c0 14             	add    $0x14,%eax
  105007:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10500a:	74 19                	je     105025 <default_check+0x425>
  10500c:	68 e8 6c 10 00       	push   $0x106ce8
  105011:	68 de 69 10 00       	push   $0x1069de
  105016:	68 2e 01 00 00       	push   $0x12e
  10501b:	68 f3 69 10 00       	push   $0x1069f3
  105020:	e8 b0 b3 ff ff       	call   1003d5 <__panic>

    free_pages(p0, 2);
  105025:	83 ec 08             	sub    $0x8,%esp
  105028:	6a 02                	push   $0x2
  10502a:	ff 75 dc             	pushl  -0x24(%ebp)
  10502d:	e8 9b dc ff ff       	call   102ccd <free_pages>
  105032:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  105035:	83 ec 08             	sub    $0x8,%esp
  105038:	6a 01                	push   $0x1
  10503a:	ff 75 c0             	pushl  -0x40(%ebp)
  10503d:	e8 8b dc ff ff       	call   102ccd <free_pages>
  105042:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  105045:	83 ec 0c             	sub    $0xc,%esp
  105048:	6a 05                	push   $0x5
  10504a:	e8 40 dc ff ff       	call   102c8f <alloc_pages>
  10504f:	83 c4 10             	add    $0x10,%esp
  105052:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105055:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105059:	75 19                	jne    105074 <default_check+0x474>
  10505b:	68 08 6d 10 00       	push   $0x106d08
  105060:	68 de 69 10 00       	push   $0x1069de
  105065:	68 33 01 00 00       	push   $0x133
  10506a:	68 f3 69 10 00       	push   $0x1069f3
  10506f:	e8 61 b3 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  105074:	83 ec 0c             	sub    $0xc,%esp
  105077:	6a 01                	push   $0x1
  105079:	e8 11 dc ff ff       	call   102c8f <alloc_pages>
  10507e:	83 c4 10             	add    $0x10,%esp
  105081:	85 c0                	test   %eax,%eax
  105083:	74 19                	je     10509e <default_check+0x49e>
  105085:	68 66 6b 10 00       	push   $0x106b66
  10508a:	68 de 69 10 00       	push   $0x1069de
  10508f:	68 34 01 00 00       	push   $0x134
  105094:	68 f3 69 10 00       	push   $0x1069f3
  105099:	e8 37 b3 ff ff       	call   1003d5 <__panic>

    assert(nr_free == 0);
  10509e:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  1050a3:	85 c0                	test   %eax,%eax
  1050a5:	74 19                	je     1050c0 <default_check+0x4c0>
  1050a7:	68 b9 6b 10 00       	push   $0x106bb9
  1050ac:	68 de 69 10 00       	push   $0x1069de
  1050b1:	68 36 01 00 00       	push   $0x136
  1050b6:	68 f3 69 10 00       	push   $0x1069f3
  1050bb:	e8 15 b3 ff ff       	call   1003d5 <__panic>
    nr_free = nr_free_store;
  1050c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1050c3:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    free_list = free_list_store;
  1050c8:	8b 45 80             	mov    -0x80(%ebp),%eax
  1050cb:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1050ce:	a3 bc 89 11 00       	mov    %eax,0x1189bc
  1050d3:	89 15 c0 89 11 00    	mov    %edx,0x1189c0
    free_pages(p0, 5);
  1050d9:	83 ec 08             	sub    $0x8,%esp
  1050dc:	6a 05                	push   $0x5
  1050de:	ff 75 dc             	pushl  -0x24(%ebp)
  1050e1:	e8 e7 db ff ff       	call   102ccd <free_pages>
  1050e6:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  1050e9:	c7 45 ec bc 89 11 00 	movl   $0x1189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1050f0:	eb 1d                	jmp    10510f <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
  1050f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050f5:	83 e8 0c             	sub    $0xc,%eax
  1050f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  1050fb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1050ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105102:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105105:	8b 40 08             	mov    0x8(%eax),%eax
  105108:	29 c2                	sub    %eax,%edx
  10510a:	89 d0                	mov    %edx,%eax
  10510c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10510f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105112:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  105115:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105118:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10511b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10511e:	81 7d ec bc 89 11 00 	cmpl   $0x1189bc,-0x14(%ebp)
  105125:	75 cb                	jne    1050f2 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  105127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10512b:	74 19                	je     105146 <default_check+0x546>
  10512d:	68 26 6d 10 00       	push   $0x106d26
  105132:	68 de 69 10 00       	push   $0x1069de
  105137:	68 41 01 00 00       	push   $0x141
  10513c:	68 f3 69 10 00       	push   $0x1069f3
  105141:	e8 8f b2 ff ff       	call   1003d5 <__panic>
    assert(total == 0);
  105146:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10514a:	74 19                	je     105165 <default_check+0x565>
  10514c:	68 31 6d 10 00       	push   $0x106d31
  105151:	68 de 69 10 00       	push   $0x1069de
  105156:	68 42 01 00 00       	push   $0x142
  10515b:	68 f3 69 10 00       	push   $0x1069f3
  105160:	e8 70 b2 ff ff       	call   1003d5 <__panic>
}
  105165:	90                   	nop
  105166:	c9                   	leave  
  105167:	c3                   	ret    

00105168 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105168:	55                   	push   %ebp
  105169:	89 e5                	mov    %esp,%ebp
  10516b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10516e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105175:	eb 04                	jmp    10517b <strlen+0x13>
        cnt ++;
  105177:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  10517b:	8b 45 08             	mov    0x8(%ebp),%eax
  10517e:	8d 50 01             	lea    0x1(%eax),%edx
  105181:	89 55 08             	mov    %edx,0x8(%ebp)
  105184:	0f b6 00             	movzbl (%eax),%eax
  105187:	84 c0                	test   %al,%al
  105189:	75 ec                	jne    105177 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  10518b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10518e:	c9                   	leave  
  10518f:	c3                   	ret    

00105190 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105190:	55                   	push   %ebp
  105191:	89 e5                	mov    %esp,%ebp
  105193:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10519d:	eb 04                	jmp    1051a3 <strnlen+0x13>
        cnt ++;
  10519f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1051a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051a9:	73 10                	jae    1051bb <strnlen+0x2b>
  1051ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1051ae:	8d 50 01             	lea    0x1(%eax),%edx
  1051b1:	89 55 08             	mov    %edx,0x8(%ebp)
  1051b4:	0f b6 00             	movzbl (%eax),%eax
  1051b7:	84 c0                	test   %al,%al
  1051b9:	75 e4                	jne    10519f <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  1051bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1051be:	c9                   	leave  
  1051bf:	c3                   	ret    

001051c0 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1051c0:	55                   	push   %ebp
  1051c1:	89 e5                	mov    %esp,%ebp
  1051c3:	57                   	push   %edi
  1051c4:	56                   	push   %esi
  1051c5:	83 ec 20             	sub    $0x20,%esp
  1051c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1051cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1051ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1051d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1051d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051da:	89 d1                	mov    %edx,%ecx
  1051dc:	89 c2                	mov    %eax,%edx
  1051de:	89 ce                	mov    %ecx,%esi
  1051e0:	89 d7                	mov    %edx,%edi
  1051e2:	ac                   	lods   %ds:(%esi),%al
  1051e3:	aa                   	stos   %al,%es:(%edi)
  1051e4:	84 c0                	test   %al,%al
  1051e6:	75 fa                	jne    1051e2 <strcpy+0x22>
  1051e8:	89 fa                	mov    %edi,%edx
  1051ea:	89 f1                	mov    %esi,%ecx
  1051ec:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1051ef:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1051f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1051f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1051f8:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1051f9:	83 c4 20             	add    $0x20,%esp
  1051fc:	5e                   	pop    %esi
  1051fd:	5f                   	pop    %edi
  1051fe:	5d                   	pop    %ebp
  1051ff:	c3                   	ret    

00105200 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105200:	55                   	push   %ebp
  105201:	89 e5                	mov    %esp,%ebp
  105203:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105206:	8b 45 08             	mov    0x8(%ebp),%eax
  105209:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10520c:	eb 21                	jmp    10522f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10520e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105211:	0f b6 10             	movzbl (%eax),%edx
  105214:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105217:	88 10                	mov    %dl,(%eax)
  105219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10521c:	0f b6 00             	movzbl (%eax),%eax
  10521f:	84 c0                	test   %al,%al
  105221:	74 04                	je     105227 <strncpy+0x27>
            src ++;
  105223:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105227:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10522b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10522f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105233:	75 d9                	jne    10520e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105235:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105238:	c9                   	leave  
  105239:	c3                   	ret    

0010523a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10523a:	55                   	push   %ebp
  10523b:	89 e5                	mov    %esp,%ebp
  10523d:	57                   	push   %edi
  10523e:	56                   	push   %esi
  10523f:	83 ec 20             	sub    $0x20,%esp
  105242:	8b 45 08             	mov    0x8(%ebp),%eax
  105245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105248:	8b 45 0c             	mov    0xc(%ebp),%eax
  10524b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10524e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105254:	89 d1                	mov    %edx,%ecx
  105256:	89 c2                	mov    %eax,%edx
  105258:	89 ce                	mov    %ecx,%esi
  10525a:	89 d7                	mov    %edx,%edi
  10525c:	ac                   	lods   %ds:(%esi),%al
  10525d:	ae                   	scas   %es:(%edi),%al
  10525e:	75 08                	jne    105268 <strcmp+0x2e>
  105260:	84 c0                	test   %al,%al
  105262:	75 f8                	jne    10525c <strcmp+0x22>
  105264:	31 c0                	xor    %eax,%eax
  105266:	eb 04                	jmp    10526c <strcmp+0x32>
  105268:	19 c0                	sbb    %eax,%eax
  10526a:	0c 01                	or     $0x1,%al
  10526c:	89 fa                	mov    %edi,%edx
  10526e:	89 f1                	mov    %esi,%ecx
  105270:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105273:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105276:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105279:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  10527c:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10527d:	83 c4 20             	add    $0x20,%esp
  105280:	5e                   	pop    %esi
  105281:	5f                   	pop    %edi
  105282:	5d                   	pop    %ebp
  105283:	c3                   	ret    

00105284 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105284:	55                   	push   %ebp
  105285:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105287:	eb 0c                	jmp    105295 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105289:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10528d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105291:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105299:	74 1a                	je     1052b5 <strncmp+0x31>
  10529b:	8b 45 08             	mov    0x8(%ebp),%eax
  10529e:	0f b6 00             	movzbl (%eax),%eax
  1052a1:	84 c0                	test   %al,%al
  1052a3:	74 10                	je     1052b5 <strncmp+0x31>
  1052a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1052a8:	0f b6 10             	movzbl (%eax),%edx
  1052ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052ae:	0f b6 00             	movzbl (%eax),%eax
  1052b1:	38 c2                	cmp    %al,%dl
  1052b3:	74 d4                	je     105289 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1052b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1052b9:	74 18                	je     1052d3 <strncmp+0x4f>
  1052bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1052be:	0f b6 00             	movzbl (%eax),%eax
  1052c1:	0f b6 d0             	movzbl %al,%edx
  1052c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052c7:	0f b6 00             	movzbl (%eax),%eax
  1052ca:	0f b6 c0             	movzbl %al,%eax
  1052cd:	29 c2                	sub    %eax,%edx
  1052cf:	89 d0                	mov    %edx,%eax
  1052d1:	eb 05                	jmp    1052d8 <strncmp+0x54>
  1052d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052d8:	5d                   	pop    %ebp
  1052d9:	c3                   	ret    

001052da <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1052da:	55                   	push   %ebp
  1052db:	89 e5                	mov    %esp,%ebp
  1052dd:	83 ec 04             	sub    $0x4,%esp
  1052e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052e3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1052e6:	eb 14                	jmp    1052fc <strchr+0x22>
        if (*s == c) {
  1052e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1052eb:	0f b6 00             	movzbl (%eax),%eax
  1052ee:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1052f1:	75 05                	jne    1052f8 <strchr+0x1e>
            return (char *)s;
  1052f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052f6:	eb 13                	jmp    10530b <strchr+0x31>
        }
        s ++;
  1052f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1052fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1052ff:	0f b6 00             	movzbl (%eax),%eax
  105302:	84 c0                	test   %al,%al
  105304:	75 e2                	jne    1052e8 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105306:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10530b:	c9                   	leave  
  10530c:	c3                   	ret    

0010530d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10530d:	55                   	push   %ebp
  10530e:	89 e5                	mov    %esp,%ebp
  105310:	83 ec 04             	sub    $0x4,%esp
  105313:	8b 45 0c             	mov    0xc(%ebp),%eax
  105316:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105319:	eb 0f                	jmp    10532a <strfind+0x1d>
        if (*s == c) {
  10531b:	8b 45 08             	mov    0x8(%ebp),%eax
  10531e:	0f b6 00             	movzbl (%eax),%eax
  105321:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105324:	74 10                	je     105336 <strfind+0x29>
            break;
        }
        s ++;
  105326:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10532a:	8b 45 08             	mov    0x8(%ebp),%eax
  10532d:	0f b6 00             	movzbl (%eax),%eax
  105330:	84 c0                	test   %al,%al
  105332:	75 e7                	jne    10531b <strfind+0xe>
  105334:	eb 01                	jmp    105337 <strfind+0x2a>
        if (*s == c) {
            break;
  105336:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105337:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10533a:	c9                   	leave  
  10533b:	c3                   	ret    

0010533c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10533c:	55                   	push   %ebp
  10533d:	89 e5                	mov    %esp,%ebp
  10533f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105349:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105350:	eb 04                	jmp    105356 <strtol+0x1a>
        s ++;
  105352:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105356:	8b 45 08             	mov    0x8(%ebp),%eax
  105359:	0f b6 00             	movzbl (%eax),%eax
  10535c:	3c 20                	cmp    $0x20,%al
  10535e:	74 f2                	je     105352 <strtol+0x16>
  105360:	8b 45 08             	mov    0x8(%ebp),%eax
  105363:	0f b6 00             	movzbl (%eax),%eax
  105366:	3c 09                	cmp    $0x9,%al
  105368:	74 e8                	je     105352 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  10536a:	8b 45 08             	mov    0x8(%ebp),%eax
  10536d:	0f b6 00             	movzbl (%eax),%eax
  105370:	3c 2b                	cmp    $0x2b,%al
  105372:	75 06                	jne    10537a <strtol+0x3e>
        s ++;
  105374:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105378:	eb 15                	jmp    10538f <strtol+0x53>
    }
    else if (*s == '-') {
  10537a:	8b 45 08             	mov    0x8(%ebp),%eax
  10537d:	0f b6 00             	movzbl (%eax),%eax
  105380:	3c 2d                	cmp    $0x2d,%al
  105382:	75 0b                	jne    10538f <strtol+0x53>
        s ++, neg = 1;
  105384:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105388:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10538f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105393:	74 06                	je     10539b <strtol+0x5f>
  105395:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105399:	75 24                	jne    1053bf <strtol+0x83>
  10539b:	8b 45 08             	mov    0x8(%ebp),%eax
  10539e:	0f b6 00             	movzbl (%eax),%eax
  1053a1:	3c 30                	cmp    $0x30,%al
  1053a3:	75 1a                	jne    1053bf <strtol+0x83>
  1053a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a8:	83 c0 01             	add    $0x1,%eax
  1053ab:	0f b6 00             	movzbl (%eax),%eax
  1053ae:	3c 78                	cmp    $0x78,%al
  1053b0:	75 0d                	jne    1053bf <strtol+0x83>
        s += 2, base = 16;
  1053b2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1053b6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1053bd:	eb 2a                	jmp    1053e9 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1053bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1053c3:	75 17                	jne    1053dc <strtol+0xa0>
  1053c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1053c8:	0f b6 00             	movzbl (%eax),%eax
  1053cb:	3c 30                	cmp    $0x30,%al
  1053cd:	75 0d                	jne    1053dc <strtol+0xa0>
        s ++, base = 8;
  1053cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1053d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1053da:	eb 0d                	jmp    1053e9 <strtol+0xad>
    }
    else if (base == 0) {
  1053dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1053e0:	75 07                	jne    1053e9 <strtol+0xad>
        base = 10;
  1053e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1053e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ec:	0f b6 00             	movzbl (%eax),%eax
  1053ef:	3c 2f                	cmp    $0x2f,%al
  1053f1:	7e 1b                	jle    10540e <strtol+0xd2>
  1053f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f6:	0f b6 00             	movzbl (%eax),%eax
  1053f9:	3c 39                	cmp    $0x39,%al
  1053fb:	7f 11                	jg     10540e <strtol+0xd2>
            dig = *s - '0';
  1053fd:	8b 45 08             	mov    0x8(%ebp),%eax
  105400:	0f b6 00             	movzbl (%eax),%eax
  105403:	0f be c0             	movsbl %al,%eax
  105406:	83 e8 30             	sub    $0x30,%eax
  105409:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10540c:	eb 48                	jmp    105456 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10540e:	8b 45 08             	mov    0x8(%ebp),%eax
  105411:	0f b6 00             	movzbl (%eax),%eax
  105414:	3c 60                	cmp    $0x60,%al
  105416:	7e 1b                	jle    105433 <strtol+0xf7>
  105418:	8b 45 08             	mov    0x8(%ebp),%eax
  10541b:	0f b6 00             	movzbl (%eax),%eax
  10541e:	3c 7a                	cmp    $0x7a,%al
  105420:	7f 11                	jg     105433 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105422:	8b 45 08             	mov    0x8(%ebp),%eax
  105425:	0f b6 00             	movzbl (%eax),%eax
  105428:	0f be c0             	movsbl %al,%eax
  10542b:	83 e8 57             	sub    $0x57,%eax
  10542e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105431:	eb 23                	jmp    105456 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105433:	8b 45 08             	mov    0x8(%ebp),%eax
  105436:	0f b6 00             	movzbl (%eax),%eax
  105439:	3c 40                	cmp    $0x40,%al
  10543b:	7e 3c                	jle    105479 <strtol+0x13d>
  10543d:	8b 45 08             	mov    0x8(%ebp),%eax
  105440:	0f b6 00             	movzbl (%eax),%eax
  105443:	3c 5a                	cmp    $0x5a,%al
  105445:	7f 32                	jg     105479 <strtol+0x13d>
            dig = *s - 'A' + 10;
  105447:	8b 45 08             	mov    0x8(%ebp),%eax
  10544a:	0f b6 00             	movzbl (%eax),%eax
  10544d:	0f be c0             	movsbl %al,%eax
  105450:	83 e8 37             	sub    $0x37,%eax
  105453:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105459:	3b 45 10             	cmp    0x10(%ebp),%eax
  10545c:	7d 1a                	jge    105478 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  10545e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105462:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105465:	0f af 45 10          	imul   0x10(%ebp),%eax
  105469:	89 c2                	mov    %eax,%edx
  10546b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10546e:	01 d0                	add    %edx,%eax
  105470:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105473:	e9 71 ff ff ff       	jmp    1053e9 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105478:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105479:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10547d:	74 08                	je     105487 <strtol+0x14b>
        *endptr = (char *) s;
  10547f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105482:	8b 55 08             	mov    0x8(%ebp),%edx
  105485:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105487:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10548b:	74 07                	je     105494 <strtol+0x158>
  10548d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105490:	f7 d8                	neg    %eax
  105492:	eb 03                	jmp    105497 <strtol+0x15b>
  105494:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105497:	c9                   	leave  
  105498:	c3                   	ret    

00105499 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105499:	55                   	push   %ebp
  10549a:	89 e5                	mov    %esp,%ebp
  10549c:	57                   	push   %edi
  10549d:	83 ec 24             	sub    $0x24,%esp
  1054a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054a3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1054a6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1054aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1054ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1054b0:	88 45 f7             	mov    %al,-0x9(%ebp)
  1054b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1054b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1054b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1054bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1054c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1054c3:	89 d7                	mov    %edx,%edi
  1054c5:	f3 aa                	rep stos %al,%es:(%edi)
  1054c7:	89 fa                	mov    %edi,%edx
  1054c9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1054cc:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1054cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1054d2:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1054d3:	83 c4 24             	add    $0x24,%esp
  1054d6:	5f                   	pop    %edi
  1054d7:	5d                   	pop    %ebp
  1054d8:	c3                   	ret    

001054d9 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1054d9:	55                   	push   %ebp
  1054da:	89 e5                	mov    %esp,%ebp
  1054dc:	57                   	push   %edi
  1054dd:	56                   	push   %esi
  1054de:	53                   	push   %ebx
  1054df:	83 ec 30             	sub    $0x30,%esp
  1054e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1054ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1054f1:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1054f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1054fa:	73 42                	jae    10553e <memmove+0x65>
  1054fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105505:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105508:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10550b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10550e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105511:	c1 e8 02             	shr    $0x2,%eax
  105514:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105516:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10551c:	89 d7                	mov    %edx,%edi
  10551e:	89 c6                	mov    %eax,%esi
  105520:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105522:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105525:	83 e1 03             	and    $0x3,%ecx
  105528:	74 02                	je     10552c <memmove+0x53>
  10552a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10552c:	89 f0                	mov    %esi,%eax
  10552e:	89 fa                	mov    %edi,%edx
  105530:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105533:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105536:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  10553c:	eb 36                	jmp    105574 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10553e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105541:	8d 50 ff             	lea    -0x1(%eax),%edx
  105544:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105547:	01 c2                	add    %eax,%edx
  105549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10554c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10554f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105552:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105558:	89 c1                	mov    %eax,%ecx
  10555a:	89 d8                	mov    %ebx,%eax
  10555c:	89 d6                	mov    %edx,%esi
  10555e:	89 c7                	mov    %eax,%edi
  105560:	fd                   	std    
  105561:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105563:	fc                   	cld    
  105564:	89 f8                	mov    %edi,%eax
  105566:	89 f2                	mov    %esi,%edx
  105568:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10556b:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10556e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105571:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105574:	83 c4 30             	add    $0x30,%esp
  105577:	5b                   	pop    %ebx
  105578:	5e                   	pop    %esi
  105579:	5f                   	pop    %edi
  10557a:	5d                   	pop    %ebp
  10557b:	c3                   	ret    

0010557c <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10557c:	55                   	push   %ebp
  10557d:	89 e5                	mov    %esp,%ebp
  10557f:	57                   	push   %edi
  105580:	56                   	push   %esi
  105581:	83 ec 20             	sub    $0x20,%esp
  105584:	8b 45 08             	mov    0x8(%ebp),%eax
  105587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10558a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10558d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105590:	8b 45 10             	mov    0x10(%ebp),%eax
  105593:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105599:	c1 e8 02             	shr    $0x2,%eax
  10559c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10559e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1055a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055a4:	89 d7                	mov    %edx,%edi
  1055a6:	89 c6                	mov    %eax,%esi
  1055a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1055aa:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1055ad:	83 e1 03             	and    $0x3,%ecx
  1055b0:	74 02                	je     1055b4 <memcpy+0x38>
  1055b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1055b4:	89 f0                	mov    %esi,%eax
  1055b6:	89 fa                	mov    %edi,%edx
  1055b8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1055bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1055be:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1055c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1055c4:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1055c5:	83 c4 20             	add    $0x20,%esp
  1055c8:	5e                   	pop    %esi
  1055c9:	5f                   	pop    %edi
  1055ca:	5d                   	pop    %ebp
  1055cb:	c3                   	ret    

001055cc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1055cc:	55                   	push   %ebp
  1055cd:	89 e5                	mov    %esp,%ebp
  1055cf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1055d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1055d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055db:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1055de:	eb 30                	jmp    105610 <memcmp+0x44>
        if (*s1 != *s2) {
  1055e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055e3:	0f b6 10             	movzbl (%eax),%edx
  1055e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055e9:	0f b6 00             	movzbl (%eax),%eax
  1055ec:	38 c2                	cmp    %al,%dl
  1055ee:	74 18                	je     105608 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1055f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055f3:	0f b6 00             	movzbl (%eax),%eax
  1055f6:	0f b6 d0             	movzbl %al,%edx
  1055f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055fc:	0f b6 00             	movzbl (%eax),%eax
  1055ff:	0f b6 c0             	movzbl %al,%eax
  105602:	29 c2                	sub    %eax,%edx
  105604:	89 d0                	mov    %edx,%eax
  105606:	eb 1a                	jmp    105622 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105608:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10560c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105610:	8b 45 10             	mov    0x10(%ebp),%eax
  105613:	8d 50 ff             	lea    -0x1(%eax),%edx
  105616:	89 55 10             	mov    %edx,0x10(%ebp)
  105619:	85 c0                	test   %eax,%eax
  10561b:	75 c3                	jne    1055e0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10561d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105622:	c9                   	leave  
  105623:	c3                   	ret    

00105624 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105624:	55                   	push   %ebp
  105625:	89 e5                	mov    %esp,%ebp
  105627:	83 ec 38             	sub    $0x38,%esp
  10562a:	8b 45 10             	mov    0x10(%ebp),%eax
  10562d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105630:	8b 45 14             	mov    0x14(%ebp),%eax
  105633:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105636:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105639:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10563c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10563f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105642:	8b 45 18             	mov    0x18(%ebp),%eax
  105645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10564b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10564e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105651:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105657:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10565a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10565e:	74 1c                	je     10567c <printnum+0x58>
  105660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105663:	ba 00 00 00 00       	mov    $0x0,%edx
  105668:	f7 75 e4             	divl   -0x1c(%ebp)
  10566b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10566e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105671:	ba 00 00 00 00       	mov    $0x0,%edx
  105676:	f7 75 e4             	divl   -0x1c(%ebp)
  105679:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10567c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10567f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105682:	f7 75 e4             	divl   -0x1c(%ebp)
  105685:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105688:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10568b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10568e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105691:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105694:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105697:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10569a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10569d:	8b 45 18             	mov    0x18(%ebp),%eax
  1056a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1056a5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1056a8:	77 41                	ja     1056eb <printnum+0xc7>
  1056aa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1056ad:	72 05                	jb     1056b4 <printnum+0x90>
  1056af:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1056b2:	77 37                	ja     1056eb <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1056b4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1056b7:	83 e8 01             	sub    $0x1,%eax
  1056ba:	83 ec 04             	sub    $0x4,%esp
  1056bd:	ff 75 20             	pushl  0x20(%ebp)
  1056c0:	50                   	push   %eax
  1056c1:	ff 75 18             	pushl  0x18(%ebp)
  1056c4:	ff 75 ec             	pushl  -0x14(%ebp)
  1056c7:	ff 75 e8             	pushl  -0x18(%ebp)
  1056ca:	ff 75 0c             	pushl  0xc(%ebp)
  1056cd:	ff 75 08             	pushl  0x8(%ebp)
  1056d0:	e8 4f ff ff ff       	call   105624 <printnum>
  1056d5:	83 c4 20             	add    $0x20,%esp
  1056d8:	eb 1b                	jmp    1056f5 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1056da:	83 ec 08             	sub    $0x8,%esp
  1056dd:	ff 75 0c             	pushl  0xc(%ebp)
  1056e0:	ff 75 20             	pushl  0x20(%ebp)
  1056e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e6:	ff d0                	call   *%eax
  1056e8:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1056eb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1056ef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1056f3:	7f e5                	jg     1056da <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1056f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056f8:	05 ec 6d 10 00       	add    $0x106dec,%eax
  1056fd:	0f b6 00             	movzbl (%eax),%eax
  105700:	0f be c0             	movsbl %al,%eax
  105703:	83 ec 08             	sub    $0x8,%esp
  105706:	ff 75 0c             	pushl  0xc(%ebp)
  105709:	50                   	push   %eax
  10570a:	8b 45 08             	mov    0x8(%ebp),%eax
  10570d:	ff d0                	call   *%eax
  10570f:	83 c4 10             	add    $0x10,%esp
}
  105712:	90                   	nop
  105713:	c9                   	leave  
  105714:	c3                   	ret    

00105715 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105715:	55                   	push   %ebp
  105716:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105718:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10571c:	7e 14                	jle    105732 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10571e:	8b 45 08             	mov    0x8(%ebp),%eax
  105721:	8b 00                	mov    (%eax),%eax
  105723:	8d 48 08             	lea    0x8(%eax),%ecx
  105726:	8b 55 08             	mov    0x8(%ebp),%edx
  105729:	89 0a                	mov    %ecx,(%edx)
  10572b:	8b 50 04             	mov    0x4(%eax),%edx
  10572e:	8b 00                	mov    (%eax),%eax
  105730:	eb 30                	jmp    105762 <getuint+0x4d>
    }
    else if (lflag) {
  105732:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105736:	74 16                	je     10574e <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105738:	8b 45 08             	mov    0x8(%ebp),%eax
  10573b:	8b 00                	mov    (%eax),%eax
  10573d:	8d 48 04             	lea    0x4(%eax),%ecx
  105740:	8b 55 08             	mov    0x8(%ebp),%edx
  105743:	89 0a                	mov    %ecx,(%edx)
  105745:	8b 00                	mov    (%eax),%eax
  105747:	ba 00 00 00 00       	mov    $0x0,%edx
  10574c:	eb 14                	jmp    105762 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10574e:	8b 45 08             	mov    0x8(%ebp),%eax
  105751:	8b 00                	mov    (%eax),%eax
  105753:	8d 48 04             	lea    0x4(%eax),%ecx
  105756:	8b 55 08             	mov    0x8(%ebp),%edx
  105759:	89 0a                	mov    %ecx,(%edx)
  10575b:	8b 00                	mov    (%eax),%eax
  10575d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105762:	5d                   	pop    %ebp
  105763:	c3                   	ret    

00105764 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105764:	55                   	push   %ebp
  105765:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10576b:	7e 14                	jle    105781 <getint+0x1d>
        return va_arg(*ap, long long);
  10576d:	8b 45 08             	mov    0x8(%ebp),%eax
  105770:	8b 00                	mov    (%eax),%eax
  105772:	8d 48 08             	lea    0x8(%eax),%ecx
  105775:	8b 55 08             	mov    0x8(%ebp),%edx
  105778:	89 0a                	mov    %ecx,(%edx)
  10577a:	8b 50 04             	mov    0x4(%eax),%edx
  10577d:	8b 00                	mov    (%eax),%eax
  10577f:	eb 28                	jmp    1057a9 <getint+0x45>
    }
    else if (lflag) {
  105781:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105785:	74 12                	je     105799 <getint+0x35>
        return va_arg(*ap, long);
  105787:	8b 45 08             	mov    0x8(%ebp),%eax
  10578a:	8b 00                	mov    (%eax),%eax
  10578c:	8d 48 04             	lea    0x4(%eax),%ecx
  10578f:	8b 55 08             	mov    0x8(%ebp),%edx
  105792:	89 0a                	mov    %ecx,(%edx)
  105794:	8b 00                	mov    (%eax),%eax
  105796:	99                   	cltd   
  105797:	eb 10                	jmp    1057a9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105799:	8b 45 08             	mov    0x8(%ebp),%eax
  10579c:	8b 00                	mov    (%eax),%eax
  10579e:	8d 48 04             	lea    0x4(%eax),%ecx
  1057a1:	8b 55 08             	mov    0x8(%ebp),%edx
  1057a4:	89 0a                	mov    %ecx,(%edx)
  1057a6:	8b 00                	mov    (%eax),%eax
  1057a8:	99                   	cltd   
    }
}
  1057a9:	5d                   	pop    %ebp
  1057aa:	c3                   	ret    

001057ab <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1057ab:	55                   	push   %ebp
  1057ac:	89 e5                	mov    %esp,%ebp
  1057ae:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1057b1:	8d 45 14             	lea    0x14(%ebp),%eax
  1057b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1057b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057ba:	50                   	push   %eax
  1057bb:	ff 75 10             	pushl  0x10(%ebp)
  1057be:	ff 75 0c             	pushl  0xc(%ebp)
  1057c1:	ff 75 08             	pushl  0x8(%ebp)
  1057c4:	e8 06 00 00 00       	call   1057cf <vprintfmt>
  1057c9:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1057cc:	90                   	nop
  1057cd:	c9                   	leave  
  1057ce:	c3                   	ret    

001057cf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1057cf:	55                   	push   %ebp
  1057d0:	89 e5                	mov    %esp,%ebp
  1057d2:	56                   	push   %esi
  1057d3:	53                   	push   %ebx
  1057d4:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057d7:	eb 17                	jmp    1057f0 <vprintfmt+0x21>
            if (ch == '\0') {
  1057d9:	85 db                	test   %ebx,%ebx
  1057db:	0f 84 8e 03 00 00    	je     105b6f <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1057e1:	83 ec 08             	sub    $0x8,%esp
  1057e4:	ff 75 0c             	pushl  0xc(%ebp)
  1057e7:	53                   	push   %ebx
  1057e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057eb:	ff d0                	call   *%eax
  1057ed:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1057f3:	8d 50 01             	lea    0x1(%eax),%edx
  1057f6:	89 55 10             	mov    %edx,0x10(%ebp)
  1057f9:	0f b6 00             	movzbl (%eax),%eax
  1057fc:	0f b6 d8             	movzbl %al,%ebx
  1057ff:	83 fb 25             	cmp    $0x25,%ebx
  105802:	75 d5                	jne    1057d9 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105804:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105808:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10580f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105812:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105815:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10581c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10581f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105822:	8b 45 10             	mov    0x10(%ebp),%eax
  105825:	8d 50 01             	lea    0x1(%eax),%edx
  105828:	89 55 10             	mov    %edx,0x10(%ebp)
  10582b:	0f b6 00             	movzbl (%eax),%eax
  10582e:	0f b6 d8             	movzbl %al,%ebx
  105831:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105834:	83 f8 55             	cmp    $0x55,%eax
  105837:	0f 87 05 03 00 00    	ja     105b42 <vprintfmt+0x373>
  10583d:	8b 04 85 10 6e 10 00 	mov    0x106e10(,%eax,4),%eax
  105844:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105846:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10584a:	eb d6                	jmp    105822 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10584c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105850:	eb d0                	jmp    105822 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105852:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105859:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10585c:	89 d0                	mov    %edx,%eax
  10585e:	c1 e0 02             	shl    $0x2,%eax
  105861:	01 d0                	add    %edx,%eax
  105863:	01 c0                	add    %eax,%eax
  105865:	01 d8                	add    %ebx,%eax
  105867:	83 e8 30             	sub    $0x30,%eax
  10586a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10586d:	8b 45 10             	mov    0x10(%ebp),%eax
  105870:	0f b6 00             	movzbl (%eax),%eax
  105873:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105876:	83 fb 2f             	cmp    $0x2f,%ebx
  105879:	7e 39                	jle    1058b4 <vprintfmt+0xe5>
  10587b:	83 fb 39             	cmp    $0x39,%ebx
  10587e:	7f 34                	jg     1058b4 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105880:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105884:	eb d3                	jmp    105859 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105886:	8b 45 14             	mov    0x14(%ebp),%eax
  105889:	8d 50 04             	lea    0x4(%eax),%edx
  10588c:	89 55 14             	mov    %edx,0x14(%ebp)
  10588f:	8b 00                	mov    (%eax),%eax
  105891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105894:	eb 1f                	jmp    1058b5 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  105896:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10589a:	79 86                	jns    105822 <vprintfmt+0x53>
                width = 0;
  10589c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1058a3:	e9 7a ff ff ff       	jmp    105822 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1058a8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1058af:	e9 6e ff ff ff       	jmp    105822 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  1058b4:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  1058b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058b9:	0f 89 63 ff ff ff    	jns    105822 <vprintfmt+0x53>
                width = precision, precision = -1;
  1058bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058c5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1058cc:	e9 51 ff ff ff       	jmp    105822 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1058d1:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1058d5:	e9 48 ff ff ff       	jmp    105822 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1058da:	8b 45 14             	mov    0x14(%ebp),%eax
  1058dd:	8d 50 04             	lea    0x4(%eax),%edx
  1058e0:	89 55 14             	mov    %edx,0x14(%ebp)
  1058e3:	8b 00                	mov    (%eax),%eax
  1058e5:	83 ec 08             	sub    $0x8,%esp
  1058e8:	ff 75 0c             	pushl  0xc(%ebp)
  1058eb:	50                   	push   %eax
  1058ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ef:	ff d0                	call   *%eax
  1058f1:	83 c4 10             	add    $0x10,%esp
            break;
  1058f4:	e9 71 02 00 00       	jmp    105b6a <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1058f9:	8b 45 14             	mov    0x14(%ebp),%eax
  1058fc:	8d 50 04             	lea    0x4(%eax),%edx
  1058ff:	89 55 14             	mov    %edx,0x14(%ebp)
  105902:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105904:	85 db                	test   %ebx,%ebx
  105906:	79 02                	jns    10590a <vprintfmt+0x13b>
                err = -err;
  105908:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10590a:	83 fb 06             	cmp    $0x6,%ebx
  10590d:	7f 0b                	jg     10591a <vprintfmt+0x14b>
  10590f:	8b 34 9d d0 6d 10 00 	mov    0x106dd0(,%ebx,4),%esi
  105916:	85 f6                	test   %esi,%esi
  105918:	75 19                	jne    105933 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  10591a:	53                   	push   %ebx
  10591b:	68 fd 6d 10 00       	push   $0x106dfd
  105920:	ff 75 0c             	pushl  0xc(%ebp)
  105923:	ff 75 08             	pushl  0x8(%ebp)
  105926:	e8 80 fe ff ff       	call   1057ab <printfmt>
  10592b:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10592e:	e9 37 02 00 00       	jmp    105b6a <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105933:	56                   	push   %esi
  105934:	68 06 6e 10 00       	push   $0x106e06
  105939:	ff 75 0c             	pushl  0xc(%ebp)
  10593c:	ff 75 08             	pushl  0x8(%ebp)
  10593f:	e8 67 fe ff ff       	call   1057ab <printfmt>
  105944:	83 c4 10             	add    $0x10,%esp
            }
            break;
  105947:	e9 1e 02 00 00       	jmp    105b6a <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10594c:	8b 45 14             	mov    0x14(%ebp),%eax
  10594f:	8d 50 04             	lea    0x4(%eax),%edx
  105952:	89 55 14             	mov    %edx,0x14(%ebp)
  105955:	8b 30                	mov    (%eax),%esi
  105957:	85 f6                	test   %esi,%esi
  105959:	75 05                	jne    105960 <vprintfmt+0x191>
                p = "(null)";
  10595b:	be 09 6e 10 00       	mov    $0x106e09,%esi
            }
            if (width > 0 && padc != '-') {
  105960:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105964:	7e 76                	jle    1059dc <vprintfmt+0x20d>
  105966:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10596a:	74 70                	je     1059dc <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10596c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10596f:	83 ec 08             	sub    $0x8,%esp
  105972:	50                   	push   %eax
  105973:	56                   	push   %esi
  105974:	e8 17 f8 ff ff       	call   105190 <strnlen>
  105979:	83 c4 10             	add    $0x10,%esp
  10597c:	89 c2                	mov    %eax,%edx
  10597e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105981:	29 d0                	sub    %edx,%eax
  105983:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105986:	eb 17                	jmp    10599f <vprintfmt+0x1d0>
                    putch(padc, putdat);
  105988:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10598c:	83 ec 08             	sub    $0x8,%esp
  10598f:	ff 75 0c             	pushl  0xc(%ebp)
  105992:	50                   	push   %eax
  105993:	8b 45 08             	mov    0x8(%ebp),%eax
  105996:	ff d0                	call   *%eax
  105998:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10599b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10599f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059a3:	7f e3                	jg     105988 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059a5:	eb 35                	jmp    1059dc <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1059a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1059ab:	74 1c                	je     1059c9 <vprintfmt+0x1fa>
  1059ad:	83 fb 1f             	cmp    $0x1f,%ebx
  1059b0:	7e 05                	jle    1059b7 <vprintfmt+0x1e8>
  1059b2:	83 fb 7e             	cmp    $0x7e,%ebx
  1059b5:	7e 12                	jle    1059c9 <vprintfmt+0x1fa>
                    putch('?', putdat);
  1059b7:	83 ec 08             	sub    $0x8,%esp
  1059ba:	ff 75 0c             	pushl  0xc(%ebp)
  1059bd:	6a 3f                	push   $0x3f
  1059bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c2:	ff d0                	call   *%eax
  1059c4:	83 c4 10             	add    $0x10,%esp
  1059c7:	eb 0f                	jmp    1059d8 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1059c9:	83 ec 08             	sub    $0x8,%esp
  1059cc:	ff 75 0c             	pushl  0xc(%ebp)
  1059cf:	53                   	push   %ebx
  1059d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d3:	ff d0                	call   *%eax
  1059d5:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059d8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1059dc:	89 f0                	mov    %esi,%eax
  1059de:	8d 70 01             	lea    0x1(%eax),%esi
  1059e1:	0f b6 00             	movzbl (%eax),%eax
  1059e4:	0f be d8             	movsbl %al,%ebx
  1059e7:	85 db                	test   %ebx,%ebx
  1059e9:	74 26                	je     105a11 <vprintfmt+0x242>
  1059eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059ef:	78 b6                	js     1059a7 <vprintfmt+0x1d8>
  1059f1:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1059f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059f9:	79 ac                	jns    1059a7 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059fb:	eb 14                	jmp    105a11 <vprintfmt+0x242>
                putch(' ', putdat);
  1059fd:	83 ec 08             	sub    $0x8,%esp
  105a00:	ff 75 0c             	pushl  0xc(%ebp)
  105a03:	6a 20                	push   $0x20
  105a05:	8b 45 08             	mov    0x8(%ebp),%eax
  105a08:	ff d0                	call   *%eax
  105a0a:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105a0d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a11:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a15:	7f e6                	jg     1059fd <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  105a17:	e9 4e 01 00 00       	jmp    105b6a <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105a1c:	83 ec 08             	sub    $0x8,%esp
  105a1f:	ff 75 e0             	pushl  -0x20(%ebp)
  105a22:	8d 45 14             	lea    0x14(%ebp),%eax
  105a25:	50                   	push   %eax
  105a26:	e8 39 fd ff ff       	call   105764 <getint>
  105a2b:	83 c4 10             	add    $0x10,%esp
  105a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a3a:	85 d2                	test   %edx,%edx
  105a3c:	79 23                	jns    105a61 <vprintfmt+0x292>
                putch('-', putdat);
  105a3e:	83 ec 08             	sub    $0x8,%esp
  105a41:	ff 75 0c             	pushl  0xc(%ebp)
  105a44:	6a 2d                	push   $0x2d
  105a46:	8b 45 08             	mov    0x8(%ebp),%eax
  105a49:	ff d0                	call   *%eax
  105a4b:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  105a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a54:	f7 d8                	neg    %eax
  105a56:	83 d2 00             	adc    $0x0,%edx
  105a59:	f7 da                	neg    %edx
  105a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a61:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a68:	e9 9f 00 00 00       	jmp    105b0c <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a6d:	83 ec 08             	sub    $0x8,%esp
  105a70:	ff 75 e0             	pushl  -0x20(%ebp)
  105a73:	8d 45 14             	lea    0x14(%ebp),%eax
  105a76:	50                   	push   %eax
  105a77:	e8 99 fc ff ff       	call   105715 <getuint>
  105a7c:	83 c4 10             	add    $0x10,%esp
  105a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a8c:	eb 7e                	jmp    105b0c <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105a8e:	83 ec 08             	sub    $0x8,%esp
  105a91:	ff 75 e0             	pushl  -0x20(%ebp)
  105a94:	8d 45 14             	lea    0x14(%ebp),%eax
  105a97:	50                   	push   %eax
  105a98:	e8 78 fc ff ff       	call   105715 <getuint>
  105a9d:	83 c4 10             	add    $0x10,%esp
  105aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105aa6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105aad:	eb 5d                	jmp    105b0c <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  105aaf:	83 ec 08             	sub    $0x8,%esp
  105ab2:	ff 75 0c             	pushl  0xc(%ebp)
  105ab5:	6a 30                	push   $0x30
  105ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aba:	ff d0                	call   *%eax
  105abc:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  105abf:	83 ec 08             	sub    $0x8,%esp
  105ac2:	ff 75 0c             	pushl  0xc(%ebp)
  105ac5:	6a 78                	push   $0x78
  105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aca:	ff d0                	call   *%eax
  105acc:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105acf:	8b 45 14             	mov    0x14(%ebp),%eax
  105ad2:	8d 50 04             	lea    0x4(%eax),%edx
  105ad5:	89 55 14             	mov    %edx,0x14(%ebp)
  105ad8:	8b 00                	mov    (%eax),%eax
  105ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105add:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ae4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105aeb:	eb 1f                	jmp    105b0c <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105aed:	83 ec 08             	sub    $0x8,%esp
  105af0:	ff 75 e0             	pushl  -0x20(%ebp)
  105af3:	8d 45 14             	lea    0x14(%ebp),%eax
  105af6:	50                   	push   %eax
  105af7:	e8 19 fc ff ff       	call   105715 <getuint>
  105afc:	83 c4 10             	add    $0x10,%esp
  105aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b02:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105b05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105b0c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b13:	83 ec 04             	sub    $0x4,%esp
  105b16:	52                   	push   %edx
  105b17:	ff 75 e8             	pushl  -0x18(%ebp)
  105b1a:	50                   	push   %eax
  105b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  105b1e:	ff 75 f0             	pushl  -0x10(%ebp)
  105b21:	ff 75 0c             	pushl  0xc(%ebp)
  105b24:	ff 75 08             	pushl  0x8(%ebp)
  105b27:	e8 f8 fa ff ff       	call   105624 <printnum>
  105b2c:	83 c4 20             	add    $0x20,%esp
            break;
  105b2f:	eb 39                	jmp    105b6a <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b31:	83 ec 08             	sub    $0x8,%esp
  105b34:	ff 75 0c             	pushl  0xc(%ebp)
  105b37:	53                   	push   %ebx
  105b38:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3b:	ff d0                	call   *%eax
  105b3d:	83 c4 10             	add    $0x10,%esp
            break;
  105b40:	eb 28                	jmp    105b6a <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b42:	83 ec 08             	sub    $0x8,%esp
  105b45:	ff 75 0c             	pushl  0xc(%ebp)
  105b48:	6a 25                	push   $0x25
  105b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4d:	ff d0                	call   *%eax
  105b4f:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b52:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b56:	eb 04                	jmp    105b5c <vprintfmt+0x38d>
  105b58:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  105b5f:	83 e8 01             	sub    $0x1,%eax
  105b62:	0f b6 00             	movzbl (%eax),%eax
  105b65:	3c 25                	cmp    $0x25,%al
  105b67:	75 ef                	jne    105b58 <vprintfmt+0x389>
                /* do nothing */;
            break;
  105b69:	90                   	nop
        }
    }
  105b6a:	e9 68 fc ff ff       	jmp    1057d7 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  105b6f:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  105b73:	5b                   	pop    %ebx
  105b74:	5e                   	pop    %esi
  105b75:	5d                   	pop    %ebp
  105b76:	c3                   	ret    

00105b77 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105b77:	55                   	push   %ebp
  105b78:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7d:	8b 40 08             	mov    0x8(%eax),%eax
  105b80:	8d 50 01             	lea    0x1(%eax),%edx
  105b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b86:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8c:	8b 10                	mov    (%eax),%edx
  105b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b91:	8b 40 04             	mov    0x4(%eax),%eax
  105b94:	39 c2                	cmp    %eax,%edx
  105b96:	73 12                	jae    105baa <sprintputch+0x33>
        *b->buf ++ = ch;
  105b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b9b:	8b 00                	mov    (%eax),%eax
  105b9d:	8d 48 01             	lea    0x1(%eax),%ecx
  105ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ba3:	89 0a                	mov    %ecx,(%edx)
  105ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  105ba8:	88 10                	mov    %dl,(%eax)
    }
}
  105baa:	90                   	nop
  105bab:	5d                   	pop    %ebp
  105bac:	c3                   	ret    

00105bad <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105bad:	55                   	push   %ebp
  105bae:	89 e5                	mov    %esp,%ebp
  105bb0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105bb3:	8d 45 14             	lea    0x14(%ebp),%eax
  105bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bbc:	50                   	push   %eax
  105bbd:	ff 75 10             	pushl  0x10(%ebp)
  105bc0:	ff 75 0c             	pushl  0xc(%ebp)
  105bc3:	ff 75 08             	pushl  0x8(%ebp)
  105bc6:	e8 0b 00 00 00       	call   105bd6 <vsnprintf>
  105bcb:	83 c4 10             	add    $0x10,%esp
  105bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bd4:	c9                   	leave  
  105bd5:	c3                   	ret    

00105bd6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105bd6:	55                   	push   %ebp
  105bd7:	89 e5                	mov    %esp,%ebp
  105bd9:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105be5:	8d 50 ff             	lea    -0x1(%eax),%edx
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
  105beb:	01 d0                	add    %edx,%eax
  105bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105bf7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105bfb:	74 0a                	je     105c07 <vsnprintf+0x31>
  105bfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c03:	39 c2                	cmp    %eax,%edx
  105c05:	76 07                	jbe    105c0e <vsnprintf+0x38>
        return -E_INVAL;
  105c07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105c0c:	eb 20                	jmp    105c2e <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105c0e:	ff 75 14             	pushl  0x14(%ebp)
  105c11:	ff 75 10             	pushl  0x10(%ebp)
  105c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c17:	50                   	push   %eax
  105c18:	68 77 5b 10 00       	push   $0x105b77
  105c1d:	e8 ad fb ff ff       	call   1057cf <vprintfmt>
  105c22:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  105c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c28:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c2e:	c9                   	leave  
  105c2f:	c3                   	ret    
