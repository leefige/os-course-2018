
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 d5 2e 00 00       	call   102ef9 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 31 15 00 00       	call   10155d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 a0 36 10 00 	movl   $0x1036a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 bc 36 10 00       	push   $0x1036bc
  10003e:	e8 07 02 00 00       	call   10024a <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 89 08 00 00       	call   1008d4 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 68 2b 00 00       	call   102bbd <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 46 16 00 00       	call   1016a0 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 c8 17 00 00       	call   101827 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 de 0c 00 00       	call   100d42 <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 74 17 00 00       	call   1017dd <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 4d 01 00 00       	call   1001bb <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 ac 0c 00 00       	call   100d30 <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	90                   	nop
  100088:	c9                   	leave  
  100089:	c3                   	ret    

0010008a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10008a:	55                   	push   %ebp
  10008b:	89 e5                	mov    %esp,%ebp
  10008d:	53                   	push   %ebx
  10008e:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100091:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100094:	8b 55 0c             	mov    0xc(%ebp),%edx
  100097:	8d 5d 08             	lea    0x8(%ebp),%ebx
  10009a:	8b 45 08             	mov    0x8(%ebp),%eax
  10009d:	51                   	push   %ecx
  10009e:	52                   	push   %edx
  10009f:	53                   	push   %ebx
  1000a0:	50                   	push   %eax
  1000a1:	e8 ca ff ff ff       	call   100070 <grade_backtrace2>
  1000a6:	83 c4 10             	add    $0x10,%esp
}
  1000a9:	90                   	nop
  1000aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b5:	83 ec 08             	sub    $0x8,%esp
  1000b8:	ff 75 10             	pushl  0x10(%ebp)
  1000bb:	ff 75 08             	pushl  0x8(%ebp)
  1000be:	e8 c7 ff ff ff       	call   10008a <grade_backtrace1>
  1000c3:	83 c4 10             	add    $0x10,%esp
}
  1000c6:	90                   	nop
  1000c7:	c9                   	leave  
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cf:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d4:	83 ec 04             	sub    $0x4,%esp
  1000d7:	68 00 00 ff ff       	push   $0xffff0000
  1000dc:	50                   	push   %eax
  1000dd:	6a 00                	push   $0x0
  1000df:	e8 cb ff ff ff       	call   1000af <grade_backtrace0>
  1000e4:	83 c4 10             	add    $0x10,%esp
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000ea:	55                   	push   %ebp
  1000eb:	89 e5                	mov    %esp,%ebp
  1000ed:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000f0:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000f3:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f6:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f9:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000fc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100100:	0f b7 c0             	movzwl %ax,%eax
  100103:	83 e0 03             	and    $0x3,%eax
  100106:	89 c2                	mov    %eax,%edx
  100108:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10010d:	83 ec 04             	sub    $0x4,%esp
  100110:	52                   	push   %edx
  100111:	50                   	push   %eax
  100112:	68 c1 36 10 00       	push   $0x1036c1
  100117:	e8 2e 01 00 00       	call   10024a <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 cf 36 10 00       	push   $0x1036cf
  100135:	e8 10 01 00 00       	call   10024a <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 dd 36 10 00       	push   $0x1036dd
  100153:	e8 f2 00 00 00       	call   10024a <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 eb 36 10 00       	push   $0x1036eb
  100171:	e8 d4 00 00 00       	call   10024a <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 f9 36 10 00       	push   $0x1036f9
  10018f:	e8 b6 00 00 00       	call   10024a <cprintf>
  100194:	83 c4 10             	add    $0x10,%esp
    round ++;
  100197:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10019c:	83 c0 01             	add    $0x1,%eax
  10019f:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001a4:	90                   	nop
  1001a5:	c9                   	leave  
  1001a6:	c3                   	ret    

001001a7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a7:	55                   	push   %ebp
  1001a8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    // "movl %%ebp, %%esp" esure that before ret, esp = ebp -> old ebp
    asm volatile (
  1001aa:	cd 78                	int    $0x78
  1001ac:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001ae:	90                   	nop
  1001af:	5d                   	pop    %ebp
  1001b0:	c3                   	ret    

001001b1 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b1:	55                   	push   %ebp
  1001b2:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    // cprintf("in lab1_switch_to_kernel\n");
    asm volatile (
  1001b4:	cd 79                	int    $0x79
  1001b6:	89 ec                	mov    %ebp,%esp
	    "int %0;"
        "movl %%ebp, %%esp"
        : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001b8:	90                   	nop
  1001b9:	5d                   	pop    %ebp
  1001ba:	c3                   	ret    

001001bb <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001bb:	55                   	push   %ebp
  1001bc:	89 e5                	mov    %esp,%ebp
  1001be:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c1:	e8 24 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c6:	83 ec 0c             	sub    $0xc,%esp
  1001c9:	68 08 37 10 00       	push   $0x103708
  1001ce:	e8 77 00 00 00       	call   10024a <cprintf>
  1001d3:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d6:	e8 cc ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001db:	e8 0a ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001e0:	83 ec 0c             	sub    $0xc,%esp
  1001e3:	68 28 37 10 00       	push   $0x103728
  1001e8:	e8 5d 00 00 00       	call   10024a <cprintf>
  1001ed:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001f0:	e8 bc ff ff ff       	call   1001b1 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f5:	e8 f0 fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  1001fa:	90                   	nop
  1001fb:	c9                   	leave  
  1001fc:	c3                   	ret    

001001fd <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001fd:	55                   	push   %ebp
  1001fe:	89 e5                	mov    %esp,%ebp
  100200:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100203:	83 ec 0c             	sub    $0xc,%esp
  100206:	ff 75 08             	pushl  0x8(%ebp)
  100209:	e8 80 13 00 00       	call   10158e <cons_putc>
  10020e:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100211:	8b 45 0c             	mov    0xc(%ebp),%eax
  100214:	8b 00                	mov    (%eax),%eax
  100216:	8d 50 01             	lea    0x1(%eax),%edx
  100219:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021c:	89 10                	mov    %edx,(%eax)
}
  10021e:	90                   	nop
  10021f:	c9                   	leave  
  100220:	c3                   	ret    

00100221 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
  100224:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10022e:	ff 75 0c             	pushl  0xc(%ebp)
  100231:	ff 75 08             	pushl  0x8(%ebp)
  100234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100237:	50                   	push   %eax
  100238:	68 fd 01 10 00       	push   $0x1001fd
  10023d:	e8 ed 2f 00 00       	call   10322f <vprintfmt>
  100242:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100245:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100248:	c9                   	leave  
  100249:	c3                   	ret    

0010024a <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10024a:	55                   	push   %ebp
  10024b:	89 e5                	mov    %esp,%ebp
  10024d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100250:	8d 45 0c             	lea    0xc(%ebp),%eax
  100253:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100259:	83 ec 08             	sub    $0x8,%esp
  10025c:	50                   	push   %eax
  10025d:	ff 75 08             	pushl  0x8(%ebp)
  100260:	e8 bc ff ff ff       	call   100221 <vcprintf>
  100265:	83 c4 10             	add    $0x10,%esp
  100268:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10026b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026e:	c9                   	leave  
  10026f:	c3                   	ret    

00100270 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100270:	55                   	push   %ebp
  100271:	89 e5                	mov    %esp,%ebp
  100273:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100276:	83 ec 0c             	sub    $0xc,%esp
  100279:	ff 75 08             	pushl  0x8(%ebp)
  10027c:	e8 0d 13 00 00       	call   10158e <cons_putc>
  100281:	83 c4 10             	add    $0x10,%esp
}
  100284:	90                   	nop
  100285:	c9                   	leave  
  100286:	c3                   	ret    

00100287 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100287:	55                   	push   %ebp
  100288:	89 e5                	mov    %esp,%ebp
  10028a:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10028d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100294:	eb 14                	jmp    1002aa <cputs+0x23>
        cputch(c, &cnt);
  100296:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10029a:	83 ec 08             	sub    $0x8,%esp
  10029d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002a0:	52                   	push   %edx
  1002a1:	50                   	push   %eax
  1002a2:	e8 56 ff ff ff       	call   1001fd <cputch>
  1002a7:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ad:	8d 50 01             	lea    0x1(%eax),%edx
  1002b0:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b3:	0f b6 00             	movzbl (%eax),%eax
  1002b6:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002b9:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002bd:	75 d7                	jne    100296 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002bf:	83 ec 08             	sub    $0x8,%esp
  1002c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c5:	50                   	push   %eax
  1002c6:	6a 0a                	push   $0xa
  1002c8:	e8 30 ff ff ff       	call   1001fd <cputch>
  1002cd:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002d3:	c9                   	leave  
  1002d4:	c3                   	ret    

001002d5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d5:	55                   	push   %ebp
  1002d6:	89 e5                	mov    %esp,%ebp
  1002d8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002db:	e8 de 12 00 00       	call   1015be <cons_getc>
  1002e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002e7:	74 f2                	je     1002db <getchar+0x6>
        /* do nothing */;
    return c;
  1002e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ec:	c9                   	leave  
  1002ed:	c3                   	ret    

001002ee <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002ee:	55                   	push   %ebp
  1002ef:	89 e5                	mov    %esp,%ebp
  1002f1:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002f8:	74 13                	je     10030d <readline+0x1f>
        cprintf("%s", prompt);
  1002fa:	83 ec 08             	sub    $0x8,%esp
  1002fd:	ff 75 08             	pushl  0x8(%ebp)
  100300:	68 47 37 10 00       	push   $0x103747
  100305:	e8 40 ff ff ff       	call   10024a <cprintf>
  10030a:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10030d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100314:	e8 bc ff ff ff       	call   1002d5 <getchar>
  100319:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10031c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100320:	79 0a                	jns    10032c <readline+0x3e>
            return NULL;
  100322:	b8 00 00 00 00       	mov    $0x0,%eax
  100327:	e9 82 00 00 00       	jmp    1003ae <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10032c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100330:	7e 2b                	jle    10035d <readline+0x6f>
  100332:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100339:	7f 22                	jg     10035d <readline+0x6f>
            cputchar(c);
  10033b:	83 ec 0c             	sub    $0xc,%esp
  10033e:	ff 75 f0             	pushl  -0x10(%ebp)
  100341:	e8 2a ff ff ff       	call   100270 <cputchar>
  100346:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10034c:	8d 50 01             	lea    0x1(%eax),%edx
  10034f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100355:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10035b:	eb 4c                	jmp    1003a9 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10035d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100361:	75 1a                	jne    10037d <readline+0x8f>
  100363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100367:	7e 14                	jle    10037d <readline+0x8f>
            cputchar(c);
  100369:	83 ec 0c             	sub    $0xc,%esp
  10036c:	ff 75 f0             	pushl  -0x10(%ebp)
  10036f:	e8 fc fe ff ff       	call   100270 <cputchar>
  100374:	83 c4 10             	add    $0x10,%esp
            i --;
  100377:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10037b:	eb 2c                	jmp    1003a9 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10037d:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100381:	74 06                	je     100389 <readline+0x9b>
  100383:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100387:	75 8b                	jne    100314 <readline+0x26>
            cputchar(c);
  100389:	83 ec 0c             	sub    $0xc,%esp
  10038c:	ff 75 f0             	pushl  -0x10(%ebp)
  10038f:	e8 dc fe ff ff       	call   100270 <cputchar>
  100394:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  100397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039a:	05 40 ea 10 00       	add    $0x10ea40,%eax
  10039f:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a2:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003a7:	eb 05                	jmp    1003ae <readline+0xc0>
        }
    }
  1003a9:	e9 66 ff ff ff       	jmp    100314 <readline+0x26>
}
  1003ae:	c9                   	leave  
  1003af:	c3                   	ret    

001003b0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b0:	55                   	push   %ebp
  1003b1:	89 e5                	mov    %esp,%ebp
  1003b3:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003b6:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003bb:	85 c0                	test   %eax,%eax
  1003bd:	75 4a                	jne    100409 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003bf:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003c9:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003cf:	83 ec 04             	sub    $0x4,%esp
  1003d2:	ff 75 0c             	pushl  0xc(%ebp)
  1003d5:	ff 75 08             	pushl  0x8(%ebp)
  1003d8:	68 4a 37 10 00       	push   $0x10374a
  1003dd:	e8 68 fe ff ff       	call   10024a <cprintf>
  1003e2:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e8:	83 ec 08             	sub    $0x8,%esp
  1003eb:	50                   	push   %eax
  1003ec:	ff 75 10             	pushl  0x10(%ebp)
  1003ef:	e8 2d fe ff ff       	call   100221 <vcprintf>
  1003f4:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003f7:	83 ec 0c             	sub    $0xc,%esp
  1003fa:	68 66 37 10 00       	push   $0x103766
  1003ff:	e8 46 fe ff ff       	call   10024a <cprintf>
  100404:	83 c4 10             	add    $0x10,%esp
  100407:	eb 01                	jmp    10040a <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100409:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  10040a:	e8 d5 13 00 00       	call   1017e4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10040f:	83 ec 0c             	sub    $0xc,%esp
  100412:	6a 00                	push   $0x0
  100414:	e8 3d 08 00 00       	call   100c56 <kmonitor>
  100419:	83 c4 10             	add    $0x10,%esp
    }
  10041c:	eb f1                	jmp    10040f <__panic+0x5f>

0010041e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10041e:	55                   	push   %ebp
  10041f:	89 e5                	mov    %esp,%ebp
  100421:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100424:	8d 45 14             	lea    0x14(%ebp),%eax
  100427:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10042a:	83 ec 04             	sub    $0x4,%esp
  10042d:	ff 75 0c             	pushl  0xc(%ebp)
  100430:	ff 75 08             	pushl  0x8(%ebp)
  100433:	68 68 37 10 00       	push   $0x103768
  100438:	e8 0d fe ff ff       	call   10024a <cprintf>
  10043d:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100443:	83 ec 08             	sub    $0x8,%esp
  100446:	50                   	push   %eax
  100447:	ff 75 10             	pushl  0x10(%ebp)
  10044a:	e8 d2 fd ff ff       	call   100221 <vcprintf>
  10044f:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100452:	83 ec 0c             	sub    $0xc,%esp
  100455:	68 66 37 10 00       	push   $0x103766
  10045a:	e8 eb fd ff ff       	call   10024a <cprintf>
  10045f:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100462:	90                   	nop
  100463:	c9                   	leave  
  100464:	c3                   	ret    

00100465 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100465:	55                   	push   %ebp
  100466:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100468:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10046d:	5d                   	pop    %ebp
  10046e:	c3                   	ret    

0010046f <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10046f:	55                   	push   %ebp
  100470:	89 e5                	mov    %esp,%ebp
  100472:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100475:	8b 45 0c             	mov    0xc(%ebp),%eax
  100478:	8b 00                	mov    (%eax),%eax
  10047a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10047d:	8b 45 10             	mov    0x10(%ebp),%eax
  100480:	8b 00                	mov    (%eax),%eax
  100482:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100485:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10048c:	e9 d2 00 00 00       	jmp    100563 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100491:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100497:	01 d0                	add    %edx,%eax
  100499:	89 c2                	mov    %eax,%edx
  10049b:	c1 ea 1f             	shr    $0x1f,%edx
  10049e:	01 d0                	add    %edx,%eax
  1004a0:	d1 f8                	sar    %eax
  1004a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ab:	eb 04                	jmp    1004b1 <stab_binsearch+0x42>
            m --;
  1004ad:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004b7:	7c 1f                	jl     1004d8 <stab_binsearch+0x69>
  1004b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bc:	89 d0                	mov    %edx,%eax
  1004be:	01 c0                	add    %eax,%eax
  1004c0:	01 d0                	add    %edx,%eax
  1004c2:	c1 e0 02             	shl    $0x2,%eax
  1004c5:	89 c2                	mov    %eax,%edx
  1004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ca:	01 d0                	add    %edx,%eax
  1004cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004d0:	0f b6 c0             	movzbl %al,%eax
  1004d3:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004d6:	75 d5                	jne    1004ad <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 0b                	jge    1004eb <stab_binsearch+0x7c>
            l = true_m + 1;
  1004e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e3:	83 c0 01             	add    $0x1,%eax
  1004e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004e9:	eb 78                	jmp    100563 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f5:	89 d0                	mov    %edx,%eax
  1004f7:	01 c0                	add    %eax,%eax
  1004f9:	01 d0                	add    %edx,%eax
  1004fb:	c1 e0 02             	shl    $0x2,%eax
  1004fe:	89 c2                	mov    %eax,%edx
  100500:	8b 45 08             	mov    0x8(%ebp),%eax
  100503:	01 d0                	add    %edx,%eax
  100505:	8b 40 08             	mov    0x8(%eax),%eax
  100508:	3b 45 18             	cmp    0x18(%ebp),%eax
  10050b:	73 13                	jae    100520 <stab_binsearch+0xb1>
            *region_left = m;
  10050d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100513:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	83 c0 01             	add    $0x1,%eax
  10051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10051e:	eb 43                	jmp    100563 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100520:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100523:	89 d0                	mov    %edx,%eax
  100525:	01 c0                	add    %eax,%eax
  100527:	01 d0                	add    %edx,%eax
  100529:	c1 e0 02             	shl    $0x2,%eax
  10052c:	89 c2                	mov    %eax,%edx
  10052e:	8b 45 08             	mov    0x8(%ebp),%eax
  100531:	01 d0                	add    %edx,%eax
  100533:	8b 40 08             	mov    0x8(%eax),%eax
  100536:	3b 45 18             	cmp    0x18(%ebp),%eax
  100539:	76 16                	jbe    100551 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10053b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053e:	8d 50 ff             	lea    -0x1(%eax),%edx
  100541:	8b 45 10             	mov    0x10(%ebp),%eax
  100544:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100549:	83 e8 01             	sub    $0x1,%eax
  10054c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10054f:	eb 12                	jmp    100563 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100551:	8b 45 0c             	mov    0xc(%ebp),%eax
  100554:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100557:	89 10                	mov    %edx,(%eax)
            l = m;
  100559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10055f:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100563:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100566:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100569:	0f 8e 22 ff ff ff    	jle    100491 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10056f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100573:	75 0f                	jne    100584 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	8b 00                	mov    (%eax),%eax
  10057a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10057d:	8b 45 10             	mov    0x10(%ebp),%eax
  100580:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100582:	eb 3f                	jmp    1005c3 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100584:	8b 45 10             	mov    0x10(%ebp),%eax
  100587:	8b 00                	mov    (%eax),%eax
  100589:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10058c:	eb 04                	jmp    100592 <stab_binsearch+0x123>
  10058e:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100592:	8b 45 0c             	mov    0xc(%ebp),%eax
  100595:	8b 00                	mov    (%eax),%eax
  100597:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10059a:	7d 1f                	jge    1005bb <stab_binsearch+0x14c>
  10059c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10059f:	89 d0                	mov    %edx,%eax
  1005a1:	01 c0                	add    %eax,%eax
  1005a3:	01 d0                	add    %edx,%eax
  1005a5:	c1 e0 02             	shl    $0x2,%eax
  1005a8:	89 c2                	mov    %eax,%edx
  1005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ad:	01 d0                	add    %edx,%eax
  1005af:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005b3:	0f b6 c0             	movzbl %al,%eax
  1005b6:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005b9:	75 d3                	jne    10058e <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c1:	89 10                	mov    %edx,(%eax)
    }
}
  1005c3:	90                   	nop
  1005c4:	c9                   	leave  
  1005c5:	c3                   	ret    

001005c6 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005c6:	55                   	push   %ebp
  1005c7:	89 e5                	mov    %esp,%ebp
  1005c9:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cf:	c7 00 88 37 10 00    	movl   $0x103788,(%eax)
    info->eip_line = 0;
  1005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e2:	c7 40 08 88 37 10 00 	movl   $0x103788,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1005f9:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ff:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100606:	c7 45 f4 2c 40 10 00 	movl   $0x10402c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10060d:	c7 45 f0 40 bc 10 00 	movl   $0x10bc40,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100614:	c7 45 ec 41 bc 10 00 	movl   $0x10bc41,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10061b:	c7 45 e8 de dc 10 00 	movl   $0x10dcde,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100625:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100628:	76 0d                	jbe    100637 <debuginfo_eip+0x71>
  10062a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10062d:	83 e8 01             	sub    $0x1,%eax
  100630:	0f b6 00             	movzbl (%eax),%eax
  100633:	84 c0                	test   %al,%al
  100635:	74 0a                	je     100641 <debuginfo_eip+0x7b>
        return -1;
  100637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10063c:	e9 91 02 00 00       	jmp    1008d2 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100648:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10064e:	29 c2                	sub    %eax,%edx
  100650:	89 d0                	mov    %edx,%eax
  100652:	c1 f8 02             	sar    $0x2,%eax
  100655:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10065b:	83 e8 01             	sub    $0x1,%eax
  10065e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100661:	ff 75 08             	pushl  0x8(%ebp)
  100664:	6a 64                	push   $0x64
  100666:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100669:	50                   	push   %eax
  10066a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10066d:	50                   	push   %eax
  10066e:	ff 75 f4             	pushl  -0xc(%ebp)
  100671:	e8 f9 fd ff ff       	call   10046f <stab_binsearch>
  100676:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10067c:	85 c0                	test   %eax,%eax
  10067e:	75 0a                	jne    10068a <debuginfo_eip+0xc4>
        return -1;
  100680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100685:	e9 48 02 00 00       	jmp    1008d2 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10068a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10068d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100693:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100696:	ff 75 08             	pushl  0x8(%ebp)
  100699:	6a 24                	push   $0x24
  10069b:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10069e:	50                   	push   %eax
  10069f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006a2:	50                   	push   %eax
  1006a3:	ff 75 f4             	pushl  -0xc(%ebp)
  1006a6:	e8 c4 fd ff ff       	call   10046f <stab_binsearch>
  1006ab:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b4:	39 c2                	cmp    %eax,%edx
  1006b6:	7f 7c                	jg     100734 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006bb:	89 c2                	mov    %eax,%edx
  1006bd:	89 d0                	mov    %edx,%eax
  1006bf:	01 c0                	add    %eax,%eax
  1006c1:	01 d0                	add    %edx,%eax
  1006c3:	c1 e0 02             	shl    $0x2,%eax
  1006c6:	89 c2                	mov    %eax,%edx
  1006c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006cb:	01 d0                	add    %edx,%eax
  1006cd:	8b 00                	mov    (%eax),%eax
  1006cf:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006d5:	29 d1                	sub    %edx,%ecx
  1006d7:	89 ca                	mov    %ecx,%edx
  1006d9:	39 d0                	cmp    %edx,%eax
  1006db:	73 22                	jae    1006ff <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e0:	89 c2                	mov    %eax,%edx
  1006e2:	89 d0                	mov    %edx,%eax
  1006e4:	01 c0                	add    %eax,%eax
  1006e6:	01 d0                	add    %edx,%eax
  1006e8:	c1 e0 02             	shl    $0x2,%eax
  1006eb:	89 c2                	mov    %eax,%edx
  1006ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f0:	01 d0                	add    %edx,%eax
  1006f2:	8b 10                	mov    (%eax),%edx
  1006f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006f7:	01 c2                	add    %eax,%edx
  1006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fc:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100702:	89 c2                	mov    %eax,%edx
  100704:	89 d0                	mov    %edx,%eax
  100706:	01 c0                	add    %eax,%eax
  100708:	01 d0                	add    %edx,%eax
  10070a:	c1 e0 02             	shl    $0x2,%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100712:	01 d0                	add    %edx,%eax
  100714:	8b 50 08             	mov    0x8(%eax),%edx
  100717:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071a:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10071d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100720:	8b 40 10             	mov    0x10(%eax),%eax
  100723:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100726:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100729:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10072c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10072f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100732:	eb 15                	jmp    100749 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100734:	8b 45 0c             	mov    0xc(%ebp),%eax
  100737:	8b 55 08             	mov    0x8(%ebp),%edx
  10073a:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10073d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100740:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100746:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100749:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074c:	8b 40 08             	mov    0x8(%eax),%eax
  10074f:	83 ec 08             	sub    $0x8,%esp
  100752:	6a 3a                	push   $0x3a
  100754:	50                   	push   %eax
  100755:	e8 13 26 00 00       	call   102d6d <strfind>
  10075a:	83 c4 10             	add    $0x10,%esp
  10075d:	89 c2                	mov    %eax,%edx
  10075f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100762:	8b 40 08             	mov    0x8(%eax),%eax
  100765:	29 c2                	sub    %eax,%edx
  100767:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076a:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10076d:	83 ec 0c             	sub    $0xc,%esp
  100770:	ff 75 08             	pushl  0x8(%ebp)
  100773:	6a 44                	push   $0x44
  100775:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100778:	50                   	push   %eax
  100779:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10077c:	50                   	push   %eax
  10077d:	ff 75 f4             	pushl  -0xc(%ebp)
  100780:	e8 ea fc ff ff       	call   10046f <stab_binsearch>
  100785:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  100788:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10078b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10078e:	39 c2                	cmp    %eax,%edx
  100790:	7f 24                	jg     1007b6 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100792:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100795:	89 c2                	mov    %eax,%edx
  100797:	89 d0                	mov    %edx,%eax
  100799:	01 c0                	add    %eax,%eax
  10079b:	01 d0                	add    %edx,%eax
  10079d:	c1 e0 02             	shl    $0x2,%eax
  1007a0:	89 c2                	mov    %eax,%edx
  1007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a5:	01 d0                	add    %edx,%eax
  1007a7:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ab:	0f b7 d0             	movzwl %ax,%edx
  1007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b1:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007b4:	eb 13                	jmp    1007c9 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007bb:	e9 12 01 00 00       	jmp    1008d2 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c3:	83 e8 01             	sub    $0x1,%eax
  1007c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cf:	39 c2                	cmp    %eax,%edx
  1007d1:	7c 56                	jl     100829 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d6:	89 c2                	mov    %eax,%edx
  1007d8:	89 d0                	mov    %edx,%eax
  1007da:	01 c0                	add    %eax,%eax
  1007dc:	01 d0                	add    %edx,%eax
  1007de:	c1 e0 02             	shl    $0x2,%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e6:	01 d0                	add    %edx,%eax
  1007e8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007ec:	3c 84                	cmp    $0x84,%al
  1007ee:	74 39                	je     100829 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	89 d0                	mov    %edx,%eax
  1007f7:	01 c0                	add    %eax,%eax
  1007f9:	01 d0                	add    %edx,%eax
  1007fb:	c1 e0 02             	shl    $0x2,%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100803:	01 d0                	add    %edx,%eax
  100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100809:	3c 64                	cmp    $0x64,%al
  10080b:	75 b3                	jne    1007c0 <debuginfo_eip+0x1fa>
  10080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100810:	89 c2                	mov    %eax,%edx
  100812:	89 d0                	mov    %edx,%eax
  100814:	01 c0                	add    %eax,%eax
  100816:	01 d0                	add    %edx,%eax
  100818:	c1 e0 02             	shl    $0x2,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	8b 40 08             	mov    0x8(%eax),%eax
  100825:	85 c0                	test   %eax,%eax
  100827:	74 97                	je     1007c0 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100829:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10082f:	39 c2                	cmp    %eax,%edx
  100831:	7c 46                	jl     100879 <debuginfo_eip+0x2b3>
  100833:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100836:	89 c2                	mov    %eax,%edx
  100838:	89 d0                	mov    %edx,%eax
  10083a:	01 c0                	add    %eax,%eax
  10083c:	01 d0                	add    %edx,%eax
  10083e:	c1 e0 02             	shl    $0x2,%eax
  100841:	89 c2                	mov    %eax,%edx
  100843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100846:	01 d0                	add    %edx,%eax
  100848:	8b 00                	mov    (%eax),%eax
  10084a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10084d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100850:	29 d1                	sub    %edx,%ecx
  100852:	89 ca                	mov    %ecx,%edx
  100854:	39 d0                	cmp    %edx,%eax
  100856:	73 21                	jae    100879 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	8b 10                	mov    (%eax),%edx
  10086f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100872:	01 c2                	add    %eax,%edx
  100874:	8b 45 0c             	mov    0xc(%ebp),%eax
  100877:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100879:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10087c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10087f:	39 c2                	cmp    %eax,%edx
  100881:	7d 4a                	jge    1008cd <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100883:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100886:	83 c0 01             	add    $0x1,%eax
  100889:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10088c:	eb 18                	jmp    1008a6 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100891:	8b 40 14             	mov    0x14(%eax),%eax
  100894:	8d 50 01             	lea    0x1(%eax),%edx
  100897:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089a:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10089d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a0:	83 c0 01             	add    $0x1,%eax
  1008a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008ac:	39 c2                	cmp    %eax,%edx
  1008ae:	7d 1d                	jge    1008cd <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b3:	89 c2                	mov    %eax,%edx
  1008b5:	89 d0                	mov    %edx,%eax
  1008b7:	01 c0                	add    %eax,%eax
  1008b9:	01 d0                	add    %edx,%eax
  1008bb:	c1 e0 02             	shl    $0x2,%eax
  1008be:	89 c2                	mov    %eax,%edx
  1008c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c3:	01 d0                	add    %edx,%eax
  1008c5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008c9:	3c a0                	cmp    $0xa0,%al
  1008cb:	74 c1                	je     10088e <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008d2:	c9                   	leave  
  1008d3:	c3                   	ret    

