
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
  100049:	e8 2a 54 00 00       	call   105478 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 6a 15 00 00       	call   1015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 20 5c 10 00 	movl   $0x105c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 3c 5c 10 00       	push   $0x105c3c
  100068:	e8 02 02 00 00       	call   10026f <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 84 08 00 00       	call   1008f9 <print_kerninfo>

    grade_backtrace();
  100075:	e8 74 00 00 00       	call   1000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 b2 31 00 00       	call   103231 <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 ae 16 00 00       	call   101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 0f 18 00 00       	call   101898 <idt_init>

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
  100137:	68 41 5c 10 00       	push   $0x105c41
  10013c:	e8 2e 01 00 00       	call   10026f <cprintf>
  100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100148:	0f b7 d0             	movzwl %ax,%edx
  10014b:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100150:	83 ec 04             	sub    $0x4,%esp
  100153:	52                   	push   %edx
  100154:	50                   	push   %eax
  100155:	68 4f 5c 10 00       	push   $0x105c4f
  10015a:	e8 10 01 00 00       	call   10026f <cprintf>
  10015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100166:	0f b7 d0             	movzwl %ax,%edx
  100169:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016e:	83 ec 04             	sub    $0x4,%esp
  100171:	52                   	push   %edx
  100172:	50                   	push   %eax
  100173:	68 5d 5c 10 00       	push   $0x105c5d
  100178:	e8 f2 00 00 00       	call   10026f <cprintf>
  10017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	0f b7 d0             	movzwl %ax,%edx
  100187:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018c:	83 ec 04             	sub    $0x4,%esp
  10018f:	52                   	push   %edx
  100190:	50                   	push   %eax
  100191:	68 6b 5c 10 00       	push   $0x105c6b
  100196:	e8 d4 00 00 00       	call   10026f <cprintf>
  10019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001aa:	83 ec 04             	sub    $0x4,%esp
  1001ad:	52                   	push   %edx
  1001ae:	50                   	push   %eax
  1001af:	68 79 5c 10 00       	push   $0x105c79
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
  1001ee:	68 88 5c 10 00       	push   $0x105c88
  1001f3:	e8 77 00 00 00       	call   10026f <cprintf>
  1001f8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001fb:	e8 cc ff ff ff       	call   1001cc <lab1_switch_to_user>
    lab1_print_cur_status();
  100200:	e8 0a ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100205:	83 ec 0c             	sub    $0xc,%esp
  100208:	68 a8 5c 10 00       	push   $0x105ca8
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
  100262:	e8 47 55 00 00       	call   1057ae <vprintfmt>
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
  100325:	68 c7 5c 10 00       	push   $0x105cc7
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
  1003fd:	68 ca 5c 10 00       	push   $0x105cca
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
  10041f:	68 e6 5c 10 00       	push   $0x105ce6
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
  100458:	68 e8 5c 10 00       	push   $0x105ce8
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
  10047a:	68 e6 5c 10 00       	push   $0x105ce6
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
  1005f4:	c7 00 08 5d 10 00    	movl   $0x105d08,(%eax)
    info->eip_line = 0;
  1005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100604:	8b 45 0c             	mov    0xc(%ebp),%eax
  100607:	c7 40 08 08 5d 10 00 	movl   $0x105d08,0x8(%eax)
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
  10062b:	c7 45 f4 28 6f 10 00 	movl   $0x106f28,-0xc(%ebp)
    stab_end = __STAB_END__;
  100632:	c7 45 f0 1c 20 11 00 	movl   $0x11201c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100639:	c7 45 ec 1d 20 11 00 	movl   $0x11201d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100640:	c7 45 e8 4f 4b 11 00 	movl   $0x114b4f,-0x18(%ebp)

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
  10077a:	e8 6d 4b 00 00       	call   1052ec <strfind>
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
  100902:	68 12 5d 10 00       	push   $0x105d12
  100907:	e8 63 f9 ff ff       	call   10026f <cprintf>
  10090c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10090f:	83 ec 08             	sub    $0x8,%esp
  100912:	68 2a 00 10 00       	push   $0x10002a
  100917:	68 2b 5d 10 00       	push   $0x105d2b
  10091c:	e8 4e f9 ff ff       	call   10026f <cprintf>
  100921:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100924:	83 ec 08             	sub    $0x8,%esp
  100927:	68 0f 5c 10 00       	push   $0x105c0f
  10092c:	68 43 5d 10 00       	push   $0x105d43
  100931:	e8 39 f9 ff ff       	call   10026f <cprintf>
  100936:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100939:	83 ec 08             	sub    $0x8,%esp
  10093c:	68 36 7a 11 00       	push   $0x117a36
  100941:	68 5b 5d 10 00       	push   $0x105d5b
  100946:	e8 24 f9 ff ff       	call   10026f <cprintf>
  10094b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10094e:	83 ec 08             	sub    $0x8,%esp
  100951:	68 c8 89 11 00       	push   $0x1189c8
  100956:	68 73 5d 10 00       	push   $0x105d73
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
  100986:	68 8c 5d 10 00       	push   $0x105d8c
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
  1009bb:	68 b6 5d 10 00       	push   $0x105db6
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
  100a22:	68 d2 5d 10 00       	push   $0x105dd2
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
  100a72:	68 e4 5d 10 00       	push   $0x105de4
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
  100ac0:	68 fc 5d 10 00       	push   $0x105dfc
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
  100b41:	68 a0 5e 10 00       	push   $0x105ea0
  100b46:	e8 6e 47 00 00       	call   1052b9 <strchr>
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
  100b67:	68 a5 5e 10 00       	push   $0x105ea5
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
  100baf:	68 a0 5e 10 00       	push   $0x105ea0
  100bb4:	e8 00 47 00 00       	call   1052b9 <strchr>
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
  100c1a:	e8 fa 45 00 00       	call   105219 <strcmp>
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
  100c67:	68 c3 5e 10 00       	push   $0x105ec3
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
  100c84:	68 dc 5e 10 00       	push   $0x105edc
  100c89:	e8 e1 f5 ff ff       	call   10026f <cprintf>
  100c8e:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c91:	83 ec 0c             	sub    $0xc,%esp
  100c94:	68 04 5f 10 00       	push   $0x105f04
  100c99:	e8 d1 f5 ff ff       	call   10026f <cprintf>
  100c9e:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ca5:	74 0e                	je     100cb5 <kmonitor+0x3a>
        print_trapframe(tf);
  100ca7:	83 ec 0c             	sub    $0xc,%esp
  100caa:	ff 75 08             	pushl  0x8(%ebp)
  100cad:	e8 9e 0d 00 00       	call   101a50 <print_trapframe>
  100cb2:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cb5:	83 ec 0c             	sub    $0xc,%esp
  100cb8:	68 29 5f 10 00       	push   $0x105f29
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
  100d23:	68 2d 5f 10 00       	push   $0x105f2d
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
  100db3:	68 36 5f 10 00       	push   $0x105f36
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
  1011dc:	e8 d7 42 00 00       	call   1054b8 <memmove>
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
  101567:	68 51 5f 10 00       	push   $0x105f51
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
  1015e1:	68 5d 5f 10 00       	push   $0x105f5d
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
  101888:	68 80 5f 10 00       	push   $0x105f80
  10188d:	e8 dd e9 ff ff       	call   10026f <cprintf>
  101892:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101895:	90                   	nop
  101896:	c9                   	leave  
  101897:	c3                   	ret    

00101898 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101898:	55                   	push   %ebp
  101899:	89 e5                	mov    %esp,%ebp
  10189b:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  10189e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018a5:	e9 c3 00 00 00       	jmp    10196d <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018b4:	89 c2                	mov    %eax,%edx
  1018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b9:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018c0:	00 
  1018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c4:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018cb:	00 08 00 
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018d8:	00 
  1018d9:	83 e2 e0             	and    $0xffffffe0,%edx
  1018dc:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e6:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018ed:	00 
  1018ee:	83 e2 1f             	and    $0x1f,%edx
  1018f1:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101902:	00 
  101903:	83 e2 f0             	and    $0xfffffff0,%edx
  101906:	83 ca 0e             	or     $0xe,%edx
  101909:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10191a:	00 
  10191b:	83 e2 ef             	and    $0xffffffef,%edx
  10191e:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101925:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101928:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10192f:	00 
  101930:	83 e2 9f             	and    $0xffffff9f,%edx
  101933:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193d:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101944:	00 
  101945:	83 ca 80             	or     $0xffffff80,%edx
  101948:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101952:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101959:	c1 e8 10             	shr    $0x10,%eax
  10195c:	89 c2                	mov    %eax,%edx
  10195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101961:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101968:	00 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  101969:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10196d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101974:	0f 8e 30 ff ff ff    	jle    1018aa <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

	// set RPL of switch_to_kernel as user 
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10197a:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  10197f:	66 a3 88 84 11 00    	mov    %ax,0x118488
  101985:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  10198c:	08 00 
  10198e:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101995:	83 e0 e0             	and    $0xffffffe0,%eax
  101998:	a2 8c 84 11 00       	mov    %al,0x11848c
  10199d:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019a4:	83 e0 1f             	and    $0x1f,%eax
  1019a7:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019ac:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019b3:	83 e0 f0             	and    $0xfffffff0,%eax
  1019b6:	83 c8 0e             	or     $0xe,%eax
  1019b9:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019be:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c5:	83 e0 ef             	and    $0xffffffef,%eax
  1019c8:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019cd:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d4:	83 c8 60             	or     $0x60,%eax
  1019d7:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019dc:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019e3:	83 c8 80             	or     $0xffffff80,%eax
  1019e6:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019eb:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019f0:	c1 e8 10             	shr    $0x10,%eax
  1019f3:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019f9:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a03:	0f 01 18             	lidtl  (%eax)

    // 3. LIDT
    lidt(&idt_pd);
}
  101a06:	90                   	nop
  101a07:	c9                   	leave  
  101a08:	c3                   	ret    

00101a09 <trapname>:

static const char *
trapname(int trapno) {
  101a09:	55                   	push   %ebp
  101a0a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0f:	83 f8 13             	cmp    $0x13,%eax
  101a12:	77 0c                	ja     101a20 <trapname+0x17>
        return excnames[trapno];
  101a14:	8b 45 08             	mov    0x8(%ebp),%eax
  101a17:	8b 04 85 e0 62 10 00 	mov    0x1062e0(,%eax,4),%eax
  101a1e:	eb 18                	jmp    101a38 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a20:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a24:	7e 0d                	jle    101a33 <trapname+0x2a>
  101a26:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a2a:	7f 07                	jg     101a33 <trapname+0x2a>
        return "Hardware Interrupt";
  101a2c:	b8 8a 5f 10 00       	mov    $0x105f8a,%eax
  101a31:	eb 05                	jmp    101a38 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a33:	b8 9d 5f 10 00       	mov    $0x105f9d,%eax
}
  101a38:	5d                   	pop    %ebp
  101a39:	c3                   	ret    

00101a3a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a3a:	55                   	push   %ebp
  101a3b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a44:	66 83 f8 08          	cmp    $0x8,%ax
  101a48:	0f 94 c0             	sete   %al
  101a4b:	0f b6 c0             	movzbl %al,%eax
}
  101a4e:	5d                   	pop    %ebp
  101a4f:	c3                   	ret    

00101a50 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a50:	55                   	push   %ebp
  101a51:	89 e5                	mov    %esp,%ebp
  101a53:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a56:	83 ec 08             	sub    $0x8,%esp
  101a59:	ff 75 08             	pushl  0x8(%ebp)
  101a5c:	68 de 5f 10 00       	push   $0x105fde
  101a61:	e8 09 e8 ff ff       	call   10026f <cprintf>
  101a66:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a69:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6c:	83 ec 0c             	sub    $0xc,%esp
  101a6f:	50                   	push   %eax
  101a70:	e8 b8 01 00 00       	call   101c2d <print_regs>
  101a75:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a78:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a7f:	0f b7 c0             	movzwl %ax,%eax
  101a82:	83 ec 08             	sub    $0x8,%esp
  101a85:	50                   	push   %eax
  101a86:	68 ef 5f 10 00       	push   $0x105fef
  101a8b:	e8 df e7 ff ff       	call   10026f <cprintf>
  101a90:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a93:	8b 45 08             	mov    0x8(%ebp),%eax
  101a96:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a9a:	0f b7 c0             	movzwl %ax,%eax
  101a9d:	83 ec 08             	sub    $0x8,%esp
  101aa0:	50                   	push   %eax
  101aa1:	68 02 60 10 00       	push   $0x106002
  101aa6:	e8 c4 e7 ff ff       	call   10026f <cprintf>
  101aab:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aae:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ab5:	0f b7 c0             	movzwl %ax,%eax
  101ab8:	83 ec 08             	sub    $0x8,%esp
  101abb:	50                   	push   %eax
  101abc:	68 15 60 10 00       	push   $0x106015
  101ac1:	e8 a9 e7 ff ff       	call   10026f <cprintf>
  101ac6:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  101acc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ad0:	0f b7 c0             	movzwl %ax,%eax
  101ad3:	83 ec 08             	sub    $0x8,%esp
  101ad6:	50                   	push   %eax
  101ad7:	68 28 60 10 00       	push   $0x106028
  101adc:	e8 8e e7 ff ff       	call   10026f <cprintf>
  101ae1:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae7:	8b 40 30             	mov    0x30(%eax),%eax
  101aea:	83 ec 0c             	sub    $0xc,%esp
  101aed:	50                   	push   %eax
  101aee:	e8 16 ff ff ff       	call   101a09 <trapname>
  101af3:	83 c4 10             	add    $0x10,%esp
  101af6:	89 c2                	mov    %eax,%edx
  101af8:	8b 45 08             	mov    0x8(%ebp),%eax
  101afb:	8b 40 30             	mov    0x30(%eax),%eax
  101afe:	83 ec 04             	sub    $0x4,%esp
  101b01:	52                   	push   %edx
  101b02:	50                   	push   %eax
  101b03:	68 3b 60 10 00       	push   $0x10603b
  101b08:	e8 62 e7 ff ff       	call   10026f <cprintf>
  101b0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b10:	8b 45 08             	mov    0x8(%ebp),%eax
  101b13:	8b 40 34             	mov    0x34(%eax),%eax
  101b16:	83 ec 08             	sub    $0x8,%esp
  101b19:	50                   	push   %eax
  101b1a:	68 4d 60 10 00       	push   $0x10604d
  101b1f:	e8 4b e7 ff ff       	call   10026f <cprintf>
  101b24:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b27:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2a:	8b 40 38             	mov    0x38(%eax),%eax
  101b2d:	83 ec 08             	sub    $0x8,%esp
  101b30:	50                   	push   %eax
  101b31:	68 5c 60 10 00       	push   $0x10605c
  101b36:	e8 34 e7 ff ff       	call   10026f <cprintf>
  101b3b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b45:	0f b7 c0             	movzwl %ax,%eax
  101b48:	83 ec 08             	sub    $0x8,%esp
  101b4b:	50                   	push   %eax
  101b4c:	68 6b 60 10 00       	push   $0x10606b
  101b51:	e8 19 e7 ff ff       	call   10026f <cprintf>
  101b56:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	8b 40 40             	mov    0x40(%eax),%eax
  101b5f:	83 ec 08             	sub    $0x8,%esp
  101b62:	50                   	push   %eax
  101b63:	68 7e 60 10 00       	push   $0x10607e
  101b68:	e8 02 e7 ff ff       	call   10026f <cprintf>
  101b6d:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b7e:	eb 3f                	jmp    101bbf <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b80:	8b 45 08             	mov    0x8(%ebp),%eax
  101b83:	8b 50 40             	mov    0x40(%eax),%edx
  101b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b89:	21 d0                	and    %edx,%eax
  101b8b:	85 c0                	test   %eax,%eax
  101b8d:	74 29                	je     101bb8 <print_trapframe+0x168>
  101b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b92:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b99:	85 c0                	test   %eax,%eax
  101b9b:	74 1b                	je     101bb8 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba0:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101ba7:	83 ec 08             	sub    $0x8,%esp
  101baa:	50                   	push   %eax
  101bab:	68 8d 60 10 00       	push   $0x10608d
  101bb0:	e8 ba e6 ff ff       	call   10026f <cprintf>
  101bb5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bb8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bbc:	d1 65 f0             	shll   -0x10(%ebp)
  101bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc2:	83 f8 17             	cmp    $0x17,%eax
  101bc5:	76 b9                	jbe    101b80 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bca:	8b 40 40             	mov    0x40(%eax),%eax
  101bcd:	25 00 30 00 00       	and    $0x3000,%eax
  101bd2:	c1 e8 0c             	shr    $0xc,%eax
  101bd5:	83 ec 08             	sub    $0x8,%esp
  101bd8:	50                   	push   %eax
  101bd9:	68 91 60 10 00       	push   $0x106091
  101bde:	e8 8c e6 ff ff       	call   10026f <cprintf>
  101be3:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101be6:	83 ec 0c             	sub    $0xc,%esp
  101be9:	ff 75 08             	pushl  0x8(%ebp)
  101bec:	e8 49 fe ff ff       	call   101a3a <trap_in_kernel>
  101bf1:	83 c4 10             	add    $0x10,%esp
  101bf4:	85 c0                	test   %eax,%eax
  101bf6:	75 32                	jne    101c2a <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	8b 40 44             	mov    0x44(%eax),%eax
  101bfe:	83 ec 08             	sub    $0x8,%esp
  101c01:	50                   	push   %eax
  101c02:	68 9a 60 10 00       	push   $0x10609a
  101c07:	e8 63 e6 ff ff       	call   10026f <cprintf>
  101c0c:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c12:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c16:	0f b7 c0             	movzwl %ax,%eax
  101c19:	83 ec 08             	sub    $0x8,%esp
  101c1c:	50                   	push   %eax
  101c1d:	68 a9 60 10 00       	push   $0x1060a9
  101c22:	e8 48 e6 ff ff       	call   10026f <cprintf>
  101c27:	83 c4 10             	add    $0x10,%esp
    }
}
  101c2a:	90                   	nop
  101c2b:	c9                   	leave  
  101c2c:	c3                   	ret    

00101c2d <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c2d:	55                   	push   %ebp
  101c2e:	89 e5                	mov    %esp,%ebp
  101c30:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c33:	8b 45 08             	mov    0x8(%ebp),%eax
  101c36:	8b 00                	mov    (%eax),%eax
  101c38:	83 ec 08             	sub    $0x8,%esp
  101c3b:	50                   	push   %eax
  101c3c:	68 bc 60 10 00       	push   $0x1060bc
  101c41:	e8 29 e6 ff ff       	call   10026f <cprintf>
  101c46:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c49:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4c:	8b 40 04             	mov    0x4(%eax),%eax
  101c4f:	83 ec 08             	sub    $0x8,%esp
  101c52:	50                   	push   %eax
  101c53:	68 cb 60 10 00       	push   $0x1060cb
  101c58:	e8 12 e6 ff ff       	call   10026f <cprintf>
  101c5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	8b 40 08             	mov    0x8(%eax),%eax
  101c66:	83 ec 08             	sub    $0x8,%esp
  101c69:	50                   	push   %eax
  101c6a:	68 da 60 10 00       	push   $0x1060da
  101c6f:	e8 fb e5 ff ff       	call   10026f <cprintf>
  101c74:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  101c7d:	83 ec 08             	sub    $0x8,%esp
  101c80:	50                   	push   %eax
  101c81:	68 e9 60 10 00       	push   $0x1060e9
  101c86:	e8 e4 e5 ff ff       	call   10026f <cprintf>
  101c8b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c91:	8b 40 10             	mov    0x10(%eax),%eax
  101c94:	83 ec 08             	sub    $0x8,%esp
  101c97:	50                   	push   %eax
  101c98:	68 f8 60 10 00       	push   $0x1060f8
  101c9d:	e8 cd e5 ff ff       	call   10026f <cprintf>
  101ca2:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca8:	8b 40 14             	mov    0x14(%eax),%eax
  101cab:	83 ec 08             	sub    $0x8,%esp
  101cae:	50                   	push   %eax
  101caf:	68 07 61 10 00       	push   $0x106107
  101cb4:	e8 b6 e5 ff ff       	call   10026f <cprintf>
  101cb9:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbf:	8b 40 18             	mov    0x18(%eax),%eax
  101cc2:	83 ec 08             	sub    $0x8,%esp
  101cc5:	50                   	push   %eax
  101cc6:	68 16 61 10 00       	push   $0x106116
  101ccb:	e8 9f e5 ff ff       	call   10026f <cprintf>
  101cd0:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd6:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cd9:	83 ec 08             	sub    $0x8,%esp
  101cdc:	50                   	push   %eax
  101cdd:	68 25 61 10 00       	push   $0x106125
  101ce2:	e8 88 e5 ff ff       	call   10026f <cprintf>
  101ce7:	83 c4 10             	add    $0x10,%esp
}
  101cea:	90                   	nop
  101ceb:	c9                   	leave  
  101cec:	c3                   	ret    