001008d4 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008d4:	55                   	push   %ebp
  1008d5:	89 e5                	mov    %esp,%ebp
  1008d7:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008da:	83 ec 0c             	sub    $0xc,%esp
  1008dd:	68 92 37 10 00       	push   $0x103792
  1008e2:	e8 63 f9 ff ff       	call   10024a <cprintf>
  1008e7:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008ea:	83 ec 08             	sub    $0x8,%esp
  1008ed:	68 00 00 10 00       	push   $0x100000
  1008f2:	68 ab 37 10 00       	push   $0x1037ab
  1008f7:	e8 4e f9 ff ff       	call   10024a <cprintf>
  1008fc:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008ff:	83 ec 08             	sub    $0x8,%esp
  100902:	68 90 36 10 00       	push   $0x103690
  100907:	68 c3 37 10 00       	push   $0x1037c3
  10090c:	e8 39 f9 ff ff       	call   10024a <cprintf>
  100911:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100914:	83 ec 08             	sub    $0x8,%esp
  100917:	68 16 ea 10 00       	push   $0x10ea16
  10091c:	68 db 37 10 00       	push   $0x1037db
  100921:	e8 24 f9 ff ff       	call   10024a <cprintf>
  100926:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100929:	83 ec 08             	sub    $0x8,%esp
  10092c:	68 80 fd 10 00       	push   $0x10fd80
  100931:	68 f3 37 10 00       	push   $0x1037f3
  100936:	e8 0f f9 ff ff       	call   10024a <cprintf>
  10093b:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10093e:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  100943:	05 ff 03 00 00       	add    $0x3ff,%eax
  100948:	ba 00 00 10 00       	mov    $0x100000,%edx
  10094d:	29 d0                	sub    %edx,%eax
  10094f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100955:	85 c0                	test   %eax,%eax
  100957:	0f 48 c2             	cmovs  %edx,%eax
  10095a:	c1 f8 0a             	sar    $0xa,%eax
  10095d:	83 ec 08             	sub    $0x8,%esp
  100960:	50                   	push   %eax
  100961:	68 0c 38 10 00       	push   $0x10380c
  100966:	e8 df f8 ff ff       	call   10024a <cprintf>
  10096b:	83 c4 10             	add    $0x10,%esp
}
  10096e:	90                   	nop
  10096f:	c9                   	leave  
  100970:	c3                   	ret    

00100971 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100971:	55                   	push   %ebp
  100972:	89 e5                	mov    %esp,%ebp
  100974:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10097a:	83 ec 08             	sub    $0x8,%esp
  10097d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100980:	50                   	push   %eax
  100981:	ff 75 08             	pushl  0x8(%ebp)
  100984:	e8 3d fc ff ff       	call   1005c6 <debuginfo_eip>
  100989:	83 c4 10             	add    $0x10,%esp
  10098c:	85 c0                	test   %eax,%eax
  10098e:	74 15                	je     1009a5 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100990:	83 ec 08             	sub    $0x8,%esp
  100993:	ff 75 08             	pushl  0x8(%ebp)
  100996:	68 36 38 10 00       	push   $0x103836
  10099b:	e8 aa f8 ff ff       	call   10024a <cprintf>
  1009a0:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a3:	eb 65                	jmp    100a0a <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009ac:	eb 1c                	jmp    1009ca <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b4:	01 d0                	add    %edx,%eax
  1009b6:	0f b6 00             	movzbl (%eax),%eax
  1009b9:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009c2:	01 ca                	add    %ecx,%edx
  1009c4:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009d0:	7f dc                	jg     1009ae <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009d2:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009db:	01 d0                	add    %edx,%eax
  1009dd:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1009e6:	89 d1                	mov    %edx,%ecx
  1009e8:	29 c1                	sub    %eax,%ecx
  1009ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f0:	83 ec 0c             	sub    $0xc,%esp
  1009f3:	51                   	push   %ecx
  1009f4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009fa:	51                   	push   %ecx
  1009fb:	52                   	push   %edx
  1009fc:	50                   	push   %eax
  1009fd:	68 52 38 10 00       	push   $0x103852
  100a02:	e8 43 f8 ff ff       	call   10024a <cprintf>
  100a07:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a0a:	90                   	nop
  100a0b:	c9                   	leave  
  100a0c:	c3                   	ret    

00100a0d <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a0d:	55                   	push   %ebp
  100a0e:	89 e5                	mov    %esp,%ebp
  100a10:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a13:	8b 45 04             	mov    0x4(%ebp),%eax
  100a16:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a1c:	c9                   	leave  
  100a1d:	c3                   	ret    

00100a1e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a1e:	55                   	push   %ebp
  100a1f:	89 e5                	mov    %esp,%ebp
  100a21:	53                   	push   %ebx
  100a22:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a25:	89 e8                	mov    %ebp,%eax
  100a27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    // 1. read_ebp
    uint32_t stack_val_ebp = read_ebp();
  100a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
  100a30:	e8 d8 ff ff ff       	call   100a0d <read_eip>
  100a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100a38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a3f:	e9 93 00 00 00       	jmp    100ad7 <print_stackframe+0xb9>
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);
  100a44:	83 ec 04             	sub    $0x4,%esp
  100a47:	ff 75 f0             	pushl  -0x10(%ebp)
  100a4a:	ff 75 f4             	pushl  -0xc(%ebp)
  100a4d:	68 64 38 10 00       	push   $0x103864
  100a52:	e8 f3 f7 ff ff       	call   10024a <cprintf>
  100a57:	83 c4 10             	add    $0x10,%esp

        // get args
        for (int j = 0; j < 4; j++) {
  100a5a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a61:	eb 1f                	jmp    100a82 <print_stackframe+0x64>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
  100a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a70:	01 d0                	add    %edx,%eax
  100a72:	83 c0 08             	add    $0x8,%eax
  100a75:	8b 10                	mov    (%eax),%edx
  100a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a7a:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x ", stack_val_ebp, stack_val_eip);

        // get args
        for (int j = 0; j < 4; j++) {
  100a7e:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a82:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a86:	7e db                	jle    100a63 <print_stackframe+0x45>
            stack_val_args[j] = *(((uint32_t*) stack_val_ebp) + 2 + j);
        }

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", stack_val_args[0], 
  100a88:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a8b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a8e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a94:	83 ec 0c             	sub    $0xc,%esp
  100a97:	53                   	push   %ebx
  100a98:	51                   	push   %ecx
  100a99:	52                   	push   %edx
  100a9a:	50                   	push   %eax
  100a9b:	68 7c 38 10 00       	push   $0x10387c
  100aa0:	e8 a5 f7 ff ff       	call   10024a <cprintf>
  100aa5:	83 c4 20             	add    $0x20,%esp
                stack_val_args[1], stack_val_args[2], stack_val_args[3]);

        // print function info
        print_debuginfo(stack_val_eip - 1);
  100aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aab:	83 e8 01             	sub    $0x1,%eax
  100aae:	83 ec 0c             	sub    $0xc,%esp
  100ab1:	50                   	push   %eax
  100ab2:	e8 ba fe ff ff       	call   100971 <print_debuginfo>
  100ab7:	83 c4 10             	add    $0x10,%esp

        // pop up stackframe, refresh ebp & eip
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
  100aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abd:	83 c0 04             	add    $0x4,%eax
  100ac0:	8b 00                	mov    (%eax),%eax
  100ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));
  100ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac8:	8b 00                	mov    (%eax),%eax
  100aca:	89 45 f4             	mov    %eax,-0xc(%ebp)

        // ebp should be valid
        if (stack_val_ebp <= 0) {
  100acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ad1:	74 10                	je     100ae3 <print_stackframe+0xc5>
    // 2. read_eip
    uint32_t stack_val_eip = read_eip();
    
    // 3. iterate stacks
    uint32_t stack_val_args[4];
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100ad3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ad7:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100adb:	0f 8e 63 ff ff ff    	jle    100a44 <print_stackframe+0x26>
        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
        }
    }
}
  100ae1:	eb 01                	jmp    100ae4 <print_stackframe+0xc6>
        stack_val_eip = *(((uint32_t*) stack_val_ebp) + 1);
        stack_val_ebp = *(((uint32_t*) stack_val_ebp));

        // ebp should be valid
        if (stack_val_ebp <= 0) {
            break;
  100ae3:	90                   	nop
        }
    }
}
  100ae4:	90                   	nop
  100ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ae8:	c9                   	leave  
  100ae9:	c3                   	ret    

00100aea <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aea:	55                   	push   %ebp
  100aeb:	89 e5                	mov    %esp,%ebp
  100aed:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100af0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af7:	eb 0c                	jmp    100b05 <parse+0x1b>
            *buf ++ = '\0';
  100af9:	8b 45 08             	mov    0x8(%ebp),%eax
  100afc:	8d 50 01             	lea    0x1(%eax),%edx
  100aff:	89 55 08             	mov    %edx,0x8(%ebp)
  100b02:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b05:	8b 45 08             	mov    0x8(%ebp),%eax
  100b08:	0f b6 00             	movzbl (%eax),%eax
  100b0b:	84 c0                	test   %al,%al
  100b0d:	74 1e                	je     100b2d <parse+0x43>
  100b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b12:	0f b6 00             	movzbl (%eax),%eax
  100b15:	0f be c0             	movsbl %al,%eax
  100b18:	83 ec 08             	sub    $0x8,%esp
  100b1b:	50                   	push   %eax
  100b1c:	68 20 39 10 00       	push   $0x103920
  100b21:	e8 14 22 00 00       	call   102d3a <strchr>
  100b26:	83 c4 10             	add    $0x10,%esp
  100b29:	85 c0                	test   %eax,%eax
  100b2b:	75 cc                	jne    100af9 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b30:	0f b6 00             	movzbl (%eax),%eax
  100b33:	84 c0                	test   %al,%al
  100b35:	74 69                	je     100ba0 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b37:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b3b:	75 12                	jne    100b4f <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b3d:	83 ec 08             	sub    $0x8,%esp
  100b40:	6a 10                	push   $0x10
  100b42:	68 25 39 10 00       	push   $0x103925
  100b47:	e8 fe f6 ff ff       	call   10024a <cprintf>
  100b4c:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b52:	8d 50 01             	lea    0x1(%eax),%edx
  100b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b62:	01 c2                	add    %eax,%edx
  100b64:	8b 45 08             	mov    0x8(%ebp),%eax
  100b67:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b69:	eb 04                	jmp    100b6f <parse+0x85>
            buf ++;
  100b6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b72:	0f b6 00             	movzbl (%eax),%eax
  100b75:	84 c0                	test   %al,%al
  100b77:	0f 84 7a ff ff ff    	je     100af7 <parse+0xd>
  100b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b80:	0f b6 00             	movzbl (%eax),%eax
  100b83:	0f be c0             	movsbl %al,%eax
  100b86:	83 ec 08             	sub    $0x8,%esp
  100b89:	50                   	push   %eax
  100b8a:	68 20 39 10 00       	push   $0x103920
  100b8f:	e8 a6 21 00 00       	call   102d3a <strchr>
  100b94:	83 c4 10             	add    $0x10,%esp
  100b97:	85 c0                	test   %eax,%eax
  100b99:	74 d0                	je     100b6b <parse+0x81>
            buf ++;
        }
    }
  100b9b:	e9 57 ff ff ff       	jmp    100af7 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100ba0:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba4:	c9                   	leave  
  100ba5:	c3                   	ret    

00100ba6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba6:	55                   	push   %ebp
  100ba7:	89 e5                	mov    %esp,%ebp
  100ba9:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bac:	83 ec 08             	sub    $0x8,%esp
  100baf:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb2:	50                   	push   %eax
  100bb3:	ff 75 08             	pushl  0x8(%ebp)
  100bb6:	e8 2f ff ff ff       	call   100aea <parse>
  100bbb:	83 c4 10             	add    $0x10,%esp
  100bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc5:	75 0a                	jne    100bd1 <runcmd+0x2b>
        return 0;
  100bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  100bcc:	e9 83 00 00 00       	jmp    100c54 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd8:	eb 59                	jmp    100c33 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bda:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100be0:	89 d0                	mov    %edx,%eax
  100be2:	01 c0                	add    %eax,%eax
  100be4:	01 d0                	add    %edx,%eax
  100be6:	c1 e0 02             	shl    $0x2,%eax
  100be9:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bee:	8b 00                	mov    (%eax),%eax
  100bf0:	83 ec 08             	sub    $0x8,%esp
  100bf3:	51                   	push   %ecx
  100bf4:	50                   	push   %eax
  100bf5:	e8 a0 20 00 00       	call   102c9a <strcmp>
  100bfa:	83 c4 10             	add    $0x10,%esp
  100bfd:	85 c0                	test   %eax,%eax
  100bff:	75 2e                	jne    100c2f <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c04:	89 d0                	mov    %edx,%eax
  100c06:	01 c0                	add    %eax,%eax
  100c08:	01 d0                	add    %edx,%eax
  100c0a:	c1 e0 02             	shl    $0x2,%eax
  100c0d:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c12:	8b 10                	mov    (%eax),%edx
  100c14:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c17:	83 c0 04             	add    $0x4,%eax
  100c1a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c1d:	83 e9 01             	sub    $0x1,%ecx
  100c20:	83 ec 04             	sub    $0x4,%esp
  100c23:	ff 75 0c             	pushl  0xc(%ebp)
  100c26:	50                   	push   %eax
  100c27:	51                   	push   %ecx
  100c28:	ff d2                	call   *%edx
  100c2a:	83 c4 10             	add    $0x10,%esp
  100c2d:	eb 25                	jmp    100c54 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c36:	83 f8 02             	cmp    $0x2,%eax
  100c39:	76 9f                	jbe    100bda <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c3e:	83 ec 08             	sub    $0x8,%esp
  100c41:	50                   	push   %eax
  100c42:	68 43 39 10 00       	push   $0x103943
  100c47:	e8 fe f5 ff ff       	call   10024a <cprintf>
  100c4c:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c54:	c9                   	leave  
  100c55:	c3                   	ret    

00100c56 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c56:	55                   	push   %ebp
  100c57:	89 e5                	mov    %esp,%ebp
  100c59:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c5c:	83 ec 0c             	sub    $0xc,%esp
  100c5f:	68 5c 39 10 00       	push   $0x10395c
  100c64:	e8 e1 f5 ff ff       	call   10024a <cprintf>
  100c69:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c6c:	83 ec 0c             	sub    $0xc,%esp
  100c6f:	68 84 39 10 00       	push   $0x103984
  100c74:	e8 d1 f5 ff ff       	call   10024a <cprintf>
  100c79:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c80:	74 0e                	je     100c90 <kmonitor+0x3a>
        print_trapframe(tf);
  100c82:	83 ec 0c             	sub    $0xc,%esp
  100c85:	ff 75 08             	pushl  0x8(%ebp)
  100c88:	e8 52 0d 00 00       	call   1019df <print_trapframe>
  100c8d:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c90:	83 ec 0c             	sub    $0xc,%esp
  100c93:	68 a9 39 10 00       	push   $0x1039a9
  100c98:	e8 51 f6 ff ff       	call   1002ee <readline>
  100c9d:	83 c4 10             	add    $0x10,%esp
  100ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ca3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca7:	74 e7                	je     100c90 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100ca9:	83 ec 08             	sub    $0x8,%esp
  100cac:	ff 75 08             	pushl  0x8(%ebp)
  100caf:	ff 75 f4             	pushl  -0xc(%ebp)
  100cb2:	e8 ef fe ff ff       	call   100ba6 <runcmd>
  100cb7:	83 c4 10             	add    $0x10,%esp
  100cba:	85 c0                	test   %eax,%eax
  100cbc:	78 02                	js     100cc0 <kmonitor+0x6a>
                break;
            }
        }
    }
  100cbe:	eb d0                	jmp    100c90 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cc0:	90                   	nop
            }
        }
    }
}
  100cc1:	90                   	nop
  100cc2:	c9                   	leave  
  100cc3:	c3                   	ret    

00100cc4 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cc4:	55                   	push   %ebp
  100cc5:	89 e5                	mov    %esp,%ebp
  100cc7:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cd1:	eb 3c                	jmp    100d0f <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd6:	89 d0                	mov    %edx,%eax
  100cd8:	01 c0                	add    %eax,%eax
  100cda:	01 d0                	add    %edx,%eax
  100cdc:	c1 e0 02             	shl    $0x2,%eax
  100cdf:	05 04 e0 10 00       	add    $0x10e004,%eax
  100ce4:	8b 08                	mov    (%eax),%ecx
  100ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce9:	89 d0                	mov    %edx,%eax
  100ceb:	01 c0                	add    %eax,%eax
  100ced:	01 d0                	add    %edx,%eax
  100cef:	c1 e0 02             	shl    $0x2,%eax
  100cf2:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf7:	8b 00                	mov    (%eax),%eax
  100cf9:	83 ec 04             	sub    $0x4,%esp
  100cfc:	51                   	push   %ecx
  100cfd:	50                   	push   %eax
  100cfe:	68 ad 39 10 00       	push   $0x1039ad
  100d03:	e8 42 f5 ff ff       	call   10024a <cprintf>
  100d08:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d0b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d12:	83 f8 02             	cmp    $0x2,%eax
  100d15:	76 bc                	jbe    100cd3 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d1c:	c9                   	leave  
  100d1d:	c3                   	ret    

00100d1e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d1e:	55                   	push   %ebp
  100d1f:	89 e5                	mov    %esp,%ebp
  100d21:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d24:	e8 ab fb ff ff       	call   1008d4 <print_kerninfo>
    return 0;
  100d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2e:	c9                   	leave  
  100d2f:	c3                   	ret    

00100d30 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d30:	55                   	push   %ebp
  100d31:	89 e5                	mov    %esp,%ebp
  100d33:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d36:	e8 e3 fc ff ff       	call   100a1e <print_stackframe>
    return 0;
  100d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d40:	c9                   	leave  
  100d41:	c3                   	ret    

00100d42 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d42:	55                   	push   %ebp
  100d43:	89 e5                	mov    %esp,%ebp
  100d45:	83 ec 18             	sub    $0x18,%esp
  100d48:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d4e:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d52:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d56:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d5a:	ee                   	out    %al,(%dx)
  100d5b:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d61:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d65:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d69:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d6d:	ee                   	out    %al,(%dx)
  100d6e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d74:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d78:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d80:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d81:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d88:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d8b:	83 ec 0c             	sub    $0xc,%esp
  100d8e:	68 b6 39 10 00       	push   $0x1039b6
  100d93:	e8 b2 f4 ff ff       	call   10024a <cprintf>
  100d98:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d9b:	83 ec 0c             	sub    $0xc,%esp
  100d9e:	6a 00                	push   $0x0
  100da0:	e8 ce 08 00 00       	call   101673 <pic_enable>
  100da5:	83 c4 10             	add    $0x10,%esp
}
  100da8:	90                   	nop
  100da9:	c9                   	leave  
  100daa:	c3                   	ret    

00100dab <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dab:	55                   	push   %ebp
  100dac:	89 e5                	mov    %esp,%ebp
  100dae:	83 ec 10             	sub    $0x10,%esp
  100db1:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dbb:	89 c2                	mov    %eax,%edx
  100dbd:	ec                   	in     (%dx),%al
  100dbe:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dc1:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dc7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100dcb:	89 c2                	mov    %eax,%edx
  100dcd:	ec                   	in     (%dx),%al
  100dce:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dd1:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ddb:	89 c2                	mov    %eax,%edx
  100ddd:	ec                   	in     (%dx),%al
  100dde:	88 45 f6             	mov    %al,-0xa(%ebp)
  100de1:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100de7:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100deb:	89 c2                	mov    %eax,%edx
  100ded:	ec                   	in     (%dx),%al
  100dee:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100df1:	90                   	nop
  100df2:	c9                   	leave  
  100df3:	c3                   	ret    

00100df4 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100df4:	55                   	push   %ebp
  100df5:	89 e5                	mov    %esp,%ebp
  100df7:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100dfa:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e04:	0f b7 00             	movzwl (%eax),%eax
  100e07:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e16:	0f b7 00             	movzwl (%eax),%eax
  100e19:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e1d:	74 12                	je     100e31 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e1f:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e26:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e2d:	b4 03 
  100e2f:	eb 13                	jmp    100e44 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e34:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e38:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e3b:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e42:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e44:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e4b:	0f b7 c0             	movzwl %ax,%eax
  100e4e:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e52:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e56:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e5a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e5e:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e5f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e66:	83 c0 01             	add    $0x1,%eax
  100e69:	0f b7 c0             	movzwl %ax,%eax
  100e6c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e74:	89 c2                	mov    %eax,%edx
  100e76:	ec                   	in     (%dx),%al
  100e77:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e7a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e7e:	0f b6 c0             	movzbl %al,%eax
  100e81:	c1 e0 08             	shl    $0x8,%eax
  100e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e87:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8e:	0f b7 c0             	movzwl %ax,%eax
  100e91:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e95:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e99:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e9d:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100ea1:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ea2:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea9:	83 c0 01             	add    $0x1,%eax
  100eac:	0f b7 c0             	movzwl %ax,%eax
  100eaf:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb3:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eb7:	89 c2                	mov    %eax,%edx
  100eb9:	ec                   	in     (%dx),%al
  100eba:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ebd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ec1:	0f b6 c0             	movzbl %al,%eax
  100ec4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eca:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed8:	90                   	nop
  100ed9:	c9                   	leave  
  100eda:	c3                   	ret    

00100edb <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100edb:	55                   	push   %ebp
  100edc:	89 e5                	mov    %esp,%ebp
  100ede:	83 ec 28             	sub    $0x28,%esp
  100ee1:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ee7:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eeb:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100eef:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ef3:	ee                   	out    %al,(%dx)
  100ef4:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100efa:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100efe:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f02:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f06:	ee                   	out    %al,(%dx)
  100f07:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f0d:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f11:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f15:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f20:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f24:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f28:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f2c:	ee                   	out    %al,(%dx)
  100f2d:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f33:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f37:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f3b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
  100f40:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f46:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f4a:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f4e:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
  100f53:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f59:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f5d:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f61:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f65:	ee                   	out    %al,(%dx)
  100f66:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f6c:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f70:	89 c2                	mov    %eax,%edx
  100f72:	ec                   	in     (%dx),%al
  100f73:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f76:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f7a:	3c ff                	cmp    $0xff,%al
  100f7c:	0f 95 c0             	setne  %al
  100f7f:	0f b6 c0             	movzbl %al,%eax
  100f82:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f87:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f91:	89 c2                	mov    %eax,%edx
  100f93:	ec                   	in     (%dx),%al
  100f94:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f97:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f9d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fa1:	89 c2                	mov    %eax,%edx
  100fa3:	ec                   	in     (%dx),%al
  100fa4:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fac:	85 c0                	test   %eax,%eax
  100fae:	74 0d                	je     100fbd <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fb0:	83 ec 0c             	sub    $0xc,%esp
  100fb3:	6a 04                	push   $0x4
  100fb5:	e8 b9 06 00 00       	call   101673 <pic_enable>
  100fba:	83 c4 10             	add    $0x10,%esp
    }
}
  100fbd:	90                   	nop
  100fbe:	c9                   	leave  
  100fbf:	c3                   	ret    

00100fc0 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc0:	55                   	push   %ebp
  100fc1:	89 e5                	mov    %esp,%ebp
  100fc3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fcd:	eb 09                	jmp    100fd8 <lpt_putc_sub+0x18>
        delay();
  100fcf:	e8 d7 fd ff ff       	call   100dab <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd8:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fde:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fe2:	89 c2                	mov    %eax,%edx
  100fe4:	ec                   	in     (%dx),%al
  100fe5:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fe8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fec:	84 c0                	test   %al,%al
  100fee:	78 09                	js     100ff9 <lpt_putc_sub+0x39>
  100ff0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff7:	7e d6                	jle    100fcf <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  100ffc:	0f b6 c0             	movzbl %al,%eax
  100fff:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101005:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101008:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10100c:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101010:	ee                   	out    %al,(%dx)
  101011:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101017:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10101b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101023:	ee                   	out    %al,(%dx)
  101024:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10102a:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10102e:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101032:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101036:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101037:	90                   	nop
  101038:	c9                   	leave  
  101039:	c3                   	ret    

0010103a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10103a:	55                   	push   %ebp
  10103b:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10103d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101041:	74 0d                	je     101050 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101043:	ff 75 08             	pushl  0x8(%ebp)
  101046:	e8 75 ff ff ff       	call   100fc0 <lpt_putc_sub>
  10104b:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10104e:	eb 1e                	jmp    10106e <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  101050:	6a 08                	push   $0x8
  101052:	e8 69 ff ff ff       	call   100fc0 <lpt_putc_sub>
  101057:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10105a:	6a 20                	push   $0x20
  10105c:	e8 5f ff ff ff       	call   100fc0 <lpt_putc_sub>
  101061:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101064:	6a 08                	push   $0x8
  101066:	e8 55 ff ff ff       	call   100fc0 <lpt_putc_sub>
  10106b:	83 c4 04             	add    $0x4,%esp
    }
}
  10106e:	90                   	nop
  10106f:	c9                   	leave  
  101070:	c3                   	ret    

00101071 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101071:	55                   	push   %ebp
  101072:	89 e5                	mov    %esp,%ebp
  101074:	53                   	push   %ebx
  101075:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101078:	8b 45 08             	mov    0x8(%ebp),%eax
  10107b:	b0 00                	mov    $0x0,%al
  10107d:	85 c0                	test   %eax,%eax
  10107f:	75 07                	jne    101088 <cga_putc+0x17>
        c |= 0x0700;
  101081:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101088:	8b 45 08             	mov    0x8(%ebp),%eax
  10108b:	0f b6 c0             	movzbl %al,%eax
  10108e:	83 f8 0a             	cmp    $0xa,%eax
  101091:	74 4e                	je     1010e1 <cga_putc+0x70>
  101093:	83 f8 0d             	cmp    $0xd,%eax
  101096:	74 59                	je     1010f1 <cga_putc+0x80>
  101098:	83 f8 08             	cmp    $0x8,%eax
  10109b:	0f 85 8a 00 00 00    	jne    10112b <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010a1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a8:	66 85 c0             	test   %ax,%ax
  1010ab:	0f 84 a0 00 00 00    	je     101151 <cga_putc+0xe0>
            crt_pos --;
  1010b1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b8:	83 e8 01             	sub    $0x1,%eax
  1010bb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010c1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010c6:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010cd:	0f b7 d2             	movzwl %dx,%edx
  1010d0:	01 d2                	add    %edx,%edx
  1010d2:	01 d0                	add    %edx,%eax
  1010d4:	8b 55 08             	mov    0x8(%ebp),%edx
  1010d7:	b2 00                	mov    $0x0,%dl
  1010d9:	83 ca 20             	or     $0x20,%edx
  1010dc:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010df:	eb 70                	jmp    101151 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010e1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e8:	83 c0 50             	add    $0x50,%eax
  1010eb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f1:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010f8:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010ff:	0f b7 c1             	movzwl %cx,%eax
  101102:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101108:	c1 e8 10             	shr    $0x10,%eax
  10110b:	89 c2                	mov    %eax,%edx
  10110d:	66 c1 ea 06          	shr    $0x6,%dx
  101111:	89 d0                	mov    %edx,%eax
  101113:	c1 e0 02             	shl    $0x2,%eax
  101116:	01 d0                	add    %edx,%eax
  101118:	c1 e0 04             	shl    $0x4,%eax
  10111b:	29 c1                	sub    %eax,%ecx
  10111d:	89 ca                	mov    %ecx,%edx
  10111f:	89 d8                	mov    %ebx,%eax
  101121:	29 d0                	sub    %edx,%eax
  101123:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101129:	eb 27                	jmp    101152 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10112b:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101131:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101138:	8d 50 01             	lea    0x1(%eax),%edx
  10113b:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101142:	0f b7 c0             	movzwl %ax,%eax
  101145:	01 c0                	add    %eax,%eax
  101147:	01 c8                	add    %ecx,%eax
  101149:	8b 55 08             	mov    0x8(%ebp),%edx
  10114c:	66 89 10             	mov    %dx,(%eax)
        break;
  10114f:	eb 01                	jmp    101152 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101151:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101152:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101159:	66 3d cf 07          	cmp    $0x7cf,%ax
  10115d:	76 59                	jbe    1011b8 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10115f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101164:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10116a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116f:	83 ec 04             	sub    $0x4,%esp
  101172:	68 00 0f 00 00       	push   $0xf00
  101177:	52                   	push   %edx
  101178:	50                   	push   %eax
  101179:	e8 bb 1d 00 00       	call   102f39 <memmove>
  10117e:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101181:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101188:	eb 15                	jmp    10119f <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  10118a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101192:	01 d2                	add    %edx,%edx
  101194:	01 d0                	add    %edx,%eax
  101196:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10119f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011a6:	7e e2                	jle    10118a <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011a8:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011af:	83 e8 50             	sub    $0x50,%eax
  1011b2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011b8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011bf:	0f b7 c0             	movzwl %ax,%eax
  1011c2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011c6:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011ca:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011ce:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011d2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d3:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011da:	66 c1 e8 08          	shr    $0x8,%ax
  1011de:	0f b6 c0             	movzbl %al,%eax
  1011e1:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011e8:	83 c2 01             	add    $0x1,%edx
  1011eb:	0f b7 d2             	movzwl %dx,%edx
  1011ee:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011f2:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011f5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011f9:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1011fd:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011fe:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101205:	0f b7 c0             	movzwl %ax,%eax
  101208:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10120c:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101210:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101214:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101218:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101219:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101220:	0f b6 c0             	movzbl %al,%eax
  101223:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10122a:	83 c2 01             	add    $0x1,%edx
  10122d:	0f b7 d2             	movzwl %dx,%edx
  101230:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101234:	88 45 eb             	mov    %al,-0x15(%ebp)
  101237:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10123b:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10123f:	ee                   	out    %al,(%dx)
}
  101240:	90                   	nop
  101241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101244:	c9                   	leave  
  101245:	c3                   	ret    

00101246 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101246:	55                   	push   %ebp
  101247:	89 e5                	mov    %esp,%ebp
  101249:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101253:	eb 09                	jmp    10125e <serial_putc_sub+0x18>
        delay();
  101255:	e8 51 fb ff ff       	call   100dab <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10125e:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101264:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101268:	89 c2                	mov    %eax,%edx
  10126a:	ec                   	in     (%dx),%al
  10126b:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10126e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  101272:	0f b6 c0             	movzbl %al,%eax
  101275:	83 e0 20             	and    $0x20,%eax
  101278:	85 c0                	test   %eax,%eax
  10127a:	75 09                	jne    101285 <serial_putc_sub+0x3f>
  10127c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101283:	7e d0                	jle    101255 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101285:	8b 45 08             	mov    0x8(%ebp),%eax
  101288:	0f b6 c0             	movzbl %al,%eax
  10128b:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  101291:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101294:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101298:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10129c:	ee                   	out    %al,(%dx)
}
  10129d:	90                   	nop
  10129e:	c9                   	leave  
  10129f:	c3                   	ret    

001012a0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012a0:	55                   	push   %ebp
  1012a1:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012a3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a7:	74 0d                	je     1012b6 <serial_putc+0x16>
        serial_putc_sub(c);
  1012a9:	ff 75 08             	pushl  0x8(%ebp)
  1012ac:	e8 95 ff ff ff       	call   101246 <serial_putc_sub>
  1012b1:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012b4:	eb 1e                	jmp    1012d4 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012b6:	6a 08                	push   $0x8
  1012b8:	e8 89 ff ff ff       	call   101246 <serial_putc_sub>
  1012bd:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012c0:	6a 20                	push   $0x20
  1012c2:	e8 7f ff ff ff       	call   101246 <serial_putc_sub>
  1012c7:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012ca:	6a 08                	push   $0x8
  1012cc:	e8 75 ff ff ff       	call   101246 <serial_putc_sub>
  1012d1:	83 c4 04             	add    $0x4,%esp
    }
}
  1012d4:	90                   	nop
  1012d5:	c9                   	leave  
  1012d6:	c3                   	ret    

001012d7 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d7:	55                   	push   %ebp
  1012d8:	89 e5                	mov    %esp,%ebp
  1012da:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012dd:	eb 33                	jmp    101312 <cons_intr+0x3b>
        if (c != 0) {
  1012df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e3:	74 2d                	je     101312 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012ea:	8d 50 01             	lea    0x1(%eax),%edx
  1012ed:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f6:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012fc:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101301:	3d 00 02 00 00       	cmp    $0x200,%eax
  101306:	75 0a                	jne    101312 <cons_intr+0x3b>
                cons.wpos = 0;
  101308:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10130f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101312:	8b 45 08             	mov    0x8(%ebp),%eax
  101315:	ff d0                	call   *%eax
  101317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10131a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131e:	75 bf                	jne    1012df <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101320:	90                   	nop
  101321:	c9                   	leave  
  101322:	c3                   	ret    

00101323 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101323:	55                   	push   %ebp
  101324:	89 e5                	mov    %esp,%ebp
  101326:	83 ec 10             	sub    $0x10,%esp
  101329:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132f:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101333:	89 c2                	mov    %eax,%edx
  101335:	ec                   	in     (%dx),%al
  101336:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101339:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10133d:	0f b6 c0             	movzbl %al,%eax
  101340:	83 e0 01             	and    $0x1,%eax
  101343:	85 c0                	test   %eax,%eax
  101345:	75 07                	jne    10134e <serial_proc_data+0x2b>
        return -1;
  101347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10134c:	eb 2a                	jmp    101378 <serial_proc_data+0x55>
  10134e:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101354:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101358:	89 c2                	mov    %eax,%edx
  10135a:	ec                   	in     (%dx),%al
  10135b:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10135e:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101362:	0f b6 c0             	movzbl %al,%eax
  101365:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101368:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10136c:	75 07                	jne    101375 <serial_proc_data+0x52>
        c = '\b';
  10136e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101375:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101378:	c9                   	leave  
  101379:	c3                   	ret    

0010137a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10137a:	55                   	push   %ebp
  10137b:	89 e5                	mov    %esp,%ebp
  10137d:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101380:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101385:	85 c0                	test   %eax,%eax
  101387:	74 10                	je     101399 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101389:	83 ec 0c             	sub    $0xc,%esp
  10138c:	68 23 13 10 00       	push   $0x101323
  101391:	e8 41 ff ff ff       	call   1012d7 <cons_intr>
  101396:	83 c4 10             	add    $0x10,%esp
    }
}
  101399:	90                   	nop
  10139a:	c9                   	leave  
  10139b:	c3                   	ret    

0010139c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10139c:	55                   	push   %ebp
  10139d:	89 e5                	mov    %esp,%ebp
  10139f:	83 ec 18             	sub    $0x18,%esp
  1013a2:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013ac:	89 c2                	mov    %eax,%edx
  1013ae:	ec                   	in     (%dx),%al
  1013af:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013b2:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013b6:	0f b6 c0             	movzbl %al,%eax
  1013b9:	83 e0 01             	and    $0x1,%eax
  1013bc:	85 c0                	test   %eax,%eax
  1013be:	75 0a                	jne    1013ca <kbd_proc_data+0x2e>
        return -1;
  1013c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c5:	e9 5d 01 00 00       	jmp    101527 <kbd_proc_data+0x18b>
  1013ca:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d4:	89 c2                	mov    %eax,%edx
  1013d6:	ec                   	in     (%dx),%al
  1013d7:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013da:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013de:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e1:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013e5:	75 17                	jne    1013fe <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013e7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ec:	83 c8 40             	or     $0x40,%eax
  1013ef:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f4:	b8 00 00 00 00       	mov    $0x0,%eax
  1013f9:	e9 29 01 00 00       	jmp    101527 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101402:	84 c0                	test   %al,%al
  101404:	79 47                	jns    10144d <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101406:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140b:	83 e0 40             	and    $0x40,%eax
  10140e:	85 c0                	test   %eax,%eax
  101410:	75 09                	jne    10141b <kbd_proc_data+0x7f>
  101412:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101416:	83 e0 7f             	and    $0x7f,%eax
  101419:	eb 04                	jmp    10141f <kbd_proc_data+0x83>
  10141b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141f:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101422:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101426:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10142d:	83 c8 40             	or     $0x40,%eax
  101430:	0f b6 c0             	movzbl %al,%eax
  101433:	f7 d0                	not    %eax
  101435:	89 c2                	mov    %eax,%edx
  101437:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143c:	21 d0                	and    %edx,%eax
  10143e:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101443:	b8 00 00 00 00       	mov    $0x0,%eax
  101448:	e9 da 00 00 00       	jmp    101527 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10144d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101452:	83 e0 40             	and    $0x40,%eax
  101455:	85 c0                	test   %eax,%eax
  101457:	74 11                	je     10146a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101459:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10145d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101462:	83 e0 bf             	and    $0xffffffbf,%eax
  101465:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10146a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101475:	0f b6 d0             	movzbl %al,%edx
  101478:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147d:	09 d0                	or     %edx,%eax
  10147f:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101484:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101488:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10148f:	0f b6 d0             	movzbl %al,%edx
  101492:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101497:	31 d0                	xor    %edx,%eax
  101499:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10149e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a3:	83 e0 03             	and    $0x3,%eax
  1014a6:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b1:	01 d0                	add    %edx,%eax
  1014b3:	0f b6 00             	movzbl (%eax),%eax
  1014b6:	0f b6 c0             	movzbl %al,%eax
  1014b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014bc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c1:	83 e0 08             	and    $0x8,%eax
  1014c4:	85 c0                	test   %eax,%eax
  1014c6:	74 22                	je     1014ea <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014c8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014cc:	7e 0c                	jle    1014da <kbd_proc_data+0x13e>
  1014ce:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d2:	7f 06                	jg     1014da <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014d8:	eb 10                	jmp    1014ea <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014da:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014de:	7e 0a                	jle    1014ea <kbd_proc_data+0x14e>
  1014e0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e4:	7f 04                	jg     1014ea <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014e6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014ea:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ef:	f7 d0                	not    %eax
  1014f1:	83 e0 06             	and    $0x6,%eax
  1014f4:	85 c0                	test   %eax,%eax
  1014f6:	75 2c                	jne    101524 <kbd_proc_data+0x188>
  1014f8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014ff:	75 23                	jne    101524 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101501:	83 ec 0c             	sub    $0xc,%esp
  101504:	68 d1 39 10 00       	push   $0x1039d1
  101509:	e8 3c ed ff ff       	call   10024a <cprintf>
  10150e:	83 c4 10             	add    $0x10,%esp
  101511:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101517:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10151f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101523:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101524:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101527:	c9                   	leave  
  101528:	c3                   	ret    

00101529 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101529:	55                   	push   %ebp
  10152a:	89 e5                	mov    %esp,%ebp
  10152c:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10152f:	83 ec 0c             	sub    $0xc,%esp
  101532:	68 9c 13 10 00       	push   $0x10139c
  101537:	e8 9b fd ff ff       	call   1012d7 <cons_intr>
  10153c:	83 c4 10             	add    $0x10,%esp
}
  10153f:	90                   	nop
  101540:	c9                   	leave  
  101541:	c3                   	ret    

00101542 <kbd_init>:

static void
kbd_init(void) {
  101542:	55                   	push   %ebp
  101543:	89 e5                	mov    %esp,%ebp
  101545:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101548:	e8 dc ff ff ff       	call   101529 <kbd_intr>
    pic_enable(IRQ_KBD);
  10154d:	83 ec 0c             	sub    $0xc,%esp
  101550:	6a 01                	push   $0x1
  101552:	e8 1c 01 00 00       	call   101673 <pic_enable>
  101557:	83 c4 10             	add    $0x10,%esp
}
  10155a:	90                   	nop
  10155b:	c9                   	leave  
  10155c:	c3                   	ret    

0010155d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10155d:	55                   	push   %ebp
  10155e:	89 e5                	mov    %esp,%ebp
  101560:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101563:	e8 8c f8 ff ff       	call   100df4 <cga_init>
    serial_init();
  101568:	e8 6e f9 ff ff       	call   100edb <serial_init>
    kbd_init();
  10156d:	e8 d0 ff ff ff       	call   101542 <kbd_init>
    if (!serial_exists) {
  101572:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101577:	85 c0                	test   %eax,%eax
  101579:	75 10                	jne    10158b <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10157b:	83 ec 0c             	sub    $0xc,%esp
  10157e:	68 dd 39 10 00       	push   $0x1039dd
  101583:	e8 c2 ec ff ff       	call   10024a <cprintf>
  101588:	83 c4 10             	add    $0x10,%esp
    }
}
  10158b:	90                   	nop
  10158c:	c9                   	leave  
  10158d:	c3                   	ret    

0010158e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158e:	55                   	push   %ebp
  10158f:	89 e5                	mov    %esp,%ebp
  101591:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101594:	ff 75 08             	pushl  0x8(%ebp)
  101597:	e8 9e fa ff ff       	call   10103a <lpt_putc>
  10159c:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10159f:	83 ec 0c             	sub    $0xc,%esp
  1015a2:	ff 75 08             	pushl  0x8(%ebp)
  1015a5:	e8 c7 fa ff ff       	call   101071 <cga_putc>
  1015aa:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015ad:	83 ec 0c             	sub    $0xc,%esp
  1015b0:	ff 75 08             	pushl  0x8(%ebp)
  1015b3:	e8 e8 fc ff ff       	call   1012a0 <serial_putc>
  1015b8:	83 c4 10             	add    $0x10,%esp
}
  1015bb:	90                   	nop
  1015bc:	c9                   	leave  
  1015bd:	c3                   	ret    

001015be <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015be:	55                   	push   %ebp
  1015bf:	89 e5                	mov    %esp,%ebp
  1015c1:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c4:	e8 b1 fd ff ff       	call   10137a <serial_intr>
    kbd_intr();
  1015c9:	e8 5b ff ff ff       	call   101529 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ce:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d4:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d9:	39 c2                	cmp    %eax,%edx
  1015db:	74 36                	je     101613 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015dd:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e2:	8d 50 01             	lea    0x1(%eax),%edx
  1015e5:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015eb:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f2:	0f b6 c0             	movzbl %al,%eax
  1015f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f8:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fd:	3d 00 02 00 00       	cmp    $0x200,%eax
  101602:	75 0a                	jne    10160e <cons_getc+0x50>
            cons.rpos = 0;
  101604:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10160b:	00 00 00 
        }
        return c;
  10160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101611:	eb 05                	jmp    101618 <cons_getc+0x5a>
    }
    return 0;
  101613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101618:	c9                   	leave  
  101619:	c3                   	ret    

0010161a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10161a:	55                   	push   %ebp
  10161b:	89 e5                	mov    %esp,%ebp
  10161d:	83 ec 14             	sub    $0x14,%esp
  101620:	8b 45 08             	mov    0x8(%ebp),%eax
  101623:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101627:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162b:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101631:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101636:	85 c0                	test   %eax,%eax
  101638:	74 36                	je     101670 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10163a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163e:	0f b6 c0             	movzbl %al,%eax
  101641:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101647:	88 45 fa             	mov    %al,-0x6(%ebp)
  10164a:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10164e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101652:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101653:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101657:	66 c1 e8 08          	shr    $0x8,%ax
  10165b:	0f b6 c0             	movzbl %al,%eax
  10165e:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101664:	88 45 fb             	mov    %al,-0x5(%ebp)
  101667:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10166b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10166f:	ee                   	out    %al,(%dx)
    }
}
  101670:	90                   	nop
  101671:	c9                   	leave  
  101672:	c3                   	ret    

00101673 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101673:	55                   	push   %ebp
  101674:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101676:	8b 45 08             	mov    0x8(%ebp),%eax
  101679:	ba 01 00 00 00       	mov    $0x1,%edx
  10167e:	89 c1                	mov    %eax,%ecx
  101680:	d3 e2                	shl    %cl,%edx
  101682:	89 d0                	mov    %edx,%eax
  101684:	f7 d0                	not    %eax
  101686:	89 c2                	mov    %eax,%edx
  101688:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10168f:	21 d0                	and    %edx,%eax
  101691:	0f b7 c0             	movzwl %ax,%eax
  101694:	50                   	push   %eax
  101695:	e8 80 ff ff ff       	call   10161a <pic_setmask>
  10169a:	83 c4 04             	add    $0x4,%esp
}
  10169d:	90                   	nop
  10169e:	c9                   	leave  
  10169f:	c3                   	ret    

001016a0 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a0:	55                   	push   %ebp
  1016a1:	89 e5                	mov    %esp,%ebp
  1016a3:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1016a6:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ad:	00 00 00 
  1016b0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b6:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016ba:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016be:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c2:	ee                   	out    %al,(%dx)
  1016c3:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016c9:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016cd:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016d1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016d5:	ee                   	out    %al,(%dx)
  1016d6:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016dc:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016e0:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e8:	ee                   	out    %al,(%dx)
  1016e9:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016ef:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016f3:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016f7:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016fb:	ee                   	out    %al,(%dx)
  1016fc:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101702:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101706:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10170a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10170e:	ee                   	out    %al,(%dx)
  10170f:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101715:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101719:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10171d:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  101721:	ee                   	out    %al,(%dx)
  101722:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101728:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10172c:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  101730:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101734:	ee                   	out    %al,(%dx)
  101735:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10173b:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  10173f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101743:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101747:	ee                   	out    %al,(%dx)
  101748:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10174e:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101752:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101756:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10175a:	ee                   	out    %al,(%dx)
  10175b:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  101761:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101765:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101769:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10176d:	ee                   	out    %al,(%dx)
  10176e:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101774:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101778:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10177c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101780:	ee                   	out    %al,(%dx)
  101781:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101787:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10178b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10178f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101793:	ee                   	out    %al,(%dx)
  101794:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10179a:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10179e:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1017a2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017a6:	ee                   	out    %al,(%dx)
  1017a7:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017ad:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017b1:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017b5:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017b9:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017ba:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c1:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c5:	74 13                	je     1017da <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017c7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ce:	0f b7 c0             	movzwl %ax,%eax
  1017d1:	50                   	push   %eax
  1017d2:	e8 43 fe ff ff       	call   10161a <pic_setmask>
  1017d7:	83 c4 04             	add    $0x4,%esp
    }
}
  1017da:	90                   	nop
  1017db:	c9                   	leave  
  1017dc:	c3                   	ret    

001017dd <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017dd:	55                   	push   %ebp
  1017de:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017e0:	fb                   	sti    
    sti();
}
  1017e1:	90                   	nop
  1017e2:	5d                   	pop    %ebp
  1017e3:	c3                   	ret    