00101ced <trap_dispatch>:
/* LAB1: temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ced:	55                   	push   %ebp
  101cee:	89 e5                	mov    %esp,%ebp
  101cf0:	57                   	push   %edi
  101cf1:	56                   	push   %esi
  101cf2:	53                   	push   %ebx
  101cf3:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf9:	8b 40 30             	mov    0x30(%eax),%eax
  101cfc:	83 f8 2f             	cmp    $0x2f,%eax
  101cff:	77 21                	ja     101d22 <trap_dispatch+0x35>
  101d01:	83 f8 2e             	cmp    $0x2e,%eax
  101d04:	0f 83 90 01 00 00    	jae    101e9a <trap_dispatch+0x1ad>
  101d0a:	83 f8 21             	cmp    $0x21,%eax
  101d0d:	0f 84 87 00 00 00    	je     101d9a <trap_dispatch+0xad>
  101d13:	83 f8 24             	cmp    $0x24,%eax
  101d16:	74 5b                	je     101d73 <trap_dispatch+0x86>
  101d18:	83 f8 20             	cmp    $0x20,%eax
  101d1b:	74 1c                	je     101d39 <trap_dispatch+0x4c>
  101d1d:	e9 42 01 00 00       	jmp    101e64 <trap_dispatch+0x177>
  101d22:	83 f8 78             	cmp    $0x78,%eax
  101d25:	0f 84 96 00 00 00    	je     101dc1 <trap_dispatch+0xd4>
  101d2b:	83 f8 79             	cmp    $0x79,%eax
  101d2e:	0f 84 02 01 00 00    	je     101e36 <trap_dispatch+0x149>
  101d34:	e9 2b 01 00 00       	jmp    101e64 <trap_dispatch+0x177>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
  101d39:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d3e:	83 c0 01             	add    $0x1,%eax
  101d41:	a3 4c 89 11 00       	mov    %eax,0x11894c

        // 2. print
        if (ticks % TICK_NUM == 0) {
  101d46:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d4c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d51:	89 c8                	mov    %ecx,%eax
  101d53:	f7 e2                	mul    %edx
  101d55:	89 d0                	mov    %edx,%eax
  101d57:	c1 e8 05             	shr    $0x5,%eax
  101d5a:	6b c0 64             	imul   $0x64,%eax,%eax
  101d5d:	29 c1                	sub    %eax,%ecx
  101d5f:	89 c8                	mov    %ecx,%eax
  101d61:	85 c0                	test   %eax,%eax
  101d63:	0f 85 34 01 00 00    	jne    101e9d <trap_dispatch+0x1b0>
            print_ticks();
  101d69:	e8 0f fb ff ff       	call   10187d <print_ticks>
        }

        // 3. too simple ?!
        break;
  101d6e:	e9 2a 01 00 00       	jmp    101e9d <trap_dispatch+0x1b0>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d73:	e8 c2 f8 ff ff       	call   10163a <cons_getc>
  101d78:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d7b:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d7f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d83:	83 ec 04             	sub    $0x4,%esp
  101d86:	52                   	push   %edx
  101d87:	50                   	push   %eax
  101d88:	68 34 61 10 00       	push   $0x106134
  101d8d:	e8 dd e4 ff ff       	call   10026f <cprintf>
  101d92:	83 c4 10             	add    $0x10,%esp
        break;
  101d95:	e9 04 01 00 00       	jmp    101e9e <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d9a:	e8 9b f8 ff ff       	call   10163a <cons_getc>
  101d9f:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101da2:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101da6:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101daa:	83 ec 04             	sub    $0x4,%esp
  101dad:	52                   	push   %edx
  101dae:	50                   	push   %eax
  101daf:	68 46 61 10 00       	push   $0x106146
  101db4:	e8 b6 e4 ff ff       	call   10026f <cprintf>
  101db9:	83 c4 10             	add    $0x10,%esp
        break;
  101dbc:	e9 dd 00 00 00       	jmp    101e9e <trap_dispatch+0x1b1>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
  101dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  101dc4:	b8 60 89 11 00       	mov    $0x118960,%eax
  101dc9:	89 d3                	mov    %edx,%ebx
  101dcb:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101dd0:	8b 0b                	mov    (%ebx),%ecx
  101dd2:	89 08                	mov    %ecx,(%eax)
  101dd4:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101dd8:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101ddc:	8d 78 04             	lea    0x4(%eax),%edi
  101ddf:	83 e7 fc             	and    $0xfffffffc,%edi
  101de2:	29 f8                	sub    %edi,%eax
  101de4:	29 c3                	sub    %eax,%ebx
  101de6:	01 c2                	add    %eax,%edx
  101de8:	83 e2 fc             	and    $0xfffffffc,%edx
  101deb:	89 d0                	mov    %edx,%eax
  101ded:	c1 e8 02             	shr    $0x2,%eax
  101df0:	89 de                	mov    %ebx,%esi
  101df2:	89 c1                	mov    %eax,%ecx
  101df4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
  101df6:	66 c7 05 9c 89 11 00 	movw   $0x1b,0x11899c
  101dfd:	1b 00 
        switchk2u.tf_ds = USER_DS;
  101dff:	66 c7 05 8c 89 11 00 	movw   $0x23,0x11898c
  101e06:	23 00 
        switchk2u.tf_es = USER_DS;
  101e08:	66 c7 05 88 89 11 00 	movw   $0x23,0x118988
  101e0f:	23 00 
        switchk2u.tf_ss = USER_DS;
  101e11:	66 c7 05 a8 89 11 00 	movw   $0x23,0x1189a8
  101e18:	23 00 

        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e1a:	a1 a0 89 11 00       	mov    0x1189a0,%eax
  101e1f:	80 cc 30             	or     $0x30,%ah
  101e22:	a3 a0 89 11 00       	mov    %eax,0x1189a0
        // set trap frame pointer
        // tf is the pointer to the pointer of trap frame (a structure)
        // tf = esp, while esp -> esp - 1 (*trap_frame) due to `pushl %esp`
        // so *(tf - 1) is the pointer to trap frame
        // change *trap_frame to point to the new frame
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e27:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2a:	83 e8 04             	sub    $0x4,%eax
  101e2d:	ba 60 89 11 00       	mov    $0x118960,%edx
  101e32:	89 10                	mov    %edx,(%eax)
        break;
  101e34:	eb 68                	jmp    101e9e <trap_dispatch+0x1b1>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
  101e36:	8b 45 08             	mov    0x8(%ebp),%eax
  101e39:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
  101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e42:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
  101e48:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4b:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)

        // restore eflags
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101e51:	8b 45 08             	mov    0x8(%ebp),%eax
  101e54:	8b 40 40             	mov    0x40(%eax),%eax
  101e57:	80 e4 cf             	and    $0xcf,%ah
  101e5a:	89 c2                	mov    %eax,%edx
  101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5f:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101e62:	eb 3a                	jmp    101e9e <trap_dispatch+0x1b1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e64:	8b 45 08             	mov    0x8(%ebp),%eax
  101e67:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e6b:	0f b7 c0             	movzwl %ax,%eax
  101e6e:	83 e0 03             	and    $0x3,%eax
  101e71:	85 c0                	test   %eax,%eax
  101e73:	75 29                	jne    101e9e <trap_dispatch+0x1b1>
            print_trapframe(tf);
  101e75:	83 ec 0c             	sub    $0xc,%esp
  101e78:	ff 75 08             	pushl  0x8(%ebp)
  101e7b:	e8 d0 fb ff ff       	call   101a50 <print_trapframe>
  101e80:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e83:	83 ec 04             	sub    $0x4,%esp
  101e86:	68 55 61 10 00       	push   $0x106155
  101e8b:	68 dc 00 00 00       	push   $0xdc
  101e90:	68 71 61 10 00       	push   $0x106171
  101e95:	e8 3b e5 ff ff       	call   1003d5 <__panic>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e9a:	90                   	nop
  101e9b:	eb 01                	jmp    101e9e <trap_dispatch+0x1b1>
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }

        // 3. too simple ?!
        break;
  101e9d:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e9e:	90                   	nop
  101e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101ea2:	5b                   	pop    %ebx
  101ea3:	5e                   	pop    %esi
  101ea4:	5f                   	pop    %edi
  101ea5:	5d                   	pop    %ebp
  101ea6:	c3                   	ret    

00101ea7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ea7:	55                   	push   %ebp
  101ea8:	89 e5                	mov    %esp,%ebp
  101eaa:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ead:	83 ec 0c             	sub    $0xc,%esp
  101eb0:	ff 75 08             	pushl  0x8(%ebp)
  101eb3:	e8 35 fe ff ff       	call   101ced <trap_dispatch>
  101eb8:	83 c4 10             	add    $0x10,%esp
}
  101ebb:	90                   	nop
  101ebc:	c9                   	leave  
  101ebd:	c3                   	ret    

00101ebe <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ebe:	6a 00                	push   $0x0
  pushl $0
  101ec0:	6a 00                	push   $0x0
  jmp __alltraps
  101ec2:	e9 69 0a 00 00       	jmp    102930 <__alltraps>

00101ec7 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ec7:	6a 00                	push   $0x0
  pushl $1
  101ec9:	6a 01                	push   $0x1
  jmp __alltraps
  101ecb:	e9 60 0a 00 00       	jmp    102930 <__alltraps>

00101ed0 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ed0:	6a 00                	push   $0x0
  pushl $2
  101ed2:	6a 02                	push   $0x2
  jmp __alltraps
  101ed4:	e9 57 0a 00 00       	jmp    102930 <__alltraps>

00101ed9 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ed9:	6a 00                	push   $0x0
  pushl $3
  101edb:	6a 03                	push   $0x3
  jmp __alltraps
  101edd:	e9 4e 0a 00 00       	jmp    102930 <__alltraps>

00101ee2 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $4
  101ee4:	6a 04                	push   $0x4
  jmp __alltraps
  101ee6:	e9 45 0a 00 00       	jmp    102930 <__alltraps>

00101eeb <vector5>:
.globl vector5
vector5:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $5
  101eed:	6a 05                	push   $0x5
  jmp __alltraps
  101eef:	e9 3c 0a 00 00       	jmp    102930 <__alltraps>

00101ef4 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $6
  101ef6:	6a 06                	push   $0x6
  jmp __alltraps
  101ef8:	e9 33 0a 00 00       	jmp    102930 <__alltraps>

00101efd <vector7>:
.globl vector7
vector7:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $7
  101eff:	6a 07                	push   $0x7
  jmp __alltraps
  101f01:	e9 2a 0a 00 00       	jmp    102930 <__alltraps>

00101f06 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f06:	6a 08                	push   $0x8
  jmp __alltraps
  101f08:	e9 23 0a 00 00       	jmp    102930 <__alltraps>

00101f0d <vector9>:
.globl vector9
vector9:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $9
  101f0f:	6a 09                	push   $0x9
  jmp __alltraps
  101f11:	e9 1a 0a 00 00       	jmp    102930 <__alltraps>

00101f16 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f16:	6a 0a                	push   $0xa
  jmp __alltraps
  101f18:	e9 13 0a 00 00       	jmp    102930 <__alltraps>

00101f1d <vector11>:
.globl vector11
vector11:
  pushl $11
  101f1d:	6a 0b                	push   $0xb
  jmp __alltraps
  101f1f:	e9 0c 0a 00 00       	jmp    102930 <__alltraps>

00101f24 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f24:	6a 0c                	push   $0xc
  jmp __alltraps
  101f26:	e9 05 0a 00 00       	jmp    102930 <__alltraps>

00101f2b <vector13>:
.globl vector13
vector13:
  pushl $13
  101f2b:	6a 0d                	push   $0xd
  jmp __alltraps
  101f2d:	e9 fe 09 00 00       	jmp    102930 <__alltraps>

00101f32 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f32:	6a 0e                	push   $0xe
  jmp __alltraps
  101f34:	e9 f7 09 00 00       	jmp    102930 <__alltraps>

00101f39 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $15
  101f3b:	6a 0f                	push   $0xf
  jmp __alltraps
  101f3d:	e9 ee 09 00 00       	jmp    102930 <__alltraps>

00101f42 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $16
  101f44:	6a 10                	push   $0x10
  jmp __alltraps
  101f46:	e9 e5 09 00 00       	jmp    102930 <__alltraps>

00101f4b <vector17>:
.globl vector17
vector17:
  pushl $17
  101f4b:	6a 11                	push   $0x11
  jmp __alltraps
  101f4d:	e9 de 09 00 00       	jmp    102930 <__alltraps>

00101f52 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $18
  101f54:	6a 12                	push   $0x12
  jmp __alltraps
  101f56:	e9 d5 09 00 00       	jmp    102930 <__alltraps>

00101f5b <vector19>:
.globl vector19
vector19:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $19
  101f5d:	6a 13                	push   $0x13
  jmp __alltraps
  101f5f:	e9 cc 09 00 00       	jmp    102930 <__alltraps>

00101f64 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $20
  101f66:	6a 14                	push   $0x14
  jmp __alltraps
  101f68:	e9 c3 09 00 00       	jmp    102930 <__alltraps>

00101f6d <vector21>:
.globl vector21
vector21:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $21
  101f6f:	6a 15                	push   $0x15
  jmp __alltraps
  101f71:	e9 ba 09 00 00       	jmp    102930 <__alltraps>

00101f76 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $22
  101f78:	6a 16                	push   $0x16
  jmp __alltraps
  101f7a:	e9 b1 09 00 00       	jmp    102930 <__alltraps>

00101f7f <vector23>:
.globl vector23
vector23:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $23
  101f81:	6a 17                	push   $0x17
  jmp __alltraps
  101f83:	e9 a8 09 00 00       	jmp    102930 <__alltraps>

00101f88 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $24
  101f8a:	6a 18                	push   $0x18
  jmp __alltraps
  101f8c:	e9 9f 09 00 00       	jmp    102930 <__alltraps>

00101f91 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $25
  101f93:	6a 19                	push   $0x19
  jmp __alltraps
  101f95:	e9 96 09 00 00       	jmp    102930 <__alltraps>

00101f9a <vector26>:
.globl vector26
vector26:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $26
  101f9c:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f9e:	e9 8d 09 00 00       	jmp    102930 <__alltraps>

00101fa3 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $27
  101fa5:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fa7:	e9 84 09 00 00       	jmp    102930 <__alltraps>

00101fac <vector28>:
.globl vector28
vector28:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $28
  101fae:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fb0:	e9 7b 09 00 00       	jmp    102930 <__alltraps>

00101fb5 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $29
  101fb7:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fb9:	e9 72 09 00 00       	jmp    102930 <__alltraps>

00101fbe <vector30>:
.globl vector30
vector30:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $30
  101fc0:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fc2:	e9 69 09 00 00       	jmp    102930 <__alltraps>

00101fc7 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $31
  101fc9:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fcb:	e9 60 09 00 00       	jmp    102930 <__alltraps>

00101fd0 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $32
  101fd2:	6a 20                	push   $0x20
  jmp __alltraps
  101fd4:	e9 57 09 00 00       	jmp    102930 <__alltraps>

00101fd9 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $33
  101fdb:	6a 21                	push   $0x21
  jmp __alltraps
  101fdd:	e9 4e 09 00 00       	jmp    102930 <__alltraps>

00101fe2 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $34
  101fe4:	6a 22                	push   $0x22
  jmp __alltraps
  101fe6:	e9 45 09 00 00       	jmp    102930 <__alltraps>

00101feb <vector35>:
.globl vector35
vector35:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $35
  101fed:	6a 23                	push   $0x23
  jmp __alltraps
  101fef:	e9 3c 09 00 00       	jmp    102930 <__alltraps>

00101ff4 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $36
  101ff6:	6a 24                	push   $0x24
  jmp __alltraps
  101ff8:	e9 33 09 00 00       	jmp    102930 <__alltraps>

00101ffd <vector37>:
.globl vector37
vector37:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $37
  101fff:	6a 25                	push   $0x25
  jmp __alltraps
  102001:	e9 2a 09 00 00       	jmp    102930 <__alltraps>

00102006 <vector38>:
.globl vector38
vector38:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $38
  102008:	6a 26                	push   $0x26
  jmp __alltraps
  10200a:	e9 21 09 00 00       	jmp    102930 <__alltraps>

0010200f <vector39>:
.globl vector39
vector39:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $39
  102011:	6a 27                	push   $0x27
  jmp __alltraps
  102013:	e9 18 09 00 00       	jmp    102930 <__alltraps>

00102018 <vector40>:
.globl vector40
vector40:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $40
  10201a:	6a 28                	push   $0x28
  jmp __alltraps
  10201c:	e9 0f 09 00 00       	jmp    102930 <__alltraps>

00102021 <vector41>:
.globl vector41
vector41:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $41
  102023:	6a 29                	push   $0x29
  jmp __alltraps
  102025:	e9 06 09 00 00       	jmp    102930 <__alltraps>

0010202a <vector42>:
.globl vector42
vector42:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $42
  10202c:	6a 2a                	push   $0x2a
  jmp __alltraps
  10202e:	e9 fd 08 00 00       	jmp    102930 <__alltraps>

00102033 <vector43>:
.globl vector43
vector43:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $43
  102035:	6a 2b                	push   $0x2b
  jmp __alltraps
  102037:	e9 f4 08 00 00       	jmp    102930 <__alltraps>

0010203c <vector44>:
.globl vector44
vector44:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $44
  10203e:	6a 2c                	push   $0x2c
  jmp __alltraps
  102040:	e9 eb 08 00 00       	jmp    102930 <__alltraps>

00102045 <vector45>:
.globl vector45
vector45:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $45
  102047:	6a 2d                	push   $0x2d
  jmp __alltraps
  102049:	e9 e2 08 00 00       	jmp    102930 <__alltraps>

0010204e <vector46>:
.globl vector46
vector46:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $46
  102050:	6a 2e                	push   $0x2e
  jmp __alltraps
  102052:	e9 d9 08 00 00       	jmp    102930 <__alltraps>

00102057 <vector47>:
.globl vector47
vector47:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $47
  102059:	6a 2f                	push   $0x2f
  jmp __alltraps
  10205b:	e9 d0 08 00 00       	jmp    102930 <__alltraps>

00102060 <vector48>:
.globl vector48
vector48:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $48
  102062:	6a 30                	push   $0x30
  jmp __alltraps
  102064:	e9 c7 08 00 00       	jmp    102930 <__alltraps>

00102069 <vector49>:
.globl vector49
vector49:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $49
  10206b:	6a 31                	push   $0x31
  jmp __alltraps
  10206d:	e9 be 08 00 00       	jmp    102930 <__alltraps>

00102072 <vector50>:
.globl vector50
vector50:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $50
  102074:	6a 32                	push   $0x32
  jmp __alltraps
  102076:	e9 b5 08 00 00       	jmp    102930 <__alltraps>

0010207b <vector51>:
.globl vector51
vector51:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $51
  10207d:	6a 33                	push   $0x33
  jmp __alltraps
  10207f:	e9 ac 08 00 00       	jmp    102930 <__alltraps>

00102084 <vector52>:
.globl vector52
vector52:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $52
  102086:	6a 34                	push   $0x34
  jmp __alltraps
  102088:	e9 a3 08 00 00       	jmp    102930 <__alltraps>

0010208d <vector53>:
.globl vector53
vector53:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $53
  10208f:	6a 35                	push   $0x35
  jmp __alltraps
  102091:	e9 9a 08 00 00       	jmp    102930 <__alltraps>

00102096 <vector54>:
.globl vector54
vector54:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $54
  102098:	6a 36                	push   $0x36
  jmp __alltraps
  10209a:	e9 91 08 00 00       	jmp    102930 <__alltraps>

0010209f <vector55>:
.globl vector55
vector55:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $55
  1020a1:	6a 37                	push   $0x37
  jmp __alltraps
  1020a3:	e9 88 08 00 00       	jmp    102930 <__alltraps>

001020a8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $56
  1020aa:	6a 38                	push   $0x38
  jmp __alltraps
  1020ac:	e9 7f 08 00 00       	jmp    102930 <__alltraps>

001020b1 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $57
  1020b3:	6a 39                	push   $0x39
  jmp __alltraps
  1020b5:	e9 76 08 00 00       	jmp    102930 <__alltraps>

001020ba <vector58>:
.globl vector58
vector58:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $58
  1020bc:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020be:	e9 6d 08 00 00       	jmp    102930 <__alltraps>

001020c3 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $59
  1020c5:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020c7:	e9 64 08 00 00       	jmp    102930 <__alltraps>

001020cc <vector60>:
.globl vector60
vector60:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $60
  1020ce:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020d0:	e9 5b 08 00 00       	jmp    102930 <__alltraps>

001020d5 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $61
  1020d7:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020d9:	e9 52 08 00 00       	jmp    102930 <__alltraps>

001020de <vector62>:
.globl vector62
vector62:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $62
  1020e0:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020e2:	e9 49 08 00 00       	jmp    102930 <__alltraps>

001020e7 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $63
  1020e9:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020eb:	e9 40 08 00 00       	jmp    102930 <__alltraps>

001020f0 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $64
  1020f2:	6a 40                	push   $0x40
  jmp __alltraps
  1020f4:	e9 37 08 00 00       	jmp    102930 <__alltraps>

001020f9 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $65
  1020fb:	6a 41                	push   $0x41
  jmp __alltraps
  1020fd:	e9 2e 08 00 00       	jmp    102930 <__alltraps>

00102102 <vector66>:
.globl vector66
vector66:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $66
  102104:	6a 42                	push   $0x42
  jmp __alltraps
  102106:	e9 25 08 00 00       	jmp    102930 <__alltraps>

0010210b <vector67>:
.globl vector67
vector67:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $67
  10210d:	6a 43                	push   $0x43
  jmp __alltraps
  10210f:	e9 1c 08 00 00       	jmp    102930 <__alltraps>

00102114 <vector68>:
.globl vector68
vector68:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $68
  102116:	6a 44                	push   $0x44
  jmp __alltraps
  102118:	e9 13 08 00 00       	jmp    102930 <__alltraps>

0010211d <vector69>:
.globl vector69
vector69:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $69
  10211f:	6a 45                	push   $0x45
  jmp __alltraps
  102121:	e9 0a 08 00 00       	jmp    102930 <__alltraps>

00102126 <vector70>:
.globl vector70
vector70:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $70
  102128:	6a 46                	push   $0x46
  jmp __alltraps
  10212a:	e9 01 08 00 00       	jmp    102930 <__alltraps>

0010212f <vector71>:
.globl vector71
vector71:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $71
  102131:	6a 47                	push   $0x47
  jmp __alltraps
  102133:	e9 f8 07 00 00       	jmp    102930 <__alltraps>

00102138 <vector72>:
.globl vector72
vector72:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $72
  10213a:	6a 48                	push   $0x48
  jmp __alltraps
  10213c:	e9 ef 07 00 00       	jmp    102930 <__alltraps>

00102141 <vector73>:
.globl vector73
vector73:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $73
  102143:	6a 49                	push   $0x49
  jmp __alltraps
  102145:	e9 e6 07 00 00       	jmp    102930 <__alltraps>

0010214a <vector74>:
.globl vector74
vector74:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $74
  10214c:	6a 4a                	push   $0x4a
  jmp __alltraps
  10214e:	e9 dd 07 00 00       	jmp    102930 <__alltraps>

00102153 <vector75>:
.globl vector75
vector75:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $75
  102155:	6a 4b                	push   $0x4b
  jmp __alltraps
  102157:	e9 d4 07 00 00       	jmp    102930 <__alltraps>

0010215c <vector76>:
.globl vector76
vector76:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $76
  10215e:	6a 4c                	push   $0x4c
  jmp __alltraps
  102160:	e9 cb 07 00 00       	jmp    102930 <__alltraps>

00102165 <vector77>:
.globl vector77
vector77:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $77
  102167:	6a 4d                	push   $0x4d
  jmp __alltraps
  102169:	e9 c2 07 00 00       	jmp    102930 <__alltraps>

0010216e <vector78>:
.globl vector78
vector78:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $78
  102170:	6a 4e                	push   $0x4e
  jmp __alltraps
  102172:	e9 b9 07 00 00       	jmp    102930 <__alltraps>

00102177 <vector79>:
.globl vector79
vector79:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $79
  102179:	6a 4f                	push   $0x4f
  jmp __alltraps
  10217b:	e9 b0 07 00 00       	jmp    102930 <__alltraps>

00102180 <vector80>:
.globl vector80
vector80:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $80
  102182:	6a 50                	push   $0x50
  jmp __alltraps
  102184:	e9 a7 07 00 00       	jmp    102930 <__alltraps>

00102189 <vector81>:
.globl vector81
vector81:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $81
  10218b:	6a 51                	push   $0x51
  jmp __alltraps
  10218d:	e9 9e 07 00 00       	jmp    102930 <__alltraps>

00102192 <vector82>:
.globl vector82
vector82:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $82
  102194:	6a 52                	push   $0x52
  jmp __alltraps
  102196:	e9 95 07 00 00       	jmp    102930 <__alltraps>

0010219b <vector83>:
.globl vector83
vector83:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $83
  10219d:	6a 53                	push   $0x53
  jmp __alltraps
  10219f:	e9 8c 07 00 00       	jmp    102930 <__alltraps>

001021a4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $84
  1021a6:	6a 54                	push   $0x54
  jmp __alltraps
  1021a8:	e9 83 07 00 00       	jmp    102930 <__alltraps>

001021ad <vector85>:
.globl vector85
vector85:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $85
  1021af:	6a 55                	push   $0x55
  jmp __alltraps
  1021b1:	e9 7a 07 00 00       	jmp    102930 <__alltraps>

001021b6 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $86
  1021b8:	6a 56                	push   $0x56
  jmp __alltraps
  1021ba:	e9 71 07 00 00       	jmp    102930 <__alltraps>

001021bf <vector87>:
.globl vector87
vector87:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $87
  1021c1:	6a 57                	push   $0x57
  jmp __alltraps
  1021c3:	e9 68 07 00 00       	jmp    102930 <__alltraps>

001021c8 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $88
  1021ca:	6a 58                	push   $0x58
  jmp __alltraps
  1021cc:	e9 5f 07 00 00       	jmp    102930 <__alltraps>

001021d1 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $89
  1021d3:	6a 59                	push   $0x59
  jmp __alltraps
  1021d5:	e9 56 07 00 00       	jmp    102930 <__alltraps>

001021da <vector90>:
.globl vector90
vector90:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $90
  1021dc:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021de:	e9 4d 07 00 00       	jmp    102930 <__alltraps>

001021e3 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $91
  1021e5:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021e7:	e9 44 07 00 00       	jmp    102930 <__alltraps>

001021ec <vector92>:
.globl vector92
vector92:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $92
  1021ee:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021f0:	e9 3b 07 00 00       	jmp    102930 <__alltraps>

001021f5 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $93
  1021f7:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021f9:	e9 32 07 00 00       	jmp    102930 <__alltraps>

001021fe <vector94>:
.globl vector94
vector94:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $94
  102200:	6a 5e                	push   $0x5e
  jmp __alltraps
  102202:	e9 29 07 00 00       	jmp    102930 <__alltraps>

00102207 <vector95>:
.globl vector95
vector95:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $95
  102209:	6a 5f                	push   $0x5f
  jmp __alltraps
  10220b:	e9 20 07 00 00       	jmp    102930 <__alltraps>

00102210 <vector96>:
.globl vector96
vector96:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $96
  102212:	6a 60                	push   $0x60
  jmp __alltraps
  102214:	e9 17 07 00 00       	jmp    102930 <__alltraps>

00102219 <vector97>:
.globl vector97
vector97:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $97
  10221b:	6a 61                	push   $0x61
  jmp __alltraps
  10221d:	e9 0e 07 00 00       	jmp    102930 <__alltraps>

00102222 <vector98>:
.globl vector98
vector98:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $98
  102224:	6a 62                	push   $0x62
  jmp __alltraps
  102226:	e9 05 07 00 00       	jmp    102930 <__alltraps>

0010222b <vector99>:
.globl vector99
vector99:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $99
  10222d:	6a 63                	push   $0x63
  jmp __alltraps
  10222f:	e9 fc 06 00 00       	jmp    102930 <__alltraps>

00102234 <vector100>:
.globl vector100
vector100:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $100
  102236:	6a 64                	push   $0x64
  jmp __alltraps
  102238:	e9 f3 06 00 00       	jmp    102930 <__alltraps>

0010223d <vector101>:
.globl vector101
vector101:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $101
  10223f:	6a 65                	push   $0x65
  jmp __alltraps
  102241:	e9 ea 06 00 00       	jmp    102930 <__alltraps>

00102246 <vector102>:
.globl vector102
vector102:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $102
  102248:	6a 66                	push   $0x66
  jmp __alltraps
  10224a:	e9 e1 06 00 00       	jmp    102930 <__alltraps>

0010224f <vector103>:
.globl vector103
vector103:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $103
  102251:	6a 67                	push   $0x67
  jmp __alltraps
  102253:	e9 d8 06 00 00       	jmp    102930 <__alltraps>

00102258 <vector104>:
.globl vector104
vector104:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $104
  10225a:	6a 68                	push   $0x68
  jmp __alltraps
  10225c:	e9 cf 06 00 00       	jmp    102930 <__alltraps>

00102261 <vector105>:
.globl vector105
vector105:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $105
  102263:	6a 69                	push   $0x69
  jmp __alltraps
  102265:	e9 c6 06 00 00       	jmp    102930 <__alltraps>

0010226a <vector106>:
.globl vector106
vector106:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $106
  10226c:	6a 6a                	push   $0x6a
  jmp __alltraps
  10226e:	e9 bd 06 00 00       	jmp    102930 <__alltraps>

00102273 <vector107>:
.globl vector107
vector107:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $107
  102275:	6a 6b                	push   $0x6b
  jmp __alltraps
  102277:	e9 b4 06 00 00       	jmp    102930 <__alltraps>

0010227c <vector108>:
.globl vector108
vector108:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $108
  10227e:	6a 6c                	push   $0x6c
  jmp __alltraps
  102280:	e9 ab 06 00 00       	jmp    102930 <__alltraps>

00102285 <vector109>:
.globl vector109
vector109:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $109
  102287:	6a 6d                	push   $0x6d
  jmp __alltraps
  102289:	e9 a2 06 00 00       	jmp    102930 <__alltraps>

0010228e <vector110>:
.globl vector110
vector110:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $110
  102290:	6a 6e                	push   $0x6e
  jmp __alltraps
  102292:	e9 99 06 00 00       	jmp    102930 <__alltraps>

00102297 <vector111>:
.globl vector111
vector111:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $111
  102299:	6a 6f                	push   $0x6f
  jmp __alltraps
  10229b:	e9 90 06 00 00       	jmp    102930 <__alltraps>

001022a0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $112
  1022a2:	6a 70                	push   $0x70
  jmp __alltraps
  1022a4:	e9 87 06 00 00       	jmp    102930 <__alltraps>

001022a9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $113
  1022ab:	6a 71                	push   $0x71
  jmp __alltraps
  1022ad:	e9 7e 06 00 00       	jmp    102930 <__alltraps>

001022b2 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $114
  1022b4:	6a 72                	push   $0x72
  jmp __alltraps
  1022b6:	e9 75 06 00 00       	jmp    102930 <__alltraps>

001022bb <vector115>:
.globl vector115
vector115:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $115
  1022bd:	6a 73                	push   $0x73
  jmp __alltraps
  1022bf:	e9 6c 06 00 00       	jmp    102930 <__alltraps>

001022c4 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $116
  1022c6:	6a 74                	push   $0x74
  jmp __alltraps
  1022c8:	e9 63 06 00 00       	jmp    102930 <__alltraps>

001022cd <vector117>:
.globl vector117
vector117:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $117
  1022cf:	6a 75                	push   $0x75
  jmp __alltraps
  1022d1:	e9 5a 06 00 00       	jmp    102930 <__alltraps>

001022d6 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $118
  1022d8:	6a 76                	push   $0x76
  jmp __alltraps
  1022da:	e9 51 06 00 00       	jmp    102930 <__alltraps>

001022df <vector119>:
.globl vector119
vector119:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $119
  1022e1:	6a 77                	push   $0x77
  jmp __alltraps
  1022e3:	e9 48 06 00 00       	jmp    102930 <__alltraps>

001022e8 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $120
  1022ea:	6a 78                	push   $0x78
  jmp __alltraps
  1022ec:	e9 3f 06 00 00       	jmp    102930 <__alltraps>

001022f1 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $121
  1022f3:	6a 79                	push   $0x79
  jmp __alltraps
  1022f5:	e9 36 06 00 00       	jmp    102930 <__alltraps>

001022fa <vector122>:
.globl vector122
vector122:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $122
  1022fc:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022fe:	e9 2d 06 00 00       	jmp    102930 <__alltraps>

00102303 <vector123>:
.globl vector123
vector123:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $123
  102305:	6a 7b                	push   $0x7b
  jmp __alltraps
  102307:	e9 24 06 00 00       	jmp    102930 <__alltraps>

0010230c <vector124>:
.globl vector124
vector124:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $124
  10230e:	6a 7c                	push   $0x7c
  jmp __alltraps
  102310:	e9 1b 06 00 00       	jmp    102930 <__alltraps>

00102315 <vector125>:
.globl vector125
vector125:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $125
  102317:	6a 7d                	push   $0x7d
  jmp __alltraps
  102319:	e9 12 06 00 00       	jmp    102930 <__alltraps>

0010231e <vector126>:
.globl vector126
vector126:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $126
  102320:	6a 7e                	push   $0x7e
  jmp __alltraps
  102322:	e9 09 06 00 00       	jmp    102930 <__alltraps>

00102327 <vector127>:
.globl vector127
vector127:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $127
  102329:	6a 7f                	push   $0x7f
  jmp __alltraps
  10232b:	e9 00 06 00 00       	jmp    102930 <__alltraps>

00102330 <vector128>:
.globl vector128
vector128:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $128
  102332:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102337:	e9 f4 05 00 00       	jmp    102930 <__alltraps>

0010233c <vector129>:
.globl vector129
vector129:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $129
  10233e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102343:	e9 e8 05 00 00       	jmp    102930 <__alltraps>

00102348 <vector130>:
.globl vector130
vector130:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $130
  10234a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10234f:	e9 dc 05 00 00       	jmp    102930 <__alltraps>

00102354 <vector131>:
.globl vector131
vector131:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $131
  102356:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10235b:	e9 d0 05 00 00       	jmp    102930 <__alltraps>

00102360 <vector132>:
.globl vector132
vector132:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $132
  102362:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102367:	e9 c4 05 00 00       	jmp    102930 <__alltraps>

0010236c <vector133>:
.globl vector133
vector133:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $133
  10236e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102373:	e9 b8 05 00 00       	jmp    102930 <__alltraps>

00102378 <vector134>:
.globl vector134
vector134:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $134
  10237a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10237f:	e9 ac 05 00 00       	jmp    102930 <__alltraps>

00102384 <vector135>:
.globl vector135
vector135:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $135
  102386:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10238b:	e9 a0 05 00 00       	jmp    102930 <__alltraps>

00102390 <vector136>:
.globl vector136
vector136:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $136
  102392:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102397:	e9 94 05 00 00       	jmp    102930 <__alltraps>

0010239c <vector137>:
.globl vector137
vector137:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $137
  10239e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023a3:	e9 88 05 00 00       	jmp    102930 <__alltraps>

001023a8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $138
  1023aa:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023af:	e9 7c 05 00 00       	jmp    102930 <__alltraps>

001023b4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $139
  1023b6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023bb:	e9 70 05 00 00       	jmp    102930 <__alltraps>

001023c0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $140
  1023c2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023c7:	e9 64 05 00 00       	jmp    102930 <__alltraps>

001023cc <vector141>:
.globl vector141
vector141:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $141
  1023ce:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023d3:	e9 58 05 00 00       	jmp    102930 <__alltraps>

001023d8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $142
  1023da:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023df:	e9 4c 05 00 00       	jmp    102930 <__alltraps>

001023e4 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $143
  1023e6:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023eb:	e9 40 05 00 00       	jmp    102930 <__alltraps>

001023f0 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $144
  1023f2:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023f7:	e9 34 05 00 00       	jmp    102930 <__alltraps>

001023fc <vector145>:
.globl vector145
vector145:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $145
  1023fe:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102403:	e9 28 05 00 00       	jmp    102930 <__alltraps>

00102408 <vector146>:
.globl vector146
vector146:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $146
  10240a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10240f:	e9 1c 05 00 00       	jmp    102930 <__alltraps>

00102414 <vector147>:
.globl vector147
vector147:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $147
  102416:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10241b:	e9 10 05 00 00       	jmp    102930 <__alltraps>

00102420 <vector148>:
.globl vector148
vector148:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $148
  102422:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102427:	e9 04 05 00 00       	jmp    102930 <__alltraps>

0010242c <vector149>:
.globl vector149
vector149:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $149
  10242e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102433:	e9 f8 04 00 00       	jmp    102930 <__alltraps>

00102438 <vector150>:
.globl vector150
vector150:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $150
  10243a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10243f:	e9 ec 04 00 00       	jmp    102930 <__alltraps>

00102444 <vector151>:
.globl vector151
vector151:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $151
  102446:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10244b:	e9 e0 04 00 00       	jmp    102930 <__alltraps>

00102450 <vector152>:
.globl vector152
vector152:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $152
  102452:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102457:	e9 d4 04 00 00       	jmp    102930 <__alltraps>

0010245c <vector153>:
.globl vector153
vector153:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $153
  10245e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102463:	e9 c8 04 00 00       	jmp    102930 <__alltraps>

00102468 <vector154>:
.globl vector154
vector154:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $154
  10246a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10246f:	e9 bc 04 00 00       	jmp    102930 <__alltraps>

00102474 <vector155>:
.globl vector155
vector155:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $155
  102476:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10247b:	e9 b0 04 00 00       	jmp    102930 <__alltraps>

00102480 <vector156>:
.globl vector156
vector156:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $156
  102482:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102487:	e9 a4 04 00 00       	jmp    102930 <__alltraps>

0010248c <vector157>:
.globl vector157
vector157:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $157
  10248e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102493:	e9 98 04 00 00       	jmp    102930 <__alltraps>

00102498 <vector158>:
.globl vector158
vector158:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $158
  10249a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10249f:	e9 8c 04 00 00       	jmp    102930 <__alltraps>

001024a4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $159
  1024a6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024ab:	e9 80 04 00 00       	jmp    102930 <__alltraps>

001024b0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $160
  1024b2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024b7:	e9 74 04 00 00       	jmp    102930 <__alltraps>

001024bc <vector161>:
.globl vector161
vector161:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $161
  1024be:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024c3:	e9 68 04 00 00       	jmp    102930 <__alltraps>

001024c8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $162
  1024ca:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024cf:	e9 5c 04 00 00       	jmp    102930 <__alltraps>

001024d4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $163
  1024d6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024db:	e9 50 04 00 00       	jmp    102930 <__alltraps>

001024e0 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $164
  1024e2:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024e7:	e9 44 04 00 00       	jmp    102930 <__alltraps>

001024ec <vector165>:
.globl vector165
vector165:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $165
  1024ee:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024f3:	e9 38 04 00 00       	jmp    102930 <__alltraps>

001024f8 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $166
  1024fa:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024ff:	e9 2c 04 00 00       	jmp    102930 <__alltraps>

00102504 <vector167>:
.globl vector167
vector167:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $167
  102506:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10250b:	e9 20 04 00 00       	jmp    102930 <__alltraps>

00102510 <vector168>:
.globl vector168
vector168:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $168
  102512:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102517:	e9 14 04 00 00       	jmp    102930 <__alltraps>

0010251c <vector169>:
.globl vector169
vector169:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $169
  10251e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102523:	e9 08 04 00 00       	jmp    102930 <__alltraps>

00102528 <vector170>:
.globl vector170
vector170:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $170
  10252a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10252f:	e9 fc 03 00 00       	jmp    102930 <__alltraps>

00102534 <vector171>:
.globl vector171
vector171:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $171
  102536:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10253b:	e9 f0 03 00 00       	jmp    102930 <__alltraps>

00102540 <vector172>:
.globl vector172
vector172:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $172
  102542:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102547:	e9 e4 03 00 00       	jmp    102930 <__alltraps>

0010254c <vector173>:
.globl vector173
vector173:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $173
  10254e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102553:	e9 d8 03 00 00       	jmp    102930 <__alltraps>

00102558 <vector174>:
.globl vector174
vector174:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $174
  10255a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10255f:	e9 cc 03 00 00       	jmp    102930 <__alltraps>

00102564 <vector175>:
.globl vector175
vector175:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $175
  102566:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10256b:	e9 c0 03 00 00       	jmp    102930 <__alltraps>

00102570 <vector176>:
.globl vector176
vector176:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $176
  102572:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102577:	e9 b4 03 00 00       	jmp    102930 <__alltraps>

0010257c <vector177>:
.globl vector177
vector177:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $177
  10257e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102583:	e9 a8 03 00 00       	jmp    102930 <__alltraps>

00102588 <vector178>:
.globl vector178
vector178:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $178
  10258a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10258f:	e9 9c 03 00 00       	jmp    102930 <__alltraps>

00102594 <vector179>:
.globl vector179
vector179:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $179
  102596:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10259b:	e9 90 03 00 00       	jmp    102930 <__alltraps>

001025a0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $180
  1025a2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025a7:	e9 84 03 00 00       	jmp    102930 <__alltraps>

001025ac <vector181>:
.globl vector181
vector181:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $181
  1025ae:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025b3:	e9 78 03 00 00       	jmp    102930 <__alltraps>

001025b8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $182
  1025ba:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025bf:	e9 6c 03 00 00       	jmp    102930 <__alltraps>

001025c4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $183
  1025c6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025cb:	e9 60 03 00 00       	jmp    102930 <__alltraps>

001025d0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $184
  1025d2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025d7:	e9 54 03 00 00       	jmp    102930 <__alltraps>

001025dc <vector185>:
.globl vector185
vector185:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $185
  1025de:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025e3:	e9 48 03 00 00       	jmp    102930 <__alltraps>

001025e8 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $186
  1025ea:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025ef:	e9 3c 03 00 00       	jmp    102930 <__alltraps>

001025f4 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $187
  1025f6:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025fb:	e9 30 03 00 00       	jmp    102930 <__alltraps>

00102600 <vector188>:
.globl vector188
vector188:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $188
  102602:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102607:	e9 24 03 00 00       	jmp    102930 <__alltraps>

0010260c <vector189>:
.globl vector189
vector189:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $189
  10260e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102613:	e9 18 03 00 00       	jmp    102930 <__alltraps>

00102618 <vector190>:
.globl vector190
vector190:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $190
  10261a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10261f:	e9 0c 03 00 00       	jmp    102930 <__alltraps>

00102624 <vector191>:
.globl vector191
vector191:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $191
  102626:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10262b:	e9 00 03 00 00       	jmp    102930 <__alltraps>

00102630 <vector192>:
.globl vector192
vector192:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $192
  102632:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102637:	e9 f4 02 00 00       	jmp    102930 <__alltraps>

0010263c <vector193>:
.globl vector193
vector193:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $193
  10263e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102643:	e9 e8 02 00 00       	jmp    102930 <__alltraps>

00102648 <vector194>:
.globl vector194
vector194:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $194
  10264a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10264f:	e9 dc 02 00 00       	jmp    102930 <__alltraps>

00102654 <vector195>:
.globl vector195
vector195:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $195
  102656:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10265b:	e9 d0 02 00 00       	jmp    102930 <__alltraps>

00102660 <vector196>:
.globl vector196
vector196:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $196
  102662:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102667:	e9 c4 02 00 00       	jmp    102930 <__alltraps>

0010266c <vector197>:
.globl vector197
vector197:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $197
  10266e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102673:	e9 b8 02 00 00       	jmp    102930 <__alltraps>

00102678 <vector198>:
.globl vector198
vector198:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $198
  10267a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10267f:	e9 ac 02 00 00       	jmp    102930 <__alltraps>

00102684 <vector199>:
.globl vector199
vector199:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $199
  102686:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10268b:	e9 a0 02 00 00       	jmp    102930 <__alltraps>

00102690 <vector200>:
.globl vector200
vector200:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $200
  102692:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102697:	e9 94 02 00 00       	jmp    102930 <__alltraps>

0010269c <vector201>:
.globl vector201
vector201:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $201
  10269e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026a3:	e9 88 02 00 00       	jmp    102930 <__alltraps>

001026a8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $202
  1026aa:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026af:	e9 7c 02 00 00       	jmp    102930 <__alltraps>

001026b4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $203
  1026b6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026bb:	e9 70 02 00 00       	jmp    102930 <__alltraps>

001026c0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $204
  1026c2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026c7:	e9 64 02 00 00       	jmp    102930 <__alltraps>

001026cc <vector205>:
.globl vector205
vector205:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $205
  1026ce:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026d3:	e9 58 02 00 00       	jmp    102930 <__alltraps>

001026d8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $206
  1026da:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026df:	e9 4c 02 00 00       	jmp    102930 <__alltraps>

001026e4 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $207
  1026e6:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026eb:	e9 40 02 00 00       	jmp    102930 <__alltraps>

001026f0 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $208
  1026f2:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026f7:	e9 34 02 00 00       	jmp    102930 <__alltraps>

001026fc <vector209>:
.globl vector209
vector209:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $209
  1026fe:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102703:	e9 28 02 00 00       	jmp    102930 <__alltraps>

00102708 <vector210>:
.globl vector210
vector210:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $210
  10270a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10270f:	e9 1c 02 00 00       	jmp    102930 <__alltraps>

00102714 <vector211>:
.globl vector211
vector211:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $211
  102716:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10271b:	e9 10 02 00 00       	jmp    102930 <__alltraps>

00102720 <vector212>:
.globl vector212
vector212:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $212
  102722:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102727:	e9 04 02 00 00       	jmp    102930 <__alltraps>

0010272c <vector213>:
.globl vector213
vector213:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $213
  10272e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102733:	e9 f8 01 00 00       	jmp    102930 <__alltraps>

00102738 <vector214>:
.globl vector214
vector214:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $214
  10273a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10273f:	e9 ec 01 00 00       	jmp    102930 <__alltraps>

00102744 <vector215>:
.globl vector215
vector215:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $215
  102746:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10274b:	e9 e0 01 00 00       	jmp    102930 <__alltraps>

00102750 <vector216>:
.globl vector216
vector216:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $216
  102752:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102757:	e9 d4 01 00 00       	jmp    102930 <__alltraps>

0010275c <vector217>:
.globl vector217
vector217:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $217
  10275e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102763:	e9 c8 01 00 00       	jmp    102930 <__alltraps>

00102768 <vector218>:
.globl vector218
vector218:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $218
  10276a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10276f:	e9 bc 01 00 00       	jmp    102930 <__alltraps>

00102774 <vector219>:
.globl vector219
vector219:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $219
  102776:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10277b:	e9 b0 01 00 00       	jmp    102930 <__alltraps>

00102780 <vector220>:
.globl vector220
vector220:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $220
  102782:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102787:	e9 a4 01 00 00       	jmp    102930 <__alltraps>

0010278c <vector221>:
.globl vector221
vector221:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $221
  10278e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102793:	e9 98 01 00 00       	jmp    102930 <__alltraps>

00102798 <vector222>:
.globl vector222
vector222:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $222
  10279a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10279f:	e9 8c 01 00 00       	jmp    102930 <__alltraps>

001027a4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $223
  1027a6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027ab:	e9 80 01 00 00       	jmp    102930 <__alltraps>

001027b0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $224
  1027b2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027b7:	e9 74 01 00 00       	jmp    102930 <__alltraps>

001027bc <vector225>:
.globl vector225
vector225:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $225
  1027be:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027c3:	e9 68 01 00 00       	jmp    102930 <__alltraps>

001027c8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $226
  1027ca:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027cf:	e9 5c 01 00 00       	jmp    102930 <__alltraps>

001027d4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $227
  1027d6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027db:	e9 50 01 00 00       	jmp    102930 <__alltraps>

001027e0 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $228
  1027e2:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027e7:	e9 44 01 00 00       	jmp    102930 <__alltraps>

001027ec <vector229>:
.globl vector229
vector229:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $229
  1027ee:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027f3:	e9 38 01 00 00       	jmp    102930 <__alltraps>

001027f8 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $230
  1027fa:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027ff:	e9 2c 01 00 00       	jmp    102930 <__alltraps>

00102804 <vector231>:
.globl vector231
vector231:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $231
  102806:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10280b:	e9 20 01 00 00       	jmp    102930 <__alltraps>

00102810 <vector232>:
.globl vector232
vector232:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $232
  102812:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102817:	e9 14 01 00 00       	jmp    102930 <__alltraps>

0010281c <vector233>:
.globl vector233
vector233:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $233
  10281e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102823:	e9 08 01 00 00       	jmp    102930 <__alltraps>

00102828 <vector234>:
.globl vector234
vector234:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $234
  10282a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10282f:	e9 fc 00 00 00       	jmp    102930 <__alltraps>

00102834 <vector235>:
.globl vector235
vector235:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $235
  102836:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10283b:	e9 f0 00 00 00       	jmp    102930 <__alltraps>

00102840 <vector236>:
.globl vector236
vector236:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $236
  102842:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102847:	e9 e4 00 00 00       	jmp    102930 <__alltraps>

0010284c <vector237>:
.globl vector237
vector237:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $237
  10284e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102853:	e9 d8 00 00 00       	jmp    102930 <__alltraps>

00102858 <vector238>:
.globl vector238
vector238:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $238
  10285a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10285f:	e9 cc 00 00 00       	jmp    102930 <__alltraps>

00102864 <vector239>:
.globl vector239
vector239:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $239
  102866:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10286b:	e9 c0 00 00 00       	jmp    102930 <__alltraps>

00102870 <vector240>:
.globl vector240
vector240:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $240
  102872:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102877:	e9 b4 00 00 00       	jmp    102930 <__alltraps>

0010287c <vector241>:
.globl vector241
vector241:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $241
  10287e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102883:	e9 a8 00 00 00       	jmp    102930 <__alltraps>

00102888 <vector242>:
.globl vector242
vector242:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $242
  10288a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10288f:	e9 9c 00 00 00       	jmp    102930 <__alltraps>

00102894 <vector243>:
.globl vector243
vector243:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $243
  102896:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10289b:	e9 90 00 00 00       	jmp    102930 <__alltraps>

001028a0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $244
  1028a2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028a7:	e9 84 00 00 00       	jmp    102930 <__alltraps>

001028ac <vector245>:
.globl vector245
vector245:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $245
  1028ae:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028b3:	e9 78 00 00 00       	jmp    102930 <__alltraps>

001028b8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $246
  1028ba:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028bf:	e9 6c 00 00 00       	jmp    102930 <__alltraps>

001028c4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $247
  1028c6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028cb:	e9 60 00 00 00       	jmp    102930 <__alltraps>

001028d0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $248
  1028d2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028d7:	e9 54 00 00 00       	jmp    102930 <__alltraps>

001028dc <vector249>:
.globl vector249
vector249:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $249
  1028de:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028e3:	e9 48 00 00 00       	jmp    102930 <__alltraps>

001028e8 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $250
  1028ea:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028ef:	e9 3c 00 00 00       	jmp    102930 <__alltraps>

001028f4 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $251
  1028f6:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028fb:	e9 30 00 00 00       	jmp    102930 <__alltraps>

00102900 <vector252>:
.globl vector252
vector252:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $252
  102902:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102907:	e9 24 00 00 00       	jmp    102930 <__alltraps>

0010290c <vector253>:
.globl vector253
vector253:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $253
  10290e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102913:	e9 18 00 00 00       	jmp    102930 <__alltraps>

00102918 <vector254>:
.globl vector254
vector254:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $254
  10291a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10291f:	e9 0c 00 00 00       	jmp    102930 <__alltraps>

00102924 <vector255>:
.globl vector255
vector255:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $255
  102926:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10292b:	e9 00 00 00 00       	jmp    102930 <__alltraps>

00102930 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102930:	1e                   	push   %ds
    pushl %es
  102931:	06                   	push   %es
    pushl %fs
  102932:	0f a0                	push   %fs
    pushl %gs
  102934:	0f a8                	push   %gs
    pushal
  102936:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102937:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10293c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10293e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102940:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102941:	e8 61 f5 ff ff       	call   101ea7 <trap>

    # pop the pushed stack pointer
    popl %esp
  102946:	5c                   	pop    %esp

00102947 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102947:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102948:	0f a9                	pop    %gs
    popl %fs
  10294a:	0f a1                	pop    %fs
    popl %es
  10294c:	07                   	pop    %es
    popl %ds
  10294d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10294e:	83 c4 08             	add    $0x8,%esp
    iret
  102951:	cf                   	iret   

00102952 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102952:	55                   	push   %ebp
  102953:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102955:	8b 45 08             	mov    0x8(%ebp),%eax
  102958:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  10295e:	29 d0                	sub    %edx,%eax
  102960:	c1 f8 02             	sar    $0x2,%eax
  102963:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102969:	5d                   	pop    %ebp
  10296a:	c3                   	ret    

0010296b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10296b:	55                   	push   %ebp
  10296c:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  10296e:	ff 75 08             	pushl  0x8(%ebp)
  102971:	e8 dc ff ff ff       	call   102952 <page2ppn>
  102976:	83 c4 04             	add    $0x4,%esp
  102979:	c1 e0 0c             	shl    $0xc,%eax
}
  10297c:	c9                   	leave  
  10297d:	c3                   	ret    

0010297e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  10297e:	55                   	push   %ebp
  10297f:	89 e5                	mov    %esp,%ebp
  102981:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  102984:	8b 45 08             	mov    0x8(%ebp),%eax
  102987:	c1 e8 0c             	shr    $0xc,%eax
  10298a:	89 c2                	mov    %eax,%edx
  10298c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102991:	39 c2                	cmp    %eax,%edx
  102993:	72 14                	jb     1029a9 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  102995:	83 ec 04             	sub    $0x4,%esp
  102998:	68 30 63 10 00       	push   $0x106330
  10299d:	6a 5a                	push   $0x5a
  10299f:	68 4f 63 10 00       	push   $0x10634f
  1029a4:	e8 2c da ff ff       	call   1003d5 <__panic>
    }
    return &pages[PPN(pa)];
  1029a9:	8b 0d b8 89 11 00    	mov    0x1189b8,%ecx
  1029af:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b2:	c1 e8 0c             	shr    $0xc,%eax
  1029b5:	89 c2                	mov    %eax,%edx
  1029b7:	89 d0                	mov    %edx,%eax
  1029b9:	c1 e0 02             	shl    $0x2,%eax
  1029bc:	01 d0                	add    %edx,%eax
  1029be:	c1 e0 02             	shl    $0x2,%eax
  1029c1:	01 c8                	add    %ecx,%eax
}
  1029c3:	c9                   	leave  
  1029c4:	c3                   	ret    

001029c5 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1029c5:	55                   	push   %ebp
  1029c6:	89 e5                	mov    %esp,%ebp
  1029c8:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  1029cb:	ff 75 08             	pushl  0x8(%ebp)
  1029ce:	e8 98 ff ff ff       	call   10296b <page2pa>
  1029d3:	83 c4 04             	add    $0x4,%esp
  1029d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029dc:	c1 e8 0c             	shr    $0xc,%eax
  1029df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029e2:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1029e7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1029ea:	72 14                	jb     102a00 <page2kva+0x3b>
  1029ec:	ff 75 f4             	pushl  -0xc(%ebp)
  1029ef:	68 60 63 10 00       	push   $0x106360
  1029f4:	6a 61                	push   $0x61
  1029f6:	68 4f 63 10 00       	push   $0x10634f
  1029fb:	e8 d5 d9 ff ff       	call   1003d5 <__panic>
  102a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a03:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a08:	c9                   	leave  
  102a09:	c3                   	ret    

00102a0a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102a0a:	55                   	push   %ebp
  102a0b:	89 e5                	mov    %esp,%ebp
  102a0d:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  102a10:	8b 45 08             	mov    0x8(%ebp),%eax
  102a13:	83 e0 01             	and    $0x1,%eax
  102a16:	85 c0                	test   %eax,%eax
  102a18:	75 14                	jne    102a2e <pte2page+0x24>
        panic("pte2page called with invalid pte");
  102a1a:	83 ec 04             	sub    $0x4,%esp
  102a1d:	68 84 63 10 00       	push   $0x106384
  102a22:	6a 6c                	push   $0x6c
  102a24:	68 4f 63 10 00       	push   $0x10634f
  102a29:	e8 a7 d9 ff ff       	call   1003d5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a36:	83 ec 0c             	sub    $0xc,%esp
  102a39:	50                   	push   %eax
  102a3a:	e8 3f ff ff ff       	call   10297e <pa2page>
  102a3f:	83 c4 10             	add    $0x10,%esp
}
  102a42:	c9                   	leave  
  102a43:	c3                   	ret    

00102a44 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102a44:	55                   	push   %ebp
  102a45:	89 e5                	mov    %esp,%ebp
  102a47:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  102a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a52:	83 ec 0c             	sub    $0xc,%esp
  102a55:	50                   	push   %eax
  102a56:	e8 23 ff ff ff       	call   10297e <pa2page>
  102a5b:	83 c4 10             	add    $0x10,%esp
}
  102a5e:	c9                   	leave  
  102a5f:	c3                   	ret    

00102a60 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102a60:	55                   	push   %ebp
  102a61:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a63:	8b 45 08             	mov    0x8(%ebp),%eax
  102a66:	8b 00                	mov    (%eax),%eax
}
  102a68:	5d                   	pop    %ebp
  102a69:	c3                   	ret    

00102a6a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a6a:	55                   	push   %ebp
  102a6b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a73:	89 10                	mov    %edx,(%eax)
}
  102a75:	90                   	nop
  102a76:	5d                   	pop    %ebp
  102a77:	c3                   	ret    

00102a78 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102a78:	55                   	push   %ebp
  102a79:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7e:	8b 00                	mov    (%eax),%eax
  102a80:	8d 50 01             	lea    0x1(%eax),%edx
  102a83:	8b 45 08             	mov    0x8(%ebp),%eax
  102a86:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102a88:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8b:	8b 00                	mov    (%eax),%eax
}
  102a8d:	5d                   	pop    %ebp
  102a8e:	c3                   	ret    

00102a8f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102a8f:	55                   	push   %ebp
  102a90:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102a92:	8b 45 08             	mov    0x8(%ebp),%eax
  102a95:	8b 00                	mov    (%eax),%eax
  102a97:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa2:	8b 00                	mov    (%eax),%eax
}
  102aa4:	5d                   	pop    %ebp
  102aa5:	c3                   	ret    

00102aa6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  102aa6:	55                   	push   %ebp
  102aa7:	89 e5                	mov    %esp,%ebp
  102aa9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102aac:	9c                   	pushf  
  102aad:	58                   	pop    %eax
  102aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102ab4:	25 00 02 00 00       	and    $0x200,%eax
  102ab9:	85 c0                	test   %eax,%eax
  102abb:	74 0c                	je     102ac9 <__intr_save+0x23>
        intr_disable();
  102abd:	e8 b4 ed ff ff       	call   101876 <intr_disable>
        return 1;
  102ac2:	b8 01 00 00 00       	mov    $0x1,%eax
  102ac7:	eb 05                	jmp    102ace <__intr_save+0x28>
    }
    return 0;
  102ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ace:	c9                   	leave  
  102acf:	c3                   	ret    

00102ad0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102ad0:	55                   	push   %ebp
  102ad1:	89 e5                	mov    %esp,%ebp
  102ad3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102ad6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ada:	74 05                	je     102ae1 <__intr_restore+0x11>
        intr_enable();
  102adc:	e8 8e ed ff ff       	call   10186f <intr_enable>
    }
}
  102ae1:	90                   	nop
  102ae2:	c9                   	leave  
  102ae3:	c3                   	ret    

00102ae4 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102ae4:	55                   	push   %ebp
  102ae5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  102aea:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102aed:	b8 23 00 00 00       	mov    $0x23,%eax
  102af2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102af4:	b8 23 00 00 00       	mov    $0x23,%eax
  102af9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102afb:	b8 10 00 00 00       	mov    $0x10,%eax
  102b00:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b02:	b8 10 00 00 00       	mov    $0x10,%eax
  102b07:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b09:	b8 10 00 00 00       	mov    $0x10,%eax
  102b0e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b10:	ea 17 2b 10 00 08 00 	ljmp   $0x8,$0x102b17
}
  102b17:	90                   	nop
  102b18:	5d                   	pop    %ebp
  102b19:	c3                   	ret    

00102b1a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b1a:	55                   	push   %ebp
  102b1b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b20:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  102b25:	90                   	nop
  102b26:	5d                   	pop    %ebp
  102b27:	c3                   	ret    

00102b28 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b28:	55                   	push   %ebp
  102b29:	89 e5                	mov    %esp,%ebp
  102b2b:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102b2e:	b8 00 70 11 00       	mov    $0x117000,%eax
  102b33:	50                   	push   %eax
  102b34:	e8 e1 ff ff ff       	call   102b1a <load_esp0>
  102b39:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102b3c:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102b43:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102b45:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102b4c:	68 00 
  102b4e:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102b53:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102b59:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102b5e:	c1 e8 10             	shr    $0x10,%eax
  102b61:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102b66:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102b6d:	83 e0 f0             	and    $0xfffffff0,%eax
  102b70:	83 c8 09             	or     $0x9,%eax
  102b73:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102b78:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102b7f:	83 e0 ef             	and    $0xffffffef,%eax
  102b82:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102b87:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102b8e:	83 e0 9f             	and    $0xffffff9f,%eax
  102b91:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102b96:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102b9d:	83 c8 80             	or     $0xffffff80,%eax
  102ba0:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102ba5:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102bac:	83 e0 f0             	and    $0xfffffff0,%eax
  102baf:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102bb4:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102bbb:	83 e0 ef             	and    $0xffffffef,%eax
  102bbe:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102bc3:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102bca:	83 e0 df             	and    $0xffffffdf,%eax
  102bcd:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102bd2:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102bd9:	83 c8 40             	or     $0x40,%eax
  102bdc:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102be1:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102be8:	83 e0 7f             	and    $0x7f,%eax
  102beb:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102bf0:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102bf5:	c1 e8 18             	shr    $0x18,%eax
  102bf8:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102bfd:	68 30 7a 11 00       	push   $0x117a30
  102c02:	e8 dd fe ff ff       	call   102ae4 <lgdt>
  102c07:	83 c4 04             	add    $0x4,%esp
  102c0a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c10:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c14:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102c17:	90                   	nop
  102c18:	c9                   	leave  
  102c19:	c3                   	ret    

00102c1a <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c1a:	55                   	push   %ebp
  102c1b:	89 e5                	mov    %esp,%ebp
  102c1d:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102c20:	c7 05 b0 89 11 00 10 	movl   $0x106d10,0x1189b0
  102c27:	6d 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102c2a:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102c2f:	8b 00                	mov    (%eax),%eax
  102c31:	83 ec 08             	sub    $0x8,%esp
  102c34:	50                   	push   %eax
  102c35:	68 b0 63 10 00       	push   $0x1063b0
  102c3a:	e8 30 d6 ff ff       	call   10026f <cprintf>
  102c3f:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102c42:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102c47:	8b 40 04             	mov    0x4(%eax),%eax
  102c4a:	ff d0                	call   *%eax
}
  102c4c:	90                   	nop
  102c4d:	c9                   	leave  
  102c4e:	c3                   	ret    

00102c4f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102c4f:	55                   	push   %ebp
  102c50:	89 e5                	mov    %esp,%ebp
  102c52:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102c55:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102c5a:	8b 40 08             	mov    0x8(%eax),%eax
  102c5d:	83 ec 08             	sub    $0x8,%esp
  102c60:	ff 75 0c             	pushl  0xc(%ebp)
  102c63:	ff 75 08             	pushl  0x8(%ebp)
  102c66:	ff d0                	call   *%eax
  102c68:	83 c4 10             	add    $0x10,%esp
}
  102c6b:	90                   	nop
  102c6c:	c9                   	leave  
  102c6d:	c3                   	ret    

00102c6e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102c6e:	55                   	push   %ebp
  102c6f:	89 e5                	mov    %esp,%ebp
  102c71:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);     // save interrupt state
  102c7b:	e8 26 fe ff ff       	call   102aa6 <__intr_save>
  102c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102c83:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102c88:	8b 40 0c             	mov    0xc(%eax),%eax
  102c8b:	83 ec 0c             	sub    $0xc,%esp
  102c8e:	ff 75 08             	pushl  0x8(%ebp)
  102c91:	ff d0                	call   *%eax
  102c93:	83 c4 10             	add    $0x10,%esp
  102c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102c99:	83 ec 0c             	sub    $0xc,%esp
  102c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  102c9f:	e8 2c fe ff ff       	call   102ad0 <__intr_restore>
  102ca4:	83 c4 10             	add    $0x10,%esp
    return page;
  102ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102caa:	c9                   	leave  
  102cab:	c3                   	ret    

00102cac <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102cac:	55                   	push   %ebp
  102cad:	89 e5                	mov    %esp,%ebp
  102caf:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102cb2:	e8 ef fd ff ff       	call   102aa6 <__intr_save>
  102cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102cba:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102cbf:	8b 40 10             	mov    0x10(%eax),%eax
  102cc2:	83 ec 08             	sub    $0x8,%esp
  102cc5:	ff 75 0c             	pushl  0xc(%ebp)
  102cc8:	ff 75 08             	pushl  0x8(%ebp)
  102ccb:	ff d0                	call   *%eax
  102ccd:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102cd0:	83 ec 0c             	sub    $0xc,%esp
  102cd3:	ff 75 f4             	pushl  -0xc(%ebp)
  102cd6:	e8 f5 fd ff ff       	call   102ad0 <__intr_restore>
  102cdb:	83 c4 10             	add    $0x10,%esp
}
  102cde:	90                   	nop
  102cdf:	c9                   	leave  
  102ce0:	c3                   	ret    

00102ce1 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102ce1:	55                   	push   %ebp
  102ce2:	89 e5                	mov    %esp,%ebp
  102ce4:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102ce7:	e8 ba fd ff ff       	call   102aa6 <__intr_save>
  102cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102cef:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  102cf4:	8b 40 14             	mov    0x14(%eax),%eax
  102cf7:	ff d0                	call   *%eax
  102cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102cfc:	83 ec 0c             	sub    $0xc,%esp
  102cff:	ff 75 f4             	pushl  -0xc(%ebp)
  102d02:	e8 c9 fd ff ff       	call   102ad0 <__intr_restore>
  102d07:	83 c4 10             	add    $0x10,%esp
    return ret;
  102d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d0d:	c9                   	leave  
  102d0e:	c3                   	ret    

00102d0f <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d0f:	55                   	push   %ebp
  102d10:	89 e5                	mov    %esp,%ebp
  102d12:	57                   	push   %edi
  102d13:	56                   	push   %esi
  102d14:	53                   	push   %ebx
  102d15:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d18:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d2d:	83 ec 0c             	sub    $0xc,%esp
  102d30:	68 c7 63 10 00       	push   $0x1063c7
  102d35:	e8 35 d5 ff ff       	call   10026f <cprintf>
  102d3a:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d3d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d44:	e9 fc 00 00 00       	jmp    102e45 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d49:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d4f:	89 d0                	mov    %edx,%eax
  102d51:	c1 e0 02             	shl    $0x2,%eax
  102d54:	01 d0                	add    %edx,%eax
  102d56:	c1 e0 02             	shl    $0x2,%eax
  102d59:	01 c8                	add    %ecx,%eax
  102d5b:	8b 50 08             	mov    0x8(%eax),%edx
  102d5e:	8b 40 04             	mov    0x4(%eax),%eax
  102d61:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102d64:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102d67:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d6d:	89 d0                	mov    %edx,%eax
  102d6f:	c1 e0 02             	shl    $0x2,%eax
  102d72:	01 d0                	add    %edx,%eax
  102d74:	c1 e0 02             	shl    $0x2,%eax
  102d77:	01 c8                	add    %ecx,%eax
  102d79:	8b 48 0c             	mov    0xc(%eax),%ecx
  102d7c:	8b 58 10             	mov    0x10(%eax),%ebx
  102d7f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d82:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d85:	01 c8                	add    %ecx,%eax
  102d87:	11 da                	adc    %ebx,%edx
  102d89:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102d8c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102d8f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d95:	89 d0                	mov    %edx,%eax
  102d97:	c1 e0 02             	shl    $0x2,%eax
  102d9a:	01 d0                	add    %edx,%eax
  102d9c:	c1 e0 02             	shl    $0x2,%eax
  102d9f:	01 c8                	add    %ecx,%eax
  102da1:	83 c0 14             	add    $0x14,%eax
  102da4:	8b 00                	mov    (%eax),%eax
  102da6:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102da9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102dac:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102daf:	83 c0 ff             	add    $0xffffffff,%eax
  102db2:	83 d2 ff             	adc    $0xffffffff,%edx
  102db5:	89 c1                	mov    %eax,%ecx
  102db7:	89 d3                	mov    %edx,%ebx
  102db9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102dbc:	89 55 80             	mov    %edx,-0x80(%ebp)
  102dbf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dc2:	89 d0                	mov    %edx,%eax
  102dc4:	c1 e0 02             	shl    $0x2,%eax
  102dc7:	01 d0                	add    %edx,%eax
  102dc9:	c1 e0 02             	shl    $0x2,%eax
  102dcc:	03 45 80             	add    -0x80(%ebp),%eax
  102dcf:	8b 50 10             	mov    0x10(%eax),%edx
  102dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  102dd5:	ff 75 84             	pushl  -0x7c(%ebp)
  102dd8:	53                   	push   %ebx
  102dd9:	51                   	push   %ecx
  102dda:	ff 75 bc             	pushl  -0x44(%ebp)
  102ddd:	ff 75 b8             	pushl  -0x48(%ebp)
  102de0:	52                   	push   %edx
  102de1:	50                   	push   %eax
  102de2:	68 d4 63 10 00       	push   $0x1063d4
  102de7:	e8 83 d4 ff ff       	call   10026f <cprintf>
  102dec:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102def:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102df2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102df5:	89 d0                	mov    %edx,%eax
  102df7:	c1 e0 02             	shl    $0x2,%eax
  102dfa:	01 d0                	add    %edx,%eax
  102dfc:	c1 e0 02             	shl    $0x2,%eax
  102dff:	01 c8                	add    %ecx,%eax
  102e01:	83 c0 14             	add    $0x14,%eax
  102e04:	8b 00                	mov    (%eax),%eax
  102e06:	83 f8 01             	cmp    $0x1,%eax
  102e09:	75 36                	jne    102e41 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e11:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e14:	77 2b                	ja     102e41 <page_init+0x132>
  102e16:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102e19:	72 05                	jb     102e20 <page_init+0x111>
  102e1b:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102e1e:	73 21                	jae    102e41 <page_init+0x132>
  102e20:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102e24:	77 1b                	ja     102e41 <page_init+0x132>
  102e26:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102e2a:	72 09                	jb     102e35 <page_init+0x126>
  102e2c:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102e33:	77 0c                	ja     102e41 <page_init+0x132>
                maxpa = end;
  102e35:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e38:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102e41:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102e45:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e48:	8b 00                	mov    (%eax),%eax
  102e4a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102e4d:	0f 8f f6 fe ff ff    	jg     102d49 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102e53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e57:	72 1d                	jb     102e76 <page_init+0x167>
  102e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e5d:	77 09                	ja     102e68 <page_init+0x159>
  102e5f:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102e66:	76 0e                	jbe    102e76 <page_init+0x167>
        maxpa = KMEMSIZE;
  102e68:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102e6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
  102e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e7c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102e80:	c1 ea 0c             	shr    $0xc,%edx
  102e83:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102e88:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102e8f:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  102e94:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e97:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e9a:	01 d0                	add    %edx,%eax
  102e9c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102e9f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102ea2:	ba 00 00 00 00       	mov    $0x0,%edx
  102ea7:	f7 75 ac             	divl   -0x54(%ebp)
  102eaa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102ead:	29 d0                	sub    %edx,%eax
  102eaf:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    for (i = 0; i < npage; i ++) {
  102eb4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ebb:	eb 2f                	jmp    102eec <page_init+0x1dd>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
  102ebd:	8b 0d b8 89 11 00    	mov    0x1189b8,%ecx
  102ec3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ec6:	89 d0                	mov    %edx,%eax
  102ec8:	c1 e0 02             	shl    $0x2,%eax
  102ecb:	01 d0                	add    %edx,%eax
  102ecd:	c1 e0 02             	shl    $0x2,%eax
  102ed0:	01 c8                	add    %ecx,%eax
  102ed2:	83 c0 04             	add    $0x4,%eax
  102ed5:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102edc:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102edf:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102ee2:	8b 55 90             	mov    -0x70(%ebp),%edx
  102ee5:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];  // start addr of physical page table

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  102ee8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102eec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102eef:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102ef4:	39 c2                	cmp    %eax,%edx
  102ef6:	72 c5                	jb     102ebd <page_init+0x1ae>
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt
  102ef8:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102efe:	89 d0                	mov    %edx,%eax
  102f00:	c1 e0 02             	shl    $0x2,%eax
  102f03:	01 d0                	add    %edx,%eax
  102f05:	c1 e0 02             	shl    $0x2,%eax
  102f08:	89 c2                	mov    %eax,%edx
  102f0a:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102f0f:	01 d0                	add    %edx,%eax
  102f11:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102f14:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102f1b:	77 17                	ja     102f34 <page_init+0x225>
  102f1d:	ff 75 a4             	pushl  -0x5c(%ebp)
  102f20:	68 04 64 10 00       	push   $0x106404
  102f25:	68 dc 00 00 00       	push   $0xdc
  102f2a:	68 28 64 10 00       	push   $0x106428
  102f2f:	e8 a1 d4 ff ff       	call   1003d5 <__panic>
  102f34:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102f37:	05 00 00 00 40       	add    $0x40000000,%eax
  102f3c:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102f3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f46:	e9 69 01 00 00       	jmp    1030b4 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102f4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f51:	89 d0                	mov    %edx,%eax
  102f53:	c1 e0 02             	shl    $0x2,%eax
  102f56:	01 d0                	add    %edx,%eax
  102f58:	c1 e0 02             	shl    $0x2,%eax
  102f5b:	01 c8                	add    %ecx,%eax
  102f5d:	8b 50 08             	mov    0x8(%eax),%edx
  102f60:	8b 40 04             	mov    0x4(%eax),%eax
  102f63:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f66:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f69:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f6f:	89 d0                	mov    %edx,%eax
  102f71:	c1 e0 02             	shl    $0x2,%eax
  102f74:	01 d0                	add    %edx,%eax
  102f76:	c1 e0 02             	shl    $0x2,%eax
  102f79:	01 c8                	add    %ecx,%eax
  102f7b:	8b 48 0c             	mov    0xc(%eax),%ecx
  102f7e:	8b 58 10             	mov    0x10(%eax),%ebx
  102f81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f87:	01 c8                	add    %ecx,%eax
  102f89:	11 da                	adc    %ebx,%edx
  102f8b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102f8e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102f91:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f97:	89 d0                	mov    %edx,%eax
  102f99:	c1 e0 02             	shl    $0x2,%eax
  102f9c:	01 d0                	add    %edx,%eax
  102f9e:	c1 e0 02             	shl    $0x2,%eax
  102fa1:	01 c8                	add    %ecx,%eax
  102fa3:	83 c0 14             	add    $0x14,%eax
  102fa6:	8b 00                	mov    (%eax),%eax
  102fa8:	83 f8 01             	cmp    $0x1,%eax
  102fab:	0f 85 ff 00 00 00    	jne    1030b0 <page_init+0x3a1>
            if (begin < freemem) {
  102fb1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102fb4:	ba 00 00 00 00       	mov    $0x0,%edx
  102fb9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fbc:	72 17                	jb     102fd5 <page_init+0x2c6>
  102fbe:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fc1:	77 05                	ja     102fc8 <page_init+0x2b9>
  102fc3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102fc6:	76 0d                	jbe    102fd5 <page_init+0x2c6>
                begin = freemem;
  102fc8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102fcb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fce:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102fd5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102fd9:	72 1d                	jb     102ff8 <page_init+0x2e9>
  102fdb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102fdf:	77 09                	ja     102fea <page_init+0x2db>
  102fe1:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102fe8:	76 0e                	jbe    102ff8 <page_init+0x2e9>
                end = KMEMSIZE;
  102fea:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102ff1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102ff8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ffb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ffe:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103001:	0f 87 a9 00 00 00    	ja     1030b0 <page_init+0x3a1>
  103007:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10300a:	72 09                	jb     103015 <page_init+0x306>
  10300c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10300f:	0f 83 9b 00 00 00    	jae    1030b0 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
  103015:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10301c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10301f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103022:	01 d0                	add    %edx,%eax
  103024:	83 e8 01             	sub    $0x1,%eax
  103027:	89 45 98             	mov    %eax,-0x68(%ebp)
  10302a:	8b 45 98             	mov    -0x68(%ebp),%eax
  10302d:	ba 00 00 00 00       	mov    $0x0,%edx
  103032:	f7 75 9c             	divl   -0x64(%ebp)
  103035:	8b 45 98             	mov    -0x68(%ebp),%eax
  103038:	29 d0                	sub    %edx,%eax
  10303a:	ba 00 00 00 00       	mov    $0x0,%edx
  10303f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103042:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103045:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103048:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10304b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10304e:	ba 00 00 00 00       	mov    $0x0,%edx
  103053:	89 c3                	mov    %eax,%ebx
  103055:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  10305b:	89 de                	mov    %ebx,%esi
  10305d:	89 d0                	mov    %edx,%eax
  10305f:	83 e0 00             	and    $0x0,%eax
  103062:	89 c7                	mov    %eax,%edi
  103064:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103067:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  10306a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10306d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103070:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103073:	77 3b                	ja     1030b0 <page_init+0x3a1>
  103075:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103078:	72 05                	jb     10307f <page_init+0x370>
  10307a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10307d:	73 31                	jae    1030b0 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10307f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103082:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103085:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103088:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10308b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10308f:	c1 ea 0c             	shr    $0xc,%edx
  103092:	89 c3                	mov    %eax,%ebx
  103094:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103097:	83 ec 0c             	sub    $0xc,%esp
  10309a:	50                   	push   %eax
  10309b:	e8 de f8 ff ff       	call   10297e <pa2page>
  1030a0:	83 c4 10             	add    $0x10,%esp
  1030a3:	83 ec 08             	sub    $0x8,%esp
  1030a6:	53                   	push   %ebx
  1030a7:	50                   	push   %eax
  1030a8:	e8 a2 fb ff ff       	call   102c4f <init_memmap>
  1030ad:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);     // page + 1: next physical page table entry
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // exactly the free mem after pdt

    for (i = 0; i < memmap->nr_map; i ++) {
  1030b0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1030b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1030b7:	8b 00                	mov    (%eax),%eax
  1030b9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1030bc:	0f 8f 89 fe ff ff    	jg     102f4b <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1030c2:	90                   	nop
  1030c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1030c6:	5b                   	pop    %ebx
  1030c7:	5e                   	pop    %esi
  1030c8:	5f                   	pop    %edi
  1030c9:	5d                   	pop    %ebp
  1030ca:	c3                   	ret    

001030cb <enable_paging>:

static void
enable_paging(void) {
  1030cb:	55                   	push   %ebp
  1030cc:	89 e5                	mov    %esp,%ebp
  1030ce:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1030d1:	a1 b4 89 11 00       	mov    0x1189b4,%eax
  1030d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1030d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030dc:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1030df:	0f 20 c0             	mov    %cr0,%eax
  1030e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1030e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1030eb:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1030f2:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  1030f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ff:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103102:	90                   	nop
  103103:	c9                   	leave  
  103104:	c3                   	ret    

00103105 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103105:	55                   	push   %ebp
  103106:	89 e5                	mov    %esp,%ebp
  103108:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10310b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310e:	33 45 14             	xor    0x14(%ebp),%eax
  103111:	25 ff 0f 00 00       	and    $0xfff,%eax
  103116:	85 c0                	test   %eax,%eax
  103118:	74 19                	je     103133 <boot_map_segment+0x2e>
  10311a:	68 36 64 10 00       	push   $0x106436
  10311f:	68 4d 64 10 00       	push   $0x10644d
  103124:	68 05 01 00 00       	push   $0x105
  103129:	68 28 64 10 00       	push   $0x106428
  10312e:	e8 a2 d2 ff ff       	call   1003d5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103133:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10313a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10313d:	25 ff 0f 00 00       	and    $0xfff,%eax
  103142:	89 c2                	mov    %eax,%edx
  103144:	8b 45 10             	mov    0x10(%ebp),%eax
  103147:	01 c2                	add    %eax,%edx
  103149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10314c:	01 d0                	add    %edx,%eax
  10314e:	83 e8 01             	sub    $0x1,%eax
  103151:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103157:	ba 00 00 00 00       	mov    $0x0,%edx
  10315c:	f7 75 f0             	divl   -0x10(%ebp)
  10315f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103162:	29 d0                	sub    %edx,%eax
  103164:	c1 e8 0c             	shr    $0xc,%eax
  103167:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10316a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103173:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103178:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10317b:	8b 45 14             	mov    0x14(%ebp),%eax
  10317e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103184:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103189:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10318c:	eb 57                	jmp    1031e5 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10318e:	83 ec 04             	sub    $0x4,%esp
  103191:	6a 01                	push   $0x1
  103193:	ff 75 0c             	pushl  0xc(%ebp)
  103196:	ff 75 08             	pushl  0x8(%ebp)
  103199:	e8 98 01 00 00       	call   103336 <get_pte>
  10319e:	83 c4 10             	add    $0x10,%esp
  1031a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1031a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1031a8:	75 19                	jne    1031c3 <boot_map_segment+0xbe>
  1031aa:	68 62 64 10 00       	push   $0x106462
  1031af:	68 4d 64 10 00       	push   $0x10644d
  1031b4:	68 0b 01 00 00       	push   $0x10b
  1031b9:	68 28 64 10 00       	push   $0x106428
  1031be:	e8 12 d2 ff ff       	call   1003d5 <__panic>
        *ptep = pa | PTE_P | perm;
  1031c3:	8b 45 14             	mov    0x14(%ebp),%eax
  1031c6:	0b 45 18             	or     0x18(%ebp),%eax
  1031c9:	83 c8 01             	or     $0x1,%eax
  1031cc:	89 c2                	mov    %eax,%edx
  1031ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031d1:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1031d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1031d7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1031de:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1031e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031e9:	75 a3                	jne    10318e <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1031eb:	90                   	nop
  1031ec:	c9                   	leave  
  1031ed:	c3                   	ret    

001031ee <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1031ee:	55                   	push   %ebp
  1031ef:	89 e5                	mov    %esp,%ebp
  1031f1:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  1031f4:	83 ec 0c             	sub    $0xc,%esp
  1031f7:	6a 01                	push   $0x1
  1031f9:	e8 70 fa ff ff       	call   102c6e <alloc_pages>
  1031fe:	83 c4 10             	add    $0x10,%esp
  103201:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103208:	75 17                	jne    103221 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  10320a:	83 ec 04             	sub    $0x4,%esp
  10320d:	68 6f 64 10 00       	push   $0x10646f
  103212:	68 17 01 00 00       	push   $0x117
  103217:	68 28 64 10 00       	push   $0x106428
  10321c:	e8 b4 d1 ff ff       	call   1003d5 <__panic>
    }
    return page2kva(p);     // va = pa + KERNELBASE(0x C000 0000)
  103221:	83 ec 0c             	sub    $0xc,%esp
  103224:	ff 75 f4             	pushl  -0xc(%ebp)
  103227:	e8 99 f7 ff ff       	call   1029c5 <page2kva>
  10322c:	83 c4 10             	add    $0x10,%esp
}
  10322f:	c9                   	leave  
  103230:	c3                   	ret    

00103231 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103231:	55                   	push   %ebp
  103232:	89 e5                	mov    %esp,%ebp
  103234:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103237:	e8 de f9 ff ff       	call   102c1a <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10323c:	e8 ce fa ff ff       	call   102d0f <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103241:	e8 38 04 00 00       	call   10367e <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  103246:	e8 a3 ff ff ff       	call   1031ee <boot_alloc_page>
  10324b:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  103250:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103255:	83 ec 04             	sub    $0x4,%esp
  103258:	68 00 10 00 00       	push   $0x1000
  10325d:	6a 00                	push   $0x0
  10325f:	50                   	push   %eax
  103260:	e8 13 22 00 00       	call   105478 <memset>
  103265:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);   // paddr of pgdir
  103268:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10326d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103270:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103277:	77 17                	ja     103290 <pmm_init+0x5f>
  103279:	ff 75 f4             	pushl  -0xc(%ebp)
  10327c:	68 04 64 10 00       	push   $0x106404
  103281:	68 31 01 00 00       	push   $0x131
  103286:	68 28 64 10 00       	push   $0x106428
  10328b:	e8 45 d1 ff ff       	call   1003d5 <__panic>
  103290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103293:	05 00 00 00 40       	add    $0x40000000,%eax
  103298:	a3 b4 89 11 00       	mov    %eax,0x1189b4

    check_pgdir();
  10329d:	e8 ff 03 00 00       	call   1036a1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1032a2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1032a7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1032ad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1032b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032b5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1032bc:	77 17                	ja     1032d5 <pmm_init+0xa4>
  1032be:	ff 75 f0             	pushl  -0x10(%ebp)
  1032c1:	68 04 64 10 00       	push   $0x106404
  1032c6:	68 39 01 00 00       	push   $0x139
  1032cb:	68 28 64 10 00       	push   $0x106428
  1032d0:	e8 00 d1 ff ff       	call   1003d5 <__panic>
  1032d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032d8:	05 00 00 00 40       	add    $0x40000000,%eax
  1032dd:	83 c8 03             	or     $0x3,%eax
  1032e0:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1032e2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1032e7:	83 ec 0c             	sub    $0xc,%esp
  1032ea:	6a 02                	push   $0x2
  1032ec:	6a 00                	push   $0x0
  1032ee:	68 00 00 00 38       	push   $0x38000000
  1032f3:	68 00 00 00 c0       	push   $0xc0000000
  1032f8:	50                   	push   %eax
  1032f9:	e8 07 fe ff ff       	call   103105 <boot_map_segment>
  1032fe:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103301:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103306:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  10330c:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103312:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103314:	e8 b2 fd ff ff       	call   1030cb <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103319:	e8 0a f8 ff ff       	call   102b28 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10331e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103329:	e8 d9 08 00 00       	call   103c07 <check_boot_pgdir>

    print_pgdir();
  10332e:	e8 cf 0c 00 00       	call   104002 <print_pgdir>

}
  103333:	90                   	nop
  103334:	c9                   	leave  
  103335:	c3                   	ret    

00103336 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103336:	55                   	push   %ebp
  103337:	89 e5                	mov    %esp,%ebp
  103339:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    size_t pdx = PDX(la);       // index of this la in page dir table
  10333c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10333f:	c1 e8 16             	shr    $0x16,%eax
  103342:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pde_t * pdep = pgdir + pdx; // NOTE: this is a virtual addr
  103345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10334f:	8b 45 08             	mov    0x8(%ebp),%eax
  103352:	01 d0                	add    %edx,%eax
  103354:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // (2) check if entry is not present
    if (!(*pdep & PTE_P)) {
  103357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335a:	8b 00                	mov    (%eax),%eax
  10335c:	83 e0 01             	and    $0x1,%eax
  10335f:	85 c0                	test   %eax,%eax
  103361:	0f 85 ae 00 00 00    	jne    103415 <get_pte+0xdf>
        // (3) check if creating is needed
        if (!create) {
  103367:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10336b:	75 0a                	jne    103377 <get_pte+0x41>
            return NULL;
  10336d:	b8 00 00 00 00       	mov    $0x0,%eax
  103372:	e9 01 01 00 00       	jmp    103478 <get_pte+0x142>
        }
        // alloc page for page table
        struct Page * pt_page =  alloc_page();
  103377:	83 ec 0c             	sub    $0xc,%esp
  10337a:	6a 01                	push   $0x1
  10337c:	e8 ed f8 ff ff       	call   102c6e <alloc_pages>
  103381:	83 c4 10             	add    $0x10,%esp
  103384:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pt_page == NULL) {
  103387:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10338b:	75 0a                	jne    103397 <get_pte+0x61>
            return NULL;
  10338d:	b8 00 00 00 00       	mov    $0x0,%eax
  103392:	e9 e1 00 00 00       	jmp    103478 <get_pte+0x142>
        }

        // (4) set page reference
        set_page_ref(pt_page, 1);
  103397:	83 ec 08             	sub    $0x8,%esp
  10339a:	6a 01                	push   $0x1
  10339c:	ff 75 ec             	pushl  -0x14(%ebp)
  10339f:	e8 c6 f6 ff ff       	call   102a6a <set_page_ref>
  1033a4:	83 c4 10             	add    $0x10,%esp

        // (5) get linear address of page
        uintptr_t pt_addr = page2pa(pt_page);
  1033a7:	83 ec 0c             	sub    $0xc,%esp
  1033aa:	ff 75 ec             	pushl  -0x14(%ebp)
  1033ad:	e8 b9 f5 ff ff       	call   10296b <page2pa>
  1033b2:	83 c4 10             	add    $0x10,%esp
  1033b5:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // (6) clear page content using memset
        memset(KADDR(pt_addr), 0, PGSIZE);
  1033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033c1:	c1 e8 0c             	shr    $0xc,%eax
  1033c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1033c7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1033cc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1033cf:	72 17                	jb     1033e8 <get_pte+0xb2>
  1033d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  1033d4:	68 60 63 10 00       	push   $0x106360
  1033d9:	68 97 01 00 00       	push   $0x197
  1033de:	68 28 64 10 00       	push   $0x106428
  1033e3:	e8 ed cf ff ff       	call   1003d5 <__panic>
  1033e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033eb:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1033f0:	83 ec 04             	sub    $0x4,%esp
  1033f3:	68 00 10 00 00       	push   $0x1000
  1033f8:	6a 00                	push   $0x0
  1033fa:	50                   	push   %eax
  1033fb:	e8 78 20 00 00       	call   105478 <memset>
  103400:	83 c4 10             	add    $0x10,%esp

        // (7) set page directory entry's permission
        *pdep = (PDE_ADDR(pt_addr)) | PTE_U | PTE_W | PTE_P; // PDE_ADDR: get pa &= ~0xFFF
  103403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10340b:	83 c8 07             	or     $0x7,%eax
  10340e:	89 c2                	mov    %eax,%edx
  103410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103413:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    size_t ptx = PTX(la);   // index of this la in page dir table
  103415:	8b 45 0c             	mov    0xc(%ebp),%eax
  103418:	c1 e8 0c             	shr    $0xc,%eax
  10341b:	25 ff 03 00 00       	and    $0x3ff,%eax
  103420:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uintptr_t pt_pa = PDE_ADDR(*pdep);
  103423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103426:	8b 00                	mov    (%eax),%eax
  103428:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10342d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t * ptep = (pte_t *)KADDR(pt_pa) + ptx;
  103430:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103433:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  103436:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103439:	c1 e8 0c             	shr    $0xc,%eax
  10343c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10343f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103444:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103447:	72 17                	jb     103460 <get_pte+0x12a>
  103449:	ff 75 d4             	pushl  -0x2c(%ebp)
  10344c:	68 60 63 10 00       	push   $0x106360
  103451:	68 9f 01 00 00       	push   $0x19f
  103456:	68 28 64 10 00       	push   $0x106428
  10345b:	e8 75 cf ff ff       	call   1003d5 <__panic>
  103460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103463:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103468:	89 c2                	mov    %eax,%edx
  10346a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10346d:	c1 e0 02             	shl    $0x2,%eax
  103470:	01 d0                	add    %edx,%eax
  103472:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return ptep;
  103475:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
  103478:	c9                   	leave  
  103479:	c3                   	ret    

0010347a <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10347a:	55                   	push   %ebp
  10347b:	89 e5                	mov    %esp,%ebp
  10347d:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103480:	83 ec 04             	sub    $0x4,%esp
  103483:	6a 00                	push   $0x0
  103485:	ff 75 0c             	pushl  0xc(%ebp)
  103488:	ff 75 08             	pushl  0x8(%ebp)
  10348b:	e8 a6 fe ff ff       	call   103336 <get_pte>
  103490:	83 c4 10             	add    $0x10,%esp
  103493:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103496:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10349a:	74 08                	je     1034a4 <get_page+0x2a>
        *ptep_store = ptep;
  10349c:	8b 45 10             	mov    0x10(%ebp),%eax
  10349f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034a2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034a8:	74 1f                	je     1034c9 <get_page+0x4f>
  1034aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034ad:	8b 00                	mov    (%eax),%eax
  1034af:	83 e0 01             	and    $0x1,%eax
  1034b2:	85 c0                	test   %eax,%eax
  1034b4:	74 13                	je     1034c9 <get_page+0x4f>
        return pte2page(*ptep);
  1034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034b9:	8b 00                	mov    (%eax),%eax
  1034bb:	83 ec 0c             	sub    $0xc,%esp
  1034be:	50                   	push   %eax
  1034bf:	e8 46 f5 ff ff       	call   102a0a <pte2page>
  1034c4:	83 c4 10             	add    $0x10,%esp
  1034c7:	eb 05                	jmp    1034ce <get_page+0x54>
    }
    return NULL;
  1034c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034ce:	c9                   	leave  
  1034cf:	c3                   	ret    

001034d0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1034d0:	55                   	push   %ebp
  1034d1:	89 e5                	mov    %esp,%ebp
  1034d3:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
  1034d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1034d9:	8b 00                	mov    (%eax),%eax
  1034db:	83 e0 01             	and    $0x1,%eax
  1034de:	85 c0                	test   %eax,%eax
  1034e0:	74 57                	je     103539 <page_remove_pte+0x69>
        return;
    }
    //(2) find corresponding page to pte
    struct Page *page = pte2page(*ptep);
  1034e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1034e5:	8b 00                	mov    (%eax),%eax
  1034e7:	83 ec 0c             	sub    $0xc,%esp
  1034ea:	50                   	push   %eax
  1034eb:	e8 1a f5 ff ff       	call   102a0a <pte2page>
  1034f0:	83 c4 10             	add    $0x10,%esp
  1034f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

    //(3) decrease page reference
    page_ref_dec(page);
  1034f6:	83 ec 0c             	sub    $0xc,%esp
  1034f9:	ff 75 f4             	pushl  -0xc(%ebp)
  1034fc:	e8 8e f5 ff ff       	call   102a8f <page_ref_dec>
  103501:	83 c4 10             	add    $0x10,%esp

    //(4) and free this page when page reference reachs 0
    if (page->ref == 0) {
  103504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103507:	8b 00                	mov    (%eax),%eax
  103509:	85 c0                	test   %eax,%eax
  10350b:	75 10                	jne    10351d <page_remove_pte+0x4d>
        free_page(page);
  10350d:	83 ec 08             	sub    $0x8,%esp
  103510:	6a 01                	push   $0x1
  103512:	ff 75 f4             	pushl  -0xc(%ebp)
  103515:	e8 92 f7 ff ff       	call   102cac <free_pages>
  10351a:	83 c4 10             	add    $0x10,%esp
    }

    //(5) clear second page table entry
    *ptep = 0;
  10351d:	8b 45 10             	mov    0x10(%ebp),%eax
  103520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
  103526:	83 ec 08             	sub    $0x8,%esp
  103529:	ff 75 0c             	pushl  0xc(%ebp)
  10352c:	ff 75 08             	pushl  0x8(%ebp)
  10352f:	e8 fa 00 00 00       	call   10362e <tlb_invalidate>
  103534:	83 c4 10             	add    $0x10,%esp
  103537:	eb 01                	jmp    10353a <page_remove_pte+0x6a>
                                  //(6) flush tlb
    }
#endif
    //(1) check if this page table entry is present
    if (!(*ptep & PTE_P)) {
        return;
  103539:	90                   	nop
    //(5) clear second page table entry
    *ptep = 0;

    //(6) flush tlb
    tlb_invalidate(pgdir, la);
}
  10353a:	c9                   	leave  
  10353b:	c3                   	ret    

0010353c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10353c:	55                   	push   %ebp
  10353d:	89 e5                	mov    %esp,%ebp
  10353f:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103542:	83 ec 04             	sub    $0x4,%esp
  103545:	6a 00                	push   $0x0
  103547:	ff 75 0c             	pushl  0xc(%ebp)
  10354a:	ff 75 08             	pushl  0x8(%ebp)
  10354d:	e8 e4 fd ff ff       	call   103336 <get_pte>
  103552:	83 c4 10             	add    $0x10,%esp
  103555:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10355c:	74 14                	je     103572 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  10355e:	83 ec 04             	sub    $0x4,%esp
  103561:	ff 75 f4             	pushl  -0xc(%ebp)
  103564:	ff 75 0c             	pushl  0xc(%ebp)
  103567:	ff 75 08             	pushl  0x8(%ebp)
  10356a:	e8 61 ff ff ff       	call   1034d0 <page_remove_pte>
  10356f:	83 c4 10             	add    $0x10,%esp
    }
}
  103572:	90                   	nop
  103573:	c9                   	leave  
  103574:	c3                   	ret    

00103575 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103575:	55                   	push   %ebp
  103576:	89 e5                	mov    %esp,%ebp
  103578:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10357b:	83 ec 04             	sub    $0x4,%esp
  10357e:	6a 01                	push   $0x1
  103580:	ff 75 10             	pushl  0x10(%ebp)
  103583:	ff 75 08             	pushl  0x8(%ebp)
  103586:	e8 ab fd ff ff       	call   103336 <get_pte>
  10358b:	83 c4 10             	add    $0x10,%esp
  10358e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103595:	75 0a                	jne    1035a1 <page_insert+0x2c>
        return -E_NO_MEM;
  103597:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10359c:	e9 8b 00 00 00       	jmp    10362c <page_insert+0xb7>
    }
    page_ref_inc(page);
  1035a1:	83 ec 0c             	sub    $0xc,%esp
  1035a4:	ff 75 0c             	pushl  0xc(%ebp)
  1035a7:	e8 cc f4 ff ff       	call   102a78 <page_ref_inc>
  1035ac:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  1035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035b2:	8b 00                	mov    (%eax),%eax
  1035b4:	83 e0 01             	and    $0x1,%eax
  1035b7:	85 c0                	test   %eax,%eax
  1035b9:	74 40                	je     1035fb <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  1035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035be:	8b 00                	mov    (%eax),%eax
  1035c0:	83 ec 0c             	sub    $0xc,%esp
  1035c3:	50                   	push   %eax
  1035c4:	e8 41 f4 ff ff       	call   102a0a <pte2page>
  1035c9:	83 c4 10             	add    $0x10,%esp
  1035cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1035cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1035d5:	75 10                	jne    1035e7 <page_insert+0x72>
            page_ref_dec(page);
  1035d7:	83 ec 0c             	sub    $0xc,%esp
  1035da:	ff 75 0c             	pushl  0xc(%ebp)
  1035dd:	e8 ad f4 ff ff       	call   102a8f <page_ref_dec>
  1035e2:	83 c4 10             	add    $0x10,%esp
  1035e5:	eb 14                	jmp    1035fb <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1035e7:	83 ec 04             	sub    $0x4,%esp
  1035ea:	ff 75 f4             	pushl  -0xc(%ebp)
  1035ed:	ff 75 10             	pushl  0x10(%ebp)
  1035f0:	ff 75 08             	pushl  0x8(%ebp)
  1035f3:	e8 d8 fe ff ff       	call   1034d0 <page_remove_pte>
  1035f8:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1035fb:	83 ec 0c             	sub    $0xc,%esp
  1035fe:	ff 75 0c             	pushl  0xc(%ebp)
  103601:	e8 65 f3 ff ff       	call   10296b <page2pa>
  103606:	83 c4 10             	add    $0x10,%esp
  103609:	0b 45 14             	or     0x14(%ebp),%eax
  10360c:	83 c8 01             	or     $0x1,%eax
  10360f:	89 c2                	mov    %eax,%edx
  103611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103614:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103616:	83 ec 08             	sub    $0x8,%esp
  103619:	ff 75 10             	pushl  0x10(%ebp)
  10361c:	ff 75 08             	pushl  0x8(%ebp)
  10361f:	e8 0a 00 00 00       	call   10362e <tlb_invalidate>
  103624:	83 c4 10             	add    $0x10,%esp
    return 0;
  103627:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10362c:	c9                   	leave  
  10362d:	c3                   	ret    

0010362e <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10362e:	55                   	push   %ebp
  10362f:	89 e5                	mov    %esp,%ebp
  103631:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103634:	0f 20 d8             	mov    %cr3,%eax
  103637:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  10363a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10363d:	8b 45 08             	mov    0x8(%ebp),%eax
  103640:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103643:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10364a:	77 17                	ja     103663 <tlb_invalidate+0x35>
  10364c:	ff 75 f0             	pushl  -0x10(%ebp)
  10364f:	68 04 64 10 00       	push   $0x106404
  103654:	68 0e 02 00 00       	push   $0x20e
  103659:	68 28 64 10 00       	push   $0x106428
  10365e:	e8 72 cd ff ff       	call   1003d5 <__panic>
  103663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103666:	05 00 00 00 40       	add    $0x40000000,%eax
  10366b:	39 c2                	cmp    %eax,%edx
  10366d:	75 0c                	jne    10367b <tlb_invalidate+0x4d>
        invlpg((void *)la);
  10366f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103672:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103678:	0f 01 38             	invlpg (%eax)
    }
}
  10367b:	90                   	nop
  10367c:	c9                   	leave  
  10367d:	c3                   	ret    

0010367e <check_alloc_page>:

static void
check_alloc_page(void) {
  10367e:	55                   	push   %ebp
  10367f:	89 e5                	mov    %esp,%ebp
  103681:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  103684:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  103689:	8b 40 18             	mov    0x18(%eax),%eax
  10368c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10368e:	83 ec 0c             	sub    $0xc,%esp
  103691:	68 88 64 10 00       	push   $0x106488
  103696:	e8 d4 cb ff ff       	call   10026f <cprintf>
  10369b:	83 c4 10             	add    $0x10,%esp
}
  10369e:	90                   	nop
  10369f:	c9                   	leave  
  1036a0:	c3                   	ret    

001036a1 <check_pgdir>:

static void
check_pgdir(void) {
  1036a1:	55                   	push   %ebp
  1036a2:	89 e5                	mov    %esp,%ebp
  1036a4:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1036a7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1036ac:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1036b1:	76 19                	jbe    1036cc <check_pgdir+0x2b>
  1036b3:	68 a7 64 10 00       	push   $0x1064a7
  1036b8:	68 4d 64 10 00       	push   $0x10644d
  1036bd:	68 1b 02 00 00       	push   $0x21b
  1036c2:	68 28 64 10 00       	push   $0x106428
  1036c7:	e8 09 cd ff ff       	call   1003d5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1036cc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036d1:	85 c0                	test   %eax,%eax
  1036d3:	74 0e                	je     1036e3 <check_pgdir+0x42>
  1036d5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036da:	25 ff 0f 00 00       	and    $0xfff,%eax
  1036df:	85 c0                	test   %eax,%eax
  1036e1:	74 19                	je     1036fc <check_pgdir+0x5b>
  1036e3:	68 c4 64 10 00       	push   $0x1064c4
  1036e8:	68 4d 64 10 00       	push   $0x10644d
  1036ed:	68 1c 02 00 00       	push   $0x21c
  1036f2:	68 28 64 10 00       	push   $0x106428
  1036f7:	e8 d9 cc ff ff       	call   1003d5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1036fc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103701:	83 ec 04             	sub    $0x4,%esp
  103704:	6a 00                	push   $0x0
  103706:	6a 00                	push   $0x0
  103708:	50                   	push   %eax
  103709:	e8 6c fd ff ff       	call   10347a <get_page>
  10370e:	83 c4 10             	add    $0x10,%esp
  103711:	85 c0                	test   %eax,%eax
  103713:	74 19                	je     10372e <check_pgdir+0x8d>
  103715:	68 fc 64 10 00       	push   $0x1064fc
  10371a:	68 4d 64 10 00       	push   $0x10644d
  10371f:	68 1d 02 00 00       	push   $0x21d
  103724:	68 28 64 10 00       	push   $0x106428
  103729:	e8 a7 cc ff ff       	call   1003d5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10372e:	83 ec 0c             	sub    $0xc,%esp
  103731:	6a 01                	push   $0x1
  103733:	e8 36 f5 ff ff       	call   102c6e <alloc_pages>
  103738:	83 c4 10             	add    $0x10,%esp
  10373b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10373e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103743:	6a 00                	push   $0x0
  103745:	6a 00                	push   $0x0
  103747:	ff 75 f4             	pushl  -0xc(%ebp)
  10374a:	50                   	push   %eax
  10374b:	e8 25 fe ff ff       	call   103575 <page_insert>
  103750:	83 c4 10             	add    $0x10,%esp
  103753:	85 c0                	test   %eax,%eax
  103755:	74 19                	je     103770 <check_pgdir+0xcf>
  103757:	68 24 65 10 00       	push   $0x106524
  10375c:	68 4d 64 10 00       	push   $0x10644d
  103761:	68 21 02 00 00       	push   $0x221
  103766:	68 28 64 10 00       	push   $0x106428
  10376b:	e8 65 cc ff ff       	call   1003d5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103770:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103775:	83 ec 04             	sub    $0x4,%esp
  103778:	6a 00                	push   $0x0
  10377a:	6a 00                	push   $0x0
  10377c:	50                   	push   %eax
  10377d:	e8 b4 fb ff ff       	call   103336 <get_pte>
  103782:	83 c4 10             	add    $0x10,%esp
  103785:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10378c:	75 19                	jne    1037a7 <check_pgdir+0x106>
  10378e:	68 50 65 10 00       	push   $0x106550
  103793:	68 4d 64 10 00       	push   $0x10644d
  103798:	68 24 02 00 00       	push   $0x224
  10379d:	68 28 64 10 00       	push   $0x106428
  1037a2:	e8 2e cc ff ff       	call   1003d5 <__panic>
    assert(pte2page(*ptep) == p1);
  1037a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037aa:	8b 00                	mov    (%eax),%eax
  1037ac:	83 ec 0c             	sub    $0xc,%esp
  1037af:	50                   	push   %eax
  1037b0:	e8 55 f2 ff ff       	call   102a0a <pte2page>
  1037b5:	83 c4 10             	add    $0x10,%esp
  1037b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1037bb:	74 19                	je     1037d6 <check_pgdir+0x135>
  1037bd:	68 7d 65 10 00       	push   $0x10657d
  1037c2:	68 4d 64 10 00       	push   $0x10644d
  1037c7:	68 25 02 00 00       	push   $0x225
  1037cc:	68 28 64 10 00       	push   $0x106428
  1037d1:	e8 ff cb ff ff       	call   1003d5 <__panic>
    assert(page_ref(p1) == 1);
  1037d6:	83 ec 0c             	sub    $0xc,%esp
  1037d9:	ff 75 f4             	pushl  -0xc(%ebp)
  1037dc:	e8 7f f2 ff ff       	call   102a60 <page_ref>
  1037e1:	83 c4 10             	add    $0x10,%esp
  1037e4:	83 f8 01             	cmp    $0x1,%eax
  1037e7:	74 19                	je     103802 <check_pgdir+0x161>
  1037e9:	68 93 65 10 00       	push   $0x106593
  1037ee:	68 4d 64 10 00       	push   $0x10644d
  1037f3:	68 26 02 00 00       	push   $0x226
  1037f8:	68 28 64 10 00       	push   $0x106428
  1037fd:	e8 d3 cb ff ff       	call   1003d5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103802:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103807:	8b 00                	mov    (%eax),%eax
  103809:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10380e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103814:	c1 e8 0c             	shr    $0xc,%eax
  103817:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10381a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10381f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103822:	72 17                	jb     10383b <check_pgdir+0x19a>
  103824:	ff 75 ec             	pushl  -0x14(%ebp)
  103827:	68 60 63 10 00       	push   $0x106360
  10382c:	68 28 02 00 00       	push   $0x228
  103831:	68 28 64 10 00       	push   $0x106428
  103836:	e8 9a cb ff ff       	call   1003d5 <__panic>
  10383b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10383e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103843:	83 c0 04             	add    $0x4,%eax
  103846:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103849:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10384e:	83 ec 04             	sub    $0x4,%esp
  103851:	6a 00                	push   $0x0
  103853:	68 00 10 00 00       	push   $0x1000
  103858:	50                   	push   %eax
  103859:	e8 d8 fa ff ff       	call   103336 <get_pte>
  10385e:	83 c4 10             	add    $0x10,%esp
  103861:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103864:	74 19                	je     10387f <check_pgdir+0x1de>
  103866:	68 a8 65 10 00       	push   $0x1065a8
  10386b:	68 4d 64 10 00       	push   $0x10644d
  103870:	68 29 02 00 00       	push   $0x229
  103875:	68 28 64 10 00       	push   $0x106428
  10387a:	e8 56 cb ff ff       	call   1003d5 <__panic>

    p2 = alloc_page();
  10387f:	83 ec 0c             	sub    $0xc,%esp
  103882:	6a 01                	push   $0x1
  103884:	e8 e5 f3 ff ff       	call   102c6e <alloc_pages>
  103889:	83 c4 10             	add    $0x10,%esp
  10388c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10388f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103894:	6a 06                	push   $0x6
  103896:	68 00 10 00 00       	push   $0x1000
  10389b:	ff 75 e4             	pushl  -0x1c(%ebp)
  10389e:	50                   	push   %eax
  10389f:	e8 d1 fc ff ff       	call   103575 <page_insert>
  1038a4:	83 c4 10             	add    $0x10,%esp
  1038a7:	85 c0                	test   %eax,%eax
  1038a9:	74 19                	je     1038c4 <check_pgdir+0x223>
  1038ab:	68 d0 65 10 00       	push   $0x1065d0
  1038b0:	68 4d 64 10 00       	push   $0x10644d
  1038b5:	68 2c 02 00 00       	push   $0x22c
  1038ba:	68 28 64 10 00       	push   $0x106428
  1038bf:	e8 11 cb ff ff       	call   1003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1038c4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038c9:	83 ec 04             	sub    $0x4,%esp
  1038cc:	6a 00                	push   $0x0
  1038ce:	68 00 10 00 00       	push   $0x1000
  1038d3:	50                   	push   %eax
  1038d4:	e8 5d fa ff ff       	call   103336 <get_pte>
  1038d9:	83 c4 10             	add    $0x10,%esp
  1038dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038e3:	75 19                	jne    1038fe <check_pgdir+0x25d>
  1038e5:	68 08 66 10 00       	push   $0x106608
  1038ea:	68 4d 64 10 00       	push   $0x10644d
  1038ef:	68 2d 02 00 00       	push   $0x22d
  1038f4:	68 28 64 10 00       	push   $0x106428
  1038f9:	e8 d7 ca ff ff       	call   1003d5 <__panic>
    assert(*ptep & PTE_U);
  1038fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103901:	8b 00                	mov    (%eax),%eax
  103903:	83 e0 04             	and    $0x4,%eax
  103906:	85 c0                	test   %eax,%eax
  103908:	75 19                	jne    103923 <check_pgdir+0x282>
  10390a:	68 38 66 10 00       	push   $0x106638
  10390f:	68 4d 64 10 00       	push   $0x10644d
  103914:	68 2e 02 00 00       	push   $0x22e
  103919:	68 28 64 10 00       	push   $0x106428
  10391e:	e8 b2 ca ff ff       	call   1003d5 <__panic>
    assert(*ptep & PTE_W);
  103923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103926:	8b 00                	mov    (%eax),%eax
  103928:	83 e0 02             	and    $0x2,%eax
  10392b:	85 c0                	test   %eax,%eax
  10392d:	75 19                	jne    103948 <check_pgdir+0x2a7>
  10392f:	68 46 66 10 00       	push   $0x106646
  103934:	68 4d 64 10 00       	push   $0x10644d
  103939:	68 2f 02 00 00       	push   $0x22f
  10393e:	68 28 64 10 00       	push   $0x106428
  103943:	e8 8d ca ff ff       	call   1003d5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103948:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10394d:	8b 00                	mov    (%eax),%eax
  10394f:	83 e0 04             	and    $0x4,%eax
  103952:	85 c0                	test   %eax,%eax
  103954:	75 19                	jne    10396f <check_pgdir+0x2ce>
  103956:	68 54 66 10 00       	push   $0x106654
  10395b:	68 4d 64 10 00       	push   $0x10644d
  103960:	68 30 02 00 00       	push   $0x230
  103965:	68 28 64 10 00       	push   $0x106428
  10396a:	e8 66 ca ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 1);
  10396f:	83 ec 0c             	sub    $0xc,%esp
  103972:	ff 75 e4             	pushl  -0x1c(%ebp)
  103975:	e8 e6 f0 ff ff       	call   102a60 <page_ref>
  10397a:	83 c4 10             	add    $0x10,%esp
  10397d:	83 f8 01             	cmp    $0x1,%eax
  103980:	74 19                	je     10399b <check_pgdir+0x2fa>
  103982:	68 6a 66 10 00       	push   $0x10666a
  103987:	68 4d 64 10 00       	push   $0x10644d
  10398c:	68 31 02 00 00       	push   $0x231
  103991:	68 28 64 10 00       	push   $0x106428
  103996:	e8 3a ca ff ff       	call   1003d5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10399b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039a0:	6a 00                	push   $0x0
  1039a2:	68 00 10 00 00       	push   $0x1000
  1039a7:	ff 75 f4             	pushl  -0xc(%ebp)
  1039aa:	50                   	push   %eax
  1039ab:	e8 c5 fb ff ff       	call   103575 <page_insert>
  1039b0:	83 c4 10             	add    $0x10,%esp
  1039b3:	85 c0                	test   %eax,%eax
  1039b5:	74 19                	je     1039d0 <check_pgdir+0x32f>
  1039b7:	68 7c 66 10 00       	push   $0x10667c
  1039bc:	68 4d 64 10 00       	push   $0x10644d
  1039c1:	68 33 02 00 00       	push   $0x233
  1039c6:	68 28 64 10 00       	push   $0x106428
  1039cb:	e8 05 ca ff ff       	call   1003d5 <__panic>
    assert(page_ref(p1) == 2);
  1039d0:	83 ec 0c             	sub    $0xc,%esp
  1039d3:	ff 75 f4             	pushl  -0xc(%ebp)
  1039d6:	e8 85 f0 ff ff       	call   102a60 <page_ref>
  1039db:	83 c4 10             	add    $0x10,%esp
  1039de:	83 f8 02             	cmp    $0x2,%eax
  1039e1:	74 19                	je     1039fc <check_pgdir+0x35b>
  1039e3:	68 a8 66 10 00       	push   $0x1066a8
  1039e8:	68 4d 64 10 00       	push   $0x10644d
  1039ed:	68 34 02 00 00       	push   $0x234
  1039f2:	68 28 64 10 00       	push   $0x106428
  1039f7:	e8 d9 c9 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 0);
  1039fc:	83 ec 0c             	sub    $0xc,%esp
  1039ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a02:	e8 59 f0 ff ff       	call   102a60 <page_ref>
  103a07:	83 c4 10             	add    $0x10,%esp
  103a0a:	85 c0                	test   %eax,%eax
  103a0c:	74 19                	je     103a27 <check_pgdir+0x386>
  103a0e:	68 ba 66 10 00       	push   $0x1066ba
  103a13:	68 4d 64 10 00       	push   $0x10644d
  103a18:	68 35 02 00 00       	push   $0x235
  103a1d:	68 28 64 10 00       	push   $0x106428
  103a22:	e8 ae c9 ff ff       	call   1003d5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a27:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a2c:	83 ec 04             	sub    $0x4,%esp
  103a2f:	6a 00                	push   $0x0
  103a31:	68 00 10 00 00       	push   $0x1000
  103a36:	50                   	push   %eax
  103a37:	e8 fa f8 ff ff       	call   103336 <get_pte>
  103a3c:	83 c4 10             	add    $0x10,%esp
  103a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a46:	75 19                	jne    103a61 <check_pgdir+0x3c0>
  103a48:	68 08 66 10 00       	push   $0x106608
  103a4d:	68 4d 64 10 00       	push   $0x10644d
  103a52:	68 36 02 00 00       	push   $0x236
  103a57:	68 28 64 10 00       	push   $0x106428
  103a5c:	e8 74 c9 ff ff       	call   1003d5 <__panic>
    assert(pte2page(*ptep) == p1);
  103a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a64:	8b 00                	mov    (%eax),%eax
  103a66:	83 ec 0c             	sub    $0xc,%esp
  103a69:	50                   	push   %eax
  103a6a:	e8 9b ef ff ff       	call   102a0a <pte2page>
  103a6f:	83 c4 10             	add    $0x10,%esp
  103a72:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103a75:	74 19                	je     103a90 <check_pgdir+0x3ef>
  103a77:	68 7d 65 10 00       	push   $0x10657d
  103a7c:	68 4d 64 10 00       	push   $0x10644d
  103a81:	68 37 02 00 00       	push   $0x237
  103a86:	68 28 64 10 00       	push   $0x106428
  103a8b:	e8 45 c9 ff ff       	call   1003d5 <__panic>
    assert((*ptep & PTE_U) == 0);
  103a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a93:	8b 00                	mov    (%eax),%eax
  103a95:	83 e0 04             	and    $0x4,%eax
  103a98:	85 c0                	test   %eax,%eax
  103a9a:	74 19                	je     103ab5 <check_pgdir+0x414>
  103a9c:	68 cc 66 10 00       	push   $0x1066cc
  103aa1:	68 4d 64 10 00       	push   $0x10644d
  103aa6:	68 38 02 00 00       	push   $0x238
  103aab:	68 28 64 10 00       	push   $0x106428
  103ab0:	e8 20 c9 ff ff       	call   1003d5 <__panic>

    page_remove(boot_pgdir, 0x0);
  103ab5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103aba:	83 ec 08             	sub    $0x8,%esp
  103abd:	6a 00                	push   $0x0
  103abf:	50                   	push   %eax
  103ac0:	e8 77 fa ff ff       	call   10353c <page_remove>
  103ac5:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103ac8:	83 ec 0c             	sub    $0xc,%esp
  103acb:	ff 75 f4             	pushl  -0xc(%ebp)
  103ace:	e8 8d ef ff ff       	call   102a60 <page_ref>
  103ad3:	83 c4 10             	add    $0x10,%esp
  103ad6:	83 f8 01             	cmp    $0x1,%eax
  103ad9:	74 19                	je     103af4 <check_pgdir+0x453>
  103adb:	68 93 65 10 00       	push   $0x106593
  103ae0:	68 4d 64 10 00       	push   $0x10644d
  103ae5:	68 3b 02 00 00       	push   $0x23b
  103aea:	68 28 64 10 00       	push   $0x106428
  103aef:	e8 e1 c8 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 0);
  103af4:	83 ec 0c             	sub    $0xc,%esp
  103af7:	ff 75 e4             	pushl  -0x1c(%ebp)
  103afa:	e8 61 ef ff ff       	call   102a60 <page_ref>
  103aff:	83 c4 10             	add    $0x10,%esp
  103b02:	85 c0                	test   %eax,%eax
  103b04:	74 19                	je     103b1f <check_pgdir+0x47e>
  103b06:	68 ba 66 10 00       	push   $0x1066ba
  103b0b:	68 4d 64 10 00       	push   $0x10644d
  103b10:	68 3c 02 00 00       	push   $0x23c
  103b15:	68 28 64 10 00       	push   $0x106428
  103b1a:	e8 b6 c8 ff ff       	call   1003d5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103b1f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b24:	83 ec 08             	sub    $0x8,%esp
  103b27:	68 00 10 00 00       	push   $0x1000
  103b2c:	50                   	push   %eax
  103b2d:	e8 0a fa ff ff       	call   10353c <page_remove>
  103b32:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103b35:	83 ec 0c             	sub    $0xc,%esp
  103b38:	ff 75 f4             	pushl  -0xc(%ebp)
  103b3b:	e8 20 ef ff ff       	call   102a60 <page_ref>
  103b40:	83 c4 10             	add    $0x10,%esp
  103b43:	85 c0                	test   %eax,%eax
  103b45:	74 19                	je     103b60 <check_pgdir+0x4bf>
  103b47:	68 e1 66 10 00       	push   $0x1066e1
  103b4c:	68 4d 64 10 00       	push   $0x10644d
  103b51:	68 3f 02 00 00       	push   $0x23f
  103b56:	68 28 64 10 00       	push   $0x106428
  103b5b:	e8 75 c8 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p2) == 0);
  103b60:	83 ec 0c             	sub    $0xc,%esp
  103b63:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b66:	e8 f5 ee ff ff       	call   102a60 <page_ref>
  103b6b:	83 c4 10             	add    $0x10,%esp
  103b6e:	85 c0                	test   %eax,%eax
  103b70:	74 19                	je     103b8b <check_pgdir+0x4ea>
  103b72:	68 ba 66 10 00       	push   $0x1066ba
  103b77:	68 4d 64 10 00       	push   $0x10644d
  103b7c:	68 40 02 00 00       	push   $0x240
  103b81:	68 28 64 10 00       	push   $0x106428
  103b86:	e8 4a c8 ff ff       	call   1003d5 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103b8b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b90:	8b 00                	mov    (%eax),%eax
  103b92:	83 ec 0c             	sub    $0xc,%esp
  103b95:	50                   	push   %eax
  103b96:	e8 a9 ee ff ff       	call   102a44 <pde2page>
  103b9b:	83 c4 10             	add    $0x10,%esp
  103b9e:	83 ec 0c             	sub    $0xc,%esp
  103ba1:	50                   	push   %eax
  103ba2:	e8 b9 ee ff ff       	call   102a60 <page_ref>
  103ba7:	83 c4 10             	add    $0x10,%esp
  103baa:	83 f8 01             	cmp    $0x1,%eax
  103bad:	74 19                	je     103bc8 <check_pgdir+0x527>
  103baf:	68 f4 66 10 00       	push   $0x1066f4
  103bb4:	68 4d 64 10 00       	push   $0x10644d
  103bb9:	68 42 02 00 00       	push   $0x242
  103bbe:	68 28 64 10 00       	push   $0x106428
  103bc3:	e8 0d c8 ff ff       	call   1003d5 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103bc8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bcd:	8b 00                	mov    (%eax),%eax
  103bcf:	83 ec 0c             	sub    $0xc,%esp
  103bd2:	50                   	push   %eax
  103bd3:	e8 6c ee ff ff       	call   102a44 <pde2page>
  103bd8:	83 c4 10             	add    $0x10,%esp
  103bdb:	83 ec 08             	sub    $0x8,%esp
  103bde:	6a 01                	push   $0x1
  103be0:	50                   	push   %eax
  103be1:	e8 c6 f0 ff ff       	call   102cac <free_pages>
  103be6:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103be9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103bf4:	83 ec 0c             	sub    $0xc,%esp
  103bf7:	68 1b 67 10 00       	push   $0x10671b
  103bfc:	e8 6e c6 ff ff       	call   10026f <cprintf>
  103c01:	83 c4 10             	add    $0x10,%esp
}
  103c04:	90                   	nop
  103c05:	c9                   	leave  
  103c06:	c3                   	ret    

00103c07 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103c07:	55                   	push   %ebp
  103c08:	89 e5                	mov    %esp,%ebp
  103c0a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c14:	e9 a3 00 00 00       	jmp    103cbc <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c22:	c1 e8 0c             	shr    $0xc,%eax
  103c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103c28:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c2d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103c30:	72 17                	jb     103c49 <check_boot_pgdir+0x42>
  103c32:	ff 75 f0             	pushl  -0x10(%ebp)
  103c35:	68 60 63 10 00       	push   $0x106360
  103c3a:	68 4e 02 00 00       	push   $0x24e
  103c3f:	68 28 64 10 00       	push   $0x106428
  103c44:	e8 8c c7 ff ff       	call   1003d5 <__panic>
  103c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c4c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103c51:	89 c2                	mov    %eax,%edx
  103c53:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c58:	83 ec 04             	sub    $0x4,%esp
  103c5b:	6a 00                	push   $0x0
  103c5d:	52                   	push   %edx
  103c5e:	50                   	push   %eax
  103c5f:	e8 d2 f6 ff ff       	call   103336 <get_pte>
  103c64:	83 c4 10             	add    $0x10,%esp
  103c67:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103c6a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103c6e:	75 19                	jne    103c89 <check_boot_pgdir+0x82>
  103c70:	68 38 67 10 00       	push   $0x106738
  103c75:	68 4d 64 10 00       	push   $0x10644d
  103c7a:	68 4e 02 00 00       	push   $0x24e
  103c7f:	68 28 64 10 00       	push   $0x106428
  103c84:	e8 4c c7 ff ff       	call   1003d5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103c89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103c8c:	8b 00                	mov    (%eax),%eax
  103c8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c93:	89 c2                	mov    %eax,%edx
  103c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c98:	39 c2                	cmp    %eax,%edx
  103c9a:	74 19                	je     103cb5 <check_boot_pgdir+0xae>
  103c9c:	68 75 67 10 00       	push   $0x106775
  103ca1:	68 4d 64 10 00       	push   $0x10644d
  103ca6:	68 4f 02 00 00       	push   $0x24f
  103cab:	68 28 64 10 00       	push   $0x106428
  103cb0:	e8 20 c7 ff ff       	call   1003d5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103cb5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103cbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103cbf:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103cc4:	39 c2                	cmp    %eax,%edx
  103cc6:	0f 82 4d ff ff ff    	jb     103c19 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103ccc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103cd1:	05 ac 0f 00 00       	add    $0xfac,%eax
  103cd6:	8b 00                	mov    (%eax),%eax
  103cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cdd:	89 c2                	mov    %eax,%edx
  103cdf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ce4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ce7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103cee:	77 17                	ja     103d07 <check_boot_pgdir+0x100>
  103cf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  103cf3:	68 04 64 10 00       	push   $0x106404
  103cf8:	68 52 02 00 00       	push   $0x252
  103cfd:	68 28 64 10 00       	push   $0x106428
  103d02:	e8 ce c6 ff ff       	call   1003d5 <__panic>
  103d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d0a:	05 00 00 00 40       	add    $0x40000000,%eax
  103d0f:	39 c2                	cmp    %eax,%edx
  103d11:	74 19                	je     103d2c <check_boot_pgdir+0x125>
  103d13:	68 8c 67 10 00       	push   $0x10678c
  103d18:	68 4d 64 10 00       	push   $0x10644d
  103d1d:	68 52 02 00 00       	push   $0x252
  103d22:	68 28 64 10 00       	push   $0x106428
  103d27:	e8 a9 c6 ff ff       	call   1003d5 <__panic>

    assert(boot_pgdir[0] == 0);
  103d2c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d31:	8b 00                	mov    (%eax),%eax
  103d33:	85 c0                	test   %eax,%eax
  103d35:	74 19                	je     103d50 <check_boot_pgdir+0x149>
  103d37:	68 c0 67 10 00       	push   $0x1067c0
  103d3c:	68 4d 64 10 00       	push   $0x10644d
  103d41:	68 54 02 00 00       	push   $0x254
  103d46:	68 28 64 10 00       	push   $0x106428
  103d4b:	e8 85 c6 ff ff       	call   1003d5 <__panic>

    struct Page *p;
    p = alloc_page();
  103d50:	83 ec 0c             	sub    $0xc,%esp
  103d53:	6a 01                	push   $0x1
  103d55:	e8 14 ef ff ff       	call   102c6e <alloc_pages>
  103d5a:	83 c4 10             	add    $0x10,%esp
  103d5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103d60:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103d65:	6a 02                	push   $0x2
  103d67:	68 00 01 00 00       	push   $0x100
  103d6c:	ff 75 e0             	pushl  -0x20(%ebp)
  103d6f:	50                   	push   %eax
  103d70:	e8 00 f8 ff ff       	call   103575 <page_insert>
  103d75:	83 c4 10             	add    $0x10,%esp
  103d78:	85 c0                	test   %eax,%eax
  103d7a:	74 19                	je     103d95 <check_boot_pgdir+0x18e>
  103d7c:	68 d4 67 10 00       	push   $0x1067d4
  103d81:	68 4d 64 10 00       	push   $0x10644d
  103d86:	68 58 02 00 00       	push   $0x258
  103d8b:	68 28 64 10 00       	push   $0x106428
  103d90:	e8 40 c6 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p) == 1);
  103d95:	83 ec 0c             	sub    $0xc,%esp
  103d98:	ff 75 e0             	pushl  -0x20(%ebp)
  103d9b:	e8 c0 ec ff ff       	call   102a60 <page_ref>
  103da0:	83 c4 10             	add    $0x10,%esp
  103da3:	83 f8 01             	cmp    $0x1,%eax
  103da6:	74 19                	je     103dc1 <check_boot_pgdir+0x1ba>
  103da8:	68 02 68 10 00       	push   $0x106802
  103dad:	68 4d 64 10 00       	push   $0x10644d
  103db2:	68 59 02 00 00       	push   $0x259
  103db7:	68 28 64 10 00       	push   $0x106428
  103dbc:	e8 14 c6 ff ff       	call   1003d5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103dc1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103dc6:	6a 02                	push   $0x2
  103dc8:	68 00 11 00 00       	push   $0x1100
  103dcd:	ff 75 e0             	pushl  -0x20(%ebp)
  103dd0:	50                   	push   %eax
  103dd1:	e8 9f f7 ff ff       	call   103575 <page_insert>
  103dd6:	83 c4 10             	add    $0x10,%esp
  103dd9:	85 c0                	test   %eax,%eax
  103ddb:	74 19                	je     103df6 <check_boot_pgdir+0x1ef>
  103ddd:	68 14 68 10 00       	push   $0x106814
  103de2:	68 4d 64 10 00       	push   $0x10644d
  103de7:	68 5a 02 00 00       	push   $0x25a
  103dec:	68 28 64 10 00       	push   $0x106428
  103df1:	e8 df c5 ff ff       	call   1003d5 <__panic>
    assert(page_ref(p) == 2);
  103df6:	83 ec 0c             	sub    $0xc,%esp
  103df9:	ff 75 e0             	pushl  -0x20(%ebp)
  103dfc:	e8 5f ec ff ff       	call   102a60 <page_ref>
  103e01:	83 c4 10             	add    $0x10,%esp
  103e04:	83 f8 02             	cmp    $0x2,%eax
  103e07:	74 19                	je     103e22 <check_boot_pgdir+0x21b>
  103e09:	68 4b 68 10 00       	push   $0x10684b
  103e0e:	68 4d 64 10 00       	push   $0x10644d
  103e13:	68 5b 02 00 00       	push   $0x25b
  103e18:	68 28 64 10 00       	push   $0x106428
  103e1d:	e8 b3 c5 ff ff       	call   1003d5 <__panic>

    const char *str = "ucore: Hello world!!";
  103e22:	c7 45 dc 5c 68 10 00 	movl   $0x10685c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103e29:	83 ec 08             	sub    $0x8,%esp
  103e2c:	ff 75 dc             	pushl  -0x24(%ebp)
  103e2f:	68 00 01 00 00       	push   $0x100
  103e34:	e8 66 13 00 00       	call   10519f <strcpy>
  103e39:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103e3c:	83 ec 08             	sub    $0x8,%esp
  103e3f:	68 00 11 00 00       	push   $0x1100
  103e44:	68 00 01 00 00       	push   $0x100
  103e49:	e8 cb 13 00 00       	call   105219 <strcmp>
  103e4e:	83 c4 10             	add    $0x10,%esp
  103e51:	85 c0                	test   %eax,%eax
  103e53:	74 19                	je     103e6e <check_boot_pgdir+0x267>
  103e55:	68 74 68 10 00       	push   $0x106874
  103e5a:	68 4d 64 10 00       	push   $0x10644d
  103e5f:	68 5f 02 00 00       	push   $0x25f
  103e64:	68 28 64 10 00       	push   $0x106428
  103e69:	e8 67 c5 ff ff       	call   1003d5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103e6e:	83 ec 0c             	sub    $0xc,%esp
  103e71:	ff 75 e0             	pushl  -0x20(%ebp)
  103e74:	e8 4c eb ff ff       	call   1029c5 <page2kva>
  103e79:	83 c4 10             	add    $0x10,%esp
  103e7c:	05 00 01 00 00       	add    $0x100,%eax
  103e81:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103e84:	83 ec 0c             	sub    $0xc,%esp
  103e87:	68 00 01 00 00       	push   $0x100
  103e8c:	e8 b6 12 00 00       	call   105147 <strlen>
  103e91:	83 c4 10             	add    $0x10,%esp
  103e94:	85 c0                	test   %eax,%eax
  103e96:	74 19                	je     103eb1 <check_boot_pgdir+0x2aa>
  103e98:	68 ac 68 10 00       	push   $0x1068ac
  103e9d:	68 4d 64 10 00       	push   $0x10644d
  103ea2:	68 62 02 00 00       	push   $0x262
  103ea7:	68 28 64 10 00       	push   $0x106428
  103eac:	e8 24 c5 ff ff       	call   1003d5 <__panic>

    free_page(p);
  103eb1:	83 ec 08             	sub    $0x8,%esp
  103eb4:	6a 01                	push   $0x1
  103eb6:	ff 75 e0             	pushl  -0x20(%ebp)
  103eb9:	e8 ee ed ff ff       	call   102cac <free_pages>
  103ebe:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  103ec1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ec6:	8b 00                	mov    (%eax),%eax
  103ec8:	83 ec 0c             	sub    $0xc,%esp
  103ecb:	50                   	push   %eax
  103ecc:	e8 73 eb ff ff       	call   102a44 <pde2page>
  103ed1:	83 c4 10             	add    $0x10,%esp
  103ed4:	83 ec 08             	sub    $0x8,%esp
  103ed7:	6a 01                	push   $0x1
  103ed9:	50                   	push   %eax
  103eda:	e8 cd ed ff ff       	call   102cac <free_pages>
  103edf:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103ee2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103eed:	83 ec 0c             	sub    $0xc,%esp
  103ef0:	68 d0 68 10 00       	push   $0x1068d0
  103ef5:	e8 75 c3 ff ff       	call   10026f <cprintf>
  103efa:	83 c4 10             	add    $0x10,%esp
}
  103efd:	90                   	nop
  103efe:	c9                   	leave  
  103eff:	c3                   	ret    

00103f00 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103f00:	55                   	push   %ebp
  103f01:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103f03:	8b 45 08             	mov    0x8(%ebp),%eax
  103f06:	83 e0 04             	and    $0x4,%eax
  103f09:	85 c0                	test   %eax,%eax
  103f0b:	74 07                	je     103f14 <perm2str+0x14>
  103f0d:	b8 75 00 00 00       	mov    $0x75,%eax
  103f12:	eb 05                	jmp    103f19 <perm2str+0x19>
  103f14:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103f19:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  103f1e:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103f25:	8b 45 08             	mov    0x8(%ebp),%eax
  103f28:	83 e0 02             	and    $0x2,%eax
  103f2b:	85 c0                	test   %eax,%eax
  103f2d:	74 07                	je     103f36 <perm2str+0x36>
  103f2f:	b8 77 00 00 00       	mov    $0x77,%eax
  103f34:	eb 05                	jmp    103f3b <perm2str+0x3b>
  103f36:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103f3b:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  103f40:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  103f47:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  103f4c:	5d                   	pop    %ebp
  103f4d:	c3                   	ret    

00103f4e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103f4e:	55                   	push   %ebp
  103f4f:	89 e5                	mov    %esp,%ebp
  103f51:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103f54:	8b 45 10             	mov    0x10(%ebp),%eax
  103f57:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f5a:	72 0e                	jb     103f6a <get_pgtable_items+0x1c>
        return 0;
  103f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  103f61:	e9 9a 00 00 00       	jmp    104000 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103f66:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  103f6d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f70:	73 18                	jae    103f8a <get_pgtable_items+0x3c>
  103f72:	8b 45 10             	mov    0x10(%ebp),%eax
  103f75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103f7c:	8b 45 14             	mov    0x14(%ebp),%eax
  103f7f:	01 d0                	add    %edx,%eax
  103f81:	8b 00                	mov    (%eax),%eax
  103f83:	83 e0 01             	and    $0x1,%eax
  103f86:	85 c0                	test   %eax,%eax
  103f88:	74 dc                	je     103f66 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  103f8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103f90:	73 69                	jae    103ffb <get_pgtable_items+0xad>
        if (left_store != NULL) {
  103f92:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103f96:	74 08                	je     103fa0 <get_pgtable_items+0x52>
            *left_store = start;
  103f98:	8b 45 18             	mov    0x18(%ebp),%eax
  103f9b:	8b 55 10             	mov    0x10(%ebp),%edx
  103f9e:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  103fa3:	8d 50 01             	lea    0x1(%eax),%edx
  103fa6:	89 55 10             	mov    %edx,0x10(%ebp)
  103fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  103fb3:	01 d0                	add    %edx,%eax
  103fb5:	8b 00                	mov    (%eax),%eax
  103fb7:	83 e0 07             	and    $0x7,%eax
  103fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103fbd:	eb 04                	jmp    103fc3 <get_pgtable_items+0x75>
            start ++;
  103fbf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  103fc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fc9:	73 1d                	jae    103fe8 <get_pgtable_items+0x9a>
  103fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  103fce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103fd5:	8b 45 14             	mov    0x14(%ebp),%eax
  103fd8:	01 d0                	add    %edx,%eax
  103fda:	8b 00                	mov    (%eax),%eax
  103fdc:	83 e0 07             	and    $0x7,%eax
  103fdf:	89 c2                	mov    %eax,%edx
  103fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103fe4:	39 c2                	cmp    %eax,%edx
  103fe6:	74 d7                	je     103fbf <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  103fe8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103fec:	74 08                	je     103ff6 <get_pgtable_items+0xa8>
            *right_store = start;
  103fee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103ff1:	8b 55 10             	mov    0x10(%ebp),%edx
  103ff4:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  103ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103ff9:	eb 05                	jmp    104000 <get_pgtable_items+0xb2>
    }
    return 0;
  103ffb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104000:	c9                   	leave  
  104001:	c3                   	ret    

00104002 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104002:	55                   	push   %ebp
  104003:	89 e5                	mov    %esp,%ebp
  104005:	57                   	push   %edi
  104006:	56                   	push   %esi
  104007:	53                   	push   %ebx
  104008:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10400b:	83 ec 0c             	sub    $0xc,%esp
  10400e:	68 f0 68 10 00       	push   $0x1068f0
  104013:	e8 57 c2 ff ff       	call   10026f <cprintf>
  104018:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  10401b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104022:	e9 e5 00 00 00       	jmp    10410c <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10402a:	83 ec 0c             	sub    $0xc,%esp
  10402d:	50                   	push   %eax
  10402e:	e8 cd fe ff ff       	call   103f00 <perm2str>
  104033:	83 c4 10             	add    $0x10,%esp
  104036:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104038:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10403b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10403e:	29 c2                	sub    %eax,%edx
  104040:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104042:	c1 e0 16             	shl    $0x16,%eax
  104045:	89 c3                	mov    %eax,%ebx
  104047:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10404a:	c1 e0 16             	shl    $0x16,%eax
  10404d:	89 c1                	mov    %eax,%ecx
  10404f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104052:	c1 e0 16             	shl    $0x16,%eax
  104055:	89 c2                	mov    %eax,%edx
  104057:	8b 75 dc             	mov    -0x24(%ebp),%esi
  10405a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10405d:	29 c6                	sub    %eax,%esi
  10405f:	89 f0                	mov    %esi,%eax
  104061:	83 ec 08             	sub    $0x8,%esp
  104064:	57                   	push   %edi
  104065:	53                   	push   %ebx
  104066:	51                   	push   %ecx
  104067:	52                   	push   %edx
  104068:	50                   	push   %eax
  104069:	68 21 69 10 00       	push   $0x106921
  10406e:	e8 fc c1 ff ff       	call   10026f <cprintf>
  104073:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  104076:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104079:	c1 e0 0a             	shl    $0xa,%eax
  10407c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10407f:	eb 4f                	jmp    1040d0 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104084:	83 ec 0c             	sub    $0xc,%esp
  104087:	50                   	push   %eax
  104088:	e8 73 fe ff ff       	call   103f00 <perm2str>
  10408d:	83 c4 10             	add    $0x10,%esp
  104090:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104092:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104095:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104098:	29 c2                	sub    %eax,%edx
  10409a:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10409c:	c1 e0 0c             	shl    $0xc,%eax
  10409f:	89 c3                	mov    %eax,%ebx
  1040a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1040a4:	c1 e0 0c             	shl    $0xc,%eax
  1040a7:	89 c1                	mov    %eax,%ecx
  1040a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040ac:	c1 e0 0c             	shl    $0xc,%eax
  1040af:	89 c2                	mov    %eax,%edx
  1040b1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  1040b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040b7:	29 c6                	sub    %eax,%esi
  1040b9:	89 f0                	mov    %esi,%eax
  1040bb:	83 ec 08             	sub    $0x8,%esp
  1040be:	57                   	push   %edi
  1040bf:	53                   	push   %ebx
  1040c0:	51                   	push   %ecx
  1040c1:	52                   	push   %edx
  1040c2:	50                   	push   %eax
  1040c3:	68 40 69 10 00       	push   $0x106940
  1040c8:	e8 a2 c1 ff ff       	call   10026f <cprintf>
  1040cd:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1040d0:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1040d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1040d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040db:	89 d3                	mov    %edx,%ebx
  1040dd:	c1 e3 0a             	shl    $0xa,%ebx
  1040e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1040e3:	89 d1                	mov    %edx,%ecx
  1040e5:	c1 e1 0a             	shl    $0xa,%ecx
  1040e8:	83 ec 08             	sub    $0x8,%esp
  1040eb:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1040ee:	52                   	push   %edx
  1040ef:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1040f2:	52                   	push   %edx
  1040f3:	56                   	push   %esi
  1040f4:	50                   	push   %eax
  1040f5:	53                   	push   %ebx
  1040f6:	51                   	push   %ecx
  1040f7:	e8 52 fe ff ff       	call   103f4e <get_pgtable_items>
  1040fc:	83 c4 20             	add    $0x20,%esp
  1040ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104102:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104106:	0f 85 75 ff ff ff    	jne    104081 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10410c:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104111:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104114:	83 ec 08             	sub    $0x8,%esp
  104117:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10411a:	52                   	push   %edx
  10411b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10411e:	52                   	push   %edx
  10411f:	51                   	push   %ecx
  104120:	50                   	push   %eax
  104121:	68 00 04 00 00       	push   $0x400
  104126:	6a 00                	push   $0x0
  104128:	e8 21 fe ff ff       	call   103f4e <get_pgtable_items>
  10412d:	83 c4 20             	add    $0x20,%esp
  104130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104133:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104137:	0f 85 ea fe ff ff    	jne    104027 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10413d:	83 ec 0c             	sub    $0xc,%esp
  104140:	68 64 69 10 00       	push   $0x106964
  104145:	e8 25 c1 ff ff       	call   10026f <cprintf>
  10414a:	83 c4 10             	add    $0x10,%esp
}
  10414d:	90                   	nop
  10414e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  104151:	5b                   	pop    %ebx
  104152:	5e                   	pop    %esi
  104153:	5f                   	pop    %edi
  104154:	5d                   	pop    %ebp
  104155:	c3                   	ret    

00104156 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104156:	55                   	push   %ebp
  104157:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104159:	8b 45 08             	mov    0x8(%ebp),%eax
  10415c:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  104162:	29 d0                	sub    %edx,%eax
  104164:	c1 f8 02             	sar    $0x2,%eax
  104167:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10416d:	5d                   	pop    %ebp
  10416e:	c3                   	ret    

0010416f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10416f:	55                   	push   %ebp
  104170:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  104172:	ff 75 08             	pushl  0x8(%ebp)
  104175:	e8 dc ff ff ff       	call   104156 <page2ppn>
  10417a:	83 c4 04             	add    $0x4,%esp
  10417d:	c1 e0 0c             	shl    $0xc,%eax
}
  104180:	c9                   	leave  
  104181:	c3                   	ret    

00104182 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  104182:	55                   	push   %ebp
  104183:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104185:	8b 45 08             	mov    0x8(%ebp),%eax
  104188:	8b 00                	mov    (%eax),%eax
}
  10418a:	5d                   	pop    %ebp
  10418b:	c3                   	ret    

0010418c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10418c:	55                   	push   %ebp
  10418d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10418f:	8b 45 08             	mov    0x8(%ebp),%eax
  104192:	8b 55 0c             	mov    0xc(%ebp),%edx
  104195:	89 10                	mov    %edx,(%eax)
}
  104197:	90                   	nop
  104198:	5d                   	pop    %ebp
  104199:	c3                   	ret    

0010419a <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10419a:	55                   	push   %ebp
  10419b:	89 e5                	mov    %esp,%ebp
  10419d:	83 ec 10             	sub    $0x10,%esp
  1041a0:	c7 45 fc bc 89 11 00 	movl   $0x1189bc,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1041a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1041ad:	89 50 04             	mov    %edx,0x4(%eax)
  1041b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041b3:	8b 50 04             	mov    0x4(%eax),%edx
  1041b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041b9:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1041bb:	c7 05 c4 89 11 00 00 	movl   $0x0,0x1189c4
  1041c2:	00 00 00 
}
  1041c5:	90                   	nop
  1041c6:	c9                   	leave  
  1041c7:	c3                   	ret    

001041c8 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1041c8:	55                   	push   %ebp
  1041c9:	89 e5                	mov    %esp,%ebp
  1041cb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1041ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1041d2:	75 16                	jne    1041ea <default_init_memmap+0x22>
  1041d4:	68 98 69 10 00       	push   $0x106998
  1041d9:	68 9e 69 10 00       	push   $0x10699e
  1041de:	6a 6d                	push   $0x6d
  1041e0:	68 b3 69 10 00       	push   $0x1069b3
  1041e5:	e8 eb c1 ff ff       	call   1003d5 <__panic>
    struct Page *p = base;
  1041ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1041ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1041f0:	eb 6c                	jmp    10425e <default_init_memmap+0x96>
        assert(PageReserved(p));
  1041f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041f5:	83 c0 04             	add    $0x4,%eax
  1041f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1041ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104205:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104208:	0f a3 10             	bt     %edx,(%eax)
  10420b:	19 c0                	sbb    %eax,%eax
  10420d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  104210:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104214:	0f 95 c0             	setne  %al
  104217:	0f b6 c0             	movzbl %al,%eax
  10421a:	85 c0                	test   %eax,%eax
  10421c:	75 16                	jne    104234 <default_init_memmap+0x6c>
  10421e:	68 c9 69 10 00       	push   $0x1069c9
  104223:	68 9e 69 10 00       	push   $0x10699e
  104228:	6a 70                	push   $0x70
  10422a:	68 b3 69 10 00       	push   $0x1069b3
  10422f:	e8 a1 c1 ff ff       	call   1003d5 <__panic>
        p->flags = p->property = 0;     // set all following pages as "not the head page"
  104234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104237:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10423e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104241:	8b 50 08             	mov    0x8(%eax),%edx
  104244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104247:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10424a:	83 ec 08             	sub    $0x8,%esp
  10424d:	6a 00                	push   $0x0
  10424f:	ff 75 f4             	pushl  -0xc(%ebp)
  104252:	e8 35 ff ff ff       	call   10418c <set_page_ref>
  104257:	83 c4 10             	add    $0x10,%esp

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  10425a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10425e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104261:	89 d0                	mov    %edx,%eax
  104263:	c1 e0 02             	shl    $0x2,%eax
  104266:	01 d0                	add    %edx,%eax
  104268:	c1 e0 02             	shl    $0x2,%eax
  10426b:	89 c2                	mov    %eax,%edx
  10426d:	8b 45 08             	mov    0x8(%ebp),%eax
  104270:	01 d0                	add    %edx,%eax
  104272:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104275:	0f 85 77 ff ff ff    	jne    1041f2 <default_init_memmap+0x2a>
        assert(PageReserved(p));
        p->flags = p->property = 0;     // set all following pages as "not the head page"
        set_page_ref(p, 0);
    }
    base->property = n;
  10427b:	8b 45 08             	mov    0x8(%ebp),%eax
  10427e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104281:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);              // mark as the head page
  104284:	8b 45 08             	mov    0x8(%ebp),%eax
  104287:	83 c0 04             	add    $0x4,%eax
  10428a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  104291:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104294:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104297:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10429a:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  10429d:	8b 15 c4 89 11 00    	mov    0x1189c4,%edx
  1042a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042a6:	01 d0                	add    %edx,%eax
  1042a8:	a3 c4 89 11 00       	mov    %eax,0x1189c4
    list_add(&free_list, &(base->page_link));
  1042ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b0:	83 c0 0c             	add    $0xc,%eax
  1042b3:	c7 45 f0 bc 89 11 00 	movl   $0x1189bc,-0x10(%ebp)
  1042ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1042bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1042c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1042c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1042c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1042cc:	8b 40 04             	mov    0x4(%eax),%eax
  1042cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042d2:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1042d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042d8:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1042db:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1042de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042e1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1042e4:	89 10                	mov    %edx,(%eax)
  1042e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042e9:	8b 10                	mov    (%eax),%edx
  1042eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1042ee:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1042f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1042f7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1042fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104300:	89 10                	mov    %edx,(%eax)
}
  104302:	90                   	nop
  104303:	c9                   	leave  
  104304:	c3                   	ret    

00104305 <default_alloc_pages>:

// MODIFIED need to be rewritten
static struct Page *
default_alloc_pages(size_t n) {
  104305:	55                   	push   %ebp
  104306:	89 e5                	mov    %esp,%ebp
  104308:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10430b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10430f:	75 16                	jne    104327 <default_alloc_pages+0x22>
  104311:	68 98 69 10 00       	push   $0x106998
  104316:	68 9e 69 10 00       	push   $0x10699e
  10431b:	6a 7d                	push   $0x7d
  10431d:	68 b3 69 10 00       	push   $0x1069b3
  104322:	e8 ae c0 ff ff       	call   1003d5 <__panic>
    if (n > nr_free) {
  104327:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  10432c:	3b 45 08             	cmp    0x8(%ebp),%eax
  10432f:	73 0a                	jae    10433b <default_alloc_pages+0x36>
        return NULL;
  104331:	b8 00 00 00 00       	mov    $0x0,%eax
  104336:	e9 48 01 00 00       	jmp    104483 <default_alloc_pages+0x17e>
    }
    struct Page *page = NULL;
  10433b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104342:	c7 45 f0 bc 89 11 00 	movl   $0x1189bc,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104349:	eb 1c                	jmp    104367 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
  10434b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10434e:	83 e8 0c             	sub    $0xc,%eax
  104351:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  104354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104357:	8b 40 08             	mov    0x8(%eax),%eax
  10435a:	3b 45 08             	cmp    0x8(%ebp),%eax
  10435d:	72 08                	jb     104367 <default_alloc_pages+0x62>
            page = p;
  10435f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104362:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104365:	eb 18                	jmp    10437f <default_alloc_pages+0x7a>
  104367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10436a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10436d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104370:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104373:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104376:	81 7d f0 bc 89 11 00 	cmpl   $0x1189bc,-0x10(%ebp)
  10437d:	75 cc                	jne    10434b <default_alloc_pages+0x46>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  10437f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104383:	0f 84 f7 00 00 00    	je     104480 <default_alloc_pages+0x17b>
  104389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10438c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10438f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104392:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *following_le = list_next(le);
  104395:	89 45 e0             	mov    %eax,-0x20(%ebp)
        list_del(&(page->page_link));
  104398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439b:	83 c0 0c             	add    $0xc,%eax
  10439e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1043a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043a4:	8b 40 04             	mov    0x4(%eax),%eax
  1043a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1043aa:	8b 12                	mov    (%edx),%edx
  1043ac:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1043af:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1043b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1043b5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1043b8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1043bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1043c1:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  1043c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043c6:	8b 40 08             	mov    0x8(%eax),%eax
  1043c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  1043cc:	0f 86 88 00 00 00    	jbe    10445a <default_alloc_pages+0x155>
            struct Page *p = page + n;                      // split the allocated page
  1043d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1043d5:	89 d0                	mov    %edx,%eax
  1043d7:	c1 e0 02             	shl    $0x2,%eax
  1043da:	01 d0                	add    %edx,%eax
  1043dc:	c1 e0 02             	shl    $0x2,%eax
  1043df:	89 c2                	mov    %eax,%edx
  1043e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043e4:	01 d0                	add    %edx,%eax
  1043e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;               // set page num
  1043e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043ec:	8b 40 08             	mov    0x8(%eax),%eax
  1043ef:	2b 45 08             	sub    0x8(%ebp),%eax
  1043f2:	89 c2                	mov    %eax,%edx
  1043f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1043f7:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);                             // mark as the head page
  1043fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1043fd:	83 c0 04             	add    $0x4,%eax
  104400:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104407:	89 45 b0             	mov    %eax,-0x50(%ebp)
  10440a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10440d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104410:	0f ab 10             	bts    %edx,(%eax)
            // list_add(&free_list, &(p->page_link));
            list_add_before(following_le, &(p->page_link)); // add the remaining block before the formerly following block
  104413:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104416:	8d 50 0c             	lea    0xc(%eax),%edx
  104419:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10441c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10441f:	89 55 c0             	mov    %edx,-0x40(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104425:	8b 00                	mov    (%eax),%eax
  104427:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10442a:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10442d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104433:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104436:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104439:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10443c:	89 10                	mov    %edx,(%eax)
  10443e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104441:	8b 10                	mov    (%eax),%edx
  104443:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104446:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104449:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10444c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10444f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104452:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104455:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104458:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
  10445a:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  10445f:	2b 45 08             	sub    0x8(%ebp),%eax
  104462:	a3 c4 89 11 00       	mov    %eax,0x1189c4
        ClearPageProperty(page);    // mark as "not head page"
  104467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10446a:	83 c0 04             	add    $0x4,%eax
  10446d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104474:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104477:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10447a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10447d:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104483:	c9                   	leave  
  104484:	c3                   	ret    

00104485 <default_free_pages>:

// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
  104485:	55                   	push   %ebp
  104486:	89 e5                	mov    %esp,%ebp
  104488:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  10448e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104492:	75 19                	jne    1044ad <default_free_pages+0x28>
  104494:	68 98 69 10 00       	push   $0x106998
  104499:	68 9e 69 10 00       	push   $0x10699e
  10449e:	68 9d 00 00 00       	push   $0x9d
  1044a3:	68 b3 69 10 00       	push   $0x1069b3
  1044a8:	e8 28 bf ff ff       	call   1003d5 <__panic>
    struct Page *p = base;
  1044ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1044b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1044b3:	e9 8f 00 00 00       	jmp    104547 <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
  1044b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044bb:	83 c0 04             	add    $0x4,%eax
  1044be:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  1044c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1044c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1044cb:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1044ce:	0f a3 10             	bt     %edx,(%eax)
  1044d1:	19 c0                	sbb    %eax,%eax
  1044d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1044d6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1044da:	0f 95 c0             	setne  %al
  1044dd:	0f b6 c0             	movzbl %al,%eax
  1044e0:	85 c0                	test   %eax,%eax
  1044e2:	75 2c                	jne    104510 <default_free_pages+0x8b>
  1044e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e7:	83 c0 04             	add    $0x4,%eax
  1044ea:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  1044f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1044f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1044f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1044fa:	0f a3 10             	bt     %edx,(%eax)
  1044fd:	19 c0                	sbb    %eax,%eax
  1044ff:	89 45 b0             	mov    %eax,-0x50(%ebp)
    return oldbit != 0;
  104502:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  104506:	0f 95 c0             	setne  %al
  104509:	0f b6 c0             	movzbl %al,%eax
  10450c:	85 c0                	test   %eax,%eax
  10450e:	74 19                	je     104529 <default_free_pages+0xa4>
  104510:	68 dc 69 10 00       	push   $0x1069dc
  104515:	68 9e 69 10 00       	push   $0x10699e
  10451a:	68 a0 00 00 00       	push   $0xa0
  10451f:	68 b3 69 10 00       	push   $0x1069b3
  104524:	e8 ac be ff ff       	call   1003d5 <__panic>
        p->flags = 0;
  104529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);     // clear ref flag
  104533:	83 ec 08             	sub    $0x8,%esp
  104536:	6a 00                	push   $0x0
  104538:	ff 75 f4             	pushl  -0xc(%ebp)
  10453b:	e8 4c fc ff ff       	call   10418c <set_page_ref>
  104540:	83 c4 10             	add    $0x10,%esp
// MODIFIED
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  104543:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104547:	8b 55 0c             	mov    0xc(%ebp),%edx
  10454a:	89 d0                	mov    %edx,%eax
  10454c:	c1 e0 02             	shl    $0x2,%eax
  10454f:	01 d0                	add    %edx,%eax
  104551:	c1 e0 02             	shl    $0x2,%eax
  104554:	89 c2                	mov    %eax,%edx
  104556:	8b 45 08             	mov    0x8(%ebp),%eax
  104559:	01 d0                	add    %edx,%eax
  10455b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10455e:	0f 85 54 ff ff ff    	jne    1044b8 <default_free_pages+0x33>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);     // clear ref flag
    }
    base->property = n;
  104564:	8b 45 08             	mov    0x8(%ebp),%eax
  104567:	8b 55 0c             	mov    0xc(%ebp),%edx
  10456a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10456d:	8b 45 08             	mov    0x8(%ebp),%eax
  104570:	83 c0 04             	add    $0x4,%eax
  104573:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10457a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10457d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104580:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104583:	0f ab 10             	bts    %edx,(%eax)
  104586:	c7 45 e8 bc 89 11 00 	movl   $0x1189bc,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10458d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104590:	8b 40 04             	mov    0x4(%eax),%eax

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
  104593:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104596:	e9 1f 01 00 00       	jmp    1046ba <default_free_pages+0x235>
        p = le2page(le, page_link);
  10459b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10459e:	83 e8 0c             	sub    $0xc,%eax
  1045a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045ad:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1045b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // page is exactly before one page
        if (base + base->property == p) {
  1045b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b6:	8b 50 08             	mov    0x8(%eax),%edx
  1045b9:	89 d0                	mov    %edx,%eax
  1045bb:	c1 e0 02             	shl    $0x2,%eax
  1045be:	01 d0                	add    %edx,%eax
  1045c0:	c1 e0 02             	shl    $0x2,%eax
  1045c3:	89 c2                	mov    %eax,%edx
  1045c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1045c8:	01 d0                	add    %edx,%eax
  1045ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1045cd:	75 67                	jne    104636 <default_free_pages+0x1b1>
            base->property += p->property;
  1045cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d2:	8b 50 08             	mov    0x8(%eax),%edx
  1045d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045d8:	8b 40 08             	mov    0x8(%eax),%eax
  1045db:	01 c2                	add    %eax,%edx
  1045dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e0:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;     // clear properties of p
  1045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(p);
  1045ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f0:	83 c0 04             	add    $0x4,%eax
  1045f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  1045fa:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1045fd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104600:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104603:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104609:	83 c0 0c             	add    $0xc,%eax
  10460c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  10460f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104612:	8b 40 04             	mov    0x4(%eax),%eax
  104615:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104618:	8b 12                	mov    (%edx),%edx
  10461a:	89 55 a8             	mov    %edx,-0x58(%ebp)
  10461d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104620:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104623:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104626:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104629:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10462c:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10462f:	89 10                	mov    %edx,(%eax)
  104631:	e9 84 00 00 00       	jmp    1046ba <default_free_pages+0x235>
        }
        // page is exactly after one page
        else if (p + p->property == base) {
  104636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104639:	8b 50 08             	mov    0x8(%eax),%edx
  10463c:	89 d0                	mov    %edx,%eax
  10463e:	c1 e0 02             	shl    $0x2,%eax
  104641:	01 d0                	add    %edx,%eax
  104643:	c1 e0 02             	shl    $0x2,%eax
  104646:	89 c2                	mov    %eax,%edx
  104648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10464b:	01 d0                	add    %edx,%eax
  10464d:	3b 45 08             	cmp    0x8(%ebp),%eax
  104650:	75 68                	jne    1046ba <default_free_pages+0x235>
            p->property += base->property;
  104652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104655:	8b 50 08             	mov    0x8(%eax),%edx
  104658:	8b 45 08             	mov    0x8(%ebp),%eax
  10465b:	8b 40 08             	mov    0x8(%eax),%eax
  10465e:	01 c2                	add    %eax,%edx
  104660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104663:	89 50 08             	mov    %edx,0x8(%eax)
            base->property = 0;     // clear properties of base
  104666:	8b 45 08             	mov    0x8(%ebp),%eax
  104669:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            ClearPageProperty(base);
  104670:	8b 45 08             	mov    0x8(%ebp),%eax
  104673:	83 c0 04             	add    $0x4,%eax
  104676:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  10467d:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104680:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104683:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104686:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10468c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  10468f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104692:	83 c0 0c             	add    $0xc,%eax
  104695:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104698:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10469b:	8b 40 04             	mov    0x4(%eax),%eax
  10469e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046a1:	8b 12                	mov    (%edx),%edx
  1046a3:	89 55 9c             	mov    %edx,-0x64(%ebp)
  1046a6:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1046a9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1046ac:	8b 55 98             	mov    -0x68(%ebp),%edx
  1046af:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1046b2:	8b 45 98             	mov    -0x68(%ebp),%eax
  1046b5:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1046b8:	89 10                	mov    %edx,(%eax)
    base->property = n;
    SetPageProperty(base);

    // try to extend free block
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  1046ba:	81 7d f0 bc 89 11 00 	cmpl   $0x1189bc,-0x10(%ebp)
  1046c1:	0f 85 d4 fe ff ff    	jne    10459b <default_free_pages+0x116>
  1046c7:	c7 45 d0 bc 89 11 00 	movl   $0x1189bc,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1046ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1046d1:	8b 40 04             	mov    0x4(%eax),%eax
            list_del(&(p->page_link));
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
  1046d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1046d7:	eb 20                	jmp    1046f9 <default_free_pages+0x274>
        p = le2page(le, page_link);
  1046d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046dc:	83 e8 0c             	sub    $0xc,%eax
  1046df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p > base) {
  1046e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  1046e8:	77 1a                	ja     104704 <default_free_pages+0x27f>
  1046ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1046f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1046f3:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  1046f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    
    // search for a place to add page into list
    le = list_next(&free_list);
    while (le != &free_list) {
  1046f9:	81 7d f0 bc 89 11 00 	cmpl   $0x1189bc,-0x10(%ebp)
  104700:	75 d7                	jne    1046d9 <default_free_pages+0x254>
  104702:	eb 01                	jmp    104705 <default_free_pages+0x280>
        p = le2page(le, page_link);
        if (p > base) {
            break;
  104704:	90                   	nop
        }
        le = list_next(le);
    }
    
    nr_free += n;
  104705:	8b 15 c4 89 11 00    	mov    0x1189c4,%edx
  10470b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10470e:	01 d0                	add    %edx,%eax
  104710:	a3 c4 89 11 00       	mov    %eax,0x1189c4
    // list_add(&free_list, &(base->page_link));
    list_add_before(le, &(base->page_link)); 
  104715:	8b 45 08             	mov    0x8(%ebp),%eax
  104718:	8d 50 0c             	lea    0xc(%eax),%edx
  10471b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10471e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104721:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104724:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104727:	8b 00                	mov    (%eax),%eax
  104729:	8b 55 90             	mov    -0x70(%ebp),%edx
  10472c:	89 55 8c             	mov    %edx,-0x74(%ebp)
  10472f:	89 45 88             	mov    %eax,-0x78(%ebp)
  104732:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104735:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104738:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10473b:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10473e:	89 10                	mov    %edx,(%eax)
  104740:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104743:	8b 10                	mov    (%eax),%edx
  104745:	8b 45 88             	mov    -0x78(%ebp),%eax
  104748:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10474b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10474e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104751:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104754:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104757:	8b 55 88             	mov    -0x78(%ebp),%edx
  10475a:	89 10                	mov    %edx,(%eax)
}
  10475c:	90                   	nop
  10475d:	c9                   	leave  
  10475e:	c3                   	ret    

0010475f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10475f:	55                   	push   %ebp
  104760:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104762:	a1 c4 89 11 00       	mov    0x1189c4,%eax
}
  104767:	5d                   	pop    %ebp
  104768:	c3                   	ret    

00104769 <basic_check>:

static void
basic_check(void) {
  104769:	55                   	push   %ebp
  10476a:	89 e5                	mov    %esp,%ebp
  10476c:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10476f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104779:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10477c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10477f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104782:	83 ec 0c             	sub    $0xc,%esp
  104785:	6a 01                	push   $0x1
  104787:	e8 e2 e4 ff ff       	call   102c6e <alloc_pages>
  10478c:	83 c4 10             	add    $0x10,%esp
  10478f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104792:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104796:	75 19                	jne    1047b1 <basic_check+0x48>
  104798:	68 01 6a 10 00       	push   $0x106a01
  10479d:	68 9e 69 10 00       	push   $0x10699e
  1047a2:	68 d5 00 00 00       	push   $0xd5
  1047a7:	68 b3 69 10 00       	push   $0x1069b3
  1047ac:	e8 24 bc ff ff       	call   1003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1047b1:	83 ec 0c             	sub    $0xc,%esp
  1047b4:	6a 01                	push   $0x1
  1047b6:	e8 b3 e4 ff ff       	call   102c6e <alloc_pages>
  1047bb:	83 c4 10             	add    $0x10,%esp
  1047be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1047c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1047c5:	75 19                	jne    1047e0 <basic_check+0x77>
  1047c7:	68 1d 6a 10 00       	push   $0x106a1d
  1047cc:	68 9e 69 10 00       	push   $0x10699e
  1047d1:	68 d6 00 00 00       	push   $0xd6
  1047d6:	68 b3 69 10 00       	push   $0x1069b3
  1047db:	e8 f5 bb ff ff       	call   1003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1047e0:	83 ec 0c             	sub    $0xc,%esp
  1047e3:	6a 01                	push   $0x1
  1047e5:	e8 84 e4 ff ff       	call   102c6e <alloc_pages>
  1047ea:	83 c4 10             	add    $0x10,%esp
  1047ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1047f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047f4:	75 19                	jne    10480f <basic_check+0xa6>
  1047f6:	68 39 6a 10 00       	push   $0x106a39
  1047fb:	68 9e 69 10 00       	push   $0x10699e
  104800:	68 d7 00 00 00       	push   $0xd7
  104805:	68 b3 69 10 00       	push   $0x1069b3
  10480a:	e8 c6 bb ff ff       	call   1003d5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10480f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104812:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104815:	74 10                	je     104827 <basic_check+0xbe>
  104817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10481a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10481d:	74 08                	je     104827 <basic_check+0xbe>
  10481f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104822:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104825:	75 19                	jne    104840 <basic_check+0xd7>
  104827:	68 58 6a 10 00       	push   $0x106a58
  10482c:	68 9e 69 10 00       	push   $0x10699e
  104831:	68 d9 00 00 00       	push   $0xd9
  104836:	68 b3 69 10 00       	push   $0x1069b3
  10483b:	e8 95 bb ff ff       	call   1003d5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104840:	83 ec 0c             	sub    $0xc,%esp
  104843:	ff 75 ec             	pushl  -0x14(%ebp)
  104846:	e8 37 f9 ff ff       	call   104182 <page_ref>
  10484b:	83 c4 10             	add    $0x10,%esp
  10484e:	85 c0                	test   %eax,%eax
  104850:	75 24                	jne    104876 <basic_check+0x10d>
  104852:	83 ec 0c             	sub    $0xc,%esp
  104855:	ff 75 f0             	pushl  -0x10(%ebp)
  104858:	e8 25 f9 ff ff       	call   104182 <page_ref>
  10485d:	83 c4 10             	add    $0x10,%esp
  104860:	85 c0                	test   %eax,%eax
  104862:	75 12                	jne    104876 <basic_check+0x10d>
  104864:	83 ec 0c             	sub    $0xc,%esp
  104867:	ff 75 f4             	pushl  -0xc(%ebp)
  10486a:	e8 13 f9 ff ff       	call   104182 <page_ref>
  10486f:	83 c4 10             	add    $0x10,%esp
  104872:	85 c0                	test   %eax,%eax
  104874:	74 19                	je     10488f <basic_check+0x126>
  104876:	68 7c 6a 10 00       	push   $0x106a7c
  10487b:	68 9e 69 10 00       	push   $0x10699e
  104880:	68 da 00 00 00       	push   $0xda
  104885:	68 b3 69 10 00       	push   $0x1069b3
  10488a:	e8 46 bb ff ff       	call   1003d5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10488f:	83 ec 0c             	sub    $0xc,%esp
  104892:	ff 75 ec             	pushl  -0x14(%ebp)
  104895:	e8 d5 f8 ff ff       	call   10416f <page2pa>
  10489a:	83 c4 10             	add    $0x10,%esp
  10489d:	89 c2                	mov    %eax,%edx
  10489f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048a4:	c1 e0 0c             	shl    $0xc,%eax
  1048a7:	39 c2                	cmp    %eax,%edx
  1048a9:	72 19                	jb     1048c4 <basic_check+0x15b>
  1048ab:	68 b8 6a 10 00       	push   $0x106ab8
  1048b0:	68 9e 69 10 00       	push   $0x10699e
  1048b5:	68 dc 00 00 00       	push   $0xdc
  1048ba:	68 b3 69 10 00       	push   $0x1069b3
  1048bf:	e8 11 bb ff ff       	call   1003d5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1048c4:	83 ec 0c             	sub    $0xc,%esp
  1048c7:	ff 75 f0             	pushl  -0x10(%ebp)
  1048ca:	e8 a0 f8 ff ff       	call   10416f <page2pa>
  1048cf:	83 c4 10             	add    $0x10,%esp
  1048d2:	89 c2                	mov    %eax,%edx
  1048d4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048d9:	c1 e0 0c             	shl    $0xc,%eax
  1048dc:	39 c2                	cmp    %eax,%edx
  1048de:	72 19                	jb     1048f9 <basic_check+0x190>
  1048e0:	68 d5 6a 10 00       	push   $0x106ad5
  1048e5:	68 9e 69 10 00       	push   $0x10699e
  1048ea:	68 dd 00 00 00       	push   $0xdd
  1048ef:	68 b3 69 10 00       	push   $0x1069b3
  1048f4:	e8 dc ba ff ff       	call   1003d5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1048f9:	83 ec 0c             	sub    $0xc,%esp
  1048fc:	ff 75 f4             	pushl  -0xc(%ebp)
  1048ff:	e8 6b f8 ff ff       	call   10416f <page2pa>
  104904:	83 c4 10             	add    $0x10,%esp
  104907:	89 c2                	mov    %eax,%edx
  104909:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10490e:	c1 e0 0c             	shl    $0xc,%eax
  104911:	39 c2                	cmp    %eax,%edx
  104913:	72 19                	jb     10492e <basic_check+0x1c5>
  104915:	68 f2 6a 10 00       	push   $0x106af2
  10491a:	68 9e 69 10 00       	push   $0x10699e
  10491f:	68 de 00 00 00       	push   $0xde
  104924:	68 b3 69 10 00       	push   $0x1069b3
  104929:	e8 a7 ba ff ff       	call   1003d5 <__panic>

    list_entry_t free_list_store = free_list;
  10492e:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104933:	8b 15 c0 89 11 00    	mov    0x1189c0,%edx
  104939:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10493c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10493f:	c7 45 e4 bc 89 11 00 	movl   $0x1189bc,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10494c:	89 50 04             	mov    %edx,0x4(%eax)
  10494f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104952:	8b 50 04             	mov    0x4(%eax),%edx
  104955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104958:	89 10                	mov    %edx,(%eax)
  10495a:	c7 45 d8 bc 89 11 00 	movl   $0x1189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104961:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104964:	8b 40 04             	mov    0x4(%eax),%eax
  104967:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10496a:	0f 94 c0             	sete   %al
  10496d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104970:	85 c0                	test   %eax,%eax
  104972:	75 19                	jne    10498d <basic_check+0x224>
  104974:	68 0f 6b 10 00       	push   $0x106b0f
  104979:	68 9e 69 10 00       	push   $0x10699e
  10497e:	68 e2 00 00 00       	push   $0xe2
  104983:	68 b3 69 10 00       	push   $0x1069b3
  104988:	e8 48 ba ff ff       	call   1003d5 <__panic>

    unsigned int nr_free_store = nr_free;
  10498d:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104992:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  104995:	c7 05 c4 89 11 00 00 	movl   $0x0,0x1189c4
  10499c:	00 00 00 

    assert(alloc_page() == NULL);
  10499f:	83 ec 0c             	sub    $0xc,%esp
  1049a2:	6a 01                	push   $0x1
  1049a4:	e8 c5 e2 ff ff       	call   102c6e <alloc_pages>
  1049a9:	83 c4 10             	add    $0x10,%esp
  1049ac:	85 c0                	test   %eax,%eax
  1049ae:	74 19                	je     1049c9 <basic_check+0x260>
  1049b0:	68 26 6b 10 00       	push   $0x106b26
  1049b5:	68 9e 69 10 00       	push   $0x10699e
  1049ba:	68 e7 00 00 00       	push   $0xe7
  1049bf:	68 b3 69 10 00       	push   $0x1069b3
  1049c4:	e8 0c ba ff ff       	call   1003d5 <__panic>

    free_page(p0);
  1049c9:	83 ec 08             	sub    $0x8,%esp
  1049cc:	6a 01                	push   $0x1
  1049ce:	ff 75 ec             	pushl  -0x14(%ebp)
  1049d1:	e8 d6 e2 ff ff       	call   102cac <free_pages>
  1049d6:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  1049d9:	83 ec 08             	sub    $0x8,%esp
  1049dc:	6a 01                	push   $0x1
  1049de:	ff 75 f0             	pushl  -0x10(%ebp)
  1049e1:	e8 c6 e2 ff ff       	call   102cac <free_pages>
  1049e6:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  1049e9:	83 ec 08             	sub    $0x8,%esp
  1049ec:	6a 01                	push   $0x1
  1049ee:	ff 75 f4             	pushl  -0xc(%ebp)
  1049f1:	e8 b6 e2 ff ff       	call   102cac <free_pages>
  1049f6:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  1049f9:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  1049fe:	83 f8 03             	cmp    $0x3,%eax
  104a01:	74 19                	je     104a1c <basic_check+0x2b3>
  104a03:	68 3b 6b 10 00       	push   $0x106b3b
  104a08:	68 9e 69 10 00       	push   $0x10699e
  104a0d:	68 ec 00 00 00       	push   $0xec
  104a12:	68 b3 69 10 00       	push   $0x1069b3
  104a17:	e8 b9 b9 ff ff       	call   1003d5 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104a1c:	83 ec 0c             	sub    $0xc,%esp
  104a1f:	6a 01                	push   $0x1
  104a21:	e8 48 e2 ff ff       	call   102c6e <alloc_pages>
  104a26:	83 c4 10             	add    $0x10,%esp
  104a29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104a30:	75 19                	jne    104a4b <basic_check+0x2e2>
  104a32:	68 01 6a 10 00       	push   $0x106a01
  104a37:	68 9e 69 10 00       	push   $0x10699e
  104a3c:	68 ee 00 00 00       	push   $0xee
  104a41:	68 b3 69 10 00       	push   $0x1069b3
  104a46:	e8 8a b9 ff ff       	call   1003d5 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104a4b:	83 ec 0c             	sub    $0xc,%esp
  104a4e:	6a 01                	push   $0x1
  104a50:	e8 19 e2 ff ff       	call   102c6e <alloc_pages>
  104a55:	83 c4 10             	add    $0x10,%esp
  104a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a5f:	75 19                	jne    104a7a <basic_check+0x311>
  104a61:	68 1d 6a 10 00       	push   $0x106a1d
  104a66:	68 9e 69 10 00       	push   $0x10699e
  104a6b:	68 ef 00 00 00       	push   $0xef
  104a70:	68 b3 69 10 00       	push   $0x1069b3
  104a75:	e8 5b b9 ff ff       	call   1003d5 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104a7a:	83 ec 0c             	sub    $0xc,%esp
  104a7d:	6a 01                	push   $0x1
  104a7f:	e8 ea e1 ff ff       	call   102c6e <alloc_pages>
  104a84:	83 c4 10             	add    $0x10,%esp
  104a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a8e:	75 19                	jne    104aa9 <basic_check+0x340>
  104a90:	68 39 6a 10 00       	push   $0x106a39
  104a95:	68 9e 69 10 00       	push   $0x10699e
  104a9a:	68 f0 00 00 00       	push   $0xf0
  104a9f:	68 b3 69 10 00       	push   $0x1069b3
  104aa4:	e8 2c b9 ff ff       	call   1003d5 <__panic>

    assert(alloc_page() == NULL);
  104aa9:	83 ec 0c             	sub    $0xc,%esp
  104aac:	6a 01                	push   $0x1
  104aae:	e8 bb e1 ff ff       	call   102c6e <alloc_pages>
  104ab3:	83 c4 10             	add    $0x10,%esp
  104ab6:	85 c0                	test   %eax,%eax
  104ab8:	74 19                	je     104ad3 <basic_check+0x36a>
  104aba:	68 26 6b 10 00       	push   $0x106b26
  104abf:	68 9e 69 10 00       	push   $0x10699e
  104ac4:	68 f2 00 00 00       	push   $0xf2
  104ac9:	68 b3 69 10 00       	push   $0x1069b3
  104ace:	e8 02 b9 ff ff       	call   1003d5 <__panic>

    free_page(p0);
  104ad3:	83 ec 08             	sub    $0x8,%esp
  104ad6:	6a 01                	push   $0x1
  104ad8:	ff 75 ec             	pushl  -0x14(%ebp)
  104adb:	e8 cc e1 ff ff       	call   102cac <free_pages>
  104ae0:	83 c4 10             	add    $0x10,%esp
  104ae3:	c7 45 e8 bc 89 11 00 	movl   $0x1189bc,-0x18(%ebp)
  104aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104aed:	8b 40 04             	mov    0x4(%eax),%eax
  104af0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104af3:	0f 94 c0             	sete   %al
  104af6:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104af9:	85 c0                	test   %eax,%eax
  104afb:	74 19                	je     104b16 <basic_check+0x3ad>
  104afd:	68 48 6b 10 00       	push   $0x106b48
  104b02:	68 9e 69 10 00       	push   $0x10699e
  104b07:	68 f5 00 00 00       	push   $0xf5
  104b0c:	68 b3 69 10 00       	push   $0x1069b3
  104b11:	e8 bf b8 ff ff       	call   1003d5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104b16:	83 ec 0c             	sub    $0xc,%esp
  104b19:	6a 01                	push   $0x1
  104b1b:	e8 4e e1 ff ff       	call   102c6e <alloc_pages>
  104b20:	83 c4 10             	add    $0x10,%esp
  104b23:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104b26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b29:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104b2c:	74 19                	je     104b47 <basic_check+0x3de>
  104b2e:	68 60 6b 10 00       	push   $0x106b60
  104b33:	68 9e 69 10 00       	push   $0x10699e
  104b38:	68 f8 00 00 00       	push   $0xf8
  104b3d:	68 b3 69 10 00       	push   $0x1069b3
  104b42:	e8 8e b8 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  104b47:	83 ec 0c             	sub    $0xc,%esp
  104b4a:	6a 01                	push   $0x1
  104b4c:	e8 1d e1 ff ff       	call   102c6e <alloc_pages>
  104b51:	83 c4 10             	add    $0x10,%esp
  104b54:	85 c0                	test   %eax,%eax
  104b56:	74 19                	je     104b71 <basic_check+0x408>
  104b58:	68 26 6b 10 00       	push   $0x106b26
  104b5d:	68 9e 69 10 00       	push   $0x10699e
  104b62:	68 f9 00 00 00       	push   $0xf9
  104b67:	68 b3 69 10 00       	push   $0x1069b3
  104b6c:	e8 64 b8 ff ff       	call   1003d5 <__panic>

    assert(nr_free == 0);
  104b71:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104b76:	85 c0                	test   %eax,%eax
  104b78:	74 19                	je     104b93 <basic_check+0x42a>
  104b7a:	68 79 6b 10 00       	push   $0x106b79
  104b7f:	68 9e 69 10 00       	push   $0x10699e
  104b84:	68 fb 00 00 00       	push   $0xfb
  104b89:	68 b3 69 10 00       	push   $0x1069b3
  104b8e:	e8 42 b8 ff ff       	call   1003d5 <__panic>
    free_list = free_list_store;
  104b93:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104b99:	a3 bc 89 11 00       	mov    %eax,0x1189bc
  104b9e:	89 15 c0 89 11 00    	mov    %edx,0x1189c0
    nr_free = nr_free_store;
  104ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ba7:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    free_page(p);
  104bac:	83 ec 08             	sub    $0x8,%esp
  104baf:	6a 01                	push   $0x1
  104bb1:	ff 75 dc             	pushl  -0x24(%ebp)
  104bb4:	e8 f3 e0 ff ff       	call   102cac <free_pages>
  104bb9:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104bbc:	83 ec 08             	sub    $0x8,%esp
  104bbf:	6a 01                	push   $0x1
  104bc1:	ff 75 f0             	pushl  -0x10(%ebp)
  104bc4:	e8 e3 e0 ff ff       	call   102cac <free_pages>
  104bc9:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104bcc:	83 ec 08             	sub    $0x8,%esp
  104bcf:	6a 01                	push   $0x1
  104bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  104bd4:	e8 d3 e0 ff ff       	call   102cac <free_pages>
  104bd9:	83 c4 10             	add    $0x10,%esp
}
  104bdc:	90                   	nop
  104bdd:	c9                   	leave  
  104bde:	c3                   	ret    

00104bdf <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104bdf:	55                   	push   %ebp
  104be0:	89 e5                	mov    %esp,%ebp
  104be2:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  104be8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104bef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104bf6:	c7 45 ec bc 89 11 00 	movl   $0x1189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104bfd:	eb 60                	jmp    104c5f <default_check+0x80>
        struct Page *p = le2page(le, page_link);
  104bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c02:	83 e8 0c             	sub    $0xc,%eax
  104c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  104c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c0b:	83 c0 04             	add    $0x4,%eax
  104c0e:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104c15:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c18:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104c1b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104c1e:	0f a3 10             	bt     %edx,(%eax)
  104c21:	19 c0                	sbb    %eax,%eax
  104c23:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  104c26:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  104c2a:	0f 95 c0             	setne  %al
  104c2d:	0f b6 c0             	movzbl %al,%eax
  104c30:	85 c0                	test   %eax,%eax
  104c32:	75 19                	jne    104c4d <default_check+0x6e>
  104c34:	68 86 6b 10 00       	push   $0x106b86
  104c39:	68 9e 69 10 00       	push   $0x10699e
  104c3e:	68 0c 01 00 00       	push   $0x10c
  104c43:	68 b3 69 10 00       	push   $0x1069b3
  104c48:	e8 88 b7 ff ff       	call   1003d5 <__panic>
        count ++, total += p->property;
  104c4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c54:	8b 50 08             	mov    0x8(%eax),%edx
  104c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c5a:	01 d0                	add    %edx,%eax
  104c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c62:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c68:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104c6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c6e:	81 7d ec bc 89 11 00 	cmpl   $0x1189bc,-0x14(%ebp)
  104c75:	75 88                	jne    104bff <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  104c77:	e8 65 e0 ff ff       	call   102ce1 <nr_free_pages>
  104c7c:	89 c2                	mov    %eax,%edx
  104c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c81:	39 c2                	cmp    %eax,%edx
  104c83:	74 19                	je     104c9e <default_check+0xbf>
  104c85:	68 96 6b 10 00       	push   $0x106b96
  104c8a:	68 9e 69 10 00       	push   $0x10699e
  104c8f:	68 0f 01 00 00       	push   $0x10f
  104c94:	68 b3 69 10 00       	push   $0x1069b3
  104c99:	e8 37 b7 ff ff       	call   1003d5 <__panic>

    basic_check();
  104c9e:	e8 c6 fa ff ff       	call   104769 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104ca3:	83 ec 0c             	sub    $0xc,%esp
  104ca6:	6a 05                	push   $0x5
  104ca8:	e8 c1 df ff ff       	call   102c6e <alloc_pages>
  104cad:	83 c4 10             	add    $0x10,%esp
  104cb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
  104cb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104cb7:	75 19                	jne    104cd2 <default_check+0xf3>
  104cb9:	68 af 6b 10 00       	push   $0x106baf
  104cbe:	68 9e 69 10 00       	push   $0x10699e
  104cc3:	68 14 01 00 00       	push   $0x114
  104cc8:	68 b3 69 10 00       	push   $0x1069b3
  104ccd:	e8 03 b7 ff ff       	call   1003d5 <__panic>
    assert(!PageProperty(p0));
  104cd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104cd5:	83 c0 04             	add    $0x4,%eax
  104cd8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104cdf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104ce2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104ce5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104ce8:	0f a3 10             	bt     %edx,(%eax)
  104ceb:	19 c0                	sbb    %eax,%eax
  104ced:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  104cf0:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  104cf4:	0f 95 c0             	setne  %al
  104cf7:	0f b6 c0             	movzbl %al,%eax
  104cfa:	85 c0                	test   %eax,%eax
  104cfc:	74 19                	je     104d17 <default_check+0x138>
  104cfe:	68 ba 6b 10 00       	push   $0x106bba
  104d03:	68 9e 69 10 00       	push   $0x10699e
  104d08:	68 15 01 00 00       	push   $0x115
  104d0d:	68 b3 69 10 00       	push   $0x1069b3
  104d12:	e8 be b6 ff ff       	call   1003d5 <__panic>

    list_entry_t free_list_store = free_list;
  104d17:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104d1c:	8b 15 c0 89 11 00    	mov    0x1189c0,%edx
  104d22:	89 45 80             	mov    %eax,-0x80(%ebp)
  104d25:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104d28:	c7 45 d0 bc 89 11 00 	movl   $0x1189bc,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d32:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104d35:	89 50 04             	mov    %edx,0x4(%eax)
  104d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d3b:	8b 50 04             	mov    0x4(%eax),%edx
  104d3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d41:	89 10                	mov    %edx,(%eax)
  104d43:	c7 45 d8 bc 89 11 00 	movl   $0x1189bc,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104d4d:	8b 40 04             	mov    0x4(%eax),%eax
  104d50:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104d53:	0f 94 c0             	sete   %al
  104d56:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104d59:	85 c0                	test   %eax,%eax
  104d5b:	75 19                	jne    104d76 <default_check+0x197>
  104d5d:	68 0f 6b 10 00       	push   $0x106b0f
  104d62:	68 9e 69 10 00       	push   $0x10699e
  104d67:	68 19 01 00 00       	push   $0x119
  104d6c:	68 b3 69 10 00       	push   $0x1069b3
  104d71:	e8 5f b6 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  104d76:	83 ec 0c             	sub    $0xc,%esp
  104d79:	6a 01                	push   $0x1
  104d7b:	e8 ee de ff ff       	call   102c6e <alloc_pages>
  104d80:	83 c4 10             	add    $0x10,%esp
  104d83:	85 c0                	test   %eax,%eax
  104d85:	74 19                	je     104da0 <default_check+0x1c1>
  104d87:	68 26 6b 10 00       	push   $0x106b26
  104d8c:	68 9e 69 10 00       	push   $0x10699e
  104d91:	68 1a 01 00 00       	push   $0x11a
  104d96:	68 b3 69 10 00       	push   $0x1069b3
  104d9b:	e8 35 b6 ff ff       	call   1003d5 <__panic>

    unsigned int nr_free_store = nr_free;
  104da0:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104da5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  104da8:	c7 05 c4 89 11 00 00 	movl   $0x0,0x1189c4
  104daf:	00 00 00 

    free_pages(p0 + 2, 3);
  104db2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104db5:	83 c0 28             	add    $0x28,%eax
  104db8:	83 ec 08             	sub    $0x8,%esp
  104dbb:	6a 03                	push   $0x3
  104dbd:	50                   	push   %eax
  104dbe:	e8 e9 de ff ff       	call   102cac <free_pages>
  104dc3:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  104dc6:	83 ec 0c             	sub    $0xc,%esp
  104dc9:	6a 04                	push   $0x4
  104dcb:	e8 9e de ff ff       	call   102c6e <alloc_pages>
  104dd0:	83 c4 10             	add    $0x10,%esp
  104dd3:	85 c0                	test   %eax,%eax
  104dd5:	74 19                	je     104df0 <default_check+0x211>
  104dd7:	68 cc 6b 10 00       	push   $0x106bcc
  104ddc:	68 9e 69 10 00       	push   $0x10699e
  104de1:	68 20 01 00 00       	push   $0x120
  104de6:	68 b3 69 10 00       	push   $0x1069b3
  104deb:	e8 e5 b5 ff ff       	call   1003d5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104df0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104df3:	83 c0 28             	add    $0x28,%eax
  104df6:	83 c0 04             	add    $0x4,%eax
  104df9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104e00:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e03:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104e06:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104e09:	0f a3 10             	bt     %edx,(%eax)
  104e0c:	19 c0                	sbb    %eax,%eax
  104e0e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104e11:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104e15:	0f 95 c0             	setne  %al
  104e18:	0f b6 c0             	movzbl %al,%eax
  104e1b:	85 c0                	test   %eax,%eax
  104e1d:	74 0e                	je     104e2d <default_check+0x24e>
  104e1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e22:	83 c0 28             	add    $0x28,%eax
  104e25:	8b 40 08             	mov    0x8(%eax),%eax
  104e28:	83 f8 03             	cmp    $0x3,%eax
  104e2b:	74 19                	je     104e46 <default_check+0x267>
  104e2d:	68 e4 6b 10 00       	push   $0x106be4
  104e32:	68 9e 69 10 00       	push   $0x10699e
  104e37:	68 21 01 00 00       	push   $0x121
  104e3c:	68 b3 69 10 00       	push   $0x1069b3
  104e41:	e8 8f b5 ff ff       	call   1003d5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104e46:	83 ec 0c             	sub    $0xc,%esp
  104e49:	6a 03                	push   $0x3
  104e4b:	e8 1e de ff ff       	call   102c6e <alloc_pages>
  104e50:	83 c4 10             	add    $0x10,%esp
  104e53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104e56:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104e5a:	75 19                	jne    104e75 <default_check+0x296>
  104e5c:	68 10 6c 10 00       	push   $0x106c10
  104e61:	68 9e 69 10 00       	push   $0x10699e
  104e66:	68 22 01 00 00       	push   $0x122
  104e6b:	68 b3 69 10 00       	push   $0x1069b3
  104e70:	e8 60 b5 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  104e75:	83 ec 0c             	sub    $0xc,%esp
  104e78:	6a 01                	push   $0x1
  104e7a:	e8 ef dd ff ff       	call   102c6e <alloc_pages>
  104e7f:	83 c4 10             	add    $0x10,%esp
  104e82:	85 c0                	test   %eax,%eax
  104e84:	74 19                	je     104e9f <default_check+0x2c0>
  104e86:	68 26 6b 10 00       	push   $0x106b26
  104e8b:	68 9e 69 10 00       	push   $0x10699e
  104e90:	68 23 01 00 00       	push   $0x123
  104e95:	68 b3 69 10 00       	push   $0x1069b3
  104e9a:	e8 36 b5 ff ff       	call   1003d5 <__panic>
    assert(p0 + 2 == p1);
  104e9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ea2:	83 c0 28             	add    $0x28,%eax
  104ea5:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  104ea8:	74 19                	je     104ec3 <default_check+0x2e4>
  104eaa:	68 2e 6c 10 00       	push   $0x106c2e
  104eaf:	68 9e 69 10 00       	push   $0x10699e
  104eb4:	68 24 01 00 00       	push   $0x124
  104eb9:	68 b3 69 10 00       	push   $0x1069b3
  104ebe:	e8 12 b5 ff ff       	call   1003d5 <__panic>

    p2 = p0 + 1;
  104ec3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ec6:	83 c0 14             	add    $0x14,%eax
  104ec9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  104ecc:	83 ec 08             	sub    $0x8,%esp
  104ecf:	6a 01                	push   $0x1
  104ed1:	ff 75 dc             	pushl  -0x24(%ebp)
  104ed4:	e8 d3 dd ff ff       	call   102cac <free_pages>
  104ed9:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  104edc:	83 ec 08             	sub    $0x8,%esp
  104edf:	6a 03                	push   $0x3
  104ee1:	ff 75 c4             	pushl  -0x3c(%ebp)
  104ee4:	e8 c3 dd ff ff       	call   102cac <free_pages>
  104ee9:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  104eec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104eef:	83 c0 04             	add    $0x4,%eax
  104ef2:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104ef9:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104efc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104eff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104f02:	0f a3 10             	bt     %edx,(%eax)
  104f05:	19 c0                	sbb    %eax,%eax
  104f07:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  104f0a:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  104f0e:	0f 95 c0             	setne  %al
  104f11:	0f b6 c0             	movzbl %al,%eax
  104f14:	85 c0                	test   %eax,%eax
  104f16:	74 0b                	je     104f23 <default_check+0x344>
  104f18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f1b:	8b 40 08             	mov    0x8(%eax),%eax
  104f1e:	83 f8 01             	cmp    $0x1,%eax
  104f21:	74 19                	je     104f3c <default_check+0x35d>
  104f23:	68 3c 6c 10 00       	push   $0x106c3c
  104f28:	68 9e 69 10 00       	push   $0x10699e
  104f2d:	68 29 01 00 00       	push   $0x129
  104f32:	68 b3 69 10 00       	push   $0x1069b3
  104f37:	e8 99 b4 ff ff       	call   1003d5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104f3c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104f3f:	83 c0 04             	add    $0x4,%eax
  104f42:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104f49:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f4c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104f4f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104f52:	0f a3 10             	bt     %edx,(%eax)
  104f55:	19 c0                	sbb    %eax,%eax
  104f57:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  104f5a:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  104f5e:	0f 95 c0             	setne  %al
  104f61:	0f b6 c0             	movzbl %al,%eax
  104f64:	85 c0                	test   %eax,%eax
  104f66:	74 0b                	je     104f73 <default_check+0x394>
  104f68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104f6b:	8b 40 08             	mov    0x8(%eax),%eax
  104f6e:	83 f8 03             	cmp    $0x3,%eax
  104f71:	74 19                	je     104f8c <default_check+0x3ad>
  104f73:	68 64 6c 10 00       	push   $0x106c64
  104f78:	68 9e 69 10 00       	push   $0x10699e
  104f7d:	68 2a 01 00 00       	push   $0x12a
  104f82:	68 b3 69 10 00       	push   $0x1069b3
  104f87:	e8 49 b4 ff ff       	call   1003d5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104f8c:	83 ec 0c             	sub    $0xc,%esp
  104f8f:	6a 01                	push   $0x1
  104f91:	e8 d8 dc ff ff       	call   102c6e <alloc_pages>
  104f96:	83 c4 10             	add    $0x10,%esp
  104f99:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104f9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104f9f:	83 e8 14             	sub    $0x14,%eax
  104fa2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104fa5:	74 19                	je     104fc0 <default_check+0x3e1>
  104fa7:	68 8a 6c 10 00       	push   $0x106c8a
  104fac:	68 9e 69 10 00       	push   $0x10699e
  104fb1:	68 2c 01 00 00       	push   $0x12c
  104fb6:	68 b3 69 10 00       	push   $0x1069b3
  104fbb:	e8 15 b4 ff ff       	call   1003d5 <__panic>
    free_page(p0);
  104fc0:	83 ec 08             	sub    $0x8,%esp
  104fc3:	6a 01                	push   $0x1
  104fc5:	ff 75 dc             	pushl  -0x24(%ebp)
  104fc8:	e8 df dc ff ff       	call   102cac <free_pages>
  104fcd:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104fd0:	83 ec 0c             	sub    $0xc,%esp
  104fd3:	6a 02                	push   $0x2
  104fd5:	e8 94 dc ff ff       	call   102c6e <alloc_pages>
  104fda:	83 c4 10             	add    $0x10,%esp
  104fdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104fe0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104fe3:	83 c0 14             	add    $0x14,%eax
  104fe6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104fe9:	74 19                	je     105004 <default_check+0x425>
  104feb:	68 a8 6c 10 00       	push   $0x106ca8
  104ff0:	68 9e 69 10 00       	push   $0x10699e
  104ff5:	68 2e 01 00 00       	push   $0x12e
  104ffa:	68 b3 69 10 00       	push   $0x1069b3
  104fff:	e8 d1 b3 ff ff       	call   1003d5 <__panic>

    free_pages(p0, 2);
  105004:	83 ec 08             	sub    $0x8,%esp
  105007:	6a 02                	push   $0x2
  105009:	ff 75 dc             	pushl  -0x24(%ebp)
  10500c:	e8 9b dc ff ff       	call   102cac <free_pages>
  105011:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  105014:	83 ec 08             	sub    $0x8,%esp
  105017:	6a 01                	push   $0x1
  105019:	ff 75 c0             	pushl  -0x40(%ebp)
  10501c:	e8 8b dc ff ff       	call   102cac <free_pages>
  105021:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  105024:	83 ec 0c             	sub    $0xc,%esp
  105027:	6a 05                	push   $0x5
  105029:	e8 40 dc ff ff       	call   102c6e <alloc_pages>
  10502e:	83 c4 10             	add    $0x10,%esp
  105031:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105034:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105038:	75 19                	jne    105053 <default_check+0x474>
  10503a:	68 c8 6c 10 00       	push   $0x106cc8
  10503f:	68 9e 69 10 00       	push   $0x10699e
  105044:	68 33 01 00 00       	push   $0x133
  105049:	68 b3 69 10 00       	push   $0x1069b3
  10504e:	e8 82 b3 ff ff       	call   1003d5 <__panic>
    assert(alloc_page() == NULL);
  105053:	83 ec 0c             	sub    $0xc,%esp
  105056:	6a 01                	push   $0x1
  105058:	e8 11 dc ff ff       	call   102c6e <alloc_pages>
  10505d:	83 c4 10             	add    $0x10,%esp
  105060:	85 c0                	test   %eax,%eax
  105062:	74 19                	je     10507d <default_check+0x49e>
  105064:	68 26 6b 10 00       	push   $0x106b26
  105069:	68 9e 69 10 00       	push   $0x10699e
  10506e:	68 34 01 00 00       	push   $0x134
  105073:	68 b3 69 10 00       	push   $0x1069b3
  105078:	e8 58 b3 ff ff       	call   1003d5 <__panic>

    assert(nr_free == 0);
  10507d:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  105082:	85 c0                	test   %eax,%eax
  105084:	74 19                	je     10509f <default_check+0x4c0>
  105086:	68 79 6b 10 00       	push   $0x106b79
  10508b:	68 9e 69 10 00       	push   $0x10699e
  105090:	68 36 01 00 00       	push   $0x136
  105095:	68 b3 69 10 00       	push   $0x1069b3
  10509a:	e8 36 b3 ff ff       	call   1003d5 <__panic>
    nr_free = nr_free_store;
  10509f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1050a2:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    free_list = free_list_store;
  1050a7:	8b 45 80             	mov    -0x80(%ebp),%eax
  1050aa:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1050ad:	a3 bc 89 11 00       	mov    %eax,0x1189bc
  1050b2:	89 15 c0 89 11 00    	mov    %edx,0x1189c0
    free_pages(p0, 5);
  1050b8:	83 ec 08             	sub    $0x8,%esp
  1050bb:	6a 05                	push   $0x5
  1050bd:	ff 75 dc             	pushl  -0x24(%ebp)
  1050c0:	e8 e7 db ff ff       	call   102cac <free_pages>
  1050c5:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  1050c8:	c7 45 ec bc 89 11 00 	movl   $0x1189bc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1050cf:	eb 1d                	jmp    1050ee <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
  1050d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050d4:	83 e8 0c             	sub    $0xc,%eax
  1050d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  1050da:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1050de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1050e1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1050e4:	8b 40 08             	mov    0x8(%eax),%eax
  1050e7:	29 c2                	sub    %eax,%edx
  1050e9:	89 d0                	mov    %edx,%eax
  1050eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1050f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1050f7:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1050fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1050fd:	81 7d ec bc 89 11 00 	cmpl   $0x1189bc,-0x14(%ebp)
  105104:	75 cb                	jne    1050d1 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  105106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10510a:	74 19                	je     105125 <default_check+0x546>
  10510c:	68 e6 6c 10 00       	push   $0x106ce6
  105111:	68 9e 69 10 00       	push   $0x10699e
  105116:	68 41 01 00 00       	push   $0x141
  10511b:	68 b3 69 10 00       	push   $0x1069b3
  105120:	e8 b0 b2 ff ff       	call   1003d5 <__panic>
    assert(total == 0);
  105125:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105129:	74 19                	je     105144 <default_check+0x565>
  10512b:	68 f1 6c 10 00       	push   $0x106cf1
  105130:	68 9e 69 10 00       	push   $0x10699e
  105135:	68 42 01 00 00       	push   $0x142
  10513a:	68 b3 69 10 00       	push   $0x1069b3
  10513f:	e8 91 b2 ff ff       	call   1003d5 <__panic>
}
  105144:	90                   	nop
  105145:	c9                   	leave  
  105146:	c3                   	ret    

00105147 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105147:	55                   	push   %ebp
  105148:	89 e5                	mov    %esp,%ebp
  10514a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10514d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105154:	eb 04                	jmp    10515a <strlen+0x13>
        cnt ++;
  105156:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  10515a:	8b 45 08             	mov    0x8(%ebp),%eax
  10515d:	8d 50 01             	lea    0x1(%eax),%edx
  105160:	89 55 08             	mov    %edx,0x8(%ebp)
  105163:	0f b6 00             	movzbl (%eax),%eax
  105166:	84 c0                	test   %al,%al
  105168:	75 ec                	jne    105156 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  10516a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10516d:	c9                   	leave  
  10516e:	c3                   	ret    

0010516f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10516f:	55                   	push   %ebp
  105170:	89 e5                	mov    %esp,%ebp
  105172:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10517c:	eb 04                	jmp    105182 <strnlen+0x13>
        cnt ++;
  10517e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105185:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105188:	73 10                	jae    10519a <strnlen+0x2b>
  10518a:	8b 45 08             	mov    0x8(%ebp),%eax
  10518d:	8d 50 01             	lea    0x1(%eax),%edx
  105190:	89 55 08             	mov    %edx,0x8(%ebp)
  105193:	0f b6 00             	movzbl (%eax),%eax
  105196:	84 c0                	test   %al,%al
  105198:	75 e4                	jne    10517e <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10519a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10519d:	c9                   	leave  
  10519e:	c3                   	ret    

0010519f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10519f:	55                   	push   %ebp
  1051a0:	89 e5                	mov    %esp,%ebp
  1051a2:	57                   	push   %edi
  1051a3:	56                   	push   %esi
  1051a4:	83 ec 20             	sub    $0x20,%esp
  1051a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1051aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1051ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1051b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1051b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051b9:	89 d1                	mov    %edx,%ecx
  1051bb:	89 c2                	mov    %eax,%edx
  1051bd:	89 ce                	mov    %ecx,%esi
  1051bf:	89 d7                	mov    %edx,%edi
  1051c1:	ac                   	lods   %ds:(%esi),%al
  1051c2:	aa                   	stos   %al,%es:(%edi)
  1051c3:	84 c0                	test   %al,%al
  1051c5:	75 fa                	jne    1051c1 <strcpy+0x22>
  1051c7:	89 fa                	mov    %edi,%edx
  1051c9:	89 f1                	mov    %esi,%ecx
  1051cb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1051ce:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1051d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1051d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1051d7:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1051d8:	83 c4 20             	add    $0x20,%esp
  1051db:	5e                   	pop    %esi
  1051dc:	5f                   	pop    %edi
  1051dd:	5d                   	pop    %ebp
  1051de:	c3                   	ret    

001051df <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1051df:	55                   	push   %ebp
  1051e0:	89 e5                	mov    %esp,%ebp
  1051e2:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1051e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1051e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1051eb:	eb 21                	jmp    10520e <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1051ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051f0:	0f b6 10             	movzbl (%eax),%edx
  1051f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051f6:	88 10                	mov    %dl,(%eax)
  1051f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051fb:	0f b6 00             	movzbl (%eax),%eax
  1051fe:	84 c0                	test   %al,%al
  105200:	74 04                	je     105206 <strncpy+0x27>
            src ++;
  105202:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105206:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10520a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10520e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105212:	75 d9                	jne    1051ed <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105214:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105217:	c9                   	leave  
  105218:	c3                   	ret    

00105219 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105219:	55                   	push   %ebp
  10521a:	89 e5                	mov    %esp,%ebp
  10521c:	57                   	push   %edi
  10521d:	56                   	push   %esi
  10521e:	83 ec 20             	sub    $0x20,%esp
  105221:	8b 45 08             	mov    0x8(%ebp),%eax
  105224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105227:	8b 45 0c             	mov    0xc(%ebp),%eax
  10522a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10522d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105233:	89 d1                	mov    %edx,%ecx
  105235:	89 c2                	mov    %eax,%edx
  105237:	89 ce                	mov    %ecx,%esi
  105239:	89 d7                	mov    %edx,%edi
  10523b:	ac                   	lods   %ds:(%esi),%al
  10523c:	ae                   	scas   %es:(%edi),%al
  10523d:	75 08                	jne    105247 <strcmp+0x2e>
  10523f:	84 c0                	test   %al,%al
  105241:	75 f8                	jne    10523b <strcmp+0x22>
  105243:	31 c0                	xor    %eax,%eax
  105245:	eb 04                	jmp    10524b <strcmp+0x32>
  105247:	19 c0                	sbb    %eax,%eax
  105249:	0c 01                	or     $0x1,%al
  10524b:	89 fa                	mov    %edi,%edx
  10524d:	89 f1                	mov    %esi,%ecx
  10524f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105252:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105255:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105258:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  10525b:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10525c:	83 c4 20             	add    $0x20,%esp
  10525f:	5e                   	pop    %esi
  105260:	5f                   	pop    %edi
  105261:	5d                   	pop    %ebp
  105262:	c3                   	ret    

00105263 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105263:	55                   	push   %ebp
  105264:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105266:	eb 0c                	jmp    105274 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105268:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10526c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105270:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105274:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105278:	74 1a                	je     105294 <strncmp+0x31>
  10527a:	8b 45 08             	mov    0x8(%ebp),%eax
  10527d:	0f b6 00             	movzbl (%eax),%eax
  105280:	84 c0                	test   %al,%al
  105282:	74 10                	je     105294 <strncmp+0x31>
  105284:	8b 45 08             	mov    0x8(%ebp),%eax
  105287:	0f b6 10             	movzbl (%eax),%edx
  10528a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10528d:	0f b6 00             	movzbl (%eax),%eax
  105290:	38 c2                	cmp    %al,%dl
  105292:	74 d4                	je     105268 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105294:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105298:	74 18                	je     1052b2 <strncmp+0x4f>
  10529a:	8b 45 08             	mov    0x8(%ebp),%eax
  10529d:	0f b6 00             	movzbl (%eax),%eax
  1052a0:	0f b6 d0             	movzbl %al,%edx
  1052a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052a6:	0f b6 00             	movzbl (%eax),%eax
  1052a9:	0f b6 c0             	movzbl %al,%eax
  1052ac:	29 c2                	sub    %eax,%edx
  1052ae:	89 d0                	mov    %edx,%eax
  1052b0:	eb 05                	jmp    1052b7 <strncmp+0x54>
  1052b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052b7:	5d                   	pop    %ebp
  1052b8:	c3                   	ret    

001052b9 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1052b9:	55                   	push   %ebp
  1052ba:	89 e5                	mov    %esp,%ebp
  1052bc:	83 ec 04             	sub    $0x4,%esp
  1052bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052c2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1052c5:	eb 14                	jmp    1052db <strchr+0x22>
        if (*s == c) {
  1052c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1052ca:	0f b6 00             	movzbl (%eax),%eax
  1052cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1052d0:	75 05                	jne    1052d7 <strchr+0x1e>
            return (char *)s;
  1052d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1052d5:	eb 13                	jmp    1052ea <strchr+0x31>
        }
        s ++;
  1052d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1052db:	8b 45 08             	mov    0x8(%ebp),%eax
  1052de:	0f b6 00             	movzbl (%eax),%eax
  1052e1:	84 c0                	test   %al,%al
  1052e3:	75 e2                	jne    1052c7 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1052e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052ea:	c9                   	leave  
  1052eb:	c3                   	ret    

001052ec <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1052ec:	55                   	push   %ebp
  1052ed:	89 e5                	mov    %esp,%ebp
  1052ef:	83 ec 04             	sub    $0x4,%esp
  1052f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052f5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1052f8:	eb 0f                	jmp    105309 <strfind+0x1d>
        if (*s == c) {
  1052fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1052fd:	0f b6 00             	movzbl (%eax),%eax
  105300:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105303:	74 10                	je     105315 <strfind+0x29>
            break;
        }
        s ++;
  105305:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105309:	8b 45 08             	mov    0x8(%ebp),%eax
  10530c:	0f b6 00             	movzbl (%eax),%eax
  10530f:	84 c0                	test   %al,%al
  105311:	75 e7                	jne    1052fa <strfind+0xe>
  105313:	eb 01                	jmp    105316 <strfind+0x2a>
        if (*s == c) {
            break;
  105315:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105316:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105319:	c9                   	leave  
  10531a:	c3                   	ret    

0010531b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10531b:	55                   	push   %ebp
  10531c:	89 e5                	mov    %esp,%ebp
  10531e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10532f:	eb 04                	jmp    105335 <strtol+0x1a>
        s ++;
  105331:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105335:	8b 45 08             	mov    0x8(%ebp),%eax
  105338:	0f b6 00             	movzbl (%eax),%eax
  10533b:	3c 20                	cmp    $0x20,%al
  10533d:	74 f2                	je     105331 <strtol+0x16>
  10533f:	8b 45 08             	mov    0x8(%ebp),%eax
  105342:	0f b6 00             	movzbl (%eax),%eax
  105345:	3c 09                	cmp    $0x9,%al
  105347:	74 e8                	je     105331 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105349:	8b 45 08             	mov    0x8(%ebp),%eax
  10534c:	0f b6 00             	movzbl (%eax),%eax
  10534f:	3c 2b                	cmp    $0x2b,%al
  105351:	75 06                	jne    105359 <strtol+0x3e>
        s ++;
  105353:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105357:	eb 15                	jmp    10536e <strtol+0x53>
    }
    else if (*s == '-') {
  105359:	8b 45 08             	mov    0x8(%ebp),%eax
  10535c:	0f b6 00             	movzbl (%eax),%eax
  10535f:	3c 2d                	cmp    $0x2d,%al
  105361:	75 0b                	jne    10536e <strtol+0x53>
        s ++, neg = 1;
  105363:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105367:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10536e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105372:	74 06                	je     10537a <strtol+0x5f>
  105374:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105378:	75 24                	jne    10539e <strtol+0x83>
  10537a:	8b 45 08             	mov    0x8(%ebp),%eax
  10537d:	0f b6 00             	movzbl (%eax),%eax
  105380:	3c 30                	cmp    $0x30,%al
  105382:	75 1a                	jne    10539e <strtol+0x83>
  105384:	8b 45 08             	mov    0x8(%ebp),%eax
  105387:	83 c0 01             	add    $0x1,%eax
  10538a:	0f b6 00             	movzbl (%eax),%eax
  10538d:	3c 78                	cmp    $0x78,%al
  10538f:	75 0d                	jne    10539e <strtol+0x83>
        s += 2, base = 16;
  105391:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105395:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10539c:	eb 2a                	jmp    1053c8 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10539e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1053a2:	75 17                	jne    1053bb <strtol+0xa0>
  1053a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a7:	0f b6 00             	movzbl (%eax),%eax
  1053aa:	3c 30                	cmp    $0x30,%al
  1053ac:	75 0d                	jne    1053bb <strtol+0xa0>
        s ++, base = 8;
  1053ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1053b2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1053b9:	eb 0d                	jmp    1053c8 <strtol+0xad>
    }
    else if (base == 0) {
  1053bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1053bf:	75 07                	jne    1053c8 <strtol+0xad>
        base = 10;
  1053c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1053c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1053cb:	0f b6 00             	movzbl (%eax),%eax
  1053ce:	3c 2f                	cmp    $0x2f,%al
  1053d0:	7e 1b                	jle    1053ed <strtol+0xd2>
  1053d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d5:	0f b6 00             	movzbl (%eax),%eax
  1053d8:	3c 39                	cmp    $0x39,%al
  1053da:	7f 11                	jg     1053ed <strtol+0xd2>
            dig = *s - '0';
  1053dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1053df:	0f b6 00             	movzbl (%eax),%eax
  1053e2:	0f be c0             	movsbl %al,%eax
  1053e5:	83 e8 30             	sub    $0x30,%eax
  1053e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053eb:	eb 48                	jmp    105435 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1053ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f0:	0f b6 00             	movzbl (%eax),%eax
  1053f3:	3c 60                	cmp    $0x60,%al
  1053f5:	7e 1b                	jle    105412 <strtol+0xf7>
  1053f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1053fa:	0f b6 00             	movzbl (%eax),%eax
  1053fd:	3c 7a                	cmp    $0x7a,%al
  1053ff:	7f 11                	jg     105412 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105401:	8b 45 08             	mov    0x8(%ebp),%eax
  105404:	0f b6 00             	movzbl (%eax),%eax
  105407:	0f be c0             	movsbl %al,%eax
  10540a:	83 e8 57             	sub    $0x57,%eax
  10540d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105410:	eb 23                	jmp    105435 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105412:	8b 45 08             	mov    0x8(%ebp),%eax
  105415:	0f b6 00             	movzbl (%eax),%eax
  105418:	3c 40                	cmp    $0x40,%al
  10541a:	7e 3c                	jle    105458 <strtol+0x13d>
  10541c:	8b 45 08             	mov    0x8(%ebp),%eax
  10541f:	0f b6 00             	movzbl (%eax),%eax
  105422:	3c 5a                	cmp    $0x5a,%al
  105424:	7f 32                	jg     105458 <strtol+0x13d>
            dig = *s - 'A' + 10;
  105426:	8b 45 08             	mov    0x8(%ebp),%eax
  105429:	0f b6 00             	movzbl (%eax),%eax
  10542c:	0f be c0             	movsbl %al,%eax
  10542f:	83 e8 37             	sub    $0x37,%eax
  105432:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105438:	3b 45 10             	cmp    0x10(%ebp),%eax
  10543b:	7d 1a                	jge    105457 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  10543d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105441:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105444:	0f af 45 10          	imul   0x10(%ebp),%eax
  105448:	89 c2                	mov    %eax,%edx
  10544a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10544d:	01 d0                	add    %edx,%eax
  10544f:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105452:	e9 71 ff ff ff       	jmp    1053c8 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105457:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105458:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10545c:	74 08                	je     105466 <strtol+0x14b>
        *endptr = (char *) s;
  10545e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105461:	8b 55 08             	mov    0x8(%ebp),%edx
  105464:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105466:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10546a:	74 07                	je     105473 <strtol+0x158>
  10546c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10546f:	f7 d8                	neg    %eax
  105471:	eb 03                	jmp    105476 <strtol+0x15b>
  105473:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105476:	c9                   	leave  
  105477:	c3                   	ret    

00105478 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105478:	55                   	push   %ebp
  105479:	89 e5                	mov    %esp,%ebp
  10547b:	57                   	push   %edi
  10547c:	83 ec 24             	sub    $0x24,%esp
  10547f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105482:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105485:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105489:	8b 55 08             	mov    0x8(%ebp),%edx
  10548c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10548f:	88 45 f7             	mov    %al,-0x9(%ebp)
  105492:	8b 45 10             	mov    0x10(%ebp),%eax
  105495:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105498:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10549b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10549f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1054a2:	89 d7                	mov    %edx,%edi
  1054a4:	f3 aa                	rep stos %al,%es:(%edi)
  1054a6:	89 fa                	mov    %edi,%edx
  1054a8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1054ab:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1054ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1054b1:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1054b2:	83 c4 24             	add    $0x24,%esp
  1054b5:	5f                   	pop    %edi
  1054b6:	5d                   	pop    %ebp
  1054b7:	c3                   	ret    

001054b8 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1054b8:	55                   	push   %ebp
  1054b9:	89 e5                	mov    %esp,%ebp
  1054bb:	57                   	push   %edi
  1054bc:	56                   	push   %esi
  1054bd:	53                   	push   %ebx
  1054be:	83 ec 30             	sub    $0x30,%esp
  1054c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1054cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1054d0:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1054d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1054d9:	73 42                	jae    10551d <memmove+0x65>
  1054db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1054e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1054ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054f0:	c1 e8 02             	shr    $0x2,%eax
  1054f3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1054f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054fb:	89 d7                	mov    %edx,%edi
  1054fd:	89 c6                	mov    %eax,%esi
  1054ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105501:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105504:	83 e1 03             	and    $0x3,%ecx
  105507:	74 02                	je     10550b <memmove+0x53>
  105509:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10550b:	89 f0                	mov    %esi,%eax
  10550d:	89 fa                	mov    %edi,%edx
  10550f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105512:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105515:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  10551b:	eb 36                	jmp    105553 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10551d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105520:	8d 50 ff             	lea    -0x1(%eax),%edx
  105523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105526:	01 c2                	add    %eax,%edx
  105528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10552b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10552e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105531:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105537:	89 c1                	mov    %eax,%ecx
  105539:	89 d8                	mov    %ebx,%eax
  10553b:	89 d6                	mov    %edx,%esi
  10553d:	89 c7                	mov    %eax,%edi
  10553f:	fd                   	std    
  105540:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105542:	fc                   	cld    
  105543:	89 f8                	mov    %edi,%eax
  105545:	89 f2                	mov    %esi,%edx
  105547:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10554a:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10554d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105550:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105553:	83 c4 30             	add    $0x30,%esp
  105556:	5b                   	pop    %ebx
  105557:	5e                   	pop    %esi
  105558:	5f                   	pop    %edi
  105559:	5d                   	pop    %ebp
  10555a:	c3                   	ret    

0010555b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10555b:	55                   	push   %ebp
  10555c:	89 e5                	mov    %esp,%ebp
  10555e:	57                   	push   %edi
  10555f:	56                   	push   %esi
  105560:	83 ec 20             	sub    $0x20,%esp
  105563:	8b 45 08             	mov    0x8(%ebp),%eax
  105566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10556c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10556f:	8b 45 10             	mov    0x10(%ebp),%eax
  105572:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105578:	c1 e8 02             	shr    $0x2,%eax
  10557b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10557d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105583:	89 d7                	mov    %edx,%edi
  105585:	89 c6                	mov    %eax,%esi
  105587:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105589:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10558c:	83 e1 03             	and    $0x3,%ecx
  10558f:	74 02                	je     105593 <memcpy+0x38>
  105591:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105593:	89 f0                	mov    %esi,%eax
  105595:	89 fa                	mov    %edi,%edx
  105597:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10559a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10559d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1055a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1055a3:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1055a4:	83 c4 20             	add    $0x20,%esp
  1055a7:	5e                   	pop    %esi
  1055a8:	5f                   	pop    %edi
  1055a9:	5d                   	pop    %ebp
  1055aa:	c3                   	ret    

001055ab <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1055ab:	55                   	push   %ebp
  1055ac:	89 e5                	mov    %esp,%ebp
  1055ae:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1055b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1055b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1055bd:	eb 30                	jmp    1055ef <memcmp+0x44>
        if (*s1 != *s2) {
  1055bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055c2:	0f b6 10             	movzbl (%eax),%edx
  1055c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055c8:	0f b6 00             	movzbl (%eax),%eax
  1055cb:	38 c2                	cmp    %al,%dl
  1055cd:	74 18                	je     1055e7 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1055cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055d2:	0f b6 00             	movzbl (%eax),%eax
  1055d5:	0f b6 d0             	movzbl %al,%edx
  1055d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055db:	0f b6 00             	movzbl (%eax),%eax
  1055de:	0f b6 c0             	movzbl %al,%eax
  1055e1:	29 c2                	sub    %eax,%edx
  1055e3:	89 d0                	mov    %edx,%eax
  1055e5:	eb 1a                	jmp    105601 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1055e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1055eb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1055ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1055f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1055f5:	89 55 10             	mov    %edx,0x10(%ebp)
  1055f8:	85 c0                	test   %eax,%eax
  1055fa:	75 c3                	jne    1055bf <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1055fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105601:	c9                   	leave  
  105602:	c3                   	ret    

00105603 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105603:	55                   	push   %ebp
  105604:	89 e5                	mov    %esp,%ebp
  105606:	83 ec 38             	sub    $0x38,%esp
  105609:	8b 45 10             	mov    0x10(%ebp),%eax
  10560c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10560f:	8b 45 14             	mov    0x14(%ebp),%eax
  105612:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105615:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105618:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10561b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10561e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105621:	8b 45 18             	mov    0x18(%ebp),%eax
  105624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10562a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10562d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105630:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10563d:	74 1c                	je     10565b <printnum+0x58>
  10563f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105642:	ba 00 00 00 00       	mov    $0x0,%edx
  105647:	f7 75 e4             	divl   -0x1c(%ebp)
  10564a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10564d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105650:	ba 00 00 00 00       	mov    $0x0,%edx
  105655:	f7 75 e4             	divl   -0x1c(%ebp)
  105658:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10565b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10565e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105661:	f7 75 e4             	divl   -0x1c(%ebp)
  105664:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105667:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10566a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10566d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105670:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105673:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105679:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10567c:	8b 45 18             	mov    0x18(%ebp),%eax
  10567f:	ba 00 00 00 00       	mov    $0x0,%edx
  105684:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105687:	77 41                	ja     1056ca <printnum+0xc7>
  105689:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10568c:	72 05                	jb     105693 <printnum+0x90>
  10568e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105691:	77 37                	ja     1056ca <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105693:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105696:	83 e8 01             	sub    $0x1,%eax
  105699:	83 ec 04             	sub    $0x4,%esp
  10569c:	ff 75 20             	pushl  0x20(%ebp)
  10569f:	50                   	push   %eax
  1056a0:	ff 75 18             	pushl  0x18(%ebp)
  1056a3:	ff 75 ec             	pushl  -0x14(%ebp)
  1056a6:	ff 75 e8             	pushl  -0x18(%ebp)
  1056a9:	ff 75 0c             	pushl  0xc(%ebp)
  1056ac:	ff 75 08             	pushl  0x8(%ebp)
  1056af:	e8 4f ff ff ff       	call   105603 <printnum>
  1056b4:	83 c4 20             	add    $0x20,%esp
  1056b7:	eb 1b                	jmp    1056d4 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1056b9:	83 ec 08             	sub    $0x8,%esp
  1056bc:	ff 75 0c             	pushl  0xc(%ebp)
  1056bf:	ff 75 20             	pushl  0x20(%ebp)
  1056c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c5:	ff d0                	call   *%eax
  1056c7:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1056ca:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1056ce:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1056d2:	7f e5                	jg     1056b9 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1056d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056d7:	05 ac 6d 10 00       	add    $0x106dac,%eax
  1056dc:	0f b6 00             	movzbl (%eax),%eax
  1056df:	0f be c0             	movsbl %al,%eax
  1056e2:	83 ec 08             	sub    $0x8,%esp
  1056e5:	ff 75 0c             	pushl  0xc(%ebp)
  1056e8:	50                   	push   %eax
  1056e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ec:	ff d0                	call   *%eax
  1056ee:	83 c4 10             	add    $0x10,%esp
}
  1056f1:	90                   	nop
  1056f2:	c9                   	leave  
  1056f3:	c3                   	ret    

001056f4 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1056f4:	55                   	push   %ebp
  1056f5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1056f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1056fb:	7e 14                	jle    105711 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1056fd:	8b 45 08             	mov    0x8(%ebp),%eax
  105700:	8b 00                	mov    (%eax),%eax
  105702:	8d 48 08             	lea    0x8(%eax),%ecx
  105705:	8b 55 08             	mov    0x8(%ebp),%edx
  105708:	89 0a                	mov    %ecx,(%edx)
  10570a:	8b 50 04             	mov    0x4(%eax),%edx
  10570d:	8b 00                	mov    (%eax),%eax
  10570f:	eb 30                	jmp    105741 <getuint+0x4d>
    }
    else if (lflag) {
  105711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105715:	74 16                	je     10572d <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105717:	8b 45 08             	mov    0x8(%ebp),%eax
  10571a:	8b 00                	mov    (%eax),%eax
  10571c:	8d 48 04             	lea    0x4(%eax),%ecx
  10571f:	8b 55 08             	mov    0x8(%ebp),%edx
  105722:	89 0a                	mov    %ecx,(%edx)
  105724:	8b 00                	mov    (%eax),%eax
  105726:	ba 00 00 00 00       	mov    $0x0,%edx
  10572b:	eb 14                	jmp    105741 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10572d:	8b 45 08             	mov    0x8(%ebp),%eax
  105730:	8b 00                	mov    (%eax),%eax
  105732:	8d 48 04             	lea    0x4(%eax),%ecx
  105735:	8b 55 08             	mov    0x8(%ebp),%edx
  105738:	89 0a                	mov    %ecx,(%edx)
  10573a:	8b 00                	mov    (%eax),%eax
  10573c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105741:	5d                   	pop    %ebp
  105742:	c3                   	ret    

00105743 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105743:	55                   	push   %ebp
  105744:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105746:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10574a:	7e 14                	jle    105760 <getint+0x1d>
        return va_arg(*ap, long long);
  10574c:	8b 45 08             	mov    0x8(%ebp),%eax
  10574f:	8b 00                	mov    (%eax),%eax
  105751:	8d 48 08             	lea    0x8(%eax),%ecx
  105754:	8b 55 08             	mov    0x8(%ebp),%edx
  105757:	89 0a                	mov    %ecx,(%edx)
  105759:	8b 50 04             	mov    0x4(%eax),%edx
  10575c:	8b 00                	mov    (%eax),%eax
  10575e:	eb 28                	jmp    105788 <getint+0x45>
    }
    else if (lflag) {
  105760:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105764:	74 12                	je     105778 <getint+0x35>
        return va_arg(*ap, long);
  105766:	8b 45 08             	mov    0x8(%ebp),%eax
  105769:	8b 00                	mov    (%eax),%eax
  10576b:	8d 48 04             	lea    0x4(%eax),%ecx
  10576e:	8b 55 08             	mov    0x8(%ebp),%edx
  105771:	89 0a                	mov    %ecx,(%edx)
  105773:	8b 00                	mov    (%eax),%eax
  105775:	99                   	cltd   
  105776:	eb 10                	jmp    105788 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105778:	8b 45 08             	mov    0x8(%ebp),%eax
  10577b:	8b 00                	mov    (%eax),%eax
  10577d:	8d 48 04             	lea    0x4(%eax),%ecx
  105780:	8b 55 08             	mov    0x8(%ebp),%edx
  105783:	89 0a                	mov    %ecx,(%edx)
  105785:	8b 00                	mov    (%eax),%eax
  105787:	99                   	cltd   
    }
}
  105788:	5d                   	pop    %ebp
  105789:	c3                   	ret    

0010578a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10578a:	55                   	push   %ebp
  10578b:	89 e5                	mov    %esp,%ebp
  10578d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  105790:	8d 45 14             	lea    0x14(%ebp),%eax
  105793:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105799:	50                   	push   %eax
  10579a:	ff 75 10             	pushl  0x10(%ebp)
  10579d:	ff 75 0c             	pushl  0xc(%ebp)
  1057a0:	ff 75 08             	pushl  0x8(%ebp)
  1057a3:	e8 06 00 00 00       	call   1057ae <vprintfmt>
  1057a8:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1057ab:	90                   	nop
  1057ac:	c9                   	leave  
  1057ad:	c3                   	ret    

001057ae <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1057ae:	55                   	push   %ebp
  1057af:	89 e5                	mov    %esp,%ebp
  1057b1:	56                   	push   %esi
  1057b2:	53                   	push   %ebx
  1057b3:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057b6:	eb 17                	jmp    1057cf <vprintfmt+0x21>
            if (ch == '\0') {
  1057b8:	85 db                	test   %ebx,%ebx
  1057ba:	0f 84 8e 03 00 00    	je     105b4e <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1057c0:	83 ec 08             	sub    $0x8,%esp
  1057c3:	ff 75 0c             	pushl  0xc(%ebp)
  1057c6:	53                   	push   %ebx
  1057c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ca:	ff d0                	call   *%eax
  1057cc:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1057d2:	8d 50 01             	lea    0x1(%eax),%edx
  1057d5:	89 55 10             	mov    %edx,0x10(%ebp)
  1057d8:	0f b6 00             	movzbl (%eax),%eax
  1057db:	0f b6 d8             	movzbl %al,%ebx
  1057de:	83 fb 25             	cmp    $0x25,%ebx
  1057e1:	75 d5                	jne    1057b8 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1057e3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1057e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1057ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1057f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1057fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105801:	8b 45 10             	mov    0x10(%ebp),%eax
  105804:	8d 50 01             	lea    0x1(%eax),%edx
  105807:	89 55 10             	mov    %edx,0x10(%ebp)
  10580a:	0f b6 00             	movzbl (%eax),%eax
  10580d:	0f b6 d8             	movzbl %al,%ebx
  105810:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105813:	83 f8 55             	cmp    $0x55,%eax
  105816:	0f 87 05 03 00 00    	ja     105b21 <vprintfmt+0x373>
  10581c:	8b 04 85 d0 6d 10 00 	mov    0x106dd0(,%eax,4),%eax
  105823:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105825:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105829:	eb d6                	jmp    105801 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10582b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10582f:	eb d0                	jmp    105801 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105831:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105838:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10583b:	89 d0                	mov    %edx,%eax
  10583d:	c1 e0 02             	shl    $0x2,%eax
  105840:	01 d0                	add    %edx,%eax
  105842:	01 c0                	add    %eax,%eax
  105844:	01 d8                	add    %ebx,%eax
  105846:	83 e8 30             	sub    $0x30,%eax
  105849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10584c:	8b 45 10             	mov    0x10(%ebp),%eax
  10584f:	0f b6 00             	movzbl (%eax),%eax
  105852:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105855:	83 fb 2f             	cmp    $0x2f,%ebx
  105858:	7e 39                	jle    105893 <vprintfmt+0xe5>
  10585a:	83 fb 39             	cmp    $0x39,%ebx
  10585d:	7f 34                	jg     105893 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10585f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105863:	eb d3                	jmp    105838 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105865:	8b 45 14             	mov    0x14(%ebp),%eax
  105868:	8d 50 04             	lea    0x4(%eax),%edx
  10586b:	89 55 14             	mov    %edx,0x14(%ebp)
  10586e:	8b 00                	mov    (%eax),%eax
  105870:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105873:	eb 1f                	jmp    105894 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  105875:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105879:	79 86                	jns    105801 <vprintfmt+0x53>
                width = 0;
  10587b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105882:	e9 7a ff ff ff       	jmp    105801 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105887:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10588e:	e9 6e ff ff ff       	jmp    105801 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  105893:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  105894:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105898:	0f 89 63 ff ff ff    	jns    105801 <vprintfmt+0x53>
                width = precision, precision = -1;
  10589e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1058ab:	e9 51 ff ff ff       	jmp    105801 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1058b0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1058b4:	e9 48 ff ff ff       	jmp    105801 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1058b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1058bc:	8d 50 04             	lea    0x4(%eax),%edx
  1058bf:	89 55 14             	mov    %edx,0x14(%ebp)
  1058c2:	8b 00                	mov    (%eax),%eax
  1058c4:	83 ec 08             	sub    $0x8,%esp
  1058c7:	ff 75 0c             	pushl  0xc(%ebp)
  1058ca:	50                   	push   %eax
  1058cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ce:	ff d0                	call   *%eax
  1058d0:	83 c4 10             	add    $0x10,%esp
            break;
  1058d3:	e9 71 02 00 00       	jmp    105b49 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1058d8:	8b 45 14             	mov    0x14(%ebp),%eax
  1058db:	8d 50 04             	lea    0x4(%eax),%edx
  1058de:	89 55 14             	mov    %edx,0x14(%ebp)
  1058e1:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1058e3:	85 db                	test   %ebx,%ebx
  1058e5:	79 02                	jns    1058e9 <vprintfmt+0x13b>
                err = -err;
  1058e7:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1058e9:	83 fb 06             	cmp    $0x6,%ebx
  1058ec:	7f 0b                	jg     1058f9 <vprintfmt+0x14b>
  1058ee:	8b 34 9d 90 6d 10 00 	mov    0x106d90(,%ebx,4),%esi
  1058f5:	85 f6                	test   %esi,%esi
  1058f7:	75 19                	jne    105912 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  1058f9:	53                   	push   %ebx
  1058fa:	68 bd 6d 10 00       	push   $0x106dbd
  1058ff:	ff 75 0c             	pushl  0xc(%ebp)
  105902:	ff 75 08             	pushl  0x8(%ebp)
  105905:	e8 80 fe ff ff       	call   10578a <printfmt>
  10590a:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10590d:	e9 37 02 00 00       	jmp    105b49 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105912:	56                   	push   %esi
  105913:	68 c6 6d 10 00       	push   $0x106dc6
  105918:	ff 75 0c             	pushl  0xc(%ebp)
  10591b:	ff 75 08             	pushl  0x8(%ebp)
  10591e:	e8 67 fe ff ff       	call   10578a <printfmt>
  105923:	83 c4 10             	add    $0x10,%esp
            }
            break;
  105926:	e9 1e 02 00 00       	jmp    105b49 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10592b:	8b 45 14             	mov    0x14(%ebp),%eax
  10592e:	8d 50 04             	lea    0x4(%eax),%edx
  105931:	89 55 14             	mov    %edx,0x14(%ebp)
  105934:	8b 30                	mov    (%eax),%esi
  105936:	85 f6                	test   %esi,%esi
  105938:	75 05                	jne    10593f <vprintfmt+0x191>
                p = "(null)";
  10593a:	be c9 6d 10 00       	mov    $0x106dc9,%esi
            }
            if (width > 0 && padc != '-') {
  10593f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105943:	7e 76                	jle    1059bb <vprintfmt+0x20d>
  105945:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105949:	74 70                	je     1059bb <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10594b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10594e:	83 ec 08             	sub    $0x8,%esp
  105951:	50                   	push   %eax
  105952:	56                   	push   %esi
  105953:	e8 17 f8 ff ff       	call   10516f <strnlen>
  105958:	83 c4 10             	add    $0x10,%esp
  10595b:	89 c2                	mov    %eax,%edx
  10595d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105960:	29 d0                	sub    %edx,%eax
  105962:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105965:	eb 17                	jmp    10597e <vprintfmt+0x1d0>
                    putch(padc, putdat);
  105967:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10596b:	83 ec 08             	sub    $0x8,%esp
  10596e:	ff 75 0c             	pushl  0xc(%ebp)
  105971:	50                   	push   %eax
  105972:	8b 45 08             	mov    0x8(%ebp),%eax
  105975:	ff d0                	call   *%eax
  105977:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10597a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10597e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105982:	7f e3                	jg     105967 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105984:	eb 35                	jmp    1059bb <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  105986:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10598a:	74 1c                	je     1059a8 <vprintfmt+0x1fa>
  10598c:	83 fb 1f             	cmp    $0x1f,%ebx
  10598f:	7e 05                	jle    105996 <vprintfmt+0x1e8>
  105991:	83 fb 7e             	cmp    $0x7e,%ebx
  105994:	7e 12                	jle    1059a8 <vprintfmt+0x1fa>
                    putch('?', putdat);
  105996:	83 ec 08             	sub    $0x8,%esp
  105999:	ff 75 0c             	pushl  0xc(%ebp)
  10599c:	6a 3f                	push   $0x3f
  10599e:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a1:	ff d0                	call   *%eax
  1059a3:	83 c4 10             	add    $0x10,%esp
  1059a6:	eb 0f                	jmp    1059b7 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1059a8:	83 ec 08             	sub    $0x8,%esp
  1059ab:	ff 75 0c             	pushl  0xc(%ebp)
  1059ae:	53                   	push   %ebx
  1059af:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b2:	ff d0                	call   *%eax
  1059b4:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059b7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1059bb:	89 f0                	mov    %esi,%eax
  1059bd:	8d 70 01             	lea    0x1(%eax),%esi
  1059c0:	0f b6 00             	movzbl (%eax),%eax
  1059c3:	0f be d8             	movsbl %al,%ebx
  1059c6:	85 db                	test   %ebx,%ebx
  1059c8:	74 26                	je     1059f0 <vprintfmt+0x242>
  1059ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059ce:	78 b6                	js     105986 <vprintfmt+0x1d8>
  1059d0:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1059d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059d8:	79 ac                	jns    105986 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059da:	eb 14                	jmp    1059f0 <vprintfmt+0x242>
                putch(' ', putdat);
  1059dc:	83 ec 08             	sub    $0x8,%esp
  1059df:	ff 75 0c             	pushl  0xc(%ebp)
  1059e2:	6a 20                	push   $0x20
  1059e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e7:	ff d0                	call   *%eax
  1059e9:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059ec:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1059f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059f4:	7f e6                	jg     1059dc <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  1059f6:	e9 4e 01 00 00       	jmp    105b49 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1059fb:	83 ec 08             	sub    $0x8,%esp
  1059fe:	ff 75 e0             	pushl  -0x20(%ebp)
  105a01:	8d 45 14             	lea    0x14(%ebp),%eax
  105a04:	50                   	push   %eax
  105a05:	e8 39 fd ff ff       	call   105743 <getint>
  105a0a:	83 c4 10             	add    $0x10,%esp
  105a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a10:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a19:	85 d2                	test   %edx,%edx
  105a1b:	79 23                	jns    105a40 <vprintfmt+0x292>
                putch('-', putdat);
  105a1d:	83 ec 08             	sub    $0x8,%esp
  105a20:	ff 75 0c             	pushl  0xc(%ebp)
  105a23:	6a 2d                	push   $0x2d
  105a25:	8b 45 08             	mov    0x8(%ebp),%eax
  105a28:	ff d0                	call   *%eax
  105a2a:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  105a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a33:	f7 d8                	neg    %eax
  105a35:	83 d2 00             	adc    $0x0,%edx
  105a38:	f7 da                	neg    %edx
  105a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a40:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a47:	e9 9f 00 00 00       	jmp    105aeb <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a4c:	83 ec 08             	sub    $0x8,%esp
  105a4f:	ff 75 e0             	pushl  -0x20(%ebp)
  105a52:	8d 45 14             	lea    0x14(%ebp),%eax
  105a55:	50                   	push   %eax
  105a56:	e8 99 fc ff ff       	call   1056f4 <getuint>
  105a5b:	83 c4 10             	add    $0x10,%esp
  105a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a6b:	eb 7e                	jmp    105aeb <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105a6d:	83 ec 08             	sub    $0x8,%esp
  105a70:	ff 75 e0             	pushl  -0x20(%ebp)
  105a73:	8d 45 14             	lea    0x14(%ebp),%eax
  105a76:	50                   	push   %eax
  105a77:	e8 78 fc ff ff       	call   1056f4 <getuint>
  105a7c:	83 c4 10             	add    $0x10,%esp
  105a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105a85:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105a8c:	eb 5d                	jmp    105aeb <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  105a8e:	83 ec 08             	sub    $0x8,%esp
  105a91:	ff 75 0c             	pushl  0xc(%ebp)
  105a94:	6a 30                	push   $0x30
  105a96:	8b 45 08             	mov    0x8(%ebp),%eax
  105a99:	ff d0                	call   *%eax
  105a9b:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  105a9e:	83 ec 08             	sub    $0x8,%esp
  105aa1:	ff 75 0c             	pushl  0xc(%ebp)
  105aa4:	6a 78                	push   $0x78
  105aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa9:	ff d0                	call   *%eax
  105aab:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105aae:	8b 45 14             	mov    0x14(%ebp),%eax
  105ab1:	8d 50 04             	lea    0x4(%eax),%edx
  105ab4:	89 55 14             	mov    %edx,0x14(%ebp)
  105ab7:	8b 00                	mov    (%eax),%eax
  105ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105abc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ac3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105aca:	eb 1f                	jmp    105aeb <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105acc:	83 ec 08             	sub    $0x8,%esp
  105acf:	ff 75 e0             	pushl  -0x20(%ebp)
  105ad2:	8d 45 14             	lea    0x14(%ebp),%eax
  105ad5:	50                   	push   %eax
  105ad6:	e8 19 fc ff ff       	call   1056f4 <getuint>
  105adb:	83 c4 10             	add    $0x10,%esp
  105ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ae1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105ae4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105aeb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105af2:	83 ec 04             	sub    $0x4,%esp
  105af5:	52                   	push   %edx
  105af6:	ff 75 e8             	pushl  -0x18(%ebp)
  105af9:	50                   	push   %eax
  105afa:	ff 75 f4             	pushl  -0xc(%ebp)
  105afd:	ff 75 f0             	pushl  -0x10(%ebp)
  105b00:	ff 75 0c             	pushl  0xc(%ebp)
  105b03:	ff 75 08             	pushl  0x8(%ebp)
  105b06:	e8 f8 fa ff ff       	call   105603 <printnum>
  105b0b:	83 c4 20             	add    $0x20,%esp
            break;
  105b0e:	eb 39                	jmp    105b49 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b10:	83 ec 08             	sub    $0x8,%esp
  105b13:	ff 75 0c             	pushl  0xc(%ebp)
  105b16:	53                   	push   %ebx
  105b17:	8b 45 08             	mov    0x8(%ebp),%eax
  105b1a:	ff d0                	call   *%eax
  105b1c:	83 c4 10             	add    $0x10,%esp
            break;
  105b1f:	eb 28                	jmp    105b49 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b21:	83 ec 08             	sub    $0x8,%esp
  105b24:	ff 75 0c             	pushl  0xc(%ebp)
  105b27:	6a 25                	push   $0x25
  105b29:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2c:	ff d0                	call   *%eax
  105b2e:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b31:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b35:	eb 04                	jmp    105b3b <vprintfmt+0x38d>
  105b37:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  105b3e:	83 e8 01             	sub    $0x1,%eax
  105b41:	0f b6 00             	movzbl (%eax),%eax
  105b44:	3c 25                	cmp    $0x25,%al
  105b46:	75 ef                	jne    105b37 <vprintfmt+0x389>
                /* do nothing */;
            break;
  105b48:	90                   	nop
        }
    }
  105b49:	e9 68 fc ff ff       	jmp    1057b6 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  105b4e:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  105b52:	5b                   	pop    %ebx
  105b53:	5e                   	pop    %esi
  105b54:	5d                   	pop    %ebp
  105b55:	c3                   	ret    