001017e4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e4:	55                   	push   %ebp
  1017e5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017e7:	fa                   	cli    
    cli();
}
  1017e8:	90                   	nop
  1017e9:	5d                   	pop    %ebp
  1017ea:	c3                   	ret    

001017eb <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017eb:	55                   	push   %ebp
  1017ec:	89 e5                	mov    %esp,%ebp
  1017ee:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f1:	83 ec 08             	sub    $0x8,%esp
  1017f4:	6a 64                	push   $0x64
  1017f6:	68 00 3a 10 00       	push   $0x103a00
  1017fb:	e8 4a ea ff ff       	call   10024a <cprintf>
  101800:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101803:	83 ec 0c             	sub    $0xc,%esp
  101806:	68 0a 3a 10 00       	push   $0x103a0a
  10180b:	e8 3a ea ff ff       	call   10024a <cprintf>
  101810:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101813:	83 ec 04             	sub    $0x4,%esp
  101816:	68 18 3a 10 00       	push   $0x103a18
  10181b:	6a 12                	push   $0x12
  10181d:	68 2e 3a 10 00       	push   $0x103a2e
  101822:	e8 89 eb ff ff       	call   1003b0 <__panic>

00101827 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101827:	55                   	push   %ebp
  101828:	89 e5                	mov    %esp,%ebp
  10182a:	83 ec 10             	sub    $0x10,%esp
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  10182d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101834:	e9 c3 00 00 00       	jmp    1018fc <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101839:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101843:	89 c2                	mov    %eax,%edx
  101845:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101848:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10184f:	00 
  101850:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101853:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10185a:	00 08 00 
  10185d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101860:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101867:	00 
  101868:	83 e2 e0             	and    $0xffffffe0,%edx
  10186b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101875:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10187c:	00 
  10187d:	83 e2 1f             	and    $0x1f,%edx
  101880:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101887:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101891:	00 
  101892:	83 e2 f0             	and    $0xfffffff0,%edx
  101895:	83 ca 0e             	or     $0xe,%edx
  101898:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a9:	00 
  1018aa:	83 e2 ef             	and    $0xffffffef,%edx
  1018ad:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b7:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018be:	00 
  1018bf:	83 e2 9f             	and    $0xffffff9f,%edx
  1018c2:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cc:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d3:	00 
  1018d4:	83 ca 80             	or     $0xffffff80,%edx
  1018d7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e1:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018e8:	c1 e8 10             	shr    $0x10,%eax
  1018eb:	89 c2                	mov    %eax,%edx
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018f7:	00 
      */
    // 1. get vectors
    extern uintptr_t __vectors[];

    // 2. setup entries
    for (int i = 0; i < 256; i++) {
  1018f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018fc:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101903:	0f 8e 30 ff ff ff    	jle    101839 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }

	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101909:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10190e:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101914:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10191b:	08 00 
  10191d:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101924:	83 e0 e0             	and    $0xffffffe0,%eax
  101927:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10192c:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101933:	83 e0 1f             	and    $0x1f,%eax
  101936:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10193b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101942:	83 e0 f0             	and    $0xfffffff0,%eax
  101945:	83 c8 0e             	or     $0xe,%eax
  101948:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10194d:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101954:	83 e0 ef             	and    $0xffffffef,%eax
  101957:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10195c:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101963:	83 c8 60             	or     $0x60,%eax
  101966:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10196b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101972:	83 c8 80             	or     $0xffffff80,%eax
  101975:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10197a:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10197f:	c1 e8 10             	shr    $0x10,%eax
  101982:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101988:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10198f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101992:	0f 01 18             	lidtl  (%eax)

    // 3. LIDT
    lidt(&idt_pd);
}
  101995:	90                   	nop
  101996:	c9                   	leave  
  101997:	c3                   	ret    

00101998 <trapname>:

static const char *
trapname(int trapno) {
  101998:	55                   	push   %ebp
  101999:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10199b:	8b 45 08             	mov    0x8(%ebp),%eax
  10199e:	83 f8 13             	cmp    $0x13,%eax
  1019a1:	77 0c                	ja     1019af <trapname+0x17>
        return excnames[trapno];
  1019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a6:	8b 04 85 e0 3d 10 00 	mov    0x103de0(,%eax,4),%eax
  1019ad:	eb 18                	jmp    1019c7 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019af:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019b3:	7e 0d                	jle    1019c2 <trapname+0x2a>
  1019b5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019b9:	7f 07                	jg     1019c2 <trapname+0x2a>
        return "Hardware Interrupt";
  1019bb:	b8 3f 3a 10 00       	mov    $0x103a3f,%eax
  1019c0:	eb 05                	jmp    1019c7 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019c2:	b8 52 3a 10 00       	mov    $0x103a52,%eax
}
  1019c7:	5d                   	pop    %ebp
  1019c8:	c3                   	ret    

001019c9 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019c9:	55                   	push   %ebp
  1019ca:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019d3:	66 83 f8 08          	cmp    $0x8,%ax
  1019d7:	0f 94 c0             	sete   %al
  1019da:	0f b6 c0             	movzbl %al,%eax
}
  1019dd:	5d                   	pop    %ebp
  1019de:	c3                   	ret    

001019df <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019df:	55                   	push   %ebp
  1019e0:	89 e5                	mov    %esp,%ebp
  1019e2:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019e5:	83 ec 08             	sub    $0x8,%esp
  1019e8:	ff 75 08             	pushl  0x8(%ebp)
  1019eb:	68 93 3a 10 00       	push   $0x103a93
  1019f0:	e8 55 e8 ff ff       	call   10024a <cprintf>
  1019f5:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fb:	83 ec 0c             	sub    $0xc,%esp
  1019fe:	50                   	push   %eax
  1019ff:	e8 b8 01 00 00       	call   101bbc <print_regs>
  101a04:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a07:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a0e:	0f b7 c0             	movzwl %ax,%eax
  101a11:	83 ec 08             	sub    $0x8,%esp
  101a14:	50                   	push   %eax
  101a15:	68 a4 3a 10 00       	push   $0x103aa4
  101a1a:	e8 2b e8 ff ff       	call   10024a <cprintf>
  101a1f:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a22:	8b 45 08             	mov    0x8(%ebp),%eax
  101a25:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a29:	0f b7 c0             	movzwl %ax,%eax
  101a2c:	83 ec 08             	sub    $0x8,%esp
  101a2f:	50                   	push   %eax
  101a30:	68 b7 3a 10 00       	push   $0x103ab7
  101a35:	e8 10 e8 ff ff       	call   10024a <cprintf>
  101a3a:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a44:	0f b7 c0             	movzwl %ax,%eax
  101a47:	83 ec 08             	sub    $0x8,%esp
  101a4a:	50                   	push   %eax
  101a4b:	68 ca 3a 10 00       	push   $0x103aca
  101a50:	e8 f5 e7 ff ff       	call   10024a <cprintf>
  101a55:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a58:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a5f:	0f b7 c0             	movzwl %ax,%eax
  101a62:	83 ec 08             	sub    $0x8,%esp
  101a65:	50                   	push   %eax
  101a66:	68 dd 3a 10 00       	push   $0x103add
  101a6b:	e8 da e7 ff ff       	call   10024a <cprintf>
  101a70:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a73:	8b 45 08             	mov    0x8(%ebp),%eax
  101a76:	8b 40 30             	mov    0x30(%eax),%eax
  101a79:	83 ec 0c             	sub    $0xc,%esp
  101a7c:	50                   	push   %eax
  101a7d:	e8 16 ff ff ff       	call   101998 <trapname>
  101a82:	83 c4 10             	add    $0x10,%esp
  101a85:	89 c2                	mov    %eax,%edx
  101a87:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8a:	8b 40 30             	mov    0x30(%eax),%eax
  101a8d:	83 ec 04             	sub    $0x4,%esp
  101a90:	52                   	push   %edx
  101a91:	50                   	push   %eax
  101a92:	68 f0 3a 10 00       	push   $0x103af0
  101a97:	e8 ae e7 ff ff       	call   10024a <cprintf>
  101a9c:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 34             	mov    0x34(%eax),%eax
  101aa5:	83 ec 08             	sub    $0x8,%esp
  101aa8:	50                   	push   %eax
  101aa9:	68 02 3b 10 00       	push   $0x103b02
  101aae:	e8 97 e7 ff ff       	call   10024a <cprintf>
  101ab3:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	8b 40 38             	mov    0x38(%eax),%eax
  101abc:	83 ec 08             	sub    $0x8,%esp
  101abf:	50                   	push   %eax
  101ac0:	68 11 3b 10 00       	push   $0x103b11
  101ac5:	e8 80 e7 ff ff       	call   10024a <cprintf>
  101aca:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101acd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad4:	0f b7 c0             	movzwl %ax,%eax
  101ad7:	83 ec 08             	sub    $0x8,%esp
  101ada:	50                   	push   %eax
  101adb:	68 20 3b 10 00       	push   $0x103b20
  101ae0:	e8 65 e7 ff ff       	call   10024a <cprintf>
  101ae5:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aeb:	8b 40 40             	mov    0x40(%eax),%eax
  101aee:	83 ec 08             	sub    $0x8,%esp
  101af1:	50                   	push   %eax
  101af2:	68 33 3b 10 00       	push   $0x103b33
  101af7:	e8 4e e7 ff ff       	call   10024a <cprintf>
  101afc:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b06:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b0d:	eb 3f                	jmp    101b4e <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	8b 50 40             	mov    0x40(%eax),%edx
  101b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b18:	21 d0                	and    %edx,%eax
  101b1a:	85 c0                	test   %eax,%eax
  101b1c:	74 29                	je     101b47 <print_trapframe+0x168>
  101b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b21:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b28:	85 c0                	test   %eax,%eax
  101b2a:	74 1b                	je     101b47 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2f:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b36:	83 ec 08             	sub    $0x8,%esp
  101b39:	50                   	push   %eax
  101b3a:	68 42 3b 10 00       	push   $0x103b42
  101b3f:	e8 06 e7 ff ff       	call   10024a <cprintf>
  101b44:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b4b:	d1 65 f0             	shll   -0x10(%ebp)
  101b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b51:	83 f8 17             	cmp    $0x17,%eax
  101b54:	76 b9                	jbe    101b0f <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b56:	8b 45 08             	mov    0x8(%ebp),%eax
  101b59:	8b 40 40             	mov    0x40(%eax),%eax
  101b5c:	25 00 30 00 00       	and    $0x3000,%eax
  101b61:	c1 e8 0c             	shr    $0xc,%eax
  101b64:	83 ec 08             	sub    $0x8,%esp
  101b67:	50                   	push   %eax
  101b68:	68 46 3b 10 00       	push   $0x103b46
  101b6d:	e8 d8 e6 ff ff       	call   10024a <cprintf>
  101b72:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b75:	83 ec 0c             	sub    $0xc,%esp
  101b78:	ff 75 08             	pushl  0x8(%ebp)
  101b7b:	e8 49 fe ff ff       	call   1019c9 <trap_in_kernel>
  101b80:	83 c4 10             	add    $0x10,%esp
  101b83:	85 c0                	test   %eax,%eax
  101b85:	75 32                	jne    101bb9 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b87:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8a:	8b 40 44             	mov    0x44(%eax),%eax
  101b8d:	83 ec 08             	sub    $0x8,%esp
  101b90:	50                   	push   %eax
  101b91:	68 4f 3b 10 00       	push   $0x103b4f
  101b96:	e8 af e6 ff ff       	call   10024a <cprintf>
  101b9b:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ba5:	0f b7 c0             	movzwl %ax,%eax
  101ba8:	83 ec 08             	sub    $0x8,%esp
  101bab:	50                   	push   %eax
  101bac:	68 5e 3b 10 00       	push   $0x103b5e
  101bb1:	e8 94 e6 ff ff       	call   10024a <cprintf>
  101bb6:	83 c4 10             	add    $0x10,%esp
    }
}
  101bb9:	90                   	nop
  101bba:	c9                   	leave  
  101bbb:	c3                   	ret    

00101bbc <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bbc:	55                   	push   %ebp
  101bbd:	89 e5                	mov    %esp,%ebp
  101bbf:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc5:	8b 00                	mov    (%eax),%eax
  101bc7:	83 ec 08             	sub    $0x8,%esp
  101bca:	50                   	push   %eax
  101bcb:	68 71 3b 10 00       	push   $0x103b71
  101bd0:	e8 75 e6 ff ff       	call   10024a <cprintf>
  101bd5:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdb:	8b 40 04             	mov    0x4(%eax),%eax
  101bde:	83 ec 08             	sub    $0x8,%esp
  101be1:	50                   	push   %eax
  101be2:	68 80 3b 10 00       	push   $0x103b80
  101be7:	e8 5e e6 ff ff       	call   10024a <cprintf>
  101bec:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 08             	mov    0x8(%eax),%eax
  101bf5:	83 ec 08             	sub    $0x8,%esp
  101bf8:	50                   	push   %eax
  101bf9:	68 8f 3b 10 00       	push   $0x103b8f
  101bfe:	e8 47 e6 ff ff       	call   10024a <cprintf>
  101c03:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 0c             	mov    0xc(%eax),%eax
  101c0c:	83 ec 08             	sub    $0x8,%esp
  101c0f:	50                   	push   %eax
  101c10:	68 9e 3b 10 00       	push   $0x103b9e
  101c15:	e8 30 e6 ff ff       	call   10024a <cprintf>
  101c1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c20:	8b 40 10             	mov    0x10(%eax),%eax
  101c23:	83 ec 08             	sub    $0x8,%esp
  101c26:	50                   	push   %eax
  101c27:	68 ad 3b 10 00       	push   $0x103bad
  101c2c:	e8 19 e6 ff ff       	call   10024a <cprintf>
  101c31:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c34:	8b 45 08             	mov    0x8(%ebp),%eax
  101c37:	8b 40 14             	mov    0x14(%eax),%eax
  101c3a:	83 ec 08             	sub    $0x8,%esp
  101c3d:	50                   	push   %eax
  101c3e:	68 bc 3b 10 00       	push   $0x103bbc
  101c43:	e8 02 e6 ff ff       	call   10024a <cprintf>
  101c48:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4e:	8b 40 18             	mov    0x18(%eax),%eax
  101c51:	83 ec 08             	sub    $0x8,%esp
  101c54:	50                   	push   %eax
  101c55:	68 cb 3b 10 00       	push   $0x103bcb
  101c5a:	e8 eb e5 ff ff       	call   10024a <cprintf>
  101c5f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c62:	8b 45 08             	mov    0x8(%ebp),%eax
  101c65:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c68:	83 ec 08             	sub    $0x8,%esp
  101c6b:	50                   	push   %eax
  101c6c:	68 da 3b 10 00       	push   $0x103bda
  101c71:	e8 d4 e5 ff ff       	call   10024a <cprintf>
  101c76:	83 c4 10             	add    $0x10,%esp
}
  101c79:	90                   	nop
  101c7a:	c9                   	leave  
  101c7b:	c3                   	ret    

00101c7c <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c7c:	55                   	push   %ebp
  101c7d:	89 e5                	mov    %esp,%ebp
  101c7f:	57                   	push   %edi
  101c80:	56                   	push   %esi
  101c81:	53                   	push   %ebx
  101c82:	83 ec 1c             	sub    $0x1c,%esp
    //     print_trapframe(tf);
    //     cprintf("\n");
    // }
    char c;

    switch (tf->tf_trapno) {
  101c85:	8b 45 08             	mov    0x8(%ebp),%eax
  101c88:	8b 40 30             	mov    0x30(%eax),%eax
  101c8b:	83 f8 2f             	cmp    $0x2f,%eax
  101c8e:	77 21                	ja     101cb1 <trap_dispatch+0x35>
  101c90:	83 f8 2e             	cmp    $0x2e,%eax
  101c93:	0f 83 a1 02 00 00    	jae    101f3a <trap_dispatch+0x2be>
  101c99:	83 f8 21             	cmp    $0x21,%eax
  101c9c:	0f 84 87 00 00 00    	je     101d29 <trap_dispatch+0xad>
  101ca2:	83 f8 24             	cmp    $0x24,%eax
  101ca5:	74 5b                	je     101d02 <trap_dispatch+0x86>
  101ca7:	83 f8 20             	cmp    $0x20,%eax
  101caa:	74 1c                	je     101cc8 <trap_dispatch+0x4c>
  101cac:	e9 53 02 00 00       	jmp    101f04 <trap_dispatch+0x288>
  101cb1:	83 f8 78             	cmp    $0x78,%eax
  101cb4:	0f 84 97 01 00 00    	je     101e51 <trap_dispatch+0x1d5>
  101cba:	83 f8 79             	cmp    $0x79,%eax
  101cbd:	0f 84 0e 02 00 00    	je     101ed1 <trap_dispatch+0x255>
  101cc3:	e9 3c 02 00 00       	jmp    101f04 <trap_dispatch+0x288>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // 1. record
        ticks++;
  101cc8:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101ccd:	83 c0 01             	add    $0x1,%eax
  101cd0:	a3 08 f9 10 00       	mov    %eax,0x10f908

        // 2. print
        if (ticks % TICK_NUM == 0) {
  101cd5:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cdb:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ce0:	89 c8                	mov    %ecx,%eax
  101ce2:	f7 e2                	mul    %edx
  101ce4:	89 d0                	mov    %edx,%eax
  101ce6:	c1 e8 05             	shr    $0x5,%eax
  101ce9:	6b c0 64             	imul   $0x64,%eax,%eax
  101cec:	29 c1                	sub    %eax,%ecx
  101cee:	89 c8                	mov    %ecx,%eax
  101cf0:	85 c0                	test   %eax,%eax
  101cf2:	0f 85 45 02 00 00    	jne    101f3d <trap_dispatch+0x2c1>
            print_ticks();
  101cf8:	e8 ee fa ff ff       	call   1017eb <print_ticks>
        }

        // 3. too simple ?!
        break;
  101cfd:	e9 3b 02 00 00       	jmp    101f3d <trap_dispatch+0x2c1>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d02:	e8 b7 f8 ff ff       	call   1015be <cons_getc>
  101d07:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d0a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d0e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d12:	83 ec 04             	sub    $0x4,%esp
  101d15:	52                   	push   %edx
  101d16:	50                   	push   %eax
  101d17:	68 e9 3b 10 00       	push   $0x103be9
  101d1c:	e8 29 e5 ff ff       	call   10024a <cprintf>
  101d21:	83 c4 10             	add    $0x10,%esp
        break;
  101d24:	e9 18 02 00 00       	jmp    101f41 <trap_dispatch+0x2c5>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d29:	e8 90 f8 ff ff       	call   1015be <cons_getc>
  101d2e:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d31:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d35:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d39:	83 ec 04             	sub    $0x4,%esp
  101d3c:	52                   	push   %edx
  101d3d:	50                   	push   %eax
  101d3e:	68 fb 3b 10 00       	push   $0x103bfb
  101d43:	e8 02 e5 ff ff       	call   10024a <cprintf>
  101d48:	83 c4 10             	add    $0x10,%esp
        
        //LAB1 CHALLENGE 2 : TODO
        // switch to kernel
        if (c == '0') {
  101d4b:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101d4f:	75 46                	jne    101d97 <trap_dispatch+0x11b>
            cprintf("switch to kern\n");
  101d51:	83 ec 0c             	sub    $0xc,%esp
  101d54:	68 0a 3c 10 00       	push   $0x103c0a
  101d59:	e8 ec e4 ff ff       	call   10024a <cprintf>
  101d5e:	83 c4 10             	add    $0x10,%esp
            tf->tf_cs = KERNEL_CS;
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6d:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101d73:	8b 45 08             	mov    0x8(%ebp),%eax
  101d76:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101d81:	8b 45 08             	mov    0x8(%ebp),%eax
  101d84:	8b 40 40             	mov    0x40(%eax),%eax
  101d87:	80 e4 cf             	and    $0xcf,%ah
  101d8a:	89 c2                	mov    %eax,%edx
  101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8f:	89 50 40             	mov    %edx,0x40(%eax)
        }
        // print to show PL
        else if (c == 'p') {
            print_trapframe(tf);
        }
        break;
  101d92:	e9 a9 01 00 00       	jmp    101f40 <trap_dispatch+0x2c4>
            tf->tf_cs = KERNEL_CS;
            tf->tf_ds = tf->tf_es = KERNEL_DS;
            tf->tf_eflags &= ~FL_IOPL_MASK;
        }
        // switch to user
        else if (c == '3') {
  101d97:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101d9b:	0f 85 93 00 00 00    	jne    101e34 <trap_dispatch+0x1b8>
            cprintf("switch to user\n");
  101da1:	83 ec 0c             	sub    $0xc,%esp
  101da4:	68 1a 3c 10 00       	push   $0x103c1a
  101da9:	e8 9c e4 ff ff       	call   10024a <cprintf>
  101dae:	83 c4 10             	add    $0x10,%esp
            switchk2u = *tf;
  101db1:	8b 55 08             	mov    0x8(%ebp),%edx
  101db4:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101db9:	89 d3                	mov    %edx,%ebx
  101dbb:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101dc0:	8b 0b                	mov    (%ebx),%ecx
  101dc2:	89 08                	mov    %ecx,(%eax)
  101dc4:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101dc8:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101dcc:	8d 78 04             	lea    0x4(%eax),%edi
  101dcf:	83 e7 fc             	and    $0xfffffffc,%edi
  101dd2:	29 f8                	sub    %edi,%eax
  101dd4:	29 c3                	sub    %eax,%ebx
  101dd6:	01 c2                	add    %eax,%edx
  101dd8:	83 e2 fc             	and    $0xfffffffc,%edx
  101ddb:	89 d0                	mov    %edx,%eax
  101ddd:	c1 e8 02             	shr    $0x2,%eax
  101de0:	89 de                	mov    %ebx,%esi
  101de2:	89 c1                	mov    %eax,%ecx
  101de4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101de6:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101ded:	1b 00 
            switchk2u.tf_ds = USER_DS;
  101def:	66 c7 05 4c f9 10 00 	movw   $0x23,0x10f94c
  101df6:	23 00 
            switchk2u.tf_es = USER_DS;
  101df8:	66 c7 05 48 f9 10 00 	movw   $0x23,0x10f948
  101dff:	23 00 
            switchk2u.tf_ss = USER_DS;
  101e01:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101e08:	23 00 

            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	83 c0 44             	add    $0x44,%eax
  101e10:	a3 64 f9 10 00       	mov    %eax,0x10f964
            
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e15:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101e1a:	80 cc 30             	or     $0x30,%ah
  101e1d:	a3 60 f9 10 00       	mov    %eax,0x10f960
        
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e22:	8b 45 08             	mov    0x8(%ebp),%eax
  101e25:	83 e8 04             	sub    $0x4,%eax
  101e28:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101e2d:	89 10                	mov    %edx,(%eax)
        }
        // print to show PL
        else if (c == 'p') {
            print_trapframe(tf);
        }
        break;
  101e2f:	e9 0c 01 00 00       	jmp    101f40 <trap_dispatch+0x2c4>
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
        }
        // print to show PL
        else if (c == 'p') {
  101e34:	80 7d e7 70          	cmpb   $0x70,-0x19(%ebp)
  101e38:	0f 85 02 01 00 00    	jne    101f40 <trap_dispatch+0x2c4>
            print_trapframe(tf);
  101e3e:	83 ec 0c             	sub    $0xc,%esp
  101e41:	ff 75 08             	pushl  0x8(%ebp)
  101e44:	e8 96 fb ff ff       	call   1019df <print_trapframe>
  101e49:	83 c4 10             	add    $0x10,%esp
        }
        break;
  101e4c:	e9 ef 00 00 00       	jmp    101f40 <trap_dispatch+0x2c4>
    //LAB1 CHALLENGE 1 : 2015010062 you should modify below codes.
    case T_SWITCH_TOU:
        switchk2u = *tf;
  101e51:	8b 55 08             	mov    0x8(%ebp),%edx
  101e54:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101e59:	89 d3                	mov    %edx,%ebx
  101e5b:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101e60:	8b 0b                	mov    (%ebx),%ecx
  101e62:	89 08                	mov    %ecx,(%eax)
  101e64:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101e68:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101e6c:	8d 78 04             	lea    0x4(%eax),%edi
  101e6f:	83 e7 fc             	and    $0xfffffffc,%edi
  101e72:	29 f8                	sub    %edi,%eax
  101e74:	29 c3                	sub    %eax,%ebx
  101e76:	01 c2                	add    %eax,%edx
  101e78:	83 e2 fc             	and    $0xfffffffc,%edx
  101e7b:	89 d0                	mov    %edx,%eax
  101e7d:	c1 e8 02             	shr    $0x2,%eax
  101e80:	89 de                	mov    %ebx,%esi
  101e82:	89 c1                	mov    %eax,%ecx
  101e84:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        switchk2u.tf_cs = USER_CS;
  101e86:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101e8d:	1b 00 
        switchk2u.tf_ds = USER_DS;
  101e8f:	66 c7 05 4c f9 10 00 	movw   $0x23,0x10f94c
  101e96:	23 00 
        switchk2u.tf_es = USER_DS;
  101e98:	66 c7 05 48 f9 10 00 	movw   $0x23,0x10f948
  101e9f:	23 00 
        switchk2u.tf_ss = USER_DS;
  101ea1:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101ea8:	23 00 

        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101ead:	83 c0 44             	add    $0x44,%eax
  101eb0:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
        // set eflags, make sure ucore can use io under user mode.
        // if CPL > IOPL, then cpu will generate a general protection.
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  101eb5:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101eba:	80 cc 30             	or     $0x30,%ah
  101ebd:	a3 60 f9 10 00       	mov    %eax,0x10f960
    
        // set temporary stack
        // then iret will jump to the right stack
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec5:	83 e8 04             	sub    $0x4,%eax
  101ec8:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101ecd:	89 10                	mov    %edx,(%eax)
        break;
  101ecf:	eb 70                	jmp    101f41 <trap_dispatch+0x2c5>
    case T_SWITCH_TOK:
        // panic("T_SWITCH_** ??\n");
        tf->tf_cs = KERNEL_CS;
  101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es = KERNEL_DS;
  101eda:	8b 45 08             	mov    0x8(%ebp),%eax
  101edd:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee6:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101eea:	8b 45 08             	mov    0x8(%ebp),%eax
  101eed:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef4:	8b 40 40             	mov    0x40(%eax),%eax
  101ef7:	80 e4 cf             	and    $0xcf,%ah
  101efa:	89 c2                	mov    %eax,%edx
  101efc:	8b 45 08             	mov    0x8(%ebp),%eax
  101eff:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101f02:	eb 3d                	jmp    101f41 <trap_dispatch+0x2c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f04:	8b 45 08             	mov    0x8(%ebp),%eax
  101f07:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f0b:	0f b7 c0             	movzwl %ax,%eax
  101f0e:	83 e0 03             	and    $0x3,%eax
  101f11:	85 c0                	test   %eax,%eax
  101f13:	75 2c                	jne    101f41 <trap_dispatch+0x2c5>
            print_trapframe(tf);
  101f15:	83 ec 0c             	sub    $0xc,%esp
  101f18:	ff 75 08             	pushl  0x8(%ebp)
  101f1b:	e8 bf fa ff ff       	call   1019df <print_trapframe>
  101f20:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101f23:	83 ec 04             	sub    $0x4,%esp
  101f26:	68 2a 3c 10 00       	push   $0x103c2a
  101f2b:	68 fc 00 00 00       	push   $0xfc
  101f30:	68 2e 3a 10 00       	push   $0x103a2e
  101f35:	e8 76 e4 ff ff       	call   1003b0 <__panic>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f3a:	90                   	nop
  101f3b:	eb 04                	jmp    101f41 <trap_dispatch+0x2c5>
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }

        // 3. too simple ?!
        break;
  101f3d:	90                   	nop
  101f3e:	eb 01                	jmp    101f41 <trap_dispatch+0x2c5>
        }
        // print to show PL
        else if (c == 'p') {
            print_trapframe(tf);
        }
        break;
  101f40:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101f41:	90                   	nop
  101f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101f45:	5b                   	pop    %ebx
  101f46:	5e                   	pop    %esi
  101f47:	5f                   	pop    %edi
  101f48:	5d                   	pop    %ebp
  101f49:	c3                   	ret    

00101f4a <cur_debug>:

void
cur_debug(void) {
  101f4a:	55                   	push   %ebp
  101f4b:	89 e5                	mov    %esp,%ebp
  101f4d:	83 ec 18             	sub    $0x18,%esp
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  101f50:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  101f53:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  101f56:	8c 45 f2             	mov    %es,-0xe(%ebp)
  101f59:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", reg1 & 3);
  101f5c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101f60:	0f b7 c0             	movzwl %ax,%eax
  101f63:	83 e0 03             	and    $0x3,%eax
  101f66:	83 ec 08             	sub    $0x8,%esp
  101f69:	50                   	push   %eax
  101f6a:	68 46 3c 10 00       	push   $0x103c46
  101f6f:	e8 d6 e2 ff ff       	call   10024a <cprintf>
  101f74:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", reg1);
  101f77:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101f7b:	0f b7 c0             	movzwl %ax,%eax
  101f7e:	83 ec 08             	sub    $0x8,%esp
  101f81:	50                   	push   %eax
  101f82:	68 54 3c 10 00       	push   $0x103c54
  101f87:	e8 be e2 ff ff       	call   10024a <cprintf>
  101f8c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", reg2);
  101f8f:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101f93:	0f b7 c0             	movzwl %ax,%eax
  101f96:	83 ec 08             	sub    $0x8,%esp
  101f99:	50                   	push   %eax
  101f9a:	68 62 3c 10 00       	push   $0x103c62
  101f9f:	e8 a6 e2 ff ff       	call   10024a <cprintf>
  101fa4:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", reg3);
  101fa7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101fab:	0f b7 c0             	movzwl %ax,%eax
  101fae:	83 ec 08             	sub    $0x8,%esp
  101fb1:	50                   	push   %eax
  101fb2:	68 70 3c 10 00       	push   $0x103c70
  101fb7:	e8 8e e2 ff ff       	call   10024a <cprintf>
  101fbc:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", reg4);
  101fbf:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101fc3:	0f b7 c0             	movzwl %ax,%eax
  101fc6:	83 ec 08             	sub    $0x8,%esp
  101fc9:	50                   	push   %eax
  101fca:	68 7e 3c 10 00       	push   $0x103c7e
  101fcf:	e8 76 e2 ff ff       	call   10024a <cprintf>
  101fd4:	83 c4 10             	add    $0x10,%esp
}
  101fd7:	90                   	nop
  101fd8:	c9                   	leave  
  101fd9:	c3                   	ret    

00101fda <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101fda:	55                   	push   %ebp
  101fdb:	89 e5                	mov    %esp,%ebp
  101fdd:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101fe0:	83 ec 0c             	sub    $0xc,%esp
  101fe3:	ff 75 08             	pushl  0x8(%ebp)
  101fe6:	e8 91 fc ff ff       	call   101c7c <trap_dispatch>
  101feb:	83 c4 10             	add    $0x10,%esp
}
  101fee:	90                   	nop
  101fef:	c9                   	leave  
  101ff0:	c3                   	ret    

00101ff1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $0
  101ff3:	6a 00                	push   $0x0
  jmp __alltraps
  101ff5:	e9 69 0a 00 00       	jmp    102a63 <__alltraps>

00101ffa <vector1>:
.globl vector1
vector1:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $1
  101ffc:	6a 01                	push   $0x1
  jmp __alltraps
  101ffe:	e9 60 0a 00 00       	jmp    102a63 <__alltraps>

00102003 <vector2>:
.globl vector2
vector2:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $2
  102005:	6a 02                	push   $0x2
  jmp __alltraps
  102007:	e9 57 0a 00 00       	jmp    102a63 <__alltraps>

0010200c <vector3>:
.globl vector3
vector3:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $3
  10200e:	6a 03                	push   $0x3
  jmp __alltraps
  102010:	e9 4e 0a 00 00       	jmp    102a63 <__alltraps>

00102015 <vector4>:
.globl vector4
vector4:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $4
  102017:	6a 04                	push   $0x4
  jmp __alltraps
  102019:	e9 45 0a 00 00       	jmp    102a63 <__alltraps>

0010201e <vector5>:
.globl vector5
vector5:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $5
  102020:	6a 05                	push   $0x5
  jmp __alltraps
  102022:	e9 3c 0a 00 00       	jmp    102a63 <__alltraps>

00102027 <vector6>:
.globl vector6
vector6:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $6
  102029:	6a 06                	push   $0x6
  jmp __alltraps
  10202b:	e9 33 0a 00 00       	jmp    102a63 <__alltraps>

00102030 <vector7>:
.globl vector7
vector7:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $7
  102032:	6a 07                	push   $0x7
  jmp __alltraps
  102034:	e9 2a 0a 00 00       	jmp    102a63 <__alltraps>

00102039 <vector8>:
.globl vector8
vector8:
  pushl $8
  102039:	6a 08                	push   $0x8
  jmp __alltraps
  10203b:	e9 23 0a 00 00       	jmp    102a63 <__alltraps>

00102040 <vector9>:
.globl vector9
vector9:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $9
  102042:	6a 09                	push   $0x9
  jmp __alltraps
  102044:	e9 1a 0a 00 00       	jmp    102a63 <__alltraps>

00102049 <vector10>:
.globl vector10
vector10:
  pushl $10
  102049:	6a 0a                	push   $0xa
  jmp __alltraps
  10204b:	e9 13 0a 00 00       	jmp    102a63 <__alltraps>

00102050 <vector11>:
.globl vector11
vector11:
  pushl $11
  102050:	6a 0b                	push   $0xb
  jmp __alltraps
  102052:	e9 0c 0a 00 00       	jmp    102a63 <__alltraps>

00102057 <vector12>:
.globl vector12
vector12:
  pushl $12
  102057:	6a 0c                	push   $0xc
  jmp __alltraps
  102059:	e9 05 0a 00 00       	jmp    102a63 <__alltraps>

0010205e <vector13>:
.globl vector13
vector13:
  pushl $13
  10205e:	6a 0d                	push   $0xd
  jmp __alltraps
  102060:	e9 fe 09 00 00       	jmp    102a63 <__alltraps>

00102065 <vector14>:
.globl vector14
vector14:
  pushl $14
  102065:	6a 0e                	push   $0xe
  jmp __alltraps
  102067:	e9 f7 09 00 00       	jmp    102a63 <__alltraps>

0010206c <vector15>:
.globl vector15
vector15:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $15
  10206e:	6a 0f                	push   $0xf
  jmp __alltraps
  102070:	e9 ee 09 00 00       	jmp    102a63 <__alltraps>

00102075 <vector16>:
.globl vector16
vector16:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $16
  102077:	6a 10                	push   $0x10
  jmp __alltraps
  102079:	e9 e5 09 00 00       	jmp    102a63 <__alltraps>

0010207e <vector17>:
.globl vector17
vector17:
  pushl $17
  10207e:	6a 11                	push   $0x11
  jmp __alltraps
  102080:	e9 de 09 00 00       	jmp    102a63 <__alltraps>

00102085 <vector18>:
.globl vector18
vector18:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $18
  102087:	6a 12                	push   $0x12
  jmp __alltraps
  102089:	e9 d5 09 00 00       	jmp    102a63 <__alltraps>

0010208e <vector19>:
.globl vector19
vector19:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $19
  102090:	6a 13                	push   $0x13
  jmp __alltraps
  102092:	e9 cc 09 00 00       	jmp    102a63 <__alltraps>

00102097 <vector20>:
.globl vector20
vector20:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $20
  102099:	6a 14                	push   $0x14
  jmp __alltraps
  10209b:	e9 c3 09 00 00       	jmp    102a63 <__alltraps>

001020a0 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $21
  1020a2:	6a 15                	push   $0x15
  jmp __alltraps
  1020a4:	e9 ba 09 00 00       	jmp    102a63 <__alltraps>

001020a9 <vector22>:
.globl vector22
vector22:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $22
  1020ab:	6a 16                	push   $0x16
  jmp __alltraps
  1020ad:	e9 b1 09 00 00       	jmp    102a63 <__alltraps>

001020b2 <vector23>:
.globl vector23
vector23:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $23
  1020b4:	6a 17                	push   $0x17
  jmp __alltraps
  1020b6:	e9 a8 09 00 00       	jmp    102a63 <__alltraps>

001020bb <vector24>:
.globl vector24
vector24:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $24
  1020bd:	6a 18                	push   $0x18
  jmp __alltraps
  1020bf:	e9 9f 09 00 00       	jmp    102a63 <__alltraps>

001020c4 <vector25>:
.globl vector25
vector25:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $25
  1020c6:	6a 19                	push   $0x19
  jmp __alltraps
  1020c8:	e9 96 09 00 00       	jmp    102a63 <__alltraps>

001020cd <vector26>:
.globl vector26
vector26:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $26
  1020cf:	6a 1a                	push   $0x1a
  jmp __alltraps
  1020d1:	e9 8d 09 00 00       	jmp    102a63 <__alltraps>

001020d6 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $27
  1020d8:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020da:	e9 84 09 00 00       	jmp    102a63 <__alltraps>

001020df <vector28>:
.globl vector28
vector28:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $28
  1020e1:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020e3:	e9 7b 09 00 00       	jmp    102a63 <__alltraps>

001020e8 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $29
  1020ea:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020ec:	e9 72 09 00 00       	jmp    102a63 <__alltraps>

001020f1 <vector30>:
.globl vector30
vector30:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $30
  1020f3:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020f5:	e9 69 09 00 00       	jmp    102a63 <__alltraps>

001020fa <vector31>:
.globl vector31
vector31:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $31
  1020fc:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020fe:	e9 60 09 00 00       	jmp    102a63 <__alltraps>

00102103 <vector32>:
.globl vector32
vector32:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $32
  102105:	6a 20                	push   $0x20
  jmp __alltraps
  102107:	e9 57 09 00 00       	jmp    102a63 <__alltraps>

0010210c <vector33>:
.globl vector33
vector33:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $33
  10210e:	6a 21                	push   $0x21
  jmp __alltraps
  102110:	e9 4e 09 00 00       	jmp    102a63 <__alltraps>

00102115 <vector34>:
.globl vector34
vector34:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $34
  102117:	6a 22                	push   $0x22
  jmp __alltraps
  102119:	e9 45 09 00 00       	jmp    102a63 <__alltraps>

0010211e <vector35>:
.globl vector35
vector35:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $35
  102120:	6a 23                	push   $0x23
  jmp __alltraps
  102122:	e9 3c 09 00 00       	jmp    102a63 <__alltraps>

00102127 <vector36>:
.globl vector36
vector36:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $36
  102129:	6a 24                	push   $0x24
  jmp __alltraps
  10212b:	e9 33 09 00 00       	jmp    102a63 <__alltraps>

00102130 <vector37>:
.globl vector37
vector37:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $37
  102132:	6a 25                	push   $0x25
  jmp __alltraps
  102134:	e9 2a 09 00 00       	jmp    102a63 <__alltraps>

00102139 <vector38>:
.globl vector38
vector38:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $38
  10213b:	6a 26                	push   $0x26
  jmp __alltraps
  10213d:	e9 21 09 00 00       	jmp    102a63 <__alltraps>

00102142 <vector39>:
.globl vector39
vector39:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $39
  102144:	6a 27                	push   $0x27
  jmp __alltraps
  102146:	e9 18 09 00 00       	jmp    102a63 <__alltraps>

0010214b <vector40>:
.globl vector40
vector40:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $40
  10214d:	6a 28                	push   $0x28
  jmp __alltraps
  10214f:	e9 0f 09 00 00       	jmp    102a63 <__alltraps>

00102154 <vector41>:
.globl vector41
vector41:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $41
  102156:	6a 29                	push   $0x29
  jmp __alltraps
  102158:	e9 06 09 00 00       	jmp    102a63 <__alltraps>

0010215d <vector42>:
.globl vector42
vector42:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $42
  10215f:	6a 2a                	push   $0x2a
  jmp __alltraps
  102161:	e9 fd 08 00 00       	jmp    102a63 <__alltraps>

00102166 <vector43>:
.globl vector43
vector43:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $43
  102168:	6a 2b                	push   $0x2b
  jmp __alltraps
  10216a:	e9 f4 08 00 00       	jmp    102a63 <__alltraps>

0010216f <vector44>:
.globl vector44
vector44:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $44
  102171:	6a 2c                	push   $0x2c
  jmp __alltraps
  102173:	e9 eb 08 00 00       	jmp    102a63 <__alltraps>

00102178 <vector45>:
.globl vector45
vector45:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $45
  10217a:	6a 2d                	push   $0x2d
  jmp __alltraps
  10217c:	e9 e2 08 00 00       	jmp    102a63 <__alltraps>

00102181 <vector46>:
.globl vector46
vector46:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $46
  102183:	6a 2e                	push   $0x2e
  jmp __alltraps
  102185:	e9 d9 08 00 00       	jmp    102a63 <__alltraps>

0010218a <vector47>:
.globl vector47
vector47:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $47
  10218c:	6a 2f                	push   $0x2f
  jmp __alltraps
  10218e:	e9 d0 08 00 00       	jmp    102a63 <__alltraps>

00102193 <vector48>:
.globl vector48
vector48:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $48
  102195:	6a 30                	push   $0x30
  jmp __alltraps
  102197:	e9 c7 08 00 00       	jmp    102a63 <__alltraps>

0010219c <vector49>:
.globl vector49
vector49:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $49
  10219e:	6a 31                	push   $0x31
  jmp __alltraps
  1021a0:	e9 be 08 00 00       	jmp    102a63 <__alltraps>

001021a5 <vector50>:
.globl vector50
vector50:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $50
  1021a7:	6a 32                	push   $0x32
  jmp __alltraps
  1021a9:	e9 b5 08 00 00       	jmp    102a63 <__alltraps>

001021ae <vector51>:
.globl vector51
vector51:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $51
  1021b0:	6a 33                	push   $0x33
  jmp __alltraps
  1021b2:	e9 ac 08 00 00       	jmp    102a63 <__alltraps>

001021b7 <vector52>:
.globl vector52
vector52:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $52
  1021b9:	6a 34                	push   $0x34
  jmp __alltraps
  1021bb:	e9 a3 08 00 00       	jmp    102a63 <__alltraps>

001021c0 <vector53>:
.globl vector53
vector53:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $53
  1021c2:	6a 35                	push   $0x35
  jmp __alltraps
  1021c4:	e9 9a 08 00 00       	jmp    102a63 <__alltraps>

001021c9 <vector54>:
.globl vector54
vector54:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $54
  1021cb:	6a 36                	push   $0x36
  jmp __alltraps
  1021cd:	e9 91 08 00 00       	jmp    102a63 <__alltraps>

001021d2 <vector55>:
.globl vector55
vector55:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $55
  1021d4:	6a 37                	push   $0x37
  jmp __alltraps
  1021d6:	e9 88 08 00 00       	jmp    102a63 <__alltraps>

001021db <vector56>:
.globl vector56
vector56:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $56
  1021dd:	6a 38                	push   $0x38
  jmp __alltraps
  1021df:	e9 7f 08 00 00       	jmp    102a63 <__alltraps>

001021e4 <vector57>:
.globl vector57
vector57:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $57
  1021e6:	6a 39                	push   $0x39
  jmp __alltraps
  1021e8:	e9 76 08 00 00       	jmp    102a63 <__alltraps>

001021ed <vector58>:
.globl vector58
vector58:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $58
  1021ef:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021f1:	e9 6d 08 00 00       	jmp    102a63 <__alltraps>

001021f6 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $59
  1021f8:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021fa:	e9 64 08 00 00       	jmp    102a63 <__alltraps>

001021ff <vector60>:
.globl vector60
vector60:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $60
  102201:	6a 3c                	push   $0x3c
  jmp __alltraps
  102203:	e9 5b 08 00 00       	jmp    102a63 <__alltraps>

00102208 <vector61>:
.globl vector61
vector61:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $61
  10220a:	6a 3d                	push   $0x3d
  jmp __alltraps
  10220c:	e9 52 08 00 00       	jmp    102a63 <__alltraps>

00102211 <vector62>:
.globl vector62
vector62:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $62
  102213:	6a 3e                	push   $0x3e
  jmp __alltraps
  102215:	e9 49 08 00 00       	jmp    102a63 <__alltraps>

0010221a <vector63>:
.globl vector63
vector63:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $63
  10221c:	6a 3f                	push   $0x3f
  jmp __alltraps
  10221e:	e9 40 08 00 00       	jmp    102a63 <__alltraps>

00102223 <vector64>:
.globl vector64
vector64:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $64
  102225:	6a 40                	push   $0x40
  jmp __alltraps
  102227:	e9 37 08 00 00       	jmp    102a63 <__alltraps>

0010222c <vector65>:
.globl vector65
vector65:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $65
  10222e:	6a 41                	push   $0x41
  jmp __alltraps
  102230:	e9 2e 08 00 00       	jmp    102a63 <__alltraps>

00102235 <vector66>:
.globl vector66
vector66:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $66
  102237:	6a 42                	push   $0x42
  jmp __alltraps
  102239:	e9 25 08 00 00       	jmp    102a63 <__alltraps>

0010223e <vector67>:
.globl vector67
vector67:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $67
  102240:	6a 43                	push   $0x43
  jmp __alltraps
  102242:	e9 1c 08 00 00       	jmp    102a63 <__alltraps>

00102247 <vector68>:
.globl vector68
vector68:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $68
  102249:	6a 44                	push   $0x44
  jmp __alltraps
  10224b:	e9 13 08 00 00       	jmp    102a63 <__alltraps>

00102250 <vector69>:
.globl vector69
vector69:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $69
  102252:	6a 45                	push   $0x45
  jmp __alltraps
  102254:	e9 0a 08 00 00       	jmp    102a63 <__alltraps>

00102259 <vector70>:
.globl vector70
vector70:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $70
  10225b:	6a 46                	push   $0x46
  jmp __alltraps
  10225d:	e9 01 08 00 00       	jmp    102a63 <__alltraps>

00102262 <vector71>:
.globl vector71
vector71:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $71
  102264:	6a 47                	push   $0x47
  jmp __alltraps
  102266:	e9 f8 07 00 00       	jmp    102a63 <__alltraps>

0010226b <vector72>:
.globl vector72
vector72:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $72
  10226d:	6a 48                	push   $0x48
  jmp __alltraps
  10226f:	e9 ef 07 00 00       	jmp    102a63 <__alltraps>

00102274 <vector73>:
.globl vector73
vector73:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $73
  102276:	6a 49                	push   $0x49
  jmp __alltraps
  102278:	e9 e6 07 00 00       	jmp    102a63 <__alltraps>

0010227d <vector74>:
.globl vector74
vector74:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $74
  10227f:	6a 4a                	push   $0x4a
  jmp __alltraps
  102281:	e9 dd 07 00 00       	jmp    102a63 <__alltraps>

00102286 <vector75>:
.globl vector75
vector75:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $75
  102288:	6a 4b                	push   $0x4b
  jmp __alltraps
  10228a:	e9 d4 07 00 00       	jmp    102a63 <__alltraps>

0010228f <vector76>:
.globl vector76
vector76:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $76
  102291:	6a 4c                	push   $0x4c
  jmp __alltraps
  102293:	e9 cb 07 00 00       	jmp    102a63 <__alltraps>

00102298 <vector77>:
.globl vector77
vector77:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $77
  10229a:	6a 4d                	push   $0x4d
  jmp __alltraps
  10229c:	e9 c2 07 00 00       	jmp    102a63 <__alltraps>

001022a1 <vector78>:
.globl vector78
vector78:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $78
  1022a3:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022a5:	e9 b9 07 00 00       	jmp    102a63 <__alltraps>

001022aa <vector79>:
.globl vector79
vector79:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $79
  1022ac:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022ae:	e9 b0 07 00 00       	jmp    102a63 <__alltraps>

001022b3 <vector80>:
.globl vector80
vector80:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $80
  1022b5:	6a 50                	push   $0x50
  jmp __alltraps
  1022b7:	e9 a7 07 00 00       	jmp    102a63 <__alltraps>

001022bc <vector81>:
.globl vector81
vector81:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $81
  1022be:	6a 51                	push   $0x51
  jmp __alltraps
  1022c0:	e9 9e 07 00 00       	jmp    102a63 <__alltraps>

001022c5 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $82
  1022c7:	6a 52                	push   $0x52
  jmp __alltraps
  1022c9:	e9 95 07 00 00       	jmp    102a63 <__alltraps>

001022ce <vector83>:
.globl vector83
vector83:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $83
  1022d0:	6a 53                	push   $0x53
  jmp __alltraps
  1022d2:	e9 8c 07 00 00       	jmp    102a63 <__alltraps>

001022d7 <vector84>:
.globl vector84
vector84:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $84
  1022d9:	6a 54                	push   $0x54
  jmp __alltraps
  1022db:	e9 83 07 00 00       	jmp    102a63 <__alltraps>

001022e0 <vector85>:
.globl vector85
vector85:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $85
  1022e2:	6a 55                	push   $0x55
  jmp __alltraps
  1022e4:	e9 7a 07 00 00       	jmp    102a63 <__alltraps>

001022e9 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $86
  1022eb:	6a 56                	push   $0x56
  jmp __alltraps
  1022ed:	e9 71 07 00 00       	jmp    102a63 <__alltraps>

001022f2 <vector87>:
.globl vector87
vector87:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $87
  1022f4:	6a 57                	push   $0x57
  jmp __alltraps
  1022f6:	e9 68 07 00 00       	jmp    102a63 <__alltraps>

001022fb <vector88>:
.globl vector88
vector88:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $88
  1022fd:	6a 58                	push   $0x58
  jmp __alltraps
  1022ff:	e9 5f 07 00 00       	jmp    102a63 <__alltraps>

00102304 <vector89>:
.globl vector89
vector89:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $89
  102306:	6a 59                	push   $0x59
  jmp __alltraps
  102308:	e9 56 07 00 00       	jmp    102a63 <__alltraps>

0010230d <vector90>:
.globl vector90
vector90:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $90
  10230f:	6a 5a                	push   $0x5a
  jmp __alltraps
  102311:	e9 4d 07 00 00       	jmp    102a63 <__alltraps>

00102316 <vector91>:
.globl vector91
vector91:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $91
  102318:	6a 5b                	push   $0x5b
  jmp __alltraps
  10231a:	e9 44 07 00 00       	jmp    102a63 <__alltraps>

0010231f <vector92>:
.globl vector92
vector92:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $92
  102321:	6a 5c                	push   $0x5c
  jmp __alltraps
  102323:	e9 3b 07 00 00       	jmp    102a63 <__alltraps>