00105b56 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105b56:	55                   	push   %ebp
  105b57:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b5c:	8b 40 08             	mov    0x8(%eax),%eax
  105b5f:	8d 50 01             	lea    0x1(%eax),%edx
  105b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b65:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b6b:	8b 10                	mov    (%eax),%edx
  105b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b70:	8b 40 04             	mov    0x4(%eax),%eax
  105b73:	39 c2                	cmp    %eax,%edx
  105b75:	73 12                	jae    105b89 <sprintputch+0x33>
        *b->buf ++ = ch;
  105b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7a:	8b 00                	mov    (%eax),%eax
  105b7c:	8d 48 01             	lea    0x1(%eax),%ecx
  105b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b82:	89 0a                	mov    %ecx,(%edx)
  105b84:	8b 55 08             	mov    0x8(%ebp),%edx
  105b87:	88 10                	mov    %dl,(%eax)
    }
}
  105b89:	90                   	nop
  105b8a:	5d                   	pop    %ebp
  105b8b:	c3                   	ret    

00105b8c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105b8c:	55                   	push   %ebp
  105b8d:	89 e5                	mov    %esp,%ebp
  105b8f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105b92:	8d 45 14             	lea    0x14(%ebp),%eax
  105b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b9b:	50                   	push   %eax
  105b9c:	ff 75 10             	pushl  0x10(%ebp)
  105b9f:	ff 75 0c             	pushl  0xc(%ebp)
  105ba2:	ff 75 08             	pushl  0x8(%ebp)
  105ba5:	e8 0b 00 00 00       	call   105bb5 <vsnprintf>
  105baa:	83 c4 10             	add    $0x10,%esp
  105bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bb3:	c9                   	leave  
  105bb4:	c3                   	ret    

00105bb5 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105bb5:	55                   	push   %ebp
  105bb6:	89 e5                	mov    %esp,%ebp
  105bb8:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  105bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  105bca:	01 d0                	add    %edx,%eax
  105bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105bd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105bda:	74 0a                	je     105be6 <vsnprintf+0x31>
  105bdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105be2:	39 c2                	cmp    %eax,%edx
  105be4:	76 07                	jbe    105bed <vsnprintf+0x38>
        return -E_INVAL;
  105be6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105beb:	eb 20                	jmp    105c0d <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105bed:	ff 75 14             	pushl  0x14(%ebp)
  105bf0:	ff 75 10             	pushl  0x10(%ebp)
  105bf3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105bf6:	50                   	push   %eax
  105bf7:	68 56 5b 10 00       	push   $0x105b56
  105bfc:	e8 ad fb ff ff       	call   1057ae <vprintfmt>
  105c01:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  105c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c07:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c0d:	c9                   	leave  
  105c0e:	c3                   	ret    