00102328 <vector93>:
.globl vector93
vector93:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $93
  10232a:	6a 5d                	push   $0x5d
  jmp __alltraps
  10232c:	e9 32 07 00 00       	jmp    102a63 <__alltraps>

00102331 <vector94>:
.globl vector94
vector94:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $94
  102333:	6a 5e                	push   $0x5e
  jmp __alltraps
  102335:	e9 29 07 00 00       	jmp    102a63 <__alltraps>

0010233a <vector95>:
.globl vector95
vector95:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $95
  10233c:	6a 5f                	push   $0x5f
  jmp __alltraps
  10233e:	e9 20 07 00 00       	jmp    102a63 <__alltraps>

00102343 <vector96>:
.globl vector96
vector96:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $96
  102345:	6a 60                	push   $0x60
  jmp __alltraps
  102347:	e9 17 07 00 00       	jmp    102a63 <__alltraps>

0010234c <vector97>:
.globl vector97
vector97:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $97
  10234e:	6a 61                	push   $0x61
  jmp __alltraps
  102350:	e9 0e 07 00 00       	jmp    102a63 <__alltraps>

00102355 <vector98>:
.globl vector98
vector98:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $98
  102357:	6a 62                	push   $0x62
  jmp __alltraps
  102359:	e9 05 07 00 00       	jmp    102a63 <__alltraps>

0010235e <vector99>:
.globl vector99
vector99:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $99
  102360:	6a 63                	push   $0x63
  jmp __alltraps
  102362:	e9 fc 06 00 00       	jmp    102a63 <__alltraps>

00102367 <vector100>:
.globl vector100
vector100:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $100
  102369:	6a 64                	push   $0x64
  jmp __alltraps
  10236b:	e9 f3 06 00 00       	jmp    102a63 <__alltraps>

00102370 <vector101>:
.globl vector101
vector101:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $101
  102372:	6a 65                	push   $0x65
  jmp __alltraps
  102374:	e9 ea 06 00 00       	jmp    102a63 <__alltraps>

00102379 <vector102>:
.globl vector102
vector102:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $102
  10237b:	6a 66                	push   $0x66
  jmp __alltraps
  10237d:	e9 e1 06 00 00       	jmp    102a63 <__alltraps>

00102382 <vector103>:
.globl vector103
vector103:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $103
  102384:	6a 67                	push   $0x67
  jmp __alltraps
  102386:	e9 d8 06 00 00       	jmp    102a63 <__alltraps>

0010238b <vector104>:
.globl vector104
vector104:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $104
  10238d:	6a 68                	push   $0x68
  jmp __alltraps
  10238f:	e9 cf 06 00 00       	jmp    102a63 <__alltraps>

00102394 <vector105>:
.globl vector105
vector105:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $105
  102396:	6a 69                	push   $0x69
  jmp __alltraps
  102398:	e9 c6 06 00 00       	jmp    102a63 <__alltraps>

0010239d <vector106>:
.globl vector106
vector106:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $106
  10239f:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023a1:	e9 bd 06 00 00       	jmp    102a63 <__alltraps>

001023a6 <vector107>:
.globl vector107
vector107:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $107
  1023a8:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023aa:	e9 b4 06 00 00       	jmp    102a63 <__alltraps>

001023af <vector108>:
.globl vector108
vector108:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $108
  1023b1:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023b3:	e9 ab 06 00 00       	jmp    102a63 <__alltraps>

001023b8 <vector109>:
.globl vector109
vector109:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $109
  1023ba:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023bc:	e9 a2 06 00 00       	jmp    102a63 <__alltraps>

001023c1 <vector110>:
.globl vector110
vector110:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $110
  1023c3:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023c5:	e9 99 06 00 00       	jmp    102a63 <__alltraps>

001023ca <vector111>:
.globl vector111
vector111:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $111
  1023cc:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023ce:	e9 90 06 00 00       	jmp    102a63 <__alltraps>

001023d3 <vector112>:
.globl vector112
vector112:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $112
  1023d5:	6a 70                	push   $0x70
  jmp __alltraps
  1023d7:	e9 87 06 00 00       	jmp    102a63 <__alltraps>

001023dc <vector113>:
.globl vector113
vector113:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $113
  1023de:	6a 71                	push   $0x71
  jmp __alltraps
  1023e0:	e9 7e 06 00 00       	jmp    102a63 <__alltraps>

001023e5 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $114
  1023e7:	6a 72                	push   $0x72
  jmp __alltraps
  1023e9:	e9 75 06 00 00       	jmp    102a63 <__alltraps>

001023ee <vector115>:
.globl vector115
vector115:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $115
  1023f0:	6a 73                	push   $0x73
  jmp __alltraps
  1023f2:	e9 6c 06 00 00       	jmp    102a63 <__alltraps>

001023f7 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $116
  1023f9:	6a 74                	push   $0x74
  jmp __alltraps
  1023fb:	e9 63 06 00 00       	jmp    102a63 <__alltraps>

00102400 <vector117>:
.globl vector117
vector117:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $117
  102402:	6a 75                	push   $0x75
  jmp __alltraps
  102404:	e9 5a 06 00 00       	jmp    102a63 <__alltraps>

00102409 <vector118>:
.globl vector118
vector118:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $118
  10240b:	6a 76                	push   $0x76
  jmp __alltraps
  10240d:	e9 51 06 00 00       	jmp    102a63 <__alltraps>

00102412 <vector119>:
.globl vector119
vector119:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $119
  102414:	6a 77                	push   $0x77
  jmp __alltraps
  102416:	e9 48 06 00 00       	jmp    102a63 <__alltraps>

0010241b <vector120>:
.globl vector120
vector120:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $120
  10241d:	6a 78                	push   $0x78
  jmp __alltraps
  10241f:	e9 3f 06 00 00       	jmp    102a63 <__alltraps>

00102424 <vector121>:
.globl vector121
vector121:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $121
  102426:	6a 79                	push   $0x79
  jmp __alltraps
  102428:	e9 36 06 00 00       	jmp    102a63 <__alltraps>

0010242d <vector122>:
.globl vector122
vector122:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $122
  10242f:	6a 7a                	push   $0x7a
  jmp __alltraps
  102431:	e9 2d 06 00 00       	jmp    102a63 <__alltraps>

00102436 <vector123>:
.globl vector123
vector123:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $123
  102438:	6a 7b                	push   $0x7b
  jmp __alltraps
  10243a:	e9 24 06 00 00       	jmp    102a63 <__alltraps>

0010243f <vector124>:
.globl vector124
vector124:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $124
  102441:	6a 7c                	push   $0x7c
  jmp __alltraps
  102443:	e9 1b 06 00 00       	jmp    102a63 <__alltraps>

00102448 <vector125>:
.globl vector125
vector125:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $125
  10244a:	6a 7d                	push   $0x7d
  jmp __alltraps
  10244c:	e9 12 06 00 00       	jmp    102a63 <__alltraps>

00102451 <vector126>:
.globl vector126
vector126:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $126
  102453:	6a 7e                	push   $0x7e
  jmp __alltraps
  102455:	e9 09 06 00 00       	jmp    102a63 <__alltraps>

0010245a <vector127>:
.globl vector127
vector127:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $127
  10245c:	6a 7f                	push   $0x7f
  jmp __alltraps
  10245e:	e9 00 06 00 00       	jmp    102a63 <__alltraps>

00102463 <vector128>:
.globl vector128
vector128:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $128
  102465:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10246a:	e9 f4 05 00 00       	jmp    102a63 <__alltraps>

0010246f <vector129>:
.globl vector129
vector129:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $129
  102471:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102476:	e9 e8 05 00 00       	jmp    102a63 <__alltraps>

0010247b <vector130>:
.globl vector130
vector130:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $130
  10247d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102482:	e9 dc 05 00 00       	jmp    102a63 <__alltraps>

00102487 <vector131>:
.globl vector131
vector131:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $131
  102489:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10248e:	e9 d0 05 00 00       	jmp    102a63 <__alltraps>

00102493 <vector132>:
.globl vector132
vector132:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $132
  102495:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10249a:	e9 c4 05 00 00       	jmp    102a63 <__alltraps>

0010249f <vector133>:
.globl vector133
vector133:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $133
  1024a1:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024a6:	e9 b8 05 00 00       	jmp    102a63 <__alltraps>

001024ab <vector134>:
.globl vector134
vector134:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $134
  1024ad:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024b2:	e9 ac 05 00 00       	jmp    102a63 <__alltraps>

001024b7 <vector135>:
.globl vector135
vector135:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $135
  1024b9:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1024be:	e9 a0 05 00 00       	jmp    102a63 <__alltraps>

001024c3 <vector136>:
.globl vector136
vector136:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $136
  1024c5:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024ca:	e9 94 05 00 00       	jmp    102a63 <__alltraps>

001024cf <vector137>:
.globl vector137
vector137:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $137
  1024d1:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024d6:	e9 88 05 00 00       	jmp    102a63 <__alltraps>

001024db <vector138>:
.globl vector138
vector138:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $138
  1024dd:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024e2:	e9 7c 05 00 00       	jmp    102a63 <__alltraps>

001024e7 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $139
  1024e9:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024ee:	e9 70 05 00 00       	jmp    102a63 <__alltraps>

001024f3 <vector140>:
.globl vector140
vector140:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $140
  1024f5:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024fa:	e9 64 05 00 00       	jmp    102a63 <__alltraps>

001024ff <vector141>:
.globl vector141
vector141:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $141
  102501:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102506:	e9 58 05 00 00       	jmp    102a63 <__alltraps>

0010250b <vector142>:
.globl vector142
vector142:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $142
  10250d:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102512:	e9 4c 05 00 00       	jmp    102a63 <__alltraps>

00102517 <vector143>:
.globl vector143
vector143:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $143
  102519:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10251e:	e9 40 05 00 00       	jmp    102a63 <__alltraps>

00102523 <vector144>:
.globl vector144
vector144:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $144
  102525:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10252a:	e9 34 05 00 00       	jmp    102a63 <__alltraps>

0010252f <vector145>:
.globl vector145
vector145:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $145
  102531:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102536:	e9 28 05 00 00       	jmp    102a63 <__alltraps>

0010253b <vector146>:
.globl vector146
vector146:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $146
  10253d:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102542:	e9 1c 05 00 00       	jmp    102a63 <__alltraps>

00102547 <vector147>:
.globl vector147
vector147:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $147
  102549:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10254e:	e9 10 05 00 00       	jmp    102a63 <__alltraps>

00102553 <vector148>:
.globl vector148
vector148:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $148
  102555:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10255a:	e9 04 05 00 00       	jmp    102a63 <__alltraps>

0010255f <vector149>:
.globl vector149
vector149:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $149
  102561:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102566:	e9 f8 04 00 00       	jmp    102a63 <__alltraps>

0010256b <vector150>:
.globl vector150
vector150:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $150
  10256d:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102572:	e9 ec 04 00 00       	jmp    102a63 <__alltraps>

00102577 <vector151>:
.globl vector151
vector151:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $151
  102579:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10257e:	e9 e0 04 00 00       	jmp    102a63 <__alltraps>

00102583 <vector152>:
.globl vector152
vector152:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $152
  102585:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10258a:	e9 d4 04 00 00       	jmp    102a63 <__alltraps>

0010258f <vector153>:
.globl vector153
vector153:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $153
  102591:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102596:	e9 c8 04 00 00       	jmp    102a63 <__alltraps>

0010259b <vector154>:
.globl vector154
vector154:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $154
  10259d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025a2:	e9 bc 04 00 00       	jmp    102a63 <__alltraps>

001025a7 <vector155>:
.globl vector155
vector155:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $155
  1025a9:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025ae:	e9 b0 04 00 00       	jmp    102a63 <__alltraps>

001025b3 <vector156>:
.globl vector156
vector156:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $156
  1025b5:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025ba:	e9 a4 04 00 00       	jmp    102a63 <__alltraps>

001025bf <vector157>:
.globl vector157
vector157:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $157
  1025c1:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025c6:	e9 98 04 00 00       	jmp    102a63 <__alltraps>

001025cb <vector158>:
.globl vector158
vector158:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $158
  1025cd:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025d2:	e9 8c 04 00 00       	jmp    102a63 <__alltraps>

001025d7 <vector159>:
.globl vector159
vector159:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $159
  1025d9:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025de:	e9 80 04 00 00       	jmp    102a63 <__alltraps>

001025e3 <vector160>:
.globl vector160
vector160:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $160
  1025e5:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025ea:	e9 74 04 00 00       	jmp    102a63 <__alltraps>

001025ef <vector161>:
.globl vector161
vector161:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $161
  1025f1:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025f6:	e9 68 04 00 00       	jmp    102a63 <__alltraps>

001025fb <vector162>:
.globl vector162
vector162:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $162
  1025fd:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102602:	e9 5c 04 00 00       	jmp    102a63 <__alltraps>

00102607 <vector163>:
.globl vector163
vector163:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $163
  102609:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10260e:	e9 50 04 00 00       	jmp    102a63 <__alltraps>

00102613 <vector164>:
.globl vector164
vector164:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $164
  102615:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10261a:	e9 44 04 00 00       	jmp    102a63 <__alltraps>

0010261f <vector165>:
.globl vector165
vector165:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $165
  102621:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102626:	e9 38 04 00 00       	jmp    102a63 <__alltraps>

0010262b <vector166>:
.globl vector166
vector166:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $166
  10262d:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102632:	e9 2c 04 00 00       	jmp    102a63 <__alltraps>

00102637 <vector167>:
.globl vector167
vector167:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $167
  102639:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10263e:	e9 20 04 00 00       	jmp    102a63 <__alltraps>

00102643 <vector168>:
.globl vector168
vector168:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $168
  102645:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10264a:	e9 14 04 00 00       	jmp    102a63 <__alltraps>

0010264f <vector169>:
.globl vector169
vector169:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $169
  102651:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102656:	e9 08 04 00 00       	jmp    102a63 <__alltraps>

0010265b <vector170>:
.globl vector170
vector170:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $170
  10265d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102662:	e9 fc 03 00 00       	jmp    102a63 <__alltraps>

00102667 <vector171>:
.globl vector171
vector171:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $171
  102669:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10266e:	e9 f0 03 00 00       	jmp    102a63 <__alltraps>

00102673 <vector172>:
.globl vector172
vector172:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $172
  102675:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10267a:	e9 e4 03 00 00       	jmp    102a63 <__alltraps>

0010267f <vector173>:
.globl vector173
vector173:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $173
  102681:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102686:	e9 d8 03 00 00       	jmp    102a63 <__alltraps>

0010268b <vector174>:
.globl vector174
vector174:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $174
  10268d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102692:	e9 cc 03 00 00       	jmp    102a63 <__alltraps>

00102697 <vector175>:
.globl vector175
vector175:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $175
  102699:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10269e:	e9 c0 03 00 00       	jmp    102a63 <__alltraps>

001026a3 <vector176>:
.globl vector176
vector176:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $176
  1026a5:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026aa:	e9 b4 03 00 00       	jmp    102a63 <__alltraps>

001026af <vector177>:
.globl vector177
vector177:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $177
  1026b1:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026b6:	e9 a8 03 00 00       	jmp    102a63 <__alltraps>

001026bb <vector178>:
.globl vector178
vector178:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $178
  1026bd:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026c2:	e9 9c 03 00 00       	jmp    102a63 <__alltraps>

001026c7 <vector179>:
.globl vector179
vector179:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $179
  1026c9:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026ce:	e9 90 03 00 00       	jmp    102a63 <__alltraps>

001026d3 <vector180>:
.globl vector180
vector180:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $180
  1026d5:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026da:	e9 84 03 00 00       	jmp    102a63 <__alltraps>

001026df <vector181>:
.globl vector181
vector181:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $181
  1026e1:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026e6:	e9 78 03 00 00       	jmp    102a63 <__alltraps>

001026eb <vector182>:
.globl vector182
vector182:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $182
  1026ed:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026f2:	e9 6c 03 00 00       	jmp    102a63 <__alltraps>

001026f7 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $183
  1026f9:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026fe:	e9 60 03 00 00       	jmp    102a63 <__alltraps>

00102703 <vector184>:
.globl vector184
vector184:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $184
  102705:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10270a:	e9 54 03 00 00       	jmp    102a63 <__alltraps>

0010270f <vector185>:
.globl vector185
vector185:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $185
  102711:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102716:	e9 48 03 00 00       	jmp    102a63 <__alltraps>

0010271b <vector186>:
.globl vector186
vector186:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $186
  10271d:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102722:	e9 3c 03 00 00       	jmp    102a63 <__alltraps>

00102727 <vector187>:
.globl vector187
vector187:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $187
  102729:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10272e:	e9 30 03 00 00       	jmp    102a63 <__alltraps>

00102733 <vector188>:
.globl vector188
vector188:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $188
  102735:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10273a:	e9 24 03 00 00       	jmp    102a63 <__alltraps>

0010273f <vector189>:
.globl vector189
vector189:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $189
  102741:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102746:	e9 18 03 00 00       	jmp    102a63 <__alltraps>

0010274b <vector190>:
.globl vector190
vector190:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $190
  10274d:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102752:	e9 0c 03 00 00       	jmp    102a63 <__alltraps>

00102757 <vector191>:
.globl vector191
vector191:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $191
  102759:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10275e:	e9 00 03 00 00       	jmp    102a63 <__alltraps>

00102763 <vector192>:
.globl vector192
vector192:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $192
  102765:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10276a:	e9 f4 02 00 00       	jmp    102a63 <__alltraps>

0010276f <vector193>:
.globl vector193
vector193:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $193
  102771:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102776:	e9 e8 02 00 00       	jmp    102a63 <__alltraps>

0010277b <vector194>:
.globl vector194
vector194:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $194
  10277d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102782:	e9 dc 02 00 00       	jmp    102a63 <__alltraps>

00102787 <vector195>:
.globl vector195
vector195:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $195
  102789:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10278e:	e9 d0 02 00 00       	jmp    102a63 <__alltraps>

00102793 <vector196>:
.globl vector196
vector196:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $196
  102795:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10279a:	e9 c4 02 00 00       	jmp    102a63 <__alltraps>

0010279f <vector197>:
.globl vector197
vector197:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $197
  1027a1:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027a6:	e9 b8 02 00 00       	jmp    102a63 <__alltraps>

001027ab <vector198>:
.globl vector198
vector198:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $198
  1027ad:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027b2:	e9 ac 02 00 00       	jmp    102a63 <__alltraps>

001027b7 <vector199>:
.globl vector199
vector199:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $199
  1027b9:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1027be:	e9 a0 02 00 00       	jmp    102a63 <__alltraps>

001027c3 <vector200>:
.globl vector200
vector200:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $200
  1027c5:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027ca:	e9 94 02 00 00       	jmp    102a63 <__alltraps>

001027cf <vector201>:
.globl vector201
vector201:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $201
  1027d1:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027d6:	e9 88 02 00 00       	jmp    102a63 <__alltraps>

001027db <vector202>:
.globl vector202
vector202:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $202
  1027dd:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027e2:	e9 7c 02 00 00       	jmp    102a63 <__alltraps>

001027e7 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $203
  1027e9:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027ee:	e9 70 02 00 00       	jmp    102a63 <__alltraps>

001027f3 <vector204>:
.globl vector204
vector204:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $204
  1027f5:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027fa:	e9 64 02 00 00       	jmp    102a63 <__alltraps>

001027ff <vector205>:
.globl vector205
vector205:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $205
  102801:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102806:	e9 58 02 00 00       	jmp    102a63 <__alltraps>

0010280b <vector206>:
.globl vector206
vector206:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $206
  10280d:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102812:	e9 4c 02 00 00       	jmp    102a63 <__alltraps>

00102817 <vector207>:
.globl vector207
vector207:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $207
  102819:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10281e:	e9 40 02 00 00       	jmp    102a63 <__alltraps>

00102823 <vector208>:
.globl vector208
vector208:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $208
  102825:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10282a:	e9 34 02 00 00       	jmp    102a63 <__alltraps>

0010282f <vector209>:
.globl vector209
vector209:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $209
  102831:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102836:	e9 28 02 00 00       	jmp    102a63 <__alltraps>

0010283b <vector210>:
.globl vector210
vector210:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $210
  10283d:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102842:	e9 1c 02 00 00       	jmp    102a63 <__alltraps>

00102847 <vector211>:
.globl vector211
vector211:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $211
  102849:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10284e:	e9 10 02 00 00       	jmp    102a63 <__alltraps>

00102853 <vector212>:
.globl vector212
vector212:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $212
  102855:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10285a:	e9 04 02 00 00       	jmp    102a63 <__alltraps>

0010285f <vector213>:
.globl vector213
vector213:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $213
  102861:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102866:	e9 f8 01 00 00       	jmp    102a63 <__alltraps>

0010286b <vector214>:
.globl vector214
vector214:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $214
  10286d:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102872:	e9 ec 01 00 00       	jmp    102a63 <__alltraps>

00102877 <vector215>:
.globl vector215
vector215:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $215
  102879:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10287e:	e9 e0 01 00 00       	jmp    102a63 <__alltraps>

00102883 <vector216>:
.globl vector216
vector216:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $216
  102885:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10288a:	e9 d4 01 00 00       	jmp    102a63 <__alltraps>

0010288f <vector217>:
.globl vector217
vector217:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $217
  102891:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102896:	e9 c8 01 00 00       	jmp    102a63 <__alltraps>

0010289b <vector218>:
.globl vector218
vector218:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $218
  10289d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028a2:	e9 bc 01 00 00       	jmp    102a63 <__alltraps>

001028a7 <vector219>:
.globl vector219
vector219:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $219
  1028a9:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028ae:	e9 b0 01 00 00       	jmp    102a63 <__alltraps>

001028b3 <vector220>:
.globl vector220
vector220:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $220
  1028b5:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028ba:	e9 a4 01 00 00       	jmp    102a63 <__alltraps>

001028bf <vector221>:
.globl vector221
vector221:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $221
  1028c1:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028c6:	e9 98 01 00 00       	jmp    102a63 <__alltraps>

001028cb <vector222>:
.globl vector222
vector222:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $222
  1028cd:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028d2:	e9 8c 01 00 00       	jmp    102a63 <__alltraps>

001028d7 <vector223>:
.globl vector223
vector223:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $223
  1028d9:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028de:	e9 80 01 00 00       	jmp    102a63 <__alltraps>

001028e3 <vector224>:
.globl vector224
vector224:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $224
  1028e5:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028ea:	e9 74 01 00 00       	jmp    102a63 <__alltraps>

001028ef <vector225>:
.globl vector225
vector225:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $225
  1028f1:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028f6:	e9 68 01 00 00       	jmp    102a63 <__alltraps>

001028fb <vector226>:
.globl vector226
vector226:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $226
  1028fd:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102902:	e9 5c 01 00 00       	jmp    102a63 <__alltraps>

00102907 <vector227>:
.globl vector227
vector227:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $227
  102909:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10290e:	e9 50 01 00 00       	jmp    102a63 <__alltraps>

00102913 <vector228>:
.globl vector228
vector228:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $228
  102915:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10291a:	e9 44 01 00 00       	jmp    102a63 <__alltraps>

0010291f <vector229>:
.globl vector229
vector229:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $229
  102921:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102926:	e9 38 01 00 00       	jmp    102a63 <__alltraps>

0010292b <vector230>:
.globl vector230
vector230:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $230
  10292d:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102932:	e9 2c 01 00 00       	jmp    102a63 <__alltraps>

00102937 <vector231>:
.globl vector231
vector231:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $231
  102939:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10293e:	e9 20 01 00 00       	jmp    102a63 <__alltraps>

00102943 <vector232>:
.globl vector232
vector232:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $232
  102945:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10294a:	e9 14 01 00 00       	jmp    102a63 <__alltraps>

0010294f <vector233>:
.globl vector233
vector233:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $233
  102951:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102956:	e9 08 01 00 00       	jmp    102a63 <__alltraps>

0010295b <vector234>:
.globl vector234
vector234:
  pushl $0
  10295b:	6a 00                	push   $0x0
  pushl $234
  10295d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102962:	e9 fc 00 00 00       	jmp    102a63 <__alltraps>

00102967 <vector235>:
.globl vector235
vector235:
  pushl $0
  102967:	6a 00                	push   $0x0
  pushl $235
  102969:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10296e:	e9 f0 00 00 00       	jmp    102a63 <__alltraps>

00102973 <vector236>:
.globl vector236
vector236:
  pushl $0
  102973:	6a 00                	push   $0x0
  pushl $236
  102975:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10297a:	e9 e4 00 00 00       	jmp    102a63 <__alltraps>

0010297f <vector237>:
.globl vector237
vector237:
  pushl $0
  10297f:	6a 00                	push   $0x0
  pushl $237
  102981:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102986:	e9 d8 00 00 00       	jmp    102a63 <__alltraps>

0010298b <vector238>:
.globl vector238
vector238:
  pushl $0
  10298b:	6a 00                	push   $0x0
  pushl $238
  10298d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102992:	e9 cc 00 00 00       	jmp    102a63 <__alltraps>

00102997 <vector239>:
.globl vector239
vector239:
  pushl $0
  102997:	6a 00                	push   $0x0
  pushl $239
  102999:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10299e:	e9 c0 00 00 00       	jmp    102a63 <__alltraps>

001029a3 <vector240>:
.globl vector240
vector240:
  pushl $0
  1029a3:	6a 00                	push   $0x0
  pushl $240
  1029a5:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029aa:	e9 b4 00 00 00       	jmp    102a63 <__alltraps>

001029af <vector241>:
.globl vector241
vector241:
  pushl $0
  1029af:	6a 00                	push   $0x0
  pushl $241
  1029b1:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029b6:	e9 a8 00 00 00       	jmp    102a63 <__alltraps>

001029bb <vector242>:
.globl vector242
vector242:
  pushl $0
  1029bb:	6a 00                	push   $0x0
  pushl $242
  1029bd:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029c2:	e9 9c 00 00 00       	jmp    102a63 <__alltraps>

001029c7 <vector243>:
.globl vector243
vector243:
  pushl $0
  1029c7:	6a 00                	push   $0x0
  pushl $243
  1029c9:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029ce:	e9 90 00 00 00       	jmp    102a63 <__alltraps>

001029d3 <vector244>:
.globl vector244
vector244:
  pushl $0
  1029d3:	6a 00                	push   $0x0
  pushl $244
  1029d5:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029da:	e9 84 00 00 00       	jmp    102a63 <__alltraps>

001029df <vector245>:
.globl vector245
vector245:
  pushl $0
  1029df:	6a 00                	push   $0x0
  pushl $245
  1029e1:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029e6:	e9 78 00 00 00       	jmp    102a63 <__alltraps>

001029eb <vector246>:
.globl vector246
vector246:
  pushl $0
  1029eb:	6a 00                	push   $0x0
  pushl $246
  1029ed:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029f2:	e9 6c 00 00 00       	jmp    102a63 <__alltraps>

001029f7 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029f7:	6a 00                	push   $0x0
  pushl $247
  1029f9:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029fe:	e9 60 00 00 00       	jmp    102a63 <__alltraps>

00102a03 <vector248>:
.globl vector248
vector248:
  pushl $0
  102a03:	6a 00                	push   $0x0
  pushl $248
  102a05:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a0a:	e9 54 00 00 00       	jmp    102a63 <__alltraps>

00102a0f <vector249>:
.globl vector249
vector249:
  pushl $0
  102a0f:	6a 00                	push   $0x0
  pushl $249
  102a11:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a16:	e9 48 00 00 00       	jmp    102a63 <__alltraps>

00102a1b <vector250>:
.globl vector250
vector250:
  pushl $0
  102a1b:	6a 00                	push   $0x0
  pushl $250
  102a1d:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a22:	e9 3c 00 00 00       	jmp    102a63 <__alltraps>

00102a27 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a27:	6a 00                	push   $0x0
  pushl $251
  102a29:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a2e:	e9 30 00 00 00       	jmp    102a63 <__alltraps>

00102a33 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a33:	6a 00                	push   $0x0
  pushl $252
  102a35:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a3a:	e9 24 00 00 00       	jmp    102a63 <__alltraps>

00102a3f <vector253>:
.globl vector253
vector253:
  pushl $0
  102a3f:	6a 00                	push   $0x0
  pushl $253
  102a41:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a46:	e9 18 00 00 00       	jmp    102a63 <__alltraps>

00102a4b <vector254>:
.globl vector254
vector254:
  pushl $0
  102a4b:	6a 00                	push   $0x0
  pushl $254
  102a4d:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a52:	e9 0c 00 00 00       	jmp    102a63 <__alltraps>

00102a57 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a57:	6a 00                	push   $0x0
  pushl $255
  102a59:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a5e:	e9 00 00 00 00       	jmp    102a63 <__alltraps>

00102a63 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a63:	1e                   	push   %ds
    pushl %es
  102a64:	06                   	push   %es
    pushl %fs
  102a65:	0f a0                	push   %fs
    pushl %gs
  102a67:	0f a8                	push   %gs
    pushal
  102a69:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a6a:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a6f:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a71:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a73:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a74:	e8 61 f5 ff ff       	call   101fda <trap>

    # pop the pushed stack pointer
    popl %esp
  102a79:	5c                   	pop    %esp

00102a7a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a7a:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a7b:	0f a9                	pop    %gs
    popl %fs
  102a7d:	0f a1                	pop    %fs
    popl %es
  102a7f:	07                   	pop    %es
    popl %ds
  102a80:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a81:	83 c4 08             	add    $0x8,%esp
    iret
  102a84:	cf                   	iret   

00102a85 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a85:	55                   	push   %ebp
  102a86:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a88:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a8e:	b8 23 00 00 00       	mov    $0x23,%eax
  102a93:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a95:	b8 23 00 00 00       	mov    $0x23,%eax
  102a9a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a9c:	b8 10 00 00 00       	mov    $0x10,%eax
  102aa1:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102aa3:	b8 10 00 00 00       	mov    $0x10,%eax
  102aa8:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102aaa:	b8 10 00 00 00       	mov    $0x10,%eax
  102aaf:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ab1:	ea b8 2a 10 00 08 00 	ljmp   $0x8,$0x102ab8
}
  102ab8:	90                   	nop
  102ab9:	5d                   	pop    %ebp
  102aba:	c3                   	ret    

00102abb <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102abb:	55                   	push   %ebp
  102abc:	89 e5                	mov    %esp,%ebp
  102abe:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102ac1:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102ac6:	05 00 04 00 00       	add    $0x400,%eax
  102acb:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102ad0:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102ad7:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102ad9:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102ae0:	68 00 
  102ae2:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102ae7:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102aed:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102af2:	c1 e8 10             	shr    $0x10,%eax
  102af5:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102afa:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b01:	83 e0 f0             	and    $0xfffffff0,%eax
  102b04:	83 c8 09             	or     $0x9,%eax
  102b07:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102b0c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b13:	83 c8 10             	or     $0x10,%eax
  102b16:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102b1b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b22:	83 e0 9f             	and    $0xffffff9f,%eax
  102b25:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102b2a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b31:	83 c8 80             	or     $0xffffff80,%eax
  102b34:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102b39:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b40:	83 e0 f0             	and    $0xfffffff0,%eax
  102b43:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b48:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b4f:	83 e0 ef             	and    $0xffffffef,%eax
  102b52:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b57:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b5e:	83 e0 df             	and    $0xffffffdf,%eax
  102b61:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b66:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b6d:	83 c8 40             	or     $0x40,%eax
  102b70:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b75:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102b7c:	83 e0 7f             	and    $0x7f,%eax
  102b7f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102b84:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102b89:	c1 e8 18             	shr    $0x18,%eax
  102b8c:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102b91:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102b98:	83 e0 ef             	and    $0xffffffef,%eax
  102b9b:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102ba0:	68 10 ea 10 00       	push   $0x10ea10
  102ba5:	e8 db fe ff ff       	call   102a85 <lgdt>
  102baa:	83 c4 04             	add    $0x4,%esp
  102bad:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102bb3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102bb7:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102bba:	90                   	nop
  102bbb:	c9                   	leave  
  102bbc:	c3                   	ret    

00102bbd <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102bbd:	55                   	push   %ebp
  102bbe:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102bc0:	e8 f6 fe ff ff       	call   102abb <gdt_init>
}
  102bc5:	90                   	nop
  102bc6:	5d                   	pop    %ebp
  102bc7:	c3                   	ret    

00102bc8 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102bc8:	55                   	push   %ebp
  102bc9:	89 e5                	mov    %esp,%ebp
  102bcb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102bce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102bd5:	eb 04                	jmp    102bdb <strlen+0x13>
        cnt ++;
  102bd7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bde:	8d 50 01             	lea    0x1(%eax),%edx
  102be1:	89 55 08             	mov    %edx,0x8(%ebp)
  102be4:	0f b6 00             	movzbl (%eax),%eax
  102be7:	84 c0                	test   %al,%al
  102be9:	75 ec                	jne    102bd7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102bee:	c9                   	leave  
  102bef:	c3                   	ret    

00102bf0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102bf0:	55                   	push   %ebp
  102bf1:	89 e5                	mov    %esp,%ebp
  102bf3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102bf6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102bfd:	eb 04                	jmp    102c03 <strnlen+0x13>
        cnt ++;
  102bff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102c03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c06:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c09:	73 10                	jae    102c1b <strnlen+0x2b>
  102c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0e:	8d 50 01             	lea    0x1(%eax),%edx
  102c11:	89 55 08             	mov    %edx,0x8(%ebp)
  102c14:	0f b6 00             	movzbl (%eax),%eax
  102c17:	84 c0                	test   %al,%al
  102c19:	75 e4                	jne    102bff <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c1e:	c9                   	leave  
  102c1f:	c3                   	ret    

00102c20 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c20:	55                   	push   %ebp
  102c21:	89 e5                	mov    %esp,%ebp
  102c23:	57                   	push   %edi
  102c24:	56                   	push   %esi
  102c25:	83 ec 20             	sub    $0x20,%esp
  102c28:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3a:	89 d1                	mov    %edx,%ecx
  102c3c:	89 c2                	mov    %eax,%edx
  102c3e:	89 ce                	mov    %ecx,%esi
  102c40:	89 d7                	mov    %edx,%edi
  102c42:	ac                   	lods   %ds:(%esi),%al
  102c43:	aa                   	stos   %al,%es:(%edi)
  102c44:	84 c0                	test   %al,%al
  102c46:	75 fa                	jne    102c42 <strcpy+0x22>
  102c48:	89 fa                	mov    %edi,%edx
  102c4a:	89 f1                	mov    %esi,%ecx
  102c4c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c4f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102c58:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102c59:	83 c4 20             	add    $0x20,%esp
  102c5c:	5e                   	pop    %esi
  102c5d:	5f                   	pop    %edi
  102c5e:	5d                   	pop    %ebp
  102c5f:	c3                   	ret    

00102c60 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102c60:	55                   	push   %ebp
  102c61:	89 e5                	mov    %esp,%ebp
  102c63:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102c66:	8b 45 08             	mov    0x8(%ebp),%eax
  102c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102c6c:	eb 21                	jmp    102c8f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c71:	0f b6 10             	movzbl (%eax),%edx
  102c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c77:	88 10                	mov    %dl,(%eax)
  102c79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c7c:	0f b6 00             	movzbl (%eax),%eax
  102c7f:	84 c0                	test   %al,%al
  102c81:	74 04                	je     102c87 <strncpy+0x27>
            src ++;
  102c83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102c87:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102c8b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102c8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c93:	75 d9                	jne    102c6e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102c95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c98:	c9                   	leave  
  102c99:	c3                   	ret    

00102c9a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102c9a:	55                   	push   %ebp
  102c9b:	89 e5                	mov    %esp,%ebp
  102c9d:	57                   	push   %edi
  102c9e:	56                   	push   %esi
  102c9f:	83 ec 20             	sub    $0x20,%esp
  102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb4:	89 d1                	mov    %edx,%ecx
  102cb6:	89 c2                	mov    %eax,%edx
  102cb8:	89 ce                	mov    %ecx,%esi
  102cba:	89 d7                	mov    %edx,%edi
  102cbc:	ac                   	lods   %ds:(%esi),%al
  102cbd:	ae                   	scas   %es:(%edi),%al
  102cbe:	75 08                	jne    102cc8 <strcmp+0x2e>
  102cc0:	84 c0                	test   %al,%al
  102cc2:	75 f8                	jne    102cbc <strcmp+0x22>
  102cc4:	31 c0                	xor    %eax,%eax
  102cc6:	eb 04                	jmp    102ccc <strcmp+0x32>
  102cc8:	19 c0                	sbb    %eax,%eax
  102cca:	0c 01                	or     $0x1,%al
  102ccc:	89 fa                	mov    %edi,%edx
  102cce:	89 f1                	mov    %esi,%ecx
  102cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102cd3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102cd6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102cdc:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102cdd:	83 c4 20             	add    $0x20,%esp
  102ce0:	5e                   	pop    %esi
  102ce1:	5f                   	pop    %edi
  102ce2:	5d                   	pop    %ebp
  102ce3:	c3                   	ret    

00102ce4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102ce4:	55                   	push   %ebp
  102ce5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102ce7:	eb 0c                	jmp    102cf5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102ce9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ced:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cf1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cf9:	74 1a                	je     102d15 <strncmp+0x31>
  102cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfe:	0f b6 00             	movzbl (%eax),%eax
  102d01:	84 c0                	test   %al,%al
  102d03:	74 10                	je     102d15 <strncmp+0x31>
  102d05:	8b 45 08             	mov    0x8(%ebp),%eax
  102d08:	0f b6 10             	movzbl (%eax),%edx
  102d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0e:	0f b6 00             	movzbl (%eax),%eax
  102d11:	38 c2                	cmp    %al,%dl
  102d13:	74 d4                	je     102ce9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d19:	74 18                	je     102d33 <strncmp+0x4f>
  102d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1e:	0f b6 00             	movzbl (%eax),%eax
  102d21:	0f b6 d0             	movzbl %al,%edx
  102d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d27:	0f b6 00             	movzbl (%eax),%eax
  102d2a:	0f b6 c0             	movzbl %al,%eax
  102d2d:	29 c2                	sub    %eax,%edx
  102d2f:	89 d0                	mov    %edx,%eax
  102d31:	eb 05                	jmp    102d38 <strncmp+0x54>
  102d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d38:	5d                   	pop    %ebp
  102d39:	c3                   	ret    

00102d3a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d3a:	55                   	push   %ebp
  102d3b:	89 e5                	mov    %esp,%ebp
  102d3d:	83 ec 04             	sub    $0x4,%esp
  102d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d43:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d46:	eb 14                	jmp    102d5c <strchr+0x22>
        if (*s == c) {
  102d48:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4b:	0f b6 00             	movzbl (%eax),%eax
  102d4e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102d51:	75 05                	jne    102d58 <strchr+0x1e>
            return (char *)s;
  102d53:	8b 45 08             	mov    0x8(%ebp),%eax
  102d56:	eb 13                	jmp    102d6b <strchr+0x31>
        }
        s ++;
  102d58:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5f:	0f b6 00             	movzbl (%eax),%eax
  102d62:	84 c0                	test   %al,%al
  102d64:	75 e2                	jne    102d48 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d6b:	c9                   	leave  
  102d6c:	c3                   	ret    

00102d6d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102d6d:	55                   	push   %ebp
  102d6e:	89 e5                	mov    %esp,%ebp
  102d70:	83 ec 04             	sub    $0x4,%esp
  102d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d76:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d79:	eb 0f                	jmp    102d8a <strfind+0x1d>
        if (*s == c) {
  102d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7e:	0f b6 00             	movzbl (%eax),%eax
  102d81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102d84:	74 10                	je     102d96 <strfind+0x29>
            break;
        }
        s ++;
  102d86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8d:	0f b6 00             	movzbl (%eax),%eax
  102d90:	84 c0                	test   %al,%al
  102d92:	75 e7                	jne    102d7b <strfind+0xe>
  102d94:	eb 01                	jmp    102d97 <strfind+0x2a>
        if (*s == c) {
            break;
  102d96:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102d97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d9a:	c9                   	leave  
  102d9b:	c3                   	ret    

00102d9c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102d9c:	55                   	push   %ebp
  102d9d:	89 e5                	mov    %esp,%ebp
  102d9f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102da2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102da9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102db0:	eb 04                	jmp    102db6 <strtol+0x1a>
        s ++;
  102db2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102db6:	8b 45 08             	mov    0x8(%ebp),%eax
  102db9:	0f b6 00             	movzbl (%eax),%eax
  102dbc:	3c 20                	cmp    $0x20,%al
  102dbe:	74 f2                	je     102db2 <strtol+0x16>
  102dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc3:	0f b6 00             	movzbl (%eax),%eax
  102dc6:	3c 09                	cmp    $0x9,%al
  102dc8:	74 e8                	je     102db2 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102dca:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcd:	0f b6 00             	movzbl (%eax),%eax
  102dd0:	3c 2b                	cmp    $0x2b,%al
  102dd2:	75 06                	jne    102dda <strtol+0x3e>
        s ++;
  102dd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102dd8:	eb 15                	jmp    102def <strtol+0x53>
    }
    else if (*s == '-') {
  102dda:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddd:	0f b6 00             	movzbl (%eax),%eax
  102de0:	3c 2d                	cmp    $0x2d,%al
  102de2:	75 0b                	jne    102def <strtol+0x53>
        s ++, neg = 1;
  102de4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102de8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102def:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102df3:	74 06                	je     102dfb <strtol+0x5f>
  102df5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102df9:	75 24                	jne    102e1f <strtol+0x83>
  102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfe:	0f b6 00             	movzbl (%eax),%eax
  102e01:	3c 30                	cmp    $0x30,%al
  102e03:	75 1a                	jne    102e1f <strtol+0x83>
  102e05:	8b 45 08             	mov    0x8(%ebp),%eax
  102e08:	83 c0 01             	add    $0x1,%eax
  102e0b:	0f b6 00             	movzbl (%eax),%eax
  102e0e:	3c 78                	cmp    $0x78,%al
  102e10:	75 0d                	jne    102e1f <strtol+0x83>
        s += 2, base = 16;
  102e12:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e16:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e1d:	eb 2a                	jmp    102e49 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102e1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e23:	75 17                	jne    102e3c <strtol+0xa0>
  102e25:	8b 45 08             	mov    0x8(%ebp),%eax
  102e28:	0f b6 00             	movzbl (%eax),%eax
  102e2b:	3c 30                	cmp    $0x30,%al
  102e2d:	75 0d                	jne    102e3c <strtol+0xa0>
        s ++, base = 8;
  102e2f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e33:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e3a:	eb 0d                	jmp    102e49 <strtol+0xad>
    }
    else if (base == 0) {
  102e3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e40:	75 07                	jne    102e49 <strtol+0xad>
        base = 10;
  102e42:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102e49:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4c:	0f b6 00             	movzbl (%eax),%eax
  102e4f:	3c 2f                	cmp    $0x2f,%al
  102e51:	7e 1b                	jle    102e6e <strtol+0xd2>
  102e53:	8b 45 08             	mov    0x8(%ebp),%eax
  102e56:	0f b6 00             	movzbl (%eax),%eax
  102e59:	3c 39                	cmp    $0x39,%al
  102e5b:	7f 11                	jg     102e6e <strtol+0xd2>
            dig = *s - '0';
  102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e60:	0f b6 00             	movzbl (%eax),%eax
  102e63:	0f be c0             	movsbl %al,%eax
  102e66:	83 e8 30             	sub    $0x30,%eax
  102e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e6c:	eb 48                	jmp    102eb6 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e71:	0f b6 00             	movzbl (%eax),%eax
  102e74:	3c 60                	cmp    $0x60,%al
  102e76:	7e 1b                	jle    102e93 <strtol+0xf7>
  102e78:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7b:	0f b6 00             	movzbl (%eax),%eax
  102e7e:	3c 7a                	cmp    $0x7a,%al
  102e80:	7f 11                	jg     102e93 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102e82:	8b 45 08             	mov    0x8(%ebp),%eax
  102e85:	0f b6 00             	movzbl (%eax),%eax
  102e88:	0f be c0             	movsbl %al,%eax
  102e8b:	83 e8 57             	sub    $0x57,%eax
  102e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e91:	eb 23                	jmp    102eb6 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102e93:	8b 45 08             	mov    0x8(%ebp),%eax
  102e96:	0f b6 00             	movzbl (%eax),%eax
  102e99:	3c 40                	cmp    $0x40,%al
  102e9b:	7e 3c                	jle    102ed9 <strtol+0x13d>
  102e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea0:	0f b6 00             	movzbl (%eax),%eax
  102ea3:	3c 5a                	cmp    $0x5a,%al
  102ea5:	7f 32                	jg     102ed9 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eaa:	0f b6 00             	movzbl (%eax),%eax
  102ead:	0f be c0             	movsbl %al,%eax
  102eb0:	83 e8 37             	sub    $0x37,%eax
  102eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eb9:	3b 45 10             	cmp    0x10(%ebp),%eax
  102ebc:	7d 1a                	jge    102ed8 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102ebe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ec5:	0f af 45 10          	imul   0x10(%ebp),%eax
  102ec9:	89 c2                	mov    %eax,%edx
  102ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ece:	01 d0                	add    %edx,%eax
  102ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102ed3:	e9 71 ff ff ff       	jmp    102e49 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102ed8:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102ed9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102edd:	74 08                	je     102ee7 <strtol+0x14b>
        *endptr = (char *) s;
  102edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  102ee5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102ee7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102eeb:	74 07                	je     102ef4 <strtol+0x158>
  102eed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ef0:	f7 d8                	neg    %eax
  102ef2:	eb 03                	jmp    102ef7 <strtol+0x15b>
  102ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102ef7:	c9                   	leave  
  102ef8:	c3                   	ret    

00102ef9 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102ef9:	55                   	push   %ebp
  102efa:	89 e5                	mov    %esp,%ebp
  102efc:	57                   	push   %edi
  102efd:	83 ec 24             	sub    $0x24,%esp
  102f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f03:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f06:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  102f0d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102f10:	88 45 f7             	mov    %al,-0x9(%ebp)
  102f13:	8b 45 10             	mov    0x10(%ebp),%eax
  102f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f19:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f1c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f20:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f23:	89 d7                	mov    %edx,%edi
  102f25:	f3 aa                	rep stos %al,%es:(%edi)
  102f27:	89 fa                	mov    %edi,%edx
  102f29:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f2c:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f32:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f33:	83 c4 24             	add    $0x24,%esp
  102f36:	5f                   	pop    %edi
  102f37:	5d                   	pop    %ebp
  102f38:	c3                   	ret    

00102f39 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f39:	55                   	push   %ebp
  102f3a:	89 e5                	mov    %esp,%ebp
  102f3c:	57                   	push   %edi
  102f3d:	56                   	push   %esi
  102f3e:	53                   	push   %ebx
  102f3f:	83 ec 30             	sub    $0x30,%esp
  102f42:	8b 45 08             	mov    0x8(%ebp),%eax
  102f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f51:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f57:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102f5a:	73 42                	jae    102f9e <memmove+0x65>
  102f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f65:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f71:	c1 e8 02             	shr    $0x2,%eax
  102f74:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102f76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f7c:	89 d7                	mov    %edx,%edi
  102f7e:	89 c6                	mov    %eax,%esi
  102f80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102f82:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102f85:	83 e1 03             	and    $0x3,%ecx
  102f88:	74 02                	je     102f8c <memmove+0x53>
  102f8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f8c:	89 f0                	mov    %esi,%eax
  102f8e:	89 fa                	mov    %edi,%edx
  102f90:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102f93:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f96:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102f9c:	eb 36                	jmp    102fd4 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fa1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fa7:	01 c2                	add    %eax,%edx
  102fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fac:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fb8:	89 c1                	mov    %eax,%ecx
  102fba:	89 d8                	mov    %ebx,%eax
  102fbc:	89 d6                	mov    %edx,%esi
  102fbe:	89 c7                	mov    %eax,%edi
  102fc0:	fd                   	std    
  102fc1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fc3:	fc                   	cld    
  102fc4:	89 f8                	mov    %edi,%eax
  102fc6:	89 f2                	mov    %esi,%edx
  102fc8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102fcb:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102fce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102fd4:	83 c4 30             	add    $0x30,%esp
  102fd7:	5b                   	pop    %ebx
  102fd8:	5e                   	pop    %esi
  102fd9:	5f                   	pop    %edi
  102fda:	5d                   	pop    %ebp
  102fdb:	c3                   	ret    

00102fdc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102fdc:	55                   	push   %ebp
  102fdd:	89 e5                	mov    %esp,%ebp
  102fdf:	57                   	push   %edi
  102fe0:	56                   	push   %esi
  102fe1:	83 ec 20             	sub    $0x20,%esp
  102fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ff3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff9:	c1 e8 02             	shr    $0x2,%eax
  102ffc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103004:	89 d7                	mov    %edx,%edi
  103006:	89 c6                	mov    %eax,%esi
  103008:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10300a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10300d:	83 e1 03             	and    $0x3,%ecx
  103010:	74 02                	je     103014 <memcpy+0x38>
  103012:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103014:	89 f0                	mov    %esi,%eax
  103016:	89 fa                	mov    %edi,%edx
  103018:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10301b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10301e:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103021:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  103024:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103025:	83 c4 20             	add    $0x20,%esp
  103028:	5e                   	pop    %esi
  103029:	5f                   	pop    %edi
  10302a:	5d                   	pop    %ebp
  10302b:	c3                   	ret    

0010302c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10302c:	55                   	push   %ebp
  10302d:	89 e5                	mov    %esp,%ebp
  10302f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103032:	8b 45 08             	mov    0x8(%ebp),%eax
  103035:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103038:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10303e:	eb 30                	jmp    103070 <memcmp+0x44>
        if (*s1 != *s2) {
  103040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103043:	0f b6 10             	movzbl (%eax),%edx
  103046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103049:	0f b6 00             	movzbl (%eax),%eax
  10304c:	38 c2                	cmp    %al,%dl
  10304e:	74 18                	je     103068 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103050:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103053:	0f b6 00             	movzbl (%eax),%eax
  103056:	0f b6 d0             	movzbl %al,%edx
  103059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10305c:	0f b6 00             	movzbl (%eax),%eax
  10305f:	0f b6 c0             	movzbl %al,%eax
  103062:	29 c2                	sub    %eax,%edx
  103064:	89 d0                	mov    %edx,%eax
  103066:	eb 1a                	jmp    103082 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103068:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10306c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103070:	8b 45 10             	mov    0x10(%ebp),%eax
  103073:	8d 50 ff             	lea    -0x1(%eax),%edx
  103076:	89 55 10             	mov    %edx,0x10(%ebp)
  103079:	85 c0                	test   %eax,%eax
  10307b:	75 c3                	jne    103040 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10307d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103082:	c9                   	leave  
  103083:	c3                   	ret    

00103084 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103084:	55                   	push   %ebp
  103085:	89 e5                	mov    %esp,%ebp
  103087:	83 ec 38             	sub    $0x38,%esp
  10308a:	8b 45 10             	mov    0x10(%ebp),%eax
  10308d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103090:	8b 45 14             	mov    0x14(%ebp),%eax
  103093:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103096:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103099:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10309c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10309f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1030a2:	8b 45 18             	mov    0x18(%ebp),%eax
  1030a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030b1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030be:	74 1c                	je     1030dc <printnum+0x58>
  1030c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030c3:	ba 00 00 00 00       	mov    $0x0,%edx
  1030c8:	f7 75 e4             	divl   -0x1c(%ebp)
  1030cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1030ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1030d6:	f7 75 e4             	divl   -0x1c(%ebp)
  1030d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030e2:	f7 75 e4             	divl   -0x1c(%ebp)
  1030e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1030eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1030f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030f4:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1030f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030fa:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1030fd:	8b 45 18             	mov    0x18(%ebp),%eax
  103100:	ba 00 00 00 00       	mov    $0x0,%edx
  103105:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103108:	77 41                	ja     10314b <printnum+0xc7>
  10310a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10310d:	72 05                	jb     103114 <printnum+0x90>
  10310f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103112:	77 37                	ja     10314b <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  103114:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103117:	83 e8 01             	sub    $0x1,%eax
  10311a:	83 ec 04             	sub    $0x4,%esp
  10311d:	ff 75 20             	pushl  0x20(%ebp)
  103120:	50                   	push   %eax
  103121:	ff 75 18             	pushl  0x18(%ebp)
  103124:	ff 75 ec             	pushl  -0x14(%ebp)
  103127:	ff 75 e8             	pushl  -0x18(%ebp)
  10312a:	ff 75 0c             	pushl  0xc(%ebp)
  10312d:	ff 75 08             	pushl  0x8(%ebp)
  103130:	e8 4f ff ff ff       	call   103084 <printnum>
  103135:	83 c4 20             	add    $0x20,%esp
  103138:	eb 1b                	jmp    103155 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10313a:	83 ec 08             	sub    $0x8,%esp
  10313d:	ff 75 0c             	pushl  0xc(%ebp)
  103140:	ff 75 20             	pushl  0x20(%ebp)
  103143:	8b 45 08             	mov    0x8(%ebp),%eax
  103146:	ff d0                	call   *%eax
  103148:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10314b:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10314f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103153:	7f e5                	jg     10313a <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103155:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103158:	05 b0 3e 10 00       	add    $0x103eb0,%eax
  10315d:	0f b6 00             	movzbl (%eax),%eax
  103160:	0f be c0             	movsbl %al,%eax
  103163:	83 ec 08             	sub    $0x8,%esp
  103166:	ff 75 0c             	pushl  0xc(%ebp)
  103169:	50                   	push   %eax
  10316a:	8b 45 08             	mov    0x8(%ebp),%eax
  10316d:	ff d0                	call   *%eax
  10316f:	83 c4 10             	add    $0x10,%esp
}
  103172:	90                   	nop
  103173:	c9                   	leave  
  103174:	c3                   	ret    

00103175 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103175:	55                   	push   %ebp
  103176:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103178:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10317c:	7e 14                	jle    103192 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10317e:	8b 45 08             	mov    0x8(%ebp),%eax
  103181:	8b 00                	mov    (%eax),%eax
  103183:	8d 48 08             	lea    0x8(%eax),%ecx
  103186:	8b 55 08             	mov    0x8(%ebp),%edx
  103189:	89 0a                	mov    %ecx,(%edx)
  10318b:	8b 50 04             	mov    0x4(%eax),%edx
  10318e:	8b 00                	mov    (%eax),%eax
  103190:	eb 30                	jmp    1031c2 <getuint+0x4d>
    }
    else if (lflag) {
  103192:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103196:	74 16                	je     1031ae <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103198:	8b 45 08             	mov    0x8(%ebp),%eax
  10319b:	8b 00                	mov    (%eax),%eax
  10319d:	8d 48 04             	lea    0x4(%eax),%ecx
  1031a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1031a3:	89 0a                	mov    %ecx,(%edx)
  1031a5:	8b 00                	mov    (%eax),%eax
  1031a7:	ba 00 00 00 00       	mov    $0x0,%edx
  1031ac:	eb 14                	jmp    1031c2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b1:	8b 00                	mov    (%eax),%eax
  1031b3:	8d 48 04             	lea    0x4(%eax),%ecx
  1031b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1031b9:	89 0a                	mov    %ecx,(%edx)
  1031bb:	8b 00                	mov    (%eax),%eax
  1031bd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1031c2:	5d                   	pop    %ebp
  1031c3:	c3                   	ret    

001031c4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1031c4:	55                   	push   %ebp
  1031c5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031cb:	7e 14                	jle    1031e1 <getint+0x1d>
        return va_arg(*ap, long long);
  1031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d0:	8b 00                	mov    (%eax),%eax
  1031d2:	8d 48 08             	lea    0x8(%eax),%ecx
  1031d5:	8b 55 08             	mov    0x8(%ebp),%edx
  1031d8:	89 0a                	mov    %ecx,(%edx)
  1031da:	8b 50 04             	mov    0x4(%eax),%edx
  1031dd:	8b 00                	mov    (%eax),%eax
  1031df:	eb 28                	jmp    103209 <getint+0x45>
    }
    else if (lflag) {
  1031e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031e5:	74 12                	je     1031f9 <getint+0x35>
        return va_arg(*ap, long);
  1031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ea:	8b 00                	mov    (%eax),%eax
  1031ec:	8d 48 04             	lea    0x4(%eax),%ecx
  1031ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1031f2:	89 0a                	mov    %ecx,(%edx)
  1031f4:	8b 00                	mov    (%eax),%eax
  1031f6:	99                   	cltd   
  1031f7:	eb 10                	jmp    103209 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fc:	8b 00                	mov    (%eax),%eax
  1031fe:	8d 48 04             	lea    0x4(%eax),%ecx
  103201:	8b 55 08             	mov    0x8(%ebp),%edx
  103204:	89 0a                	mov    %ecx,(%edx)
  103206:	8b 00                	mov    (%eax),%eax
  103208:	99                   	cltd   
    }
}
  103209:	5d                   	pop    %ebp
  10320a:	c3                   	ret    

0010320b <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10320b:	55                   	push   %ebp
  10320c:	89 e5                	mov    %esp,%ebp
  10320e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  103211:	8d 45 14             	lea    0x14(%ebp),%eax
  103214:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10321a:	50                   	push   %eax
  10321b:	ff 75 10             	pushl  0x10(%ebp)
  10321e:	ff 75 0c             	pushl  0xc(%ebp)
  103221:	ff 75 08             	pushl  0x8(%ebp)
  103224:	e8 06 00 00 00       	call   10322f <vprintfmt>
  103229:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10322c:	90                   	nop
  10322d:	c9                   	leave  
  10322e:	c3                   	ret    

0010322f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10322f:	55                   	push   %ebp
  103230:	89 e5                	mov    %esp,%ebp
  103232:	56                   	push   %esi
  103233:	53                   	push   %ebx
  103234:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103237:	eb 17                	jmp    103250 <vprintfmt+0x21>
            if (ch == '\0') {
  103239:	85 db                	test   %ebx,%ebx
  10323b:	0f 84 8e 03 00 00    	je     1035cf <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  103241:	83 ec 08             	sub    $0x8,%esp
  103244:	ff 75 0c             	pushl  0xc(%ebp)
  103247:	53                   	push   %ebx
  103248:	8b 45 08             	mov    0x8(%ebp),%eax
  10324b:	ff d0                	call   *%eax
  10324d:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103250:	8b 45 10             	mov    0x10(%ebp),%eax
  103253:	8d 50 01             	lea    0x1(%eax),%edx
  103256:	89 55 10             	mov    %edx,0x10(%ebp)
  103259:	0f b6 00             	movzbl (%eax),%eax
  10325c:	0f b6 d8             	movzbl %al,%ebx
  10325f:	83 fb 25             	cmp    $0x25,%ebx
  103262:	75 d5                	jne    103239 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  103264:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103268:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103272:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103275:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10327c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10327f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103282:	8b 45 10             	mov    0x10(%ebp),%eax
  103285:	8d 50 01             	lea    0x1(%eax),%edx
  103288:	89 55 10             	mov    %edx,0x10(%ebp)
  10328b:	0f b6 00             	movzbl (%eax),%eax
  10328e:	0f b6 d8             	movzbl %al,%ebx
  103291:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103294:	83 f8 55             	cmp    $0x55,%eax
  103297:	0f 87 05 03 00 00    	ja     1035a2 <vprintfmt+0x373>
  10329d:	8b 04 85 d4 3e 10 00 	mov    0x103ed4(,%eax,4),%eax
  1032a4:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1032a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1032aa:	eb d6                	jmp    103282 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1032ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1032b0:	eb d0                	jmp    103282 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1032b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1032b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032bc:	89 d0                	mov    %edx,%eax
  1032be:	c1 e0 02             	shl    $0x2,%eax
  1032c1:	01 d0                	add    %edx,%eax
  1032c3:	01 c0                	add    %eax,%eax
  1032c5:	01 d8                	add    %ebx,%eax
  1032c7:	83 e8 30             	sub    $0x30,%eax
  1032ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1032cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1032d0:	0f b6 00             	movzbl (%eax),%eax
  1032d3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1032d6:	83 fb 2f             	cmp    $0x2f,%ebx
  1032d9:	7e 39                	jle    103314 <vprintfmt+0xe5>
  1032db:	83 fb 39             	cmp    $0x39,%ebx
  1032de:	7f 34                	jg     103314 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1032e0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1032e4:	eb d3                	jmp    1032b9 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1032e6:	8b 45 14             	mov    0x14(%ebp),%eax
  1032e9:	8d 50 04             	lea    0x4(%eax),%edx
  1032ec:	89 55 14             	mov    %edx,0x14(%ebp)
  1032ef:	8b 00                	mov    (%eax),%eax
  1032f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1032f4:	eb 1f                	jmp    103315 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1032f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032fa:	79 86                	jns    103282 <vprintfmt+0x53>
                width = 0;
  1032fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103303:	e9 7a ff ff ff       	jmp    103282 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103308:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10330f:	e9 6e ff ff ff       	jmp    103282 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  103314:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103315:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103319:	0f 89 63 ff ff ff    	jns    103282 <vprintfmt+0x53>
                width = precision, precision = -1;
  10331f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103322:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103325:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10332c:	e9 51 ff ff ff       	jmp    103282 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103331:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103335:	e9 48 ff ff ff       	jmp    103282 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10333a:	8b 45 14             	mov    0x14(%ebp),%eax
  10333d:	8d 50 04             	lea    0x4(%eax),%edx
  103340:	89 55 14             	mov    %edx,0x14(%ebp)
  103343:	8b 00                	mov    (%eax),%eax
  103345:	83 ec 08             	sub    $0x8,%esp
  103348:	ff 75 0c             	pushl  0xc(%ebp)
  10334b:	50                   	push   %eax
  10334c:	8b 45 08             	mov    0x8(%ebp),%eax
  10334f:	ff d0                	call   *%eax
  103351:	83 c4 10             	add    $0x10,%esp
            break;
  103354:	e9 71 02 00 00       	jmp    1035ca <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103359:	8b 45 14             	mov    0x14(%ebp),%eax
  10335c:	8d 50 04             	lea    0x4(%eax),%edx
  10335f:	89 55 14             	mov    %edx,0x14(%ebp)
  103362:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103364:	85 db                	test   %ebx,%ebx
  103366:	79 02                	jns    10336a <vprintfmt+0x13b>
                err = -err;
  103368:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10336a:	83 fb 06             	cmp    $0x6,%ebx
  10336d:	7f 0b                	jg     10337a <vprintfmt+0x14b>
  10336f:	8b 34 9d 94 3e 10 00 	mov    0x103e94(,%ebx,4),%esi
  103376:	85 f6                	test   %esi,%esi
  103378:	75 19                	jne    103393 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  10337a:	53                   	push   %ebx
  10337b:	68 c1 3e 10 00       	push   $0x103ec1
  103380:	ff 75 0c             	pushl  0xc(%ebp)
  103383:	ff 75 08             	pushl  0x8(%ebp)
  103386:	e8 80 fe ff ff       	call   10320b <printfmt>
  10338b:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10338e:	e9 37 02 00 00       	jmp    1035ca <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  103393:	56                   	push   %esi
  103394:	68 ca 3e 10 00       	push   $0x103eca
  103399:	ff 75 0c             	pushl  0xc(%ebp)
  10339c:	ff 75 08             	pushl  0x8(%ebp)
  10339f:	e8 67 fe ff ff       	call   10320b <printfmt>
  1033a4:	83 c4 10             	add    $0x10,%esp
            }
            break;
  1033a7:	e9 1e 02 00 00       	jmp    1035ca <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1033ac:	8b 45 14             	mov    0x14(%ebp),%eax
  1033af:	8d 50 04             	lea    0x4(%eax),%edx
  1033b2:	89 55 14             	mov    %edx,0x14(%ebp)
  1033b5:	8b 30                	mov    (%eax),%esi
  1033b7:	85 f6                	test   %esi,%esi
  1033b9:	75 05                	jne    1033c0 <vprintfmt+0x191>
                p = "(null)";
  1033bb:	be cd 3e 10 00       	mov    $0x103ecd,%esi
            }
            if (width > 0 && padc != '-') {
  1033c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033c4:	7e 76                	jle    10343c <vprintfmt+0x20d>
  1033c6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1033ca:	74 70                	je     10343c <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1033cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033cf:	83 ec 08             	sub    $0x8,%esp
  1033d2:	50                   	push   %eax
  1033d3:	56                   	push   %esi
  1033d4:	e8 17 f8 ff ff       	call   102bf0 <strnlen>
  1033d9:	83 c4 10             	add    $0x10,%esp
  1033dc:	89 c2                	mov    %eax,%edx
  1033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e1:	29 d0                	sub    %edx,%eax
  1033e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033e6:	eb 17                	jmp    1033ff <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1033e8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1033ec:	83 ec 08             	sub    $0x8,%esp
  1033ef:	ff 75 0c             	pushl  0xc(%ebp)
  1033f2:	50                   	push   %eax
  1033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f6:	ff d0                	call   *%eax
  1033f8:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1033fb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1033ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103403:	7f e3                	jg     1033e8 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103405:	eb 35                	jmp    10343c <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  103407:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10340b:	74 1c                	je     103429 <vprintfmt+0x1fa>
  10340d:	83 fb 1f             	cmp    $0x1f,%ebx
  103410:	7e 05                	jle    103417 <vprintfmt+0x1e8>
  103412:	83 fb 7e             	cmp    $0x7e,%ebx
  103415:	7e 12                	jle    103429 <vprintfmt+0x1fa>
                    putch('?', putdat);
  103417:	83 ec 08             	sub    $0x8,%esp
  10341a:	ff 75 0c             	pushl  0xc(%ebp)
  10341d:	6a 3f                	push   $0x3f
  10341f:	8b 45 08             	mov    0x8(%ebp),%eax
  103422:	ff d0                	call   *%eax
  103424:	83 c4 10             	add    $0x10,%esp
  103427:	eb 0f                	jmp    103438 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103429:	83 ec 08             	sub    $0x8,%esp
  10342c:	ff 75 0c             	pushl  0xc(%ebp)
  10342f:	53                   	push   %ebx
  103430:	8b 45 08             	mov    0x8(%ebp),%eax
  103433:	ff d0                	call   *%eax
  103435:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103438:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10343c:	89 f0                	mov    %esi,%eax
  10343e:	8d 70 01             	lea    0x1(%eax),%esi
  103441:	0f b6 00             	movzbl (%eax),%eax
  103444:	0f be d8             	movsbl %al,%ebx
  103447:	85 db                	test   %ebx,%ebx
  103449:	74 26                	je     103471 <vprintfmt+0x242>
  10344b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10344f:	78 b6                	js     103407 <vprintfmt+0x1d8>
  103451:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103455:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103459:	79 ac                	jns    103407 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10345b:	eb 14                	jmp    103471 <vprintfmt+0x242>
                putch(' ', putdat);
  10345d:	83 ec 08             	sub    $0x8,%esp
  103460:	ff 75 0c             	pushl  0xc(%ebp)
  103463:	6a 20                	push   $0x20
  103465:	8b 45 08             	mov    0x8(%ebp),%eax
  103468:	ff d0                	call   *%eax
  10346a:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10346d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103471:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103475:	7f e6                	jg     10345d <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  103477:	e9 4e 01 00 00       	jmp    1035ca <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10347c:	83 ec 08             	sub    $0x8,%esp
  10347f:	ff 75 e0             	pushl  -0x20(%ebp)
  103482:	8d 45 14             	lea    0x14(%ebp),%eax
  103485:	50                   	push   %eax
  103486:	e8 39 fd ff ff       	call   1031c4 <getint>
  10348b:	83 c4 10             	add    $0x10,%esp
  10348e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103491:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10349a:	85 d2                	test   %edx,%edx
  10349c:	79 23                	jns    1034c1 <vprintfmt+0x292>
                putch('-', putdat);
  10349e:	83 ec 08             	sub    $0x8,%esp
  1034a1:	ff 75 0c             	pushl  0xc(%ebp)
  1034a4:	6a 2d                	push   $0x2d
  1034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a9:	ff d0                	call   *%eax
  1034ab:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034b4:	f7 d8                	neg    %eax
  1034b6:	83 d2 00             	adc    $0x0,%edx
  1034b9:	f7 da                	neg    %edx
  1034bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034be:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1034c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1034c8:	e9 9f 00 00 00       	jmp    10356c <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1034cd:	83 ec 08             	sub    $0x8,%esp
  1034d0:	ff 75 e0             	pushl  -0x20(%ebp)
  1034d3:	8d 45 14             	lea    0x14(%ebp),%eax
  1034d6:	50                   	push   %eax
  1034d7:	e8 99 fc ff ff       	call   103175 <getuint>
  1034dc:	83 c4 10             	add    $0x10,%esp
  1034df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1034e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1034ec:	eb 7e                	jmp    10356c <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1034ee:	83 ec 08             	sub    $0x8,%esp
  1034f1:	ff 75 e0             	pushl  -0x20(%ebp)
  1034f4:	8d 45 14             	lea    0x14(%ebp),%eax
  1034f7:	50                   	push   %eax
  1034f8:	e8 78 fc ff ff       	call   103175 <getuint>
  1034fd:	83 c4 10             	add    $0x10,%esp
  103500:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103503:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103506:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10350d:	eb 5d                	jmp    10356c <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  10350f:	83 ec 08             	sub    $0x8,%esp
  103512:	ff 75 0c             	pushl  0xc(%ebp)
  103515:	6a 30                	push   $0x30
  103517:	8b 45 08             	mov    0x8(%ebp),%eax
  10351a:	ff d0                	call   *%eax
  10351c:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10351f:	83 ec 08             	sub    $0x8,%esp
  103522:	ff 75 0c             	pushl  0xc(%ebp)
  103525:	6a 78                	push   $0x78
  103527:	8b 45 08             	mov    0x8(%ebp),%eax
  10352a:	ff d0                	call   *%eax
  10352c:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10352f:	8b 45 14             	mov    0x14(%ebp),%eax
  103532:	8d 50 04             	lea    0x4(%eax),%edx
  103535:	89 55 14             	mov    %edx,0x14(%ebp)
  103538:	8b 00                	mov    (%eax),%eax
  10353a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10353d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103544:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10354b:	eb 1f                	jmp    10356c <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10354d:	83 ec 08             	sub    $0x8,%esp
  103550:	ff 75 e0             	pushl  -0x20(%ebp)
  103553:	8d 45 14             	lea    0x14(%ebp),%eax
  103556:	50                   	push   %eax
  103557:	e8 19 fc ff ff       	call   103175 <getuint>
  10355c:	83 c4 10             	add    $0x10,%esp
  10355f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103562:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103565:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10356c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103573:	83 ec 04             	sub    $0x4,%esp
  103576:	52                   	push   %edx
  103577:	ff 75 e8             	pushl  -0x18(%ebp)
  10357a:	50                   	push   %eax
  10357b:	ff 75 f4             	pushl  -0xc(%ebp)
  10357e:	ff 75 f0             	pushl  -0x10(%ebp)
  103581:	ff 75 0c             	pushl  0xc(%ebp)
  103584:	ff 75 08             	pushl  0x8(%ebp)
  103587:	e8 f8 fa ff ff       	call   103084 <printnum>
  10358c:	83 c4 20             	add    $0x20,%esp
            break;
  10358f:	eb 39                	jmp    1035ca <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103591:	83 ec 08             	sub    $0x8,%esp
  103594:	ff 75 0c             	pushl  0xc(%ebp)
  103597:	53                   	push   %ebx
  103598:	8b 45 08             	mov    0x8(%ebp),%eax
  10359b:	ff d0                	call   *%eax
  10359d:	83 c4 10             	add    $0x10,%esp
            break;
  1035a0:	eb 28                	jmp    1035ca <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1035a2:	83 ec 08             	sub    $0x8,%esp
  1035a5:	ff 75 0c             	pushl  0xc(%ebp)
  1035a8:	6a 25                	push   $0x25
  1035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ad:	ff d0                	call   *%eax
  1035af:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1035b2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1035b6:	eb 04                	jmp    1035bc <vprintfmt+0x38d>
  1035b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1035bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1035bf:	83 e8 01             	sub    $0x1,%eax
  1035c2:	0f b6 00             	movzbl (%eax),%eax
  1035c5:	3c 25                	cmp    $0x25,%al
  1035c7:	75 ef                	jne    1035b8 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1035c9:	90                   	nop
        }
    }
  1035ca:	e9 68 fc ff ff       	jmp    103237 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1035cf:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1035d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1035d3:	5b                   	pop    %ebx
  1035d4:	5e                   	pop    %esi
  1035d5:	5d                   	pop    %ebp
  1035d6:	c3                   	ret    

001035d7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1035d7:	55                   	push   %ebp
  1035d8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1035da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035dd:	8b 40 08             	mov    0x8(%eax),%eax
  1035e0:	8d 50 01             	lea    0x1(%eax),%edx
  1035e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035e6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1035e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ec:	8b 10                	mov    (%eax),%edx
  1035ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035f1:	8b 40 04             	mov    0x4(%eax),%eax
  1035f4:	39 c2                	cmp    %eax,%edx
  1035f6:	73 12                	jae    10360a <sprintputch+0x33>
        *b->buf ++ = ch;
  1035f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035fb:	8b 00                	mov    (%eax),%eax
  1035fd:	8d 48 01             	lea    0x1(%eax),%ecx
  103600:	8b 55 0c             	mov    0xc(%ebp),%edx
  103603:	89 0a                	mov    %ecx,(%edx)
  103605:	8b 55 08             	mov    0x8(%ebp),%edx
  103608:	88 10                	mov    %dl,(%eax)
    }
}
  10360a:	90                   	nop
  10360b:	5d                   	pop    %ebp
  10360c:	c3                   	ret    

0010360d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10360d:	55                   	push   %ebp
  10360e:	89 e5                	mov    %esp,%ebp
  103610:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103613:	8d 45 14             	lea    0x14(%ebp),%eax
  103616:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10361c:	50                   	push   %eax
  10361d:	ff 75 10             	pushl  0x10(%ebp)
  103620:	ff 75 0c             	pushl  0xc(%ebp)
  103623:	ff 75 08             	pushl  0x8(%ebp)
  103626:	e8 0b 00 00 00       	call   103636 <vsnprintf>
  10362b:	83 c4 10             	add    $0x10,%esp
  10362e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103631:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103634:	c9                   	leave  
  103635:	c3                   	ret    

00103636 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103636:	55                   	push   %ebp
  103637:	89 e5                	mov    %esp,%ebp
  103639:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10363c:	8b 45 08             	mov    0x8(%ebp),%eax
  10363f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103642:	8b 45 0c             	mov    0xc(%ebp),%eax
  103645:	8d 50 ff             	lea    -0x1(%eax),%edx
  103648:	8b 45 08             	mov    0x8(%ebp),%eax
  10364b:	01 d0                	add    %edx,%eax
  10364d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103650:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103657:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10365b:	74 0a                	je     103667 <vsnprintf+0x31>
  10365d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103663:	39 c2                	cmp    %eax,%edx
  103665:	76 07                	jbe    10366e <vsnprintf+0x38>
        return -E_INVAL;
  103667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10366c:	eb 20                	jmp    10368e <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10366e:	ff 75 14             	pushl  0x14(%ebp)
  103671:	ff 75 10             	pushl  0x10(%ebp)
  103674:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103677:	50                   	push   %eax
  103678:	68 d7 35 10 00       	push   $0x1035d7
  10367d:	e8 ad fb ff ff       	call   10322f <vprintfmt>
  103682:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103688:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10368e:	c9                   	leave  
  10368f:	c3                   	ret    
